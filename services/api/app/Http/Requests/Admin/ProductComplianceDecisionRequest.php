<?php

declare(strict_types=1);

namespace App\Http\Requests\Admin;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class ProductComplianceDecisionRequest extends FormRequest
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
            'lock_version' => ['required', 'integer', 'min:1'],
            'reason' => ['required_unless:decision,APPROVED', 'nullable', 'string', 'min:3', 'max:2000'],
            'remarks' => ['sometimes', 'nullable', 'string', 'max:2000'],
            'source_reference' => ['sometimes', 'nullable', 'string', 'max:500'],
        ];
    }
}
