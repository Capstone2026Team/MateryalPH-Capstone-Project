<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use Closure;
use Illuminate\Http\Request;
use Symfony\Component\HttpFoundation\Response;

final class VerifyAccountCsrf
{
    public function handle(Request $request, Closure $next): Response
    {
        return $request->isMethodSafe() ? $next($request) : app(VerifyWebCsrf::class)->handle($request, $next);
    }
}
