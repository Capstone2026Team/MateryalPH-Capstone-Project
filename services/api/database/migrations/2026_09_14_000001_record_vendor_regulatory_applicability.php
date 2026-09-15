<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    public function up(): void
    {
        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->boolean('regulatory_evidence_required')->nullable();
            $table->text('regulatory_review_basis')->nullable();
        });
    }

    public function down(): void
    {
        Schema::table('vendor_organizations', fn (Blueprint $table) => $table->dropColumn(['regulatory_evidence_required', 'regulatory_review_basis']));
    }
};
