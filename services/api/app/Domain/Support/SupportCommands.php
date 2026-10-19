<?php

declare(strict_types=1);

namespace App\Domain\Support;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Claims and results commit with the command, including anonymous submissions. */
final class SupportCommands
{
    /** @param array<string, mixed> $input
     * @param  callable(): array<string, mixed>  $command
     * @return array<string, mixed>
     */
    public function run(Request $request, string $scope, array $input, callable $command): array
    {
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || ! Str::isUuid($key)) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'A unique request identifier is required.', 422);
        }
        $scopeHash = SupportAccess::hash($scope);
        $hash = hash('sha256', json_encode($input, JSON_THROW_ON_ERROR));

        return DB::transaction(function () use ($scopeHash, $key, $hash, $command): array {
            $inserted = DB::table('support_commands')->insertOrIgnore(['id' => (string) Str::uuid7(), 'scope_hash' => $scopeHash,
                'idempotency_key' => $key, 'request_hash' => $hash, 'created_at' => now()]);
            $record = DB::table('support_commands')->where('scope_hash', $scopeHash)->where('idempotency_key', $key)->lockForUpdate()->first();
            if ($record === null || ! hash_equals((string) $record->request_hash, $hash)) {
                throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new request identifier for a changed request.', 409);
            }
            if ($inserted === 0 && $record->result !== null) {
                return json_decode((string) $record->result, true, flags: JSON_THROW_ON_ERROR);
            }
            $result = $command();
            DB::table('support_commands')->where('id', $record->id)->update(['result' => json_encode($result, JSON_THROW_ON_ERROR)]);

            return $result;
        });
    }
}
