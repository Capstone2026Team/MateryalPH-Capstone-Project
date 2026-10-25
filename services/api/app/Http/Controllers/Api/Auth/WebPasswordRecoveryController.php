<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\RecoverWebPassword;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\CompleteWebPasswordRecoveryRequest;
use App\Http\Requests\Auth\VerifyWebPasswordRecoveryRequest;
use Illuminate\Http\JsonResponse;

final class WebPasswordRecoveryController extends Controller
{
    public function verify(VerifyWebPasswordRecoveryRequest $request, RecoverWebPassword $recovery, AuthCookieFactory $cookies): JsonResponse
    {
        $result = $recovery->verify($request, (string) $request->validated('portal'), (string) $request->validated('email'), $request->validated('code'), $request->validated('recovery_code'), $request->validated('challenge_id'));

        return ApiResponse::success([
            'verified' => true, 'expires_in' => $result['expires_in'], 'recovery_codes' => $result['recovery_codes'],
        ])->withCookie($cookies->passwordRecovery($result['token'], $result['expires_in']))
            ->header('Cache-Control', 'no-store, private');
    }

    public function reset(CompleteWebPasswordRecoveryRequest $request, RecoverWebPassword $recovery, AuthCookieFactory $cookies): JsonResponse
    {
        $recovery->reset($request, (string) $request->validated('portal'), (string) $request->validated('email'), (string) $request->cookie('mp_password_recovery', ''), (string) $request->validated('password'));

        return ApiResponse::success(['password_reset' => true, 'next' => 'SIGN_IN'])
            ->withCookie($cookies->forget('mp_password_recovery', '/api/v1/auth/password'))
            ->header('Cache-Control', 'no-store, private');
    }
}
