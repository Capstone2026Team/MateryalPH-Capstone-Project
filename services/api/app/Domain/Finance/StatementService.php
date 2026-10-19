<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use App\Domain\Payments\RefundService;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-03 monthly Vendor statements. At 00:05 Asia/Manila on the first day of each month an idempotent job drafts
 * one statement per Vendor for the previous calendar month from unbilled EARNED assessments and approved credits;
 * disputed (held) entries stay identified and uncollectible. A finance reviewer with finance.approve_statements
 * issues it (target: by the third). Due date = max(15th of the following month, issue date + 12 calendar days),
 * end of that day in Asia/Manila. Overdue statements notify the Owner on the due date and seven days later, then
 * enter finance review; they never cancel orders or block refunds, tax records or invoices. A statement never
 * goes negative: excess credits carry to the next statement and are never a negative Xendit payment request.
 */
final class StatementService
{
    public function __construct(private readonly FinanceNotifier $notifier, private readonly OutboxPublisher $outbox) {}

    /**
     * Append a credit to its original bill. Preserve gross verified payments; any credit beyond the unpaid
     * receivable is a refund payable, never new debt or a credit on a second monthly bill. Caller owns the transaction.
     *
     * @return array{refund_centavos: int, applied: bool}
     */
    public function applyCredit(object $adjustment): array
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Statement credits require the approval transaction.');
        }
        $statementId = DB::table('fee_statement_lines')->where('fee_assessment_id', $adjustment->fee_assessment_id)->value('fee_statement_id');
        if ($statementId === null) {
            return ['refund_centavos' => 0, 'applied' => false];
        }
        $statement = DB::table('fee_statements')->where('id', $statementId)->lockForUpdate()->first();
        $previousLine = DB::table('fee_statement_lines')->where('fee_adjustment_id', $adjustment->id)->first();
        if ($statement->state === 'VOIDED' || ($previousLine !== null && ($previousLine->fee_statement_id === $statementId
            || ! DB::table('fee_statement_lines')->where('corrects_line_id', $previousLine->id)->where('line_type', 'CREDIT_REVERSAL')->exists()
            || DB::table('fee_statement_lines')->where('corrects_line_id', $previousLine->id)->where('line_type', 'CREDIT_TRANSFER')->exists()))) {
            return ['refund_centavos' => 0, 'applied' => false];
        }
        $credit = (int) $adjustment->amount_centavos;
        $credits = (int) $statement->credits_centavos + $credit;
        $balance = max(0, (int) $statement->charges_centavos - $credits - (int) $statement->paid_centavos);
        $refund = max(0, $credit - (int) $statement->outstanding_centavos);
        DB::table('fee_statement_lines')->insert(['id' => (string) Str::uuid7(), 'fee_statement_id' => $statementId,
            ...($previousLine === null ? ['fee_adjustment_id' => $adjustment->id] : ['corrects_line_id' => $previousLine->id]),
            'line_type' => $previousLine === null ? 'CREDIT' : 'CREDIT_TRANSFER', 'amount_centavos' => $credit, 'description' => 'Approved commission credit on original order', 'created_at' => now(), 'updated_at' => now()]);
        $state = $statement->state === 'DRAFT' ? 'DRAFT' : ($balance === 0 ? 'PAID' : ((int) $statement->paid_centavos > 0 ? 'PARTIALLY_PAID' : 'ISSUED'));
        DB::table('fee_statements')->where('id', $statementId)->update(['credits_centavos' => $credits, 'balance_centavos' => $balance,
            'outstanding_centavos' => $balance, 'state' => $state, 'lock_version' => (int) $statement->lock_version + 1, 'updated_at' => now()]);
        if ($balance === 0) {
            DB::table('finance_review_items')->where('kind', 'STATEMENT_OVERDUE')->where('source_id', $statementId)->where('state', 'OPEN')
                ->update(['state' => 'RESOLVED', 'resolution' => 'Settled by approved commission credit.', 'resolved_at' => now(), 'updated_at' => now()]);
        }

        return ['refund_centavos' => $refund, 'applied' => true];
    }

    /** Repair previously approved, unallocated credits once, with compensating ledger entries and original-source refunds. */
    public function synchronizeCredits(string $correlationId): void
    {
        // Earlier billing could reuse a paid/refunded credit on a later bill. Append reversals before relocating
        // credits, so no source line is edited/deleted and no credit reduces both a debt and refunded cash.
        DB::table('fee_statement_lines as l')->join('fee_adjustments as a', 'a.id', '=', 'l.fee_adjustment_id')
            ->join('fee_statement_lines as earned', 'earned.fee_assessment_id', '=', 'a.fee_assessment_id')
            ->whereColumn('l.fee_statement_id', '<>', 'earned.fee_statement_id')
            ->whereNotExists(fn ($q) => $q->selectRaw('1')->from('fee_statement_lines as reversal')->whereColumn('reversal.corrects_line_id', 'l.id')->where('reversal.line_type', 'CREDIT_REVERSAL'))
            ->orderBy('l.id')->get(['l.*'])->each(function (object $line): void {
                DB::transaction(function () use ($line): void {
                    $statement = DB::table('fee_statements')->where('id', $line->fee_statement_id)->lockForUpdate()->first();
                    if (DB::table('fee_statement_lines')->where('corrects_line_id', $line->id)->where('line_type', 'CREDIT_REVERSAL')->exists()) {
                        return;
                    }
                    $credits = (int) $statement->credits_centavos - (int) $line->amount_centavos;
                    $balance = max(0, (int) $statement->charges_centavos - $credits - (int) $statement->paid_centavos);
                    DB::table('fee_statement_lines')->insert(['id' => (string) Str::uuid7(), 'fee_statement_id' => $statement->id, 'corrects_line_id' => $line->id,
                        'line_type' => 'CREDIT_REVERSAL', 'amount_centavos' => (int) $line->amount_centavos, 'description' => 'Credit relocated to its original commission statement', 'created_at' => now(), 'updated_at' => now()]);
                    $state = in_array($statement->state, ['DRAFT', 'VOIDED'], true) ? $statement->state : ($balance === 0 ? 'PAID' : ((int) $statement->paid_centavos > 0 ? 'PARTIALLY_PAID' : 'ISSUED'));
                    DB::table('fee_statements')->where('id', $statement->id)->update(['credits_centavos' => $credits, 'balance_centavos' => $balance, 'outstanding_centavos' => $balance,
                        'state' => $state, 'lock_version' => (int) $statement->lock_version + 1, 'updated_at' => now()]);
                });
            });
        DB::table('fee_adjustments')->where('kind', 'CREDIT')->orderBy('id')->eachById(function (object $adjustment) use ($correlationId): void {
            DB::transaction(function () use ($adjustment, $correlationId): void {
                $assessment = DB::table('fee_assessments')->where('id', $adjustment->fee_assessment_id)->lockForUpdate()->first();
                $result = $this->applyCredit($adjustment);
                if (! $result['applied']) {
                    return;
                }
                $previousPayable = (int) DB::table('financial_ledger_entries')->where('source_type', 'FEE_ADJUSTMENT')->where('source_id', $adjustment->id)
                    ->where('account_code', 'FEE_REFUND_PAYABLE')->where('direction', 'CREDIT')->sum('amount_centavos');
                $difference = $result['refund_centavos'] - $previousPayable;
                $source = ['FEE_ADJUSTMENT', (string) $adjustment->id];
                app(FinancialLedgerService::class)->post(FinancialLedgerService::PLATFORM_FEE, 'FEE_CREDIT_ALLOCATION', 'PLATFORM_FEE:CREDIT_ALLOCATION:'.$adjustment->id, [
                    FinancialLedgerService::debit($difference >= 0 ? 'FEE_RECEIVABLE' : 'FEE_REFUND_PAYABLE', abs($difference), ...$source),
                    FinancialLedgerService::credit($difference >= 0 ? 'FEE_REFUND_PAYABLE' : 'FEE_RECEIVABLE', abs($difference), ...$source),
                ], $correlationId);
                if ($result['refund_centavos'] > 0) {
                    app(RefundService::class)->createFeeCreditRefunds($adjustment, $assessment, $correlationId, $result['refund_centavos']);
                }
                $this->outbox->publish('FEE_CREDIT_APPROVED', 'FEE_ADJUSTMENT', (string) $adjustment->id, ['fee_adjustment_id' => (string) $adjustment->id, 'credit_centavos' => (int) $adjustment->amount_centavos]);
            });
        });
        DB::table('finance_review_items')->where('kind', 'STATEMENT_OVERDUE')->where('state', 'OPEN')
            ->whereIn('source_id', DB::table('fee_statements')->where(fn ($q) => $q->whereIn('state', ['PAID', 'VOIDED'])->orWhere('outstanding_centavos', 0))->select('id'))
            ->update(['state' => 'RESOLVED', 'resolution' => 'Commission statement no longer has collectible debt.', 'resolved_at' => now(), 'updated_at' => now()]);
    }

    /** @return int statements drafted */
    public function draftMonthly(CarbonImmutable $now): int
    {
        $local = $now->setTimezone('Asia/Manila');
        $periodStart = $local->startOfMonth()->subMonth()->startOfDay();
        $periodEnd = $periodStart->endOfMonth();
        $vendors = DB::table('fee_assessments')->where('state', 'EARNED')->whereNull('billed_at')->where('earned_at', '<=', $periodEnd->utc())->distinct()->pluck('vendor_organization_id');
        $drafted = 0;
        foreach ($vendors as $vendorId) {
            $drafted += DB::transaction(function () use ($vendorId, $periodStart, $periodEnd, $local): int {
                DB::table('vendor_organizations')->where('id', $vendorId)->lockForUpdate()->first();
                if (DB::table('fee_statements')->where('vendor_organization_id', $vendorId)->where('period_start', $periodStart->toDateString())->where('period_end', $periodEnd->toDateString())->exists()) {
                    return 0;
                }
                $earned = DB::table('fee_assessments')->where('vendor_organization_id', $vendorId)->where('state', 'EARNED')->whereNull('billed_at')
                    ->where('earned_at', '<=', $periodEnd->utc())->orderBy('earned_at')->orderBy('id')->lockForUpdate()->get();
                $billable = $earned->where('dispute_hold', false);
                $charges = (int) $billable->sum(fn (object $row): int => (int) $row->earned_centavos);
                $held = (int) $earned->where('dispute_hold', true)->sum(fn (object $row): int => (int) $row->earned_centavos);
                if ($charges === 0) {
                    return 0;
                }
                $credits = DB::table('fee_adjustments as a')->join('fee_assessments as f', 'f.id', '=', 'a.fee_assessment_id')->whereIn('f.id', $billable->pluck('id'))
                    ->where('a.kind', 'CREDIT')->whereNotExists(fn ($query) => $query->selectRaw('1')->from('fee_statement_lines as l')->whereColumn('l.fee_adjustment_id', 'a.id'))
                    ->orderBy('a.approved_at')->get(['a.id', 'a.amount_centavos', 'a.fee_assessment_id']);
                $id = (string) Str::uuid7();
                $due = CarbonImmutable::create($periodEnd->year, $periodEnd->month, 1, 0, 0, 0, 'Asia/Manila')->addMonth()->day(15);
                DB::table('fee_statements')->insert(['id' => $id, 'vendor_organization_id' => $vendorId, 'environment' => 'TEST', 'period_start' => $periodStart->toDateString(),
                    'period_end' => $periodEnd->toDateString(), 'issued_on' => $local->toDateString(), 'due_on' => $due->max($local)->toDateString(), 'charges_centavos' => $charges,
                    'credits_centavos' => 0, 'paid_centavos' => 0, 'balance_centavos' => $charges, 'outstanding_centavos' => $charges, 'state' => 'DRAFT', 'version' => 1,
                    'statement_reference' => 'SAMPLE-STMT-'.$periodStart->format('Ym').'-'.Str::upper(Str::random(8)), 'fee_policy_version_id' => $billable->pluck('fee_policy_version_id')->unique()->count() === 1 ? $billable->first()->fee_policy_version_id : null, 'drafted_at' => now(),
                    'disputed_held_centavos' => $held, 'lock_version' => 1, 'created_at' => now(), 'updated_at' => now()]);
                foreach ($billable as $row) {
                    DB::table('fee_statement_lines')->insert(['id' => (string) Str::uuid7(), 'fee_statement_id' => $id, 'fee_assessment_id' => $row->id, 'line_type' => 'EARNED_COMMISSION',
                        'amount_centavos' => (int) $row->earned_centavos, 'description' => 'Earned '.CommissionPolicyService::percent((int) $row->commission_basis_points).' commission on completed order', 'created_at' => now(), 'updated_at' => now()]);
                    DB::table('fee_assessments')->where('id', $row->id)->update(['billed_at' => now(), 'updated_at' => now()]);
                }
                $creditTotal = 0;
                foreach ($credits as $credit) {
                    if ($creditTotal + (int) $credit->amount_centavos > $charges) {
                        break;
                    }
                    $creditTotal += (int) $credit->amount_centavos;
                    DB::table('fee_statement_lines')->insert(['id' => (string) Str::uuid7(), 'fee_statement_id' => $id, 'fee_adjustment_id' => $credit->id, 'line_type' => 'CREDIT',
                        'amount_centavos' => (int) $credit->amount_centavos, 'description' => 'Approved commission credit', 'created_at' => now(), 'updated_at' => now()]);
                }
                if ($creditTotal > 0) {
                    DB::table('fee_statements')->where('id', $id)->update(['credits_centavos' => $creditTotal, 'balance_centavos' => $charges - $creditTotal, 'outstanding_centavos' => $charges - $creditTotal]);
                }
                $this->outbox->publish('FEE_STATEMENT_DRAFTED', 'FEE_STATEMENT', $id, ['fee_statement_id' => $id]);

                return 1;
            });
        }

        return $drafted;
    }

    /** Issues a DRAFT statement. Approval never edits earned source amounts; corrections are referenced credits. */
    public function approve(string $statementId, int $reviewerUserId, int $lockVersion): object
    {
        return DB::transaction(function () use ($statementId, $reviewerUserId, $lockVersion): object {
            $statement = DB::table('fee_statements')->where('id', $statementId)->lockForUpdate()->first();
            if ($statement === null) {
                throw new AuthenticationException('STATEMENT_NOT_FOUND', 'This statement is unavailable.', 404);
            }
            if ((int) $statement->lock_version !== $lockVersion) {
                throw new AuthenticationException('VERSION_CONFLICT', 'This statement changed. Refresh before approving.', 409, ['current_lock_version' => (int) $statement->lock_version]);
            }
            if ($statement->state !== 'DRAFT') {
                throw new AuthenticationException('STATEMENT_NOT_DRAFT', 'Only a draft statement can be approved.', 409);
            }
            $issue = CarbonImmutable::now('Asia/Manila');
            $nominal = CarbonImmutable::parse((string) $statement->period_end, 'Asia/Manila')->startOfMonth()->addMonth()->day(15);
            $due = $nominal->max($issue->startOfDay()->addDays(12));
            $balance = (int) $statement->balance_centavos;
            DB::table('fee_statements')->where('id', $statementId)->update(['state' => $balance === 0 ? 'PAID' : 'ISSUED', 'approved_by_user_id' => $reviewerUserId, 'approved_at' => now(),
                'issued_at' => now(), 'issued_on' => $issue->toDateString(), 'due_on' => $due->toDateString(), 'due_at' => $due->endOfDay()->utc(), 'lock_version' => $lockVersion + 1, 'updated_at' => now()]);
            $this->notifier->owner((string) $statement->vendor_organization_id, 'Commission statement '.$statement->statement_reference.' issued',
                'Your monthly commission statement for '.CarbonImmutable::parse((string) $statement->period_start)->format('F Y').' is issued: ₱'.WithholdingThresholdService::pesos($balance)
                .' due by '.$due->format('M j, Y').' (end of day, Philippine time). TEST/DEMO statement — pay it from Finance with a Xendit TEST payment. No automatic debit is made.',
                true, 'FEE_STATEMENT', $statementId);
            $this->outbox->publish('FEE_STATEMENT_ISSUED', 'FEE_STATEMENT', $statementId, ['fee_statement_id' => $statementId]);

            return DB::table('fee_statements')->where('id', $statementId)->first();
        });
    }

    /** Daily scan: Owner notices on the due date and seven days later, then finance review. */
    public function overdueScan(CarbonImmutable $now): int
    {
        $today = $now->setTimezone('Asia/Manila')->toDateString();
        $sent = 0;
        foreach (DB::table('fee_statements')->whereIn('state', ['ISSUED', 'PARTIALLY_PAID'])->where('outstanding_centavos', '>', 0)->where('due_on', '<=', $today)->pluck('id') as $id) {
            $sent += DB::transaction(function () use ($id, $today): int {
                $statement = DB::table('fee_statements')->where('id', $id)->lockForUpdate()->first();
                if (! in_array($statement->state, ['ISSUED', 'PARTIALLY_PAID'], true) || (int) $statement->outstanding_centavos <= 0 || (string) $statement->due_on > $today) {
                    return 0;
                }
                $secondDate = CarbonImmutable::parse((string) $statement->due_on)->addDays(7)->toDateString();
                $notice = match (true) {
                    (int) $statement->overdue_notices_sent === 0 => 1,
                    (int) $statement->overdue_notices_sent === 1 && $today >= $secondDate => 2,
                    default => 0,
                };
                if ($notice === 0) {
                    return 0;
                }
                DB::table('fee_statements')->where('id', $id)->update(['overdue_notices_sent' => $notice, 'last_overdue_notice_at' => now(), 'finance_review_at' => $notice === 2 ? now() : null, 'updated_at' => now()]);
                $this->notifier->owner((string) $statement->vendor_organization_id, 'Commission statement '.$statement->statement_reference.($notice === 1 ? ' is due today' : ' is overdue'),
                    'Outstanding ₱'.WithholdingThresholdService::pesos((int) $statement->outstanding_centavos).'. Existing orders, refunds, tax records and invoices are not affected. TEST/DEMO statement.',
                    true, 'FEE_STATEMENT', (string) $id);
                if ($notice === 2) {
                    app(WithholdingThresholdService::class)->reviewItem('TEST', (string) $statement->vendor_organization_id, 'STATEMENT_OVERDUE', (string) $id, 'SEVEN_DAYS_OVERDUE',
                        'A commission statement remained unpaid seven days after its due date.', ['outstanding_centavos' => (int) $statement->outstanding_centavos], [], 'FEE_STATEMENT');
                }

                return 1;
            });
        }

        return $sent;
    }
}
