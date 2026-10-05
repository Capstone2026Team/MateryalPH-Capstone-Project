<?php

use App\Http\Controllers\Api\MaterialsAnalyticsController as A;
use App\Http\Controllers\Api\ReviewController as R;
use App\Http\Controllers\Api\ScoreController as S;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

// Phase 14 reviews, scores, badges and Materials Analytics. The prefix fixes the audience and transport; the domain
// and the analytics policy authorize again on every request. No route deletes a review or awards a badge.
$buyer = ['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER', 'throttle:account'];
$web = fn (string $audience): array => ['auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:'.$audience, 'throttle:account'];

Route::prefix('buyers')->middleware($buyer)->group(function (): void {
    Route::get('/orders/{orderId}/reviews', [R::class, 'buyerOrder'])->whereUuid('orderId');
    Route::post('/orders/{orderId}/reviews', [R::class, 'buyerSubmit'])->whereUuid('orderId');
    Route::patch('/reviews/{reviewId}', [R::class, 'buyerEdit'])->whereUuid('reviewId');
    Route::post('/reviews/{reviewId}/media', [R::class, 'addMedia'])->whereUuid('reviewId')->middleware('throttle:account-upload');
    Route::delete('/reviews/{reviewId}/media/{mediaId}', [R::class, 'removeMedia'])->whereUuid('reviewId')->whereUuid('mediaId');
    Route::post('/reviews/{reviewId}/flags', [R::class, 'buyerFlag'])->whereUuid('reviewId');
    Route::get('/listings/{listingId}/reviews', [R::class, 'listingReviews'])->whereUuid('listingId');
    Route::get('/stores/{vendorId}/reviews', [R::class, 'storeReviews'])->whereUuid('vendorId');
    // Origins stay in request bodies, so these read-only analytics queries use POST.
    Route::post('/materials-analytics', [A::class, 'buyerList'])->middleware('throttle:buyer-discovery');
    Route::post('/materials-analytics/{groupId}', [A::class, 'buyerDetail'])->whereUuid('groupId')->middleware('throttle:buyer-discovery');
    Route::post('/materials-analytics/{groupId}/offers', [A::class, 'buyerOffers'])->whereUuid('groupId')->middleware('throttle:buyer-discovery');
});

Route::prefix('vendor')->middleware($web('VENDOR'))->group(function (): void {
    Route::get('/reviews', [R::class, 'vendorIndex']);
    Route::patch('/reviews/{reviewId}', [R::class, 'vendorEdit'])->whereUuid('reviewId');
    Route::post('/reviews/{reviewId}/flags', [R::class, 'vendorFlag'])->whereUuid('reviewId');
    Route::get('/orders/{orderId}/reviews', [R::class, 'vendorOrder'])->whereUuid('orderId');
    Route::post('/orders/{orderId}/buyer-rating', [R::class, 'vendorSubmit'])->whereUuid('orderId');
    Route::get('/performance', [S::class, 'vendorPerformance']);
    Route::get('/materials-analytics', [A::class, 'vendorList']);
    Route::get('/materials-analytics/export', [A::class, 'vendorExport']);
    Route::get('/materials-analytics/{groupId}', [A::class, 'vendorDetail'])->whereUuid('groupId');
});

Route::prefix('admin')->middleware($web('ADMIN'))->group(function (): void {
    Route::get('/reviews', [R::class, 'moderationQueue']);
    Route::get('/reviews/{reviewId}', [R::class, 'moderationDetail'])->whereUuid('reviewId');
    Route::post('/reviews/{reviewId}/moderation', [R::class, 'moderate'])->whereUuid('reviewId');
    Route::get('/scores', [S::class, 'adminIndex']);
    Route::post('/scores/exclusions/{exclusionId}/revoke', [S::class, 'revokeExclusion'])->whereUuid('exclusionId');
    Route::post('/scores/badge-suppressions/{suppressionId}/lift', [S::class, 'lift'])->whereUuid('suppressionId');
    Route::get('/scores/{vendorId}', [S::class, 'adminShow'])->whereUuid('vendorId');
    Route::post('/scores/{vendorId}/exclusions', [S::class, 'exclude'])->whereUuid('vendorId');
    Route::post('/scores/{vendorId}/badge-suppressions', [S::class, 'suppress'])->whereUuid('vendorId');
    Route::get('/materials-analytics', [A::class, 'adminList']);
    Route::get('/materials-analytics/export', [A::class, 'adminExport']);
    Route::get('/materials-analytics/runs', [A::class, 'adminRuns']);
    Route::post('/materials-analytics/runs/{runId}/corrections', [A::class, 'adminCorrect'])->whereUuid('runId');
    Route::get('/materials-analytics/{groupId}', [A::class, 'adminDetail'])->whereUuid('groupId');
    Route::get('/materials-analytics/{groupId}/sources', [A::class, 'adminSources'])->whereUuid('groupId');
});

// Five-minute signed review photo links; the fetch re-authorizes the signed-in caller against the review.
Route::get('/buyers/reviews/{reviewId}/media/{mediaId}/content', [R::class, 'media'])->whereUuid('reviewId')->whereUuid('mediaId')
    ->middleware(['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER', 'signed', 'throttle:account'])->name('reviews.buyer.media');
Route::get('/vendor/reviews/{reviewId}/media/{mediaId}/content', [R::class, 'media'])->whereUuid('reviewId')->whereUuid('mediaId')
    ->middleware(['auth.transport:WEB', 'auth.cookie', 'auth:api', 'account.access:VENDOR', 'signed', 'throttle:account'])->name('reviews.vendor.media');
Route::get('/admin/reviews/{reviewId}/media/{mediaId}/content', [R::class, 'media'])->whereUuid('reviewId')->whereUuid('mediaId')
    ->middleware(['auth.transport:WEB', 'auth.cookie', 'auth:api', 'account.access:ADMIN', 'signed', 'throttle:account'])->name('reviews.admin.media');
