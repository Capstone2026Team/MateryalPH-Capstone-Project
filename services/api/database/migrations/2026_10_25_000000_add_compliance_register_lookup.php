<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * PS/ICC register lookup (rule compliance.register-number.v2, approved by the
 * project owner on 2026-10-17): ICC sticker serial ranges and the remaining
 * official columns on register records, register snapshots synced from an
 * authorized feed, and the Vendor's explicit manual-review request.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('compliance_reference_records', function (Blueprint $table): void {
            // ICC sticker serials are issued in ranges, e.g. B012717015 – B012717192.
            $table->string('serial_prefix', 4)->nullable();
            $table->unsignedBigInteger('serial_from')->nullable();
            $table->unsignedBigInteger('serial_to')->nullable();
            $table->unsignedSmallInteger('serial_digits')->nullable();
            $table->text('model_type')->nullable();
            $table->jsonb('details')->nullable();
        });
        DB::statement("ALTER TABLE compliance_reference_records ADD CONSTRAINT compliance_reference_serial_range_check CHECK ((serial_prefix IS NULL AND serial_from IS NULL AND serial_to IS NULL AND serial_digits IS NULL) OR (serial_prefix ~ '^[A-Z]{1,2}$' AND serial_from IS NOT NULL AND serial_to IS NOT NULL AND serial_from <= serial_to AND serial_digits BETWEEN 6 AND 12))");
        DB::statement('CREATE INDEX compliance_reference_serial_lookup_index ON compliance_reference_records (compliance_reference_register_id, serial_prefix, serial_from, serial_to) WHERE serial_prefix IS NOT NULL');

        Schema::table('compliance_reference_registers', function (Blueprint $table): void {
            $table->string('source_channel', 16)->default('UPLOAD');
        });
        DB::statement('ALTER TABLE compliance_reference_registers ALTER COLUMN imported_by_user_id DROP NOT NULL');
        DB::statement("ALTER TABLE compliance_reference_registers ADD CONSTRAINT compliance_register_channel_check CHECK (source_channel IN ('UPLOAD','FEED') AND (source_channel = 'FEED' OR imported_by_user_id IS NOT NULL))");

        Schema::table('compliance_submissions', function (Blueprint $table): void {
            $table->string('review_mode', 16)->default('AUTOMATIC');
            $table->foreignUuid('compliance_reference_record_id')->nullable()->constrained('compliance_reference_records')->restrictOnDelete();
        });
        DB::statement("ALTER TABLE compliance_submissions ADD CONSTRAINT compliance_submission_review_mode_check CHECK (review_mode IN ('AUTOMATIC','MANUAL_REVIEW'))");
    }

    public function down(): void
    {
        DB::statement('ALTER TABLE compliance_submissions DROP CONSTRAINT IF EXISTS compliance_submission_review_mode_check');
        Schema::table('compliance_submissions', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('compliance_reference_record_id');
            $table->dropColumn('review_mode');
        });
        DB::statement('ALTER TABLE compliance_reference_registers DROP CONSTRAINT IF EXISTS compliance_register_channel_check');
        Schema::table('compliance_reference_registers', function (Blueprint $table): void {
            $table->dropColumn('source_channel');
        });
        DB::statement('DROP INDEX IF EXISTS compliance_reference_serial_lookup_index');
        DB::statement('ALTER TABLE compliance_reference_records DROP CONSTRAINT IF EXISTS compliance_reference_serial_range_check');
        Schema::table('compliance_reference_records', function (Blueprint $table): void {
            $table->dropColumn(['serial_prefix', 'serial_from', 'serial_to', 'serial_digits', 'model_type', 'details']);
        });
    }
};
