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
        Schema::table('vendor_vehicles', function (Blueprint $table): void {
            $table->string('vehicle_category', 32)->nullable();
            $table->string('custom_type_name', 120)->nullable();
            $table->string('brand', 120)->nullable();
            $table->decimal('mixer_capacity_m3', 12, 4)->nullable();
        });
        DB::statement("ALTER TABLE vendor_vehicles ADD CONSTRAINT vendor_vehicle_category_check CHECK (vehicle_category IS NULL OR vehicle_category IN ('MOTORCYCLE', 'PICKUP', 'VAN', 'TRUCK'))");
        DB::statement("ALTER TABLE vendor_vehicles ADD CONSTRAINT vendor_vehicle_mixer_check CHECK (mixer_capacity_m3 IS NULL OR (mixer_capacity_m3 > 0 AND vehicle_category = 'TRUCK' AND vehicle_type = 'CONCRETE_MIXER'))");
        DB::statement("ALTER TABLE vendor_vehicles ADD CONSTRAINT vendor_vehicle_mixer_dimensions_check CHECK (vehicle_type <> 'CONCRETE_MIXER' OR (cargo_length_m IS NULL AND cargo_width_m IS NULL AND cargo_height_m IS NULL))");
        Schema::create('order_delivery_snapshots', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_id')->unique()->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignId('confirmed_by_user_id')->constrained('users')->restrictOnDelete();
            $table->jsonb('snapshot');
            $table->bigInteger('final_charge_centavos');
            $table->timestampTz('created_at');
        });
        DB::statement('ALTER TABLE order_delivery_snapshots ADD CONSTRAINT delivery_snapshot_charge_check CHECK (final_charge_centavos >= 0)');
        DB::unprepared('CREATE TRIGGER order_delivery_snapshots_immutable BEFORE UPDATE OR DELETE ON order_delivery_snapshots FOR EACH ROW EXECUTE FUNCTION prevent_phase_three_history_mutation()');
    }

    public function down(): void
    {
        Schema::dropIfExists('order_delivery_snapshots');
        DB::statement('ALTER TABLE vendor_vehicles DROP CONSTRAINT vendor_vehicle_mixer_dimensions_check, DROP CONSTRAINT vendor_vehicle_mixer_check, DROP CONSTRAINT vendor_vehicle_category_check');
        Schema::table('vendor_vehicles', function (Blueprint $table): void {
            $table->dropColumn(['vehicle_category', 'custom_type_name', 'brand', 'mixer_capacity_m3']);
        });
    }
};
