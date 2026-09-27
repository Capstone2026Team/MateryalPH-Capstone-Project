<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Identity\AuthenticationException;
use App\Infrastructure\Storage\CloudinaryPublicStoreMediaStorage;
use Illuminate\Config\Repository;
use Illuminate\Container\Container;
use Illuminate\Http\Client\Factory;
use Illuminate\Http\Client\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\Facade;
use Illuminate\Support\Facades\Http;
use Illuminate\Support\Facades\Log;
use PHPUnit\Framework\TestCase;
use Psr\Log\NullLogger;

final class CloudinaryPublicStoreMediaStorageTest extends TestCase
{
    protected function setUp(): void
    {
        parent::setUp();
        $container = new Container;
        Container::setInstance($container);
        $container->instance('config', new Repository(['services' => ['cloudinary' => [
            'cloud_name' => 'test-store', 'api_key' => 'test-key', 'api_secret' => 'test-only-secret',
        ]]]));
        $container->instance(Factory::class, new Factory);
        $container->instance('log', new NullLogger);
        Facade::clearResolvedInstances();
        Facade::setFacadeApplication($container);
        Http::preventStrayRequests();
    }

    protected function tearDown(): void
    {
        \Mockery::close();
        Facade::clearResolvedInstances();
        Facade::setFacadeApplication(null);
        Container::setInstance(null);
        parent::tearDown();
    }

    public function test_valid_upload_returns_verified_provider_location(): void
    {
        $url = 'https://res.cloudinary.com/test-store/image/upload/store/logo.png';
        Http::fake(['api.cloudinary.com/*' => Http::response(['public_id' => 'store/logo', 'secure_url' => $url])]);
        $result = (new CloudinaryPublicStoreMediaStorage)->upload(UploadedFile::fake()->create('logo.png', 1, 'image/png'), 'store/logo', 'image');
        $this->assertSame(['public_id' => 'store/logo', 'url' => $url], $result);
        Http::assertSentCount(1);
        Http::assertSent(function (Request $request): bool {
            $fields = array_column($request->data(), 'contents', 'name');

            return ($fields['asset_folder'] ?? null) === 'marketplace'
                && ($fields['public_id'] ?? null) === 'store/logo';
        });
    }

    public function test_upload_targets_the_configured_folder(): void
    {
        config()->set('services.cloudinary.asset_folder', 'marketplace/stores');
        Http::fake(['api.cloudinary.com/*' => Http::response(['public_id' => 'store/logo', 'secure_url' => 'https://res.cloudinary.com/test-store/image/upload/store/logo.png'])]);
        (new CloudinaryPublicStoreMediaStorage)->upload(UploadedFile::fake()->create('logo.png', 1, 'image/png'), 'store/logo', 'image');
        Http::assertSent(function (Request $request): bool {
            $fields = array_column($request->data(), 'contents', 'name');

            return ($fields['asset_folder'] ?? null) === 'marketplace/stores';
        });
    }

    public function test_provider_rejection_logs_only_status_and_provider(): void
    {
        Http::fake(['api.cloudinary.com/*' => Http::response(['error' => ['message' => 'sensitive-provider-payload']], 401)]);
        Log::shouldReceive('warning')->once()->with('Public Store media provider rejected upload.', ['provider' => 'CLOUDINARY', 'http_status' => 401]);
        $this->assertSafeFailure('Image storage is not authorized to accept uploads. Please contact support.');
    }

    public function test_upload_permission_rejection_is_not_reported_as_a_connection_failure(): void
    {
        Http::fake(['api.cloudinary.com/*' => Http::response(['error' => ['message' => 'sensitive-provider-payload']], 403)]);
        Log::shouldReceive('warning')->once()->with('Public Store media provider rejected upload.', ['provider' => 'CLOUDINARY', 'http_status' => 403]);
        $this->assertSafeFailure('Image storage is not authorized to accept uploads. Please contact support.');
    }

    public function test_provider_outage_retains_the_retry_message(): void
    {
        Http::fake(['api.cloudinary.com/*' => Http::response([], 503)]);
        Log::shouldReceive('warning')->once()->with('Public Store media provider rejected upload.', ['provider' => 'CLOUDINARY', 'http_status' => 503]);
        $this->assertSafeFailure('Public Store media could not be stored. Try again later.');
    }

    public function test_connection_failure_has_a_safe_retry_message(): void
    {
        Http::fake(['api.cloudinary.com/*' => Http::failedConnection()]);
        Log::shouldReceive('warning')->once()->with('Public Store media provider connection failed.', ['provider' => 'CLOUDINARY']);
        $this->assertSafeFailure('Image storage is temporarily unreachable. Please retry your upload.');
    }

    public function test_untrusted_media_url_is_rejected(): void
    {
        Http::fake(['api.cloudinary.com/*' => Http::response(['public_id' => 'store/logo', 'secure_url' => 'https://untrusted.example/logo.png'])]);
        Log::shouldReceive('warning')->once()->with('Public Store media provider returned invalid media metadata.', ['provider' => 'CLOUDINARY']);
        $this->assertSafeFailure('Public Store media could not be stored. Try again later.');
    }

    private function assertSafeFailure(string $message): void
    {
        try {
            (new CloudinaryPublicStoreMediaStorage)->upload(UploadedFile::fake()->create('logo.png', 1, 'image/png'), 'store/logo', 'image');
            $this->fail('Upload should be rejected.');
        } catch (AuthenticationException $exception) {
            $this->assertSame('PUBLIC_MEDIA_STORAGE_UNAVAILABLE', $exception->errorCode);
            $this->assertSame(503, $exception->httpStatus);
            $this->assertSame($message, $exception->getMessage());
        }
    }
}
