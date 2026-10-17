<?php

use App\Http\Controllers\Api\VendorOnboardingController;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

Route::prefix('vendors/onboarding')->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:VENDOR',
])->group(function (): void {
    Route::get('/requirements', [VendorOnboardingController::class, 'previewRequirements']);
    Route::get('/', [VendorOnboardingController::class, 'snapshot']);
    Route::patch('/verification', [VendorOnboardingController::class, 'draftVerification']);
    Route::post('/verification/submit', [VendorOnboardingController::class, 'submitVerification']);
    Route::post('/verification/commission', [VendorOnboardingController::class, 'acceptCommission']);
    Route::patch('/setup', [VendorOnboardingController::class, 'draftSetup']);
    Route::post('/setup/complete', [VendorOnboardingController::class, 'completeSetup']);
    Route::post('/welcome/dismiss', [VendorOnboardingController::class, 'dismissWelcome']);
    Route::get('/address/areas', [VendorOnboardingController::class, 'addressAreas']);
    Route::post('/address/pin', [VendorOnboardingController::class, 'resolvePin']);
    Route::post('/address/resolve', [VendorOnboardingController::class, 'resolveAddress']);
    Route::post('/address/geocode', [VendorOnboardingController::class, 'geocode']);
    Route::post('/store-email', [VendorOnboardingController::class, 'requestStoreEmailVerification'])->middleware('throttle:account-security');
    Route::post('/store-email/confirm', [VendorOnboardingController::class, 'confirmStoreEmailVerification'])->middleware('throttle:account-security');
    Route::delete('/documents/pending/{requirementKey}', [VendorOnboardingController::class, 'removePendingDocument']);
    Route::post('/documents', [VendorOnboardingController::class, 'uploadDocument']);
    Route::post('/media', [VendorOnboardingController::class, 'uploadMedia']);
    Route::delete('/media/{mediaId}', [VendorOnboardingController::class, 'removeMedia'])->whereUuid('mediaId');
    Route::get('/files/{fileId}', [VendorOnboardingController::class, 'signedFile'])->whereUuid('fileId');
    Route::post('/payment-connection', [VendorOnboardingController::class, 'connectPayment']);
    Route::post('/payment-connection/reconcile', [VendorOnboardingController::class, 'reconcilePaymentConnection']);
    Route::post('/activation', [VendorOnboardingController::class, 'activate']);
});

Route::get('vendor/onboarding', [VendorOnboardingController::class, 'snapshot'])->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:VENDOR',
]);
