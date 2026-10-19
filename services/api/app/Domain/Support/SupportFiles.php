<?php

declare(strict_types=1);

namespace App\Domain\Support;

use App\Domain\Catalog\CatalogFileStore;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Vendors\EvidenceContentValidator;
use Illuminate\Http\UploadedFile;
use Illuminate\Support\Facades\DB;

final class SupportFiles
{
    public function __construct(private readonly EvidenceContentValidator $validator, private readonly CatalogFileStore $store) {}

    public function store(UploadedFile $file, string $ticketId, ?int $uploader): string
    {
        if ((int) $file->getSize() > 3 * 1024 * 1024) {
            throw new AuthenticationException('FILE_VALIDATION_FAILED', 'Each support attachment must be at most 3 MB.', 422);
        }
        $this->validator->validate($file);
        $mime = (string) (new \finfo(FILEINFO_MIME_TYPE))->file((string) $file->getRealPath());
        $id = $this->store->store($file, 'SUPPORT_TICKET', $ticketId, 'SUPPORT_ATTACHMENT', $uploader, $mime);
        DB::table('files')->where('id', $id)->update(['retention_class' => 'SUPPORT_HISTORY']);

        return $id;
    }

    /** @param list<string> $ids */
    public function discard(array $ids): void
    {
        foreach ($ids as $id) {
            $this->store->discard($id);
        }
    }

    public function stream(string $ticketId, string $fileId): mixed
    {
        $referenced = DB::table('support_attachments as a')->join('support_entries as e', 'e.id', '=', 'a.entry_id')
            ->where('e.ticket_id', $ticketId)->where('a.file_id', $fileId)->exists();
        $file = $referenced ? DB::table('files')->where('id', $fileId)->where('owner_type', 'SUPPORT_TICKET')->where('owner_id', $ticketId)
            ->where('visibility', 'PRIVATE')->where('scan_state', 'CLEAN')->first() : null;
        if ($file === null) {
            throw new AuthenticationException('FILE_NOT_FOUND', 'This attachment is unavailable.', 404);
        }

        return $this->store->stream($file);
    }
}
