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
        Schema::table('notifications', function (Blueprint $t): void {
            $t->string('event_key', 64)->nullable();
            $t->string('resume_key', 80)->nullable();
            $t->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $t->unique(['user_id', 'event_key']);
        });
        Schema::create('notification_devices', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignId('user_id')->constrained()->restrictOnDelete();
            $t->string('platform', 16);
            $t->string('environment', 32);
            $t->string('token_hash', 64)->unique();
            $t->text('sealed_token');
            $t->string('session_id', 64)->nullable();
            $t->timestampTz('revoked_at')->nullable();
            $t->timestampTz('last_seen_at');
            $t->timestampsTz();
            $t->index(['user_id', 'revoked_at']);
        });
        Schema::table('notification_deliveries', function (Blueprint $t): void {
            $t->foreignUuid('device_id')->nullable()->constrained('notification_devices')->restrictOnDelete();
            $t->string('destination_key', 64)->nullable();
            $t->string('template', 48)->default('ORDER_NOTICE');
            $t->text('sealed_recipient')->nullable();
            $t->string('failure_code', 48)->nullable();
            $t->timestampTz('available_at')->nullable();
            $t->unique(['notification_id', 'channel', 'destination_key'], 'notification_delivery_destination_unique');
            $t->index(['state', 'available_at']);
        });
        Schema::create('notification_delivery_attempts', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('notification_delivery_id')->constrained()->restrictOnDelete();
            $t->unsignedSmallInteger('attempt');
            $t->string('outcome', 32);
            $t->string('failure_code', 48)->nullable();
            $t->timestampTz('attempted_at');
            $t->unique(['notification_delivery_id', 'attempt']);
        });
        Schema::table('data_exports', function (Blueprint $t): void {
            $t->string('format', 8)->default('CSV');
            $t->string('resource_type', 32)->nullable();
            $t->uuid('resource_id')->nullable();
            $t->jsonb('source_snapshot')->nullable();
            $t->string('source_hash', 64)->nullable();
            $t->jsonb('source_versions')->nullable();
            $t->string('request_key', 64)->nullable();
            $t->string('failure_code', 48)->nullable();
            $t->unique(['requested_by_user_id', 'request_key']);
        });
        Schema::create('export_access_events', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('data_export_id')->constrained()->restrictOnDelete();
            $t->foreignId('user_id')->constrained()->restrictOnDelete();
            $t->string('action', 24);
            $t->string('checksum', 64)->nullable();
            $t->timestampTz('occurred_at');
        });
        Schema::table('tax_report_packages', function (Blueprint $t): void {
            // A return may contain several payees; a 2307 remains scoped to one named Vendor.
            $t->uuid('vendor_organization_id')->nullable()->change();
            $t->string('withholding_entity', 32)->nullable();
            $t->string('form_version', 80)->nullable();
            $t->string('filing_channel', 24)->default('NON_EFPS_DEMO');
            $t->date('nominal_due_date')->nullable();
            $t->date('actual_due_date')->nullable();
            $t->text('due_date_source')->nullable();
            $t->foreignId('due_date_reviewer_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->timestampTz('due_date_reviewed_at')->nullable();
            $t->jsonb('snapshot')->nullable();
            $t->unsignedInteger('lock_version')->default(1);
        });
        Schema::table('tax_report_package_lines', function (Blueprint $t): void {
            $t->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $t->jsonb('source_snapshot')->nullable();
            $t->string('source_hash', 64)->nullable();
        });
        Schema::table('remittance_assessments', function (Blueprint $t): void {
            $t->foreignUuid('tax_profile_version_id')->nullable()->constrained('vendor_tax_profile_versions')->restrictOnDelete();
            $t->string('reporting_atc', 8)->nullable();
            $t->string('atc_rule_version', 80)->nullable();
        });
        $calendarId = (string) Str::uuid7();
        $version = (int) DB::table('filing_calendar_versions')->where('environment', 'TEST')->max('version') + 1;
        DB::table('filing_calendar_versions')->insert(['id' => $calendarId, 'environment' => 'TEST', 'version' => $version, 'source_type' => 'FIN08_NON_EFPS_DEMO',
            'source_reference' => 'FIN-08; RR 11-2018; RMC 55-2026; current calendar review required', 'effective_from' => '2026-01-01 00:00:00+08', 'created_at' => now(), 'updated_at' => now()]);
        foreach (['2307' => 'QUARTER_END_PLUS_20', '0619-E' => 'FIRST_TWO_MONTHS_NEXT_MONTH_10', '1601-EQ' => 'QUARTER_NEXT_MONTH_END', 'QAP' => 'QUARTER_NEXT_MONTH_END', '1604-E' => 'NEXT_YEAR_MARCH_1', 'ANNUAL_ALPHALIST' => 'NEXT_YEAR_MARCH_1'] as $form => $rule) {
            DB::table('filing_deadlines')->insert(['id' => (string) Str::uuid7(), 'filing_calendar_version_id' => $calendarId, 'obligation_code' => $form,
                'taxpayer_class' => 'NON_EFPS_DEMO', 'periodicity' => $form === '0619-E' ? 'MONTHLY' : (in_array($form, ['1604-E', 'ANNUAL_ALPHALIST']) ? 'ANNUAL' : 'QUARTERLY'),
                'due_rule' => json_encode(['rule' => $rule, 'timezone' => 'Asia/Manila', 'review_required' => true]), 'created_at' => now(), 'updated_at' => now()]);
        }
        DB::statement("ALTER TABLE tax_report_packages ADD CONSTRAINT phase15_demo_package_state CHECK (state IN ('DRAFT','REVIEWED','EXPORTED','SIMULATED_SUBMISSION_RECORDED'))");
        DB::statement('ALTER TABLE tax_report_packages ADD CONSTRAINT phase15_independent_reviewer CHECK (reviewed_by_user_id IS NULL OR reviewed_by_user_id <> prepared_by_user_id)');
    }

    public function down(): void
    {
        // Operational/audit history must be retained. This additive migration is intentionally forward-only.
    }
};
