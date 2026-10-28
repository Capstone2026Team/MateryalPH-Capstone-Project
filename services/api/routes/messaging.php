<?php

use App\Http\Controllers\Api\ConversationController as C;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

foreach (['buyers' => ['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER'],
    'vendor' => ['auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:VENDOR']] as $prefix => $middleware) {
    Route::prefix($prefix)->middleware($middleware)->group(function () use ($prefix): void {
        Route::get('/messaging/realtime', [C::class, 'realtime']);
        Route::post('/messaging/auth', [C::class, 'authorizeChannel']);
        Route::get('/conversations', [C::class, 'index']);
        if ($prefix === 'vendor') {
            Route::post('/orders/{orderId}/conversation', [C::class, 'fromOrder'])->whereUuid('orderId');
        }
        if ($prefix === 'buyers') {
            Route::post('/conversations', [C::class, 'create']);
            Route::post('/site-inspections', [C::class, 'requestSiteInspection']);
        }
        Route::prefix('conversations/{conversationId}')->whereUuid('conversationId')->group(function () use ($prefix): void {
            Route::get('/', [C::class, 'show']);
            Route::get('/project-inquiries', [C::class, 'projectInquiries']);
            Route::post('/messages', [C::class, 'send']);
            Route::get('/products', [C::class, 'products']);
            Route::post('/typing', [C::class, 'typing']);
            Route::post('/read', [C::class, 'read']);
            if ($prefix === 'buyers') {
                Route::put('/destination', [C::class, 'destination']);
                Route::put('/archive', [C::class, 'archive']);
                Route::delete('/archive', [C::class, 'restore']);
            }
            Route::post('/attachments', [C::class, 'upload']);
            Route::get('/attachments/{attachmentId}', [C::class, 'download'])->whereUuid('attachmentId');
            Route::get('/avatars/{userId}', [C::class, 'avatar'])->whereNumber('userId');
            if ($prefix === 'vendor') {
                Route::get('/fulfillment-conversations', [C::class, 'fulfillmentConversations']);
                Route::get('/handlers', [C::class, 'handlers']);
                Route::post('/transfer', [C::class, 'transfer']);
                Route::put('/quotation/draft', [C::class, 'draft']);
                Route::post('/quotation/location', [C::class, 'quotationLocation']);
                Route::post('/quotation/delivery-plan', [C::class, 'quotationDeliveryPlan']);
                Route::post('/quotation/publish', [C::class, 'publish']);
                Route::post('/quotation/start', [C::class, 'startQuotation']);
            }
            Route::post('/quotation/{action}', [C::class, 'decision'])->whereIn('action', $prefix === 'buyers' ? ['view', 'accept', 'reject', 'counter'] : ['withdraw']);
            if ($prefix === 'buyers') {
                Route::post('/site-inspections/{inspectionId}/cancel', [C::class, 'cancelSiteInspection'])->whereUuid('inspectionId');
            } else {
                Route::post('/site-inspections/{inspectionId}/{action}', [C::class, 'decideSiteInspection'])->whereUuid('inspectionId')->whereIn('action', ['schedule', 'decline', 'complete']);
            }
        });
    });
}
