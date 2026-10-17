<?php

declare(strict_types=1);

namespace App\Http\Requests\Auth;

use App\Http\Requests\Auth\Concerns\ValidatesBotProtectionEvidence;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Validator;

final class AcceptVendorInvitationRequest extends FormRequest
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
            'token' => ['required', 'string', 'max:256'],
            'email' => ['required', 'email:rfc', 'max:254'],
            'full_name' => ['required', 'string', 'max:160'],
            'password' => ['required', 'string', 'confirmed', 'max:1024'],
            'role' => ['prohibited'],
            'organization_id' => ['prohibited'],
            'can_manage_staff' => ['prohibited'],
            'account_type' => ['prohibited'],
            'portal' => ['prohibited'],
        ] + $this->botProtectionRules();
    }

    public function withValidator(Validator $validator): void
    {
        $this->validateBotProtectionEvidence($validator);
    }
}
