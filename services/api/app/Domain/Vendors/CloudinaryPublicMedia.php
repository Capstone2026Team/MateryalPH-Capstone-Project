<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Client\PendingRequest;
use Illuminate\Support\Facades\Http;

final class CloudinaryPublicMedia implements PublicMediaProvider
{
    private function cloud(): string
    {
        $cloud = (string) config('vendor_providers.cloudinary.cloud_name');
        if (! preg_match('/^[a-zA-Z0-9_-]+$/', $cloud) || ! filled(config('vendor_providers.cloudinary.api_key')) || ! filled(config('vendor_providers.cloudinary.api_secret'))) {
            throw new AuthenticationException('PUBLIC_MEDIA_CONFIGURATION_REQUIRED', 'Backend Cloudinary configuration is required for public store media.', 503);
        }

        return $cloud;
    }

    private function client(): PendingRequest
    {
        return Http::withBasicAuth((string) config('vendor_providers.cloudinary.api_key'), (string) config('vendor_providers.cloudinary.api_secret'))->acceptJson()->connectTimeout(5)->timeout(30)->withOptions(['allow_redirects' => false]);
    }

    public function upload(string $path, string $key): array
    {
        $cloud = $this->cloud();
        try {
            // Authenticated delivery keeps unreviewed public-media candidates inaccessible anonymously.
            $response = $this->client()->attach('file', file_get_contents($path), 'store-image')->post('https://api.cloudinary.com/v1_1/'.$cloud.'/image/upload', ['public_id' => $key, 'type' => 'authenticated', 'overwrite' => 'false', 'unique_filename' => 'false']);
            if (! $response->successful() || $response->json('public_id') !== $key || $response->json('resource_type') !== 'image' || $response->json('type') !== 'authenticated' || ! is_string($response->json('asset_id')) || ! in_array($response->json('format'), ['jpg', 'png'], true)) {
                throw new \RuntimeException('Invalid public-media provider response.');
            }

            return ['asset_id' => $response->json('asset_id'), 'format' => $response->json('format')];
        } catch (\Throwable) {
            throw new AuthenticationException('PUBLIC_MEDIA_UPLOAD_FAILED', 'Cloudinary did not confirm this image upload. Retry after checking media storage health.', 503);
        }
    }

    public function remove(string $key): void
    {
        $cloud = $this->cloud();
        try {
            $response = $this->client()->asForm()->post('https://api.cloudinary.com/v1_1/'.$cloud.'/image/destroy', ['public_id' => $key, 'type' => 'authenticated', 'invalidate' => 'true']);
            if (! $response->successful() || ! in_array($response->json('result'), ['ok', 'not found'], true)) {
                throw new \RuntimeException('Removal not confirmed.');
            }
        } catch (\Throwable) {
            throw new AuthenticationException('PUBLIC_MEDIA_CLEANUP_REQUIRED', 'A public-media upload needs backend cleanup. Contact support.', 503);
        }
    }

    public function contents(string $key, string $format): string
    {
        $cloud = $this->cloud();
        if (! preg_match('#^vendor-store-media/[a-f0-9-]+/[a-f0-9-]+$#', $key) || ! in_array($format, ['jpg', 'png'], true)) {
            throw new AuthenticationException('PUBLIC_MEDIA_INVALID', 'This image is unavailable.', 404);
        }
        $resource = $key.'.'.$format;
        $signature = substr(strtr(base64_encode(sha1($resource.(string) config('vendor_providers.cloudinary.api_secret'), true)), '+/', '-_'), 0, 8);
        try {
            $response = Http::connectTimeout(5)->timeout(20)->withOptions(['allow_redirects' => false])->get('https://res.cloudinary.com/'.$cloud.'/image/authenticated/s--'.$signature.'--/'.$resource);
            if (! $response->successful() || strlen($response->body()) > 10 * 1024 * 1024) {
                throw new \RuntimeException('Image unavailable.');
            }

            return $response->body();
        } catch (\Throwable) {
            throw new AuthenticationException('PUBLIC_MEDIA_UNAVAILABLE', 'The image is temporarily unavailable. Retry later.', 503);
        }
    }
}
