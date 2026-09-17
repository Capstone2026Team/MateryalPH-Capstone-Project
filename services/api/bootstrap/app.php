<?php

use App\Domain\Identity\AuthenticationException as IdentityAuthenticationException;
use App\Http\ApiResponse;
use App\Http\Middleware\AuthenticateFromCookie;
use App\Http\Middleware\CorrelationId;
use App\Http\Middleware\IsolatePortalCookies;
use App\Http\Middleware\RequireAccountAccess;
use App\Http\Middleware\SetAuthTransport;
use App\Http\Middleware\VerifyWebCsrf;
use Illuminate\Auth\AuthenticationException;
use Illuminate\Contracts\Auth\Middleware\AuthenticatesRequests;
use Illuminate\Foundation\Application;
use Illuminate\Foundation\Configuration\Exceptions;
use Illuminate\Foundation\Configuration\Middleware;
use Illuminate\Http\Request;
use Illuminate\Validation\ValidationException;
use Symfony\Component\HttpFoundation\Response;
use Symfony\Component\HttpKernel\Exception\HttpExceptionInterface;
use Throwable as BaseThrowable;

return Application::configure(basePath: dirname(__DIR__))
    ->withRouting(
        web: __DIR__.'/../routes/web.php',
        api: __DIR__.'/../routes/api.php',
        apiPrefix: 'api/v1',
        commands: __DIR__.'/../routes/console.php',
        health: '/up',
    )
    ->withMiddleware(function (Middleware $middleware): void {
        $middleware->redirectGuestsTo(static fn (Request $_request): ?string => null);
        $middleware->prependToGroup('api', [CorrelationId::class, IsolatePortalCookies::class]);
        $middleware->prependToPriorityList(AuthenticatesRequests::class, AuthenticateFromCookie::class);
        $middleware->alias([
            'auth.cookie' => AuthenticateFromCookie::class,
            'auth.transport' => SetAuthTransport::class,
            'web.csrf' => VerifyWebCsrf::class,
            'account.access' => RequireAccountAccess::class,
        ]);
    })
    ->withExceptions(function (Exceptions $exceptions): void {
        $exceptions->render(function (IdentityAuthenticationException $exception) {
            return ApiResponse::error(
                $exception->errorCode,
                $exception->getMessage(),
                $exception->httpStatus,
                $exception->details,
            );
        });
        $exceptions->render(function (ValidationException $exception, $request) {
            if ($request->is('api/*')) {
                return ApiResponse::error('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, $exception->errors());
            }
        });
        $exceptions->respond(function (Response $response, BaseThrowable $exception, Request $request): Response {
            return $exception instanceof AuthenticationException && $request->is('api/*')
                ? ApiResponse::error('UNAUTHENTICATED', 'Sign in to continue.', 401)
                : $response;
        });
        $exceptions->render(function (HttpExceptionInterface $exception, $request) {
            if ($request->is('api/*')) {
                if ($exception->getStatusCode() === 429) {
                    $seconds = max(1, (int) ($exception->getHeaders()['Retry-After'] ?? 60));

                    return ApiResponse::error('RATE_LIMITED', 'This action is temporarily limited. Please retry after the indicated wait.', 429, ['retry_after_seconds' => $seconds])
                        ->withHeaders($exception->getHeaders());
                }

                return ApiResponse::error('HTTP_ERROR', $exception->getMessage() ?: 'The request could not be completed.', $exception->getStatusCode())->withHeaders($exception->getHeaders());
            }
        });
        $exceptions->render(function (BaseThrowable $exception, $request) {
            if ($request->is('api/*')) {
                return ApiResponse::error('INTERNAL_ERROR', 'The request could not be completed.', 500);
            }
        });
    })->create();
