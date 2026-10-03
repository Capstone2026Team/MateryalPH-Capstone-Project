<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Payments\RefundService;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Admin order operations for Order and Dispute Staff and Super Admin: refund instructions and exceptions, authorized
 * retry of a failed refund after funding is resolved, evidenced cash reimbursements, open cancellation requests and
 * NFR events. Admins never hold, receive or disburse money; a retry only re-sends the same instruction to the original
 * payment. Buyer coordinates, private contacts and provider identifiers never appear.
 */
final class AdminOrderOperationsService
{
    public const VIEW = 'orders.operations.view';

    public const RETRY = 'refunds.retry';

    public function __construct(private readonly CatalogAccess $access, private readonly RefundService $refunds, private readonly AuditRecorder $audit) {}

    /** @return array<string, int> */
    public function summary(Request $request): array
    {
        $this->access->requireAdmin($request, self::VIEW);

        return [
            'refunds_failed' => DB::table('refunds')->where('state', 'REFUND_FAILED')->count(),
            'refunds_pending' => DB::table('refunds')->where('state', 'REFUND_PENDING')->count(),
            'reimbursements_pending' => DB::table('physical_reimbursements')->whereNotNull('order_id')->where('state', 'VENDOR_REIMBURSEMENT_PENDING')->count(),
            'cancellation_requests_open' => DB::table('cancellation_requests')->where('state', 'REQUESTED')->count(),
            'nfr_events_30_days' => DB::table('nfr_events')->where('occurred_at', '>=', now()->subDays(30))->count(),
        ];
    }

    /**
     * @param  array{state?: string, trigger?: string, page?: int}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function refunds(Request $request, array $filters): array
    {
        $this->access->requireAdmin($request, self::VIEW);
        $retry = $this->allows($request, self::RETRY);
        $query = DB::table('refunds as r')->leftJoin('orders as o', 'o.id', '=', 'r.order_id')->leftJoin('fee_statements as s', 's.id', '=', 'r.fee_statement_id')
            ->leftJoin('store_profiles as sp', 'sp.vendor_organization_id', '=', DB::raw('coalesce(o.vendor_organization_id, s.vendor_organization_id)'))
            ->when(isset($filters['state']), fn ($q) => $q->where('r.state', $filters['state']))->when(isset($filters['trigger']), fn ($q) => $q->where('r.trigger', $filters['trigger']));
        $page = max(1, (int) ($filters['page'] ?? 1));
        $total = (clone $query)->count();
        $rows = $query->orderByRaw("CASE r.state WHEN 'REFUND_FAILED' THEN 0 WHEN 'REFUND_PENDING' THEN 1 ELSE 2 END")->orderByDesc('r.created_at')->orderByDesc('r.id')
            ->offset(($page - 1) * 25)->limit(25)->get(['r.*', 'o.reference as order_reference', 's.statement_reference', 'sp.public_store_name']);

        return ['items' => $rows->map(static fn (object $row): array => [
            'id' => (string) $row->id, 'target_type' => (string) $row->target_type, 'trigger' => (string) $row->trigger, 'state' => (string) $row->state,
            'display_state' => $row->state === 'REFUNDED' ? 'PROCESSED' : ($row->state === 'REFUND_FAILED' ? 'FAILED' : ($row->provider_reference === null ? 'QUEUED' : 'INITIATED')),
            'amount_centavos' => (int) $row->amount_centavos, 'attempt_number' => (int) $row->attempt_number, 'failure_code' => $row->failure_code, 'evidence_origin' => $row->evidence_origin,
            'order_id' => $row->order_id, 'order_reference' => $row->order_reference, 'statement_reference' => $row->statement_reference, 'vendor_name' => $row->public_store_name,
            'requested_at' => self::iso($row->requested_at ?? $row->created_at), 'completed_at' => self::iso($row->completed_at), 'can_retry' => $retry && $row->state === 'REFUND_FAILED',
        ])->values()->all(), 'meta' => ['page' => $page, 'per_page' => 25, 'total' => $total, 'has_more' => $page * 25 < $total]];
    }

    public function retry(Request $request, string $refundId): void
    {
        $this->access->requireAdmin($request, self::RETRY);
        $key = $this->access->requireIdempotencyKey($request);
        if ($this->access->replayed($request, 'ADMIN_REFUND_RETRY', $key, $refundId)) {
            return;
        }
        $role = (string) (DB::table('admin_memberships as m')->join('platform_roles as r', 'r.id', '=', 'm.platform_role_id')->where('m.user_id', $request->user()->getKey())->where('m.status', 'ACTIVE')->value('r.code') ?? 'ADMIN');
        $this->refunds->retry($refundId, new OrderActor((int) $request->user()->getKey(), $role, 'SYSTEM', (string) ($request->attributes->get('correlation_id') ?: Str::uuid7())));
        $this->access->claim($request, 'ADMIN_REFUND_RETRY', $key, $refundId, 200);
        $this->audit->account($request, 'REFUND_RETRIED_BY_ADMIN', 'REFUND', $refundId);
    }

    /** @return list<array<string, mixed>> */
    public function reimbursements(Request $request): array
    {
        $this->access->requireAdmin($request, self::VIEW);

        return DB::table('physical_reimbursements as p')->join('orders as o', 'o.id', '=', 'p.order_id')->leftJoin('store_profiles as sp', 'sp.vendor_organization_id', '=', 'o.vendor_organization_id')
            ->orderByRaw("CASE p.state WHEN 'VENDOR_REIMBURSEMENT_PENDING' THEN 0 ELSE 1 END")->orderByDesc('p.created_at')->limit(100)
            ->get(['p.*', 'o.reference as order_reference', 'sp.public_store_name'])->map(fn (object $row): array => [
                'id' => (string) $row->id, 'order_reference' => (string) $row->order_reference, 'vendor_name' => $row->public_store_name, 'state' => (string) $row->state,
                'amount_centavos' => (int) $row->amount_centavos, 'method' => (string) $row->method, 'has_evidence' => $row->evidence_file_id !== null,
                'reimbursed_at' => self::iso($row->reimbursed_at), 'buyer_acknowledged_at' => self::iso($row->buyer_acknowledged_at), 'confirmed_by_review' => $row->confirmed_by_user_id !== null,
                'can_decide' => $row->state === 'VENDOR_REIMBURSEMENT_PENDING' && $row->evidence_file_id !== null && $this->allows($request, 'reimbursements.decide'),
            ])->values()->all();
    }

    /** @return list<array<string, mixed>> */
    public function cancellationRequests(Request $request): array
    {
        $this->access->requireAdmin($request, self::VIEW);

        return DB::table('cancellation_requests as c')->join('orders as o', 'o.id', '=', 'c.order_id')->leftJoin('store_profiles as sp', 'sp.vendor_organization_id', '=', 'o.vendor_organization_id')
            ->where('c.state', 'REQUESTED')->orderBy('c.response_due_at')->limit(100)->get(['c.*', 'o.reference as order_reference', 'sp.public_store_name'])
            ->map(static fn (object $row): array => ['id' => (string) $row->id, 'order_reference' => (string) $row->order_reference, 'vendor_name' => $row->public_store_name,
                'reason_code' => (string) $row->reason_code, 'requested_at' => self::iso($row->created_at), 'response_due_at' => self::iso($row->response_due_at),
                'overdue' => $row->response_due_at !== null && CarbonImmutable::parse((string) $row->response_due_at)->isPast()])->values()->all();
    }

    private function allows(Request $request, string $permission): bool
    {
        try {
            $this->access->requireAdmin($request, $permission);

            return true;
        } catch (AuthenticationException) {
            return false;
        }
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
