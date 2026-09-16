<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class VendorSetupDraftRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'organization_lock_version' => ['required', 'integer', 'min:1'],
            'public_store_name' => ['sometimes', 'string', 'max:180'],
            'description' => ['sometimes', 'nullable', 'string', 'max:3000'],
            'bulk_capability' => ['sometimes', 'boolean'],
            'fulfillment_method' => ['sometimes', Rule::in(['SELF_PICKUP', 'VENDOR_DELIVERY', 'BOTH'])],
            'public_email' => ['sometimes', 'nullable', 'email:rfc', 'max:254'],
            'public_phone' => ['sometimes', 'nullable', 'string', 'max:24'],
            'delivery' => ['sometimes', 'array'],
            'delivery.maximum_distance_km' => ['required_with:delivery', 'integer', 'between:1,1000'],
            'delivery.coverage_notes' => ['sometimes', 'nullable', 'string', 'max:1000'],
            'vehicles' => ['sometimes', 'array', 'max:20'],
            'vehicles.*.id' => ['sometimes', 'uuid'],
            'vehicles.*.vehicle_type' => ['required', 'string', 'max:32'],
            'vehicles.*.name' => ['required', 'string', 'max:120'],
            'vehicles.*.capacity_kg' => ['required', 'numeric', 'gt:0', 'max:1000000'],
            'vehicles.*.number_available' => ['required', 'integer', 'min:1', 'max:10000'],
            'vehicles.*.cargo_length_m' => ['sometimes', 'nullable', 'numeric', 'gt:0', 'max:1000'],
            'vehicles.*.cargo_width_m' => ['sometimes', 'nullable', 'numeric', 'gt:0', 'max:1000'],
            'vehicles.*.cargo_height_m' => ['sometimes', 'nullable', 'numeric', 'gt:0', 'max:1000'],
            'vehicles.*.heavy_classification' => ['sometimes', 'nullable', 'string', 'max:32'],
            'vehicles.*.base_fee_centavos' => ['sometimes', 'integer', 'min:0', 'max:1000000000'],
            'vehicles.*.per_km_centavos' => ['sometimes', 'integer', 'min:0', 'max:1000000000'],
            'vehicles.*.maximum_distance_km' => ['sometimes', 'integer', 'between:1,1000'],
        ];
    }
}
