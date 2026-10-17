<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::statement('ALTER TABLE bot_risk_challenges DROP CONSTRAINT bot_risk_portal_check');
            DB::statement("ALTER TABLE bot_risk_challenges ADD CONSTRAINT bot_risk_portal_check CHECK (portal IN ('BUYER', 'VENDOR', 'ADMIN'))");
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::statement('ALTER TABLE bot_risk_challenges DROP CONSTRAINT bot_risk_portal_check');
            DB::statement("ALTER TABLE bot_risk_challenges ADD CONSTRAINT bot_risk_portal_check CHECK (portal IN ('BUYER', 'VENDOR'))");
        }
    }
};
