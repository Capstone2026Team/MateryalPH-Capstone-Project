<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use App\Domain\Vendors\StoreOperatingSchedule;
use App\Domain\Vendors\VehicleConfiguration;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Validator;

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
            'draft_lock_version' => ['sometimes', 'integer', 'min:0'],
            'organization_lock_version' => ['required', 'integer', 'min:1'],
            'public_store_name' => ['sometimes', 'string', 'max:180'],
            'form_state' => ['sometimes', 'string', 'json', 'max:65536'],
            'vacation_mode' => ['sometimes', 'boolean'],
            'description' => ['sometimes', 'nullable', 'string', 'max:3000'],
            'bulk_capability' => ['sometimes', 'boolean'],
            'fulfillment_method' => ['sometimes', Rule::in(['SELF_PICKUP', 'VENDOR_DELIVERY', 'BOTH'])],
            'public_email' => ['sometimes', 'nullable', 'email:rfc', 'max:254'],
            'public_phone' => ['sometimes', 'nullable', 'string', 'max:24'],
            'operating_schedule' => ['sometimes', 'array', 'size:7'],
            'operating_schedule.*.day_of_week' => ['required_with:operating_schedule', 'integer', 'between:1,7', 'distinct'],
            'operating_schedule.*.status' => ['required_with:operating_schedule', Rule::in(['OPEN', 'CLOSED'])],
            'operating_schedule.*.opens_at' => ['sometimes', 'nullable', 'date_format:H:i'],
            'operating_schedule.*.closes_at' => ['sometimes', 'nullable', 'date_format:H:i'],
            'delivery' => ['sometimes', 'array'],
            'delivery.maximum_distance_km' => ['sometimes', 'integer', 'between:1,1000'],
            'delivery.coverage_notes' => ['sometimes', 'nullable', 'string', 'max:1000'],
            'vehicles' => ['sometimes', 'array'],
            'vehicles.*.id' => ['sometimes', 'uuid', 'distinct'],
            'vehicles.*.vehicle_category' => ['sometimes', Rule::in(array_keys(VehicleConfiguration::TYPES))],
            'vehicles.*.custom_type_name' => ['sometimes', 'nullable', 'string', 'max:120'],
            'vehicles.*.brand' => ['sometimes', 'nullable', 'string', 'max:120'],
            'vehicles.*.mixer_capacity_m3' => ['sometimes', 'nullable', 'numeric', 'gt:0', 'max:1000000'],
            'vehicles.*.image_file_id' => ['sometimes', 'nullable', 'uuid'],
            'vehicles.*.active' => ['sometimes', 'boolean'],
            'vehicles.*.vehicle_type' => ['required_unless:vehicles.*.active,false', 'string', 'max:32'],
            'vehicles.*.name' => ['required_unless:vehicles.*.active,false', 'string', 'max:120'],
            'vehicles.*.capacity_kg' => ['required_unless:vehicles.*.active,false', 'numeric', 'gt:0', 'max:1000000'],
            'vehicles.*.number_available' => ['required_unless:vehicles.*.active,false', 'integer', 'min:1', 'max:10000'],
            'vehicles.*.cargo_length_m' => ['sometimes', 'nullable', 'numeric', 'gt:0', 'max:1000'],
            'vehicles.*.cargo_width_m' => ['sometimes', 'nullable', 'numeric', 'gt:0', 'max:1000'],
            'vehicles.*.cargo_height_m' => ['sometimes', 'nullable', 'numeric', 'gt:0', 'max:1000'],
            'vehicles.*.heavy_classification' => ['sometimes', 'nullable', 'string', 'max:32'],
            'vehicles.*.base_fee_centavos' => ['sometimes', 'integer', 'min:0', 'max:1000000000'],
            'vehicles.*.per_km_centavos' => ['sometimes', 'integer', 'min:0', 'max:1000000000'],
            'vehicles.*.maximum_distance_km' => ['sometimes', 'integer', 'between:1,1000'],
        ];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $validator): void {
            if (! $this->exists('operating_schedule') || $validator->errors()->has('operating_schedule*')) {
                return;
            }
            $days = $this->input('operating_schedule', []);
            if (! is_array($days) || ! array_is_list($days) || ! app(StoreOperatingSchedule::class)->valid($days)) {
                $validator->errors()->add('operating_schedule', 'Set all seven days explicitly. Open days need valid opening and later closing times; closed days have no times.');
            }
        });
    }
}
