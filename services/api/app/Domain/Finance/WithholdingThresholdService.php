<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-04A gross-remittance threshold counter: one `vendor_withholding_accumulators` row per (environment,
 * taxpayer_key, taxable_year), always read FOR UPDATE inside the assessment transaction so concurrent settlements
 * for one taxpayer serialize. Every status change appends exactly one `vendor_withholding_status_events` row.
 * No provider call, notification dispatch or PDF render ever runs while the row is locked: notices are in-app
 * rows plus post-commit outbox email.
 *
 * Rollover creates the next year lazily on first assessment (and from the scheduled job): the counter restarts at
 * zero, the prior year's effective total is carried, and a prior year above the threshold starts SUBJECT_PRIOR_YEAR.
 */
final class WithholdingThresholdService
{
    public const ADVISORY_RATIO_PERCENT = 80;

    public function __construct(
        private readonly TaxpayerContext $taxpayers,
        private readonly FinanceNotifier $notifier,
        private readonly OutboxPublisher $outbox,
    ) {}

    /**
     * Locks (creating on first use) the accumulator for this taxpayer and year. Must run inside a transaction.
     *
     * @param  array<string, mixed>  $context  TaxpayerContext::forOrganization()
     */
    public function lock(string $environment, string $organizationId, array $context, CarbonImmutable $instant, string $correlationId): object
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('The withholding accumulator is locked only inside the assessment transaction.');
        }
        $key = ['environment' => $environment, 'taxpayer_key' => $context['taxpayer_key'], 'taxable_year' => $context['taxable_year']];
        $row = DB::table('vendor_withholding_accumulators')->where($key)->lockForUpdate()->first();
        if ($row !== null) {
            return $row;
        }
        $initial = $this->initialStatus($environment, $organizationId, $context, $instant);
        $id = (string) Str::uuid7();
        $inserted = DB::table('vendor_withholding_accumulators')->insertOrIgnore($key + [
            'id' => $id, 'organization_id' => $organizationId, 'year_start_at' => $context['year_start_at'], 'year_end_at' => $context['year_end_at'],
            'threshold_centavos' => WithholdingThresholdEngine::DEFAULT_THRESHOLD_CENTAVOS, 'g_accumulated_centavos' => 0,
            'g_external_declared_centavos' => $context['external_declared_centavos'], 'g_external_overlap_centavos' => 0,
            'external_overlap_state' => $context['external_overlap_unresolved'] ? 'UNRESOLVED' : 'NONE',
            'withholding_status' => $initial['status'], 'status_reason_code' => $initial['reason'], 'effective_declaration_id' => $initial['evidence_id'],
            'prior_year_total_centavos' => $initial['prior_total'], 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now(),
        ]);
        $row = DB::table('vendor_withholding_accumulators')->where($key)->lockForUpdate()->firstOrFail();
        if ($inserted === 1) {
            $this->event((string) $row->id, null, $initial['status'], $initial['reason'], 0, (int) $row->g_effective_centavos, null, 'SYSTEM', null, $initial['evidence_id'], $correlationId);
            if ($initial['status'] === WithholdingThresholdEngine::UNDER_REVIEW) {
                $this->reviewItem($environment, $organizationId, 'OVERLAP_UNRESOLVED', (string) $row->id, 'OVERLAP_UNRESOLVED',
                    'The declared outside-platform total may include on-platform remittances. Record the overlap before relief can be evaluated.', ['g_external_declared_centavos' => (int) $row->g_external_declared_centavos]);
            }
            if (str_starts_with($initial['status'], 'SUBJECT_') && $initial['status'] !== WithholdingThresholdEngine::SUBJECT_STANDARD) {
                $this->subjectNotice($row, $initial['status'], $initial['reason']);
            }
        }

        return $row;
    }

    /**
     * Applies one canonical group's G to the locked accumulator and returns the decision plus snapshot values.
     *
     * @param  array<string, mixed>  $context
     * @return array<string, mixed>
     */
    public function apply(object $accumulator, array $context, string $organizationId, int $groupCentavos, int $rateBasisPoints, CarbonImmutable $instant, string $assessmentId, string $correlationId): array
    {
        $reliefId = $this->taxpayers->reliefBasis($organizationId, (int) $accumulator->taxable_year, $instant, (bool) $context['relief_claimed']);
        $decision = WithholdingThresholdEngine::decide((string) $accumulator->withholding_status, (string) $accumulator->status_reason_code,
            (int) $accumulator->g_effective_centavos, $groupCentavos, (int) $accumulator->threshold_centavos, $reliefId !== null, $rateBasisPoints);

        return $decision + ['relief_basis_id' => $decision['status_after'] === WithholdingThresholdEngine::RELIEF_ACTIVE ? ($reliefId ?? $accumulator->effective_declaration_id) : null,
            'status_before' => (string) $accumulator->withholding_status, 'assessment_id' => $assessmentId, 'correlation_id' => $correlationId];
    }

    /**
     * Posts the counter update for an inserted assessment: the whole G is added once, a crossing is stamped once,
     * the status event and notices are written, and an 80% advisory is sent once per taxable year.
     *
     * @param  array<string, mixed>  $decision  apply()
     */
    public function post(object $accumulator, array $decision, int $groupCentavos): void
    {
        $update = ['g_accumulated_centavos' => (int) $accumulator->g_accumulated_centavos + $groupCentavos, 'withholding_status' => $decision['status_after'],
            'status_reason_code' => $decision['reason_code'], 'lock_version' => (int) $accumulator->lock_version + 1, 'updated_at' => now()];
        if ($decision['crossed'] && $accumulator->crossed_at === null) {
            $update['crossed_at'] = now();
            $update['crossing_assessment_id'] = $decision['assessment_id'];
        }
        if ($decision['relief_basis_id'] !== null) {
            $update['effective_declaration_id'] = $decision['relief_basis_id'];
        }
        $advisoryLimit = intdiv((int) $accumulator->threshold_centavos * self::ADVISORY_RATIO_PERCENT, 100);
        $advisory = $accumulator->advisory_notified_at === null && $decision['g_after_centavos'] >= $advisoryLimit && ! $decision['crossed'];
        if ($advisory) {
            $update['advisory_notified_at'] = now();
        }
        DB::table('vendor_withholding_accumulators')->where('id', $accumulator->id)->update($update);
        $fresh = DB::table('vendor_withholding_accumulators')->where('id', $accumulator->id)->first();
        if ($decision['changed']) {
            $this->event((string) $accumulator->id, (string) $accumulator->withholding_status, $decision['status_after'], $decision['reason_code'],
                $decision['g_before_centavos'], $decision['g_after_centavos'], $decision['assessment_id'], 'SYSTEM', null, $decision['relief_basis_id'], $decision['correlation_id']);
            if (str_starts_with($decision['status_after'], 'SUBJECT_')) {
                $this->subjectNotice($fresh, $decision['status_after'], $decision['reason_code']);
            }
        }
        if ($advisory) {
            $this->notifier->owner((string) $accumulator->organization_id, 'Gross remittances reached 80% of the ₱500,000.00 threshold',
                'DEMO figures: cumulative gross remittances for taxable year '.$accumulator->taxable_year.' are now ₱'.self::pesos($decision['g_after_centavos']).
                ', with ₱'.self::pesos(max(0, (int) $accumulator->threshold_centavos - $decision['g_after_centavos'])).' remaining before withholding applies to the whole crossing remittance and every later one this year.',
                false, 'WITHHOLDING_ACCUMULATOR', (string) $accumulator->id);
        }
        $this->outbox->publish('WITHHOLDING_ACCUMULATOR_POSTED', 'WITHHOLDING_ACCUMULATOR', (string) $accumulator->id, [
            'accumulator_id' => (string) $accumulator->id, 'assessment_id' => (string) $decision['assessment_id'], 'status' => $decision['status_after'], 'changed' => $decision['changed'] ? 1 : 0,
        ]);
    }

    /**
     * An Admin-reviewed in-period relief basis is the only exit from SUBJECT_STANDARD or SUBJECT_PRIOR_YEAR, and
     * never after a crossing or above the threshold. A crossed year only records the acknowledgment.
     */
    public function reliefBasisApproved(string $organizationId, string $evidenceId, int $adminUserId, string $correlationId): string
    {
        return DB::transaction(function () use ($organizationId, $evidenceId, $adminUserId, $correlationId): string {
            $context = $this->taxpayers->forOrganization($organizationId, CarbonImmutable::now());
            $accumulator = DB::table('vendor_withholding_accumulators')->where('environment', 'TEST')->where('taxpayer_key', $context['taxpayer_key'])
                ->where('taxable_year', $context['taxable_year'])->lockForUpdate()->first();
            if ($accumulator === null) {
                return 'APPLIES_AT_FIRST_REMITTANCE';
            }
            if ($accumulator->crossed_at !== null || (int) $accumulator->g_effective_centavos > (int) $accumulator->threshold_centavos) {
                $this->acknowledgeAfterCrossing($accumulator, $evidenceId, 'ADMIN', $adminUserId, $correlationId);

                return 'ACKNOWLEDGED_NO_EFFECT';
            }
            if (! in_array($accumulator->withholding_status, [WithholdingThresholdEngine::SUBJECT_STANDARD, WithholdingThresholdEngine::SUBJECT_PRIOR_YEAR], true)) {
                return 'NO_CHANGE';
            }
            DB::table('vendor_withholding_accumulators')->where('id', $accumulator->id)->update(['withholding_status' => WithholdingThresholdEngine::RELIEF_ACTIVE,
                'status_reason_code' => 'RELIEF_EVIDENCED', 'effective_declaration_id' => $evidenceId, 'lock_version' => (int) $accumulator->lock_version + 1, 'updated_at' => now()]);
            $this->event((string) $accumulator->id, (string) $accumulator->withholding_status, WithholdingThresholdEngine::RELIEF_ACTIVE, 'RELIEF_EVIDENCED',
                (int) $accumulator->g_effective_centavos, (int) $accumulator->g_effective_centavos, null, 'ADMIN', $adminUserId, $evidenceId, $correlationId);

            return 'RELIEF_ACTIVE';
        });
    }

    /** A declaration stored after the crossing is acknowledged once and changes nothing for that taxable year. */
    public function declarationRecorded(string $organizationId, string $evidenceId, string $actorType, ?int $actorId, string $correlationId): string
    {
        return DB::transaction(function () use ($organizationId, $evidenceId, $actorType, $actorId, $correlationId): string {
            try {
                $context = $this->taxpayers->forOrganization($organizationId, CarbonImmutable::now());
            } catch (AuthenticationException) {
                return 'NO_ACCUMULATOR';
            }
            $accumulator = DB::table('vendor_withholding_accumulators')->where('environment', 'TEST')->where('taxpayer_key', $context['taxpayer_key'])
                ->where('taxable_year', $context['taxable_year'])->lockForUpdate()->first();
            if ($accumulator === null || $accumulator->crossed_at === null) {
                return 'PENDING_REVIEW';
            }
            $this->acknowledgeAfterCrossing($accumulator, $evidenceId, $actorType, $actorId, $correlationId);

            return 'ACKNOWLEDGED_NO_EFFECT';
        });
    }

    /**
     * Admin records the part of a declared outside-platform total already represented locally. The overlap can
     * only resolve UNDER_REVIEW; the effective total then decides the status, and a total above the limit breaches.
     */
    public function resolveOverlap(string $accumulatorId, int $overlapCentavos, int $lockVersion, int $adminUserId, string $reason, string $correlationId): object
    {
        return DB::transaction(function () use ($accumulatorId, $overlapCentavos, $lockVersion, $adminUserId, $reason, $correlationId): object {
            $accumulator = DB::table('vendor_withholding_accumulators')->where('id', $accumulatorId)->lockForUpdate()->first();
            if ($accumulator === null) {
                throw new AuthenticationException('ACCUMULATOR_NOT_FOUND', 'This withholding record is unavailable.', 404);
            }
            if ((int) $accumulator->lock_version !== $lockVersion) {
                throw new AuthenticationException('VERSION_CONFLICT', 'This withholding record changed. Refresh and review it again.', 409, ['current_lock_version' => (int) $accumulator->lock_version]);
            }
            if ($accumulator->withholding_status !== WithholdingThresholdEngine::UNDER_REVIEW || $accumulator->external_overlap_state !== 'UNRESOLVED') {
                throw new AuthenticationException('OVERLAP_NOT_UNDER_REVIEW', 'Only an unresolved outside-platform overlap can be recorded.', 409);
            }
            if ($overlapCentavos < 0 || $overlapCentavos > (int) $accumulator->g_external_declared_centavos || $overlapCentavos > (int) $accumulator->g_accumulated_centavos + (int) $accumulator->g_external_declared_centavos) {
                throw new AuthenticationException('OVERLAP_INVALID', 'The overlap cannot exceed the declared outside-platform total.', 422, ['overlap_centavos' => ['The overlap cannot exceed the declared outside-platform total.']]);
            }
            $effective = (int) $accumulator->g_accumulated_centavos + (int) $accumulator->g_external_declared_centavos - $overlapCentavos;
            $context = $this->taxpayers->forOrganization((string) $accumulator->organization_id, CarbonImmutable::now());
            $relief = $this->taxpayers->reliefBasis((string) $accumulator->organization_id, (int) $accumulator->taxable_year, CarbonImmutable::now(), (bool) $context['relief_claimed']);
            [$status, $code] = match (true) {
                $effective > (int) $accumulator->threshold_centavos => [WithholdingThresholdEngine::SUBJECT_THRESHOLD_BREACHED, 'EXTERNAL_BREACH_REPORTED'],
                $relief !== null => [WithholdingThresholdEngine::RELIEF_ACTIVE, 'RELIEF_EVIDENCED'],
                default => [WithholdingThresholdEngine::SUBJECT_STANDARD, 'NO_DECLARATION'],
            };
            DB::table('vendor_withholding_accumulators')->where('id', $accumulatorId)->update(['g_external_overlap_centavos' => $overlapCentavos, 'external_overlap_state' => 'RESOLVED',
                'withholding_status' => $status, 'status_reason_code' => $code, 'effective_declaration_id' => $relief ?? $accumulator->effective_declaration_id,
                'crossed_at' => $status === WithholdingThresholdEngine::SUBJECT_THRESHOLD_BREACHED ? now() : null, 'lock_version' => (int) $accumulator->lock_version + 1, 'updated_at' => now()]);
            $this->event($accumulatorId, WithholdingThresholdEngine::UNDER_REVIEW, $status, $code, (int) $accumulator->g_effective_centavos, $effective, null, 'ADMIN', $adminUserId, $relief, $correlationId);
            DB::table('finance_review_items')->where('kind', 'OVERLAP_UNRESOLVED')->where('source_id', $accumulatorId)->where('state', 'OPEN')
                ->update(['state' => 'RESOLVED', 'resolution' => mb_substr($reason, 0, 2000), 'resolved_by_user_id' => $adminUserId, 'resolved_at' => now(), 'updated_at' => now()]);
            $fresh = DB::table('vendor_withholding_accumulators')->where('id', $accumulatorId)->first();
            if (str_starts_with($status, 'SUBJECT_')) {
                $this->subjectNotice($fresh, $status, $code);
            }

            return $fresh;
        });
    }

    /** Scheduled rollover: creates next-year accumulators so January never grants an automatic fresh allowance. */
    public function rollover(CarbonImmutable $now): int
    {
        $created = 0;
        $organizations = DB::table('vendor_withholding_accumulators')->where('year_end_at', '<=', $now)->distinct()->pluck('organization_id');
        foreach ($organizations as $organizationId) {
            DB::transaction(function () use ($organizationId, $now, &$created): void {
                try {
                    $context = $this->taxpayers->forOrganization((string) $organizationId, $now);
                } catch (AuthenticationException) {
                    return;
                }
                $exists = DB::table('vendor_withholding_accumulators')->where('environment', 'TEST')->where('taxpayer_key', $context['taxpayer_key'])->where('taxable_year', $context['taxable_year'])->exists();
                if (! $exists) {
                    $this->lock('TEST', (string) $organizationId, $context, $now, (string) Str::uuid7());
                    $created++;
                }
            });
        }

        return $created;
    }

    /**
     * @param  array<string, mixed>  $context
     * @return array{status: string, reason: string, prior_total: ?int, evidence_id: ?string}
     */
    private function initialStatus(string $environment, string $organizationId, array $context, CarbonImmutable $instant): array
    {
        $prior = DB::table('vendor_withholding_accumulators')->where('environment', $environment)->where('taxpayer_key', $context['taxpayer_key'])
            ->where('taxable_year', (int) $context['taxable_year'] - 1)->first(['g_effective_centavos']);
        $priorTotal = $prior !== null ? (int) $prior->g_effective_centavos : $context['declared_prior_year_centavos'];
        $relief = $this->taxpayers->reliefBasis($organizationId, (int) $context['taxable_year'], $instant, (bool) $context['relief_claimed']);

        return match (true) {
            $priorTotal !== null && $priorTotal > WithholdingThresholdEngine::DEFAULT_THRESHOLD_CENTAVOS => ['status' => WithholdingThresholdEngine::SUBJECT_PRIOR_YEAR, 'reason' => 'PRIOR_YEAR_BREACH', 'prior_total' => $priorTotal, 'evidence_id' => null],
            (bool) $context['external_overlap_unresolved'] => ['status' => WithholdingThresholdEngine::UNDER_REVIEW, 'reason' => 'OVERLAP_UNRESOLVED', 'prior_total' => $priorTotal, 'evidence_id' => null],
            $relief !== null => ['status' => WithholdingThresholdEngine::RELIEF_ACTIVE, 'reason' => 'RELIEF_EVIDENCED', 'prior_total' => $priorTotal, 'evidence_id' => $relief],
            default => ['status' => WithholdingThresholdEngine::SUBJECT_STANDARD, 'reason' => 'NO_DECLARATION', 'prior_total' => $priorTotal, 'evidence_id' => null],
        };
    }

    private function acknowledgeAfterCrossing(object $accumulator, string $evidenceId, string $actorType, ?int $actorId, string $correlationId): void
    {
        $exists = DB::table('audit_logs')->where('action', 'WITHHOLDING_DECLARATION_AFTER_CROSSING_ACKNOWLEDGED')->where('resource_id', $accumulator->id)
            ->whereRaw("after->>'evidence_id' = ?", [$evidenceId])->exists();
        if ($exists) {
            return;
        }
        DB::table('audit_logs')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => $actorId, 'actor_role' => $actorType, 'action' => 'WITHHOLDING_DECLARATION_AFTER_CROSSING_ACKNOWLEDGED',
            'resource_type' => 'WITHHOLDING_ACCUMULATOR', 'resource_id' => $accumulator->id, 'vendor_organization_id' => $accumulator->organization_id,
            'before' => json_encode(['withholding_status' => $accumulator->withholding_status], JSON_THROW_ON_ERROR),
            'after' => json_encode(['withholding_status' => $accumulator->withholding_status, 'evidence_id' => $evidenceId, 'effect' => 'NONE_FOR_TAXABLE_YEAR'], JSON_THROW_ON_ERROR),
            'reason' => 'A declaration recorded after the threshold crossing is stored and acknowledged but does not change this taxable year.', 'correlation_id' => $correlationId,
            'succeeded' => true, 'created_at' => now(), 'updated_at' => now()]);
    }

    private function subjectNotice(object $accumulator, string $status, string $reason): void
    {
        $body = match ($status) {
            WithholdingThresholdEngine::SUBJECT_THRESHOLD_BREACHED => 'DEMO figures: cumulative gross remittances for taxable year '.$accumulator->taxable_year.' reached ₱'.self::pesos((int) $accumulator->g_effective_centavos)
                .', above the ₱500,000.00 threshold. The 0.5% creditable withholding applies to the whole crossing remittance and every later remittance this taxable year. Crossing is final for the year: a later refund or a newly uploaded declaration does not restore relief.',
            WithholdingThresholdEngine::SUBJECT_PRIOR_YEAR => 'DEMO figures: the prior taxable year closed above the ₱500,000.00 threshold, so taxable year '.$accumulator->taxable_year.' starts subject to 0.5% creditable withholding until a reviewer approves a new in-period relief basis.',
            WithholdingThresholdEngine::UNDER_REVIEW => 'DEMO figures: your declared outside-platform total needs review. Remittances are assessed at the standard 0.5% until it is resolved.',
            default => 'DEMO figures: no reviewed relief basis applies, so remittances are assessed at the standard 0.5% creditable withholding.',
        };
        $this->notifier->owner((string) $accumulator->organization_id, 'Withholding status changed: '.str_replace('_', ' ', $status).' ('.$reason.')', $body, true, 'WITHHOLDING_ACCUMULATOR', (string) $accumulator->id);
    }

    private function event(string $accumulatorId, ?string $from, string $to, string $reason, int $gBefore, int $gAfter, ?string $assessmentId, string $actorType, ?int $actorId, ?string $evidenceId, string $correlationId): void
    {
        DB::table('vendor_withholding_status_events')->insert(['id' => (string) Str::uuid7(), 'accumulator_id' => $accumulatorId, 'from_status' => $from, 'to_status' => $to,
            'reason_code' => $reason, 'g_before_centavos' => $gBefore, 'g_after_centavos' => $gAfter, 'assessment_id' => $assessmentId, 'actor_type' => $actorType,
            'actor_id' => $actorId, 'evidence_id' => $evidenceId, 'correlation_id' => mb_substr($correlationId, 0, 64), 'occurred_at' => now()]);
    }

    /**
     * @param  array<string, mixed>  $expected
     * @param  array<string, mixed>  $reported
     */
    public function reviewItem(string $environment, ?string $organizationId, string $kind, string $sourceId, string $reason, string $summary, array $expected = [], array $reported = [], string $sourceType = 'WITHHOLDING_ACCUMULATOR'): void
    {
        DB::table('finance_review_items')->insertOrIgnore(['id' => (string) Str::uuid7(), 'environment' => $environment, 'kind' => $kind, 'vendor_organization_id' => $organizationId,
            'source_type' => $sourceType, 'source_id' => $sourceId, 'reason_code' => $reason, 'summary' => $summary, 'expected' => json_encode($expected, JSON_THROW_ON_ERROR),
            'reported' => json_encode($reported, JSON_THROW_ON_ERROR), 'state' => 'OPEN', 'dedupe_key' => $kind.':'.$sourceType.':'.$sourceId.':'.$reason, 'created_at' => now(), 'updated_at' => now()]);
    }

    public static function pesos(int $centavos): string
    {
        return number_format(intdiv($centavos, 100)).'.'.str_pad((string) ($centavos % 100), 2, '0', STR_PAD_LEFT);
    }
}
