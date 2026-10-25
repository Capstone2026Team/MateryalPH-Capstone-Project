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
        Schema::table('directory_suppliers', function (Blueprint $table): void {
            $table->decimal('google_rating', 2, 1)->nullable();
            $table->integer('google_rating_count')->nullable();
        });
        DB::statement('ALTER TABLE directory_suppliers ADD CONSTRAINT directory_google_rating_range CHECK (google_rating IS NULL OR google_rating BETWEEN 1.0 AND 5.0), ADD CONSTRAINT directory_google_rating_count_range CHECK (google_rating_count IS NULL OR google_rating_count >= 0)');
    }

    public function down(): void
    {
        DB::statement('ALTER TABLE directory_suppliers DROP CONSTRAINT directory_google_rating_range, DROP CONSTRAINT directory_google_rating_count_range');
        Schema::table('directory_suppliers', fn (Blueprint $table) => $table->dropColumn(['google_rating', 'google_rating_count']));
    }
};
