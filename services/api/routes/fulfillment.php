<?php

use App\Http\Controllers\Api\AdminOrderOperationsController;
use App\Http\Controllers\Api\BuyerFulfillmentController;
use App\Http\Controllers\Api\VendorFulfillmentController;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

// Phase 12 Buyer fulfillment, receipt, problem reports and cancellation: native bearer, Buyer-only, own orders only.
Route::prefix('buyers/orders/{orderId}')->whereUuid('orderId')->middleware(['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER', 'throttle:account'])->group(function (): void {
    Route::get('/cancellation-preview', [BuyerFulfillmentController::class, 'cancellationPreview']);
    Route::post('/cancel', [BuyerFulfillmentController::class, 'cancel']);
    Route::post('/cancellation-request/withdraw', [BuyerFulfillmentController::class, 'withdrawRequest']);
    Route::post('/receipt/confirm', [BuyerFulfillmentController::class, 'confirmReceipt']);
    Route::post('/problems', [BuyerFulfillmentController::class, 'reportProblem'])->middleware('throttle:account-upload');
    Route::post('/problems/{issueId}/resolve', [BuyerFulfillmentController::class, 'resolveProblem'])->whereUuid('issueId');
    Route::post('/reimbursements/{reimbursementId}/acknowledge', [BuyerFulfillmentController::class, 'acknowledgeReimbursement'])->whereUuid('reimbursementId');
    Route::get('/files/{fileId}', [BuyerFulfillmentController::class, 'file'])->whereUuid('fileId');
});

// Phase 12 Vendor fulfillment workspace: web cookies with CSRF; role and assignment scope enforced in the domain.
Route::prefix('vendor/orders/{orderId}')->whereUuid('orderId')->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:VENDOR', 'throttle:account',
])->group(function (): void {
    Route::get('/fulfillment/assignees', [VendorFulfillmentController::class, 'assignees']);
    Route::post('/fulfillment/assignment', [VendorFulfillmentController::class, 'assign']);
    Route::post('/fulfillment/milestones', [VendorFulfillmentController::class, 'milestone'])->middleware('throttle:account-upload');
    Route::post('/fulfillment/trips', [VendorFulfillmentController::class, 'trip']);
    Route::post('/fulfillment/vehicle-issues', [VendorFulfillmentController::class, 'vehicleIssue']);
    Route::post('/problems/{issueId}/respond', [VendorFulfillmentController::class, 'respondProblem'])->whereUuid('issueId');
    Route::get('/cancellation-preview', [VendorFulfillmentController::class, 'cancellationPreview']);
    Route::post('/cancel', [VendorFulfillmentController::class, 'cancel']);
    Route::post('/cancellation-request/finalize', [VendorFulfillmentController::class, 'finalizeCancellation'])->middleware('throttle:account-upload');
    Route::post('/refunds/{refundId}/retry', [VendorFulfillmentController::class, 'retryRefund'])->whereUuid('refundId');
    Route::post('/reimbursements/{reimbursementId}', [VendorFulfillmentController::class, 'recordReimbursement'])->whereUuid('reimbursementId')->middleware('throttle:account-upload');
    Route::get('/files/{fileId}', [VendorFulfillmentController::class, 'file'])->whereUuid('fileId');
});

// Phase 12 Admin order operations: invitation-only Admin web transport; permissions checked in the domain.
Route::prefix('admin/order-operations')->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:ADMIN', 'throttle:account',
])->group(function (): void {
    Route::get('/summary', [AdminOrderOperationsController::class, 'summary']);
    Route::get('/refunds', [AdminOrderOperationsController::class, 'refunds']);
    Route::post('/refunds/{refundId}/retry', [AdminOrderOperationsController::class, 'retryRefund'])->whereUuid('refundId')->middleware('throttle:account-security');
    Route::get('/reimbursements', [AdminOrderOperationsController::class, 'reimbursements']);
    Route::post('/reimbursements/{reimbursementId}/confirm', [AdminOrderOperationsController::class, 'decideReimbursement'])->whereUuid('reimbursementId')->middleware('throttle:account-security');
    Route::get('/cancellation-requests', [AdminOrderOperationsController::class, 'cancellationRequests']);
});
