<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderActor;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Deny-by-default case authorization, re-resolved from the database on every request so a revoked role, membership
 * or Owner dispute flag takes effect at once for REST, files, exports and realtime alike.
 *
 *   Buyer             only cases of their own orders
 *   Owner / Manager   every case of their organization
 *   Store Staff, CS   every case of their organization while the Owner's staff dispute flag is enabled
 *   Fulfillment       only adds fulfillment evidence to a case of an order currently assigned to them
 *   Inventory         no case access
 *   Admin             disputes.view to investigate, disputes.decide to escalate, clarify, decide and review appeals
 *
 * A foreign or hidden case is reported as not found. Hidden controls are never the guard.
 */
final class DisputeAccess
{
    public const PORTAL = 'portal.disputes';

    public const RESPOND = 'disputes.respond';

    public const REFUND_OFFER = 'disputes.refund_offer';

    public const EXPORT = 'disputes.export';

    public const FULFILLMENT_EVIDENCE = 'disputes.fulfillment_evidence';

    public const ADMIN_VIEW = 'disputes.view';

    public const ADMIN_DECIDE = 'disputes.decide';

    public function __construct(private readonly AccountAccess $access, private readonly BuyerProfiles $profiles) {}

    public function buyerProfileId(Request $request): string
    {
        return $this->profiles->idFor($request);
    }

    public function buyerCase(Request $request, string $caseId, bool $lock = false): object
    {
        $query = DB::table('dispute_cases')->where('id', self::uuid($caseId))->where('buyer_profile_id', $this->profiles->idFor($request));
        $case = ($lock ? $query->lockForUpdate() : $query)->first();
        if ($case === null) {
            throw new AuthenticationException('DISPUTE_NOT_FOUND', 'This case is unavailable.', 404);
        }

        return $case;
    }

    /** @return array{organization_id: string, role: string, permissions: list<string>, user_id: int} */
    public function vendorScope(Request $request, bool $allowFulfillmentEvidence = false): array
    {
        $scope = $request->attributes->get('account_scope');
        $user = $request->user();
        if (! is_array($scope) || ! is_string($scope['organization_id'] ?? null) || ! $user instanceof User) {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot access Vendor disputes.', 403);
        }
        $current = $this->access->resolve($user);
        $allowed = in_array(self::PORTAL, $current['permissions'], true) || ($allowFulfillmentEvidence && in_array(self::FULFILLMENT_EVIDENCE, $current['permissions'], true));
        if ($current['organization_id'] !== $scope['organization_id'] || ! $allowed) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Disputes are not available to your role. The store Owner controls staff dispute access.', 403);
        }

        return ['organization_id' => (string) $current['organization_id'], 'role' => $current['role'], 'permissions' => $current['permissions'], 'user_id' => (int) $user->getKey()];
    }

    /** @param array{organization_id: string, role: string, permissions: list<string>, user_id: int} $scope */
    public function vendorCase(array $scope, string $caseId, bool $lock = false): object
    {
        $query = DB::table('dispute_cases')->where('id', self::uuid($caseId))->where('vendor_organization_id', $scope['organization_id']);
        $case = ($lock ? $query->lockForUpdate() : $query)->first();
        if ($case === null || ! self::vendorCanSee($scope, $case)) {
            throw new AuthenticationException('DISPUTE_NOT_FOUND', 'This case is unavailable.', 404);
        }

        return $case;
    }

    /** @param array{role: string, permissions: list<string>, user_id: int} $scope */
    public static function vendorCanSee(array $scope, object $case): bool
    {
        if (in_array(self::PORTAL, $scope['permissions'], true)) {
            return true;
        }

        return $scope['role'] === 'FULFILLMENT' && in_array(self::FULFILLMENT_EVIDENCE, $scope['permissions'], true) && OrderAccess::assignedTo((string) $case->order_id, $scope['user_id']);
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

    /** @return array{user_id: int, role: string, permissions: list<string>} */
    public function admin(Request $request, string $permission): array
    {
        $user = $request->user();
        if (! $user instanceof User || $user->account_type !== 'ADMIN') {
            throw new AuthenticationException('PERMISSION_DENIED', 'This Admin action is not available to your role.', 403);
        }
        $current = $this->access->resolve($user);
        if (! in_array($permission, $current['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This Admin action is not available to your role.', 403);
        }

        return ['user_id' => (int) $user->getKey(), 'role' => $current['role'], 'permissions' => $current['permissions']];
    }

    /** Whether a user currently holds case access for this organization; used by exports, files, notices and realtime. */
    public function userCanAccessCase(User $user, object $case): bool
    {
        try {
            $current = $this->access->resolve($user);
        } catch (AuthenticationException) {
            return false;
        }
        if ($user->account_type === 'ADMIN') {
            return in_array(self::ADMIN_VIEW, $current['permissions'], true);
        }
        if ($user->account_type === 'BUYER') {
            return DB::table('buyer_profiles')->where('id', $case->buyer_profile_id)->value('user_id') === $user->getKey();
        }

        return $current['organization_id'] === $case->vendor_organization_id
            && self::vendorCanSee(['role' => $current['role'], 'permissions' => $current['permissions'], 'user_id' => (int) $user->getKey()], $case);
    }

    public static function buyerActor(Request $request): OrderActor
    {
        return OrderActor::buyer($request);
    }

    /** @param array{role: string} $scope */
    public static function vendorActor(Request $request, array $scope): OrderActor
    {
        return OrderActor::vendor($request, $scope['role']);
    }

    /** @param array{user_id: int, role: string} $admin */
    public static function adminActor(Request $request, array $admin): OrderActor
    {
        $correlation = $request->attributes->get('correlation_id');

        // Order history records an Admin-decided change as a SYSTEM source attributed to the actual Admin user and role.
        return new OrderActor($admin['user_id'], $admin['role'], 'SYSTEM', is_string($correlation) && $correlation !== '' ? $correlation : (string) Str::uuid7());
    }

    public static function uuid(string $value): string
    {
        return Str::isUuid($value) ? $value : '00000000-0000-0000-0000-000000000000';
    }
}
