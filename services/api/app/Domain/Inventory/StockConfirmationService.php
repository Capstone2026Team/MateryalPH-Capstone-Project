<?php

declare(strict_types=1);

namespace App\Domain\Inventory;

use App\Domain\Catalog\ListingReadiness;
use App\Domain\Catalog\ListingTransitions;
use App\Domain\Catalog\MarketplaceDiscoverability;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Keeping listings fresh. Day 7 and Day 12 reminders go out at or after the Vendor's configured
 * Asia/Manila reminder time; after 15 consecutive days without confirmation an ACTIVE listing becomes
 * TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED (never called a suspension). A valid confirmation restores it
 * immediately unless another restriction applies. Reminder rows are unique per confirmation anchor, so
 * repeated or overlapping runs never send twice.
 */
final class StockConfirmationService
{
    private const NOTIFY_ROLES = ['OWNER', 'STORE_MANAGER', 'STORE_STAFF', 'INVENTORY'];

    public function __construct(
        private readonly ListingTransitions $transitions,
        private readonly ListingReadiness $readiness,
        private readonly MarketplaceDiscoverability $discoverability,
        private readonly VendorInventoryNotifier $notifier,
    ) {}

    /** @return array{reminders: int, hidden: int} */
    public function sweep(?CarbonImmutable $now = null): array
    {
        $now ??= CarbonImmutable::now();
        $counts = ['reminders' => 0, 'hidden' => 0];
        $candidates = DB::table('vendor_listings as l')->join('listing_variants as v', 'v.vendor_listing_id', '=', 'l.id')
            ->leftJoin('inventory_items as i', 'i.listing_variant_id', '=', 'v.id')
            ->where('l.status', 'ACTIVE')->whereNull('l.removed_at')->where('v.active', true)
            ->groupBy('l.id', 'l.vendor_organization_id')
            ->havingRaw('MIN(i.confirmed_at) <= ?', [$now->subDays(StockConfirmationPolicy::FIRST_REMINDER_DAYS)])
            ->orderBy('l.id')->selectRaw('l.id, l.vendor_organization_id')->get();
        foreach ($candidates as $candidate) {
            $result = DB::transaction(fn (): array => $this->evaluateListing((string) $candidate->vendor_organization_id, (string) $candidate->id, $now));
            $counts['reminders'] += $result['reminders'];
            $counts['hidden'] += $result['hidden'];
        }

        return $counts;
    }

    /**
     * Restores a hidden listing whose active variants are all freshly confirmed. The caller holds the listing
     * lock. Compliance, readiness and store restrictions still apply; a blocked listing stays hidden.
     */
    public function restoreIfConfirmed(object $listing, ?int $actorId, string $source): bool
    {
        if ($listing->status !== 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED') {
            return false;
        }
        if (StockConfirmationPolicy::isStale(StockConfirmationPolicy::listingAnchor((string) $listing->id))) {
            return false;
        }
        $store = DB::table('vendor_organizations')->where('id', $listing->vendor_organization_id)->value('store_activation_status');
        if ($store !== 'ACTIVE' || ($listing->regulated && $listing->compliance_status !== 'VERIFIED') || $this->readiness->evaluate((string) $listing->id)['blockers'] !== []) {
            return false;
        }
        $this->transitions->transition($listing, 'ACTIVE', $source, $actorId, 'STOCK_CONFIRMED', 'Stock confirmation restored the listing.');

        return true;
    }

    /** @return array{reminders: int, hidden: int} */
    private function evaluateListing(string $organizationId, string $listingId, CarbonImmutable $now): array
    {
        DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first(['id']);
        $listing = DB::table('vendor_listings')->where('id', $listingId)->lockForUpdate()->first();
        if ($listing === null || $listing->status !== 'ACTIVE') {
            return ['reminders' => 0, 'hidden' => 0];
        }
        $anchor = StockConfirmationPolicy::listingAnchor($listingId);
        $schedule = StockConfirmationPolicy::schedule($anchor, $now);
        if ($anchor === null || $schedule['state'] === 'CONFIRMED') {
            return ['reminders' => 0, 'hidden' => 0];
        }
        $settings = DB::table('vendor_inventory_settings')->where('vendor_organization_id', $organizationId)->first(['reminder_local_time', 'email_reminders']);
        $email = $settings === null ? true : (bool) $settings->email_reminders;
        $name = Str::limit((string) $listing->display_name, 120);
        $hideAtLocal = CarbonImmutable::parse((string) $schedule['hide_at'])->setTimezone(StockConfirmationPolicy::TIMEZONE)->format('M j, Y g:i A');
        if ($schedule['state'] === 'OVERDUE') {
            if (! $this->record($listingId, (string) $schedule['confirmed_at'], 'DAY_15_HIDDEN')) {
                return ['reminders' => 0, 'hidden' => 0];
            }
            $this->transitions->transition($listing, 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED', 'SYSTEM', null, 'STOCK_NOT_CONFIRMED', 'Stock was not confirmed for 15 consecutive days.');
            $this->discoverability->evaluate($organizationId);
            $this->notifier->notify($organizationId, self::NOTIFY_ROLES, 'STOCK_CONFIRMATION', 'Listing temporarily hidden', '“'.$name.'” is temporarily hidden because its stock was not confirmed for 15 days. Confirm the stock count to restore it right away. Your store is not suspended.', 'VENDOR_LISTING', $listingId, $email);

            return ['reminders' => 0, 'hidden' => 1];
        }
        $stage = $schedule['state'] === 'FINAL_REMINDER' ? 'DAY_12' : 'DAY_7';
        if (! $this->reminderTimeReached($settings?->reminder_local_time, $now) || ! $this->record($listingId, (string) $schedule['confirmed_at'], $stage)) {
            return ['reminders' => 0, 'hidden' => 0];
        }
        $this->notifier->notify($organizationId, self::NOTIFY_ROLES, 'STOCK_CONFIRMATION', $stage === 'DAY_12' ? 'Final reminder: confirm stock' : 'Confirm stock', 'Confirm the stock of “'.$name.'”. If it is not confirmed by '.$hideAtLocal.' (Asia/Manila), the listing will be temporarily hidden from Buyers.', 'VENDOR_LISTING', $listingId, $email);

        return ['reminders' => 1, 'hidden' => 0];
    }

    /** Claims one reminder stage for one confirmation anchor. Returns false when it was already recorded. */
    private function record(string $listingId, string $anchor, string $stage): bool
    {
        return DB::table('stock_confirmation_reminders')->insertOrIgnore(['id' => (string) Str::uuid7(), 'vendor_listing_id' => $listingId, 'anchor_confirmed_at' => $anchor, 'stage' => $stage, 'recorded_at' => now()]) === 1;
    }

    private function reminderTimeReached(?string $localTime, CarbonImmutable $now): bool
    {
        $local = $now->setTimezone(StockConfirmationPolicy::TIMEZONE);

        return $local->format('H:i:s') >= substr(($localTime ?? '08:00:00').':00', 0, 8);
    }
}
