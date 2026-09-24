<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class VendorMediaUploadRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'kind' => ['required', Rule::in(['LOGO', 'BANNER', 'PROMOTIONAL_IMAGE', 'PROMOTIONAL_VIDEO'])],
            'file' => ['required', 'file', 'max:20480'],
            'alt_text' => ['sometimes', 'nullable', 'string', 'max:160'],
        ];
    }
}
