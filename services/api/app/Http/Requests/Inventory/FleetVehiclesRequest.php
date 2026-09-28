<?php

declare(strict_types=1);

namespace App\Http\Requests\Inventory;

use App\Domain\Vendors\VehicleConfiguration;
use App\Domain\Vendors\VendorFleetService;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/** Transport shape only; per-vehicle business validation is reported by the fleet use case. */
final class FleetVehiclesRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'vehicles' => ['required', 'array', 'min:1', 'max:'.VendorFleetService::MAX_VEHICLES],
            'vehicles.*' => ['array'],
            'vehicles.*.id' => ['sometimes', 'uuid', 'distinct'],
            'vehicles.*.lock_version' => ['sometimes', 'integer', 'min:0'],
            'vehicles.*.removed' => ['sometimes', 'boolean'],
            'vehicles.*.vehicle_category' => ['sometimes', 'nullable', Rule::in(array_keys(VehicleConfiguration::TYPES))],
            'vehicles.*.vehicle_type' => ['sometimes', 'nullable', 'string', 'max:32'],
            'vehicles.*.custom_type_name' => ['sometimes', 'nullable', 'string', 'max:120'],
            'vehicles.*.name' => ['sometimes', 'nullable', 'string', 'max:120'],
            'vehicles.*.brand' => ['sometimes', 'nullable', 'string', 'max:120'],
            'vehicles.*.image_file_id' => ['sometimes', 'nullable', 'uuid'],
            'vehicles.*.heavy_classification' => ['sometimes', 'nullable', Rule::in(['HEAVY', 'NOT_HEAVY'])],
            'vehicles.*.active' => ['sometimes', 'boolean'],
            'vehicles.*.available' => ['sometimes', 'boolean'],
            'vehicles.*.number_available' => ['sometimes'],
            'vehicles.*.capacity_kg' => ['sometimes'],
            'vehicles.*.cargo_length_m' => ['sometimes'],
            'vehicles.*.cargo_width_m' => ['sometimes'],
            'vehicles.*.cargo_height_m' => ['sometimes'],
            'vehicles.*.mixer_capacity_m3' => ['sometimes'],
            'vehicles.*.base_fee_centavos' => ['sometimes'],
            'vehicles.*.per_km_centavos' => ['sometimes'],
            'vehicles.*.maximum_distance_km' => ['sometimes'],
        ];
    }
}
