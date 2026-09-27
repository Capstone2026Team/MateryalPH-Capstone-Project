<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Deny-by-default Vendor catalog authorization. Access is the intersection of the
 * active identity, membership, fixed role and the organization's current state.
 */
final class CatalogAccess
{
    public const VIEW = 'portal.products';

    public const MANAGE = 'catalog.manage';

    public const SUBMIT_COMPLIANCE = 'compliance.submit';

    public function __construct(private readonly AccountAccess $access) {}

    /**
     * Resolves current authority from the database for every request so a revoked
     * role or membership cannot act on a cached scope.
     */
    public function organizationFor(Request $request, string $permission): string
    {
        $scope = $request->attributes->get('account_scope');
        if (! is_array($scope) || ! is_string($scope['organization_id'] ?? null)) {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot access the Vendor catalog.', 403);
        }
        if (! in_array($permission, $this->access->resolve($request->user())['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This catalog action is not available to your role.', 403);
        }

        return $scope['organization_id'];
    }

    /** Locks the organization and requires Store Activation for marketplace catalog changes. */
    public function lockActiveStore(string $organizationId): object
    {
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
        if ($organization === null || $organization->account_status !== 'ACTIVE') {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This Vendor organization is unavailable.', 403);
        }
        if ($organization->store_activation_status !== 'ACTIVE') {
            throw new AuthenticationException('STORE_NOT_ACTIVE', 'Complete Store Activation before managing marketplace listings. Existing records stay visible.', 409, ['store_activation_status' => $organization->store_activation_status]);
        }

        return $organization;
    }

    public function requireIdempotencyKey(Request $request): string
    {
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || ! Str::isUuid($key)) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'A unique request identifier is required.', 422);
        }

        return $key;
    }

    /** Returns true when this exact request was already applied; a changed body under the same key is a conflict. */
    public function replayed(Request $request, string $endpoint, string $key, string $scopeId): bool
    {
        $record = DB::table('idempotency_records')->where('actor_user_id', $request->user()->getKey())->where('endpoint', $endpoint)->where('idempotency_key', $key)->first();
        if ($record === null) {
            return false;
        }
        if (! hash_equals((string) $record->request_hash, $this->hash($request, $endpoint, $scopeId)) || ($record->expires_at !== null && now()->greaterThanOrEqualTo($record->expires_at))) {
            throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new request identifier for the changed or expired request.', 409);
        }

        return true;
    }

    public function claim(Request $request, string $endpoint, string $key, string $scopeId, int $status): void
    {
        DB::table('idempotency_records')->insert(['id' => (string) Str::uuid7(), 'actor_user_id' => $request->user()->getKey(), 'endpoint' => $endpoint, 'idempotency_key' => $key, 'request_hash' => $this->hash($request, $endpoint, $scopeId), 'response_status' => $status, 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now()]);
    }

    public function requireAdmin(Request $request, string $permission): void
    {
        $user = $request->user();
        if ($user === null || $user->account_type !== 'ADMIN' || ! in_array($permission, $this->access->resolve($user)['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This Admin action is not available to your role.', 403);
        }
    }

    private function hash(Request $request, string $endpoint, string $scopeId): string
    {
        $body = $request->isJson() ? $request->getContent() : json_encode($request->except(['file']), JSON_THROW_ON_ERROR);

        return hash_hmac('sha256', $endpoint.'|'.$scopeId.'|'.$body, (string) config('app.key'));
    }
}
