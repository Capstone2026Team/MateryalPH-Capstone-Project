<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;

/**
 * Phase 8: Item-Based order submission, Vendor confirmation/revision/decline, Buyer approval, manual NRPC,
 * atomic hard reservations, auto-accept and payment-expiry preparation. Extends the Phase 1 order, NRPC,
 * inventory-hold, checkout and FIN-02 tables instead of duplicating them. Commercial versions, line snapshots,
 * confirmations, NRPC proposals/decisions, financial snapshots and state history become append-only; the
 * accepted financial snapshot is versioned so a later approved correction appends a new version.
 */
return new class extends Migration
{
    private const ORDER_STATES = "'AWAITING_VENDOR_CONFIRMATION','AWAITING_BUYER_APPROVAL','AWAITING_NRPC_ACCEPTANCE','AWAITING_PAYMENT','CONFIRMED','PROCESSING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','PICKED_UP','COMPLETED','CANCELLATION_REQUESTED','DECLINED','EXPIRED','CANCELLED','DISPUTED'";

    public function up(): void
    {
        Schema::table('checkout_groups', function (Blueprint $table): void {
            $table->foreignUuid('cart_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignId('submitted_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('request_hash', 64)->nullable();
            $table->timestampTz('submitted_at')->nullable();
        });

        Schema::table('orders', function (Blueprint $table): void {
            $table->string('fulfillment_state', 32)->default('NOT_STARTED');
            $table->string('dispute_state', 40)->default('NONE');
            $table->timestampTz('submitted_at')->nullable();
            $table->timestampTz('vendor_response_due_at')->nullable();
            $table->timestampTz('buyer_response_due_at')->nullable();
            $table->timestampTz('payment_expires_at')->nullable();
            $table->timestampTz('accepted_at')->nullable();
            $table->timestampTz('closed_at')->nullable();
            $table->unsignedInteger('current_snapshot_version')->default(1);
            $table->unsignedInteger('accepted_snapshot_version')->nullable();
            $table->string('confirmation_source', 16)->nullable();
            $table->jsonb('auto_accept_outcome')->nullable();
            $table->date('expected_fulfillment_date')->nullable();
            $table->bigInteger('materials_centavos')->default(0);
            $table->bigInteger('vendor_discount_centavos')->default(0);
            $table->bigInteger('delivery_centavos')->nullable();
            $table->bigInteger('nrpc_centavos')->default(0);
            $table->jsonb('destination')->nullable();
            $table->text('access_instructions_encrypted')->nullable();
            $table->string('terminal_reason_code', 48)->nullable();
            $table->index(['vendor_organization_id', 'order_state', 'created_at']);
            $table->index(['buyer_profile_id', 'created_at']);
            $table->index(['checkout_group_id']);
        });

        Schema::table('order_lines', function (Blueprint $table): void {
            $table->unsignedSmallInteger('line_number')->default(1);
            $table->foreignUuid('vendor_listing_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('listing_price_version_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('applied_price_version_id')->nullable()->constrained('listing_price_versions')->restrictOnDelete();
            $table->bigInteger('ordinary_unit_price_centavos')->nullable();
            $table->jsonb('volume_tiers')->nullable();
            $table->jsonb('snapshot')->nullable();
            $table->unique(['order_id', 'line_number']);
            $table->unique(['order_id', 'listing_variant_id']);
        });

        Schema::table('order_snapshots', function (Blueprint $table): void {
            $table->string('kind', 24)->default('SUBMITTED');
            $table->foreignId('created_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('actor_role', 32)->nullable();
            $table->bigInteger('materials_centavos')->default(0);
            $table->bigInteger('vendor_discount_centavos')->default(0);
            $table->bigInteger('delivery_centavos')->nullable();
            $table->bigInteger('nrpc_centavos')->default(0);
            $table->bigInteger('commercial_total_centavos')->nullable();
            $table->string('calculation_version', 48)->nullable();
        });

        Schema::table('order_status_history', function (Blueprint $table): void {
            $table->string('state_family', 16)->default('ORDER');
            $table->string('actor_role', 32)->nullable();
            $table->string('source', 16)->default('SYSTEM');
            $table->string('reason_code', 48)->nullable();
            $table->unsignedInteger('snapshot_version')->nullable();
            $table->index(['order_id', 'created_at']);
        });

        Schema::table('vendor_confirmations', function (Blueprint $table): void {
            $table->unsignedInteger('order_snapshot_version')->nullable();
            $table->string('actor_role', 32)->nullable();
            $table->string('reason_code', 48)->nullable();
        });

        Schema::create('vendor_confirmation_policy_versions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_confirmation_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('listing_variant_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('auto_accept_policy_version_id')->constrained()->restrictOnDelete();
            $table->decimal('consumed_quantity', 18, 4);
            $table->timestampTz('created_at');
            $table->unique(['vendor_confirmation_id', 'listing_variant_id'], 'vendor_confirmation_policy_variant_unique');
        });

        Schema::table('nrpc_records', function (Blueprint $table): void {
            $table->foreignUuid('agreement_version_id')->nullable()->constrained()->restrictOnDelete();
            $table->unsignedInteger('order_snapshot_version')->nullable();
            $table->string('actor_role', 32)->nullable();
            $table->bigInteger('eligible_subtotal_centavos')->nullable();
        });

        Schema::create('nrpc_line_allocations', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('nrpc_record_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('order_line_id')->constrained()->restrictOnDelete();
            $table->bigInteger('principal_centavos');
            $table->bigInteger('line_payable_centavos');
            $table->bigInteger('vat_centavos')->default(0);
            $table->timestampTz('created_at');
            $table->unique(['nrpc_record_id', 'order_line_id']);
        });

        Schema::table('nrpc_acceptances', function (Blueprint $table): void {
            $table->foreignUuid('nrpc_record_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('agreement_version_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('decision', 16)->nullable();
            $table->string('review_state', 32)->nullable();
        });

        Schema::table('inventory_holds', function (Blueprint $table): void {
            $table->foreignUuid('order_line_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('release_reason', 48)->nullable();
            $table->index(['source_type', 'source_id', 'state']);
        });

        Schema::table('financial_snapshots', function (Blueprint $table): void {
            $table->unsignedInteger('version')->default(1);
            $table->foreignUuid('order_snapshot_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('payment_method', 24)->nullable();
            $table->jsonb('payment_matrix')->nullable();
        });
        Schema::table('financial_snapshots', function (Blueprint $table): void {
            $table->dropUnique('financial_snapshots_order_id_unique');
            $table->unique(['order_id', 'version']);
        });
        Schema::table('financial_snapshot_lines', function (Blueprint $table): void {
            $table->dropUnique('financial_snapshot_lines_order_line_id_unique');
            $table->bigInteger('nrpc_principal_centavos')->default(0);
            $table->bigInteger('nrpc_vat_centavos')->default(0);
            $table->unique(['financial_snapshot_id', 'order_line_id']);
        });

        Schema::create('fee_assessment_events', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('fee_assessment_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->string('event_type', 16);
            $table->string('order_state', 40);
            $table->bigInteger('amount_centavos');
            $table->string('correlation_id', 64)->nullable();
            $table->timestampTz('created_at');
            $table->unique(['fee_assessment_id', 'event_type']);
        });

        Schema::table('vendor_inventory_settings', function (Blueprint $table): void {
            $table->unsignedSmallInteger('auto_accept_ready_lead_days')->nullable();
        });

        if (DB::getDriverName() !== 'pgsql') {
            return;
        }

        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION prevent_phase_eight_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Order commercial and financial history is append-only (%).', TG_TABLE_NAME;
END;
$$;
CREATE TRIGGER order_lines_append_only BEFORE UPDATE OR DELETE ON order_lines FOR EACH ROW EXECUTE FUNCTION prevent_phase_eight_history_mutation();
CREATE TRIGGER order_snapshots_append_only BEFORE UPDATE OR DELETE ON order_snapshots FOR EACH ROW EXECUTE FUNCTION prevent_phase_eight_history_mutation();
CREATE TRIGGER order_status_history_append_only BEFORE UPDATE OR DELETE ON order_status_history FOR EACH ROW EXECUTE FUNCTION prevent_phase_eight_history_mutation();
CREATE TRIGGER vendor_confirmations_append_only BEFORE UPDATE OR DELETE ON vendor_confirmations FOR EACH ROW EXECUTE FUNCTION prevent_phase_eight_history_mutation();
CREATE TRIGGER vendor_confirmation_policy_versions_append_only BEFORE UPDATE OR DELETE ON vendor_confirmation_policy_versions FOR EACH ROW EXECUTE FUNCTION prevent_phase_eight_history_mutation();
CREATE TRIGGER nrpc_records_append_only BEFORE UPDATE OR DELETE ON nrpc_records FOR EACH ROW EXECUTE FUNCTION prevent_phase_eight_history_mutation();
CREATE TRIGGER nrpc_line_allocations_append_only BEFORE UPDATE OR DELETE ON nrpc_line_allocations FOR EACH ROW EXECUTE FUNCTION prevent_phase_eight_history_mutation();
CREATE TRIGGER nrpc_acceptances_append_only BEFORE UPDATE OR DELETE ON nrpc_acceptances FOR EACH ROW EXECUTE FUNCTION prevent_phase_eight_history_mutation();
CREATE TRIGGER financial_snapshots_append_only BEFORE UPDATE OR DELETE ON financial_snapshots FOR EACH ROW EXECUTE FUNCTION prevent_phase_eight_history_mutation();
CREATE TRIGGER financial_allocations_append_only BEFORE UPDATE OR DELETE ON financial_allocations FOR EACH ROW EXECUTE FUNCTION prevent_phase_eight_history_mutation();
CREATE TRIGGER fee_assessment_events_append_only BEFORE UPDATE OR DELETE ON fee_assessment_events FOR EACH ROW EXECUTE FUNCTION prevent_phase_eight_history_mutation();

-- Snapshot lines keep their frozen amounts; only the running principal/refund allocation counters may move.
CREATE OR REPLACE FUNCTION protect_financial_snapshot_lines() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Financial snapshot lines are append-only.';
    END IF;
    IF (NEW.financial_snapshot_id, NEW.order_line_id, NEW.source_quantity, NEW.source_unit_price_centavos, NEW.gross_centavos, NEW.discount_centavos, NEW.vat_centavos, NEW.ordinary_payable_centavos, NEW.tax_category, NEW.nrpc_principal_centavos, NEW.nrpc_vat_centavos)
        IS DISTINCT FROM (OLD.financial_snapshot_id, OLD.order_line_id, OLD.source_quantity, OLD.source_unit_price_centavos, OLD.gross_centavos, OLD.discount_centavos, OLD.vat_centavos, OLD.ordinary_payable_centavos, OLD.tax_category, OLD.nrpc_principal_centavos, OLD.nrpc_vat_centavos) THEN
        RAISE EXCEPTION 'Frozen financial snapshot line amounts cannot change.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER financial_snapshot_lines_frozen BEFORE UPDATE OR DELETE ON financial_snapshot_lines FOR EACH ROW EXECUTE FUNCTION protect_financial_snapshot_lines();

-- A hard reservation row is never deleted; it only moves ACTIVE -> RELEASED | FULFILLED with its reason.
CREATE OR REPLACE FUNCTION protect_inventory_holds() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Inventory holds are retained as history.';
    END IF;
    IF OLD.state <> 'ACTIVE' OR (NEW.inventory_item_id, NEW.hold_type, NEW.quantity, NEW.source_type, NEW.source_id) IS DISTINCT FROM (OLD.inventory_item_id, OLD.hold_type, OLD.quantity, OLD.source_type, OLD.source_id) THEN
        RAISE EXCEPTION 'Only an active hold may be released or fulfilled.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER inventory_holds_protected BEFORE UPDATE OR DELETE ON inventory_holds FOR EACH ROW EXECUTE FUNCTION protect_inventory_holds();
SQL);

        foreach ([
            'ALTER TABLE orders ADD CONSTRAINT order_state_check CHECK (order_state IN ('.self::ORDER_STATES.'))',
            "ALTER TABLE orders ADD CONSTRAINT order_payment_state_check CHECK (payment_state IN ('NOT_REQUIRED','PENDING','PAID','FAILED','EXPIRED'))",
            "ALTER TABLE orders ADD CONSTRAINT order_refund_state_check CHECK (refund_state IN ('NOT_REQUESTED','REFUND_PENDING','PARTIALLY_REFUNDED','REFUNDED','REFUND_FAILED'))",
            "ALTER TABLE orders ADD CONSTRAINT order_fulfillment_state_check CHECK (fulfillment_state IN ('NOT_STARTED','PROCESSING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','PICKED_UP'))",
            "ALTER TABLE orders ADD CONSTRAINT order_dispute_state_check CHECK (dispute_state IN ('NONE','OPEN_AWAITING_RESPONSE','MUTUAL_RESOLUTION','ESCALATED_ADMIN_REVIEW','AWAITING_CLARIFICATION','DECIDED','APPEAL_OPEN','RESOLVED','CLOSED_INCONCLUSIVE'))",
            "ALTER TABLE orders ADD CONSTRAINT order_procurement_type_check CHECK (procurement_type IN ('ITEM_BASED','PROJECT_BASED'))",
            "ALTER TABLE orders ADD CONSTRAINT order_fulfillment_method_check CHECK (fulfillment_method IN ('DELIVERY','PICKUP'))",
            // COD only with Site Delivery; In-Store Payment only with Self-Pickup.
            "ALTER TABLE orders ADD CONSTRAINT order_payment_method_check CHECK (payment_method = 'ONLINE' OR (payment_method = 'CASH_ON_DELIVERY' AND fulfillment_method = 'DELIVERY') OR (payment_method = 'IN_STORE' AND fulfillment_method = 'PICKUP'))",
            "ALTER TABLE orders ADD CONSTRAINT order_confirmation_source_check CHECK (confirmation_source IS NULL OR confirmation_source IN ('MANUAL','AUTO_ACCEPT'))",
            // NRPC is part of the existing materials value and never auto-accepted.
            "ALTER TABLE orders ADD CONSTRAINT order_amounts_check CHECK (materials_centavos >= 0 AND vendor_discount_centavos >= 0 AND nrpc_centavos >= 0 AND nrpc_centavos <= materials_centavos AND (delivery_centavos IS NULL OR delivery_centavos >= 0) AND commercial_total_centavos = materials_centavos + COALESCE(delivery_centavos, 0) AND (nrpc_centavos = 0 OR confirmation_source IS DISTINCT FROM 'AUTO_ACCEPT'))",
            "ALTER TABLE orders ADD CONSTRAINT order_payment_window_check CHECK (order_state <> 'AWAITING_PAYMENT' OR (payment_expires_at IS NOT NULL AND payment_state = 'PENDING'))",
            'ALTER TABLE orders ADD CONSTRAINT order_accepted_version_check CHECK (accepted_snapshot_version IS NULL OR (accepted_at IS NOT NULL AND accepted_snapshot_version <= current_snapshot_version))',
            'CREATE INDEX orders_open_deadlines ON orders (order_state, vendor_response_due_at, buyer_response_due_at, payment_expires_at) WHERE closed_at IS NULL',
            'ALTER TABLE order_lines ADD CONSTRAINT order_line_price_snapshot_check CHECK (ordinary_unit_price_centavos IS NULL OR (ordinary_unit_price_centavos > 0 AND unit_price_centavos <= ordinary_unit_price_centavos))',
            "ALTER TABLE order_lines ADD CONSTRAINT order_line_tax_category_check CHECK (tax_category IN ('VAT_12','VAT_ZERO','VAT_EXEMPT','NON_VAT'))",
            "ALTER TABLE order_snapshots ADD CONSTRAINT order_snapshot_kind_check CHECK (kind IN ('SUBMITTED','VENDOR_CONFIRMED','AUTO_ACCEPTED'))",
            "ALTER TABLE order_snapshots ADD CONSTRAINT order_snapshot_amounts_check CHECK (version >= 1 AND materials_centavos >= 0 AND vendor_discount_centavos >= 0 AND nrpc_centavos >= 0 AND nrpc_centavos <= materials_centavos AND (delivery_centavos IS NULL OR delivery_centavos >= 0) AND (commercial_total_centavos IS NULL OR commercial_total_centavos = materials_centavos + COALESCE(delivery_centavos, 0)) AND (kind <> 'AUTO_ACCEPTED' OR nrpc_centavos = 0))",
            "ALTER TABLE order_status_history ADD CONSTRAINT order_history_family_check CHECK (state_family IN ('ORDER','PAYMENT','FULFILLMENT','REFUND','DISPUTE'))",
            "ALTER TABLE order_status_history ADD CONSTRAINT order_history_source_check CHECK (source IN ('BUYER','VENDOR','SYSTEM','AUTO_ACCEPT'))",
            "ALTER TABLE vendor_confirmations ADD CONSTRAINT vendor_confirmation_state_check CHECK (state IN ('CONFIRMED','REVISED','DECLINED'))",
            "ALTER TABLE vendor_confirmations ADD CONSTRAINT vendor_confirmation_decline_reason_check CHECK (state <> 'DECLINED' OR (reason_code IS NOT NULL AND length(trim(coalesce(reason, ''))) >= 5))",
            'ALTER TABLE vendor_confirmation_policy_versions ADD CONSTRAINT vendor_confirmation_policy_quantity_check CHECK (consumed_quantity > 0 AND consumed_quantity = trunc(consumed_quantity))',
            // No platform-wide NRPC cap: only 0 < N <= the eligible prepared-material subtotal, with a reason.
            "ALTER TABLE nrpc_records ADD CONSTRAINT nrpc_record_amount_check CHECK (amount_centavos > 0 AND (eligible_subtotal_centavos IS NULL OR amount_centavos <= eligible_subtotal_centavos) AND length(trim(coalesce(reason, ''))) >= 10 AND state = 'PROPOSED')",
            'ALTER TABLE nrpc_line_allocations ADD CONSTRAINT nrpc_line_allocation_check CHECK (principal_centavos > 0 AND principal_centavos <= line_payable_centavos AND vat_centavos >= 0 AND vat_centavos <= principal_centavos)',
            "ALTER TABLE nrpc_acceptances ADD CONSTRAINT nrpc_acceptance_decision_check CHECK (decision IN ('ACCEPTED','REJECTED','FLAGGED') AND nrpc_record_id IS NOT NULL AND (decision <> 'ACCEPTED' OR agreement_version_id IS NOT NULL) AND (decision <> 'FLAGGED' OR (review_state = 'PENDING_ADMIN_REVIEW' AND length(trim(coalesce(reason, ''))) >= 10)))",
            "CREATE UNIQUE INDEX nrpc_one_decision_per_record ON nrpc_acceptances (nrpc_record_id) WHERE decision IN ('ACCEPTED','REJECTED')",
            "CREATE UNIQUE INDEX nrpc_one_flag_per_record ON nrpc_acceptances (nrpc_record_id) WHERE decision = 'FLAGGED'",
            "ALTER TABLE inventory_holds ADD CONSTRAINT inventory_hold_state_check CHECK (hold_type IN ('SOFT','HARD') AND state IN ('ACTIVE','RELEASED','FULFILLED') AND (state = 'ACTIVE') = (released_at IS NULL) AND (state <> 'RELEASED' OR release_reason IS NOT NULL))",
            "ALTER TABLE financial_snapshots ADD CONSTRAINT financial_snapshot_payment_method_check CHECK (payment_method IS NULL OR payment_method IN ('ONLINE','CASH_ON_DELIVERY','IN_STORE'))",
            'ALTER TABLE financial_snapshot_lines ADD CONSTRAINT financial_snapshot_line_nrpc_check CHECK (nrpc_principal_centavos >= 0 AND nrpc_principal_centavos <= ordinary_payable_centavos AND nrpc_vat_centavos >= 0 AND nrpc_vat_centavos <= vat_centavos)',
            "ALTER TABLE fee_assessment_events ADD CONSTRAINT fee_assessment_event_check CHECK (event_type IN ('ESTIMATED','EARNED','CANCELLED') AND amount_centavos >= 0 AND (event_type <> 'EARNED' OR order_state = 'COMPLETED'))",
            "ALTER TABLE checkout_groups ADD CONSTRAINT checkout_group_state_check CHECK (state IN ('SUBMITTED'))",
            'ALTER TABLE vendor_inventory_settings ADD CONSTRAINT inventory_settings_ready_lead_check CHECK (auto_accept_ready_lead_days IS NULL OR auto_accept_ready_lead_days BETWEEN 0 AND 30)',
        ] as $statement) {
            DB::statement($statement);
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared(<<<'SQL'
DROP TRIGGER IF EXISTS order_lines_append_only ON order_lines;
DROP TRIGGER IF EXISTS order_snapshots_append_only ON order_snapshots;
DROP TRIGGER IF EXISTS order_status_history_append_only ON order_status_history;
DROP TRIGGER IF EXISTS vendor_confirmations_append_only ON vendor_confirmations;
DROP TRIGGER IF EXISTS vendor_confirmation_policy_versions_append_only ON vendor_confirmation_policy_versions;
DROP TRIGGER IF EXISTS nrpc_records_append_only ON nrpc_records;
DROP TRIGGER IF EXISTS nrpc_line_allocations_append_only ON nrpc_line_allocations;
DROP TRIGGER IF EXISTS nrpc_acceptances_append_only ON nrpc_acceptances;
DROP TRIGGER IF EXISTS financial_snapshots_append_only ON financial_snapshots;
DROP TRIGGER IF EXISTS financial_allocations_append_only ON financial_allocations;
DROP TRIGGER IF EXISTS fee_assessment_events_append_only ON fee_assessment_events;
DROP TRIGGER IF EXISTS financial_snapshot_lines_frozen ON financial_snapshot_lines;
DROP TRIGGER IF EXISTS inventory_holds_protected ON inventory_holds;
DROP FUNCTION IF EXISTS protect_inventory_holds();
DROP FUNCTION IF EXISTS protect_financial_snapshot_lines();
DROP FUNCTION IF EXISTS prevent_phase_eight_history_mutation();
DROP INDEX IF EXISTS orders_open_deadlines;
DROP INDEX IF EXISTS nrpc_one_decision_per_record;
DROP INDEX IF EXISTS nrpc_one_flag_per_record;
ALTER TABLE orders DROP CONSTRAINT IF EXISTS order_state_check, DROP CONSTRAINT IF EXISTS order_payment_state_check, DROP CONSTRAINT IF EXISTS order_refund_state_check,
    DROP CONSTRAINT IF EXISTS order_fulfillment_state_check, DROP CONSTRAINT IF EXISTS order_dispute_state_check, DROP CONSTRAINT IF EXISTS order_procurement_type_check,
    DROP CONSTRAINT IF EXISTS order_fulfillment_method_check, DROP CONSTRAINT IF EXISTS order_payment_method_check, DROP CONSTRAINT IF EXISTS order_confirmation_source_check,
    DROP CONSTRAINT IF EXISTS order_amounts_check, DROP CONSTRAINT IF EXISTS order_payment_window_check, DROP CONSTRAINT IF EXISTS order_accepted_version_check;
ALTER TABLE order_lines DROP CONSTRAINT IF EXISTS order_line_price_snapshot_check, DROP CONSTRAINT IF EXISTS order_line_tax_category_check;
ALTER TABLE order_snapshots DROP CONSTRAINT IF EXISTS order_snapshot_kind_check, DROP CONSTRAINT IF EXISTS order_snapshot_amounts_check;
ALTER TABLE order_status_history DROP CONSTRAINT IF EXISTS order_history_family_check, DROP CONSTRAINT IF EXISTS order_history_source_check;
ALTER TABLE vendor_confirmations DROP CONSTRAINT IF EXISTS vendor_confirmation_state_check, DROP CONSTRAINT IF EXISTS vendor_confirmation_decline_reason_check;
ALTER TABLE nrpc_records DROP CONSTRAINT IF EXISTS nrpc_record_amount_check;
ALTER TABLE nrpc_acceptances DROP CONSTRAINT IF EXISTS nrpc_acceptance_decision_check;
ALTER TABLE inventory_holds DROP CONSTRAINT IF EXISTS inventory_hold_state_check;
ALTER TABLE financial_snapshots DROP CONSTRAINT IF EXISTS financial_snapshot_payment_method_check;
ALTER TABLE financial_snapshot_lines DROP CONSTRAINT IF EXISTS financial_snapshot_line_nrpc_check;
ALTER TABLE checkout_groups DROP CONSTRAINT IF EXISTS checkout_group_state_check;
ALTER TABLE vendor_inventory_settings DROP CONSTRAINT IF EXISTS inventory_settings_ready_lead_check;
SQL);
        }
        Schema::table('vendor_inventory_settings', fn (Blueprint $table) => $table->dropColumn('auto_accept_ready_lead_days'));
        Schema::dropIfExists('fee_assessment_events');
        Schema::table('financial_snapshot_lines', function (Blueprint $table): void {
            $table->dropUnique(['financial_snapshot_id', 'order_line_id']);
            $table->dropColumn(['nrpc_principal_centavos', 'nrpc_vat_centavos']);
            $table->unique('order_line_id');
        });
        Schema::table('financial_snapshots', function (Blueprint $table): void {
            $table->dropUnique(['order_id', 'version']);
            $table->dropConstrainedForeignId('order_snapshot_id');
            $table->dropColumn(['version', 'payment_method', 'payment_matrix']);
            $table->unique('order_id');
        });
        Schema::table('inventory_holds', function (Blueprint $table): void {
            $table->dropIndex(['source_type', 'source_id', 'state']);
            $table->dropConstrainedForeignId('order_line_id');
            $table->dropColumn('release_reason');
        });
        Schema::table('nrpc_acceptances', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('nrpc_record_id');
            $table->dropConstrainedForeignId('agreement_version_id');
            $table->dropColumn(['decision', 'review_state']);
        });
        Schema::dropIfExists('nrpc_line_allocations');
        Schema::table('nrpc_records', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('agreement_version_id');
            $table->dropColumn(['order_snapshot_version', 'actor_role', 'eligible_subtotal_centavos']);
        });
        Schema::dropIfExists('vendor_confirmation_policy_versions');
        Schema::table('vendor_confirmations', fn (Blueprint $table) => $table->dropColumn(['order_snapshot_version', 'actor_role', 'reason_code']));
        Schema::table('order_status_history', function (Blueprint $table): void {
            $table->dropIndex(['order_id', 'created_at']);
            $table->dropColumn(['state_family', 'actor_role', 'source', 'reason_code', 'snapshot_version']);
        });
        Schema::table('order_snapshots', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('created_by_user_id');
            $table->dropColumn(['kind', 'actor_role', 'materials_centavos', 'vendor_discount_centavos', 'delivery_centavos', 'nrpc_centavos', 'commercial_total_centavos', 'calculation_version']);
        });
        Schema::table('order_lines', function (Blueprint $table): void {
            $table->dropUnique(['order_id', 'line_number']);
            $table->dropUnique(['order_id', 'listing_variant_id']);
            $table->dropConstrainedForeignId('vendor_listing_id');
            $table->dropConstrainedForeignId('listing_price_version_id');
            $table->dropConstrainedForeignId('applied_price_version_id');
            $table->dropColumn(['line_number', 'ordinary_unit_price_centavos', 'volume_tiers', 'snapshot']);
        });
        Schema::table('orders', function (Blueprint $table): void {
            $table->dropIndex(['vendor_organization_id', 'order_state', 'created_at']);
            $table->dropIndex(['buyer_profile_id', 'created_at']);
            $table->dropIndex(['checkout_group_id']);
            $table->dropColumn(['fulfillment_state', 'dispute_state', 'submitted_at', 'vendor_response_due_at', 'buyer_response_due_at', 'payment_expires_at', 'accepted_at', 'closed_at',
                'current_snapshot_version', 'accepted_snapshot_version', 'confirmation_source', 'auto_accept_outcome', 'expected_fulfillment_date', 'materials_centavos',
                'vendor_discount_centavos', 'delivery_centavos', 'nrpc_centavos', 'destination', 'access_instructions_encrypted', 'terminal_reason_code']);
        });
        Schema::table('checkout_groups', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('cart_id');
            $table->dropConstrainedForeignId('submitted_by_user_id');
            $table->dropColumn(['request_hash', 'submitted_at']);
        });
    }
};
