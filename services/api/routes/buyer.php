<?php

use App\Http\Controllers\Api\BuyerCartController;
use App\Http\Controllers\Api\BuyerDiscoveryController;
use App\Http\Controllers\Api\BuyerLocationController;
use App\Http\Controllers\Api\BuyerProcurementController;
use Illuminate\Support\Facades\Route;

// Buyer mobile only: native bearer transport, Buyer account access, per-user throttles. Every resource is
// scoped to the authenticated Buyer's own profile inside the domain services.
Route::prefix('buyers')->middleware(['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER', 'throttle:account'])->group(function (): void {
    Route::get('/onboarding', [BuyerLocationController::class, 'onboarding']);
    Route::put('/onboarding', [BuyerLocationController::class, 'saveOnboarding']);
    Route::put('/discovery/preferences', [BuyerLocationController::class, 'saveRadius']);

    Route::get('/geography/areas', [BuyerLocationController::class, 'areas']);
    Route::get('/locations', [BuyerLocationController::class, 'index']);
    Route::post('/locations/autocomplete', [BuyerLocationController::class, 'autocomplete'])->middleware('throttle:buyer-places');
    Route::post('/locations/resolve', [BuyerLocationController::class, 'resolve'])->middleware('throttle:buyer-geocode');
    Route::post('/locations', [BuyerLocationController::class, 'store']);
    Route::patch('/locations/{locationId}', [BuyerLocationController::class, 'update'])->whereUuid('locationId');
    Route::post('/locations/{locationId}/primary', [BuyerLocationController::class, 'primary'])->whereUuid('locationId');
    Route::delete('/locations/{locationId}', [BuyerLocationController::class, 'destroy'])->whereUuid('locationId');

    Route::post('/discovery/search', [BuyerDiscoveryController::class, 'search'])->middleware('throttle:buyer-discovery');
    Route::get('/discovery/directory-suppliers/{supplierId}', [BuyerDiscoveryController::class, 'directorySupplier'])->whereUuid('supplierId')->middleware('throttle:buyer-places');
    Route::get('/discovery/directory-suppliers/{supplierId}/photo', [BuyerDiscoveryController::class, 'directorySupplierPhoto'])->whereUuid('supplierId')->middleware('throttle:buyer-places');
    Route::post('/discovery/routes', [BuyerDiscoveryController::class, 'route'])->middleware('throttle:buyer-route');

    // Phase 7 Item-Based procurement. Origins stay in bodies; cart and preview never reserve stock.
    Route::post('/explore/summary', [BuyerProcurementController::class, 'explore'])->middleware('throttle:buyer-discovery');
    Route::post('/listings/search', [BuyerProcurementController::class, 'search'])->middleware('throttle:buyer-discovery');
    Route::post('/listings/{listingId}/details', [BuyerProcurementController::class, 'listing'])->whereUuid('listingId');
    Route::get('/ranking-preferences/item-based', [BuyerProcurementController::class, 'preferences']);
    Route::put('/ranking-preferences/item-based', [BuyerProcurementController::class, 'savePreferences']);
    Route::delete('/ranking-preferences/item-based', [BuyerProcurementController::class, 'resetPreferences']);
    Route::get('/cart', [BuyerCartController::class, 'show']);
    Route::post('/cart/items', [BuyerCartController::class, 'add']);
    Route::patch('/cart/items/{itemId}', [BuyerCartController::class, 'update'])->whereUuid('itemId');
    Route::delete('/cart/items/{itemId}', [BuyerCartController::class, 'remove'])->whereUuid('itemId');
    Route::put('/cart/vendor-groups/{vendorId}/fulfillment', [BuyerCartController::class, 'fulfillment'])->whereUuid('vendorId');
    Route::put('/cart/destination', [BuyerCartController::class, 'destination']);
    Route::post('/cart/checkout-preview', [BuyerCartController::class, 'preview'])->middleware('throttle:buyer-route');

    Route::get('/favorite-suppliers', [BuyerDiscoveryController::class, 'favorites']);
    Route::put('/favorite-suppliers/{vendorId}', [BuyerDiscoveryController::class, 'addFavorite'])->whereUuid('vendorId');
    Route::delete('/favorite-suppliers/{vendorId}', [BuyerDiscoveryController::class, 'removeFavorite'])->whereUuid('vendorId');
});
