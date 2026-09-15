<?php

use App\Http\Controllers\Api\AccountAdministrationController;
use App\Http\Controllers\Api\AccountController;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

foreach (['buyers' => ['BUYER', 'MOBILE'], 'vendors' => ['VENDOR', 'WEB'], 'admin' => ['ADMIN', 'WEB']] as $prefix => [$portal, $transport]) {
    $middleware = ['auth.transport:'.$transport];
    if ($transport === 'WEB') {
        $middleware = [...$middleware, 'auth.cookie', VerifyAccountCsrf::class];
    }
    Route::prefix($prefix.'/account')->middleware([...$middleware, 'auth:api', 'account.access:'.$portal, 'throttle:account'])->group(function () use ($portal): void {
        Route::get('/profile', [AccountController::class, 'profile']);
        Route::patch('/profile', [AccountController::class, 'updateProfile']);
        Route::get('/security', [AccountController::class, 'security']);
        Route::post('/reauthentication', [AccountController::class, 'reauthenticate'])->middleware('throttle:account-security');
        Route::post('/reauthentication/email', [AccountController::class, 'reauthenticationEmail'])->middleware('throttle:account-security');
        Route::get('/sessions', [AccountController::class, 'sessions']);
        Route::delete('/sessions/{sessionId}', [AccountController::class, 'revokeSession'])->whereUuid('sessionId');
        Route::post('/sessions/revoke', [AccountController::class, 'revokeSessions']);
        Route::post('/password', [AccountController::class, 'changePassword'])->middleware('throttle:account-security');
        Route::post('/email', [AccountController::class, 'startEmailChange'])->middleware('throttle:account-security');
        Route::post('/email/confirm', [AccountController::class, 'confirmEmailChange'])->middleware('throttle:account-security');
        Route::get('/agreements', [AccountController::class, 'agreements']);
        Route::post('/agreements', [AccountController::class, 'acceptAgreements']);
        if ($portal !== 'BUYER') {
            Route::post('/factor', [AccountController::class, 'startFactor'])->middleware('throttle:account-security');
            Route::post('/factor/confirm', [AccountController::class, 'confirmFactor'])->middleware('throttle:account-security');
            Route::post('/recovery-codes', [AccountController::class, 'recoveryCodes'])->middleware('throttle:account-security');
        }
        if ($portal === 'VENDOR') {
            Route::get('/memberships', [AccountAdministrationController::class, 'memberships']);
            Route::patch('/memberships/{membershipId}/delegation', [AccountAdministrationController::class, 'delegate'])->whereUuid('membershipId');
            Route::patch('/memberships/{membershipId}/status', [AccountAdministrationController::class, 'changeMembership'])->whereUuid('membershipId');
        }
        if ($portal === 'ADMIN') {
            Route::get('/administrators', [AccountAdministrationController::class, 'administrators']);
            Route::patch('/administrators/{publicId}', [AccountAdministrationController::class, 'changeAdmin'])->whereUuid('publicId');
            Route::get('/roles', [AccountAdministrationController::class, 'roles']);
            Route::post('/invitations', [AccountAdministrationController::class, 'inviteAdmin']);
        }
    });
}
