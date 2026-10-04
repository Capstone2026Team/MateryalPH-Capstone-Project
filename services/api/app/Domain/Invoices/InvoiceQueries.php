<?php

declare(strict_types=1);

namespace App\Domain\Invoices;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Disputes\DisputeRules;
use App\Domain\Orders\OrderAccess;
use App\Domain\Orders\OrderStates;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;

/**
 * Read models for invoice records and requests on the Buyer order page, the Vendor E-Invoices workspace and the
 * Admin Invoice Request Log. Every uploaded copy is labelled as a DEMO sample in TEST and as not verified for
 * BIR/structured e-invoicing compliance; MateryalPH's own Purchase Order and payment confirmation are labelled "not a
 * tax invoice". No response carries commission, withholding, statements, Earnings or other protected finance.
 */
final class InvoiceQueries
{
    public const PER_PAGE = 20;

    public const COMPLIANCE_NOTE = 'Uploaded copy for reference. An uploaded PDF or image is not proof of BIR registration or structured e-invoicing compliance; the Vendor issues its invoice through its registered process.';

    public const ISSUANCE_NOTICE = 'The Vendor issues its invoice through its own registered process when it is legally due. This does not wait for order completion or a Buyer request, and the three-business-day copy target never extends that deadline.';

    private const NOT_YET_A_SALE = [...OrderStates::PENDING_ACCEPTANCE, OrderStates::AWAITING_PAYMENT, OrderStates::DECLINED, OrderStates::EXPIRED];

    public function __construct(private readonly OrderAccess $orders, private readonly InvoiceService $invoices, private readonly CatalogAccess $access) {}

    /** @return array<string, mixed> */
    public function buyerOrder(Request $request, string $orderId): array
    {
        $order = $this->orders->buyerOrder($request, $orderId);
        $summary = $this->summary($order, 'BUYER', true);
        $details = DB::table('order_invoice_details')->where('order_id', $order->id)->first();
        $open = fn (string $kind): bool => DB::table('invoice_requests')->where('order_id', $order->id)->where('kind', $kind)->where('state', '<>', 'CLOSED')->exists();
        $sale = ! in_array($order->order_state, self::NOT_YET_A_SALE, true);

        return $summary + [
            'billing_details' => $details === null ? null : ['billing_name' => (string) $details->billing_name, 'billing_address' => (string) $details->billing_address,
                'tin_masked' => $details->tin_last4 === null ? null : '•••• '.$details->tin_last4, 'lock_version' => (int) $details->lock_version],
            'can_edit_billing_details' => ! in_array($order->order_state, [OrderStates::DECLINED, OrderStates::EXPIRED], true),
            'can_request_copy' => $sale && ! $open('COPY'),
            'can_request_correction' => $summary['records'] !== [] && ! $open('CORRECTION'),
        ];
    }

    /** @return array<string, mixed> */
    public function vendorOrder(Request $request, string $orderId): array
    {
        $scope = $this->orders->vendorScope($request);
        $this->orders->require($scope, InvoiceService::VIEW, 'Invoices are not available to your role.');
        $order = $this->orders->vendorOrder($scope, $orderId);
        $files = InvoiceAccess::roleCanOpenFiles($scope['role']);
        $summary = $this->summary($order, 'VENDOR', $files);
        $details = DB::table('order_invoice_details')->where('order_id', $order->id)->first();
        $upload = OrderAccess::allows($scope, InvoiceService::UPLOAD);

        return $summary + [
            'billing_details' => $details === null ? null : ['billing_name' => (string) $details->billing_name, 'billing_address' => (string) $details->billing_address,
                // The full TIN is needed to issue the invoice; only the roles that upload it see it.
                'tin' => $upload && $details->tin_encrypted !== null ? Crypt::decryptString((string) $details->tin_encrypted) : null,
                'tin_masked' => $details->tin_last4 === null ? null : '•••• '.$details->tin_last4],
            'can_upload' => $upload && ! in_array($order->order_state, self::NOT_YET_A_SALE, true), 'can_open_files' => $files,
            'issuer_name' => (string) (DB::table('vendor_organizations')->where('id', $order->vendor_organization_id)->value('legal_business_name') ?? ''),
            'invoice_types' => InvoiceService::VENDOR_TYPES, 'source_systems' => InvoiceService::SOURCE_SYSTEMS, 'invoicing_methods' => InvoiceService::INVOICING_METHODS,
            'lines' => DB::table('order_lines')->where('order_id', $order->id)->orderBy('line_number')->get(['id', 'snapshot'])
                ->map(static fn (object $line): array => ['order_line_id' => (string) $line->id, 'display_name' => (string) ((json_decode((string) $line->snapshot, true) ?: [])['display_name'] ?? 'Line')])->all(),
        ];
    }

    /**
     * @param  array{view?: string, page?: int}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function vendorList(Request $request, array $filters): array
    {
        $scope = $this->orders->vendorScope($request);
        $this->orders->require($scope, InvoiceService::VIEW, 'Invoices are not available to your role.');
        $view = $filters['view'] ?? 'REQUESTS';
        $organization = $scope['organization_id'];
        $assigned = $scope['role'] === 'FULFILLMENT' ? DB::table('order_fulfillment_assignments')->select('order_id')->where('user_id', $request->user()->getKey())->whereNull('ended_at') : null;
        $requests = DB::table('invoice_requests')->where('vendor_organization_id', $organization)->where('state', '<>', 'CLOSED');
        $records = DB::table('invoice_records')->where('vendor_organization_id', $organization)->whereNotNull('order_id');
        $due = DB::table('orders as o')->where('o.vendor_organization_id', $organization)->whereNotIn('o.order_state', [...self::NOT_YET_A_SALE, OrderStates::CANCELLED])
            ->whereNotExists(fn (Builder $query) => $query->selectRaw('1')->from('invoice_records as r')->whereColumn('r.order_id', 'o.id')->where('r.invoice_type', 'VENDOR_GOODS_INVOICE'));
        if ($assigned !== null) {
            $requests->whereIn('order_id', $assigned);
            $records->whereIn('order_id', $assigned);
            $due->whereIn('o.id', $assigned);
        }
        $counts = ['REQUESTS' => (clone $requests)->count(), 'DUE' => (clone $due)->count(), 'RECORDS' => (clone $records)->count(),
            'RECONCILIATION' => (clone $records)->where('reconciliation_state', 'INVOICE_RECONCILIATION_REQUIRED')->count()];
        $page = max(1, (int) ($filters['page'] ?? 1));
        [$query, $present] = match ($view) {
            'DUE' => [$due->select('o.*')->orderBy('o.accepted_at'), fn (object $order): array => $this->dueRow($order)],
            'RECORDS' => [$records->orderByDesc('created_at'), fn (object $record): array => $this->recordRow($record, 'VENDOR', false) + ['order_reference' => self::orderReference((string) $record->order_id)]],
            'RECONCILIATION' => [$records->where('reconciliation_state', 'INVOICE_RECONCILIATION_REQUIRED')->orderByDesc('created_at'),
                fn (object $record): array => $this->recordRow($record, 'VENDOR', false) + ['order_reference' => self::orderReference((string) $record->order_id)]],
            default => [$requests->orderBy('service_target_at'), fn (object $row): array => $this->requestRow($row, 'VENDOR') + ['order_reference' => self::orderReference((string) $row->order_id)]],
        };
        $total = (clone $query)->count();
        $items = $query->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get()->map($present)->values()->all();

        return ['items' => $items, 'meta' => ['view' => $view, 'counts' => $counts, 'page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'has_more' => $page * self::PER_PAGE < $total,
            'can_upload' => OrderAccess::allows($scope, InvoiceService::UPLOAD), 'issuance_notice' => self::ISSUANCE_NOTICE]];
    }

    /**
     * @param  array{view?: string, page?: int}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function adminLog(Request $request, array $filters): array
    {
        $this->access->requireAdmin($request, InvoiceService::VIEW);
        $view = $filters['view'] ?? 'REQUESTS';
        $page = max(1, (int) ($filters['page'] ?? 1));
        [$query, $present] = match ($view) {
            'RECORDS' => [DB::table('invoice_records')->whereNotNull('order_id')->orderByDesc('created_at'), fn (object $record): array => $this->adminRecord($record)],
            'MISMATCHES' => [DB::table('invoice_records')->whereNotNull('order_id')->whereIn('reconciliation_state', ['INVOICE_RECONCILIATION_REQUIRED', 'EXPLAINED'])->orderByDesc('created_at'),
                fn (object $record): array => $this->adminRecord($record)],
            default => [DB::table('invoice_requests')->orderByRaw("CASE WHEN state = 'CLOSED' THEN 1 ELSE 0 END")->orderBy('service_target_at'),
                fn (object $row): array => $this->requestRow($row, 'ADMIN') + ['order_reference' => self::orderReference((string) $row->order_id), 'vendor_name' => self::vendorName((string) $row->vendor_organization_id)]],
        };
        $total = (clone $query)->count();
        $items = $query->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get()->map($present)->values()->all();
        $counts = ['REQUESTS_OPEN' => DB::table('invoice_requests')->where('state', '<>', 'CLOSED')->count(),
            'REQUESTS_OVERDUE' => DB::table('invoice_requests')->whereIn('state', ['REQUESTED', 'RETURNED_FOR_CORRECTION'])->where('service_target_at', '<', now())->count(),
            'RECORDS' => DB::table('invoice_records')->whereNotNull('order_id')->count(), 'MISMATCHES' => DB::table('invoice_records')->where('reconciliation_state', 'INVOICE_RECONCILIATION_REQUIRED')->count()];

        return ['items' => $items, 'meta' => ['view' => $view, 'counts' => $counts, 'page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'has_more' => $page * self::PER_PAGE < $total,
            'notice' => 'Read-only. Admins never create or calculate a Vendor tax invoice, never mark a sample as official and never treat a PDF as structured e-invoicing compliance.']];
    }

    /** @return array<string, mixed> */
    private function summary(object $order, string $audience, bool $files): array
    {
        $records = DB::table('invoice_records')->where('order_id', $order->id)->orderBy('created_at')->get();
        $sale = ! in_array($order->order_state, self::NOT_YET_A_SALE, true);

        return [
            'order_id' => (string) $order->id, 'order_reference' => (string) $order->reference,
            'status' => $records->contains(static fn (object $record): bool => $record->invoice_type === 'VENDOR_GOODS_INVOICE') ? 'ISSUED' : ($sale ? 'NOT_YET_UPLOADED' : 'NOT_DUE'),
            'issuance_notice' => self::ISSUANCE_NOTICE,
            'records' => $records->map(fn (object $record): array => $this->recordRow($record, $audience, $files))->values()->all(),
            'requests' => DB::table('invoice_requests')->where('order_id', $order->id)->orderByDesc('created_at')->get()->map(fn (object $row): array => $this->requestRow($row, $audience))->values()->all(),
            'platform_documents' => [
                ['kind' => 'PURCHASE_ORDER', 'title' => 'MateryalPH Purchase Order', 'not_tax_invoice' => true, 'label' => 'Not a tax invoice', 'availability' => 'PHASE_15_PDF_PENDING'],
                ['kind' => 'PAYMENT_CONFIRMATION', 'title' => 'MateryalPH payment confirmation', 'not_tax_invoice' => true, 'label' => 'Not a tax invoice', 'availability' => $order->payment_state === 'PAID' ? 'IN_ORDER_DETAILS' : 'AFTER_PAYMENT'],
            ],
        ];
    }

    /** @return array<string, mixed> */
    private function recordRow(object $record, string $audience, bool $files): array
    {
        $breakdown = json_decode((string) ($record->tax_breakdown ?? '{}'), true) ?: [];

        return [
            'id' => (string) $record->id, 'invoice_type' => (string) $record->invoice_type, 'issuer' => (string) $record->issuer, 'invoice_number' => (string) ($record->invoice_number_display ?? ''),
            'issued_on' => (string) $record->issued_on, 'amount_centavos' => (int) $record->amount_centavos, 'vat_centavos' => isset($breakdown['vat_centavos']) ? (int) $breakdown['vat_centavos'] : null,
            'document_origin' => (string) $record->document_origin, 'origin_label' => $record->document_origin === 'DEMO_SAMPLE' ? 'DEMO sample (TEST)' : 'Vendor registered process',
            'verification_state' => (string) $record->verification_state, 'e_invoicing_coverage' => (string) $record->e_invoicing_coverage, 'compliance_note' => self::COMPLIANCE_NOTE,
            'reconciliation_state' => (string) $record->reconciliation_state, 'reconciliation_difference_centavos' => (int) $record->reconciliation_difference_centavos,
            'expected_total_centavos' => $record->expected_total_centavos === null ? null : (int) $record->expected_total_centavos, 'reconciliation_note' => $record->reconciliation_note,
            'amends_invoice_record_id' => $record->amends_invoice_record_id, 'uploaded_at' => self::iso($record->created_at), 'uploaded_role' => $record->uploaded_role,
            'source_system' => $record->source_system, 'invoicing_method' => $record->invoicing_method,
            'download' => $files ? $this->invoices->link($audience, (string) $record->id) : null,
            'can_explain' => $audience === 'VENDOR' && $files && $record->reconciliation_state === 'INVOICE_RECONCILIATION_REQUIRED',
            'buyer_total_unchanged' => true,
        ];
    }

    /** @return array<string, mixed> */
    private function requestRow(object $row, string $audience): array
    {
        $target = CarbonImmutable::parse((string) $row->service_target_at);

        return [
            'id' => (string) $row->id, 'kind' => (string) $row->kind, 'state' => (string) $row->state, 'details' => $row->details, 'invoice_record_id' => $row->invoice_record_id,
            'fulfilled_invoice_record_id' => $row->fulfilled_invoice_record_id, 'requested_at' => self::iso($row->created_at), 'service_target_at' => $target->toIso8601String(),
            'service_target_label' => $target->setTimezone(DisputeRules::TIMEZONE)->format('M j, Y g:i A').' (Asia/Manila)',
            'overdue' => in_array($row->state, ['REQUESTED', 'RETURNED_FOR_CORRECTION'], true) && $target->isPast(),
            'uploaded_at' => self::iso($row->uploaded_at), 'downloaded_at' => self::iso($row->downloaded_at), 'closed_at' => self::iso($row->closed_at),
            'can_return' => $audience === 'BUYER' && in_array($row->state, ['UPLOADED', 'DOWNLOADED'], true), 'can_close' => $audience === 'BUYER' && $row->state !== 'CLOSED',
        ];
    }

    /** @return array<string, mixed> */
    private function dueRow(object $order): array
    {
        return ['order_id' => (string) $order->id, 'order_reference' => (string) $order->reference, 'order_state' => (string) $order->order_state, 'payment_state' => (string) $order->payment_state,
            'accepted_at' => self::iso($order->accepted_at), 'open_request' => DB::table('invoice_requests')->where('order_id', $order->id)->where('state', '<>', 'CLOSED')->exists(),
            'note' => 'No invoice copy is recorded yet. Issue it through your registered process when legally due; a Buyer request is not required.'];
    }

    /** @return array<string, mixed> */
    private function adminRecord(object $record): array
    {
        return $this->recordRow($record, 'ADMIN', true) + ['order_reference' => self::orderReference((string) $record->order_id), 'vendor_name' => self::vendorName((string) $record->vendor_organization_id),
            'downloads' => DB::table('invoice_record_downloads')->where('invoice_record_id', $record->id)->count(),
            'last_download_at' => self::iso(DB::table('invoice_record_downloads')->where('invoice_record_id', $record->id)->max('created_at'))];
    }

    private static function orderReference(string $orderId): string
    {
        return (string) (DB::table('orders')->where('id', $orderId)->value('reference') ?? '');
    }

    private static function vendorName(string $organizationId): string
    {
        return (string) (DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->value('public_store_name') ?? 'Store');
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
