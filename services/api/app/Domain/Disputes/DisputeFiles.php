<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Fulfillment\OrderEvidenceFiles;
use App\Domain\Identity\AuthenticationException;
use App\Models\User;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Private case evidence. Uploads are validated by content (JPG, PNG or PDF), scanned fail-closed and stored privately
 * under the order; they are never public. Every evidence link is a five-minute signed URL for one audience's route,
 * and the fetch re-authorizes the signed-in caller against the case, so an unexpired link stops working the moment
 * the caller loses access (for example when the Owner switches staff dispute handling off).
 */
final class DisputeFiles
{
    public const PURPOSE = 'DISPUTE_EVIDENCE';

    public const MAX_FILES = 5;

    public const TTL_MINUTES = 5;

    private const ROUTES = ['BUYER' => 'disputes.buyer.file', 'VENDOR' => 'disputes.vendor.file', 'ADMIN' => 'disputes.admin.file'];

    public function __construct(private readonly OrderEvidenceFiles $files, private readonly CatalogFileStore $store, private readonly DisputeAccess $access) {}

    /**
     * Validates, scans and stores each file before the caller's transaction.
     *
     * @param  list<UploadedFile>  $uploads
     * @return list<string>
     */
    public function store(array $uploads, string $orderId, int $uploaderId): array
    {
        if (count($uploads) > self::MAX_FILES) {
            throw new AuthenticationException('VALIDATION_FAILED', 'Attach up to five files.', 422, ['files' => ['Attach up to five files.']]);
        }
        $stored = [];
        try {
            foreach ($uploads as $upload) {
                $stored[] = $this->files->store($upload, $orderId, self::PURPOSE, $uploaderId, false);
            }
        } catch (\Throwable $exception) {
            $this->files->discard($stored);
            throw $exception;
        }

        return $stored;
    }

    /** @param array<int, string|null> $fileIds */
    public function discard(array $fileIds): void
    {
        $this->files->discard($fileIds);
    }

    /** @return array{url: string, expires_at: string} */
    public function link(string $audience, string $caseId, string $fileId): array
    {
        $expires = now()->addMinutes(self::TTL_MINUTES);

        return ['url' => URL::temporarySignedRoute(self::ROUTES[$audience], $expires, ['caseId' => $caseId, 'fileId' => $fileId]), 'expires_at' => $expires->toIso8601String()];
    }

    /** Streams one file the case references, after re-authorizing the caller for the case. */
    public function stream(User $user, string $caseId, string $fileId): StreamedResponse
    {
        $case = DB::table('dispute_cases')->where('id', DisputeAccess::uuid($caseId))->first();
        if ($case === null || ! $this->access->userCanAccessCase($user, $case)) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This file is unavailable.', 404);
        }
        // Fulfillment Staff reach only the fulfillment evidence of an assigned order's case, never the commercial file.
        $fulfillmentOnly = $user->account_type === 'VENDOR' && DB::table('vendor_memberships')->where('user_id', $user->getKey())->where('status', 'ACTIVE')->value('role') === 'FULFILLMENT';
        $evidence = DB::table('dispute_evidence')->where('dispute_case_id', $case->id)->where('file_id', DisputeAccess::uuid($fileId));
        if ($fulfillmentOnly) {
            $evidence->where('label', 'FULFILLMENT');
        }
        $referenced = $evidence->exists() || (! $fulfillmentOnly && DB::table('dispute_remedies')->where('dispute_case_id', $case->id)->where('evidence_file_id', DisputeAccess::uuid($fileId))->exists());
        $file = $referenced ? DB::table('files')->where('id', $fileId)->where('owner_type', 'ORDER')->where('owner_id', $case->order_id)->where('visibility', 'PRIVATE')->where('scan_state', 'CLEAN')->first() : null;
        if ($file === null) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This file is unavailable.', 404);
        }
        $metadata = json_decode((string) ($file->metadata ?? '{}'), true) ?: [];
        $stream = Storage::disk(is_string($metadata['disk'] ?? null) ? $metadata['disk'] : $this->store->privateDisk())->readStream($file->object_key);
        if (! is_resource($stream)) {
            throw new AuthenticationException('FILE_UNAVAILABLE', 'The file is temporarily unavailable.', 503);
        }

        return response()->streamDownload(static function () use ($stream): void {
            fpassthru($stream);
            fclose($stream);
        }, 'case-evidence', ['Content-Type' => $file->content_type, 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff', 'Content-Disposition' => 'inline']);
    }
}
