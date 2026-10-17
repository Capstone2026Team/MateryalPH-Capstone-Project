<?php

declare(strict_types=1);

namespace App\Http\Requests\Auth;

use App\Http\AuthTransport;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class ResendBotChallengeRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, list<mixed>> */
    public function rules(): array
    {
        return [
            'email' => ['required', 'email:rfc', 'max:254'],
            'portal' => AuthTransport::fromRequest($this) === AuthTransport::WEB
                ? ['sometimes', 'required', Rule::in(['VENDOR', 'ADMIN'])]
                : ['prohibited'],
        ];
    }
}
