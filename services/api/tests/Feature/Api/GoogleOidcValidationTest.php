<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\GoogleOidcResult;
use App\Domain\Identity\GoogleOidcService;
use App\Models\ExternalIdentity;
use App\Models\User;
use Database\Seeders\SystemFoundationSeeder;
use Firebase\JWT\JWT;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Http;
use PHPUnit\Framework\Attributes\DataProvider;
use Tests\TestCase;

final class GoogleOidcValidationTest extends TestCase
{
    use RefreshDatabase;

    public function test_buyer_google_signup_carries_reviewed_terms_and_records_existing_acceptance_evidence(): void
    {
        $this->seed(SystemFoundationSeeder::class);
        $this->configureOidc();
        config()->set('app.buyer_redirect_uri', 'materyalph://auth/callback');
        $terms = collect($this->getJson('/api/v1/agreements/current')->json('data'))->firstWhere('code', 'TERMS_OF_SERVICE');
        $response = $this->postJson('/api/v1/mobile/auth/google/start', [
            'mode' => 'SIGN_UP', 'mobile_e164' => '+639171234567', 'buyer_type' => 'INDIVIDUAL',
            'terms_accepted' => true, 'privacy_accepted' => true, 'terms_version_id' => $terms['id'], 'terms_content_hash' => $terms['content_hash'],
        ])->assertOk();
        $url = (string) $response->json('data.authorization_url');
        $flow = $this->flowFromAuthorizationUrl($url);
        self::assertSame($terms['id'], $flow['terms_version_id']);
        self::assertSame($terms['content_hash'], $flow['terms_content_hash']);
        $this->assertDatabaseCount('agreement_acceptances', 0);
        parse_str((string) parse_url($url, PHP_URL_QUERY), $query);
        $this->fakeGoogleIdentity($flow['nonce'], 'google-signup@example.test');
        $result = app(GoogleOidcService::class)->complete($query['state'], 'authorization-code');
        $this->assertDatabaseHas('agreement_acceptances', ['user_id' => $result->user->getKey(), 'agreement_version_id' => $terms['id'], 'source' => 'GOOGLE_OIDC']);
    }

    public function test_terms_retired_during_google_signup_cannot_be_silently_replaced(): void
    {
        $this->seed(SystemFoundationSeeder::class);
        $this->configureOidc();
        config()->set('app.buyer_redirect_uri', 'materyalph://auth/callback');
        $terms = collect($this->getJson('/api/v1/agreements/current')->json('data'))->firstWhere('code', 'TERMS_OF_SERVICE');
        $service = app(GoogleOidcService::class);
        $url = $service->authorizationUrl('BUYER', 'MOBILE', true, true, 'SIGN_UP', '+639171234567', 'INDIVIDUAL', null, null, $terms['id'], $terms['content_hash']);
        $flow = $this->flowFromAuthorizationUrl($url);
        parse_str((string) parse_url($url, PHP_URL_QUERY), $query);
        $this->fakeGoogleIdentity($flow['nonce'], 'stale-google@example.test');
        DB::table('agreement_versions')->where('id', $terms['id'])->update(['retired_at' => now()]);
        try {
            $service->complete($query['state'], 'authorization-code');
            self::fail('A changed Terms version requires another review.');
        } catch (AuthenticationException $error) {
            self::assertSame('AGREEMENT_VERSION_CONFLICT', $error->errorCode);
        }
        $this->assertDatabaseMissing('users', ['email' => 'stale-google@example.test']);
        $this->assertDatabaseCount('agreement_acceptances', 0);
    }

    public function test_web_and_native_google_starts_store_route_owned_transport_context(): void
    {
        $this->configureOidc();
        config()->set('app.buyer_redirect_uri', 'materyalph://auth/callback');

        $mobileResponse = $this->postJson('/api/v1/mobile/auth/google/start', [
            'mode' => 'SIGN_IN',
        ])->assertOk();
        $mobileFlow = $this->flowFromAuthorizationUrl((string) $mobileResponse->json('data.authorization_url'));
        self::assertSame('BUYER', $mobileFlow['portal']);
        self::assertSame('MOBILE', $mobileFlow['client_kind']);

        $webResponse = $this->withCredentials()
            ->withUnencryptedCookie('mp_csrf', 'test-csrf-token')
            ->withHeader('X-CSRF-Token', 'test-csrf-token')
            ->postJson('/api/v1/auth/google/start', [
                'portal' => 'VENDOR',
                'mode' => 'SIGN_IN',
            ])->assertOk();
        $webFlow = $this->flowFromAuthorizationUrl((string) $webResponse->json('data.authorization_url'));
        self::assertSame('VENDOR', $webFlow['portal']);
        self::assertSame('WEB', $webFlow['client_kind']);
    }

    public function test_google_token_with_a_mismatched_audience_is_rejected(): void
    {
        $this->configureOidc();

        $service = app(GoogleOidcService::class);
        $authorizationUrl = $service->authorizationUrl('BUYER', 'WEB', false, false, 'SIGN_IN', null, null, null, null);
        parse_str((string) parse_url($authorizationUrl, PHP_URL_QUERY), $query);
        $state = (string) ($query['state'] ?? '');
        self::assertNotSame('', $state);
        /** @var array{nonce: string} $flow */
        $flow = Cache::get('oidc:'.hash('sha256', $state));

        $this->fakeGoogleIdentity($flow['nonce'], 'buyer@example.test', 'different-client-id');

        try {
            $service->complete($state, 'authorization-code');
            self::fail('An ID token issued to another OAuth client must be rejected.');
        } catch (AuthenticationException $exception) {
            self::assertSame('OIDC_TOKEN_INVALID', $exception->errorCode);
        }
    }

    public function test_cross_portal_google_identity_redirects_to_a_safe_vendor_error_without_creating_access(): void
    {
        $this->configureOidc();
        config()->set('app.vendor_frontend_url', 'https://vendor.example.test');
        User::factory()->create([
            'email' => 'single-identity@example.test',
            'account_type' => 'BUYER',
            'account_status' => 'ACTIVE',
            'email_verified_at' => now(),
        ]);

        $service = app(GoogleOidcService::class);
        $authorizationUrl = $service->authorizationUrl('VENDOR', 'WEB', false, false, 'SIGN_IN', null, null, null, null);
        parse_str((string) parse_url($authorizationUrl, PHP_URL_QUERY), $query);
        $state = (string) ($query['state'] ?? '');
        self::assertNotSame('', $state);
        /** @var array{nonce: string} $flow */
        $flow = Cache::get('oidc:'.hash('sha256', $state));
        $this->fakeGoogleIdentity($flow['nonce'], 'single-identity@example.test');

        $this->get('/api/v1/auth/google/callback?'.http_build_query([
            'state' => $state,
            'code' => 'authorization-code',
        ]))->assertRedirect('https://vendor.example.test/auth/callback?status=error&code=PORTAL_ACCESS_DENIED');

        $this->assertDatabaseCount('users', 1);
        $this->assertDatabaseCount('external_identities', 0);
        $this->assertDatabaseCount('auth_sessions', 0);
        $this->assertDatabaseCount('oauth_access_tokens', 0);
        $this->assertDatabaseHas('login_events', [
            'event_type' => 'GOOGLE_OIDC_CALLBACK_FAILED',
            'succeeded' => false,
        ]);
    }

    public function test_existing_vendor_email_is_verified_when_a_valid_google_identity_is_linked(): void
    {
        $this->configureOidc();
        $user = User::factory()->create([
            'email' => 'vendor-google@example.test',
            'account_type' => 'VENDOR',
            'account_status' => 'ACTIVE',
            'email_verified_at' => null,
        ]);

        $service = app(GoogleOidcService::class);
        $url = $service->authorizationUrl('VENDOR', 'WEB', false, false, 'SIGN_IN', null, null, null, null);
        $flow = $this->flowFromAuthorizationUrl($url);
        parse_str((string) parse_url($url, PHP_URL_QUERY), $query);
        $this->fakeGoogleIdentity($flow['nonce'], 'vendor-google@example.test');

        $result = $service->complete($query['state'], 'authorization-code');

        self::assertSame($user->id, $result->user->id);
        self::assertNotNull($user->fresh()->email_verified_at);
        $this->assertDatabaseHas('external_identities', [
            'user_id' => $user->id,
            'provider' => 'GOOGLE',
            'email_at_link' => 'vendor-google@example.test',
        ]);
    }

    public function test_non_allowlisted_google_callback_failure_uses_the_sanitized_api_error_path(): void
    {
        $this->configureOidc();
        config()->set('app.vendor_frontend_url', 'https://vendor.example.test');
        $service = app(GoogleOidcService::class);
        $authorizationUrl = $service->authorizationUrl('VENDOR', 'WEB', false, false, 'SIGN_IN', null, null, null, null);
        parse_str((string) parse_url($authorizationUrl, PHP_URL_QUERY), $query);
        $state = (string) ($query['state'] ?? '');
        Http::fake([
            'https://accounts.example.test/token' => Http::response([], 503),
        ]);

        $this->getJson('/api/v1/auth/google/callback?'.http_build_query([
            'state' => $state,
            'code' => 'authorization-code',
        ]))->assertUnauthorized()
            ->assertJsonPath('errors.0.code', 'OIDC_EXCHANGE_FAILED');
    }

    #[DataProvider('deletedGoogleAccounts')]
    public function test_google_signup_releases_a_deleted_buyer_without_restoring_the_old_account(bool $linked, bool $changedEmail): void
    {
        $this->seed(SystemFoundationSeeder::class);
        $buyer = $this->deletedBuyer('deleted-google@example.test', $linked);
        $email = $changedEmail ? 'changed-google@example.test' : $buyer->email;

        $result = $this->completeBuyerGoogle($email, 'SIGN_UP');

        self::assertNotSame($buyer->id, $result->user->id);
        self::assertSame('BUYER', $result->user->account_type);
        self::assertSame('ACTIVE', $result->user->account_status);
        self::assertNotNull($result->user->email_verified_at);
        self::assertSame('DELETED', $buyer->refresh()->account_status);
        self::assertStringEndsWith('@accounts.materyalph.invalid', $buyer->email);
        $this->assertDatabaseMissing('external_identities', ['user_id' => $buyer->id]);
        $this->assertDatabaseHas('external_identities', ['user_id' => $result->user->id, 'provider_subject' => 'google-subject', 'email_at_link' => $email]);
        $this->assertDatabaseHas('buyer_profiles', ['user_id' => $result->user->id]);
        self::assertSame(2, DB::table('agreement_acceptances')->where('user_id', $result->user->id)->count());
        $this->assertDatabaseCount('email_otps', 0);
        $service = app(GoogleOidcService::class);
        self::assertSame($result->user->id, $service->consumeMobileExchangeCode($service->issueMobileExchangeCode($result))->user->id);
    }

    /** @return array<string, array{bool, bool}> */
    public static function deletedGoogleAccounts(): array
    {
        return ['linked Google account' => [true, false], 'unlinked Gmail address' => [false, false], 'Google email changed' => [true, true]];
    }

    public function test_google_signin_cannot_restore_or_release_a_deleted_buyer(): void
    {
        $buyer = $this->deletedBuyer('deleted-google@example.test', true);
        try {
            $this->completeBuyerGoogle($buyer->email, 'SIGN_IN');
            self::fail('Deleted accounts require a fresh registration.');
        } catch (AuthenticationException $error) {
            self::assertSame('PORTAL_ACCESS_DENIED', $error->errorCode);
        }
        self::assertSame('DELETED', $buyer->refresh()->account_status);
        self::assertSame('deleted-google@example.test', $buyer->email);
        $this->assertDatabaseHas('external_identities', ['user_id' => $buyer->id, 'provider_subject' => 'google-subject']);
        $this->assertDatabaseCount('users', 1);
    }

    public function test_failed_google_registration_rolls_back_deleted_identity_release(): void
    {
        $this->seed(SystemFoundationSeeder::class);
        $buyer = $this->deletedBuyer('deleted-google@example.test', true);
        $this->configureOidc();
        config()->set('app.buyer_redirect_uri', 'materyalph://auth/callback');
        $terms = collect($this->getJson('/api/v1/agreements/current')->json('data'))->firstWhere('code', 'TERMS_OF_SERVICE');
        $service = app(GoogleOidcService::class);
        $url = $service->authorizationUrl('BUYER', 'MOBILE', true, true, 'SIGN_UP', '+639171234567', 'INDIVIDUAL', null, null, $terms['id'], $terms['content_hash']);
        $flow = $this->flowFromAuthorizationUrl($url);
        parse_str((string) parse_url($url, PHP_URL_QUERY), $query);
        $this->fakeGoogleIdentity($flow['nonce'], $buyer->email);
        DB::table('agreement_versions')->where('id', $terms['id'])->update(['retired_at' => now()]);
        try {
            $service->complete($query['state'], 'authorization-code');
            self::fail('Stale consent must reject the entire registration.');
        } catch (AuthenticationException $error) {
            self::assertSame('AGREEMENT_VERSION_CONFLICT', $error->errorCode);
        }
        self::assertSame('deleted-google@example.test', $buyer->refresh()->email);
        self::assertSame('DELETED', $buyer->account_status);
        $this->assertDatabaseHas('external_identities', ['user_id' => $buyer->id, 'provider_subject' => 'google-subject']);
        $this->assertDatabaseCount('users', 1);
    }

    private function deletedBuyer(string $email, bool $linked): User
    {
        $buyer = User::factory()->create(['email' => $email, 'account_type' => 'BUYER', 'account_status' => 'DELETED', 'account_deleted_at' => now()]);
        if ($linked) {
            ExternalIdentity::query()->create(['user_id' => $buyer->id, 'provider' => 'GOOGLE', 'provider_subject' => 'google-subject', 'email_at_link' => $email, 'linked_at' => now()]);
        }

        return $buyer;
    }

    private function completeBuyerGoogle(string $email, string $mode): GoogleOidcResult
    {
        $this->configureOidc();
        config()->set('app.buyer_redirect_uri', 'materyalph://auth/callback');
        $terms = $mode === 'SIGN_UP' ? collect($this->getJson('/api/v1/agreements/current')->json('data'))->firstWhere('code', 'TERMS_OF_SERVICE') : null;
        $url = app(GoogleOidcService::class)->authorizationUrl('BUYER', 'MOBILE', true, true, $mode, '+639171234567', 'INDIVIDUAL', null, null, $terms['id'] ?? null, $terms['content_hash'] ?? null);
        $flow = $this->flowFromAuthorizationUrl($url);
        parse_str((string) parse_url($url, PHP_URL_QUERY), $query);
        $this->fakeGoogleIdentity($flow['nonce'], $email);

        return app(GoogleOidcService::class)->complete($query['state'], 'authorization-code');
    }

    private function base64Url(string $value): string
    {
        return rtrim(strtr(base64_encode($value), '+/', '-_'), '=');
    }

    private function fakeGoogleIdentity(string $nonce, string $email, string $audience = 'expected-client-id'): void
    {
        $privateKey = openssl_pkey_new(['private_key_bits' => 2048, 'private_key_type' => OPENSSL_KEYTYPE_RSA]);
        self::assertNotFalse($privateKey);
        self::assertTrue(openssl_pkey_export($privateKey, $privatePem));
        $details = openssl_pkey_get_details($privateKey);
        self::assertIsArray($details);
        self::assertArrayHasKey('rsa', $details);

        $idToken = JWT::encode([
            'iss' => 'https://accounts.google.com',
            'aud' => $audience,
            'sub' => 'google-subject',
            'email' => $email,
            'email_verified' => true,
            'nonce' => $nonce,
            'iat' => time(),
            'exp' => time() + 300,
        ], $privatePem, 'RS256', 'test-key');

        /** @var array{n: string, e: string} $rsa */
        $rsa = $details['rsa'];
        Http::fake([
            'https://accounts.example.test/token' => Http::response(['id_token' => $idToken]),
            'https://accounts.example.test/jwks' => Http::response(['keys' => [[
                'kty' => 'RSA',
                'kid' => 'test-key',
                'use' => 'sig',
                'alg' => 'RS256',
                'n' => $this->base64Url($rsa['n']),
                'e' => $this->base64Url($rsa['e']),
            ]]]),
        ]);
    }

    /** @return array<string, mixed> */
    private function flowFromAuthorizationUrl(string $authorizationUrl): array
    {
        parse_str((string) parse_url($authorizationUrl, PHP_URL_QUERY), $query);
        $state = (string) ($query['state'] ?? '');
        self::assertNotSame('', $state);
        $flow = Cache::get('oidc:'.hash('sha256', $state));
        self::assertIsArray($flow);

        return $flow;
    }

    private function configureOidc(): void
    {
        config()->set([
            'services.google_oidc.client_id' => 'expected-client-id',
            'services.google_oidc.client_secret' => 'test-client-secret',
            'services.google_oidc.redirect_uri' => 'http://localhost:8080/api/v1/auth/google/callback',
            'services.google_oidc.authorization_endpoint' => 'https://accounts.example.test/auth',
            'services.google_oidc.token_endpoint' => 'https://accounts.example.test/token',
            'services.google_oidc.jwks_uri' => 'https://accounts.example.test/jwks',
        ]);
    }
}
