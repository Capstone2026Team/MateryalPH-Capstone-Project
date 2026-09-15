<?php

namespace App\Providers;

use App\Domain\Identity\AccessTokenIssuer;
use App\Domain\Identity\OtpCodeGenerator;
use App\Domain\Identity\PassportAccessTokenIssuer;
use App\Domain\Identity\RecaptchaAssessmentGateway;
use App\Domain\Identity\SecureOtpCodeGenerator;
use App\Domain\Vendors\CloudinaryPublicMedia;
use App\Domain\Vendors\FileScanner;
use App\Domain\Vendors\PublicMediaProvider;
use App\Domain\Vendors\SimulatedXenditConnection;
use App\Domain\Vendors\TestConnectionProvider;
use App\Domain\Vendors\TestFileScanner;
use App\Domain\Vendors\XenditTestConnection;
use App\Infrastructure\Identity\GoogleRecaptchaEnterpriseGateway;
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
        $this->app->bind(FileScanner::class, TestFileScanner::class);
        $this->app->bind(PublicMediaProvider::class, CloudinaryPublicMedia::class);
        $this->app->bind(TestConnectionProvider::class, fn () => config('vendor_onboarding.simulated_connection') ? new SimulatedXenditConnection : new XenditTestConnection);
        $this->app->bind(OtpCodeGenerator::class, SecureOtpCodeGenerator::class);
        $this->app->bind(AccessTokenIssuer::class, PassportAccessTokenIssuer::class);
        $this->app->bind(RecaptchaAssessmentGateway::class, GoogleRecaptchaEnterpriseGateway::class);
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        RateLimiter::for('account', fn (Request $request): Limit => Limit::perMinute(60)->by((string) $request->user()?->getAuthIdentifier()));
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
        RateLimiter::for('auth-registration', fn (Request $request): Limit => Limit::perHour(5)->by($request->ip()));
        RateLimiter::for('auth-refresh', fn (Request $request): Limit => Limit::perMinute(30)->by($request->ip()));
    }
}
