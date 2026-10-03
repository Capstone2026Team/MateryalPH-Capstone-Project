<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Orders\OrderQueries;
use PHPUnit\Framework\Attributes\DataProvider;
use PHPUnit\Framework\TestCase;
use ReflectionMethod;

final class OrderPickupAddressTest extends TestCase
{
    /** The API contract declares the pickup address as one line of text, whatever the stored snapshot holds. */
    #[DataProvider('addresses')]
    public function test_pickup_address_is_returned_as_text(mixed $stored, ?string $expected): void
    {
        $method = new ReflectionMethod(OrderQueries::class, 'addressText');
        $method->setAccessible(true);

        $this->assertSame($expected, $method->invoke(null, $stored));
    }

    /** @return array<string, array{mixed, ?string}> */
    public static function addresses(): array
    {
        return [
            'text is kept' => ['1 Example Street, Quezon City', '1 Example Street, Quezon City'],
            'structured address uses its formatted line' => [['province' => 'NCR', 'city_municipality' => 'Quezon City', 'formatted_address' => '1 Example Street, Quezon City'], '1 Example Street, Quezon City'],
            'structured address without a formatted line falls back to city and province' => [['province' => 'NCR', 'city_municipality' => 'Quezon City'], 'Quezon City, NCR'],
            'empty text is absent' => ['', null],
            'empty structure is absent' => [[], null],
            'null is absent' => [null, null],
        ];
    }
}
