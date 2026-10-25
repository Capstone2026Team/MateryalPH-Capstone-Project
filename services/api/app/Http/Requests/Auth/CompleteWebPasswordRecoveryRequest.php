<?php

declare(strict_types=1);

namespace App\Http\Requests\Auth;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rules\Password;

final class CompleteWebPasswordRecoveryRequest extends FormRequest
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
            'portal' => ['required', 'in:VENDOR,ADMIN'],
            'password' => ['required', 'confirmed', Password::min($this->input('portal') === 'ADMIN' ? 14 : 12)->mixedCase()->numbers()],
        ];
    }
}
