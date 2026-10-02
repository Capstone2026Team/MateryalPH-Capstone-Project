<?php

use App\Http\Controllers\Api\AdminFinanceController;
use App\Http\Controllers\Api\BuyerPaymentController;
use App\Http\Controllers\Api\PaymentReturnController;
use App\Http\Controllers\Api\PaymentWebhookController;
use App\Http\Controllers\Api\VendorFinanceController;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

// Phase 11 Xendit payment inbox: token-verified, stored once, acknowledged, processed asynchronously.
Route::post('/webhooks/xendit', PaymentWebhookController::class)->middleware('throttle:payment-webhook');
// Browser return from the hosted payment page. Always Pending; never reads or changes payment state.
Route::get('/payments/return', PaymentReturnController::class)->middleware('throttle:public-store');

Route::prefix('buyers')->middleware(['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER', 'throttle:account'])->group(function (): void {
    Route::get('/orders/{orderId}/payment-options', [BuyerPaymentController::class, 'options'])->whereUuid('orderId');
    Route::post('/orders/{orderId}/payments', [BuyerPaymentController::class, 'create'])->whereUuid('orderId')->middleware('throttle:payment-create');
    Route::get('/payments/{paymentId}', [BuyerPaymentController::class, 'show'])->whereUuid('paymentId');
    Route::post('/payments/{paymentId}/refresh', [BuyerPaymentController::class, 'refresh'])->whereUuid('paymentId')->middleware('throttle:payment-create');
    Route::post('/orders/{orderId}/physical-payments/{recordId}/acknowledge', [BuyerPaymentController::class, 'acknowledgePhysical'])->whereUuid('orderId')->whereUuid('recordId');
});

Route::prefix('vendor')->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:VENDOR', 'throttle:account',
])->group(function (): void {
    Route::get('/finance', [VendorFinanceController::class, 'overview']);
    Route::put('/finance/physical-payments', [VendorFinanceController::class, 'updatePhysicalPayments']);
    Route::get('/finance/transactions', [VendorFinanceController::class, 'transactions']);
    Route::get('/finance/transactions/export', [VendorFinanceController::class, 'export']);
    Route::get('/finance/earnings', [VendorFinanceController::class, 'earnings']);
    Route::get('/finance/statements/{statementId}', [VendorFinanceController::class, 'statement'])->whereUuid('statementId');
    Route::post('/finance/statements/{statementId}/payments', [VendorFinanceController::class, 'payStatement'])->whereUuid('statementId')->middleware('throttle:payment-create');
    Route::get('/finance/payments/{paymentId}', [VendorFinanceController::class, 'payment'])->whereUuid('paymentId');
    Route::post('/finance/payments/{paymentId}/refresh', [VendorFinanceController::class, 'refreshPayment'])->whereUuid('paymentId')->middleware('throttle:payment-create');
    Route::post('/orders/{orderId}/physical-payments', [VendorFinanceController::class, 'recordPhysical'])->whereUuid('orderId');
    Route::post('/orders/{orderId}/online-balance/approve', [VendorFinanceController::class, 'approveOnlineBalance'])->whereUuid('orderId');
});

Route::prefix('admin/finance')->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:ADMIN', 'throttle:account',
])->group(function (): void {
    Route::get('/payments', [AdminFinanceController::class, 'payments']);
    Route::get('/review-items', [AdminFinanceController::class, 'reviewItems']);
    Route::post('/review-items/{itemId}/resolve', [AdminFinanceController::class, 'resolveItem'])->whereUuid('itemId')->middleware('throttle:account-security');
    Route::get('/withholding-accumulators', [AdminFinanceController::class, 'accumulators']);
    Route::get('/withholding-accumulators/{accumulatorId}', [AdminFinanceController::class, 'accumulator'])->whereUuid('accumulatorId');
    Route::post('/withholding-accumulators/{accumulatorId}/overlap', [AdminFinanceController::class, 'resolveOverlap'])->whereUuid('accumulatorId')->middleware('throttle:account-security');
    Route::get('/statements', [AdminFinanceController::class, 'statements']);
    Route::post('/statements/draft', [AdminFinanceController::class, 'draftStatements'])->middleware('throttle:account-security');
    Route::post('/statements/{statementId}/approve', [AdminFinanceController::class, 'approveStatement'])->whereUuid('statementId')->middleware('throttle:account-security');
    Route::post('/fee-credits', [AdminFinanceController::class, 'proposeFeeCredit'])->middleware('throttle:account-security');
    Route::post('/fee-credits/{proposalId}/approve', [AdminFinanceController::class, 'approveFeeCredit'])->whereUuid('proposalId')->middleware('throttle:account-security');
    Route::get('/channel-fees', [AdminFinanceController::class, 'channelFees']);
    Route::post('/reconciliation/run', [AdminFinanceController::class, 'reconcile'])->middleware('throttle:account-security');
});
