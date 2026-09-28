<?php

declare(strict_types=1);

namespace App\Http\Requests\Inventory;

use Illuminate\Foundation\Http\FormRequest;

final class AutoAcceptPolicyRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'lock_version' => ['required', 'integer', 'min:0'],
            'enabled' => ['required', 'boolean'],
            'allotment_quantity' => ['required', 'regex:/^\d{1,14}$/'],
            'max_unit_count' => ['sometimes', 'nullable', 'regex:/^\d{1,14}(\.\d{1,4})?$/'],
            'max_order_amount_centavos' => ['sometimes', 'nullable', 'integer', 'min:1', 'max:100000000000'],
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'allotment_quantity.regex' => 'Enter a whole-number allotment of zero or more.',
            'max_unit_count.regex' => 'Enter a maximum unit count above zero, or leave it empty for no unit cap.',
        ];
    }
}
