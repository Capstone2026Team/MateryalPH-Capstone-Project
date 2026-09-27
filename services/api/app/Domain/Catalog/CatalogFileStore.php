<?php

declare(strict_types=1);

namespace App\Domain\Catalog;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\PublicStoreMediaStorage;
use App\Domain\Vendors\VendorFileScanner;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Str;

/**
 * Stores catalog uploads. Compliance evidence, import sources and register
 * snapshots are always private; listing images are the only public catalog
 * media. Every file is scanned before storage and scanning fails closed.
 */
final class CatalogFileStore
{
    public const LISTING_MEDIA = 'LISTING_MEDIA';

    public const COMPLIANCE_EVIDENCE = 'PRODUCT_COMPLIANCE_EVIDENCE';

    public const CATALOG_IMPORT = 'CATALOG_IMPORT';

    public const COMPLIANCE_REGISTER = 'COMPLIANCE_REGISTER';

    public function __construct(private readonly VendorFileScanner $scanner, private readonly PublicStoreMediaStorage $publicMedia) {}

    public function store(UploadedFile $file, string $ownerType, string $ownerId, string $purpose, int $uploaderId, string $contentType): string
    {
        $path = $file->getRealPath();
        if ($path === false) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'The uploaded file could not be read.', 422);
        }
        $this->scanner->assertClean($path);
        $fileId = (string) Str::uuid7();
        $extension = match ($contentType) {
            'image/jpeg' => 'jpg', 'image/png' => 'png', 'image/webp' => 'webp', 'text/csv' => 'csv', default => 'bin',
        };
        $visibility = 'PRIVATE';
        $disk = $this->privateDisk();
        $objectKey = 'private/'.strtolower($ownerType).'/'.$ownerId.'/catalog/'.strtolower($purpose).'/'.$fileId.'.'.$extension;
        $metadata = ['source' => 'CATALOG', 'purpose' => $purpose, 'disk' => $disk];
        if ($purpose === self::LISTING_MEDIA && $this->publicMedia->configured()) {
            $stored = $this->publicMedia->upload($file, 'materyalph/listings/'.$ownerId.'/'.$fileId, 'image');
            $objectKey = $stored['public_id'];
            $visibility = 'PUBLIC';
            $metadata = ['source' => 'CATALOG', 'purpose' => $purpose, 'storage_provider' => 'CLOUDINARY', 'public_url' => $stored['url']];
        } elseif (! Storage::disk($disk)->putFileAs('', $file, $objectKey, ['visibility' => 'private'])) {
            throw new AuthenticationException('FILE_STORAGE_UNAVAILABLE', 'The file could not be stored. Try again.', 503);
        }
        DB::table('files')->insert([
            'id' => $fileId, 'owner_type' => $ownerType, 'owner_id' => $ownerId, 'purpose' => $purpose, 'visibility' => $visibility,
            'content_type' => $contentType, 'byte_size' => (int) $file->getSize(), 'checksum_sha256' => (string) hash_file('sha256', $path),
            'scan_state' => 'CLEAN', 'object_key' => $objectKey, 'retention_class' => $purpose === self::COMPLIANCE_EVIDENCE ? 'PRODUCT_COMPLIANCE' : 'CATALOG',
            'original_name' => Str::limit($file->getClientOriginalName(), 180, ''), 'uploaded_by_user_id' => $uploaderId,
            'metadata' => json_encode($metadata, JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now(),
        ]);

        return $fileId;
    }

    /** @return array{url: string, expires_at: string} */
    public function temporaryUrl(object $file): array
    {
        $expires = now()->addMinutes(5);
        $metadata = ComparableMappingService::decode($file->metadata ?? null);
        if ($file->visibility === 'PUBLIC' && ($metadata['storage_provider'] ?? '') === 'CLOUDINARY' && is_string($metadata['public_url'] ?? null)) {
            return ['url' => $metadata['public_url'], 'expires_at' => $expires->toIso8601String()];
        }

        return ['url' => URL::temporarySignedRoute('catalog.file-content', $expires, ['fileId' => $file->id]), 'expires_at' => $expires->toIso8601String()];
    }

    public function stream(object $file): mixed
    {
        $metadata = ComparableMappingService::decode($file->metadata ?? null);
        $stream = Storage::disk(is_string($metadata['disk'] ?? null) ? $metadata['disk'] : $this->privateDisk())->readStream($file->object_key);
        if (! is_resource($stream)) {
            throw new AuthenticationException('FILE_UNAVAILABLE', 'The file is temporarily unavailable.', 503);
        }

        return response()->streamDownload(static function () use ($stream): void {
            fpassthru($stream);
            fclose($stream);
        }, 'catalog-file', ['Content-Type' => $file->content_type, 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff', 'Content-Disposition' => 'inline']);
    }

    public function discard(string $fileId): void
    {
        $file = DB::table('files')->where('id', $fileId)->first();
        if ($file !== null && $file->visibility === 'PRIVATE' && Storage::disk($this->privateDisk())->delete($file->object_key)) {
            DB::table('files')->where('id', $fileId)->delete();
        }
    }

    public function privateDisk(): string
    {
        $disk = (string) config('materyalph.files.disk', 'local');
        $configuration = config('filesystems.disks.'.$disk);
        if (! is_array($configuration) || $disk === 'public' || ($configuration['visibility'] ?? 'private') !== 'private') {
            throw new AuthenticationException('PRIVATE_STORAGE_UNAVAILABLE', 'Private file storage is not configured.', 503);
        }
        if (($configuration['driver'] ?? '') === 'local') {
            $root = str_replace('\\', '/', (string) ($configuration['root'] ?? ''));
            foreach ([public_path(), storage_path('app/public')] as $publicRoot) {
                $publicRoot = str_replace('\\', '/', $publicRoot);
                if ($root === $publicRoot || str_starts_with($root, $publicRoot.'/')) {
                    throw new AuthenticationException('PRIVATE_STORAGE_UNAVAILABLE', 'Private file storage is not configured.', 503);
                }
            }
        }

        return $disk;
    }
}
