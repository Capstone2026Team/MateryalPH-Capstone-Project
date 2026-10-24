<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Settings\PlatformSettings;
use Carbon\CarbonImmutable;

/**
 * The documented dispute contract: case states, issue types per filing party, requested remedies, outcomes and
 * the Asia/Manila timers. Every deadline is stored as an exact UTC instant computed once from the triggering event:
 *
 *   response              48 calendar hours after filing; no response escalates to Admin review
 *   mutual resolution     72 calendar hours after the response
 *   clarification         24 calendar hours after each Admin request
 *   appeal                five business days (Monday–Friday, Asia/Manila, no inferred holidays) after a decision
 *   post-completion case  seven calendar days after COMPLETED, subject to non-waivable statutory rights
 *
 * Order-state decisions (approved by the project owner on 2026-10-04): the order becomes DISPUTED only while it
 * awaits receipt; one appeal per case; an award executes at once only when the decision is marked immediately
 * enforceable, otherwise when the appeal window lapses; sanctions beyond a warning are recorded and referred.
 */
final class DisputeRules
{
    public const RESPONSE_HOURS = 48;

    public const MUTUAL_RESOLUTION_HOURS = 72;

    public const CLARIFICATION_HOURS = 24;

    public const APPEAL_BUSINESS_DAYS = 5;

    public const POST_COMPLETION_DAYS = 7;

    public const TIMEZONE = 'Asia/Manila';

    /**
     * The effective deadline from the versioned Platform Setting `disputes.deadlines` (response_hours,
     * mutual_resolution_hours, clarification_hours, appeal_business_days, post_completion_filing_days). The constants
     * above are the approved defaults; running deadlines keep the instant stored when they were opened.
     */
    public static function deadline(string $field): int
    {
        return (int) PlatformSettings::current()->field('disputes.deadlines', $field);
    }

    public const OPEN_AWAITING_RESPONSE = 'OPEN_AWAITING_RESPONSE';

    public const MUTUAL_RESOLUTION = 'MUTUAL_RESOLUTION';

    public const ESCALATED_ADMIN_REVIEW = 'ESCALATED_ADMIN_REVIEW';

    public const AWAITING_CLARIFICATION = 'AWAITING_CLARIFICATION';

    public const DECIDED = 'DECIDED';

    public const APPEAL_OPEN = 'APPEAL_OPEN';

    public const RESOLVED = 'RESOLVED';

    public const CLOSED_INCONCLUSIVE = 'CLOSED_INCONCLUSIVE';

    public const ACTIVE = [self::OPEN_AWAITING_RESPONSE, self::MUTUAL_RESOLUTION, self::ESCALATED_ADMIN_REVIEW, self::AWAITING_CLARIFICATION, self::DECIDED, self::APPEAL_OPEN];

    public const CONCLUDED = [self::RESOLVED, self::CLOSED_INCONCLUSIVE];

    /** Admin review states in which the case has a decision-maker but no decision yet. */
    public const UNDER_ADMIN_REVIEW = [self::ESCALATED_ADMIN_REVIEW, self::AWAITING_CLARIFICATION];

    public const BUYER_ISSUES = ['WRONG_ITEM', 'DEFECTIVE', 'INCOMPLETE_DELIVERY', 'LATE_OR_MISSING', 'MISLEADING_LISTING', 'PAYMENT', 'INVOICE', 'OTHER_TRANSACTION'];

    public const VENDOR_ISSUES = ['PHYSICAL_PAYMENT_NOT_RECEIVED', 'PICKUP_NO_SHOW', 'ABUSIVE_COMMUNICATION', 'FALSE_EVIDENCE', 'INACCESSIBLE_DELIVERY_SITE'];

    public const BUYER_REMEDIES = ['REPLACEMENT', 'FULL_REFUND', 'PARTIAL_REFUND', 'RETURN_AND_REFUND', 'INVOICE_CORRECTION', 'OTHER'];

    public const VENDOR_REMEDIES = ['PAYMENT_OF_BALANCE', 'WARNING_ONLY', 'OTHER'];

    public const OUTCOMES = ['DISMISSED', 'REPLACEMENT', 'FULL_REFUND', 'PARTIAL_REFUND', 'INCONCLUSIVE', 'NO_FURTHER_ACTION'];

    public const MONEY_OUTCOMES = ['FULL_REFUND', 'PARTIAL_REFUND'];

    public const PROPOSAL_REMEDIES = ['REPLACEMENT', 'FULL_REFUND', 'PARTIAL_REFUND', 'NO_FURTHER_ACTION'];

    public const RESPONSE_POSITIONS = ['ACCEPT_REQUEST', 'OFFER_REPLACEMENT', 'OFFER_REFUND', 'REJECT_WITH_EVIDENCE', 'REQUEST_ADMIN_REVIEW'];

    public const SANCTIONS = ['WARNING', 'TEMPORARY_RESTRICTION', 'SUSPENSION', 'PERMANENT_BAN'];

    /** Confirmed Vendor events the scoring service recalculates from; never an arbitrary score. */
    public const METRIC_EVENTS = ['VALIDATED_DEFECT_RETURN', 'VENDOR_NON_FULFILLMENT', 'MISREPRESENTED_LISTING'];

    public const APPEAL_GROUNDS = ['NEW_EVIDENCE', 'MATERIAL_PROCESS_ERROR'];

    /** Order states from which a transaction dispute may be filed (PROCESSING onward, before completion). */
    public const FILEABLE_ORDER_STATES = ['PROCESSING', 'READY_FOR_PICKUP', 'OUT_FOR_DELIVERY', 'DELIVERED', 'PICKED_UP'];

    /**
     * Adds Monday–Friday business days in Asia/Manila, keeping the local clock time, and returns the exact UTC
     * instant. A start on a weekend counts from the next business day. Holidays are never inferred; an approved
     * calendar override would be a separate, cited record.
     */
    public static function addBusinessDays(CarbonImmutable $from, int $days): CarbonImmutable
    {
        $local = $from->setTimezone(self::TIMEZONE);
        $added = 0;
        while ($added < $days) {
            $local = $local->addDay();
            if (! $local->isWeekend()) {
                $added++;
            }
        }

        return $local->utc();
    }

    /** @return list<string> */
    public static function issuesFor(string $party): array
    {
        return $party === 'VENDOR' ? self::VENDOR_ISSUES : self::BUYER_ISSUES;
    }

    /** @return list<string> */
    public static function remediesFor(string $party): array
    {
        return $party === 'VENDOR' ? self::VENDOR_REMEDIES : self::BUYER_REMEDIES;
    }

    public static function otherParty(string $party): string
    {
        return $party === 'BUYER' ? 'VENDOR' : 'BUYER';
    }

    /**
     * Separation of review applies among Order and Dispute Staff: one who made the appealed decision leaves the
     * appeal to another staff member or a Super Admin. A Super Admin may decide any appeal, including on their own
     * decision.
     */
    public static function appealReviewerConflict(?object $appealed, ?int $userId, ?string $role): bool
    {
        return $appealed !== null && $role !== 'ADMIN_SUPERADMIN' && (int) $appealed->actor_user_id === $userId;
    }
}
