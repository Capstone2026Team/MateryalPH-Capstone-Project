<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Validation\ValidationException;

final class VehicleConfiguration
{
    public const TYPES = [
        'MOTORCYCLE' => ['MOTORCYCLE'],
        'PICKUP' => ['COMPACT_PICKUP', 'MID_SIZE_PICKUP', 'HEAVY_DUTY_PICKUP', 'CUSTOM'],
        'VAN' => ['MINI_PANEL_VAN', 'MID_SIZE_CARGO_VAN', 'FULL_SIZE_CARGO_VAN', 'CUSTOM'],
        'TRUCK' => ['BOX_TRUCK', 'WING_TRUCK', 'FLATBED_TRUCK', 'CONCRETE_MIXER', 'CUSTOM'],
    ];

    /** @param array<string, mixed> $vehicle
     * @return array<string, mixed>
     */
    public static function normalize(array $vehicle, int $index): array
    {
        $category = $vehicle['vehicle_category'] ?? null;
        // Legacy callers may retain their existing shape; these records are not recommendation-ready.
        if ($category === null) {
            return [];
        }
        $type = $vehicle['vehicle_type'] ?? '';
        $errors = [];
        if (! in_array($type, self::TYPES[$category] ?? [], true)) {
            $errors["vehicles.$index.vehicle_type"] = 'Choose a vehicle type belonging to the selected category.';
        }
        if ($type === 'CUSTOM' && trim((string) ($vehicle['custom_type_name'] ?? '')) === '') {
            $errors["vehicles.$index.custom_type_name"] = 'Enter the custom vehicle type name.';
        }
        if ($type === 'CONCRETE_MIXER' && (float) ($vehicle['mixer_capacity_m3'] ?? 0) <= 0) {
            $errors["vehicles.$index.mixer_capacity_m3"] = 'Enter a positive mixer capacity in cubic meters.';
        }
        if ($type !== 'CONCRETE_MIXER') {
            foreach (['cargo_length_m', 'cargo_width_m', 'cargo_height_m'] as $field) {
                if ((float) ($vehicle[$field] ?? 0) <= 0) {
                    $errors["vehicles.$index.$field"] = 'Enter a positive usable cargo dimension.';
                }
            }
        }
        if (! in_array($vehicle['heavy_classification'] ?? '', ['HEAVY', 'NOT_HEAVY'], true)) {
            $errors["vehicles.$index.heavy_classification"] = 'Select whether this is a heavy vehicle.';
        }
        if ($errors !== []) {
            throw ValidationException::withMessages($errors);
        }

        return [
            'vehicle_category' => $category,
            'custom_type_name' => $type === 'CUSTOM' ? trim((string) $vehicle['custom_type_name']) : null,
            'brand' => isset($vehicle['brand']) ? trim((string) $vehicle['brand']) : null,
            'mixer_capacity_m3' => $type === 'CONCRETE_MIXER' ? $vehicle['mixer_capacity_m3'] : null,
        ];
    }
}
