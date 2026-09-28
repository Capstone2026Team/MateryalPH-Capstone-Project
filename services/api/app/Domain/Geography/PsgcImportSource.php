<?php

declare(strict_types=1);

namespace App\Domain\Geography;

interface PsgcImportSource
{
    /** PSA_CSV or PSGC_CLOUD_SNAPSHOT. */
    public function kind(): string;

    /** @return list<array{code: string, name: string, level: string}> */
    public function rows(): array;
}
