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
        Schema::table('auth_sessions', function (Blueprint $table): void {
            $table->timestampTz('reauthenticated_at')->nullable();
            $table->string('reauthentication_method', 16)->nullable();
        });
        foreach (['admin_invitations', 'vendor_invitations'] as $name) {
            Schema::table($name, function (Blueprint $table): void {
                $table->timestampTz('revoked_at')->nullable();
            });
        }
        Schema::table('agreement_versions', function (Blueprint $table): void {
            $table->boolean('requires_reacceptance')->default(false);
        });
        Schema::create('account_email_changes', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('auth_session_id')->constrained()->restrictOnDelete();
            $table->string('normalized_email');
            $table->foreignUuid('email_otp_id')->constrained()->restrictOnDelete();
            $table->timestampTz('expires_at');
            $table->timestampTz('completed_at')->nullable();
            $table->timestampTz('invalidated_at')->nullable();
            $table->timestampsTz();
            $table->index(['user_id', 'completed_at']);
        });
        Schema::create('account_factor_replacements', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('auth_session_id')->constrained()->restrictOnDelete();
            $table->text('encrypted_secret');
            $table->timestampTz('expires_at');
            $table->timestampTz('completed_at')->nullable();
            $table->timestampsTz();
        });
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION prevent_phase_two_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Immutable history cannot be updated or deleted';
END;
$$;
CREATE TRIGGER audit_logs_immutable BEFORE UPDATE OR DELETE ON audit_logs FOR EACH ROW EXECUTE FUNCTION prevent_phase_two_history_mutation();
CREATE TRIGGER agreement_acceptances_immutable BEFORE UPDATE OR DELETE ON agreement_acceptances FOR EACH ROW EXECUTE FUNCTION prevent_phase_two_history_mutation();
SQL);
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared('DROP TRIGGER IF EXISTS audit_logs_immutable ON audit_logs; DROP TRIGGER IF EXISTS agreement_acceptances_immutable ON agreement_acceptances; DROP FUNCTION IF EXISTS prevent_phase_two_history_mutation();');
        }
        Schema::dropIfExists('account_factor_replacements');
        Schema::dropIfExists('account_email_changes');
        Schema::table('agreement_versions', fn (Blueprint $table) => $table->dropColumn('requires_reacceptance'));
        foreach (['admin_invitations', 'vendor_invitations'] as $name) {
            Schema::table($name, fn (Blueprint $table) => $table->dropColumn('revoked_at'));
        }
        Schema::table('auth_sessions', fn (Blueprint $table) => $table->dropColumn(['reauthenticated_at', 'reauthentication_method']));
    }
};
