<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\EmailOtpService;
use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Notifications\MailDeliveryException;
use App\Domain\Notifications\MailDeliveryPolicy;
use App\Domain\Notifications\MailProvider;
use App\Domain\Notifications\NotificationDelivery;
use App\Domain\Notifications\NotificationService;
use App\Domain\Operations\OutboxProcessor;
use App\Domain\Operations\OutboxPublisher;
use App\Mail\EmailOtpMail;
use App\Mail\MailTestMail;
use App\Mail\VendorOnboardingNoticeMail;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Foundation\Testing\RefreshDatabase;
use Illuminate\Mail\MailManager;
use Illuminate\Support\Env;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Mail;
use Illuminate\Support\Facades\Queue;
use Illuminate\Support\Str;
use PHPUnit\Framework\Attributes\DataProvider;
use RuntimeException;
use Symfony\Component\Mailer\Exception\TransportException;
use Symfony\Component\Mailer\Transport\Smtp\EsmtpTransport;
use Tests\TestCase;

final class GmailDeliveryTest extends TestCase
{
    use RefreshDatabase;

    protected function setUp(): void
    {
        parent::setUp();
        Queue::fake();
        Mail::fake();
        config(['mail.delivery_not_before' => null]);
        $this->app->instance(OtpCodeGenerator::class, new class implements OtpCodeGenerator
        {
            public function sixDigits(): string
            {
                return '987654';
            }
        });
    }

    public function test_gmail_uses_required_starttls_certificate_verification_and_bounded_timeout(): void
    {
        $this->configureGmail();
        $transport = (new MailManager($this->app))->createSymfonyTransport(config('mail.mailers.smtp'));
        self::assertInstanceOf(EsmtpTransport::class, $transport);
        self::assertTrue($transport->isAutoTls());
        self::assertTrue($transport->isTlsRequired());
        self::assertFalse($transport->getStream()->isTLS());
        self::assertSame(10.0, $transport->getStream()->getTimeout());
        self::assertSame(587, $transport->getStream()->getPort());
        self::assertNotFalse($transport->getStream()->getStreamOptions()['ssl']['verify_peer'] ?? true);
        app(MailProvider::class)->send('recipient@example.test', new MailTestMail);
        Mail::assertSent(MailTestMail::class, 1);
    }

    public function test_blank_mail_url_does_not_override_the_actual_smtp_transport(): void
    {
        $environment = Env::getRepository();
        $previous = $environment->get('MAIL_URL');
        $environment->set('MAIL_URL', '');
        try {
            $configuration = require config_path('mail.php');
            self::assertNull($configuration['mailers']['smtp']['url']);
            $this->configureGmail();
            config(['mail.mailers.smtp.url' => $configuration['mailers']['smtp']['url']]);
            $transport = (new MailManager($this->app))->mailer()->getSymfonyTransport();
            self::assertInstanceOf(EsmtpTransport::class, $transport);
            self::assertTrue($transport->isTlsRequired());
        } finally {
            if ($previous === null) {
                $environment->clear('MAIL_URL');
            } else {
                $environment->set('MAIL_URL', $previous);
            }
        }
    }

    #[DataProvider('unsafeGmailSettings')]
    public function test_gmail_configuration_fails_closed(string $setting, mixed $value): void
    {
        $this->configureGmail();
        config([$setting => $value]);
        try {
            app(MailProvider::class)->send('recipient@example.test', new MailTestMail);
            self::fail('Unsafe Gmail settings must not send email.');
        } catch (MailDeliveryException $exception) {
            self::assertSame('MAIL_CONFIGURATION_INVALID', $exception->errorCode);
            self::assertNull($exception->getPrevious());
        }
        Mail::assertNothingSent();
    }

    /** @return array<string, array{string, mixed}> */
    public static function unsafeGmailSettings(): array
    {
        return [
            'log transport' => ['mail.default', 'log'],
            'logging failover' => ['mail.default', 'failover'],
            'URL override' => ['mail.mailers.smtp.url', 'smtp://override.example.test:587'],
            'TLS optional' => ['mail.mailers.smtp.require_tls', false],
            'auto TLS disabled' => ['mail.mailers.smtp.auto_tls', false],
            'certificate verification disabled' => ['mail.mailers.smtp.verify_peer', false],
            'wrong scheme' => ['mail.mailers.smtp.scheme', 'smtps'],
            'wrong port' => ['mail.mailers.smtp.port', 25],
            'missing username' => ['mail.mailers.smtp.username', ''],
            'missing password' => ['mail.mailers.smtp.password', ''],
            'different sender' => ['mail.from.address', 'another@example.test'],
            'unbounded timeout' => ['mail.mailers.smtp.timeout', 0],
            'missing activation' => ['mail.delivery_not_before', null],
            'invalid activation' => ['mail.delivery_not_before', 'yesterday'],
            'invalid calendar date' => ['mail.delivery_not_before', '2026-02-31T00:00:00Z'],
        ];
    }

    public function test_transport_failure_is_sanitized_and_outbox_retry_can_succeed(): void
    {
        $eventId = $this->onboardingEvent();
        Mail::shouldReceive('to')->once()->andThrow(new RuntimeException('Synthetic SMTP transcript: synthetic-password recipient@example.test'));
        try {
            app(OutboxProcessor::class)->process($eventId);
            self::fail('Transport failure must remain retryable.');
        } catch (MailDeliveryException $exception) {
            self::assertSame('MAIL_TRANSPORT_UNAVAILABLE', $exception->errorCode);
            self::assertNull($exception->getPrevious());
            self::assertStringNotContainsString('synthetic-password', (string) $exception);
            self::assertStringNotContainsString('recipient@example.test', (string) $exception);
        }
        $event = DB::table('outbox_events')->where('id', $eventId)->sole();
        self::assertSame(1, (int) $event->attempts);
        self::assertNull($event->processed_at);
        self::assertTrue(CarbonImmutable::parse($event->available_at)->isFuture());
        Mail::swap(new MailManager($this->app));
        Mail::fake();
        $this->travel(31)->seconds();
        app(OutboxProcessor::class)->process($eventId);
        app(OutboxProcessor::class)->process($eventId);
        Mail::assertSent(VendorOnboardingNoticeMail::class, 1);
        self::assertNotNull(DB::table('outbox_events')->where('id', $eventId)->value('processed_at'));
    }

    public function test_authentication_failure_has_a_safe_actionable_error_without_transcript(): void
    {
        Mail::shouldReceive('to')->once()->andThrow(new TransportException('Failed to authenticate on SMTP server with username recipient@example.test: synthetic-password'));
        try {
            app(MailProvider::class)->send('recipient@example.test', new MailTestMail);
            self::fail('Authentication failure must not be reported as delivery success.');
        } catch (MailDeliveryException $exception) {
            self::assertSame('MAIL_AUTHENTICATION_FAILED', $exception->errorCode);
            self::assertNull($exception->getPrevious());
            self::assertStringNotContainsString('synthetic-password', (string) $exception);
            self::assertStringNotContainsString('recipient@example.test', (string) $exception);
        }
    }

    public function test_cutoff_skips_old_outbox_mail_and_delivers_new_mail_without_removing_history(): void
    {
        $this->travelTo(CarbonImmutable::parse('2026-10-14T01:00:00Z'));
        $old = $this->onboardingEvent();
        $this->travel(60)->seconds();
        config(['mail.delivery_not_before' => '2026-10-14T01:01:00Z']);
        $new = $this->onboardingEvent();
        app(OutboxProcessor::class)->process($old);
        app(OutboxProcessor::class)->process($new);
        Mail::assertSentCount(1);
        self::assertSame(2, DB::table('outbox_events')->whereNotNull('processed_at')->count());
        self::assertSame('2026-10-14T01:01:00Z', config('mail.delivery_not_before'));
    }

    public function test_notification_created_before_activation_is_skipped_even_when_delivery_is_enqueued_later(): void
    {
        $this->travelTo(CarbonImmutable::parse('2026-10-14T01:00:00Z'));
        $user = User::factory()->create(['account_type' => 'BUYER', 'account_status' => 'ACTIVE']);
        $old = app(NotificationService::class)->record((int) $user->id, 'SECURITY', 'Account update', 'Review your account.', 'ACCOUNT', $user->public_id, 'old');
        $this->travel(60)->seconds();
        config(['mail.delivery_not_before' => '2026-10-14T01:01:00Z']);
        app(NotificationService::class)->enqueue($old);
        $oldDelivery = (string) DB::table('notification_deliveries')->where('notification_id', $old)->value('id');
        app(NotificationDelivery::class)->send($oldDelivery);
        self::assertSame('SKIPPED', DB::table('notification_deliveries')->where('id', $oldDelivery)->value('state'));
        Mail::assertNothingSent();
        $new = app(NotificationService::class)->record((int) $user->id, 'SECURITY', 'Account update', 'Review your account.', 'ACCOUNT', $user->public_id, 'new');
        app(NotificationService::class)->enqueue($new);
        $newDelivery = (string) DB::table('notification_deliveries')->where('notification_id', $new)->value('id');
        app(NotificationDelivery::class)->send($newDelivery);
        self::assertSame('SENT', DB::table('notification_deliveries')->where('id', $newDelivery)->value('state'));
        self::assertSame(2, DB::table('notifications')->count());
        Mail::assertSentCount(1);
    }

    public function test_activation_cutoff_rejects_missing_or_invalid_origin_time(): void
    {
        config(['mail.delivery_not_before' => '2026-10-14T01:01:00Z']);
        self::assertFalse(app(MailDeliveryPolicy::class)->allows(''));
        self::assertFalse(app(MailDeliveryPolicy::class)->allows('not-a-timestamp'));
    }

    #[DataProvider('undeliverableOtps')]
    public function test_stale_or_mismatched_otp_is_not_sent(string $kind): void
    {
        $otp = app(EmailOtpService::class)->issue('recipient@example.test', 'EMAIL_VERIFICATION', null);
        $eventId = (string) DB::table('outbox_events')->where('aggregate_id', $otp->id)->value('id');
        match ($kind) {
            'expired' => $otp->update(['expires_at' => now()]),
            'consumed' => $otp->update(['consumed_at' => now()]),
            'invalidated' => $otp->update(['invalidated_at' => now()]),
            'exhausted' => $otp->update(['attempts' => $otp->max_attempts]),
            'recipient' => $otp->update(['normalized_email' => 'another@example.test']),
            'purpose' => $otp->update(['purpose' => 'PASSWORD_RESET']),
            'code' => $otp->update(['code_hash' => str_repeat('0', 64)]),
            'missing' => $otp->delete(),
        };
        app(OutboxProcessor::class)->process($eventId);
        Mail::assertNothingSent();
        self::assertNotNull(DB::table('outbox_events')->where('id', $eventId)->value('processed_at'));
        self::assertSame(0, (int) DB::table('outbox_events')->where('id', $eventId)->value('attempts'));
    }

    /** @return array<string, array{string}> */
    public static function undeliverableOtps(): array
    {
        return array_combine($kinds = ['expired', 'consumed', 'invalidated', 'exhausted', 'recipient', 'purpose', 'code', 'missing'], array_map(fn (string $kind): array => [$kind], $kinds));
    }

    public function test_resend_suppresses_old_otp_and_sends_only_the_current_challenge(): void
    {
        $service = app(EmailOtpService::class);
        $old = $service->issue('recipient@example.test', 'PASSWORD_RESET', null);
        $this->travel(61)->seconds();
        $new = $service->issue('recipient@example.test', 'PASSWORD_RESET', null);
        foreach ([$old, $new] as $otp) {
            app(OutboxProcessor::class)->process((string) DB::table('outbox_events')->where('aggregate_id', $otp->id)->value('id'));
        }
        Mail::assertSent(EmailOtpMail::class, 1);
        self::assertNotNull($old->refresh()->invalidated_at);
        self::assertNull($new->refresh()->consumed_at);
    }

    public function test_mail_test_command_requires_explicit_valid_recipient_and_smtp(): void
    {
        $this->artisan('materyalph:mail-test')->expectsOutputToContain('Provide --to')->assertExitCode(2);
        $this->artisan('materyalph:mail-test', ['--to' => 'invalid'])->assertExitCode(2);
        $this->artisan('materyalph:mail-test', ['--to' => 'recipient@example.test'])->expectsOutputToContain('MAIL_MAILER=smtp')->assertFailed();
        Mail::assertNothingSent();
    }

    public function test_mail_test_command_reports_acceptance_and_sanitized_failures(): void
    {
        $this->configureGmail();
        $this->artisan('materyalph:mail-test', ['--to' => 'recipient@example.test'])->expectsOutputToContain('SMTP accepted')->assertSuccessful();
        Mail::assertSent(MailTestMail::class, 1);
        Mail::shouldReceive('to')->once()->andThrow(new RuntimeException('Synthetic SMTP transcript'));
        $this->artisan('materyalph:mail-test', ['--to' => 'recipient@example.test'])->expectsOutputToContain('MAIL_TRANSPORT_UNAVAILABLE')->assertFailed();
    }

    public function test_mail_test_command_refuses_production_and_future_activation(): void
    {
        $this->configureGmail();
        config(['mail.delivery_not_before' => now()->addMinute()->utc()->format('Y-m-d\TH:i:s\Z')]);
        $this->artisan('materyalph:mail-test', ['--to' => 'recipient@example.test'])->expectsOutputToContain('before the configured activation time')->assertFailed();
        $this->app->instance('env', 'production');
        $this->artisan('materyalph:mail-test', ['--to' => 'recipient@example.test'])->expectsOutputToContain('only in local development')->assertFailed();
        Mail::assertNothingSent();
    }

    private function onboardingEvent(): string
    {
        return app(OutboxPublisher::class)->publish('VENDOR_ONBOARDING_NOTICE', 'TEST', (string) Str::uuid7(), ['recipient' => 'recipient@example.test', 'message' => 'Review your setup.']);
    }

    private function configureGmail(): void
    {
        config([
            'mail.default' => 'smtp', 'mail.mailers.smtp.host' => 'smtp.gmail.com', 'mail.mailers.smtp.port' => 587,
            'mail.mailers.smtp.scheme' => 'smtp', 'mail.mailers.smtp.url' => null,
            'mail.mailers.smtp.auto_tls' => true, 'mail.mailers.smtp.require_tls' => true, 'mail.mailers.smtp.verify_peer' => true,
            'mail.mailers.smtp.timeout' => 10, 'mail.mailers.smtp.username' => 'sender@example.test',
            'mail.mailers.smtp.password' => 'synthetic-app-password', 'mail.from.address' => 'sender@example.test',
            'mail.delivery_not_before' => now()->subMinute()->utc()->format('Y-m-d\TH:i:s\Z'),
        ]);
    }
}
