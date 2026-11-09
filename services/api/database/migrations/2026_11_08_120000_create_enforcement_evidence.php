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
        Schema::create('enforcement_evidence', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('enforcement_action_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('file_id')->unique()->constrained()->restrictOnDelete();
            $table->foreignId('recorded_by_user_id')->constrained('users')->restrictOnDelete();
            $table->timestampTz('created_at');
            $table->index(['enforcement_action_id', 'created_at']);
        });
        DB::unprepared(<<<'SQL'
            CREATE OR REPLACE FUNCTION protect_enforcement_evidence() RETURNS trigger LANGUAGE plpgsql AS $$
            BEGIN
                RAISE EXCEPTION 'Enforcement evidence is immutable';
            END;
            $$;
            CREATE TRIGGER enforcement_evidence_immutable BEFORE UPDATE OR DELETE ON enforcement_evidence
                FOR EACH ROW EXECUTE FUNCTION protect_enforcement_evidence();
            SQL);
    }

    public function down(): void
    {
        Schema::dropIfExists('enforcement_evidence');
        DB::statement('DROP FUNCTION IF EXISTS protect_enforcement_evidence()');
    }
};
