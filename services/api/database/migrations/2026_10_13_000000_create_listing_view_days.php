<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Product views for Vendor Product Analytics (approved by the project owner on 2026-10-10).
 *
 * One row means one signed-in Buyer opened one listing's Product Details on one Asia/Manila calendar day; repeat opens
 * that day change nothing. The row holds no location, device, IP or session data, and Vendors only ever read counts,
 * never the Buyer key. A view is behavioural analytics, not commercial history, so a Buyer profile erasure removes its
 * rows; listings are never hard-deleted once Buyers can see them (drafts are soft-removed), so listing references
 * restrict deletion.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('listing_view_days', function (Blueprint $t): void {
            $t->foreignUuid('vendor_listing_id')->constrained()->restrictOnDelete();
            $t->date('view_date');
            $t->foreignUuid('buyer_profile_id')->constrained()->cascadeOnDelete();
            $t->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $t->timestampTz('first_viewed_at');
            $t->primary(['vendor_listing_id', 'view_date', 'buyer_profile_id']);
            $t->index(['vendor_organization_id', 'view_date']);
            $t->index('buyer_profile_id');
        });
        if (DB::getDriverName() === 'pgsql') {
            DB::statement("COMMENT ON TABLE listing_view_days IS 'One row per Buyer, listing and Asia/Manila day that Product Details was opened. Counts only reach Vendors.'");
        }
    }

    public function down(): void
    {
        Schema::dropIfExists('listing_view_days');
    }
};
