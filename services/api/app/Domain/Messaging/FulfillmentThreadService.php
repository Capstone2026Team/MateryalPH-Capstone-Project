<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderStates;
use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * One order-specific FULFILLMENT thread (ONB-09), separate from every sales conversation. It is enabled only by the
 * first valid READY_FOR_PICKUP or OUT_FOR_DELIVERY milestone, inside that milestone's transaction, so its creation
 * and CONVERSATION_CHANGED outbox event commit with the milestone or not at all. A repeated or reordered milestone
 * reuses the one thread (unique order id). Participants are the Buyer, the Owner/Store Manager by role, and the
 * currently assigned active Fulfillment Staff; access is re-evaluated on every request, socket and file read, so a
 * reassignment or deactivation removes access immediately while every earlier message keeps its attribution.
 *
 * Lifecycle (approved by the project owner on 2026-10-02): writable until the order closes; at COMPLETED or
 * CANCELLED it becomes read-only, the Fulfillment Staff assignment ends, and the Buyer, Owner and Store Manager keep
 * the full history.
 */
final class FulfillmentThreadService
{
    public const ENTRY_ENABLED = true;

    /** Orders whose thread accepts new messages. */
    public const WRITABLE_STATES = [OrderStates::READY_FOR_PICKUP, OrderStates::OUT_FOR_DELIVERY, OrderStates::DELIVERED, OrderStates::PICKED_UP, 'DISPUTED'];

    /**
     * Assigns (or reassigns) active Fulfillment Staff to an order the caller has locked. Ends the previous
     * assignment, revokes the former assignee's thread participation and announces the change in the thread.
     */
    public function assign(object $order, User $actor, int $userId, string $reason): ?int
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Fulfillment assignment changes only inside the order transaction.');
        }
        if (OrderStates::isClosed((string) $order->order_state) || in_array($order->order_state, [...OrderStates::PENDING_ACCEPTANCE, OrderStates::AWAITING_PAYMENT], true)) {
            throw new AuthenticationException('ASSIGNMENT_NOT_AVAILABLE', 'Fulfillment Staff can be assigned from confirmation until the order closes.', 409);
        }
        $target = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $order->vendor_organization_id)
            ->where('m.user_id', $userId)->where('m.role', 'FULFILLMENT')->where('m.status', 'ACTIVE')->where('u.account_status', 'ACTIVE')->exists();
        if (! $target || mb_strlen(trim($reason)) < 5) {
            throw new AuthenticationException('HANDLER_UNAVAILABLE', 'Choose active Fulfillment Staff and give an assignment reason of at least 5 characters.', 422);
        }
        $old = DB::table('order_fulfillment_assignments')->where('order_id', $order->id)->whereNull('ended_at')->lockForUpdate()->first();
        if ($old !== null && (int) $old->user_id === $userId) {
            return null;
        }
        DB::table('order_fulfillment_assignments')->where('order_id', $order->id)->whereNull('ended_at')->update(['ended_at' => now(), 'updated_at' => now()]);
        DB::table('order_fulfillment_assignments')->insert(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'user_id' => $userId, 'assigned_by_user_id' => $actor->id, 'created_at' => now(), 'updated_at' => now()]);
        $c = DB::table('conversations')->where('order_id', $order->id)->where('purpose', 'FULFILLMENT')->lockForUpdate()->first();
        if ($c !== null) {
            DB::table('conversation_participants')->where('conversation_id', $c->id)->where('participant_role', 'FULFILLMENT')->whereNull('revoked_at')->update(['revoked_at' => now(), 'updated_at' => now()]);
            DB::table('conversation_assignments')->where('conversation_id', $c->id)->whereNull('ended_at')->update(['ended_at' => now(), 'updated_at' => now()]);
            DB::table('conversation_assignments')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $c->id, 'assigned_user_id' => $userId, 'assigned_by_user_id' => $actor->id,
                'assigned_role' => 'FULFILLMENT', 'reason' => mb_substr($reason, 0, 500), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('conversations')->where('id', $c->id)->update(['handler_user_id' => $userId, 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
            $messages = app(ConversationService::class);
            $messages->participant((string) $c->id, $userId, 'FULFILLMENT');
            $messages->append($c, $actor, 'The assigned Fulfillment Staff changed. Earlier messages keep their original attribution.');
        }

        return $old === null ? null : (int) $old->user_id;
    }

    /**
     * Creates or reuses the order's single fulfillment thread inside the caller's milestone transaction. Throws when
     * the order has not reached READY_FOR_PICKUP or OUT_FOR_DELIVERY, so no thread can open early.
     */
    public function ensureForMilestone(string $orderId, ?int $actorUserId = null): string
    {
        return DB::transaction(function () use ($orderId, $actorUserId): string {
            $order = DB::table('orders')->where('id', $orderId)->lockForUpdate()->first();
            $existing = DB::table('conversations')->where('order_id', $orderId)->where('purpose', 'FULFILLMENT')->first();
            if ($existing !== null) {
                return (string) $existing->id;
            }
            if ($order === null || ! in_array($order->order_state, OrderStates::HANDOVER_STAGE, true)) {
                throw new AuthenticationException('FULFILLMENT_THREAD_NOT_READY', 'Fulfillment messages open at Ready for Pickup or Out for Delivery.', 409);
            }
            $id = (string) Str::uuid7();
            $assigned = DB::table('order_fulfillment_assignments as a')->join('vendor_memberships as m', fn ($join) => $join->on('m.user_id', '=', 'a.user_id')->where('m.vendor_organization_id', $order->vendor_organization_id))
                ->join('users as u', 'u.id', '=', 'a.user_id')->where('a.order_id', $orderId)->whereNull('a.ended_at')->where('m.role', 'FULFILLMENT')->where('m.status', 'ACTIVE')
                ->where('u.account_status', 'ACTIVE')->value('a.user_id');
            // Teams are optional: without assigned staff the Owner/Store Manager who recorded the milestone handles it.
            $handler = $assigned ?? $actorUserId ?? DB::table('vendor_memberships')->where('vendor_organization_id', $order->vendor_organization_id)->where('role', 'OWNER')->where('status', 'ACTIVE')->value('user_id');
            DB::table('conversations')->insert(['id' => $id, 'buyer_profile_id' => $order->buyer_profile_id, 'vendor_organization_id' => $order->vendor_organization_id,
                'purpose' => 'FULFILLMENT', 'order_id' => $orderId, 'context_type' => $order->procurement_type, 'context_id' => $orderId, 'handler_user_id' => $handler,
                'created_at' => now(), 'updated_at' => now()]);
            $service = app(ConversationService::class);
            $service->participant($id, (int) DB::table('buyer_profiles')->where('id', $order->buyer_profile_id)->value('user_id'), 'BUYER');
            if ($assigned !== null) {
                $service->participant($id, (int) $assigned, 'FULFILLMENT');
            }
            if ($handler !== null) {
                $role = $assigned !== null ? 'FULFILLMENT' : (string) (DB::table('vendor_memberships')->where('vendor_organization_id', $order->vendor_organization_id)->where('user_id', $handler)->value('role') ?? 'OWNER');
                DB::table('conversation_assignments')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'assigned_user_id' => $handler,
                    'assigned_role' => $role, 'reason' => 'Opened by the '.strtolower(str_replace('_', ' ', (string) $order->order_state)).' milestone', 'created_at' => now(), 'updated_at' => now()]);
            }
            $service->changed($id);

            return $id;
        });
    }

    /**
     * At COMPLETED or CANCELLED: the thread becomes read-only by order state, the Fulfillment Staff assignment ends so
     * staff access is removed, and a system message records the closure. History is never deleted.
     */
    public function close(object $order, User|int|null $actor, string $closingState): void
    {
        DB::table('order_fulfillment_assignments')->where('order_id', $order->id)->whereNull('ended_at')->update(['ended_at' => now(), 'updated_at' => now()]);
        $c = DB::table('conversations')->where('order_id', $order->id)->where('purpose', 'FULFILLMENT')->lockForUpdate()->first();
        if ($c === null) {
            return;
        }
        DB::table('conversation_participants')->where('conversation_id', $c->id)->where('participant_role', 'FULFILLMENT')->whereNull('revoked_at')->update(['revoked_at' => now(), 'updated_at' => now()]);
        DB::table('conversations')->where('id', $c->id)->update(['lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
        // A system message shows the MateryalPH identity; the stored sender is the acting user or the store Owner.
        $system = $actor instanceof User ? $actor : User::query()->find(is_int($actor) ? $actor
            : DB::table('vendor_memberships')->where('vendor_organization_id', $order->vendor_organization_id)->where('role', 'OWNER')->where('status', 'ACTIVE')->value('user_id'));
        if ($system !== null) {
            app(ConversationService::class)->append($c, $system, $closingState === OrderStates::COMPLETED
                ? 'This order is completed. Fulfillment messages are now read-only and kept for your records.'
                : 'This order was cancelled. Fulfillment messages are now read-only and kept for your records.');
        }
    }

    /** @return array{read_only: bool, reason: ?string} */
    public static function writability(object $conversation): array
    {
        if ($conversation->purpose !== 'FULFILLMENT') {
            return ['read_only' => false, 'reason' => null];
        }
        $state = (string) DB::table('orders')->where('id', $conversation->order_id)->value('order_state');
        if (in_array($state, self::WRITABLE_STATES, true)) {
            return ['read_only' => false, 'reason' => null];
        }

        return ['read_only' => true, 'reason' => $state === OrderStates::COMPLETED ? 'ORDER_COMPLETED' : ($state === OrderStates::CANCELLED ? 'ORDER_CANCELLED' : 'ORDER_NOT_IN_FULFILLMENT')];
    }

    public static function requireWritable(object $conversation): void
    {
        $state = self::writability($conversation);
        if ($state['read_only']) {
            throw new AuthenticationException('CONVERSATION_READ_ONLY', 'This order is closed, so its fulfillment messages are read-only. Use Report a Problem or the dispute process for any issue.', 409, ['reason' => $state['reason']]);
        }
    }
}
