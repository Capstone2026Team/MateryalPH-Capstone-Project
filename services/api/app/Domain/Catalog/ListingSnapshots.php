<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Immutable publication snapshots. Each records the exact price, tax, mapping,
 * compliance and canonical public-identity versions a publication exposed, so a
 * later quotation or accepted order can reference them without re-reading
 * mutable listing rows.
 */
final class ListingSnapshots
{
    public function __construct(private readonly ComparableMappingService $comparability) {}

    public function record(string $listingId, int $publicationVersion, ?int $actorId): string
    {
        $snapshot = $this->build($listingId);
        $json = json_encode($snapshot, JSON_THROW_ON_ERROR);
        $id = (string) Str::uuid7();
        DB::table('listing_publication_snapshots')->insert(['id' => $id, 'vendor_listing_id' => $listingId, 'publication_version' => $publicationVersion, 'snapshot' => $json, 'content_hash' => hash('sha256', $json), 'created_by_user_id' => $actorId, 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }

    /** @return array<string, mixed> */
    public function build(string $listingId): array
    {
        $listing = DB::table('vendor_listings as l')->join('products as p', 'p.id', '=', 'l.product_id')->leftJoin('store_profiles as s', 's.vendor_organization_id', '=', 'l.vendor_organization_id')
            ->leftJoin('regulated_material_rules as r', 'r.id', '=', 'l.regulated_material_rule_id')
            ->where('l.id', $listingId)
            ->first(['l.id', 'l.vendor_organization_id', 'l.display_name', 'l.vendor_sku', 'l.material_category_id', 'l.other_label', 'l.regulated', 'l.compliance_status', 'l.current_compliance_submission_id', 'l.technical_attributes', 'p.material_id', 'p.brand', 'p.model', 'p.manufacturer', 'p.country_of_manufacture', 's.public_store_name', 'r.id as rule_id', 'r.version as rule_version', 'r.required_marking']);
        $variants = DB::table('listing_variants as v')->join('units as u', 'u.id', '=', 'v.unit_id')->where('v.vendor_listing_id', $listingId)->where('v.active', true)->orderBy('v.sort_order')->orderBy('v.id')
            ->get(['v.id', 'v.sku', 'v.label', 'v.unit_id', 'u.code as unit_code', 'v.pack_quantity', 'v.attributes', 'v.weight_kg', 'v.length_cm', 'v.width_cm', 'v.height_cm']);
        $reviewId = $listing?->current_compliance_submission_id === null ? null
            : DB::table('compliance_reviews')->where('compliance_submission_id', $listing->current_compliance_submission_id)->orderByDesc('created_at')->orderByDesc('id')->value('id');

        return [
            'listing_id' => $listingId,
            'captured_at' => now()->toIso8601String(),
            'store' => ['vendor_organization_id' => $listing?->vendor_organization_id, 'public_store_name' => $listing?->public_store_name],
            'display_name' => $listing?->display_name,
            'vendor_sku' => $listing?->vendor_sku,
            'material_id' => $listing?->material_id,
            'material_category_id' => $listing?->material_category_id,
            'other_label' => $listing?->other_label,
            'product' => ['brand' => $listing?->brand, 'model' => $listing?->model, 'manufacturer' => $listing?->manufacturer, 'country_of_manufacture' => $listing?->country_of_manufacture],
            'technical_attributes' => ComparableMappingService::decode($listing?->technical_attributes),
            'tags' => DB::table('listing_tag_links as t')->join('material_tags as m', 'm.id', '=', 't.material_tag_id')->where('t.vendor_listing_id', $listingId)->orderBy('m.code')->pluck('m.code')->all(),
            'compliance' => ['regulated' => (bool) $listing?->regulated, 'status' => $listing?->compliance_status, 'rule_id' => $listing?->rule_id, 'rule_version' => $listing?->rule_version, 'required_marking' => $listing?->required_marking, 'submission_id' => $listing?->current_compliance_submission_id, 'review_id' => $reviewId],
            'media_file_ids' => DB::table('listing_media')->where('vendor_listing_id', $listingId)->where('status', 'READY')->orderBy('sort_order')->orderBy('id')->pluck('file_id')->all(),
            'variants' => array_map(fn (object $variant): array => $this->variant($variant), $variants->all()),
        ];
    }

    /**
     * Price, tax and comparable-mapping source versions of one sellable variant.
     *
     * @return array<string, mixed>
     */
    private function variant(object $variant): array
    {
        $price = $this->comparability->ordinaryPublicPrice((string) $variant->id);
        $assignment = DB::table('listing_comparable_assignments')->where('listing_variant_id', $variant->id)->whereNull('effective_until')->where('mapping_state', 'APPROVED')->first(['id', 'material_comparable_group_version_id']);
        $normalized = $price === null || $assignment === null ? null : $this->comparability->normalizedPrice((int) $price->amount_centavos, (string) $variant->pack_quantity, (string) $variant->unit_id, (string) $assignment->material_comparable_group_version_id);

        return [
            'variant_id' => $variant->id, 'sku' => $variant->sku, 'label' => $variant->label, 'unit_code' => $variant->unit_code, 'pack_quantity' => (string) $variant->pack_quantity,
            'attributes' => ComparableMappingService::decode($variant->attributes),
            'weight_kg' => $variant->weight_kg === null ? null : (string) $variant->weight_kg,
            'dimensions_cm' => [$variant->length_cm === null ? null : (string) $variant->length_cm, $variant->width_cm === null ? null : (string) $variant->width_cm, $variant->height_cm === null ? null : (string) $variant->height_cm],
            'price' => $price === null ? null : ['price_version_id' => $price->id, 'version' => (int) $price->version, 'amount_centavos' => (int) $price->amount_centavos, 'currency' => $price->currency, 'tax_category' => $price->tax_category, 'tax_basis' => $price->tax_basis, 'included_vat_centavos' => ListingTaxPolicy::includedVatCentavos((int) $price->amount_centavos, (string) $price->tax_category), 'effective_at' => (string) $price->effective_at],
            'volume_tiers' => DB::table('listing_price_versions')->where('listing_variant_id', $variant->id)->where('price_kind', 'VOLUME_TIER')->whereNull('retired_at')->orderBy('minimum_quantity')
                ->get(['id', 'version', 'minimum_quantity', 'amount_centavos', 'tax_category'])
                ->map(static fn (object $tier): array => ['price_version_id' => $tier->id, 'version' => (int) $tier->version, 'minimum_quantity' => VolumePricing::normalizeQuantity((string) $tier->minimum_quantity), 'amount_centavos' => (int) $tier->amount_centavos, 'included_vat_centavos' => ListingTaxPolicy::includedVatCentavos((int) $tier->amount_centavos, (string) $tier->tax_category)])->all(),
            'comparability' => $assignment === null
                ? ['status' => 'NOT_YET_COMPARABLE', 'assignment_id' => null, 'group_version_id' => null, 'normalized_php_price' => null]
                : ['status' => 'COMPARABLE', 'assignment_id' => $assignment->id, 'group_version_id' => $assignment->material_comparable_group_version_id, 'normalized_php_price' => $normalized, 'mapping_rule' => ComparableMappingService::MAPPING_RULE],
        ];
    }
}
