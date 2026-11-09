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
        Schema::create('order_document_renditions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_document_id')->constrained()->restrictOnDelete();
            $table->unsignedSmallInteger('layout_version');
            $table->foreignUuid('file_id')->unique()->constrained()->restrictOnDelete();
            $table->timestampTz('generated_at');
            $table->unique(['order_document_id', 'layout_version']);
        });
        DB::statement('ALTER TABLE order_document_renditions ADD CONSTRAINT order_document_layout_version_check CHECK (layout_version > 0)');
        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION protect_order_document_rendition() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Issued order document renditions are immutable';
END;
$$;
CREATE TRIGGER order_document_rendition_immutable BEFORE UPDATE OR DELETE ON order_document_renditions
FOR EACH ROW EXECUTE FUNCTION protect_order_document_rendition();
SQL);
    }

    public function down(): void
    {
        // Forward-only: retain every issued layout and the original commercial record.
    }
};
