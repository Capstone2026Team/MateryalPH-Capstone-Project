<?php

use App\Http\Controllers\Api\BuyerOrderController;
use App\Http\Controllers\Api\VendorOrderController;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

// Phase 8 Buyer orders: native bearer transport, Buyer-only. Retry-sensitive mutations require Idempotency-Key.
Route::prefix('buyers')->middleware(['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER', 'throttle:account'])->group(function (): void {
    Route::post('/checkouts', [BuyerOrderController::class, 'submit'])->middleware('throttle:buyer-route');
    Route::get('/checkouts/{checkoutId}', [BuyerOrderController::class, 'checkout'])->whereUuid('checkoutId');
    Route::get('/orders', [BuyerOrderController::class, 'index']);
    Route::get('/orders/{orderId}', [BuyerOrderController::class, 'show'])->whereUuid('orderId');
    Route::post('/orders/{orderId}/revision/approve', [BuyerOrderController::class, 'approveRevision'])->whereUuid('orderId');
    Route::post('/orders/{orderId}/revision/reject', [BuyerOrderController::class, 'rejectRevision'])->whereUuid('orderId');
    Route::post('/orders/{orderId}/nrpc/accept', [BuyerOrderController::class, 'acceptNrpc'])->whereUuid('orderId');
    Route::post('/orders/{orderId}/nrpc/reject', [BuyerOrderController::class, 'rejectNrpc'])->whereUuid('orderId');
    Route::post('/orders/{orderId}/nrpc/flag', [BuyerOrderController::class, 'flagNrpc'])->whereUuid('orderId');
});

// Phase 8 Vendor orders: web cookie transport with CSRF, Vendor-only; role authority is enforced in the domain.
Route::prefix('vendor')->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:VENDOR', 'throttle:account',
])->group(function (): void {
    Route::get('/orders', [VendorOrderController::class, 'index']);
    Route::get('/orders/{orderId}', [VendorOrderController::class, 'show'])->whereUuid('orderId');
    Route::post('/orders/{orderId}/delivery-recommendations', [VendorOrderController::class, 'deliveryPlan'])->whereUuid('orderId')->middleware('throttle:buyer-route');
    Route::post('/orders/{orderId}/confirm', [VendorOrderController::class, 'confirm'])->whereUuid('orderId');
    Route::post('/orders/{orderId}/decline', [VendorOrderController::class, 'decline'])->whereUuid('orderId');
});
