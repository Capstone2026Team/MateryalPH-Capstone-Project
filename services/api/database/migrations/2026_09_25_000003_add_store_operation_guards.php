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
        DB::statement('ALTER TABLE operating_hours ADD CONSTRAINT operating_hours_day_check CHECK (day_of_week BETWEEN 1 AND 7) NOT VALID');
        DB::statement('ALTER TABLE operating_hours ADD CONSTRAINT operating_hours_period_check CHECK ((is_closed AND opens_at IS NULL AND closes_at IS NULL) OR (NOT is_closed AND opens_at IS NOT NULL AND closes_at IS NOT NULL AND closes_at > opens_at)) NOT VALID');

        Schema::create('store_operation_date_overrides', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('store_profile_id')->constrained()->restrictOnDelete();
            $table->date('specific_date');
            $table->boolean('is_closed');
            $table->time('opens_at')->nullable();
            $table->time('closes_at')->nullable();
            $table->foreignId('created_by_user_id')->constrained('users')->restrictOnDelete();
            $table->foreignId('updated_by_user_id')->constrained('users')->restrictOnDelete();
            $table->timestampsTz();
            $table->unique(['store_profile_id', 'specific_date']);
        });
        DB::statement('ALTER TABLE store_operation_date_overrides ADD CONSTRAINT store_operation_override_period_check CHECK ((is_closed AND opens_at IS NULL AND closes_at IS NULL) OR (NOT is_closed AND opens_at IS NOT NULL AND closes_at IS NOT NULL AND closes_at > opens_at))');
    }

    public function down(): void
    {
        Schema::dropIfExists('store_operation_date_overrides');
        DB::statement('ALTER TABLE operating_hours DROP CONSTRAINT IF EXISTS operating_hours_period_check');
        DB::statement('ALTER TABLE operating_hours DROP CONSTRAINT IF EXISTS operating_hours_day_check');
    }
};
