<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Catalog\ReadyMixedConcrete;
use App\Domain\Finance\Money;
use App\Domain\Geography\GeographyProviderUnavailable;
use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Geography\RouteProvider;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderEligibility;
use App\Domain\Payments\PaymentMethodPolicy;
use App\Domain\Procurement\DeliveryPreviewService;
use App\Domain\Procurement\ListingPublicFacts;
use App\Domain\Vendors\DeliveryRecommendationService;
use App\Domain\Vendors\VendorDeliveryEligibility;
use Illuminate\Http\Request;
use Illuminate\Support\Collection;
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
        $candidates = $this->candidates($point, $content['fulfillment_method'], $radius);
        $buyer = DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
        $preferences = FulfillmentMatchScore::preferences($buyer);
        $vps = app(ListingPublicFacts::class)->vps($candidates->pluck('id')->all());
        $summaries = $this->vendors->summaries($candidates->pluck('id')->all());
        $compiled = [];
        foreach ($candidates as $candidate) {
            if (! app(OrderEligibility::class)->onlinePaymentReady($candidate->id)) {
                continue;
            }
            // Cash on Delivery and In-Store Payment are offered only by Vendors whose Owner enabled them.
            if ($content['payment_method'] !== 'ONLINE' && ! collect(app(PaymentMethodPolicy::class)->options($candidate->id, $content['fulfillment_method'], true))
                ->contains(static fn (array $option): bool => $option['method'] === $content['payment_method'] && $option['available'])) {
                continue;
            }
            $source = $this->fingerprint($candidate->id);
            $distance = (int) round((float) $candidate->distance);
            $priced = $this->price($candidate->id, $content, [], ['distance' => $distance, 'radius' => $radius, 'budget' => (int) $w->budget_centavos, 'vps' => $vps[$candidate->id] ?? null, 'weights' => $preferences['weights']]);
            if ($priced === null) {
                continue;
            }
            $compiled[] = ['vendor_id' => $candidate->id, 'store_name' => $summaries[$candidate->id]['public_store_name'], 'latitude' => (float) $candidate->latitude, 'longitude' => (float) $candidate->longitude,
                'score_label' => $summaries[$candidate->id]['score_label']['text'], 'vps' => $vps[$candidate->id] ?? null] + $priced + [
                    'processing_fee_centavos' => null, 'processing_fee_status' => 'PENDING_PAYMENT_CHANNEL',
                    'distance_meters' => $distance, 'distance_basis' => 'GEODESIC_PROJECT_SITE_TO_STORE', 'eta_seconds' => null,
                    'fulfillment_method' => $content['fulfillment_method'], 'payment_method' => $content['payment_method'], 'destination' => $content['destination'],
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

    /** Bulk-capable, open Tier 2 stores whose fulfillment method suits the package, within the radius of the site.
     * @param array<string, mixed> $point
     * @return Collection<int, \stdClass> */
    private function candidates(array $point, string $fulfillment, int $radius): Collection
    {
        return $this->vendors->members()->where('p.bulk_capability', true)->where('p.vacation_mode', false)
            ->whereIn('p.fulfillment_method', $fulfillment === 'PICKUP' ? ['SELF_PICKUP', 'BOTH'] : ['VENDOR_DELIVERY', 'BOTH'])
            ->when($fulfillment === 'DELIVERY', fn ($query) => $query->whereIn('o.id', app(VendorDeliveryEligibility::class)->availableOrganizations()))
            ->whereRaw('ST_DWithin(av.location, ST_SetSRID(ST_MakePoint(?, ?),4326)::geography, ?)', [$point['longitude'], $point['latitude'], $radius * 1000 + 0.001])
            ->selectRaw('o.id, av.latitude, av.longitude, ST_Distance(av.location, ST_SetSRID(ST_MakePoint(?, ?),4326)::geography) AS distance', [$point['longitude'], $point['latitude']])
            ->orderBy('o.id')->get();
    }

    /**
     * Owner decision 2026-10-12: an advisory, materials-only budget estimate for a Work Package being drafted.
     * Each catalog line is priced at the half-up average of one price per Vendor (that Vendor's lowest eligible
     * exact match: material, unit, brand when set, and every stated specification) among the Vendors scanning
     * would consider. Unlisted lines and lines without a match are reported as such, never guessed. Delivery
     * fees and labor are excluded. Nothing is stored.
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
        $vendors = $this->candidates($point, $input['fulfillment_method'], (int) $input['radius_km'])->pluck('id')
            ->filter(fn (string $vendor): bool => app(OrderEligibility::class)->onlinePaymentReady($vendor))->values()->all();
        $materials = array_values(array_unique(array_filter(array_column($input['lines'], 'material_id'))));
        $offers = $vendors === [] || $materials === [] ? collect() : $this->offers->variants($vendors)->join('products as p', 'p.id', '=', 'l.product_id')->whereIn('p.material_id', $materials)
            ->get(['v.unit_id', 'v.attributes', 'l.vendor_organization_id', 'l.technical_attributes', 'p.material_id', 'p.brand', 'pv.amount_centavos', DB::raw('i.quantity_on_hand - i.hard_reserved_quantity AS available')]);
        $lines = [];
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
                    || ! SpecificationMatch::satisfies($specifications, $attributes) || bccomp((string) $offer->available, '0', 4) <= 0) {
                    continue;
                }
                $lowest[$offer->vendor_organization_id] = min($lowest[$offer->vendor_organization_id] ?? PHP_INT_MAX, (int) $offer->amount_centavos);
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

        return ['lines' => $lines, 'materials_total_centavos' => $total, 'priced_line_count' => $priced, 'unpriced_line_count' => count($lines) - $priced,
            'radius_km' => (int) $input['radius_km'], 'basis' => 'AVERAGE_OF_VENDOR_LOWEST_ELIGIBLE_PRICE', 'excludes' => ['DELIVERY_FEE', 'LABOR'], 'computed_at' => now()->toIso8601String()];
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
    public function withSelections(Request $request, string $packageId, string $candidateId, array $selections): array
    {
        $candidate = $this->candidate($request, $packageId, $candidateId);
        $s = $candidate['snapshot'];
        $offered = [];
        foreach ($s['lines'] as $line) {
            $offered[$line['line_id']] = array_column($line['options'] ?? [], 'option_id');
        }
        foreach ($selections as $lineId => $optionId) {
            if (! in_array($optionId, $offered[$lineId] ?? [], true)) {
                throw new AuthenticationException('SPECIFICATION_OPTION_INVALID', 'Choose one of the listed specifications for this material.', 422, ['line_id' => $lineId]);
            }
        }
        $content = json_decode((string) DB::table('work_package_versions')->where('id', $candidate['package']->current_version_id)->value('content'), true);
        $context = json_decode((string) DB::table('compiled_estimates')->where('id', $candidate['estimate']->compiled_estimate_id)->value('context'), true);
        $priced = $this->price((string) $s['vendor_id'], $content, $selections, ['distance' => (int) $s['distance_meters'], 'radius' => (int) $context['radius_km'],
            'budget' => (int) $candidate['package']->budget_centavos, 'vps' => $s['vps'] ?? null, 'weights' => $context['preferences']['weights']]);
        if ($priced === null) {
            throw new AuthenticationException('ESTIMATE_SOURCE_CHANGED', 'Prices, inventory, capability, address or vehicle rates changed. Refresh the system estimate.', 409);
        }

        return array_merge($s, $priced, ['specification_selections' => (object) $selections]);
    }

    /** The candidate as the comparison list shows it.
     * @param array<string, mixed> $snapshot
     * @param array<string, mixed> $favorites
     * @return array<string, mixed> */
    private function view(array $snapshot, string $rowId, string $estimateId, mixed $expiresAt, object $w, array $favorites): array
    {
        $state = DB::table('quotations as q')->join('conversations as c', 'c.id', '=', 'q.conversation_id')->where('q.work_package_id', $w->id)->where('q.vendor_organization_id', $snapshot['vendor_id'])
            ->whereRaw("c.locked_reference->>'version_id' = ?", [$w->current_version_id])->orderByDesc('q.updated_at')->value('q.state');

        return $snapshot + ['id' => $rowId, 'estimate_id' => $estimateId, 'expires_at' => $expiresAt, 'stale' => ! hash_equals($snapshot['source_fingerprint'], $this->fingerprint((string) $snapshot['vendor_id'])),
            'current_quotation_state' => $state ?? 'NO_INQUIRY', 'is_favorite' => isset($favorites[(string) $snapshot['vendor_id']])];
    }

    /** @param array<string, string> $selections
     * @return array<string, mixed> */
    public function selectionPreview(Request $request, string $packageId, string $candidateId, array $selections): array
    {
        $snapshot = $this->withSelections($request, $packageId, $candidateId, $selections);
        $w = $this->projects->package($request, $packageId);
        $row = DB::table('compiled_estimate_vendors as v')->join('compiled_estimates as e', 'e.id', '=', 'v.compiled_estimate_id')->where('v.id', $candidateId)->first(['v.compiled_estimate_id', 'e.expires_at']);
        $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');

        return $this->view($snapshot, $candidateId, (string) $row->compiled_estimate_id, $row->expires_at, $w, app(ListingPublicFacts::class)->favoriteOrganizations($buyer));
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

    /** Result orderings for the comparison list; every one ends on the system rank so pages stay stable. */
    private const SORTS = [
        'BEST_MATCH' => "(snapshot->>'rank')::int",
        'BUDGET_FIT' => "(snapshot->'fms'->'components'->>'budget_fit')::numeric DESC NULLS LAST, (snapshot->>'projected_total_centavos')::bigint ASC NULLS LAST, (snapshot->>'rank')::int",
        'RATING' => "(snapshot->>'vps')::numeric DESC NULLS LAST, (snapshot->>'rank')::int",
        'PRICE' => "(snapshot->>'projected_total_centavos')::bigint ASC NULLS LAST, (snapshot->>'rank')::int",
    ];

    /**
     * @param  array{sort?: string, favorites_only?: bool, complete_only?: bool, within_budget?: bool}  $options
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
            return ['estimate' => null, 'items' => [], 'page' => 1, 'has_more' => false, 'total' => 0, 'unfiltered_total' => 0, 'sort' => $options['sort'] ?? 'BEST_MATCH', 'suggested_radius_km' => null];
        }
        $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
        $favorites = app(ListingPublicFacts::class)->favoriteOrganizations($buyer);
        $all = DB::table('compiled_estimate_vendors')->where('compiled_estimate_id', $e->id);
        $filtered = (clone $all)
            ->when($options['favorites_only'] ?? false, fn ($q) => $q->whereIn('vendor_organization_id', array_keys($favorites) === [] ? ['00000000-0000-0000-0000-000000000000'] : array_keys($favorites)))
            ->when($options['complete_only'] ?? false, fn ($q) => $q->whereRaw("(snapshot->>'complete')::boolean"))
            ->when($options['within_budget'] ?? false, fn ($q) => $q->whereRaw("snapshot->>'budget_label' IN ('UNDER_BUDGET', 'WITHIN_BUDGET')"));
        $page = $filtered->orderByRaw(self::SORTS[$options['sort'] ?? 'BEST_MATCH'])->orderBy('id')->paginate(25);
        $rows = array_map(fn (object $row): array => $this->view(json_decode($row->snapshot, true), (string) $row->id, (string) $e->id, $e->expires_at, $w, $favorites), $page->items());
        $context = json_decode($e->context, true);
        $next = [5 => 10, 10 => 20, 20 => 30, 30 => 40, 40 => 50, 50 => null][$context['radius_km']];

        return ['estimate' => ['id' => $e->id, 'version_id' => $e->work_package_version_id, 'created_at' => $e->created_at, 'expires_at' => $e->expires_at,
            'state' => $e->invalidated_at !== null ? 'INVALIDATED' : (now()->greaterThanOrEqualTo($e->expires_at) ? 'EXPIRED' : 'ACTIVE'), 'context' => $context],
            'items' => $rows, 'page' => $page->currentPage(), 'has_more' => $page->hasMorePages(), 'total' => $page->total(), 'unfiltered_total' => $all->count(),
            'sort' => $options['sort'] ?? 'BEST_MATCH', 'suggested_radius_km' => $all->count() < 3 ? $next : null];
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
