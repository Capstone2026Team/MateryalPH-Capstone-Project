<?php

use App\Http\Controllers\Api\AdminFinanceOperationsController as F;
use App\Http\Controllers\Api\AdminOperationsController as O;
use App\Http\Controllers\Api\AdminUserDirectoryController as U;
use App\Http\Controllers\Api\DashboardInsightsController;
use App\Http\Controllers\Api\GeoAnalyticsController as G;
use App\Http\Controllers\Api\VendorFinanceController;
use App\Http\Controllers\Api\VendorProductAnalyticsController;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

// Phase 16 Admin operations and geographic analytics. The prefix fixes the audience and transport; each domain
// service authorizes the specific Admin permission again. There is no route that edits or deletes an audit entry,
// reveals a secret, shows a balance, withdraws funds or marks a provider connection ready.
$web = fn (string $audience): array => ['auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:'.$audience];

Route::prefix('admin')->middleware($web('ADMIN'))->group(function (): void {
    Route::get('/platform-settings', [O::class, 'settings']);
    Route::get('/platform-settings/{key}/history', [O::class, 'settingHistory'])->where('key', '[a-z0-9_.]+');
    Route::put('/platform-settings/{key}', [O::class, 'updateSetting'])->where('key', '[a-z0-9_.]+');

    Route::get('/enforcement', [O::class, 'enforcementQueue']);
    Route::post('/enforcement', [O::class, 'recordEnforcement']);
    Route::get('/enforcement/subjects', [O::class, 'enforcementSubjects']);
    Route::get('/enforcement/subjects/{type}/{subjectId}', [O::class, 'enforcementSubject'])->whereIn('type', ['BUYER', 'VENDOR_ORGANIZATION'])->whereUuid('subjectId');
    Route::get('/enforcement/{actionId}', [O::class, 'enforcementDetail'])->whereUuid('actionId');
    Route::post('/enforcement/{actionId}/apply', [O::class, 'applyEnforcement'])->whereUuid('actionId');
    Route::post('/enforcement/{actionId}/decline', [O::class, 'declineEnforcement'])->whereUuid('actionId');
    Route::post('/enforcement/{actionId}/lift', [O::class, 'liftEnforcement'])->whereUuid('actionId');

    Route::get('/buyers', [U::class, 'buyers']);
    Route::get('/buyers/{buyerId}', [U::class, 'buyer'])->whereUuid('buyerId');
    Route::get('/buyers/{buyerId}/photo', [U::class, 'buyerPhoto'])->whereUuid('buyerId')->middleware('signed')->name('admin.directory.buyer-photo');
    Route::get('/buyers/{buyerId}/reviews', [U::class, 'buyerReviews'])->whereUuid('buyerId');
    Route::get('/vendors', [U::class, 'vendors']);
    Route::get('/vendors/{vendorId}', [U::class, 'vendor'])->whereUuid('vendorId');
    Route::get('/vendors/{vendorId}/reviews', [U::class, 'vendorReviews'])->whereUuid('vendorId');
    Route::get('/vendors/{vendorId}/listings', [U::class, 'vendorListings'])->whereUuid('vendorId');

    Route::get('/audit-log', [O::class, 'audit']);
    Route::get('/audit-log/actions', [O::class, 'auditActions']);
    Route::get('/audit-log/{auditId}', [O::class, 'auditDetail'])->whereUuid('auditId');

    Route::get('/integrations', [O::class, 'integrations']);
    Route::get('/integrations/failures', [O::class, 'failures']);
    Route::get('/integrations/retries', [O::class, 'retries']);
    Route::post('/integrations/retries', [O::class, 'retry']);

    Route::get('/budget-overrides', [O::class, 'budgetOverrides']);

    Route::get('/dashboard/insights', [DashboardInsightsController::class, 'admin']);

    Route::get('/geo-analytics', [G::class, 'dashboard']);
    Route::get('/geo-analytics/demand', [G::class, 'demand']);
    Route::get('/geo-analytics/filter-options', [G::class, 'filterOptions']);
    Route::get('/geo-analytics/boundaries', [G::class, 'boundaries']);

    Route::get('/finance/kpis', [F::class, 'kpis']);
    Route::get('/finance/remittances', [F::class, 'remittances']);
    Route::get('/finance/evidence', [F::class, 'evidence']);
    Route::get('/finance/tax-adjustments', [F::class, 'taxAdjustments']);
    Route::post('/finance/tax-adjustments/{adjustmentId}/prepare', [F::class, 'prepareTaxAdjustment'])->whereUuid('adjustmentId');
    Route::post('/finance/tax-adjustments/{adjustmentId}/review', [F::class, 'reviewTaxAdjustment'])->whereUuid('adjustmentId');
    Route::post('/finance/tax-adjustments/{adjustmentId}/post', [F::class, 'postTaxAdjustment'])->whereUuid('adjustmentId');
});

Route::get('/vendor/finance/reviews', [VendorFinanceController::class, 'reviews'])->middleware($web('VENDOR'));
Route::get('/vendor/dashboard/insights', [DashboardInsightsController::class, 'vendor'])->middleware($web('VENDOR'));
Route::prefix('vendor/product-analytics')->middleware($web('VENDOR'))->group(function (): void {
    Route::get('/', [VendorProductAnalyticsController::class, 'overview']);
    Route::get('/summaries', [VendorProductAnalyticsController::class, 'summaries']);
    Route::get('/listings/{listingId}', [VendorProductAnalyticsController::class, 'product'])->whereUuid('listingId');
});
