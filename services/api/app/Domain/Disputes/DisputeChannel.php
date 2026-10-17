<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Models\User;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\DB;

/**
 * One private, account-scoped dispute channel per user. Its name embeds an epoch derived from the user's current
 * scope and permissions, so a role change or the Owner switching staff dispute handling off changes the name: the
 * old subscription stops receiving invalidations and cannot be authorized again. Only "case changed" signals with
 * a case id travel over the socket; every fetch re-authorizes through REST.
 */
final class DisputeChannel
{
    public function name(User $user): ?string
    {
        $user->refresh();
        try {
            $scope = app(AccountAccess::class)->resolve($user);
        } catch (AuthenticationException) {
            return null;
        }
        $allowed = match ($user->account_type) {
            'BUYER' => true,
            'VENDOR' => in_array(DisputeAccess::PORTAL, $scope['permissions'], true) || in_array(DisputeAccess::FULFILLMENT_EVIDENCE, $scope['permissions'], true),
            'ADMIN' => in_array(DisputeAccess::ADMIN_VIEW, $scope['permissions'], true),
            default => false,
        };
        if (! $allowed) {
            return null;
        }
        $epoch = hash_hmac('sha256', implode('|', ['disputes', $user->id, $user->account_status, $user->updated_at, json_encode($scope)]), (string) config('app.key'));

        return 'disputes-'.strtolower((string) $user->account_type).'.'.$epoch;
    }

    public function join(User $user, string $channel): bool
    {
        $name = $this->name($user);

        return $name !== null && hash_equals('private-'.$name, $channel);
    }

    /** Signals every user who may currently see the case; no case content leaves the API. */
    public function deliver(string $caseId): void
    {
        if (config('broadcasting.default') !== 'reverb') {
            return; // REST refresh remains the source of truth when realtime is not configured.
        }
        $case = DB::table('dispute_cases')->where('id', $caseId)->first();
        if ($case === null) {
            return;
        }
        $ids = DB::table('vendor_memberships')->where('vendor_organization_id', $case->vendor_organization_id)->where('status', 'ACTIVE')->pluck('user_id')->all();
        $ids[] = DB::table('buyer_profiles')->where('id', $case->buyer_profile_id)->value('user_id');
        if ($case->assigned_admin_user_id !== null) {
            $ids[] = $case->assigned_admin_user_id;
        }
        $access = app(DisputeAccess::class);
        foreach (User::query()->whereIn('id', array_filter($ids))->cursor() as $user) {
            $name = $this->name($user);
            if ($name !== null && $access->userCanAccessCase($user, $case)) {
                Broadcast::connection('reverb')->broadcast(['private-'.$name], 'dispute.changed', ['case_id' => $caseId]);
            }
        }
    }
}
