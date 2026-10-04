<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Disputes\DisputeFilingService;
use App\Domain\Disputes\DisputeRules;
use App\Domain\Finance\Money;
use Carbon\CarbonImmutable;
use PHPUnit\Framework\TestCase;

/** Phase 13 pure rules: Asia/Manila business days, timers, issue/remedy sets, role grants and award arithmetic. */
final class PhaseThirteenRulesTest extends TestCase
{
    public function test_business_days_skip_weekends_in_manila_and_keep_the_local_clock_time(): void
    {
        // Friday 10:00 Manila (02:00 UTC) + 5 business days = the next Friday 10:00 Manila.
        $friday = CarbonImmutable::parse('2026-10-02 02:00:00', 'UTC');
        self::assertSame('2026-10-09 10:00', DisputeRules::addBusinessDays($friday, 5)->setTimezone('Asia/Manila')->format('Y-m-d H:i'));
        // Saturday counts from Monday: + 3 business days = Wednesday.
        $saturday = CarbonImmutable::parse('2026-10-03 09:30:00', 'Asia/Manila');
        self::assertSame('2026-10-07 09:30', DisputeRules::addBusinessDays($saturday, 3)->setTimezone('Asia/Manila')->format('Y-m-d H:i'));
        // Late Friday in UTC is already Saturday in Manila.
        $lateFridayUtc = CarbonImmutable::parse('2026-10-02 17:00:00', 'UTC');
        self::assertSame('2026-10-07 01:00', DisputeRules::addBusinessDays($lateFridayUtc, 3)->setTimezone('Asia/Manila')->format('Y-m-d H:i'));
        self::assertSame('UTC', DisputeRules::addBusinessDays($friday, 1)->getTimezone()->getName(), 'Stored as an exact UTC instant.');
    }

    public function test_documented_timers_and_party_specific_issue_and_remedy_sets(): void
    {
        self::assertSame([48, 72, 24, 5, 7], [DisputeRules::RESPONSE_HOURS, DisputeRules::MUTUAL_RESOLUTION_HOURS, DisputeRules::CLARIFICATION_HOURS, DisputeRules::APPEAL_BUSINESS_DAYS, DisputeRules::POST_COMPLETION_DAYS]);
        self::assertContains('DEFECTIVE', DisputeRules::issuesFor('BUYER'));
        self::assertNotContains('PICKUP_NO_SHOW', DisputeRules::issuesFor('BUYER'));
        self::assertContains('PICKUP_NO_SHOW', DisputeRules::issuesFor('VENDOR'));
        self::assertNotContains('FULL_REFUND', DisputeRules::remediesFor('VENDOR'), 'A Vendor case never requests a Buyer refund.');
        self::assertSame(['DISMISSED', 'REPLACEMENT', 'FULL_REFUND', 'PARTIAL_REFUND', 'INCONCLUSIVE', 'NO_FURTHER_ACTION'], DisputeRules::OUTCOMES);
        self::assertSame(['WARNING', 'TEMPORARY_RESTRICTION', 'SUSPENSION', 'PERMANENT_BAN'], DisputeRules::SANCTIONS);
        self::assertSame(['BUYER', 'VENDOR'], [DisputeRules::otherParty('VENDOR'), DisputeRules::otherParty('BUYER')]);
        self::assertSame([], array_intersect(DisputeRules::ACTIVE, DisputeRules::CONCLUDED));
    }

    public function test_refund_destination_fields_are_refused_by_name(): void
    {
        foreach (['refund_destination', 'bank_account', 'card_number', 'ewallet_number', 'gcash_number', 'payout_account'] as $field) {
            self::assertContains($field, DisputeFilingService::DESTINATION_FIELDS);
        }
    }

    public function test_role_grants_follow_the_matrix_and_the_owner_flag_controls_only_staff_and_customer_service(): void
    {
        $access = new AccountAccess;
        $owner = $access->vendorPermissions('OWNER');
        $manager = $access->vendorPermissions('STORE_MANAGER');
        $staff = $access->vendorPermissions('STORE_STAFF');
        $service = $access->vendorPermissions('CUSTOMER_SERVICE');
        $inventory = $access->vendorPermissions('INVENTORY');
        $fulfillment = $access->vendorPermissions('FULFILLMENT');
        self::assertContains('disputes.refund_offer', $owner);
        foreach ([$manager, $staff, $service] as $permissions) {
            self::assertNotContains('disputes.refund_offer', $permissions, 'Voluntary financial refunds stay Owner-only.');
            self::assertContains('disputes.respond', $permissions);
        }
        self::assertSame([true, true, true, false], [in_array('invoices.upload', $owner, true), in_array('invoices.upload', $manager, true), in_array('invoices.upload', $staff, true), in_array('invoices.upload', $service, true)]);
        self::assertSame([], array_values(array_intersect(['portal.disputes', 'disputes.respond', 'invoices.view', 'invoices.upload'], $inventory)));
        self::assertSame(['disputes.fulfillment_evidence'], array_values(array_intersect(['portal.disputes', 'disputes.respond', 'disputes.export', 'disputes.fulfillment_evidence'], $fulfillment)));
        foreach ([$manager, $staff, $service, $inventory, $fulfillment] as $permissions) {
            self::assertSame([], array_values(array_intersect(['finance.view', 'finance.pay', 'portal.earnings', 'portal.wallet'], $permissions)), 'No case or invoice role grants protected finance.');
        }
        self::assertSame(['STORE_STAFF', 'CUSTOMER_SERVICE'], AccountAccess::FLAG_CONTROLLED_DISPUTE_ROLES);
        self::assertSame(['portal.disputes', 'disputes.respond', 'disputes.export'], AccountAccess::FLAG_CONTROLLED_DISPUTE_PERMISSIONS);
    }

    public function test_partial_award_line_split_reverses_original_vat_and_discount_proportionally(): void
    {
        $parts = Money::allocate(300000, ['line-a' => 600000, 'line-b' => 400000]);
        self::assertSame(['line-a' => 180000, 'line-b' => 120000], $parts);
        // A ₱1,800 part of a ₱6,000 VAT_12 line that carried ₱642.86 VAT and a ₱300 discount.
        self::assertSame(19286, Money::proportion(180000, 64286, 600000));
        self::assertSame(9000, Money::proportion(180000, 30000, 600000));
        self::assertSame(array_sum($parts), 300000, 'Shares always sum exactly to the award.');
    }
}
