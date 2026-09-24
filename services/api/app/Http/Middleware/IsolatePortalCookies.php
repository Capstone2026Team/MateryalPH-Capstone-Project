<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Cookie;
use Symfony\Component\HttpFoundation\Response;

/** Cookie namespaces select credentials only; account access still authorizes every request. */
final class IsolatePortalCookies
{
    private const NAMES = ['mp_access', 'mp_refresh', 'mp_csrf', 'mp_mfa_challenge', 'mp_bot_proof'];

    public function handle(Request $request, Closure $next): Response
    {
        if ($request->is('api/v1/mobile/*')) {
            return $next($request);
        }
        $portal = $this->portal($request);
        if ($portal === null) {
            return $next($request);
        }
        foreach (self::NAMES as $name) {
            $value = $request->cookies->get($name.'_'.$portal);
            $request->cookies->remove($name);
            if (is_string($value)) {
                $request->cookies->set($name, $value);
            }
        }
        $response = $next($request);
        foreach ($response->headers->getCookies() as $cookie) {
            if (! in_array($cookie->getName(), self::NAMES, true)) {
                continue;
            }
            $response->headers->removeCookie($cookie->getName(), $cookie->getPath(), $cookie->getDomain());
            $response->headers->setCookie(new Cookie(
                $cookie->getName().'_'.$portal, $cookie->getValue(), $cookie->getExpiresTime(),
                $cookie->getPath(), $cookie->getDomain(), $cookie->isSecure(), $cookie->isHttpOnly(),
                $cookie->isRaw(), $cookie->getSameSite(), $cookie->isPartitioned(),
            ));
        }

        return $response;
    }

    private function portal(Request $request): ?string
    {
        // Google web callback is Vendor-only; its Origin/Referer belongs to Google.
        if ($request->is('api/v1/auth/google/callback')) {
            return 'vendor';
        }
        $source = $request->header('Origin') ?? $request->header('Referer');
        if (! is_string($source)) {
            return null;
        }
        $origin = $this->origin($source);
        foreach (['vendor', 'admin'] as $portal) {
            $configured = $this->origin((string) config('app.'.$portal.'_frontend_url'));
            if ($origin !== null && $origin === $configured) {
                return $portal;
            }
        }

        return null;
    }

    private function origin(string $url): ?string
    {
        $parts = parse_url($url);
        if (! is_array($parts) || ! isset($parts['scheme'], $parts['host'])) {
            return null;
        }

        return strtolower($parts['scheme'].'://'.$parts['host']).':'.($parts['port'] ?? ($parts['scheme'] === 'https' ? 443 : 80));
    }
}
