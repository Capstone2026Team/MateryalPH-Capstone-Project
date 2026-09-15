<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api\Auth;

use App\Domain\Identity\AcceptVendorInvitation;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Validation\Rules\Password;

final class AcceptVendorInvitationController extends Controller
{
    public function __invoke(Request $request, AcceptVendorInvitation $accept): JsonResponse
    {
        $input = $request->validate([
            'token' => ['required', 'string', 'max:256'], 'email' => ['required', 'email:rfc', 'max:254'],
            'full_name' => ['required', 'string', 'max:160'], 'password' => ['required', 'confirmed', Password::min(14)->mixedCase()->numbers()],
            'role' => ['prohibited'], 'organization_id' => ['prohibited'], 'can_manage_staff' => ['prohibited'], 'account_type' => ['prohibited'],
        ]);
        $accept->handle($request, $input['token'], $input['email'], $input['full_name'], $input['password']);

        return ApiResponse::success(['next' => 'VERIFY_EMAIL_AND_SIGN_IN'], status: 201);
    }
}
