<?php

declare(strict_types=1);

namespace App\Domain\Invoices;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Disputes\DisputeRules;
use App\Domain\Fulfillment\OrderEvidenceFiles;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderStates;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\StreamedResponse;
use Throwable;

/**
 * FIN-09 Vendor invoice records and document requests. The Vendor issues its official invoice through its own
 * registered process when legally due — that duty never waits for completion or a Buyer request — and uploads a
 * copy here. MateryalPH stores the protected file and its metadata; it never assigns an official invoice number,
 * never issues the invoice and never treats an uploaded PDF as proof of BIR or structured e-invoicing compliance.
 *
 *   upload          Owner, Store Manager or Store Staff (Customer Service sees status only); type and issuer are
 *                   validated against the Vendor's registered business name; the declared totals are compared with
 *                   the accepted order and a difference opens INVOICE_RECONCILIATION_REQUIRED without ever
 *                   changing what the Buyer agreed to pay
 *   requests        the Buyer asks for a copy or a correction: REQUESTED → UPLOADED → DOWNLOADED, RETURNED_FOR_
 *                   CORRECTION or CLOSED, with a three-business-day service target that never extends a legal
 *                   issuance deadline, a reminder one business day before it and an overdue notice
 *   access          short-lived signed links; every download is recorded with the actual user and audience
 *
 * TEST documents are DEMO samples. Purchase Orders and payment confirmations from MateryalPH are not tax invoices.
 */
final class InvoiceService
{
    public const PURPOSE = 'VENDOR_INVOICE';

    public const SERVICE_TARGET_BUSINESS_DAYS = 3;

    public const VENDOR_TYPES = ['VENDOR_GOODS_INVOICE', 'VENDOR_ADJUSTMENT_DOCUMENT'];

    public const SOURCE_SYSTEMS = ['REGISTERED_CAS', 'BIR_EIS', 'LOOSE_LEAF_OR_PRINTED', 'OTHER_REGISTERED'];

    public const INVOICING_METHODS = ['ELECTRONIC', 'COMPUTERIZED', 'MANUAL'];

    public const VIEW = 'invoices.view';

    public const UPLOAD = 'invoices.upload';

    /** Orders whose sale is not yet confirmed have no invoice to issue. */
    private const NOT_YET_A_SALE = [...OrderStates::PENDING_ACCEPTANCE, OrderStates::AWAITING_PAYMENT, OrderStates::DECLINED, OrderStates::EXPIRED];

    private const ROUTES = ['BUYER' => 'invoices.buyer.file', 'VENDOR' => 'invoices.vendor.file', 'ADMIN' => 'invoices.admin.file'];

    public function __construct(
        private readonly OrderAccess $orders,
        private readonly CatalogAccess $keys,
        private readonly OrderEvidenceFiles $files,
        private readonly CatalogFileStore $store,
        private readonly OrderNotifier $notifier,
        private readonly AuditRecorder $audit,
    ) {}

    /**
     * @param  array{invoice_type: string, issuer_name: string, invoice_number: string, issued_on: string, amount_centavos: int, vat_centavos?: int|null, vat_exempt_centavos?: int|null,
     *               zero_rated_centavos?: int|null, related_line_ids?: list<string>, source_system: string, invoicing_method: string, amends_invoice_record_id?: string|null, invoice_request_id?: string|null}  $input
     */
    public function upload(Request $request, string $orderId, array $input, UploadedFile $file): string
    {
        $scope = $this->vendorScope($request, self::UPLOAD, 'Only the Owner, Store Manager or Store Staff can upload the official invoice. Customer Service can follow its status.');
        $key = $this->keys->requireIdempotencyKey($request);
        $preview = $this->orders->vendorOrder($scope, $orderId);
        $fileId = $this->files->store($file, (string) $preview->id, self::PURPOSE, (int) $request->user()->getKey(), false);
        try {
            return DB::transaction(function () use ($request, $scope, $orderId, $input, $key, $fileId): string {
                if ($this->keys->replayed($request, 'INVOICE_UPLOAD', $key, $orderId)) {
                    return (string) DB::table('invoice_records')->where('order_id', $orderId)->orderByDesc('created_at')->value('id');
                }
                $order = $this->orders->vendorOrder($scope, $orderId, true);
                if (in_array($order->order_state, self::NOT_YET_A_SALE, true)) {
                    throw new AuthenticationException('INVOICE_NOT_DUE', 'An invoice is recorded once the sale is confirmed.', 409, ['order_state' => $order->order_state]);
                }
                $id = $this->insertRecord($order, $scope, $input, $fileId, $request);
                $this->keys->claim($request, 'INVOICE_UPLOAD', $key, $orderId, 201);

                return $id;
            });
        } catch (Throwable $exception) {
            $this->files->discard([$fileId]);
            throw $exception;
        }
    }

    public function explainDifference(Request $request, string $orderId, string $recordId, string $note): void
    {
        $scope = $this->vendorScope($request, self::UPLOAD, 'Only the Owner, Store Manager or Store Staff can explain an invoice difference.');
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $scope, $orderId, $recordId, $note, $key): void {
            if ($this->keys->replayed($request, 'INVOICE_EXPLAIN', $key, $recordId)) {
                return;
            }
            $order = $this->orders->vendorOrder($scope, $orderId, true);
            $record = DB::table('invoice_records')->where('id', self::uuid($recordId))->where('order_id', $order->id)->lockForUpdate()->first();
            if ($record === null || $record->reconciliation_state !== 'INVOICE_RECONCILIATION_REQUIRED') {
                throw new AuthenticationException('RECONCILIATION_NOT_OPEN', 'This invoice has no open difference to explain.', 409);
            }
            DB::table('invoice_records')->where('id', $record->id)->update(['reconciliation_state' => 'EXPLAINED', 'reconciliation_note' => mb_substr(trim($note), 0, 2000),
                'reconciliation_noted_by_user_id' => $request->user()->getKey(), 'reconciliation_noted_at' => now(), 'lock_version' => (int) $record->lock_version + 1, 'updated_at' => now()]);
            $this->keys->claim($request, 'INVOICE_EXPLAIN', $key, $recordId, 200);
            $this->audit->account($request, 'INVOICE_DIFFERENCE_EXPLAINED', 'INVOICE_RECORD', (string) $record->id, after: ['order_id' => (string) $order->id]);
        });
    }

    /** @param array{billing_name: string, billing_address: string, tin?: string|null, lock_version?: int|null} $input */
    public function saveBuyerDetails(Request $request, string $orderId, array $input): void
    {
        DB::transaction(function () use ($request, $orderId, $input): void {
            $order = $this->orders->buyerOrder($request, $orderId, true);
            $existing = DB::table('order_invoice_details')->where('order_id', $order->id)->lockForUpdate()->first();
            if ($existing !== null && (int) ($input['lock_version'] ?? 0) !== (int) $existing->lock_version) {
                throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'Your invoice details changed. Refresh before saving again.', 409);
            }
            $tin = isset($input['tin']) && trim((string) $input['tin']) !== '' ? preg_replace('/\D/', '', (string) $input['tin']) : null;
            if ($tin !== null && (strlen((string) $tin) < 9 || strlen((string) $tin) > 14)) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Enter a 9- to 14-digit TIN, or leave it blank.', 422, ['tin' => ['Enter a 9- to 14-digit TIN.']]);
            }
            $values = ['billing_name' => mb_substr(trim($input['billing_name']), 0, 180), 'billing_address' => mb_substr(trim($input['billing_address']), 0, 500),
                'tin_encrypted' => $tin === null ? null : Crypt::encryptString((string) $tin), 'tin_last4' => $tin === null ? null : substr((string) $tin, -4),
                'updated_by_user_id' => $request->user()->getKey(), 'updated_at' => now()];
            if ($existing === null) {
                DB::table('order_invoice_details')->insert($values + ['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'buyer_profile_id' => $order->buyer_profile_id, 'lock_version' => 1, 'created_at' => now()]);
            } else {
                DB::table('order_invoice_details')->where('id', $existing->id)->update($values + ['lock_version' => (int) $existing->lock_version + 1]);
            }
            $this->audit->account($request, 'INVOICE_DETAILS_SAVED', 'ORDER', (string) $order->id, after: ['tin_provided' => $tin !== null]);
        });
    }

    /** @param array{kind: string, details: string, invoice_record_id?: string|null} $input */
    public function request(Request $request, string $orderId, array $input): string
    {
        $key = $this->keys->requireIdempotencyKey($request);

        return DB::transaction(function () use ($request, $orderId, $input, $key): string {
            if ($this->keys->replayed($request, 'INVOICE_REQUEST', $key, $orderId)) {
                return (string) DB::table('invoice_requests')->where('order_id', $orderId)->orderByDesc('created_at')->value('id');
            }
            $order = $this->orders->buyerOrder($request, $orderId, true);
            if (in_array($order->order_state, self::NOT_YET_A_SALE, true)) {
                throw new AuthenticationException('INVOICE_NOT_DUE', 'You can request an invoice once the Vendor confirms the sale.', 409);
            }
            $recordId = null;
            if ($input['kind'] === 'CORRECTION') {
                $recordId = DB::table('invoice_records')->where('id', self::uuid((string) ($input['invoice_record_id'] ?? '')))->where('order_id', $order->id)->value('id');
                if ($recordId === null) {
                    throw new AuthenticationException('VALIDATION_FAILED', 'Choose the invoice that needs a correction.', 422, ['invoice_record_id' => ['Choose an uploaded invoice.']]);
                }
            }
            if (DB::table('invoice_requests')->where('order_id', $order->id)->where('kind', $input['kind'])->where('state', '<>', 'CLOSED')->exists()) {
                throw new AuthenticationException('INVOICE_REQUEST_OPEN', 'You already have an open request of this kind. Follow it on the order.', 409);
            }
            $target = DisputeRules::addBusinessDays(CarbonImmutable::now(), self::SERVICE_TARGET_BUSINESS_DAYS);
            $id = (string) Str::uuid7();
            DB::table('invoice_requests')->insert(['id' => $id, 'order_id' => $order->id, 'vendor_organization_id' => $order->vendor_organization_id, 'buyer_profile_id' => $order->buyer_profile_id,
                'kind' => $input['kind'], 'state' => 'REQUESTED', 'details' => mb_substr(trim($input['details']), 0, 2000), 'invoice_record_id' => $recordId,
                'requested_by_user_id' => $request->user()->getKey(), 'service_target_at' => $target, 'created_at' => now(), 'updated_at' => now()]);
            $this->keys->claim($request, 'INVOICE_REQUEST', $key, $orderId, 201);
            $this->audit->account($request, 'INVOICE_REQUESTED', 'ORDER', (string) $order->id, after: ['request_id' => $id, 'kind' => $input['kind']]);
            $when = $target->setTimezone(DisputeRules::TIMEZONE)->format('M j, Y g:i A');
            $this->notifier->vendor($order, 'Invoice '.strtolower($input['kind']).' requested for order '.$order->reference,
                'The Buyer requested an invoice '.strtolower($input['kind']).'. Upload it by '.$when.' (Asia/Manila). This service target never extends your legal issuance deadline.');

            return $id;
        });
    }

    public function answerRequest(Request $request, string $orderId, string $requestId, string $action, ?string $reason): void
    {
        $key = $this->keys->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $orderId, $requestId, $action, $reason, $key): void {
            if ($this->keys->replayed($request, 'INVOICE_REQUEST_'.$action, $key, $requestId)) {
                return;
            }
            $order = $this->orders->buyerOrder($request, $orderId, true);
            $row = DB::table('invoice_requests')->where('id', self::uuid($requestId))->where('order_id', $order->id)->lockForUpdate()->first();
            if ($row === null) {
                throw new AuthenticationException('INVOICE_REQUEST_NOT_FOUND', 'This request is unavailable.', 404);
            }
            if ($action === 'RETURN') {
                if (! in_array($row->state, ['UPLOADED', 'DOWNLOADED'], true) || mb_strlen(trim((string) $reason)) < 10) {
                    throw new AuthenticationException('INVOICE_REQUEST_STATE_CONFLICT', 'Return an uploaded document with the correction needed (at least 10 characters).', 409);
                }
                DB::table('invoice_requests')->where('id', $row->id)->update(['state' => 'RETURNED_FOR_CORRECTION', 'details' => mb_substr(trim((string) $row->details)."\n\nReturned: ".trim((string) $reason), 0, 4000),
                    'service_target_at' => DisputeRules::addBusinessDays(CarbonImmutable::now(), self::SERVICE_TARGET_BUSINESS_DAYS), 'reminder_sent_at' => null, 'overdue_notified_at' => null,
                    'lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
                $this->notifier->vendor($order, 'Invoice returned for correction on order '.$order->reference, 'The Buyer returned the uploaded invoice for correction: '.trim((string) $reason));
            } else {
                if ($row->state === 'CLOSED') {
                    throw new AuthenticationException('INVOICE_REQUEST_STATE_CONFLICT', 'This request is already closed.', 409);
                }
                DB::table('invoice_requests')->where('id', $row->id)->update(['state' => 'CLOSED', 'closed_at' => now(), 'lock_version' => (int) $row->lock_version + 1, 'updated_at' => now()]);
            }
            $this->keys->claim($request, 'INVOICE_REQUEST_'.$action, $key, $requestId, 200);
            $this->audit->account($request, 'INVOICE_REQUEST_'.$action, 'ORDER', (string) $order->id, after: ['request_id' => (string) $row->id]);
        });
    }

    /** @return array{url: string, expires_at: string} */
    public function link(string $audience, string $recordId): array
    {
        $expires = now()->addMinutes(5);

        return ['url' => URL::temporarySignedRoute(self::ROUTES[$audience], $expires, ['recordId' => $recordId]), 'expires_at' => $expires->toIso8601String()];
    }

    /** Streams an invoice copy after re-authorizing the caller and records the download with the actual user. */
    public function stream(User $user, string $audience, string $recordId, ?string $role, ?string $correlationId): StreamedResponse
    {
        $record = DB::table('invoice_records')->where('id', self::uuid($recordId))->whereNotNull('order_id')->first();
        $order = $record === null ? null : DB::table('orders')->where('id', $record->order_id)->first();
        if ($order === null || ! InvoiceAccess::canDownload($user, $audience, $order)) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This file is unavailable.', 404);
        }
        $file = DB::table('files')->where('id', $record->file_id)->where('visibility', 'PRIVATE')->where('scan_state', 'CLEAN')->first();
        if ($file === null) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This file is unavailable.', 404);
        }
        $metadata = json_decode((string) ($file->metadata ?? '{}'), true) ?: [];
        $stream = Storage::disk(is_string($metadata['disk'] ?? null) ? $metadata['disk'] : $this->store->privateDisk())->readStream((string) $file->object_key);
        if (! is_resource($stream)) {
            throw new AuthenticationException('FILE_UNAVAILABLE', 'The file is temporarily unavailable.', 503);
        }
        DB::transaction(function () use ($record, $user, $audience, $role, $correlationId): void {
            DB::table('invoice_record_downloads')->insert(['id' => (string) Str::uuid7(), 'invoice_record_id' => $record->id, 'user_id' => $user->getKey(), 'audience' => $audience, 'actor_role' => $role,
                'correlation_id' => $correlationId === null ? null : mb_substr($correlationId, 0, 64), 'created_at' => now()]);
            if ($audience === 'BUYER') {
                DB::table('invoice_requests')->where('fulfilled_invoice_record_id', $record->id)->where('state', 'UPLOADED')->update(['state' => 'DOWNLOADED', 'downloaded_at' => now(), 'updated_at' => now()]);
            }
        });

        return response()->streamDownload(static function () use ($stream): void {
            fpassthru($stream);
            fclose($stream);
        }, 'invoice-copy', ['Content-Type' => (string) $file->content_type, 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff', 'Content-Disposition' => 'inline']);
    }

    /** @return array<string, int> reminders one business day before the target and one overdue notice */
    public function sweep(int $limit = 200): array
    {
        $counts = ['reminders' => 0, 'overdue' => 0];
        $now = CarbonImmutable::now();
        $open = DB::table('invoice_requests')->whereIn('state', ['REQUESTED', 'RETURNED_FOR_CORRECTION'])->orderBy('service_target_at')->limit($limit)->get();
        foreach ($open as $row) {
            $order = DB::table('orders')->where('id', $row->order_id)->first();
            $target = CarbonImmutable::parse((string) $row->service_target_at);
            if ($row->overdue_notified_at === null && $target->lessThanOrEqualTo($now)) {
                if (DB::table('invoice_requests')->where('id', $row->id)->whereNull('overdue_notified_at')->update(['overdue_notified_at' => now(), 'updated_at' => now()]) > 0) {
                    $this->notifier->vendor($order, 'Invoice request overdue on order '.$order->reference, 'The three-business-day service target for the Buyer\'s invoice '.strtolower((string) $row->kind).' has passed. Upload it now.', ['OWNER', 'STORE_MANAGER', 'STORE_STAFF']);
                    $counts['overdue']++;
                }
            } elseif ($row->reminder_sent_at === null && DisputeRules::addBusinessDays($now, 1)->greaterThanOrEqualTo($target)) {
                if (DB::table('invoice_requests')->where('id', $row->id)->whereNull('reminder_sent_at')->update(['reminder_sent_at' => now(), 'updated_at' => now()]) > 0) {
                    $this->notifier->vendor($order, 'Invoice request due soon on order '.$order->reference, 'The Buyer\'s invoice '.strtolower((string) $row->kind).' is due by '.$target->setTimezone(DisputeRules::TIMEZONE)->format('M j, Y g:i A').' (Asia/Manila).', ['OWNER', 'STORE_MANAGER', 'STORE_STAFF']);
                    $counts['reminders']++;
                }
            }
        }

        return $counts;
    }

    /**
     * @param  array{organization_id: string, role: string, permissions: list<string>}  $scope
     * @param  array<string, mixed>  $input
     */
    private function insertRecord(object $order, array $scope, array $input, string $fileId, Request $request): string
    {
        if (! in_array($input['invoice_type'], self::VENDOR_TYPES, true)) {
            throw new AuthenticationException('INVOICE_TYPE_NOT_ALLOWED', 'Upload a Vendor goods invoice or a Vendor adjustment document. Platform, processor and Form 2307 documents are separate records.', 422);
        }
        $organization = DB::table('vendor_organizations')->where('id', $order->vendor_organization_id)->first(['legal_business_name', 'legal_name']);
        $registered = (string) ($organization->legal_business_name ?? $organization->legal_name ?? '');
        if ($registered === '' || self::normalize((string) $input['issuer_name']) !== self::normalize($registered)) {
            throw new AuthenticationException('INVOICE_ISSUER_MISMATCH', 'The issuer must be your registered business name exactly as verified: '.$registered.'.', 422, ['issuer_name' => ['Use the registered business name: '.$registered.'.']]);
        }
        $amends = null;
        if (($input['amends_invoice_record_id'] ?? null) !== null) {
            $amends = DB::table('invoice_records')->where('id', self::uuid((string) $input['amends_invoice_record_id']))->where('order_id', $order->id)->first();
            if ($amends === null) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Choose an invoice of this order to amend.', 422, ['amends_invoice_record_id' => ['Choose an uploaded invoice of this order.']]);
            }
        }
        if ($input['invoice_type'] === 'VENDOR_ADJUSTMENT_DOCUMENT' && $amends === null) {
            throw new AuthenticationException('VALIDATION_FAILED', 'An adjustment document references the invoice it adjusts.', 422, ['amends_invoice_record_id' => ['Choose the invoice this document adjusts.']]);
        }
        $issuerKey = hash_hmac('sha256', 'INVOICE_ISSUER|'.$order->vendor_organization_id, (string) config('app.key'));
        $numberHash = hash_hmac('sha256', 'INVOICE_NUMBER|'.Str::upper(trim((string) $input['invoice_number'])), (string) config('app.key'));
        if (DB::table('invoice_records')->where('environment', 'TEST')->where('issuer_taxpayer_key_hash', $issuerKey)->where('invoice_number_hash', $numberHash)->exists()) {
            throw new AuthenticationException('INVOICE_NUMBER_DUPLICATE', 'This invoice number is already recorded for your store. Upload a correction with its own number.', 409);
        }
        $lines = DB::table('order_lines')->where('order_id', $order->id)->pluck('id')->map(fn ($id): string => (string) $id)->all();
        $related = array_values(array_intersect($input['related_line_ids'] ?? [], $lines)) ?: $lines;
        [$expectedTotal, $expectedVat] = self::expected($order, $related, count($related) === count($lines));
        $declaredVat = isset($input['vat_centavos']) ? (int) $input['vat_centavos'] : null;
        $difference = (int) $input['amount_centavos'] - $expectedTotal;
        $state = $input['invoice_type'] === 'VENDOR_ADJUSTMENT_DOCUMENT' ? 'NOT_APPLICABLE'
            : ($difference === 0 && ($declaredVat === null || $declaredVat === $expectedVat) ? 'MATCHED' : 'INVOICE_RECONCILIATION_REQUIRED');
        $requestRow = $this->openRequest($order, $input['invoice_request_id'] ?? null, $amends);
        $id = (string) Str::uuid7();
        DB::table('invoice_records')->insert([
            'id' => $id, 'vendor_organization_id' => $order->vendor_organization_id, 'order_id' => $order->id, 'fee_statement_id' => null, 'environment' => 'TEST',
            'invoice_type' => $input['invoice_type'], 'document_origin' => 'DEMO_SAMPLE', 'issuer' => $registered, 'issuer_taxpayer_key_hash' => $issuerKey,
            'payee_name' => (string) (DB::table('order_invoice_details')->where('order_id', $order->id)->value('billing_name') ?? 'Buyer'), 'payee_taxpayer_key_hash' => null,
            'invoice_number_hash' => $numberHash, 'invoice_number_display' => mb_substr(trim((string) $input['invoice_number']), 0, 64), 'issued_on' => CarbonImmutable::parse((string) $input['issued_on'])->toDateString(),
            'amount_centavos' => (int) $input['amount_centavos'], 'file_id' => $fileId, 'content_hash' => (string) DB::table('files')->where('id', $fileId)->value('checksum_sha256'),
            'verification_state' => 'UNVERIFIED', 'uploaded_by_user_id' => $request->user()->getKey(), 'uploaded_role' => $scope['role'],
            'tax_breakdown' => json_encode(['vat_centavos' => $declaredVat, 'vat_exempt_centavos' => $input['vat_exempt_centavos'] ?? null, 'zero_rated_centavos' => $input['zero_rated_centavos'] ?? null,
                'expected_vat_centavos' => $expectedVat], JSON_THROW_ON_ERROR),
            'related_line_ids' => json_encode($related, JSON_THROW_ON_ERROR), 'source_system' => $input['source_system'], 'invoicing_method' => $input['invoicing_method'],
            'e_invoicing_coverage' => 'REVIEW_REQUIRED', 'amends_invoice_record_id' => $amends?->id, 'expected_total_centavos' => $expectedTotal, 'reconciliation_difference_centavos' => $difference,
            'reconciliation_state' => $state, 'invoice_request_id' => $requestRow?->id, 'created_at' => now(), 'updated_at' => now(),
        ]);
        if ($requestRow !== null) {
            DB::table('invoice_requests')->where('id', $requestRow->id)->update(['state' => 'UPLOADED', 'fulfilled_invoice_record_id' => $id, 'uploaded_at' => now(), 'lock_version' => (int) $requestRow->lock_version + 1, 'updated_at' => now()]);
        }
        if ($amends !== null && $amends->reconciliation_state === 'INVOICE_RECONCILIATION_REQUIRED') {
            DB::table('invoice_records')->where('id', $amends->id)->update(['reconciliation_state' => 'CORRECTED', 'reconciliation_note' => 'Corrected by a later uploaded document.', 'updated_at' => now()]);
        }
        $this->audit->account($request, 'INVOICE_UPLOADED', 'INVOICE_RECORD', $id, after: ['order_id' => (string) $order->id, 'invoice_type' => $input['invoice_type'],
            'invoice_number' => mb_substr(trim((string) $input['invoice_number']), 0, 64), 'issued_on' => (string) $input['issued_on'], 'reconciliation_state' => $state, 'file_sha256' => (string) DB::table('files')->where('id', $fileId)->value('checksum_sha256')]);
        $this->notifier->buyer($order, 'Invoice copy available for order '.$order->reference, 'The Vendor uploaded a copy of its invoice. Open the order to view it. MateryalPH stores the copy; the Vendor issues the invoice through its registered process.');
        if ($state === 'INVOICE_RECONCILIATION_REQUIRED') {
            $this->notifier->vendor($order, 'Invoice difference on order '.$order->reference, 'The uploaded invoice totals differ from the accepted order. Explain or upload a correction; the Buyer\'s agreed amount does not change.', ['OWNER', 'STORE_MANAGER', 'STORE_STAFF']);
        }

        return $id;
    }

    private function openRequest(object $order, ?string $requestId, ?object $amends): ?object
    {
        $query = DB::table('invoice_requests')->where('order_id', $order->id)->whereIn('state', ['REQUESTED', 'RETURNED_FOR_CORRECTION'])->lockForUpdate();
        if ($requestId !== null) {
            $row = (clone $query)->where('id', self::uuid($requestId))->first();
            if ($row === null) {
                throw new AuthenticationException('INVOICE_REQUEST_NOT_OPEN', 'This invoice request is not waiting for an upload.', 409);
            }

            return $row;
        }

        return (clone $query)->where('kind', $amends === null ? 'COPY' : 'CORRECTION')->orderBy('created_at')->first();
    }

    /**
     * Accepted Buyer amounts the Vendor's sale invoice should show: the related lines' frozen payable values, plus the
     * accepted delivery when the invoice covers the whole order. The Buyer's processing fee is never part of it.
     *
     * @param  list<string>  $lineIds
     * @return array{0: int, 1: int}
     */
    private static function expected(object $order, array $lineIds, bool $wholeOrder): array
    {
        $snapshot = DB::table('financial_snapshots')->where('order_id', $order->id)->orderByDesc('version')->first();
        if ($snapshot === null) {
            return [0, 0];
        }
        $lines = DB::table('financial_snapshot_lines')->where('financial_snapshot_id', $snapshot->id)->whereIn('order_line_id', $lineIds)->get(['ordinary_payable_centavos', 'vat_centavos']);
        $total = (int) $lines->sum('ordinary_payable_centavos') + ($wholeOrder ? (int) $snapshot->delivery_centavos : 0);
        $vat = (int) $lines->sum('vat_centavos') + ($wholeOrder ? (int) $snapshot->delivery_vat_centavos : 0);

        return [$total, $vat];
    }

    /** @return array{organization_id: string, role: string, permissions: list<string>} */
    private function vendorScope(Request $request, string $permission, string $message): array
    {
        $scope = $this->orders->vendorScope($request);
        $this->orders->require($scope, $permission, $message);

        return $scope;
    }

    private static function normalize(string $name): string
    {
        return mb_strtolower(trim((string) preg_replace('/\s+/', ' ', str_replace(['.', ','], '', $name))));
    }

    public static function uuid(string $value): string
    {
        return Str::isUuid($value) ? $value : '00000000-0000-0000-0000-000000000000';
    }
}
