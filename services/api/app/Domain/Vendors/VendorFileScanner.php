<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Identity\ProfilePhotoScanner;

class VendorFileScanner
{
    public function __construct(private readonly ProfilePhotoScanner $scanner) {}

    public function assertClean(string $path): void
    {
        try {
            $this->scanner->assertClean($path);
        } catch (AuthenticationException $exception) {
            throw new AuthenticationException($exception->httpStatus === 422 ? 'FILE_REJECTED' : 'FILE_SCANNER_UNAVAILABLE', $exception->httpStatus === 422 ? 'This file did not pass the security check.' : 'File scanning is unavailable. Try again later.', $exception->httpStatus);
        }
    }
}
