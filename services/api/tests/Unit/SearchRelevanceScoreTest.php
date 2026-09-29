<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Finance\FinancialSnapshotService;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Procurement\RankingWeights;
use App\Domain\Procurement\SearchRelevanceScore;
use PHPUnit\Framework\TestCase;

final class SearchRelevanceScoreTest extends TestCase
{
    public function test_each_component_is_normalized_to_0_100_and_clamped(): void
    {
        self::assertSame('100.00000000', SearchRelevanceScore::distance(0, 5000));
        self::assertSame('50.00000000', SearchRelevanceScore::distance(2500, 5000));
        self::assertSame('0.00000000', SearchRelevanceScore::distance(5000, 5000));
        self::assertSame('0.00000000', SearchRelevanceScore::distance(5001, 5000), 'Never negative just past the boundary.');

        self::assertSame('100.00000000', SearchRelevanceScore::price('15.00000000', '15.00000000'));
        self::assertSame('83.33333300', SearchRelevanceScore::price('15.00000000', '18.00000000'));
        self::assertSame('100.00000000', SearchRelevanceScore::price('15.00000000', '12.00000000'), 'Capped at 100.');
        self::assertSame('50.00000000', SearchRelevanceScore::price(null, null), 'Not Yet Comparable uses the approved neutral 50.');

        self::assertSame('50.00000000', SearchRelevanceScore::vps(null), 'New Vendor internal default.');
        self::assertSame('0.00000000', SearchRelevanceScore::vps('1.00'));
        self::assertSame('100.00000000', SearchRelevanceScore::vps('5.00'));
        self::assertSame('75.00000000', SearchRelevanceScore::vps('4.00'));

        self::assertSame('100.00000000', SearchRelevanceScore::stock('IN_STOCK'));
        self::assertSame('50.00000000', SearchRelevanceScore::stock('LIMITED_STOCK'));
        self::assertNull(SearchRelevanceScore::stock('OUT_OF_STOCK'), 'Out of Stock is excluded, not scored zero.');

        self::assertSame('60.00000000', SearchRelevanceScore::productRating(null), 'Unrated listing internal default, labelled New.');
        self::assertSame('92.00000000', SearchRelevanceScore::productRating('4.60'));
    }

    public function test_srs_is_a_normalized_weighted_sum_with_the_approved_default_weights(): void
    {
        $default = RankingWeights::fromInput(RankingWeights::APPROVED_DEFAULT);
        self::assertSame(['distance' => 30, 'price' => 25, 'vps' => 20, 'stock' => 15, 'product_rating' => 10], $default->values);
        $components = ['distance' => '80', 'price' => SearchRelevanceScore::price('15', '18'), 'vps' => '50', 'stock' => '100', 'product_rating' => '60'];
        self::assertSame('75.8333', SearchRelevanceScore::combine($components, $default));
        self::assertSame('100.0000', SearchRelevanceScore::combine(array_fill_keys(RankingWeights::COMPONENTS, '100'), $default));
        self::assertSame('0.0000', SearchRelevanceScore::combine(['distance' => '0', 'price' => '0', 'vps' => '0', 'stock' => '0', 'product_rating' => '0'], $default));

        $personal = RankingWeights::fromInput(['distance' => 100, 'price' => 0, 'vps' => 0, 'stock' => 0, 'product_rating' => 0]);
        self::assertSame('80.0000', SearchRelevanceScore::combine($components, $personal));
        self::assertSame(758333, SearchRelevanceScore::sortInteger('75.8333'));

        $explained = SearchRelevanceScore::explain($components, $default, ['distance' => '1.0 km']);
        self::assertSame(['distance', 'price', 'vps', 'stock', 'product_rating'], array_column($explained, 'key'));
        self::assertSame(['80.00', '24.00'], [$explained[0]['score'], $explained[0]['weighted']]);
        self::assertSame(['83.33', '20.83'], [$explained[1]['score'], $explained[1]['weighted']]);
        self::assertSame('1.0 km', $explained[0]['basis']);
    }

    public function test_weights_must_be_whole_percentages_totalling_100_and_never_all_zero(): void
    {
        self::assertSame([], RankingWeights::errors(['distance' => 20, 'price' => 20, 'vps' => 20, 'stock' => 20, 'product_rating' => 20]));
        self::assertArrayHasKey('weights', RankingWeights::errors(['distance' => 20, 'price' => 20, 'vps' => 20, 'stock' => 20, 'product_rating' => 10]));
        self::assertArrayHasKey('weights.distance', RankingWeights::errors(['distance' => -10, 'price' => 60, 'vps' => 20, 'stock' => 20, 'product_rating' => 10]));
        self::assertArrayHasKey('weights.distance', RankingWeights::errors(['distance' => 25.5, 'price' => 24.5, 'vps' => 20, 'stock' => 20, 'product_rating' => 10]));
        self::assertArrayHasKey('weights.product_rating', RankingWeights::errors(['distance' => 50, 'price' => 50, 'vps' => 0, 'stock' => 0]));
        self::assertArrayHasKey('weights.sponsored', RankingWeights::errors(['distance' => 50, 'price' => 50, 'vps' => 0, 'stock' => 0, 'product_rating' => 0, 'sponsored' => 0]));
        foreach ([['distance' => 0, 'price' => 0, 'vps' => 0, 'stock' => 0, 'product_rating' => 0], ['distance' => 40, 'price' => 40, 'vps' => 0, 'stock' => 0, 'product_rating' => 0]] as $invalid) {
            try {
                RankingWeights::fromInput($invalid);
                self::fail('Invalid weights must be rejected.');
            } catch (AuthenticationException $exception) {
                self::assertContains($exception->errorCode, ['WEIGHTS_ALL_ZERO', 'WEIGHTS_TOTAL_INVALID']);
                self::assertSame(422, $exception->httpStatus);
            }
        }
    }

    public function test_fin02_line_amounts_round_half_up_and_included_vat_is_never_added(): void
    {
        self::assertSame(1234, FinancialSnapshotService::lineAmountCentavos('1.0000', 1234));
        self::assertSame(1851, FinancialSnapshotService::lineAmountCentavos('1.5000', 1234), '1,851.0 centavos.');
        self::assertSame(617, FinancialSnapshotService::lineAmountCentavos('0.5000', 1233), '616.5 rounds half-up to 617.');
        $preview = (new FinancialSnapshotService)->previewChildOrder([
            ['line_id' => 'a', 'quantity' => '3.0000', 'unit_price_centavos' => 11200, 'tax_category' => 'VAT_12'],
            ['line_id' => 'b', 'quantity' => '2.0000', 'unit_price_centavos' => 5000, 'tax_category' => 'VAT_EXEMPT'],
        ], ['status' => 'ESTIMATE', 'min_centavos' => 60500, 'max_centavos' => 70000]);
        self::assertSame(43600, $preview['materials_subtotal_centavos']);
        self::assertSame(3600, $preview['included_vat_centavos']);
        self::assertSame(40000, $preview['vat_exclusive_materials_centavos']);
        self::assertSame([104100, 113600], [$preview['total_before_processing_min_centavos'], $preview['total_before_processing_max_centavos']]);
        self::assertSame(['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'], $preview['excludes']);
        self::assertNull($preview['processing_fee']['amount_centavos']);
    }
}
