<?php

declare(strict_types=1);

namespace App\Http\Requests\Catalog;

use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class CatalogListingUpdateRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'lock_version' => ['required', 'integer', 'min:1'],
            'display_name' => ['sometimes', 'string', 'min:2', 'max:180'],
            'vendor_sku' => ['sometimes', 'string', 'min:1', 'max:96', 'regex:/^[A-Za-z0-9][A-Za-z0-9 ._\/-]*$/'],
            'description' => ['sometimes', 'nullable', 'string', 'max:4000'],
            'material_id' => ['sometimes', 'nullable', 'uuid'],
            'material_match' => ['sometimes', Rule::in(['EXACT', 'ALIAS', 'FUZZY_CONFIRMED'])],
            'other_label' => ['sometimes', 'nullable', 'string', 'max:60'],
            'material_category_id' => ['sometimes', 'nullable', 'uuid'],
            'tag_ids' => ['sometimes', 'array', 'max:3'],
            'tag_ids.*' => ['uuid'],
            'brand' => ['sometimes', 'nullable', 'string', 'max:180'],
            'model' => ['sometimes', 'nullable', 'string', 'max:180'],
            'manufacturer' => ['sometimes', 'nullable', 'string', 'max:200'],
            'manufacturer_address' => ['sometimes', 'nullable', 'string', 'max:500'],
            'country_of_manufacture' => ['sometimes', 'nullable', 'string', 'size:2', 'regex:/^[A-Z]{2}$/'],
            'technical_attributes' => ['sometimes', 'array', 'max:30'],
            'technical_attributes.*' => ['nullable', 'max:120'],
        ];
    }
}
