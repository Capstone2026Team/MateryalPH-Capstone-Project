<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Models\User;
use Illuminate\Support\Facades\DB;

/** Current authority is re-read for REST, file bytes, subscription and every outbox delivery. */
final class ConversationAccess
{
    public const SALES_ROLES = ['OWNER', 'STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE'];

    public function __construct(private readonly AccountAccess $accounts) {}

    public function allows(User $user, object $conversation): bool
    {
        $user->refresh();
        try {
            $scope = $this->accounts->resolve($user);
        } catch (AuthenticationException) {
            return false;
        }
        if ($user->account_type === 'BUYER') {
            return DB::table('buyer_profiles')->where('id', $conversation->buyer_profile_id)->where('user_id', $user->id)->exists();
        }
        if ($user->account_type !== 'VENDOR' || $scope['organization_id'] !== $conversation->vendor_organization_id) {
            return false;
        }
        if ($conversation->purpose === 'FULFILLMENT') {
            return in_array($scope['role'], ['OWNER', 'STORE_MANAGER'], true) || ($scope['role'] === 'FULFILLMENT'
                && DB::table('order_fulfillment_assignments')->where('order_id', $conversation->order_id)->where('user_id', $user->id)->whereNull('ended_at')->exists());
        }
        if (! in_array($scope['role'], self::SALES_ROLES, true)) {
            return false;
        }

        // Owners/managers supervise; a transferred handler loses access, even when their role remains sales-capable.
        return in_array($scope['role'], ['OWNER', 'STORE_MANAGER'], true)
            || ((int) $conversation->handler_user_id === (int) $user->id && DB::table('conversation_participants')
                ->where('conversation_id', $conversation->id)->where('user_id', $user->id)->where('participant_role', $scope['role'])->whereNull('revoked_at')->exists());
    }

    public function require(User $user, string $id, bool $lock = false): object
    {
        $query = DB::table('conversations')->where('id', $id);
        $conversation = ($lock ? $query->lockForUpdate() : $query)->first();
        if ($conversation === null || ! $this->allows($user, $conversation)) {
            throw new AuthenticationException('CONVERSATION_NOT_FOUND', 'This conversation is unavailable or your access changed.', 404);
        }

        return $conversation;
    }

    public function role(User $user): string
    {
        return $this->accounts->resolve($user)['role'];
    }

    public function requireSales(User $user, object $conversation, bool $publish = false): string
    {
        $role = $this->role($user);
        if ($conversation->purpose !== 'SALES' || ! in_array($role, self::SALES_ROLES, true) || ($publish && $role === 'CUSTOMER_SERVICE')) {
            throw new AuthenticationException('PERMISSION_DENIED', $publish ? 'Your role may prepare drafts but cannot publish commercial terms.' : 'This action requires sales conversation authority.', 403);
        }

        return $role;
    }

    /** Per-viewer channel epochs prevent an old socket receiving even invalidations after a transfer/role change. */
    public function channel(User $user, object $conversation): string
    {
        $member = DB::table('vendor_memberships')->where('user_id', $user->id)->where('vendor_organization_id', $conversation->vendor_organization_id)->first();
        $assignment = $conversation->purpose === 'FULFILLMENT'
            ? DB::table('order_fulfillment_assignments')->where('order_id', $conversation->order_id)->whereNull('ended_at')->value('id')
            : DB::table('conversation_assignments')->where('conversation_id', $conversation->id)->whereNull('ended_at')->value('id');
        $epoch = hash_hmac('sha256', implode('|', [$user->id, $user->account_status, $user->updated_at, $member?->role, $member?->status, $member?->updated_at, $assignment]), (string) config('app.key'));

        return 'conversation.'.$conversation->purpose.'.'.$conversation->id.'.'.$user->id.'.'.$epoch;
    }
}
