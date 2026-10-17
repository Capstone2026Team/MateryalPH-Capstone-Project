<?php

use App\Http\Controllers\Api\DisputeController as D;
use App\Http\Controllers\Api\InvoiceController as I;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

// Phase 13 disputes and FIN-09 invoices. The prefix fixes the audience and transport; the domain authorizes again.
$buyer = ['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER'];
$web = fn (string $audience): array => ['auth.transport:WEB', 'auth.cookie', VerifyAccountCsrf::class, 'auth:api', 'account.access:'.$audience];

Route::prefix('buyers')->middleware($buyer)->group(function (): void {
    Route::get('/disputes', [D::class, 'index']);
    Route::post('/disputes', [D::class, 'file']);
    Route::get('/disputes/realtime', [D::class, 'realtime']);
    Route::post('/disputes/realtime/auth', [D::class, 'authorizeChannel']);
    Route::get('/orders/{orderId}/dispute-eligibility', [D::class, 'eligibility'])->whereUuid('orderId');
    Route::prefix('disputes/{caseId}')->whereUuid('caseId')->group(function (): void {
        Route::get('/', [D::class, 'show']);
        Route::post('/respond', [D::class, 'respond']);
        Route::post('/proposals', [D::class, 'propose']);
        Route::post('/proposals/{proposalId}/answer', [D::class, 'answerProposal'])->whereUuid('proposalId');
        Route::post('/escalate', [D::class, 'escalate']);
        Route::post('/evidence', [D::class, 'evidence']);
        Route::post('/messages', [D::class, 'message']);
        Route::post('/clarifications/{clarificationId}/answer', [D::class, 'answerClarification'])->whereUuid('clarificationId');
        Route::post('/appeal', [D::class, 'appeal']);
        Route::post('/remedies/{remedyId}/confirm', [D::class, 'confirmReplacement'])->whereUuid('remedyId');
    });
    Route::prefix('orders/{orderId}/invoices')->whereUuid('orderId')->group(function (): void {
        Route::get('/', [I::class, 'buyerOrder']);
        Route::put('/details', [I::class, 'saveDetails']);
        Route::post('/requests', [I::class, 'request']);
        Route::post('/requests/{requestId}/answer', [I::class, 'answerRequest'])->whereUuid('requestId');
    });
});

Route::prefix('vendor')->middleware($web('VENDOR'))->group(function (): void {
    Route::get('/disputes', [D::class, 'index']);
    Route::post('/disputes', [D::class, 'file']);
    Route::get('/disputes/realtime', [D::class, 'realtime']);
    Route::post('/disputes/realtime/auth', [D::class, 'authorizeChannel']);
    Route::get('/disputes/exports', [D::class, 'exports']);
    Route::post('/disputes/exports', [D::class, 'requestExport']);
    Route::get('/disputes/exports/{exportId}/download', [D::class, 'downloadExport'])->whereUuid('exportId');
    Route::get('/orders/{orderId}/dispute-eligibility', [D::class, 'eligibility'])->whereUuid('orderId');
    Route::prefix('disputes/{caseId}')->whereUuid('caseId')->group(function (): void {
        Route::get('/', [D::class, 'show']);
        Route::post('/respond', [D::class, 'respond']);
        Route::post('/proposals', [D::class, 'propose']);
        Route::post('/proposals/{proposalId}/answer', [D::class, 'answerProposal'])->whereUuid('proposalId');
        Route::post('/escalate', [D::class, 'escalate']);
        Route::post('/evidence', [D::class, 'evidence']);
        Route::post('/messages', [D::class, 'message']);
        Route::post('/clarifications/{clarificationId}/answer', [D::class, 'answerClarification'])->whereUuid('clarificationId');
        Route::post('/appeal', [D::class, 'appeal']);
        Route::post('/remedies/{remedyId}/record', [D::class, 'recordReplacement'])->whereUuid('remedyId');
    });
    Route::get('/invoices', [I::class, 'vendorIndex']);
    Route::prefix('orders/{orderId}/invoices')->whereUuid('orderId')->group(function (): void {
        Route::get('/', [I::class, 'vendorOrder']);
        Route::post('/', [I::class, 'upload']);
        Route::post('/{recordId}/explanation', [I::class, 'explain'])->whereUuid('recordId');
    });
});

Route::prefix('admin')->middleware($web('ADMIN'))->group(function (): void {
    Route::get('/disputes', [D::class, 'queue']);
    Route::get('/disputes/realtime', [D::class, 'realtime']);
    Route::post('/disputes/realtime/auth', [D::class, 'authorizeChannel']);
    Route::prefix('disputes/{caseId}')->whereUuid('caseId')->group(function (): void {
        Route::get('/', [D::class, 'show']);
        Route::post('/assign', [D::class, 'assign']);
        Route::post('/escalate', [D::class, 'escalate']);
        Route::post('/clarifications', [D::class, 'requestClarification']);
        Route::post('/decision', [D::class, 'decide']);
        Route::post('/appeal-decision', [D::class, 'decideAppeal']);
        Route::post('/remedies/{remedyId}/confirm', [D::class, 'confirmReplacement'])->whereUuid('remedyId');
    });
    Route::get('/invoices', [I::class, 'adminLog']);
});

// Short-lived signed content links: the signature and expiry are checked by `signed`, then the domain re-authorizes
// the signed-in caller against the case or invoice on every fetch.
Route::get('/buyers/disputes/{caseId}/files/{fileId}/content', [D::class, 'evidenceContent'])->whereUuid('caseId')->whereUuid('fileId')
    ->middleware(['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER', 'signed'])->name('disputes.buyer.file');
Route::get('/vendor/disputes/{caseId}/files/{fileId}/content', [D::class, 'evidenceContent'])->whereUuid('caseId')->whereUuid('fileId')
    ->middleware(['auth.transport:WEB', 'auth.cookie', 'auth:api', 'account.access:VENDOR', 'signed'])->name('disputes.vendor.file');
Route::get('/admin/disputes/{caseId}/files/{fileId}/content', [D::class, 'evidenceContent'])->whereUuid('caseId')->whereUuid('fileId')
    ->middleware(['auth.transport:WEB', 'auth.cookie', 'auth:api', 'account.access:ADMIN', 'signed'])->name('disputes.admin.file');
Route::get('/buyers/invoice-records/{recordId}/content', [I::class, 'content'])->whereUuid('recordId')
    ->middleware(['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER', 'signed'])->name('invoices.buyer.file');
Route::get('/vendor/invoice-records/{recordId}/content', [I::class, 'content'])->whereUuid('recordId')
    ->middleware(['auth.transport:WEB', 'auth.cookie', 'auth:api', 'account.access:VENDOR', 'signed'])->name('invoices.vendor.file');
Route::get('/admin/invoice-records/{recordId}/content', [I::class, 'content'])->whereUuid('recordId')
    ->middleware(['auth.transport:WEB', 'auth.cookie', 'auth:api', 'account.access:ADMIN', 'signed'])->name('invoices.admin.file');
