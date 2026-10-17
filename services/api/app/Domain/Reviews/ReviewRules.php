<?php

declare(strict_types=1);

namespace App\Domain\Reviews;

use App\Domain\Disputes\DisputeRules;
use App\Domain\Settings\PlatformSettings;
use Carbon\CarbonImmutable;
use Illuminate\Database\Query\Builder;

/**
 * Rating Eligibility Rules from the System Workflow. Trigger: the order reaches COMPLETED. Limit: one Vendor rating
 * per party per order and one Product Review per eligible line. Window: 14 calendar days after completion by default (an
 * exact instant stored when the window opens). Correction: 24 hours after submission by default. Both windows and the
 * moderation correction window come from the versioned Platform Setting `reviews.windows`. Blind reveal: both parties submit or the
 * window expires. Dispute: a rating stays withheld while a directly related dispute remains active. An Admin
 * "Request Correction" hides the review and gives its author one correction within 7 days (approved by the project
 * owner on 2026-10-04).
 */
final class ReviewRules
{
    public const WINDOW_DAYS = 14;

    public const EDIT_HOURS = 24;

    public const CORRECTION_DAYS = 7;

    public const COMMENT_MAX = 1000;

    public const MEDIA_MAX = 3;

    public const PHOTO_MAX_BYTES = 10 * 1024 * 1024;

    public const VIDEO_MAX_BYTES = 100 * 1024 * 1024;

    /** Buyer rates the Vendor. */
    public const VENDOR = 'VENDOR';

    /** Buyer reviews one purchased line. */
    public const PRODUCT = 'PRODUCT';

    /** Vendor rates the Buyer (CCS). */
    public const BUYER = 'BUYER';

    public const DISPLAY_CHOICES = ['FIRST_NAME_LAST_INITIAL', 'VERIFIED_BUYER'];

    public const FLAG_REASONS = ['OFFENSIVE', 'PERSONAL_INFORMATION', 'SPAM', 'IRRELEVANT', 'CONFLICT_OF_INTEREST', 'FALSE_CLAIM', 'OTHER'];

    public const MODERATION_ACTIONS = ['DISMISS_FLAG', 'REQUEST_CORRECTION', 'HIDE_PENDING_REVIEW', 'REMOVE', 'RESTORE'];

    /** States in which the review is not public and does not count toward any score. */
    public const HIDDEN_STATES = ['HIDDEN_PENDING_REVIEW', 'CORRECTION_REQUESTED', 'REMOVED'];

    public static function closesAt(CarbonImmutable $completedAt): CarbonImmutable
    {
        return $completedAt->addDays((int) PlatformSettings::current()->field('reviews.windows', 'rating_window_days'));
    }

    public static function editableUntil(CarbonImmutable $submittedAt): CarbonImmutable
    {
        return $submittedAt->addHours((int) PlatformSettings::current()->field('reviews.windows', 'edit_hours'));
    }

    public static function correctionDays(): int
    {
        return (int) PlatformSettings::current()->field('reviews.windows', 'correction_days');
    }

    /** Effective review media limits: the versioned upload setting, never above the approved ceilings above. */
    public static function photoMaxBytes(): int
    {
        return min(self::PHOTO_MAX_BYTES, PlatformSettings::current()->uploadKb('review_photo') * 1024);
    }

    public static function videoMaxBytes(): int
    {
        return min(self::VIDEO_MAX_BYTES, PlatformSettings::current()->uploadKb('review_video') * 1024);
    }

    public static function speedKind(string $fulfillmentMethod): string
    {
        return $fulfillmentMethod === 'DELIVERY' ? 'DELIVERY_SPEED' : 'PROCESSING_SPEED';
    }

    public static function speedLabel(string $speedKind): string
    {
        return $speedKind === 'DELIVERY_SPEED' ? 'Delivery Speed' : 'Processing Speed';
    }

    /** "Juan dela Cruz" → "Juan C." ; a single name keeps only the first name; empty → Verified Buyer. */
    public static function publicName(?string $fullName, string $choice): string
    {
        $parts = preg_split('/\s+/u', trim((string) $fullName)) ?: [];
        $parts = array_values(array_filter($parts, static fn (string $part): bool => $part !== ''));
        if ($choice !== 'FIRST_NAME_LAST_INITIAL' || $parts === []) {
            return 'Verified Buyer';
        }
        $first = mb_substr($parts[0], 0, 40);
        if (count($parts) === 1) {
            return $first;
        }

        return $first.' '.mb_strtoupper(mb_substr($parts[count($parts) - 1], 0, 1)).'.';
    }

    /**
     * Restricts a reviews query (alias r) to publicly visible, score-eligible reviews: revealed by the blind window,
     * not hidden or removed by moderation, no active dispute on the order, and the order not excluded from scores.
     */
    public static function constrainVisible(Builder $reviews, string $alias = 'r'): Builder
    {
        return $reviews->whereNotNull($alias.'.revealed_at')->whereNotNull($alias.'.submitted_at')
            ->whereNotIn($alias.'.moderation_state', self::HIDDEN_STATES)
            ->whereNotExists(fn (Builder $dispute) => $dispute->selectRaw('1')->from('dispute_cases as rdc')->whereColumn('rdc.order_id', $alias.'.order_id')->whereIn('rdc.status', DisputeRules::ACTIVE))
            ->whereNotExists(fn (Builder $exclusion) => $exclusion->selectRaw('1')->from('score_exclusions as rse')->whereColumn('rse.order_id', $alias.'.order_id')->whereNull('rse.revoked_at'));
    }
}
