<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Analytics\Geo\DisclosureControl;
use App\Domain\Settings\PlatformSettingRegistry;
use PHPUnit\Framework\TestCase;

final class PhaseSixteenRulesTest extends TestCase
{
    public function test_small_cells_are_suppressed_and_a_lone_hidden_sibling_gets_complementary_protection(): void
    {
        $k = new DisclosureControl(5);
        self::assertSame(['a' => DisclosureControl::COMPLEMENTARY, 'b' => DisclosureControl::PRIMARY, 'c' => null], $k->siblings(['a' => 12, 'b' => 2, 'c' => 0]),
            'Exactly one primary cell forces the smallest other non-zero sibling to be hidden.');
        self::assertSame(['a' => DisclosureControl::COMPLEMENTARY, 'b' => DisclosureControl::PRIMARY, 'c' => null, 'd' => null], $k->siblings(['a' => 7, 'b' => 4, 'c' => 0, 'd' => 30]),
            'The smallest visible non-zero sibling is chosen; empty cells are never chosen.');
        self::assertSame(['a' => DisclosureControl::PRIMARY, 'b' => DisclosureControl::PRIMARY, 'c' => null], $k->siblings(['a' => 1, 'b' => 4, 'c' => 9]), 'Two primary cells need no complement.');
        self::assertSame(['a' => null, 'b' => null], $k->siblings(['a' => 5, 'b' => 0]), 'Exactly k persons is shown; zero reveals nothing.');
        self::assertFalse($k->suppressed(0));
        self::assertTrue($k->suppressed(4));
        self::assertStringContainsString('Region X total', (string) $k->message(DisclosureControl::PRIMARY, 'Region X'));
    }

    public function test_registry_validates_totals_ranges_cross_setting_rules_and_rejects_unknown_keys(): void
    {
        $current = [];
        foreach (PlatformSettingRegistry::definitions() as $key => $definition) {
            self::assertSame([], PlatformSettingRegistry::errors($key, $definition['default'], $current + ['orders.pending_payment_window_hours' => 24]), 'The approved default for '.$key.' is valid.');
            $current[$key] = $definition['default'];
        }
        self::assertNotSame([], PlatformSettingRegistry::errors('ranking.fms.default_weights', ['material_match' => 40, 'budget_fit' => 25, 'distance' => 20, 'vps' => 10], $current));
        self::assertNotSame([], PlatformSettingRegistry::errors('reminders.payment_hours_before', [30, 1], $current), 'Reminders must be shorter than the Pending Payment window.');
        self::assertNotSame([], PlatformSettingRegistry::errors('quotations.deadline_limits', ['min_hours' => 10, 'max_hours' => 8, 'default_hours' => 9], $current));
        self::assertNotSame([], PlatformSettingRegistry::errors('uploads.limits_kb', ['vendor_document' => 20480] + $current['uploads.limits_kb'], $current), 'A limit cannot exceed its ceiling.');
        self::assertNotSame([], PlatformSettingRegistry::errors('badges.thresholds', ['highly_rated' => ['min_vcs' => '5.10', 'min_vendor_ratings' => 10]] + $current['badges.thresholds'], $current));
        self::assertNotSame([], PlatformSettingRegistry::errors('analytics.disclosure_min_persons', 2, $current), 'The disclosure threshold cannot drop below three.');
        self::assertNotSame([], PlatformSettingRegistry::errors('orders.nrpc_cap', 1000, $current));
        self::assertFalse(PlatformSettingRegistry::exists('ranking.vps_weights'));
    }
}
