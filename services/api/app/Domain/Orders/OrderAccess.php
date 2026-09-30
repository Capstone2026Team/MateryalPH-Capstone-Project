<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Deny-by-default order authorization. A Buyer reaches only orders of their own profile; a Vendor user reaches
 * only orders of their current organization, re-resolved from the database on every request. A foreign order
 * is reported as not found. Commercial authority follows the fixed-role matrix: Owner, Manager, Store Staff and
 * Customer Service confirm an unchanged order or decline; only Owner, Manager and Store Staff publish a revision
 * or NRPC; only Owner and Manager confirm the delivery arrangement. Hidden controls are never the guard.
 */
final class OrderAccess
{
    public const VIEW = 'portal.orders';

    public const CONFIRM = 'orders.confirm';

    public const REVISE = 'orders.revise';

    public const SET_NRPC = 'orders.set_nrpc';

    public const CONFIRM_DELIVERY = 'vehicles.manage';

    public const VIEW_INVENTORY = 'inventory.view';

    public function __construct(private readonly AccountAccess $access, private readonly BuyerProfiles $profiles) {}

    public function buyerProfileId(Request $request): string
    {
        return $this->profiles->idFor($request);
    }

    /** Loads (and optionally locks) an order of the authenticated Buyer. */
    public function buyerOrder(Request $request, string $orderId, bool $lock = false): object
    {
        $buyerId = $this->profiles->idFor($request);
        $query = DB::table('orders')->where('id', Str::isUuid($orderId) ? $orderId : '00000000-0000-0000-0000-000000000000')->where('buyer_profile_id', $buyerId);
        $order = ($lock ? $query->lockForUpdate() : $query)->first();
        if ($order === null) {
            throw new AuthenticationException('ORDER_NOT_FOUND', 'This order is unavailable.', 404);
        }

        return $order;
    }

    /** @return array{organization_id: string, role: string, permissions: list<string>} */
    public function vendorScope(Request $request): array
    {
        $scope = $request->attributes->get('account_scope');
        if (! is_array($scope) || ! is_string($scope['organization_id'] ?? null) || $request->user() === null) {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot access Vendor orders.', 403);
        }
        $current = $this->access->resolve($request->user());
        if ($current['organization_id'] !== $scope['organization_id'] || ! in_array(self::VIEW, $current['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Orders are not available to your role.', 403);
        }

        return ['organization_id' => (string) $current['organization_id'], 'role' => $current['role'], 'permissions' => $current['permissions']];
    }

    /**
     * @param  array{organization_id: string, role: string, permissions: list<string>}  $scope
     */
    public function vendorOrder(array $scope, string $orderId, bool $lock = false): object
    {
        $query = DB::table('orders')->where('id', Str::isUuid($orderId) ? $orderId : '00000000-0000-0000-0000-000000000000')->where('vendor_organization_id', $scope['organization_id']);
        $order = ($lock ? $query->lockForUpdate() : $query)->first();
        if ($order === null || ! self::visibleToRole($scope['role'], (string) $order->order_state)) {
            throw new AuthenticationException('ORDER_NOT_FOUND', 'This order is unavailable.', 404);
        }

        return $order;
    }

    /** Fulfillment Staff act only after confirmation and payment conditions are satisfied. */
    public static function visibleToRole(string $role, string $orderState): bool
    {
        return $role !== 'FULFILLMENT' || ! in_array($orderState, [...OrderStates::PENDING_ACCEPTANCE, OrderStates::AWAITING_PAYMENT, OrderStates::DECLINED], true);
    }

    /** @param array{permissions: list<string>} $scope */
    public static function allows(array $scope, string $permission): bool
    {
        return in_array($permission, $scope['permissions'], true);
    }

    /** @param array{permissions: list<string>} $scope */
    public function require(array $scope, string $permission, string $message): void
    {
        if (! self::allows($scope, $permission)) {
            throw new AuthenticationException('PERMISSION_DENIED', $message, 403);
        }
    }
}
