<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Vendor-typed search tags (approved by the project owner on 2026-10-17). A listing keeps up to three approved
 * tags from the platform list and may add any number of its own words; at least one tag of either kind is
 * needed. A custom tag belongs to its listing only and never enters Admin Taxonomy Management.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::create('listing_custom_tags', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_listing_id')->constrained()->restrictOnDelete();
            $table->string('label', 40);
            $table->string('normalized_label', 40);
            $table->timestampsTz();
            $table->unique(['vendor_listing_id', 'normalized_label']);
        });
        DB::statement('ALTER TABLE listing_custom_tags ADD CONSTRAINT listing_custom_tags_label_check CHECK (char_length(btrim(label)) >= 2 AND normalized_label = lower(normalized_label))');
    }

    public function down(): void
    {
        Schema::dropIfExists('listing_custom_tags');
    }
};
