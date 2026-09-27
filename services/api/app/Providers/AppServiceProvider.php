<?php

namespace App\Providers;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Compliance\ComplianceReferenceProvider;
use App\Domain\Compliance\ComplianceTextExtractor;
use App\Domain\Identity\AccessTokenIssuer;
use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Identity\PassportAccessTokenIssuer;
use App\Domain\Identity\RecaptchaAssessmentGateway;
use App\Domain\Identity\SecureOtpCodeGenerator;
use App\Domain\Vendors\AddressGeocoder;
use App\Domain\Vendors\PsgcProvider;
use App\Domain\Vendors\PublicStoreMediaStorage;
use App\Domain\Vendors\XenditAccountVerificationGateway;
use App\Infrastructure\Compliance\RegisterComplianceReferenceProvider;
use App\Infrastructure\Compliance\UnavailableComplianceTextExtractor;
use App\Infrastructure\Geography\ConfiguredGoogleMapsGeocoder;
use App\Infrastructure\Geography\PsgcCloudProvider;
use App\Infrastructure\Identity\GoogleRecaptchaEnterpriseGateway;
use App\Infrastructure\Payments\ConfiguredXenditAccountVerificationGateway;
use App\Infrastructure\Storage\CloudinaryPublicStoreMediaStorage;
use Illuminate\Cache\RateLimiting\Limit;
use Illuminate\Http\Request;
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
        $this->app->bind(OtpCodeGenerator::class, SecureOtpCodeGenerator::class);
        $this->app->bind(AccessTokenIssuer::class, PassportAccessTokenIssuer::class);
        $this->app->bind(RecaptchaAssessmentGateway::class, GoogleRecaptchaEnterpriseGateway::class);
        $this->app->bind(PublicStoreMediaStorage::class, CloudinaryPublicStoreMediaStorage::class);
        $this->app->bind(AddressGeocoder::class, ConfiguredGoogleMapsGeocoder::class);
        $this->app->bind(PsgcProvider::class, PsgcCloudProvider::class);
        $this->app->bind(XenditAccountVerificationGateway::class, ConfiguredXenditAccountVerificationGateway::class);
        $this->app->bind(ComplianceReferenceProvider::class, RegisterComplianceReferenceProvider::class);
        $this->app->bind(ComplianceTextExtractor::class, UnavailableComplianceTextExtractor::class);
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        RateLimiter::for('account', fn (Request $request): Limit => Limit::perMinute(60)->by((string) $request->user()?->getAuthIdentifier()));
        RateLimiter::for('profile-photo', fn (Request $request): Limit => Limit::perMinute(5)->by((string) $request->user()?->getAuthIdentifier()));
        RateLimiter::for('account-security', fn (Request $request): Limit => Limit::perMinutes(15, 5)->by((string) $request->user()?->getAuthIdentifier().'|'.$request->path()));
        RateLimiter::for('vendor-payment-status', fn (Request $request): Limit => Limit::perMinute(6)->by((string) $request->user()?->getAuthIdentifier()));
        RateLimiter::for('account-upload', function (Request $request): array {
            $scope = $request->attributes->get('account_scope');
            if (! is_array($scope)) {
                $scope = app(AccountAccess::class)->resolve($request->user());
            }

            return [
                Limit::perMinute(20)->by('user|'.$request->user()->getAuthIdentifier()),
                Limit::perMinute(20)->by('organization|'.$scope['organization_id']),
            ];
        });
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
        // Browsing, bootstrap and provider traffic must not exhaust authentication attempts.
        RateLimiter::for('public-store', fn (Request $request): Limit => Limit::perMinute(10)->by($request->ip()));
        RateLimiter::for('auth-csrf', fn (Request $request): Limit => Limit::perMinute(10)->by($request->ip()));
        RateLimiter::for('provider-webhook', fn (Request $request): Limit => Limit::perMinute(10)->by($request->ip()));
        RateLimiter::for('vendor-address', fn (Request $request): Limit => Limit::perMinute(10)->by((string) $request->user()?->getAuthIdentifier()));
        RateLimiter::for('auth-registration', fn (Request $request): Limit => Limit::perHour(5)->by($request->ip()));
        RateLimiter::for('auth-refresh', fn (Request $request): Limit => Limit::perMinute(30)->by($request->ip()));
    }
}
