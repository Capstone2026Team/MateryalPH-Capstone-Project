<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    private const EVENTS = "'PROCESSING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','PICKED_UP','COMPLETED','TRIP_DISPATCHED','VEHICLE_ISSUE_REPORTED','LATE_FLAGGED','ASSIGNED','ISSUE_REPORTED','ISSUE_RESPONDED','ISSUE_RESOLVED','RECEIPT_REMINDER','CANCELLED','AUTO_CONFIRM_PAUSED','AUTO_CONFIRM_RESUMED'";

    public function up(): void
    {
        Schema::table('order_fulfillment_assignments', function (Blueprint $table): void {
            $table->foreignUuid('vehicle_id')->nullable()->constrained('vendor_vehicles')->restrictOnDelete();
            $table->unsignedSmallInteger('vehicle_index')->nullable();
            $table->unsignedSmallInteger('number_of_vehicles')->default(1);
            $table->timestampTz('acknowledged_at')->nullable();
            $table->index(['vehicle_id', 'ended_at']);
        });
        if (DB::getDriverName() === 'pgsql') {
            // Existing dispatched assignments also consume accepted fleet capacity. Do not rewrite their history.
            DB::statement(<<<'SQL'
UPDATE order_fulfillment_assignments AS a
SET vehicle_index = (m.payload->'vehicle'->>'vehicle_index')::smallint,
    vehicle_id = (s.snapshot->'vehicles'->((m.payload->'vehicle'->>'vehicle_index')::integer)->>'vehicle_id')::uuid,
    number_of_vehicles = (s.snapshot->'vehicles'->((m.payload->'vehicle'->>'vehicle_index')::integer)->>'number_of_vehicles')::smallint
FROM orders AS o
JOIN order_delivery_snapshots AS s ON s.order_id = o.id
JOIN LATERAL (
    SELECT payload FROM fulfillment_milestones
    WHERE order_id = o.id AND event_type = 'OUT_FOR_DELIVERY'
    ORDER BY occurred_at DESC, id DESC LIMIT 1
) AS m ON true
WHERE a.order_id = o.id AND o.fulfillment_method = 'DELIVERY'
  AND EXISTS (
      SELECT 1 FROM vendor_vehicles AS v
      WHERE v.id = (s.snapshot->'vehicles'->((m.payload->'vehicle'->>'vehicle_index')::integer)->>'vehicle_id')::uuid
        AND v.vendor_organization_id = o.vendor_organization_id
  )
SQL);
            DB::statement('ALTER TABLE fulfillment_milestones DROP CONSTRAINT fulfillment_milestone_event_check');
            DB::statement('ALTER TABLE fulfillment_milestones ADD CONSTRAINT fulfillment_milestone_event_check CHECK (event_type IN ('.self::EVENTS.",'ASSIGNMENT_ACKNOWLEDGED') AND source IN ('BUYER','VENDOR','SYSTEM'))");
            DB::statement('ALTER TABLE order_fulfillment_assignments ADD CONSTRAINT delivery_assignment_vehicle_check CHECK (number_of_vehicles > 0 AND ((vehicle_id IS NULL) = (vehicle_index IS NULL)))');
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::statement('ALTER TABLE order_fulfillment_assignments DROP CONSTRAINT delivery_assignment_vehicle_check');
            // Keep the event vocabulary: acknowledgement history remains append-only.
        }
        Schema::table('order_fulfillment_assignments', function (Blueprint $table): void {
            $table->dropIndex(['vehicle_id', 'ended_at']);
            $table->dropConstrainedForeignId('vehicle_id');
            $table->dropColumn(['vehicle_index', 'number_of_vehicles', 'acknowledged_at']);
        });
    }
};
