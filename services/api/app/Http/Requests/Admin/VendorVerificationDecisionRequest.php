<?php

declare(strict_types=1);

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class VendorVerificationDecisionRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'ADMIN';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'decision' => ['required', Rule::in(['APPROVED', 'CHANGES_REQUIRED', 'REJECTED'])],
            'lock_version' => ['sometimes', 'integer', 'min:1'],
            'reason' => ['required_unless:decision,APPROVED', 'nullable', 'string', 'min:3', 'max:2000'],
            'verified_document_number' => ['sometimes', 'nullable', 'string', 'max:180'],
            'verified_issue_date' => ['sometimes', 'nullable', 'date'],
            'expiration_kind' => ['sometimes', Rule::in(['DATE', 'NO_EXPIRATION', 'UNVERIFIED'])],
            'verified_expiration_date' => ['sometimes', 'nullable', 'date', 'after_or_equal:verified_issue_date'],
            'verified_vat_category' => ['sometimes', 'nullable', Rule::in(['VAT', 'NON_VAT', 'VAT_ZERO', 'VAT_EXEMPT'])],
            'evidence_source' => ['sometimes', 'nullable', 'string', 'max:48'],
            'authority_evidence_version_id' => ['sometimes', 'nullable', 'uuid'],
            'authority_scopes' => ['sometimes', 'array', 'max:3'],
            'authority_scopes.*' => [Rule::in(['TAX_DECLARATIONS', 'COMMISSION_AGREEMENT', 'PAYMENT_CONFIGURATION'])],
            'remarks' => ['sometimes', 'nullable', 'string', 'max:2000'],
        ];
    }
}
