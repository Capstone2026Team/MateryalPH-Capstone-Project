<?php

declare(strict_types=1);

namespace App\Domain\Enforcement;

use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuditRecorder;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\AdminAccess;
use App\Domain\Reviews\ReviewMediaFiles;
use App\Domain\Vendors\EvidenceContentValidator;
use Illuminate\Http\Request;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\URL;
use Illuminate\Support\Str;

/** Private, scanned justification files. Upload/scan completes before any sanction transaction begins. */
final class EnforcementFiles
{
    public const PURPOSE = 'ENFORCEMENT_EVIDENCE';

    public function __construct(
        private readonly AdminAccess $access,
        private readonly EnforcementService $enforcement,
        private readonly EvidenceContentValidator $documents,
        private readonly ReviewMediaFiles $media,
        private readonly CatalogFileStore $store,
        private readonly AuditRecorder $audit,
    ) {}

    /** @return array<string, mixed> */
    public function upload(Request $request, string $type, string $subjectId, UploadedFile $file): array
    {
        $actor = $this->access->require($request, 'enforcement.view', 'enforcement.apply');
        $this->enforcement->subject($request, $type, $subjectId);
        $extension = strtolower($file->getClientOriginalExtension());
        if (in_array($extension, ['mp4', 'mov'], true)) {
            $mime = $this->media->validate($file);
        } else {
            $this->documents->validate($file);
            $mime = (string) $file->getMimeType();
        }
        $id = $this->store->store($file, $type, $subjectId, self::PURPOSE, $actor['user_id'], $mime);
        DB::table('files')->where('id', $id)->update(['retention_class' => 'ENFORCEMENT_HISTORY']);

        return ['id' => $id, 'name' => (string) $file->getClientOriginalName(), 'content_type' => $mime, 'byte_size' => (int) $file->getSize()];
    }

    /** Attach only this actor's clean uploads for this exact subject, once, inside the decision transaction.
     * @param  list<string>  $ids
     */
    public static function attach(array $ids, string $actionId, string $type, string $subjectId, int $actorId): void
    {
        sort($ids);
        foreach ($ids as $id) {
            $file = DB::table('files')->where('id', $id)->where('owner_type', $type)->where('owner_id', $subjectId)
                ->where('purpose', self::PURPOSE)->where('uploaded_by_user_id', $actorId)->where('visibility', 'PRIVATE')->where('scan_state', 'CLEAN')->lockForUpdate()->first();
            if ($file === null || DB::table('enforcement_evidence')->where('file_id', $id)->exists()) {
                throw new AuthenticationException('ENFORCEMENT_EVIDENCE_INVALID', 'Choose clean proof files uploaded for this account and decision.', 422);
            }
            DB::table('enforcement_evidence')->insert(['id' => (string) Str::uuid7(), 'enforcement_action_id' => $actionId,
                'file_id' => $id, 'recorded_by_user_id' => $actorId, 'created_at' => now()]);
        }
    }

    /** @return list<array<string, mixed>> */
    public static function summary(string $actionId): array
    {
        return DB::table('enforcement_evidence as e')->join('files as f', 'f.id', '=', 'e.file_id')->where('e.enforcement_action_id', $actionId)
            ->orderBy('e.created_at')->orderBy('e.id')->get(['f.id', 'f.original_name', 'f.content_type', 'f.byte_size'])
            ->map(static fn (object $file): array => ['id' => (string) $file->id, 'name' => (string) $file->original_name,
                'content_type' => (string) $file->content_type, 'byte_size' => (int) $file->byte_size])->all();
    }

    /** @return array{url: string, expires_at: string} */
    public function link(Request $request, string $actionId, string $fileId): array
    {
        $this->file($request, $actionId, $fileId);
        $expires = now()->addMinutes(5);

        return ['url' => URL::temporarySignedRoute('admin.enforcement.file', $expires, compact('actionId', 'fileId')), 'expires_at' => $expires->toIso8601String()];
    }

    public function stream(Request $request, string $actionId, string $fileId): mixed
    {
        $file = $this->file($request, $actionId, $fileId);
        $this->audit->account($request, 'ENFORCEMENT_EVIDENCE_VIEWED', 'ENFORCEMENT_ACTION', $actionId, [], ['file_id' => $fileId]);

        return $this->store->stream($file);
    }

    private function file(Request $request, string $actionId, string $fileId): object
    {
        $this->access->require($request, 'enforcement.view');
        $file = DB::table('enforcement_evidence as e')->join('files as f', 'f.id', '=', 'e.file_id')->where('e.enforcement_action_id', $actionId)
            ->where('e.file_id', $fileId)->where('f.purpose', self::PURPOSE)->where('f.visibility', 'PRIVATE')->where('f.scan_state', 'CLEAN')->first(['f.*']);
        if ($file === null) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This proof attachment is unavailable.', 404);
        }

        return $file;
    }
}
