<?php

declare(strict_types=1);

namespace App\Domain\Analytics\Products;

use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;
use Throwable;

/**
 * Records a product view (approved by the project owner on 2026-10-10): one signed-in Buyer opening one listing's
 * Product Details counts once per Asia/Manila calendar day; repeat opens that day are ignored by the primary key.
 * Only the Buyer profile key, listing, store and day are kept — no location, device, IP or session. Recording is a
 * single idempotent statement outside any transaction, and a failure is reported but never fails the Buyer's read.
 */
final class ProductViewRecorder
{
    public const TIMEZONE = 'Asia/Manila';

    public function record(string $buyerProfileId, string $listingId, string $organizationId, ?CarbonImmutable $at = null): void
    {
        $at ??= CarbonImmutable::now();
        try {
            DB::table('listing_view_days')->insertOrIgnore([
                'vendor_listing_id' => $listingId,
                'view_date' => $at->setTimezone(self::TIMEZONE)->toDateString(),
                'buyer_profile_id' => $buyerProfileId,
                'vendor_organization_id' => $organizationId,
                'first_viewed_at' => $at->setTimezone('UTC'),
            ]);
        } catch (Throwable $exception) {
            report($exception);
        }
    }
}
