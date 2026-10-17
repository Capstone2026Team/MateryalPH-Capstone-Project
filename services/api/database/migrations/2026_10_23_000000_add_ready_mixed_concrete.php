<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/**
 * Ready-Mixed Concrete (approved by the project owner on 2026-10-16). Ready-mixed concrete is its own material
 * category, sold per cubic meter and delivered only by a Concrete Mixer Truck / Transit Mixer: one variant per
 * compressive-strength class (Required PSI) carries its own price. Bagged cement stays in Cement and Concrete
 * and keeps the ordinary cargo rule.
 *
 * A mixer rate version may add a Vendor-set mobilization fee charged per truck dispatched or per trip. Older
 * rate versions keep a zero fee, so accepted delivery snapshots never change. A Buyer may request a free site
 * inspection instead of stating a volume; the Vendor then quotes the measured volume in the same conversation.
 */
return new class extends Migration
{
    public function up(): void
    {
        $categoryId = $this->upsert('material_categories', ['code' => 'READY_MIXED_CONCRETE'], ['name' => 'Ready-Mixed Concrete', 'sort_order' => 75, 'active' => true]);
        $definitions = [
            ['compressive_strength_psi', 'Required PSI (compressive strength)', 'ENUM', true, ['2000', '2500', '3000', '3500', '4000', '4500', '5000', '6000'], 'psi', true],
            ['maximum_aggregate_size_mm', 'Maximum aggregate size', 'NUMBER', false, null, 'mm', false],
        ];
        foreach ($definitions as $index => [$code, $label, $type, $required, $allowed, $unit, $key]) {
            $this->upsert('technical_attribute_definitions', ['material_category_id' => $categoryId, 'code' => $code], [
                'label' => $label, 'value_type' => $type, 'required' => $required, 'allowed_values' => $allowed === null ? null : json_encode($allowed, JSON_THROW_ON_ERROR),
                'unit_code' => $unit, 'sort_order' => $index * 10, 'comparability_key' => $key,
            ]);
        }
        $cubicMeter = DB::table('units')->where('code', 'CUM')->value('id');
        $materialId = $this->upsert('materials', ['code' => 'READY_MIXED_CONCRETE'], [
            'material_category_id' => $categoryId, 'name' => 'Ready-mixed concrete', 'normalized_name' => 'ready-mixed concrete',
            'canonical_unit_id' => $cubicMeter, 'regulated' => false, 'active' => true,
        ]);
        $this->upsert('material_compatible_units', ['material_id' => $materialId, 'unit_id' => $cubicMeter], []);
        foreach (['ready-mixed concrete', 'ready mixed concrete', 'ready mix', 'ready mix concrete', 'readymix', 'rmc', 'transit mix concrete', 'premixed concrete', 'pre-mixed concrete'] as $alias) {
            $this->upsert('material_aliases', ['material_id' => $materialId, 'normalized_alias' => $alias], []);
        }
        foreach (['STRUCTURAL', 'FOUNDATION', 'BULK'] as $tagCode) {
            $this->upsert('material_tag_links', ['material_id' => $materialId, 'material_tag_id' => DB::table('material_tags')->where('code', $tagCode)->value('id')], []);
        }

        Schema::table('vehicle_rate_versions', function (Blueprint $table): void {
            $table->bigInteger('mobilization_fee_centavos')->default(0);
            $table->string('mobilization_basis', 16)->nullable();
        });
        DB::statement("ALTER TABLE vehicle_rate_versions ADD CONSTRAINT vehicle_rate_mobilization_check CHECK (mobilization_fee_centavos >= 0
            AND (mobilization_basis IS NULL OR mobilization_basis IN ('PER_TRUCK', 'PER_TRIP'))
            AND (mobilization_fee_centavos = 0 OR mobilization_basis IS NOT NULL))");

        Schema::create('site_inspection_requests', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('conversation_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_listing_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('listing_variant_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('buyer_location_id')->constrained()->restrictOnDelete();
            $table->jsonb('site');
            $table->date('preferred_date');
            $table->text('buyer_notes_encrypted')->nullable();
            $table->string('status', 16);
            $table->timestampTz('scheduled_for')->nullable();
            $table->string('vendor_note', 1000)->nullable();
            $table->decimal('measured_volume_m3', 12, 3)->nullable();
            $table->foreignId('requested_by_user_id')->constrained('users')->restrictOnDelete();
            $table->foreignId('decided_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->unsignedInteger('lock_version')->default(1);
            $table->timestampTz('requested_at');
            $table->timestampTz('closed_at')->nullable();
            $table->timestampsTz();
            $table->index(['vendor_organization_id', 'status']);
            $table->index(['conversation_id', 'requested_at']);
        });
        DB::statement("ALTER TABLE site_inspection_requests ADD CONSTRAINT site_inspection_status_check CHECK (
            status IN ('REQUESTED', 'SCHEDULED', 'COMPLETED', 'DECLINED', 'CANCELLED')
            AND (status <> 'SCHEDULED' OR scheduled_for IS NOT NULL)
            AND (status <> 'COMPLETED' OR (measured_volume_m3 > 0 AND scheduled_for IS NOT NULL))
            AND ((status IN ('REQUESTED', 'SCHEDULED')) = (closed_at IS NULL)))");
        DB::statement("CREATE UNIQUE INDEX site_inspection_one_open_per_conversation ON site_inspection_requests (conversation_id) WHERE status IN ('REQUESTED', 'SCHEDULED')");
    }

    public function down(): void
    {
        Schema::dropIfExists('site_inspection_requests');
        DB::statement('ALTER TABLE vehicle_rate_versions DROP CONSTRAINT IF EXISTS vehicle_rate_mobilization_check');
        Schema::table('vehicle_rate_versions', fn (Blueprint $table) => $table->dropColumn(['mobilization_fee_centavos', 'mobilization_basis']));
        // Reference taxonomy may already be referenced by listings, orders and compliance history.
    }

    /**
     * @param  array<string, mixed>  $keys
     * @param  array<string, mixed>  $values
     */
    private function upsert(string $table, array $keys, array $values): string
    {
        $existing = DB::table($table)->where($keys)->value('id');
        if (is_string($existing)) {
            return $existing;
        }
        $id = (string) Str::uuid7();
        DB::table($table)->insert($keys + $values + ['id' => $id, 'created_at' => now(), 'updated_at' => now()]);

        return $id;
    }
};
