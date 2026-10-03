<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\InventoryAccess;
use App\Domain\Messaging\BuyerInboxChannel;
use App\Models\User;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\DB;

/** Post-commit invalidation on the existing account-private channel; fleet data always requires REST authorization. */
final class FleetBroadcast
{
    public function deliver(string $organizationId): void
    {
        if (config('broadcasting.default') !== 'reverb') {
            return;
        }
        $ids = DB::table('vendor_memberships')->where('vendor_organization_id', $organizationId)->where('status', 'ACTIVE')->pluck('user_id');
        foreach (User::query()->where('account_type', 'VENDOR')->whereIn('id', $ids)->cursor() as $user) {
            try {
                $scope = app(AccountAccess::class)->resolve($user);
            } catch (AuthenticationException) {
                continue;
            }
            if ($scope['organization_id'] !== $organizationId || ! in_array(InventoryAccess::VEHICLES_MANAGE, $scope['permissions'], true)) {
                continue;
            }
            $channel = app(BuyerInboxChannel::class)->name($user);
            if ($channel !== null) {
                Broadcast::connection('reverb')->broadcast(['private-'.$channel], 'fleet.changed', []);
            }
        }
    }
}
