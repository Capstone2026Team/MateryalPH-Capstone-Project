<?php

use App\Http\Controllers\Api\AdminProductComplianceController;
use App\Http\Controllers\Api\CatalogFileController;
use App\Http\Controllers\Api\VendorCatalogController;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

Route::prefix('vendor/catalog')->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:VENDOR', 'throttle:account',
])->group(function (): void {
    Route::get('/taxonomy', [VendorCatalogController::class, 'taxonomy']);
    Route::get('/materials/search', [VendorCatalogController::class, 'searchMaterials']);
    Route::get('/materials/{materialId}', [VendorCatalogController::class, 'material'])->whereUuid('materialId');
    Route::get('/listings', [VendorCatalogController::class, 'index']);
    Route::post('/listings', [VendorCatalogController::class, 'store']);
    Route::get('/listings/{listingId}', [VendorCatalogController::class, 'show'])->whereUuid('listingId');
    Route::patch('/listings/{listingId}', [VendorCatalogController::class, 'update'])->whereUuid('listingId');
    Route::put('/listings/{listingId}/variants', [VendorCatalogController::class, 'variants'])->whereUuid('listingId');
    Route::post('/listings/{listingId}/media', [VendorCatalogController::class, 'uploadMedia'])->whereUuid('listingId')->middleware('throttle:account-upload');
    Route::delete('/listings/{listingId}/media/{mediaId}', [VendorCatalogController::class, 'removeMedia'])->whereUuid(['listingId', 'mediaId']);
    Route::post('/listings/{listingId}/publish', [VendorCatalogController::class, 'publish'])->whereUuid('listingId');
    Route::post('/listings/{listingId}/deactivate', [VendorCatalogController::class, 'deactivate'])->whereUuid('listingId');
    Route::delete('/listings/{listingId}', [VendorCatalogController::class, 'destroy'])->whereUuid('listingId');
    Route::post('/listings/{listingId}/compliance/evidence', [VendorCatalogController::class, 'uploadComplianceEvidence'])->whereUuid('listingId')->middleware('throttle:account-upload');
    Route::post('/listings/{listingId}/compliance', [VendorCatalogController::class, 'submitCompliance'])->whereUuid('listingId');
    Route::get('/files/{fileId}', [VendorCatalogController::class, 'fileUrl'])->whereUuid('fileId');
    Route::get('/imports/template', [VendorCatalogController::class, 'importTemplate']);
    Route::post('/imports', [VendorCatalogController::class, 'uploadImport'])->middleware('throttle:account-upload');
    Route::get('/imports/{jobId}', [VendorCatalogController::class, 'showImport'])->whereUuid('jobId');
    Route::post('/imports/{jobId}/apply', [VendorCatalogController::class, 'applyImport'])->whereUuid('jobId');
});

Route::prefix('admin/product-compliance')->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:ADMIN', 'throttle:account',
])->group(function (): void {
    Route::get('/', [AdminProductComplianceController::class, 'queue']);
    Route::get('/registers', [AdminProductComplianceController::class, 'registers']);
    Route::post('/registers', [AdminProductComplianceController::class, 'importRegister'])->middleware('throttle:account-security');
    Route::post('/registers/{registerId}/activate', [AdminProductComplianceController::class, 'activateRegister'])->whereUuid('registerId')->middleware('throttle:account-security');
    Route::get('/files/{fileId}', [AdminProductComplianceController::class, 'fileUrl'])->whereUuid('fileId');
    Route::get('/{submissionId}', [AdminProductComplianceController::class, 'show'])->whereUuid('submissionId');
    Route::post('/{submissionId}/decision', [AdminProductComplianceController::class, 'decide'])->whereUuid('submissionId')->middleware('throttle:account-security');
});

Route::post('admin/taxonomy/comparable-groups', [AdminProductComplianceController::class, 'createComparableGroup'])->middleware([
    'auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:ADMIN', 'throttle:account-security',
]);

Route::get('/catalog-files/{fileId}/content', CatalogFileController::class)
    ->whereUuid('fileId')
    ->middleware(['auth.transport:WEB', 'auth.cookie', 'auth:api', 'account.access', 'signed', 'throttle:account'])
    ->name('catalog.file-content');
