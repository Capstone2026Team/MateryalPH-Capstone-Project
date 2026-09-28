<?php

use App\Http\Controllers\Api\BuyerDiscoveryController;
use App\Http\Controllers\Api\BuyerLocationController;
use Illuminate\Support\Facades\Route;

// Buyer mobile only: native bearer transport, Buyer account access, per-user throttles. Every resource is
// scoped to the authenticated Buyer's own profile inside the domain services.
Route::prefix('buyers')->middleware(['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER', 'throttle:account'])->group(function (): void {
    Route::get('/onboarding', [BuyerLocationController::class, 'onboarding']);
    Route::put('/onboarding', [BuyerLocationController::class, 'saveOnboarding']);
    Route::put('/discovery/preferences', [BuyerLocationController::class, 'saveRadius']);

    Route::get('/geography/areas', [BuyerLocationController::class, 'areas']);
    Route::get('/locations', [BuyerLocationController::class, 'index']);
    Route::post('/locations/resolve', [BuyerLocationController::class, 'resolve'])->middleware('throttle:buyer-geocode');
    Route::post('/locations', [BuyerLocationController::class, 'store']);
    Route::patch('/locations/{locationId}', [BuyerLocationController::class, 'update'])->whereUuid('locationId');
    Route::post('/locations/{locationId}/primary', [BuyerLocationController::class, 'primary'])->whereUuid('locationId');
    Route::delete('/locations/{locationId}', [BuyerLocationController::class, 'destroy'])->whereUuid('locationId');

    Route::post('/discovery/search', [BuyerDiscoveryController::class, 'search'])->middleware('throttle:buyer-discovery');
    Route::get('/discovery/directory-suppliers/{supplierId}', [BuyerDiscoveryController::class, 'directorySupplier'])->whereUuid('supplierId')->middleware('throttle:buyer-places');
    Route::post('/discovery/routes', [BuyerDiscoveryController::class, 'route'])->middleware('throttle:buyer-route');

    Route::get('/favorite-suppliers', [BuyerDiscoveryController::class, 'favorites']);
    Route::put('/favorite-suppliers/{vendorId}', [BuyerDiscoveryController::class, 'addFavorite'])->whereUuid('vendorId');
    Route::delete('/favorite-suppliers/{vendorId}', [BuyerDiscoveryController::class, 'removeFavorite'])->whereUuid('vendorId');
});
