<?php

use App\Http\Controllers\Api\AdminVendorVerificationController;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

Route::prefix('admin/vendor-verification')->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:ADMIN', 'throttle:account',
])->group(function (): void {
    Route::get('/', [AdminVendorVerificationController::class, 'queue']);
    Route::get('/{organizationId}', [AdminVendorVerificationController::class, 'detail'])->whereUuid('organizationId');
    Route::post('/{organizationId}/requirements/{requirementKey}/decision', [AdminVendorVerificationController::class, 'decide'])->whereUuid('organizationId')->where('requirementKey', '[A-Za-z0-9_-]+')->middleware('throttle:account-security');
    Route::get('/files/{fileId}', [AdminVendorVerificationController::class, 'signedFile'])->whereUuid('fileId');
    Route::post('/{organizationId}/restrict', [AdminVendorVerificationController::class, 'restrict'])->whereUuid('organizationId')->middleware('throttle:account-security');
    Route::post('/{organizationId}/restore', [AdminVendorVerificationController::class, 'restore'])->whereUuid('organizationId')->middleware('throttle:account-security');
});
