<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-10 operational reconciliation subledger. Each posting is one balanced, append-only batch keyed by its
 * source event, so a retry returns the original batch instead of posting twice. DEMO_FLOW projects simulated
 * merchant money movement; PLATFORM_FEE projects the platform's fee account; the two never share accounts.
 * This projection does not assert that MateryalPH owns or holds Vendor funds.
 */
final class FinancialLedgerService
{
    public const DEMO_FLOW = 'DEMO_FLOW';

    public const PLATFORM_FEE = 'PLATFORM_FEE';

    /**
     * @param  list<array{account: string, direction: 'DEBIT'|'CREDIT', amount: int, source_type: string, source_id: string}>  $lines
     */
    public function post(string $ledger, string $batchType, string $sourceEventKey, array $lines, string $correlationId, ?int $actorUserId = null, string $actorRole = 'SYSTEM', string $environment = 'TEST'): string
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Ledger batches are posted inside the source transaction.');
        }
        $existing = DB::table('financial_posting_batches')->where('source_event_key', $sourceEventKey)->value('id');
        if ($existing !== null) {
            return (string) $existing;
        }
        $lines = array_values(array_filter($lines, static fn (array $line): bool => $line['amount'] > 0));
        $debits = array_sum(array_map(static fn (array $line): int => $line['direction'] === 'DEBIT' ? $line['amount'] : 0, $lines));
        $credits = array_sum(array_map(static fn (array $line): int => $line['direction'] === 'CREDIT' ? $line['amount'] : 0, $lines));
        if ($debits !== $credits) {
            throw new \LogicException('A ledger batch must balance by currency and environment.');
        }
        if ($lines === []) {
            return '';
        }
        $batchId = (string) Str::uuid7();
        DB::table('financial_posting_batches')->insert([
            'id' => $batchId, 'environment' => $environment, 'ledger' => $ledger, 'currency' => 'PHP', 'batch_type' => $batchType, 'source_event_key' => $sourceEventKey,
            'posting_date' => now('Asia/Manila')->toDateString(), 'state' => 'POSTED', 'debit_total_centavos' => $debits, 'credit_total_centavos' => $credits,
            'content_hash' => hash('sha256', $sourceEventKey.'|'.json_encode($lines, JSON_THROW_ON_ERROR)), 'correlation_id' => $correlationId, 'posted_at' => now(),
            'created_at' => now(), 'updated_at' => now(),
        ]);
        foreach ($lines as $index => $line) {
            DB::table('financial_ledger_entries')->insert([
                'id' => (string) Str::uuid7(), 'financial_posting_batch_id' => $batchId, 'environment' => $environment, 'ledger' => $ledger, 'account_code' => $line['account'],
                'source_type' => $line['source_type'], 'source_id' => $line['source_id'], 'direction' => $line['direction'], 'amount_centavos' => $line['amount'], 'currency' => 'PHP',
                'idempotency_key' => $sourceEventKey.'#'.$index, 'actor_user_id' => $actorUserId, 'actor_role' => $actorRole, 'correlation_id' => $correlationId, 'occurred_at' => now(),
                'created_at' => now(), 'updated_at' => now(),
            ]);
        }

        return $batchId;
    }

    /** @return array{account: string, direction: 'DEBIT', amount: int, source_type: string, source_id: string} */
    public static function debit(string $account, int $amount, string $sourceType, string $sourceId): array
    {
        return ['account' => $account, 'direction' => 'DEBIT', 'amount' => $amount, 'source_type' => $sourceType, 'source_id' => $sourceId];
    }

    /** @return array{account: string, direction: 'CREDIT', amount: int, source_type: string, source_id: string} */
    public static function credit(string $account, int $amount, string $sourceType, string $sourceId): array
    {
        return ['account' => $account, 'direction' => 'CREDIT', 'amount' => $amount, 'source_type' => $sourceType, 'source_id' => $sourceId];
    }
}
