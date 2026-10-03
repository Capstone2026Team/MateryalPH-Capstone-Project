<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Http\Response;
use Illuminate\Support\Str;

/**
 * Browser return page after the hosted payment page. It never reads or changes payment state and never renders
 * success: it always shows Pending and hands the Buyer back to the app, which reads the verified status.
 */
final class PaymentReturnController extends Controller
{
    public function __invoke(Request $request): Response
    {
        $attempt = $request->query('attempt');
        $deepLink = is_string($attempt) && Str::isUuid($attempt) ? 'materyalph://payments/'.$attempt : 'materyalph://orders';
        $html = '<!doctype html><html lang="en"><head><meta charset="utf-8"><meta name="viewport" content="width=device-width, initial-scale=1"><title>Payment pending</title>'
            .'<style>body{margin:0;font-family:Inter,system-ui,sans-serif;background:#F8FAFC;color:#0F172A;display:grid;place-items:center;min-height:100vh}main{max-width:28rem;padding:24px;text-align:left}'
            .'h1{font-size:1.5rem;margin:0 0 12px}p{line-height:1.6;color:#334155}a{display:inline-block;margin-top:16px;padding:12px 20px;min-height:44px;box-sizing:border-box;background:#C2410C;color:#fff;border-radius:8px;text-decoration:none;font-weight:600}</style></head>'
            .'<body><main><h1>Payment pending verification</h1><p>MateryalPH confirms a payment only after the payment provider verifies it. Returning to this page does not confirm or complete a payment.</p>'
            .'<p>TEST — no real charge.</p><a href="'.e($deepLink).'">Return to MateryalPH</a></main></body></html>';

        return response($html, 200, ['Content-Type' => 'text/html; charset=UTF-8', 'Cache-Control' => 'no-store', 'X-Robots-Tag' => 'noindex', 'Referrer-Policy' => 'no-referrer']);
    }
}
