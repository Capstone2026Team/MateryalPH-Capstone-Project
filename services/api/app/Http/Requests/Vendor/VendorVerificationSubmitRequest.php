<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use Illuminate\Foundation\Http\FormRequest;

final class VendorVerificationSubmitRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return ['lock_version' => ['required', 'integer', 'min:1'], 'privacy_acknowledged' => ['accepted']];
    }
}
