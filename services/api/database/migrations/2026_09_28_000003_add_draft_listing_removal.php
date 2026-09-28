<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * A Vendor may delete a listing that was never published. The row is kept for audit and is
 * only hidden from the catalog; its Vendor SKU becomes reusable. Anything ever published keeps
 * its history and can only be deactivated.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('vendor_listings', function (Blueprint $table): void {
            $table->timestampTz('removed_at')->nullable();
            $table->foreignId('removed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });
        if (DB::getDriverName() !== 'pgsql') {
            return;
        }
        DB::unprepared(<<<'SQL'
ALTER TABLE vendor_listings DROP CONSTRAINT vendor_listings_vendor_organization_id_vendor_sku_unique;
CREATE UNIQUE INDEX vendor_listings_current_sku_unique ON vendor_listings (vendor_organization_id, vendor_sku) WHERE removed_at IS NULL;
ALTER TABLE vendor_listings ADD CONSTRAINT vendor_listing_removal_check CHECK (removed_at IS NULL OR (publication_version = 0 AND published_at IS NULL AND status <> 'ACTIVE' AND removed_by_user_id IS NOT NULL));
SQL);
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            // Restoring the organization-wide SKU uniqueness needs every removed draft's SKU to be unique again.
            DB::unprepared(<<<'SQL'
ALTER TABLE vendor_listings DROP CONSTRAINT IF EXISTS vendor_listing_removal_check;
DROP INDEX IF EXISTS vendor_listings_current_sku_unique;
ALTER TABLE vendor_listings ADD CONSTRAINT vendor_listings_vendor_organization_id_vendor_sku_unique UNIQUE (vendor_organization_id, vendor_sku);
SQL);
        }
        Schema::table('vendor_listings', function (Blueprint $table): void {
            $table->dropForeign(['removed_by_user_id']);
            $table->dropColumn(['removed_at', 'removed_by_user_id']);
        });
    }
};
