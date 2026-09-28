<?php

declare(strict_types=1);

namespace App\Http\Requests\Inventory;

use App\Domain\Inventory\InventoryLedgerWriter;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;

final class InventoryRowUpdateRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        $quantity = 'regex:/^\d{1,14}(\.\d{1,4})?$/';

        return [
            'lock_version' => ['required', 'integer', 'min:0'],
            'quantity_on_hand' => ['sometimes', 'nullable', $quantity],
            'reorder_level' => ['sometimes', 'nullable', $quantity],
            'reason_code' => ['sometimes', Rule::in(InventoryLedgerWriter::REASONS)],
            'note' => ['sometimes', 'nullable', 'string', 'max:500'],
            'price' => ['sometimes', 'array:expected_price_version_id,amount_centavos'],
            'price.expected_price_version_id' => ['required_with:price', 'uuid'],
            'price.amount_centavos' => ['required_with:price', 'integer', 'min:1', 'max:100000000000'],
        ];
    }

    /** @return array<string, string> */
    public function messages(): array
    {
        return [
            'quantity_on_hand.regex' => 'Enter a counted quantity of zero or more, with up to four decimals.',
            'reorder_level.regex' => 'Enter a reorder level of zero or more, with up to four decimals, or leave it empty.',
        ];
    }
}
