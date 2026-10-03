<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/**
 * Phase 12: fulfillment milestones and proof, Buyer receipt confirmation with the 48-hour auto-confirmation that an
 * open problem report pauses, cancellation requests and final decisions, the NFR event, Cancellation Refunds with
 * provider attempts/events and target-type-aware PLATFORM_FEE credits, and evidenced Vendor cash reimbursements.
 * Extends the Phase 1 fulfillment, cancellation, refund and reimbursement tables instead of duplicating them.
 *
 * Mapping to the Technical Design: `fulfillments` is one row per order; `fulfillment_milestones` is the append-only
 * milestone/event log (dedupe_key makes a repeated milestone or trip a replay, never a second row);
 * `fulfillment_proofs` holds the proof attached to the milestone that requires it; `fulfillment_issues` is the
 * Report a Problem record that pauses auto-confirmation (a formal dispute stays Phase 13).
 */
return new class extends Migration
{
    private const REVIEW_KINDS = "'RECONCILIATION_EXCEPTION','PAYMENT_MISMATCH','LATE_CAPTURE_COMPENSATION','OVERLAP_UNRESOLVED','THRESHOLD_ADJUSTMENT_REQUIRED','BASE_REVIEW_REQUIRED','FEE_OVERPAYMENT','STATEMENT_OVERDUE','FEE_CREDIT_PROPOSAL','PAID_FEE_CREDIT_PAYABLE'";

    private const MILESTONE_EVENTS = "'PROCESSING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','PICKED_UP','COMPLETED','TRIP_DISPATCHED','VEHICLE_ISSUE_REPORTED','LATE_FLAGGED','ASSIGNED','ISSUE_REPORTED','ISSUE_RESPONDED','ISSUE_RESOLVED','RECEIPT_REMINDER','CANCELLED','AUTO_CONFIRM_PAUSED','AUTO_CONFIRM_RESUMED'";

    public function up(): void
    {
        Schema::table('fulfillments', function (Blueprint $table): void {
            $table->string('method', 16)->nullable();
            $table->date('expected_fulfillment_date')->nullable();
            $table->timestampTz('late_flagged_at')->nullable();
            $table->timestampTz('auto_confirm_due_at')->nullable();
            $table->timestampTz('auto_confirm_paused_at')->nullable();
            $table->unsignedInteger('auto_confirm_remaining_seconds')->nullable();
            $table->timestampTz('reminder_24h_sent_at')->nullable();
            $table->timestampTz('reminder_2h_sent_at')->nullable();
            $table->timestampTz('receipt_confirmed_at')->nullable();
            $table->string('receipt_confirmation_source', 24)->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->index(['state', 'auto_confirm_due_at']);
        });
        Schema::table('fulfillment_milestones', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('actor_role', 32)->nullable();
            $table->string('source', 16)->default('VENDOR');
            $table->string('dedupe_key', 96)->nullable();
            $table->string('correlation_id', 64)->nullable();
            $table->unique(['fulfillment_id', 'dedupe_key']);
            $table->index(['order_id', 'occurred_at']);
        });
        Schema::table('fulfillment_proofs', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('milestone_id')->nullable()->unique()->constrained('fulfillment_milestones')->restrictOnDelete();
            $table->foreignUuid('photo_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->foreignUuid('signature_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->text('receiver_name_encrypted')->nullable();
            $table->string('receiver_kind', 24)->nullable();
            $table->boolean('handover_confirmed')->default(false);
            $table->jsonb('vehicle_reference')->nullable();
        });
        Schema::create('fulfillment_issues', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('fulfillment_id')->constrained()->restrictOnDelete();
            $table->foreignId('reported_by_user_id')->constrained('users')->restrictOnDelete();
            $table->string('category', 32);
            $table->text('description');
            $table->jsonb('evidence_file_ids')->default('[]');
            $table->string('order_state_at_report', 40);
            $table->string('state', 16)->default('OPEN');
            $table->text('vendor_response')->nullable();
            $table->foreignId('vendor_responded_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('vendor_responded_role', 32)->nullable();
            $table->timestampTz('vendor_responded_at')->nullable();
            $table->string('resolution', 32)->nullable();
            $table->text('resolution_note')->nullable();
            $table->timestampTz('resolved_at')->nullable();
            $table->timestampsTz();
            $table->index(['order_id', 'created_at']);
        });

        Schema::table('cancellation_requests', function (Blueprint $table): void {
            $table->string('kind', 24)->nullable();
            $table->string('source', 16)->nullable();
            $table->string('actor_role', 32)->nullable();
            $table->string('reason_code', 48)->nullable();
            $table->string('order_state_at_request', 40)->nullable();
            $table->timestampTz('response_due_at')->nullable();
            $table->timestampTz('resolved_at')->nullable();
            $table->index(['state', 'response_due_at']);
        });
        Schema::table('cancellation_decisions', function (Blueprint $table): void {
            $table->foreignUuid('cancellation_request_id')->nullable()->unique()->constrained()->restrictOnDelete();
            $table->string('cause', 16)->nullable();
            $table->string('decided_by', 16)->nullable();
            $table->string('decision_code', 48)->nullable();
            $table->string('actor_role', 32)->nullable();
            $table->string('reason_code', 48)->nullable();
            $table->string('order_state_before', 40)->nullable();
            $table->bigInteger('nrpc_retained_centavos')->default(0);
            $table->foreignUuid('evidence_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->bigInteger('refund_total_centavos')->default(0);
            $table->bigInteger('cash_reimbursement_centavos')->default(0);
            $table->bigInteger('released_unpaid_centavos')->default(0);
            $table->string('correlation_id', 64)->nullable();
        });
        Schema::create('nfr_events', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_id')->unique()->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('cancellation_decision_id')->unique()->constrained()->restrictOnDelete();
            $table->string('reason_code', 48);
            $table->string('order_state_before', 40);
            $table->string('environment', 8)->default('TEST');
            $table->timestampTz('occurred_at');
            $table->timestampTz('created_at');
            $table->index(['vendor_organization_id', 'occurred_at']);
        });

        Schema::table('refunds', function (Blueprint $table): void {
            $table->foreignUuid('cancellation_decision_id')->nullable()->constrained()->restrictOnDelete();
            $table->bigInteger('principal_centavos')->nullable();
            $table->bigInteger('processing_fee_centavos')->default(0);
            $table->jsonb('allocation')->nullable();
            $table->unsignedSmallInteger('attempt_number')->default(1);
            $table->string('provider_status', 32)->nullable();
            $table->timestampTz('last_reconciled_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->index(['state', 'updated_at']);
        });
        Schema::table('refund_attempts', function (Blueprint $table): void {
            $table->unsignedSmallInteger('attempt_number')->default(1);
            $table->string('operation', 16)->default('CREATE');
            $table->unsignedSmallInteger('http_status')->nullable();
            $table->string('provider_refund_id', 128)->nullable();
            $table->string('correlation_id', 64)->nullable();
        });
        Schema::table('refund_events', function (Blueprint $table): void {
            $table->unsignedSmallInteger('attempt_number')->default(1);
            $table->string('from_state', 24)->nullable();
            $table->string('source', 24)->default('SYSTEM');
            $table->foreignUuid('webhook_event_id')->nullable()->constrained('webhook_events')->restrictOnDelete();
            $table->string('correlation_id', 64)->nullable();
            $table->unique(['refund_id', 'attempt_number', 'state']);
        });
        Schema::table('physical_reimbursements', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('cancellation_decision_id')->nullable()->unique()->constrained()->restrictOnDelete();
            $table->string('recorded_role', 32)->nullable();
            $table->text('vendor_note')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });

        if (DB::getDriverName() === 'pgsql') {
            $this->postgresRules();
        }
        $this->grantAdminPermissions();
    }

    private function postgresRules(): void
    {
        foreach ([
            // A cash reimbursement after a cancellation is not a provider refund; it needs no refunds row.
            'ALTER TABLE physical_reimbursements ALTER COLUMN refund_id DROP NOT NULL',
            'ALTER TABLE physical_reimbursements ALTER COLUMN recorded_by_user_id DROP NOT NULL',
            "ALTER TABLE fulfillments ADD CONSTRAINT fulfillment_state_check CHECK (state IN ('NOT_STARTED','PROCESSING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','PICKED_UP','COMPLETED','CANCELLED') AND (method IS NULL OR method IN ('DELIVERY','PICKUP')) AND (receipt_confirmation_source IS NULL OR receipt_confirmation_source IN ('BUYER','AUTO_CONFIRMATION')))",
            'ALTER TABLE fulfillments ADD CONSTRAINT fulfillment_pause_check CHECK ((auto_confirm_paused_at IS NULL) = (auto_confirm_remaining_seconds IS NULL) AND (auto_confirm_paused_at IS NULL OR auto_confirm_due_at IS NULL))',
            'ALTER TABLE fulfillment_milestones ADD CONSTRAINT fulfillment_milestone_event_check CHECK (event_type IN ('.self::MILESTONE_EVENTS.") AND source IN ('BUYER','VENDOR','SYSTEM'))",
            // Proof belongs to the milestone that requires it: Site Delivery needs a photo and receiver name; Self-Pickup
            // needs a confirmed handover and the Buyer or an authorized receiver.
            "ALTER TABLE fulfillment_proofs ADD CONSTRAINT fulfillment_proof_requirement_check CHECK ((event_type = 'DELIVERED' AND photo_file_id IS NOT NULL AND receiver_name_encrypted IS NOT NULL)
                OR (event_type = 'PICKED_UP' AND handover_confirmed AND receiver_name_encrypted IS NOT NULL AND receiver_kind IN ('BUYER','AUTHORIZED_RECEIVER')))",
            "ALTER TABLE fulfillment_issues ADD CONSTRAINT fulfillment_issue_check CHECK (category IN ('NOT_RECEIVED','INCOMPLETE','DAMAGED','WRONG_ITEM','LATE','ACCESS_PROBLEM','OTHER') AND state IN ('OPEN','RESOLVED')
                AND length(trim(description)) >= 10 AND (state = 'OPEN') = (resolved_at IS NULL) AND (resolution IS NULL OR resolution IN ('BUYER_RESOLVED','RECEIPT_CONFIRMED','ORDER_CANCELLED')))",
            "CREATE UNIQUE INDEX fulfillment_one_open_issue ON fulfillment_issues (order_id) WHERE state = 'OPEN'",
            "ALTER TABLE cancellation_requests ADD CONSTRAINT cancellation_request_check CHECK (kind IN ('WITHDRAWAL','BUYER_CANCELLATION','BUYER_REQUEST','VENDOR_CANCELLATION','UNPAID_CANCELLATION')
                AND source IN ('BUYER','VENDOR','SYSTEM') AND state IN ('REQUESTED','FINALIZED','WITHDRAWN','SUPERSEDED')
                AND (kind IN ('WITHDRAWAL','UNPAID_CANCELLATION') OR reason_code IS NOT NULL)
                AND (reason_code IS DISTINCT FROM 'OTHER' OR length(trim(coalesce(reason, ''))) >= 5)
                AND (state <> 'REQUESTED' OR (kind = 'BUYER_REQUEST' AND response_due_at IS NOT NULL)))",
            "CREATE UNIQUE INDEX cancellation_one_open_request ON cancellation_requests (order_id) WHERE state = 'REQUESTED'",
            'ALTER TABLE cancellation_decisions ADD CONSTRAINT cancellation_decision_unique_order UNIQUE (order_id)',
            "ALTER TABLE cancellation_decisions ADD CONSTRAINT cancellation_decision_check CHECK (state = 'APPROVED' AND cause IN ('BUYER','VENDOR') AND decided_by IN ('BUYER','VENDOR','SYSTEM')
                AND nrpc_retained_centavos >= 0 AND refund_total_centavos >= 0 AND cash_reimbursement_centavos >= 0 AND released_unpaid_centavos >= 0
                AND (cause = 'BUYER' OR nrpc_retained_centavos = 0)
                AND (nrpc_retained_centavos = 0 OR (evidence_file_id IS NOT NULL AND order_state_before IN ('PROCESSING','CANCELLATION_REQUESTED'))))",
            "ALTER TABLE refunds ADD CONSTRAINT refund_state_check CHECK (state IN ('REFUND_PENDING','REFUNDED','REFUND_FAILED') AND attempt_number >= 1 AND processing_fee_centavos >= 0
                AND (principal_centavos IS NULL OR (principal_centavos >= 0 AND principal_centavos + processing_fee_centavos = amount_centavos)))",
            "ALTER TABLE refunds ADD CONSTRAINT refund_cancellation_link_check CHECK ((trigger = 'CANCELLATION') = (cancellation_decision_id IS NOT NULL))",
            "CREATE UNIQUE INDEX refunds_one_cancellation_per_payment ON refunds (source_payment_id) WHERE trigger = 'CANCELLATION'",
            "CREATE UNIQUE INDEX refunds_one_fee_credit_per_payment ON refunds (fee_adjustment_id, source_payment_id) WHERE trigger = 'FEE_CREDIT'",
            "ALTER TABLE refund_attempts ADD CONSTRAINT refund_attempt_check CHECK (operation IN ('CREATE','RETRIEVE') AND attempt_number >= 1)",
            "ALTER TABLE refund_events ADD CONSTRAINT refund_event_check CHECK (state IN ('REFUND_PENDING','REFUNDED','REFUND_FAILED') AND source IN ('WEBHOOK','RECONCILIATION','SYSTEM','PROVIDER_RESPONSE'))",
            "ALTER TABLE physical_reimbursements ADD CONSTRAINT physical_reimbursement_confirmation_check CHECK (state <> 'REIMBURSEMENT_CONFIRMED' OR (evidence_file_id IS NOT NULL AND reimbursed_at IS NOT NULL
                AND (buyer_acknowledged_at IS NOT NULL OR (confirmed_by_user_id IS NOT NULL AND length(trim(coalesce(confirmation_reason, ''))) >= 10))))",
            'ALTER TABLE physical_reimbursements ADD CONSTRAINT physical_reimbursement_source_check CHECK (refund_id IS NOT NULL OR cancellation_decision_id IS NOT NULL)',
            // A failed or mismatched refund becomes a visible exception work item, never a silent success.
            'ALTER TABLE finance_review_items DROP CONSTRAINT finance_review_item_check',
            'ALTER TABLE finance_review_items ADD CONSTRAINT finance_review_item_check CHECK (environment IN (\'TEST\',\'DEMO\',\'LIVE\') AND kind IN ('.self::REVIEW_KINDS.",'REFUND_EXCEPTION','REFUND_MISMATCH') AND state IN ('OPEN','RESOLVED') AND (state = 'OPEN') = (resolved_at IS NULL))",
        ] as $statement) {
            DB::statement($statement);
        }

        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION prevent_phase_twelve_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Fulfillment, cancellation and refund history is append-only (%).', TG_TABLE_NAME;
END;
$$;
CREATE TRIGGER fulfillment_milestones_append_only BEFORE UPDATE OR DELETE ON fulfillment_milestones FOR EACH ROW EXECUTE FUNCTION prevent_phase_twelve_history_mutation();
CREATE TRIGGER fulfillment_proofs_append_only BEFORE UPDATE OR DELETE ON fulfillment_proofs FOR EACH ROW EXECUTE FUNCTION prevent_phase_twelve_history_mutation();
CREATE TRIGGER cancellation_decisions_append_only BEFORE UPDATE OR DELETE ON cancellation_decisions FOR EACH ROW EXECUTE FUNCTION prevent_phase_twelve_history_mutation();
CREATE TRIGGER nfr_events_append_only BEFORE UPDATE OR DELETE ON nfr_events FOR EACH ROW EXECUTE FUNCTION prevent_phase_twelve_history_mutation();
CREATE TRIGGER refund_events_append_only BEFORE UPDATE OR DELETE ON refund_events FOR EACH ROW EXECUTE FUNCTION prevent_phase_twelve_history_mutation();
CREATE TRIGGER refund_attempts_append_only BEFORE UPDATE OR DELETE ON refund_attempts FOR EACH ROW EXECUTE FUNCTION prevent_phase_twelve_history_mutation();

-- A refund instruction is never deleted and its target, source, trigger and amount never change; only its
-- provider progress (state, reference, attempt, status, failure, completion and reconciliation time) advances.
CREATE OR REPLACE FUNCTION protect_refund_instructions() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Refund instructions are retained.';
    END IF;
    IF (to_jsonb(NEW) - ARRAY['state','provider_reference','attempt_number','provider_status','failure_code','completed_at','last_reconciled_at','lock_version','updated_at'])
        IS DISTINCT FROM (to_jsonb(OLD) - ARRAY['state','provider_reference','attempt_number','provider_status','failure_code','completed_at','last_reconciled_at','lock_version','updated_at']) THEN
        RAISE EXCEPTION 'A refund instruction is immutable; create a compensating record.';
    END IF;
    IF OLD.state = 'REFUNDED' AND NEW.state <> 'REFUNDED' THEN
        RAISE EXCEPTION 'A refunded instruction is final.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER refunds_protected BEFORE UPDATE OR DELETE ON refunds FOR EACH ROW EXECUTE FUNCTION protect_refund_instructions();
SQL);
    }

    private function grantAdminPermissions(): void
    {
        $roles = DB::table('platform_roles')->whereIn('code', ['ADMIN_SUPERADMIN', 'ADMIN_ORDER_DISPUTE'])->pluck('id');
        foreach (['orders.operations.view' => 'View order fulfillment, cancellation and refund operations',
            'refunds.retry' => 'Retry a failed refund after funding or capability is resolved',
            'reimbursements.decide' => 'Record a reasoned decision on an evidenced Vendor cash reimbursement'] as $code => $description) {
            $permissionId = DB::table('permissions')->where('code', $code)->value('id');
            if ($permissionId === null) {
                $permissionId = (string) Str::uuid7();
                DB::table('permissions')->insert(['id' => $permissionId, 'code' => $code, 'description' => $description, 'created_at' => now(), 'updated_at' => now()]);
            }
            foreach ($roles as $roleId) {
                if (! DB::table('role_permissions')->where('platform_role_id', $roleId)->where('permission_id', $permissionId)->exists()) {
                    DB::table('role_permissions')->insert(['id' => (string) Str::uuid7(), 'platform_role_id' => $roleId, 'permission_id' => $permissionId, 'created_at' => now(), 'updated_at' => now()]);
                }
            }
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared(<<<'SQL'
DROP TRIGGER IF EXISTS fulfillment_milestones_append_only ON fulfillment_milestones;
DROP TRIGGER IF EXISTS fulfillment_proofs_append_only ON fulfillment_proofs;
DROP TRIGGER IF EXISTS cancellation_decisions_append_only ON cancellation_decisions;
DROP TRIGGER IF EXISTS nfr_events_append_only ON nfr_events;
DROP TRIGGER IF EXISTS refund_events_append_only ON refund_events;
DROP TRIGGER IF EXISTS refund_attempts_append_only ON refund_attempts;
DROP TRIGGER IF EXISTS refunds_protected ON refunds;
DROP FUNCTION IF EXISTS protect_refund_instructions();
DROP FUNCTION IF EXISTS prevent_phase_twelve_history_mutation();
DROP INDEX IF EXISTS fulfillment_one_open_issue;
DROP INDEX IF EXISTS cancellation_one_open_request;
DROP INDEX IF EXISTS refunds_one_cancellation_per_payment;
DROP INDEX IF EXISTS refunds_one_fee_credit_per_payment;
ALTER TABLE fulfillments DROP CONSTRAINT IF EXISTS fulfillment_state_check, DROP CONSTRAINT IF EXISTS fulfillment_pause_check;
ALTER TABLE fulfillment_milestones DROP CONSTRAINT IF EXISTS fulfillment_milestone_event_check;
ALTER TABLE fulfillment_proofs DROP CONSTRAINT IF EXISTS fulfillment_proof_requirement_check;
ALTER TABLE cancellation_requests DROP CONSTRAINT IF EXISTS cancellation_request_check;
ALTER TABLE cancellation_decisions DROP CONSTRAINT IF EXISTS cancellation_decision_unique_order, DROP CONSTRAINT IF EXISTS cancellation_decision_check;
ALTER TABLE refunds DROP CONSTRAINT IF EXISTS refund_state_check, DROP CONSTRAINT IF EXISTS refund_cancellation_link_check;
ALTER TABLE refund_attempts DROP CONSTRAINT IF EXISTS refund_attempt_check;
ALTER TABLE refund_events DROP CONSTRAINT IF EXISTS refund_event_check;
ALTER TABLE physical_reimbursements DROP CONSTRAINT IF EXISTS physical_reimbursement_confirmation_check, DROP CONSTRAINT IF EXISTS physical_reimbursement_source_check;
ALTER TABLE finance_review_items DROP CONSTRAINT IF EXISTS finance_review_item_check;
SQL);
            DB::statement("ALTER TABLE finance_review_items ADD CONSTRAINT finance_review_item_check CHECK (environment IN ('TEST','DEMO','LIVE') AND kind IN (".self::REVIEW_KINDS.") AND state IN ('OPEN','RESOLVED') AND (state = 'OPEN') = (resolved_at IS NULL))");
        }
        Schema::table('physical_reimbursements', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('order_id');
            $table->dropConstrainedForeignId('cancellation_decision_id');
            $table->dropColumn(['recorded_role', 'vendor_note', 'lock_version']);
        });
        Schema::table('refund_events', function (Blueprint $table): void {
            $table->dropUnique(['refund_id', 'attempt_number', 'state']);
            $table->dropConstrainedForeignId('webhook_event_id');
            $table->dropColumn(['attempt_number', 'from_state', 'source', 'correlation_id']);
        });
        Schema::table('refund_attempts', fn (Blueprint $table) => $table->dropColumn(['attempt_number', 'operation', 'http_status', 'provider_refund_id', 'correlation_id']));
        Schema::table('refunds', function (Blueprint $table): void {
            $table->dropIndex(['state', 'updated_at']);
            $table->dropConstrainedForeignId('cancellation_decision_id');
            $table->dropColumn(['principal_centavos', 'processing_fee_centavos', 'allocation', 'attempt_number', 'provider_status', 'last_reconciled_at', 'lock_version']);
        });
        Schema::dropIfExists('nfr_events');
        Schema::table('cancellation_decisions', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('cancellation_request_id');
            $table->dropConstrainedForeignId('evidence_file_id');
            $table->dropColumn(['cause', 'decided_by', 'decision_code', 'actor_role', 'reason_code', 'order_state_before', 'nrpc_retained_centavos', 'refund_total_centavos',
                'cash_reimbursement_centavos', 'released_unpaid_centavos', 'correlation_id']);
        });
        Schema::table('cancellation_requests', function (Blueprint $table): void {
            $table->dropIndex(['state', 'response_due_at']);
            $table->dropColumn(['kind', 'source', 'actor_role', 'reason_code', 'order_state_at_request', 'response_due_at', 'resolved_at']);
        });
        Schema::dropIfExists('fulfillment_issues');
        Schema::table('fulfillment_proofs', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('order_id');
            $table->dropConstrainedForeignId('milestone_id');
            $table->dropConstrainedForeignId('photo_file_id');
            $table->dropConstrainedForeignId('signature_file_id');
            $table->dropColumn(['receiver_name_encrypted', 'receiver_kind', 'handover_confirmed', 'vehicle_reference']);
        });
        Schema::table('fulfillment_milestones', function (Blueprint $table): void {
            $table->dropUnique(['fulfillment_id', 'dedupe_key']);
            $table->dropIndex(['order_id', 'occurred_at']);
            $table->dropConstrainedForeignId('order_id');
            $table->dropColumn(['actor_role', 'source', 'dedupe_key', 'correlation_id']);
        });
        Schema::table('fulfillments', function (Blueprint $table): void {
            $table->dropIndex(['state', 'auto_confirm_due_at']);
            $table->dropColumn(['method', 'expected_fulfillment_date', 'late_flagged_at', 'auto_confirm_due_at', 'auto_confirm_paused_at', 'auto_confirm_remaining_seconds',
                'reminder_24h_sent_at', 'reminder_2h_sent_at', 'receipt_confirmed_at', 'receipt_confirmation_source', 'lock_version']);
        });
        // Permission grants may already be referenced by immutable audit history and are retained.
    }
};
