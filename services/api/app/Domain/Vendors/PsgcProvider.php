<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

interface PsgcProvider
{
    /** @return list<array<string, mixed>> */
    public function list(string $path): array;
}
