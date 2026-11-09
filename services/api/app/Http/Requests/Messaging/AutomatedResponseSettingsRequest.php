<?php

declare(strict_types=1);

namespace App\Http\Requests\Messaging;

use Illuminate\Foundation\Http\FormRequest;

final class AutomatedResponseSettingsRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    /** @return array<string, list<string>> */
    public function rules(): array
    {
        return ['enabled' => ['required', 'boolean'], 'lock_version' => ['required', 'integer', 'min:0'],
            'welcome_message' => ['required_if:enabled,true', 'nullable', 'string', 'max:5000', 'not_regex:/^\s*$/u'],
            'options' => ['present', 'array', 'max:3'], 'options.*' => ['array:label,response'],
            'options.*.label' => ['required', 'string', 'max:80', 'distinct', 'not_regex:/^\s*$/u'],
            'options.*.response' => ['required', 'string', 'max:5000', 'not_regex:/^\s*$/u']];
    }
}
