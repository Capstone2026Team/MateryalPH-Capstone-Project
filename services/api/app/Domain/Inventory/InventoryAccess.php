<?php

declare(strict_types=1);

namespace App\Domain\Inventory;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;

/**
 * Deny-by-default Vendor inventory, auto-accept and fleet authorization. Authority is resolved from the
 * database on every request so a revoked membership or changed role cannot act on a cached scope.
 */
final class InventoryAccess
{
    public const VIEW = 'inventory.view';

    public const MANAGE = 'inventory.manage';

    public const PRICE = 'catalog.manage';

    public const SETTINGS = 'inventory.settings';

    public const AUTO_ACCEPT_CONFIGURE = 'auto_accept.configure';

    public const AUTO_ACCEPT_ALLOTMENT = 'auto_accept.manage_allotment';

    public const AUTO_ACCEPT_VIEW = 'auto_accept.view_outcomes';

    public const VEHICLES_MANAGE = 'vehicles.manage';

    public const VEHICLES_ASSIGNED = 'vehicles.view_assigned';

    public function __construct(private readonly AccountAccess $access) {}

    /** @return array{organization_id: string, role: string, permissions: list<string>} */
    public function scope(Request $request): array
    {
        $scope = $request->attributes->get('account_scope');
        if (! is_array($scope) || ! is_string($scope['organization_id'] ?? null) || $request->user() === null) {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot access Vendor inventory.', 403);
        }
        $current = $this->access->resolve($request->user());
        if ($current['organization_id'] !== $scope['organization_id']) {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot access Vendor inventory.', 403);
        }

        return ['organization_id' => (string) $current['organization_id'], 'role' => $current['role'], 'permissions' => $current['permissions']];
    }

    /**
     * Requires at least one of the given permissions and returns the organization.
     *
     * @param  list<string>  $permissions
     */
    public function organizationFor(Request $request, array $permissions): string
    {
        $scope = $this->scope($request);
        if (array_intersect($permissions, $scope['permissions']) === []) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This action is not available to your role.', 403);
        }

        return $scope['organization_id'];
    }

    public function allows(Request $request, string $permission): bool
    {
        return in_array($permission, $this->scope($request)['permissions'], true);
    }
}
