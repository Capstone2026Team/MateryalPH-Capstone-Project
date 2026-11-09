<?php

declare(strict_types=1);

namespace App\Http\Requests\Finance;

use Illuminate\Foundation\Http\FormRequest;

final class PublishCommissionPolicyRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true; // Domain authorization also applies to preview and replay.
    }

    /** @return array<string, list<string>> */
    public function rules(): array
    {
        return ['commission_basis_points' => ['required', 'integer', 'between:0,10000'], 'expected_version' => ['required', 'integer', 'min:0'],
            'effective_from' => ['nullable', 'date'], 'reason' => ['required', 'string', 'min:10', 'max:2000'],
            'vendor_message' => ['nullable', 'string', 'max:2000'], 'notice_override' => ['sometimes', 'boolean'],
            'notice_override_reason' => ['nullable', 'required_if:notice_override,true', 'string', 'min:10', 'max:2000'],
            'supersedes_policy_id' => ['nullable', 'uuid'], 'cancel_scheduled' => ['sometimes', 'boolean']];
    }
}
