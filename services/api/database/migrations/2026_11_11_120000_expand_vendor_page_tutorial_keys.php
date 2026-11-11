<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::statement('ALTER TABLE user_tutorials DROP CONSTRAINT user_tutorial_key_check');
        DB::statement("ALTER TABLE user_tutorials ADD CONSTRAINT user_tutorial_key_check CHECK (tutorial_key IN ('overview', 'discovery', 'procurement', 'projects', 'messages', 'orders', 'store', 'products', 'inventory', 'dashboard', 'fulfillment', 'invoices', 'disputes', 'reviews', 'vehicles', 'finance', 'commissions', 'transactions', 'remittance', 'performance', 'analytics', 'team', 'tracking', 'settings', 'notifications', 'support'))");
    }

    public function down(): void
    {
        DB::statement('ALTER TABLE user_tutorials DROP CONSTRAINT user_tutorial_key_check');
        // Preserve page acknowledgments on rollback; the old constraint still governs new writes.
        DB::statement("ALTER TABLE user_tutorials ADD CONSTRAINT user_tutorial_key_check CHECK (tutorial_key IN ('overview', 'discovery', 'procurement', 'projects', 'messages', 'orders', 'store', 'products', 'inventory')) NOT VALID");
    }
};
