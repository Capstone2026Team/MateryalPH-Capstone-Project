<?php

use App\Http\Controllers\Api\SupportController as S;
use App\Http\Middleware\SetSupportPortal;
use App\Http\Middleware\VerifyAccountCsrf;
use Illuminate\Support\Facades\Route;

foreach (['buyers' => 'BUYER', 'vendors' => 'VENDOR', 'admin' => 'ADMIN', 'guest' => null] as $portal => $account) {
    $middleware = $portal === 'buyers' ? ['auth.transport:MOBILE', 'auth:api', 'account.access:BUYER'] : ['auth.transport:WEB', VerifyAccountCsrf::class];
    if (in_array($portal, ['vendors', 'admin'], true)) {
        $middleware = [...$middleware, 'auth.cookie', 'auth:api', 'account.access:'.$account];
    }
    if ($portal === 'guest') {
        $middleware[] = 'throttle:support-guest';
    }
    Route::prefix('support/'.$portal)->middleware([...$middleware, SetSupportPortal::class.':'.$portal])->group(function () use ($portal): void {
        if ($portal === 'guest') {
            Route::post('/access-email', [S::class, 'accessEmail'])->middleware('throttle:support-submit');
            Route::post('/access', [S::class, 'exchange']);
        } else {
            Route::get('/tickets', [S::class, 'index']);
        }
        if ($portal === 'admin') {
            Route::get('/handlers', [S::class, 'handlers']);
        } else {
            Route::post('/tickets', [S::class, 'create'])->middleware('throttle:support-submit');
        }
        Route::get('/tickets/{ticketId}', [S::class, 'show'])->whereUuid('ticketId');
        Route::get('/tickets/{ticketId}/entries', [S::class, 'entries'])->whereUuid('ticketId');
        Route::post('/tickets/{ticketId}/entries', [S::class, 'reply'])->whereUuid('ticketId');
        Route::get('/tickets/{ticketId}/attachments/{fileId}', [S::class, 'attachment'])->whereUuid('ticketId')->whereUuid('fileId');
        if ($portal === 'admin') {
            Route::patch('/tickets/{ticketId}', [S::class, 'update'])->whereUuid('ticketId');
        }
    });
}
