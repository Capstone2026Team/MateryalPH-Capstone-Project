<?php

declare(strict_types=1);

namespace App\Policies;

use App\Domain\Authorization\AccountAccess;
use App\Models\User;

final class VendorEvidencePolicy
{
    public function __construct(private readonly AccountAccess $access) {}

    public function view(User $user, string $organizationId): bool
    {
        $scope = $this->access->resolve($user);

        return match ($user->account_type) {
            'VENDOR' => $scope['organization_id'] === $organizationId && in_array('vendor.onboarding.private_documents', $scope['permissions'], true),
            'ADMIN' => in_array('vendor_verification.view_private_documents', $scope['permissions'], true),
            default => false,
        };
    }
}
