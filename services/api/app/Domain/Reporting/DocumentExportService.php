<?php

declare(strict_types=1);

namespace App\Domain\Reporting;

use App\Domain\Authorization\RecentAuthentication;
use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use App\Models\User;
use Carbon\CarbonImmutable;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Cache;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Storage;
use Illuminate\Support\Str;
use Symfony\Component\HttpFoundation\StreamedResponse;

final class DocumentExportService
{
    public const TYPES = ['PURCHASE_ORDER', 'PAYMENT_CONFIRMATION', 'PROJECT_SUMMARY', 'BUDGET_REPORT', 'OPERATIONAL_ORDER', 'FEE_STATEMENT', 'MATERIALS_ANALYTICS', 'TAX_PACKAGE', 'AUDIT_LOG', 'GEO_ANALYTICS', 'TRANSACTION_HISTORY', 'EARNINGS'];

    /** @param array<string, mixed> $input
     * @return array<string, mixed> */
    public function request(Request $request, array $input): array
    {
        $user = $request->user();
        $type = $input['type'];
        $resourceId = $input['resource_id'] ?? null;
        if (! app(ExportAccess::class)->allows($user, $type, $resourceId)) {
            throw new AuthenticationException('EXPORT_ACCESS_DENIED', 'This document is unavailable to your current role or is not ready.', 403);
        }
        if ($user->account_type === 'ADMIN') {
            app(RecentAuthentication::class)->require($request);
        }
        $key = $request->header('Idempotency-Key');
        if (! is_string($key) || strlen($key) < 8 || strlen($key) > 128) {
            throw new AuthenticationException('IDEMPOTENCY_KEY_REQUIRED', 'Provide an Idempotency-Key for this export.', 422);
        }

        return DB::transaction(function () use ($input, $request, $user, $type, $resourceId, $key): array {
            // Serialize actor requests so concurrent retries cannot capture different versions under one key.
            DB::table('users')->where('id', $user->getKey())->lockForUpdate()->first();
            $hash = hash('sha256', $key);
            $existing = DB::table('data_exports')->where('requested_by_user_id', $user->getKey())->where('request_key', $hash)->first();
            if ($existing !== null) {
                if ($existing->export_type !== $type || $existing->resource_id !== $resourceId || $existing->format !== $input['format'] || $existing->reason !== $input['purpose'] || json_decode($existing->filters, true) != ($input['filters'] ?? [])) {
                    throw new AuthenticationException('IDEMPOTENCY_CONFLICT', 'Use a new key for changed export options.', 409);
                }

                return $this->present($existing);
            }
            $capture = app(DocumentSnapshot::class)->capture($request, $type, $resourceId, $input['filters'] ?? []);
            $sourceHash = hash('sha256', json_encode($capture, JSON_THROW_ON_ERROR));
            $snapshot = ['title' => DocumentSnapshot::label($type), 'generated_at' => now('Asia/Manila')->format('Y-m-d H:i:s'), 'source_hash' => $sourceHash, ...$capture];
            $id = (string) Str::uuid7();
            $scope = $request->attributes->get('account_scope');
            DB::table('data_exports')->insert(['id' => $id, 'requested_by_user_id' => $user->getKey(), 'export_type' => $type, 'format' => $input['format'],
                'filters' => json_encode($input['filters'] ?? [], JSON_THROW_ON_ERROR), 'reason' => $input['purpose'], 'state' => 'QUEUED', 'resource_type' => $type,
                'resource_id' => $resourceId, 'source_snapshot' => json_encode($snapshot, JSON_THROW_ON_ERROR), 'source_versions' => json_encode($capture['versions'], JSON_THROW_ON_ERROR),
                'source_hash' => $sourceHash, 'request_key' => $hash, 'vendor_organization_id' => $scope['organization_id'] ?? null, 'requested_role' => $scope['role'] ?? 'BUYER', 'created_at' => now(), 'updated_at' => now()]);
            app(OutboxPublisher::class)->publish('DOCUMENT_EXPORT_REQUESTED', 'DATA_EXPORT', $id, ['export_id' => $id]);
            app(AuditRecorder::class)->account($request, 'DOCUMENT_EXPORT_REQUESTED', 'DATA_EXPORT', $id, after: ['source_hash' => $sourceHash, 'type' => $type]);

            return $this->present(DB::table('data_exports')->where('id', $id)->first());
        });
    }

    public function process(string $id): void
    {
        Cache::lock('document-export:'.$id, 120)->block(5, function () use ($id): void {
            $export = DB::table('data_exports')->where('id', $id)->first();
            if ($export === null || $export->state !== 'QUEUED') {
                return;
            }
            if (! $this->allowed($export)) {
                $this->revoke($export);

                return;
            }
            $snapshot = json_decode($export->source_snapshot, true, flags: JSON_THROW_ON_ERROR);
            $snapshot['captured_at'] = $snapshot['generated_at'];
            $snapshot['generated_at'] = now('Asia/Manila')->format('Y-m-d H:i:s');
            $bytes = app(DocumentRenderer::class)->render($snapshot, $export->format);
            if ($bytes === '' || ($export->format === 'PDF' && ! str_starts_with($bytes, '%PDF-'))) {
                throw new \RuntimeException('EXPORT_RENDER_FAILED');
            }
            $disk = app(CatalogFileStore::class)->privateDisk();
            $fileId = (string) Str::uuid7();
            $key = 'private/exports/'.app()->environment().'/'.$id.'/'.$fileId.'.'.strtolower($export->format);
            if (! Storage::disk($disk)->put($key, $bytes, ['visibility' => 'private'])) {
                throw new \RuntimeException('EXPORT_STORAGE_UNAVAILABLE');
            }
            if (! $this->allowed($export)) {
                Storage::disk($disk)->delete($key);
                $this->revoke($export);

                return;
            }
            DB::transaction(function () use ($export, $id, $fileId, $key, $bytes, $disk, $snapshot): void {
                DB::table('files')->insert(['id' => $fileId, 'owner_type' => 'USER', 'owner_id' => DB::table('users')->where('id', $export->requested_by_user_id)->value('public_id'),
                    'purpose' => 'DOCUMENT_EXPORT', 'visibility' => 'PRIVATE', 'content_type' => $export->format === 'PDF' ? 'application/pdf' : 'text/csv',
                    'byte_size' => strlen($bytes), 'checksum_sha256' => hash('sha256', $bytes), 'scan_state' => 'CLEAN', 'object_key' => $key, 'retention_class' => 'OPERATIONAL_EXPORT',
                    'original_name' => 'materyalph-'.strtolower($export->export_type).'.'.strtolower($export->format), 'uploaded_by_user_id' => $export->requested_by_user_id,
                    'metadata' => json_encode(['source' => 'GENERATED_SNAPSHOT', 'disk' => $disk], JSON_THROW_ON_ERROR), 'created_at' => now(), 'updated_at' => now()]);
                DB::table('data_exports')->where('id', $id)->where('state', 'QUEUED')->update(['state' => 'READY', 'file_id' => $fileId, 'row_count' => count($snapshot['rows']), 'completed_at' => now(), 'expires_at' => now()->addDay(), 'updated_at' => now()]);
                $this->audit($export, 'GENERATED', hash('sha256', $bytes));
                if ($export->export_type === 'TAX_PACKAGE') {
                    DB::table('tax_report_packages')->where('id', $export->resource_id)->where('state', 'REVIEWED')->update(['state' => 'EXPORTED', 'export_hash' => hash('sha256', $bytes), 'file_id' => $fileId, 'issued_at' => now(), 'updated_at' => now()]);
                }
            });
        });
    }

    public function download(Request $request, string $id): StreamedResponse
    {
        $export = DB::table('data_exports')->where('id', $id)->where('requested_by_user_id', $request->user()->getKey())->first();
        if ($export === null || ! $this->allowed($export)) {
            if ($export !== null) {
                $this->revoke($export);
            }
            throw new AuthenticationException('EXPORT_ACCESS_REVOKED', 'You no longer have access to this export.', 403);
        }
        if ($export->state !== 'READY' || $export->expires_at === null || CarbonImmutable::parse($export->expires_at)->isPast()) {
            throw new AuthenticationException('EXPORT_EXPIRED', 'This export is unavailable or expired. Request a new copy.', 410);
        }
        $file = DB::table('files')->where('id', $export->file_id)->first();
        if ($file === null) {
            throw new AuthenticationException('EXPORT_FILE_UNAVAILABLE', 'This file is unavailable. Generate a new copy.', 410);
        }
        $disk = json_decode($file->metadata, true)['disk'];
        if (! Storage::disk($disk)->exists($file->object_key)) {
            throw new AuthenticationException('EXPORT_FILE_UNAVAILABLE', 'This file is unavailable. Generate a new copy.', 410);
        }
        $bytes = Storage::disk($disk)->get($file->object_key);
        if (! is_string($bytes) || ! hash_equals($file->checksum_sha256, hash('sha256', $bytes))) {
            throw new AuthenticationException('EXPORT_CHECKSUM_FAILED', 'This file could not be verified. Request a new export.', 409);
        }
        $this->audit($export, 'DOWNLOADED', $file->checksum_sha256);
        app(AuditRecorder::class)->account($request, 'DOCUMENT_EXPORT_DOWNLOADED', 'DATA_EXPORT', $id, after: ['sha256' => $file->checksum_sha256]);

        return response()->streamDownload(static function () use ($bytes): void {
            echo $bytes;
        }, $file->original_name, ['Content-Type' => $file->content_type, 'Content-Length' => (string) strlen($bytes), 'Cache-Control' => 'private, no-store', 'X-Content-Type-Options' => 'nosniff']);
    }

    /** @phpstan-impure Current membership and assignments can change between generation and delivery. */
    public function allowed(object $export): bool
    {
        $user = User::query()->find($export->requested_by_user_id);

        return $user instanceof User && app(ExportAccess::class)->allows($user, $export->export_type, $export->resource_id, $export->vendor_organization_id);
    }

    private function revoke(object $export): void
    {
        DB::table('data_exports')->where('id', $export->id)->where('state', '<>', 'REVOKED')->update(['state' => 'REVOKED', 'revoked_at' => now(), 'revocation_reason' => 'ACCESS_REVOKED', 'updated_at' => now()]);
        $this->audit($export, 'ACCESS_DENIED', null);
    }

    private function audit(object $export, string $action, ?string $hash): void
    {
        DB::table('export_access_events')->insert(['id' => (string) Str::uuid7(), 'data_export_id' => $export->id, 'user_id' => $export->requested_by_user_id, 'action' => $action, 'checksum' => $hash, 'occurred_at' => now()]);
    }

    /** @return array<string, mixed> */
    public function present(object $row): array
    {
        $state = $row->state === 'READY' && $row->expires_at !== null && CarbonImmutable::parse($row->expires_at)->isPast() ? 'EXPIRED' : $row->state;

        return ['id' => $row->id, 'type' => $row->export_type, 'resource_id' => $row->resource_id, 'format' => $row->format, 'state' => $state, 'purpose' => $row->reason,
            'filters' => (object) json_decode($row->filters, true), 'source_hash' => $row->source_hash, 'source_versions' => (object) json_decode($row->source_versions ?? '{}', true),
            'checksum' => $row->file_id === null ? null : DB::table('files')->where('id', $row->file_id)->value('checksum_sha256'), 'created_at' => $row->created_at,
            'expires_at' => $row->expires_at, 'failure_code' => $row->failure_code,
            'access_record' => DB::table('export_access_events')->where('data_export_id', $row->id)->orderByDesc('occurred_at')->limit(10)->get(['action', 'occurred_at'])->map(fn (object $e): array => (array) $e)->all()];
    }
}
