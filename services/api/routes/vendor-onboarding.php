<?php

use App\Http\Controllers\Api\VendorOnboardingController;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

Route::prefix('vendors/onboarding')->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:VENDOR', 'throttle:account',
])->group(function (): void {
    Route::get('/', [VendorOnboardingController::class, 'snapshot']);
    Route::patch('/verification', [VendorOnboardingController::class, 'draftVerification']);
    Route::post('/verification/submit', [VendorOnboardingController::class, 'submitVerification'])->middleware('throttle:account-security');
    Route::patch('/setup', [VendorOnboardingController::class, 'draftSetup']);
    Route::post('/setup/complete', [VendorOnboardingController::class, 'completeSetup'])->middleware('throttle:account-security');
    Route::post('/welcome/dismiss', [VendorOnboardingController::class, 'dismissWelcome']);
    Route::post('/address/geocode', [VendorOnboardingController::class, 'geocode'])->middleware('throttle:auth-public');
    Route::post('/store-email', [VendorOnboardingController::class, 'requestStoreEmailVerification'])->middleware('throttle:account-security');
    Route::post('/store-email/confirm', [VendorOnboardingController::class, 'confirmStoreEmailVerification'])->middleware('throttle:account-security');
    Route::post('/documents', [VendorOnboardingController::class, 'uploadDocument'])->middleware('throttle:account-security');
    Route::post('/media', [VendorOnboardingController::class, 'uploadMedia'])->middleware('throttle:account-security');
    Route::get('/files/{fileId}', [VendorOnboardingController::class, 'signedFile'])->whereUuid('fileId');
    Route::post('/payment-connection', [VendorOnboardingController::class, 'capturePaymentConnection'])->middleware('throttle:account-security');
    Route::post('/payment-connection/reconcile', [VendorOnboardingController::class, 'reconcilePaymentConnection'])->middleware('throttle:account-security');
    Route::post('/activation', [VendorOnboardingController::class, 'activate'])->middleware('throttle:account-security');
});
