<?php

declare(strict_types=1);

namespace App\Domain\Projects;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Catalog\ReadyMixedConcrete;
use App\Domain\Enforcement\BuyerCommerceRestriction;
use App\Domain\Finance\Money;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Geography\GeographyScopeResolver;
use App\Domain\Geography\PublicVendorProjection;
use App\Domain\Geography\RadiusPolicy;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Messaging\FulfillmentThreadService;
use App\Domain\Orders\OrderActor;
use App\Domain\Orders\OrderCommercial;
use App\Domain\Orders\OrderNotifier;
use App\Domain\Orders\OrderStates;
use App\Domain\Orders\OrderTransitionService;
use App\Domain\Payments\PaymentMethodPolicy;
use App\Domain\Procurement\CartService;
use App\Domain\Procurement\DeliveryPreviewService;
use App\Domain\Procurement\ListingPublicFacts;
use App\Domain\Procurement\ScopedOfferQuery;
use App\Domain\Settings\PlatformSettings;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Project review selections only. No cart, stock reservation or payment is changed here. */
final class ProjectProcurementDraft
{
    public function __construct(private readonly ProjectService $projects, private readonly ProjectEstimateService $estimates) {}

    /** @return list<array<string, mixed>> */
    public static function items(object $package, string $primaryVendor, ?string $method = null): array
    {
        $items = DB::table('project_procurement_draft_items')->where('work_package_version_id', $package->current_version_id)
            ->where('primary_vendor_id', $primaryVendor)->whereNull('order_id')->orderBy('id')->get();

        $methods = [];
        foreach ($items as $row) {
            $saved = json_decode($row->snapshot, true);
            $vendor = $saved['vendor_id'];
            $methods[$vendor] ??= $method ?? $saved['fulfillment_method'];
            if (($saved['load']['material_kind'] ?? null) === ReadyMixedConcrete::MATERIAL_CODE) {
                $methods[$vendor] = 'DELIVERY';
            }
        }
        $result = [];
        $remainingStock = [];
        foreach ($items as $row) {
            $item = ['draft_item_id' => (string) $row->id, 'stage' => 'DRAFT', 'line_id' => (string) $row->work_package_line_id,
                'quantity' => (string) $row->quantity, 'order_id' => null, 'order_reference' => null] + json_decode($row->snapshot, true);
            try {
                $current = app(self::class)->offer($package, $item['variant_id'], $methods[$item['vendor_id']]);
                $item['fulfillment_method'] = $current['fulfillment_method'];
                $item['fulfillment_options'] = $current['fulfillment_options'];
                $requirement = DB::table('work_package_lines')->where('id', $row->work_package_line_id)->first();
                $specifications = json_decode((string) ($requirement->specifications ?? '{}'), true);
                $item['satisfies_requirement'] = $current['material_id'] === $requirement->material_id && $current['unit_id'] === $requirement->unit_id
                    && ($requirement->preferred_brand === null || $requirement->preferred_brand === $current['brand'])
                    && SpecificationMatch::satisfies($specifications, $current['offered_specifications']);
                $remainingStock[$item['variant_id']] ??= $current['_available'];
                $available = $remainingStock[$item['variant_id']];
                $item['coverage_quantity'] = bccomp($available, $item['quantity'], 4) >= 0 ? $item['quantity'] : $available;
                $remainingStock[$item['variant_id']] = bcsub($available, $item['coverage_quantity'], 4);
                $item['image'] = $current['image'];
            } catch (AuthenticationException) {
                $item['coverage_quantity'] = '0.0000';
            }
            $result[] = $item;
        }
        $stores = app(PublicVendorProjection::class)->summaries(array_values(array_unique(array_column($result, 'vendor_id'))));
        foreach ($result as &$item) {
            $item['store_name'] = $stores[$item['vendor_id']]['public_store_name'] ?? 'Supplier';
        }
        unset($item);

        return self::priceItems($result);
    }

    /** @param list<array<string, mixed>> $result
     * @return list<array<string, mixed>> */
    public static function priceItems(array $result): array
    {
        // A product may cover several requirements, but becomes one order line.
        // Allocate its rounded amount so draft rows and that line agree exactly.
        $products = [];
        foreach ($result as $index => $item) {
            if ($item['preserve_commercial_amount'] ?? false) {
                continue;
            }
            $products[$item['variant_id'].':'.$item['unit_price_centavos']][] = $index;
        }
        foreach ($products as $indices) {
            $quantity = '0';
            $weights = [];
            foreach ($indices as $index) {
                $quantity = bcadd($quantity, $result[$index]['quantity'], 4);
                $weights[$result[$index]['draft_item_id'].':'.$result[$index]['line_id']] = (int) bcmul($result[$index]['quantity'], '10000', 0);
            }
            $shares = Money::allocate(Money::lineAmount($quantity, $result[$indices[0]]['unit_price_centavos']), $weights);
            foreach ($indices as $index) {
                $result[$index]['line_total_centavos'] = $shares[$result[$index]['draft_item_id'].':'.$result[$index]['line_id']];
            }
        }

        return $result;
    }

    /** Exact-match defaults are computed on reads; only an explicit preview saves them.
     * @param array<string, mixed> $snapshot
     * @param list<array<string, mixed>> $existing
     * @return list<array<string, mixed>> */
    public function automaticItems(Request $request, object $w, string $candidateId, array $snapshot, array $existing, bool $projectOnly = false): array
    {
        if ($w->selected_vendor_organization_id !== null || ! in_array($w->status, ['ACTIVE', 'QUOTATION_INQUIRY'], true)
            || $this->projects->project($request, (string) $w->project_id)->status !== 'ACTIVE') {
            return [];
        }
        $excluded = DB::table('project_procurement_draft_exclusions')->where('work_package_version_id', $w->current_version_id)
            ->where('primary_vendor_id', $snapshot['vendor_id'])->pluck('work_package_line_id')->all();
        $chosen = array_column($existing, 'line_id');
        $selections = [];
        foreach ($snapshot['lines'] as $line) {
            if (($line['selected_option_id'] ?? null) !== null) {
                $selections[$line['line_id']] = $line['selected_option_id'];
            }
        }
        $allocated = [];
        foreach ($existing as $item) {
            $allocated[$item['variant_id']] = bcadd($allocated[$item['variant_id']] ?? '0', $item['quantity'], 4);
        }
        $result = [];
        $deliveryCoverage = [];
        foreach ($snapshot['lines'] as $line) {
            if ($line['material_id'] === null || $line['selection_required'] || in_array($line['line_id'], array_merge($excluded, $chosen), true) || bccomp($line['missing_quantity'], '0', 4) <= 0) {
                continue;
            }
            $needed = null;
            $page = 1;
            $variants = [];
            do {
                $offers = app(WorkPackageAlternatives::class)->list($request, (string) $w->id, $line['line_id'], $snapshot['vendor_id'], $page, $candidateId, $selections, $projectOnly ? null : $snapshot['fulfillment_method'], null, false, $projectOnly);
                $needed ??= $offers['needed_quantity'];
                foreach ($offers['items'] as $offer) {
                    if (! $offer['exact_match']) {
                        $offers['has_more'] = false;
                        break;
                    }
                    if ($offer['already_added'] || isset($variants[$offer['variant_id']]) || count($existing) + count($result) >= 100) {
                        continue;
                    }
                    try {
                        $method = $projectOnly && ! in_array($snapshot['fulfillment_method'], $offer['fulfillment_methods'], true) ? $offer['fulfillment_methods'][0] : $snapshot['fulfillment_method'];
                        $item = $this->offer($w, $offer['variant_id'], $method);
                    } catch (AuthenticationException) {
                        continue;
                    }
                    if (($line['preferred_brand'] !== null && $line['preferred_brand'] !== $item['brand']) || ! SpecificationMatch::satisfies($line['specifications'], $item['offered_specifications'])) {
                        continue;
                    }
                    $available = bcsub($item['_available'], $allocated[$item['variant_id']] ?? '0', 4);
                    $quantity = bcadd(bccomp($needed, $available, 4) <= 0 ? $needed : $available, '0', $item['unit_precision']);
                    if (bccomp($quantity, '0', 4) <= 0) {
                        continue;
                    }
                    $proposal = $item + ['draft_item_id' => (string) Str::uuid7(), 'stage' => 'DRAFT', 'line_id' => $line['line_id'], 'quantity' => $quantity,
                        'coverage_quantity' => $quantity, 'line_total_centavos' => Money::lineAmount($quantity, $item['unit_price_centavos']), 'satisfies_requirement' => true,
                        'store_name' => $offer['store_name'], 'order_id' => null, 'order_reference' => null];
                    unset($proposal['_available']);
                    if ($item['fulfillment_method'] === 'DELIVERY') {
                        if (! array_key_exists($item['vendor_id'], $deliveryCoverage)) {
                            $group = $this->groups($w, $snapshot, [$proposal])[0];
                            $deliveryCoverage[$item['vendor_id']] = ! in_array('OUTSIDE_DELIVERY_COVERAGE', array_column($group['delivery']['issues'], 'code'), true);
                        }
                        if (! $deliveryCoverage[$item['vendor_id']]) {
                            continue;
                        }
                    }
                    $allocated[$item['variant_id']] = bcadd($allocated[$item['variant_id']] ?? '0', $quantity, 4);
                    $needed = bcsub($needed, $quantity, 4);
                    $result[] = $proposal;
                    $variants[$item['variant_id']] = true;
                    if (bccomp($needed, '0', 4) <= 0) {
                        break;
                    }
                }
                $page++;
            } while ($offers['has_more'] && bccomp($needed, '0', 4) > 0 && count($existing) + count($result) < 100);
        }

        return $result;
    }

    /** Persist the same defaults before checklist/checkout review; removals and manual choices win races.
     * @param array<string, mixed> $snapshot */
    public function saveAutomatic(Request $request, object $w, string $candidateId, array $snapshot): void
    {
        $items = $this->automaticItems($request, $w, $candidateId, $snapshot, self::items($w, $snapshot['vendor_id'], $snapshot['fulfillment_method']));
        if ($items === []) {
            return;
        }
        BuyerCommerceRestriction::assertAllowed(app(BuyerProfiles::class)->idFor($request));
        DB::transaction(function () use ($request, $w, $snapshot, $items): void {
            $current = $this->projects->package($request, (string) $w->id, true);
            if ($current->current_version_id !== $w->current_version_id || $current->selected_vendor_organization_id !== null || ! in_array($current->status, ['ACTIVE', 'QUOTATION_INQUIRY'], true)) {
                throw new AuthenticationException('WORK_PACKAGE_LOCKED', 'Refresh the Work Package before reviewing its procurement arrangement.', 409);
            }
            $blocked = DB::table('project_procurement_draft_exclusions')->where('work_package_version_id', $w->current_version_id)->where('primary_vendor_id', $snapshot['vendor_id'])->pluck('work_package_line_id')->all();
            $chosen = DB::table('project_procurement_draft_items')->where('work_package_version_id', $w->current_version_id)->where('primary_vendor_id', $snapshot['vendor_id'])->whereNull('order_id')->pluck('work_package_line_id')->all();
            $stock = [];
            $saved = 0;
            $count = count($chosen);
            foreach ($items as $item) {
                if ($count >= 100) {
                    break;
                }
                if (in_array($item['line_id'], array_merge($blocked, $chosen), true)) {
                    continue;
                }
                try {
                    $live = $this->offer($current, $item['variant_id'], $snapshot['fulfillment_method']);
                } catch (AuthenticationException) {
                    continue;
                }
                $stock[$item['variant_id']] ??= bcsub($live['_available'], (string) DB::table('project_procurement_draft_items')->where('work_package_version_id', $w->current_version_id)->where('primary_vendor_id', $snapshot['vendor_id'])->whereNull('order_id')->where('listing_variant_id', $item['variant_id'])->sum('quantity'), 4);
                if ($live['source_price_version_id'] !== $item['source_price_version_id'] || ! SpecificationMatch::satisfies($item['offered_specifications'], $live['offered_specifications']) || bccomp($stock[$item['variant_id']], $item['quantity'], 4) < 0) {
                    continue;
                }
                $stock[$item['variant_id']] = bcsub($stock[$item['variant_id']], $item['quantity'], 4);
                DB::table('project_procurement_draft_items')->insert(['id' => $item['draft_item_id'], 'work_package_version_id' => $w->current_version_id, 'primary_vendor_id' => $snapshot['vendor_id'],
                    'work_package_line_id' => $item['line_id'], 'listing_variant_id' => $item['variant_id'], 'quantity' => $item['quantity'], 'snapshot' => json_encode($item, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                $saved++;
                $count++;
            }
            if ($saved > 0) {
                $this->projects->record($request, 'PROJECT_DRAFT_AUTOMATIC_ITEMS_SAVED', (string) $w->id);
            }
        });
    }

    /** @param array<string, mixed> $input */
    public function change(Request $request, string $packageId, string $candidateId, string $lineId, string $variantId, array $input, bool $remove): void
    {
        BuyerCommerceRestriction::assertAllowed(app(BuyerProfiles::class)->idFor($request));
        $candidate = $this->estimates->candidate($request, $packageId, $candidateId, ! $remove);
        // Provider work happens before the package lock.
        $snapshot = $remove ? $candidate['snapshot'] : $this->estimates->withSelections($request, $packageId, $candidateId, ProjectInquiryService::selections($input), $input['fulfillment_method'] ?? null);
        DB::transaction(function () use ($request, $packageId, $lineId, $variantId, $input, $remove, $candidate, $snapshot): void {
            $w = $this->projects->package($request, $packageId, true);
            ProjectService::version($w, (int) $input['lock_version']);
            if ($w->current_version_id !== $candidate['package']->current_version_id || ($w->selected_vendor_organization_id !== null && $w->selected_vendor_organization_id !== $snapshot['vendor_id'])
                || ! in_array($w->status, ['ACTIVE', 'QUOTATION_INQUIRY', 'VENDOR_SELECTED'], true)) {
                throw new AuthenticationException('WORK_PACKAGE_LOCKED', 'Refresh the Work Package before changing its procurement arrangement.', 409);
            }
            $query = DB::table('project_procurement_draft_items')->where('work_package_version_id', $w->current_version_id)->where('primary_vendor_id', $snapshot['vendor_id'])
                ->where('work_package_line_id', $lineId)->where('listing_variant_id', $variantId)->whereNull('order_id');
            if ($remove) {
                $query->delete();
                if (DB::table('work_package_lines')->where('id', $lineId)->where('work_package_version_id', $w->current_version_id)->exists()) {
                    DB::table('project_procurement_draft_exclusions')->insertOrIgnore(['id' => (string) Str::uuid7(), 'work_package_version_id' => $w->current_version_id,
                        'primary_vendor_id' => $snapshot['vendor_id'], 'work_package_line_id' => $lineId, 'created_at' => now(), 'updated_at' => now()]);
                }
            } elseif (! $query->exists()) {
                if ($w->selected_vendor_organization_id !== null) {
                    throw new AuthenticationException('WORK_PACKAGE_LOCKED', 'The primary request has already been submitted.', 409);
                }
                if (DB::table('project_procurement_draft_items')->where('work_package_version_id', $w->current_version_id)->where('primary_vendor_id', $snapshot['vendor_id'])->whereNull('order_id')->count() >= 100) {
                    throw new AuthenticationException('PROJECT_DRAFT_LIMIT', 'Review or remove draft items before adding more.', 422);
                }
                $line = null;
                foreach ($snapshot['lines'] as $requirement) {
                    if ($requirement['line_id'] === $lineId) {
                        $line = $requirement;
                        break;
                    }
                }
                if ($line === null || $line['material_id'] === null) {
                    throw new AuthenticationException('WORK_PACKAGE_LINE_NOT_FOUND', 'Choose a requirement from this Work Package.', 404);
                }
                $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
                $purchases = self::purchases($w, $buyer, (string) $snapshot['vendor_id'], (string) $snapshot['fulfillment_method']);
                $needed = PackageFulfillment::remaining($snapshot['lines'], $purchases, $lineId) ?? '0';
                // Similar selections consume draft quantity too, but never mark the requirement fulfilled.
                foreach ($purchases[$lineId] ?? [] as $purchase) {
                    if (! $purchase['satisfies_requirement']) {
                        $needed = bcsub($needed, $purchase['quantity'], 4);
                    }
                }
                $item = $this->offer($w, $variantId, (string) $snapshot['fulfillment_method']);
                if ($item['vendor_id'] === $snapshot['vendor_id'] || $item['material_id'] !== $line['material_id'] || $item['unit_id'] !== $line['unit_id']) {
                    throw new AuthenticationException('ALTERNATIVE_NOT_COMPATIBLE', 'Choose the same material and normalized unit from another supplier.', 422);
                }
                if ($item['source_price_version_id'] !== $input['price_version_id']) {
                    throw new AuthenticationException('PRICE_CHANGED', 'Refresh the recommendation before adding it.', 409);
                }
                $allocated = DB::table('project_procurement_draft_items')->where('work_package_version_id', $w->current_version_id)->where('primary_vendor_id', $snapshot['vendor_id'])
                    ->where('listing_variant_id', $variantId)->whereNull('order_id')->sum('quantity');
                $available = bcsub($item['_available'], (string) $allocated, 4);
                $quantity = bcadd(bccomp($needed, $available, 4) <= 0 ? $needed : $available, '0', $item['unit_precision']);
                if (bccomp($quantity, '0', 4) <= 0) {
                    throw new AuthenticationException('QUANTITY_ALREADY_COVERED', 'The draft already covers this quantity, or the product is no longer available. Remove a selection to replace it.', 409);
                }
                $item['quantity'] = $quantity;
                $item['line_total_centavos'] = Money::lineAmount($quantity, $item['unit_price_centavos']);
                $item['satisfies_requirement'] = ($line['preferred_brand'] === null || $line['preferred_brand'] === $item['brand']) && SpecificationMatch::satisfies($line['specifications'], $item['offered_specifications']);
                unset($item['_available']);
                DB::table('project_procurement_draft_items')->insert(['id' => (string) Str::uuid7(), 'work_package_version_id' => $w->current_version_id, 'primary_vendor_id' => $snapshot['vendor_id'],
                    'work_package_line_id' => $lineId, 'listing_variant_id' => $variantId, 'quantity' => $quantity, 'snapshot' => json_encode($item, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                DB::table('project_procurement_draft_exclusions')->where('work_package_version_id', $w->current_version_id)->where('primary_vendor_id', $snapshot['vendor_id'])->where('work_package_line_id', $lineId)->delete();
            }
            $this->projects->record($request, $remove ? 'PROJECT_DRAFT_ITEM_REMOVED' : 'PROJECT_DRAFT_ITEM_ADDED', $packageId);
        });
    }

    /** @return array<string, list<array<string, mixed>>> */
    public static function purchases(object $w, string $buyer, string $primaryVendor, ?string $method = null): array
    {
        $purchases = PackageFulfillment::purchases($w, $buyer);
        foreach (self::items($w, $primaryVendor, $method) as $item) {
            $purchases[$item['line_id']][] = $item;
        }

        return $purchases;
    }

    /** Resolve an eligible public offer from the locked site, never the live mobile location.
     * @return array<string, mixed> */
    public function offer(object $w, string $variantId, string $method): array
    {
        $content = json_decode((string) DB::table('work_package_versions')->where('id', $w->current_version_id)->value('content'), true);
        $point = $content['site']['point'];
        $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
        $scope = app(GeographyScopeResolver::class)->forBuyer($buyer, ['latitude' => (float) $point['latitude'], 'longitude' => (float) $point['longitude'], 'origin_source' => 'MAP_PIN', 'radius_km' => RadiusPolicy::PROJECT_BASED_KM]);
        $row = app(ScopedOfferQuery::class)->within($scope)->join('products as pd', 'pd.id', '=', 'l.product_id')->join('units as u', 'u.id', '=', 'v.unit_id')
            ->where('v.id', $variantId)->where('p.vacation_mode', false)->select(['v.id', 'v.label', 'v.attributes', 'v.unit_id', 'v.weight_kg', 'v.length_cm', 'v.width_cm', 'v.height_cm',
                'l.id as listing_id', 'l.display_name', 'l.technical_attributes', 'l.publication_version', 'l.material_category_id', 'o.id as vendor_id', 'pd.material_id', 'pd.brand', 'p.fulfillment_method',
                'pv.id as price_version_id', 'pv.amount_centavos', 'pv.tax_category', 'u.code as unit_code', 'u.name as unit_name', 'u.precision'])->selectRaw('i.quantity_on_hand - i.hard_reserved_quantity AS available')
            ->selectRaw(ReadyMixedConcrete::listingSql('l').' AS ready_mixed_concrete')->first();
        $methods = $row === null ? [] : CartService::groupFulfillmentOptions((string) $row->fulfillment_method, (string) $row->vendor_id, [['ready_mixed_concrete' => (bool) $row->ready_mixed_concrete]]);
        if ($row !== null && $row->ready_mixed_concrete) {
            $method = 'DELIVERY';
        }
        if ($row === null || bccomp((string) $row->available, '0', 4) <= 0 || ! in_array($method, $methods, true)) {
            throw new AuthenticationException('ALTERNATIVE_UNAVAILABLE', 'This product cannot currently supply the selected fulfillment method. Remove it or choose another recommendation.', 409);
        }
        $attributes = SpecificationMatch::offered($row->technical_attributes, $row->attributes);
        $definitions = SpecificationMatch::definitions([(string) $row->material_category_id])[(string) $row->material_category_id] ?? [];
        $images = app(ListingPublicFacts::class)->images([(string) $row->listing_id]);

        return ['variant_id' => (string) $row->id, 'listing_id' => (string) $row->listing_id, 'vendor_id' => (string) $row->vendor_id, 'display_name' => (string) $row->display_name,
            'variant_label' => $row->label, 'brand' => $row->brand, 'material_id' => $row->material_id, 'unit_id' => (string) $row->unit_id, 'unit_code' => (string) $row->unit_code,
            'unit_name' => (string) $row->unit_name, 'unit_precision' => (int) $row->precision, 'quantity_step' => CartService::quantityStep((int) $row->precision),
            'unit_price_centavos' => (int) $row->amount_centavos, 'source_price_version_id' => (string) $row->price_version_id, 'tax_category' => (string) $row->tax_category,
            'publication_version' => (int) $row->publication_version, 'offered_specifications' => $attributes, 'specifications' => SpecificationMatch::labelled($attributes, $definitions), 'image' => $images[(string) $row->listing_id][0] ?? null,
            'fulfillment_method' => $method, 'fulfillment_options' => $methods, '_available' => (string) $row->available, 'load' => ['weight_kg' => $row->weight_kg, 'length_cm' => $row->length_cm, 'width_cm' => $row->width_cm, 'height_cm' => $row->height_cm]
                + ReadyMixedConcrete::load($row->ready_mixed_concrete ? ReadyMixedConcrete::MATERIAL_CODE : null, (string) $row->unit_code)];
    }

    /** Draft quantities are checked again when specifications or primary coverage change.
     * @param array<string, mixed> $snapshot
     * @return list<string> */
    public static function excessiveLines(object $w, array $snapshot): array
    {
        $buyer = (string) DB::table('projects')->where('id', $w->project_id)->value('buyer_profile_id');
        $purchases = PackageFulfillment::purchases($w, $buyer);
        $quantities = DB::table('project_procurement_draft_items')->where('work_package_version_id', $w->current_version_id)->where('primary_vendor_id', $snapshot['vendor_id'])
            ->whereNull('order_id')->selectRaw('work_package_line_id, SUM(quantity) AS quantity')->groupBy('work_package_line_id')->get();
        $excessive = [];
        foreach ($quantities as $row) {
            $remaining = PackageFulfillment::remaining($snapshot['lines'], $purchases, (string) $row->work_package_line_id) ?? '0';
            if (bccomp((string) $row->quantity, $remaining, 4) > 0) {
                $excessive[] = (string) $row->work_package_line_id;
            }
        }

        return $excessive;
    }

    /** @param array<string, mixed> $snapshot
     * @param list<array<string, mixed>>|null $items
     * @param array<string, string> $fulfillment
     * @return list<array<string, mixed>> */
    public function groups(object $w, array $snapshot, ?array $items = null, array $fulfillment = [], bool $legacy = true): array
    {
        $items ??= self::items($w, (string) $snapshot['vendor_id'], (string) $snapshot['fulfillment_method']);
        $excessive = $legacy ? self::excessiveLines($w, $snapshot) : [];
        $stores = app(PublicVendorProjection::class)->summaries(array_values(array_unique(array_column($items, 'vendor_id'))));
        $methods = [];
        foreach ($items as $item) {
            $methods[$item['vendor_id']] ??= $fulfillment[$item['vendor_id']] ?? $item['fulfillment_method'] ?? $snapshot['fulfillment_method'];
            if (($item['load']['material_kind'] ?? null) === ReadyMixedConcrete::MATERIAL_CODE) {
                $methods[$item['vendor_id']] = 'DELIVERY';
            }
        }
        $groups = [];
        foreach ($items as $item) {
            $vendor = $item['vendor_id'];
            $groups[$vendor] ??= ['vendor_id' => $vendor, 'store_name' => $stores[$vendor]['public_store_name'] ?? 'Supplier', 'store_address' => $stores[$vendor]['address'] ?? null, 'items' => [], 'materials_centavos' => 0, 'issues' => [],
                'fulfillment_method' => $methods[$vendor], 'payment_methods' => app(PaymentMethodPolicy::class)->options($vendor, $methods[$vendor])];
            if (in_array($item['line_id'], $excessive, true)) {
                $groups[$vendor]['issues'][] = 'The remaining requirement changed. Remove this selection and review the quantity again.';
            }
            try {
                $current = $this->offer($w, $item['variant_id'], $methods[$vendor]);
                $item['fulfillment_method'] = $current['fulfillment_method'];
                $groups[$vendor]['fulfillment_options'] = array_values(array_intersect($groups[$vendor]['fulfillment_options'] ?? $current['fulfillment_options'], $current['fulfillment_options']));
                $aggregate = '0';
                foreach ($items as $other) {
                    if ($other['variant_id'] === $item['variant_id']) {
                        $aggregate = bcadd($aggregate, $other['quantity'], 4);
                    }
                }
                if ($current['source_price_version_id'] !== $item['source_price_version_id'] || $current['publication_version'] !== $item['publication_version'] || bccomp($aggregate, $current['_available'], 4) > 0) {
                    $groups[$vendor]['issues'][] = 'Product details, price or availability changed. Remove and re-add the item to review it.';
                }
                $item['image'] = $current['image'];
            } catch (AuthenticationException $e) {
                $groups[$vendor]['issues'][] = $e->getMessage();
            }
            $item['store_name'] = $groups[$vendor]['store_name'];
            $groups[$vendor]['items'][] = $item;
            $groups[$vendor]['materials_centavos'] += $item['line_total_centavos'];
        }
        foreach ($groups as &$group) {
            $group['fulfillment_options'] ??= [];
            $group['draft_fingerprint'] = self::fingerprint($group['items']);
            // The primary pickup view deliberately clears heavy access. Use the locked
            // package's delivery endpoint for a supplementary mixer instead.
            $content = json_decode((string) DB::table('work_package_versions')->where('id', $w->current_version_id)->value('content'), true);
            $destination = ProjectEstimateService::concrete($content, $group['fulfillment_method'])['destination'];
            $destination['_points'] = ['intended' => $content['site']['point'] + ['active' => true], 'alternate' => $destination['alternate_drop_off'] === null ? null : $destination['alternate_drop_off'] + ['active' => true]];
            $loads = [];
            foreach ($group['items'] as $item) {
                $variant = $item['variant_id'];
                $loads[$variant] ??= ['id' => $variant, 'quantity' => '0', 'load' => $item['load']];
                $loads[$variant]['quantity'] = bcadd($loads[$variant]['quantity'], $item['quantity'], 4);
            }
            $delivery = $group['fulfillment_method'] === 'PICKUP' ? DeliveryPreviewService::notApplicable() : app(DeliveryPreviewService::class)->preview($group['vendor_id'], $destination,
                array_values($loads), true);
            $group['delivery_centavos'] = $group['fulfillment_method'] === 'PICKUP' ? 0 : ($delivery['estimate']['fee_min_centavos'] ?? null);
            $group['delivery'] = $delivery;
            $group['projected_total_centavos'] = $group['delivery_centavos'] === null ? null : $group['materials_centavos'] + $group['delivery_centavos'];
            if ($delivery['status'] === 'BLOCKED') {
                $group['issues'][] = 'Delivery requires attention before requesting this supplier.';
            }
        }
        unset($group);

        return array_values($groups);
    }

    /** @param list<array<string, mixed>> $items */
    private static function fingerprint(array $items): string
    {
        return hash('sha256', json_encode(array_map(static fn (array $item): array => array_intersect_key($item, array_flip(['draft_item_id', 'quantity', 'source_price_version_id', 'publication_version', 'fulfillment_method'])), $items), JSON_THROW_ON_ERROR));
    }

    /** An explicit request to ONE supplementary supplier, after the primary request. Never auto-accepted or paid.
     * @param array<string, mixed> $input */
    public function submit(Request $request, string $packageId, string $candidateId, string $vendorId, array $input): string
    {
        $buyer = app(BuyerProfiles::class)->idFor($request);
        BuyerCommerceRestriction::assertAllowed($buyer);
        $keys = app(CatalogAccess::class);
        $key = $keys->requireIdempotencyKey($request);
        $this->projects->package($request, $packageId);
        if ($keys->replayed($request, 'PROJECT_SUPPLEMENT_REQUEST', $key, $packageId)) {
            return $key;
        }
        $candidate = $this->estimates->candidate($request, $packageId, $candidateId, false);
        $w = $candidate['package'];
        $primary = DB::table('orders')->where('work_package_id', $packageId)->where('procurement_type', 'PROJECT_BASED')->where('vendor_organization_id', $candidate['snapshot']['vendor_id'])
            ->whereNotIn('order_state', OrderStates::CLOSED_BEFORE_FULFILLMENT)->orderByDesc('created_at')->first();
        if ($primary === null) {
            throw new AuthenticationException('PRIMARY_REQUEST_REQUIRED', 'Send the primary Vendor request before requesting supplementary suppliers.', 409);
        }
        $original = json_decode((string) DB::table('order_snapshots')->where('order_id', $primary->id)->where('kind', 'SUBMITTED')->orderBy('version')->value('snapshot'), true);
        $snapshot = $original['system_estimate'];
        $group = collect($this->groups($w, $snapshot))->firstWhere('vendor_id', $vendorId);

        return DB::transaction(function () use ($request, $packageId, $input, $vendorId, $buyer, $key, $keys, $w, $primary, $group): string {
            $current = $this->projects->package($request, $packageId, true);
            if ($keys->replayed($request, 'PROJECT_SUPPLEMENT_REQUEST', $key, $packageId)) {
                return $key;
            }
            ProjectService::version($current, (int) $input['lock_version']);
            $primaryNow = DB::table('orders')->where('id', $primary->id)->lockForUpdate()->first();
            if ($current->current_version_id !== $w->current_version_id || $current->selected_vendor_organization_id !== $primary->vendor_organization_id || $group === null || $group['issues'] !== []
                || in_array($primaryNow->order_state, OrderStates::CLOSED_BEFORE_FULFILLMENT, true)
                || ! hash_equals($group['draft_fingerprint'], $input['draft_fingerprint'])) {
                throw new AuthenticationException('PROJECT_DRAFT_CHANGED', 'Review the latest procurement arrangement before requesting this supplier.', 409);
            }
            DB::table('vendor_organizations')->where('id', $vendorId)->lockForUpdate()->first();
            app(PaymentMethodPolicy::class)->assertAllowed($vendorId, $group['fulfillment_method'], $input['payment_method']);
            $live = array_values(array_filter(self::items($current, (string) $primary->vendor_organization_id, $primary->fulfillment_method), static fn (array $item): bool => $item['vendor_id'] === $vendorId));
            if (! hash_equals(self::fingerprint($live), $input['draft_fingerprint'])) {
                throw new AuthenticationException('PROJECT_DRAFT_CHANGED', 'The selected products changed. Review this supplier again.', 409);
            }
            foreach ($group['items'] as $item) {
                $offer = $this->offer($current, $item['variant_id'], $group['fulfillment_method']);
                $quantity = '0';
                foreach ($group['items'] as $other) {
                    if ($other['variant_id'] === $item['variant_id']) {
                        $quantity = bcadd($quantity, $other['quantity'], 4);
                    }
                }
                if ($offer['source_price_version_id'] !== $item['source_price_version_id'] || $offer['publication_version'] !== $item['publication_version'] || bccomp($quantity, $offer['_available'], 4) > 0) {
                    throw new AuthenticationException('PROJECT_DRAFT_CHANGED', 'The selected products changed. Review this supplier again.', 409);
                }
            }
            $actor = OrderActor::buyer($request);
            $content = json_decode((string) DB::table('work_package_versions')->where('id', $current->current_version_id)->value('content'), true);
            $destination = $group['fulfillment_method'] === 'PICKUP' ? ['type' => 'PICKUP', 'store_address' => $group['store_address']] : ProjectEstimateService::concrete($content, 'DELIVERY')['destination'];
            DB::table('orders')->insert(['id' => $key, 'reference' => 'ORD-'.now('Asia/Manila')->format('Y').'-'.Str::upper(Str::random(10)), 'buyer_profile_id' => $buyer, 'vendor_organization_id' => $vendorId,
                'work_package_id' => $packageId, 'work_package_version_id' => $w->current_version_id, 'procurement_type' => 'ITEM_BASED', 'order_state' => 'AWAITING_VENDOR_CONFIRMATION', 'payment_state' => 'NOT_REQUIRED',
                'fulfillment_method' => $group['fulfillment_method'], 'payment_method' => $input['payment_method'], 'materials_centavos' => $group['materials_centavos'], 'commercial_total_centavos' => $group['materials_centavos'],
                'delivery_centavos' => $group['fulfillment_method'] === 'PICKUP' ? 0 : null, 'destination' => json_encode($destination, JSON_THROW_ON_ERROR),
                'access_instructions_encrypted' => $group['fulfillment_method'] === 'PICKUP' || empty($destination['access_instructions']) ? null : Crypt::encryptString($destination['access_instructions']),
                'submitted_at' => now(), 'vendor_response_due_at' => now()->addHours(PlatformSettings::current()->int('orders.vendor_response_hours')), 'created_at' => now(), 'updated_at' => now()]);
            $allocations = [];
            $priced = [];
            foreach ($group['items'] as $item) {
                $allocations[$item['variant_id']][] = ['line_id' => $item['line_id'], 'quantity' => $item['quantity']];
                $priced[] = array_merge($item, ['matched_quantity' => $item['quantity'], 'amount_centavos' => $item['line_total_centavos']]);
            }
            foreach (ProjectInquiryService::aggregateLines($priced) as $index => $item) {
                $item['quantity'] = $item['matched_quantity'];
                $item['line_total_centavos'] = $item['amount_centavos'];
                $item['work_package_allocations'] = $allocations[$item['variant_id']];
                DB::table('order_lines')->insert(['id' => (string) Str::uuid7(), 'order_id' => $key, 'line_number' => $index + 1, 'listing_variant_id' => $item['variant_id'], 'vendor_listing_id' => $item['listing_id'],
                    'work_package_line_id' => $item['line_id'], 'unit_id' => $item['unit_id'], 'quantity' => $item['quantity'], 'unit_price_centavos' => $item['unit_price_centavos'], 'payable_centavos' => $item['line_total_centavos'],
                    'tax_category' => $item['tax_category'], 'included_vat_centavos' => Money::includedVat($item['line_total_centavos'], $item['tax_category']), 'listing_price_version_id' => $item['source_price_version_id'],
                    'snapshot' => json_encode(array_merge($item, ['specification_details' => $item['specifications'], 'specifications' => $item['offered_specifications']]), JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
            }
            $order = DB::table('orders')->where('id', $key)->first();
            $commercial = app(OrderCommercial::class);
            $money = $commercial->compute($commercial->lines($key), [], 0, $order->delivery_centavos);
            $commercial->record($order, 'SUBMITTED', ['work_package_id' => $packageId, 'source' => 'PROJECT_PROCUREMENT_DRAFT', 'fulfillment_method' => $group['fulfillment_method'], 'payment_method' => $input['payment_method']], $money, $actor);
            app(ProjectBudget::class)->guard($request, $current, $group['projected_total_centavos'] ?? $group['materials_centavos'], $input, $key);
            app(OrderTransitionService::class)->opened($order, $actor);
            app(FulfillmentThreadService::class)->ensureForOrder($key);
            DB::table('project_procurement_draft_items')->whereIn('id', array_column($group['items'], 'draft_item_id'))->update(['order_id' => $key, 'updated_at' => now()]);
            app(OrderNotifier::class)->vendor($order, 'Project supplementary request '.$order->reference, 'Manually confirm this linked materials request before the Buyer gives final approval.');
            $this->projects->record($request, 'PROJECT_SUPPLEMENT_REQUESTED', $packageId);
            $keys->claim($request, 'PROJECT_SUPPLEMENT_REQUEST', $key, $packageId, 201);

            return $key;
        });
    }
}
