<?php

declare(strict_types=1);

namespace App\Http\Requests\Account;

use App\Domain\Identity\TutorialProgress;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Validation\Rule;
use Illuminate\Validation\Validator;

final class TutorialRequest extends FormRequest
{
    public function authorize(): bool
    {
        return in_array($this->user()?->account_type, ['BUYER', 'VENDOR'], true);
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return ['status' => ['required', Rule::in(['COMPLETED', 'SKIPPED'])]];
    }

    public function withValidator(Validator $validator): void
    {
        $validator->after(function (Validator $validator): void {
            if (! in_array($this->route('tutorialKey'), TutorialProgress::keys($this->user()->account_type), true)) {
                $validator->errors()->add('tutorialKey', 'This tutorial is unavailable for your account.');
            }
            foreach (array_keys($this->all()) as $key) {
                if ($key !== 'status') {
                    $validator->errors()->add($key, 'This field cannot be changed here.');
                }
            }
        });
    }
}
