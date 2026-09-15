<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

interface PublicMediaProvider
{
    /** @return array{asset_id: string, format: string} */
    public function upload(string $path, string $key): array;

    public function remove(string $key): void;

    public function contents(string $key, string $format): string;
}
