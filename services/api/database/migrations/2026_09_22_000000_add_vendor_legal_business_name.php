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
        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->string('legal_business_name')->nullable();
        });
        Schema::table('vendor_documents', function (Blueprint $table): void {
            $table->timestampTz('superseded_at')->nullable();
        });
        DB::statement('UPDATE vendor_organizations SET legal_business_name = COALESCE(registered_name, legal_name)');
    }

    public function down(): void
    {
        Schema::table('vendor_documents', function (Blueprint $table): void {
            $table->dropColumn('superseded_at');
        });
        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->dropColumn('legal_business_name');
        });
    }
};
