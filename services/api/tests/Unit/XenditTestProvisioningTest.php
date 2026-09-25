<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Vendors\XenditProviderUnavailable;
use App\Infrastructure\Payments\ConfiguredXenditAccountVerificationGateway;
use Illuminate\Support\Facades\Http;
use PHPUnit\Framework\Attributes\DataProvider;
use Tests\TestCase;

final class XenditTestProvisioningTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        config()->set('services.xendit.secret_key', 'xnd_development_synthetic_fixture');
        config()->set('services.xendit.mode', 'TEST');
        config()->set('services.xendit.base_url', 'https://api.xendit.co');
        Http::preventStrayRequests();
    }

    public function test_documented_owned_test_account_uses_no_invitation(): void
    {
        Http::fake(['https://api.xendit.co/v2/accounts' => Http::response($this->payload())]);
        $result = app(ConfiguredXenditAccountVerificationGateway::class)->initiate('owner@example.test', 'Test store');
        self::assertSame(['provider_account_id' => '5cafeb170a2b18519b1b8763', 'status' => 'LIVE', 'provider_created_at' => '2026-09-25T01:00:00Z'], $result);
        Http::assertSent(fn ($request) => $request->method() === 'POST'
            && $request->hasHeader('Authorization', 'Basic '.base64_encode('xnd_development_synthetic_fixture:'))
            && $request->data() === ['email' => 'owner@example.test', 'type' => 'OWNED', 'public_profile' => ['business_name' => 'Test store']]);
        Http::assertSentCount(1);
    }

    /** @return array<string, mixed> */
    private function payload(): array
    {
        return ['id' => '5cafeb170a2b18519b1b8763', 'status' => 'LIVE', 'email' => 'owner@example.test', 'type' => 'OWNED', 'public_profile' => ['business_name' => 'Test store'], 'country' => 'PH', 'created' => '2026-09-25T01:00:00Z'];
    }

    /** @return array<string, array{int, bool}> */
    public static function failures(): array
    {
        return ['invalid request or country/entity' => [400, true], 'credentials' => [401, true], 'permission or account limit' => [403, true], 'account conflict' => [409, true], 'validation' => [422, true], 'rate limit' => [429, true], 'server uncertainty' => [500, false]];
    }

    #[DataProvider('failures')]
    public function test_http_failures_are_redacted_and_never_retried(int $status, bool $rejected): void
    {
        Http::fake(['https://api.xendit.co/v2/accounts' => Http::response(['message' => 'sensitive provider body'], $status)]);
        try {
            app(ConfiguredXenditAccountVerificationGateway::class)->initiate('owner@example.test', 'Test store');
            self::fail('Failure must not connect');
        } catch (XenditProviderUnavailable $error) {
            self::assertSame($rejected, $error->creationRejected);
            self::assertStringNotContainsString('sensitive provider body', $error->getMessage());
            Http::assertSentCount(1);
        }
    }

    /** @return array<string, array{string, mixed}> */
    public static function invalidResponses(): array
    {
        return ['empty id' => ['id', ''], 'wrong status' => ['status', 'SUSPENDED'], 'wrong owner' => ['email', 'other@example.test'], 'wrong operation' => ['public_profile', ['business_name' => 'Other store']], 'wrong country' => ['country', 'SG'], 'wrong type' => ['type', 'MANAGED'], 'bad timestamp' => ['created', 'not a date']];
    }

    #[DataProvider('invalidResponses')]
    public function test_invalid_success_response_retains_uncertainty(string $field, mixed $value): void
    {
        Http::fake(['https://api.xendit.co/v2/accounts' => Http::response(array_replace($this->payload(), [$field => $value]))]);
        $this->expectException(XenditProviderUnavailable::class);
        app(ConfiguredXenditAccountVerificationGateway::class)->initiate('owner@example.test', 'Test store');
    }

    public function test_timeout_or_connection_failure_is_uncertain(): void
    {
        Http::fake(['https://api.xendit.co/v2/accounts' => Http::failedConnection()]);
        try {
            app(ConfiguredXenditAccountVerificationGateway::class)->initiate('owner@example.test', 'Test store');
            self::fail('Timeout must not connect');
        } catch (XenditProviderUnavailable $error) {
            self::assertFalse($error->creationRejected);
        }
    }

    public function test_non_json_success_is_rejected(): void
    {
        Http::fake(['https://api.xendit.co/v2/accounts' => Http::response('not json', 200)]);
        $this->expectException(XenditProviderUnavailable::class);
        app(ConfiguredXenditAccountVerificationGateway::class)->initiate('owner@example.test', 'Test store');
    }

    public function test_missing_credentials_prevent_network_access(): void
    {
        config()->set('services.xendit.secret_key', null);
        try {
            app(ConfiguredXenditAccountVerificationGateway::class)->initiate('owner@example.test', 'Test store');
            self::fail('Missing configuration must not connect');
        } catch (XenditProviderUnavailable $error) {
            self::assertTrue($error->creationRejected);
            Http::assertNothingSent();
        }
    }

    public function test_untrusted_provider_request_reference_is_not_propagated(): void
    {
        Http::fake(['https://api.xendit.co/v2/accounts' => Http::response(['error_code' => 'DISALLOWED_OPERATION'], 403, ['Request-Id' => 'unsafe reference'])]);
        try {
            app(ConfiguredXenditAccountVerificationGateway::class)->initiate('owner@example.test', 'Test store');
            self::fail('The provider denial must be reported.');
        } catch (XenditProviderUnavailable $error) {
            self::assertNull($error->providerRequestId);
            self::assertSame('DISALLOWED_OPERATION', $error->providerErrorCode);
        }
    }

    public function test_reconcile_reads_only_the_server_associated_account(): void
    {
        Http::fake(['https://api.xendit.co/v2/accounts/acct_test_123' => Http::response([
            'id' => 'acct_test_123', 'type' => 'OWNED', 'status' => 'REGISTERED',
        ])]);
        self::assertSame(
            ['provider_account_id' => 'acct_test_123', 'status' => 'REGISTERED', 'capabilities' => []],
            app(ConfiguredXenditAccountVerificationGateway::class)->reconcile('acct_test_123'),
        );
        Http::assertSent(fn ($request) => $request->method() === 'GET' && $request->url() === 'https://api.xendit.co/v2/accounts/acct_test_123');
        Http::assertSentCount(1);
    }

    public function test_reconcile_rejects_an_unrecognized_account_type(): void
    {
        Http::fake(['https://api.xendit.co/v2/accounts/acct_test_123' => Http::response([
            'id' => 'acct_test_123', 'type' => 'OTHER', 'status' => 'LIVE',
        ])]);
        $this->expectException(XenditProviderUnavailable::class);
        app(ConfiguredXenditAccountVerificationGateway::class)->reconcile('acct_test_123');
    }
}
