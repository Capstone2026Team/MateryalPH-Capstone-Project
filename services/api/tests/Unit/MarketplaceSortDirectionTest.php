<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Procurement\MarketplaceSearchService;
use PHPUnit\Framework\TestCase;
use ReflectionClass;

final class MarketplaceSortDirectionTest extends TestCase
{
    public function test_reverse_sorts_use_real_distance_price_and_rating_and_keep_unrated_last(): void
    {
        $reflection = new ReflectionClass(MarketplaceSearchService::class);
        $service = $reflection->newInstanceWithoutConstructor();
        $key = $reflection->getMethod('sortKey');
        $offers = [
            ['listing_id' => 'near', 'distance' => 100, 'price' => 300, 'rating' => ['average' => '2.00', 'count' => 5]],
            ['listing_id' => 'far', 'distance' => 3000, 'price' => 100, 'rating' => ['average' => '4.50', 'count' => 5]],
            ['listing_id' => 'new', 'distance' => 200, 'price' => 200, 'rating' => ['average' => null, 'count' => 0]],
        ];
        foreach ([
            'DISTANCE' => ['near', 'new', 'far'],
            'DISTANCE_DESC' => ['far', 'new', 'near'],
            'PRICE' => ['far', 'new', 'near'],
            'PRICE_DESC' => ['near', 'new', 'far'],
            'RATING' => ['far', 'near', 'new'],
            'RATING_ASC' => ['near', 'far', 'new'],
        ] as $sort => $expected) {
            $ordered = $offers;
            usort($ordered, static fn (array $a, array $b): int => $key->invoke($service, $sort, $a + ['srs' => '50.0000', 'variant_id' => 'v']) <=> $key->invoke($service, $sort, $b + ['srs' => '50.0000', 'variant_id' => 'v']));
            self::assertSame($expected, array_column($ordered, 'listing_id'), $sort);
        }
    }
}
