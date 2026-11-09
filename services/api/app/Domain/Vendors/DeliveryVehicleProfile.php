<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

/** Buyer-safe display fields only; fleet availability counts and private operational data stay excluded. */
final class DeliveryVehicleProfile
{
    /** @param array<string, mixed> $configuration
     * @return array<string, string|null>
     */
    public static function from(array $configuration): array
    {
        $profile = [];
        foreach (['name', 'vehicle_category', 'vehicle_type', 'custom_type_name', 'brand', 'image_file_id', 'capacity_kg', 'mixer_capacity_m3', 'cargo_length_m', 'cargo_width_m', 'cargo_height_m', 'heavy_classification'] as $field) {
            $value = $configuration[$field] ?? null;
            $profile[$field] = is_scalar($value) ? (string) $value : null;
        }

        return $profile;
    }
}
