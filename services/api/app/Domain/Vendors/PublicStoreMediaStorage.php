<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use Illuminate\Http\UploadedFile;

interface PublicStoreMediaStorage
{
    public function configured(): bool;

    /** @return array{public_id: string, url: string} */
    public function upload(UploadedFile $file, string $publicId, string $resourceType): array;
}
