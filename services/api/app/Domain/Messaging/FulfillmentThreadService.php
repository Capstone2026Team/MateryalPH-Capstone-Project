<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Phase 12 will invoke this inside its milestone transaction. There is deliberately no public entry action. */
final class FulfillmentThreadService
{
    public const ENTRY_ENABLED = false;

    /** Internal Phase 12 assignment use case; no early conversation is created. */
    public function assign(Request $request, string $orderId, int $userId, string $reason): void
    {
        DB::transaction(function () use ($request, $orderId, $userId, $reason): void {
            $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            $scope = app(AccountAccess::class)->resolve($request->user());
            if ($order === null || $scope['organization_id'] !== $order->vendor_organization_id || ! in_array($scope['role'], ['OWNER', 'STORE_MANAGER'], true)) {
                throw new AuthenticationException('PERMISSION_DENIED', 'Only the permitted Owner or Manager may assign this order.', 403);
            }
            $target = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $order->vendor_organization_id)
                ->where('m.user_id', $userId)->where('m.role', 'FULFILLMENT')->where('m.status', 'ACTIVE')->where('u.account_status', 'ACTIVE')->exists();
            if (! $target || trim($reason) === '') {
                throw new AuthenticationException('HANDLER_UNAVAILABLE', 'Choose active Fulfillment Staff and provide an assignment reason.', 422);
            }
            $old = DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->whereNull('ended_at')->first();
            if ($old !== null && (int) $old->user_id === $userId) {
                return;
            }
            DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->whereNull('ended_at')->update(['ended_at' => now(), 'updated_at' => now()]);
            DB::table('order_fulfillment_assignments')->insert(['id' => (string) Str::uuid7(), 'order_id' => $orderId, 'user_id' => $userId, 'assigned_by_user_id' => $request->user()->id, 'created_at' => now(), 'updated_at' => now()]);
            $c = DB::table('conversations')->where('order_id', $orderId)->lockForUpdate()->first();
            if ($c !== null) {
                DB::table('conversation_participants')->where('conversation_id', $c->id)->where('participant_role', 'FULFILLMENT')->update(['revoked_at' => now(), 'updated_at' => now()]);
                DB::table('conversation_assignments')->where('conversation_id', $c->id)->whereNull('ended_at')->update(['ended_at' => now(), 'updated_at' => now()]);
                DB::table('conversation_assignments')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $c->id, 'assigned_user_id' => $userId, 'assigned_by_user_id' => $request->user()->id, 'assigned_role' => 'FULFILLMENT', 'reason' => $reason, 'created_at' => now(), 'updated_at' => now()]);
                DB::table('conversations')->where('id', $c->id)->update(['handler_user_id' => $userId, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
                $messages = app(ConversationService::class);
                $messages->participant((string) $c->id, $userId, 'FULFILLMENT');
                $messages->append($c, $request->user(), 'The assigned Fulfillment Staff changed. Earlier messages retain their original attribution.');
            }
            app(AuditRecorder::class)->account($request, 'ORDER_FULFILLMENT_ASSIGNED', 'ORDER', $orderId, before: ['user_id' => $old?->user_id], after: ['user_id' => $userId, 'reason' => $reason]);
        });
    }

    public function ensureForMilestone(string $orderId): string
    {
        return DB::transaction(function () use ($orderId): string {
            $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            $existing = DB::table('conversations')->where('order_id', $orderId)->first();
            if ($existing !== null) {
                return (string) $existing->id;
            }
            if ($order === null || ! in_array($order->order_state, ['READY_FOR_PICKUP', 'OUT_FOR_DELIVERY'], true)) {
                throw new AuthenticationException('FULFILLMENT_THREAD_NOT_READY', 'Fulfillment messages open at Ready for Pickup or Out for Delivery.', 409);
            }
            $id = (string) Str::uuid7();
            $assigned = DB::table('order_fulfillment_assignments')->where('order_id', $orderId)->whereNull('ended_at')->value('user_id');
            if ($assigned === null || ! DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')
                ->where('m.vendor_organization_id', $order->vendor_organization_id)->where('m.user_id', $assigned)->where('m.role', 'FULFILLMENT')
                ->where('m.status', 'ACTIVE')->where('u.account_status', 'ACTIVE')->exists()) {
                throw new AuthenticationException('FULFILLMENT_ASSIGNMENT_REQUIRED', 'Assign active Fulfillment Staff before opening order coordination.', 409);
            }
            DB::table('conversations')->insert(['id' => $id, 'buyer_profile_id' => $order->buyer_profile_id, 'vendor_organization_id' => $order->vendor_organization_id,
                'purpose' => 'FULFILLMENT', 'order_id' => $orderId, 'context_type' => $order->procurement_type, 'context_id' => $orderId, 'handler_user_id' => $assigned,
                'created_at' => now(), 'updated_at' => now()]);
            $service = app(ConversationService::class);
            $service->participant($id, (int) DB::table('buyer_profiles')->where('id', $order->buyer_profile_id)->value('user_id'), 'BUYER');
            $service->participant($id, (int) $assigned, 'FULFILLMENT');
            DB::table('conversation_assignments')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'assigned_user_id' => $assigned,
                'assigned_role' => 'FULFILLMENT', 'reason' => 'Initial order fulfillment assignment', 'created_at' => now(), 'updated_at' => now()]);
            $service->changed($id);

            return $id;
        });
    }
}
