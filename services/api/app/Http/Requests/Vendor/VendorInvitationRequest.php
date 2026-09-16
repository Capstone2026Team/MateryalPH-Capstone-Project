<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class VendorInvitationRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'email' => ['required', 'email:rfc', 'max:254'],
            'invitee_name' => ['required', 'string', 'max:160'],
            'invitee_mobile' => ['sometimes', 'nullable', 'string', 'max:24'],
            'role' => ['required', Rule::in(['STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'])],
        ];
    }
}
