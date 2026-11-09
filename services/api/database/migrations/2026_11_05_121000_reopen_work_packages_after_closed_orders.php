<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        // Repair previous selections without changing closed order or quotation history.
        DB::statement(<<<'SQL'
UPDATE work_packages w SET status = 'ACTIVE', selected_vendor_organization_id = NULL,
 lock_version = lock_version + 1, updated_at = NOW()
WHERE selected_arrangement_id IS NULL AND status NOT IN ('DRAFT','CANCELLED')
 AND EXISTS (SELECT 1 FROM orders o WHERE o.work_package_id = w.id AND o.work_package_version_id = w.current_version_id
  AND o.procurement_type = 'PROJECT_BASED' AND o.order_state IN ('CANCELLED','DECLINED','EXPIRED'))
 AND NOT EXISTS (SELECT 1 FROM orders o WHERE o.work_package_id = w.id AND o.work_package_version_id = w.current_version_id
  AND o.procurement_type = 'PROJECT_BASED' AND o.order_state NOT IN ('CANCELLED','DECLINED','EXPIRED'))
SQL);
    }

    public function down(): void
    {
        // Reopening is a forward-only data repair; never restore a lock from cancelled commercial history.
    }
};
