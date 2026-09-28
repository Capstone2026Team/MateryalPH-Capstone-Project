<?php

declare(strict_types=1);

namespace App\Domain\Inventory;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * Stale-stock schedule. A listing's confirmation age is its least-recently confirmed active variant
 * (approved by the project owner on 2026-09-28): confirming stock means confirming every sellable variant.
 * Day 7 and Day 12 send reminders; after 15 consecutive days the listing becomes
 * TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED. A stale variant is excluded from MAT-02 eligibility immediately.
 * Every threshold is an exact instant; clients render it in Asia/Manila.
 */
final class StockConfirmationPolicy
{
    public const FIRST_REMINDER_DAYS = 7;

    public const FINAL_REMINDER_DAYS = 12;

    public const HIDE_AFTER_DAYS = 15;

    public const TIMEZONE = 'Asia/Manila';

    /**
     * @return array{state: string, confirmed_at: ?string, first_reminder_at: ?string, final_reminder_at: ?string, hide_at: ?string, days_since_confirmation: ?int}
     */
    public static function schedule(?string $confirmedAt, ?CarbonImmutable $now = null): array
    {
        if ($confirmedAt === null) {
            return ['state' => 'NOT_CONFIRMED', 'confirmed_at' => null, 'first_reminder_at' => null, 'final_reminder_at' => null, 'hide_at' => null, 'days_since_confirmation' => null];
        }
        $now ??= CarbonImmutable::now();
        $anchor = CarbonImmutable::parse($confirmedAt)->utc();
        $hideAt = $anchor->addDays(self::HIDE_AFTER_DAYS);
        $state = match (true) {
            $now->greaterThanOrEqualTo($hideAt) => 'OVERDUE',
            $now->greaterThanOrEqualTo($anchor->addDays(self::FINAL_REMINDER_DAYS)) => 'FINAL_REMINDER',
            $now->greaterThanOrEqualTo($anchor->addDays(self::FIRST_REMINDER_DAYS)) => 'REMINDER',
            default => 'CONFIRMED',
        };

        return [
            'state' => $state, 'confirmed_at' => $anchor->toIso8601String(),
            'first_reminder_at' => $anchor->addDays(self::FIRST_REMINDER_DAYS)->toIso8601String(),
            'final_reminder_at' => $anchor->addDays(self::FINAL_REMINDER_DAYS)->toIso8601String(),
            'hide_at' => $hideAt->toIso8601String(),
            'days_since_confirmation' => (int) floor($anchor->diffInSeconds($now, false) / 86400),
        ];
    }

    public static function isStale(?string $confirmedAt, ?CarbonImmutable $now = null): bool
    {
        return self::schedule($confirmedAt, $now)['state'] === 'OVERDUE' || $confirmedAt === null;
    }

    /**
     * Least-recent confirmation across a listing's active variants, or null when any active variant has
     * never been counted.
     */
    public static function listingAnchor(string $listingId): ?string
    {
        $row = DB::table('listing_variants as v')->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
            ->where('v.vendor_listing_id', $listingId)->where('v.active', true)
            ->selectRaw('COUNT(*) AS variants, COUNT(i.confirmed_at) AS confirmed, MIN(i.confirmed_at) AS anchor')->first();
        if ($row === null || (int) $row->variants === 0 || (int) $row->variants !== (int) $row->confirmed) {
            return null;
        }

        return (string) $row->anchor;
    }
}
