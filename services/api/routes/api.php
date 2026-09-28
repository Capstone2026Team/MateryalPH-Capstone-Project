<?php

use App\Http\Controllers\Api\AgreementController;
use App\Http\Controllers\Api\Auth\AcceptAdminInvitationController;
use App\Http\Controllers\Api\Auth\AcceptVendorInvitationController;
use App\Http\Controllers\Api\Auth\BotChallengeController;
use App\Http\Controllers\Api\Auth\CsrfController;
use App\Http\Controllers\Api\Auth\GoogleOidcController;
use App\Http\Controllers\Api\Auth\LoginController;
use App\Http\Controllers\Api\Auth\LogoutController;
use App\Http\Controllers\Api\Auth\MfaController;
use App\Http\Controllers\Api\Auth\PasswordRecoveryController;
use App\Http\Controllers\Api\Auth\RefreshController;
use App\Http\Controllers\Api\Auth\RegisterController;
use App\Http\Controllers\Api\Auth\ResendVerificationController;
use App\Http\Controllers\Api\Auth\SessionController;
use App\Http\Controllers\Api\Auth\VerifyEmailController;
use App\Http\Controllers\Api\HealthController;
use App\Http\Controllers\Api\PublicStoreProfileController;
use App\Http\Controllers\Api\XenditAccountVerificationWebhookController;
use Illuminate\Support\Facades\Route;

Route::get('/health', HealthController::class);
Route::get('/stores', [PublicStoreProfileController::class, 'index'])->middleware('throttle:public-store');
Route::get('/stores/{storeId}/profile', PublicStoreProfileController::class)->whereUuid('storeId')->middleware('throttle:public-store');
Route::get('/agreements/current', AgreementController::class);

require __DIR__.'/account.php';
require __DIR__.'/vendor-onboarding.php';
require __DIR__.'/admin-vendor-verification.php';
require __DIR__.'/vendor-private-files.php';
require __DIR__.'/catalog.php';
require __DIR__.'/inventory.php';
require __DIR__.'/buyer.php';

Route::post('/webhooks/xendit/account-verification', XenditAccountVerificationWebhookController::class)->middleware('throttle:provider-webhook');

Route::prefix('auth')->middleware('auth.transport:WEB')->group(function (): void {
    Route::get('/csrf', CsrfController::class)->middleware('throttle:auth-csrf');
    Route::get('/google/callback', [GoogleOidcController::class, 'callback'])->middleware('throttle:auth-public');
    Route::post('/login', LoginController::class)->middleware('web.csrf');
    Route::middleware(['web.csrf', 'throttle:auth-public'])->group(function (): void {
        Route::post('/admin-invitations/accept', AcceptAdminInvitationController::class);
        Route::post('/vendor-invitations/accept', AcceptVendorInvitationController::class);
        Route::post('/verify-email', VerifyEmailController::class);
        Route::post('/verify-email/resend', ResendVerificationController::class);
        Route::post('/google/start', [GoogleOidcController::class, 'start']);
        Route::post('/password/forgot', [PasswordRecoveryController::class, 'request']);
        Route::post('/password/reset', [PasswordRecoveryController::class, 'reset']);
        Route::post('/bot-challenges/{challengeId}/verify', [BotChallengeController::class, 'verify']);
        Route::post('/bot-challenges/{challengeId}/resend', [BotChallengeController::class, 'resend']);
    });
    Route::post('/register', RegisterController::class)->middleware(['web.csrf', 'throttle:auth-registration']);
    Route::post('/refresh', RefreshController::class)->middleware(['web.csrf', 'throttle:auth-refresh']);
    Route::prefix('mfa')->group(function (): void {
        Route::get('/status', [MfaController::class, 'status'])->middleware('throttle:auth-public');
        Route::middleware(['web.csrf', 'throttle:auth-public'])->group(function (): void {
            Route::post('/enrollment', [MfaController::class, 'enroll']);
            Route::post('/enrollment/confirm', [MfaController::class, 'confirm']);
            Route::post('/challenge', [MfaController::class, 'challenge']);
            Route::post('/recovery', [MfaController::class, 'recover']);
        });
    });
    Route::middleware(['auth.cookie', 'auth:api'])->group(function (): void {
        Route::get('/session', SessionController::class)->middleware('account.access');
        Route::post('/logout', LogoutController::class)->middleware('web.csrf');
    });
});

Route::prefix('mobile/auth')->middleware('auth.transport:MOBILE')->group(function (): void {
    Route::post('/login', LoginController::class);
    Route::middleware('throttle:auth-public')->group(function (): void {
        Route::post('/verify-email', VerifyEmailController::class);
        Route::post('/verify-email/resend', ResendVerificationController::class);
        Route::post('/google/start', [GoogleOidcController::class, 'start']);
        Route::post('/google/exchange', [GoogleOidcController::class, 'exchangeMobile']);
        Route::post('/password/forgot', [PasswordRecoveryController::class, 'request']);
        Route::post('/password/reset', [PasswordRecoveryController::class, 'reset']);
        Route::post('/bot-challenges/{challengeId}/verify', [BotChallengeController::class, 'verify']);
        Route::post('/bot-challenges/{challengeId}/resend', [BotChallengeController::class, 'resend']);
    });
    Route::post('/register', RegisterController::class)->middleware('throttle:auth-registration');
    Route::post('/refresh', RefreshController::class)->middleware('throttle:auth-refresh');
    Route::middleware('auth:api')->group(function (): void {
        Route::get('/session', SessionController::class)->middleware('account.access:BUYER');
        Route::post('/logout', LogoutController::class);
    });
});
