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
        Schema::table('fee_statements', function (Blueprint $table): void {
            $table->jsonb('issued_invoice_snapshot')->nullable();
            $table->string('issued_invoice_hash', 64)->nullable();
        });
        DB::statement("CREATE UNIQUE INDEX platform_service_invoice_statement_unique ON invoice_records (fee_statement_id) WHERE invoice_type = 'PLATFORM_SERVICE_INVOICE' AND amends_invoice_record_id IS NULL");
        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION protect_issued_fee_invoice() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.issued_invoice_snapshot IS NOT NULL THEN
        IF TG_OP = 'DELETE' THEN RAISE EXCEPTION 'Issued platform invoice snapshots are retained'; END IF;
        IF NEW.issued_invoice_snapshot IS DISTINCT FROM OLD.issued_invoice_snapshot OR NEW.issued_invoice_hash IS DISTINCT FROM OLD.issued_invoice_hash THEN
            RAISE EXCEPTION 'Issued platform invoice snapshots are immutable';
        END IF;
    END IF;
    IF TG_OP = 'DELETE' THEN RETURN OLD; END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER issued_fee_invoice_immutable BEFORE UPDATE OR DELETE ON fee_statements FOR EACH ROW EXECUTE FUNCTION protect_issued_fee_invoice();
ALTER TABLE fee_statements ADD CONSTRAINT issued_fee_invoice_snapshot_check CHECK ((issued_invoice_snapshot IS NULL) = (issued_invoice_hash IS NULL));
SQL);
    }

    public function down(): void
    {
        if (DB::table('fee_statements')->whereNotNull('issued_invoice_snapshot')->exists()) {
            throw new RuntimeException('Issued platform invoice history must be retained.');
        }
        DB::unprepared('DROP TRIGGER issued_fee_invoice_immutable ON fee_statements; DROP FUNCTION protect_issued_fee_invoice(); ALTER TABLE fee_statements DROP CONSTRAINT issued_fee_invoice_snapshot_check; DROP INDEX platform_service_invoice_statement_unique;');
        Schema::table('fee_statements', fn (Blueprint $table) => $table->dropColumn(['issued_invoice_snapshot', 'issued_invoice_hash']));
    }
};
