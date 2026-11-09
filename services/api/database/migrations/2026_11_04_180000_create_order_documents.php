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
        Schema::create('order_documents', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->string('kind', 32);
            $table->string('state', 16)->default('QUEUED');
            $table->jsonb('source_snapshot');
            $table->string('source_hash', 64);
            $table->foreignUuid('file_id')->nullable()->constrained()->restrictOnDelete();
            $table->timestampTz('generated_at')->nullable();
            $table->timestampsTz();
            $table->unique(['order_id', 'kind']);
            $table->index(['state', 'created_at']);
        });
        DB::statement("ALTER TABLE order_documents ADD CONSTRAINT order_document_state_check CHECK (kind IN ('PURCHASE_ORDER','PAYMENT_CONFIRMATION') AND state IN ('QUEUED','READY','FAILED') AND (state <> 'READY' OR (file_id IS NOT NULL AND generated_at IS NOT NULL)))");
        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION protect_order_document() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Order document history is immutable';
    END IF;
    IF ROW(NEW.id, NEW.order_id, NEW.kind, NEW.source_snapshot, NEW.source_hash, NEW.created_at)
       IS DISTINCT FROM ROW(OLD.id, OLD.order_id, OLD.kind, OLD.source_snapshot, OLD.source_hash, OLD.created_at)
       OR (OLD.state = 'READY' AND ROW(NEW.state, NEW.file_id, NEW.generated_at) IS DISTINCT FROM ROW(OLD.state, OLD.file_id, OLD.generated_at)) THEN
        RAISE EXCEPTION 'Order document sources and issued files are immutable';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER order_document_immutable BEFORE UPDATE OR DELETE ON order_documents
FOR EACH ROW EXECUTE FUNCTION protect_order_document();
SQL);
    }

    public function down(): void
    {
        // Forward-only: issued order documents and their sources remain part of commercial history.
    }
};
