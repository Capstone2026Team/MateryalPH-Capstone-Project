<?php

declare(strict_types=1);

namespace App\Http\Requests\Auth;

use App\Http\AuthTransport;
use Illuminate\Foundation\Http\FormRequest;

final class MfaCodeRequest extends FormRequest
{
    public function authorize(): bool
    {
        return true;
    }

    /** @return array<string, list<mixed>> */
    public function rules(): array
    {
        return ['code' => ['required', 'string', 'regex:/^\d{6}$/'], 'challenge_token' => self::challengeTokenRules($this)];
    }

    /** @return list<string> Native clients send the login challenge in the body; web clients must rely on the HttpOnly cookie. */
    public static function challengeTokenRules(FormRequest $request): array
    {
        return AuthTransport::fromRequest($request) === AuthTransport::MOBILE
            ? ['required', 'string', 'max:128']
            : ['prohibited'];
    }
}
