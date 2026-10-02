<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Procurement\DeliveryPreviewService;
use App\Domain\Projects\FulfillmentMatchScore as FMS;
use App\Domain\Projects\ProjectBudget;
use App\Domain\Projects\ProjectInquiryService;
use App\Domain\Vendors\DeliveryRecommendationService;
use PHPUnit\Framework\TestCase;

final class PhaseTenProjectCalculationsTest extends TestCase
{
    public function test_default_fms_is_normalized_and_new_vendor_is_neutral(): void
    {
        $score = FMS::calculate('10', '10', 9000, 10000, 2500, 5, null, FMS::DEFAULTS);
        self::assertSame('82.50', $score['score']);
        self::assertSame('50.00000000', $score['components']['vps']);
        self::assertSame('100', $score['components']['budget_fit']);
    }

    public function test_overage_distance_boundary_missing_lines_and_unknown_cost_are_explicit(): void
    {
        $score = FMS::calculate('5', '10', 11000, 10000, 5000, 5, '5', FMS::DEFAULTS);
        self::assertSame('47.50', $score['score']);
        self::assertSame('50.00000000', $score['components']['budget_fit']);
        self::assertNull(FMS::calculate('5', '10', null, 10000, 0, 5, null, FMS::DEFAULTS)['score']);
        self::assertSame('0', FMS::calculate('5', '10', 1, 0, 0, 5, null, FMS::DEFAULTS)['components']['budget_fit']);
    }

    public function test_separate_project_preferences_require_four_integer_weights_and_100_percent(): void
    {
        foreach ([['material_match' => 40, 'budget_fit' => 25, 'distance' => 20, 'vps' => 14], ['material_match' => '40', 'budget_fit' => 25, 'distance' => 20, 'vps' => 15], ['material_match' => 40, 'budget_fit' => 25, 'distance' => 20, 'vps' => 15, 'extra' => 0]] as $weights) {
            try {
                FMS::validate($weights);
                self::fail('Invalid weights must fail');
            } catch (AuthenticationException $e) {
                self::assertSame(422, $e->httpStatus);
            }
        }
        self::assertSame(FMS::DEFAULTS, FMS::validate(FMS::DEFAULTS));
    }

    public function test_fin_11_keeps_order_buckets_disjoint_and_actual_is_subtracted_once(): void
    {
        self::assertSame(['pending' => 10000, 'actual' => 0, 'recovery' => 0], ProjectBudget::orderBuckets('PROCESSING', true, 10000, 6000, 0, 0));
        self::assertSame(['pending' => 0, 'actual' => 8000, 'recovery' => 0], ProjectBudget::orderBuckets('COMPLETED', true, 10000, 10000, 2000, 0));
        self::assertSame(['pending' => 0, 'actual' => 2000, 'recovery' => 4000], ProjectBudget::orderBuckets('CANCELLED', true, 10000, 8000, 2000, 2000));
        self::assertSame(['pending' => 0, 'actual' => 0, 'recovery' => 0], ProjectBudget::orderBuckets('EXPIRED', false, 10000, 0, 0, 0));
        $metrics = ProjectBudget::buckets(30000, 10000, 10000, 4000);
        self::assertSame(24000, $metrics['committed_centavos']);
        self::assertSame(6000, $metrics['remaining_centavos']);
        self::assertFalse($metrics['warning']);
        self::assertTrue(ProjectBudget::buckets(30000, 27000, 0, 0)['warning']);
        self::assertSame(-1, ProjectBudget::buckets(30000, 30001, 0, 0)['remaining_centavos']);
    }

    public function test_mixer_volume_and_bagged_cargo_reuse_the_same_advisor_boundary(): void
    {
        $mixer = DeliveryPreviewService::loadGroupFor('r', '4.5', ['weight_kg' => '2400', 'length_cm' => null, 'width_cm' => null, 'height_cm' => null, 'material_kind' => DeliveryRecommendationService::READY_MIXED_CONCRETE, 'volume_m3_per_unit' => '1']);
        self::assertSame('READY_MIXED_CONCRETE', $mixer['material_kind']);
        self::assertEquals(4.5, $mixer['volume_m3']);
        self::assertEquals(10800, $mixer['weight_kg']);
        $bags = DeliveryPreviewService::loadGroupFor('c', '50', ['weight_kg' => '40', 'length_cm' => '60', 'width_cm' => '40', 'height_cm' => '15']);
        self::assertSame('CARGO', $bags['material_kind']);
        self::assertArrayNotHasKey('volume_m3', $bags);
    }

    public function test_repeated_requirements_do_not_create_duplicate_stock_order_rows(): void
    {
        $line = ['variant_id' => 'v', 'matched_quantity' => '2', 'line_id' => 'a', 'unit_price_centavos' => 1500, 'tax_category' => 'NON_VAT', 'amount_centavos' => 3000, 'included_vat_centavos' => 0];
        $rows = ProjectInquiryService::aggregateLines([$line, array_replace($line, ['line_id' => 'b'])]);
        self::assertCount(1, $rows);
        self::assertSame('4.0000', $rows[0]['matched_quantity']);
        self::assertSame(['a', 'b'], $rows[0]['work_package_line_ids']);
        self::assertSame(6000, $rows[0]['amount_centavos']);
    }
}
