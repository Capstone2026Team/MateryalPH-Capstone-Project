<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use App\Domain\Files\FileMalwareScanner;
use App\Domain\Files\FileScanRejected;

class ProfilePhotoScanner
{
    public function __construct(private readonly FileMalwareScanner $scanner) {}

    public function assertClean(string $path): void
    {
        try {
            $this->scanner->assertClean($path);
        } catch (FileScanRejected) {
            throw new AuthenticationException('PHOTO_REJECTED', 'This image did not pass the security check.', 422);
        } catch (\Throwable) {
            throw new AuthenticationException('PHOTO_SCANNER_UNAVAILABLE', 'Image scanning is unavailable. Please try again later.', 503);
        }
    }
}
