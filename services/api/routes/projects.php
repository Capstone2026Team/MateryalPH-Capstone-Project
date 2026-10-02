<?php

use App\Http\Controllers\Api\BuyerProjectController as P;
use Illuminate\Support\Facades\Route;

Route::prefix('buyers')->middleware(['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER', 'throttle:account'])->group(function (): void {
    Route::get('project-ranking-preferences', [P::class, 'preferences']);
    Route::put('project-ranking-preferences', [P::class, 'savePreferences']);
    Route::post('project-ranking-preferences/reset', [P::class, 'resetPreferences']);
    Route::post('work-packages/import-preview', [P::class, 'importPreview']);
    Route::get('project-materials', [P::class, 'materials']);
    Route::get('projects', [P::class, 'index']);
    Route::post('projects', [P::class, 'create']);
    Route::prefix('projects/{projectId}')->whereUuid('projectId')->group(function (): void {
        Route::get('/', [P::class, 'show']);
        Route::patch('/', [P::class, 'update']);
        Route::delete('/', [P::class, 'deleteProject']);
        Route::post('work-packages', [P::class, 'savePackage']);
    });
    Route::prefix('work-packages/{packageId}')->whereUuid('packageId')->group(function (): void {
        Route::get('/', [P::class, 'packageShow']);
        Route::put('/', [P::class, 'editPackage']);
        Route::delete('/', [P::class, 'deletePackage']);
        Route::post('versions', [P::class, 'newVersion']);
        Route::post('activate', [P::class, 'activate']);
        Route::post('close', [P::class, 'close']);
        Route::get('estimates', [P::class, 'estimates']);
        Route::post('estimates', [P::class, 'compile']);
        Route::post('inquiries', [P::class, 'inquire']);
        Route::post('selection', [P::class, 'select']);
        Route::post('candidates/{candidateId}/route', [P::class, 'route'])->whereUuid('candidateId');
        Route::put('missing-lines/{lineId}', [P::class, 'missing'])->whereUuid('lineId');
    });
});
