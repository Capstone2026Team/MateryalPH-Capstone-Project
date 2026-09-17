<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Http\AuthCookieFactory;
use App\Http\Middleware\IsolatePortalCookies;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;
use Tests\TestCase;

final class PortalCookieIsolationTest extends TestCase
{
    public function test_each_portal_reads_only_its_own_cookies_and_logout_preserves_the_other(): void
    {
        config()->set('app.vendor_frontend_url', 'http://localhost:5173');
        config()->set('app.admin_frontend_url', 'http://localhost:5174');
        foreach (['vendor' => 5173, 'admin' => 5174] as $portal => $port) {
            $request = Request::create('/api/v1/auth/logout', 'POST', cookies: [
                'mp_access' => 'legacy', 'mp_access_vendor' => 'vendor-session', 'mp_access_admin' => 'admin-session',
                'mp_refresh_vendor' => 'vendor-refresh', 'mp_refresh_admin' => 'admin-refresh',
                'mp_mfa_challenge_vendor' => 'vendor-mfa', 'mp_mfa_challenge_admin' => 'admin-mfa',
                'mp_csrf_vendor' => 'vendor-csrf', 'mp_csrf_admin' => 'admin-csrf',
            ], server: ['HTTP_ORIGIN' => 'http://localhost:'.$port]);
            $response = (new IsolatePortalCookies)->handle($request, function (Request $incoming) use ($portal): Response {
                self::assertSame($portal.'-session', $incoming->cookie('mp_access'));
                self::assertSame($portal.'-refresh', $incoming->cookie('mp_refresh'));
                self::assertSame($portal.'-mfa', $incoming->cookie('mp_mfa_challenge'));
                self::assertSame($portal.'-csrf', $incoming->cookie('mp_csrf'));
                $response = new Response;
                $response->headers->setCookie((new AuthCookieFactory)->forget('mp_access'));

                return $response;
            });
            $cookies = $response->headers->getCookies();
            self::assertCount(1, $cookies);
            self::assertSame('mp_access_'.$portal, $cookies[0]->getName());
            self::assertTrue($cookies[0]->isHttpOnly());
        }
    }

    public function test_a_missing_portal_cookie_never_falls_back_to_the_other_or_legacy_session(): void
    {
        config()->set('app.admin_frontend_url', 'http://localhost:5174');
        $request = Request::create('/api/v1/admin/vendor-verification', 'GET', cookies: [
            'mp_access' => 'legacy', 'mp_access_vendor' => 'vendor-session',
        ], server: ['HTTP_ORIGIN' => 'http://localhost:5174']);
        (new IsolatePortalCookies)->handle($request, function (Request $incoming): Response {
            self::assertNull($incoming->cookie('mp_access'));

            return new Response;
        });
    }

    public function test_browser_csrf_bootstrap_emits_separate_cookie_names(): void
    {
        config()->set('app.vendor_frontend_url', 'http://localhost:5173');
        config()->set('app.admin_frontend_url', 'http://localhost:5174');
        $this->withHeader('Origin', 'http://localhost:5173')->getJson('/api/v1/auth/csrf')
            ->assertOk()->assertCookie('mp_csrf_vendor')->assertCookieMissing('mp_csrf_admin')->assertCookieMissing('mp_csrf');
        $this->withHeader('Origin', 'http://localhost:5174')->getJson('/api/v1/auth/csrf')
            ->assertOk()->assertCookie('mp_csrf_admin')->assertCookieMissing('mp_csrf_vendor')->assertCookieMissing('mp_csrf');
    }
}
