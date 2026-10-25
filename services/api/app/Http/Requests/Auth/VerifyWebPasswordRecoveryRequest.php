<?php

declare(strict_types=1);

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;

final class VerifyWebPasswordRecoveryRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, list<string>> */
    public function rules(): array
    {
        return [
            'email' => ['required', 'email:rfc', 'max:254'],
            'portal' => ['required', 'in:VENDOR,ADMIN'],
            'code' => ['required_without:recovery_code', 'prohibits:recovery_code', 'string', 'digits:6'],
            'recovery_code' => ['required_without:code', 'prohibits:code', 'string', 'max:128'],
            'challenge_id' => ['sometimes', 'uuid', 'prohibits:recovery_code'],
        ];
    }
}
