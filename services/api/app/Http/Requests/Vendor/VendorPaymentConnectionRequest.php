<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use Illuminate\Foundation\Http\FormRequest;

final class VendorPaymentConnectionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'invitation_url' => ['required', 'url:https', 'max:2048'],
            'provider_account_id' => ['required', 'regex:/^[A-Za-z0-9_-]{3,128}$/'],
        ];
    }
}
