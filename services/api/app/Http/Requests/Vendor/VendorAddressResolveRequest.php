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
            'province_code' => ['required', 'string', 'max:16'],
            'city_code' => ['required', 'string', 'max:16'],
            'psgc_code' => ['required', 'string', 'max:16'],
            'street' => ['nullable', 'string', 'max:200'],
            'unit' => ['nullable', 'string', 'max:120'],
            'postal_code' => ['nullable', 'string', 'max:16'],
        ];
    }
}
