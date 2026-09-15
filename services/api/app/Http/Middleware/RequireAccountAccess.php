<?php

declare(strict_types=1);

namespace App\Http\Middleware;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\MfaChallengeService;
use App\Domain\Identity\TotpService;
use App\Http\AuthTransport;
use App\Models\AuthSession;
use Closure;
use Illuminate\Http\Request;
use Laravel\Passport\AccessToken;
use Symfony\Component\HttpFoundation\Response;

final class RequireAccountAccess
{
    public function __construct(private readonly AccountAccess $access, private readonly MfaChallengeService $mfa, private readonly TotpService $totp) {}

    public function handle(Request $request, Closure $next, ?string $portal = null): Response
    {
        $user = $request->user();
        $token = $user?->currentAccessToken();
        if ($user === null || ! $token instanceof AccessToken) {
            throw new AuthenticationException('UNAUTHENTICATED', 'Sign in to continue.', 401);
        }
        if (($portal !== null && $user->account_type !== $portal) || ! $token->can($user->account_type)) {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot access this portal.', 403);
        }
        $session = AuthSession::query()->where('user_id', $user->getKey())->where('oauth_access_token_id', $token->oauth_access_token_id)
            ->whereNull('revoked_at')->where('expires_at', '>', now())->first();
        if ($session === null || $session->client_kind !== AuthTransport::fromRequest($request)->value) {
            throw new AuthenticationException('SESSION_EXPIRED', 'Your session has expired. Sign in again.', 401);
        }
        $scope = $this->access->resolve($user);
        if ($this->mfa->requiredFor($user) && ! $this->totp->hasConfirmedFactor($user)) {
            throw new AuthenticationException('MFA_REQUIRED', 'Sign in and complete authenticator verification.', 403);
        }
        $request->attributes->set('account_scope', $scope);
        $request->attributes->set('auth_session', $session);
        $session->update(['last_used_at' => now()]);
        $response = $next($request);
        $response->headers->set('Cache-Control', 'no-store, private');

        return $response;
    }
}
