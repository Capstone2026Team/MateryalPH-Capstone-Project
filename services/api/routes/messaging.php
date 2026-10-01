<?php

use App\Http\Controllers\Api\ConversationController as C;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

foreach (['buyers' => ['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER', 'throttle:account'],
    'vendor' => ['auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:VENDOR', 'throttle:account']] as $prefix => $middleware) {
    Route::prefix($prefix)->middleware($middleware)->group(function () use ($prefix): void {
        Route::get('/messaging/realtime', [C::class, 'realtime']);
        Route::post('/messaging/auth', [C::class, 'authorizeChannel']);
        Route::get('/conversations', [C::class, 'index']);
        if ($prefix === 'buyers') {
            Route::post('/conversations', [C::class, 'create']);
        }
        Route::prefix('conversations/{conversationId}')->whereUuid('conversationId')->group(function () use ($prefix): void {
            Route::get('/', [C::class, 'show']);
            Route::post('/messages', [C::class, 'send']);
            Route::post('/read', [C::class, 'read']);
            Route::post('/attachments', [C::class, 'upload'])->middleware('throttle:account-upload');
            Route::get('/attachments/{attachmentId}', [C::class, 'download'])->whereUuid('attachmentId');
            Route::get('/avatars/{userId}', [C::class, 'avatar'])->whereNumber('userId');
            if ($prefix === 'vendor') {
                Route::get('/handlers', [C::class, 'handlers']);
                Route::post('/transfer', [C::class, 'transfer']);
                Route::put('/quotation/draft', [C::class, 'draft']);
                Route::post('/quotation/publish', [C::class, 'publish']);
            }
            Route::post('/quotation/{action}', [C::class, 'decision'])->whereIn('action', $prefix === 'buyers' ? ['view', 'accept', 'reject', 'counter'] : ['withdraw']);
        });
    });
}
