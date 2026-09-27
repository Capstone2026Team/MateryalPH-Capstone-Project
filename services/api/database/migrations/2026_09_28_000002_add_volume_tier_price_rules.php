<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

/**
 * CAT-PRICE-01: a variant has at most one current volume tier per minimum quantity, and a
 * tier always starts above a single unit. Price ordering against the ordinary price is a
 * cross-row rule enforced by the catalog domain.
 */
return new class extends Migration
{
    public function up(): void
    {
        if (DB::getDriverName() !== 'pgsql') {
            return;
        }
        DB::unprepared(<<<'SQL'
ALTER TABLE listing_price_versions ADD CONSTRAINT listing_price_tier_minimum_check CHECK (price_kind <> 'VOLUME_TIER' OR minimum_quantity > 1);
CREATE UNIQUE INDEX listing_one_current_volume_tier ON listing_price_versions (listing_variant_id, minimum_quantity) WHERE retired_at IS NULL AND price_kind = 'VOLUME_TIER';
SQL);
    }

    public function down(): void
    {
        if (DB::getDriverName() !== 'pgsql') {
            return;
        }
        DB::unprepared(<<<'SQL'
DROP INDEX IF EXISTS listing_one_current_volume_tier;
ALTER TABLE listing_price_versions DROP CONSTRAINT IF EXISTS listing_price_tier_minimum_check;
SQL);
    }
};
