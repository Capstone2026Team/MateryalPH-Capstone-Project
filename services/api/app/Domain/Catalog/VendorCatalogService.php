<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Vendor catalog use cases. Organization → listing → variant/inventory rows are
 * always locked in that order; every mutation is audited and re-evaluates
 * Marketplace Discoverability after its state change.
 */
final class VendorCatalogService
{
    public const MAX_VARIANTS = 50;

    public const MAX_MEDIA = 8;

    public const COMPLIANCE_SENSITIVE = ['material_id', 'brand', 'model', 'manufacturer', 'manufacturer_address', 'country_of_manufacture'];

    public function __construct(
        private readonly CatalogAccess $access,
        private readonly AccountAccess $accounts,
        private readonly ListingTransitions $transitions,
        private readonly ListingReadiness $readiness,
        private readonly ListingTaxPolicy $tax,
        private readonly ComparableMappingService $comparability,
        private readonly MarketplaceDiscoverability $discoverability,
        private readonly RentalServicePolicy $rental,
        private readonly CatalogFileStore $files,
        private readonly ImageContentValidator $images,
        private readonly AuditRecorder $audit,
    ) {}

    /** @return array<string, mixed> */
    public function taxonomy(Request $request): array
    {
        $this->access->organizationFor($request, CatalogAccess::VIEW);

        return [
            'categories' => DB::table('material_categories')->where('active', true)->orderBy('sort_order')->orderBy('name')->get(['id', 'code', 'name'])->all(),
            'units' => DB::table('units')->orderBy('name')->get(['id', 'code', 'name', 'dimension', 'precision'])->all(),
            'tags' => DB::table('material_tags')->orderBy('name')->get(['id', 'code', 'name'])->all(),
            'attribute_definitions' => DB::table('technical_attribute_definitions')->orderBy('material_category_id')->orderBy('sort_order')->get(['id', 'material_category_id', 'code', 'label', 'value_type', 'required', 'allowed_values', 'unit_code', 'comparability_key'])
                ->map(fn (object $row): array => ['id' => $row->id, 'material_category_id' => $row->material_category_id, 'code' => $row->code, 'label' => $row->label, 'value_type' => $row->value_type, 'required' => (bool) $row->required, 'allowed_values' => $row->allowed_values === null ? null : ComparableMappingService::decode($row->allowed_values), 'unit_code' => $row->unit_code, 'comparability_key' => (bool) $row->comparability_key])->all(),
            'tax_categories' => ListingTaxPolicy::CATEGORIES,
            'allowed_tax_categories' => $this->tax->allowedCategories($this->access->organizationFor($request, CatalogAccess::VIEW)),
            'limits' => ['max_variants' => self::MAX_VARIANTS, 'max_media' => self::MAX_MEDIA, 'max_listing_image_kb' => $this->maxImageKb(), 'image_types' => array_values(array_unique(ImageContentValidator::TYPES))],
        ];
    }

    /** @return array<string, mixed> */
    public function material(Request $request, string $materialId): array
    {
        $this->access->organizationFor($request, CatalogAccess::VIEW);
        $material = DB::table('materials as m')->join('material_categories as c', 'c.id', '=', 'm.material_category_id')->join('units as u', 'u.id', '=', 'm.canonical_unit_id')
            ->where('m.id', $materialId)->where('m.active', true)->first(['m.id', 'm.code', 'm.name', 'm.regulated', 'c.id as category_id', 'c.name as category_name', 'u.id as canonical_unit_id']);
        if ($material === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The material is unavailable.', 404);
        }

        return [
            'id' => $material->id, 'code' => $material->code, 'name' => $material->name, 'regulated' => (bool) $material->regulated,
            'category_id' => $material->category_id, 'category_name' => $material->category_name, 'canonical_unit_id' => $material->canonical_unit_id,
            'compatible_unit_ids' => DB::table('material_compatible_units')->where('material_id', $materialId)->pluck('unit_id')->all(),
            'suggested_tag_ids' => DB::table('material_tag_links')->where('material_id', $materialId)->pluck('material_tag_id')->all(),
            'regulated_rule' => $this->currentRule($materialId),
        ];
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function list(Request $request, array $filters): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::VIEW);
        $role = $this->accounts->resolve($request->user())['role'];
        if ($role === 'FULFILLMENT') {
            // Fulfillment Staff see only products on assigned fulfillment work.
            return ['items' => [], 'meta' => ['current_page' => 1, 'last_page' => 1, 'total' => 0, 'scope' => 'ASSIGNED_ONLY', 'status_counts' => new \stdClass, 'active_out_of_stock' => 0]];
        }
        $scoped = function () use ($organizationId, $filters) {
            $query = DB::table('vendor_listings as l')->where('l.vendor_organization_id', $organizationId);
            if (! empty($filters['compliance_status'])) {
                $query->where('l.compliance_status', $filters['compliance_status']);
            }
            if (! empty($filters['category_id'])) {
                $query->where('l.material_category_id', $filters['category_id']);
            }
            if (! empty($filters['q'])) {
                $term = '%'.addcslashes(mb_strtolower((string) $filters['q']), '%_\\').'%';
                $query->where(fn ($search) => $search->whereRaw('lower(l.display_name) LIKE ?', [$term])->orWhereRaw('lower(l.vendor_sku) LIKE ?', [$term]));
            }

            return $query;
        };
        // Tab and summary counts share the search and category scope but ignore the selected status.
        $statusCounts = $scoped()->groupBy('l.status')->selectRaw('l.status, COUNT(*) AS total')->pluck('total', 'status')->map(static fn (mixed $total): int => (int) $total)->all();
        $activeOutOfStock = $scoped()->where('l.status', 'ACTIVE')->whereNotExists(fn ($stock) => $stock->selectRaw('1')->from('listing_variants as v')->join('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
            ->whereColumn('v.vendor_listing_id', 'l.id')->where('v.active', true)->whereRaw('i.quantity_on_hand - i.hard_reserved_quantity > 0'))->count();
        $query = $scoped()->join('products as p', 'p.id', '=', 'l.product_id')
            ->leftJoin('materials as m', 'm.id', '=', 'p.material_id')->leftJoin('material_categories as c', 'c.id', '=', 'l.material_category_id');
        if (! empty($filters['status'])) {
            $query->where('l.status', $filters['status']);
        }
        $page = $query->orderByDesc('l.updated_at')->orderBy('l.id')->paginate(20, ['l.id', 'l.display_name', 'l.vendor_sku', 'l.status', 'l.compliance_status', 'l.regulated', 'l.other_label', 'l.lock_version', 'l.updated_at', 'c.name as category_name', 'm.name as material_name'], 'page', (int) ($filters['page'] ?? 1));
        $ids = collect($page->items())->pluck('id')->all();
        $prices = DB::table('listing_variants as v')->join('listing_price_versions as pv', fn ($join) => $join->on('pv.listing_variant_id', '=', 'v.id')->where('pv.price_kind', 'ORDINARY')->whereNull('pv.retired_at'))
            ->whereIn('v.vendor_listing_id', $ids)->where('v.active', true)->groupBy('v.vendor_listing_id')
            ->selectRaw('v.vendor_listing_id, MIN(pv.amount_centavos) AS min_price, MAX(pv.amount_centavos) AS max_price, COUNT(DISTINCT v.id) AS variant_count')->get()->keyBy('vendor_listing_id');
        $available = DB::table('listing_variants as v')->join('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')->whereIn('v.vendor_listing_id', $ids)->where('v.active', true)
            ->whereRaw('i.quantity_on_hand - i.hard_reserved_quantity > 0')->distinct()->pluck('v.vendor_listing_id')->flip();
        $images = DB::table('listing_media')->whereIn('vendor_listing_id', $ids)->where('status', 'READY')->orderBy('sort_order')->orderBy('id')->get(['vendor_listing_id', 'file_id'])->groupBy('vendor_listing_id');
        $imageFiles = DB::table('files')->whereIn('id', $images->map(fn ($media) => $media[0]->file_id)->values()->all())->where('scan_state', 'CLEAN')->get()->keyBy('id');
        // One sale unit per listing lets the card show "₱275 / bag" and a summed Vendor-only stock figure.
        $units = DB::table('listing_variants as v')->join('units as u', 'u.id', '=', 'v.unit_id')->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
            ->whereIn('v.vendor_listing_id', $ids)->where('v.active', true)->groupBy('v.vendor_listing_id')
            ->selectRaw('v.vendor_listing_id, MIN(u.code) AS unit_code, COUNT(DISTINCT v.unit_id) AS unit_count, COUNT(i.id) AS counted, COUNT(v.id) AS variants, SUM(i.quantity_on_hand - i.hard_reserved_quantity) AS available')
            ->get()->keyBy('vendor_listing_id');

        return ['items' => array_map(fn (object $row): array => [
            'id' => $row->id, 'display_name' => $row->display_name, 'vendor_sku' => $row->vendor_sku, 'status' => $row->status,
            'compliance_status' => $row->compliance_status, 'regulated' => (bool) $row->regulated, 'category_name' => $row->category_name,
            'material_name' => $row->material_name, 'other_label' => $row->other_label, 'lock_version' => (int) $row->lock_version, 'updated_at' => $row->updated_at,
            'variant_count' => (int) ($prices[$row->id]->variant_count ?? 0),
            'min_price_centavos' => isset($prices[$row->id]) ? (int) $prices[$row->id]->min_price : null,
            'max_price_centavos' => isset($prices[$row->id]) ? (int) $prices[$row->id]->max_price : null,
            'public_availability' => isset($available[$row->id]) ? 'IN_STOCK' : 'OUT_OF_STOCK',
            'primary_image_file_id' => $images[$row->id][0]->file_id ?? null,
            'primary_image_url' => isset($images[$row->id], $imageFiles[$images[$row->id][0]->file_id]) ? $this->files->temporaryUrl($imageFiles[$images[$row->id][0]->file_id])['url'] : null,
            'unit_code' => isset($units[$row->id]) && (int) $units[$row->id]->unit_count === 1 ? (string) $units[$row->id]->unit_code : null,
            'available_quantity' => isset($units[$row->id]) && (int) $units[$row->id]->unit_count === 1 && (int) $units[$row->id]->counted === (int) $units[$row->id]->variants ? bcadd((string) $units[$row->id]->available, '0', 4) : null,
        ], $page->items()), 'meta' => [
            'current_page' => $page->currentPage(), 'last_page' => $page->lastPage(), 'total' => $page->total(), 'scope' => 'ORGANIZATION',
            'status_counts' => (object) $statusCounts, 'active_out_of_stock' => $activeOutOfStock,
        ]];
    }

    /** @return array<string, mixed> */
    public function detail(Request $request, string $listingId): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::VIEW);
        if ($this->accounts->resolve($request->user())['role'] === 'FULFILLMENT') {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The listing is unavailable.', 404);
        }

        return $this->present($request, $this->ownedListing($listingId, $organizationId, false));
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function create(Request $request, array $input): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::MANAGE);
        $key = $this->access->requireIdempotencyKey($request);
        $listingId = DB::transaction(function () use ($request, $input, $organizationId, $key): string {
            $this->access->lockActiveStore($organizationId);
            if ($this->access->replayed($request, 'catalog.listings.create', $key, $organizationId)) {
                $existing = DB::table('vendor_listings')->where('vendor_organization_id', $organizationId)->where('vendor_sku', $this->sku((string) $input['vendor_sku']))->value('id');
                if (is_string($existing)) {
                    return $existing;
                }
            }
            $this->assertNotRental((string) $input['display_name'], 'display_name');
            $sku = $this->sku((string) $input['vendor_sku']);
            if (DB::table('vendor_listings')->where('vendor_organization_id', $organizationId)->where('vendor_sku', $sku)->exists()) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['vendor_sku' => ['This Vendor SKU is already used by another listing.']]);
            }
            $productId = DB::table('products')->insertGetId(['name' => trim((string) $input['display_name']), 'public_id' => (string) Str::uuid7(), 'vendor_organization_id' => $organizationId, 'created_at' => now(), 'updated_at' => now()]);
            $listingId = (string) Str::uuid7();
            DB::table('vendor_listings')->insert(['id' => $listingId, 'vendor_organization_id' => $organizationId, 'product_id' => $productId, 'vendor_sku' => $sku, 'display_name' => trim((string) $input['display_name']), 'status' => 'DRAFT', 'created_by_user_id' => $request->user()->getKey(), 'updated_by_user_id' => $request->user()->getKey(), 'created_at' => now(), 'updated_at' => now()]);
            DB::table('listing_status_history')->insert(['id' => (string) Str::uuid7(), 'vendor_listing_id' => $listingId, 'from_status' => null, 'to_status' => 'DRAFT', 'actor_user_id' => $request->user()->getKey(), 'source' => 'VENDOR', 'reason_code' => 'CREATED', 'created_at' => now(), 'updated_at' => now()]);
            $this->access->claim($request, 'catalog.listings.create', $key, $organizationId, 201);
            $this->audit->account($request, 'CATALOG_LISTING_CREATED', 'VENDOR_LISTING', $listingId, after: ['vendor_sku' => $sku]);

            return $listingId;
        });

        return $this->present($request, $this->ownedListing($listingId, $organizationId, false));
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function update(Request $request, string $listingId, array $input): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::MANAGE);
        DB::transaction(function () use ($request, $listingId, $input, $organizationId): void {
            $this->access->lockActiveStore($organizationId);
            $listing = $this->ownedListing($listingId, $organizationId, true);
            $this->assertVersion($listing, $input['lock_version']);
            $product = DB::table('products')->where('id', $listing->product_id)->lockForUpdate()->first();
            $before = $this->complianceFingerprint($product, $listing);
            $listingValues = ['updated_by_user_id' => $request->user()->getKey(), 'updated_at' => now(), 'lock_version' => DB::raw('lock_version + 1')];
            $productValues = ['updated_at' => now()];
            foreach (['display_name', 'description'] as $field) {
                if (array_key_exists($field, $input)) {
                    $listingValues[$field] = $input[$field] === null ? null : trim((string) $input[$field]);
                }
            }
            if (isset($input['display_name'])) {
                $this->assertNotRental((string) $input['display_name'], 'display_name');
                $productValues['name'] = trim((string) $input['display_name']);
            }
            if (isset($input['vendor_sku'])) {
                $sku = $this->sku((string) $input['vendor_sku']);
                if (DB::table('vendor_listings')->where('vendor_organization_id', $organizationId)->where('vendor_sku', $sku)->where('id', '!=', $listingId)->exists()) {
                    throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['vendor_sku' => ['This Vendor SKU is already used by another listing.']]);
                }
                $listingValues['vendor_sku'] = $sku;
            }
            foreach (['brand', 'model', 'manufacturer', 'manufacturer_address', 'country_of_manufacture'] as $field) {
                if (array_key_exists($field, $input)) {
                    $productValues[$field] = $input[$field] === null || trim((string) $input[$field]) === '' ? null : trim((string) $input[$field]);
                }
            }
            if (array_key_exists('material_id', $input) || array_key_exists('other_label', $input) || array_key_exists('material_category_id', $input)) {
                [$materialValues, $productMaterial] = $this->classification($input, $listing, $product);
                $listingValues += $materialValues;
                $productValues['material_id'] = $productMaterial;
            }
            // Attributes are validated against the category resolved from this same save.
            $categoryId = $listingValues['material_category_id'] ?? $listing->material_category_id;
            if (array_key_exists('technical_attributes', $input)) {
                $listingValues['technical_attributes'] = json_encode($this->attributes($input['technical_attributes'] ?? [], $categoryId), JSON_THROW_ON_ERROR);
            } elseif ($categoryId !== $listing->material_category_id) {
                // A category change drops attributes that belonged to the previous category.
                $listingValues['technical_attributes'] = json_encode([], JSON_THROW_ON_ERROR);
            }
            if (array_key_exists('tag_ids', $input)) {
                $tags = array_values(array_unique(array_filter($input['tag_ids'], 'is_string')));
                if (count($tags) > 3 || DB::table('material_tags')->whereIn('id', $tags)->count() !== count($tags)) {
                    throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['tag_ids' => ['Choose one to three approved search tags.']]);
                }
                DB::table('listing_tag_links')->where('vendor_listing_id', $listingId)->delete();
                foreach ($tags as $tagId) {
                    DB::table('listing_tag_links')->insert(['id' => (string) Str::uuid7(), 'vendor_listing_id' => $listingId, 'material_tag_id' => $tagId, 'created_at' => now(), 'updated_at' => now()]);
                }
            }
            DB::table('products')->where('id', $product->id)->update($productValues);
            DB::table('vendor_listings')->where('id', $listingId)->update($listingValues);

            $listing = $this->ownedListing($listingId, $organizationId, true);
            $after = $this->complianceFingerprint(DB::table('products')->where('id', $product->id)->first(), $listing);
            $this->applyRegulation($request, $listing, $before !== $after);
            foreach (DB::table('listing_variants')->where('vendor_listing_id', $listingId)->orderBy('id')->pluck('id') as $variantId) {
                $this->comparability->assign((string) $variantId);
            }
            $this->guardActiveListing($listingId);
            $listing = $this->ownedListing($listingId, $organizationId, true);
            $this->transitions->republish($listing, $request->user()->getKey(), 'LISTING_DETAILS_CHANGED');
            $this->audit->account($request, 'CATALOG_LISTING_UPDATED', 'VENDOR_LISTING', $listingId, after: array_intersect_key($input, array_flip(['display_name', 'vendor_sku', 'material_id', 'material_category_id', 'other_label', 'brand', 'manufacturer'])));
            $this->discoverability->evaluate($organizationId, $request->user()->getKey(), 'VENDOR');
        });

        return $this->present($request, $this->ownedListing($listingId, $organizationId, false));
    }

    /**
     * Saves the variant row group atomically. Every row is validated and all
     * row errors are returned together, keyed variants.{index}.{field}.
     *
     * @param  array{lock_version: int, variants: list<array<string, mixed>>}  $input
     * @return array<string, mixed>
     */
    public function saveVariants(Request $request, string $listingId, array $input): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::MANAGE);
        DB::transaction(function () use ($request, $listingId, $input, $organizationId): void {
            $this->access->lockActiveStore($organizationId);
            $listing = $this->ownedListing($listingId, $organizationId, true);
            $this->assertVersion($listing, $input['lock_version']);
            $rows = $input['variants'];
            $existing = DB::table('listing_variants')->where('vendor_listing_id', $listingId)->orderBy('id')->lockForUpdate()->get()->keyBy('id');
            $errors = $this->variantErrors($rows, $existing->keys()->all(), $listing);
            if ($errors !== []) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted variant rows and try again.', 422, $errors);
            }
            $kept = [];
            $priceChanged = false;
            foreach ($rows as $index => $row) {
                $variantId = isset($row['id']) && $existing->has($row['id']) ? (string) $row['id'] : (string) Str::uuid7();
                $values = [
                    'sku' => $this->sku((string) $row['sku']), 'label' => isset($row['label']) ? trim((string) $row['label']) : null, 'unit_id' => $row['unit_id'],
                    'pack_quantity' => (string) $row['pack_quantity'], 'attributes' => json_encode($this->attributes($row['attributes'] ?? [], $listing->material_category_id), JSON_THROW_ON_ERROR),
                    'weight_kg' => $row['weight_kg'] ?? null, 'length_cm' => $row['length_cm'] ?? null, 'width_cm' => $row['width_cm'] ?? null, 'height_cm' => $row['height_cm'] ?? null,
                    'active' => (bool) ($row['active'] ?? true), 'sort_order' => $index, 'updated_at' => now(),
                ];
                if ($existing->has($variantId)) {
                    DB::table('listing_variants')->where('id', $variantId)->update($values + ['lock_version' => DB::raw('lock_version + 1')]);
                } else {
                    DB::table('listing_variants')->insert($values + ['id' => $variantId, 'vendor_listing_id' => $listingId, 'created_at' => now()]);
                }
                $kept[] = $variantId;
                $priceChanged = $this->savePrice($request, $variantId, (int) $row['price_centavos'], (string) $row['tax_category'], $row['tax_basis'] ?? null) || $priceChanged;
                $tiers = array_key_exists('volume_tiers', $row) ? $this->requestedTiers($row) : array_map(static fn (array $tier): array => ['minimum_quantity' => $tier['minimum_quantity'], 'price_centavos' => $tier['amount_centavos']], $this->currentTiers($variantId));
                $priceChanged = $this->saveTiers($request, $variantId, $tiers, (string) $row['tax_category'], $row['tax_basis'] ?? null) || $priceChanged;
                if (array_key_exists('quantity_on_hand', $row) && $row['quantity_on_hand'] !== null) {
                    $this->recordStockCount($request, $variantId, (string) $row['quantity_on_hand']);
                }
            }
            foreach ($existing->keys()->diff($kept) as $removedId) {
                // Variants may already be referenced by quotations and orders; they are deactivated, never deleted.
                DB::table('listing_variants')->where('id', $removedId)->update(['active' => false, 'updated_at' => now(), 'lock_version' => DB::raw('lock_version + 1')]);
            }
            foreach (DB::table('listing_variants')->where('vendor_listing_id', $listingId)->orderBy('id')->pluck('id') as $variantId) {
                $this->comparability->assign((string) $variantId);
            }
            DB::table('vendor_listings')->where('id', $listingId)->update(['lock_version' => DB::raw('lock_version + 1'), 'updated_by_user_id' => $request->user()->getKey(), 'updated_at' => now()]);
            $this->guardActiveListing($listingId);
            $this->transitions->republish($this->ownedListing($listingId, $organizationId, true), $request->user()->getKey(), $priceChanged ? 'PRICE_VERSION_CHANGED' : 'VARIANTS_CHANGED');
            $this->audit->account($request, 'CATALOG_VARIANTS_SAVED', 'VENDOR_LISTING', $listingId, after: ['variant_count' => count($rows), 'price_changed' => $priceChanged]);
            $this->discoverability->evaluate($organizationId, $request->user()->getKey(), 'VENDOR');
        });

        return $this->present($request, $this->ownedListing($listingId, $organizationId, false));
    }

    /** @return array<string, mixed> */
    public function uploadMedia(Request $request, string $listingId, UploadedFile $file, ?string $altText, ?string $replacesMediaId): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::MANAGE);
        $maxKb = $this->maxImageKb();
        $image = $this->images->validate($file, $maxKb, 'product photo');
        DB::transaction(function () use ($organizationId, $listingId): void {
            $this->access->lockActiveStore($organizationId);
            $this->ownedListing($listingId, $organizationId, false);
        });
        $fileId = $this->files->store($file, 'VENDOR_ORGANIZATION', $organizationId, CatalogFileStore::LISTING_MEDIA, (int) $request->user()->getKey(), $image['mime']);
        try {
            $mediaId = DB::transaction(function () use ($request, $organizationId, $listingId, $fileId, $altText, $replacesMediaId): string {
                $this->access->lockActiveStore($organizationId);
                $this->ownedListing($listingId, $organizationId, true);
                $version = 1;
                if ($replacesMediaId !== null) {
                    $replaced = DB::table('listing_media')->where('id', $replacesMediaId)->where('vendor_listing_id', $listingId)->where('status', 'READY')->lockForUpdate()->first();
                    if ($replaced === null) {
                        throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'That photo was already replaced or removed. Refresh the listing.', 409);
                    }
                    DB::table('listing_media')->where('id', $replacesMediaId)->update(['status' => 'REPLACED', 'removed_at' => now(), 'updated_at' => now()]);
                    $version = (int) $replaced->media_version + 1;
                } elseif (DB::table('listing_media')->where('vendor_listing_id', $listingId)->where('status', 'READY')->count() >= self::MAX_MEDIA) {
                    throw new AuthenticationException('MEDIA_LIMIT_REACHED', 'A listing can have up to '.self::MAX_MEDIA.' photos. Remove or replace one first.', 422);
                }
                $mediaId = (string) Str::uuid7();
                $order = (int) DB::table('listing_media')->where('vendor_listing_id', $listingId)->max('sort_order') + 1;
                DB::table('listing_media')->insert(['id' => $mediaId, 'vendor_listing_id' => $listingId, 'file_id' => $fileId, 'alt_text' => $altText === null ? null : Str::limit(trim($altText), 160, ''), 'sort_order' => $order, 'status' => 'READY', 'media_version' => $version, 'replaces_media_id' => $replacesMediaId, 'uploaded_by_user_id' => $request->user()->getKey(), 'created_at' => now(), 'updated_at' => now()]);
                DB::table('vendor_listings')->where('id', $listingId)->update(['lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
                $this->transitions->republish($this->ownedListing($listingId, $organizationId, true), $request->user()->getKey(), 'MEDIA_CHANGED');
                $this->audit->account($request, 'CATALOG_LISTING_MEDIA_UPLOADED', 'LISTING_MEDIA', $mediaId, after: ['version' => $version]);

                return $mediaId;
            });
        } catch (\Throwable $exception) {
            $this->files->discard($fileId);
            throw $exception;
        }

        return $this->present($request, $this->ownedListing($listingId, $organizationId, false)) + ['uploaded_media_id' => $mediaId];
    }

    /** @return array<string, mixed> */
    public function removeMedia(Request $request, string $listingId, string $mediaId): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::MANAGE);
        DB::transaction(function () use ($request, $organizationId, $listingId, $mediaId): void {
            $this->access->lockActiveStore($organizationId);
            $this->ownedListing($listingId, $organizationId, true);
            $media = DB::table('listing_media')->where('id', $mediaId)->where('vendor_listing_id', $listingId)->lockForUpdate()->first();
            if ($media === null || $media->status !== 'READY') {
                throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'That photo was already replaced or removed. Refresh the listing.', 409);
            }
            DB::table('listing_media')->where('id', $mediaId)->update(['status' => 'REMOVED', 'removed_at' => now(), 'updated_at' => now()]);
            DB::table('vendor_listings')->where('id', $listingId)->update(['lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
            $this->guardActiveListing($listingId);
            $this->transitions->republish($this->ownedListing($listingId, $organizationId, true), $request->user()->getKey(), 'MEDIA_CHANGED');
            $this->audit->account($request, 'CATALOG_LISTING_MEDIA_REMOVED', 'LISTING_MEDIA', $mediaId);
        });

        return $this->present($request, $this->ownedListing($listingId, $organizationId, false));
    }

    /** @return array<string, mixed> */
    public function publish(Request $request, string $listingId, int $lockVersion): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::MANAGE);
        $key = $this->access->requireIdempotencyKey($request);
        DB::transaction(function () use ($request, $organizationId, $listingId, $lockVersion, $key): void {
            $this->access->lockActiveStore($organizationId);
            if ($this->access->replayed($request, 'catalog.listings.publish', $key, $listingId)) {
                return;
            }
            $listing = $this->ownedListing($listingId, $organizationId, true);
            $this->assertVersion($listing, $lockVersion);
            if ($listing->status === 'ACTIVE') {
                throw new AuthenticationException('LISTING_ALREADY_ACTIVE', 'This listing is already published.', 409);
            }
            $readiness = $this->readiness->evaluate($listingId);
            if ($readiness['blockers'] !== []) {
                throw new AuthenticationException('LISTING_NOT_PUBLISHABLE', 'Complete the listing before publishing.', 422, ['blockers' => $readiness['blockers']]);
            }
            DB::table('vendor_listings')->where('id', $listingId)->update(['publication_requested_at' => now()]);
            $this->transitions->transition($listing, ListingTransitions::publicationTarget($listing), 'VENDOR', $request->user()->getKey(), 'PUBLICATION_REQUESTED');
            $this->access->claim($request, 'catalog.listings.publish', $key, $listingId, 200);
            $this->audit->account($request, 'CATALOG_LISTING_PUBLICATION_REQUESTED', 'VENDOR_LISTING', $listingId, after: ['status' => $listing->status]);
            $this->discoverability->evaluate($organizationId, $request->user()->getKey(), 'VENDOR');
        });

        return $this->present($request, $this->ownedListing($listingId, $organizationId, false));
    }

    /** @return array<string, mixed> */
    public function deactivate(Request $request, string $listingId, int $lockVersion, ?string $reason): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::MANAGE);
        DB::transaction(function () use ($request, $organizationId, $listingId, $lockVersion, $reason): void {
            // Deactivation stays available while a store is restricted so a Vendor can withdraw offers.
            DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
            $listing = $this->ownedListing($listingId, $organizationId, true);
            $this->assertVersion($listing, $lockVersion);
            if (! in_array($listing->status, ['ACTIVE', 'PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED'], true)) {
                throw new AuthenticationException('LISTING_TRANSITION_INVALID', 'Only a published or pending listing can be deactivated.', 409);
            }
            DB::table('vendor_listings')->where('id', $listingId)->update(['publication_requested_at' => null]);
            $this->transitions->transition($listing, 'INACTIVE', 'VENDOR', $request->user()->getKey(), 'VENDOR_DEACTIVATED', $reason);
            $this->audit->account($request, 'CATALOG_LISTING_DEACTIVATED', 'VENDOR_LISTING', $listingId, reason: $reason);
            $this->discoverability->evaluate($organizationId, $request->user()->getKey(), 'VENDOR');
        });

        return $this->present($request, $this->ownedListing($listingId, $organizationId, false));
    }

    /** @return array{url: string, expires_at: string} */
    public function fileUrl(Request $request, string $fileId): array
    {
        $organizationId = $this->access->organizationFor($request, CatalogAccess::VIEW);

        return $this->files->temporaryUrl($this->authorizedVendorFile($request, $organizationId, $fileId));
    }

    public function authorizedVendorFile(Request $request, string $organizationId, string $fileId): object
    {
        $file = DB::table('files')->where('id', $fileId)->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $organizationId)->where('scan_state', 'CLEAN')->first();
        $permissions = $this->accounts->resolve($request->user())['permissions'];
        $allowed = $file !== null && match ($file->purpose) {
            CatalogFileStore::LISTING_MEDIA => DB::table('listing_media')->where('file_id', $fileId)->exists(),
            CatalogFileStore::COMPLIANCE_EVIDENCE => in_array(CatalogAccess::SUBMIT_COMPLIANCE, $permissions, true) && DB::table('compliance_evidence')->where('file_id', $fileId)->where('vendor_organization_id', $organizationId)->exists(),
            default => false,
        };
        if (! $allowed) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The file is unavailable.', 404);
        }

        return $file;
    }

    public function ownedListing(string $listingId, string $organizationId, bool $lock): object
    {
        $query = DB::table('vendor_listings')->where('id', $listingId)->where('vendor_organization_id', $organizationId);
        $listing = ($lock ? $query->lockForUpdate() : $query)->first();
        if ($listing === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'The listing is unavailable.', 404);
        }

        return $listing;
    }

    /** @return array<string, mixed>|null */
    public function currentRule(string $materialId): ?array
    {
        $rule = DB::table('regulated_material_rules')->where('material_id', $materialId)->where('effective_from', '<=', now('Asia/Manila')->toDateString())
            ->where(fn ($query) => $query->whereNull('effective_to')->orWhere('effective_to', '>', now('Asia/Manila')->toDateString()))->orderByDesc('version')->first();

        return $rule === null ? null : [
            'id' => $rule->id, 'version' => (int) $rule->version, 'required_marking' => $rule->required_marking, 'product_name' => $rule->product_name,
            'reference_standard' => $rule->reference_standard, 'technical_regulation' => $rule->technical_regulation, 'scope' => $rule->scope,
            'marking_requirements' => ComparableMappingService::decode($rule->marking_requirements), 'source_reference' => $rule->source_reference,
        ];
    }

    /** @return array<string, mixed> */
    public function present(Request $request, object $listing): array
    {
        $product = DB::table('products')->where('id', $listing->product_id)->first();
        $material = $product?->material_id === null ? null : DB::table('materials')->where('id', $product->material_id)->first(['id', 'code', 'name', 'regulated']);
        $permissions = $this->accounts->resolve($request->user())['permissions'];
        $variants = DB::table('listing_variants as v')->join('units as u', 'u.id', '=', 'v.unit_id')->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
            ->where('v.vendor_listing_id', $listing->id)->orderByDesc('v.active')->orderBy('v.sort_order')->orderBy('v.id')
            ->get(['v.*', 'u.code as unit_code', 'i.quantity_on_hand', 'i.hard_reserved_quantity', 'i.confirmed_at']);
        $submissions = DB::table('compliance_submissions')->where('vendor_listing_id', $listing->id)->orderByDesc('version')->limit(20)->get();
        $readiness = $this->readiness->evaluate((string) $listing->id);

        return [
            'id' => $listing->id, 'status' => $listing->status, 'lock_version' => (int) $listing->lock_version,
            'display_name' => $listing->display_name, 'vendor_sku' => $listing->vendor_sku, 'description' => $listing->description,
            'material' => $material === null ? null : ['id' => $material->id, 'code' => $material->code, 'name' => $material->name, 'regulated' => (bool) $material->regulated],
            'material_match' => $listing->material_match, 'material_category_id' => $listing->material_category_id, 'other_label' => $listing->other_label,
            'tag_ids' => DB::table('listing_tag_links')->where('vendor_listing_id', $listing->id)->pluck('material_tag_id')->all(),
            'technical_attributes' => ComparableMappingService::decode($listing->technical_attributes),
            'brand' => $product?->brand, 'model' => $product?->model, 'manufacturer' => $product?->manufacturer, 'manufacturer_address' => $product?->manufacturer_address, 'country_of_manufacture' => $product?->country_of_manufacture,
            'regulated' => (bool) $listing->regulated, 'compliance_status' => $listing->compliance_status,
            'regulated_rule' => $product?->material_id === null || ! $listing->regulated ? null : $this->currentRule((string) $product->material_id),
            'publication_version' => (int) $listing->publication_version, 'published_at' => $listing->published_at, 'publication_requested_at' => $listing->publication_requested_at,
            'variants' => array_map(fn (object $variant): array => $this->presentVariant($variant), $variants->all()),
            'media' => DB::table('listing_media as m')->join('files as f', 'f.id', '=', 'm.file_id')->where('m.vendor_listing_id', $listing->id)->orderByRaw("CASE WHEN m.status = 'READY' THEN 0 ELSE 1 END")->orderBy('m.sort_order')->limit(40)
                ->get(['m.id', 'm.file_id', 'm.alt_text', 'm.status', 'm.media_version', 'm.replaces_media_id', 'm.created_at', 'f.content_type', 'f.byte_size', 'f.scan_state'])
                ->map(fn (object $media): array => ['id' => $media->id, 'file_id' => $media->file_id, 'alt_text' => $media->alt_text, 'status' => $media->status, 'version' => (int) $media->media_version, 'replaces_media_id' => $media->replaces_media_id, 'content_type' => $media->content_type, 'byte_size' => (int) $media->byte_size, 'scan_state' => $media->scan_state, 'uploaded_at' => $media->created_at])->all(),
            'compliance_submissions' => $submissions->map(fn (object $submission): array => [
                'id' => $submission->id, 'version' => (int) $submission->version, 'path' => $submission->path, 'status' => $submission->status, 'marking_type' => $submission->marking_type,
                'submitted_at' => $submission->submitted_at, 'decided_at' => $submission->decided_at,
                'latest_review' => ($review = DB::table('compliance_reviews')->where('compliance_submission_id', $submission->id)->orderByDesc('created_at')->first(['decision', 'reason', 'reviewed_at', 'reviewer_user_id'])) === null ? null : ['decision' => $review->decision, 'reason' => $review->reason, 'reviewed_at' => $review->reviewed_at, 'source' => $review->reviewer_user_id === null ? 'SYSTEM_REGISTER_MATCH' : 'ADMIN'],
            ])->all(),
            'status_history' => DB::table('listing_status_history')->where('vendor_listing_id', $listing->id)->orderByDesc('created_at')->orderByDesc('id')->limit(20)->get(['from_status', 'to_status', 'source', 'reason_code', 'reason', 'publication_version', 'created_at'])->all(),
            'completion' => ['key' => 'LISTING', 'label' => 'Listing', 'steps' => $readiness['steps']],
            'blockers' => $readiness['blockers'],
            'permissions' => ['can_manage' => in_array(CatalogAccess::MANAGE, $permissions, true), 'can_submit_compliance' => in_array(CatalogAccess::SUBMIT_COMPLIANCE, $permissions, true)],
        ];
    }

    /**
     * Vendor-only variant view. Exact quantities are private to the Vendor; Buyers only ever see the availability label.
     *
     * @return array<string, mixed>
     */
    private function presentVariant(object $variant): array
    {
        $price = $this->comparability->ordinaryPublicPrice((string) $variant->id);
        $assignment = DB::table('listing_comparable_assignments')->where('listing_variant_id', $variant->id)->whereNull('effective_until')->where('mapping_state', 'APPROVED')->value('material_comparable_group_version_id');
        $available = $variant->quantity_on_hand === null ? null : bcsub((string) $variant->quantity_on_hand, (string) $variant->hard_reserved_quantity, 4);

        return [
            'id' => $variant->id, 'sku' => $variant->sku, 'label' => $variant->label, 'unit_id' => $variant->unit_id, 'unit_code' => $variant->unit_code,
            'pack_quantity' => (string) $variant->pack_quantity, 'attributes' => ComparableMappingService::decode($variant->attributes), 'active' => (bool) $variant->active,
            'weight_kg' => $variant->weight_kg === null ? null : (string) $variant->weight_kg, 'length_cm' => $variant->length_cm === null ? null : (string) $variant->length_cm,
            'width_cm' => $variant->width_cm === null ? null : (string) $variant->width_cm, 'height_cm' => $variant->height_cm === null ? null : (string) $variant->height_cm,
            'lock_version' => (int) $variant->lock_version,
            'price' => $price === null ? null : ['price_version_id' => $price->id, 'version' => (int) $price->version, 'amount_centavos' => (int) $price->amount_centavos, 'tax_category' => $price->tax_category, 'tax_basis' => $price->tax_basis, 'included_vat_centavos' => ListingTaxPolicy::includedVatCentavos((int) $price->amount_centavos, (string) $price->tax_category), 'effective_at' => $price->effective_at],
            'volume_tiers' => array_map(static fn (array $tier): array => ['price_version_id' => $tier['price_version_id'], 'version' => $tier['version'], 'minimum_quantity' => $tier['minimum_quantity'], 'amount_centavos' => $tier['amount_centavos'], 'included_vat_centavos' => ListingTaxPolicy::includedVatCentavos($tier['amount_centavos'], $tier['tax_category'])], $this->currentTiers((string) $variant->id)),
            'inventory' => $available === null ? null : ['quantity_on_hand' => (string) $variant->quantity_on_hand, 'hard_reserved_quantity' => (string) $variant->hard_reserved_quantity, 'available_to_sell' => $available, 'confirmed_at' => $variant->confirmed_at],
            'public_availability' => $available !== null && bccomp($available, '0', 4) > 0 ? 'IN_STOCK' : 'OUT_OF_STOCK',
            'comparability' => $assignment === null ? 'NOT_YET_COMPARABLE' : 'COMPARABLE',
        ];
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array{0: array<string, mixed>, 1: ?string}
     */
    private function classification(array $input, object $listing, object $product): array
    {
        $materialId = array_key_exists('material_id', $input) ? $input['material_id'] : $product->material_id;
        $otherLabel = array_key_exists('other_label', $input) ? ($input['other_label'] === null ? null : trim((string) preg_replace('/\s+/u', ' ', (string) $input['other_label']))) : $listing->other_label;
        $categoryId = array_key_exists('material_category_id', $input) ? $input['material_category_id'] : $listing->material_category_id;
        $match = 'UNMATCHED';
        if ($materialId !== null) {
            $material = DB::table('materials')->where('id', $materialId)->where('active', true)->first(['id', 'material_category_id']);
            if ($material === null) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['material_id' => ['Choose an active canonical material.']]);
            }
            $categoryId ??= $material->material_category_id;
            if ($categoryId !== $material->material_category_id) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['material_category_id' => ['The category must match the selected canonical material.']]);
            }
            $match = in_array($input['material_match'] ?? null, ['EXACT', 'ALIAS', 'FUZZY_CONFIRMED'], true) ? $input['material_match'] : 'EXACT';
            $otherLabel = null;
        } elseif ($otherLabel !== null) {
            // Other labels describe this listing only; they are never written to the shared taxonomy.
            if (mb_strlen($otherLabel) < 2 || mb_strlen($otherLabel) > 60) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['other_label' => ['Use 2–60 characters for the Other label.']]);
            }
            $this->assertNotRental($otherLabel, 'other_label');
        }
        if ($categoryId !== null && ! DB::table('material_categories')->where('id', $categoryId)->where('active', true)->exists()) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['material_category_id' => ['Choose an active category.']]);
        }

        return [['material_category_id' => $categoryId, 'other_label' => $otherLabel, 'material_match' => $match], $materialId];
    }

    /** Applies the current regulated-material rule and withdraws verification after compliance-sensitive edits. */
    private function applyRegulation(Request $request, object $listing, bool $sensitiveChange): void
    {
        $materialId = DB::table('products')->where('id', $listing->product_id)->value('material_id');
        $rule = $materialId === null ? null : $this->currentRule((string) $materialId);
        $regulated = $rule !== null;
        $status = (string) $listing->compliance_status;
        if (! $regulated) {
            $status = 'NOT_REQUIRED';
        } elseif (! $listing->regulated || $status === 'NOT_REQUIRED' || ($sensitiveChange && in_array($status, ['VERIFIED', 'PENDING_ADMIN_REVIEW'], true)) || $listing->regulated_material_rule_id !== $rule['id']) {
            $status = 'NOT_SUBMITTED';
        }
        if ($sensitiveChange && $status === 'NOT_SUBMITTED') {
            // A pending review of the superseded declaration no longer describes this product.
            DB::table('compliance_submissions')->where('vendor_listing_id', $listing->id)->where('status', 'PENDING_ADMIN_REVIEW')->update(['status' => 'SUPERSEDED', 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
        }
        // Leave a published state before withdrawing verification so the regulated gate check always holds.
        if ($regulated && $status !== 'VERIFIED' && in_array($listing->status, ['ACTIVE', 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED', 'PENDING_ADMIN_REVIEW'], true)) {
            $this->transitions->transition($listing, 'PENDING_COMPLIANCE', 'VENDOR', $request->user()->getKey(), $sensitiveChange ? 'COMPLIANCE_SENSITIVE_EDIT' : 'REGULATED_MATERIAL_SELECTED');
        } elseif (! $regulated && in_array($listing->status, ['PENDING_COMPLIANCE', 'PENDING_ADMIN_REVIEW'], true)) {
            $this->transitions->transition($listing, 'DRAFT', 'VENDOR', $request->user()->getKey(), 'REGULATION_NOT_APPLICABLE');
        }
        DB::table('vendor_listings')->where('id', $listing->id)->update(['regulated' => $regulated, 'regulated_material_rule_id' => $rule['id'] ?? null, 'compliance_status' => $status, 'current_compliance_submission_id' => $status === 'NOT_REQUIRED' || $status === 'NOT_SUBMITTED' ? null : $listing->current_compliance_submission_id]);
    }

    /** An edit that would leave a published listing incomplete is rejected rather than silently unpublishing it. */
    private function guardActiveListing(string $listingId): void
    {
        $status = DB::table('vendor_listings')->where('id', $listingId)->value('status');
        if ($status !== 'ACTIVE') {
            return;
        }
        $blockers = $this->readiness->evaluate($listingId)['blockers'];
        if ($blockers !== []) {
            throw new AuthenticationException('LISTING_EDIT_WOULD_UNPUBLISH', 'This change would leave the published listing incomplete. Deactivate it first or keep the required details.', 422, ['blockers' => $blockers]);
        }
    }

    private function complianceFingerprint(?object $product, object $listing): string
    {
        return hash('sha256', json_encode([
            'material_id' => $product?->material_id, 'brand' => MaterialSearch::normalize((string) $product?->brand), 'model' => MaterialSearch::normalize((string) $product?->model),
            'manufacturer' => MaterialSearch::normalize((string) $product?->manufacturer), 'manufacturer_address' => MaterialSearch::normalize((string) $product?->manufacturer_address),
            'country' => $product?->country_of_manufacture, 'rule' => $listing->regulated_material_rule_id,
        ], JSON_THROW_ON_ERROR));
    }

    public function listingFingerprint(string $listingId): string
    {
        $listing = DB::table('vendor_listings')->where('id', $listingId)->first();

        return $this->complianceFingerprint(DB::table('products')->where('id', $listing->product_id)->first(), $listing);
    }

    /**
     * @param  list<array<string, mixed>>  $rows
     * @param  list<string>  $existingIds
     * @return array<string, list<string>>
     */
    private function variantErrors(array $rows, array $existingIds, object $listing): array
    {
        $errors = [];
        if ($rows === []) {
            $errors['variants'] = ['Add at least one variant.'];
        }
        if (count($rows) > self::MAX_VARIANTS) {
            $errors['variants'] = ['A listing can have up to '.self::MAX_VARIANTS.' variants.'];
        }
        $units = DB::table('units')->pluck('id')->all();
        $materialId = DB::table('products')->where('id', $listing->product_id)->value('material_id');
        $compatible = $materialId === null ? [] : DB::table('material_compatible_units')->where('material_id', $materialId)->pluck('unit_id')->all();
        $allowedTax = $this->tax->allowedCategories((string) $listing->vendor_organization_id);
        $skus = [];
        foreach ($rows as $index => $row) {
            $add = static function (string $field, string $message) use (&$errors, $index): void {
                $errors['variants.'.$index.'.'.$field][] = $message;
            };
            if (isset($row['id']) && ! in_array($row['id'], $existingIds, true)) {
                $add('id', 'This variant belongs to another listing or no longer exists. Refresh the listing.');
            }
            $sku = $this->sku((string) ($row['sku'] ?? ''));
            if ($sku === '') {
                $add('sku', 'Enter a variant SKU.');
            } elseif (in_array($sku, $skus, true)) {
                $add('sku', 'Each variant SKU must be unique within the listing.');
            }
            $skus[] = $sku;
            if (! in_array($row['unit_id'] ?? null, $units, true)) {
                $add('unit_id', 'Choose a sale unit.');
            } elseif ($compatible !== [] && ! in_array($row['unit_id'], $compatible, true)) {
                $add('unit_id', 'Choose a unit compatible with the selected material.');
            }
            if (! is_numeric($row['pack_quantity'] ?? null) || bccomp((string) $row['pack_quantity'], '0', 4) <= 0) {
                $add('pack_quantity', 'Enter a pack quantity greater than zero.');
            }
            if (! is_int($row['price_centavos'] ?? null) || $row['price_centavos'] <= 0) {
                $add('price_centavos', 'Enter a price greater than zero.');
            }
            $category = $row['tax_category'] ?? null;
            if (! in_array($category, ListingTaxPolicy::CATEGORIES, true)) {
                $add('tax_category', 'Choose a tax classification.');
            } elseif ($allowedTax !== [] && ! in_array($category, $allowedTax, true)) {
                $add('tax_category', 'This classification is not permitted by your reviewed VAT registration.');
            } elseif (in_array($category, ListingTaxPolicy::BASIS_REQUIRED, true) && mb_strlen(trim((string) ($row['tax_basis'] ?? ''))) < 3) {
                $add('tax_basis', 'Zero-rated and exempt lines need their supporting basis.');
            }
            foreach (['weight_kg', 'length_cm', 'width_cm', 'height_cm'] as $field) {
                if (isset($row[$field]) && (! is_numeric($row[$field]) || (float) $row[$field] <= 0)) {
                    $add($field, 'Enter a value greater than zero.');
                }
            }
            if (isset($row['quantity_on_hand']) && (! is_numeric($row['quantity_on_hand']) || bccomp((string) $row['quantity_on_hand'], '0', 4) < 0 || preg_match('/^\d{1,14}(\.\d{1,4})?$/', (string) $row['quantity_on_hand']) !== 1)) {
                $add('quantity_on_hand', 'Enter a counted quantity of zero or more, with up to four decimals.');
            }
            $ordinary = is_int($row['price_centavos'] ?? null) && $row['price_centavos'] > 0 ? $row['price_centavos'] : null;
            foreach (VolumePricing::errors($this->requestedTiers($row), $ordinary) as $field => $messages) {
                foreach ($messages as $message) {
                    $add($field === 'tiers' ? 'volume_tiers' : 'volume_tiers.'.$field, $message);
                }
            }
        }

        return $errors;
    }

    /**
     * Volume tiers the row asks for. An omitted `volume_tiers` key keeps the variant's current
     * tiers, which must still satisfy the rule against the row's ordinary price.
     *
     * @param  array<string, mixed>  $row
     * @return list<array<string, mixed>>
     */
    private function requestedTiers(array $row): array
    {
        if (array_key_exists('volume_tiers', $row)) {
            return is_array($row['volume_tiers']) ? array_values($row['volume_tiers']) : [];
        }
        if (! isset($row['id'])) {
            return [];
        }

        return array_map(static fn (array $tier): array => ['minimum_quantity' => $tier['minimum_quantity'], 'price_centavos' => $tier['amount_centavos']], $this->currentTiers((string) $row['id']));
    }

    /** @return list<array{price_version_id: string, version: int, minimum_quantity: string, amount_centavos: int, tax_category: string, tax_basis: ?string}> */
    public function currentTiers(string $variantId): array
    {
        return DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->where('price_kind', 'VOLUME_TIER')->whereNull('retired_at')
            ->orderBy('minimum_quantity')->get(['id', 'version', 'minimum_quantity', 'amount_centavos', 'tax_category', 'tax_basis'])
            ->map(static fn (object $tier): array => ['price_version_id' => (string) $tier->id, 'version' => (int) $tier->version, 'minimum_quantity' => VolumePricing::normalizeQuantity((string) $tier->minimum_quantity), 'amount_centavos' => (int) $tier->amount_centavos, 'tax_category' => (string) $tier->tax_category, 'tax_basis' => $tier->tax_basis === null ? null : (string) $tier->tax_basis])
            ->values()->all();
    }

    /**
     * Replaces a variant's volume tiers with new immutable price versions when the tier terms or the
     * ordinary tax terms they inherit change. Retired tiers stay attached to earlier publications.
     *
     * @param  list<array<string, mixed>>  $requested
     */
    private function saveTiers(Request $request, string $variantId, array $requested, string $category, mixed $basis): bool
    {
        $basis = in_array($category, ListingTaxPolicy::BASIS_REQUIRED, true) ? trim((string) $basis) : null;
        $current = DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->where('price_kind', 'VOLUME_TIER')->whereNull('retired_at')->orderBy('id')->lockForUpdate()->get();
        $terms = static fn (string $minimum, int $amount): string => VolumePricing::normalizeQuantity($minimum).'|'.$amount.'|'.$category.'|'.$basis;
        $desired = array_map(static fn (array $tier): string => $terms((string) $tier['minimum_quantity'], (int) $tier['price_centavos']), $requested);
        $existing = $current->map(static fn (object $tier): string => VolumePricing::normalizeQuantity((string) $tier->minimum_quantity).'|'.(int) $tier->amount_centavos.'|'.$tier->tax_category.'|'.$tier->tax_basis)->all();
        sort($desired);
        sort($existing);
        if ($desired === $existing) {
            return false;
        }
        $superseded = [];
        foreach ($current as $tier) {
            DB::table('listing_price_versions')->where('id', $tier->id)->update(['retired_at' => now(), 'updated_at' => now()]);
            $superseded[VolumePricing::normalizeQuantity((string) $tier->minimum_quantity)] = (string) $tier->id;
        }
        $version = (int) DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->max('version');
        foreach ($requested as $tier) {
            $minimum = VolumePricing::normalizeQuantity((string) $tier['minimum_quantity']);
            DB::table('listing_price_versions')->insert(['id' => (string) Str::uuid7(), 'listing_variant_id' => $variantId, 'version' => ++$version, 'amount_centavos' => (int) $tier['price_centavos'], 'currency' => 'PHP', 'tax_category' => $category, 'tax_basis' => $basis, 'price_kind' => 'VOLUME_TIER', 'minimum_quantity' => $minimum, 'effective_at' => now(), 'created_by_user_id' => $request->user()->getKey(), 'supersedes_price_version_id' => $superseded[$minimum] ?? null, 'created_at' => now(), 'updated_at' => now()]);
        }

        return true;
    }

    /** Creates a new immutable ordinary price version only when the price terms change. */
    private function savePrice(Request $request, string $variantId, int $amount, string $category, mixed $basis): bool
    {
        $basis = in_array($category, ListingTaxPolicy::BASIS_REQUIRED, true) ? trim((string) $basis) : null;
        $current = DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->where('price_kind', 'ORDINARY')->whereNull('retired_at')->lockForUpdate()->first();
        if ($current !== null && (int) $current->amount_centavos === $amount && $current->tax_category === $category && $current->tax_basis === $basis) {
            return false;
        }
        if ($current !== null) {
            DB::table('listing_price_versions')->where('id', $current->id)->update(['retired_at' => now(), 'updated_at' => now()]);
        }
        $version = (int) DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->max('version') + 1;
        DB::table('listing_price_versions')->insert(['id' => (string) Str::uuid7(), 'listing_variant_id' => $variantId, 'version' => $version, 'amount_centavos' => $amount, 'currency' => 'PHP', 'tax_category' => $category, 'tax_basis' => $basis, 'price_kind' => 'ORDINARY', 'effective_at' => now(), 'created_by_user_id' => $request->user()->getKey(), 'supersedes_price_version_id' => $current?->id, 'created_at' => now(), 'updated_at' => now()]);

        return true;
    }

    /** Records a counted stock quantity. Physical quantity never falls below hard reservations. */
    private function recordStockCount(Request $request, string $variantId, string $quantity): void
    {
        $item = DB::table('inventory_items')->where('listing_variant_id', $variantId)->lockForUpdate()->first();
        if ($item === null) {
            $itemId = (string) Str::uuid7();
            DB::table('inventory_items')->insert(['id' => $itemId, 'listing_variant_id' => $variantId, 'quantity_on_hand' => $quantity, 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            $delta = $quantity;
            $type = 'INITIAL_COUNT';
        } else {
            $itemId = (string) $item->id;
            if (bccomp($quantity, (string) $item->hard_reserved_quantity, 4) < 0) {
                throw new AuthenticationException('STOCK_BELOW_RESERVED', 'The counted quantity cannot be lower than stock already reserved for confirmed orders.', 422);
            }
            $delta = bcsub($quantity, (string) $item->quantity_on_hand, 4);
            $type = 'COUNT_ADJUSTMENT';
            DB::table('inventory_items')->where('id', $itemId)->update(['quantity_on_hand' => $quantity, 'confirmed_at' => now(), 'lock_version' => DB::raw('lock_version + 1'), 'updated_at' => now()]);
        }
        if (bccomp($delta, '0', 4) !== 0) {
            DB::table('inventory_movements')->insert(['id' => (string) Str::uuid7(), 'inventory_item_id' => $itemId, 'movement_type' => $type, 'quantity' => $delta, 'quantity_on_hand_after' => $quantity, 'actor_user_id' => $request->user()->getKey(), 'source_type' => 'CATALOG_LISTING', 'source_id' => $variantId, 'created_at' => now(), 'updated_at' => now()]);
        }
        DB::table('stock_confirmation_events')->insert(['id' => (string) Str::uuid7(), 'inventory_item_id' => $itemId, 'actor_user_id' => $request->user()->getKey(), 'confirmed_quantity' => $quantity, 'confirmed_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
    }

    /**
     * @param  array<string, mixed>|mixed  $values
     * @return array<string, string>
     */
    private function attributes(mixed $values, ?string $categoryId): array
    {
        if (! is_array($values)) {
            return [];
        }
        $definitions = $categoryId === null ? collect() : DB::table('technical_attribute_definitions')->where('material_category_id', $categoryId)->get(['code', 'label', 'value_type', 'allowed_values'])->keyBy('code');
        $clean = [];
        foreach ($values as $code => $value) {
            if ($value === null || trim((string) $value) === '') {
                continue;
            }
            $definition = $definitions[$code] ?? null;
            if ($definition === null) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['technical_attributes.'.$code => ['This attribute does not apply to the selected category.']]);
            }
            $value = Str::limit(trim((string) $value), 120, '');
            $allowed = $definition->allowed_values === null ? null : ComparableMappingService::decode($definition->allowed_values);
            if (($definition->value_type === 'NUMBER' && (! is_numeric($value) || (float) $value <= 0)) || ($allowed !== null && ! in_array($value, $allowed, true))) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Review the highlighted fields and try again.', 422, ['technical_attributes.'.$code => [$definition->label.' has an invalid value.']]);
            }
            $clean[(string) $code] = $value;
        }
        ksort($clean);

        return $clean;
    }

    private function assertNotRental(string $label, string $field): void
    {
        if ($this->rental->describesRental($label)) {
            throw new AuthenticationException('CATALOG_RENTAL_UNSUPPORTED', RentalServicePolicy::MESSAGE, 422, [$field => [RentalServicePolicy::MESSAGE]]);
        }
    }

    private function assertVersion(object $listing, mixed $version): void
    {
        if (! is_numeric($version) || (int) $version !== (int) $listing->lock_version) {
            throw new AuthenticationException('RESOURCE_VERSION_CONFLICT', 'This listing changed in another session. Reload the latest version before saving again.', 409, ['current_lock_version' => (int) $listing->lock_version]);
        }
    }

    private function sku(string $value): string
    {
        return Str::limit(strtoupper(trim((string) preg_replace('/\s+/', '-', $value))), 96, '');
    }

    private function maxImageKb(): int
    {
        return (int) config('materyalph.catalog.max_listing_image_kb', 5120);
    }
}
