<?php

declare(strict_types=1);

namespace App\Http\Controllers\Api;

use App\Domain\Disputes\DisputeFilingService;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Invoices\InvoiceQueries;
use App\Domain\Invoices\InvoiceService;
use App\Http\ApiResponse;
use App\Http\Controllers\Controller;
use App\Models\User;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Validation\Rule;
use Symfony\Component\HttpFoundation\StreamedResponse;

/** FIN-09 invoice records, Buyer billing details and copy/correction requests for the three audiences. */
final class InvoiceController extends Controller
{
    public function __construct(private readonly InvoiceQueries $queries, private readonly InvoiceService $invoices) {}

    public function buyerOrder(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->queries->buyerOrder($request, $orderId));
    }

    public function saveDetails(Request $request, string $orderId): JsonResponse
    {
        DisputeFilingService::rejectDestination($request);
        $input = $request->validate(['billing_name' => ['required', 'string', 'min:2', 'max:180'], 'billing_address' => ['required', 'string', 'min:10', 'max:500'],
            'tin' => ['sometimes', 'nullable', 'string', 'max:20'], 'lock_version' => ['sometimes', 'nullable', 'integer', 'min:1']]);
        $this->invoices->saveBuyerDetails($request, $orderId, ['billing_name' => (string) $input['billing_name'], 'billing_address' => (string) $input['billing_address'],
            'tin' => isset($input['tin']) ? (string) $input['tin'] : null, 'lock_version' => isset($input['lock_version']) ? (int) $input['lock_version'] : null]);

        return ApiResponse::success($this->queries->buyerOrder($request, $orderId));
    }

    public function request(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate(['kind' => ['required', Rule::in(['COPY', 'CORRECTION'])], 'details' => ['required', 'string', 'min:10', 'max:2000'], 'invoice_record_id' => ['sometimes', 'nullable', 'uuid']]);
        $this->invoices->request($request, $orderId, ['kind' => (string) $input['kind'], 'details' => (string) $input['details'], 'invoice_record_id' => $input['invoice_record_id'] ?? null]);

        return ApiResponse::success($this->queries->buyerOrder($request, $orderId), [], 201);
    }

    public function answerRequest(Request $request, string $orderId, string $requestId): JsonResponse
    {
        $input = $request->validate(['action' => ['required', Rule::in(['RETURN', 'CLOSE'])], 'reason' => ['sometimes', 'nullable', 'string', 'max:1000']]);
        $this->invoices->answerRequest($request, $orderId, $requestId, (string) $input['action'], isset($input['reason']) ? (string) $input['reason'] : null);

        return ApiResponse::success($this->queries->buyerOrder($request, $orderId));
    }

    public function vendorIndex(Request $request): JsonResponse
    {
        $filters = $request->validate(['view' => ['sometimes', Rule::in(['REQUESTS', 'DUE', 'RECORDS', 'RECONCILIATION'])], 'page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = $this->queries->vendorList($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function vendorOrder(Request $request, string $orderId): JsonResponse
    {
        return ApiResponse::success($this->queries->vendorOrder($request, $orderId));
    }

    public function upload(Request $request, string $orderId): JsonResponse
    {
        $input = $request->validate([
            'invoice_type' => ['required', Rule::in(InvoiceService::VENDOR_TYPES)], 'issuer_name' => ['required', 'string', 'max:240'],
            'invoice_number' => ['required', 'string', 'max:64', 'regex:/^[A-Za-z0-9][A-Za-z0-9 \-\/#.]*$/'], 'issued_on' => ['required', 'date', 'before_or_equal:today'],
            'amount_centavos' => ['required', 'integer', 'min:0', 'max:100000000000'], 'vat_centavos' => ['sometimes', 'nullable', 'integer', 'min:0'],
            'vat_exempt_centavos' => ['sometimes', 'nullable', 'integer', 'min:0'], 'zero_rated_centavos' => ['sometimes', 'nullable', 'integer', 'min:0'],
            'related_line_ids' => ['sometimes', 'array', 'max:200'], 'related_line_ids.*' => ['uuid'],
            'source_system' => ['required', Rule::in(InvoiceService::SOURCE_SYSTEMS)], 'invoicing_method' => ['required', Rule::in(InvoiceService::INVOICING_METHODS)],
            'amends_invoice_record_id' => ['sometimes', 'nullable', 'uuid'], 'invoice_request_id' => ['sometimes', 'nullable', 'uuid'], 'file' => ['required', 'file', 'max:10240'],
        ]);
        $file = $request->file('file');
        if (! $file instanceof UploadedFile) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Attach the invoice copy.', 422, ['file' => ['Attach a PDF, JPG or PNG copy.']]);
        }
        $values = $input;
        unset($values['file']);
        foreach (['amount_centavos', 'vat_centavos', 'vat_exempt_centavos', 'zero_rated_centavos'] as $field) {
            if (isset($values[$field])) {
                $values[$field] = (int) $values[$field];
            }
        }
        /** @var array{invoice_type: string, issuer_name: string, invoice_number: string, issued_on: string, amount_centavos: int, vat_centavos?: int|null, vat_exempt_centavos?: int|null, zero_rated_centavos?: int|null, related_line_ids?: list<string>, source_system: string, invoicing_method: string, amends_invoice_record_id?: string|null, invoice_request_id?: string|null} $values */
        $this->invoices->upload($request, $orderId, $values, $file);

        return ApiResponse::success($this->queries->vendorOrder($request, $orderId), [], 201);
    }

    public function explain(Request $request, string $orderId, string $recordId): JsonResponse
    {
        $input = $request->validate(['note' => ['required', 'string', 'min:10', 'max:2000']]);
        $this->invoices->explainDifference($request, $orderId, $recordId, (string) $input['note']);

        return ApiResponse::success($this->queries->vendorOrder($request, $orderId));
    }

    public function adminLog(Request $request): JsonResponse
    {
        $filters = $request->validate(['view' => ['sometimes', Rule::in(['REQUESTS', 'RECORDS', 'MISMATCHES'])], 'page' => ['sometimes', 'integer', 'between:1,1000']]);
        $result = $this->queries->adminLog($request, $filters);

        return ApiResponse::success($result['items'], $result['meta']);
    }

    public function content(Request $request, string $recordId): StreamedResponse
    {
        $user = $request->user();
        if (! $user instanceof User) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This file is unavailable.', 404);
        }
        $audience = match ($user->account_type) {
            'BUYER' => 'BUYER', 'VENDOR' => 'VENDOR', default => 'ADMIN'
        };
        $scope = $request->attributes->get('account_scope');
        $correlation = $request->attributes->get('correlation_id');

        return $this->invoices->stream($user, $audience, $recordId, is_array($scope) ? ($scope['role'] ?? null) : null, is_string($correlation) ? $correlation : null);
    }
}
