<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use Illuminate\Support\Facades\DB;

/**
 * One evaluator derives the wizard's step completion and the publication
 * blockers from saved data. The browser never submits completion as truth.
 */
final class ListingReadiness
{
    public const REGULATED_SUGGESTION_THRESHOLD = 0.6;

    public const STEPS = [
        'material_classification' => 'Material and classification',
        'product_details' => 'Product details',
        'variants_pricing' => 'Variants, pricing and stock',
        'media' => 'Product photos',
        'product_compliance' => 'PS/ICC compliance',
        'review_publish' => 'Review and publish',
    ];

    public function __construct(private readonly ListingTaxPolicy $tax, private readonly MaterialSearch $search) {}

    /**
     * @return array{steps: list<array{key: string, label: string, level: string, status: string, reason: ?string}>, blockers: list<array{key: string, step: string, reason: string}>}
     */
    public function evaluate(string $listingId): array
    {
        $listing = DB::table('vendor_listings as l')->join('products as p', 'p.id', '=', 'l.product_id')->where('l.id', $listingId)
            ->first(['l.*', 'p.material_id', 'p.brand', 'p.manufacturer', 'p.manufacturer_address', 'p.country_of_manufacture', 'p.model']);
        $blockers = [];
        $block = static function (string $step, string $key, string $reason) use (&$blockers): void {
            $blockers[] = ['key' => $key, 'step' => $step, 'reason' => $reason];
        };

        $tagCount = DB::table('listing_tag_links')->where('vendor_listing_id', $listingId)->count();
        if ($listing->material_category_id === null) {
            $block('material_classification', 'material_category_id', 'Choose the material category.');
        }
        if ($listing->material_id === null && $listing->other_label === null) {
            $block('material_classification', 'material', 'Select a canonical material or describe the product with an Other label.');
        }
        if ($tagCount < 1 || $tagCount > 3) {
            $block('material_classification', 'tag_ids', 'Choose one to three search tags.');
        }
        if ($listing->material_id === null) {
            $regulatedSuggestion = collect($this->search->search((string) $listing->display_name))
                ->first(fn (array $row): bool => $row['regulated'] && $row['similarity'] >= self::REGULATED_SUGGESTION_THRESHOLD);
            if ($regulatedSuggestion !== null) {
                $block('material_classification', 'material', 'This product name closely matches the regulated material “'.$regulatedSuggestion['name'].'”. Select it, or rename the listing if it is a different product.');
            }
        }

        foreach (['display_name' => 'Enter the display name.', 'vendor_sku' => 'Enter the Vendor SKU.', 'description' => 'Enter a product description.'] as $field => $reason) {
            if (trim((string) $listing->{$field}) === '') {
                $block('product_details', $field, $reason);
            }
        }
        if ($listing->regulated) {
            foreach (['brand' => 'Enter the brand name.', 'manufacturer' => 'Enter the manufacturer name.', 'manufacturer_address' => 'Enter the manufacturer address.', 'country_of_manufacture' => 'Choose the country of manufacture.'] as $field => $reason) {
                if (trim((string) $listing->{$field}) === '') {
                    $block('product_details', $field, $reason);
                }
            }
        }
        $listingAttributes = ComparableMappingService::decode($listing->technical_attributes);
        $required = $listing->material_category_id === null ? collect() : DB::table('technical_attribute_definitions')->where('material_category_id', $listing->material_category_id)->where('required', true)->get(['code', 'label']);

        $variants = DB::table('listing_variants as v')->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')->where('v.vendor_listing_id', $listingId)->where('v.active', true)->orderBy('v.sort_order')->get(['v.*', 'i.id as inventory_id']);
        $allowedTax = $this->tax->allowedCategories((string) $listing->vendor_organization_id);
        $compatible = $listing->material_id === null ? null : DB::table('material_compatible_units')->where('material_id', $listing->material_id)->pluck('unit_id')->all();
        if ($variants->isEmpty()) {
            $block('variants_pricing', 'variants', 'Add at least one variant with a unit, price and stock count.');
        }
        foreach ($variants as $index => $variant) {
            $row = 'variants.'.$index;
            $attributes = array_merge($listingAttributes, ComparableMappingService::decode($variant->attributes));
            foreach ($required as $definition) {
                if (! isset($attributes[$definition->code]) || trim((string) $attributes[$definition->code]) === '') {
                    $block('product_details', 'technical_attributes.'.$definition->code, $definition->label.' is required for '.($variant->label ?: $variant->sku).'.');
                }
            }
            if ($compatible !== null && $compatible !== [] && ! in_array($variant->unit_id, $compatible, true)) {
                $block('variants_pricing', $row.'.unit_id', 'Choose a unit compatible with the selected material.');
            }
            if ($variant->weight_kg === null || $variant->length_cm === null || $variant->width_cm === null || $variant->height_cm === null) {
                $block('variants_pricing', $row.'.weight_kg', 'Enter the weight and dimensions of '.($variant->label ?: $variant->sku).'.');
            }
            $price = DB::table('listing_price_versions')->where('listing_variant_id', $variant->id)->where('price_kind', 'ORDINARY')->whereNull('retired_at')->first(['tax_category']);
            if ($price === null) {
                $block('variants_pricing', $row.'.price_centavos', 'Enter the ordinary public price of '.($variant->label ?: $variant->sku).'.');
            } elseif ($allowedTax === []) {
                $block('variants_pricing', $row.'.tax_category', 'Your reviewed VAT classification is not available, so payable prices cannot be published yet.');
            } elseif (! in_array($price->tax_category, $allowedTax, true)) {
                $block('variants_pricing', $row.'.tax_category', 'Choose a tax classification permitted by your reviewed VAT registration.');
            }
            if ($variant->inventory_id === null) {
                $block('variants_pricing', $row.'.quantity_on_hand', 'Record the counted stock of '.($variant->label ?: $variant->sku).'.');
            }
        }
        $readyMedia = DB::table('listing_media as m')->join('files as f', 'f.id', '=', 'm.file_id')->where('m.vendor_listing_id', $listingId)->where('m.status', 'READY')->where('f.scan_state', 'CLEAN')->count();
        if ($readyMedia < 1) {
            $block('media', 'media', 'Upload at least one product photo that passed the safety check.');
        }

        $stepStatus = function (string $step, bool $touched) use ($blockers): string {
            if (collect($blockers)->contains('step', $step)) {
                return $touched ? 'IN_PROGRESS' : 'NOT_STARTED';
            }

            return 'COMPLETED';
        };
        $steps = [
            ['key' => 'material_classification', 'status' => $stepStatus('material_classification', $listing->material_category_id !== null || $tagCount > 0)],
            ['key' => 'product_details', 'status' => $stepStatus('product_details', trim((string) $listing->display_name) !== '')],
            ['key' => 'variants_pricing', 'status' => $stepStatus('variants_pricing', $variants->isNotEmpty())],
            ['key' => 'media', 'status' => $stepStatus('media', false)],
            ['key' => 'product_compliance', 'status' => $listing->regulated ? match ($listing->compliance_status) {
                'VERIFIED' => 'APPROVED', 'PENDING_ADMIN_REVIEW' => 'PENDING_VERIFICATION', 'CHANGES_REQUIRED' => 'CHANGES_REQUIRED', 'REJECTED' => 'REJECTED', default => 'NOT_STARTED',
            } : 'NOT_APPLICABLE'],
            ['key' => 'review_publish', 'status' => $listing->status === 'ACTIVE' ? 'COMPLETED' : ($blockers === [] ? 'IN_PROGRESS' : 'NOT_STARTED')],
        ];
        $reasons = collect($blockers)->groupBy('step')->map(fn ($items): string => (string) $items->first()['reason']);

        return [
            'steps' => array_map(fn (array $step): array => [
                'key' => $step['key'], 'label' => self::STEPS[$step['key']],
                'level' => $step['key'] === 'product_compliance' ? 'CONDITIONALLY_REQUIRED' : 'REQUIRED',
                'status' => $step['status'],
                'reason' => $step['key'] === 'product_compliance' && ! $listing->regulated ? 'This material is not on the DTI-BPS regulated list.' : ($reasons[$step['key']] ?? null),
            ], $steps),
            'blockers' => $blockers,
        ];
    }
}
