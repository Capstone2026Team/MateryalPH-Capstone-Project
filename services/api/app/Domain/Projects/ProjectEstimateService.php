<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Catalog\ReadyMixedConcrete;
use App\Domain\Finance\Money;
use App\Domain\Geography\GeographyProviderUnavailable;
use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Geography\RadiusPolicy;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderEligibility;
use App\Domain\Orders\OrderStates;
use App\Domain\Payments\PaymentMethodPolicy;
use App\Domain\Procurement\DeliveryPreviewService;
use App\Domain\Procurement\ListingPublicFacts;
use App\Domain\Vendors\DeliveryRecommendationService;
use App\Domain\Vendors\VendorDeliveryEligibility;
use Illuminate\Http\Request;
use Illuminate\Pagination\LengthAwarePaginator;
use Illuminate\Support\Collection;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Provider work precedes locks. Price, stock, capability and vehicle revisions are checked again before saving. */
final class ProjectEstimateService
{
    public function __construct(private readonly ProjectService $projects, private readonly PublicVendorProjection $vendors, private readonly EligibleOfferQuery $offers) {}

    /** @return array<string, mixed> */
    public function compile(Request $request, string $id, int $lock): array
    {
        $radius = RadiusPolicy::PROJECT_BASED_KM;
        $w = $this->projects->package($request, $id);
        if ($this->projects->project($request, $w->project_id)->status !== 'ACTIVE') {
            throw new AuthenticationException('PROJECT_CLOSED', 'This Project is read-only. Saved estimates remain available.', 409);
        }
        ProjectService::version($w, $lock);
        if (! in_array($w->status, ['ACTIVE', 'QUOTATION_INQUIRY'], true) || $w->selected_vendor_organization_id !== null || $w->selected_arrangement_id !== null) {
            throw new AuthenticationException('WORK_PACKAGE_LOCKED', 'Activate an unassigned Work Package before scanning.', 409);
        }
        $version = DB::table('work_package_versions')->where('id', $w->current_version_id)->first();
        $content = json_decode($version->content, true);
        $point = $content['site']['point'];
        $concretePickup = $content['fulfillment_method'] === 'PICKUP' && $this->hasConcrete($content['lines']);
        $candidates = $this->candidates($point, $concretePickup ? 'BOTH' : $content['fulfillment_method'], $radius);
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
            $distance = (int) round((float) $candidate->distance);
            // A Both package is priced once for each method the Vendor offers; the Buyer picks one when inquiring or selecting.
            $views = [];
            foreach ($candidate->methods as $method) {
                $view = self::concrete($content, $method);
                $priced = $this->price($candidate->id, $view, [], ['distance' => $distance, 'radius' => $radius, 'budget' => (int) $w->budget_centavos, 'vps' => $vps[$candidate->id] ?? null, 'weights' => $preferences['weights']]);
                if ($priced !== null && (! $concretePickup || $method !== 'DELIVERY' || self::suppliesConcrete($priced))) {
                    $views[$method] = $priced + ['fulfillment_method' => $method, 'destination' => $view['destination']];
                }
            }
            if ($views === []) {
                continue;
            }
            if (isset($views['DELIVERY']) && self::suppliesConcrete($views['DELIVERY'])) {
                // One supplier request has one method. A group containing concrete
                // cannot switch to pickup and silently lose that product.
                unset($views['PICKUP']);
            }
            $default = self::preferred($views);
            $compiled[] = ['vendor_id' => $candidate->id, 'store_name' => $summaries[$candidate->id]['public_store_name'], 'latitude' => (float) $candidate->latitude, 'longitude' => (float) $candidate->longitude,
                'score_label' => $summaries[$candidate->id]['score_label']['text'], 'vps' => $vps[$candidate->id] ?? null] + $views[$default] + [
                    'processing_fee_centavos' => null, 'processing_fee_status' => 'PENDING_PAYMENT_CHANNEL',
                    'distance_meters' => $distance, 'distance_basis' => 'GEODESIC_PROJECT_SITE_TO_STORE', 'eta_seconds' => null,
                    'payment_method' => 'ONLINE', 'fulfillment_options' => array_values(array_intersect(['DELIVERY', 'PICKUP'], array_keys($views))),
                    'source_fingerprint' => $source, 'vehicle_revisions' => $this->vehicleRevisions($candidate->id), 'label' => 'System-compiled estimate — advisory', 'quotation_state' => 'NO_INQUIRY']
                + (count($views) > 1 ? ['method_views' => $views] : []);
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

    /** Bulk-capable, open Tier 2 stores within the radius of the site, each with the `methods` it offers that suit the package.
     * A Both package accepts a store offering Site Delivery, Self-Pickup or both; Site Delivery also needs live delivery eligibility.
     *
     * @param array<string, mixed> $point
     * @return Collection<int, \stdClass> */
    private function candidates(array $point, string $fulfillment, int $radius): Collection
    {
        $wanted = $fulfillment === 'BOTH' ? ['DELIVERY', 'PICKUP'] : [$fulfillment];
        $delivers = in_array('DELIVERY', $wanted, true);
        $pickups = in_array('PICKUP', $wanted, true);
        $deliverable = $delivers ? app(VendorDeliveryEligibility::class)->availableOrganizations()->pluck('vendor_organization_id')->all() : [];

        return $this->vendors->members()->where('p.bulk_capability', true)->where('p.vacation_mode', false)
            ->whereIn('p.fulfillment_method', array_merge($pickups ? ['SELF_PICKUP'] : [], $delivers ? ['VENDOR_DELIVERY'] : [], ['BOTH']))
            ->whereRaw('ST_DWithin(av.location, ST_SetSRID(ST_MakePoint(?, ?),4326)::geography, ?)', [$point['longitude'], $point['latitude'], $radius * 1000 + 0.001])
            ->selectRaw('o.id, p.fulfillment_method AS profile_method, av.latitude, av.longitude, ST_Distance(av.location, ST_SetSRID(ST_MakePoint(?, ?),4326)::geography) AS distance', [$point['longitude'], $point['latitude']])
            ->orderBy('o.id')->get()
            ->map(static function (object $row) use ($delivers, $pickups, $deliverable): object {
                $row->methods = array_values(array_filter([
                    $delivers && in_array($row->profile_method, ['VENDOR_DELIVERY', 'BOTH'], true) && in_array($row->id, $deliverable, true) ? 'DELIVERY' : null,
                    $pickups && in_array($row->profile_method, ['SELF_PICKUP', 'BOTH'], true) ? 'PICKUP' : null,
                ]));

                return $row;
            })->filter(static fn (object $row): bool => $row->methods !== [])->values();
    }

    /** The package content for one offered method, including the delivery-only concrete exception to Pickup.
     * @param array<string, mixed> $content
     * @return array<string, mixed> */
    public static function concrete(array $content, string $method): array
    {
        $destination = ['type' => $method] + $content['destination'];
        if ($method === 'PICKUP') {
            // A pick-up has no vehicle drop-off; the intended location stays the reference point.
            $destination = ['heavy_vehicle_restriction' => 'NO', 'alternate_drop_off' => null, 'vehicle_endpoint' => 'INTENDED_LOCATION'] + $destination;
        }

        return ['fulfillment_method' => $method, 'destination' => $destination] + $content;
    }

    /** The method a Vendor card opens on: a complete match first, then the better score, then Self-Pickup.
     * @param array<string, array<string, mixed>> $views priced views keyed by method */
    private static function preferred(array $views): string
    {
        $methods = array_keys($views);
        usort($methods, static fn (string $a, string $b): int => ($views[$b]['complete'] <=> $views[$a]['complete'])
            ?: bccomp($views[$b]['fms']['score'] ?? '0', $views[$a]['fms']['score'] ?? '0', 2) ?: strcmp($b, $a));

        return $methods[0];
    }

    /** @param array<string, mixed> $view */
    private static function suppliesConcrete(array $view): bool
    {
        foreach ($view['lines'] as $line) {
            foreach (array_merge($line['allocations'], $line['options'] ?? []) as $offer) {
                if (($offer['load']['material_kind'] ?? null) === ReadyMixedConcrete::MATERIAL_CODE) {
                    return true;
                }
            }
        }

        return false;
    }

    /** Apply the concrete rule to an unassigned comparison compiled before this correction.
     * @param array<string, mixed> $snapshot
     * @return array<string, mixed> */
    private static function deliveryOnly(array $snapshot): array
    {
        $delivery = $snapshot['method_views']['DELIVERY'] ?? ($snapshot['fulfillment_method'] === 'DELIVERY' ? $snapshot : null);
        if ($delivery !== null && self::suppliesConcrete($delivery)) {
            $snapshot = array_merge($snapshot, $delivery, ['fulfillment_method' => 'DELIVERY', 'fulfillment_options' => ['DELIVERY']]);
            unset($snapshot['method_views']);
        }

        return $snapshot;
    }

    /** @param array<int, array<string, mixed>> $lines */
    private function hasConcrete(array $lines): bool
    {
        return DB::table('materials')->whereIn('id', array_values(array_filter(array_column($lines, 'material_id'))))->where('code', ReadyMixedConcrete::MATERIAL_CODE)->exists();
    }

    /** The candidate as one concrete method. A Vendor offering both needs the Buyer's choice; an unoffered method is refused.
     * @param array<string, mixed> $snapshot
     * @return array<string, mixed> */
    public static function resolve(array $snapshot, ?string $method): array
    {
        $options = $snapshot['fulfillment_options'] ?? [$snapshot['fulfillment_method']];
        if ($method === null) {
            if (count($options) > 1) {
                throw new AuthenticationException('FULFILLMENT_CHOICE_REQUIRED', 'Choose Site Delivery or Self-Pickup for this Vendor.', 422, ['fulfillment_options' => $options]);
            }

            return $snapshot;
        }
        if (! in_array($method, $options, true)) {
            throw new AuthenticationException('FULFILLMENT_NOT_OFFERED', 'This Vendor does not offer that fulfillment method for the package. Refresh the Work Package candidates.', 422);
        }

        return array_merge($snapshot, $snapshot['method_views'][$method] ?? [], ['fulfillment_method' => $method]);
    }

    /**
     * Advisory budget estimate for a Work Package being drafted.
     * Each catalog line is priced at the half-up average of one price per Vendor (that Vendor's lowest eligible
     * exact match: material, unit, brand when set, and every stated specification) among the Vendors scanning
     * would consider. Unlisted lines and lines without a match are reported as such, never guessed.
     * Delivery/Both add actual supplier delivery estimates. Labor and processing are excluded. Nothing is stored.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function budgetEstimate(Request $request, string $projectId, array $input): array
    {
        $this->projects->project($request, $projectId);
        $site = DB::table('project_sites')->where('id', $input['site_id'])->where('project_id', $projectId)->where('active', true)->first();
        if ($site === null) {
            throw new AuthenticationException('SITE_NOT_FOUND', 'Select a site from this Project.', 422);
        }
        $point = json_decode($site->snapshot, true);
        $method = $input['fulfillment_method'] === 'PICKUP' ? 'PICKUP' : 'DELIVERY';
        $concretePickup = $method === 'PICKUP' && $this->hasConcrete($input['lines']);
        $suppliers = $this->candidates($point, $concretePickup ? 'BOTH' : $method, RadiusPolicy::PROJECT_BASED_KM)
            ->filter(fn (object $vendor): bool => app(OrderEligibility::class)->onlinePaymentReady($vendor->id))->keyBy('id');
        $vendors = $suppliers->keys()->all();
        $materials = array_values(array_unique(array_filter(array_column($input['lines'], 'material_id'))));
        $offers = $vendors === [] || $materials === [] ? collect() : $this->offers->variants($vendors)->join('products as p', 'p.id', '=', 'l.product_id')->join('units as u', 'u.id', '=', 'v.unit_id')->whereIn('p.material_id', $materials)
            ->select(['v.id', 'v.unit_id', 'v.attributes', 'v.weight_kg', 'v.length_cm', 'v.width_cm', 'v.height_cm', 'u.code as unit_code', 'l.vendor_organization_id', 'l.technical_attributes', 'p.material_id', 'p.brand', 'pv.amount_centavos', DB::raw('i.quantity_on_hand - i.hard_reserved_quantity AS available')])
            ->selectRaw(ReadyMixedConcrete::listingSql('l').' AS ready_mixed_concrete')->orderBy('v.id')->get();
        $lines = [];
        $choices = [];
        $total = 0;
        // Validated wildcard data can reorder lines that omit a key; report in request order.
        $requested = $input['lines'];
        ksort($requested);
        foreach ($requested as $index => $line) {
            $materialId = $line['material_id'] ?? null;
            $specifications = $line['specifications'] ?? [];
            $brand = $line['preferred_brand'] ?? null;
            $lowest = [];
            foreach ($materialId === null ? [] : $offers as $offer) {
                $attributes = SpecificationMatch::offered($offer->technical_attributes, $offer->attributes);
                if ($offer->material_id !== $materialId || $offer->unit_id !== $line['unit_id'] || ($brand !== null && $brand !== $offer->brand)
                    || ! SpecificationMatch::satisfies($specifications, $attributes) || bccomp((string) $offer->available, (string) $line['quantity'], 4) < 0
                    || ! in_array($offer->ready_mixed_concrete ? 'DELIVERY' : $method, $suppliers[$offer->vendor_organization_id]->methods, true)) {
                    continue;
                }
                $lowest[$offer->vendor_organization_id] = min($lowest[$offer->vendor_organization_id] ?? PHP_INT_MAX, (int) $offer->amount_centavos);
                $choices[$index][] = $offer;
            }
            if ($lowest === []) {
                $lines[] = ['index' => $index, 'status' => $materialId === null ? 'UNLISTED' : 'NO_PRICE_DATA', 'average_unit_price_centavos' => null, 'amount_centavos' => null, 'vendor_count' => 0];

                continue;
            }
            $average = intdiv(2 * array_sum($lowest) + count($lowest), 2 * count($lowest));
            $amount = Money::lineAmount((string) $line['quantity'], $average);
            $total += $amount;
            $lines[] = ['index' => $index, 'status' => 'PRICED', 'average_unit_price_centavos' => $average, 'amount_centavos' => $amount, 'vendor_count' => count($lowest)];
        }
        $priced = count(array_filter($lines, static fn (array $line): bool => $line['status'] === 'PRICED'));
        $deliveryFee = 0;
        $issues = [];
        $hasDelivery = $method === 'DELIVERY' || $concretePickup;
        if ($hasDelivery) {
            // Keep the marketplace materials average. Price delivery on an actual,
            // exact-match supplier plan, consolidating loads and charging each supplier once.
            $coverage = [];
            foreach ($choices as $index => $options) {
                foreach ($options as $offer) {
                    $coverage[$offer->vendor_organization_id][$index] = true;
                }
            }
            uasort($choices, static fn (array $a, array $b): int => count($a) <=> count($b));
            $groups = $stock = [];
            foreach ($choices as $index => $options) {
                usort($options, static fn (object $a, object $b): int => (isset($groups[$b->vendor_organization_id]) <=> isset($groups[$a->vendor_organization_id]))
                    ?: (count($coverage[$b->vendor_organization_id]) <=> count($coverage[$a->vendor_organization_id])) ?: ($a->amount_centavos <=> $b->amount_centavos) ?: strcmp($a->id, $b->id));
                $assigned = false;
                foreach ($options as $offer) {
                    $stock[$offer->id] ??= (string) $offer->available;
                    $quantity = (string) $requested[$index]['quantity'];
                    if (bccomp($stock[$offer->id], $quantity, 4) < 0) {
                        continue;
                    }
                    $stock[$offer->id] = bcsub($stock[$offer->id], $quantity, 4);
                    $vendor = (string) $offer->vendor_organization_id;
                    $load = ['weight_kg' => $offer->weight_kg, 'length_cm' => $offer->length_cm, 'width_cm' => $offer->width_cm, 'height_cm' => $offer->height_cm]
                        + ReadyMixedConcrete::load($offer->ready_mixed_concrete ? ReadyMixedConcrete::MATERIAL_CODE : null, $offer->unit_code);
                    $groups[$vendor][$offer->id] ??= ['id' => $offer->id, 'quantity' => '0', 'load' => $load];
                    $groups[$vendor][$offer->id]['quantity'] = bcadd($groups[$vendor][$offer->id]['quantity'], $quantity, 4);
                    $assigned = true;
                    break;
                }
                if (! $assigned) {
                    $issues[] = 'The selected quantities need supplier availability review.';
                }
            }
            $alternate = ($input['heavy_vehicle_restriction'] ?? 'UNANSWERED') === 'YES' && isset($input['alternate_drop_off_location_id']) ? $this->projects->point($request, $input['alternate_drop_off_location_id']) : null;
            $destination = ['type' => 'DELIVERY', 'intended' => $point, 'heavy_vehicle_restriction' => $input['heavy_vehicle_restriction'] ?? 'UNANSWERED',
                'alternate_drop_off' => $alternate, 'vehicle_endpoint' => $alternate === null ? 'INTENDED_LOCATION' : 'ALTERNATE_DROP_OFF',
                '_points' => ['intended' => $point + ['active' => true], 'alternate' => $alternate === null ? null : $alternate + ['active' => true]]];
            foreach ($groups as $vendor => $load) {
                if ($method === 'PICKUP' && ! collect($load)->contains(static fn (array $line): bool => ($line['load']['material_kind'] ?? null) === ReadyMixedConcrete::MATERIAL_CODE)) {
                    continue;
                }
                $preview = app(DeliveryPreviewService::class)->preview($vendor, $destination, array_values($load), true);
                $fee = $preview['estimate']['fee_min_centavos'] ?? null;
                if ($fee === null) {
                    $issues = array_merge($issues, array_column($preview['issues'], 'message'));
                    $issues[] = 'A supplier delivery fee needs Vendor review.';
                } else {
                    $deliveryFee += $fee;
                }
            }
            if ($priced !== count($lines) || $issues !== []) {
                $deliveryFee = null;
            }
        }
        $complete = $priced === count($lines) && $deliveryFee !== null;

        return ['lines' => $lines, 'materials_total_centavos' => $total, 'priced_line_count' => $priced, 'unpriced_line_count' => count($lines) - $priced,
            'delivery_centavos' => $deliveryFee, 'estimated_total_centavos' => $complete ? $total + $deliveryFee : null,
            'delivery_status' => ! $hasDelivery ? 'NOT_APPLICABLE' : ($deliveryFee === null ? 'REVIEW_REQUIRED' : 'ESTIMATED'),
            'delivery_issues' => array_values(array_unique($issues)), 'fulfillment_method' => $method,
            'radius_km' => RadiusPolicy::PROJECT_BASED_KM, 'basis' => 'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE', 'excludes' => ['LABOR', 'PROCESSING_FEE'], 'computed_at' => now()->toIso8601String()];
    }

    /**
     * Prices one Vendor for the package: matched lines, totals, delivery estimate and score. Delivery uses the
     * route provider, so call this outside any lock. Null when the Vendor supplies nothing.
     *
     * @param  array<string, mixed>  $content
     * @param  array<string, string>  $selections  Work Package line id => specification option id
     * @param  array{distance: int, radius: int, budget: int, vps: ?string, weights: array<string, mixed>}  $basis
     * @return array<string, mixed>|null
     */
    private function price(string $vendor, array $content, array $selections, array $basis): ?array
    {
        $lines = $this->match($vendor, $content['lines'], $selections, (string) $content['fulfillment_method']);
        if (! collect($lines)->contains(fn (array $l): bool => bccomp($l['matched_quantity'], '0', 4) > 0)) {
            return null;
        }
        // Material Match is the average share of each requirement the Vendor supplies. Lines are in different units (blocks, cubic metres, bags), so quantities are never added across lines.
        $matched = $required = '0';
        $subtotal = $vat = 0;
        $missing = [];
        foreach ($lines as $line) {
            $matched = bcadd($matched, bccomp($line['quantity'], '0', 4) <= 0 ? '0' : bcdiv($line['matched_quantity'], $line['quantity'], 8), 8);
            $required = bcadd($required, '1', 8);
            $subtotal += (int) $line['amount_centavos'];
            $vat += (int) $line['included_vat_centavos'];
            if (bccomp($line['missing_quantity'], '0', 4) > 0) {
                $missing[] = ['line_id' => $line['line_id'], 'name' => $line['name'], 'quantity' => $line['missing_quantity'], 'unit_code' => $line['unit_code'], 'reason' => $line['missing_reason']];
            }
        }
        $point = $content['site']['point'];
        $destination = $content['destination'];
        $previewDestination = $destination + ['_points' => ['intended' => $point + ['active' => true], 'alternate' => $destination['alternate_drop_off'] === null ? null : $destination['alternate_drop_off'] + ['active' => true]]];
        $loadLines = array_map(static fn (array $l): array => ['id' => $l['variant_id'], 'quantity' => $l['matched_quantity'], 'load' => $l['load']], ProjectInquiryService::aggregateLines($lines));
        $delivery = $content['fulfillment_method'] === 'PICKUP' ? DeliveryPreviewService::notApplicable() : app(DeliveryPreviewService::class)->preview($vendor, $previewDestination, $loadLines, true);
        $fee = $content['fulfillment_method'] === 'PICKUP' ? 0 : ($delivery['estimate']['fee_min_centavos'] ?? null);
        $total = $fee === null ? null : $subtotal + $fee;
        $score = FulfillmentMatchScore::calculate($matched, $required, $total, $basis['budget'], $basis['distance'], $basis['radius'], $basis['vps'], $basis['weights']);

        return ['fms' => $score, 'complete' => $missing === [], 'fulfillment_percent' => $score['components']['material_match'], 'missing_lines' => $missing, 'lines' => $lines,
            'materials_centavos' => $subtotal, 'included_vat_centavos' => $vat, 'delivery_centavos' => $fee, 'projected_total_centavos' => $total,
            'budget_label' => $total === null ? 'COST_REVIEW_REQUIRED' : ($total > $basis['budget'] ? 'OVER_BUDGET' : ($total === $basis['budget'] ? 'WITHIN_BUDGET' : 'UNDER_BUDGET')),
            'delivery' => $delivery, 'selection_required' => collect($lines)->contains(fn (array $l): bool => $l['selection_required'])];
    }

    /**
     * Owner request 2026-10-16: when a Vendor offers several specifications that each satisfy a line (the Buyer
     * left a detail open), the Buyer chooses one. This re-prices a fresh candidate with those choices; nothing is
     * stored. Selection and inquiry apply the same choices again before they write.
     *
     * @param  array<string, string>  $selections  Work Package line id => specification option id
     * @return array<string, mixed> the candidate snapshot with the choices applied
     */
    public function withSelections(Request $request, string $packageId, string $candidateId, array $selections, ?string $method = null): array
    {
        $candidate = $this->candidate($request, $packageId, $candidateId);
        // A Vendor offering both opens on its preferred method until the Buyer picks one.
        $s = self::resolve($candidate['snapshot'], $method ?? $candidate['snapshot']['fulfillment_method']);
        $offered = [];
        foreach ($s['lines'] as $line) {
            $offered[$line['line_id']] = array_column($line['options'] ?? [], 'option_id');
        }
        foreach ($selections as $lineId => $optionId) {
            if (! in_array($optionId, $offered[$lineId] ?? [], true)) {
                throw new AuthenticationException('SPECIFICATION_OPTION_INVALID', 'Choose one of the listed specifications for this material.', 422, ['line_id' => $lineId]);
            }
        }
        $content = self::concrete(json_decode((string) DB::table('work_package_versions')->where('id', $candidate['package']->current_version_id)->value('content'), true), $s['fulfillment_method']);
        $context = json_decode((string) DB::table('compiled_estimates')->where('id', $candidate['estimate']->compiled_estimate_id)->value('context'), true);
        $priced = $this->price((string) $s['vendor_id'], $content, $selections, ['distance' => (int) $s['distance_meters'], 'radius' => RadiusPolicy::PROJECT_BASED_KM,
            'budget' => (int) $candidate['package']->budget_centavos, 'vps' => $s['vps'] ?? null, 'weights' => $context['preferences']['weights']]);
        if ($priced === null) {
            throw new AuthenticationException('ESTIMATE_SOURCE_CHANGED', 'Prices, inventory, capability, address or vehicle rates changed. Refresh the system estimate.', 409);
        }

        return array_merge($s, $priced, ['specification_selections' => (object) $selections, 'destination' => $content['destination']]);
    }

    /** Reconcile a recommendation's quantity with chosen specifications without a delivery-provider call.
     * @param array<string, string> $selections
     * @return array<string, mixed> */
    public function coverageSnapshot(Request $request, string $packageId, string $candidateId, array $selections, ?string $method): array
    {
        $candidate = $this->candidate($request, $packageId, $candidateId, false);
        $snapshot = self::resolve($candidate['snapshot'], $method ?? $candidate['snapshot']['fulfillment_method']);
        $content = json_decode((string) DB::table('work_package_versions')->where('id', $candidate['package']->current_version_id)->value('content'), true);
        $snapshot['lines'] = $this->match((string) $snapshot['vendor_id'], $content['lines'], $selections, $snapshot['fulfillment_method']);

        return $snapshot;
    }

    /** The candidate as the comparison list shows it.
     * @param array<string, mixed> $snapshot
     * @param array<string, mixed> $favorites
     * @param array<string, list<array<string, mixed>>> $purchases separate Item-Based purchases by Work Package line id
     * @return array<string, mixed> */
    private function view(Request $request, array $snapshot, string $rowId, string $estimateId, mixed $expiresAt, object $w, array $favorites, array $purchases, bool $projectOnly = false): array
    {
        if ($w->selected_vendor_organization_id === null) {
            $snapshot = self::deliveryOnly($snapshot);
        }
        // The other methods' priced views stay server-side; the Buyer re-prices through selection-preview.
        unset($snapshot['method_views']);
        $snapshot['payment_methods'] = app(PaymentMethodPolicy::class)->options((string) $snapshot['vendor_id'], (string) $snapshot['fulfillment_method']);
        $draft = app(ProjectProcurementDraft::class);
        $items = ProjectProcurementDraft::items($w, (string) $snapshot['vendor_id'], (string) $snapshot['fulfillment_method']);
        if ($projectOnly) {
            $eligible = DB::table('store_profiles')->where('bulk_capability', true)->whereIn('vendor_organization_id', array_column($items, 'vendor_id'))->pluck('vendor_organization_id')->all();
            $items = array_values(array_filter($items, static fn (array $i): bool => in_array($i['vendor_id'], $eligible, true)));
            $purchases = array_map(static fn (array $rows): array => array_values(array_filter($rows, static fn (array $i): bool => $i['stage'] !== 'IN_CART')), $purchases);
        }
        $stale = ! hash_equals($snapshot['source_fingerprint'], $this->fingerprint((string) $snapshot['vendor_id']));
        if (! $stale && now()->lessThan($expiresAt)) {
            $items = ProjectProcurementDraft::priceItems(array_merge($items, $draft->automaticItems($request, $w, $rowId, $snapshot, $items, $projectOnly)));
        }
        foreach ($items as $item) {
            $purchases[$item['line_id']][] = $item;
        }
        $images = app(ListingPublicFacts::class)->images(array_values(array_unique(array_filter(array_merge(
            array_column(ProjectInquiryService::aggregateLines($snapshot['lines']), 'listing_id'),
            ...array_map(static fn (array $line): array => array_column($line['options'] ?? [], 'listing_id'), $snapshot['lines'])
        )))));
        foreach ($snapshot['lines'] as &$line) {
            foreach ($line['allocations'] as &$allocation) {
                $allocation['image'] = $images[$allocation['listing_id']][0] ?? null;
            }
            unset($allocation);
            foreach ($line['options'] as &$option) {
                $option['image'] = $images[$option['listing_id']][0] ?? null;
            }
            unset($option);
        }
        unset($line);
        // Derived on every read from the lines and the current separate purchases, never stored, so it cannot drift from the order summary.
        $snapshot['fulfillment'] = PackageFulfillment::summarize($snapshot['lines'], $purchases, (int) $snapshot['materials_centavos'], $snapshot['projected_total_centavos'] === null ? null : (int) $snapshot['projected_total_centavos']);

        $state = DB::table('quotations as q')->join('conversations as c', 'c.id', '=', 'q.conversation_id')->where('q.work_package_id', $w->id)->where('q.vendor_organization_id', $snapshot['vendor_id'])
            ->whereRaw("c.locked_reference->>'version_id' = ?", [$w->current_version_id])->orderByDesc('q.updated_at')->value('q.state');

        $view = $snapshot + ['id' => $rowId, 'estimate_id' => $estimateId, 'expires_at' => $expiresAt, 'stale' => $stale,
            'current_quotation_state' => $state ?? 'NO_INQUIRY', 'is_favorite' => isset($favorites[(string) $snapshot['vendor_id']])];

        return $this->arrangement($view, $w, $draft->groups($w, $snapshot, $items));
    }

    /** @param array<string, mixed> $view
     * @param list<array<string, mixed>> $groups
     * @return array<string, mixed> */
    private function arrangement(array $view, object $w, array $groups): array
    {
        $fees = array_column($groups, 'delivery_centavos');
        $separateOrders = array_values(array_unique(array_filter(array_column($view['fulfillment']['separate_items'], 'order_id'))));
        $orderedFees = DB::table('orders')->whereIn('id', $separateOrders)->pluck('delivery_centavos')->all();
        $legacyCart = false;
        foreach ($view['fulfillment']['separate_items'] as $item) {
            $legacyCart = $legacyCart || $item['stage'] === 'IN_CART';
        }
        $known = $view['projected_total_centavos'] !== null && ! $legacyCart && ! in_array(null, array_merge($fees, $orderedFees), true);
        $separateDelivery = ! $legacyCart && ! in_array(null, array_merge($fees, $orderedFees), true) ? array_sum($fees) + array_sum($orderedFees) : null;
        $total = $known ? $view['fulfillment']['combined_total_centavos'] + $separateDelivery : null;

        return $view + ['draft_groups' => $groups,
            'procurement_materials_centavos' => $view['materials_centavos'] + $view['fulfillment']['separate_total_centavos'],
            'separate_delivery_centavos' => $separateDelivery,
            'procurement_delivery_centavos' => $known ? $view['delivery_centavos'] + $separateDelivery : null,
            'procurement_budget_label' => $total === null ? 'COST_REVIEW_REQUIRED' : ProjectBudget::buckets((int) $w->budget_centavos, $total, 0, 0)['label'],
            'procurement_total_centavos' => $total];
    }

    /** @param array<string, string> $selections
     * @return array<string, mixed> */
    public function selectionPreview(Request $request, string $packageId, string $candidateId, array $selections, ?string $method = null): array
    {
        $w = $this->projects->package($request, $packageId);
        $order = DB::table('orders')->where('work_package_id', $packageId)->where('work_package_version_id', $w->current_version_id)->where('compiled_estimate_vendor_id', $candidateId)
            ->where('procurement_type', 'PROJECT_BASED')->whereNotIn('order_state', OrderStates::CLOSED_BEFORE_FULFILLMENT)->orderByDesc('created_at')->first();
        if ($order === null) {
            $snapshot = $this->withSelections($request, $packageId, $candidateId, $selections, $method);
            app(ProjectProcurementDraft::class)->saveAutomatic($request, $w, $candidateId, $snapshot);
        } else {
            $original = json_decode((string) DB::table('order_snapshots')->where('order_id', $order->id)->where('kind', 'SUBMITTED')->orderBy('version')->value('snapshot'), true);
            $snapshot = $original['system_estimate'];
            $snapshot['payment_method'] = $order->payment_method;
        }
        $row = DB::table('compiled_estimate_vendors as v')->join('compiled_estimates as e', 'e.id', '=', 'v.compiled_estimate_id')->where('v.id', $candidateId)->first(['v.compiled_estimate_id', 'e.expires_at']);
        $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');

        $view = $this->view($request, $snapshot, $candidateId, (string) $row->compiled_estimate_id, $row->expires_at, $w, app(ListingPublicFacts::class)->favoriteOrganizations($buyer), PackageFulfillment::purchases($w, $buyer));

        return $view + ['primary_order_id' => $order?->id];
    }

    /**
     * Each requirement is filled from one specification option. Eligible offers (material, unit, brand when set,
     * every stated detail, stock) that share normalized details and option label form one option; quantity may
     * span offers of that option, never two options. With one option it is used; with several the Buyer chooses
     * (a chosen option comes from $selections), and until then the line is priced on the option that supplies
     * the most, cheapest first, as a basis that is flagged `selection_required` and never ordered.
     *
     * Ready-mixed concrete is delivered only by mixer, so a Self-Pickup package never matches it.
     *
     * @param  list<array<string, mixed>>  $requirements
     * @param  array<string, string>  $selections
     * @return list<array<string, mixed>>
     */
    private function match(string $vendor, array $requirements, array $selections, string $fulfillment): array
    {
        $offers = $this->offers->variants([$vendor])->join('products as p', 'p.id', '=', 'l.product_id')->join('units as u', 'u.id', '=', 'v.unit_id')->join('materials as m', 'm.id', '=', 'p.material_id')
            ->when($fulfillment === 'PICKUP', static fn ($query) => $query->where('m.code', '<>', ReadyMixedConcrete::MATERIAL_CODE))
            ->orderBy('pv.amount_centavos')->orderBy('v.id')->get(['v.*', 'l.id as listing_id', 'l.display_name', 'l.technical_attributes', 'l.publication_version', 'm.material_category_id', 'p.material_id', 'p.brand', 'pv.id as price_version_id', 'pv.amount_centavos', 'pv.tax_category', 'i.confirmed_at', 'u.code as unit_code', 'u.name as unit_name', 'u.precision as unit_precision', 'm.code as material_code', DB::raw('i.quantity_on_hand - i.hard_reserved_quantity AS available')]);
        $definitions = SpecificationMatch::definitions($offers->pluck('material_category_id')->map(static fn (mixed $id): string => (string) $id)->all());
        $remaining = [];
        $result = [];
        foreach ($requirements as $required) {
            $groups = [];
            foreach ($offers as $offer) {
                $attributes = SpecificationMatch::offered($offer->technical_attributes, $offer->attributes);
                if (($required['material_id'] ?? null) === null || $offer->material_id !== $required['material_id'] || $offer->unit_id !== $required['unit_id'] || ($required['preferred_brand'] !== null && $required['preferred_brand'] !== $offer->brand)
                    || ! SpecificationMatch::satisfies($required['specifications'], $attributes) || bccomp($remaining[$offer->id] ?? $offer->available, '0', 4) <= 0) {
                    continue;
                }
                $groups[SpecificationMatch::optionId($attributes, $offer->label)][] = ['offer' => $offer, 'attributes' => SpecificationMatch::labelled($attributes, $definitions[(string) $offer->material_category_id] ?? [])];
            }
            $fill = static function (array $group, string $needed) use ($remaining): array {
                $allocations = [];
                foreach ($group as ['offer' => $offer, 'attributes' => $attributes]) {
                    if (bccomp($needed, '0', 4) <= 0) {
                        break;
                    }
                    $available = $remaining[$offer->id] ?? $offer->available;
                    $quantity = bccomp($needed, $available, 4) <= 0 ? $needed : $available;
                    $remaining[$offer->id] = bcsub($available, $quantity, 4);
                    $needed = bcsub($needed, $quantity, 4);
                    $allocations[] = [$offer, $attributes, $quantity];
                }

                return [$allocations, $needed, $remaining];
            };
            $options = [];
            $filled = [];
            foreach ($groups as $optionId => $group) {
                $filled[$optionId] = $fill($group, $required['quantity']);
                $cheapest = $group[0]['offer'];
                $options[] = ['option_id' => $optionId, 'listing_id' => $cheapest->listing_id, 'variant_id' => $cheapest->id, 'display_name' => $cheapest->display_name, 'variant_label' => $cheapest->label,
                    'brand' => $cheapest->brand, 'unit_price_centavos' => (int) $cheapest->amount_centavos, 'specifications' => $group[0]['attributes'],
                    'availability' => bccomp($filled[$optionId][1], '0', 4) === 0 ? 'FULFILLABLE' : 'PARTIAL'];
            }
            $chosen = $selections[$required['id']] ?? null;
            if ($chosen !== null && ! isset($groups[$chosen])) {
                throw new AuthenticationException('ESTIMATE_SOURCE_CHANGED', 'Prices, inventory, capability, address or vehicle rates changed. Refresh the system estimate.', 409);
            }
            $selectionRequired = $chosen === null && count($groups) > 1;
            if ($chosen === null && $groups !== []) {
                // The option that supplies the most, then the lowest amount; deterministic on its id.
                $ranked = array_keys($filled);
                usort($ranked, static function (string $a, string $b) use ($filled): int {
                    $amount = static fn (array $f): int => array_sum(array_map(static fn (array $x): int => Money::lineAmount($x[2], (int) $x[0]->amount_centavos), $f[0]));

                    return bccomp($filled[$a][1], $filled[$b][1], 4) ?: ($amount($filled[$a]) <=> $amount($filled[$b])) ?: strcmp($a, $b);
                });
                $chosen = $ranked[0];
            }
            [$picked, $needed, $after] = $chosen === null ? [[], $required['quantity'], $remaining] : $filled[$chosen];
            $remaining = $after;
            $allocations = [];
            foreach ($picked as [$offer, $attributes, $quantity]) {
                $amount = Money::lineAmount($quantity, (int) $offer->amount_centavos);
                $load = ['weight_kg' => $offer->weight_kg, 'length_cm' => $offer->length_cm, 'width_cm' => $offer->width_cm, 'height_cm' => $offer->height_cm];
                $load += ReadyMixedConcrete::load($offer->material_code, $offer->unit_code);
                $allocations[] = ['variant_id' => $offer->id, 'listing_id' => $offer->listing_id, 'description' => $offer->display_name, 'variant_label' => $offer->label, 'brand' => $offer->brand,
                    'option_id' => $chosen, 'offered_specifications' => $attributes,
                    'matched_quantity' => $quantity, 'unit_price_centavos' => (int) $offer->amount_centavos, 'amount_centavos' => $amount, 'included_vat_centavos' => Money::includedVat($amount, $offer->tax_category),
                    'tax_category' => $offer->tax_category, 'source_price_version_id' => $offer->price_version_id, 'stock_confirmed_at' => $offer->confirmed_at, 'publication_version' => $offer->publication_version,
                    'unit_name' => $offer->unit_name, 'unit_precision' => (int) $offer->unit_precision, 'load' => $load];
            }
            $first = $allocations[0] ?? ['variant_id' => null, 'listing_id' => null, 'unit_price_centavos' => null, 'brand' => null, 'tax_category' => null, 'source_price_version_id' => null,
                'load' => ['weight_kg' => null, 'length_cm' => null, 'width_cm' => null, 'height_cm' => null]];
            $result[] = array_merge($first, ['line_id' => $required['id'], 'name' => $required['name'], 'material_id' => $required['material_id'], 'specifications' => $required['specifications'], 'preferred_brand' => $required['preferred_brand'],
                'quantity' => $required['quantity'], 'unit_id' => $required['unit_id'], 'unit_code' => $required['unit_code'], 'matched_quantity' => bcsub($required['quantity'], $needed, 4),
                'missing_quantity' => $needed, 'missing_reason' => ($required['material_id'] ?? null) === null ? 'UNLISTED_MATERIAL' : ($allocations === [] ? 'NO_EXACT_ACTIVE_MATCH' : 'QUANTITY_NOT_FULFILLABLE'), 'allocations' => $allocations,
                'amount_centavos' => array_sum(array_column($allocations, 'amount_centavos')), 'included_vat_centavos' => array_sum(array_column($allocations, 'included_vat_centavos')),
                'availability' => $allocations === [] ? 'UNAVAILABLE' : (bccomp($needed, '0', 4) === 0 ? 'FULFILLABLE' : 'PARTIAL'),
                'options' => count($options) > 1 ? $options : [], 'selected_option_id' => $selectionRequired ? null : $chosen, 'selection_required' => $selectionRequired]);
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

        return hash('sha256', json_encode([DeliveryRecommendationService::CALCULATION_VERSION, $org, $profile, $address, $offers, $this->vehicleRevisions($vendor), $coverage, $paymentReady], JSON_THROW_ON_ERROR));
    }

    /** @param array<string, mixed> $snapshot */
    public function assertFresh(array $snapshot): void
    {
        if (! hash_equals($snapshot['source_fingerprint'], $this->fingerprint($snapshot['vendor_id']))) {
            throw new AuthenticationException('ESTIMATE_SOURCE_CHANGED', 'Prices, inventory, capability, address or vehicle rates changed. Refresh the system estimate.', 409);
        }
    }

    /** Each ordering's sort key and the direction it opens on (owner request 2026-10-17). Best Match is a fixed ranking. */
    private const SORT_KEYS = [
        'BUDGET_FIT' => ["(snapshot->'fms'->'components'->>'budget_fit')::numeric", 'DESC'],
        'RATING' => ["(snapshot->>'vps')::numeric", 'DESC'],
        'PRICE' => ["(snapshot->>'projected_total_centavos')::bigint", 'ASC'],
    ];

    /**
     * The direction an ordering applies: Best Match has none, otherwise the Buyer's choice or the ordering's default.
     */
    public static function direction(string $sort, ?string $direction): ?string
    {
        if (! isset(self::SORT_KEYS[$sort])) {
            return null;
        }

        return in_array($direction, ['ASC', 'DESC'], true) ? $direction : self::SORT_KEYS[$sort][1];
    }

    /**
     * Result ordering for the comparison list. A Vendor without a value (no rating, cost under review) is always last
     * whichever way the list runs, ties go to the nearest store, and every ordering ends on the system rank so pages stay stable.
     */
    private static function ordering(string $sort, ?string $direction): string
    {
        $rank = "(snapshot->>'rank')::int";
        $direction = self::direction($sort, $direction);
        if ($direction === null) {
            return $rank;
        }

        return self::SORT_KEYS[$sort][0].' '.$direction." NULLS LAST, (snapshot->>'distance_meters')::int ASC, ".$rank;
    }

    /**
     * @param  array{sort?: string, direction?: string|null, favorites_only?: bool, complete_only?: bool, within_budget?: bool}  $options
     * @return array<string, mixed>
     */
    public function show(Request $request, string $packageId, ?string $estimateId = null, array $options = []): array
    {
        $w = $this->projects->package($request, $packageId);
        $query = DB::table('compiled_estimates')->where('work_package_version_id', $w->current_version_id);
        if ($estimateId !== null) {
            $query->where('id', $estimateId);
        }
        $e = $query->orderByDesc('created_at')->orderByDesc('id')->first();
        if ($e === null) {
            return ['estimate' => null, 'items' => [], 'page' => 1, 'has_more' => false, 'total' => 0, 'unfiltered_total' => 0, 'sort' => $options['sort'] ?? 'BEST_MATCH',
                'direction' => self::direction($options['sort'] ?? 'BEST_MATCH', $options['direction'] ?? null)];
        }
        $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
        $favorites = app(ListingPublicFacts::class)->favoriteOrganizations($buyer);
        $all = DB::table('compiled_estimate_vendors')->where('compiled_estimate_id', $e->id);
        $filtered = (clone $all)
            ->when($options['favorites_only'] ?? false, fn ($q) => $q->whereIn('vendor_organization_id', array_keys($favorites) === [] ? ['00000000-0000-0000-0000-000000000000'] : array_keys($favorites)))
            ->when($options['complete_only'] ?? false, fn ($q) => $q->whereRaw("(snapshot->>'complete')::boolean"));
        $sort = $options['sort'] ?? 'BEST_MATCH';
        $purchases = PackageFulfillment::purchases($w, $buyer);
        $ordered = $filtered->orderByRaw(self::ordering($sort, $options['direction'] ?? null))->orderBy('id');
        $render = fn (object $row): array => $this->view($request, json_decode($row->snapshot, true), (string) $row->id, (string) $e->id, $e->expires_at, $w, $favorites, $purchases);
        if ($sort === 'PRICE' || ($options['within_budget'] ?? false)) {
            $rows = array_map($render, $ordered->get()->all());
            if ($options['within_budget'] ?? false) {
                $rows = array_values(array_filter($rows, static fn (array $row): bool => in_array($row['procurement_budget_label'], ['UNDER_BUDGET', 'WITHIN_BUDGET'], true)));
            }
            if ($sort === 'PRICE') {
                $descending = self::direction($sort, $options['direction'] ?? null) === 'DESC';
                usort($rows, static fn (array $a, array $b): int => (($a['procurement_total_centavos'] === null) <=> ($b['procurement_total_centavos'] === null))
                    ?: ($descending ? ($b['procurement_total_centavos'] <=> $a['procurement_total_centavos']) : ($a['procurement_total_centavos'] <=> $b['procurement_total_centavos']))
                    ?: ($a['distance_meters'] <=> $b['distance_meters']) ?: ($a['rank'] <=> $b['rank']));
            }
            $number = max(1, (int) $request->query('page', 1));
            $page = new LengthAwarePaginator(array_slice($rows, ($number - 1) * 25, 25), count($rows), 25, $number);
            $rows = $page->items();
        } else {
            $page = $ordered->paginate(25);
            $rows = array_map($render, $page->items());
        }
        $context = json_decode($e->context, true);
        // Reuse the comparison's existing refresh path after a preference change.
        // Historical estimates and selected packages keep their original ranking snapshots.
        $rankingChanged = $estimateId === null && $w->selected_vendor_organization_id === null
            && in_array($w->status, ['ACTIVE', 'QUOTATION_INQUIRY'], true)
            && (($context['preferences']['weights'] ?? []) != FulfillmentMatchScore::preferences($buyer)['weights']
                || ($context['preferences']['algorithm_version'] ?? null) !== FulfillmentMatchScore::VERSION);

        return ['estimate' => ['id' => $e->id, 'version_id' => $e->work_package_version_id, 'created_at' => $e->created_at, 'expires_at' => $e->expires_at,
            'state' => $e->invalidated_at !== null || $rankingChanged ? 'INVALIDATED' : (now()->greaterThanOrEqualTo($e->expires_at) ? 'EXPIRED' : 'ACTIVE'), 'context' => $context],
            'items' => $rows, 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages(), 'total' => $page->total(), 'unfiltered_total' => $all->count(),
            'sort' => $sort, 'direction' => self::direction($sort, $options['direction'] ?? null)];
    }

    /** @return array<string, mixed> */
    public function comparison(Request $request, string $packageId, string $candidateId): array
    {
        $c = $this->candidate($request, $packageId, $candidateId, false);
        $w = $c['package'];
        $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');

        return $this->view($request, $c['snapshot'], $candidateId, (string) $c['estimate']->compiled_estimate_id, $c['estimate']->expires_at, $w,
            app(ListingPublicFacts::class)->favoriteOrganizations($buyer), PackageFulfillment::purchases($w, $buyer), true);
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
        if ($w->selected_vendor_organization_id === null) {
            $snapshot = self::deliveryOnly($snapshot);
        }
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
