<?php

declare(strict_types=1);

namespace App\Http\Requests\Support;

use App\Domain\Support\SupportRules;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class SubmitSupportRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    protected function prepareForValidation(): void
    {
        foreach (['full_name', 'email', 'subject', 'message', 'reference'] as $key) {
            if (is_string($this->input($key))) {
                $this->merge([$key => trim($this->input($key))]);
            }
        }
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        $creating = $this->route('ticketId') === null;
        $guest = $this->attributes->get('support_portal') === 'guest';
        $rules = ['message' => ['required', 'string', 'min:3', 'max:10000'],
            'files' => ['sometimes', 'array', 'max:3'], 'files.*' => ['required', 'file', 'max:3072'],
        ];
        if ($creating) {
            $rules += ['full_name' => [$guest ? 'required' : 'nullable', 'string', 'max:160'],
                'email' => [$guest ? 'required' : 'nullable', 'email:rfc', 'max:254'],
                'user_type' => ['required', Rule::in(SupportRules::TYPES)],
                'category' => ['required', Rule::in(SupportRules::CATEGORIES)],
                'subject' => ['required', 'string', 'min:3', 'max:160'],
                'reference_type' => ['nullable', Rule::in(SupportRules::REFERENCES)],
                'reference' => ['nullable', 'required_with:reference_type', 'string', 'max:120'],
                'privacy_acknowledged' => ['required', 'accepted'],
                'website' => ['nullable', 'string', 'max:0'],
            ];
        }

        return $rules;
    }
}
