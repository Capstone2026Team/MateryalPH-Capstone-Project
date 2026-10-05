<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Analytics\MaterialsAnalyticsService;
use App\Domain\Authorization\AccountAccess;
use App\Domain\Reviews\ReviewModerationService;
use App\Domain\Reviews\ReviewRules;
use App\Domain\Scores\ScoreRules;
use Carbon\CarbonImmutable;
use PHPUnit\Framework\TestCase;

/** Phase 14 pure rules: every OHS penalty-band and LVD edge, score formulas, Most Ordered, MAT-04 trend/point rules and grants. */
final class PhaseFourteenRulesTest extends TestCase
{
    public function test_every_penalty_band_edge_uses_two_decimal_rates(): void
    {
        $cases = [
            'NFR' => [['2.00', '0.00'], ['2.01', '0.25'], ['5.00', '0.25'], ['5.01', '0.75'], ['10.00', '0.75'], ['10.01', '1.50']],
            'LSR' => [['3.00', '0.00'], ['3.01', '0.25'], ['8.00', '0.25'], ['8.01', '0.75'], ['15.00', '0.75'], ['15.01', '1.25']],
            'RR' => [['2.00', '0.00'], ['2.01', '0.25'], ['5.00', '0.25'], ['5.01', '0.50'], ['10.00', '0.50'], ['10.01', '1.00']],
            'ODR' => [['1.00', '0.00'], ['1.01', '0.25'], ['3.00', '0.25'], ['3.01', '0.75'], ['6.00', '0.75'], ['6.01', '1.25']],
        ];
        foreach ($cases as $metric => $edges) {
            foreach ($edges as [$rate, $penalty]) {
                self::assertSame($penalty, ScoreRules::penalty($metric, $rate), $metric.' at '.$rate.'%');
            }
        }
        self::assertSame('2.00', ScoreRules::percent(1, 50));
        self::assertSame('2.01', ScoreRules::percent(201, 10000));
        self::assertSame('2.00', ScoreRules::percent(2004, 100000), '2.004% displays as 2.00% and carries no penalty.');
        self::assertSame('0.00', ScoreRules::percent(0, 0));
    }

    public function test_lvd_bands_ohs_clamp_and_vps_vcs_formulas(): void
    {
        self::assertSame(['0.00', '0.10', '0.30', '0.30', '0.60', '0.60', '1.00', '1.00'], array_map(ScoreRules::lvdPenalty(...), [0, 1, 2, 3, 4, 5, 6, 12]));
        self::assertSame('5.00', ScoreRules::ohs(['NFR' => '0.00', 'LSR' => '0.00', 'RR' => '0.00', 'ODR' => '0.00', 'LVD' => '0.00']));
        self::assertSame('1.00', ScoreRules::ohs(['NFR' => '1.50', 'LSR' => '1.25', 'RR' => '1.00', 'ODR' => '1.25', 'LVD' => '1.00']), 'Clamped to 1.00.');
        self::assertSame('3.25', ScoreRules::ohs(['NFR' => '0.75', 'LSR' => '0.25', 'RR' => '0.50', 'ODR' => '0.25', 'LVD' => '0.00']));
        self::assertSame('4.46', ScoreRules::round(ScoreRules::vps(ScoreRules::vcs('5', '4', '5'), '4.25')));
        self::assertSame('3.00', ScoreRules::round(ScoreRules::vps('3', '3')));
        self::assertNull(ScoreRules::average(0, 0));
        self::assertSame([5, 5, 10, 30, 90, 30, 90, 12], [ScoreRules::MIN_VENDOR_RATINGS, ScoreRules::MIN_PRODUCT_RATINGS, ScoreRules::MIN_OHS_ORDERS, ScoreRules::OHS_WINDOW_DAYS,
            ScoreRules::RATING_WINDOW_DAYS, ScoreRules::CRR_WINDOW_DAYS, ScoreRules::FRR_WINDOW_DAYS, ScoreRules::RESPONSE_HOURS]);
        self::assertSame('New Vendor — Building Track Record', ScoreRules::NEW_VENDOR_LABEL);
    }

    public function test_most_ordered_needs_twenty_orders_and_the_top_ten_percent_with_ties(): void
    {
        $counts = ['a' => 40, 'b' => 40, 'c' => 25, 'd' => 19];
        for ($i = 0; $i < 16; $i++) {
            $counts['x'.$i] = 3;
        }
        // 20 Vendors → ceil(10% × 20) = 2 places; a and b tie for the top and both qualify; c is third.
        self::assertSame(['a', 'b'], ScoreRules::mostOrdered($counts));
        self::assertSame([], ScoreRules::mostOrdered(['solo' => 19]), 'Below 20 completed orders never qualifies.');
        self::assertSame(['solo'], ScoreRules::mostOrdered(['solo' => 20]));
    }

    public function test_mat04_trend_exact_formula_direction_and_null_reasons(): void
    {
        $point = static fn (string $average, int $vendors, array $ids = []): array => ['vendors' => $vendors, 'average' => $average, 'vendor_ids' => $ids === [] ? array_map(static fn (int $i): string => 'v'.$i, range(1, $vendors)) : $ids];
        $up = MaterialsAnalyticsService::trend($point('100.00000000', 3), $point('110.00000000', 3), 2);
        self::assertSame(['10.00', 'INCREASING', null, false], [$up['change_percent'], $up['direction'], $up['reason'], $up['composition_changed']]);
        $down = MaterialsAnalyticsService::trend($point('110.00000000', 2), $point('100.00000000', 2, ['v1', 'v9']), 2);
        self::assertSame(['-9.09', 'DECREASING', true], [$down['change_percent'], $down['direction'], $down['composition_changed']]);
        $flat = MaterialsAnalyticsService::trend($point('100.00000000', 2), $point('100.00400000', 2), 2);
        self::assertSame(['0.00', 'NO_MATERIAL_CHANGE'], [$flat['change_percent'], $flat['direction']]);
        self::assertSame('INSUFFICIENT_LOCAL_DATA', MaterialsAnalyticsService::trend($point('100', 1), $point('110', 2), 2)['reason'], 'Two Vendors at each endpoint.');
        self::assertSame('INSUFFICIENT_COMPETITOR_DATA', MaterialsAnalyticsService::trend($point('100', 2), $point('110', 3), 3)['reason']);
        self::assertSame('MISSING_ENDPOINT_SNAPSHOT', MaterialsAnalyticsService::trend(null, $point('110', 3), 2, false)['reason']);
        self::assertSame('INSUFFICIENT_LOCAL_DATA', MaterialsAnalyticsService::trend(null, $point('110', 3), 2)['reason']);
        self::assertSame('ZERO_BASELINE', MaterialsAnalyticsService::trend($point('0', 2), $point('110', 2), 2)['reason']);
        // Unrounded means: 100.004 → 110.006 is +10.00 (from 10.0019…), never recomputed from displayed values.
        self::assertSame('10.00', MaterialsAnalyticsService::trend($point('100.00400000', 2), $point('110.00600000', 2), 2)['change_percent']);
    }

    public function test_point_status_per_audience_never_reveals_a_vendor_sub_threshold_count(): void
    {
        $one = ['vendors' => 1, 'average' => '100', 'vendor_ids' => ['a']];
        $two = ['vendors' => 2, 'average' => '100', 'vendor_ids' => ['a', 'b']];
        $three = ['vendors' => 3, 'average' => '100', 'vendor_ids' => ['a', 'b', 'c']];
        self::assertSame(['LIMITED_DATA', 'OK', 'NO_LOCAL_OBSERVATIONS', 'MISSING_DAY'], [MaterialsAnalyticsService::pointStatus('BUYER', true, $one), MaterialsAnalyticsService::pointStatus('BUYER', true, $two),
            MaterialsAnalyticsService::pointStatus('ADMIN', true, null), MaterialsAnalyticsService::pointStatus('BUYER', false, null)]);
        self::assertSame(['SUPPRESSED', 'SUPPRESSED', 'SUPPRESSED', 'OK'], [MaterialsAnalyticsService::pointStatus('VENDOR', true, null), MaterialsAnalyticsService::pointStatus('VENDOR', true, $one),
            MaterialsAnalyticsService::pointStatus('VENDOR', true, $two), MaterialsAnalyticsService::pointStatus('VENDOR', true, $three)]);
    }

    public function test_review_windows_names_and_moderation_transitions(): void
    {
        $completed = CarbonImmutable::parse('2026-10-01 23:30:00', 'UTC');
        self::assertSame('2026-10-15 23:30:00', ReviewRules::closesAt($completed)->format('Y-m-d H:i:s'));
        self::assertSame('2026-10-02 23:30:00', ReviewRules::editableUntil($completed)->format('Y-m-d H:i:s'));
        self::assertSame([14, 24, 7, 1000], [ReviewRules::WINDOW_DAYS, ReviewRules::EDIT_HOURS, ReviewRules::CORRECTION_DAYS, ReviewRules::COMMENT_MAX]);
        self::assertSame('Juan C.', ReviewRules::publicName('Juan dela Cruz', 'FIRST_NAME_LAST_INITIAL'));
        self::assertSame('Maria', ReviewRules::publicName('Maria', 'FIRST_NAME_LAST_INITIAL'));
        self::assertSame('Verified Buyer', ReviewRules::publicName('Juan dela Cruz', 'VERIFIED_BUYER'));
        self::assertSame('Verified Buyer', ReviewRules::publicName('', 'FIRST_NAME_LAST_INITIAL'));
        self::assertSame(['DELIVERY_SPEED', 'PROCESSING_SPEED'], [ReviewRules::speedKind('DELIVERY'), ReviewRules::speedKind('PICKUP')]);
        self::assertSame([], ReviewModerationService::actionsFor('REMOVED'), 'Remove is final.');
        self::assertSame(['DISMISS_FLAG', 'HIDE_PENDING_REVIEW', 'REQUEST_CORRECTION', 'REMOVE'], ReviewModerationService::actionsFor('FLAGGED'));
        self::assertNotContains('DELETE', ReviewRules::MODERATION_ACTIONS);
    }

    public function test_materials_analytics_and_store_performance_are_owner_and_manager_only(): void
    {
        $access = new AccountAccess;
        foreach (AccountAccess::VENDOR_ROLES as $role) {
            foreach ([false, true] as $delegated) {
                $permissions = $access->vendorPermissions($role, $delegated);
                $expected = in_array($role, ['OWNER', 'STORE_MANAGER'], true);
                self::assertSame($expected, in_array('materials_analytics.view_competitors', $permissions, true), $role);
                self::assertSame($expected, in_array('scores.view_store', $permissions, true), $role);
                self::assertSame($expected, in_array('portal.materials_analytics', $permissions, true), $role);
                self::assertSame($role === 'OWNER', in_array('finance.view', $permissions, true), 'Analytics never grants protected finance: '.$role);
            }
        }
        self::assertNotContains('reviews.rate_buyer', $access->vendorPermissions('INVENTORY'));
        self::assertNotContains('reviews.rate_buyer', $access->vendorPermissions('FULFILLMENT'));
        self::assertContains('reviews.rate_buyer', $access->vendorPermissions('CUSTOMER_SERVICE'));
    }
}
