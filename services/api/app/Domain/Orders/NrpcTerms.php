<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Agreements\AgreementContent;
use Illuminate\Support\Facades\DB;

/** The current versioned NRPC Terms. An NRPC can be proposed or accepted only while their text is available. */
final class NrpcTerms
{
    public const CODE = 'NRPC_TERMS';

    public function __construct(private readonly AgreementContent $content) {}

    /** @return array{id: string, version: int, title: string, content: ?string, content_hash: string}|null */
    public function current(): ?array
    {
        $row = DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->where('d.code', self::CODE)
            ->whereNull('v.retired_at')->where('v.effective_at', '<=', now())->orderByDesc('v.version')->first(['v.id', 'v.version', 'v.content_hash', 'd.code', 'd.title']);

        return $row === null ? null : $this->present($row);
    }

    /** @return array{id: string, version: int, title: string, content: ?string, content_hash: string}|null */
    public function version(?string $versionId): ?array
    {
        if ($versionId === null) {
            return null;
        }
        $row = DB::table('agreement_versions as v')->join('agreement_documents as d', 'd.id', '=', 'v.agreement_document_id')->where('v.id', $versionId)->where('d.code', self::CODE)
            ->first(['v.id', 'v.version', 'v.content_hash', 'd.code', 'd.title']);

        return $row === null ? null : $this->present($row);
    }

    /** @return array{id: string, version: int, title: string, content: ?string, content_hash: string} */
    private function present(object $row): array
    {
        return ['id' => (string) $row->id, 'version' => (int) $row->version, 'title' => (string) $row->title, 'content' => $this->content->read($row), 'content_hash' => (string) $row->content_hash];
    }
}
