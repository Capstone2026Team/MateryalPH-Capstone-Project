<?php

declare(strict_types=1);

namespace App\Http\Requests\Vendor;

use App\Domain\Vendors\VendorOnboardingService;
use Illuminate\Foundation\Http\FormRequest;
use Illuminate\Http\UploadedFile;
use Illuminate\Validation\Rule;

final class VendorDocumentUploadRequest extends FormRequest
{
    public function authorize(): bool
    {
        return $this->user()?->account_type === 'VENDOR';
    }

    protected function prepareForValidation(): void
    {
        // Generated clients send object-valued multipart parts as JSON blobs.
        $metadata = $this->file('metadata') ?? $this->input('metadata');
        if ($metadata instanceof UploadedFile) {
            if (! $metadata->isValid() || $metadata->getSize() > 65536) {
                return;
            }
            $metadata = $metadata->getContent();
        }

        if (! is_string($metadata) || strlen($metadata) > 65536) {
            return;
        }

        $decoded = json_decode($metadata, associative: false, depth: 32);
        if (! $decoded instanceof \stdClass) {
            return;
        }

        $this->files->remove('metadata');
        // Laravel initializes this untyped cache to null and rebuilds it with ??= in allFiles().
        $this->convertedFiles = null; // @phpstan-ignore assign.propertyType (Framework PHPDoc omits the supported null cache state.)
        $this->merge(['metadata' => get_object_vars($decoded)]);
    }

    /** @return array<string, mixed> */
    public function rules(): array
    {
        return [
            'requirement_key' => ['required', Rule::in(array_keys(VendorOnboardingService::DOCUMENTS))],
            'file' => ['required', 'file', 'mimes:jpg,jpeg,png,pdf', 'extensions:jpg,jpeg,png,pdf', 'max:10240'],
            'metadata' => ['sometimes', 'array', 'max:20'],
            'metadata.*' => ['bail', 'nullable', 'string', 'max:255'],
        ];
    }
}
