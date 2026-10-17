<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\AcceptAdminInvitation;
use App\Domain\Identity\BotProtectionService;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\Controllers\Controller;
use App\Http\Requests\Auth\AcceptAdminInvitationRequest;
use Illuminate\Http\JsonResponse;

final class AcceptAdminInvitationController extends Controller
{
    public function __invoke(
        AcceptAdminInvitationRequest $request,
        AcceptAdminInvitation $accept,
        BotProtectionService $botProtection,
        AuthCookieFactory $cookies,
    ): JsonResponse {
        $input = $request->validated();
        // Validate recipient and current inviter authority before a provider call or email delivery.
        // Acceptance rechecks availability in its transaction after bot verification.
        $invitation = $accept->assertInvitationAvailable($input['token'], $input['email'] ?? null);
        $usedProof = $botProtection->guard($request, $invitation->normalized_email, 'ADMIN', 'INVITATION_ACCEPT', $input['bot_protection'] ?? null, null, true);
        $user = $accept->handle(
            (string) $request->validated('token'),
            (string) $request->validated('full_name'),
            (string) $request->validated('password'),
        );

        $response = ApiResponse::success(['user_id' => $user->public_id, 'next' => 'SIGN_IN_AND_ENROLL_MFA'], status: 201);

        return $usedProof ? $response->withCookie($cookies->forgetBotProof()) : $response;
    }
}
