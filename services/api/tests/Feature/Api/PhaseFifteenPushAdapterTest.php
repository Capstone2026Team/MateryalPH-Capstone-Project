<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Infrastructure\Notifications\FcmPushGateway;
use Illuminate\Http\Client\Request;
use Illuminate\Support\Facades\Http;
use RuntimeException;
use Tests\TestCase;

final class PhaseFifteenPushAdapterTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        $key = openssl_pkey_new(['private_key_bits' => 2048, 'private_key_type' => OPENSSL_KEYTYPE_RSA]);
        openssl_pkey_export($key, $private);
        config()->set('notifications.firebase_project_id', 'synthetic-phase15');
        config()->set('notifications.firebase_credentials_base64', base64_encode(json_encode(['project_id' => 'synthetic-phase15', 'client_email' => 'synthetic@example.test', 'private_key' => $private])));
        Http::preventStrayRequests();
    }

    public function test_mobile_push_only_contains_generic_copy_and_an_opaque_notice_id(): void
    {
        Http::fake(['oauth2.googleapis.com/*' => Http::response(['access_token' => 'synthetic-oauth-fixture']), 'fcm.googleapis.com/*' => Http::response(['name' => 'synthetic-message'])]);
        self::assertSame('SENT', app(FcmPushGateway::class)->send('synthetic-device', 'synthetic-notice', 'ANDROID'));
        Http::assertSent(fn (Request $request): bool => str_contains($request->url(), 'messages:send') && $request['message']['data'] === ['notification_id' => 'synthetic-notice'] && $request['message']['notification']['body'] === 'A new notification is available. Sign in to view it.');
        Http::assertSentCount(2);
    }

    public function test_web_push_uses_the_registered_worker_origin_and_unregistered_devices_are_revoked(): void
    {
        Http::fake(['oauth2.googleapis.com/*' => Http::response(['access_token' => 'synthetic-oauth-fixture']), 'fcm.googleapis.com/*' => Http::response(['error' => ['details' => [['errorCode' => 'UNREGISTERED']]]], 404)]);
        self::assertSame('REVOKED', app(FcmPushGateway::class)->send('synthetic-device', 'synthetic-notice', 'WEB'));
        Http::assertSent(fn (Request $request): bool => str_contains($request->url(), 'messages:send') && ! isset($request['message']['notification']) && ! isset($request['message']['webpush']['fcm_options']));
    }

    public function test_provider_failure_cannot_expose_response_or_credentials_in_exception_history(): void
    {
        Http::fake(['oauth2.googleapis.com/*' => Http::response(['access_token' => 'synthetic-oauth-fixture']), 'fcm.googleapis.com/*' => Http::response(['private' => 'synthetic-private-provider-payload'], 503)]);
        try {
            app(FcmPushGateway::class)->send('synthetic-device', 'synthetic-notice', 'ANDROID');
            self::fail('Provider failure must fail delivery.');
        } catch (RuntimeException $exception) {
            self::assertSame('PUSH_UNAVAILABLE', $exception->getMessage());
            self::assertNull($exception->getPrevious());
        }
    }
}
