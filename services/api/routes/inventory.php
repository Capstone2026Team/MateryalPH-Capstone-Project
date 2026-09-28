<?php

use App\Http\Controllers\Api\FleetFileController;
use App\Http\Controllers\Api\VendorFleetController;
use App\Http\Controllers\Api\VendorInventoryController;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

Route::prefix('vendor')->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:VENDOR', 'throttle:account',
])->group(function (): void {
    Route::get('/inventory/items', [VendorInventoryController::class, 'index']);
    Route::patch('/inventory/items/{variantId}', [VendorInventoryController::class, 'update'])->whereUuid('variantId');
    Route::get('/inventory/items/{variantId}/movements', [VendorInventoryController::class, 'movements'])->whereUuid('variantId');
    Route::get('/inventory/items/{variantId}/prices', [VendorInventoryController::class, 'prices'])->whereUuid('variantId');
    Route::post('/inventory/confirmations', [VendorInventoryController::class, 'confirm']);
    Route::get('/inventory/settings', [VendorInventoryController::class, 'settings']);
    Route::put('/inventory/settings', [VendorInventoryController::class, 'saveSettings']);

    Route::get('/auto-accept/policies/{variantId}', [VendorInventoryController::class, 'autoAccept'])->whereUuid('variantId');
    Route::put('/auto-accept/policies/{variantId}', [VendorInventoryController::class, 'configureAutoAccept'])->whereUuid('variantId');
    Route::patch('/auto-accept/policies/{variantId}/allotment', [VendorInventoryController::class, 'autoAcceptAllotment'])->whereUuid('variantId');
    Route::post('/auto-accept/policies/{variantId}/pause', [VendorInventoryController::class, 'pauseAutoAccept'])->whereUuid('variantId');
    Route::post('/auto-accept/policies/{variantId}/resume', [VendorInventoryController::class, 'resumeAutoAccept'])->whereUuid('variantId');

    Route::get('/fleet/vehicles', [VendorFleetController::class, 'index']);
    Route::put('/fleet/vehicles', [VendorFleetController::class, 'save']);
    Route::post('/fleet/vehicle-images', [VendorFleetController::class, 'uploadImage'])->middleware('throttle:account-upload');
    Route::get('/fleet/vehicle-images/{fileId}', [VendorFleetController::class, 'imageUrl'])->whereUuid('fileId');
});

Route::get('/fleet-files/{fileId}/content', FleetFileController::class)
    ->whereUuid('fileId')
    ->middleware(['auth.transport:WEB', 'auth.cookie', 'auth:api', 'account.access', 'signed', 'throttle:account'])
    ->name('fleet.file-content');
