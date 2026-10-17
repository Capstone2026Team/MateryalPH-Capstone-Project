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
        Schema::table('vendor_memberships', function (Blueprint $table): void {
            $table->timestampTz('deleted_at')->nullable();
            $table->dropUnique(['user_id']);
        });
        DB::statement('CREATE UNIQUE INDEX vendor_current_membership_user_unique ON vendor_memberships (user_id) WHERE deleted_at IS NULL');
        DB::statement("ALTER TABLE vendor_memberships ADD CONSTRAINT vendor_deleted_membership_inactive CHECK (deleted_at IS NULL OR (status = 'DEACTIVATED' AND role <> 'OWNER' AND can_manage_staff = false))");
        Schema::table('vendor_invitations', function (Blueprint $table): void {
            $table->timestampTz('deleted_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->foreignUuid('accepted_membership_id')->nullable()->constrained('vendor_memberships')->restrictOnDelete();
        });
        // The acceptance audit links the original membership even after an employee changes email.
        DB::statement(<<<'SQL'
UPDATE vendor_invitations i SET accepted_membership_id = m.id
FROM audit_logs a JOIN vendor_memberships m ON m.id = a.resource_id
WHERE a.action = 'VENDOR_INVITATION_ACCEPTED' AND a.resource_type = 'VENDOR_MEMBERSHIP'
AND a."after"->>'invitation_id' = i.id::text AND i.accepted_at IS NOT NULL
AND i.vendor_organization_id = m.vendor_organization_id AND a.vendor_organization_id = i.vendor_organization_id
SQL);

    }

    public function down(): void
    {
        // Removed memberships and their immutable attribution must survive rollback requests.
        throw new LogicException('Vendor team deletion history is forward-only.');
    }
};
