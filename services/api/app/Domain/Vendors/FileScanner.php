<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

interface FileScanner
{
    public function scan(string $path): string;
}
