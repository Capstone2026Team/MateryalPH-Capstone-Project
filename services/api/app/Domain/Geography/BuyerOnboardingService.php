<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Optional Buyer profile onboarding. Required account information stays complete when onboarding is skipped;
 * company fields stay optional for independent and DIY builders. The industry list (with Other) was
 * approved by the project owner on 2026-09-28. Saved addresses and project sites use saved locations.
 */
final class BuyerOnboardingService
{
    public const INDUSTRIES = ['GENERAL_CONTRACTOR', 'SUBCONTRACTOR_TRADE', 'INDEPENDENT_BUILDER', 'DIY_HOMEOWNER', 'OTHER'];

    public function __construct(private readonly BuyerProfiles $profiles, private readonly AuditRecorder $audit) {}

    /** @return array<string, mixed> */
    public function snapshot(Request $request): array
    {
        $buyerId = $this->profiles->idFor($request);
        $profile = DB::table('buyer_profiles')->where('id', $buyerId)->first();

        return [
            'status' => $profile->onboarding_status,
            'completed_at' => $profile->onboarding_completed_at === null ? null : Carbon::parse((string) $profile->onboarding_completed_at)->toIso8601String(),
            'buyer_type' => $profile->buyer_type,
            'company_name' => $profile->company_name,
            'position_title' => $profile->position_title,
            'industry_classification' => $profile->industry_classification,
            'industry_other_label' => $profile->industry_other_label,
            'preferred_category_ids' => DB::table('buyer_preferred_categories')->where('buyer_profile_id', $buyerId)->orderBy('material_category_id')->pluck('material_category_id')->map(static fn (mixed $id): string => (string) $id)->all(),
            'discovery_radius_km' => (int) $profile->discovery_radius_km,
            'has_primary_location' => DB::table('buyer_locations')->where('buyer_profile_id', $buyerId)->where('is_primary', true)->whereNull('archived_at')->exists(),
            'lock_version' => (int) $profile->lock_version,
            'categories' => DB::table('material_categories')->where('active', true)->orderBy('sort_order')->orderBy('name')->get(['id', 'code', 'name'])
                ->map(static fn (object $category): array => ['id' => (string) $category->id, 'code' => $category->code, 'name' => $category->name])->all(),
            'industries' => self::INDUSTRIES,
        ];
    }

    /**
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function save(Request $request, array $input): array
    {
        $buyerId = $this->profiles->idFor($request);
        DB::transaction(function () use ($request, $buyerId, $input): void {
            $profile = DB::table('buyer_profiles')->where('id', $buyerId)->lockForUpdate()->first();
            if ((int) $profile->lock_version !== (int) $input['lock_version']) {
                throw new AuthenticationException('ONBOARDING_VERSION_CONFLICT', 'Your profile changed on another device. Reload and try again.', 409, ['current_lock_version' => (int) $profile->lock_version]);
            }
            $action = (string) $input['action'];
            $update = ['lock_version' => (int) $profile->lock_version + 1, 'updated_at' => now()];
            if ($action !== 'SKIP') {
                foreach (['company_name' => 180, 'position_title' => 80] as $field => $max) {
                    if (array_key_exists($field, $input)) {
                        $value = is_string($input[$field]) ? trim($input[$field]) : '';
                        $update[$field] = $value === '' ? null : mb_substr($value, 0, $max);
                    }
                }
                if (array_key_exists('industry_classification', $input)) {
                    $industry = $input['industry_classification'];
                    $other = is_string($input['industry_other_label'] ?? null) ? trim($input['industry_other_label']) : '';
                    if ($industry === 'OTHER' && mb_strlen($other) < 2) {
                        throw new AuthenticationException('INDUSTRY_OTHER_REQUIRED', 'Describe your industry when you choose Other.', 422, ['field' => 'industry_other_label']);
                    }
                    $update['industry_classification'] = $industry;
                    $update['industry_other_label'] = $industry === 'OTHER' ? mb_substr($other, 0, 80) : null;
                }
                if (array_key_exists('preferred_category_ids', $input)) {
                    $ids = array_values(array_unique(array_map('strval', (array) $input['preferred_category_ids'])));
                    if (DB::table('material_categories')->whereIn('id', $ids)->where('active', true)->count() !== count($ids)) {
                        throw new AuthenticationException('CATEGORY_UNKNOWN', 'Choose categories from the current list.', 422, ['field' => 'preferred_category_ids']);
                    }
                    DB::table('buyer_preferred_categories')->where('buyer_profile_id', $buyerId)->whereNotIn('material_category_id', $ids)->delete();
                    foreach ($ids as $id) {
                        DB::table('buyer_preferred_categories')->insertOrIgnore(['id' => (string) Str::uuid7(), 'buyer_profile_id' => $buyerId, 'material_category_id' => $id, 'created_at' => now(), 'updated_at' => now()]);
                    }
                }
            }
            if ($action === 'COMPLETE') {
                $update += ['onboarding_status' => 'COMPLETED', 'onboarding_completed_at' => $profile->onboarding_completed_at ?? now()];
            } elseif ($action === 'SKIP' && $profile->onboarding_status !== 'COMPLETED') {
                $update += ['onboarding_status' => 'SKIPPED'];
            }
            DB::table('buyer_profiles')->where('id', $buyerId)->update($update);
            $this->audit->account($request, 'BUYER_ONBOARDING_'.$action, 'BUYER_PROFILE', $buyerId, after: ['fields' => array_values(array_diff(array_keys($update), ['lock_version', 'updated_at']))]);
        });

        return $this->snapshot($request);
    }

    /** Saves the Buyer's confirmed radius. Only called after an explicit selection or confirmed expansion. */
    public function saveRadius(Request $request, mixed $radiusKm): int
    {
        $radius = RadiusPolicy::assertAllowed($radiusKm);
        DB::table('buyer_profiles')->where('id', $this->profiles->idFor($request))->update(['discovery_radius_km' => $radius, 'updated_at' => now()]);

        return $radius;
    }

    /** @return array{items: list<array<string, string>>, meta: array<string, mixed>} */
    public function areas(string $level, ?string $parentCode, string $query, int $page): array
    {
        $version = DB::table('psgc_versions')->where('status', 'ACTIVE')->first(['id', 'version']);
        if ($version === null) {
            return ['items' => [], 'meta' => ['psgc_version' => null, 'page' => $page, 'has_more' => false, 'status' => 'NO_ACTIVE_PSGC_VERSION']];
        }
        $levels = ['REGION' => ['REGION'], 'PROVINCE' => ['PROVINCE', 'CITY'], 'CITY' => PsgcResolver::CITY_LEVELS, 'BARANGAY' => ['BARANGAY']][$level];
        $rows = DB::table('psgc_areas as a')->where('a.psgc_version_id', $version->id)->whereIn('a.level', $levels);
        if ($level === 'PROVINCE') {
            // Provinces plus cities that sit directly under a region (independent/highly urbanized cities).
            $rows->where(fn ($query) => $query->where('a.level', 'PROVINCE')->orWhereIn('a.parent_id', DB::table('psgc_areas')->select('id')->where('psgc_version_id', $version->id)->where('level', 'REGION')));
        }
        if ($parentCode !== null) {
            $parent = DB::table('psgc_areas')->where('psgc_version_id', $version->id)->where('code', $parentCode)->first(['id', 'level']);
            if ($parent === null) {
                return ['items' => [], 'meta' => ['psgc_version' => $version->version, 'page' => $page, 'has_more' => false, 'status' => 'PARENT_UNKNOWN']];
            }
            $rows->where(fn ($query) => $query->where('a.parent_id', $parent->id)->orWhereIn('a.parent_id', DB::table('psgc_areas')->select('id')->where('parent_id', $parent->id)->where('level', 'SUB_MUNICIPALITY')));
            if ($level === 'CITY' && $parent->level === 'CITY') {
                $rows = DB::table('psgc_areas as a')->where('a.id', $parent->id);
            }
        }
        if (trim($query) !== '') {
            $rows->where('a.normalized_name', 'like', '%'.str_replace(['%', '_'], ['\\%', '\\_'], PsgcNames::normalize($query)).'%');
        }
        $items = $rows->orderBy('a.name')->orderBy('a.code')->offset(($page - 1) * 25)->limit(26)->get(['a.code', 'a.name', 'a.level']);

        return ['items' => $items->take(25)->map(static fn (object $row): array => ['code' => $row->code, 'name' => $row->name, 'level' => $row->level])->values()->all(),
            'meta' => ['psgc_version' => $version->version, 'page' => $page, 'has_more' => $items->count() > 25, 'status' => 'AVAILABLE']];
    }
}
