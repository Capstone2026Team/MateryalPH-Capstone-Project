<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use App\Domain\Operations\OutboxProcessor;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Support\Facades\DB;

/**
 * Stock, reservation, listing, price and Vendor-eligibility changes publish one post-commit outbox event
 * that invalidates cached MAT-02 current counts. The work is bounded: a still-pending event for the same
 * organization already covers any later change, and processing bumps one cache generation counter.
 */
final class EligibilityInvalidation
{
    public const EVENT = 'MARKETPLACE_ELIGIBILITY_CHANGED';

    public function __construct(private readonly OutboxPublisher $outbox) {}

    public function changed(string $organizationId, string $reason): void
    {
        $pending = DB::table('outbox_events')->where('event_type', self::EVENT)->where('aggregate_id', $organizationId)
            ->whereNull('processed_at')->where('attempts', '<', OutboxProcessor::MAX_ATTEMPTS)->exists();
        if ($pending) {
            return;
        }
        $this->outbox->publish(self::EVENT, 'VENDOR_ORGANIZATION', $organizationId, ['reason' => $reason, 'eligibility_version' => EligibleOfferQuery::VERSION]);
    }
}
