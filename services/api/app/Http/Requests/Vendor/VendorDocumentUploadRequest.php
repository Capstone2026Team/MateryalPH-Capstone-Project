<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use App\Domain\Vendors\VendorOnboardingService;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class VendorDocumentUploadRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'requirement_key' => ['required', Rule::in(array_keys(VendorOnboardingService::DOCUMENTS))],
            'file' => ['required', 'file', 'mimes:jpg,jpeg,png,pdf', 'max:10240'],
            'metadata' => ['sometimes', 'array', 'max:20'],
            'metadata.*' => ['nullable', 'string', 'max:255'],
        ];
    }
}
