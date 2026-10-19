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
        Schema::create('support_tickets', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->string('ticket_number', 32)->unique();
            $t->foreignId('user_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->string('full_name', 160);
            $t->string('email', 254);
            $t->string('user_type', 10);
            $t->string('category', 32);
            $t->string('subject', 160);
            $t->string('reference_type', 20)->nullable();
            $t->string('reference', 120)->nullable();
            $t->string('status', 20)->default('OPEN');
            $t->foreignId('assigned_admin_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->unsignedInteger('lock_version')->default(1);
            $t->timestampTz('privacy_acknowledged_at');
            $t->timestampsTz();
            $t->index(['user_id', 'id']);
            $t->index(['status', 'category', 'created_at']);
            $t->index(['user_type', 'created_at']);
        });
        Schema::create('support_entries', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->uuid('ticket_id');
            $t->foreign('ticket_id')->references('id')->on('support_tickets')->restrictOnDelete();
            $t->string('kind', 24);
            $t->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->string('actor_name', 160);
            $t->string('actor_role', 64);
            $t->text('body');
            $t->jsonb('details')->default('{}');
            $t->uuid('correlation_id');
            $t->timestampTz('created_at');
            $t->index(['ticket_id', 'id']);
        });
        Schema::create('support_attachments', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->uuid('entry_id');
            $t->foreign('entry_id')->references('id')->on('support_entries')->restrictOnDelete();
            $t->uuid('file_id')->unique();
            $t->foreign('file_id')->references('id')->on('files')->restrictOnDelete();
            $t->timestampTz('created_at');
        });
        Schema::create('support_guest_credentials', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->uuid('ticket_id');
            $t->foreign('ticket_id')->references('id')->on('support_tickets')->restrictOnDelete();
            $t->string('token_hash', 64)->unique();
            $t->string('purpose', 10);
            $t->timestampTz('expires_at');
            $t->timestampTz('consumed_at')->nullable();
            $t->timestampTz('created_at');
        });
        Schema::create('support_commands', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->string('scope_hash', 64);
            $t->uuid('idempotency_key');
            $t->string('request_hash', 64);
            $t->jsonb('result')->nullable();
            $t->timestampTz('created_at');
            $t->unique(['scope_hash', 'idempotency_key']);
        });
        DB::statement("ALTER TABLE support_tickets ADD CONSTRAINT support_status_check CHECK (status IN ('OPEN','IN_PROGRESS','WAITING_FOR_USER','RESOLVED','CLOSED') AND lock_version > 0)");
        DB::statement("ALTER TABLE support_tickets ADD CONSTRAINT support_type_check CHECK (user_type IN ('BUYER','VENDOR','GUEST'))");
        DB::statement("ALTER TABLE support_tickets ADD CONSTRAINT support_category_check CHECK (category IN ('GENERAL_INQUIRY','TECHNICAL_ISSUE','ACCOUNT_CONCERN','VERIFICATION_ISSUE','PAYMENT_CONCERN','ORDER_CONCERN','COMPLAINT','FEEDBACK_SUGGESTION','OTHER'))");
        DB::statement("ALTER TABLE support_guest_credentials ADD CONSTRAINT support_credential_purpose_check CHECK (purpose IN ('LINK','SESSION'))");
        DB::statement("ALTER TABLE support_entries ADD CONSTRAINT support_entry_kind_check CHECK (kind IN ('MESSAGE','STATUS_CHANGED','ASSIGNED'))");
        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION prevent_support_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN RAISE EXCEPTION 'Support history is append-only.'; END; $$;
CREATE TRIGGER support_entries_append_only BEFORE UPDATE OR DELETE ON support_entries FOR EACH ROW EXECUTE FUNCTION prevent_support_history_mutation();
CREATE TRIGGER support_attachments_append_only BEFORE UPDATE OR DELETE ON support_attachments FOR EACH ROW EXECUTE FUNCTION prevent_support_history_mutation();
SQL);
        foreach (['support.view', 'support.manage'] as $code) {
            $id = (string) Str::uuid7();
            DB::table('permissions')->insert(['id' => $id, 'code' => $code, 'description' => 'View and handle private support requests', 'created_at' => now(), 'updated_at' => now()]);
            foreach (['ADMIN_SUPERADMIN', 'ADMIN_SUPPORT'] as $role) {
                $roleId = DB::table('platform_roles')->where('platform', 'ADMIN')->where('code', $role)->value('id');
                if ($roleId !== null) {
                    DB::table('role_permissions')->insert(['id' => (string) Str::uuid7(), 'platform_role_id' => $roleId, 'permission_id' => $id, 'created_at' => now(), 'updated_at' => now()]);
                }
            }
        }
    }

    public function down(): void
    {
        // Retain support conversations, attachments, grants and attribution history.
    }
};
