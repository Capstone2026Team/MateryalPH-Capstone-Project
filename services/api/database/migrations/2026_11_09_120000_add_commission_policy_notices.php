<?php

declare(strict_types=1);

use App\Domain\Finance\CommissionTermsTemplate;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('fee_policy_versions', function (Blueprint $table): void {
            $table->foreignUuid('legacy_agreement_version_id')->nullable()->constrained('agreement_versions')->restrictOnDelete();
            $table->text('vendor_message')->nullable();
            $table->text('notice_override_reason')->nullable();
            $table->unsignedInteger('notice_hours')->nullable();
        });
        Schema::create('commission_policy_revisions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('policy_id')->unique()->constrained('fee_policy_versions')->restrictOnDelete();
            $table->foreignUuid('replacement_policy_id')->constrained('fee_policy_versions')->restrictOnDelete();
            $table->string('kind', 16);
            $table->foreignId('created_by_user_id')->constrained('users')->restrictOnDelete();
            $table->text('reason');
            $table->timestampTz('created_at');
        });
        DB::unprepared('CREATE TRIGGER commission_revisions_append_only BEFORE UPDATE OR DELETE ON commission_policy_revisions FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();');
        Schema::create('commission_email_events', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->string('event_key', 160)->unique();
            $table->string('subject_type', 24);
            $table->uuid('subject_id');
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('notification_id')->nullable()->unique()->constrained()->restrictOnDelete();
            $table->string('notification_type', 40);
            $table->unsignedInteger('old_basis_points')->nullable();
            $table->timestampTz('created_at');
            $table->index(['subject_type', 'subject_id']);
        });
        Schema::table('notification_deliveries', function (Blueprint $table): void {
            // Resends retain monotonically numbered immutable attempts.
            $table->unsignedInteger('retry_after_attempt')->default(0);
        });
        app(CommissionTermsTemplate::class)->backfill();
    }

    public function down(): void
    {
        if (DB::table('commission_email_events')->exists() || DB::table('commission_policy_revisions')->exists()) {
            throw new RuntimeException('Commission notice and revision history must be retained.');
        }
        Schema::dropIfExists('commission_email_events');
        Schema::dropIfExists('commission_policy_revisions');
        Schema::table('notification_deliveries', fn (Blueprint $table) => $table->dropColumn('retry_after_attempt'));
        Schema::table('fee_policy_versions', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('legacy_agreement_version_id');
            $table->dropColumn(['vendor_message', 'notice_override_reason', 'notice_hours']);
        });
    }
};
