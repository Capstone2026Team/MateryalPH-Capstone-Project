<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        // Fresh databases receive v2 from the foundation seeder. Existing acceptances retain v1.
        $document = DB::table('agreement_documents')->where('code', 'NRPC_TERMS')->value('id');
        if ($document === null) {
            return;
        }
        $content = file_get_contents(resource_path('agreements/NRPC_TERMS/2.md'));
        if ($content === false) {
            throw new RuntimeException('NRPC Terms v2 content is unavailable.');
        }
        $existing = DB::table('agreement_versions')->where('agreement_document_id', $document)->where('version', 2)->first();
        if ($existing !== null && ! hash_equals((string) $existing->content_hash, hash('sha256', $content))) {
            throw new RuntimeException('Refusing to overwrite NRPC Terms v2.');
        }
        if ($existing === null) {
            DB::table('agreement_versions')->insert([
                'id' => (string) Str::uuid7(), 'agreement_document_id' => $document, 'version' => 2,
                'content_hash' => hash('sha256', $content), 'content_uri' => '/legal/nrpc-terms',
                'effective_at' => now(), 'retired_at' => null, 'requires_reacceptance' => false,
                'created_at' => now(), 'updated_at' => now(),
            ]);
        }
        DB::table('agreement_versions')->where('agreement_document_id', $document)->where('version', '<', 2)
            ->whereNull('retired_at')->update(['retired_at' => now(), 'updated_at' => now()]);
    }

    public function down(): void
    {
        // Published terms and their acceptances are immutable; corrections publish another version.
    }
};
