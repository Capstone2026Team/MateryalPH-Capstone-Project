<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Vendors\DeliveryVehicleProfile;
use PHPUnit\Framework\TestCase;

final class DeliveryVehicleProfileTest extends TestCase
{
    public function test_only_display_fields_are_shared_and_historical_missing_fields_are_nullable(): void
    {
        $profile = DeliveryVehicleProfile::from(['name' => 'Mixer A', 'capacity_kg' => 14400, 'mixer_capacity_m3' => '6', 'image_file_id' => 'photo', 'number_available' => 7, 'internal_note' => 'private']);
        self::assertSame('14400', $profile['capacity_kg']);
        self::assertSame('6', $profile['mixer_capacity_m3']);
        self::assertSame('photo', $profile['image_file_id']);
        self::assertNull($profile['brand']);
        self::assertArrayNotHasKey('number_available', $profile);
        self::assertArrayNotHasKey('internal_note', $profile);
    }
}
