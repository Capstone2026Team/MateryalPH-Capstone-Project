<?php

declare(strict_types=1);

namespace App\Http\Requests\Account;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Rules\Password;
use Illuminate\Validation\Validator;

final class AccountRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user() !== null;
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        $password = ['required', 'string', 'confirmed', Password::min(14)->mixedCase()->numbers(), 'max:1024'];

        return match ($this->route()?->getActionMethod()) {
            'updateProfile' => [
                'full_name' => ['required', 'string', 'max:160'],
                'lock_version' => ['required', 'integer', 'min:1'],
                'buyer_type' => ['sometimes', Rule::in(['INDIVIDUAL', 'BUSINESS'])],
                'company_name' => ['sometimes', 'nullable', 'string', 'max:180'],
            ],
            'reauthenticate' => ['password' => ['required_without:email_code', 'nullable', 'string', 'max:1024'], 'email_code' => ['required_without:password', 'nullable', 'digits:6'], 'code' => ['nullable', 'digits:6']],
            'changePassword' => ['password' => $password, 'password_confirmation' => ['required', 'string']],
            'startEmailChange' => ['email' => ['required', 'email:rfc', 'max:254']],
            'confirmEmailChange', 'confirmFactor' => ['id' => ['required', 'uuid'], 'code' => ['required', 'digits:6']],
            'revokeSessions' => ['scope' => ['required', Rule::in(['OTHERS', 'ALL'])]],
            'acceptAgreements' => ['version_ids' => ['required', 'array', 'min:1', 'max:20'], 'version_ids.*' => ['required', 'uuid', 'distinct']],
            'delegate' => ['can_manage_staff' => ['required', 'boolean']],
            'changeMembership' => ['status' => ['required', Rule::in(['ACTIVE', 'SUSPENDED', 'DEACTIVATED'])]],
            'inviteAdmin' => ['email' => ['required', 'email:rfc', 'max:254'], 'role_id' => ['required', 'uuid']],
            'changeAdmin' => ['lock_version' => ['required', 'integer', 'min:1'], 'reason' => ['required', 'string', 'min:3', 'max:500'], 'status' => ['required_without:role_id', Rule::in(['ACTIVE', 'SUSPENDED', 'DEACTIVATED'])], 'role_id' => ['required_without:status', 'uuid']],
            default => [],
        };
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $validator): void {
            $allowed = array_keys($this->rules());
            foreach (array_keys($this->all()) as $key) {
                if (! in_array($key, $allowed, true)) {
                    $validator->errors()->add($key, 'This field cannot be changed here.');
                }
            }
        });
    }
}
