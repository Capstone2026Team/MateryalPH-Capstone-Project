<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-05 remittance assessment for one canonical remittance group. In this TEST release the DEMO tax adapter
 * forms one group per verified successful collection (approved by the project owner on 2026-10-02) and labels
 * every figure SIMULATED; Xendit TEST payment success is evidence of the payment only, never of withholding.
 *
 *   C   = gross successful collection allocated to this remittance, including the Buyer processing fee
 *   R   = approved refunds removed before this remittance (none can precede a per-collection DEMO remittance)
 *   D_r = separately billed delivery in this remittance;  V_r = included material VAT in this remittance
 *   P   = evidenced platform/DFSP consideration removed from it (the quoted provider charge in DEMO)
 *   G   = C − R − D_r − V_r − P;  W = money(G × 0.005) unless FIN-04A relief applies;  cash = C − R − P − W
 *
 * commission_deducted_in_remittance is always 0: the 2% commission is billed monthly and never netted here.
 * The assessment, counter update, ledger postings and outbox events commit in one transaction with the taxpayer
 * year row locked; uniqueness on (environment, taxpayer_key, remittance_group_id, obligation_type) makes a retry
 * return the stored result without touching the counter.
 */
final class RemittanceAssessmentService
{
    public const OBLIGATION = 'MERCHANT_CWT';

    public const CALCULATION_VERSION = 'fin05.remittance.v1';

    public function __construct(
        private readonly TaxpayerContext $taxpayers,
        private readonly WithholdingThresholdService $threshold,
        private readonly WithholdingEvidenceAdapter $evidence,
        private readonly FinancialLedgerService $ledger,
    ) {}

    /**
     * Assesses a verified, non-late order collection. Returns the assessment id, or null when the payment is not
     * an assessable merchant remittance (platform-fee payments, late captures awaiting compensation).
     */
    public function assessCollection(string $paymentId, ?string $correlationId = null): ?string
    {
        $payment = DB::table('payments')->where('id', $paymentId)->first();
        if ($payment === null || $payment->state !== 'PAID' || $payment->purpose === 'PLATFORM_FEE_PAYMENT' || (bool) $payment->late_capture || $payment->order_id === null) {
            return null;
        }
        $components = $this->components($payment);

        return $this->assess([
            'environment' => 'TEST', 'organization_id' => (string) $payment->vendor_organization_id, 'order_id' => (string) $payment->order_id,
            'financial_snapshot_id' => (string) $payment->financial_snapshot_id, 'payment_id' => $paymentId, 'group_key' => 'COLLECTION:'.$paymentId,
            'instant' => CarbonImmutable::parse((string) $payment->paid_at), 'evidence_origin' => (string) $payment->evidence_origin,
        ] + $components, $correlationId ?? (string) Str::uuid7());
    }

    /**
     * The FIN-05 core for one group. Inputs are integer centavos; see the class contract.
     *
     * @param  array{environment: string, organization_id: string, order_id: string, financial_snapshot_id: string, payment_id: ?string, group_key: string, instant: CarbonImmutable, evidence_origin: string, collected: int, refunds: int, delivery: int, vat: int, provider_charge: int, principal: int, basis: array<string, mixed>}  $input
     */
    public function assess(array $input, string $correlationId): string
    {
        $context = $this->taxpayers->forOrganization($input['organization_id'], $input['instant']);

        return DB::transaction(function () use ($input, $context, $correlationId): string {
            $assignment = $this->assignment($context);
            $groupId = $this->group($input, $context, $assignment);
            $existing = DB::table('remittance_assessments')->where('environment', $input['environment'])->where('taxpayer_key_hash', $context['taxpayer_key'])
                ->where('remittance_group_id', $groupId)->where('obligation_type', self::OBLIGATION)->value('id');
            if ($existing !== null) {
                return (string) $existing;
            }
            $gross = $input['collected'] - $input['refunds'] - $input['delivery'] - $input['vat'] - $input['provider_charge'];
            $invalid = min($input['collected'], $input['refunds'], $input['delivery'], $input['vat'], $input['provider_charge']) < 0 || $gross < 0;
            // Lock order: the taxpayer-year accumulator, after the group row; never across a network call.
            $accumulator = $this->threshold->lock($input['environment'], $input['organization_id'], $context, $input['instant'], $correlationId);
            $existing = DB::table('remittance_assessments')->where('environment', $input['environment'])->where('taxpayer_key_hash', $context['taxpayer_key'])
                ->where('remittance_group_id', $groupId)->where('obligation_type', self::OBLIGATION)->value('id');
            if ($existing !== null) {
                return (string) $existing;
            }
            $assessmentId = (string) Str::uuid7();
            $rate = (int) $assignment->rate_basis_points;
            $decision = $invalid ? null : $this->threshold->apply($accumulator, $context, $input['organization_id'], $gross, $rate, $input['instant'], $assessmentId, $correlationId);
            $withheld = $decision['withheld_centavos'] ?? 0;
            $cash = WithholdingThresholdEngine::expectedVendorCash($input['collected'], $input['refunds'], $input['provider_charge'], $withheld);
            $evidence = $invalid ? ['state' => 'UNCONFIRMED', 'actor' => null, 'reported_withheld_centavos' => null, 'reconciliation_state' => 'PENDING'] : $this->evidence->deduction($context['scenario'], $withheld);
            $before = (int) $accumulator->g_effective_centavos;
            DB::table('remittance_assessments')->insert([
                'id' => $assessmentId, 'remittance_group_id' => $groupId, 'financial_snapshot_id' => $input['financial_snapshot_id'], 'order_id' => $input['order_id'],
                'environment' => $input['environment'], 'taxpayer_key_hash' => $context['taxpayer_key'], 'obligation_type' => self::OBLIGATION,
                'assigned_withholding_entity' => $context['scenario'], 'collections_centavos' => $input['collected'], 'refunds_centavos' => $input['refunds'],
                'discounts_refunded_centavos' => 0, 'vat_refunded_centavos' => 0, 'delivery_centavos' => $input['delivery'], 'vat_centavos' => $input['vat'],
                'provider_charge_centavos' => $input['provider_charge'], 'principal_centavos' => $input['principal'], 'gross_basis_centavos' => max(0, $gross),
                'withheld_centavos' => $withheld, 'threshold_before_centavos' => $before, 'threshold_after_centavos' => $decision['g_after_centavos'] ?? $before,
                'effective_rate_basis_points' => $decision['rate_basis_points'] ?? 0, 'threshold_status' => $decision['status_after'] ?? (string) $accumulator->withholding_status,
                'calculation_state' => $invalid ? 'BASE_REVIEW_REQUIRED' : 'POSTED', 'deduction_evidence_state' => $evidence['state'], 'reconciliation_state' => $evidence['reconciliation_state'],
                'assessment_reason' => $invalid ? 'A negative or inconsistent base needs finance review; nothing was posted to the threshold counter.' : self::reason($decision),
                'calculation' => json_encode(['version' => self::CALCULATION_VERSION, 'mode' => 'DEMO', 'grouping_rule' => 'ONE_PER_COLLECTION', 'basis' => $input['basis'],
                    'formula' => 'G = C - R - D_r - V_r - P; W = half-up(G * rate); cash = C - R - P - W', 'g_centavos' => $gross], JSON_THROW_ON_ERROR),
                'threshold_status_before' => (string) $accumulator->withholding_status, 'threshold_status_after' => $decision['status_after'] ?? (string) $accumulator->withholding_status,
                'g_effective_before_centavos' => $before, 'g_effective_after_centavos' => $decision['g_after_centavos'] ?? $before, 'relief_basis_id' => $decision['relief_basis_id'] ?? null,
                'accumulator_id' => $accumulator->id, 'payment_id' => $input['payment_id'], 'taxable_year' => $context['taxable_year'], 'withholding_scenario' => $context['scenario'],
                'deduction_actor' => $evidence['actor'], 'expected_vendor_cash_centavos' => $cash, 'commission_deducted_centavos' => 0,
                'reported_withheld_centavos' => $evidence['reported_withheld_centavos'], 'evidence_origin' => $input['evidence_origin'], 'correlation_id' => mb_substr($correlationId, 0, 64),
                'posted_at' => $invalid ? null : now(), 'created_at' => now(), 'updated_at' => now(),
            ]);
            if ($invalid || $decision === null) {
                $this->threshold->reviewItem($input['environment'], $input['organization_id'], 'BASE_REVIEW_REQUIRED', $assessmentId, 'NEGATIVE_OR_INCONSISTENT_BASE',
                    'A remittance base component was negative or exceeded its source amount.', ['g_centavos' => $gross] + $input['basis'], [], 'REMITTANCE_ASSESSMENT');

                return $assessmentId;
            }
            $this->threshold->post($accumulator, $decision, $gross);
            $this->postLedger($assessmentId, $input, $withheld, $cash, $context['scenario'], $correlationId);

            return $assessmentId;
        });
    }

    /**
     * FIN-07: a refund after a posted assessment never lowers the counter or restores relief. It opens one
     * system tax-adjustment case linked to the assessment and, for a crossed year, a finance work item.
     */
    public function openAdjustmentForRefund(string $assessmentId, ?string $refundId, int $refundedCentavos, string $reason): string
    {
        return DB::transaction(function () use ($assessmentId, $refundId, $refundedCentavos, $reason): string {
            $assessment = DB::table('remittance_assessments')->where('id', $assessmentId)->first();
            if ($assessment === null) {
                throw new AuthenticationException('ASSESSMENT_NOT_FOUND', 'This remittance assessment is unavailable.', 404);
            }
            $existing = DB::table('tax_adjustments')->where('opened_by', 'SYSTEM')->where('original_record_type', 'REMITTANCE_ASSESSMENT')
                ->where('original_record_id', $assessmentId)->where('kind', 'REFUND_AFTER_ASSESSMENT')->value('id');
            if ($existing !== null) {
                return (string) $existing;
            }
            $accumulator = $assessment->accumulator_id === null ? null : DB::table('vendor_withholding_accumulators')->where('id', $assessment->accumulator_id)->lockForUpdate()->first();
            $local = CarbonImmutable::parse((string) $assessment->created_at)->setTimezone('Asia/Manila');
            $id = (string) Str::uuid7();
            DB::table('tax_adjustments')->insert([
                'id' => $id, 'order_id' => $assessment->order_id, 'refund_id' => $refundId, 'remittance_assessment_id' => $assessmentId, 'environment' => $assessment->environment,
                'original_record_type' => 'REMITTANCE_ASSESSMENT', 'original_record_id' => $assessmentId, 'period_start' => $local->startOfMonth()->toDateString(), 'period_end' => $local->endOfMonth()->toDateString(),
                'kind' => 'REFUND_AFTER_ASSESSMENT', 'amount_centavos' => $refundedCentavos,
                'before_values' => json_encode(['gross_basis_centavos' => (int) $assessment->gross_basis_centavos, 'withheld_centavos' => (int) $assessment->withheld_centavos, 'threshold_status' => $assessment->threshold_status_after], JSON_THROW_ON_ERROR),
                'after_values' => json_encode(['proposed' => null, 'note' => 'Determined by the responsible reviewer; posted tax is never rewritten.'], JSON_THROW_ON_ERROR),
                'reason' => mb_substr($reason, 0, 2000), 'state' => 'ADJUSTMENT_REQUIRED', 'prepared_by_user_id' => null, 'opened_by' => 'SYSTEM', 'accumulator_id' => $assessment->accumulator_id,
                'created_at' => now(), 'updated_at' => now(),
            ]);
            if ($accumulator !== null && $accumulator->crossed_at !== null) {
                $this->threshold->reviewItem((string) $assessment->environment, (string) $accumulator->organization_id, 'THRESHOLD_ADJUSTMENT_REQUIRED', $id, 'REFUND_AFTER_CROSSING',
                    'A refund touched a remittance in a crossed taxable year. The counter and SUBJECT_THRESHOLD_BREACHED status stay unchanged; review the posted assessment.',
                    ['accumulator_id' => (string) $accumulator->id, 'refunded_centavos' => $refundedCentavos], [], 'TAX_ADJUSTMENT');
            }

            return $id;
        });
    }

    /** @return array{collected: int, refunds: int, delivery: int, vat: int, provider_charge: int, principal: int, basis: array<string, mixed>} */
    private function components(object $payment): array
    {
        $snapshot = DB::table('financial_snapshots')->where('id', $payment->financial_snapshot_id)->first();
        if ($snapshot === null) {
            throw new \LogicException('An order payment always references its accepted financial snapshot.');
        }
        $breakdown = json_decode((string) $payment->amount_breakdown, true) ?: [];
        $principal = (int) $payment->principal_centavos;
        [$delivery, $vat] = match ($payment->purpose) {
            // Full online payment carries the whole separately billed delivery and all included material VAT.
            'FULL_ORDER_PAYMENT' => [(int) $snapshot->delivery_centavos, (int) $snapshot->materials_vat_centavos],
            // NRPC principal is allocated to affected material lines only; its VAT share is the frozen NRPC VAT.
            'NRPC_ASSURANCE_PAYMENT' => [0, (int) DB::table('financial_snapshot_lines')->where('financial_snapshot_id', $snapshot->id)->sum('nrpc_vat_centavos')],
            'ORDER_BALANCE_PAYMENT' => [(int) ($breakdown['delivery_allocated_centavos'] ?? 0), (int) ($breakdown['vat_allocated_centavos'] ?? 0)],
            default => throw new \LogicException('Unsupported merchant collection purpose.'),
        };

        return ['collected' => (int) $payment->total_centavos, 'refunds' => 0, 'delivery' => $delivery, 'vat' => $vat, 'provider_charge' => (int) ($payment->provider_charge_centavos ?? $payment->processing_fee_centavos),
            'principal' => $principal, 'basis' => ['purpose' => $payment->purpose, 'principal_centavos' => $principal, 'processing_fee_centavos' => (int) $payment->processing_fee_centavos,
                'financial_snapshot_id' => (string) $snapshot->id, 'channel_code' => $payment->channel_code]];
    }

    /** @param array<string, mixed> $context */
    private function assignment(array $context): object
    {
        if (($assignment = $this->currentAssignment((string) $context['version_id'])) !== null) {
            return $assignment;
        }
        // Creating the first assignment is serialized on the tax profile so two first settlements share one.
        DB::table('vendor_tax_profiles')->where('id', $context['profile_id'])->lockForUpdate()->first();
        if (($assignment = $this->currentAssignment((string) $context['version_id'])) !== null) {
            return $assignment;
        }
        $rule = DB::table('tax_rule_versions')->where('environment', 'DEMO')->where('code', $context['scenario'])->orderByDesc('version')->first(['id', 'rules']);
        $rules = $rule === null ? [] : (json_decode((string) $rule->rules, true) ?: []);
        if ($rule === null || ! is_numeric($rules['rate_basis_points'] ?? null)) {
            throw new AuthenticationException('WITHHOLDING_RULE_UNAVAILABLE', 'The approved DEMO withholding fixture is unavailable.', 503);
        }
        $id = (string) Str::uuid7();
        DB::table('withholding_assignments')->insert(['id' => $id, 'vendor_tax_profile_version_id' => $context['version_id'], 'tax_rule_version_id' => $rule->id, 'atc_code' => null,
            'rate_basis_points' => (int) $rules['rate_basis_points'], 'effective_from' => now(), 'scenario' => $context['scenario'],
            'reason' => 'DEMO responsibility assignment created at first assessment; production assignment unconfirmed.', 'created_at' => now(), 'updated_at' => now()]);

        return DB::table('withholding_assignments')->where('id', $id)->first();
    }

    /** @phpstan-impure */
    private function currentAssignment(string $versionId): ?object
    {
        return DB::table('withholding_assignments')->where('vendor_tax_profile_version_id', $versionId)
            ->where(fn ($query) => $query->whereNull('effective_until')->orWhere('effective_until', '>', now()))->orderByDesc('effective_from')->first();
    }

    /**
     * @param  array<string, mixed>  $input
     * @param  array<string, mixed>  $context
     */
    private function group(array $input, array $context, object $assignment): string
    {
        $existing = DB::table('remittance_groups')->where('vendor_organization_id', $input['organization_id'])->where('withholding_assignment_id', $assignment->id)
            ->where('period_key', $input['group_key'])->value('id');
        if ($existing !== null) {
            return (string) $existing;
        }
        $id = (string) Str::uuid7();
        DB::table('remittance_groups')->insertOrIgnore(['id' => $id, 'vendor_organization_id' => $input['organization_id'], 'withholding_assignment_id' => $assignment->id,
            'tax_year' => $context['taxable_year'], 'environment' => $input['environment'], 'taxpayer_key_hash' => $context['taxpayer_key'], 'obligation_type' => self::OBLIGATION,
            'period_key' => $input['group_key'], 'state' => 'ASSESSED', 'payment_id' => $input['payment_id'], 'grouping_rule' => 'ONE_PER_COLLECTION', 'evidence_origin' => $input['evidence_origin'],
            'created_at' => now(), 'updated_at' => now()]);
        $groupId = (string) DB::table('remittance_groups')->where('vendor_organization_id', $input['organization_id'])->where('withholding_assignment_id', $assignment->id)
            ->where('period_key', $input['group_key'])->lockForUpdate()->value('id');
        if ($input['payment_id'] !== null) {
            DB::table('remittance_collections')->insertOrIgnore(['id' => (string) Str::uuid7(), 'remittance_group_id' => $groupId, 'payment_id' => $input['payment_id'],
                'collected_centavos' => max(1, $input['collected']), 'source_principal_centavos' => max(1, $input['collected']), 'prior_allocated_centavos' => 0,
                'collected_at' => $input['instant'], 'created_at' => now(), 'updated_at' => now()]);
        }

        return $groupId;
    }

    /** @param array<string, mixed> $input */
    private function postLedger(string $assessmentId, array $input, int $withheld, int $cash, string $scenario, string $correlationId): void
    {
        $source = ['ASSESSMENT', $assessmentId];
        $actor = $scenario === 'DEMO_PROVIDER_WITHHOLDER' ? 'DEMO_PROVIDER' : 'DEMO_PLATFORM';
        $this->ledger->post(FinancialLedgerService::DEMO_FLOW, 'SIMULATED_COLLECTION', 'DEMO_FLOW:COLLECTION:'.$input['group_key'], [
            FinancialLedgerService::debit('COLLECTION_CONTROL', $input['collected'], ...$source), FinancialLedgerService::credit('VENDOR_PAYABLE', $input['collected'], ...$source),
        ], $correlationId);
        $this->ledger->post(FinancialLedgerService::DEMO_FLOW, 'SIMULATED_PROVIDER_CHARGE', 'DEMO_FLOW:PROVIDER_CHARGE:'.$input['group_key'], [
            FinancialLedgerService::debit('VENDOR_PAYABLE', $input['provider_charge'], ...$source), FinancialLedgerService::credit('PROVIDER_CHARGE_CONTROL', $input['provider_charge'], ...$source),
        ], $correlationId);
        // One deduction event per remittance, recorded once under the scenario's actor; never twice.
        $this->ledger->post(FinancialLedgerService::DEMO_FLOW, 'SIMULATED_CWT', 'DEMO_FLOW:CWT:'.$input['group_key'], [
            FinancialLedgerService::debit('VENDOR_PAYABLE', $withheld, ...$source), FinancialLedgerService::credit('CWT_CONTROL', $withheld, ...$source),
        ], $correlationId, null, $actor);
        $this->ledger->post(FinancialLedgerService::DEMO_FLOW, 'SIMULATED_REMITTANCE', 'DEMO_FLOW:REMITTANCE:'.$input['group_key'], [
            FinancialLedgerService::debit('VENDOR_PAYABLE', $cash, ...$source), FinancialLedgerService::credit('COLLECTION_CONTROL', $cash, ...$source),
        ], $correlationId);
    }

    /** @param array<string, mixed>|null $decision */
    private static function reason(?array $decision): string
    {
        if ($decision === null) {
            return 'Base review required.';
        }

        return match ($decision['status_after']) {
            WithholdingThresholdEngine::RELIEF_ACTIVE => 'Reviewed in-period relief applies and the taxable-year total stays within ₱500,000.00; W = 0.',
            WithholdingThresholdEngine::SUBJECT_THRESHOLD_BREACHED => $decision['crossed'] ? 'This remittance crossed the ₱500,000.00 threshold; the whole remittance is taxed at 0.5%.' : 'The threshold was crossed earlier this taxable year; 0.5% applies.',
            WithholdingThresholdEngine::SUBJECT_PRIOR_YEAR => 'The prior taxable year closed above the threshold; 0.5% applies until a new relief basis is reviewed.',
            WithholdingThresholdEngine::UNDER_REVIEW => 'Outside-platform overlap is under review; assessed at the standard 0.5%.',
            default => 'No reviewed relief basis applies; standard 0.5% withholding.',
        };
    }
}
