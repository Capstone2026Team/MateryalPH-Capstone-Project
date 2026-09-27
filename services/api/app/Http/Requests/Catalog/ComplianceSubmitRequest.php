<?php

declare(strict_types=1);

namespace App\Http\Requests\Catalog;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class ComplianceSubmitRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'listing_lock_version' => ['required', 'integer', 'min:1'],
            'path' => ['required', Rule::in(['PHOTO_OCR', 'QR', 'MANUAL'])],
            'evidence_ids' => ['required', 'array', 'min:1', 'max:5'],
            'evidence_ids.*' => ['uuid', 'distinct'],
            'marking_type' => ['required', Rule::in(['PS_MARK', 'ICC_STICKER'])],
            'certificate_number' => ['required', 'string', 'min:3', 'max:60', 'regex:/^[A-Za-z0-9][A-Za-z0-9 .\/-]*$/'],
            'manufacturer_name' => ['required_if:marking_type,PS_MARK', 'nullable', 'string', 'max:200'],
            'manufacturer_address' => ['nullable', 'string', 'max:500'],
            'importer_name' => ['required_if:marking_type,ICC_STICKER', 'nullable', 'string', 'max:200'],
            'importer_address' => ['nullable', 'string', 'max:500'],
            'country_of_manufacture' => ['nullable', 'string', 'max:60'],
            'brand' => ['nullable', 'string', 'max:180'],
            'batch_number' => ['nullable', 'string', 'max:60'],
            'confirmed' => ['accepted'],
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'manufacturer_name.required_if' => 'Enter the manufacturer named on the PS licence.',
            'importer_name.required_if' => 'Enter the importer named on the ICC certificate.',
            'confirmed.accepted' => 'Confirm that you reviewed the values against the physical marking.',
        ];
    }
}
