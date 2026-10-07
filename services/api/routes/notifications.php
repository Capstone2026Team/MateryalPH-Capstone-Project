<?php

use App\Http\Controllers\Api\NotificationController;
use App\Http\Controllers\Api\ReportingController;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

foreach (['buyers' => ['BUYER', 'MOBILE'], 'vendor' => ['VENDOR', 'WEB'], 'admin' => ['ADMIN', 'WEB']] as $prefix => [$portal, $transport]) {
    $middleware = ['auth.transport:'.$transport];
    if ($transport === 'WEB') {
        $middleware = [...$middleware, 'auth.cookie', VerifyAccountCsrf::class];
    }
    Route::prefix($prefix)->middleware([...$middleware, 'auth:api', 'account.access:'.$portal])->group(function () use ($portal): void {
        Route::get('/notifications', [NotificationController::class, 'index']);
        Route::get('/notifications/preferences', [NotificationController::class, 'preferences']);
        Route::put('/notifications/preferences', [NotificationController::class, 'updatePreference']);
        Route::post('/notifications/devices', [NotificationController::class, 'registerDevice']);
        Route::delete('/notifications/devices/{deviceId}', [NotificationController::class, 'revokeDevice'])->whereUuid('deviceId');
        Route::post('/notifications/{noticeId}/read', [NotificationController::class, 'read'])->whereUuid('noticeId');
        Route::post('/notifications/{noticeId}/resolve', [NotificationController::class, 'resolve'])->whereUuid('noticeId');
        Route::get('/reports', [ReportingController::class, 'index']);
        Route::post('/reports', [ReportingController::class, 'request']);
        Route::get('/reports/{exportId}/download', [ReportingController::class, 'download'])->whereUuid('exportId');
        if ($portal === 'ADMIN') {
            Route::get('/notifications/failures', [NotificationController::class, 'failures']);
            Route::get('/reports/tax', [ReportingController::class, 'taxList']);
            Route::post('/reports/tax', [ReportingController::class, 'prepareTax']);
            Route::get('/reports/tax/{packageId}', [ReportingController::class, 'taxDetail'])->whereUuid('packageId');
            Route::post('/reports/tax/{packageId}/review', [ReportingController::class, 'reviewTax'])->whereUuid('packageId');
            Route::post('/reports/tax/{packageId}/simulation', [ReportingController::class, 'simulateTax'])->whereUuid('packageId');
        }
    });
}
