<?php

namespace App\Providers;

use App\Domain\Compliance\ComplianceReferenceProvider;
use App\Domain\Compliance\ComplianceRegisterSource;
use App\Domain\Compliance\ComplianceTextExtractor;
use App\Domain\Finance\DemoWithholdingEvidenceAdapter;
use App\Domain\Finance\WithholdingEvidenceAdapter;
use App\Domain\Geography\PlacesProvider;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AccessTokenIssuer;
use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Identity\PassportAccessTokenIssuer;
use App\Domain\Identity\RecaptchaAssessmentGateway;
use App\Domain\Identity\SecureOtpCodeGenerator;
use App\Domain\Notifications\MailProvider;
use App\Domain\Notifications\PushGateway;
use App\Domain\Operations\ScheduledTaskRecorder;
use App\Domain\Payments\PaymentGateway;
use App\Domain\Settings\PlatformSettings;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\PsgcProvider;
use App\Domain\Vendors\PublicStoreMediaStorage;
use App\Domain\Vendors\XenditAccountVerificationGateway;
use App\Infrastructure\Compliance\HttpComplianceRegisterSource;
use App\Infrastructure\Compliance\RegisterComplianceReferenceProvider;
use App\Infrastructure\Compliance\TesseractComplianceTextExtractor;
use App\Infrastructure\Compliance\UnavailableComplianceTextExtractor;
use App\Infrastructure\Geography\ConfiguredGoogleMapsGeocoder;
use App\Infrastructure\Geography\GooglePlacesProvider;
use App\Infrastructure\Geography\GoogleRoutesProvider;
use App\Infrastructure\Geography\PsgcCloudProvider;
use App\Infrastructure\Identity\GoogleRecaptchaEnterpriseGateway;
use App\Infrastructure\Notifications\FakePushGateway;
use App\Infrastructure\Notifications\FcmPushGateway;
use App\Infrastructure\Notifications\LaravelMailProvider;
use App\Infrastructure\Payments\ConfiguredXenditAccountVerificationGateway;
use App\Infrastructure\Payments\FakePaymentGateway;
use App\Infrastructure\Payments\XenditPaymentSessionGateway;
use App\Infrastructure\Storage\CloudinaryPublicStoreMediaStorage;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Console\Events\ScheduledTaskFailed;
use Illuminate\Console\Events\ScheduledTaskFinished;
use Illuminate\Console\Events\ScheduledTaskSkipped;
use Illuminate\Console\Events\ScheduledTaskStarting;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Event;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\ServiceProvider;
use Laravel\Passport\Passport;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        $this->app->bind(MailProvider::class, LaravelMailProvider::class);
        $this->app->singleton(PushGateway::class, fn () => config('notifications.push_driver') === 'fake' && ! app()->isProduction()
            ? new FakePushGateway : new FcmPushGateway);
        $this->app->bind(OtpCodeGenerator::class, SecureOtpCodeGenerator::class);
        $this->app->bind(AccessTokenIssuer::class, PassportAccessTokenIssuer::class);
        $this->app->bind(RecaptchaAssessmentGateway::class, GoogleRecaptchaEnterpriseGateway::class);
        $this->app->bind(PublicStoreMediaStorage::class, CloudinaryPublicStoreMediaStorage::class);
        $this->app->bind(AddressGeocoder::class, ConfiguredGoogleMapsGeocoder::class);
        $this->app->bind(PsgcProvider::class, PsgcCloudProvider::class);
        $this->app->bind(XenditAccountVerificationGateway::class, ConfiguredXenditAccountVerificationGateway::class);
        $this->app->bind(ComplianceReferenceProvider::class, RegisterComplianceReferenceProvider::class);
        $this->app->bind(ComplianceRegisterSource::class, HttpComplianceRegisterSource::class);
        $this->app->bind(ComplianceTextExtractor::class, fn ($app) => $app->make(
            config('materyalph.compliance_ocr.driver') === 'tesseract' ? TesseractComplianceTextExtractor::class : UnavailableComplianceTextExtractor::class,
        ));
        $this->app->bind(PlacesProvider::class, GooglePlacesProvider::class);
        $this->app->bind(RouteProvider::class, GoogleRoutesProvider::class);
        $this->app->singleton(WithholdingEvidenceAdapter::class, DemoWithholdingEvidenceAdapter::class);
        // Effective Platform Settings are read once per request or queued job and forgotten after a change.
        $this->app->scoped(PlatformSettings::class);
        // One adapter per process: the deterministic simulator keeps its injected failures for the whole request.
        $this->app->singleton(PaymentGateway::class, fn (): PaymentGateway => config('payments.gateway') === 'fake' ? new FakePaymentGateway : new XenditPaymentSessionGateway);
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        require base_path('routes/channels.php');
        // Integration and Job Health: every scheduled task records its start, outcome and duration (no output or payload).
        Event::listen(ScheduledTaskStarting::class, [ScheduledTaskRecorder::class, 'starting']);
        Event::listen(ScheduledTaskFinished::class, [ScheduledTaskRecorder::class, 'finished']);
        Event::listen(ScheduledTaskFailed::class, [ScheduledTaskRecorder::class, 'failed']);
        Event::listen(ScheduledTaskSkipped::class, [ScheduledTaskRecorder::class, 'skipped']);
        // Throttle credential and verification actions, without a shared app-activity budget.
        RateLimiter::for('account-security', fn (Request $request): Limit => Limit::perMinutes(15, 5)->by((string) $request->user()?->getAuthIdentifier().'|'.$request->path()));
        $keyPath = config('passport.key_path');
        if (is_string($keyPath) && trim($keyPath) !== '') {
            Passport::loadKeysFrom($keyPath);
        }

        Passport::tokensCan([
            'BUYER' => 'Buyer account access',
            'VENDOR' => 'Vendor account access',
            'ADMIN' => 'Admin account access',
        ]);
        Passport::tokensExpireIn(now()->addMinutes((int) config('materyalph.auth.access_token_minutes', 15)));
        Passport::refreshTokensExpireIn(now()->addDays((int) config('materyalph.auth.refresh_token_days', 14)));

        RateLimiter::for('auth-public', fn (Request $request): Limit => Limit::perMinute(10)->by($request->ip()));
        // Bootstrap and provider traffic must not exhaust authentication attempts.
        RateLimiter::for('auth-csrf', fn (Request $request): Limit => Limit::perMinute(10)->by($request->ip()));
        // Xendit retries and bursts payment events from a small set of addresses; the inbox only stores and acknowledges.
        RateLimiter::for('payment-webhook', fn (Request $request): Limit => Limit::perMinute(600)->by($request->ip()));
        RateLimiter::for('provider-webhook', fn (Request $request): Limit => Limit::perMinute(10)->by($request->ip()));
        RateLimiter::for('auth-registration', fn (Request $request): Limit => Limit::perHour(5)->by($request->ip()));
        RateLimiter::for('support-guest', fn (Request $request): Limit => Limit::perMinute(30)->by('support|'.$request->ip()));
        RateLimiter::for('support-submit', fn (Request $request): array => [
            Limit::perHour(10)->by('support-ip|'.$request->ip()),
            Limit::perHour(5)->by('support-identity|'.hash('sha256', (string) ($request->user()?->getAuthIdentifier() ?? mb_strtolower((string) $request->input('email'))))),
        ]);
        RateLimiter::for('auth-refresh', fn (Request $request): Limit => Limit::perMinute(30)->by($request->ip()));
    }
}
