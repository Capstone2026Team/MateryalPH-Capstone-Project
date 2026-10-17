<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Notifications\PushNotification;
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

    public function test_message_push_contains_the_authorized_sender_preview_and_an_opaque_notice_id(): void
    {
        Http::fake(['oauth2.googleapis.com/*' => Http::response(['access_token' => 'synthetic-oauth-fixture']), 'fcm.googleapis.com/*' => Http::response(['name' => 'synthetic-message'])]);
        $notice = new PushNotification('synthetic-notice', 'Juan Cruz · Sample Hardware', 'Your cement is ready for pickup.');
        self::assertSame('SENT', app(FcmPushGateway::class)->send('synthetic-device', $notice, 'ANDROID'));
        Http::assertSent(fn (Request $request): bool => str_contains($request->url(), 'messages:send')
            && $request['message']['data'] === ['notification_id' => 'synthetic-notice']
            && $request['message']['notification'] === ['title' => 'Juan Cruz · Sample Hardware', 'body' => 'Your cement is ready for pickup.']
            && $request['message']['android']['priority'] === 'high'
            && $request['message']['android']['notification'] === [
                'channel_id' => 'materyalph_updates', 'icon' => 'ic_notification',
                'sound' => 'default', 'tag' => 'synthetic-notice', 'visibility' => 'PRIVATE',
            ]);
        Http::assertSentCount(2);
    }

    public function test_ios_push_displays_the_actual_event_summary_and_requests_sound(): void
    {
        Http::fake(['oauth2.googleapis.com/*' => Http::response(['access_token' => 'synthetic-oauth-fixture']), 'fcm.googleapis.com/*' => Http::response(['name' => 'synthetic-message'])]);
        self::assertSame('SENT', app(FcmPushGateway::class)->send('synthetic-device', new PushNotification('synthetic-notice', 'Order ready for pickup', 'The Vendor marked your order ready for pickup.'), 'IOS'));
        Http::assertSent(fn (Request $request): bool => str_contains($request->url(), 'messages:send')
            && $request['message']['data'] === ['notification_id' => 'synthetic-notice']
            && $request['message']['notification'] === ['title' => 'Order ready for pickup', 'body' => 'The Vendor marked your order ready for pickup.']
            && $request['message']['apns'] === ['headers' => ['apns-priority' => '10'], 'payload' => ['aps' => ['sound' => 'default']]]
            && ! isset($request['message']['android']));
        Http::assertSentCount(2);
    }

    public function test_web_push_uses_the_registered_worker_origin_and_unregistered_devices_are_revoked(): void
    {
        Http::fake(['oauth2.googleapis.com/*' => Http::response(['access_token' => 'synthetic-oauth-fixture']), 'fcm.googleapis.com/*' => Http::response(['error' => ['details' => [['errorCode' => 'UNREGISTERED']]]], 404)]);
        self::assertSame('REVOKED', app(FcmPushGateway::class)->send('synthetic-device', new PushNotification('synthetic-notice', 'Event title', 'Event summary'), 'WEB'));
        Http::assertSent(fn (Request $request): bool => str_contains($request->url(), 'messages:send') && ! isset($request['message']['notification']) && ! isset($request['message']['webpush']['fcm_options']));
    }

    public function test_provider_failure_cannot_expose_response_or_credentials_in_exception_history(): void
    {
        Http::fake(['oauth2.googleapis.com/*' => Http::response(['access_token' => 'synthetic-oauth-fixture']), 'fcm.googleapis.com/*' => Http::response(['private' => 'synthetic-private-provider-payload'], 503)]);
        try {
            app(FcmPushGateway::class)->send('synthetic-device', new PushNotification('synthetic-notice', 'Event title', 'Event summary'), 'ANDROID');
            self::fail('Provider failure must fail delivery.');
        } catch (RuntimeException $exception) {
            self::assertSame('PUSH_UNAVAILABLE', $exception->getMessage());
            self::assertNull($exception->getPrevious());
        }
    }

    public function test_multibyte_previews_stay_readable_and_below_the_fcm_payload_limit(): void
    {
        Http::fake(['oauth2.googleapis.com/*' => Http::response(['access_token' => 'synthetic-oauth-fixture']), 'fcm.googleapis.com/*' => Http::response(['name' => 'synthetic-message'])]);
        $notice = new PushNotification('synthetic-notice', str_repeat('🧱', 400), "Cement\n\tready\x00 ".str_repeat('🧱', 1000));
        self::assertLessThanOrEqual(255, mb_strlen($notice->title));
        self::assertLessThanOrEqual(320, mb_strlen($notice->body));
        self::assertStringStartsWith('Cement ready ', $notice->body);
        self::assertStringEndsWith('…', $notice->body);
        self::assertSame('SENT', app(FcmPushGateway::class)->send('synthetic-device', $notice, 'ANDROID'));
        Http::assertSent(fn (Request $request): bool => str_contains($request->url(), 'messages:send')
            && strlen($request->body()) < 4096);
    }
}
