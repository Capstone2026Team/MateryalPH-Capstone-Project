<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use Illuminate\Foundation\Http\FormRequest;

final class VendorSetupCompleteRequest extends FormRequest
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
            'commission_terms_accepted' => ['accepted'],
        ];
    }
}
