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
        $rules = ['lock_version' => ['required', 'integer', 'min:1'], 'privacy_acknowledged' => ['accepted'], 'draft' => ['sometimes', 'array']];
        foreach ((new VendorVerificationDraftRequest)->rules() as $key => $rule) {
            if (in_array($key, ['form_state', 'lock_version', 'draft_lock_version'], true)) {
                continue;
            }
            $rules['draft.'.$key] = array_map(static function ($item) {
                if (is_string($item)) {
                    return preg_replace('/^(required_with|after_or_equal|exclude_if):/', '$1:draft.', $item);
                }

                return $item;
            }, $rule);
        }

        return $rules;
    }
}
