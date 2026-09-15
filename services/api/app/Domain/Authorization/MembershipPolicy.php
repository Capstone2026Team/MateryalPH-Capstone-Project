<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Models\User;
use App\Models\VendorMembership;

final class MembershipPolicy
{
    public function __construct(private readonly AccountAccess $access) {}

    public function manage(User $actor, VendorMembership $target): bool
    {
        $scope = $this->access->resolve($actor);
        if ($actor->account_type !== 'VENDOR' || $scope['organization_id'] !== $target->vendor_organization_id
            || (string) $actor->getKey() === (string) $target->user_id || $target->role === 'OWNER') {
            return false;
        }

        return $scope['role'] === 'OWNER' || ($scope['role'] === 'STORE_MANAGER' && $scope['can_manage_staff'] && in_array($target->role, ['STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'], true));
    }

    public function delegate(User $actor, VendorMembership $target): bool
    {
        return $this->manage($actor, $target) && $this->access->resolve($actor)['role'] === 'OWNER' && $target->role === 'STORE_MANAGER';
    }
}
