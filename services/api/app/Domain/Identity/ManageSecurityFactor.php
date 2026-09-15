<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Domain\Authorization\RecentAuthentication;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class ManageSecurityFactor
{
    public function __construct(private readonly RecentAuthentication $recent, private readonly TotpService $totp, private readonly ManageAccount $accounts, private readonly AuditRecorder $audit) {}

    /** @return array<string, mixed> */
    public function start(Request $request): array
    {
        $this->recent->require($request);
        if (! $this->totp->hasConfirmedFactor($request->user())) {
            throw new AuthenticationException('MFA_NOT_ENROLLED', 'An enrolled authenticator is required.', 409);
        }

        return DB::transaction(function () use ($request): array {
            DB::table('users')->where('id', $request->user()->getKey())->lockForUpdate()->first();
            $this->recent->require($request);
            $payload = $this->totp->replacementPayload($request->user());
            $id = (string) Str::uuid7();
            DB::table('account_factor_replacements')->insert([
                'id' => $id, 'user_id' => $request->user()->getKey(), 'auth_session_id' => $this->recent->session($request)->getKey(),
                'encrypted_secret' => Crypt::encryptString($payload['secret']), 'expires_at' => now()->addMinutes(5), 'created_at' => now(), 'updated_at' => now(),
            ]);
            $this->audit->account($request, 'FACTOR_REPLACEMENT_STARTED', 'USER', $request->user()->public_id);

            return ['id' => $id, 'expires_at' => now()->addMinutes(5)->toIso8601String(), ...$payload];
        });
    }

    /** @return list<string> */
    public function confirm(Request $request, string $id, string $code): array
    {
        $this->recent->require($request);

        return DB::transaction(function () use ($request, $id, $code): array {
            DB::table('users')->where('id', $request->user()->getKey())->lockForUpdate()->first();
            $this->recent->require($request);
            $replacement = DB::table('account_factor_replacements')->where('id', $id)->where('user_id', $request->user()->getKey())
                ->where('auth_session_id', $this->recent->session($request)->getKey())->whereNull('completed_at')->where('expires_at', '>', now())->lockForUpdate()->first();
            if ($replacement === null) {
                throw new AuthenticationException('FACTOR_REPLACEMENT_INVALID', 'Start authenticator replacement again.', 404);
            }
            if (! $this->totp->confirmReplacement($request->user(), $replacement->encrypted_secret, $code)) {
                throw new AuthenticationException('MFA_CODE_INVALID', 'The verification code is incorrect.', 422);
            }
            DB::table('account_factor_replacements')->where('user_id', $request->user()->getKey())->whereNull('completed_at')->update(['completed_at' => now(), 'updated_at' => now()]);
            $this->recent->require($request);
            $codes = $this->totp->replaceRecoveryCodes($request->user());
            $this->accounts->revokeSessions($request, 'ALL');
            $this->audit->account($request, 'FACTOR_REPLACED', 'USER', $request->user()->public_id);
            $this->accounts->notice($request->user()->email, $request->user()->public_id, 'Your MateryalPH authenticator was replaced. All sessions were signed out.');

            return $codes;
        });
    }

    /** @return list<string> */
    public function recoveryCodes(Request $request): array
    {
        $this->recent->require($request);
        if (! $this->totp->hasConfirmedFactor($request->user())) {
            throw new AuthenticationException('MFA_NOT_ENROLLED', 'An enrolled authenticator is required.', 409);
        }

        return DB::transaction(function () use ($request): array {
            DB::table('users')->where('id', $request->user()->getKey())->lockForUpdate()->first();
            $this->recent->require($request);
            $codes = $this->totp->replaceRecoveryCodes($request->user());
            $this->recent->session($request)->update(['reauthenticated_at' => null, 'reauthentication_method' => null]);
            $this->audit->account($request, 'RECOVERY_CODES_REPLACED', 'USER', $request->user()->public_id);
            $this->accounts->notice($request->user()->email, $request->user()->public_id, 'Your MateryalPH recovery codes were replaced. Previous codes are no longer valid.');

            return $codes;
        });
    }
}
