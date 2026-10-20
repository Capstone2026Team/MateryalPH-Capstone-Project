<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::create('imported_encrypted_values', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->char('source_ciphertext_sha256', 64)->unique();
            $table->text('staging_ciphertext');
            $table->string('source_table', 64);
            $table->string('source_column', 64);
            $table->uuid('source_record_id');
            $table->char('staging_identity_hash', 64)->nullable();
            $table->char('canonical_identity_hash', 64)->nullable();
            $table->index(['source_table', 'source_column', 'staging_identity_hash'], 'imported_identity_lookup');
            $table->uuid('import_batch_id')->index();
            $table->timestampTz('created_at');
        });
        DB::statement("ALTER TABLE imported_encrypted_values ADD CONSTRAINT imported_ciphertext_fingerprint_check CHECK (source_ciphertext_sha256 ~ '^[a-f0-9]{64}$')");
        DB::statement("ALTER TABLE imported_encrypted_values ADD CONSTRAINT imported_identity_hashes_check CHECK ((staging_identity_hash IS NULL AND canonical_identity_hash IS NULL) OR (staging_identity_hash IS NOT NULL AND canonical_identity_hash IS NOT NULL AND staging_identity_hash ~ '^[a-f0-9]{64}$' AND canonical_identity_hash ~ '^[a-f0-9]{64}$'))");
        DB::unprepared(<<<'SQL'
            CREATE OR REPLACE FUNCTION protect_imported_encrypted_values() RETURNS trigger LANGUAGE plpgsql AS $$
            BEGIN
                RAISE EXCEPTION 'Imported encryption recovery records are immutable';
            END;
            $$;
            CREATE TRIGGER imported_encrypted_values_immutable BEFORE UPDATE OR DELETE ON imported_encrypted_values
                FOR EACH ROW EXECUTE FUNCTION protect_imported_encrypted_values();
            SQL);
    }

    public function down(): void
    {
        Schema::dropIfExists('imported_encrypted_values');
        DB::statement('DROP FUNCTION IF EXISTS protect_imported_encrypted_values()');
    }
};
