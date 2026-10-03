<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Payments\XenditWebhookInbox;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;

/** Xendit payment webhook inbox: verify, store once, acknowledge; processing is asynchronous. */
final class PaymentWebhookController extends Controller
{
    public function __invoke(Request $request, XenditWebhookInbox $inbox): JsonResponse
    {
        $result = $inbox->receive($request->getContent(), $request->header('x-callback-token'), $request->header('webhook-id'));

        return ApiResponse::success(['received' => $result['received'], 'duplicate' => $result['duplicate']]);
    }
}
