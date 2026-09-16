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
            $table->string('individual_registered_surname')->nullable();
            $table->string('individual_registered_first_name')->nullable();
            $table->string('individual_registered_middle_name')->nullable();
            $table->string('individual_registered_suffix', 32)->nullable();
            $table->string('company_registered_name')->nullable();
            $table->boolean('legal_identity_same_as_owner')->default(false);
            $table->string('identity_id_type', 64)->nullable();
            $table->text('identity_id_number_encrypted')->nullable();
            $table->string('identity_id_number_last4', 4)->nullable();
        });

        Schema::table('vendor_tax_profile_versions', function (Blueprint $table): void {
            $table->text('tin_encrypted')->nullable();
            $table->string('tin_hash', 64)->nullable();
            $table->string('tin_branch_code', 16)->nullable();
            $table->string('bir_cor_reference', 180)->nullable();
            $table->string('vat_verified_category', 24)->nullable();
        });
    }

    public function down(): void
    {
        Schema::table('vendor_tax_profile_versions', function (Blueprint $table): void {
            $table->dropColumn(['tin_encrypted', 'tin_hash', 'tin_branch_code', 'bir_cor_reference', 'vat_verified_category']);
        });

        Schema::table('vendor_organizations', function (Blueprint $table): void {
            $table->dropColumn([
                'individual_registered_surname', 'individual_registered_first_name', 'individual_registered_middle_name',
                'individual_registered_suffix', 'company_registered_name', 'legal_identity_same_as_owner',
                'identity_id_type', 'identity_id_number_encrypted', 'identity_id_number_last4',
            ]);
        });
    }
};
