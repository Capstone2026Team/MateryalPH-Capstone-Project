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
        Schema::create('remittance_reconciliation_decisions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('remittance_assessment_id')->unique()->constrained()->restrictOnDelete();
            $table->string('environment', 8);
            $table->string('method', 24);
            $table->string('previous_state', 32);
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('actor_role', 64);
            $table->string('source_version', 64);
            $table->string('request_key', 64)->nullable();
            $table->string('request_hash', 64)->nullable();
            $table->text('reason');
            $table->jsonb('evidence');
            $table->string('correlation_id', 64);
            $table->timestampTz('created_at');
            $table->unique(['actor_user_id', 'request_key']);
        });
        DB::statement("ALTER TABLE remittance_reconciliation_decisions ADD CONSTRAINT remittance_reconciliation_decision_check CHECK (
            environment = 'TEST' AND previous_state IN ('PENDING', 'RECONCILIATION_EXCEPTION') AND
            ((method = 'AUTOMATIC' AND actor_user_id IS NULL AND actor_role = 'SYSTEM' AND request_key IS NULL AND request_hash IS NULL)
            OR (method = 'BACKUP_APPROVAL' AND actor_user_id IS NOT NULL AND actor_role IN ('ADMIN_SUPERADMIN', 'ADMIN_FINANCE') AND request_key IS NOT NULL AND request_hash IS NOT NULL)))");
        DB::statement('CREATE TRIGGER remittance_reconciliation_decisions_append_only BEFORE UPDATE OR DELETE ON remittance_reconciliation_decisions FOR EACH ROW EXECUTE FUNCTION prevent_phase_eleven_history_mutation()');

        foreach (['ADMIN_SUPERADMIN' => 'Superadmin', 'ADMIN_FINANCE' => 'Finance Admin'] as $code => $name) {
            DB::table('platform_roles')->insertOrIgnore(['id' => (string) Str::uuid7(), 'code' => $code, 'platform' => 'ADMIN', 'name' => $name, 'system_role' => true, 'created_at' => now(), 'updated_at' => now()]);
            $role = DB::table('platform_roles')->where('code', $code)->value('id');
            foreach (['finance.view', 'finance.approve_remittance_reconciliation'] as $permission) {
                DB::table('permissions')->insertOrIgnore(['id' => (string) Str::uuid7(), 'code' => $permission, 'description' => $permission, 'created_at' => now(), 'updated_at' => now()]);
                DB::table('role_permissions')->insertOrIgnore(['id' => (string) Str::uuid7(), 'platform_role_id' => $role, 'permission_id' => DB::table('permissions')->where('code', $permission)->value('id'), 'created_at' => now(), 'updated_at' => now()]);
            }
        }
    }

    public function down(): void
    {
        // Approval decisions and the referenced role/permission identities are retained financial history.
    }
};
