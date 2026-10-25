<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * A Buyer may save a Tier 1 Directory Supplier as a Favorite Supplier. Directory rows are a bounded Google cache
 * (pruned within 30 days), so the Favorite keeps only the Google Place ID, which may be stored indefinitely;
 * name, address and rating are always read from the current cache or provider, never copied here.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('favorite_directory_suppliers', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $t->string('google_place_id', 255);
            $t->timestampsTz();
            $t->unique(['buyer_profile_id', 'google_place_id']);
            $t->index(['buyer_profile_id', 'created_at']);
        });
        DB::statement("ALTER TABLE favorite_directory_suppliers ADD CONSTRAINT favorite_directory_place_id_check CHECK (btrim(google_place_id) <> '')");
    }

    public function down(): void
    {
        Schema::dropIfExists('favorite_directory_suppliers');
    }
};
