<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Messaging\BuyerInboxChannel;
use App\Domain\Operations\OutboxPublisher;
use App\Models\User;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\DB;

/** Invalidate authorized team views after commit; all activity details remain behind REST authorization. */
final class VendorTeamActivityBroadcast
{
    public const EVENT = 'VENDOR_TEAM_ACTIVITY_CHANGED';

    public function publish(?string $organizationId, ?string $actorRole): void
    {
        if ($organizationId === null || $actorRole === null) {
            return;
        }
        app(OutboxPublisher::class)->publish(self::EVENT, 'VENDOR_ORGANIZATION', $organizationId,
            ['vendor_organization_id' => $organizationId, 'actor_role' => $actorRole]);
    }

    public function deliver(string $organizationId, string $actorRole): void
    {
        if (config('broadcasting.default') !== 'reverb') {
            return;
        }
        $ids = DB::table('vendor_memberships')->where('vendor_organization_id', $organizationId)->where('status', 'ACTIVE')->whereNull('deleted_at')->pluck('user_id');
        foreach (User::query()->where('account_type', 'VENDOR')->whereIn('id', $ids)->cursor() as $user) {
            try {
                $scope = app(AccountAccess::class)->resolve($user);
            } catch (AuthenticationException) {
                continue;
            }
            if ($scope['organization_id'] !== $organizationId || ! in_array('staff.manage', $scope['permissions'], true)
                || ($scope['role'] !== 'OWNER' && ! in_array($actorRole, ['STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'], true))) {
                continue;
            }
            $channel = app(BuyerInboxChannel::class)->name($user);
            if ($channel !== null) {
                Broadcast::connection('reverb')->broadcast(['private-'.$channel], 'team.activity.changed', []);
            }
        }
    }
}
