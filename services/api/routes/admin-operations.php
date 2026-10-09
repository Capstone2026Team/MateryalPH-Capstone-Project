<?php

use App\Http\Controllers\Api\AdminFinanceOperationsController as F;
use App\Http\Controllers\Api\AdminOperationsController as O;
use App\Http\Controllers\Api\GeoAnalyticsController as G;
use App\Http\Controllers\Api\VendorFinanceController;
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

    Route::get('/privacy-requests', [O::class, 'privacyQueue']);
    Route::post('/privacy-requests', [O::class, 'recordPrivacyRequest']);
    Route::get('/privacy-requests/{requestId}', [O::class, 'privacyDetail'])->whereUuid('requestId');
    Route::post('/privacy-requests/{requestId}/{command}', [O::class, 'privacyTransition'])->whereUuid('requestId')->whereIn('command', ['assign', 'verify', 'start', 'complete', 'reject', 'withdraw']);

    Route::get('/audit-log', [O::class, 'audit']);
    Route::get('/audit-log/actions', [O::class, 'auditActions']);
    Route::get('/audit-log/{auditId}', [O::class, 'auditDetail'])->whereUuid('auditId');

    Route::get('/integrations', [O::class, 'integrations']);
    Route::get('/integrations/failures', [O::class, 'failures']);
    Route::get('/integrations/retries', [O::class, 'retries']);
    Route::post('/integrations/retries', [O::class, 'retry']);

    Route::get('/budget-overrides', [O::class, 'budgetOverrides']);

    Route::get('/geo-analytics', [G::class, 'dashboard']);
    Route::get('/geo-analytics/demand', [G::class, 'demand']);
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
