<?php

declare(strict_types=1);

namespace Tests\Feature\Api;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\CloudinaryPublicMedia;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Http;
use Tests\TestCase;

final class PhaseThreeCloudinaryTest extends TestCase
{
    public function test_backend_upload_uses_authenticated_delivery_and_only_safe_metadata(): void
    {
        Http::preventStrayRequests();
        config(['vendor_providers.cloudinary.cloud_name' => 'test-fixture', 'vendor_providers.cloudinary.api_key' => bin2hex(random_bytes(16)), 'vendor_providers.cloudinary.api_secret' => bin2hex(random_bytes(32))]);
        $key = 'vendor-store-media/00000000-0000-0000-0000-000000000001/00000000-0000-0000-0000-000000000002';
        Http::fake(['https://api.cloudinary.com/v1_1/test-fixture/image/upload' => Http::response(['public_id' => $key, 'asset_id' => 'TEST-ASSET', 'resource_type' => 'image', 'format' => 'png', 'type' => 'authenticated'])]);
        $file = UploadedFile::fake()->createWithContent('sample.png', base64_decode('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+aV1sAAAAASUVORK5CYII='));
        self::assertSame(['asset_id' => 'TEST-ASSET', 'format' => 'png'], app(CloudinaryPublicMedia::class)->upload($file->getPathname(), $key));
        Http::assertSentCount(1);
        Http::assertSent(fn ($request): bool => $request->hasHeader('Authorization') && str_contains($request->body(), 'authenticated') && str_contains($request->body(), 'overwrite'));
    }

    public function test_missing_cloudinary_configuration_fails_closed_without_a_request(): void
    {
        Http::preventStrayRequests();
        Http::fake();
        config(['vendor_providers.cloudinary.cloud_name' => null]);
        try {
            app(CloudinaryPublicMedia::class)->upload('unused', 'unused');
            self::fail('Missing credentials accepted.');
        } catch (AuthenticationException $exception) {
            self::assertSame(503, $exception->httpStatus);
        }
        Http::assertNothingSent();
    }
}
