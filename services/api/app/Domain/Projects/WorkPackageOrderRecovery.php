<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Operations\OutboxPublisher;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderStates;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Reopens procurement coverage, retaining every order, payment, quotation and locked original. */
final class WorkPackageOrderRecovery
{
    public function reopen(object $order, OrderActor $actor): void
    {
        if ($order->work_package_id === null || ! in_array($order->order_state, OrderStates::CLOSED_BEFORE_FULFILLMENT, true)) {
            return;
        }
        $w = DB::table('work_packages')->where('id', $order->work_package_id)->lockForUpdate()->first();
        if ($w === null || $w->current_version_id !== $order->work_package_version_id || $w->deleted_at !== null
            || in_array($w->status, ['DRAFT', 'CANCELLED'], true)) {
            return;
        }
        if (DB::table('audit_logs')->where('resource_type', 'WORK_PACKAGE')->where('resource_id', $w->id)->where('action', 'WORK_PACKAGE_REOPENED')
            ->whereRaw("\"after\"->>'closed_order_id' = ?", [$order->id])->exists()) {
            return;
        }
        if ($w->selected_arrangement_id !== null) {
            if ($w->selected_arrangement_id !== $order->project_arrangement_id) {
                return;
            }
            // Peers remain selected; the arrangement's existing failed-member projection exposes only uncovered requirements.
            DB::table('project_procurement_arrangements')->where('id', $w->selected_arrangement_id)->increment('lock_version');
        } else {
            if (DB::table('orders')->where('work_package_id', $w->id)->where('work_package_version_id', $w->current_version_id)
                ->where('procurement_type', 'PROJECT_BASED')->whereNotIn('order_state', OrderStates::CLOSED_BEFORE_FULFILLMENT)->exists()) {
                return;
            }
            DB::table('work_packages')->where('id', $w->id)->update(['status' => 'ACTIVE', 'selected_vendor_organization_id' => null]);
            DB::table('compiled_estimates')->where('work_package_version_id', $w->current_version_id)->where('created_at', '<=', $order->closed_at ?? $order->updated_at)
                ->whereNull('invalidated_at')->update(['invalidated_at' => now(), 'state' => 'INVALIDATED', 'updated_at' => now()]);
        }
        DB::table('work_packages')->where('id', $w->id)->update(['lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
        DB::table('audit_logs')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => $actor->userId, 'actor_role' => $actor->role,
            'vendor_organization_id' => $order->vendor_organization_id, 'action' => 'WORK_PACKAGE_REOPENED', 'resource_type' => 'WORK_PACKAGE', 'resource_id' => $w->id,
            'before' => json_encode(['status' => $w->status], JSON_THROW_ON_ERROR), 'after' => json_encode(['closed_order_id' => $order->id, 'coverage_reopened' => true], JSON_THROW_ON_ERROR),
            'correlation_id' => $actor->correlationId, 'succeeded' => true, 'created_at' => now(), 'updated_at' => now()]);
        app(OutboxPublisher::class)->publish('WORK_PACKAGE_REOPENED', 'WORK_PACKAGE', (string) $w->id,
            ['work_package_id' => $w->id, 'closed_order_id' => $order->id, 'reason' => $order->order_state]);
    }
}
