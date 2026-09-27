<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Models\User;
use Illuminate\Http\Exceptions\ThrottleRequestsException;
use Illuminate\Http\Request;
use Illuminate\Routing\Middleware\ThrottleRequests;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\RateLimiter;
use Symfony\Component\HttpFoundation\Response;
use Tests\TestCase;

final class RateLimitIsolationTest extends TestCase
{
    public function test_unrelated_traffic_cannot_consume_authentication_budget_and_abuse_still_gets_429(): void
    {
        Cache::flush();
        $request = Request::create('/api/v1/stores', 'GET', server: ['REMOTE_ADDR' => '192.0.2.10']);
        $middleware = app(ThrottleRequests::class);
        foreach (['public-store', 'auth-csrf', 'provider-webhook'] as $name) {
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

    public function test_authenticated_limits_use_user_identity_and_keep_existing_budgets(): void
    {
        Cache::flush();
        $first = Request::create('/api/v1/vendors/onboarding/address/pin');
        $second = Request::create('/api/v1/vendors/onboarding/address/pin');
        $first->setUserResolver(fn (): User => (new User)->forceFill(['id' => 1]));
        $second->setUserResolver(fn (): User => (new User)->forceFill(['id' => 2]));
        foreach (['account' => 60, 'vendor-address' => 10] as $name => $budget) {
            $limiter = RateLimiter::limiter($name);
            self::assertNotNull($limiter);
            self::assertSame($budget, $limiter($first)->maxAttempts);
            self::assertNotSame($limiter($first)->key, $limiter($second)->key);
        }
        $middleware = app(ThrottleRequests::class);
        for ($attempt = 0; $attempt < 10; $attempt++) {
            $middleware->handle($first, fn (): Response => new Response, 'vendor-address');
        }
        self::assertSame(200, $middleware->handle($second, fn (): Response => new Response, 'vendor-address')->getStatusCode());
        $this->expectException(ThrottleRequestsException::class);
        $middleware->handle($first, fn (): Response => new Response, 'vendor-address');
    }
}
