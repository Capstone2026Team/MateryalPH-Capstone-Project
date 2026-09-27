<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\UploadedFile;

/**
 * Content validation for listing images and compliance marking photos. The
 * declared extension, declared MIME type and sniffed content must agree and
 * the image must decode within bounded dimensions; anything else is rejected.
 */
final class ImageContentValidator
{
    public const TYPES = ['jpg' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'png' => 'image/png', 'webp' => 'image/webp'];

    public const MAX_PIXELS = 40_000_000;

    /** @return array{mime: string, width: int, height: int} */
    public function validate(UploadedFile $file, int $maxKb, string $label): array
    {
        $path = $file->getRealPath();
        $size = $path === false ? false : filesize($path);
        // Enforce the larger of the stored and declared size so neither can understate the upload.
        $size = $size === false ? false : max($size, (int) $file->getSize());
        $mime = $path === false ? false : (new \finfo(FILEINFO_MIME_TYPE))->file($path);
        $extension = strtolower($file->getClientOriginalExtension());
        $declared = strtolower((string) $file->getClientMimeType());
        $expected = self::TYPES[$extension] ?? null;
        $valid = $path !== false && $size !== false && $size > 0 && $size <= $maxKb * 1024 && $expected !== null && $mime === $expected
            && ($declared === $mime || $declared === 'application/octet-stream');
        $dimensions = $valid ? @getimagesize($path) : false;
        if ($valid && $dimensions !== false && $dimensions[0] > 0 && $dimensions[1] > 0 && $dimensions[0] * $dimensions[1] <= self::MAX_PIXELS && $dimensions['mime'] === $mime) {
            $decoded = @imagecreatefromstring((string) file_get_contents($path));
            if ($decoded !== false) {
                return ['mime' => (string) $mime, 'width' => (int) $dimensions[0], 'height' => (int) $dimensions[1]];
            }
        }

        throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Upload the '.$label.' as a valid JPG, PNG or WebP image up to '.intdiv($maxKb, 1024).' MB.', 422, ['accepted_types' => array_values(array_unique(self::TYPES)), 'max_kb' => $maxKb]);
    }
}
