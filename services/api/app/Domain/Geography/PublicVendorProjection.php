<?php

declare(strict_types=1);

namespace App\Domain\Geography;

use App\Domain\Catalog\EligibleOfferQuery;
use App\Domain\Vendors\StoreOperatingSchedule;
use Illuminate\Database\Query\Builder;
use Illuminate\Support\Carbon;
use Illuminate\Support\Facades\DB;

/**
 * The one public Tier 2 projection consumed by map markers, list rows, the preview sheet and the public
 * Store Profile. Membership requires an active organization, stored DISCOVERABLE status, a completed public
 * profile, a saved store point and at least one currently eligible listing (MAT-02, evaluated live so a
 * stale stored status never shows a store without offers). Saved hours never affect membership.
 *
 * Fields are allowlisted: the canonical Public Store Name, validated public media, approved public contacts
 * and the structured public address. Legal/registered names, IDs, TIN, authority evidence, the private store
 * email, staff details and payout data are never selected here.
 */
final class PublicVendorProjection
{
    public const VERSION = 'phase6.public-vendor.v1';

    public function __construct(private readonly EligibleOfferQuery $offers, private readonly StoreOperatingSchedule $schedule) {}

    /** Organizations (alias o) with profile p and current store address version av. */
    public function members(): Builder
    {
        return DB::table('vendor_organizations as o')
            ->join('store_profiles as p', 'p.vendor_organization_id', '=', 'o.id')
            ->join('vendor_addresses as va', 'va.vendor_organization_id', '=', 'o.id')
            ->join('vendor_address_versions as av', 'av.id', '=', 'va.current_version_id')
            ->where('o.account_status', 'ACTIVE')->where('o.store_activation_status', 'ACTIVE')->whereNull('o.activation_hold_code')
            ->where('o.marketplace_discoverability_status', 'DISCOVERABLE')
            ->where('p.status', 'COMPLETED')->whereNotNull('av.location')
            ->whereExists(fn (Builder $listing) => $this->offers->constrainListings($listing->selectRaw('1')->from('vendor_listings as l')->whereColumn('l.vendor_organization_id', 'o.id')));
    }

    /** Restricts members to those with an eligible listing in one controlled material category. */
    public function inCategory(Builder $members, string $categoryId): Builder
    {
        return $members->whereExists(fn (Builder $listing) => $this->offers->constrainListings($listing->selectRaw('1')->from('vendor_listings as l')
            ->whereColumn('l.vendor_organization_id', 'o.id')->where('l.material_category_id', $categoryId)));
    }

    /**
     * Allowlisted public fields keyed by organization id.
     *
     * @param  list<string>  $organizationIds
     * @return array<string, array<string, mixed>>
     */
    public function summaries(array $organizationIds): array
    {
        if ($organizationIds === []) {
            return [];
        }
        $rows = DB::table('vendor_organizations as o')
            ->join('store_profiles as p', 'p.vendor_organization_id', '=', 'o.id')
            ->leftJoin('vendor_addresses as va', 'va.vendor_organization_id', '=', 'o.id')
            ->leftJoin('vendor_address_versions as av', 'av.id', '=', 'va.current_version_id')
            ->leftJoin('vendor_classifications as c', 'c.vendor_organization_id', '=', 'o.id')
            ->leftJoin('delivery_service_areas as d', fn ($join) => $join->on('d.vendor_organization_id', '=', 'o.id')->where('d.active', true))
            ->whereIn('o.id', $organizationIds)
            ->get(['o.id', 'p.id as profile_id', 'p.public_store_name', 'p.description', 'p.public_email', 'p.public_phone', 'p.vacation_mode', 'p.fulfillment_method', 'p.bulk_capability',
                'p.logo_file_id', 'p.banner_file_id', 'av.id as address_version_id', 'av.formatted_address', 'av.city_municipality', 'av.province',
                'c.supplier_type', 'c.niches', 'd.maximum_distance_km']);
        $media = $this->publicMedia($rows->flatMap(static fn (object $row): array => array_filter([$row->logo_file_id, $row->banner_file_id]))->values()->all());
        $scores = DB::query()->fromSub(DB::table('score_snapshots')->whereIn('vendor_organization_id', $organizationIds)->whereNotNull('vps')
            ->selectRaw('DISTINCT ON (vendor_organization_id) vendor_organization_id, vps')->orderBy('vendor_organization_id')->orderByDesc('window_ends_on'), 's')
            ->pluck('vps', 'vendor_organization_id');
        $hours = $this->openStatuses($rows->pluck('profile_id')->map(static fn (mixed $id): string => (string) $id)->all());

        $summaries = [];
        foreach ($rows as $row) {
            $vps = $scores[$row->id] ?? null;
            $niches = json_decode((string) ($row->niches ?? '[]'), true);
            $summaries[(string) $row->id] = [
                'id' => (string) $row->id,
                'public_store_name' => (string) $row->public_store_name,
                'description' => $row->description,
                'logo_url' => $media[(string) $row->logo_file_id] ?? null,
                'banner_url' => $media[(string) $row->banner_file_id] ?? null,
                'public_phone' => $row->public_phone,
                'public_email' => $row->public_email,
                'address' => ['formatted_address' => $row->formatted_address, 'city_municipality' => $row->city_municipality, 'province' => $row->province],
                'supplier_type' => $row->supplier_type,
                'niches' => is_array($niches) ? array_values(array_filter($niches, 'is_string')) : [],
                'fulfillment_method' => $row->fulfillment_method,
                'bulk_capability' => $row->bulk_capability === null ? null : (bool) $row->bulk_capability,
                'vacation_mode' => (bool) $row->vacation_mode,
                'delivery_maximum_km' => in_array($row->fulfillment_method, ['VENDOR_DELIVERY', 'BOTH'], true) && $row->maximum_distance_km !== null ? (int) $row->maximum_distance_km : null,
                'score_label' => $vps === null
                    ? ['kind' => 'NEW_VENDOR', 'value' => null, 'text' => 'New Vendor']
                    : ['kind' => 'VPS', 'value' => number_format((float) $vps, 1, '.', ''), 'text' => 'VPS '.number_format((float) $vps, 1, '.', '')],
                'open_status' => $hours[(string) $row->profile_id] ?? ['status' => 'UNAVAILABLE', 'opens_at' => null, 'closes_at' => null, 'basis' => 'SAVED_SCHEDULE'],
                'address_version_id' => $row->address_version_id,
            ];
        }

        return $summaries;
    }

    /**
     * Validated public media only: a READY store_media record whose file is PUBLIC, CLEAN and carries a
     * public delivery URL. Private or unscanned files are never exposed.
     *
     * @param  list<string>  $fileIds
     * @return array<string, string>
     */
    private function publicMedia(array $fileIds): array
    {
        if ($fileIds === []) {
            return [];
        }
        $urls = [];
        foreach (DB::table('files as f')->join('store_media as m', 'm.file_id', '=', 'f.id')->whereIn('f.id', $fileIds)
            ->where('f.visibility', 'PUBLIC')->where('f.scan_state', 'CLEAN')->where('m.status', 'READY')->get(['f.id', 'f.metadata']) as $file) {
            $metadata = json_decode((string) $file->metadata, true);
            $url = is_array($metadata) ? ($metadata['public_url'] ?? null) : null;
            if (is_string($url) && preg_match('~^https://~i', $url) === 1) {
                $urls[(string) $file->id] = $url;
            }
        }

        return $urls;
    }

    /**
     * Descriptive Open/Closed label from the saved schedule and server time in Asia/Manila; a dated override
     * wins for its date. Informational only: it never filters, ranks or changes radius membership.
     *
     * @param  list<string>  $profileIds
     * @return array<string, array{status: string, opens_at: ?string, closes_at: ?string, basis: string}>
     */
    public function openStatuses(array $profileIds, ?Carbon $at = null): array
    {
        $now = ($at ?? Carbon::now())->copy()->setTimezone('Asia/Manila');
        $overrides = DB::table('store_operation_date_overrides')->whereIn('store_profile_id', $profileIds)->where('specific_date', $now->toDateString())->get()->keyBy('store_profile_id');
        $result = [];
        foreach ($profileIds as $profileId) {
            $weekly = $this->schedule->weekly($profileId);
            if (! $this->schedule->valid($weekly)) {
                $result[$profileId] = ['status' => 'UNAVAILABLE', 'opens_at' => null, 'closes_at' => null, 'basis' => 'SAVED_SCHEDULE'];

                continue;
            }
            $override = $overrides[$profileId] ?? null;
            $today = $override === null
                ? collect($weekly)->firstWhere('day_of_week', $now->isoWeekday())
                : ['status' => $override->is_closed ? 'CLOSED' : 'OPEN', 'opens_at' => $override->is_closed ? null : substr((string) $override->opens_at, 0, 5), 'closes_at' => $override->is_closed ? null : substr((string) $override->closes_at, 0, 5)];
            $clock = $now->format('H:i');
            $open = ($today['status'] ?? 'CLOSED') === 'OPEN' && $clock >= $today['opens_at'] && $clock < $today['closes_at'];
            $result[$profileId] = ['status' => $open ? 'OPEN' : 'CLOSED', 'opens_at' => $today['opens_at'] ?? null, 'closes_at' => $today['closes_at'] ?? null,
                'basis' => $override === null ? 'SAVED_SCHEDULE' : 'DATE_OVERRIDE'];
        }

        return $result;
    }
}
