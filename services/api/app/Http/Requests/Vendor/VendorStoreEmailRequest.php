<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use Illuminate\Foundation\Http\FormRequest;

final class VendorStoreEmailRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return match ($this->route()?->getActionMethod()) {
            'requestStoreEmailVerification' => ['email' => ['required', 'email:rfc', 'max:254']],
            'confirmStoreEmailVerification' => ['email' => ['required', 'email:rfc', 'max:254'], 'code' => ['required', 'digits:6']],
            default => [],
        };
    }
}
