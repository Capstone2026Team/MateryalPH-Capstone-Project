<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * MAT-03 comparability. A listing variant joins a comparable group only on an
 * exact controlled key: canonical material, exact brand/model, every controlled
 * specification and an identity or approved versioned unit conversion. Fuzzy
 * names, different grades/diameters/brands or unconverted pack units never merge.
 * Unmapped variants stay purchasable and are reported as Not Yet Comparable.
 */
final class ComparableMappingService
{
    public const MAPPING_RULE = 'mat03.exact-key.v1';

    public const IDENTITY_CONVERSION = 'IDENTITY';

    /**
     * SQL form of normalizedPrice() over the aliases added by joinComparable() and a price alias pv: PHP per
     * canonical unit, rounded half-up to eight decimals (round() on positive NUMERIC), NULL when the variant is
     * unmapped or has neither an identity unit nor an approved conversion for the stated version.
     */
    public const NORMALIZED_PRICE_SQL = "CASE WHEN ca.id IS NULL OR v.pack_quantity <= 0 THEN NULL WHEN v.unit_id = gv.canonical_unit_id THEN round((pv.amount_centavos::numeric / 100) / v.pack_quantity, 8) WHEN uc.multiplier IS NOT NULL AND gv.conversion_version <> 'IDENTITY' THEN round((pv.amount_centavos::numeric / 100) / (v.pack_quantity * uc.multiplier), 8) ELSE NULL END";

    /**
     * Left-joins a variant query (alias v) to its current approved MAT-03 assignment (ca), group version (gv),
     * group (cg), canonical unit (cu) and approved conversion (uc) for NORMALIZED_PRICE_SQL.
     */
    public static function joinComparable(Builder $query): Builder
    {
        return $query
            ->leftJoin('listing_comparable_assignments as ca', fn ($join) => $join->on('ca.listing_variant_id', '=', 'v.id')->whereNull('ca.effective_until')->where('ca.mapping_state', 'APPROVED'))
            ->leftJoin('material_comparable_group_versions as gv', 'gv.id', '=', 'ca.material_comparable_group_version_id')
            ->leftJoin('material_comparable_groups as cg', 'cg.id', '=', 'gv.material_comparable_group_id')
            ->leftJoin('units as cu', 'cu.id', '=', 'gv.canonical_unit_id')
            ->leftJoin('unit_conversions as uc', fn ($join) => $join->on('uc.material_id', '=', 'cg.material_id')->on('uc.from_unit_id', '=', 'v.unit_id')
                ->on('uc.to_unit_id', '=', 'gv.canonical_unit_id')->whereRaw('uc.version::text = gv.conversion_version')->whereNotNull('uc.approved_by_user_id'));
    }

    /**
     * @param  array<string, mixed>  $specification
     * @param  list<string>  $keys
     * @return array<string, string>
     */
    public static function controlledSpecification(array $specification, array $keys): array
    {
        $controlled = [];
        foreach ($keys as $key) {
            $value = $specification[$key] ?? null;
            if (is_string($value) || is_int($value) || is_float($value)) {
                $controlled[$key] = MaterialSearch::normalize((string) $value);
            }
        }
        ksort($controlled);

        return $controlled;
    }

    /** @param array<string, string> $controlled */
    public static function variantKey(?string $brand, ?string $model, array $controlled): string
    {
        return hash('sha256', json_encode([
            'brand' => MaterialSearch::normalize((string) $brand),
            'model' => MaterialSearch::normalize((string) $model),
            'specification' => $controlled,
        ], JSON_THROW_ON_ERROR));
    }

    /** @return list<string> */
    public function comparabilityKeys(?string $categoryId): array
    {
        if ($categoryId === null) {
            return [];
        }

        return DB::table('technical_attribute_definitions')->where('material_category_id', $categoryId)->where('comparability_key', true)->orderBy('code')->pluck('code')->all();
    }

    /**
     * Recomputes the effective assignment for one variant inside the caller's transaction.
     *
     * @return array{status: string, group_version_id: ?string, assignment_id: ?string}
     */
    public function assign(string $variantId): array
    {
        $variant = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->join('products as p', 'p.id', '=', 'l.product_id')
            ->where('v.id', $variantId)->first(['v.id', 'v.unit_id', 'v.attributes', 'v.active', 'l.technical_attributes', 'l.material_category_id', 'p.material_id', 'p.brand', 'p.model']);
        $candidate = $variant === null || ! $variant->active || $variant->material_id === null ? null : $this->matchingGroupVersion($variant);
        $current = DB::table('listing_comparable_assignments')->where('listing_variant_id', $variantId)->whereNull('effective_until')->where('mapping_state', 'APPROVED')->first();
        if ($current !== null && $candidate !== null && $current->material_comparable_group_version_id === $candidate) {
            return ['status' => 'COMPARABLE', 'group_version_id' => $candidate, 'assignment_id' => (string) $current->id];
        }
        if ($current !== null) {
            DB::table('listing_comparable_assignments')->where('id', $current->id)->update(['mapping_state' => 'RETIRED', 'effective_until' => DB::raw("GREATEST(clock_timestamp(), effective_from + interval '1 millisecond')"), 'updated_at' => now()]);
        }
        if ($candidate === null) {
            return ['status' => 'NOT_YET_COMPARABLE', 'group_version_id' => null, 'assignment_id' => null];
        }
        $existing = DB::table('listing_comparable_assignments')->where('listing_variant_id', $variantId)->where('material_comparable_group_version_id', $candidate)->first();
        if ($existing !== null) {
            DB::table('listing_comparable_assignments')->where('id', $existing->id)->update(['mapping_state' => 'APPROVED', 'effective_from' => now(), 'effective_until' => null, 'review_reason' => self::MAPPING_RULE, 'updated_at' => now()]);

            return ['status' => 'COMPARABLE', 'group_version_id' => $candidate, 'assignment_id' => (string) $existing->id];
        }
        $id = (string) Str::uuid7();
        DB::table('listing_comparable_assignments')->insert(['id' => $id, 'listing_variant_id' => $variantId, 'material_comparable_group_version_id' => $candidate, 'mapping_state' => 'APPROVED', 'review_reason' => self::MAPPING_RULE, 'effective_from' => now(), 'created_at' => now(), 'updated_at' => now()]);

        return ['status' => 'COMPARABLE', 'group_version_id' => $candidate, 'assignment_id' => $id];
    }

    /**
     * MAT-03 normalized ordinary public price per canonical unit, NUMERIC(20,8) as a decimal string.
     * Returns null when no identity or approved conversion exists for the stated conversion version.
     */
    public function normalizedPrice(int $amountCentavos, string $packQuantity, string $variantUnitId, string $groupVersionId): ?string
    {
        $group = DB::table('material_comparable_group_versions as v')->join('material_comparable_groups as g', 'g.id', '=', 'v.material_comparable_group_id')
            ->where('v.id', $groupVersionId)->first(['g.material_id', 'v.canonical_unit_id', 'v.conversion_version']);
        if ($group === null || bccomp($packQuantity, '0', 8) <= 0) {
            return null;
        }
        $multiplier = $this->conversionMultiplier((string) $group->material_id, $variantUnitId, (string) $group->canonical_unit_id, (string) $group->conversion_version);
        if ($multiplier === null) {
            return null;
        }
        $canonicalQuantity = bcmul($packQuantity, $multiplier, 12);

        return self::roundHalfUp(bcdiv(bcdiv((string) $amountCentavos, '100', 12), $canonicalQuantity, 12), 8);
    }

    /**
     * The current ordinary single-sale public price of a variant. Promotions, volume tiers
     * and negotiated amounts are never an analytics source (MAT-03).
     */
    public function ordinaryPublicPrice(string $variantId): ?object
    {
        return DB::table('listing_price_versions')->where('listing_variant_id', $variantId)->where('price_kind', 'ORDINARY')
            ->whereNull('retired_at')->where('effective_at', '<=', now())->orderByDesc('version')->first();
    }

    /**
     * Admin-authored comparable group version. Creation by an authorized taxonomy manager is its review.
     *
     * @param  array{material_id: string, code: string, display_name: string, brand?: ?string, model?: ?string, specification: array<string, mixed>, canonical_unit_id: string, conversion_version?: ?string}  $input
     * @return array{group_id: string, group_version_id: string, mapped_variants: int}
     */
    public function createGroup(array $input, int $reviewerId): array
    {
        $material = DB::table('materials')->where('id', $input['material_id'])->where('active', true)->first(['id', 'material_category_id']);
        if ($material === null) {
            throw new AuthenticationException('MATERIAL_UNAVAILABLE', 'Choose an active canonical material.', 422);
        }
        $keys = $this->comparabilityKeys((string) $material->material_category_id);
        $controlled = self::controlledSpecification($input['specification'], $keys);
        if (count($controlled) !== count($keys)) {
            throw new AuthenticationException('COMPARABLE_SPECIFICATION_INCOMPLETE', 'Every controlled specification for this category is required to define a comparable group.', 422, ['missing' => array_values(array_diff($keys, array_keys($controlled)))]);
        }
        $conversion = $input['conversion_version'] ?? self::IDENTITY_CONVERSION;
        if ($conversion !== self::IDENTITY_CONVERSION && ! DB::table('unit_conversions')->where('material_id', $material->id)->where('to_unit_id', $input['canonical_unit_id'])->where('version', (int) $conversion)->whereNotNull('approved_by_user_id')->exists()) {
            throw new AuthenticationException('UNIT_CONVERSION_UNAPPROVED', 'Use an approved material-specific unit conversion version.', 422);
        }
        $variantKey = self::variantKey($input['brand'] ?? null, $input['model'] ?? null, $controlled);

        return DB::transaction(function () use ($input, $material, $controlled, $conversion, $variantKey, $reviewerId): array {
            $groupId = (string) Str::uuid7();
            $versionId = (string) Str::uuid7();
            DB::table('material_comparable_groups')->insert(['id' => $groupId, 'material_id' => $material->id, 'code' => $input['code'], 'display_name' => $input['display_name'], 'status' => 'ACTIVE', 'created_at' => now(), 'updated_at' => now()]);
            DB::table('material_comparable_group_versions')->insert([
                'id' => $versionId, 'material_comparable_group_id' => $groupId, 'version' => 1, 'brand' => $input['brand'] ?? null, 'model' => $input['model'] ?? null,
                'controlled_specification' => json_encode($controlled, JSON_THROW_ON_ERROR), 'variant_key' => $variantKey, 'canonical_unit_id' => $input['canonical_unit_id'],
                'conversion_version' => $conversion, 'review_state' => 'APPROVED', 'reviewed_by_user_id' => $reviewerId, 'reviewed_at' => now(), 'effective_from' => now(),
                'content_hash' => hash('sha256', $variantKey.'|'.$input['canonical_unit_id'].'|'.$conversion), 'created_at' => now(), 'updated_at' => now(),
            ]);
            DB::table('material_comparable_groups')->where('id', $groupId)->update(['current_version_id' => $versionId]);
            $mapped = 0;
            $variants = DB::table('listing_variants as v')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')->join('products as p', 'p.id', '=', 'l.product_id')
                ->where('p.material_id', $material->id)->where('v.active', true)->orderBy('v.id')->pluck('v.id');
            foreach ($variants as $variantId) {
                $mapped += $this->assign((string) $variantId)['group_version_id'] === $versionId ? 1 : 0;
            }

            return ['group_id' => $groupId, 'group_version_id' => $versionId, 'mapped_variants' => $mapped];
        });
    }

    private function matchingGroupVersion(object $variant): ?string
    {
        $specification = array_merge(self::decode($variant->technical_attributes), self::decode($variant->attributes));
        $keys = $this->comparabilityKeys($variant->material_category_id === null ? null : (string) $variant->material_category_id);
        $controlled = self::controlledSpecification($specification, $keys);
        if (count($controlled) !== count($keys)) {
            return null;
        }
        $key = self::variantKey($variant->brand, $variant->model, $controlled);
        $versions = DB::table('material_comparable_group_versions as v')->join('material_comparable_groups as g', 'g.id', '=', 'v.material_comparable_group_id')
            ->where('g.material_id', $variant->material_id)->where('g.status', 'ACTIVE')->where('v.review_state', 'APPROVED')->whereNull('v.effective_until')
            ->where('v.variant_key', $key)->orderBy('v.id')->get(['v.id', 'v.canonical_unit_id', 'v.conversion_version']);
        foreach ($versions as $version) {
            if ($this->conversionMultiplier((string) $variant->material_id, (string) $variant->unit_id, (string) $version->canonical_unit_id, (string) $version->conversion_version) !== null) {
                return (string) $version->id;
            }
        }

        return null;
    }

    private function conversionMultiplier(string $materialId, string $fromUnitId, string $toUnitId, string $conversionVersion): ?string
    {
        if ($fromUnitId === $toUnitId) {
            return '1';
        }
        if ($conversionVersion === self::IDENTITY_CONVERSION || ! ctype_digit($conversionVersion)) {
            return null;
        }
        $multiplier = DB::table('unit_conversions')->where('material_id', $materialId)->where('from_unit_id', $fromUnitId)->where('to_unit_id', $toUnitId)
            ->where('version', (int) $conversionVersion)->whereNotNull('approved_by_user_id')->value('multiplier');

        return $multiplier === null ? null : (string) $multiplier;
    }

    public static function roundHalfUp(string $value, int $scale): string
    {
        $offset = '0.'.str_repeat('0', $scale).'5';

        return bcadd($value, str_starts_with($value, '-') ? '-'.$offset : $offset, $scale);
    }

    /** @return array<string, mixed> */
    public static function decode(mixed $value): array
    {
        if (is_array($value)) {
            return $value;
        }
        $decoded = is_string($value) ? json_decode($value, true) : null;

        return is_array($decoded) ? $decoded : [];
    }
}
