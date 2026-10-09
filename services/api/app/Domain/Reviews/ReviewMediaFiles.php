<?php

declare(strict_types=1);

namespace App\Domain\Reviews;

use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Fulfillment\OrderEvidenceFiles;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\VendorFileScanner;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Process;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Throwable;

/** Product-review media stays private and is validated/scanned before any review row is locked. */
final class ReviewMediaFiles
{
    public function __construct(private readonly OrderEvidenceFiles $photos, private readonly VendorFileScanner $scanner, private readonly CatalogFileStore $store) {}

    public function store(UploadedFile $file, string $orderId, int $uploaderId): string
    {
        $mime = $this->validate($file);
        if (str_starts_with($mime, 'image/')) {
            return $this->photos->store($file, $orderId, 'REVIEW_MEDIA', $uploaderId, true);
        }
        $this->scanner->assertClean((string) $file->getRealPath());
        $disk = $this->store->privateDisk();
        $id = (string) Str::uuid7();
        $key = 'private/order/'.$orderId.'/review_media/'.$id.($mime === 'video/quicktime' ? '.mov' : '.mp4');
        if (! Storage::disk($disk)->putFileAs('', $file, $key, ['visibility' => 'private'])) {
            throw new AuthenticationException('FILE_STORAGE_UNAVAILABLE', 'The media could not be stored. Try again.', 503);
        }
        try {
            DB::table('files')->insert([
                'id' => $id, 'owner_type' => 'ORDER', 'owner_id' => $orderId, 'purpose' => 'REVIEW_MEDIA', 'visibility' => 'PRIVATE', 'content_type' => $mime,
                'byte_size' => (int) $file->getSize(), 'checksum_sha256' => (string) hash_file('sha256', (string) $file->getRealPath()), 'scan_state' => 'CLEAN', 'object_key' => $key,
                'retention_class' => 'COMMERCIAL_HISTORY', 'original_name' => Str::limit($file->getClientOriginalName(), 180, ''), 'uploaded_by_user_id' => $uploaderId,
                'metadata' => json_encode(['source' => 'ORDER', 'purpose' => 'REVIEW_MEDIA', 'disk' => $disk], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now(),
            ]);
        } catch (Throwable $exception) {
            Storage::disk($disk)->delete($key);
            throw $exception;
        }

        return $id;
    }

    /** Checks extension, detected MIME, size and a real video stream; never trusts the client MIME. */
    public function validate(UploadedFile $file): string
    {
        $mime = (string) (new \finfo(FILEINFO_MIME_TYPE))->file((string) $file->getRealPath());
        $expected = ['jpg' => 'image/jpeg', 'jpeg' => 'image/jpeg', 'png' => 'image/png', 'mp4' => 'video/mp4', 'mov' => 'video/quicktime'];
        $photo = str_starts_with($mime, 'image/');
        $limit = $photo ? ReviewRules::photoMaxBytes() : ReviewRules::videoMaxBytes();
        if (($expected[strtolower($file->getClientOriginalExtension())] ?? null) !== $mime || (int) $file->getSize() < 1 || (int) $file->getSize() > $limit) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Use JPG/PNG up to 10 MB or MP4/MOV up to 100 MB.', 422);
        }
        if ($photo) {
            return $mime; // The existing photo store additionally decodes the image and validates its dimensions.
        }
        try {
            $result = Process::timeout(20)->run(['ffprobe', '-v', 'error', '-protocol_whitelist', 'file', '-f', 'mov', '-enable_drefs', '0', '-select_streams', 'V:0',
                '-show_entries', 'stream=codec_type,width,height:format=duration', '-of', 'json', (string) $file->getRealPath()]);
        } catch (Throwable) {
            throw new AuthenticationException('FILE_VALIDATION_UNAVAILABLE', 'Video validation is temporarily unavailable. Keep the video and retry.', 503);
        }
        if ($result->exitCode() === 127 || $result->exitCode() === 9009) {
            throw new AuthenticationException('FILE_VALIDATION_UNAVAILABLE', 'Video validation is temporarily unavailable. Keep the video and retry.', 503);
        }
        $data = json_decode($result->output(), true);
        $stream = is_array($data) ? ($data['streams'][0] ?? []) : [];
        $width = (int) ($stream['width'] ?? 0);
        $height = (int) ($stream['height'] ?? 0);
        if (! $result->successful() || ($stream['codec_type'] ?? '') !== 'video' || $width < 1 || $height < 1 || $width * $height > 40000000 || (float) ($data['format']['duration'] ?? 0) <= 0) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Upload a playable MP4 or MOV video.', 422);
        }

        return $mime;
    }
}
