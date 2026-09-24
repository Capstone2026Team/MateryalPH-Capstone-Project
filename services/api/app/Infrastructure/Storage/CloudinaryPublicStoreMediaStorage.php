<?php

declare(strict_types=1);

namespace App\Infrastructure\Storage;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\PublicStoreMediaStorage;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Http;

final class CloudinaryPublicStoreMediaStorage implements PublicStoreMediaStorage
{
    public function configured(): bool
    {
        return (string) config('services.cloudinary.cloud_name', '') !== '';
    }

    public function upload(UploadedFile $file, string $publicId, string $resourceType): array
    {
        $cloud = (string) config('services.cloudinary.cloud_name');
        $key = (string) config('services.cloudinary.api_key');
        $secret = (string) config('services.cloudinary.api_secret');
        if (preg_match('/^[a-zA-Z0-9_-]+$/D', $cloud) !== 1 || $key === '' || $secret === '' || ! in_array($resourceType, ['image', 'video'], true)) {
            throw new AuthenticationException('PUBLIC_MEDIA_STORAGE_UNAVAILABLE', 'Public Store media storage is not configured.', 503);
        }
        $stream = fopen($file->getRealPath(), 'rb');
        if (! is_resource($stream)) {
            throw new AuthenticationException('FILE_UNAVAILABLE', 'The upload could not be read.', 422);
        }
        try {
            $response = Http::withBasicAuth($key, $secret)->connectTimeout(5)->timeout(30)->attach('file', $stream, $publicId.'.'.$file->guessExtension())->post('https://api.cloudinary.com/v1_1/'.$cloud.'/'.$resourceType.'/upload', ['public_id' => $publicId, 'overwrite' => 'false', 'type' => 'upload']);
            $url = $response->json('secure_url');
            if (! $response->successful() || $response->json('public_id') !== $publicId || ! is_string($url) || ! str_starts_with($url, 'https://res.cloudinary.com/'.$cloud.'/')) {
                throw new \RuntimeException('Invalid media response');
            }

            return ['public_id' => $publicId, 'url' => $url];
        } catch (\Throwable) {
            throw new AuthenticationException('PUBLIC_MEDIA_STORAGE_UNAVAILABLE', 'Public Store media could not be stored. Try again later.', 503);
        } finally {
            if (is_resource($stream)) {
                fclose($stream);
            }
        }
    }
}
