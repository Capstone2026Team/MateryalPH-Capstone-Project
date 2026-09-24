<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('vendor_pending_documents', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->constrained('vendor_organizations')->restrictOnDelete();
            $table->string('requirement_key', 64);
            $table->foreignUuid('file_id')->constrained('files')->restrictOnDelete();
            $table->jsonb('metadata')->nullable();
            $table->timestampsTz();
            $table->unique(['vendor_organization_id', 'requirement_key']);
        });
        Schema::table('vendor_documents', function (Blueprint $table): void {
            $table->boolean('review_submitted')->default(true);
        });
        // Earlier uploads created immutable versions before submission. Keep their
        // historical rows, but recover the current unsubmitted file as a draft.
        $legacy = DB::table('vendor_documents as d')
            ->join('vendor_document_versions as v', 'v.id', '=', 'd.current_version_id')
            ->join('vendor_onboarding_steps as s', 's.id', '=', 'd.onboarding_step_id')
            ->where('d.status', 'IN_PROGRESS')->whereNull('s.submitted_at')
            ->whereNull('d.superseded_at')
            ->whereNotExists(fn ($query) => $query->selectRaw('1')->from('business_document_reviews as r')->join('vendor_document_versions as rv', 'rv.id', '=', 'r.business_document_version_id')->whereColumn('rv.business_document_id', 'd.id'))
            ->get(['d.id', 'd.vendor_organization_id', 'd.requirement_key', 'v.file_id', 'v.vendor_metadata']);
        foreach ($legacy as $document) {
            DB::table('vendor_pending_documents')->insert(['id' => (string) Str::uuid7(), 'vendor_organization_id' => $document->vendor_organization_id, 'requirement_key' => $document->requirement_key, 'file_id' => $document->file_id, 'metadata' => $document->vendor_metadata, 'created_at' => now(), 'updated_at' => now()]);
            DB::table('vendor_documents')->where('id', $document->id)->update(['review_submitted' => false, 'superseded_at' => now()]);
        }

    }

    public function down(): void
    {
        Schema::dropIfExists('vendor_pending_documents');
        Schema::table('vendor_documents', fn (Blueprint $table) => $table->dropColumn('review_submitted'));
    }
};
