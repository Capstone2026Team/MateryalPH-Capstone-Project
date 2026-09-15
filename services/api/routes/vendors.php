<?php

use App\Http\Controllers\Api\VendorOnboardingController as Onboarding;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

Route::get('public/vendors/{organization}/store-media/{media}', [Onboarding::class, 'publicMedia'])->whereUuid(['organization', 'media'])->middleware('throttle:auth-public');

foreach (['vendors' => 'VENDOR', 'admin' => 'ADMIN'] as $prefix => $portal) {
    Route::prefix($prefix)->middleware(['auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:'.$portal, 'throttle:account'])->group(function () use ($prefix, $portal): void {
        if ($portal === 'ADMIN') {
            Route::get('vendor-verification', [Onboarding::class, 'queue']);
        }
        Route::prefix($portal === 'ADMIN' ? 'vendor-verification/{organization}' : '{organization}')->whereUuid('organization')->group(function () use ($prefix, $portal): void {
            Route::get('onboarding', [Onboarding::class, 'show']);
            Route::get('business', [Onboarding::class, 'business']);
            Route::get('store-media', [Onboarding::class, 'media']);
            Route::get('store-media/{media}', [Onboarding::class, 'previewMedia'])->whereUuid('media');
            Route::get('documents', [Onboarding::class, 'documents']);
            Route::get('tax-profile', [Onboarding::class, 'tax']);
            Route::post('documents/{version}/download-link', [Onboarding::class, 'link'])->whereUuid('version');
            Route::get('documents/{version}/download', [Onboarding::class, 'download'])->whereUuid('version')->name($prefix.'.evidence.download');
            if ($portal === 'VENDOR') {
                Route::post('store-media', [Onboarding::class, 'uploadMedia']);
                Route::post('store-media/{media}/remove', [Onboarding::class, 'removeMedia'])->whereUuid('media');
                Route::put('business', [Onboarding::class, 'saveBusiness']);
                Route::post('business/store-email/verification', [Onboarding::class, 'requestStoreEmailVerification']);
                Route::post('business/store-email/verification/confirm', [Onboarding::class, 'confirmStoreEmailVerification']);
                Route::post('documents', [Onboarding::class, 'upload']);
                Route::post('activation', [Onboarding::class, 'activate']);
                Route::post('tax-profile/versions', [Onboarding::class, 'saveTax']);
                Route::get('setup', [Onboarding::class, 'setup']);
                Route::put('store-profile', [Onboarding::class, 'saveStore']);
                Route::post('payment-connection', [Onboarding::class, 'connect']);
                Route::post('payment-connection/reconciliation', [Onboarding::class, 'reconcileConnection']);
                Route::get('commission-terms', [Onboarding::class, 'commission']);
                Route::post('commission-terms/acceptance', [Onboarding::class, 'acceptCommission']);
                Route::get('team', [Onboarding::class, 'team']);
                Route::get('team/invitations', [Onboarding::class, 'invitations']);
                Route::post('team/invitations', [Onboarding::class, 'invite']);
                Route::post('team/invitations/{invitation}/revoke', [Onboarding::class, 'revokeInvitation'])->whereUuid('invitation');
                Route::patch('team/memberships/{membership}', [Onboarding::class, 'changeMember'])->whereUuid('membership');
            } else {
                Route::post('store-media/{media}/reviews', [Onboarding::class, 'reviewMedia'])->whereUuid('media');
                Route::post('business/reviews', [Onboarding::class, 'reviewBusiness']);
                Route::post('documents/{version}/reviews', [Onboarding::class, 'reviewDocument'])->whereUuid('version');
                Route::post('tax-profile/versions/{version}/reviews', [Onboarding::class, 'reviewTax'])->whereUuid('version');
            }
        });
    });
}
