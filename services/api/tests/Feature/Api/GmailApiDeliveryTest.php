<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Notifications\MailDeliveryException;
use App\Domain\Notifications\MailProvider;
use App\Mail\MailTestMail;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Mail;
use Tests\TestCase;

final class GmailApiDeliveryTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        config([
            'mail.default' => 'gmail_api', 'mail.from.address' => 'sender@example.test',
            'mail.delivery_not_before' => '2026-10-21T00:00:00Z',
            'services.gmail_api.client_id' => 'sender-client',
            'services.gmail_api.client_secret' => 'synthetic-client-secret',
            'services.gmail_api.refresh_token' => 'synthetic-refresh',
            'services.google_oidc.client_id' => 'sign-in-client',
        ]);
        Mail::forgetMailers();
        Http::preventStrayRequests();
    }

    public function test_existing_mail_provider_and_mailable_use_the_registered_https_transport(): void
    {
        Http::fake([
            '*oauth2.googleapis.com/token' => Http::response(['access_token' => 'synthetic-access', 'token_type' => 'Bearer', 'expires_in' => 3600]),
            '*gmail.googleapis.com/*' => Http::response(['id' => 'provider-accepted']),
        ]);
        app(MailProvider::class)->send('recipient@example.test', new MailTestMail);
        Http::assertSentCount(2);
        self::assertSame('gmail_api', (string) Mail::mailer()->getSymfonyTransport());
    }

    public function test_transport_errors_keep_the_safe_error_code_through_the_existing_adapter(): void
    {
        Http::fake(['*' => Http::response(['error' => 'invalid_grant'], 400)]);
        try {
            app(MailProvider::class)->send('recipient@example.test', new MailTestMail);
            self::fail('Revoked sender authorization must fail.');
        } catch (MailDeliveryException $error) {
            self::assertSame('MAIL_AUTHENTICATION_FAILED', $error->errorCode);
            self::assertNull($error->getPrevious());
        }
    }
}
