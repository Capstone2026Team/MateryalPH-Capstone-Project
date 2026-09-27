<?php

declare(strict_types=1);

namespace App\Http\Requests\Catalog;

use Illuminate\Foundation\Http\FormRequest;

final class CatalogListingCreateRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'display_name' => ['required', 'string', 'min:2', 'max:180'],
            'vendor_sku' => ['required', 'string', 'min:1', 'max:96', 'regex:/^[A-Za-z0-9][A-Za-z0-9 ._\/-]*$/'],
        ];
    }
}
