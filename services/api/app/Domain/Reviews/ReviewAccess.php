<?php

declare(strict_types=1);

namespace App\Domain\Reviews;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Deny-by-default review authorization. A Buyer reaches only orders of their own profile; a Vendor member reaches only
 * orders of their own organization and only with the fixed-role review grants, resolved from the database on every
 * request so a revoked role cannot act on a cached scope. Admin moderation needs reviews.moderate.
 */
final class ReviewAccess
{
    /** Owner, Store Manager, Store Staff and Customer Service read the store's received reviews. */
    public const VIEW = 'reviews.view';

    /** The same sales roles rate the Buyer of a completed order (CCS). */
    public const RATE_BUYER = 'reviews.rate_buyer';

    public const REPORT = 'reviews.report';

    public const MODERATE = 'reviews.moderate';

    public function __construct(private readonly AccountAccess $access) {}

    public function buyerProfileId(Request $request): string
    {
        $user = $request->user();
        $id = $user === null || $user->account_type !== 'BUYER' ? null : DB::table('buyer_profiles')->where('user_id', $user->getKey())->value('id');
        if ($id === null) {
            throw new AuthenticationException('BUYER_PROFILE_REQUIRED', 'Complete your Buyer account first.', 409);
        }

        return (string) $id;
    }

    /** @return array{organization_id: string, role: string, permissions: list<string>} */
    public function vendorScope(Request $request, string $permission): array
    {
        $user = $request->user();
        if ($user === null || $user->account_type !== 'VENDOR') {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot access store reviews.', 403);
        }
        $scope = $this->access->resolve($user);
        if (! is_string($scope['organization_id']) || ! in_array($permission, $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Reviews are not available to your role.', 403);
        }

        return ['organization_id' => $scope['organization_id'], 'role' => $scope['role'], 'permissions' => $scope['permissions']];
    }

    /** @return array{role: string, permissions: list<string>} */
    public function admin(Request $request, string $permission): array
    {
        $user = $request->user();
        if ($user === null || $user->account_type !== 'ADMIN') {
            throw new AuthenticationException('PERMISSION_DENIED', 'This Admin action is not available to your role.', 403);
        }
        $scope = $this->access->resolve($user);
        if (! in_array($permission, $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This Admin action is not available to your role.', 403);
        }

        return ['role' => $scope['role'], 'permissions' => $scope['permissions']];
    }

    public function buyerOrder(Request $request, string $orderId, bool $lock = false): object
    {
        $query = DB::table('orders')->where('id', self::uuid($orderId))->where('buyer_profile_id', $this->buyerProfileId($request));
        $order = ($lock ? $query->lockForUpdate() : $query)->first();
        if ($order === null) {
            throw new AuthenticationException('ORDER_NOT_FOUND', 'This order is unavailable.', 404);
        }

        return $order;
    }

    public function vendorOrder(string $organizationId, string $orderId, bool $lock = false): object
    {
        $query = DB::table('orders')->where('id', self::uuid($orderId))->where('vendor_organization_id', $organizationId);
        $order = ($lock ? $query->lockForUpdate() : $query)->first();
        if ($order === null) {
            throw new AuthenticationException('ORDER_NOT_FOUND', 'This order is unavailable.', 404);
        }

        return $order;
    }

    /** A non-UUID identifier can never match; it is treated as not found rather than a database error. */
    public static function uuid(string $id): string
    {
        return Str::isUuid($id) ? $id : '00000000-0000-0000-0000-000000000000';
    }
}
