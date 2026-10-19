<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use Illuminate\Foundation\Http\FormRequest;

final class VendorAddressResolveRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'pin_token' => ['nullable', 'string', 'max:8192'],
            'province_code' => ['sometimes', 'required_with:city_code,psgc_code', 'string', 'max:16'],
            'city_code' => ['sometimes', 'required_with:province_code,psgc_code', 'string', 'max:16'],
            'psgc_code' => ['sometimes', 'required_with:province_code,city_code', 'string', 'max:16'],
            'province' => ['required_without:province_code', 'string', 'max:120'],
            'city_municipality' => ['required_without:city_code', 'string', 'max:120'],
            'barangay' => ['required_without:psgc_code', 'string', 'max:120'],
            'street' => ['nullable', 'string', 'max:200'],
            'unit' => ['nullable', 'string', 'max:120'],
            'postal_code' => ['nullable', 'string', 'max:16'],
        ];
    }
}
