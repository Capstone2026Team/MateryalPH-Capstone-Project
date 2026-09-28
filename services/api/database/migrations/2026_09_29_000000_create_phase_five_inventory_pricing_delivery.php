<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/**
 * Phase 5: exact Vendor inventory, append-only movements, reorder level, stale-stock reminders,
 * versioned Item-Based auto-accept policies and versioned vehicle configurations. Extends the
 * Phase 1 inventory/auto-accept tables and the Phase 3D vehicle records instead of duplicating them.
 */
return new class extends Migration
{
    public function up(): void
    {
        Schema::table('inventory_items', function (Blueprint $table): void {
            $table->decimal('reorder_level', 18, 4)->nullable();
            $table->foreignId('updated_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });

        Schema::table('inventory_movements', function (Blueprint $table): void {
            $table->decimal('quantity_on_hand_before', 18, 4)->nullable();
            $table->decimal('hard_reserved_before', 18, 4)->nullable();
            $table->decimal('hard_reserved_after', 18, 4)->nullable();
            $table->decimal('soft_held_before', 18, 4)->nullable();
            $table->decimal('soft_held_after', 18, 4)->nullable();
            $table->string('reason_code', 32)->nullable();
            $table->text('note')->nullable();
            $table->uuid('auto_accept_policy_version_id')->nullable();
            $table->index(['inventory_item_id', 'created_at']);
        });

        Schema::table('stock_confirmation_events', function (Blueprint $table): void {
            $table->string('source', 24)->default('COUNT');
            $table->index(['inventory_item_id', 'confirmed_at']);
        });

        Schema::table('auto_accept_policies', function (Blueprint $table): void {
            $table->decimal('allotment_quantity', 18, 4)->default(0);
            $table->decimal('remaining_allotment_quantity', 18, 4)->default(0);
            $table->decimal('max_unit_count', 18, 4)->nullable();
            $table->bigInteger('max_order_amount_centavos')->nullable();
            $table->string('pause_reason', 32)->nullable();
            $table->timestampTz('paused_at')->nullable();
            $table->foreignId('updated_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });
        DB::table('auto_accept_policies')->where('enabled', false)->update(['paused' => false]);
        Schema::table('auto_accept_policies', function (Blueprint $table): void {
            $table->boolean('paused')->default(false)->change();
        });

        Schema::table('auto_accept_policy_versions', function (Blueprint $table): void {
            $table->boolean('enabled')->default(false);
            $table->boolean('paused')->default(false);
            $table->string('pause_reason', 32)->nullable();
            $table->string('change_kind', 32)->default('CONFIGURED');
            $table->boolean('automated')->default(false);
        });

        Schema::table('vendor_vehicles', function (Blueprint $table): void {
            $table->boolean('available')->default(true);
            $table->unsignedInteger('configuration_version')->default(1);
            $table->timestampTz('removed_at')->nullable();
            $table->foreignId('updated_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });

        Schema::create('vendor_vehicle_versions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_vehicle_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('version');
            $table->jsonb('configuration');
            $table->string('content_hash', 64);
            $table->foreignId('created_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('created_at');
            $table->unique(['vendor_vehicle_id', 'version']);
        });

        Schema::table('vehicle_rate_versions', function (Blueprint $table): void {
            $table->foreignId('created_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });

        Schema::create('vendor_inventory_settings', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->unique()->constrained()->restrictOnDelete();
            $table->time('reminder_local_time')->default('08:00');
            $table->boolean('email_reminders')->default(true);
            $table->unsignedInteger('lock_version')->default(1);
            $table->foreignId('updated_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampsTz();
        });

        Schema::create('stock_confirmation_reminders', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_listing_id')->constrained()->restrictOnDelete();
            $table->timestampTz('anchor_confirmed_at');
            $table->string('stage', 16);
            $table->timestampTz('recorded_at');
            $table->unique(['vendor_listing_id', 'anchor_confirmed_at', 'stage']);
        });

        Schema::table('order_delivery_snapshots', function (Blueprint $table): void {
            $table->date('fulfillment_date')->nullable();
            $table->string('calculation_version', 48)->nullable();
            $table->string('basis', 24)->nullable();
        });

        Schema::table('vendor_confirmations', function (Blueprint $table): void {
            $table->string('source', 16)->default('MANUAL');
            $table->foreignUuid('auto_accept_policy_version_id')->nullable()->constrained()->restrictOnDelete();
        });

        Schema::table('price_observations', function (Blueprint $table): void {
            $table->timestampTz('price_effective_at')->nullable();
            $table->string('unit_conversion_version', 32)->nullable();
            $table->string('comparability_rule_version', 32)->nullable();
            $table->timestampTz('stock_confirmed_at')->nullable();
        });

        if (DB::getDriverName() !== 'pgsql') {
            return;
        }

        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION prevent_phase_five_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Inventory, auto-accept and vehicle history is append-only (%).', TG_TABLE_NAME;
END;
$$;
CREATE TRIGGER inventory_movements_append_only BEFORE UPDATE OR DELETE ON inventory_movements FOR EACH ROW EXECUTE FUNCTION prevent_phase_five_history_mutation();
CREATE TRIGGER stock_confirmation_events_append_only BEFORE UPDATE OR DELETE ON stock_confirmation_events FOR EACH ROW EXECUTE FUNCTION prevent_phase_five_history_mutation();
CREATE TRIGGER auto_accept_policy_versions_append_only BEFORE UPDATE OR DELETE ON auto_accept_policy_versions FOR EACH ROW EXECUTE FUNCTION prevent_phase_five_history_mutation();
CREATE TRIGGER vendor_vehicle_versions_append_only BEFORE UPDATE OR DELETE ON vendor_vehicle_versions FOR EACH ROW EXECUTE FUNCTION prevent_phase_five_history_mutation();
CREATE TRIGGER vehicle_rate_versions_append_only BEFORE UPDATE OR DELETE ON vehicle_rate_versions FOR EACH ROW EXECUTE FUNCTION prevent_phase_five_history_mutation();
CREATE TRIGGER stock_confirmation_reminders_append_only BEFORE UPDATE OR DELETE ON stock_confirmation_reminders FOR EACH ROW EXECUTE FUNCTION prevent_phase_five_history_mutation();

ALTER TABLE inventory_items ADD CONSTRAINT inventory_reorder_level_check CHECK (reorder_level IS NULL OR reorder_level >= 0);
ALTER TABLE inventory_movements ADD CONSTRAINT inventory_movement_type_check CHECK (movement_type IN ('INITIAL_COUNT','COUNT_ADJUSTMENT','RECEIVED','DAMAGED','LOST','RETURNED','CORRECTION','HARD_RESERVE','HARD_RELEASE','SOFT_HOLD','SOFT_RELEASE','FULFILLED'));
ALTER TABLE inventory_movements ADD CONSTRAINT inventory_movement_after_check CHECK (quantity_on_hand_after >= 0 AND (hard_reserved_after IS NULL OR (hard_reserved_after >= 0 AND hard_reserved_after <= quantity_on_hand_after)) AND (soft_held_after IS NULL OR soft_held_after >= 0));
ALTER TABLE stock_confirmation_events ADD CONSTRAINT stock_confirmation_quantity_check CHECK (confirmed_quantity >= 0);
ALTER TABLE stock_confirmation_events ADD CONSTRAINT stock_confirmation_source_check CHECK (source IN ('COUNT','CONFIRM_UNCHANGED'));

ALTER TABLE auto_accept_policies ADD CONSTRAINT auto_accept_policy_counter_check CHECK (allotment_quantity >= 0 AND remaining_allotment_quantity >= 0 AND allotment_quantity = trunc(allotment_quantity) AND remaining_allotment_quantity = trunc(remaining_allotment_quantity));
ALTER TABLE auto_accept_policies ADD CONSTRAINT auto_accept_policy_caps_check CHECK ((max_unit_count IS NULL OR max_unit_count > 0) AND (max_order_amount_centavos IS NULL OR max_order_amount_centavos > 0));
ALTER TABLE auto_accept_policies ADD CONSTRAINT auto_accept_policy_active_check CHECK (NOT enabled OR paused OR remaining_allotment_quantity > 0);
ALTER TABLE auto_accept_policies ADD CONSTRAINT auto_accept_policy_pause_check CHECK ((paused AND enabled) = (pause_reason IS NOT NULL) AND (pause_reason IS NULL OR pause_reason IN ('ALLOTMENT_EXHAUSTED','MANUAL')));
ALTER TABLE auto_accept_policy_versions ADD CONSTRAINT auto_accept_version_kind_check CHECK (change_kind IN ('CONFIGURED','ALLOTMENT_UPDATED','PAUSED','RESUMED','EXHAUSTED','DISABLED'));
ALTER TABLE auto_accept_policy_versions ADD CONSTRAINT auto_accept_version_integer_check CHECK (allotment_quantity = trunc(allotment_quantity) AND remaining_allotment_quantity = trunc(remaining_allotment_quantity));
ALTER TABLE auto_accept_policy_versions ADD CONSTRAINT auto_accept_version_caps_check CHECK ((max_unit_count IS NULL OR max_unit_count > 0) AND (max_order_amount_centavos IS NULL OR max_order_amount_centavos > 0));

ALTER TABLE vendor_vehicles ADD CONSTRAINT vendor_vehicle_count_check CHECK (number_available >= 1 AND capacity_kg > 0);
ALTER TABLE vendor_vehicles ADD CONSTRAINT vendor_vehicle_removed_check CHECK (removed_at IS NULL OR active = false);
ALTER TABLE vehicle_rate_versions ADD CONSTRAINT vehicle_rate_values_check CHECK (base_fee_centavos >= 0 AND per_km_centavos >= 0 AND maximum_distance_km > 0);
ALTER TABLE vendor_inventory_settings ADD CONSTRAINT inventory_settings_version_check CHECK (lock_version >= 1);
ALTER TABLE stock_confirmation_reminders ADD CONSTRAINT stock_reminder_stage_check CHECK (stage IN ('DAY_7','DAY_12','DAY_15_HIDDEN'));
ALTER TABLE order_delivery_snapshots ADD CONSTRAINT delivery_snapshot_basis_check CHECK (basis IS NULL OR basis IN ('ADVISORY_CONFIRMED','MANUAL_REVIEW'));

ALTER TABLE vendor_confirmations ADD CONSTRAINT vendor_confirmation_source_check CHECK (source IN ('MANUAL','AUTO_ACCEPT') AND ((source = 'AUTO_ACCEPT') = (auto_accept_policy_version_id IS NOT NULL)));
CREATE OR REPLACE FUNCTION enforce_item_based_auto_accept() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    -- Record fields are referenced only inside the branch for their own table.
    IF TG_TABLE_NAME = 'vendor_confirmations' THEN
        IF NEW.source = 'AUTO_ACCEPT' THEN
            IF NOT EXISTS (SELECT 1 FROM orders o WHERE o.id = NEW.order_id AND o.procurement_type = 'ITEM_BASED') THEN
                RAISE EXCEPTION 'Auto-accept applies only to Item-Based orders.';
            END IF;
            IF EXISTS (SELECT 1 FROM nrpc_records n WHERE n.order_id = NEW.order_id AND n.amount_centavos > 0) THEN
                RAISE EXCEPTION 'An order with NRPC always requires manual Vendor confirmation.';
            END IF;
        END IF;
    ELSIF TG_TABLE_NAME = 'nrpc_records' THEN
        IF NEW.amount_centavos > 0 AND EXISTS (SELECT 1 FROM vendor_confirmations c WHERE c.order_id = NEW.order_id AND c.source = 'AUTO_ACCEPT') THEN
            RAISE EXCEPTION 'An auto-accepted order cannot carry NRPC.';
        END IF;
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER vendor_confirmations_item_based_auto_accept BEFORE INSERT OR UPDATE ON vendor_confirmations FOR EACH ROW EXECUTE FUNCTION enforce_item_based_auto_accept();
CREATE TRIGGER nrpc_records_no_auto_accept BEFORE INSERT OR UPDATE ON nrpc_records FOR EACH ROW EXECUTE FUNCTION enforce_item_based_auto_accept();
SQL);

        // Every existing configuration gets its first immutable version so later snapshots can reference it.
        foreach (DB::table('vendor_vehicles')->orderBy('id')->get() as $vehicle) {
            $configuration = json_encode(array_intersect_key((array) $vehicle, array_flip(['vehicle_category', 'vehicle_type', 'custom_type_name', 'name', 'brand', 'image_file_id', 'number_available', 'capacity_kg', 'cargo_length_m', 'cargo_width_m', 'cargo_height_m', 'mixer_capacity_m3', 'heavy_classification', 'active', 'available'])), JSON_THROW_ON_ERROR);
            DB::table('vendor_vehicle_versions')->insert(['id' => (string) Str::uuid7(), 'vendor_vehicle_id' => $vehicle->id, 'version' => 1, 'configuration' => $configuration, 'content_hash' => hash('sha256', $configuration), 'created_at' => now()]);
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared(<<<'SQL'
DROP TRIGGER IF EXISTS inventory_movements_append_only ON inventory_movements;
DROP TRIGGER IF EXISTS stock_confirmation_events_append_only ON stock_confirmation_events;
DROP TRIGGER IF EXISTS auto_accept_policy_versions_append_only ON auto_accept_policy_versions;
DROP TRIGGER IF EXISTS vendor_vehicle_versions_append_only ON vendor_vehicle_versions;
DROP TRIGGER IF EXISTS vehicle_rate_versions_append_only ON vehicle_rate_versions;
DROP TRIGGER IF EXISTS stock_confirmation_reminders_append_only ON stock_confirmation_reminders;
ALTER TABLE inventory_items DROP CONSTRAINT IF EXISTS inventory_reorder_level_check;
ALTER TABLE inventory_movements DROP CONSTRAINT IF EXISTS inventory_movement_type_check;
ALTER TABLE inventory_movements DROP CONSTRAINT IF EXISTS inventory_movement_after_check;
ALTER TABLE stock_confirmation_events DROP CONSTRAINT IF EXISTS stock_confirmation_quantity_check;
ALTER TABLE stock_confirmation_events DROP CONSTRAINT IF EXISTS stock_confirmation_source_check;
ALTER TABLE auto_accept_policies DROP CONSTRAINT IF EXISTS auto_accept_policy_counter_check;
ALTER TABLE auto_accept_policies DROP CONSTRAINT IF EXISTS auto_accept_policy_caps_check;
ALTER TABLE auto_accept_policies DROP CONSTRAINT IF EXISTS auto_accept_policy_active_check;
ALTER TABLE auto_accept_policies DROP CONSTRAINT IF EXISTS auto_accept_policy_pause_check;
ALTER TABLE auto_accept_policy_versions DROP CONSTRAINT IF EXISTS auto_accept_version_kind_check;
ALTER TABLE auto_accept_policy_versions DROP CONSTRAINT IF EXISTS auto_accept_version_integer_check;
ALTER TABLE auto_accept_policy_versions DROP CONSTRAINT IF EXISTS auto_accept_version_caps_check;
ALTER TABLE vendor_vehicles DROP CONSTRAINT IF EXISTS vendor_vehicle_count_check;
ALTER TABLE vendor_vehicles DROP CONSTRAINT IF EXISTS vendor_vehicle_removed_check;
ALTER TABLE vehicle_rate_versions DROP CONSTRAINT IF EXISTS vehicle_rate_values_check;
ALTER TABLE order_delivery_snapshots DROP CONSTRAINT IF EXISTS delivery_snapshot_basis_check;
DROP TRIGGER IF EXISTS vendor_confirmations_item_based_auto_accept ON vendor_confirmations;
DROP TRIGGER IF EXISTS nrpc_records_no_auto_accept ON nrpc_records;
DROP FUNCTION IF EXISTS enforce_item_based_auto_accept();
ALTER TABLE vendor_confirmations DROP CONSTRAINT IF EXISTS vendor_confirmation_source_check;
DROP FUNCTION IF EXISTS prevent_phase_five_history_mutation();
SQL);
        }
        Schema::table('vendor_confirmations', function (Blueprint $table): void {
            $table->dropForeign(['auto_accept_policy_version_id']);
            $table->dropColumn(['source', 'auto_accept_policy_version_id']);
        });
        Schema::table('price_observations', fn (Blueprint $table) => $table->dropColumn(['price_effective_at', 'unit_conversion_version', 'comparability_rule_version', 'stock_confirmed_at']));
        Schema::table('order_delivery_snapshots', fn (Blueprint $table) => $table->dropColumn(['fulfillment_date', 'calculation_version', 'basis']));
        Schema::dropIfExists('stock_confirmation_reminders');
        Schema::dropIfExists('vendor_inventory_settings');
        Schema::table('vehicle_rate_versions', function (Blueprint $table): void {
            $table->dropForeign(['created_by_user_id']);
            $table->dropColumn('created_by_user_id');
        });
        Schema::dropIfExists('vendor_vehicle_versions');
        Schema::table('vendor_vehicles', function (Blueprint $table): void {
            $table->dropForeign(['updated_by_user_id']);
            $table->dropColumn(['available', 'configuration_version', 'removed_at', 'updated_by_user_id']);
        });
        Schema::table('auto_accept_policy_versions', fn (Blueprint $table) => $table->dropColumn(['enabled', 'paused', 'pause_reason', 'change_kind', 'automated']));
        Schema::table('auto_accept_policies', function (Blueprint $table): void {
            $table->dropForeign(['updated_by_user_id']);
            $table->dropColumn(['allotment_quantity', 'remaining_allotment_quantity', 'max_unit_count', 'max_order_amount_centavos', 'pause_reason', 'paused_at', 'updated_by_user_id']);
            $table->boolean('paused')->default(true)->change();
        });
        Schema::table('stock_confirmation_events', function (Blueprint $table): void {
            $table->dropIndex(['inventory_item_id', 'confirmed_at']);
            $table->dropColumn('source');
        });
        Schema::table('inventory_movements', function (Blueprint $table): void {
            $table->dropIndex(['inventory_item_id', 'created_at']);
            $table->dropColumn(['quantity_on_hand_before', 'hard_reserved_before', 'hard_reserved_after', 'soft_held_before', 'soft_held_after', 'reason_code', 'note', 'auto_accept_policy_version_id']);
        });
        Schema::table('inventory_items', function (Blueprint $table): void {
            $table->dropForeign(['updated_by_user_id']);
            $table->dropColumn(['reorder_level', 'updated_by_user_id']);
        });
    }
};
