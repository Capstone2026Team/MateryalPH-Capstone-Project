<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/**
 * Phase 7: Item-Based search, SRS preferences, cart and checkout preview. Extends the Phase 1 carts,
 * cart_items, buyer_ranking_preferences and platform_settings tables instead of duplicating them. A cart
 * never reserves stock: it records the listing/price version the Buyer saw so later changes are detected,
 * the intended destination and any heavy-vehicle alternate drop-off (both preserved, never overwritten),
 * and one fulfillment choice per Vendor group.
 */
return new class extends Migration
{
    public function up(): void
    {
        if (! DB::table('platform_settings')->where('key', 'ranking.srs.default_weights')->exists()) {
            DB::table('platform_settings')->insert([
                'id' => (string) Str::uuid7(), 'key' => 'ranking.srs.default_weights',
                'value' => json_encode(['distance' => 30, 'price' => 25, 'vps' => 20, 'stock' => 15, 'product_rating' => 10], JSON_THROW_ON_ERROR),
                'version' => 1, 'created_at' => now(), 'updated_at' => now(),
            ]);
        }

        Schema::table('buyer_ranking_preferences', function (Blueprint $table): void {
            $table->foreignId('updated_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });

        Schema::table('carts', function (Blueprint $table): void {
            $table->foreignUuid('intended_location_id')->nullable()->constrained('buyer_locations')->restrictOnDelete();
            $table->string('heavy_vehicle_restriction', 12)->default('UNANSWERED');
            $table->foreignUuid('alternate_drop_off_location_id')->nullable()->constrained('buyer_locations')->restrictOnDelete();
            $table->text('access_instructions_encrypted')->nullable();
        });

        Schema::table('cart_items', function (Blueprint $table): void {
            $table->unsignedInteger('listing_publication_version')->nullable();
            $table->bigInteger('unit_price_centavos')->nullable();
            $table->string('tax_category', 16)->nullable();
            $table->string('stock_label', 16)->nullable();
            $table->timestampTz('saved_for_later_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });

        Schema::create('cart_vendor_groups', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('cart_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('fulfillment_method', 12)->nullable();
            $table->timestampsTz();
            $table->unique(['cart_id', 'vendor_organization_id']);
        });

        if (DB::getDriverName() !== 'pgsql') {
            return;
        }
        foreach ([
            "ALTER TABLE buyer_ranking_preferences ADD CONSTRAINT buyer_ranking_procurement_type_check CHECK (procurement_type IN ('ITEM_BASED','PROJECT_BASED'))",
            // Item-Based SRS weights: exactly the five components, whole percentages 0–100, total 100 (never all zero).
            "ALTER TABLE buyer_ranking_preferences ADD CONSTRAINT buyer_ranking_item_weights_check CHECK (procurement_type <> 'ITEM_BASED' OR (
                jsonb_typeof(weights) = 'object'
                AND jsonb_exists_all(weights, array['distance','price','vps','stock','product_rating'])
                AND (weights - array['distance','price','vps','stock','product_rating']) = '{}'::jsonb
                AND (weights->>'distance') ~ '^[0-9]{1,3}$' AND (weights->>'price') ~ '^[0-9]{1,3}$' AND (weights->>'vps') ~ '^[0-9]{1,3}$'
                AND (weights->>'stock') ~ '^[0-9]{1,3}$' AND (weights->>'product_rating') ~ '^[0-9]{1,3}$'
                AND (weights->>'distance')::int + (weights->>'price')::int + (weights->>'vps')::int + (weights->>'stock')::int + (weights->>'product_rating')::int = 100))",
            "ALTER TABLE carts ADD CONSTRAINT cart_state_check CHECK (state IN ('ACTIVE','CHECKED_OUT','ABANDONED'))",
            "ALTER TABLE carts ADD CONSTRAINT cart_heavy_restriction_check CHECK (heavy_vehicle_restriction IN ('UNANSWERED','NO','YES'))",
            // Yes requires a distinct alternate drop-off; otherwise none is stored. The intended location stays separate.
            "ALTER TABLE carts ADD CONSTRAINT cart_alternate_drop_off_check CHECK ((heavy_vehicle_restriction = 'YES' AND alternate_drop_off_location_id IS NOT NULL AND intended_location_id IS NOT NULL AND alternate_drop_off_location_id <> intended_location_id) OR (heavy_vehicle_restriction <> 'YES' AND alternate_drop_off_location_id IS NULL))",
            "CREATE UNIQUE INDEX IF NOT EXISTS carts_one_active_per_buyer ON carts (buyer_profile_id) WHERE state = 'ACTIVE'",
            'ALTER TABLE cart_items ADD CONSTRAINT cart_item_quantity_check CHECK (quantity > 0 AND quantity <= 1000000)',
            "ALTER TABLE cart_items ADD CONSTRAINT cart_item_stock_label_check CHECK (stock_label IS NULL OR stock_label IN ('IN_STOCK','LIMITED_STOCK','OUT_OF_STOCK'))",
            'ALTER TABLE cart_items ADD CONSTRAINT cart_item_unit_price_check CHECK (unit_price_centavos IS NULL OR unit_price_centavos > 0)',
            'ALTER TABLE cart_items ADD CONSTRAINT cart_items_price_version_fk FOREIGN KEY (listing_price_version_id) REFERENCES listing_price_versions (id) ON DELETE RESTRICT NOT VALID',
            "ALTER TABLE cart_vendor_groups ADD CONSTRAINT cart_vendor_group_fulfillment_check CHECK (fulfillment_method IS NULL OR fulfillment_method IN ('DELIVERY','PICKUP'))",
            'CREATE INDEX IF NOT EXISTS vendor_listings_display_name_trgm ON vendor_listings USING gin (lower(display_name) gin_trgm_ops)',
            'CREATE INDEX IF NOT EXISTS products_brand_trgm ON products USING gin (lower(brand) gin_trgm_ops)',
        ] as $statement) {
            DB::statement($statement);
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            foreach ([
                'DROP INDEX IF EXISTS products_brand_trgm',
                'DROP INDEX IF EXISTS vendor_listings_display_name_trgm',
                'ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_items_price_version_fk',
                'ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_item_unit_price_check',
                'ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_item_stock_label_check',
                'ALTER TABLE cart_items DROP CONSTRAINT IF EXISTS cart_item_quantity_check',
                'DROP INDEX IF EXISTS carts_one_active_per_buyer',
                'ALTER TABLE carts DROP CONSTRAINT IF EXISTS cart_alternate_drop_off_check',
                'ALTER TABLE carts DROP CONSTRAINT IF EXISTS cart_heavy_restriction_check',
                'ALTER TABLE carts DROP CONSTRAINT IF EXISTS cart_state_check',
                'ALTER TABLE buyer_ranking_preferences DROP CONSTRAINT IF EXISTS buyer_ranking_item_weights_check',
                'ALTER TABLE buyer_ranking_preferences DROP CONSTRAINT IF EXISTS buyer_ranking_procurement_type_check',
            ] as $statement) {
                DB::statement($statement);
            }
        }
        Schema::dropIfExists('cart_vendor_groups');
        Schema::table('cart_items', function (Blueprint $table): void {
            $table->dropColumn(['listing_publication_version', 'unit_price_centavos', 'tax_category', 'stock_label', 'saved_for_later_at', 'lock_version']);
        });
        Schema::table('carts', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('alternate_drop_off_location_id');
            $table->dropConstrainedForeignId('intended_location_id');
            $table->dropColumn(['heavy_vehicle_restriction', 'access_instructions_encrypted']);
        });
        Schema::table('buyer_ranking_preferences', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('updated_by_user_id');
        });
        DB::table('platform_settings')->where('key', 'ranking.srs.default_weights')->where('version', 1)->delete();
    }
};
