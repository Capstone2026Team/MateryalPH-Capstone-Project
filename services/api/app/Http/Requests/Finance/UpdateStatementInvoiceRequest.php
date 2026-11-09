<?php

declare(strict_types=1);

namespace App\Http\Requests\Finance;

use Illuminate\Foundation\Http\FormRequest;

final class UpdateStatementInvoiceRequest extends FormRequest
{
    public function authorize(): bool
    {
        // AdminFinanceService enforces finance.approve_statements before any read or write.
        return true;
    }

    /** @return array<string, list<string>> */
    public function rules(): array
    {
        return [
            'lock_version' => ['required', 'integer', 'min:1'],
            'invoice_heading' => ['required', 'string', 'max:100'],
            'invoice_message' => ['present', 'nullable', 'string', 'max:1000'],
        ];
    }
}
