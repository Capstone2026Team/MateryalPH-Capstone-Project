<?php

declare(strict_types=1);

namespace App\Models;

/**
 * @property string $vendor_organization_id
 * @property int $user_id
 * @property string $role
 * @property string $status
 * @property bool $can_manage_staff
 */
final class VendorMembership extends UuidModel
{
    protected function casts(): array
    {
        return ['can_manage_staff' => 'boolean'];
    }
}
