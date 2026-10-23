<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Notifications\MailDeliveryException;
use App\Infrastructure\Notifications\GmailApiTransport;
use Illuminate\Config\Repository;
use Illuminate\Container\Container;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\Client\Factory;
use Illuminate\Http\Client\Request;
use Illuminate\Support\Facades\Facade;
use Illuminate\Support\Facades\Http;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;
use Symfony\Component\Mime\Email;

/** No database, real OAuth credentials, or real network is used by this transport suite. */
final class GmailApiTransportTest extends TestCase
{
    private Container $previousContainer;

    protected function setUp(): void
    {
        parent::setUp();
        $this->previousContainer = Container::getInstance();
        $app = new Container;
        Container::setInstance($app);
        Facade::clearResolvedInstances();
        Facade::setFacadeApplication($app);
        $app->instance('config', new Repository([
            'mail' => ['delivery_not_before' => '2026-10-21T00:00:00Z', 'from' => ['address' => 'sender@example.test'], 'mailers' => ['gmail_api' => ['transport' => 'gmail_api', 'timeout' => 10]]],
            'services' => ['gmail_api' => ['client_id' => 'mail-client', 'client_secret' => 'synthetic-client-secret', 'refresh_token' => 'synthetic-refresh'], 'google_oidc' => ['client_id' => 'sign-in-client']],
        ]));
        $app->instance(Factory::class, new Factory);
        Http::preventStrayRequests();
    }

    protected function tearDown(): void
    {
        Facade::clearResolvedInstances();
        Facade::setFacadeApplication($this->previousContainer);
        Container::setInstance($this->previousContainer);
        parent::tearDown();
    }

    public function test_sends_mime_with_send_only_refresh_and_reuses_short_lived_access_token(): void
    {
        Http::fake([
            '*oauth2.googleapis.com/token' => Http::response($this->token()),
            '*gmail.googleapis.com/*' => Http::response(['id' => 'accepted-message']),
        ]);
        $transport = new GmailApiTransport;
        $transport->send($this->email());
        $transport->send($this->email());
        Http::assertSentCount(3);
        Http::assertSent(fn (Request $request): bool => str_contains($request->url(), '/token')
            && $request['grant_type'] === 'refresh_token' && $request['client_id'] === 'mail-client');
        Http::assertSent(function (Request $request): bool {
            if (! str_contains($request->url(), '/messages/send')) {
                return false;
            }
            $mime = base64_decode(strtr($request['raw'], '-_', '+/'), true);

            return $request->hasHeader('Authorization', 'Bearer synthetic-access') && is_string($mime)
                && str_contains($mime, 'To: recipient@example.test') && str_contains($mime, 'Synthetic message')
                && str_contains($mime, 'Content-Type: multipart/mixed');
        });
        self::assertSame('gmail_api', (string) $transport);
    }

    public function test_explicit_unauthorized_rejection_refreshes_once(): void
    {
        Http::fake([
            '*oauth2.googleapis.com/token' => Http::response($this->token()),
            '*gmail.googleapis.com/*' => Http::sequence()->push([], 401)->push(['id' => 'accepted']),
        ]);
        (new GmailApiTransport)->send($this->email());
        Http::assertSentCount(4);
    }

    #[DataProvider('failures')]
    public function test_provider_failures_are_sanitized(int $status, string $expected): void
    {
        Http::fake([
            '*oauth2.googleapis.com/token' => Http::response($this->token()),
            '*gmail.googleapis.com/*' => Http::response(['error' => 'synthetic sensitive provider payload'], $status),
        ]);
        try {
            (new GmailApiTransport)->send($this->email());
            self::fail('Delivery must fail.');
        } catch (MailDeliveryException $error) {
            self::assertSame($expected, $error->errorCode);
            self::assertNull($error->getPrevious());
            self::assertStringNotContainsString('sensitive', $error->getMessage());
        }
    }

    public static function failures(): array
    {
        return [[401, 'MAIL_AUTHENTICATION_FAILED'], [403, 'MAIL_PROVIDER_REJECTED'], [429, 'MAIL_RATE_LIMITED'], [503, 'MAIL_TRANSPORT_UNAVAILABLE']];
    }

    public function test_revoked_refresh_token_and_timeouts_do_not_leak_payloads_or_retry_sends(): void
    {
        Http::fake(['*' => Http::response(['error' => 'invalid_grant', 'detail' => 'synthetic-refresh'], 400)]);
        try {
            (new GmailApiTransport)->send($this->email());
            self::fail('Revoked authorization must fail.');
        } catch (MailDeliveryException $error) {
            self::assertSame('MAIL_AUTHENTICATION_FAILED', $error->errorCode);
            self::assertNull($error->getPrevious());
        }
        Http::assertSentCount(1);
        Http::fake([
            '*oauth2.googleapis.com/token' => Http::response($this->token()),
            '*gmail.googleapis.com/*' => fn () => throw new ConnectionException('synthetic sensitive request'),
        ]);
        $this->expectException(MailDeliveryException::class);
        (new GmailApiTransport)->send($this->email());
    }

    #[DataProvider('invalidSettings')]
    public function test_invalid_configuration_never_calls_google(string $key, mixed $value): void
    {
        config([$key => $value]);
        Http::fake();
        try {
            (new GmailApiTransport)->send($this->email());
            self::fail('Invalid configuration must fail.');
        } catch (MailDeliveryException $error) {
            self::assertSame('MAIL_CONFIGURATION_INVALID', $error->errorCode);
            Http::assertNothingSent();
        }
    }

    public static function invalidSettings(): array
    {
        return [['services.gmail_api.client_secret', ''], ['services.gmail_api.refresh_token', "bad\r\nvalue"],
            ['services.gmail_api.client_id', 'sign-in-client'], ['mail.from.address', 'invalid'], ['mail.mailers.gmail_api.timeout', 0],
            ['mail.delivery_not_before', null], ['mail.delivery_not_before', 'invalid']];
    }

    public function test_gmail_daily_quota_is_a_sanitized_rate_limit_failure(): void
    {
        Http::fake([
            '*oauth2.googleapis.com/token' => Http::response($this->token()),
            '*gmail.googleapis.com/*' => Http::response(['error' => ['errors' => [['reason' => 'dailyLimitExceeded']]]], 403),
        ]);
        try {
            (new GmailApiTransport)->send($this->email());
            self::fail('Quota exhaustion must fail.');
        } catch (MailDeliveryException $failure) {
            self::assertSame('MAIL_RATE_LIMITED', $failure->errorCode);
            self::assertNull($failure->getPrevious());
        }
    }

    public function test_sender_override_is_rejected_and_excessive_oauth_scopes_are_rejected(): void
    {
        Http::fake();
        try {
            (new GmailApiTransport)->send($this->email()->from('other@example.test'));
            self::fail('Sender override must fail.');
        } catch (MailDeliveryException $error) {
            self::assertSame('MAIL_CONFIGURATION_INVALID', $error->errorCode);
            Http::assertNothingSent();
        }
        Http::fake(['*' => Http::response($this->token() + ['scope' => 'https://mail.google.com/'])]);
        $this->expectException(MailDeliveryException::class);
        (new GmailApiTransport)->send($this->email());
    }

    private function email(): Email
    {
        return (new Email)->from('sender@example.test')->to('recipient@example.test')->subject('Synthetic message')
            ->text('Synthetic body')->attach('Synthetic attachment', 'notice.txt');
    }

    private function token(): array
    {
        return ['access_token' => 'synthetic-access', 'token_type' => 'Bearer', 'expires_in' => 3600];
    }
}
