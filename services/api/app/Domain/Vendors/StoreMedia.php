<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\StreamedResponse;

final class StoreMedia
{
    public function __construct(private readonly OnboardingAccess $access, private readonly PublicMediaProvider $mediaProvider, private readonly PublicMediaRecovery $recovery, private readonly FileScanner $scanner, private readonly AuditRecorder $audit, private readonly ActivationReadiness $readiness) {}

    /** @return list<object> */
    public function read(Request $request, string $organization): array
    {
        $this->authorize($request, $organization);

        return DB::table('store_media as m')->join('store_profiles as p', 'p.id', '=', 'm.store_profile_id')->join('files as f', 'f.id', '=', 'm.file_id')->where('p.vendor_organization_id', $organization)->whereNull('m.replaced_at')->orderBy('m.kind')->orderBy('m.id')->limit(22)->get(['m.id', 'm.kind', 'm.alt_text', 'm.review_status', 'f.scan_state'])->all();
    }

    private function authorize(Request $request, string $organization): void
    {
        if ($request->user()->account_type === 'ADMIN') {
            $this->access->reviewer($request);
        } else {
            $this->access->vendor($request, $organization);
        }
    }

    public function upload(Request $request, string $organization, UploadedFile $file): void
    {
        $this->access->vendor($request, $organization);
        $mime = $file->getMimeType();
        $allowed = ['image/jpeg' => ['jpg', 'jpeg'], 'image/png' => ['png']];
        $dimensions = @getimagesize($file->getPathname());
        if (! $file->isValid() || $file->getSize() < 1 || $file->getSize() > config('vendor_onboarding.maximum_file_bytes') || ! isset($allowed[$mime]) || ! in_array(strtolower($file->getClientOriginalExtension()), $allowed[$mime], true) || $dimensions === false || $dimensions[0] * $dimensions[1] > 40000000) {
            throw new AuthenticationException('FILE_INVALID', 'Use a valid JPEG or PNG up to 10 MB and 40 megapixels.', 422);
        }
        $id = (string) Str::uuid7();
        $key = 'vendor-store-media/'.$organization.'/'.$id;
        $this->preflight($request, $organization);
        $scan = $this->scanner->scan($file->getPathname());
        $recovery = $this->recovery->begin($request, $organization, $key);
        try {
            $asset = $this->mediaProvider->upload($file->getPathname(), $key);
            $this->recovery->uploaded($recovery, $asset);
        } catch (\Throwable) {
            $this->recovery->markUnconfirmed($recovery);
            throw new AuthenticationException('PUBLIC_MEDIA_CLEANUP_REQUIRED', 'This image upload has an uncertain provider outcome. Backend recovery must reconcile the object before retrying.', 503);
        }
        try {
            DB::transaction(function () use ($request, $organization, $file, $mime, $id, $key, $scan, $asset, $recovery): void {
                $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
                $this->access->vendor($request, $organization);
                $this->access->version($org, $request->integer('lock_version'));
                $this->requireStoreVerificationSubmission($org);
                $store = DB::table('store_profiles')->where('vendor_organization_id', $organization)->first();
                if ($store === null) {
                    throw new AuthenticationException('STORE_PROFILE_REQUIRED', 'Save the store profile first.', 409);
                }
                $kind = $request->string('kind')->toString();
                $existing = DB::table('store_media')->where('store_profile_id', $store->id)->where('kind', $kind)->whereNull('replaced_at');
                if ($kind === 'PROMOTIONAL' && $existing->count() >= 20) {
                    throw new AuthenticationException('MEDIA_LIMIT', 'Remove a promotional image before adding another.', 422);
                }
                if ($kind !== 'PROMOTIONAL') {
                    if ((clone $existing)->where('review_status', 'PENDING_VERIFICATION')->exists()) {
                        throw new AuthenticationException('MEDIA_REVIEW_PENDING', 'Remove the pending image before uploading another for this purpose.', 409);
                    }
                    $replaced = (clone $existing)->where('review_status', '!=', 'APPROVED')->pluck('id')->all();
                    DB::table('store_media')->whereIn('id', $replaced)->update(['replaced_at' => now(), 'updated_at' => now()]);
                    $this->recovery->scheduleLinkedCleanup($request, $replaced);
                }
                DB::table('files')->insert(['id' => $id, 'owner_type' => 'VENDOR_ORGANIZATION', 'owner_id' => $organization, 'vendor_organization_id' => $organization, 'storage_provider' => 'CLOUDINARY', 'provider_asset_id' => $asset['asset_id'], 'provider_format' => $asset['format'], 'purpose' => 'STORE_MEDIA', 'visibility' => 'PRIVATE', 'content_type' => $mime, 'byte_size' => $file->getSize(), 'checksum_sha256' => hash_file('sha256', $file->getPathname()), 'scan_state' => $scan, 'object_key' => $key, 'retention_class' => 'STORE_MEDIA', 'environment' => 'TEST', 'evidence_origin' => 'SAMPLE_DEMO', 'created_at' => now(), 'updated_at' => now()]);
                $media = (string) Str::uuid7();
                DB::table('store_media')->insert(['id' => $media, 'store_profile_id' => $store->id, 'file_id' => $id, 'kind' => $kind, 'alt_text' => $request->string('alt_text')->toString(), 'review_status' => 'PENDING_VERIFICATION', 'created_at' => now(), 'updated_at' => now()]);
                $this->recovery->linked($recovery, $media);
                DB::table('vendor_organizations')->where('id', $organization)->increment('lock_version');
                $this->audit->account($request, 'VENDOR_STORE_MEDIA_UPLOADED', 'STORE_MEDIA', $media, after: ['kind' => $kind]);
                $this->readiness->reconcile($request, $organization);
            });
        } catch (\Throwable $exception) {
            $this->recovery->requireCleanup($recovery, 'DATABASE_WRITE_FAILED');
            if (! $this->recovery->cleanup($request, $recovery)) {
                throw new AuthenticationException('PUBLIC_MEDIA_CLEANUP_REQUIRED', 'Cloudinary stored this image but the Store Profile update failed. Backend cleanup is required before retrying.', 503);
            }
            throw $exception;
        }
    }

    private function preflight(Request $request, string $organization): void
    {
        DB::transaction(function () use ($request, $organization): void {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->version($org, $request->integer('lock_version'));
            $this->requireStoreVerificationSubmission($org);
            $store = DB::table('store_profiles')->where('vendor_organization_id', $organization)->first();
            if ($store === null) {
                throw new AuthenticationException('STORE_PROFILE_REQUIRED', 'Save the store profile first.', 409);
            }
            $kind = $request->string('kind')->toString();
            $existing = DB::table('store_media')->where('store_profile_id', $store->id)->where('kind', $kind)->whereNull('replaced_at');
            if ($kind === 'PROMOTIONAL' && $existing->count() >= 20) {
                throw new AuthenticationException('MEDIA_LIMIT', 'Remove a promotional image before adding another.', 422);
            }
            if ($kind !== 'PROMOTIONAL' && (clone $existing)->where('review_status', 'PENDING_VERIFICATION')->exists()) {
                throw new AuthenticationException('MEDIA_REVIEW_PENDING', 'Remove the pending image before uploading another for this purpose.', 409);
            }
            if (DB::table('vendor_public_media_recoveries')->where('vendor_organization_id', $organization)->whereNull('store_media_id')->whereIn('state', ['PLANNED', 'UPLOAD_UNCONFIRMED', 'UPLOAD_CONFIRMED', 'CLEANUP_REQUIRED'])->exists()) {
                throw new AuthenticationException('PUBLIC_MEDIA_RECOVERY_PENDING', 'A previous public-media operation still needs backend recovery before another upload.', 503);
            }
        });
    }

    private function requireStoreVerificationSubmission(object $organization): void
    {
        if ($organization->submitted_at === null) {
            throw new AuthenticationException('STORE_VERIFICATION_SUBMISSION_REQUIRED', 'Submit Store Verification before proceeding to Store Setup.', 409);
        }
    }

    public function review(Request $request, string $organization, string $media): void
    {
        $this->access->reviewer($request);
        DB::transaction(function () use ($request, $organization, $media): void {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->version($org, $request->integer('lock_version'));
            $row = $this->find($organization, $media);
            if ($row->review_status !== 'PENDING_VERIFICATION') {
                throw new AuthenticationException('MEDIA_REVIEW_FINAL', 'This image already has a final review decision. Upload a replacement for another review.', 409);
            }
            $decision = $request->string('decision')->toString();
            if ($decision === 'APPROVE' && ! in_array($row->scan_state, ['CLEAN', 'TEST_SIMULATED_CLEAN'], true)) {
                throw new AuthenticationException('DOCUMENT_SCAN_PENDING', 'The image must clear scanning before approval.', 409);
            }
            $status = match ($decision) {
                'APPROVE' => 'APPROVED', 'REJECT' => 'REJECTED', default => 'RETURN_FOR_CORRECTION'
            };
            if ($status === 'APPROVED' && $row->kind !== 'PROMOTIONAL') {
                $replaced = DB::table('store_media')->where('store_profile_id', $row->store_profile_id)->where('kind', $row->kind)->where('id', '!=', $media)->whereNull('replaced_at')->pluck('id')->all();
                DB::table('store_media')->whereIn('id', $replaced)->update(['replaced_at' => now(), 'updated_at' => now()]);
                $this->recovery->scheduleLinkedCleanup($request, $replaced);
            }
            DB::table('store_media')->where('id', $media)->update(['review_status' => $status, 'updated_at' => now()]);
            DB::table('vendor_organizations')->where('id', $organization)->increment('lock_version');
            $this->audit->account($request, 'VENDOR_STORE_MEDIA_REVIEWED', 'STORE_MEDIA', $media, after: ['decision' => $decision, 'reason' => $request->input('reason')]);
            app(ReviewVendorEvidence::class)->notice($organization, 'A store image was reviewed. Open Store and fulfillment for its status.');
            $this->readiness->reconcile($request, $organization);
        });
    }

    public function remove(Request $request, string $organization, string $media): void
    {
        $this->access->vendor($request, $organization);
        DB::transaction(function () use ($request, $organization, $media): void {
            $org = DB::table('vendor_organizations')->where('id', $organization)->lockForUpdate()->firstOrFail();
            $this->access->version($org, $request->integer('lock_version'));
            $this->find($organization, $media);
            DB::table('store_media')->where('id', $media)->update(['replaced_at' => now(), 'updated_at' => now()]);
            $this->recovery->scheduleLinkedCleanup($request, [$media]);
            DB::table('vendor_organizations')->where('id', $organization)->increment('lock_version');
            $this->audit->account($request, 'VENDOR_STORE_MEDIA_REMOVED', 'STORE_MEDIA', $media);
            $this->readiness->reconcile($request, $organization);
        });
    }

    private function find(string $organization, string $media): object
    {
        $row = DB::table('store_media as m')->join('store_profiles as p', 'p.id', '=', 'm.store_profile_id')->join('files as f', 'f.id', '=', 'm.file_id')->where('p.vendor_organization_id', $organization)->where('m.id', $media)->whereNull('m.replaced_at')->first(['f.*', 'm.store_profile_id', 'm.kind', 'm.review_status']);
        if ($row === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This image is unavailable.', 404);
        }

        return $row;
    }

    public function preview(Request $request, string $organization, string $media): StreamedResponse
    {
        $this->authorize($request, $organization);
        $row = $this->find($organization, $media);
        if (! in_array($row->scan_state, ['CLEAN', 'TEST_SIMULATED_CLEAN'], true)) {
            throw new AuthenticationException('DOCUMENT_SCAN_PENDING', 'This image is not cleared for viewing.', 409);
        }

        if ($row->storage_provider !== 'CLOUDINARY') {
            throw new AuthenticationException('PUBLIC_MEDIA_MIGRATION_REQUIRED', 'Re-upload this earlier draft image to Cloudinary.', 409);
        }
        $contents = $this->mediaProvider->contents($row->object_key, $row->provider_format);

        return response()->stream(function () use ($contents): void {
            echo $contents;
        }, 200, ['Content-Type' => $row->content_type, 'X-Content-Type-Options' => 'nosniff', 'Cache-Control' => 'private, no-store']);
    }

    public function publicPreview(string $organization, string $media): StreamedResponse
    {
        $row = DB::table('store_media as m')->join('store_profiles as p', 'p.id', '=', 'm.store_profile_id')->join('vendor_organizations as o', 'o.id', '=', 'p.vendor_organization_id')->join('files as f', 'f.id', '=', 'm.file_id')->where('p.vendor_organization_id', $organization)->where('m.id', $media)->where('o.marketplace_status', 'ACTIVE')->where('m.review_status', 'APPROVED')->whereNull('m.replaced_at')->where('f.storage_provider', 'CLOUDINARY')->where('f.environment', 'TEST')->whereIn('f.scan_state', ['CLEAN', 'TEST_SIMULATED_CLEAN'])->first(['f.object_key', 'f.provider_format', 'f.content_type']);
        if ($row === null) {
            throw new AuthenticationException('RESOURCE_NOT_FOUND', 'This public Store Profile image is unavailable.', 404);
        }
        $contents = $this->mediaProvider->contents($row->object_key, $row->provider_format);

        return response()->stream(function () use ($contents): void {
            echo $contents;
        }, 200, ['Content-Type' => $row->content_type, 'X-Content-Type-Options' => 'nosniff', 'Cache-Control' => 'public, max-age=3600']);
    }
}
