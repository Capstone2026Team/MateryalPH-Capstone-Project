<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Models\User;
use Illuminate\Http\Exceptions\ThrottleRequestsException;
use Illuminate\Http\Request;
use Illuminate\Routing\Middleware\ThrottleRequests;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\RateLimiter;
use Illuminate\Support\Facades\Route;
use Symfony\Component\HttpFoundation\Response;
use Tests\TestCase;

final class RateLimitIsolationTest extends TestCase
{
    public function test_unrelated_traffic_cannot_consume_authentication_budget_and_abuse_still_gets_429(): void
    {
        Cache::flush();
        $request = Request::create('/api/v1/stores', 'GET', server: ['REMOTE_ADDR' => '192.0.2.10']);
        $middleware = app(ThrottleRequests::class);
        foreach (['auth-csrf', 'provider-webhook'] as $name) {
            for ($attempt = 0; $attempt < 10; $attempt++) {
                self::assertSame(200, $middleware->handle($request, fn (): Response => new Response, $name)->getStatusCode());
            }
        }
        for ($attempt = 0; $attempt < 10; $attempt++) {
            self::assertSame(200, $middleware->handle($request, fn (): Response => new Response, 'auth-public')->getStatusCode());
        }
        try {
            $middleware->handle($request, fn (): Response => new Response, 'auth-public');
            self::fail('Abusive authentication traffic must remain throttled.');
        } catch (ThrottleRequestsException $exception) {
            self::assertSame(429, $exception->getStatusCode());
            self::assertGreaterThan(0, (int) $exception->getHeaders()['Retry-After']);
        }
        $this->travel(61)->seconds();
        self::assertSame(200, $middleware->handle($request, fn (): Response => new Response, 'auth-public')->getStatusCode());
    }

    public function test_credential_limits_remain_scoped_to_user_and_action(): void
    {
        Cache::flush();
        $first = Request::create('/api/v1/vendors/account/reauthentication');
        $second = Request::create('/api/v1/vendors/account/reauthentication');
        $first->setUserResolver(fn (): User => (new User)->forceFill(['id' => 1]));
        $second->setUserResolver(fn (): User => (new User)->forceFill(['id' => 2]));
        $limiter = RateLimiter::limiter('account-security');
        self::assertNotNull($limiter);
        self::assertSame(5, $limiter($first)->maxAttempts);
        self::assertNotSame($limiter($first)->key, $limiter($second)->key);
        $differentAction = Request::create('/api/v1/vendors/account/password');
        $differentAction->setUserResolver($first->getUserResolver());
        self::assertNotSame($limiter($first)->key, $limiter($differentAction)->key);
        $middleware = app(ThrottleRequests::class);
        for ($attempt = 0; $attempt < 5; $attempt++) {
            $middleware->handle($first, fn (): Response => new Response, 'account-security');
        }
        self::assertSame(200, $middleware->handle($second, fn (): Response => new Response, 'account-security')->getStatusCode());
        $this->expectException(ThrottleRequestsException::class);
        $middleware->handle($first, fn (): Response => new Response, 'account-security');
    }

    public function test_everyday_routes_have_no_throttles_and_keep_authorization(): void
    {
        $count = 0;
        foreach (Route::getRoutes() as $route) {
            if (! str_starts_with($route->uri(), 'api/v1/')) {
                continue;
            }
            $middleware = $route->gatherMiddleware();
            $throttles = array_values(array_filter($middleware, fn (string $name): bool => str_starts_with($name, 'throttle:')));
            if (str_starts_with($route->uri(), 'api/v1/auth/')
                || str_starts_with($route->uri(), 'api/v1/mobile/auth/')
                || str_starts_with($route->uri(), 'api/v1/webhooks/')) {
                continue;
            }
            $credentialAction = in_array('POST', $route->methods(), true)
                && preg_match('~/(?:account/(?:reauthentication(?:/email)?|password|email(?:/confirm)?|factor(?:/confirm)?|recovery-codes|two-factor(?:/confirm|/disable)?|deletion)|vendors/account/invitations|vendors/onboarding/store-email(?:/confirm)?)$~', $route->uri()) === 1;
            $expected = $credentialAction ? ['throttle:account-security'] : [];
            if (str_starts_with($route->uri(), 'api/v1/support/guest/')) {
                $expected[] = 'throttle:support-guest';
            }
            if (in_array('POST', $route->methods(), true)
                && preg_match('~^api/v1/support/(?:(?:buyers|vendors|guest)/tickets|guest/access-email)$~', $route->uri()) === 1) {
                $expected[] = 'throttle:support-submit';
            }
            self::assertSame($expected, $throttles, $route->uri());
            if (preg_match('~^api/v1/(buyers|vendors|vendor|admin)/~', $route->uri()) === 1) {
                self::assertContains('auth:api', $middleware, $route->uri());
                self::assertNotEmpty(array_filter($middleware, fn (string $name): bool => str_starts_with($name, 'account.access')), $route->uri());
                $count++;
            }
        }
        self::assertGreaterThan(100, $count);
        foreach (['account', 'account-upload', 'profile-photo', 'public-store', 'payment-create', 'vendor-payment-status', 'vendor-address', 'buyer-discovery', 'buyer-geocode', 'buyer-places', 'buyer-route'] as $name) {
            self::assertNull(RateLimiter::limiter($name), $name);
        }
    }
}
