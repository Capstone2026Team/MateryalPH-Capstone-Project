<?php

use App\Http\Controllers\Api\VendorOnboardingController;
use Illuminate\Support\Facades\Route;

Route::get('/vendor-onboarding-files/{fileId}/content', [VendorOnboardingController::class, 'streamFile'])
    ->whereUuid('fileId')
    ->middleware(['auth.transport:WEB', 'auth.cookie', 'auth:api', 'account.access', 'signed', 'throttle:account'])
    ->name('vendor.onboarding.file-content');
