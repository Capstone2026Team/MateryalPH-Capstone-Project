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
        // Removal from the Buyer's history never changes a locked commercial original.
        Schema::create('work_package_version_deletions', function (Blueprint $table): void {
            $table->foreignUuid('work_package_version_id')->primary()->constrained()->restrictOnDelete();
            $table->foreignId('deleted_by_user_id')->constrained('users')->restrictOnDelete();
            $table->timestampTz('deleted_at');
        });
        DB::unprepared('CREATE TRIGGER work_package_version_deletion_immutable BEFORE UPDATE OR DELETE ON work_package_version_deletions FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation()');
    }

    public function down(): void
    {
        if (DB::table('work_package_version_deletions')->exists()) {
            throw new LogicException('Version deletion history is retained. Use a reviewed forward migration.');
        }
        Schema::dropIfExists('work_package_version_deletions');
    }
};
