<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Identity\DeleteBuyerAccount;
use App\Domain\Identity\ManageBuyerTwoFactor;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Http\Requests\Account\AccountRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/** Buyer-only security self-service: optional authenticator 2FA and account deletion. */
final class BuyerAccountSecurityController extends Controller
{
    public function startTwoFactor(AccountRequest $request, ManageBuyerTwoFactor $twoFactor): JsonResponse
    {
        return ApiResponse::success($twoFactor->start($request));
    }

    public function confirmTwoFactor(AccountRequest $request, ManageBuyerTwoFactor $twoFactor): JsonResponse
    {
        return ApiResponse::success(['recovery_codes' => $twoFactor->confirm($request, (string) $request->validated('code')), 'sign_in_required' => false]);
    }

    public function disableTwoFactor(AccountRequest $request, ManageBuyerTwoFactor $twoFactor): JsonResponse
    {
        $twoFactor->disable($request, $request->validated('code'), $request->validated('recovery_code'));

        return ApiResponse::success(['changed' => true]);
    }

    public function deletionPreview(Request $request, DeleteBuyerAccount $deletion): JsonResponse
    {
        return ApiResponse::success($deletion->preview($request));
    }

    public function deleteAccount(AccountRequest $request, DeleteBuyerAccount $deletion): JsonResponse
    {
        return ApiResponse::success($deletion->delete($request));
    }
}
