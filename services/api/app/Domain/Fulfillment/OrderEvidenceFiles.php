<?php

declare(strict_types=1);

namespace App\Domain\Fulfillment;

use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\EvidenceContentValidator;
use App\Domain\Vendors\VendorFileScanner;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\StreamedResponse;

/**
 * Private order evidence: delivery/handover proof photos and signatures, Buyer problem photos, NRPC preparation
 * evidence and Vendor cash-reimbursement evidence. Content is validated by type and structure, scanned fail-closed
 * and stored privately under the order. Bytes leave only through an authorized order-scoped download; a file is
 * served only when one of that order's own records references it.
 */
final class OrderEvidenceFiles
{
    public const PROOF = 'FULFILLMENT_PROOF';

    public const ISSUE = 'FULFILLMENT_ISSUE_EVIDENCE';

    public const NRPC = 'CANCELLATION_NRPC_EVIDENCE';

    public const REIMBURSEMENT = 'REIMBURSEMENT_EVIDENCE';

    public function __construct(private readonly EvidenceContentValidator $validator, private readonly VendorFileScanner $scanner, private readonly CatalogFileStore $store) {}

    /** Validates, scans and stores one file before the caller's transaction; returns the file id. */
    public function store(UploadedFile $file, string $orderId, string $purpose, int $uploaderId, bool $photoOnly): string
    {
        $this->validator->validate($file);
        $contentType = (string) (new \finfo(FILEINFO_MIME_TYPE))->file((string) $file->getRealPath());
        if ($photoOnly && ! in_array($contentType, ['image/jpeg', 'image/png'], true)) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Upload a JPG or PNG photo.', 422, ['file' => ['Upload a JPG or PNG photo.']]);
        }
        $this->scanner->assertClean((string) $file->getRealPath());
        $disk = $this->store->privateDisk();
        $fileId = (string) Str::uuid7();
        $key = 'private/order/'.$orderId.'/'.strtolower($purpose).'/'.$fileId.($contentType === 'application/pdf' ? '.pdf' : ($contentType === 'image/png' ? '.png' : '.jpg'));
        if (! Storage::disk($disk)->putFileAs('', $file, $key, ['visibility' => 'private'])) {
            throw new AuthenticationException('FILE_STORAGE_UNAVAILABLE', 'The file could not be stored. Try again.', 503);
        }
        DB::table('files')->insert([
            'id' => $fileId, 'owner_type' => 'ORDER', 'owner_id' => $orderId, 'purpose' => $purpose, 'visibility' => 'PRIVATE', 'content_type' => $contentType,
            'byte_size' => (int) $file->getSize(), 'checksum_sha256' => (string) hash_file('sha256', (string) $file->getRealPath()), 'scan_state' => 'CLEAN', 'object_key' => $key,
            'retention_class' => 'COMMERCIAL_HISTORY', 'original_name' => Str::limit($file->getClientOriginalName(), 180, ''), 'uploaded_by_user_id' => $uploaderId,
            'metadata' => json_encode(['source' => 'ORDER', 'purpose' => $purpose, 'disk' => $disk], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now(),
        ]);

        return $fileId;
    }

    /**
     * Removes files stored for a request whose transaction did not commit.
     *
     * @param  array<int, string|null>  $fileIds
     */
    public function discard(array $fileIds): void
    {
        foreach (array_filter($fileIds) as $fileId) {
            $this->store->discard((string) $fileId);
        }
    }

    /** Streams a private file that a record of this order references; anything else is not found. */
    public function stream(string $orderId, string $fileId, bool $forBuyer): StreamedResponse
    {
        $referenced = DB::table('fulfillment_proofs')->where('order_id', $orderId)->where(fn ($q) => $q->where('photo_file_id', $fileId)->orWhere('signature_file_id', $fileId))->exists()
            || DB::table('fulfillment_issues')->where('order_id', $orderId)->whereRaw('evidence_file_ids @> ?::jsonb', [json_encode([$fileId], JSON_THROW_ON_ERROR)])->exists()
            || DB::table('physical_reimbursements')->where('order_id', $orderId)->where('evidence_file_id', $fileId)->exists()
            // NRPC preparation evidence is a Vendor commercial record; the Buyer sees its status, not the file.
            || (! $forBuyer && DB::table('cancellation_decisions')->where('order_id', $orderId)->where('evidence_file_id', $fileId)->exists());
        $file = $referenced ? DB::table('files')->where('id', $fileId)->where('owner_type', 'ORDER')->where('owner_id', $orderId)->where('visibility', 'PRIVATE')->where('scan_state', 'CLEAN')->first() : null;
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
        }, 'order-evidence', ['Content-Type' => $file->content_type, 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff', 'Content-Disposition' => 'inline']);
    }
}
