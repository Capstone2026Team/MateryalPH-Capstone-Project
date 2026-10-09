<?php

declare(strict_types=1);

namespace App\Domain\Reviews;

use App\Domain\Catalog\CatalogAccess;
use App\Domain\Disputes\DisputeRules;
use App\Domain\Fulfillment\OrderEvidenceFiles;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderStates;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Throwable;

/**
 * Verified-purchase review lifecycle. Only a COMPLETED order opens a 14-day window. The Buyer gives one Vendor rating
 * (Service Quality plus Delivery or Processing Speed) and one Product Review per purchased line; the Vendor gives one
 * Buyer rating (CCS). Every submission and edit appends an immutable revision; the author may edit for 24 hours, or
 * once within 7 days after an Admin requests a correction. Both sides stay hidden until both parties have submitted
 * or the window expires (reveal happens under the order's window lock, so two concurrent submissions reveal once).
 * Visibility and score eligibility additionally exclude moderation-hidden reviews, orders with an active dispute and
 * Admin-excluded orders. Nothing here deletes a review; a Vendor can only report one.
 */
final class ReviewService
{
    public function __construct(
        private readonly ReviewAccess $access,
        private readonly CatalogAccess $keys,
        private readonly AuditRecorder $audit,
        private readonly OrderEvidenceFiles $files,
        private readonly ReviewMediaFiles $mediaFiles,
        private readonly ReviewPresenter $presenter,
    ) {}

    /** @return array<string, mixed> */
    public function buyerOrder(Request $request, string $orderId): array
    {
        $order = $this->access->buyerOrder($request, $orderId);
        $window = $this->ensureWindow($order);

        return $this->presenter->buyerOrder($order, $window, (int) $request->user()->getKey());
    }

    /** @return array<string, mixed> */
    public function vendorOrder(Request $request, string $orderId): array
    {
        $scope = $this->access->vendorScope($request, ReviewAccess::VIEW);
        $order = $this->access->vendorOrder($scope['organization_id'], $orderId);
        $window = $this->ensureWindow($order);

        return $this->presenter->vendorOrder($order, $window, $scope);
    }

    /**
     * Buyer submission: any not-yet-submitted subset of the Vendor rating and line reviews, once each.
     *
     * @param  array{display_name_choice: string, vendor_rating?: ?array{service_quality: int, speed_rating: int, comment?: ?string}, product_reviews?: list<array{order_line_id: string, rating: int, comment?: ?string}>}  $input
     * @return array<string, mixed>
     */
    public function submitBuyer(Request $request, string $orderId, array $input): array
    {
        $key = $this->keys->requireIdempotencyKey($request);
        $profileId = $this->access->buyerProfileId($request);
        $userId = (int) $request->user()->getKey();
        if (($input['vendor_rating'] ?? null) === null && ($input['product_reviews'] ?? []) === []) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Rate the Vendor or at least one purchased product.', 422);
        }
        DB::transaction(function () use ($request, $orderId, $input, $key, $profileId, $userId): void {
            if ($this->keys->replayed($request, 'REVIEW_SUBMIT_BUYER', $key, $orderId)) {
                return;
            }
            $order = $this->access->buyerOrder($request, $orderId, true);
            $window = $this->lockOpenWindow($order);
            $name = ReviewRules::publicName($this->fullName($userId), $input['display_name_choice']);
            $now = CarbonImmutable::now();
            $created = [];
            if (($input['vendor_rating'] ?? null) !== null) {
                if (DB::table('reviews')->where('order_id', $order->id)->where('review_type', ReviewRules::VENDOR)->exists()) {
                    throw new AuthenticationException('REVIEW_ALREADY_SUBMITTED', 'You already rated this Vendor for this order. You can edit it within 24 hours of submitting.', 409);
                }
                $rating = $input['vendor_rating'];
                $created[] = $this->insert($order, ReviewRules::VENDOR, $userId, 'BUYER', 'BUYER', $profileId, $now, [
                    'service_quality' => (int) $rating['service_quality'], 'speed_rating' => (int) $rating['speed_rating'], 'speed_kind' => ReviewRules::speedKind((string) $order->fulfillment_method),
                    'comment' => self::comment($rating['comment'] ?? null), 'display_name_choice' => $input['display_name_choice'], 'public_display_name' => $name,
                ]);
            }
            $seen = [];
            foreach ($input['product_reviews'] ?? [] as $review) {
                $lineId = (string) $review['order_line_id'];
                if (isset($seen[$lineId])) {
                    throw new AuthenticationException('VALIDATION_FAILED', 'Each purchased line can be reviewed once.', 422);
                }
                $seen[$lineId] = true;
                $line = DB::table('order_lines as ol')->join('listing_variants as v', 'v.id', '=', 'ol.listing_variant_id')->where('ol.order_id', $order->id)
                    ->where('ol.id', ReviewAccess::uuid($lineId))->where('ol.quantity', '>', 0)->first(['ol.id', 'v.vendor_listing_id']);
                if ($line === null) {
                    throw new AuthenticationException('REVIEW_LINE_INELIGIBLE', 'Only purchased lines of this completed order can be reviewed.', 422, ['order_line_id' => $lineId]);
                }
                if (DB::table('reviews')->where('order_id', $order->id)->where('review_type', ReviewRules::PRODUCT)->where('order_line_id', $line->id)->exists()) {
                    throw new AuthenticationException('REVIEW_ALREADY_SUBMITTED', 'You already reviewed this product for this order.', 409, ['order_line_id' => $lineId]);
                }
                $created[] = $this->insert($order, ReviewRules::PRODUCT, $userId, 'BUYER', 'BUYER', $profileId, $now, [
                    'order_line_id' => $line->id, 'vendor_listing_id' => $line->vendor_listing_id, 'rating' => (int) $review['rating'], 'comment' => self::comment($review['comment'] ?? null),
                    'display_name_choice' => $input['display_name_choice'], 'public_display_name' => $name,
                ]);
            }
            $this->revealIfReady($window, $now);
            $this->keys->claim($request, 'REVIEW_SUBMIT_BUYER', $key, $orderId, 201);
            $this->audit->account($request, 'REVIEW_SUBMITTED', 'ORDER', (string) $order->id, after: ['reviews' => $created, 'party' => 'BUYER']);
        });

        return $this->buyerOrder($request, $orderId);
    }

    /**
     * @param  array{inquiry_seriousness: int, communication_quality: int, payment_reliability: int, comment?: ?string}  $input
     * @return array<string, mixed>
     */
    public function submitVendor(Request $request, string $orderId, array $input): array
    {
        $key = $this->keys->requireIdempotencyKey($request);
        $scope = $this->access->vendorScope($request, ReviewAccess::RATE_BUYER);
        $userId = (int) $request->user()->getKey();
        DB::transaction(function () use ($request, $orderId, $input, $key, $scope, $userId): void {
            if ($this->keys->replayed($request, 'REVIEW_SUBMIT_VENDOR', $key, $orderId)) {
                return;
            }
            $order = $this->access->vendorOrder($scope['organization_id'], $orderId, true);
            $window = $this->lockOpenWindow($order);
            if (DB::table('reviews')->where('order_id', $order->id)->where('review_type', ReviewRules::BUYER)->exists()) {
                throw new AuthenticationException('REVIEW_ALREADY_SUBMITTED', 'Your store already rated this Buyer for this order. It can be edited within 24 hours of submitting.', 409);
            }
            $now = CarbonImmutable::now();
            $storeName = (string) (DB::table('store_profiles')->where('vendor_organization_id', $order->vendor_organization_id)->value('public_store_name')
                ?? DB::table('vendor_organizations')->where('id', $order->vendor_organization_id)->value('store_name'));
            $id = $this->insert($order, ReviewRules::BUYER, $userId, 'VENDOR', $scope['role'], (string) $order->buyer_profile_id, $now, [
                'inquiry_seriousness' => (int) $input['inquiry_seriousness'], 'communication_quality' => (int) $input['communication_quality'], 'payment_reliability' => (int) $input['payment_reliability'],
                'comment' => self::comment($input['comment'] ?? null), 'display_name_choice' => 'STORE_NAME', 'public_display_name' => mb_substr($storeName, 0, 80),
            ]);
            $this->revealIfReady($window, $now);
            $this->keys->claim($request, 'REVIEW_SUBMIT_VENDOR', $key, $orderId, 201);
            $this->audit->account($request, 'REVIEW_SUBMITTED', 'ORDER', (string) $order->id, after: ['reviews' => [$id], 'party' => 'VENDOR']);
        });

        return $this->vendorOrder($request, $orderId);
    }

    /**
     * The author's correction: within 24 hours of submission, or once within 7 days after an Admin request.
     *
     * @param  array<string, mixed>  $input
     * @return array<string, mixed>
     */
    public function edit(Request $request, string $party, string $reviewId, array $input): array
    {
        $userId = (int) $request->user()->getKey();
        $scope = $party === 'VENDOR' ? $this->access->vendorScope($request, ReviewAccess::RATE_BUYER) : null;
        $orderId = DB::transaction(function () use ($request, $party, $reviewId, $input, $userId, $scope): string {
            $review = $this->ownReview($request, $party, $reviewId, $scope, true);
            if ((int) $review->lock_version !== (int) $input['lock_version']) {
                throw new AuthenticationException('REVIEW_VERSION_CONFLICT', 'This review changed since you opened it. Refresh and try again.', 409);
            }
            $now = CarbonImmutable::now();
            $correction = $review->moderation_state === 'CORRECTION_REQUESTED';
            if ($correction) {
                if ($review->corrected_at !== null || $review->correction_due_at === null || $now->greaterThanOrEqualTo(CarbonImmutable::parse((string) $review->correction_due_at))) {
                    throw new AuthenticationException('REVIEW_CORRECTION_CLOSED', 'The correction period for this review has ended.', 409);
                }
            } elseif ($review->editable_until === null || $now->greaterThanOrEqualTo(CarbonImmutable::parse((string) $review->editable_until))) {
                throw new AuthenticationException('REVIEW_LOCKED', 'Reviews can be corrected only within 24 hours of submitting. This review is now locked.', 409);
            } elseif (in_array($review->moderation_state, ReviewRules::HIDDEN_STATES, true)) {
                throw new AuthenticationException('REVIEW_UNDER_MODERATION', 'This review is under moderation and cannot be edited now.', 409);
            }
            $fields = match ($review->review_type) {
                ReviewRules::VENDOR => ['service_quality', 'speed_rating', 'comment'],
                ReviewRules::PRODUCT => ['rating', 'comment'],
                default => ['inquiry_seriousness', 'communication_quality', 'payment_reliability', 'comment'],
            };
            $update = [];
            foreach ($fields as $field) {
                if (array_key_exists($field, $input)) {
                    $update[$field] = $field === 'comment' ? self::comment($input[$field]) : (int) $input[$field];
                }
            }
            if ($update === []) {
                throw new AuthenticationException('VALIDATION_FAILED', 'Change at least one rating or the comment.', 422);
            }
            $update += ['edited_at' => $now, 'revision' => (int) $review->revision + 1, 'lock_version' => (int) $review->lock_version + 1, 'updated_at' => $now];
            if ($correction) {
                $update += ['corrected_at' => $now, 'moderation_state' => 'HIDDEN_PENDING_REVIEW'];
            }
            DB::table('reviews')->where('id', $review->id)->update($update);
            $after = DB::table('reviews')->where('id', $review->id)->first();
            $this->revision($after, $userId, $correction ? 'CORRECTED' : 'EDITED');
            if ($correction) {
                DB::table('review_moderation')->insert(['id' => (string) Str::uuid7(), 'review_id' => $review->id, 'actor_user_id' => $userId, 'action' => 'CORRECTION_SUBMITTED',
                    'from_state' => 'CORRECTION_REQUESTED', 'to_state' => 'HIDDEN_PENDING_REVIEW', 'reason' => 'Author submitted the requested correction.', 'actor_role' => $party,
                    'payload' => json_encode(['revision' => (int) $after->revision], JSON_THROW_ON_ERROR), 'correlation_id' => (string) $request->attributes->get('correlation_id'), 'created_at' => $now, 'updated_at' => $now]);
            }
            $this->audit->account($request, $correction ? 'REVIEW_CORRECTED' : 'REVIEW_EDITED', 'REVIEW', (string) $review->id, after: ['revision' => (int) $after->revision]);

            return (string) $review->order_id;
        });

        return $party === 'VENDOR' ? $this->vendorOrder($request, $orderId) : $this->buyerOrder($request, $orderId);
    }

    /**
     * Adds up to three photos or videos to the Buyer's own Product Review while it can still be edited.
     *
     * @param  list<UploadedFile>  $uploads
     * @return array<string, mixed>
     */
    public function addMedia(Request $request, string $reviewId, array $uploads): array
    {
        $key = $this->keys->requireIdempotencyKey($request);
        $peek = $this->ownReview($request, 'BUYER', $reviewId, null, false);
        if ($peek->review_type !== ReviewRules::PRODUCT) {
            throw new AuthenticationException('REVIEW_MEDIA_NOT_ALLOWED', 'Media can be added to Product Reviews only.', 422);
        }
        if ($this->keys->replayed($request, 'REVIEW_MEDIA_ADD', $key, $reviewId)) {
            return $this->buyerOrder($request, (string) $peek->order_id);
        }
        $this->assertEditable($peek);
        $userId = (int) $request->user()->getKey();
        $stored = [];
        $attached = false;
        try {
            foreach ($uploads as $upload) {
                $stored[] = $this->mediaFiles->store($upload, (string) $peek->order_id, $userId);
            }
            DB::transaction(function () use ($request, $reviewId, $key, $stored, $userId, &$attached): void {
                if ($this->keys->replayed($request, 'REVIEW_MEDIA_ADD', $key, $reviewId)) {
                    return;
                }
                $review = $this->ownReview($request, 'BUYER', $reviewId, null, true);
                $this->assertEditable($review);
                $existing = DB::table('review_media')->where('review_id', $review->id)->whereNull('retired_at')->count();
                if ($existing + count($stored) > ReviewRules::MEDIA_MAX) {
                    throw new AuthenticationException('VALIDATION_FAILED', 'A Product Review can have up to three attachments.', 422, ['files' => ['A Product Review can have up to three attachments.']]);
                }
                foreach ($stored as $index => $fileId) {
                    DB::table('review_media')->insert(['id' => (string) Str::uuid7(), 'review_id' => $review->id, 'actor_user_id' => $userId, 'file_id' => $fileId, 'sort_order' => $existing + $index,
                        'payload' => json_encode(['kind' => str_starts_with((string) DB::table('files')->where('id', $fileId)->value('content_type'), 'video/') ? 'VIDEO' : 'PHOTO'], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                }
                DB::table('reviews')->where('id', $review->id)->update(['revision' => (int) $review->revision + 1, 'lock_version' => (int) $review->lock_version + 1, 'edited_at' => now(), 'updated_at' => now()]);
                $this->revision(DB::table('reviews')->where('id', $review->id)->first(), $userId, 'EDITED');
                $this->keys->claim($request, 'REVIEW_MEDIA_ADD', $key, $reviewId, 200);
                $this->audit->account($request, 'REVIEW_MEDIA_ADDED', 'REVIEW', (string) $review->id, after: ['files' => count($stored)]);
                $attached = true;
            });
        } catch (Throwable $exception) {
            $this->files->discard($stored);
            throw $exception;
        }

        if (! $attached) {
            $this->files->discard($stored);
        }

        return $this->buyerOrder($request, (string) $peek->order_id);
    }

    /** @return array<string, mixed> */
    public function removeMedia(Request $request, string $reviewId, string $mediaId): array
    {
        $orderId = DB::transaction(function () use ($request, $reviewId, $mediaId): string {
            $review = $this->ownReview($request, 'BUYER', $reviewId, null, true);
            $this->assertEditable($review);
            $updated = DB::table('review_media')->where('review_id', $review->id)->where('id', ReviewAccess::uuid($mediaId))->whereNull('retired_at')->update(['retired_at' => now(), 'updated_at' => now()]);
            if ($updated === 0) {
                throw new AuthenticationException('REVIEW_MEDIA_NOT_FOUND', 'This attachment is unavailable.', 404);
            }
            DB::table('reviews')->where('id', $review->id)->update(['revision' => (int) $review->revision + 1, 'lock_version' => (int) $review->lock_version + 1, 'edited_at' => now(), 'updated_at' => now()]);
            $this->revision(DB::table('reviews')->where('id', $review->id)->first(), (int) $request->user()->getKey(), 'EDITED');
            $this->audit->account($request, 'REVIEW_MEDIA_REMOVED', 'REVIEW', (string) $review->id, after: ['media_id' => $mediaId]);

            return (string) $review->order_id;
        });

        return $this->buyerOrder($request, $orderId);
    }

    /**
     * Report Review: any signed-in Buyer for a public review, or a Vendor member with reviews.report for a review of
     * their store. A report never hides or deletes anything; it sends the review to the moderation queue.
     *
     * @param  array{reason_code: string, details?: ?string}  $input
     */
    public function flag(Request $request, string $party, string $reviewId, array $input): void
    {
        $key = $this->keys->requireIdempotencyKey($request);
        $scope = $party === 'VENDOR' ? $this->access->vendorScope($request, ReviewAccess::REPORT) : null;
        if ($party === 'BUYER') {
            $this->access->buyerProfileId($request);
        }
        DB::transaction(function () use ($request, $party, $reviewId, $input, $key, $scope): void {
            if ($this->keys->replayed($request, 'REVIEW_FLAG', $key, $reviewId)) {
                return;
            }
            $query = DB::table('reviews as r')->where('r.id', ReviewAccess::uuid($reviewId))->whereIn('r.review_type', [ReviewRules::VENDOR, ReviewRules::PRODUCT]);
            if ($party === 'VENDOR') {
                $query->where('r.vendor_organization_id', $scope['organization_id']);
            } else {
                ReviewRules::constrainVisible($query);
            }
            $review = $query->lockForUpdate()->first(['r.*']);
            if ($review === null) {
                throw new AuthenticationException('REVIEW_NOT_FOUND', 'This review is unavailable.', 404);
            }
            $userId = (int) $request->user()->getKey();
            if ((int) $review->reviewer_user_id === $userId) {
                throw new AuthenticationException('REVIEW_FLAG_OWN', 'You cannot report your own review.', 422);
            }
            if (DB::table('review_flags')->where('review_id', $review->id)->where('reporter_user_id', $userId)->exists()) {
                throw new AuthenticationException('REVIEW_ALREADY_REPORTED', 'You already reported this review. Our team will review it.', 409);
            }
            $flagId = (string) Str::uuid7();
            DB::table('review_flags')->insert(['id' => $flagId, 'review_id' => $review->id, 'reporter_user_id' => $userId, 'reporter_party' => $party, 'reason_code' => $input['reason_code'],
                'details' => isset($input['details']) ? mb_substr(trim((string) $input['details']), 0, 1000) : null, 'state' => 'OPEN', 'created_at' => now(), 'updated_at' => now()]);
            $to = $review->moderation_state === 'NONE' ? 'FLAGGED' : (string) $review->moderation_state;
            if ($to !== $review->moderation_state) {
                DB::table('reviews')->where('id', $review->id)->update(['moderation_state' => $to, 'lock_version' => (int) $review->lock_version + 1, 'updated_at' => now()]);
            }
            DB::table('review_moderation')->insert(['id' => (string) Str::uuid7(), 'review_id' => $review->id, 'actor_user_id' => $userId, 'action' => 'FLAG_RAISED', 'from_state' => $review->moderation_state,
                'to_state' => $to, 'reason' => $input['reason_code'], 'actor_role' => $party === 'VENDOR' ? $scope['role'] : 'BUYER', 'review_flag_id' => $flagId,
                'payload' => json_encode([], JSON_THROW_ON_ERROR), 'correlation_id' => (string) $request->attributes->get('correlation_id'), 'created_at' => now(), 'updated_at' => now()]);
            $this->keys->claim($request, 'REVIEW_FLAG', $key, $reviewId, 201);
            $this->audit->account($request, 'REVIEW_REPORTED', 'REVIEW', (string) $review->id, after: ['reason_code' => $input['reason_code']]);
        });
    }

    /**
     * Opens windows for completed orders that lack one and reveals every window whose 14 days have elapsed.
     *
     * @return array{opened: int, revealed: int}
     */
    public function sweep(int $limit = 500): array
    {
        $counts = ['opened' => 0, 'revealed' => 0];
        $missing = DB::table('orders as o')->where('o.order_state', OrderStates::COMPLETED)->whereNotNull('o.closed_at')
            ->whereNotExists(fn ($q) => $q->selectRaw('1')->from('review_windows as w')->whereColumn('w.order_id', 'o.id'))->limit($limit)->get();
        foreach ($missing as $order) {
            $counts['opened'] += $this->ensureWindow($order) !== null ? 1 : 0;
        }
        $expired = DB::table('review_windows')->whereNull('revealed_at')->where('closes_at', '<=', now())->orderBy('closes_at')->limit($limit)->pluck('id');
        foreach ($expired as $windowId) {
            $counts['revealed'] += DB::transaction(function () use ($windowId): int {
                $window = DB::table('review_windows')->where('id', $windowId)->lockForUpdate()->first();
                if ($window === null || $window->revealed_at !== null) {
                    return 0;
                }
                $this->reveal($window, CarbonImmutable::now(), 'WINDOW_EXPIRED');

                return 1;
            });
        }

        return $counts;
    }

    /** The order's review window, created idempotently once the order is COMPLETED; null before completion. */
    public function ensureWindow(object $order): ?object
    {
        if ($order->order_state !== OrderStates::COMPLETED || $order->closed_at === null) {
            return DB::table('review_windows')->where('order_id', $order->id)->first();
        }
        $completed = CarbonImmutable::parse((string) $order->closed_at);
        DB::table('review_windows')->insertOrIgnore(['id' => (string) Str::uuid7(), 'order_id' => $order->id, 'vendor_organization_id' => $order->vendor_organization_id,
            'buyer_profile_id' => $order->buyer_profile_id, 'completed_at' => $completed, 'closes_at' => ReviewRules::closesAt($completed), 'created_at' => now(), 'updated_at' => now()]);

        return DB::table('review_windows')->where('order_id', $order->id)->first();
    }

    private function lockOpenWindow(object $order): object
    {
        if ($order->order_state !== OrderStates::COMPLETED) {
            throw new AuthenticationException('REVIEW_NOT_ELIGIBLE', 'Ratings open when the order is completed.', 409, ['order_state' => $order->order_state]);
        }
        $this->ensureWindow($order);
        $window = DB::table('review_windows')->where('order_id', $order->id)->lockForUpdate()->first();
        if ($window === null || now()->greaterThanOrEqualTo($window->closes_at)) {
            throw new AuthenticationException('REVIEW_WINDOW_CLOSED', 'The 14-day rating period for this order has ended.', 409);
        }

        return $window;
    }

    private function revealIfReady(object $window, CarbonImmutable $now): void
    {
        if ($window->revealed_at !== null) {
            // Already public: later submissions inside the window become visible at once.
            DB::table('reviews')->where('order_id', $window->order_id)->whereNotNull('submitted_at')->whereNull('revealed_at')->update(['revealed_at' => $now]);

            return;
        }
        $buyer = DB::table('reviews')->where('order_id', $window->order_id)->where('review_type', ReviewRules::VENDOR)->whereNotNull('submitted_at')->exists();
        $vendor = DB::table('reviews')->where('order_id', $window->order_id)->where('review_type', ReviewRules::BUYER)->whereNotNull('submitted_at')->exists();
        if ($buyer && $vendor) {
            $this->reveal($window, $now, 'BOTH_SUBMITTED');
        }
    }

    private function reveal(object $window, CarbonImmutable $now, string $reason): void
    {
        DB::table('review_windows')->where('id', $window->id)->update(['revealed_at' => $now, 'reveal_reason' => $reason, 'updated_at' => $now]);
        DB::table('reviews')->where('order_id', $window->order_id)->whereNotNull('submitted_at')->whereNull('revealed_at')->update(['revealed_at' => $now]);
    }

    /** @param array<string, mixed> $content */
    private function insert(object $order, string $type, int $userId, string $party, string $role, string $buyerProfileId, CarbonImmutable $now, array $content): string
    {
        $id = (string) Str::uuid7();
        DB::table('reviews')->insert($content + [
            'id' => $id, 'order_id' => $order->id, 'reviewer_user_id' => $userId, 'review_type' => $type, 'reviewer_party' => $party, 'reviewer_role' => $role,
            'vendor_organization_id' => $order->vendor_organization_id, 'buyer_profile_id' => $buyerProfileId, 'submitted_at' => $now, 'editable_until' => ReviewRules::editableUntil($now),
            'revision' => 1, 'moderation_state' => 'NONE', 'environment' => 'TEST', 'lock_version' => 1, 'created_at' => $now, 'updated_at' => $now,
        ]);
        $this->revision(DB::table('reviews')->where('id', $id)->first(), $userId, 'SUBMITTED');

        return $id;
    }

    private function revision(object $review, int $userId, string $reason): void
    {
        $media = DB::table('review_media')->where('review_id', $review->id)->whereNull('retired_at')->orderBy('sort_order')->pluck('file_id')->all();
        DB::table('review_revisions')->insert(['id' => (string) Str::uuid7(), 'review_id' => $review->id, 'revision' => (int) $review->revision, 'actor_user_id' => $userId, 'reason' => $reason, 'created_at' => now(),
            'content' => json_encode(array_filter([
                'rating' => $review->rating, 'service_quality' => $review->service_quality, 'speed_rating' => $review->speed_rating, 'speed_kind' => $review->speed_kind,
                'inquiry_seriousness' => $review->inquiry_seriousness, 'communication_quality' => $review->communication_quality, 'payment_reliability' => $review->payment_reliability,
                'comment' => $review->comment, 'display_name_choice' => $review->display_name_choice, 'media_file_ids' => $media,
            ], static fn (mixed $value): bool => $value !== null), JSON_THROW_ON_ERROR)]);
    }

    /** @param array{organization_id: string, role: string, permissions: list<string>}|null $scope */
    private function ownReview(Request $request, string $party, string $reviewId, ?array $scope, bool $lock): object
    {
        $query = DB::table('reviews')->where('id', ReviewAccess::uuid($reviewId));
        if ($party === 'VENDOR') {
            $query->where('review_type', ReviewRules::BUYER)->where('vendor_organization_id', $scope['organization_id'] ?? '');
        } else {
            $query->whereIn('review_type', [ReviewRules::VENDOR, ReviewRules::PRODUCT])->where('reviewer_user_id', $request->user()->getKey())->where('buyer_profile_id', $this->access->buyerProfileId($request));
        }
        $review = ($lock ? $query->lockForUpdate() : $query)->first();
        if ($review === null) {
            throw new AuthenticationException('REVIEW_NOT_FOUND', 'This review is unavailable.', 404);
        }

        return $review;
    }

    private function assertEditable(object $review): void
    {
        $now = CarbonImmutable::now();
        $correction = $review->moderation_state === 'CORRECTION_REQUESTED' && $review->corrected_at === null && $review->correction_due_at !== null && $now->lessThan(CarbonImmutable::parse((string) $review->correction_due_at));
        $window = ! in_array($review->moderation_state, ReviewRules::HIDDEN_STATES, true) && $review->editable_until !== null && $now->lessThan(CarbonImmutable::parse((string) $review->editable_until));
        if (! $correction && ! $window) {
            throw new AuthenticationException('REVIEW_LOCKED', 'Reviews can be corrected only within 24 hours of submitting. This review is now locked.', 409);
        }
    }

    private function fullName(int $userId): ?string
    {
        $name = DB::table('user_profiles')->where('user_id', $userId)->value('full_name') ?? DB::table('users')->where('id', $userId)->value('name');

        return is_string($name) ? $name : null;
    }

    private static function comment(mixed $comment): ?string
    {
        $text = trim((string) $comment);

        return $text === '' ? null : mb_substr($text, 0, ReviewRules::COMMENT_MAX);
    }

    /** True while the order's case is active; publication waits without deleting anything. */
    public static function disputeActive(string $orderId): bool
    {
        return DB::table('dispute_cases')->where('order_id', $orderId)->whereIn('status', DisputeRules::ACTIVE)->exists();
    }
}
