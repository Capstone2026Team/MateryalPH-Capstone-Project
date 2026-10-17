<?php

declare(strict_types=1);

namespace App\Domain\Operations;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Models\User;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Deny-by-default Admin authorization for the Phase 16 operational modules. The role and permissions are resolved
 * from the database on every call (never from the request or a cached client claim); a hidden button is never the
 * guard. The actor carries the role held at the time of the action for attribution.
 */
final class AdminAccess
{
    public function __construct(private readonly AccountAccess $access) {}

    /** @return array{user_id: int, role: string, permissions: list<string>} */
    public function require(Request $request, string ...$permissions): array
    {
        $actor = $this->actor($request);
        foreach ($permissions as $permission) {
            if (! in_array($permission, $actor['permissions'], true)) {
                throw new AuthenticationException('PERMISSION_DENIED', 'This action is not available to your Admin role.', 403);
            }
        }

        return $actor;
    }

    /** @return array{user_id: int, role: string, permissions: list<string>} */
    public function actor(Request $request): array
    {
        $user = $request->user();
        if (! $user instanceof User || $user->account_type !== 'ADMIN') {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot use the Admin Portal.', 403);
        }
        $scope = $this->access->resolve($user);

        return ['user_id' => (int) $user->getKey(), 'role' => $scope['role'], 'permissions' => $scope['permissions']];
    }

    public function allows(Request $request, string $permission): bool
    {
        try {
            return in_array($permission, $this->actor($request)['permissions'], true);
        } catch (AuthenticationException) {
            return false;
        }
    }

    /**
     * Runs a record-creating Admin command once per Idempotency-Key. The key is claimed inside the same transaction as
     * the command, so a concurrent duplicate waits and then replays; a changed body under the same key is a conflict.
     *
     * @param  callable(): array<string, mixed>  $command
     * @return array{replayed: bool, result: array<string, mixed>}
     */
    public function idempotent(Request $request, string $endpoint, callable $command): array
    {
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || ! Str::isUuid($key)) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'A unique request identifier is required.', 422);
        }
        $actor = (int) $request->user()?->getKey();
        $hash = hash('sha256', $endpoint.'|'.$request->getContent());

        return DB::transaction(function () use ($actor, $endpoint, $key, $hash, $command): array {
            $claimed = DB::table('idempotency_records')->insertOrIgnore(['id' => (string) Str::uuid7(), 'actor_user_id' => $actor, 'endpoint' => $endpoint, 'idempotency_key' => $key,
                'request_hash' => $hash, 'expires_at' => now()->addDay(), 'created_at' => now(), 'updated_at' => now()]);
            if ($claimed === 0) {
                $record = DB::table('idempotency_records')->where('actor_user_id', $actor)->where('endpoint', $endpoint)->where('idempotency_key', $key)->lockForUpdate()->first();
                if ($record === null || ! hash_equals((string) $record->request_hash, $hash) || $record->response_body === null) {
                    throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new request identifier for a changed request.', 409);
                }

                return ['replayed' => true, 'result' => json_decode((string) $record->response_body, true) ?: []];
            }
            $result = $command();
            DB::table('idempotency_records')->where('actor_user_id', $actor)->where('endpoint', $endpoint)->where('idempotency_key', $key)
                ->update(['response_status' => 200, 'response_body' => json_encode($result, JSON_THROW_ON_ERROR), 'updated_at' => now()]);

            return ['replayed' => false, 'result' => $result];
        });
    }

    public static function correlation(Request $request): string
    {
        $id = $request->attributes->get('correlation_id');

        return is_string($id) && $id !== '' ? $id : (string) Str::uuid7();
    }

    /** A required, trimmed reason; decisions without a meaningful reason are refused. */
    public static function reason(mixed $reason, int $minimum = 10): string
    {
        $text = trim((string) $reason);
        if (mb_strlen($text) < $minimum) {
            throw new AuthenticationException('REASON_REQUIRED', sprintf('Enter a reason of at least %d characters.', $minimum), 422, ['fields' => ['reason' => ['A reason of at least '.$minimum.' characters is required.']]]);
        }

        return mb_substr($text, 0, 2000);
    }
}
