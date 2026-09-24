<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\UploadedFile;

final class EvidenceContentValidator
{
    public function validate(UploadedFile $file): void
    {
        $size = filesize($file->getRealPath());
        $mime = (new \finfo(FILEINFO_MIME_TYPE))->file($file->getRealPath());
        $extension = strtolower($file->getClientOriginalExtension());
        $expected = ['jpg' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'png' => 'image/png', 'pdf' => 'application/pdf'];
        $declaredMime = strtolower($file->getClientMimeType());
        $valid = ($declaredMime === $mime || $declaredMime === 'application/octet-stream') && ($expected[$extension] ?? null) === $mime && $size !== false && $size > 0 && $size <= (int) config('materyalph.files.max_document_kb', 10240) * 1024;
        if ($valid && in_array($mime, ['image/jpeg', 'image/png'], true)) {
            $dimensions = @getimagesize($file->getRealPath());
            $valid = $dimensions !== false && $dimensions[0] > 0 && $dimensions[1] > 0 && $dimensions[0] * $dimensions[1] <= 40000000 && $dimensions['mime'] === $mime;
            if ($valid) {
                $decoded = @imagecreatefromstring((string) file_get_contents($file->getRealPath()));
                $valid = $decoded !== false;
            }
        } elseif ($valid && $mime === 'application/pdf') {
            $contents = (string) file_get_contents($file->getRealPath());
            $valid = preg_match('/^%PDF-(?:1\.[0-9]|2\.0)/', $contents) === 1
                && preg_match('/%%EOF\s*$/', $contents) === 1
                && preg_match('/\/Type\s*\/Catalog\b/', $contents) === 1
                && preg_match('/\/(JavaScript|JS|Launch|EmbeddedFile|OpenAction|AA)\b/i', $contents) !== 1;
        } else {
            $valid = false;
        }
        if (! $valid) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Upload a valid JPG, PNG or PDF within the configured size limit.', 422);
        }
    }
}
