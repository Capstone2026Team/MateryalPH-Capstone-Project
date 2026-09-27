<?php

declare(strict_types=1);

namespace App\Http\Requests\Catalog;

use Illuminate\Foundation\Http\FormRequest;

/** Transport shape only; per-row business validation happens in the catalog domain. */
final class CatalogVariantsRequest extends FormRequest
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
            'variants' => ['present', 'array', 'max:50'],
            'variants.*' => ['array'],
            'variants.*.id' => ['sometimes', 'nullable', 'uuid'],
            'variants.*.sku' => ['present', 'nullable', 'string', 'max:96'],
            'variants.*.label' => ['sometimes', 'nullable', 'string', 'max:120'],
            'variants.*.unit_id' => ['present', 'nullable', 'string', 'max:64'],
            'variants.*.pack_quantity' => ['present', 'nullable'],
            'variants.*.price_centavos' => ['present', 'nullable'],
            'variants.*.tax_category' => ['present', 'nullable', 'string', 'max:16'],
            'variants.*.tax_basis' => ['sometimes', 'nullable', 'string', 'max:500'],
            'variants.*.weight_kg' => ['sometimes', 'nullable'],
            'variants.*.length_cm' => ['sometimes', 'nullable'],
            'variants.*.width_cm' => ['sometimes', 'nullable'],
            'variants.*.height_cm' => ['sometimes', 'nullable'],
            'variants.*.quantity_on_hand' => ['sometimes', 'nullable'],
            'variants.*.active' => ['sometimes', 'boolean'],
            'variants.*.attributes' => ['sometimes', 'array', 'max:30'],
            'variants.*.volume_tiers' => ['sometimes', 'array', 'max:10'],
            'variants.*.volume_tiers.*' => ['array'],
            'variants.*.volume_tiers.*.minimum_quantity' => ['present', 'nullable'],
            'variants.*.volume_tiers.*.price_centavos' => ['present', 'nullable'],
        ];
    }
}
