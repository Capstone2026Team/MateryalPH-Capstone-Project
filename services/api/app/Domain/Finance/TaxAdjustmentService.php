<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Notifications\NotificationService;
use App\Support\PortalDateRange;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * FIN-07/FIN-10 tax adjustments (DEMO — simulation). A preparer records the original period and assessment, the
 * reason, the proposed corrected withholding, the refund evidence reference and the certificate impact; a different
 * authorized reviewer approves or rejects; an approved adjustment is posted as a linked compensating entry in the
 * DEMO_FLOW ledger. Posted assessments, filed returns and the FIN-04A accumulator are never rewritten: refunds never
 * restore relief, and nothing here changes the taxable-year counter or status.
 */
final class TaxAdjustmentService
{
    public const CERTIFICATE_IMPACT = ['NONE', 'REISSUE_REQUIRED', 'AMENDMENT_REQUIRED'];

    private const PER_PAGE = 25;

    public function __construct(
        private readonly FinanceAccess $access,
        private readonly FinancialLedgerService $ledger,
        private readonly AuditRecorder $audit,
        private readonly NotificationService $notifications,
    ) {}

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function list(Request $request, array $filters): array
    {
        $viewer = $this->access->admin($request, 'finance.view');
        $query = $this->base()->when($filters['state'] ?? null, fn (Builder $q, string $state) => $q->where('t.state', $state));
        PortalDateRange::apply($query, 't.created_at', $filters);
        $total = (clone $query)->count();
        $page = max(1, min(1000, (int) ($filters['page'] ?? 1)));
        $rows = $query->orderByRaw("CASE t.state WHEN 'ADJUSTMENT_REQUIRED' THEN 0 WHEN 'UNDER_REVIEW' THEN 1 WHEN 'APPROVED' THEN 2 ELSE 3 END")->orderBy('t.created_at')
            ->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get();

        return ['items' => $rows->map(fn (object $row): array => $this->present($row, $viewer))->all(), 'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total,
            'has_more' => $page * self::PER_PAGE < $total, 'label' => 'DEMO — No real funds or BIR filing']];
    }

    /**
     * @param  array{corrected_withheld_centavos: int, reason: string, certificate_impact: string, evidence_reference?: string|null}  $input
     * @return array<string, mixed>
     */
    public function prepare(Request $request, string $id, array $input): array
    {
        $preparer = $this->access->admin($request, 'finance.review_tax');
        if (! in_array($input['certificate_impact'], self::CERTIFICATE_IMPACT, true) || $input['corrected_withheld_centavos'] < 0) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Enter a non-negative corrected withholding and the certificate impact.', 422);
        }
        DB::transaction(function () use ($id, $input, $preparer): void {
            $row = $this->locked($id);
            if (! in_array($row->state, ['ADJUSTMENT_REQUIRED', 'REJECTED'], true)) {
                throw new AuthenticationException('TAX_ADJUSTMENT_NOT_OPEN', 'Only an open or rejected adjustment can be prepared.', 409);
            }
            $before = json_decode((string) $row->before_values, true) ?: [];
            $original = (int) ($before['withheld_centavos'] ?? 0);
            DB::table('tax_adjustments')->where('id', $row->id)->update(['state' => 'UNDER_REVIEW', 'prepared_by_user_id' => $preparer, 'reviewed_by_user_id' => null, 'reviewed_at' => null,
                'after_values' => json_encode(['proposed_withheld_centavos' => $input['corrected_withheld_centavos'], 'difference_centavos' => $input['corrected_withheld_centavos'] - $original,
                    'certificate_impact' => $input['certificate_impact'], 'evidence_reference' => mb_substr(trim((string) ($input['evidence_reference'] ?? '')), 0, 200) ?: null,
                    'preparer_reason' => mb_substr(trim($input['reason']), 0, 2000)], JSON_THROW_ON_ERROR), 'updated_at' => now()]);
        });
        $this->audit->account($request, 'TAX_ADJUSTMENT_PREPARED', 'TAX_ADJUSTMENT', $id, after: ['corrected_withheld_centavos' => $input['corrected_withheld_centavos'], 'certificate_impact' => $input['certificate_impact']], reason: $input['reason']);

        return $this->show($request, $id);
    }

    /** @return array<string, mixed> */
    public function review(Request $request, string $id, string $decision, string $reason): array
    {
        $reviewer = $this->access->admin($request, 'finance.review_tax');
        if (! in_array($decision, ['APPROVED', 'REJECTED'], true)) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Approve or reject the prepared adjustment.', 422);
        }
        DB::transaction(function () use ($id, $decision, $reviewer): void {
            $row = $this->locked($id);
            if ($row->state !== 'UNDER_REVIEW') {
                throw new AuthenticationException('TAX_ADJUSTMENT_NOT_UNDER_REVIEW', 'Only a prepared adjustment can be reviewed.', 409);
            }
            if ((int) $row->prepared_by_user_id === $reviewer) {
                throw new AuthenticationException('PREPARER_CANNOT_REVIEW', 'A different finance user must review an adjustment you prepared.', 409);
            }
            DB::table('tax_adjustments')->where('id', $row->id)->update(['state' => $decision, 'reviewed_by_user_id' => $reviewer, 'reviewed_at' => now(), 'updated_at' => now()]);
        });
        $this->audit->account($request, 'TAX_ADJUSTMENT_'.$decision, 'TAX_ADJUSTMENT', $id, ['state' => 'UNDER_REVIEW'], ['state' => $decision], reason: $reason);

        return $this->show($request, $id);
    }

    /** @return array<string, mixed> */
    public function post(Request $request, string $id): array
    {
        $actor = $this->access->admin($request, 'finance.review_tax');
        $correlation = (string) ($request->attributes->get('correlation_id') ?? Str::uuid7());
        $row = DB::transaction(function () use ($id, $actor, $correlation): object {
            $row = $this->locked($id);
            if ($row->state !== 'APPROVED') {
                throw new AuthenticationException('TAX_ADJUSTMENT_NOT_APPROVED', 'Only an approved adjustment can be posted.', 409);
            }
            $after = json_decode((string) $row->after_values, true) ?: [];
            $difference = (int) ($after['difference_centavos'] ?? 0);
            $source = ['TAX_ADJUSTMENT', (string) $row->id];
            // A linked compensating entry: the original CWT batch stays untouched.
            $this->ledger->post(FinancialLedgerService::DEMO_FLOW, 'SIMULATED_CWT_ADJUSTMENT', 'DEMO_FLOW:CWT_ADJUSTMENT:'.$row->id, $difference < 0
                ? [FinancialLedgerService::debit('CWT_CONTROL', -$difference, ...$source), FinancialLedgerService::credit('VENDOR_PAYABLE', -$difference, ...$source)]
                : [FinancialLedgerService::debit('VENDOR_PAYABLE', $difference, ...$source), FinancialLedgerService::credit('CWT_CONTROL', $difference, ...$source)], $correlation, $actor, 'FINANCE_REVIEWER', (string) $row->environment);
            DB::table('tax_adjustments')->where('id', $row->id)->update(['state' => 'POSTED', 'posted_at' => now(), 'updated_at' => now()]);

            return $row;
        });
        $this->audit->account($request, 'TAX_ADJUSTMENT_POSTED', 'TAX_ADJUSTMENT', $id, ['state' => 'APPROVED'], ['state' => 'POSTED']);
        $organization = $row->order_id === null ? null : DB::table('orders')->where('id', $row->order_id)->value('vendor_organization_id');
        if ($organization !== null) {
            foreach (DB::table('vendor_memberships')->where('vendor_organization_id', $organization)->where('role', 'OWNER')->where('status', 'ACTIVE')->pluck('user_id') as $owner) {
                $this->notifications->record((int) $owner, 'FINANCE_MANDATORY', 'Withholding adjustment posted (DEMO)', 'A reviewed withholding adjustment was posted as a linked entry. The original assessment is unchanged. DEMO — No real funds or BIR filing.',
                    'TAX_ADJUSTMENT', $id, 'tax-adjustment-posted:'.$id, (string) $organization);
            }
        }

        return $this->show($request, $id);
    }

    /** @return array<string, mixed> */
    public function show(Request $request, string $id): array
    {
        $viewer = $this->access->admin($request, 'finance.view');
        $row = Str::isUuid($id) ? $this->base()->where('t.id', $id)->first() : null;
        if ($row === null) {
            throw new AuthenticationException('TAX_ADJUSTMENT_NOT_FOUND', 'This tax adjustment is unavailable.', 404);
        }

        return $this->present($row, $viewer);
    }

    private function locked(string $id): object
    {
        $row = Str::isUuid($id) ? DB::table('tax_adjustments')->where('id', $id)->lockForUpdate()->first() : null;
        if ($row === null) {
            throw new AuthenticationException('TAX_ADJUSTMENT_NOT_FOUND', 'This tax adjustment is unavailable.', 404);
        }

        return $row;
    }

    private function base(): Builder
    {
        return DB::table('tax_adjustments as t')->leftJoin('orders as o', 'o.id', '=', 't.order_id')->leftJoin('vendor_organizations as v', 'v.id', '=', 'o.vendor_organization_id')
            ->leftJoin('users as p', 'p.id', '=', 't.prepared_by_user_id')->leftJoin('users as r', 'r.id', '=', 't.reviewed_by_user_id')
            ->select(['t.*', 'o.reference as order_reference', 'v.store_name', 'p.name as preparer_name', 'r.name as reviewer_name']);
    }

    /** @return array<string, mixed> */
    private function present(object $row, int $viewer): array
    {
        $allowed = match ($row->state) {
            'ADJUSTMENT_REQUIRED', 'REJECTED' => ['PREPARE'],
            'UNDER_REVIEW' => (int) $row->prepared_by_user_id === $viewer ? [] : ['APPROVE', 'REJECT'],
            'APPROVED' => ['POST'],
            default => [],
        };

        return ['id' => (string) $row->id, 'kind' => (string) $row->kind, 'state' => (string) $row->state, 'environment' => (string) $row->environment, 'opened_by' => (string) $row->opened_by,
            'order_reference' => $row->order_reference, 'vendor_name' => $row->store_name, 'original_record_type' => (string) $row->original_record_type, 'original_record_id' => (string) $row->original_record_id,
            'period_start' => (string) $row->period_start, 'period_end' => (string) $row->period_end, 'amount_centavos' => (int) $row->amount_centavos,
            'before_values' => json_decode((string) $row->before_values, true) ?: (object) [], 'after_values' => json_decode((string) $row->after_values, true) ?: (object) [],
            'reason' => (string) $row->reason, 'preparer' => $row->preparer_name, 'reviewer' => $row->reviewer_name, 'reviewed_at' => self::iso($row->reviewed_at), 'posted_at' => self::iso($row->posted_at),
            'created_at' => self::iso($row->created_at), 'allowed_actions' => $allowed,
            'separation_note' => (int) $row->prepared_by_user_id === $viewer && $row->state === 'UNDER_REVIEW' ? 'You prepared this adjustment; a different finance user must review it.' : null];
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
