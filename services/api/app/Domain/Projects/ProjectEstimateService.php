<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Finance\Money;
use App\Domain\Geography\GeographyProviderUnavailable;
use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderEligibility;
use App\Domain\Procurement\DeliveryPreviewService;
use App\Domain\Procurement\ListingPublicFacts;
use App\Domain\Vendors\DeliveryRecommendationService;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Provider work precedes locks. Price, stock, capability and vehicle revisions are checked again before saving. */
final class ProjectEstimateService
{
    public function __construct(private readonly ProjectService $projects, private readonly PublicVendorProjection $vendors, private readonly EligibleOfferQuery $offers) {}

    /** @return array<string, mixed> */
    public function compile(Request $request, string $id, int $lock, int $radius): array
    {
        $w = $this->projects->package($request, $id);
        if ($this->projects->project($request, $w->project_id)->status !== 'ACTIVE') {
            throw new AuthenticationException('PROJECT_CLOSED', 'This Project is read-only. Saved estimates remain available.', 409);
        }
        ProjectService::version($w, $lock);
        if (! in_array($w->status, ['ACTIVE', 'QUOTATION_INQUIRY'], true) || $w->selected_vendor_organization_id !== null) {
            throw new AuthenticationException('WORK_PACKAGE_LOCKED', 'Activate an unassigned Work Package before scanning.', 409);
        }
        $version = DB::table('work_package_versions')->where('id', $w->current_version_id)->first();
        $content = json_decode($version->content, true);
        $point = $content['site']['point'];
        $candidates = $this->vendors->members()->where('p.bulk_capability', true)->where('p.vacation_mode', false)
            ->whereIn('p.fulfillment_method', $content['fulfillment_method'] === 'PICKUP' ? ['SELF_PICKUP', 'BOTH'] : ['VENDOR_DELIVERY', 'BOTH'])
            ->whereRaw('ST_DWithin(av.location, ST_SetSRID(ST_MakePoint(?, ?),4326)::geography, ?)', [$point['longitude'], $point['latitude'], $radius * 1000 + 0.001])
            ->selectRaw('o.id, av.latitude, av.longitude, ST_Distance(av.location, ST_SetSRID(ST_MakePoint(?, ?),4326)::geography) AS distance', [$point['longitude'], $point['latitude']])
            ->orderBy('o.id')->get();
        $buyer = DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
        $preferences = FulfillmentMatchScore::preferences($buyer);
        $vps = app(ListingPublicFacts::class)->vps($candidates->pluck('id')->all());
        $summaries = $this->vendors->summaries($candidates->pluck('id')->all());
        $compiled = [];
        foreach ($candidates as $candidate) {
            if (! app(OrderEligibility::class)->onlinePaymentReady($candidate->id)) {
                continue;
            }
            $source = $this->fingerprint($candidate->id);
            $lines = $this->match($candidate->id, $content['lines']);
            if (! collect($lines)->contains(fn (array $l): bool => bccomp($l['matched_quantity'], '0', 4) > 0)) {
                continue;
            }
            $matched = $required = '0';
            $subtotal = $vat = 0;
            $missing = [];
            foreach ($lines as $line) {
                $matched = bcadd($matched, $line['matched_quantity'], 4);
                $required = bcadd($required, $line['quantity'], 4);
                $subtotal += (int) $line['amount_centavos'];
                $vat += (int) $line['included_vat_centavos'];
                if (bccomp($line['missing_quantity'], '0', 4) > 0) {
                    $missing[] = ['line_id' => $line['line_id'], 'name' => $line['name'], 'quantity' => $line['missing_quantity'], 'unit_code' => $line['unit_code'], 'reason' => $line['missing_reason']];
                }
            }
            $destination = $content['destination'];
            $previewDestination = $destination + ['_points' => ['intended' => $point + ['active' => true], 'alternate' => $destination['alternate_drop_off'] === null ? null : $destination['alternate_drop_off'] + ['active' => true]]];
            $loadLines = array_map(static fn (array $l): array => ['id' => $l['variant_id'], 'quantity' => $l['matched_quantity'], 'load' => $l['load']], ProjectInquiryService::aggregateLines($lines));
            $delivery = $content['fulfillment_method'] === 'PICKUP' ? DeliveryPreviewService::notApplicable() : app(DeliveryPreviewService::class)->preview($candidate->id, $previewDestination, $loadLines, true);
            $fee = $content['fulfillment_method'] === 'PICKUP' ? 0 : ($delivery['estimate']['fee_min_centavos'] ?? null);
            $total = $fee === null ? null : $subtotal + $fee;
            $distance = (int) round((float) $candidate->distance);
            $score = FulfillmentMatchScore::calculate($matched, $required, $total, (int) $w->budget_centavos, $distance, $radius, $vps[$candidate->id] ?? null, $preferences['weights']);
            $compiled[] = ['vendor_id' => $candidate->id, 'store_name' => $summaries[$candidate->id]['public_store_name'], 'latitude' => (float) $candidate->latitude, 'longitude' => (float) $candidate->longitude,
                'score_label' => $summaries[$candidate->id]['score_label']['text'], 'vps' => $vps[$candidate->id] ?? null, 'fms' => $score, 'complete' => $missing === [], 'fulfillment_percent' => $score['components']['material_match'],
                'missing_lines' => $missing, 'lines' => $lines, 'materials_centavos' => $subtotal, 'included_vat_centavos' => $vat, 'delivery_centavos' => $fee,
                'processing_fee_centavos' => null, 'processing_fee_status' => 'PENDING_PAYMENT_CHANNEL', 'projected_total_centavos' => $total,
                'budget_label' => $total === null ? 'COST_REVIEW_REQUIRED' : ($total > $w->budget_centavos ? 'OVER_BUDGET' : ($total === (int) $w->budget_centavos ? 'WITHIN_BUDGET' : 'UNDER_BUDGET')),
                'distance_meters' => $distance, 'distance_basis' => 'GEODESIC_PROJECT_SITE_TO_STORE', 'eta_seconds' => null,
                'fulfillment_method' => $content['fulfillment_method'], 'payment_method' => $content['payment_method'], 'delivery' => $delivery, 'destination' => $destination,
                'source_fingerprint' => $source, 'vehicle_revisions' => $this->vehicleRevisions($candidate->id), 'label' => 'System-compiled estimate — advisory', 'quotation_state' => 'NO_INQUIRY'];
        }
        usort($compiled, static fn (array $a, array $b): int => ($b['complete'] <=> $a['complete']) ?: (($b['fms']['score'] !== null) <=> ($a['fms']['score'] !== null)) ?: bccomp($b['fms']['score'] ?? '0', $a['fms']['score'] ?? '0', 2) ?: strcmp($a['vendor_id'], $b['vendor_id']));
        $estimateId = DB::transaction(function () use ($request, $id, $lock, $radius, $version, $content, $preferences, $compiled): string {
            $w = $this->projects->package($request, $id, true);
            ProjectService::version($w, $lock);
            if ($w->current_version_id !== $version->id || $w->selected_vendor_organization_id !== null) {
                throw new AuthenticationException('ESTIMATE_VERSION_CONFLICT', 'The Work Package changed while scanning. Refresh and retry.', 409);
            }
            $vendorIds = array_column($compiled, 'vendor_id');
            sort($vendorIds);
            DB::table('vendor_organizations')->whereIn('id', $vendorIds)->orderBy('id')->lockForUpdate()->get(['id']);
            foreach ($compiled as $row) {
                $this->assertFresh($row);
            }
            $id = (string) Str::uuid7();
            DB::table('compiled_estimates')->insert(['id' => $id, 'work_package_version_id' => $version->id, 'expires_at' => now()->addHours(48),
                'context' => json_encode(['site' => $content['site'], 'radius_km' => $radius, 'preferences' => $preferences, 'version_hash' => $version->content_hash], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            foreach ($compiled as $rank => $row) {
                $vendorId = (string) Str::uuid7();
                $row['rank'] = $rank + 1;
                DB::table('compiled_estimate_vendors')->insert(['id' => $vendorId, 'compiled_estimate_id' => $id, 'vendor_organization_id' => $row['vendor_id'],
                    'fms' => $row['fms']['score'], 'projected_total_centavos' => $row['projected_total_centavos'], 'snapshot' => json_encode($row, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                foreach ($row['lines'] as $line) {
                    DB::table('compiled_estimate_lines')->insert(['id' => (string) Str::uuid7(), 'compiled_estimate_vendor_id' => $vendorId,
                        'work_package_line_id' => $line['line_id'], 'listing_variant_id' => $line['variant_id'], 'matched_quantity' => $line['matched_quantity'], 'amount_centavos' => $line['amount_centavos'],
                        'snapshot' => json_encode($line, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                }
            }
            $this->projects->record($request, 'PROJECT_ESTIMATE_COMPILED', $id);

            return $id;
        });

        return $this->show($request, $id, $estimateId);
    }

    /** @param list<array<string, mixed>> $requirements
     * @return list<array<string, mixed>> */
    private function match(string $vendor, array $requirements): array
    {
        $offers = $this->offers->variants([$vendor])->join('products as p', 'p.id', '=', 'l.product_id')->join('units as u', 'u.id', '=', 'v.unit_id')->join('materials as m', 'm.id', '=', 'p.material_id')
            ->orderBy('pv.amount_centavos')->orderBy('v.id')->get(['v.*', 'l.id as listing_id', 'l.display_name', 'l.technical_attributes', 'l.publication_version', 'p.material_id', 'p.brand', 'pv.id as price_version_id', 'pv.amount_centavos', 'pv.tax_category', 'i.confirmed_at', 'u.code as unit_code', 'u.name as unit_name', 'u.precision as unit_precision', 'm.code as material_code', DB::raw('i.quantity_on_hand - i.hard_reserved_quantity AS available')]);
        $remaining = [];
        $result = [];
        foreach ($requirements as $required) {
            $needed = $required['quantity'];
            $allocations = [];
            foreach ($offers as $offer) {
                $attributes = array_merge(json_decode($offer->technical_attributes ?? '{}', true), json_decode($offer->attributes ?? '{}', true));
                $available = $remaining[$offer->id] ?? $offer->available;
                if (bccomp($needed, '0', 4) <= 0) {
                    break;
                }
                if ($offer->material_id !== $required['material_id'] || $offer->unit_id !== $required['unit_id'] || ($required['preferred_brand'] !== null && $required['preferred_brand'] !== $offer->brand)
                    || array_diff_assoc($required['specifications'], $attributes) !== [] || bccomp($available, '0', 4) <= 0) {
                    continue;
                }
                $quantity = bccomp($needed, $available, 4) <= 0 ? $needed : $available;
                $remaining[$offer->id] = bcsub($available, $quantity, 4);
                $needed = bcsub($needed, $quantity, 4);
                $amount = Money::lineAmount($quantity, (int) $offer->amount_centavos);
                $load = ['weight_kg' => $offer->weight_kg, 'length_cm' => $offer->length_cm, 'width_cm' => $offer->width_cm, 'height_cm' => $offer->height_cm];
                if ($offer->material_code === 'READY_MIXED_CONCRETE') {
                    $load += ['material_kind' => DeliveryRecommendationService::READY_MIXED_CONCRETE, 'volume_m3_per_unit' => $offer->unit_code === 'M3' ? '1' : null];
                }
                $allocations[] = ['variant_id' => $offer->id, 'listing_id' => $offer->listing_id, 'description' => $offer->display_name, 'variant_label' => $offer->label, 'brand' => $offer->brand,
                    'matched_quantity' => $quantity, 'unit_price_centavos' => (int) $offer->amount_centavos, 'amount_centavos' => $amount, 'included_vat_centavos' => Money::includedVat($amount, $offer->tax_category),
                    'tax_category' => $offer->tax_category, 'source_price_version_id' => $offer->price_version_id, 'stock_confirmed_at' => $offer->confirmed_at, 'publication_version' => $offer->publication_version,
                    'unit_name' => $offer->unit_name, 'unit_precision' => (int) $offer->unit_precision, 'load' => $load];
            }
            $first = $allocations[0] ?? ['variant_id' => null, 'listing_id' => null, 'unit_price_centavos' => null, 'brand' => null, 'tax_category' => null, 'source_price_version_id' => null,
                'load' => ['weight_kg' => null, 'length_cm' => null, 'width_cm' => null, 'height_cm' => null]];
            $result[] = array_merge($first, ['line_id' => $required['id'], 'name' => $required['name'], 'material_id' => $required['material_id'], 'specifications' => $required['specifications'], 'preferred_brand' => $required['preferred_brand'],
                'quantity' => $required['quantity'], 'unit_id' => $required['unit_id'], 'unit_code' => $required['unit_code'], 'matched_quantity' => bcsub($required['quantity'], $needed, 4),
                'missing_quantity' => $needed, 'missing_reason' => $allocations === [] ? 'NO_EXACT_ACTIVE_MATCH' : 'QUANTITY_NOT_FULFILLABLE', 'allocations' => $allocations,
                'amount_centavos' => array_sum(array_column($allocations, 'amount_centavos')), 'included_vat_centavos' => array_sum(array_column($allocations, 'included_vat_centavos')),
                'availability' => $allocations === [] ? 'UNAVAILABLE' : (bccomp($needed, '0', 4) === 0 ? 'FULFILLABLE' : 'PARTIAL')]);
        }

        return $result;
    }

    /** @return list<array<string, mixed>> */
    private function vehicleRevisions(string $vendor): array
    {
        return array_map(static fn (array $v): array => array_intersect_key($v, array_flip(['id', 'vehicle_version_id', 'rate_version_id', 'number_available', 'active', 'available', 'base_fee_centavos', 'per_km_centavos', 'maximum_distance_km'])), app(DeliveryRecommendationService::class)->eligibleVehicles($vendor));
    }

    public function fingerprint(string $vendor): string
    {
        $offers = $this->offers->variants([$vendor])->orderBy('v.id')->get(['v.id', 'v.unit_id', 'v.attributes', 'v.weight_kg', 'v.length_cm', 'v.width_cm', 'v.height_cm', 'l.technical_attributes', 'l.publication_version', 'pv.id as price_version_id', 'i.quantity_on_hand', 'i.hard_reserved_quantity', 'i.confirmed_at'])->all();
        $org = DB::table('vendor_organizations')->where('id', $vendor)->first(['account_status', 'store_activation_status', 'activation_hold_code', 'marketplace_discoverability_status']);
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $vendor)->first(['status', 'bulk_capability', 'vacation_mode', 'fulfillment_method']);
        $address = DB::table('vendor_addresses')->where('vendor_organization_id', $vendor)->value('current_version_id');

        $coverage = DB::table('delivery_service_areas')->where('vendor_organization_id', $vendor)->orderBy('id')->get(['id', 'active', 'maximum_distance_km'])->all();
        $paymentReady = app(OrderEligibility::class)->onlinePaymentReady($vendor);

        return hash('sha256', json_encode([$org, $profile, $address, $offers, $this->vehicleRevisions($vendor), $coverage, $paymentReady], JSON_THROW_ON_ERROR));
    }

    /** @param array<string, mixed> $snapshot */
    public function assertFresh(array $snapshot): void
    {
        if (! hash_equals($snapshot['source_fingerprint'], $this->fingerprint($snapshot['vendor_id']))) {
            throw new AuthenticationException('ESTIMATE_SOURCE_CHANGED', 'Prices, inventory, capability, address or vehicle rates changed. Refresh the system estimate.', 409);
        }
    }

    /** @return array<string, mixed> */
    public function show(Request $request, string $packageId, ?string $estimateId = null): array
    {
        $w = $this->projects->package($request, $packageId);
        $query = DB::table('compiled_estimates')->where('work_package_version_id', $w->current_version_id);
        if ($estimateId !== null) {
            $query->where('id', $estimateId);
        }
        $e = $query->orderByDesc('created_at')->orderByDesc('id')->first();
        if ($e === null) {
            return ['estimate' => null, 'items' => [], 'page' => 1, 'has_more' => false, 'total' => 0, 'suggested_radius_km' => null];
        }
        $page = DB::table('compiled_estimate_vendors')->where('compiled_estimate_id', $e->id)->orderByRaw("(snapshot->>'rank')::int")->paginate(25);
        $rows = array_map(function (object $row) use ($e, $w): array {
            $s = json_decode($row->snapshot, true);
            $state = DB::table('quotations as q')->join('conversations as c', 'c.id', '=', 'q.conversation_id')->where('q.work_package_id', $w->id)->where('q.vendor_organization_id', $row->vendor_organization_id)
                ->whereRaw("c.locked_reference->>'version_id' = ?", [$w->current_version_id])->orderByDesc('q.updated_at')->value('q.state');

            return $s + ['id' => $row->id, 'estimate_id' => $e->id, 'expires_at' => $e->expires_at, 'stale' => ! hash_equals($s['source_fingerprint'], $this->fingerprint($row->vendor_organization_id)), 'current_quotation_state' => $state ?? 'NO_INQUIRY'];
        }, $page->items());
        $context = json_decode($e->context, true);
        $next = [5 => 10, 10 => 20, 20 => 30, 30 => 40, 40 => 50, 50 => null][$context['radius_km']];

        return ['estimate' => ['id' => $e->id, 'version_id' => $e->work_package_version_id, 'created_at' => $e->created_at, 'expires_at' => $e->expires_at,
            'state' => $e->invalidated_at !== null ? 'INVALIDATED' : (now()->greaterThanOrEqualTo($e->expires_at) ? 'EXPIRED' : 'ACTIVE'), 'context' => $context],
            'items' => $rows, 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages(), 'total' => $page->total(), 'suggested_radius_km' => $page->total() < 3 ? $next : null];
    }

    /** @return array{package: object, estimate: object, snapshot: array<string, mixed>} */
    public function candidate(Request $request, string $packageId, string $candidateId, bool $fresh = true): array
    {
        $w = $this->projects->package($request, $packageId);
        $e = DB::table('compiled_estimate_vendors as v')->join('compiled_estimates as e', 'e.id', '=', 'v.compiled_estimate_id')->where('v.id', $candidateId)->where('e.work_package_version_id', $w->current_version_id)
            ->first(['v.*', 'e.expires_at', 'e.invalidated_at']);
        if ($e === null) {
            throw new AuthenticationException('ESTIMATE_NOT_FOUND', 'Select a candidate from this Work Package version.', 404);
        }
        if ($fresh && ($e->invalidated_at !== null || now()->greaterThanOrEqualTo($e->expires_at))) {
            throw new AuthenticationException('ESTIMATE_EXPIRED', 'Refresh the 48-hour estimate before continuing.', 409);
        }
        $snapshot = json_decode($e->snapshot, true);
        if ($fresh) {
            $this->assertFresh($snapshot);
        }

        return ['package' => $w, 'estimate' => $e, 'snapshot' => $snapshot];
    }

    /** Route origin is the saved Project site, never the alternate delivery endpoint.
     * @return array<string, mixed> */
    public function route(Request $request, string $id, string $candidateId): array
    {
        $candidate = $this->candidate($request, $id, $candidateId);
        $version = DB::table('work_package_versions')->where('id', $candidate['package']->current_version_id)->first();
        $p = json_decode($version->content, true)['site']['point'];
        $s = $candidate['snapshot'];
        try {
            $route = app(RouteProvider::class)->drive((float) $p['latitude'], (float) $p['longitude'], $s['latitude'], $s['longitude']);
        } catch (GeographyProviderUnavailable) {
            throw new AuthenticationException('ROUTE_UNAVAILABLE', 'The Project route is unavailable. Retry; the list remains accessible.', 503);
        }
        if ($route === null) {
            throw new AuthenticationException('ROUTE_NOT_FOUND', 'No driving route was found for this candidate.', 422);
        }
        $current = $this->projects->package($request, $id);
        if ($current->current_version_id !== $version->id) {
            throw new AuthenticationException('ESTIMATE_VERSION_CONFLICT', 'The Work Package changed during the route request.', 409);
        }
        $this->candidate($request, $id, $candidateId);

        return $route + ['candidate_id' => $candidateId, 'version_id' => $version->id, 'origin' => 'PROJECT_SITE', 'computed_at' => now()->toIso8601String()];
    }
}
