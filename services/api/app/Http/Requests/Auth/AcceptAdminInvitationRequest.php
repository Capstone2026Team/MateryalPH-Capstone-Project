<?php

declare(strict_types=1);

namespace App\Http\Requests\Auth;

use App\Http\Requests\Auth\Concerns\ValidatesBotProtectionEvidence;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\Validator;

final class AcceptAdminInvitationRequest extends FormRequest
{
    use ValidatesBotProtectionEvidence;

    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, list<mixed>> */
    public function rules(): array
    {
        return [
            'token' => ['required', 'string', 'max:512'],
            'email' => ['sometimes', 'required', 'email:rfc', 'max:254'],
            'portal' => ['prohibited'],
            'account_type' => ['prohibited'],
            'full_name' => ['required', 'string', 'max:160'],
            'password' => ['required', 'confirmed', Password::min(14)->mixedCase()->numbers()],
            'terms_accepted' => ['accepted'],
            'privacy_accepted' => ['accepted'],
        ] + $this->botProtectionRules();
    }

    public function withValidator(Validator $validator): void
    {
        $this->validateBotProtectionEvidence($validator, 'ADMIN');
    }
}
