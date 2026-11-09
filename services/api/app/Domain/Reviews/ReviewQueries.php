<?php

declare(strict_types=1);

namespace App\Domain\Reviews;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Scores\PublicScores;
use App\Models\User;
use App\Support\PortalDateRange;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Read models: public product and store reviews for Buyers, the store's received reviews for authorized Vendor
 * members, and the Admin moderation queue. Lists are bounded pages; only visible reviews reach Buyers and Vendors.
 * Product ratings (MQS inputs) and Vendor ratings (VCS inputs) are always separate aggregates.
 */
final class ReviewQueries
{
    public const PER_PAGE = 20;

    public function __construct(private readonly ReviewAccess $access, private readonly ReviewPresenter $presenter, private readonly PublicScores $scores, private readonly CatalogFileStore $store, private readonly BuyerRatingSummary $buyerRatings) {}

    /** @return array{items: list<array<string, mixed>>, meta: array<string, mixed>} */
    public function listingReviews(string $listingId, int $page): array
    {
        $listing = DB::table('vendor_listings')->where('id', ReviewAccess::uuid($listingId))->where('status', 'ACTIVE')->whereNull('removed_at')->first(['id']);
        if ($listing === null) {
            throw new AuthenticationException('LISTING_NOT_FOUND', 'This product is unavailable.', 404);
        }
        $base = ReviewRules::constrainVisible(DB::table('reviews as r')->where('r.vendor_listing_id', $listing->id)->where('r.review_type', ReviewRules::PRODUCT));
        $summary = (clone $base)->selectRaw('count(*) AS total, avg(r.rating)::numeric AS average')->first();
        $distribution = (clone $base)->groupBy('r.rating')->selectRaw('r.rating, count(*) AS total')->pluck('total', 'rating');

        return $this->page($base, $page, 'BUYER', [
            'summary' => ['count' => (int) $summary->total, 'average' => $summary->total > 0 ? PublicScores::round((string) $summary->average) : null, 'label' => $summary->total > 0 ? PublicScores::round((string) $summary->average).' of 5' : 'New',
                'distribution' => array_map(static fn (int $stars): array => ['stars' => $stars, 'count' => (int) ($distribution[$stars] ?? 0)], [5, 4, 3, 2, 1])],
        ]);
    }

    /** @return array{items: list<array<string, mixed>>, meta: array<string, mixed>} */
    public function storeReviews(string $vendorId, int $page): array
    {
        $organization = DB::table('vendor_organizations')->where('id', ReviewAccess::uuid($vendorId))->where('account_status', 'ACTIVE')->first(['id']);
        if ($organization === null) {
            throw new AuthenticationException('STORE_NOT_FOUND', 'This store is unavailable.', 404);
        }
        $base = ReviewRules::constrainVisible(DB::table('reviews as r')->where('r.vendor_organization_id', $organization->id)->where('r.review_type', ReviewRules::VENDOR));
        $summary = (clone $base)->selectRaw('count(*) AS total, avg(r.service_quality)::numeric AS service, avg(r.speed_rating)::numeric AS speed')->first();

        return $this->page($base, $page, 'BUYER', [
            'summary' => ['count' => (int) $summary->total, 'service_quality' => $summary->total > 0 ? PublicScores::round((string) $summary->service) : null,
                'speed' => $summary->total > 0 ? PublicScores::round((string) $summary->speed) : null],
            'scores' => $this->scores->forOrganization((string) $organization->id),
        ]);
    }

    /** @return array{items: list<array<string, mixed>>, meta: array<string, mixed>} */
    public function buyerRatings(Request $request, int $page): array
    {
        $profileId = $this->access->buyerProfileId($request);
        $base = ReviewRules::constrainVisible(DB::table('reviews as r')->join('orders as o', 'o.id', '=', 'r.order_id')
            ->where('r.buyer_profile_id', $profileId)->where('r.review_type', ReviewRules::BUYER)->where('o.order_state', 'COMPLETED'));
        $rows = (clone $base)->orderByDesc('r.submitted_at')->orderByDesc('r.id')->forPage($page, self::PER_PAGE)->get(['r.*', 'o.reference as order_reference']);

        return ['items' => $rows->map(fn (object $review): array => [
            'id' => (string) $review->id, 'store_name' => $this->presenter->authorName($review), 'order_id' => (string) $review->order_id,
            'order_reference' => (string) $review->order_reference, 'ratings' => $this->presenter->ratings($review), 'comment' => $review->comment,
            'submitted_at' => ReviewPresenter::iso($review->submitted_at),
        ])->all(), 'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => (clone $base)->count(), 'summary' => $this->buyerRatings->forProfiles([$profileId])[$profileId]]];
    }

    /**
     * @param  array{type?: string, page?: int, listing_id?: string, from?: string, to?: string}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function vendorReviews(Request $request, array $filters): array
    {
        $scope = $this->access->vendorScope($request, ReviewAccess::VIEW);
        $type = $filters['type'] ?? ReviewRules::VENDOR;
        $base = DB::table('reviews as r')->where('r.vendor_organization_id', $scope['organization_id'])->where('r.review_type', $type)->whereNotNull('r.submitted_at');
        if (isset($filters['listing_id'])) {
            $listing = DB::table('vendor_listings')->where('id', $filters['listing_id'])->where('vendor_organization_id', $scope['organization_id'])->first(['id']);
            if ($listing === null) {
                throw new AuthenticationException('LISTING_NOT_FOUND', 'This product is unavailable.', 404);
            }
            // Archived listings retain their received reviews and commercial history.
            $base->where('r.vendor_listing_id', $listing->id);
        }
        if ($type !== ReviewRules::BUYER) {
            ReviewRules::constrainVisible($base);
        }
        $page = max(1, (int) ($filters['page'] ?? 1));
        PortalDateRange::apply($base, 'r.submitted_at', $filters);
        $total = (clone $base)->count();
        $rows = (clone $base)->join('orders as o', 'o.id', '=', 'r.order_id')->leftJoin('users as author', 'author.id', '=', 'r.reviewer_user_id')
            ->orderByDesc('r.submitted_at')->orderByDesc('r.id')->forPage($page, self::PER_PAGE)->select(['r.*', 'o.reference as order_reference'])
            ->selectRaw('author.profile_photo_key IS NOT NULL AS buyer_has_photo')->get();

        $meta = ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'type' => $type];
        if ($type === ReviewRules::PRODUCT) {
            $summary = (clone $base)->selectRaw('count(*) AS total, avg(r.rating)::numeric AS average')->first();
            $distribution = (clone $base)->groupBy('r.rating')->selectRaw('r.rating, count(*) AS total')->pluck('total', 'rating');
            $meta['summary'] = ['count' => (int) $summary->total, 'average' => $summary->total > 0 ? (float) PublicScores::round((string) $summary->average) : null,
                'distribution' => array_map(static fn (int $stars): array => ['stars' => $stars, 'count' => (int) ($distribution[$stars] ?? 0)], [5, 4, 3, 2, 1])];
        }

        return ['items' => $rows->map(fn (object $review): array => $this->vendorRow($review, $scope['permissions']))->all(), 'meta' => $meta];
    }

    /** @return array<string, mixed> */
    public function vendorDetail(Request $request, string $reviewId): array
    {
        $scope = $this->access->vendorScope($request, ReviewAccess::VIEW);
        $base = DB::table('reviews as r')->where('r.id', ReviewAccess::uuid($reviewId))->where('r.vendor_organization_id', $scope['organization_id'])->whereNotNull('r.submitted_at');
        $base->where(function (Builder $query): void {
            $query->where('r.review_type', ReviewRules::BUYER)->orWhere(function (Builder $received): void {
                ReviewRules::constrainVisible($received);
            });
        });
        $review = $base->join('orders as o', 'o.id', '=', 'r.order_id')->leftJoin('users as author', 'author.id', '=', 'r.reviewer_user_id')
            ->select(['r.*', 'o.reference as order_reference'])->selectRaw('author.profile_photo_key IS NOT NULL AS buyer_has_photo')->first();
        if ($review === null) {
            throw new AuthenticationException('REVIEW_NOT_FOUND', 'This review is unavailable.', 404);
        }

        $row = $this->vendorRow($review, $scope['permissions']);
        if ($row['product'] !== null) {
            // Use current catalog media without changing the purchased name or variant snapshot.
            $image = DB::table('listing_media as m')->join('files as f', 'f.id', '=', 'm.file_id')
                ->where('m.vendor_listing_id', $review->vendor_listing_id)->where('m.status', 'READY')
                ->where('f.owner_type', 'VENDOR_ORGANIZATION')->where('f.owner_id', $scope['organization_id'])
                ->where('f.purpose', CatalogFileStore::LISTING_MEDIA)->where('f.scan_state', 'CLEAN')
                ->whereIn('f.content_type', ['image/jpeg', 'image/png', 'image/webp'])
                ->orderBy('m.sort_order')->orderBy('m.id')->first(['f.*']);
            $row['product']['image_url'] = $image === null ? null : $this->store->temporaryUrl($image)['url'];
        }

        return $row;
    }

    /**
     * @param  list<string>  $permissions
     * @return array<string, mixed>
     */
    private function vendorRow(object $review, array $permissions): array
    {
        $own = $review->review_type === ReviewRules::BUYER;
        $row = $own ? $this->presenter->own($review, 'VENDOR') : $this->presenter->public($review, 'VENDOR');
        $product = null;
        if ($review->review_type === ReviewRules::PRODUCT) {
            $line = DB::table('order_lines as ol')->leftJoin('listing_variants as v', 'v.id', '=', 'ol.listing_variant_id')->leftJoin('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
                ->where('ol.id', $review->order_line_id)->first(['ol.snapshot', 'l.display_name', 'v.label as variant_label']);
            $snapshot = json_decode((string) ($line->snapshot ?? '{}'), true);
            $snapshot = is_array($snapshot) ? $snapshot : [];
            $product = ['listing_id' => (string) $review->vendor_listing_id, 'name' => (string) ($snapshot['display_name'] ?? $line->display_name ?? 'Product'),
                'variant_label' => array_key_exists('variant_label', $snapshot) ? $snapshot['variant_label'] : $line?->variant_label];
            $row['variant_label'] = $product['variant_label'];
        }

        return $row + ['order_id' => (string) $review->order_id, 'order_reference' => (string) $review->order_reference, 'product' => $product,
            'can_report' => ! $own && in_array(ReviewAccess::REPORT, $permissions, true),
            'buyer_avatar_url' => ! $own && $this->buyerIdentityVisible($review) && $review->buyer_has_photo
                ? URL::temporarySignedRoute('reviews.vendor.buyer-photo', now()->addMinutes(ReviewPresenter::MEDIA_TTL_MINUTES), ['reviewId' => $review->id]) : null];
    }

    /** A named review grants only its current store's review readers access to the sanitized Buyer photo. */
    public function buyerPhoto(Request $request, string $reviewId): StreamedResponse
    {
        $scope = $this->access->vendorScope($request, ReviewAccess::VIEW);
        $review = ReviewRules::constrainVisible(DB::table('reviews as r')->where('r.id', ReviewAccess::uuid($reviewId))
            ->where('r.vendor_organization_id', $scope['organization_id'])->whereIn('r.review_type', [ReviewRules::VENDOR, ReviewRules::PRODUCT])->whereNotNull('r.submitted_at'))->first(['r.*']);
        $photo = $review !== null && $this->buyerIdentityVisible($review)
            ? DB::table('users')->where('id', $review->reviewer_user_id)->where('account_type', 'BUYER')->first(['profile_photo_key', 'profile_photo_disk']) : null;
        if ($photo?->profile_photo_key === null || ! Storage::disk($photo->profile_photo_disk)->exists($photo->profile_photo_key)) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This Buyer profile picture is unavailable.', 404);
        }

        return Storage::disk($photo->profile_photo_disk)->response($photo->profile_photo_key, null, ['Content-Type' => 'image/png', 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff']);
    }

    private function buyerIdentityVisible(object $review): bool
    {
        return $review->reviewer_party === 'BUYER' && $this->presenter->authorName($review) !== 'Reviewer unavailable';
    }

    /**
     * @param  array{state?: string, page?: int}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function moderationQueue(Request $request, array $filters): array
    {
        $this->access->admin($request, ReviewAccess::MODERATE);
        $state = $filters['state'] ?? 'NEEDS_ACTION';
        $query = DB::table('reviews as r')->join('orders as o', 'o.id', '=', 'r.order_id')->join('vendor_organizations as vo', 'vo.id', '=', 'r.vendor_organization_id')->whereNotNull('r.submitted_at');
        PortalDateRange::apply($query, 'r.submitted_at', $filters);
        $needsAction = fn (Builder $q) => $q->whereIn('r.moderation_state', ['FLAGGED', 'HIDDEN_PENDING_REVIEW'])
            ->orWhereExists(fn (Builder $flag) => $flag->selectRaw('1')->from('review_flags as f')->whereColumn('f.review_id', 'r.id')->where('f.state', 'OPEN'));
        $counts = array_fill_keys(['FLAGGED', 'HIDDEN_PENDING_REVIEW', 'CORRECTION_REQUESTED', 'REMOVED', 'NONE'], 0);
        foreach ((clone $query)->selectRaw('r.moderation_state, count(*) as total')->groupBy('r.moderation_state')->get() as $row) {
            $counts[$row->moderation_state] = (int) $row->total;
        }
        $counts['ALL'] = array_sum($counts);
        $counts['NEEDS_ACTION'] = (clone $query)->where($needsAction)->count();
        match ($state) {
            'NEEDS_ACTION' => $query->where($needsAction),
            'ALL' => null,
            default => $query->where('r.moderation_state', $state),
        };
        $page = max(1, (int) ($filters['page'] ?? 1));
        $total = (clone $query)->count();
        $rows = $query->orderByDesc('r.updated_at')->orderByDesc('r.id')->forPage($page, self::PER_PAGE)->get(['r.*', 'o.reference as order_reference', 'vo.store_name']);
        $flags = DB::table('review_flags')->whereIn('review_id', $rows->pluck('id'))->where('state', 'OPEN')->groupBy('review_id')->selectRaw('review_id, count(*) AS total')->pluck('total', 'review_id');

        return ['items' => $rows->map(fn (object $review): array => [
            'id' => (string) $review->id, 'type' => $review->review_type, 'moderation_state' => $review->moderation_state, 'order_reference' => (string) $review->order_reference,
            'store_name' => (string) $review->store_name, 'display_name' => $this->presenter->authorName($review), 'ratings' => $this->presenter->ratings($review), 'comment' => $review->comment,
            'open_flags' => (int) ($flags[$review->id] ?? 0), 'submitted_at' => ReviewPresenter::iso($review->submitted_at), 'updated_at' => ReviewPresenter::iso($review->updated_at),
        ])->all(), 'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'state' => $state, 'counts' => $counts]];
    }

    /** @return array<string, mixed> */
    public function moderationDetail(Request $request, string $reviewId): array
    {
        $this->access->admin($request, ReviewAccess::MODERATE);
        $review = DB::table('reviews')->where('id', ReviewAccess::uuid($reviewId))->whereNotNull('submitted_at')->first();
        if ($review === null) {
            throw new AuthenticationException('REVIEW_NOT_FOUND', 'This review is unavailable.', 404);
        }
        $order = DB::table('orders as o')->join('vendor_organizations as vo', 'vo.id', '=', 'o.vendor_organization_id')->where('o.id', $review->order_id)->first(['o.reference', 'o.closed_at', 'o.fulfillment_method', 'vo.store_name']);
        $case = DB::table('dispute_cases')->where('order_id', $review->order_id)->orderByDesc('created_at')->first(['id', 'reference', 'status']);

        return $this->presenter->own($review, 'ADMIN') + [
            'moderation_state' => $review->moderation_state,
            'reviewer_party' => $review->reviewer_party,
            'display_name_choice' => $review->display_name_choice,
            'author_display_rule' => $review->reviewer_party === 'VENDOR' ? 'Store name' : 'Full Buyer profile name',
            'verified_purchase' => ['order_id' => (string) $review->order_id, 'order_reference' => (string) $order->reference, 'store_name' => (string) $order->store_name, 'completed_at' => ReviewPresenter::iso($order->closed_at),
                'order_line_id' => $review->order_line_id, 'listing_id' => $review->vendor_listing_id],
            'related_dispute' => $case === null ? null : ['id' => (string) $case->id, 'reference' => (string) $case->reference, 'status' => (string) $case->status],
            'revisions' => DB::table('review_revisions')->where('review_id', $review->id)->orderBy('revision')->get()->map(static fn (object $revision): array => [
                'revision' => (int) $revision->revision, 'reason' => $revision->reason, 'content' => json_decode((string) $revision->content, true), 'created_at' => ReviewPresenter::iso($revision->created_at)])->all(),
            'flags' => DB::table('review_flags')->where('review_id', $review->id)->orderBy('created_at')->get()->map(static fn (object $flag): array => [
                'id' => (string) $flag->id, 'reporter_party' => $flag->reporter_party, 'reason_code' => $flag->reason_code, 'details' => $flag->details, 'state' => $flag->state, 'created_at' => ReviewPresenter::iso($flag->created_at)])->all(),
            'history' => DB::table('review_moderation as m')->leftJoin('users as u', 'u.id', '=', 'm.actor_user_id')->where('m.review_id', $review->id)->whereNotNull('m.action')->orderBy('m.created_at')->orderBy('m.id')
                ->get(['m.action', 'm.from_state', 'm.to_state', 'm.reason', 'm.actor_role', 'm.created_at'])->map(static fn (object $entry): array => [
                    'action' => $entry->action, 'from_state' => $entry->from_state, 'to_state' => $entry->to_state, 'reason' => $entry->reason, 'actor_role' => $entry->actor_role, 'at' => ReviewPresenter::iso($entry->created_at)])->all(),
            'available_actions' => ReviewModerationService::actionsFor((string) $review->moderation_state),
        ];
    }

    /** Streams one review photo after re-authorizing the signed-in caller for that review. */
    public function media(User $user, string $reviewId, string $mediaId): StreamedResponse
    {
        $review = DB::table('reviews')->where('id', ReviewAccess::uuid($reviewId))->first();
        $allowed = $review !== null && match ($user->account_type) {
            'BUYER' => (int) $review->reviewer_user_id === (int) $user->getKey() || $this->presenter->visible($review),
            'VENDOR' => $this->vendorMayView($user, $review),
            'ADMIN' => in_array(ReviewAccess::MODERATE, app(AccountAccess::class)->resolve($user)['permissions'], true),
            default => false,
        };
        $media = $allowed ? DB::table('review_media')->where('review_id', $review->id)->where('id', ReviewAccess::uuid($mediaId))->whereNull('retired_at')->first() : null;
        $file = $media === null ? null : DB::table('files')->where('id', $media->file_id)->where('owner_type', 'ORDER')->where('owner_id', $review->order_id)->where('visibility', 'PRIVATE')->where('scan_state', 'CLEAN')->first();
        if ($file === null) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This attachment is unavailable.', 404);
        }
        $metadata = json_decode((string) ($file->metadata ?? '{}'), true) ?: [];
        $stream = Storage::disk(is_string($metadata['disk'] ?? null) ? $metadata['disk'] : $this->store->privateDisk())->readStream($file->object_key);
        if (! is_resource($stream)) {
            throw new AuthenticationException('FILE_UNAVAILABLE', 'The attachment is temporarily unavailable.', 503);
        }

        return response()->streamDownload(static function () use ($stream): void {
            fpassthru($stream);
            fclose($stream);
        }, 'review-media', ['Content-Type' => $file->content_type, 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff', 'Content-Disposition' => 'inline']);
    }

    private function vendorMayView(User $user, object $review): bool
    {
        $scope = app(AccountAccess::class)->resolve($user);

        return $scope['organization_id'] === $review->vendor_organization_id && in_array(ReviewAccess::VIEW, $scope['permissions'], true) && $this->presenter->visible($review);
    }

    /**
     * @param  array<string, mixed>  $meta
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    private function page(Builder $base, int $page, string $audience, array $meta): array
    {
        $page = max(1, $page);
        $total = (clone $base)->count();
        $rows = (clone $base)->orderByDesc('r.submitted_at')->orderByDesc('r.id')->forPage($page, self::PER_PAGE)->get(['r.*']);

        return ['items' => $rows->map(fn (object $review): array => $this->presenter->public($review, $audience))->all(), 'meta' => $meta + ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total]];
    }
}
