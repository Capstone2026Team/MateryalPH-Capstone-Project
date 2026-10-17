<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\AcceptVendorInvitation;
use App\Domain\Identity\BotProtectionService;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\AcceptVendorInvitationRequest;
use Illuminate\Http\JsonResponse;

final class AcceptVendorInvitationController extends Controller
{
    public function __invoke(
        AcceptVendorInvitationRequest $request,
        AcceptVendorInvitation $accept,
        BotProtectionService $botProtection,
        AuthCookieFactory $cookies,
    ): JsonResponse {
        $input = $request->validated();
        $accept->assertInvitationAvailable($input['token'], $input['email']);
        $usedProof = $botProtection->guard($request, $input['email'], 'VENDOR', 'INVITATION_ACCEPT', $input['bot_protection'] ?? null, null, true);
        $accept->handle($request, $input['token'], $input['email'], $input['full_name'], $input['password']);

        $response = ApiResponse::success(['next' => 'VERIFY_EMAIL_AND_SIGN_IN'], status: 201);

        return $usedProof ? $response->withCookie($cookies->forgetBotProof()) : $response;
    }
}
