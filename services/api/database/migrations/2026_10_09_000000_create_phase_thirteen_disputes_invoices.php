<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/**
 * Phase 13: transaction disputes with timed response, mutual resolution, Admin clarification, decision and one
 * appeal; remedy tracking; Dispute-Conclusion Refunds linked to the Case ID and decision version; recorded and
 * referred sanctions; FIN-09 Vendor invoice records, copy/correction requests, Buyer billing details and download
 * audit; and the Owner-controlled staff dispute export. Extends the Phase 1 dispute, refund, reimbursement,
 * invoice-record and data-export tables instead of duplicating them.
 *
 * Mapping to the Technical Design: `dispute_cases` is the case and its current timers; `dispute_events` is the one
 * append-only chronological timeline every surface renders; `dispute_parties`, `dispute_evidence`,
 * `dispute_responses`, `dispute_clarifications`, `dispute_decisions`, `dispute_appeals` and `dispute_remedies` keep
 * their documented names; `dispute_resolution_proposals` holds mutual-resolution offers; `enforcement_actions`
 * records sanctions that User Management Staff apply in Phase 16; `data_exports` carries the Vendor case export.
 */
return new class extends Migration
{
    private const CASE_STATES = "'OPEN_AWAITING_RESPONSE','MUTUAL_RESOLUTION','ESCALATED_ADMIN_REVIEW','AWAITING_CLARIFICATION','DECIDED','APPEAL_OPEN','RESOLVED','CLOSED_INCONCLUSIVE'";

    private const ISSUES = "'WRONG_ITEM','DEFECTIVE','INCOMPLETE_DELIVERY','LATE_OR_MISSING','MISLEADING_LISTING','PAYMENT','INVOICE','OTHER_TRANSACTION','PHYSICAL_PAYMENT_NOT_RECEIVED','PICKUP_NO_SHOW','ABUSIVE_COMMUNICATION','FALSE_EVIDENCE','INACCESSIBLE_DELIVERY_SITE'";

    private const REMEDIES = "'REPLACEMENT','FULL_REFUND','PARTIAL_REFUND','RETURN_AND_REFUND','INVOICE_CORRECTION','PAYMENT_OF_BALANCE','WARNING_ONLY','OTHER'";

    private const OUTCOMES = "'DISMISSED','REPLACEMENT','FULL_REFUND','PARTIAL_REFUND','INCONCLUSIVE','NO_FURTHER_ACTION'";

    private const EVENTS = "'CASE_FILED','RESPONSE_SUBMITTED','EVIDENCE_ADDED','MESSAGE','PROPOSAL_MADE','PROPOSAL_ACCEPTED','PROPOSAL_REJECTED','AGREEMENT_RECORDED','ESCALATED','CLARIFICATION_REQUESTED','CLARIFICATION_ANSWERED','CLARIFICATION_EXPIRED','DECISION_ISSUED','DECISION_ENFORCEABLE','APPEAL_FILED','APPEAL_DECIDED','REMEDY_CREATED','REMEDY_UPDATED','REMEDY_COMPLETED','REFUND_UPDATED','SANCTION_RECORDED','HANDLER_ASSIGNED','HANDLER_REASSIGNED','CASE_RESOLVED','CASE_CLOSED_INCONCLUSIVE','ORDER_HOLD_CHANGED'";

    public function up(): void
    {
        $this->disputes();
        $this->financialLinks();
        $this->invoices();
        if (DB::getDriverName() === 'pgsql') {
            $this->postgresRules();
        }
        $this->grantAdminPermissions();
    }

    private function disputes(): void
    {
        Schema::table('dispute_cases', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('buyer_profile_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('environment', 8)->default('TEST');
            $table->string('case_kind', 32)->default('TRANSACTION');
            $table->string('filed_by_party', 16)->nullable();
            $table->foreignId('filed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('filed_by_role', 32)->nullable();
            $table->string('responding_party', 16)->nullable();
            $table->string('order_state_at_filing', 40)->nullable();
            $table->text('description')->nullable();
            $table->bigInteger('requested_amount_centavos')->nullable();
            $table->jsonb('affected_lines')->nullable();
            $table->string('masked_payment_method', 120)->nullable();
            $table->string('preferred_contact_channel', 16)->default('IN_APP');
            $table->timestampTz('responded_at')->nullable();
            $table->timestampTz('mutual_resolution_due_at')->nullable();
            $table->timestampTz('agreement_reached_at')->nullable();
            $table->timestampTz('escalated_at')->nullable();
            $table->string('escalation_reason', 48)->nullable();
            $table->timestampTz('clarification_due_at')->nullable();
            $table->timestampTz('decided_at')->nullable();
            $table->timestampTz('appeal_due_at')->nullable();
            $table->timestampTz('concluded_at')->nullable();
            $table->foreignUuid('current_decision_id')->nullable();
            $table->foreignId('assigned_admin_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->foreignId('vendor_handler_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('vendor_handler_role', 32)->nullable();
            $table->string('remedy_state', 16)->default('NONE');
            $table->unsignedInteger('event_sequence')->default(0);
            $table->unsignedInteger('lock_version')->default(1);
            $table->index(['vendor_organization_id', 'status', 'created_at']);
            $table->index(['buyer_profile_id', 'created_at']);
            $table->index(['status', 'response_due_at']);
        });
        Schema::table('dispute_parties', function (Blueprint $table): void {
            $table->string('party', 16)->nullable();
            $table->foreignUuid('buyer_profile_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $table->unique(['dispute_case_id', 'party']);
        });
        Schema::create('dispute_events', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('dispute_case_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('sequence');
            $table->string('event_type', 40);
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('actor_role', 48)->nullable();
            $table->string('actor_party', 16);
            $table->text('body')->nullable();
            $table->jsonb('payload')->nullable();
            $table->string('correlation_id', 64)->nullable();
            $table->timestampTz('occurred_at');
            $table->timestampTz('created_at');
            $table->unique(['dispute_case_id', 'sequence']);
        });
        Schema::table('dispute_evidence', function (Blueprint $table): void {
            $table->foreignUuid('file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->foreignUuid('dispute_event_id')->nullable()->constrained('dispute_events')->restrictOnDelete();
            $table->string('party', 16)->nullable();
            $table->string('actor_role', 48)->nullable();
            $table->string('label', 24)->nullable();
            $table->text('description')->nullable();
            $table->index(['dispute_case_id', 'created_at']);
        });
        Schema::table('dispute_responses', function (Blueprint $table): void {
            $table->string('party', 16)->nullable();
            $table->string('actor_role', 48)->nullable();
            $table->string('position', 32)->nullable();
            $table->text('body')->nullable();
            $table->foreignUuid('dispute_event_id')->nullable()->constrained('dispute_events')->restrictOnDelete();
        });
        Schema::create('dispute_resolution_proposals', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('dispute_case_id')->constrained()->restrictOnDelete();
            $table->string('proposed_by_party', 16);
            $table->foreignId('proposed_by_user_id')->constrained('users')->restrictOnDelete();
            $table->string('proposed_by_role', 48);
            $table->string('remedy', 32);
            $table->bigInteger('amount_centavos')->nullable();
            $table->text('terms');
            $table->string('state', 16)->default('PROPOSED');
            $table->foreignId('answered_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('answered_by_role', 48)->nullable();
            $table->timestampTz('answered_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->timestampsTz();
            $table->index(['dispute_case_id', 'state']);
        });
        Schema::table('dispute_clarifications', function (Blueprint $table): void {
            $table->uuid('request_group_id')->nullable();
            $table->string('requested_party', 16)->nullable();
            $table->text('question')->nullable();
            $table->timestampTz('due_at')->nullable();
            $table->text('response')->nullable();
            $table->foreignId('responded_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('responded_role', 48)->nullable();
            $table->timestampTz('responded_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->index(['state', 'due_at']);
        });
        Schema::table('dispute_decisions', function (Blueprint $table): void {
            $table->unsignedSmallInteger('version')->default(1);
            $table->string('kind', 24)->nullable();
            $table->string('outcome', 32)->nullable();
            $table->string('appeal_result', 16)->nullable();
            $table->text('reason')->nullable();
            $table->text('evidence_limitation')->nullable();
            $table->string('actor_role', 48)->nullable();
            $table->jsonb('sanctions')->nullable();
            $table->jsonb('allocation')->nullable();
            $table->boolean('conflict_check_confirmed')->default(false);
            $table->foreignUuid('supersedes_decision_id')->nullable()->constrained('dispute_decisions')->restrictOnDelete();
            $table->foreignUuid('dispute_proposal_id')->nullable()->unique()->constrained('dispute_resolution_proposals')->restrictOnDelete();
            $table->timestampTz('appeal_due_at')->nullable();
            $table->string('correlation_id', 64)->nullable();
            $table->unique(['dispute_case_id', 'version']);
        });
        Schema::table('dispute_cases', fn (Blueprint $table) => $table->foreign('current_decision_id')->references('id')->on('dispute_decisions')->restrictOnDelete());
        Schema::table('dispute_appeals', function (Blueprint $table): void {
            $table->foreignUuid('appealed_decision_id')->nullable()->constrained('dispute_decisions')->restrictOnDelete();
            $table->foreignUuid('result_decision_id')->nullable()->unique()->constrained('dispute_decisions')->restrictOnDelete();
            $table->string('appellant_party', 16)->nullable();
            $table->string('appellant_role', 48)->nullable();
            $table->string('grounds', 32)->nullable();
            $table->text('statement')->nullable();
            $table->timestampTz('decided_at')->nullable();
            $table->unique('dispute_case_id');
        });
        Schema::table('dispute_remedies', function (Blueprint $table): void {
            $table->foreignUuid('dispute_decision_id')->nullable()->constrained('dispute_decisions')->restrictOnDelete();
            $table->string('kind', 32)->nullable();
            $table->bigInteger('amount_centavos')->default(0);
            $table->string('dedupe_key', 160)->nullable()->unique();
            $table->text('note')->nullable();
            $table->foreignUuid('evidence_file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->foreignId('recorded_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('recorded_role', 48)->nullable();
            $table->timestampTz('completed_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });
        Schema::create('enforcement_actions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('dispute_case_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('dispute_decision_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('subject_type', 32);
            $table->uuid('subject_id');
            $table->string('action', 32);
            $table->string('state', 16);
            $table->text('reason');
            $table->string('scope', 160);
            $table->unsignedSmallInteger('duration_days')->nullable();
            $table->text('restoration_condition')->nullable();
            $table->timestampTz('effective_at')->nullable();
            $table->foreignId('issued_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('issued_role', 48)->nullable();
            $table->string('environment', 8)->default('TEST');
            $table->timestampsTz();
            $table->unique(['dispute_decision_id', 'subject_type', 'action']);
            $table->index(['subject_type', 'subject_id', 'created_at']);
        });
        Schema::table('data_exports', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('requested_role', 48)->nullable();
            $table->unsignedInteger('row_count')->nullable();
            $table->timestampTz('completed_at')->nullable();
            $table->timestampTz('revoked_at')->nullable();
            $table->string('revocation_reason', 64)->nullable();
            $table->index(['vendor_organization_id', 'export_type', 'created_at']);
        });
    }

    private function financialLinks(): void
    {
        Schema::table('refunds', function (Blueprint $table): void {
            $table->foreignUuid('dispute_case_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('dispute_decision_id')->nullable()->constrained()->restrictOnDelete();
        });
        Schema::table('physical_reimbursements', function (Blueprint $table): void {
            $table->foreignUuid('dispute_decision_id')->nullable()->unique()->constrained()->restrictOnDelete();
        });
    }

    private function invoices(): void
    {
        Schema::table('invoice_records', function (Blueprint $table): void {
            $table->string('invoice_number_display', 64)->nullable();
            $table->foreignId('uploaded_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('uploaded_role', 48)->nullable();
            $table->jsonb('tax_breakdown')->nullable();
            $table->jsonb('related_line_ids')->nullable();
            $table->string('source_system', 32)->nullable();
            $table->string('invoicing_method', 32)->nullable();
            $table->string('e_invoicing_coverage', 32)->default('REVIEW_REQUIRED');
            $table->foreignUuid('amends_invoice_record_id')->nullable()->constrained('invoice_records')->restrictOnDelete();
            $table->bigInteger('expected_total_centavos')->nullable();
            $table->bigInteger('reconciliation_difference_centavos')->default(0);
            $table->string('reconciliation_state', 40)->default('NOT_APPLICABLE');
            $table->text('reconciliation_note')->nullable();
            $table->foreignId('reconciliation_noted_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('reconciliation_noted_at')->nullable();
            $table->uuid('invoice_request_id')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->index(['order_id', 'created_at']);
        });
        Schema::create('invoice_requests', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->string('kind', 16);
            $table->string('state', 32)->default('REQUESTED');
            $table->text('details')->nullable();
            $table->foreignUuid('invoice_record_id')->nullable()->constrained('invoice_records')->restrictOnDelete();
            $table->foreignUuid('fulfilled_invoice_record_id')->nullable()->constrained('invoice_records')->restrictOnDelete();
            $table->foreignId('requested_by_user_id')->constrained('users')->restrictOnDelete();
            $table->timestampTz('service_target_at');
            $table->timestampTz('reminder_sent_at')->nullable();
            $table->timestampTz('overdue_notified_at')->nullable();
            $table->timestampTz('uploaded_at')->nullable();
            $table->timestampTz('downloaded_at')->nullable();
            $table->timestampTz('closed_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->timestampsTz();
            $table->index(['vendor_organization_id', 'state', 'service_target_at']);
        });
        Schema::table('invoice_records', fn (Blueprint $table) => $table->foreign('invoice_request_id')->references('id')->on('invoice_requests')->restrictOnDelete());
        Schema::create('order_invoice_details', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_id')->unique()->constrained()->restrictOnDelete();
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->string('billing_name', 180);
            $table->text('billing_address');
            $table->text('tin_encrypted')->nullable();
            $table->string('tin_last4', 4)->nullable();
            $table->foreignId('updated_by_user_id')->constrained('users')->restrictOnDelete();
            $table->unsignedInteger('lock_version')->default(1);
            $table->timestampsTz();
        });
        Schema::create('invoice_record_downloads', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('invoice_record_id')->constrained()->restrictOnDelete();
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->string('audience', 16);
            $table->string('actor_role', 48)->nullable();
            $table->string('correlation_id', 64)->nullable();
            $table->timestampTz('created_at');
            $table->index(['invoice_record_id', 'created_at']);
        });
    }

    private function postgresRules(): void
    {
        foreach ([
            'ALTER TABLE dispute_cases ADD CONSTRAINT dispute_case_state_check CHECK (status IN ('.self::CASE_STATES.") AND case_kind IN ('TRANSACTION','POST_COMPLETION_RETURN')
                AND filed_by_party IN ('BUYER','VENDOR') AND responding_party IN ('BUYER','VENDOR') AND filed_by_party <> responding_party
                AND issue_type IN (".self::ISSUES.') AND requested_remedy IN ('.self::REMEDIES.")
                AND (requested_amount_centavos IS NULL OR requested_amount_centavos > 0) AND (requested_remedy <> 'PARTIAL_REFUND' OR requested_amount_centavos IS NOT NULL)
                AND remedy_state IN ('NONE','PENDING','COMPLETED','FAILED') AND preferred_contact_channel IN ('IN_APP','EMAIL')
                AND length(trim(coalesce(description, ''))) >= 20)",
            // One active case per order: a duplicate filing is linked to the open case instead of creating another.
            "CREATE UNIQUE INDEX dispute_one_active_case ON dispute_cases (order_id) WHERE status NOT IN ('RESOLVED','CLOSED_INCONCLUSIVE')",
            "ALTER TABLE dispute_parties ADD CONSTRAINT dispute_party_check CHECK (party IN ('BUYER','VENDOR') AND ((party = 'BUYER') = (buyer_profile_id IS NOT NULL)) AND ((party = 'VENDOR') = (vendor_organization_id IS NOT NULL)))",
            'ALTER TABLE dispute_events ADD CONSTRAINT dispute_event_check CHECK (event_type IN ('.self::EVENTS.") AND actor_party IN ('BUYER','VENDOR','ADMIN','SYSTEM') AND sequence >= 1)",
            "ALTER TABLE dispute_evidence ADD CONSTRAINT dispute_evidence_check CHECK (file_id IS NOT NULL AND party IN ('BUYER','VENDOR') AND label IN ('ORIGINAL','SUPPLEMENTAL','RESPONSE','CLARIFICATION','APPEAL','FULFILLMENT','REMEDY'))",
            "ALTER TABLE dispute_responses ADD CONSTRAINT dispute_response_check CHECK (party IN ('BUYER','VENDOR') AND position IN ('ACCEPT_REQUEST','OFFER_REPLACEMENT','OFFER_REFUND','REJECT_WITH_EVIDENCE','REQUEST_ADMIN_REVIEW') AND length(trim(coalesce(body, ''))) >= 10)",
            'CREATE UNIQUE INDEX dispute_one_response ON dispute_responses (dispute_case_id)',
            "ALTER TABLE dispute_resolution_proposals ADD CONSTRAINT dispute_proposal_check CHECK (proposed_by_party IN ('BUYER','VENDOR') AND remedy IN ('REPLACEMENT','FULL_REFUND','PARTIAL_REFUND','NO_FURTHER_ACTION')
                AND state IN ('PROPOSED','ACCEPTED','REJECTED','SUPERSEDED','EXPIRED') AND (remedy <> 'PARTIAL_REFUND' OR amount_centavos > 0) AND (remedy = 'PARTIAL_REFUND' OR amount_centavos IS NULL)
                AND length(trim(terms)) >= 10 AND ((state IN ('ACCEPTED','REJECTED')) = (answered_at IS NOT NULL)))",
            "CREATE UNIQUE INDEX dispute_one_open_proposal_per_party ON dispute_resolution_proposals (dispute_case_id, proposed_by_party) WHERE state = 'PROPOSED'",
            "ALTER TABLE dispute_clarifications ADD CONSTRAINT dispute_clarification_check CHECK (requested_party IN ('BUYER','VENDOR') AND state IN ('OPEN','ANSWERED','EXPIRED') AND due_at IS NOT NULL
                AND length(trim(coalesce(question, ''))) >= 10 AND ((state = 'ANSWERED') = (responded_at IS NOT NULL)))",
            "CREATE UNIQUE INDEX dispute_one_open_clarification_per_party ON dispute_clarifications (dispute_case_id, requested_party) WHERE state = 'OPEN'",
            "ALTER TABLE dispute_decisions ADD CONSTRAINT dispute_decision_check CHECK (kind IN ('ADMIN_DECISION','APPEAL_DECISION','MUTUAL_AGREEMENT') AND outcome IN (".self::OUTCOMES.")
                AND awarded_centavos >= 0 AND (outcome IN ('FULL_REFUND','PARTIAL_REFUND')) = (awarded_centavos > 0)
                AND (kind = 'MUTUAL_AGREEMENT' OR (conflict_check_confirmed AND length(trim(coalesce(reason, ''))) >= 20))
                AND (kind <> 'APPEAL_DECISION' OR appeal_result IN ('AFFIRMED','MODIFIED','REVERSED')) AND (kind = 'APPEAL_DECISION' OR appeal_result IS NULL)
                AND (kind <> 'MUTUAL_AGREEMENT' OR dispute_proposal_id IS NOT NULL) AND version >= 1)",
            "ALTER TABLE dispute_appeals ADD CONSTRAINT dispute_appeal_check CHECK (appellant_party IN ('BUYER','VENDOR') AND grounds IN ('NEW_EVIDENCE','MATERIAL_PROCESS_ERROR') AND state IN ('OPEN','DECIDED')
                AND length(trim(coalesce(statement, ''))) >= 20 AND ((state = 'DECIDED') = (result_decision_id IS NOT NULL)))",
            "ALTER TABLE dispute_remedies ADD CONSTRAINT dispute_remedy_check CHECK (kind IN ('ONLINE_REFUND','CASH_REIMBURSEMENT','REPLACEMENT','FEE_CREDIT_REVIEW','ORDER_CANCELLATION') AND state IN ('PENDING','COMPLETED','FAILED') AND amount_centavos >= 0
                AND ((state = 'COMPLETED') = (completed_at IS NOT NULL)))",
            "ALTER TABLE enforcement_actions ADD CONSTRAINT enforcement_action_check CHECK (subject_type IN ('VENDOR_ORGANIZATION','BUYER') AND action IN ('WARNING','TEMPORARY_RESTRICTION','SUSPENSION','PERMANENT_BAN')
                AND state IN ('EFFECTIVE','REFERRED','APPLIED','LIFTED') AND length(trim(reason)) >= 10 AND (action <> 'TEMPORARY_RESTRICTION' OR duration_days > 0)
                AND (action = 'WARNING' OR restoration_condition IS NOT NULL OR action = 'PERMANENT_BAN'))",
            // DISPUTE_CONCLUSION refunds always carry the Case ID and decision version; one per decision and original payment.
            "ALTER TABLE refunds ADD CONSTRAINT refund_dispute_link_check CHECK ((trigger = 'DISPUTE_CONCLUSION') = (dispute_decision_id IS NOT NULL AND dispute_case_id IS NOT NULL))",
            "CREATE UNIQUE INDEX refunds_one_dispute_award_per_payment ON refunds (dispute_decision_id, source_payment_id) WHERE trigger = 'DISPUTE_CONCLUSION'",
            'ALTER TABLE physical_reimbursements DROP CONSTRAINT physical_reimbursement_source_check',
            'ALTER TABLE physical_reimbursements ADD CONSTRAINT physical_reimbursement_source_check CHECK ((refund_id IS NOT NULL)::int + (cancellation_decision_id IS NOT NULL)::int + (dispute_decision_id IS NOT NULL)::int >= 1)',
            // A dispute conclusion may now complete an order that waited in DISPUTED for its remedy.
            'ALTER TABLE fulfillments DROP CONSTRAINT fulfillment_state_check',
            "ALTER TABLE fulfillments ADD CONSTRAINT fulfillment_state_check CHECK (state IN ('NOT_STARTED','PROCESSING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','PICKED_UP','COMPLETED','CANCELLED') AND (method IS NULL OR method IN ('DELIVERY','PICKUP')) AND (receipt_confirmation_source IS NULL OR receipt_confirmation_source IN ('BUYER','AUTO_CONFIRMATION','DISPUTE_CONCLUSION')))",
            "ALTER TABLE invoice_records ADD CONSTRAINT invoice_record_type_check CHECK (invoice_type IN ('VENDOR_GOODS_INVOICE','VENDOR_ADJUSTMENT_DOCUMENT','PLATFORM_SERVICE_INVOICE','PROCESSOR_INVOICE')
                AND document_origin IN ('DEMO_SAMPLE','VENDOR_REGISTERED_PROCESS','PLATFORM_SAMPLE') AND (environment = 'LIVE' OR document_origin <> 'VENDOR_REGISTERED_PROCESS')
                AND verification_state IN ('UNVERIFIED','VERIFIED','REJECTED') AND e_invoicing_coverage IN ('REVIEW_REQUIRED','COVERED','NOT_COVERED','EXEMPT_MICRO')
                AND reconciliation_state IN ('NOT_APPLICABLE','MATCHED','INVOICE_RECONCILIATION_REQUIRED','EXPLAINED','CORRECTED')
                AND (invoice_type <> 'VENDOR_ADJUSTMENT_DOCUMENT' OR amends_invoice_record_id IS NOT NULL))",
            "ALTER TABLE invoice_requests ADD CONSTRAINT invoice_request_check CHECK (kind IN ('COPY','CORRECTION') AND state IN ('REQUESTED','UPLOADED','DOWNLOADED','RETURNED_FOR_CORRECTION','CLOSED')
                AND (kind = 'COPY' OR invoice_record_id IS NOT NULL) AND ((state = 'CLOSED') = (closed_at IS NOT NULL)))",
            "CREATE UNIQUE INDEX invoice_one_open_request ON invoice_requests (order_id, kind) WHERE state <> 'CLOSED'",
            "ALTER TABLE invoice_record_downloads ADD CONSTRAINT invoice_download_audience_check CHECK (audience IN ('BUYER','VENDOR','ADMIN'))",
            "ALTER TABLE data_exports ADD CONSTRAINT data_export_state_check CHECK (state IN ('QUEUED','READY','REVOKED','FAILED','EXPIRED'))",
        ] as $statement) {
            DB::statement($statement);
        }

        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION prevent_phase_thirteen_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Dispute evidence, decisions and timeline are append-only (%).', TG_TABLE_NAME;
END;
$$;
CREATE TRIGGER dispute_events_append_only BEFORE UPDATE OR DELETE ON dispute_events FOR EACH ROW EXECUTE FUNCTION prevent_phase_thirteen_history_mutation();
CREATE TRIGGER dispute_evidence_append_only BEFORE UPDATE OR DELETE ON dispute_evidence FOR EACH ROW EXECUTE FUNCTION prevent_phase_thirteen_history_mutation();
CREATE TRIGGER dispute_decisions_append_only BEFORE UPDATE OR DELETE ON dispute_decisions FOR EACH ROW EXECUTE FUNCTION prevent_phase_thirteen_history_mutation();
CREATE TRIGGER dispute_responses_append_only BEFORE UPDATE OR DELETE ON dispute_responses FOR EACH ROW EXECUTE FUNCTION prevent_phase_thirteen_history_mutation();
CREATE TRIGGER invoice_record_downloads_append_only BEFORE UPDATE OR DELETE ON invoice_record_downloads FOR EACH ROW EXECUTE FUNCTION prevent_phase_thirteen_history_mutation();

-- Proposals, clarifications, appeals and remedies keep their original content; only their progress fields advance.
CREATE OR REPLACE FUNCTION protect_phase_thirteen_progress() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
    progress text[] := CASE TG_TABLE_NAME
        WHEN 'dispute_resolution_proposals' THEN ARRAY['state','answered_by_user_id','answered_by_role','answered_at','lock_version','updated_at']
        WHEN 'dispute_clarifications' THEN ARRAY['state','response','responded_by_user_id','responded_role','responded_at','lock_version','updated_at']
        WHEN 'dispute_appeals' THEN ARRAY['state','result_decision_id','decided_at','updated_at']
        WHEN 'dispute_remedies' THEN ARRAY['state','note','evidence_file_id','recorded_by_user_id','recorded_role','completed_at','lock_version','updated_at']
        ELSE ARRAY['updated_at'] END;
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Dispute records are retained (%).', TG_TABLE_NAME;
    END IF;
    IF (to_jsonb(NEW) - progress) IS DISTINCT FROM (to_jsonb(OLD) - progress) THEN
        RAISE EXCEPTION 'A submitted dispute record is immutable; append a new record (%).', TG_TABLE_NAME;
    END IF;
    IF TG_TABLE_NAME = 'dispute_remedies' AND OLD.state = 'COMPLETED' AND NEW.state <> 'COMPLETED' THEN
        RAISE EXCEPTION 'A completed remedy is final.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER dispute_resolution_proposals_protected BEFORE UPDATE OR DELETE ON dispute_resolution_proposals FOR EACH ROW EXECUTE FUNCTION protect_phase_thirteen_progress();
CREATE TRIGGER dispute_clarifications_protected BEFORE UPDATE OR DELETE ON dispute_clarifications FOR EACH ROW EXECUTE FUNCTION protect_phase_thirteen_progress();
CREATE TRIGGER dispute_appeals_protected BEFORE UPDATE OR DELETE ON dispute_appeals FOR EACH ROW EXECUTE FUNCTION protect_phase_thirteen_progress();
CREATE TRIGGER dispute_remedies_protected BEFORE UPDATE OR DELETE ON dispute_remedies FOR EACH ROW EXECUTE FUNCTION protect_phase_thirteen_progress();

-- An uploaded invoice copy keeps its document facts; only verification and reconciliation notes may advance.
CREATE OR REPLACE FUNCTION protect_invoice_records() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
    progress text[] := ARRAY['verification_state','verified_by_user_id','verified_at','reconciliation_state','reconciliation_note','reconciliation_noted_by_user_id','reconciliation_noted_at','lock_version','updated_at'];
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Invoice records are retained.';
    END IF;
    IF (to_jsonb(NEW) - progress) IS DISTINCT FROM (to_jsonb(OLD) - progress) THEN
        RAISE EXCEPTION 'An invoice record is immutable; upload a correction that references it.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER invoice_records_protected BEFORE UPDATE OR DELETE ON invoice_records FOR EACH ROW EXECUTE FUNCTION protect_invoice_records();
SQL);
    }

    private function grantAdminPermissions(): void
    {
        $grants = [
            'disputes.view' => ['Investigate dispute cases, evidence and remedies', ['ADMIN_SUPERADMIN', 'ADMIN_ORDER_DISPUTE']],
            'disputes.decide' => ['Escalate, request clarification, decide and review appeals of dispute cases', ['ADMIN_SUPERADMIN', 'ADMIN_ORDER_DISPUTE']],
            'invoices.view' => ['Read the invoice request log and authorized invoice records', ['ADMIN_SUPERADMIN', 'ADMIN_ORDER_DISPUTE']],
        ];
        foreach ($grants as $code => [$description, $roleCodes]) {
            $permissionId = DB::table('permissions')->where('code', $code)->value('id');
            if ($permissionId === null) {
                $permissionId = (string) Str::uuid7();
                DB::table('permissions')->insert(['id' => $permissionId, 'code' => $code, 'description' => $description, 'created_at' => now(), 'updated_at' => now()]);
            }
            foreach (DB::table('platform_roles')->whereIn('code', $roleCodes)->pluck('id') as $roleId) {
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
DROP TRIGGER IF EXISTS dispute_events_append_only ON dispute_events;
DROP TRIGGER IF EXISTS dispute_evidence_append_only ON dispute_evidence;
DROP TRIGGER IF EXISTS dispute_decisions_append_only ON dispute_decisions;
DROP TRIGGER IF EXISTS dispute_responses_append_only ON dispute_responses;
DROP TRIGGER IF EXISTS invoice_record_downloads_append_only ON invoice_record_downloads;
DROP TRIGGER IF EXISTS dispute_resolution_proposals_protected ON dispute_resolution_proposals;
DROP TRIGGER IF EXISTS dispute_clarifications_protected ON dispute_clarifications;
DROP TRIGGER IF EXISTS dispute_appeals_protected ON dispute_appeals;
DROP TRIGGER IF EXISTS dispute_remedies_protected ON dispute_remedies;
DROP TRIGGER IF EXISTS invoice_records_protected ON invoice_records;
DROP FUNCTION IF EXISTS protect_invoice_records();
DROP FUNCTION IF EXISTS protect_phase_thirteen_progress();
DROP FUNCTION IF EXISTS prevent_phase_thirteen_history_mutation();
DROP INDEX IF EXISTS dispute_one_active_case;
DROP INDEX IF EXISTS dispute_one_response;
DROP INDEX IF EXISTS dispute_one_open_proposal_per_party;
DROP INDEX IF EXISTS dispute_one_open_clarification_per_party;
DROP INDEX IF EXISTS refunds_one_dispute_award_per_payment;
DROP INDEX IF EXISTS invoice_one_open_request;
ALTER TABLE dispute_cases DROP CONSTRAINT IF EXISTS dispute_case_state_check;
ALTER TABLE dispute_parties DROP CONSTRAINT IF EXISTS dispute_party_check;
ALTER TABLE dispute_evidence DROP CONSTRAINT IF EXISTS dispute_evidence_check;
ALTER TABLE dispute_responses DROP CONSTRAINT IF EXISTS dispute_response_check;
ALTER TABLE dispute_clarifications DROP CONSTRAINT IF EXISTS dispute_clarification_check;
ALTER TABLE dispute_decisions DROP CONSTRAINT IF EXISTS dispute_decision_check;
ALTER TABLE dispute_appeals DROP CONSTRAINT IF EXISTS dispute_appeal_check;
ALTER TABLE dispute_remedies DROP CONSTRAINT IF EXISTS dispute_remedy_check;
ALTER TABLE refunds DROP CONSTRAINT IF EXISTS refund_dispute_link_check;
ALTER TABLE invoice_records DROP CONSTRAINT IF EXISTS invoice_record_type_check;
ALTER TABLE data_exports DROP CONSTRAINT IF EXISTS data_export_state_check;
ALTER TABLE physical_reimbursements DROP CONSTRAINT IF EXISTS physical_reimbursement_source_check;
ALTER TABLE fulfillments DROP CONSTRAINT IF EXISTS fulfillment_state_check;
SQL);
            DB::statement('ALTER TABLE physical_reimbursements ADD CONSTRAINT physical_reimbursement_source_check CHECK (refund_id IS NOT NULL OR cancellation_decision_id IS NOT NULL)');
            DB::statement("ALTER TABLE fulfillments ADD CONSTRAINT fulfillment_state_check CHECK (state IN ('NOT_STARTED','PROCESSING','READY_FOR_PICKUP','OUT_FOR_DELIVERY','DELIVERED','PICKED_UP','COMPLETED','CANCELLED') AND (method IS NULL OR method IN ('DELIVERY','PICKUP')) AND (receipt_confirmation_source IS NULL OR receipt_confirmation_source IN ('BUYER','AUTO_CONFIRMATION')))");
        }
        Schema::table('invoice_records', fn (Blueprint $table) => $table->dropForeign(['invoice_request_id']));
        Schema::dropIfExists('invoice_record_downloads');
        Schema::dropIfExists('order_invoice_details');
        Schema::dropIfExists('invoice_requests');
        Schema::table('invoice_records', function (Blueprint $table): void {
            $table->dropIndex(['order_id', 'created_at']);
            $table->dropConstrainedForeignId('uploaded_by_user_id');
            $table->dropConstrainedForeignId('amends_invoice_record_id');
            $table->dropConstrainedForeignId('reconciliation_noted_by_user_id');
            $table->dropColumn(['invoice_number_display', 'uploaded_role', 'tax_breakdown', 'related_line_ids', 'source_system', 'invoicing_method', 'e_invoicing_coverage', 'expected_total_centavos',
                'reconciliation_difference_centavos', 'reconciliation_state', 'reconciliation_note', 'reconciliation_noted_at', 'invoice_request_id', 'lock_version']);
        });
        Schema::table('physical_reimbursements', fn (Blueprint $table) => $table->dropConstrainedForeignId('dispute_decision_id'));
        Schema::table('refunds', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('dispute_decision_id');
            $table->dropConstrainedForeignId('dispute_case_id');
        });
        Schema::table('data_exports', function (Blueprint $table): void {
            $table->dropIndex(['vendor_organization_id', 'export_type', 'created_at']);
            $table->dropConstrainedForeignId('vendor_organization_id');
            $table->dropColumn(['requested_role', 'row_count', 'completed_at', 'revoked_at', 'revocation_reason']);
        });
        Schema::dropIfExists('enforcement_actions');
        Schema::table('dispute_remedies', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('dispute_decision_id');
            $table->dropConstrainedForeignId('evidence_file_id');
            $table->dropConstrainedForeignId('recorded_by_user_id');
            $table->dropUnique(['dedupe_key']);
            $table->dropColumn(['kind', 'amount_centavos', 'dedupe_key', 'note', 'recorded_role', 'completed_at', 'lock_version']);
        });
        Schema::table('dispute_appeals', function (Blueprint $table): void {
            $table->dropUnique(['dispute_case_id']);
            $table->dropConstrainedForeignId('appealed_decision_id');
            $table->dropConstrainedForeignId('result_decision_id');
            $table->dropColumn(['appellant_party', 'appellant_role', 'grounds', 'statement', 'decided_at']);
        });
        Schema::table('dispute_cases', fn (Blueprint $table) => $table->dropForeign(['current_decision_id']));
        Schema::table('dispute_decisions', function (Blueprint $table): void {
            $table->dropUnique(['dispute_case_id', 'version']);
            $table->dropConstrainedForeignId('supersedes_decision_id');
            $table->dropConstrainedForeignId('dispute_proposal_id');
            $table->dropColumn(['version', 'kind', 'outcome', 'appeal_result', 'reason', 'evidence_limitation', 'actor_role', 'sanctions', 'allocation', 'conflict_check_confirmed', 'appeal_due_at', 'correlation_id']);
        });
        Schema::table('dispute_clarifications', function (Blueprint $table): void {
            $table->dropIndex(['state', 'due_at']);
            $table->dropConstrainedForeignId('responded_by_user_id');
            $table->dropColumn(['request_group_id', 'requested_party', 'question', 'due_at', 'response', 'responded_role', 'responded_at', 'lock_version']);
        });
        Schema::dropIfExists('dispute_resolution_proposals');
        Schema::table('dispute_responses', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('dispute_event_id');
            $table->dropColumn(['party', 'actor_role', 'position', 'body']);
        });
        Schema::table('dispute_evidence', function (Blueprint $table): void {
            $table->dropIndex(['dispute_case_id', 'created_at']);
            $table->dropConstrainedForeignId('file_id');
            $table->dropConstrainedForeignId('dispute_event_id');
            $table->dropColumn(['party', 'actor_role', 'label', 'description']);
        });
        Schema::dropIfExists('dispute_events');
        Schema::table('dispute_parties', function (Blueprint $table): void {
            $table->dropUnique(['dispute_case_id', 'party']);
            $table->dropConstrainedForeignId('buyer_profile_id');
            $table->dropConstrainedForeignId('vendor_organization_id');
            $table->dropColumn('party');
        });
        Schema::table('dispute_cases', function (Blueprint $table): void {
            $table->dropIndex(['vendor_organization_id', 'status', 'created_at']);
            $table->dropIndex(['buyer_profile_id', 'created_at']);
            $table->dropIndex(['status', 'response_due_at']);
            foreach (['vendor_organization_id', 'buyer_profile_id', 'filed_by_user_id', 'assigned_admin_user_id', 'vendor_handler_user_id'] as $foreign) {
                $table->dropConstrainedForeignId($foreign);
            }
            $table->dropColumn(['environment', 'case_kind', 'filed_by_party', 'filed_by_role', 'responding_party', 'order_state_at_filing', 'description', 'requested_amount_centavos',
                'affected_lines', 'masked_payment_method', 'preferred_contact_channel', 'responded_at', 'mutual_resolution_due_at', 'agreement_reached_at', 'escalated_at', 'escalation_reason',
                'clarification_due_at', 'decided_at', 'appeal_due_at', 'concluded_at', 'current_decision_id', 'vendor_handler_role', 'remedy_state', 'event_sequence', 'lock_version']);
        });
        // Permission grants may already be referenced by immutable audit history and are retained.
    }
};
