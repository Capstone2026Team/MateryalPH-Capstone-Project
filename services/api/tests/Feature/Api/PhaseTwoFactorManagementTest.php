<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\TokenSessionService;
use App\Domain\Identity\TotpService;
use App\Models\AuthSession;
use App\Models\User;
use App\Models\VendorMembership;
use App\Models\VendorOrganization;
use Database\Seeders\SystemFoundationSeeder;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\DB;
use Laravel\Passport\AccessToken;
use Tests\TestCase;

final class PhaseTwoFactorManagementTest extends TestCase
{
    use RefreshDatabase;

    public function test_factor_replacement_preserves_old_factor_until_confirmation_and_revokes_all_sessions(): void
    {
        [$user, $session, $oldCodes] = $this->owner();
        $original = DB::table('totp_factors')->where('user_id', $user->getKey())->value('encrypted_secret');
        $this->postJson('/api/v1/vendors/account/factor')->assertForbidden();
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $response = $this->postJson('/api/v1/vendors/account/factor')->assertOk();
        self::assertSame($original, DB::table('totp_factors')->where('user_id', $user->getKey())->value('encrypted_secret'));
        $secret = $response->json('data.secret');
        $id = $response->json('data.id');
        $code = $this->totpCode($secret, intdiv(time(), 30));
        $wrongCode = str_pad((string) (((int) $code + 1) % 1000000), 6, '0', STR_PAD_LEFT);
        $this->postJson('/api/v1/vendors/account/factor/confirm', ['id' => $id, 'code' => $wrongCode])->assertUnprocessable();
        self::assertSame($original, DB::table('totp_factors')->where('user_id', $user->getKey())->value('encrypted_secret'));
        $this->postJson('/api/v1/vendors/account/factor/confirm', ['id' => $id, 'code' => $code])->assertOk()->assertJsonCount(8, 'data.recovery_codes')->assertJsonPath('data.sign_in_required', true);
        self::assertNotNull($session->refresh()->revoked_at);
        self::assertNull(app(TotpService::class)->consumeRecoveryCode($user, $oldCodes[0]));
        $this->getJson('/api/v1/vendors/account/profile')->assertUnauthorized();
        $this->assertDatabaseHas('audit_logs', ['action' => 'FACTOR_REPLACED', 'actor_user_id' => $user->getKey()]);
    }

    public function test_recovery_replacement_invalidates_previous_codes_and_consumes_recent_proof(): void
    {
        [$user, $session, $oldCodes] = $this->owner();
        $session->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $this->postJson('/api/v1/vendors/account/recovery-codes')->assertOk()->assertJsonCount(8, 'data.recovery_codes');
        self::assertNull(app(TotpService::class)->consumeRecoveryCode($user, $oldCodes[0]));
        self::assertNull($session->refresh()->reauthenticated_at);
        $this->postJson('/api/v1/vendors/account/recovery-codes')->assertForbidden();
        $this->assertDatabaseHas('audit_logs', ['action' => 'RECOVERY_CODES_REPLACED', 'actor_user_id' => $user->getKey()]);
    }

    public function test_factor_request_cannot_be_confirmed_by_another_session(): void
    {
        [$user, $first] = $this->owner();
        $first->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $data = $this->postJson('/api/v1/vendors/account/factor')->assertOk()->json('data');
        $second = $this->signIn($user);
        $second->update(['reauthenticated_at' => now(), 'reauthentication_method' => 'PASSWORD_TOTP']);
        $this->postJson('/api/v1/vendors/account/factor/confirm', ['id' => $data['id'], 'code' => $this->totpCode($data['secret'], intdiv(time(), 30))])->assertNotFound();
        self::assertNull($first->refresh()->revoked_at);
        self::assertNull($second->refresh()->revoked_at);
    }

    /** @return array{User, AuthSession, list<string>} */
    private function owner(): array
    {
        $this->seed(SystemFoundationSeeder::class);
        $org = VendorOrganization::query()->create(['legal_name' => 'Factor test organization', 'store_name' => 'Factor test store']);
        $user = User::factory()->create(['account_type' => 'VENDOR', 'account_status' => 'ACTIVE']);
        VendorMembership::query()->create(['user_id' => $user->getKey(), 'vendor_organization_id' => $org->getKey(), 'role' => 'OWNER', 'status' => 'ACTIVE']);
        $totp = app(TotpService::class);
        $enrollment = $totp->startEnrollment($user);
        $codes = $totp->confirm($user, $this->totpCode($enrollment['secret'], intdiv(time(), 30)));

        return [$user, $this->signIn($user), $codes];
    }

    private function signIn(User $user): AuthSession
    {
        $tokens = app(TokenSessionService::class)->start($user, 'WEB', null, null, null);
        $session = AuthSession::query()->findOrFail($tokens->sessionId);
        $user->withAccessToken(new AccessToken(['oauth_access_token_id' => $session->oauth_access_token_id, 'oauth_scopes' => ['VENDOR']]));
        $this->actingAs($user, 'api')->withCredentials()->withUnencryptedCookie('mp_csrf', 'test-csrf')->withHeader('X-CSRF-Token', 'test-csrf');

        return $session;
    }

    private function totpCode(string $secret, int $counter): string
    {
        $alphabet = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ234567';
        $buffer = 0;
        $bits = 0;
        $decoded = '';
        foreach (str_split($secret) as $character) {
            $position = strpos($alphabet, $character);
            self::assertNotFalse($position);
            $buffer = ($buffer << 5) | $position;
            $bits += 5;
            if ($bits >= 8) {
                $bits -= 8;
                $decoded .= chr(($buffer >> $bits) & 0xFF);
            }
        }

        $hash = hash_hmac('sha1', pack('N2', 0, $counter), $decoded, true);
        $offset = ord($hash[19]) & 0x0F;
        $value = ((ord($hash[$offset]) & 0x7F) << 24)
            | ((ord($hash[$offset + 1]) & 0xFF) << 16)
            | ((ord($hash[$offset + 2]) & 0xFF) << 8)
            | (ord($hash[$offset + 3]) & 0xFF);

        return str_pad((string) ($value % 1_000_000), 6, '0', STR_PAD_LEFT);
    }
}
