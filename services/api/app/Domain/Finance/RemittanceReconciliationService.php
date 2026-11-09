<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Reconciles the recorded TEST flow, never a real provider deduction, settlement or BIR payment. */
final class RemittanceReconciliationService
{
    public const PERMISSION = 'finance.approve_remittance_reconciliation';

    public const ROLES = ['ADMIN_SUPERADMIN', 'ADMIN_FINANCE'];

    /** @return array{reconciled: int, exceptions: int} */
    public function sweep(int $limit = 200): array
    {
        $counts = ['reconciled' => 0, 'exceptions' => 0];
        $ids = DB::table('remittance_assessments')->where('environment', 'TEST')->where('calculation_state', 'POSTED')
            ->where('assigned_withholding_entity', 'DEMO_PLATFORM_WITHHOLDER')->where('reconciliation_state', 'PENDING')
            ->whereNotNull('payment_id')->orderBy('id')->limit($limit)->pluck('id');
        foreach ($ids as $id) {
            $result = $this->reconcile((string) $id);
            if ($result === 'RECONCILED') {
                $counts['reconciled']++;
            } elseif ($result === 'RECONCILIATION_EXCEPTION') {
                $counts['exceptions']++;
            }
        }

        return $counts;
    }

    public function reconcile(string $assessmentId): string
    {
        return DB::transaction(function () use ($assessmentId): string {
            $assessment = DB::table('remittance_assessments')->where('id', $assessmentId)->lockForUpdate()->first();
            if ($assessment === null || ! self::candidate($assessment) || $assessment->reconciliation_state !== 'PENDING') {
                return 'SKIPPED';
            }
            $evidence = $this->check($assessment);
            if ($evidence['blockers'] !== []) {
                DB::table('remittance_assessments')->where('id', $assessmentId)->update(['reconciliation_state' => 'RECONCILIATION_EXCEPTION', 'updated_at' => now()]);
                app(WithholdingThresholdService::class)->reviewItem('TEST', (string) DB::table('orders')->where('id', $assessment->order_id)->value('vendor_organization_id'),
                    'RECONCILIATION_EXCEPTION', $assessmentId, 'AUTOMATIC_REMITTANCE_CHECK_FAILED',
                    'The recorded TEST remittance did not pass automatic source and ledger checks. Correct the source issue before backup approval.',
                    ['source_version' => self::version($assessment)], ['blockers' => $evidence['blockers']], 'REMITTANCE_ASSESSMENT');
                $this->audit($assessment, null, 'SYSTEM', 'REMITTANCE_RECONCILIATION_EXCEPTION', (string) Str::uuid7(), ['reconciliation_state' => 'RECONCILIATION_EXCEPTION', 'blockers' => $evidence['blockers']]);

                return 'RECONCILIATION_EXCEPTION';
            }
            $this->record($assessment, $evidence, null, 'SYSTEM', 'AUTOMATIC', 'Recorded TEST collection, calculation and ledger entries match exactly.', (string) Str::uuid7());

            return 'RECONCILED';
        }, attempts: 3);
    }

    public function canApprove(Request $request): bool
    {
        $user = $request->user();
        if ($user === null || $user->account_type !== 'ADMIN') {
            return false;
        }
        $scope = app(AccountAccess::class)->resolve($user);

        return in_array($scope['role'], self::ROLES, true) && in_array(self::PERMISSION, $scope['permissions'], true)
            && in_array('finance.view', $scope['permissions'], true);
    }

    /** @param array{source_version: string, reason: string} $input
     * @return array<string, mixed> */
    public function approve(Request $request, string $assessmentId, array $input): array
    {
        if (! $this->canApprove($request)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Only Superadmin and Finance Admin can approve remittance reconciliation.', 403);
        }
        app(RecentAuthentication::class)->require($request);
        $actor = (int) $request->user()->getKey();
        $role = app(AccountAccess::class)->resolve($request->user())['role'];
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || strlen($key) < 8 || strlen($key) > 128) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'Provide an Idempotency-Key for this approval.', 422);
        }
        $fingerprint = hash('sha256', json_encode([$assessmentId, $input], JSON_THROW_ON_ERROR));

        return DB::transaction(function () use ($assessmentId, $input, $request, $actor, $role, $key, $fingerprint): array {
            // Serialize a user's request keys before taking the assessment lock; automatic processing locks only the assessment.
            DB::table('users')->where('id', $actor)->lockForUpdate()->first();
            $existing = DB::table('remittance_reconciliation_decisions')->where('actor_user_id', $actor)->where('request_key', hash('sha256', $key))->first();
            if ($existing !== null) {
                if (! hash_equals((string) $existing->request_hash, $fingerprint)) {
                    throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new key for a different approval.', 409);
                }

                return self::decision($existing);
            }
            $assessment = DB::table('remittance_assessments')->where('id', $assessmentId)->lockForUpdate()->first();
            if ($assessment === null) {
                throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This remittance assessment is unavailable.', 404);
            }
            if (! self::candidate($assessment) || ! in_array($assessment->reconciliation_state, ['PENDING', 'RECONCILIATION_EXCEPTION'], true)
                || ! hash_equals(self::version($assessment), $input['source_version'])) {
                throw new AuthenticationException('SOURCE_VERSION_CHANGED', 'This assessment changed or no longer needs approval. Refresh the records.', 409);
            }
            $evidence = $this->check($assessment);
            if ($evidence['blockers'] !== []) {
                throw new AuthenticationException('REMITTANCE_EVIDENCE_MISMATCH', 'The recorded collection and ledger must match before approval.', 422, ['blockers' => $evidence['blockers']]);
            }

            return $this->record($assessment, $evidence, $actor, $role, 'BACKUP_APPROVAL', trim($input['reason']),
                (string) $request->attributes->get('correlation_id', Str::uuid7()), hash('sha256', $key), $fingerprint);
        }, attempts: 3);
    }

    public static function candidate(object $assessment): bool
    {
        return $assessment->environment === 'TEST' && $assessment->assigned_withholding_entity === 'DEMO_PLATFORM_WITHHOLDER'
            && $assessment->calculation_state === 'POSTED' && $assessment->deduction_evidence_state === 'SIMULATED_WITHHELD';
    }

    public static function version(object $assessment): string
    {
        $fields = ['id', 'payment_id', 'remittance_group_id', 'environment', 'assigned_withholding_entity', 'calculation_state', 'deduction_evidence_state', 'reconciliation_state',
            'collections_centavos', 'refunds_centavos', 'delivery_centavos', 'vat_centavos', 'provider_charge_centavos', 'gross_basis_centavos', 'withheld_centavos', 'expected_vendor_cash_centavos', 'reported_withheld_centavos'];

        return hash('sha256', json_encode(array_map(static fn (string $field): mixed => $assessment->{$field}, $fields), JSON_THROW_ON_ERROR));
    }

    /** @return array{origin: string, blockers: list<string>, payment_id: ?string, collection_id: ?string, ledger_batches: list<array<string, mixed>>} */
    private function check(object $assessment): array
    {
        $blockers = [];
        $payment = $assessment->payment_id === null ? null : DB::table('payments')->where('id', $assessment->payment_id)->first();
        $collections = DB::table('remittance_collections')->where('remittance_group_id', $assessment->remittance_group_id)->get();
        $collection = $collections->count() === 1 ? $collections->first() : null;
        if ($payment === null || $payment->state !== 'PAID' || (bool) $payment->late_capture || $payment->purpose === 'PLATFORM_FEE_PAYMENT'
            || $payment->order_id !== $assessment->order_id || $payment->financial_snapshot_id !== $assessment->financial_snapshot_id
            || (int) $payment->total_centavos !== (int) $assessment->collections_centavos || (int) $payment->principal_centavos !== (int) $assessment->principal_centavos
            || $collection === null || $collection->payment_id !== $payment->id || (int) $collection->collected_centavos !== (int) $payment->total_centavos) {
            $blockers[] = 'COLLECTION_SOURCE_MISMATCH';
        }
        if ($payment !== null && (int) DB::table('refunds')->where('source_payment_id', $payment->id)->where('target_type', 'ORDER')->where('state', 'REFUNDED')->sum('amount_centavos') >= (int) $payment->total_centavos) {
            $blockers[] = 'COLLECTION_FULLY_REFUNDED';
        }
        if (DB::table('tax_adjustments')->where('remittance_assessment_id', $assessment->id)->whereNotIn('state', ['POSTED', 'REJECTED', 'NOT_REQUIRED'])->exists()) {
            $blockers[] = 'TAX_ADJUSTMENT_REVIEW_REQUIRED';
        }
        $gross = (int) $assessment->collections_centavos - (int) $assessment->refunds_centavos - (int) $assessment->delivery_centavos - (int) $assessment->vat_centavos - (int) $assessment->provider_charge_centavos;
        $cash = (int) $assessment->collections_centavos - (int) $assessment->refunds_centavos - (int) $assessment->provider_charge_centavos - (int) $assessment->withheld_centavos;
        if ($gross < 0 || $gross !== (int) $assessment->gross_basis_centavos || $cash !== (int) $assessment->expected_vendor_cash_centavos
            || Money::proportion(max(0, $gross), (int) $assessment->effective_rate_basis_points, 10000) !== (int) $assessment->withheld_centavos
            || ($assessment->reported_withheld_centavos !== null && (int) $assessment->reported_withheld_centavos !== (int) $assessment->withheld_centavos)) {
            $blockers[] = 'ASSESSMENT_AMOUNT_MISMATCH';
        }
        $expected = [
            'SIMULATED_COLLECTION' => [(int) $assessment->collections_centavos, 'COLLECTION_CONTROL', 'VENDOR_PAYABLE'],
            'SIMULATED_PROVIDER_CHARGE' => [(int) $assessment->provider_charge_centavos, 'VENDOR_PAYABLE', 'PROVIDER_CHARGE_CONTROL'],
            'SIMULATED_CWT' => [(int) $assessment->withheld_centavos, 'VENDOR_PAYABLE', 'CWT_CONTROL'],
            'SIMULATED_REMITTANCE' => [$cash, 'VENDOR_PAYABLE', 'COLLECTION_CONTROL'],
        ];
        $entries = DB::table('financial_ledger_entries as e')->join('financial_posting_batches as b', 'b.id', '=', 'e.financial_posting_batch_id')
            ->where('e.source_type', 'ASSESSMENT')->where('e.source_id', $assessment->id)->where('b.environment', 'TEST')->where('b.ledger', FinancialLedgerService::DEMO_FLOW)
            ->get(['b.id', 'b.batch_type', 'b.state', 'b.currency', 'b.content_hash', 'b.debit_total_centavos', 'b.credit_total_centavos', 'e.account_code', 'e.direction', 'e.amount_centavos', 'e.environment as entry_environment', 'e.ledger as entry_ledger', 'e.currency as entry_currency']);
        if ($entries->whereNotIn('batch_type', array_keys($expected))->isNotEmpty()) {
            $blockers[] = 'UNEXPECTED_LEDGER_BATCH';
        }
        foreach ($expected as $type => [$amount, $debit, $credit]) {
            $lines = $entries->where('batch_type', $type);
            $match = $amount === 0 ? $lines->isEmpty() : $lines->count() === 2 && $lines->pluck('id')->unique()->count() === 1
                && $lines->every(static fn (object $line): bool => $line->state === 'POSTED' && $line->currency === 'PHP'
                    && $line->entry_environment === 'TEST' && $line->entry_ledger === FinancialLedgerService::DEMO_FLOW && $line->entry_currency === 'PHP'
                    && (int) $line->amount_centavos === $amount && (int) $line->debit_total_centavos === $amount && (int) $line->credit_total_centavos === $amount)
                && $lines->where('direction', 'DEBIT')->where('account_code', $debit)->count() === 1
                && $lines->where('direction', 'CREDIT')->where('account_code', $credit)->count() === 1;
            if (! $match) {
                $blockers[] = 'LEDGER_MISMATCH:'.$type;
            }
        }

        return ['origin' => 'SIMULATED', 'blockers' => $blockers, 'payment_id' => $assessment->payment_id, 'collection_id' => $collection?->id,
            'ledger_batches' => $entries->unique('id')->map(static fn (object $line): array => ['id' => $line->id, 'type' => $line->batch_type, 'hash' => $line->content_hash])->values()->all()];
    }

    /** @param array<string, mixed> $evidence
     * @return array<string, mixed> */
    private function record(object $assessment, array $evidence, ?int $actor, string $role, string $method, string $reason, string $correlation, ?string $key = null, ?string $fingerprint = null): array
    {
        $id = (string) Str::uuid7();
        DB::table('remittance_reconciliation_decisions')->insert(['id' => $id, 'remittance_assessment_id' => $assessment->id, 'environment' => 'TEST', 'method' => $method,
            'previous_state' => $assessment->reconciliation_state, 'actor_user_id' => $actor, 'actor_role' => $role, 'source_version' => self::version($assessment),
            'request_key' => $key, 'request_hash' => $fingerprint, 'reason' => $reason, 'evidence' => json_encode($evidence, JSON_THROW_ON_ERROR), 'correlation_id' => mb_substr($correlation, 0, 64), 'created_at' => now()]);
        DB::table('remittance_assessments')->where('id', $assessment->id)->update(['reconciliation_state' => 'RECONCILED', 'updated_at' => now()]);
        DB::table('finance_review_items')->where('source_type', 'REMITTANCE_ASSESSMENT')->where('source_id', $assessment->id)->where('reason_code', 'AUTOMATIC_REMITTANCE_CHECK_FAILED')->where('state', 'OPEN')
            ->update(['state' => 'RESOLVED', 'resolution' => $reason, 'resolved_by_user_id' => $actor, 'resolved_at' => now(), 'updated_at' => now()]);
        $this->audit($assessment, $actor, $role, 'REMITTANCE_RECONCILED', $correlation, ['reconciliation_state' => 'RECONCILED', 'method' => $method, 'decision_id' => $id, 'origin' => 'SIMULATED', 'reason' => $reason]);

        return self::decision(DB::table('remittance_reconciliation_decisions')->where('id', $id)->sole());
    }

    /** @param array<mixed> $after */
    private function audit(object $assessment, ?int $actor, string $role, string $action, string $correlation, array $after): void
    {
        DB::table('audit_logs')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => $actor, 'actor_role' => $role, 'action' => $action,
            'resource_type' => 'REMITTANCE_ASSESSMENT', 'resource_id' => $assessment->id, 'vendor_organization_id' => DB::table('orders')->where('id', $assessment->order_id)->value('vendor_organization_id'),
            'before' => json_encode(['reconciliation_state' => $assessment->reconciliation_state], JSON_THROW_ON_ERROR), 'after' => json_encode($after, JSON_THROW_ON_ERROR),
            'reason' => 'Recorded TEST remittance reconciliation; no real funds or BIR filing.', 'correlation_id' => mb_substr($correlation, 0, 64), 'succeeded' => true, 'created_at' => now(), 'updated_at' => now()]);
    }

    /** @return array<string, mixed> */
    public static function decision(object $decision): array
    {
        return ['id' => (string) $decision->id, 'assessment_id' => (string) $decision->remittance_assessment_id, 'environment' => 'TEST', 'origin' => 'SIMULATED',
            'method' => (string) $decision->method, 'actor_role' => (string) $decision->actor_role, 'reason' => (string) $decision->reason,
            'reconciled_at' => CarbonImmutable::parse((string) $decision->created_at)->toIso8601String()];
    }
}
