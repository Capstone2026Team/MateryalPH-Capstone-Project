<?php

declare(strict_types=1);

namespace App\Domain\Enforcement;

use App\Domain\Identity\AuthenticationException;
use Carbon\CarbonImmutable;
use Illuminate\Support\Facades\DB;

/**
 * Graduated enforcement (approved by the project owner on 2026-10-09): an applied Temporary Restriction blocks a
 * Buyer's new orders, new inquiries and quotation acceptances or counter-offers until it expires or is lifted.
 * Existing orders, payments, refunds, fulfillment and disputes continue; Suspension and Permanent Ban act at the
 * account level instead (the account cannot sign in).
 */
final class BuyerCommerceRestriction
{
    public static function activeUntil(string $buyerProfileId): ?CarbonImmutable
    {
        $expires = DB::table('enforcement_actions')->where('subject_type', 'BUYER')->where('subject_id', $buyerProfileId)->where('state', 'APPLIED')
            ->where('action', 'TEMPORARY_RESTRICTION')->where('expires_at', '>', now())->max('expires_at');

        return $expires === null ? null : CarbonImmutable::parse((string) $expires);
    }

    public static function assertAllowed(string $buyerProfileId): void
    {
        $until = self::activeUntil($buyerProfileId);
        if ($until !== null) {
            throw new AuthenticationException('BUYER_COMMERCE_RESTRICTED', 'Your account is temporarily restricted from new orders, inquiries and quotation acceptances until '
                .$until->setTimezone('Asia/Manila')->format('M j, Y g:i A').' (Asia/Manila). Your existing orders continue.', 403, ['restricted_until' => $until->toIso8601String()]);
        }
    }
}
