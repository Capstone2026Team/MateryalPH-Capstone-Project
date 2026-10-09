<?php

declare(strict_types=1);

namespace App\Domain\Reviews;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Scores\PublicScores;
use App\Models\User;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Read models: public product and store reviews for Buyers, the store's received reviews for authorized Vendor
 * members, and the Admin moderation queue. Lists are bounded pages; only visible reviews reach Buyers and Vendors.
 * Product ratings (MQS inputs) and Vendor ratings (VCS inputs) are always separate aggregates.
 */
final class ReviewQueries
{
    public const PER_PAGE = 20;

    public function __construct(private readonly ReviewAccess $access, private readonly ReviewPresenter $presenter, private readonly PublicScores $scores, private readonly CatalogFileStore $store) {}

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

    /**
     * @param  array{type?: string, page?: int}  $filters
     * @return array{items: list<array<string, mixed>>, meta: array<string, mixed>}
     */
    public function vendorReviews(Request $request, array $filters): array
    {
        $scope = $this->access->vendorScope($request, ReviewAccess::VIEW);
        $type = $filters['type'] ?? ReviewRules::VENDOR;
        $base = DB::table('reviews as r')->where('r.vendor_organization_id', $scope['organization_id'])->where('r.review_type', $type)->whereNotNull('r.submitted_at');
        if ($type !== ReviewRules::BUYER) {
            ReviewRules::constrainVisible($base);
        }
        $page = max(1, (int) ($filters['page'] ?? 1));
        $total = (clone $base)->count();
        $rows = (clone $base)->join('orders as o', 'o.id', '=', 'r.order_id')->orderByDesc('r.submitted_at')->orderByDesc('r.id')->forPage($page, self::PER_PAGE)->get(['r.*', 'o.reference as order_reference']);

        return ['items' => $rows->map(fn (object $review): array => ($type === ReviewRules::BUYER ? $this->presenter->own($review, 'VENDOR') : $this->presenter->public($review, 'VENDOR'))
            + ['order_id' => (string) $review->order_id, 'order_reference' => (string) $review->order_reference, 'can_report' => $type !== ReviewRules::BUYER && in_array(ReviewAccess::REPORT, $scope['permissions'], true)])->all(),
            'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'type' => $type]];
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
        match ($state) {
            'NEEDS_ACTION' => $query->where(fn (Builder $q) => $q->whereIn('r.moderation_state', ['FLAGGED', 'HIDDEN_PENDING_REVIEW'])
                ->orWhereExists(fn (Builder $flag) => $flag->selectRaw('1')->from('review_flags as f')->whereColumn('f.review_id', 'r.id')->where('f.state', 'OPEN'))),
            'ALL' => null,
            default => $query->where('r.moderation_state', $state),
        };
        $page = max(1, (int) ($filters['page'] ?? 1));
        $total = (clone $query)->count();
        $rows = $query->orderByDesc('r.updated_at')->orderByDesc('r.id')->forPage($page, self::PER_PAGE)->get(['r.*', 'o.reference as order_reference', 'vo.store_name']);
        $flags = DB::table('review_flags')->whereIn('review_id', $rows->pluck('id'))->where('state', 'OPEN')->groupBy('review_id')->selectRaw('review_id, count(*) AS total')->pluck('total', 'review_id');

        return ['items' => $rows->map(fn (object $review): array => [
            'id' => (string) $review->id, 'type' => $review->review_type, 'moderation_state' => $review->moderation_state, 'order_reference' => (string) $review->order_reference,
            'store_name' => (string) $review->store_name, 'display_name' => (string) $review->public_display_name, 'ratings' => $this->presenter->ratings($review), 'comment' => $review->comment,
            'open_flags' => (int) ($flags[$review->id] ?? 0), 'submitted_at' => ReviewPresenter::iso($review->submitted_at), 'updated_at' => ReviewPresenter::iso($review->updated_at),
        ])->all(), 'meta' => ['page' => $page, 'per_page' => self::PER_PAGE, 'total' => $total, 'state' => $state]];
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
            'author_display_rule' => $review->reviewer_party === 'VENDOR' ? 'Store name' : ($review->display_name_choice === 'VERIFIED_BUYER' ? 'Verified Buyer (reviewer chose the more restrictive name)' : 'First name and last initial'),
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
