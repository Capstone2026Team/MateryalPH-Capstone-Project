<?php

declare(strict_types=1);

namespace App\Domain\Reviews;

use App\Domain\Settings\PlatformSettings;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\URL;

/**
 * Audience-specific review payloads. A party sees its own submissions at once; the counterpart's ratings appear only
 * after the blind reveal and only while they remain visible. Public names are the stored privacy-safe display name;
 * reviewer user ids, contacts and order amounts are never serialized. Photos are five-minute signed links.
 */
final class ReviewPresenter
{
    public const MEDIA_TTL_MINUTES = 5;

    private const MEDIA_ROUTES = ['BUYER' => 'reviews.buyer.media', 'VENDOR' => 'reviews.vendor.media', 'ADMIN' => 'reviews.admin.media'];

    /** @return array<string, mixed> */
    public function buyerOrder(object $order, ?object $window, int $userId): array
    {
        $reviews = DB::table('reviews')->where('order_id', $order->id)->get()->keyBy(static fn (object $review): string => $review->review_type === ReviewRules::PRODUCT ? 'L'.$review->order_line_id : $review->review_type);
        $lines = DB::table('order_lines as ol')->join('listing_variants as v', 'v.id', '=', 'ol.listing_variant_id')->join('vendor_listings as l', 'l.id', '=', 'v.vendor_listing_id')
            ->where('ol.order_id', $order->id)->where('ol.quantity', '>', 0)->orderBy('ol.line_number')->get(['ol.id', 'ol.snapshot', 'l.id as listing_id', 'l.display_name', 'v.label as variant_label']);
        $open = $this->open($order, $window);
        $own = $reviews->get(ReviewRules::VENDOR);
        $counterpart = $reviews->get(ReviewRules::BUYER);
        $name = DB::table('user_profiles')->where('user_id', $userId)->value('full_name') ?? DB::table('users')->where('id', $userId)->value('name');

        return $this->header($order, $window) + [
            'party' => 'BUYER',
            'speed_kind' => ReviewRules::speedKind((string) $order->fulfillment_method),
            'speed_label' => ReviewRules::speedLabel(ReviewRules::speedKind((string) $order->fulfillment_method)),
            'display_name_options' => array_map(static fn (string $choice): array => ['choice' => $choice, 'preview' => ReviewRules::publicName(is_string($name) ? $name : null, $choice)], ReviewRules::DISPLAY_CHOICES),
            'vendor_rating' => $own === null ? null : $this->own($own, 'BUYER'),
            'can_submit_vendor_rating' => $open && $own === null,
            'lines' => $lines->map(fn (object $line): array => [
                'order_line_id' => (string) $line->id, 'listing_id' => (string) $line->listing_id, 'display_name' => (string) $line->display_name, 'variant_label' => $line->variant_label,
                'review' => ($review = $reviews->get('L'.$line->id)) === null ? null : $this->own($review, 'BUYER'),
                'can_review' => $open && ! $reviews->has('L'.$line->id),
            ])->all(),
            'counterpart_rating' => $counterpart === null || ! $this->visible($counterpart) ? null : $this->ratingOnly($counterpart),
        ];
    }

    /**
     * @param  array{organization_id: string, role: string, permissions: list<string>}  $scope
     * @return array<string, mixed>
     */
    public function vendorOrder(object $order, ?object $window, array $scope): array
    {
        $reviews = DB::table('reviews')->where('order_id', $order->id)->get();
        $own = $reviews->firstWhere('review_type', ReviewRules::BUYER);
        $received = $reviews->filter(fn (object $review): bool => $review->review_type !== ReviewRules::BUYER && $this->visible($review));

        return $this->header($order, $window) + [
            'party' => 'VENDOR',
            'buyer_rating' => $own === null ? null : $this->own($own, 'VENDOR'),
            'can_submit_buyer_rating' => $this->open($order, $window) && $own === null && in_array(ReviewAccess::RATE_BUYER, $scope['permissions'], true),
            'received' => $received->values()->map(fn (object $review): array => $this->public($review, 'VENDOR'))->all(),
        ];
    }

    /** @return array<string, mixed> Public, privacy-safe review card. */
    public function public(object $review, string $audience): array
    {
        return [
            'id' => (string) $review->id,
            'type' => $review->review_type,
            'ratings' => $this->ratings($review),
            'comment' => $review->comment,
            'display_name' => (string) ($review->public_display_name ?? 'Verified Buyer'),
            'verified_purchase' => true,
            'submitted_at' => self::iso($review->submitted_at),
            'edited' => (int) $review->revision > 1,
            'variant_label' => $review->review_type === ReviewRules::PRODUCT ? DB::table('order_lines as ol')->join('listing_variants as v', 'v.id', '=', 'ol.listing_variant_id')->where('ol.id', $review->order_line_id)->value('v.label') : null,
            'media' => $this->media($review, $audience),
        ];
    }

    /** @return array<string, mixed> The author's own view, with edit eligibility and moderation status. */
    public function own(object $review, string $audience): array
    {
        $now = CarbonImmutable::now();
        $correction = $review->moderation_state === 'CORRECTION_REQUESTED' && $review->corrected_at === null && $review->correction_due_at !== null && $now->lessThan(CarbonImmutable::parse((string) $review->correction_due_at));
        $editable = ! in_array($review->moderation_state, ReviewRules::HIDDEN_STATES, true) && $review->editable_until !== null && $now->lessThan(CarbonImmutable::parse((string) $review->editable_until));

        return [
            'id' => (string) $review->id,
            'type' => $review->review_type,
            'ratings' => $this->ratings($review),
            'comment' => $review->comment,
            'display_name' => (string) ($review->public_display_name ?? ''),
            'submitted_at' => self::iso($review->submitted_at),
            'editable_until' => self::iso($review->editable_until),
            'editable_until_label' => self::manila($review->editable_until),
            'can_edit' => $editable || $correction,
            'correction_requested' => $review->moderation_state === 'CORRECTION_REQUESTED',
            'correction_due_at' => self::iso($review->correction_due_at),
            'visibility' => $this->visibility($review),
            'revision' => (int) $review->revision,
            'lock_version' => (int) $review->lock_version,
            'media' => $this->media($review, $audience),
        ];
    }

    /** @return array<string, int|string|null> */
    public function ratings(object $review): array
    {
        return match ($review->review_type) {
            ReviewRules::VENDOR => ['service_quality' => (int) $review->service_quality, 'speed_rating' => (int) $review->speed_rating, 'speed_kind' => $review->speed_kind],
            ReviewRules::PRODUCT => ['product_quality' => (int) $review->rating],
            default => ['inquiry_seriousness' => (int) $review->inquiry_seriousness, 'communication_quality' => (int) $review->communication_quality, 'payment_reliability' => (int) $review->payment_reliability],
        };
    }

    /** @return list<array{id: string, url: string, expires_at: string, content_type: string, byte_size: int}> */
    public function media(object $review, string $audience): array
    {
        $expires = now()->addMinutes(self::MEDIA_TTL_MINUTES);

        return DB::table('review_media as m')->join('files as f', 'f.id', '=', 'm.file_id')->where('m.review_id', $review->id)->whereNull('m.retired_at')
            ->where('f.scan_state', 'CLEAN')->orderBy('m.sort_order')->get(['m.id', 'f.content_type', 'f.byte_size'])
            ->map(static fn (object $media): array => ['id' => (string) $media->id, 'url' => URL::temporarySignedRoute(self::MEDIA_ROUTES[$audience], $expires, ['reviewId' => $review->id, 'mediaId' => (string) $media->id]),
                'expires_at' => $expires->toIso8601String(), 'content_type' => (string) $media->content_type, 'byte_size' => (int) $media->byte_size])->all();
    }

    public function visibility(object $review): string
    {
        return match (true) {
            $review->moderation_state === 'REMOVED' => 'REMOVED',
            in_array($review->moderation_state, ReviewRules::HIDDEN_STATES, true) => 'HIDDEN_BY_MODERATION',
            $review->revealed_at === null => 'HIDDEN_UNTIL_REVEAL',
            ReviewService::disputeActive((string) $review->order_id) => 'WITHHELD_ACTIVE_DISPUTE',
            DB::table('score_exclusions')->where('order_id', $review->order_id)->whereNull('revoked_at')->exists() => 'EXCLUDED_BY_INVESTIGATION',
            default => 'PUBLIC',
        };
    }

    public function visible(object $review): bool
    {
        return $this->visibility($review) === 'PUBLIC';
    }

    /** @return array<string, mixed> */
    private function header(object $order, ?object $window): array
    {
        return [
            'order_id' => (string) $order->id,
            'order_reference' => (string) $order->reference,
            'state' => match (true) {
                $window === null => 'NOT_COMPLETED',
                CarbonImmutable::now()->greaterThanOrEqualTo(CarbonImmutable::parse((string) $window->closes_at)) => 'CLOSED',
                default => 'OPEN',
            },
            'completed_at' => $window === null ? null : self::iso($window->completed_at),
            'closes_at' => $window === null ? null : self::iso($window->closes_at),
            'closes_at_label' => $window === null ? null : self::manila($window->closes_at),
            'revealed' => $window !== null && $window->revealed_at !== null,
            'revealed_at' => $window === null ? null : self::iso($window->revealed_at),
            'reveal_reason' => $window?->reveal_reason,
            'withheld_for_dispute' => ReviewService::disputeActive((string) $order->id),
            'rules' => ['window_days' => (int) PlatformSettings::current()->field('reviews.windows', 'rating_window_days'), 'edit_hours' => (int) PlatformSettings::current()->field('reviews.windows', 'edit_hours'), 'comment_max' => ReviewRules::COMMENT_MAX, 'media_max' => ReviewRules::MEDIA_MAX, 'photo_max_bytes' => ReviewRules::photoMaxBytes(), 'video_max_bytes' => ReviewRules::videoMaxBytes(),
                'blind_reveal' => 'Ratings stay hidden until both parties submit or the 14-day window ends.'],
        ];
    }

    private function open(object $order, ?object $window): bool
    {
        return $window !== null && $order->order_state === 'COMPLETED' && CarbonImmutable::now()->lessThan(CarbonImmutable::parse((string) $window->closes_at));
    }

    /** @return array<string, mixed> */
    private function ratingOnly(object $review): array
    {
        return ['ratings' => $this->ratings($review), 'comment' => $review->comment, 'display_name' => (string) ($review->public_display_name ?? ''), 'submitted_at' => self::iso($review->submitted_at)];
    }

    public static function iso(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->toIso8601String();
    }

    public static function manila(mixed $value): ?string
    {
        return $value === null ? null : CarbonImmutable::parse((string) $value)->setTimezone('Asia/Manila')->format('M j, Y g:i A').' (Asia/Manila)';
    }
}
