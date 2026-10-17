<?php

declare(strict_types=1);

namespace App\Http\Requests\Catalog;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

/**
 * The Vendor supplies the PS License No. or ICC sticker serial; a register match
 * supplies the manufacturer or importer. The other fields are optional and are
 * kept only for a manual-review request or as additional marking details.
 */
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
            'review_mode' => ['sometimes', Rule::in(['AUTOMATIC', 'MANUAL_REVIEW'])],
            'evidence_ids' => ['required', 'array', 'min:1', 'max:5'],
            'evidence_ids.*' => ['uuid', 'distinct'],
            'marking_type' => ['required', Rule::in(['PS_MARK', 'ICC_STICKER'])],
            'certificate_number' => ['required', 'string', 'min:3', 'max:60', 'regex:/^[A-Za-z0-9][A-Za-z0-9 .\/-]*$/'],
            'manufacturer_name' => ['nullable', 'string', 'max:200'],
            'manufacturer_address' => ['nullable', 'string', 'max:500'],
            'importer_name' => ['nullable', 'string', 'max:200'],
            'importer_address' => ['nullable', 'string', 'max:500'],
            'country_of_manufacture' => ['nullable', 'string', 'max:60'],
            'brand' => ['nullable', 'string', 'max:180'],
            'batch_number' => ['nullable', 'string', 'max:60'],
            'review_note' => ['nullable', 'string', 'max:500'],
            'confirmed' => ['accepted'],
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'certificate_number.required' => 'Enter the PS License No. or ICC sticker serial printed on the marking.',
            'certificate_number.regex' => 'Use only the letters, digits, spaces, dots, slashes and hyphens printed on the marking.',
            'confirmed.accepted' => 'Confirm that you checked the number against the physical marking.',
        ];
    }
}
