<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Analytics\Products\VendorProductAnalytics;
use PHPUnit\Framework\TestCase;

/** "Top performing" ranks by the Wilson 95% lower bound so a tiny sample cannot outrank a long, steady record. */
final class ProductAnalyticsRankingTest extends TestCase
{
    public function test_wilson_lower_bound_values(): void
    {
        self::assertNull(VendorProductAnalytics::wilson(0, 0));
        self::assertSame(0.0, VendorProductAnalytics::wilson(0, 10));
        self::assertSame(0.0945, VendorProductAnalytics::wilson(1, 2));
        self::assertSame(0.2407, VendorProductAnalytics::wilson(60, 200));
        self::assertSame(0.2065, VendorProductAnalytics::wilson(1, 1));
    }

    public function test_a_long_record_outranks_a_two_view_product_with_a_higher_raw_rate(): void
    {
        self::assertGreaterThan(VendorProductAnalytics::wilson(1, 2), VendorProductAnalytics::wilson(60, 200));
        self::assertGreaterThan(VendorProductAnalytics::wilson(1, 1), VendorProductAnalytics::wilson(60, 200));
    }
}
