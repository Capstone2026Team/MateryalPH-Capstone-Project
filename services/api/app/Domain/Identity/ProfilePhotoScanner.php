<?php

declare(strict_types=1);

namespace App\Domain\Identity;

use Symfony\Component\Process\Process;

class ProfilePhotoScanner
{
    public function assertClean(string $path): void
    {
        try {
            $process = new Process(['clamscan', '--no-summary', '--infected', '--fail-if-cvd-older-than=7', $path]);
            $process->setTimeout(30);
            $process->run();
        } catch (\Throwable) {
            throw new AuthenticationException('PHOTO_SCANNER_UNAVAILABLE', 'Image scanning is unavailable. Please try again later.', 503);
        }
        if ($process->getExitCode() === 1) {
            throw new AuthenticationException('PHOTO_REJECTED', 'This image did not pass the security check.', 422);
        }
        if (! $process->isSuccessful()) {
            throw new AuthenticationException('PHOTO_SCANNER_UNAVAILABLE', 'Image scanning is unavailable. Please try again later.', 503);
        }
    }
}
