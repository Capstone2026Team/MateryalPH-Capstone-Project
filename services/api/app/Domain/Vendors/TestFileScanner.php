<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

final class TestFileScanner implements FileScanner
{
    public function scan(string $path): string
    {
        // A deterministic TEST adapter is not an antivirus engine.
        return config('vendor_onboarding.simulated_scan') && ! config('finance.live_commerce_enabled')
            && in_array(config('finance.mode'), ['TEST', 'DEMO'], true) ? 'TEST_SIMULATED_CLEAN' : 'PENDING';
    }
}
