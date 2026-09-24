<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('vendor_onboarding_requirements')->where('requirement_key', 'commission_terms')->where('is_current', true)->update(['section' => 'STORE_VERIFICATION']);
    }

    public function down(): void
    {
        DB::table('vendor_onboarding_requirements')->where('requirement_key', 'commission_terms')->where('is_current', true)->update(['section' => 'STORE_SETUP']);
    }
};
