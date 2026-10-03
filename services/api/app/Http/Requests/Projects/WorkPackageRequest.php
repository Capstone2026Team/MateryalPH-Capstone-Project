<?php

declare(strict_types=1);

namespace App\Http\Requests\Projects;

use Illuminate\Foundation\Http\FormRequest;

final class WorkPackageRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'BUYER';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return ['lock_version' => ['sometimes', 'integer', 'min:1'], 'name' => ['required', 'string', 'max:150'], 'description' => ['nullable', 'string', 'max:2000'],
            'budget_centavos' => ['required', 'integer', 'between:0,100000000000'], 'site_id' => ['required', 'uuid'], 'radius_km' => ['required', 'integer', 'in:5,10,20,30,40,50'],
            'fulfillment_method' => ['required', 'in:PICKUP,DELIVERY'], 'payment_method' => ['required', 'in:ONLINE,CASH_ON_DELIVERY,IN_STORE', static function (string $attribute, mixed $value, \Closure $fail) {
                if (($value === 'CASH_ON_DELIVERY' && request()->input('fulfillment_method') !== 'DELIVERY') || ($value === 'IN_STORE' && request()->input('fulfillment_method') !== 'PICKUP')) {
                    $fail('Cash on Delivery pairs with Site Delivery and In-Store Payment with Self-Pickup.');
                }
            }],
            'site_contact' => ['required_if:fulfillment_method,DELIVERY', 'nullable', 'string', 'min:3', 'max:200'],
            'heavy_vehicle_restriction' => ['required_if:fulfillment_method,DELIVERY', 'in:NO,YES'],
            'alternate_drop_off_location_id' => ['required_if:heavy_vehicle_restriction,YES', 'nullable', 'uuid'],
            'access_instructions' => ['required_if:fulfillment_method,DELIVERY', 'nullable', 'string', 'min:5', 'max:500'],
            'lines' => ['required', 'array', 'min:1', 'max:100'], 'lines.*.material_id' => ['required', 'uuid'], 'lines.*.name' => ['required', 'string', 'max:200'],
            'lines.*.unit_id' => ['required', 'uuid'], 'lines.*.quantity' => ['required', 'regex:/^\d{1,7}(\.\d{1,4})?$/', 'numeric', 'gt:0', 'max:1000000'],
            'lines.*.specifications' => ['present', 'array', 'max:30'], 'lines.*.specifications.*' => ['string', 'max:200'], 'lines.*.preferred_brand' => ['nullable', 'string', 'max:100']];
    }
}
