<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Finance\FinancialCalculator;
use App\Domain\Inventory\InventoryAccess;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Procurement\ListingPublicFacts;
use App\Domain\Projects\ProjectBudget;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;

/**
 * Read models for the Buyer order hub and the Vendor order workspace. Order, payment, fulfillment, refund and
 * dispute are always separate fields. Amounts come from the current commercial version; payment amounts from
 * the FIN-02 matrix, with the processing fee pending until a payment channel exists. Buyer coordinates, exact
 * inventory (outside authorized Vendor roles), private files and commission/withholding never appear.
 */
final class OrderQueries
{
    public const PER_PAGE = 20;

    /** Buyer hub groups. */
    public const BUYER_GROUPS = [
        'AWAITING_ACTION' => [OrderStates::AWAITING_BUYER_APPROVAL, OrderStates::AWAITING_NRPC_ACCEPTANCE, OrderStates::AWAITING_PAYMENT],
        'ACTIVE' => [OrderStates::AWAITING_VENDOR_CONFIRMATION, OrderStates::CONFIRMED, 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'CANCELLATION_REQUESTED'],
        'COMPLETED' => [OrderStates::COMPLETED],
        'CANCELLED' => [OrderStates::DECLINED, OrderStates::EXPIRED, OrderStates::CANCELLED],
        'DISPUTED' => ['DISPUTED'],
    ];

    /** Vendor workspace status filters. */
    public const VENDOR_GROUPS = [
        'NEW' => [OrderStates::AWAITING_VENDOR_CONFIRMATION],
        'WAITING_ON_BUYER' => [OrderStates::AWAITING_BUYER_APPROVAL, OrderStates::AWAITING_NRPC_ACCEPTANCE],
        'AWAITING_PAYMENT' => [OrderStates::AWAITING_PAYMENT],
        'CONFIRMED' => [OrderStates::CONFIRMED, 'PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP', 'CANCELLATION_REQUESTED', 'DISPUTED'],
        'CLOSED' => [OrderStates::COMPLETED, OrderStates::DECLINED, OrderStates::EXPIRED, OrderStates::CANCELLED],
    ];

    public function __construct(
        private readonly OrderAccess $access,
        private readonly OrderExpiryService $expiry,
        private readonly NrpcTerms $terms,
    ) {}

    /**
     * @param  array{group?: string, page?: int}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function buyerList(Request $request, array $filters): array
    {
        $buyerId = $this->access->buyerProfileId($request);
        $this->expiry->expireDueFor('buyer_profile_id', $buyerId);
        $query = DB::table('orders as o')->where('o.buyer_profile_id', $buyerId);
        $group = $filters['group'] ?? 'ALL';
        if ($group !== 'ALL') {
            $query->whereIn('o.order_state', self::BUYER_GROUPS[$group]);
        }

        return $this->page($query, (int) ($filters['page'] ?? 1), fn (object $order): array => $this->summary($order) + ['next_action' => $this->buyerNextAction($order)], ['group' => $group,
            'counts' => $this->counts(DB::table('orders')->where('buyer_profile_id', $buyerId), self::BUYER_GROUPS)]);
    }

    /** @return array<string, mixed> */
    public function buyerDetail(Request $request, string $orderId): array
    {
        $order = $this->access->buyerOrder($request, $orderId);
        if ($this->expiry->expireIfDue((string) $order->id)) {
            $order = $this->access->buyerOrder($request, $orderId);
        }
        $detail = $this->detail($order, false);
        $nrpc = $detail['nrpc'];
        if (($detail['destination']['type'] ?? null) === 'DELIVERY') {
            // The Buyer's own access instructions; shown back to them and to the fulfilling Vendor only.
            $detail['destination']['access_instructions'] = $order->access_instructions_encrypted === null ? null : Crypt::decryptString((string) $order->access_instructions_encrypted);
        }
        $detail['available_actions'] = array_values(array_filter([
            $order->order_state === OrderStates::AWAITING_BUYER_APPROVAL ? 'APPROVE_REVISION' : null,
            $order->order_state === OrderStates::AWAITING_BUYER_APPROVAL ? 'REJECT_REVISION' : null,
            $order->order_state === OrderStates::AWAITING_NRPC_ACCEPTANCE ? 'ACCEPT_NRPC' : null,
            $order->order_state === OrderStates::AWAITING_NRPC_ACCEPTANCE ? 'REJECT_NRPC' : null,
            $nrpc !== null && $nrpc['flag'] === null && ! OrderStates::isClosed((string) $order->order_state) ? 'FLAG_NRPC' : null,
        ]));
        $detail['payment'] = ['available' => false, 'reason' => $order->order_state === OrderStates::AWAITING_PAYMENT ? 'ONLINE_PAYMENT_NOT_YET_ENABLED' : null,
            'notice' => $order->order_state === OrderStates::AWAITING_PAYMENT ? 'Online payment opens in the payments release. Your stock stays reserved until the payment window ends.' : null];

        return $detail;
    }

    /**
     * @param  array{group?: string, q?: string, page?: int}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function vendorList(Request $request, array $filters): array
    {
        $scope = $this->access->vendorScope($request);
        $this->expiry->expireDueFor('vendor_organization_id', $scope['organization_id']);
        $base = DB::table('orders as o')->where('o.vendor_organization_id', $scope['organization_id']);
        if ($scope['role'] === 'FULFILLMENT') {
            $base->whereNotIn('o.order_state', [...OrderStates::PENDING_ACCEPTANCE, OrderStates::AWAITING_PAYMENT, OrderStates::DECLINED]);
        }
        $query = clone $base;
        $group = $filters['group'] ?? 'ALL';
        if ($group !== 'ALL') {
            $query->whereIn('o.order_state', self::VENDOR_GROUPS[$group]);
        }
        $term = trim((string) ($filters['q'] ?? ''));
        if ($term !== '') {
            $like = '%'.str_replace(['\\', '%', '_'], ['\\\\', '\\%', '\\_'], mb_strtolower($term)).'%';
            $query->where(fn (Builder $match) => $match->whereRaw('lower(o.reference) like ?', [$like])->orWhereExists(fn (Builder $buyer) => $buyer->selectRaw('1')->from('buyer_profiles as b')
                ->join('user_profiles as up', 'up.user_id', '=', 'b.user_id')->whereColumn('b.id', 'o.buyer_profile_id')->whereRaw('lower(up.full_name) like ?', [$like])));
        }

        return $this->page($query, (int) ($filters['page'] ?? 1), fn (object $order): array => $this->summary($order) + [
            'buyer' => ['display_name' => $this->buyerName((string) $order->buyer_profile_id)],
            'primary_action' => $this->vendorPrimaryAction($order),
            'nrpc_indicator' => (int) $order->nrpc_centavos > 0,
        ], ['group' => $group, 'counts' => $this->counts($base, self::VENDOR_GROUPS)]);
    }

    /** @return array<string, mixed> */
    public function vendorDetail(Request $request, string $orderId): array
    {
        $scope = $this->access->vendorScope($request);
        $order = $this->access->vendorOrder($scope, $orderId);
        if ($this->expiry->expireIfDue((string) $order->id)) {
            $order = $this->access->vendorOrder($scope, $orderId);
        }
        $detail = $this->detail($order, true);
        $lines = DB::table('order_lines')->where('order_id', $order->id)->orderBy('line_number')->get();
        if (OrderAccess::allows($scope, InventoryAccess::VIEW)) {
            $inventory = DB::table('inventory_items')->whereIn('listing_variant_id', $lines->pluck('listing_variant_id')->all())->get()->keyBy('listing_variant_id');
            foreach ($detail['lines'] as $index => $line) {
                $item = $inventory->get($lines[$index]->listing_variant_id);
                $detail['lines'][$index]['inventory'] = $item === null ? null : ['quantity_on_hand' => StockAvailability::quantity($item->quantity_on_hand),
                    'hard_reserved_quantity' => StockAvailability::quantity($item->hard_reserved_quantity),
                    'available_to_sell' => StockAvailability::availableToSell(StockAvailability::quantity($item->quantity_on_hand), StockAvailability::quantity($item->hard_reserved_quantity))];
            }
        }
        $pending = $order->order_state === OrderStates::AWAITING_VENDOR_CONFIRMATION;
        $terms = $this->terms->current();
        $detail['buyer'] = ['display_name' => $this->buyerName((string) $order->buyer_profile_id)];
        $detail['auto_accept'] = json_decode((string) ($order->auto_accept_outcome ?? 'null'), true);
        $detail['reservations'] = DB::table('inventory_holds as h')->join('order_lines as l', 'l.id', '=', 'h.order_line_id')->where('h.source_type', 'ORDER')->where('h.source_id', $order->id)
            ->orderBy('l.line_number')->get(['h.order_line_id', 'h.quantity', 'h.state', 'h.release_reason', 'h.created_at', 'h.released_at'])
            ->map(static fn (object $hold): array => ['order_line_id' => (string) $hold->order_line_id, 'quantity' => StockAvailability::quantity($hold->quantity), 'state' => (string) $hold->state,
                'release_reason' => $hold->release_reason, 'reserved_at' => self::iso($hold->created_at), 'released_at' => self::iso($hold->released_at)])->all();
        $detail['permissions'] = [
            'can_confirm' => $pending && OrderAccess::allows($scope, OrderAccess::CONFIRM),
            'can_revise' => $pending && OrderAccess::allows($scope, OrderAccess::REVISE),
            'can_set_nrpc' => $pending && OrderAccess::allows($scope, OrderAccess::SET_NRPC),
            'can_confirm_delivery' => $pending && $order->fulfillment_method === 'DELIVERY' && OrderAccess::allows($scope, OrderAccess::CONFIRM_DELIVERY),
            'can_decline' => $pending && OrderAccess::allows($scope, OrderAccess::CONFIRM),
            'can_view_inventory' => OrderAccess::allows($scope, InventoryAccess::VIEW),
        ];
        $detail['primary_action'] = $this->vendorPrimaryAction($order);
        $detail['nrpc_terms'] = $terms === null ? null : ['id' => $terms['id'], 'version' => $terms['version'], 'title' => $terms['title'], 'available' => $terms['content'] !== null];
        $detail['decline_reasons'] = OrderConfirmationService::DECLINE_REASONS;

        return $detail;
    }

    /** @return array<string, mixed> */
    private function detail(object $order, bool $forVendor): array
    {
        $snapshots = DB::table('order_snapshots')->where('order_id', $order->id)->orderBy('version')->get()->keyBy('version');
        $current = $snapshots->get((int) $order->current_snapshot_version);
        $content = $current === null ? [] : OrderCommercial::content($current);
        $submitted = $snapshots->get(1) === null ? [] : OrderCommercial::content($snapshots->get(1));
        $commercial = $content['commercial'] ?? null;
        $confirmedLines = [];
        $orderLineIds = DB::table('order_lines')->where('order_id', $order->id)->pluck('id', 'listing_variant_id')->all();
        foreach (($content['lines'] ?? []) as $line) {
            $lineId = $line['order_line_id'] ?? $orderLineIds[$line['variant_id'] ?? ''] ?? null;
            if ($lineId !== null) {
                $confirmedLines[(string) $lineId] = $line + ['confirmed_quantity' => $line['quantity'] ?? null];
            }
        }
        $vendorVersion = (int) $order->current_snapshot_version > 1;
        $computed = [];
        foreach (($commercial['lines'] ?? []) as $line) {
            $computed[(string) $line['line_id']] = $line;
        }
        $lines = [];
        foreach (DB::table('order_lines')->where('order_id', $order->id)->orderBy('line_number')->get() as $line) {
            $snapshot = json_decode((string) $line->snapshot, true) ?: [];
            $confirmed = $vendorVersion ? ($confirmedLines[(string) $line->id]['confirmed_quantity'] ?? null) : null;
            $amounts = $computed[(string) $line->id] ?? null;
            $requested = StockAvailability::quantity($line->quantity);
            $lines[] = [
                'id' => (string) $line->id, 'line_number' => (int) $line->line_number, 'listing_id' => (string) $line->vendor_listing_id, 'listing_variant_id' => (string) $line->listing_variant_id,
                'display_name' => (string) ($snapshot['display_name'] ?? ''), 'variant_label' => $snapshot['variant_label'] ?? null, 'brand' => $snapshot['brand'] ?? null,
                'category' => $snapshot['category'] ?? null, 'image' => $snapshot['image'] ?? null, 'unit_code' => (string) ($snapshot['unit_code'] ?? ''), 'unit_name' => (string) ($snapshot['unit_name'] ?? ''),
                'unit_precision' => (int) ($snapshot['unit_precision'] ?? 0), 'quantity_step' => (string) ($snapshot['quantity_step'] ?? '1'),
                'requested_quantity' => $requested, 'confirmed_quantity' => $confirmed,
                'unit_price_centavos' => $amounts['unit_price_centavos'] ?? (int) $line->unit_price_centavos, 'ordinary_unit_price_centavos' => $line->ordinary_unit_price_centavos === null ? null : (int) $line->ordinary_unit_price_centavos,
                'volume_tier_applied' => (bool) ($snapshot['volume_tier_applied'] ?? false), 'volume_tiers' => json_decode((string) ($line->volume_tiers ?? '[]'), true) ?: [],
                'gross_centavos' => $amounts['gross_centavos'] ?? 0, 'discount_centavos' => $amounts['discount_centavos'] ?? 0, 'line_total_centavos' => $amounts['payable_centavos'] ?? 0,
                'included_vat_centavos' => $amounts['vat_centavos'] ?? 0, 'tax_category' => (string) $line->tax_category, 'vat_label' => ListingPublicFacts::vatLabel((string) $line->tax_category),
                'change' => $confirmed === null || bccomp($confirmed, $requested, 4) === 0 ? null : (bccomp($confirmed, '0', 4) === 0 ? 'LINE_REMOVED' : 'QUANTITY_REDUCED'),
                'price_version_id' => $line->listing_price_version_id === null ? null : (string) $line->listing_price_version_id,
            ];
        }
        $vendor = DB::table('store_profiles')->where('vendor_organization_id', $order->vendor_organization_id)->first(['public_store_name', 'logo_file_id']);
        $destination = OrderDeliveryPlanner::destination($order);
        $nrpc = $this->nrpc($order, $lines);
        $projectContext = null;
        if ($order->work_package_version_id !== null) {
            $version = DB::table('work_package_versions as v')->join('work_packages as w', 'w.id', '=', 'v.work_package_id')->join('projects as p', 'p.id', '=', 'w.project_id')
                ->where('v.id', $order->work_package_version_id)->first(['v.id', 'v.version', 'v.content_hash', 'v.content', 'p.name as project_name']);
            if ($version !== null) {
                $projectContext = ['version_id' => $version->id, 'version' => (int) $version->version, 'content_hash' => $version->content_hash, 'project_name' => $version->project_name,
                    'work_package' => json_decode($version->content, true), 'note' => $order->project_note, 'note_response_required' => false,
                    'budget' => $forVendor ? null : app(ProjectBudget::class)->metrics(DB::table('projects as p')->join('work_packages as w', 'w.project_id', '=', 'p.id')->where('w.id', $order->work_package_id)->first(['p.*']), DB::table('work_packages')->where('id', $order->work_package_id)->first()),
                    'document_status' => 'PHASE_15_PDF_PENDING'];
            }
        }

        return [
            'id' => (string) $order->id, 'reference' => (string) $order->reference, 'checkout' => $this->checkout($order),
            'vendor' => ['id' => (string) $order->vendor_organization_id, 'name' => (string) ($vendor->public_store_name ?? 'Store')],
            'procurement_type' => (string) $order->procurement_type, 'fulfillment_method' => (string) $order->fulfillment_method, 'payment_method' => (string) $order->payment_method,
            'project_context' => $projectContext,
            'submitted_at' => self::iso($order->submitted_at ?? $order->created_at), 'accepted_at' => self::iso($order->accepted_at), 'closed_at' => self::iso($order->closed_at),
            'terminal_reason_code' => $order->terminal_reason_code, 'confirmation_source' => $order->confirmation_source,
            'states' => $this->states($order),
            'deadlines' => ['vendor_response_due_at' => self::iso($order->vendor_response_due_at), 'buyer_response_due_at' => self::iso($order->buyer_response_due_at),
                'payment_expires_at' => self::iso($order->payment_expires_at), 'server_time' => now()->toIso8601String(), 'timezone' => 'Asia/Manila'],
            'commercial_version' => ['current' => (int) $order->current_snapshot_version, 'accepted' => $order->accepted_snapshot_version === null ? null : (int) $order->accepted_snapshot_version,
                'kind' => $current?->kind, 'content_hash' => $current?->content_hash, 'recorded_at' => $current === null ? null : self::iso($current->created_at)],
            'changes' => $content['changes'] ?? [],
            'expected_fulfillment_date' => $order->expected_fulfillment_date,
            'lines' => $lines,
            'destination' => $destination === [] ? null : (($destination['type'] ?? null) === 'PICKUP'
                ? ['type' => 'PICKUP', 'store_address' => $destination['store_address'] ?? null]
                : ['type' => 'DELIVERY', 'intended' => OrderDeliveryPlanner::publicPoint($destination['intended'] ?? null), 'heavy_vehicle_restriction' => $destination['heavy_vehicle_restriction'] ?? null,
                    'alternate_drop_off' => OrderDeliveryPlanner::publicPoint($destination['alternate_drop_off'] ?? null), 'vehicle_endpoint' => $destination['vehicle_endpoint'] ?? null,
                    'access_instructions' => $forVendor && $order->access_instructions_encrypted !== null ? Crypt::decryptString((string) $order->access_instructions_encrypted) : null]),
            'delivery' => $this->delivery($order, $submitted),
            'money' => $this->money($order, $commercial, $nrpc),
            'nrpc' => $nrpc,
            'timeline' => DB::table('order_status_history')->where('order_id', $order->id)->orderBy('created_at')->orderBy('id')
                ->get(['state_family', 'from_state', 'to_state', 'source', 'actor_role', 'reason_code', 'snapshot_version', 'created_at'])
                ->map(static fn (object $row): array => ['family' => (string) $row->state_family, 'from_state' => $row->from_state, 'to_state' => (string) $row->to_state, 'source' => (string) $row->source,
                    'actor_role' => $row->actor_role, 'reason_code' => $row->reason_code, 'snapshot_version' => $row->snapshot_version === null ? null : (int) $row->snapshot_version, 'at' => self::iso($row->created_at)])->all(),
            'lock_version' => (int) $order->lock_version,
        ];
    }

    /** @return list<array{family: string, state: string}> */
    private function states(object $order): array
    {
        return array_map(static fn (string $family): array => ['family' => $family, 'state' => (string) $order->{OrderStates::COLUMNS[$family]}],
            [OrderStates::ORDER, OrderStates::PAYMENT, OrderStates::FULFILLMENT, OrderStates::REFUND, OrderStates::DISPUTE]);
    }

    /**
     * @param  array<string, mixed>|null  $commercial
     * @param  array<string, mixed>|null  $nrpc
     * @return array<string, mixed>
     */
    private function money(object $order, ?array $commercial, ?array $nrpc): array
    {
        $delivery = $order->fulfillment_method === 'PICKUP' ? ['status' => 'NOT_APPLICABLE', 'amount_centavos' => 0]
            : ($order->delivery_centavos === null ? ['status' => 'PENDING_VENDOR_CONFIRMATION', 'amount_centavos' => null] : ['status' => 'CONFIRMED', 'amount_centavos' => (int) $order->delivery_centavos]);
        $estimate = null;
        if ($delivery['status'] === 'PENDING_VENDOR_CONFIRMATION') {
            $first = DB::table('order_snapshots')->where('order_id', $order->id)->where('version', 1)->first();
            $range = $first === null ? null : (OrderCommercial::content($first)['delivery_estimate']['estimate'] ?? null);
            $estimate = is_array($range) ? ['min_centavos' => (int) $range['fee_min_centavos'], 'max_centavos' => (int) $range['fee_max_centavos']] : null;
        }
        $matrix = $commercial !== null && $commercial['commercial_total_centavos'] !== null ? FinancialCalculator::paymentMatrix($commercial, (string) $order->payment_method, null) : null;
        $vat = (int) ($commercial['materials_vat_centavos'] ?? 0);

        return [
            'currency' => 'PHP', 'calculation_version' => (string) ($commercial['calculation_version'] ?? FinancialCalculator::VERSION),
            'status' => $order->accepted_at !== null ? 'ACCEPTED' : ((int) $order->current_snapshot_version > 1 ? 'AWAITING_BUYER_ACCEPTANCE' : 'ADVISORY_UNTIL_VENDOR_CONFIRMATION'),
            'materials_gross_centavos' => (int) ($commercial['materials_gross_centavos'] ?? $order->materials_centavos),
            'vendor_discount_centavos' => (int) ($commercial['vendor_discount_centavos'] ?? 0),
            'materials_subtotal_centavos' => (int) ($commercial['materials_payable_centavos'] ?? $order->materials_centavos),
            'included_vat_centavos' => $vat, 'vat_exclusive_centavos' => (int) ($commercial['materials_exclusive_centavos'] ?? $order->materials_centavos),
            'vat_treatment' => $vat > 0 ? 'PRICES_INCLUDE_VAT' : 'NO_INCLUDED_VAT',
            'delivery' => $delivery + ['estimate' => $estimate],
            'nrpc' => ['amount_centavos' => (int) $order->nrpc_centavos, 'within_order_value' => true, 'status' => $nrpc['status'] ?? null],
            'processing_fee' => $matrix['processing_fee'] ?? ['status' => 'PENDING_PAYMENT_CHANNEL', 'amount_centavos' => null],
            'commercial_total_centavos' => $matrix === null ? null : (int) $matrix['commercial_total_centavos'],
            'amount_due_online_centavos' => $matrix['amount_due_online_centavos'] ?? null,
            'online_principal_centavos' => $matrix['online_principal_centavos'] ?? null,
            'physical_balance_centavos' => $matrix['physical_balance_centavos'] ?? null,
            'payment_purpose' => $matrix['purpose'] ?? null,
            'excludes' => ['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'],
        ];
    }

    /**
     * @param  list<array<string, mixed>>  $lines
     * @return array<string, mixed>|null
     */
    private function nrpc(object $order, array $lines): ?array
    {
        $record = DB::table('nrpc_records')->where('order_id', $order->id)->orderByDesc('order_snapshot_version')->first();
        if ($record === null) {
            return null;
        }
        $labels = array_column($lines, 'display_name', 'id');
        $decisions = DB::table('nrpc_acceptances')->where('nrpc_record_id', $record->id)->get()->keyBy('decision');
        $accepted = $decisions->get('ACCEPTED');
        $flag = $decisions->get('FLAGGED');
        $terms = $this->terms->version((string) $record->agreement_version_id);

        return [
            'id' => (string) $record->id, 'amount_centavos' => (int) $record->amount_centavos, 'reason' => (string) $record->reason,
            'eligible_subtotal_centavos' => $record->eligible_subtotal_centavos === null ? null : (int) $record->eligible_subtotal_centavos,
            'snapshot_version' => (int) $record->order_snapshot_version, 'proposed_at' => self::iso($record->created_at),
            'affected_lines' => DB::table('nrpc_line_allocations')->where('nrpc_record_id', $record->id)->orderBy('order_line_id')->get()
                ->map(static fn (object $allocation): array => ['order_line_id' => (string) $allocation->order_line_id, 'label' => (string) ($labels[(string) $allocation->order_line_id] ?? ''),
                    'principal_centavos' => (int) $allocation->principal_centavos, 'line_payable_centavos' => (int) $allocation->line_payable_centavos, 'included_vat_centavos' => (int) $allocation->vat_centavos])->all(),
            'terms' => $terms,
            'cancellation_effect' => 'If you cancel during preparation and the Vendor substantiates the preparation, the Vendor may keep this amount. If the Vendor cancels, it is forfeited and fully refunded. It never limits remedies for defective, incorrect or nonconforming goods.',
            'status' => $accepted !== null ? 'ACCEPTED' : ($decisions->has('REJECTED') ? 'REJECTED' : 'PROPOSED'),
            'accepted_at' => $accepted === null ? null : self::iso($accepted->created_at),
            'flag' => $flag === null ? null : ['review_state' => (string) $flag->review_state, 'reason' => (string) $flag->reason, 'flagged_at' => self::iso($flag->created_at)],
        ];
    }

    /**
     * @param  array<string, mixed>  $submitted
     * @return array<string, mixed>
     */
    private function delivery(object $order, array $submitted): array
    {
        if ($order->fulfillment_method === 'PICKUP') {
            return ['status' => 'NOT_APPLICABLE', 'estimate' => null, 'confirmed' => null];
        }
        $row = DB::table('order_delivery_snapshots')->where('order_id', $order->id)->first();
        $confirmed = null;
        if ($row !== null) {
            $snapshot = json_decode((string) $row->snapshot, true) ?: [];
            $confirmed = [
                'vehicles' => array_map(static fn (array $vehicle): array => [
                    'name' => $vehicle['configuration']['name'] ?? null, 'vehicle_category' => $vehicle['configuration']['vehicle_category'] ?? null,
                    'vehicle_type' => $vehicle['configuration']['vehicle_type'] ?? null, 'custom_type_name' => $vehicle['configuration']['custom_type_name'] ?? null,
                    'brand' => $vehicle['configuration']['brand'] ?? null, 'capacity_kg' => isset($vehicle['configuration']['capacity_kg']) ? (string) $vehicle['configuration']['capacity_kg'] : null,
                    'heavy_classification' => $vehicle['configuration']['heavy_classification'] ?? null, 'configuration_version' => $vehicle['configuration_version'] ?? null,
                    'rate_version' => $vehicle['rate_version'] ?? null, 'number_of_vehicles' => (int) $vehicle['number_of_vehicles'], 'total_vehicle_trips' => (int) $vehicle['total_vehicle_trips'],
                    'per_trip_centavos' => (int) $vehicle['per_trip_centavos'], 'trip_total_centavos' => (int) $vehicle['trip_total_centavos'],
                ], $snapshot['vehicles'] ?? []),
                'distance_meters' => (int) ($snapshot['distance_meters'] ?? 0), 'route_source' => $snapshot['route_source'] ?? null, 'basis' => $snapshot['basis'] ?? null,
                // The Phase 5 advisory names the alternate endpoint ALTERNATIVE_DROP_OFF; clients use the cart vocabulary.
                'endpoint' => ($snapshot['endpoint'] ?? null) === 'ALTERNATIVE_DROP_OFF' ? 'ALTERNATE_DROP_OFF' : ($snapshot['endpoint'] ?? null), 'heavy_vehicle_restriction' => (bool) ($snapshot['heavy_vehicle_restriction'] ?? false),
                'intended' => OrderDeliveryPlanner::publicPoint($snapshot['intended_location'] ?? null), 'alternate_drop_off' => OrderDeliveryPlanner::publicPoint($snapshot['alternative_drop_off'] ?? null),
                'final_fee_centavos' => (int) $row->final_charge_centavos, 'fulfillment_date' => $snapshot['fulfillment_date'] ?? null, 'arrangement' => $snapshot['arrangement'] ?? null,
                'calculation_version' => $snapshot['calculation_version'] ?? null, 'confirmed_by_role' => $snapshot['confirmed_by']['role'] ?? null, 'confirmed_at' => $snapshot['confirmed_at'] ?? null,
            ];
        }
        $estimate = $submitted['delivery_estimate'] ?? null;

        return [
            'status' => $confirmed !== null ? 'CONFIRMED' : (($estimate['status'] ?? null) === 'ADVISORY_ESTIMATE' ? 'ADVISORY_ESTIMATE' : 'PENDING_VENDOR_REVIEW'),
            'estimate' => is_array($estimate['estimate'] ?? null) ? ['fee_min_centavos' => (int) $estimate['estimate']['fee_min_centavos'], 'fee_max_centavos' => (int) $estimate['estimate']['fee_max_centavos'],
                'trips_min' => (int) $estimate['estimate']['trips_min'], 'trips_max' => (int) $estimate['estimate']['trips_max']] : null,
            'confirmed' => $confirmed,
        ];
    }

    /** @return array<string, mixed>|null */
    private function checkout(object $order): ?array
    {
        $checkout = $order->checkout_group_id === null ? null : DB::table('checkout_groups')->where('id', $order->checkout_group_id)->first(['id', 'reference']);

        return $checkout === null ? null : ['id' => (string) $checkout->id, 'reference' => (string) $checkout->reference];
    }

    /** @return array<string, mixed> */
    private function summary(object $order): array
    {
        $lines = DB::table('order_lines')->where('order_id', $order->id)->orderBy('line_number')->get(['snapshot']);
        $first = $lines->isEmpty() ? [] : (json_decode((string) $lines[0]->snapshot, true) ?: []);
        $vendor = DB::table('store_profiles')->where('vendor_organization_id', $order->vendor_organization_id)->value('public_store_name');

        return [
            'id' => (string) $order->id, 'reference' => (string) $order->reference, 'vendor' => ['id' => (string) $order->vendor_organization_id, 'name' => (string) ($vendor ?? 'Store')],
            'submitted_at' => self::iso($order->submitted_at ?? $order->created_at), 'procurement_type' => (string) $order->procurement_type, 'confirmation_source' => $order->confirmation_source,
            'states' => $this->states($order), 'fulfillment_method' => (string) $order->fulfillment_method, 'payment_method' => (string) $order->payment_method,
            'line_count' => $lines->count(), 'first_line' => ['display_name' => (string) ($first['display_name'] ?? ''), 'image' => $first['image'] ?? null],
            'materials_centavos' => (int) $order->materials_centavos, 'delivery_centavos' => $order->delivery_centavos === null ? null : (int) $order->delivery_centavos,
            'commercial_total_centavos' => (int) $order->commercial_total_centavos, 'delivery_pending' => $order->delivery_centavos === null,
            'deadline' => self::deadline($order), 'expected_fulfillment_date' => $order->expected_fulfillment_date,
        ];
    }

    /** @return array{kind: string, at: string}|null */
    private static function deadline(object $order): ?array
    {
        return match ($order->order_state) {
            OrderStates::AWAITING_VENDOR_CONFIRMATION => $order->vendor_response_due_at === null ? null : ['kind' => 'VENDOR_RESPONSE', 'at' => (string) self::iso($order->vendor_response_due_at)],
            OrderStates::AWAITING_BUYER_APPROVAL, OrderStates::AWAITING_NRPC_ACCEPTANCE => $order->buyer_response_due_at === null ? null : ['kind' => 'BUYER_RESPONSE', 'at' => (string) self::iso($order->buyer_response_due_at)],
            OrderStates::AWAITING_PAYMENT => $order->payment_expires_at === null ? null : ['kind' => 'PAYMENT', 'at' => (string) self::iso($order->payment_expires_at)],
            default => null,
        };
    }

    private function buyerNextAction(object $order): ?string
    {
        return match ($order->order_state) {
            OrderStates::AWAITING_BUYER_APPROVAL => 'REVIEW_REVISION',
            OrderStates::AWAITING_NRPC_ACCEPTANCE => 'REVIEW_NRPC',
            OrderStates::AWAITING_PAYMENT => 'PAY',
            default => null,
        };
    }

    private function vendorPrimaryAction(object $order): string
    {
        return match ($order->order_state) {
            OrderStates::AWAITING_VENDOR_CONFIRMATION => 'CONFIRM',
            OrderStates::AWAITING_BUYER_APPROVAL, OrderStates::AWAITING_NRPC_ACCEPTANCE => 'WAITING_FOR_BUYER',
            OrderStates::AWAITING_PAYMENT => 'WAITING_FOR_PAYMENT',
            OrderStates::CONFIRMED => 'PREPARE_WHEN_AVAILABLE',
            default => 'NONE',
        };
    }

    private function buyerName(string $buyerProfileId): string
    {
        return (string) (DB::table('buyer_profiles as b')->join('user_profiles as up', 'up.user_id', '=', 'b.user_id')->where('b.id', $buyerProfileId)->value('up.full_name') ?? 'Buyer');
    }

    /**
     * @param  array<string, list<string>>  $groups
     * @return array<string, int>
     */
    private function counts(Builder $base, array $groups): array
    {
        $rows = (clone $base)->groupBy('order_state')->selectRaw('order_state, count(*) as total')->pluck('total', 'order_state');
        $counts = ['ALL' => (int) $rows->sum()];
        foreach ($groups as $group => $states) {
            $counts[$group] = (int) $rows->only($states)->sum();
        }

        return $counts;
    }

    /**
     * @param  callable(object): array<string, mixed>  $present
     * @param  array<string, mixed>  $meta
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    private function page(Builder $query, int $page, callable $present, array $meta): array
    {
        $page = max(1, min(1000, $page));
        $total = (clone $query)->count();
        $rows = $query->orderByDesc('o.created_at')->orderByDesc('o.id')->offset(($page - 1) * self::PER_PAGE)->limit(self::PER_PAGE)->get(['o.*']);

        return ['items' => $rows->map($present)->all(), 'meta' => $meta + ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total,
            'has_more' => $page * self::PER_PAGE < $total, 'current_as_of' => now()->toIso8601String()]];
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
