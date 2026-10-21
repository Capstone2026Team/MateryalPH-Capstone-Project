<?php

declare(strict_types=1);

namespace Tests\Unit;

use Illuminate\Config\Repository;
use Illuminate\Contracts\Http\Kernel;
use Illuminate\Http\Middleware\TrustProxies;
use Illuminate\Http\Request;
use Illuminate\Routing\Route;
use Illuminate\Routing\RouteCollection;
use Illuminate\Routing\UrlGenerator;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\Attributes\PreserveGlobalState;
use PHPUnit\Framework\Attributes\RunInSeparateProcess;
use PHPUnit\Framework\TestCase;
use Symfony\Component\HttpFoundation\Response;

/** Exercises the real bootstrap proxy configuration without a database or network. */
final class TrustedProxyConfigurationTest extends TestCase
{
    /** @return iterable<string, array{string, string, bool}> */
    public static function proxies(): iterable
    {
        yield 'platform wildcard' => ['*', '10.20.30.40', true];
        yield 'alternate platform wildcard' => ['**', '10.20.30.40', true];
        yield 'calling proxy' => ['REMOTE_ADDR', '10.20.30.40', true];
        yield 'explicit proxy list' => [' 192.0.2.1, 10.20.30.0/24 ', '10.20.30.40', true];
        yield 'untrusted caller' => ['192.0.2.1', '10.20.30.40', false];
        yield 'no configured proxies' => ['', '10.20.30.40', false];
    }

    #[DataProvider('proxies')]
    #[RunInSeparateProcess]
    #[PreserveGlobalState(false)]
    public function test_photo_urls_use_forwarded_https_only_from_configured_proxies(string $configured, string $remote, bool $trusted): void
    {
        putenv('TRUSTED_PROXIES='.$configured);
        $_ENV['TRUSTED_PROXIES'] = $_SERVER['TRUSTED_PROXIES'] = $configured;
        $app = require dirname(__DIR__, 2).'/bootstrap/app.php';
        $app->make(Kernel::class);
        $app->instance('config', new Repository);
        $request = Request::create('http://internal.example.test/api/v1/vendors/account/profile', server: [
            'REMOTE_ADDR' => $remote,
            'HTTP_X_FORWARDED_HOST' => 'vendor.example.test',
            'HTTP_X_FORWARDED_PROTO' => 'https',
            'HTTP_X_FORWARDED_PORT' => '443',
        ]);

        (new TrustProxies)->handle($request, function (Request $request) use ($trusted): Response {
            self::assertSame($trusted, $request->isSecure());
            $routes = new RouteCollection;
            $routes->add((new Route('GET', 'api/v1/vendors/account/photo', static fn () => null))->name('photo'));
            $urls = new UrlGenerator($routes, $request);
            $urls->setKeyResolver(static fn (): string => 'synthetic-signing-key-for-proxy-test');
            $photo = $urls->temporarySignedRoute('photo', time() + 300, ['owner' => 'fixture', 'version' => 2]);
            self::assertStringStartsWith($trusted ? 'https://vendor.example.test/' : 'http://internal.example.test/', $photo);
            self::assertTrue($urls->hasValidSignature(Request::create($photo)));
            self::assertFalse($urls->hasValidSignature(Request::create(str_replace('version=2', 'version=3', $photo))));

            return new Response;
        });
    }
}
