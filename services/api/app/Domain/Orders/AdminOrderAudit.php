<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Disputes\DisputeAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\AdminAccess;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/** Read-only commercial investigation. Reads never expire, reconcile or transition an order. */
final class AdminOrderAudit
{
    public function __construct(private readonly AdminAccess $access, private readonly OrderQueries $orders, private readonly AuditRecorder $audit) {}

    /** @param array<string, mixed> $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function search(Request $request, array $filters): array
    {
        $this->access->require($request, AdminOrderOperationsService::VIEW);

        return $this->orders->auditList($filters);
    }

    /** Case-scoped access never grants an investigator access to unrelated orders. */
    public function authorize(Request $request, string $orderId, ?string $caseId): object
    {
        if ($caseId === null) {
            $this->access->require($request, AdminOrderOperationsService::VIEW);
        } else {
            $this->access->require($request, DisputeAccess::ADMIN_VIEW);
            if (! DB::table('dispute_cases')->where('id', $caseId)->where('order_id', $orderId)->exists()) {
                throw new AuthenticationException('ORDER_NOT_FOUND', 'This order is unavailable for this case.', 404);
            }
        }
        $order = DB::table('orders')->where('id', $orderId)->first();
        if ($order === null) {
            throw new AuthenticationException('ORDER_NOT_FOUND', 'This order is unavailable.', 404);
        }

        return $order;
    }

    /** @return array<string, mixed> */
    public function detail(Request $request, string $orderId, ?string $caseId): array
    {
        $order = $this->authorize($request, $orderId, $caseId);
        $detail = $this->orders->auditDetail($request, $order, $caseId);
        $this->audit->account($request, 'ORDER_AUDIT_VIEWED', 'ORDER', $orderId, after: ['case_id' => $caseId]);

        return $detail;
    }
}
