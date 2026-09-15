<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class OnboardingAccess
{
    public function __construct(private readonly AccountAccess $access, private readonly RecentAuthentication $recent) {}

    public function vendor(Request $request, string $organization, string $permission = 'organization.legal', bool $sensitive = false): object
    {
        $scope = $this->access->resolve($request->user());
        if ($request->user()->account_type !== 'VENDOR' || $scope['organization_id'] !== $organization) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This organization is unavailable.', 404);
        }
        if (! in_array($permission, $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Your role cannot perform this action.', 403);
        }
        if ($sensitive) {
            $this->recent->require($request);
        }

        return DB::table('vendor_organizations')->where('id', $organization)->firstOrFail();
    }

    public function reviewer(Request $request, bool $tax = false): void
    {
        if ($request->user()->account_type !== 'ADMIN' || ! $this->access->allows($request->user(), $tax ? 'vendors.review_tax_evidence' : 'vendors.verify')) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Your role cannot review this evidence.', 403);
        }
    }

    public function version(object $row, int $version): void
    {
        if ((int) $row->lock_version !== $version) {
            throw new AuthenticationException('VERSION_CONFLICT', 'This record changed. Reload it before saving.', 409);
        }
    }
}
