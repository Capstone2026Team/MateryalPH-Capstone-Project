<?php

declare(strict_types=1);

namespace App\Domain\UserManagement;

use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Enforcement\BuyerCommerceRestriction;
use App\Domain\Enforcement\EnforcementService;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Inventory\StockAvailability;
use App\Domain\Operations\AdminAccess;
use App\Domain\Reviews\ReviewPresenter;
use App\Domain\Reviews\ReviewRules;
use App\Domain\Scores\PublicScores;
use App\Models\AuthSession;
use App\Support\PortalDateRange;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Str;
use League\Flysystem\FilesystemException;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Admin Buyer and Vendor user directories: a bounded, filterable list and a read-only profile with contact details,
 * ratings and reviews, activity and (for Vendors) basic product listings. It never changes an account; sanctions stay
 * in Enforcement. Contact details need user_directory.view, which the enforcement review does not grant, and every
 * profile opening is audited. A self-deleted Buyer's contact details stay masked. Product stock is the public
 * availability label only: exact Vendor inventory is never returned.
 */
final class UserDirectoryService
{
    public const PERMISSION = 'user_directory.view';

    public const PER_PAGE = 20;

    public const BUYER_STATUSES = ['ACTIVE', 'PENDING_VERIFICATION', 'SUSPENDED', 'DEACTIVATED', 'DELETED'];

    public const VENDOR_ACTIVATION = ['NOT_READY', 'READY', 'ACTIVE', 'RESTRICTED', 'SUSPENDED'];

    public const VENDOR_VERIFICATION = ['NOT_STARTED', 'IN_PROGRESS', 'SUBMITTED', 'PENDING_VERIFICATION', 'APPROVED', 'CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'];

    public const SORTS = ['joined_desc', 'joined_asc', 'name_asc', 'name_desc'];

    private const TERMINAL_ORDER_STATES = ['COMPLETED', 'CANCELLED', 'DECLINED', 'EXPIRED'];

    private const CLOSED_DISPUTES = ['RESOLVED', 'CLOSED_INCONCLUSIVE'];

    public function __construct(
        private readonly AdminAccess $access,
        private readonly AuditRecorder $audit,
        private readonly ReviewPresenter $presenter,
        private readonly CatalogFileStore $files,
    ) {}

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function buyers(Request $request, array $filters): array
    {
        $this->access->require($request, self::PERMISSION);
        $scoped = fn (): Builder => $this->buyerScope($filters);
        $counts = $scoped()->groupBy('u.account_status')->selectRaw('u.account_status AS status, COUNT(*) AS total')->pluck('total', 'status')->map(static fn (mixed $total): int => (int) $total)->all();
        $query = $scoped();
        if (! empty($filters['status'])) {
            $query->where('u.account_status', $filters['status']);
        }
        $total = (clone $query)->count();
        $page = $this->page($filters);
        match ($filters['sort'] ?? 'joined_desc') {
            'joined_asc' => $query->orderBy('u.created_at'),
            'name_asc' => $query->orderByRaw('lower(coalesce(up.full_name, u.name))'),
            'name_desc' => $query->orderByRaw('lower(coalesce(up.full_name, u.name)) DESC'),
            default => $query->orderByDesc('u.created_at'),
        };
        $rows = $query->orderBy('b.id')->forPage($page, self::PER_PAGE)
            ->get(['b.id', 'b.buyer_type', 'b.company_name', 'u.email', 'u.account_status', 'u.created_at', 'u.last_authenticated_at', DB::raw('coalesce(up.full_name, u.name) AS display_name')]);

        return ['items' => $rows->map(fn (object $row): array => [
            'id' => (string) $row->id, 'name' => (string) $row->display_name, 'email' => $this->buyerEmail($row), 'status' => (string) $row->account_status,
            'buyer_type' => (string) $row->buyer_type, 'company_name' => $row->company_name, 'joined_at' => self::iso($row->created_at), 'last_active_at' => self::iso($row->last_authenticated_at),
        ])->all(), 'meta' => $this->meta($page, $total, ['status_counts' => (object) $counts])];
    }

    /** @return array<string, mixed> */
    public function buyer(Request $request, string $id): array
    {
        $actor = $this->access->require($request, self::PERMISSION);
        $buyer = $this->buyerRow($id);
        $profileId = (string) $buyer->id;
        $deleted = $buyer->account_status === 'DELETED';
        $address = DB::table('buyer_locations as l')->join('addresses as a', 'a.id', '=', 'l.address_id')->where('l.buyer_profile_id', $profileId)->whereNull('l.archived_at')
            ->orderByDesc('l.is_primary')->orderBy('l.created_at')->first(['a.city_municipality', 'a.province']);
        $orders = DB::table('orders')->where('buyer_profile_id', $profileId)->groupBy('order_state')->selectRaw('order_state, COUNT(*) AS total')->pluck('total', 'order_state');
        $received = ReviewRules::constrainVisible(DB::table('reviews as r')->where('r.buyer_profile_id', $profileId)->where('r.review_type', ReviewRules::BUYER))
            ->selectRaw('count(*) AS total, avg(r.inquiry_seriousness)::numeric AS seriousness, avg(r.communication_quality)::numeric AS communication, avg(r.payment_reliability)::numeric AS payment')->first();
        $this->audit->account($request, 'USER_DIRECTORY_VIEWED', 'BUYER_PROFILE', $profileId, [], ['subject_type' => 'BUYER', 'fields' => ['contact', 'profile_photo', 'ratings', 'activity']]);

        return [
            'id' => $profileId, 'subject_type' => 'BUYER', 'name' => (string) $buyer->display_name, 'status' => (string) $buyer->account_status,
            'profile' => [
                'avatar_url' => $deleted || $buyer->profile_photo_key === null || $buyer->profile_photo_disk === null ? null : URL::temporarySignedRoute('admin.directory.buyer-photo', now()->addMinutes(5),
                    ['buyerId' => $profileId, 'owner' => $buyer->public_id, 'version' => $buyer->lock_version, 'viewer' => $request->user()->public_id]),
                'email' => $this->buyerEmail($buyer), 'email_verified' => $buyer->email_verified_at !== null, 'mobile' => $deleted ? null : $buyer->mobile_e164,
                'buyer_type' => (string) $buyer->buyer_type, 'company_name' => $buyer->company_name, 'position_title' => $buyer->position_title,
                'industry' => $buyer->industry_classification === 'OTHER' ? ($buyer->industry_other_label ?? 'Other') : $buyer->industry_classification,
                'area' => $address === null ? null : implode(', ', array_filter([$address->city_municipality, $address->province])),
                'onboarding_status' => (string) $buyer->onboarding_status, 'joined_at' => self::iso($buyer->joined_at), 'deleted_at' => self::iso($buyer->account_deleted_at),
                'commerce_restricted_until' => BuyerCommerceRestriction::activeUntil($profileId)?->toIso8601String(),
            ],
            'ratings' => [
                'received' => ['count' => (int) $received->total, 'inquiry_seriousness' => $received->total > 0 ? PublicScores::round((string) $received->seriousness) : null,
                    'communication_quality' => $received->total > 0 ? PublicScores::round((string) $received->communication) : null, 'payment_reliability' => $received->total > 0 ? PublicScores::round((string) $received->payment) : null],
                'written' => ['count' => DB::table('reviews')->where('buyer_profile_id', $profileId)->whereIn('review_type', [ReviewRules::VENDOR, ReviewRules::PRODUCT])->whereNotNull('submitted_at')->count()],
            ],
            'activity' => [
                'orders_total' => (int) $orders->sum(), 'orders_open' => (int) $orders->except(self::TERMINAL_ORDER_STATES)->sum(), 'orders_completed' => (int) ($orders['COMPLETED'] ?? 0),
                'orders_cancelled' => (int) ($orders['CANCELLED'] ?? 0) + (int) ($orders['DECLINED'] ?? 0) + (int) ($orders['EXPIRED'] ?? 0),
                'quotations_total' => DB::table('quotations')->where('buyer_profile_id', $profileId)->count(),
                'quotations_accepted' => DB::table('quotations')->where('buyer_profile_id', $profileId)->where('state', 'ACCEPTED')->count(),
                'projects_total' => DB::table('projects')->where('buyer_profile_id', $profileId)->count(),
                'work_packages_total' => DB::table('work_packages as w')->join('projects as p', 'p.id', '=', 'w.project_id')->where('p.buyer_profile_id', $profileId)->whereNull('w.deleted_at')->count(),
                'conversations_total' => DB::table('conversations')->where('buyer_profile_id', $profileId)->count(),
                'favorite_stores' => DB::table('favorite_vendors')->where('buyer_profile_id', $profileId)->count(),
                'disputes_total' => DB::table('dispute_cases')->where('buyer_profile_id', $profileId)->count(),
                'disputes_open' => DB::table('dispute_cases')->where('buyer_profile_id', $profileId)->whereNotIn('status', self::CLOSED_DISPUTES)->count(),
                'sign_ins_30_days' => DB::table('auth_sessions')->where('user_id', $buyer->user_id)->where('created_at', '>=', now()->subDays(30))->count(),
                'last_active_at' => self::iso($buyer->last_authenticated_at),
            ],
            'recent_orders' => DB::table('orders as o')->join('vendor_organizations as v', 'v.id', '=', 'o.vendor_organization_id')->where('o.buyer_profile_id', $profileId)
                ->orderByDesc('o.created_at')->orderByDesc('o.id')->limit(5)->get(['o.id', 'o.reference', 'o.order_state', 'o.payment_state', 'o.procurement_type', 'o.created_at', 'v.store_name'])
                ->map(static fn (object $order): array => ['id' => (string) $order->id, 'reference' => (string) $order->reference, 'order_state' => (string) $order->order_state, 'payment_state' => (string) $order->payment_state,
                    'procurement_type' => (string) $order->procurement_type, 'store_name' => (string) $order->store_name, 'created_at' => self::iso($order->created_at)])->all(),
            'sanctions' => $this->sanctions('BUYER', $profileId, $actor['permissions']),
            'can_view_enforcement' => in_array('enforcement.view', $actor['permissions'], true),
        ];
    }

    /** A signed URL never grants access without the current directory permission and a current active Admin session. */
    public function buyerPhoto(Request $request, string $id): StreamedResponse
    {
        $buyer = $this->authorizedPhotoBuyer($request, $id);
        try {
            $bytes = Storage::disk((string) $buyer->profile_photo_disk)->get((string) $buyer->profile_photo_key);
        } catch (FilesystemException) {
            throw new AuthenticationException('FILE_UNAVAILABLE', 'The Buyer photo is temporarily unavailable.', 503);
        }
        if (! is_string($bytes)) {
            throw new AuthenticationException('FILE_UNAVAILABLE', 'The Buyer photo is temporarily unavailable.', 503);
        }
        // Private storage may be remote: account deletion, permission revocation and photo replacement take effect
        // before any bytes leave this process, even when they happen while storage is being read.
        $current = $this->authorizedPhotoBuyer($request, $id);
        if ($current->profile_photo_key !== $buyer->profile_photo_key || $current->profile_photo_disk !== $buyer->profile_photo_disk) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This Buyer photo changed. Reload the profile.', 404);
        }

        return response()->stream(static function () use ($bytes): void {
            echo $bytes;
        }, 200, ['Content-Type' => 'image/png', 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff']);
    }

    private function authorizedPhotoBuyer(Request $request, string $id): object
    {
        $request->user()->refresh();
        $this->access->require($request, self::PERMISSION);
        $session = $request->attributes->get('auth_session');
        if (! $session instanceof AuthSession || ! AuthSession::query()->whereKey($session->getKey())->where('user_id', $request->user()->getKey())
            ->whereNull('revoked_at')->where('expires_at', '>', now())->exists()) {
            throw new AuthenticationException('SESSION_EXPIRED', 'Your session has expired. Sign in again.', 401);
        }
        $buyer = $this->buyerRow($id);
        if ($buyer->account_status === 'DELETED' || $buyer->profile_photo_key === null || $buyer->profile_photo_disk === null
            || $request->query('owner') !== $buyer->public_id || (string) $request->query('version') !== (string) $buyer->lock_version
            || $request->query('viewer') !== $request->user()->public_id) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This Buyer photo is unavailable.', 404);
        }

        return $buyer;
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function buyerReviews(Request $request, string $id, array $filters): array
    {
        $actor = $this->access->require($request, self::PERMISSION);
        $this->buyerRow($id);
        $direction = $filters['direction'] ?? 'RECEIVED';
        $query = DB::table('reviews as r')->join('orders as o', 'o.id', '=', 'r.order_id')->join('vendor_organizations as v', 'v.id', '=', 'r.vendor_organization_id')
            ->where('r.buyer_profile_id', $id)->whereNotNull('r.submitted_at');
        $direction === 'WRITTEN' ? $query->whereIn('r.review_type', [ReviewRules::VENDOR, ReviewRules::PRODUCT]) : $query->where('r.review_type', ReviewRules::BUYER);

        return $this->reviewPage($query, $filters, $actor['permissions'], ['direction' => $direction]);
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function vendors(Request $request, array $filters): array
    {
        $this->access->require($request, self::PERMISSION);
        $scoped = fn (): Builder => $this->vendorScope($filters);
        $counts = $scoped()->groupBy('o.store_activation_status')->selectRaw('o.store_activation_status AS status, COUNT(*) AS total')->pluck('total', 'status')->map(static fn (mixed $total): int => (int) $total)->all();
        $query = $scoped();
        if (! empty($filters['status'])) {
            $query->where('o.store_activation_status', $filters['status']);
        }
        $total = (clone $query)->count();
        $page = $this->page($filters);
        match ($filters['sort'] ?? 'joined_desc') {
            'joined_asc' => $query->orderBy('o.created_at'),
            'name_asc' => $query->orderByRaw('lower(o.store_name)'),
            'name_desc' => $query->orderByRaw('lower(o.store_name) DESC'),
            default => $query->orderByDesc('o.created_at'),
        };
        $rows = $query->orderBy('o.id')->forPage($page, self::PER_PAGE)->get(['o.id', 'o.store_name', 'o.store_activation_status', 'o.store_verification_status', 'o.marketplace_discoverability_status', 'o.account_status', 'o.created_at',
            'address.province', 'address.city_municipality', DB::raw($this->ownerSql('name').' AS owner_name'), DB::raw($this->ownerSql('email').' AS owner_email')]);

        return ['items' => $rows->map(static fn (object $row): array => [
            'id' => (string) $row->id, 'store_name' => (string) $row->store_name, 'owner_name' => $row->owner_name, 'owner_email' => $row->owner_email, 'status' => (string) $row->store_activation_status,
            'verification_status' => (string) $row->store_verification_status, 'discoverability_status' => (string) $row->marketplace_discoverability_status, 'account_status' => (string) $row->account_status,
            'location' => implode(', ', array_filter([$row->city_municipality, $row->province])) ?: null, 'joined_at' => self::iso($row->created_at),
        ])->all(), 'meta' => $this->meta($page, $total, ['status_counts' => (object) $counts])];
    }

    /** @return array<string, mixed> */
    public function vendor(Request $request, string $id): array
    {
        $actor = $this->access->require($request, self::PERMISSION);
        $store = $this->vendorRow($id);
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $id)->first();
        $address = DB::table('addresses')->where('owner_type', 'VENDOR_ORGANIZATION')->where('owner_id', $id)->where('is_current', true)->first(['formatted_address', 'city_municipality', 'province']);
        $owner = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->leftJoin('user_profiles as up', 'up.user_id', '=', 'u.id')
            ->where('m.vendor_organization_id', $id)->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->orderBy('m.created_at')->first(['u.name', 'u.email', 'up.mobile_e164']);
        $logo = $profile?->logo_file_id === null ? null : DB::table('files')->where('id', $profile->logo_file_id)->where('scan_state', 'CLEAN')->first();
        $banner = $profile?->banner_file_id === null ? null : DB::table('files')->where('id', $profile->banner_file_id)->where('scan_state', 'CLEAN')->first();
        $members = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $id)->whereNull('m.deleted_at');
        $orders = DB::table('orders')->where('vendor_organization_id', $id)->groupBy('order_state')->selectRaw('order_state, COUNT(*) AS total')->pluck('total', 'order_state');
        $storeRatings = ReviewRules::constrainVisible(DB::table('reviews as r')->where('r.vendor_organization_id', $id)->where('r.review_type', ReviewRules::VENDOR))
            ->selectRaw('count(*) AS total, avg(r.service_quality)::numeric AS service, avg(r.speed_rating)::numeric AS speed')->first();
        $productRatings = ReviewRules::constrainVisible(DB::table('reviews as r')->where('r.vendor_organization_id', $id)->where('r.review_type', ReviewRules::PRODUCT))
            ->selectRaw('count(*) AS total, avg(r.rating)::numeric AS average')->first();
        $listings = DB::table('vendor_listings')->where('vendor_organization_id', $id)->whereNull('removed_at')->groupBy('status')->selectRaw('status, COUNT(*) AS total')->pluck('total', 'status');
        $quotes = DB::table('quotation_versions as qv')->join('quotations as q', 'q.id', '=', 'qv.quotation_id')->where('q.vendor_organization_id', $id);
        $this->audit->account($request, 'USER_DIRECTORY_VIEWED', 'VENDOR_ORGANIZATION', $id, [], ['subject_type' => 'VENDOR_ORGANIZATION', 'fields' => ['contact', 'ratings', 'activity', 'listings']]);

        return [
            'id' => $id, 'subject_type' => 'VENDOR_ORGANIZATION', 'store_name' => (string) $store->store_name, 'status' => (string) $store->store_activation_status,
            'store' => [
                'legal_name' => $store->legal_business_name ?? $store->legal_name, 'registered_name' => $store->registered_name, 'business_type' => $store->business_type, 'description' => $profile?->description,
                'logo_url' => $logo === null ? null : $this->files->temporaryUrl($logo)['url'], 'banner_url' => $banner === null ? null : $this->files->temporaryUrl($banner)['url'],
                'contact_email' => $profile->public_email ?? $store->store_email, 'contact_phone' => $profile->public_phone ?? $store->store_phone,
                'address' => $address?->formatted_address, 'location' => $address === null ? null : implode(', ', array_filter([$address->city_municipality, $address->province])),
                'verification_status' => (string) $store->store_verification_status, 'setup_status' => (string) $store->store_setup_status, 'activation_status' => (string) $store->store_activation_status,
                'discoverability_status' => (string) $store->marketplace_discoverability_status, 'account_status' => (string) $store->account_status, 'activation_hold_code' => $store->activation_hold_code,
                'vacation_mode' => (bool) ($profile->vacation_mode ?? false), 'bulk_capability' => (bool) ($profile->bulk_capability ?? false), 'joined_at' => self::iso($store->created_at),
            ],
            'owner' => $owner === null ? null : ['name' => (string) $owner->name, 'email' => (string) $owner->email, 'mobile' => $owner->mobile_e164],
            'ratings' => [
                'store' => ['count' => (int) $storeRatings->total, 'service_quality' => $storeRatings->total > 0 ? PublicScores::round((string) $storeRatings->service) : null, 'speed' => $storeRatings->total > 0 ? PublicScores::round((string) $storeRatings->speed) : null],
                'product' => ['count' => (int) $productRatings->total, 'average' => $productRatings->total > 0 ? PublicScores::round((string) $productRatings->average) : null],
            ],
            'activity' => [
                'quotes_sent' => (clone $quotes)->count(), 'quotes_accepted' => DB::table('quotations')->where('vendor_organization_id', $id)->where('state', 'ACCEPTED')->count(),
                'orders_total' => (int) $orders->sum(), 'orders_fulfilled' => (int) ($orders['COMPLETED'] ?? 0), 'orders_open' => (int) $orders->except(self::TERMINAL_ORDER_STATES)->sum(),
                'orders_cancelled' => (int) ($orders['CANCELLED'] ?? 0) + (int) ($orders['DECLINED'] ?? 0) + (int) ($orders['EXPIRED'] ?? 0),
                'disputes_total' => DB::table('dispute_cases')->where('vendor_organization_id', $id)->count(),
                'disputes_open' => DB::table('dispute_cases')->where('vendor_organization_id', $id)->whereNotIn('status', self::CLOSED_DISPUTES)->count(),
                'listings_total' => (int) $listings->sum(), 'listings_active' => (int) ($listings['ACTIVE'] ?? 0),
                'team_members' => (clone $members)->where('m.status', 'ACTIVE')->count(),
                'last_login_at' => self::iso((clone $members)->max('u.last_authenticated_at')),
                'sign_ins_30_days' => DB::table('auth_sessions as s')->join('vendor_memberships as m', 'm.user_id', '=', 's.user_id')->where('m.vendor_organization_id', $id)->where('s.created_at', '>=', now()->subDays(30))->count(),
            ],
            'sanctions' => $this->sanctions('VENDOR_ORGANIZATION', $id, $actor['permissions']),
            'can_view_enforcement' => in_array('enforcement.view', $actor['permissions'], true),
            'can_view_verification' => in_array('vendor_verification.review', $actor['permissions'], true),
        ];
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function vendorReviews(Request $request, string $id, array $filters): array
    {
        $actor = $this->access->require($request, self::PERMISSION);
        $this->vendorRow($id);
        $type = $filters['type'] ?? ReviewRules::VENDOR;
        $query = DB::table('reviews as r')->join('orders as o', 'o.id', '=', 'r.order_id')->join('vendor_organizations as v', 'v.id', '=', 'r.vendor_organization_id')
            ->where('r.vendor_organization_id', $id)->where('r.review_type', $type)->whereNotNull('r.submitted_at');

        return $this->reviewPage($query, $filters, $actor['permissions'], ['type' => $type]);
    }

    /**
     * Basic listing facts only: image, name, price range, public stock label and status.
     *
     * @param  array<string, mixed>  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function vendorListings(Request $request, string $id, array $filters): array
    {
        $this->access->require($request, self::PERMISSION);
        $this->vendorRow($id);
        $scoped = function () use ($id, $filters): Builder {
            $query = DB::table('vendor_listings as l')->where('l.vendor_organization_id', $id)->whereNull('l.removed_at');
            if (! empty($filters['q'])) {
                $term = '%'.addcslashes(mb_strtolower((string) $filters['q']), '%_\\').'%';
                $query->where(fn (Builder $search) => $search->whereRaw('lower(l.display_name) LIKE ?', [$term])->orWhereRaw('lower(l.vendor_sku) LIKE ?', [$term]));
            }

            return $query;
        };
        $counts = $scoped()->groupBy('l.status')->selectRaw('l.status, COUNT(*) AS total')->pluck('total', 'status')->map(static fn (mixed $total): int => (int) $total)->all();
        $query = $scoped();
        if (! empty($filters['status'])) {
            $query->where('l.status', $filters['status']);
        }
        $total = (clone $query)->count();
        $page = $this->page($filters);
        $rows = $query->orderByDesc('l.updated_at')->orderBy('l.id')->forPage($page, self::PER_PAGE)->get(['l.id', 'l.display_name', 'l.vendor_sku', 'l.status', 'l.updated_at']);
        $ids = $rows->pluck('id')->all();
        $prices = DB::table('listing_variants as v')->join('listing_price_versions as pv', fn ($join) => $join->on('pv.listing_variant_id', '=', 'v.id')->where('pv.price_kind', 'ORDINARY')->whereNull('pv.retired_at'))
            ->whereIn('v.vendor_listing_id', $ids)->where('v.active', true)->groupBy('v.vendor_listing_id')
            ->selectRaw('v.vendor_listing_id, MIN(pv.amount_centavos) AS min_price, MAX(pv.amount_centavos) AS max_price, COUNT(DISTINCT v.id) AS variant_count')->get()->keyBy('vendor_listing_id');
        $stock = DB::table('listing_variants as v')->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')->whereIn('v.vendor_listing_id', $ids)->where('v.active', true)->groupBy('v.vendor_listing_id')
            ->selectRaw('v.vendor_listing_id, bool_or(i.quantity_on_hand - i.hard_reserved_quantity > 0) AS has_stock, bool_or(i.quantity_on_hand - i.hard_reserved_quantity > 0 AND (i.reorder_level IS NULL OR i.quantity_on_hand - i.hard_reserved_quantity > i.reorder_level)) AS above_reorder')
            ->get()->keyBy('vendor_listing_id');
        $units = DB::table('listing_variants as v')->join('units as u', 'u.id', '=', 'v.unit_id')->whereIn('v.vendor_listing_id', $ids)->where('v.active', true)->groupBy('v.vendor_listing_id')
            ->selectRaw('v.vendor_listing_id, MIN(u.code) AS unit_code, COUNT(DISTINCT v.unit_id) AS unit_count')->get()->keyBy('vendor_listing_id');
        $media = DB::table('listing_media')->whereIn('vendor_listing_id', $ids)->where('status', 'READY')->orderBy('sort_order')->orderBy('id')->get(['vendor_listing_id', 'file_id', 'alt_text'])->groupBy('vendor_listing_id');
        $files = DB::table('files')->whereIn('id', $media->map(static fn ($group) => $group[0]->file_id)->values()->all())->where('scan_state', 'CLEAN')->get()->keyBy('id');

        return ['items' => $rows->map(fn (object $row): array => [
            'id' => (string) $row->id, 'name' => (string) $row->display_name, 'sku' => $row->vendor_sku, 'status' => (string) $row->status, 'updated_at' => self::iso($row->updated_at),
            'variant_count' => (int) ($prices[$row->id]->variant_count ?? 0),
            'min_price_centavos' => isset($prices[$row->id]) ? (int) $prices[$row->id]->min_price : null, 'max_price_centavos' => isset($prices[$row->id]) ? (int) $prices[$row->id]->max_price : null,
            'unit_code' => isset($units[$row->id]) && (int) $units[$row->id]->unit_count === 1 ? (string) $units[$row->id]->unit_code : null,
            'stock' => match (true) {
                ! isset($stock[$row->id]) || ! $stock[$row->id]->has_stock => StockAvailability::OUT_OF_STOCK,
                $stock[$row->id]->above_reorder => StockAvailability::IN_STOCK,
                default => StockAvailability::LIMITED_STOCK,
            },
            'image_url' => isset($media[$row->id], $files[$media[$row->id][0]->file_id]) ? $this->files->temporaryUrl($files[$media[$row->id][0]->file_id])['url'] : null,
            'image_alt' => $media[$row->id][0]->alt_text ?? null,
        ])->all(), 'meta' => $this->meta($page, $total, ['status_counts' => (object) $counts])];
    }

    /** @param array<string, mixed> $filters */
    private function buyerScope(array $filters): Builder
    {
        $query = DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')->leftJoin('user_profiles as up', 'up.user_id', '=', 'u.id');
        if (! empty($filters['q'])) {
            $term = self::like((string) $filters['q']);
            $query->where(fn (Builder $search) => $search->whereRaw('lower(coalesce(up.full_name, u.name)) LIKE ?', [$term])->orWhereRaw('lower(u.email) LIKE ?', [$term])
                ->orWhereRaw("lower(coalesce(b.company_name, '')) LIKE ?", [$term]));
        }
        if (! empty($filters['buyer_type'])) {
            $query->where('b.buyer_type', $filters['buyer_type']);
        }

        return PortalDateRange::apply($query, 'u.created_at', $filters);
    }

    /** @param array<string, mixed> $filters */
    private function vendorScope(array $filters): Builder
    {
        $query = DB::table('vendor_organizations as o')->leftJoin('addresses as address', fn ($join) => $join->on('address.owner_id', '=', 'o.id')->where('address.owner_type', 'VENDOR_ORGANIZATION')->where('address.is_current', true));
        if (! empty($filters['q'])) {
            $term = self::like((string) $filters['q']);
            $query->where(fn (Builder $search) => $search->whereRaw('lower(o.store_name) LIKE ?', [$term])->orWhereRaw("lower(coalesce(o.legal_business_name, o.legal_name, '')) LIKE ?", [$term])
                ->orWhereRaw("lower(coalesce({$this->ownerSql('name')}, '')) LIKE ?", [$term])->orWhereRaw("lower(coalesce({$this->ownerSql('email')}, '')) LIKE ?", [$term]));
        }
        if (! empty($filters['verification'])) {
            $query->where('o.store_verification_status', $filters['verification']);
        }
        if (! empty($filters['discoverability'])) {
            $query->where('o.marketplace_discoverability_status', $filters['discoverability']);
        }

        return PortalDateRange::apply($query, 'o.created_at', $filters);
    }

    /** First active Owner of the store; the correlated subquery cannot duplicate a store row. */
    private function ownerSql(string $column): string
    {
        return "(SELECT u.{$column} FROM vendor_memberships m JOIN users u ON u.id = m.user_id WHERE m.vendor_organization_id = o.id AND m.role = 'OWNER' AND m.status = 'ACTIVE' ORDER BY m.created_at, m.id LIMIT 1)";
    }

    /**
     * @param  list<string>  $permissions
     * @param  array<string, mixed>  $filters
     * @param  array<string, mixed>  $meta
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    private function reviewPage(Builder $query, array $filters, array $permissions, array $meta): array
    {
        $total = (clone $query)->count();
        $page = $this->page($filters);
        $canSeeHidden = in_array('reviews.moderate', $permissions, true);
        $rows = $query->leftJoin('vendor_listings as l', 'l.id', '=', 'r.vendor_listing_id')->orderByDesc('r.submitted_at')->orderByDesc('r.id')->forPage($page, self::PER_PAGE)
            ->get(['r.*', 'o.reference as order_reference', 'v.store_name', 'l.display_name as product_name']);

        return ['items' => $rows->map(function (object $review) use ($canSeeHidden): array {
            $hidden = in_array($review->moderation_state, ReviewRules::HIDDEN_STATES, true);

            return ['id' => (string) $review->id, 'type' => (string) $review->review_type, 'ratings' => $this->presenter->ratings($review),
                // Hidden or removed text stays with the moderators who can already read it.
                'comment' => $hidden && ! $canSeeHidden ? null : $review->comment, 'author_name' => (string) ($review->public_display_name ?? ''), 'order_reference' => (string) $review->order_reference,
                'store_name' => (string) $review->store_name, 'product_name' => $review->product_name, 'moderation_state' => (string) $review->moderation_state,
                'visibility' => $this->presenter->visibility($review), 'submitted_at' => self::iso($review->submitted_at)];
        })->all(), 'meta' => $this->meta($page, $total, $meta + ['can_moderate' => $canSeeHidden])];
    }

    /**
     * @param  list<string>  $permissions
     * @return list<array<string, mixed>>
     */
    private function sanctions(string $type, string $subjectId, array $permissions): array
    {
        if (! in_array('enforcement.view', $permissions, true)) {
            return [];
        }

        return DB::table('enforcement_actions')->where('subject_type', $type)->where('subject_id', $subjectId)->orderByDesc('created_at')->orderByDesc('id')->limit(5)
            ->get(['id', 'action', 'state', 'reason', 'created_at', 'expires_at'])->map(static fn (object $row): array => ['id' => (string) $row->id, 'action' => (string) $row->action, 'action_label' => EnforcementService::label((string) $row->action),
                'state' => (string) $row->state, 'reason' => (string) $row->reason, 'created_at' => self::iso($row->created_at), 'expires_at' => self::iso($row->expires_at)])->all();
    }

    private function buyerRow(string $id): object
    {
        $row = ! Str::isUuid($id) ? null : DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')->leftJoin('user_profiles as up', 'up.user_id', '=', 'u.id')->where('b.id', $id)
            ->first(['b.id', 'b.user_id', 'b.buyer_type', 'b.company_name', 'b.position_title', 'b.industry_classification', 'b.industry_other_label', 'b.onboarding_status', 'u.email', 'u.email_verified_at', 'u.account_status',
                'u.account_deleted_at', 'u.last_authenticated_at', 'u.created_at as joined_at', 'u.public_id', 'u.lock_version', 'u.profile_photo_key', 'u.profile_photo_disk',
                'up.mobile_e164', DB::raw('coalesce(up.full_name, u.name) AS display_name')]);
        if ($row === null) {
            throw new AuthenticationException('USER_NOT_FOUND', 'This Buyer is unavailable.', 404);
        }

        return $row;
    }

    private function vendorRow(string $id): object
    {
        $row = ! Str::isUuid($id) ? null : DB::table('vendor_organizations')->where('id', $id)->first();
        if ($row === null) {
            throw new AuthenticationException('USER_NOT_FOUND', 'This Vendor is unavailable.', 404);
        }

        return $row;
    }

    /** A Buyer who deleted their account keeps only a masked address in the directory. */
    private function buyerEmail(object $row): string
    {
        return $row->account_status === 'DELETED' ? EnforcementService::maskEmail((string) $row->email) : (string) $row->email;
    }

    /** @param array<string, mixed> $filters */
    private function page(array $filters): int
    {
        return max(1, min(1000, (int) ($filters['page'] ?? 1)));
    }

    /**
     * @param  array<string, mixed>  $extra
     * @return array<string, mixed>
     */
    private function meta(int $page, int $total, array $extra = []): array
    {
        return ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'last_page' => max(1, (int) ceil($total / self::PER_PAGE))] + $extra;
    }

    private static function like(string $term): string
    {
        return '%'.addcslashes(mb_strtolower(trim($term)), '%_\\').'%';
    }

    private static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }
}
