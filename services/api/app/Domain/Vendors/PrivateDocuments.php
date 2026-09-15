<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\StreamedResponse;

final class PrivateDocuments
{
    public const TYPES = ['GOVERNMENT_ID', 'DTI', 'SEC', 'CDA', 'LGU_PERMIT', 'BIR_COR', 'REGULATORY', 'ISO_CERTIFICATION', 'TAX_DECLARATION', 'WITHHOLDING_DECLARATION'];

    public function __construct(private readonly OnboardingAccess $access, private readonly AuditRecorder $audit, private readonly FileScanner $scanner, private readonly ActivationReadiness $readiness) {}

    /** @return array<string, mixed> */
    public function upload(Request $request, string $organization, string $type, UploadedFile $upload, int $version): array
    {
        $this->access->vendor($request, $organization, sensitive: true);
        if (! in_array($type, self::TYPES, true) || ! $upload->isValid() || $upload->getSize() < 1 || $upload->getSize() > config('vendor_onboarding.maximum_file_bytes')) {
            throw new AuthenticationException('FILE_INVALID', 'Use a nonempty PDF, JPEG or PNG within the upload limit.', 422);
        }
        $mime = $upload->getMimeType();
        $extension = strtolower($upload->getClientOriginalExtension());
        $allow = ['application/pdf' => ['pdf'], 'image/jpeg' => ['jpg', 'jpeg'], 'image/png' => ['png']];
        if (! isset($allow[$mime]) || ! in_array($extension, $allow[$mime], true) || ($mime !== 'application/pdf' && @getimagesize($upload->getPathname()) === false)) {
            throw new AuthenticationException('FILE_CONTENT_MISMATCH', 'The file content must match its supported file type.', 422);
        }
        $contents = file_get_contents($upload->getPathname());
        if ($mime === 'application/pdf' && (! str_starts_with($contents, '%PDF-') || ! str_contains(substr($contents, -1024), '%%EOF'))) {
            throw new AuthenticationException('FILE_MALFORMED', 'The PDF is malformed.', 422);
        }
        $fileId = (string) Str::uuid7();
        $key = 'vendor-evidence/'.$organization.'/'.$fileId;
        $scan = $this->scanner->scan($upload->getPathname());
        $disk = Storage::disk(config('vendor_onboarding.disk'));
        if (! $disk->put($key, $contents, ['visibility' => 'private', 'ContentType' => $mime])) {
            throw new AuthenticationException('STORAGE_UNAVAILABLE', 'Private storage is unavailable. Retry later.', 503);
        }

        try {
            return DB::transaction(function () use ($request, $organization, $type, $version, $upload, $fileId, $key, $mime, $scan): array {
                $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
                $this->access->vendor($request, $organization, sensitive: true);
                $this->access->version($org, $version);
                $document = DB::table('business_documents')->where('vendor_organization_id', $organization)->where('document_type', $type)->first();
                $documentId = $document->id ?? (string) Str::uuid7();
                if ($document === null) {
                    DB::table('business_documents')->insert(['id' => $documentId, 'vendor_organization_id' => $organization, 'document_type' => $type, 'created_at' => now(), 'updated_at' => now()]);
                }
                $checksum = hash_file('sha256', $upload->getPathname());
                DB::table('files')->insert(['id' => $fileId, 'owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $organization, 'vendor_organization_id' => $organization, 'purpose' => 'BUSINESS_EVIDENCE', 'visibility' => 'PRIVATE', 'content_type' => $mime, 'byte_size' => $upload->getSize(), 'checksum_sha256' => $checksum, 'scan_state' => $scan, 'object_key' => $key, 'retention_class' => 'BUSINESS_EVIDENCE', 'environment' => 'TEST', 'evidence_origin' => 'SAMPLE_DEMO', 'created_at' => now(), 'updated_at' => now()]);
                $versionId = (string) Str::uuid7();
                $number = (int) DB::table('business_document_versions')->where('business_document_id', $documentId)->max('version') + 1;
                DB::table('business_document_versions')->insert(['id' => $versionId, 'business_document_id' => $documentId, 'version' => $number, 'file_id' => $fileId, 'content_hash' => $checksum, 'uploaded_by_user_id' => $request->user()->getKey(), 'environment' => 'TEST', 'evidence_origin' => 'SAMPLE_DEMO', 'created_at' => now(), 'updated_at' => now()]);
                DB::table('business_documents')->where('id', $documentId)->update(['current_version_id' => $versionId, 'status' => 'PENDING_VERIFICATION', 'lock_version' => ($document->lock_version ?? 1) + 1, 'updated_at' => now()]);
                DB::table('vendor_organizations')->where('id', $organization)->increment('lock_version');
                $this->audit->account($request, 'VENDOR_DOCUMENT_UPLOADED', 'BUSINESS_DOCUMENT_VERSION', $versionId, after: ['document_id' => $documentId, 'version' => $number, 'environment' => 'TEST', 'scan_state' => $scan]);
                $this->readiness->reconcile($request, $organization);
                $stepCode = $type === 'GOVERNMENT_ID' ? 'GOVERNMENT_ID' : $type;
                $stepId = DB::table('vendor_onboarding_steps')->where('vendor_organization_id', $organization)->where('step_code', $stepCode)->value('id');
                if ($stepId !== null) {
                    DB::table('business_documents')->where('id', $documentId)->update(['vendor_onboarding_step_id' => $stepId]);
                }

                return ['id' => $versionId, 'document_id' => $documentId, 'version' => $number, 'scan_state' => $scan, 'environment' => 'TEST'];
            });
        } catch (\Throwable $exception) {
            // The opaque object belongs only to this failed upload attempt.
            $disk->delete($key);
            throw $exception;
        }
    }

    private function authorize(Request $request, string $organization, string $version): object
    {
        if ($request->user()->account_type === 'ADMIN') {
            $this->access->reviewer($request);
        } else {
            $this->access->vendor($request, $organization);
        }
        $file = DB::table('business_document_versions as v')->join('business_documents as d', 'd.id', '=', 'v.business_document_id')->join('files as f', 'f.id', '=', 'v.file_id')->where('v.id', $version)->where('d.vendor_organization_id', $organization)->where('f.vendor_organization_id', $organization)->where('f.visibility', 'PRIVATE')->first(['f.*']);
        if ($file === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This document is unavailable.', 404);
        }
        if (! in_array($file->scan_state, ['CLEAN', 'TEST_SIMULATED_CLEAN'], true)) {
            throw new AuthenticationException('DOCUMENT_SCAN_PENDING', 'This document is not cleared for viewing.', 409);
        }

        return $file;
    }

    /** @return array<string, mixed> */
    public function link(Request $request, string $organization, string $version): array
    {
        $this->authorize($request, $organization, $version);
        $prefix = $request->user()->account_type === 'ADMIN' ? 'admin' : 'vendors';
        $expires = now()->addMinutes(config('vendor_onboarding.download_minutes'));
        $url = URL::temporarySignedRoute($prefix.'.evidence.download', $expires, ['organization' => $organization, 'version' => $version, 'viewer' => $request->user()->public_id]);
        $this->audit->account($request, 'VENDOR_DOCUMENT_ACCESS_ISSUED', 'BUSINESS_DOCUMENT_VERSION', $version);

        return ['url' => $url, 'expires_at' => $expires->toIso8601String()];
    }

    public function download(Request $request, string $organization, string $version): StreamedResponse
    {
        if (! $request->hasValidSignature() || $request->query('viewer') !== $request->user()->public_id) {
            throw new AuthenticationException('DOCUMENT_LINK_EXPIRED', 'Request a new document link.', 403);
        }
        $file = $this->authorize($request, $organization, $version);
        $this->audit->account($request, 'VENDOR_DOCUMENT_DOWNLOADED', 'BUSINESS_DOCUMENT_VERSION', $version);

        return Storage::disk(config('vendor_onboarding.disk'))->download($file->object_key, 'SAMPLE-DEMO-evidence.'.match ($file->content_type) {
            'image/png' => 'png', 'image/jpeg' => 'jpg', default => 'pdf'
        }, ['Content-Type' => $file->content_type, 'X-Content-Type-Options' => 'nosniff', 'Cache-Control' => 'private, no-store']);
    }
}
