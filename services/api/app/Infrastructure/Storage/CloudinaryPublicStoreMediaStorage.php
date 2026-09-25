<?php

declare(strict_types=1);

namespace App\Infrastructure\Storage;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\PublicStoreMediaStorage;
use Illuminate\Http\Client\ConnectionException;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;

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
        $assetFolder = trim((string) config('services.cloudinary.asset_folder', 'marketplace'));
        if (preg_match('/^[a-zA-Z0-9_-]+$/D', $cloud) !== 1 || $key === '' || $secret === '' || $assetFolder === '' || ! in_array($resourceType, ['image', 'video'], true)) {
            throw new AuthenticationException('PUBLIC_MEDIA_STORAGE_UNAVAILABLE', 'Public Store media storage is not configured.', 503);
        }
        $stream = fopen($file->getRealPath(), 'rb');
        if (! is_resource($stream)) {
            throw new AuthenticationException('FILE_UNAVAILABLE', 'The upload could not be read.', 422);
        }
        try {
            $response = Http::withBasicAuth($key, $secret)->connectTimeout(5)->timeout(30)->attach('file', $stream, $publicId.'.'.$file->guessExtension())->post('https://api.cloudinary.com/v1_1/'.$cloud.'/'.$resourceType.'/upload', ['public_id' => $publicId, 'asset_folder' => $assetFolder, 'overwrite' => 'false', 'type' => 'upload']);
            if (! $response->successful()) {
                Log::warning('Public Store media provider rejected upload.', ['provider' => 'CLOUDINARY', 'http_status' => $response->status()]);
                if (in_array($response->status(), [401, 403], true)) {
                    throw new AuthenticationException('PUBLIC_MEDIA_STORAGE_UNAVAILABLE', 'Image storage is not authorized to accept uploads. Please contact support.', 503);
                }
                throw new \RuntimeException('Provider rejected upload');
            }
            $url = $response->json('secure_url');
            if ($response->json('public_id') !== $publicId || ! is_string($url) || ! str_starts_with($url, 'https://res.cloudinary.com/'.$cloud.'/')) {
                Log::warning('Public Store media provider returned invalid media metadata.', ['provider' => 'CLOUDINARY']);
                throw new \RuntimeException('Invalid media response');
            }

            return ['public_id' => $publicId, 'url' => $url];
        } catch (AuthenticationException $exception) {
            throw $exception;
        } catch (ConnectionException) {
            Log::warning('Public Store media provider connection failed.', ['provider' => 'CLOUDINARY']);
            throw new AuthenticationException('PUBLIC_MEDIA_STORAGE_UNAVAILABLE', 'Image storage is temporarily unreachable. Please retry your upload.', 503);
        } catch (\Throwable) {
            throw new AuthenticationException('PUBLIC_MEDIA_STORAGE_UNAVAILABLE', 'Public Store media could not be stored. Try again later.', 503);
        } finally {
            if (is_resource($stream)) {
                fclose($stream);
            }
        }
    }
}
