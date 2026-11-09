<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Identity\DeleteVendorAccount;
use App\Http\ApiResponse;
use App\Http\AuthCookieFactory;
use App\Http\Controllers\Controller;
use App\Http\Requests\Account\AccountRequest;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

final class VendorAccountDeletionController extends Controller
{
    public function preview(Request $request, DeleteVendorAccount $deletion): JsonResponse
    {
        return ApiResponse::success($deletion->preview($request));
    }

    public function deleteAccount(AccountRequest $request, DeleteVendorAccount $deletion, AuthCookieFactory $cookies): JsonResponse
    {
        return ApiResponse::success($deletion->delete($request))
            ->withCookie($cookies->forget('mp_access'))
            ->withCookie($cookies->forget('mp_refresh', '/api/v1/auth'));
    }
}
