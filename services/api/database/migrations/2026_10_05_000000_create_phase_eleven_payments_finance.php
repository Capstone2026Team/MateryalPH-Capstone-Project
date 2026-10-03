<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/**
 * Phase 11: Xendit TEST checkout payments, Buyer processing-fee snapshots, payment purposes, the verified webhook
 * inbox, reconciliation and technical compensation, plus the FIN-04A gross-remittance threshold counter, FIN-05
 * remittance assessment snapshots, FIN-03 statements and platform-fee payments, physical-payment obligations and
 * finance review work items. Extends the Phase 1 payment/finance tables instead of duplicating them.
 *
 * Mapping to the Technical Design: one `payments` row is one payment attempt (one provider session);
 * `payment_attempts` is its provider-call log; `webhook_events` is the inbox; `finance_review_items` holds
 * reconciliation exceptions, overlap and adjustment work; FIN-04A `taxpayer_key` stores the keyed taxpayer
 * hash already used by `vendor_tax_profile_versions.taxpayer_key_hash`, never a raw TIN.
 */
return new class extends Migration
{
    public function up(): void
    {
        $this->channelFees();
        $this->vendorSettingsAndAccounts();
        $this->payments();
        $this->webhookInbox();
        $this->withholdingThreshold();
        $this->remittance();
        $this->statementsAndObligations();
        $this->reviewItems();

        if (DB::getDriverName() === 'pgsql') {
            $this->postgresRules();
        }
        $this->seedChannelFees();
    }

    private function channelFees(): void
    {
        Schema::create('payment_channel_fee_versions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->string('environment', 8)->default('TEST');
            $table->string('channel_code', 32);
            $table->unsignedInteger('version');
            $table->string('display_name', 120);
            $table->string('channel_kind', 24);
            $table->string('provider_channel_code', 48);
            $table->unsignedInteger('rate_ppm')->default(0);
            $table->bigInteger('fixed_centavos')->default(0);
            $table->unsignedInteger('fee_vat_basis_points')->default(1200);
            $table->boolean('rate_includes_vat')->default(false);
            $table->string('fee_bearer', 16)->default('BUYER');
            $table->boolean('refund_supported');
            $table->boolean('enabled');
            $table->string('disabled_reason', 64)->nullable();
            $table->bigInteger('minimum_amount_centavos')->nullable();
            $table->bigInteger('maximum_amount_centavos')->nullable();
            $table->string('rounding_basis', 48)->default('HALF_UP_PER_COMPONENT');
            $table->string('source_type', 40);
            $table->text('source_reference');
            $table->timestampTz('effective_from');
            $table->timestampTz('effective_until')->nullable();
            $table->timestampTz('created_at');
            $table->unique(['environment', 'channel_code', 'version']);
        });
    }

    private function vendorSettingsAndAccounts(): void
    {
        Schema::create('vendor_payment_settings', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->unique()->constrained()->restrictOnDelete();
            $table->boolean('cod_enabled')->default(false);
            $table->boolean('in_store_enabled')->default(false);
            $table->unsignedInteger('lock_version')->default(1);
            $table->foreignId('updated_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampsTz();
        });
        Schema::table('vendor_payment_accounts', function (Blueprint $table): void {
            // The Phase 3D association was provisioned and reconciled through the Accounts v2 contract.
            $table->string('provider_api_version', 48)->default('XENDIT_ACCOUNTS_V2');
        });
        Schema::table('orders', function (Blueprint $table): void {
            $table->timestampTz('online_balance_approved_at')->nullable();
            $table->foreignId('online_balance_approved_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
        });
    }

    private function payments(): void
    {
        Schema::table('payments', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('buyer_profile_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('financial_snapshot_id')->nullable()->constrained()->restrictOnDelete();
            $table->unsignedSmallInteger('attempt_number')->default(1);
            $table->string('account_scope', 24)->default('VENDOR_SUB_ACCOUNT');
            $table->string('provider_account_id', 128)->nullable();
            $table->string('account_contract_version', 48)->nullable();
            $table->string('provider_api_version', 48)->nullable();
            $table->string('gateway_mode', 24)->default('XENDIT_TEST');
            $table->string('evidence_origin', 24)->default('XENDIT_TEST');
            $table->string('channel_code', 32)->nullable();
            $table->foreignUuid('channel_fee_version_id')->nullable()->constrained('payment_channel_fee_versions')->restrictOnDelete();
            $table->jsonb('amount_breakdown')->nullable();
            $table->string('provider_session_id', 64)->nullable()->unique();
            $table->string('provider_payment_id', 128)->nullable()->unique();
            $table->string('provider_payment_request_id', 128)->nullable();
            $table->text('checkout_url_encrypted')->nullable();
            $table->foreignId('created_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->bigInteger('provider_charge_centavos')->nullable();
            $table->timestampTz('provider_created_at')->nullable();
            $table->timestampTz('paid_at')->nullable();
            $table->timestampTz('failed_at')->nullable();
            $table->timestampTz('expired_at')->nullable();
            $table->timestampTz('cancelled_at')->nullable();
            $table->string('failure_code', 64)->nullable();
            $table->boolean('late_capture')->default(false);
            $table->string('reconciliation_state', 24)->default('NOT_REQUIRED');
            $table->timestampTz('last_reconciled_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->index(['state', 'expires_at']);
            $table->index(['vendor_organization_id', 'created_at']);
        });
        Schema::table('payment_attempts', function (Blueprint $table): void {
            $table->string('operation', 24)->default('CREATE');
            $table->unsignedSmallInteger('http_status')->nullable();
            $table->string('provider_request_id', 128)->nullable();
            $table->string('correlation_id', 64)->nullable();
        });
        Schema::table('payment_events', function (Blueprint $table): void {
            $table->foreignUuid('webhook_event_id')->nullable()->constrained('webhook_events')->restrictOnDelete();
            $table->string('source', 24)->default('WEBHOOK');
            $table->string('from_state', 24)->nullable();
            $table->string('correlation_id', 64)->nullable();
        });
        Schema::table('processing_fee_snapshots', function (Blueprint $table): void {
            $table->foreignUuid('channel_fee_version_id')->nullable()->constrained('payment_channel_fee_versions')->restrictOnDelete();
            $table->bigInteger('principal_centavos')->default(0);
            $table->string('fee_bearer', 16)->default('BUYER');
        });
        Schema::table('refunds', function (Blueprint $table): void {
            $table->string('environment', 8)->default('TEST');
            $table->string('evidence_origin', 24)->nullable();
            $table->string('reason_code', 64)->nullable();
            $table->string('failure_code', 64)->nullable();
            $table->timestampTz('requested_at')->nullable();
            $table->timestampTz('completed_at')->nullable();
        });
    }

    private function webhookInbox(): void
    {
        Schema::table('webhook_events', function (Blueprint $table): void {
            $table->string('event_type', 96)->nullable();
            $table->string('resource_reference', 128)->nullable();
            $table->text('payload_encrypted')->nullable();
            $table->string('verification', 24)->default('TOKEN_VERIFIED');
            $table->timestampTz('received_at')->nullable();
            $table->unsignedSmallInteger('attempts')->default(0);
            $table->string('result_code', 64)->nullable();
            $table->index(['state', 'received_at']);
        });
    }

    private function withholdingThreshold(): void
    {
        Schema::create('vendor_withholding_accumulators', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->string('environment', 8);
            $table->string('taxpayer_key', 128);
            $table->foreignUuid('organization_id')->constrained('vendor_organizations')->restrictOnDelete();
            $table->smallInteger('taxable_year');
            $table->timestampTz('year_start_at');
            $table->timestampTz('year_end_at');
            $table->bigInteger('threshold_centavos')->default(50000000);
            $table->bigInteger('g_accumulated_centavos')->default(0);
            $table->bigInteger('g_external_declared_centavos')->default(0);
            $table->bigInteger('g_external_overlap_centavos')->default(0);
            $table->bigInteger('g_effective_centavos')->storedAs('g_accumulated_centavos + g_external_declared_centavos - g_external_overlap_centavos');
            $table->string('external_overlap_state', 16)->default('NONE');
            $table->string('withholding_status', 32);
            $table->string('status_reason_code', 48);
            $table->timestampTz('crossed_at')->nullable();
            $table->uuid('crossing_assessment_id')->nullable();
            $table->foreignUuid('effective_declaration_id')->nullable()->constrained('tax_evidence')->restrictOnDelete();
            $table->bigInteger('prior_year_total_centavos')->nullable();
            $table->timestampTz('advisory_notified_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->timestampsTz();
            $table->unique(['environment', 'taxpayer_key', 'taxable_year'], 'withholding_accumulator_taxpayer_year_unique');
            $table->index(['environment', 'organization_id', 'taxable_year'], 'withholding_accumulator_org_year_index');
        });
        Schema::create('vendor_withholding_status_events', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('accumulator_id')->constrained('vendor_withholding_accumulators')->restrictOnDelete();
            $table->string('from_status', 32)->nullable();
            $table->string('to_status', 32);
            $table->string('reason_code', 48);
            $table->bigInteger('g_before_centavos');
            $table->bigInteger('g_after_centavos');
            $table->uuid('assessment_id')->nullable();
            $table->string('actor_type', 16);
            $table->unsignedBigInteger('actor_id')->nullable();
            $table->uuid('evidence_id')->nullable();
            $table->string('correlation_id', 64);
            $table->timestampTz('occurred_at');
            $table->index(['accumulator_id', 'occurred_at']);
        });
    }

    private function remittance(): void
    {
        DB::statement('ALTER TABLE remittance_groups ALTER COLUMN period_key TYPE varchar(64)');
        Schema::table('remittance_groups', function (Blueprint $table): void {
            $table->foreignUuid('payment_id')->nullable()->unique()->constrained()->restrictOnDelete();
            $table->string('grouping_rule', 32)->default('ONE_PER_COLLECTION');
            $table->string('evidence_origin', 24)->nullable();
        });
        Schema::table('remittance_assessments', function (Blueprint $table): void {
            $table->string('threshold_status_before', 32)->nullable();
            $table->string('threshold_status_after', 32)->nullable();
            $table->bigInteger('g_effective_before_centavos')->nullable();
            $table->bigInteger('g_effective_after_centavos')->nullable();
            $table->foreignUuid('relief_basis_id')->nullable()->constrained('tax_evidence')->restrictOnDelete();
            $table->foreignUuid('accumulator_id')->nullable()->constrained('vendor_withholding_accumulators')->restrictOnDelete();
            $table->foreignUuid('payment_id')->nullable()->constrained()->restrictOnDelete();
            $table->smallInteger('taxable_year')->nullable();
            $table->string('withholding_scenario', 32)->nullable();
            $table->string('deduction_actor', 32)->nullable();
            $table->bigInteger('expected_vendor_cash_centavos')->nullable();
            $table->bigInteger('commission_deducted_centavos')->default(0);
            $table->bigInteger('reported_withheld_centavos')->nullable();
            $table->string('evidence_origin', 24)->nullable();
            $table->string('correlation_id', 64)->nullable();
            $table->timestampTz('posted_at')->nullable();
        });
        Schema::table('vendor_withholding_accumulators', function (Blueprint $table): void {
            $table->foreign('crossing_assessment_id')->references('id')->on('remittance_assessments')->restrictOnDelete();
        });
        Schema::table('withholding_assignments', function (Blueprint $table): void {
            $table->string('scenario', 32)->nullable();
        });
        Schema::table('tax_adjustments', function (Blueprint $table): void {
            $table->foreignUuid('accumulator_id')->nullable()->constrained('vendor_withholding_accumulators')->restrictOnDelete();
            $table->string('opened_by', 16)->default('USER');
        });
        // A system-opened adjustment case (refund after a posted assessment) has no human preparer yet.
        DB::statement('ALTER TABLE tax_adjustments ALTER COLUMN prepared_by_user_id DROP NOT NULL');
    }

    private function statementsAndObligations(): void
    {
        Schema::table('fee_statements', function (Blueprint $table): void {
            $table->string('statement_reference', 48)->nullable()->unique();
            $table->foreignUuid('fee_policy_version_id')->nullable()->constrained()->restrictOnDelete();
            $table->timestampTz('drafted_at')->nullable();
            $table->timestampTz('issued_at')->nullable();
            $table->timestampTz('due_at')->nullable();
            $table->foreignId('approved_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('approved_at')->nullable();
            $table->bigInteger('disputed_held_centavos')->default(0);
            $table->unsignedSmallInteger('overdue_notices_sent')->default(0);
            $table->timestampTz('last_overdue_notice_at')->nullable();
            $table->timestampTz('finance_review_at')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
        });
        Schema::table('fee_assessments', function (Blueprint $table): void {
            $table->timestampTz('billed_at')->nullable();
        });
        Schema::table('physical_payment_records', function (Blueprint $table): void {
            $table->foreignUuid('online_payment_id')->nullable()->constrained('payments')->restrictOnDelete();
            $table->string('recorded_role', 32)->nullable();
            $table->foreignId('buyer_acknowledged_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->text('note')->nullable();
            $table->index(['order_id', 'recorded_at']);
        });
        DB::statement('ALTER TABLE physical_payment_records ALTER COLUMN recorded_by_user_id DROP NOT NULL');
    }

    private function reviewItems(): void
    {
        Schema::create('finance_review_items', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->string('environment', 8)->default('TEST');
            $table->string('kind', 48);
            $table->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('source_type', 32);
            $table->uuid('source_id');
            $table->string('reason_code', 64);
            $table->text('summary');
            $table->jsonb('expected')->nullable();
            $table->jsonb('reported')->nullable();
            $table->string('state', 16)->default('OPEN');
            $table->text('resolution')->nullable();
            $table->foreignId('resolved_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('resolved_at')->nullable();
            $table->string('dedupe_key', 160)->unique();
            $table->timestampsTz();
            $table->index(['state', 'kind', 'created_at']);
        });
    }

    private function postgresRules(): void
    {
        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION prevent_phase_eleven_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Phase 11 payment and finance history is append-only (%).', TG_TABLE_NAME;
END;
$$;
CREATE TRIGGER vendor_withholding_status_events_append_only BEFORE UPDATE OR DELETE ON vendor_withholding_status_events FOR EACH ROW EXECUTE FUNCTION prevent_phase_eleven_history_mutation();
CREATE TRIGGER payment_events_append_only BEFORE UPDATE OR DELETE ON payment_events FOR EACH ROW EXECUTE FUNCTION prevent_phase_eleven_history_mutation();
CREATE TRIGGER payment_attempts_append_only BEFORE UPDATE OR DELETE ON payment_attempts FOR EACH ROW EXECUTE FUNCTION prevent_phase_eleven_history_mutation();
CREATE TRIGGER processing_fee_snapshots_append_only BEFORE UPDATE OR DELETE ON processing_fee_snapshots FOR EACH ROW EXECUTE FUNCTION prevent_phase_eleven_history_mutation();
CREATE TRIGGER financial_ledger_entries_append_only BEFORE UPDATE OR DELETE ON financial_ledger_entries FOR EACH ROW EXECUTE FUNCTION prevent_phase_eleven_history_mutation();
-- A physical record is append-only except for the Buyer's one-time acknowledgment of that record.
CREATE OR REPLACE FUNCTION protect_physical_payment_records() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Physical payment records are retained.';
    END IF;
    IF OLD.buyer_acknowledged_at IS NOT NULL OR NEW.buyer_acknowledged_at IS NULL
        OR (to_jsonb(NEW) - ARRAY['buyer_acknowledged_at','buyer_acknowledged_by_user_id','updated_at']) IS DISTINCT FROM (to_jsonb(OLD) - ARRAY['buyer_acknowledged_at','buyer_acknowledged_by_user_id','updated_at']) THEN
        RAISE EXCEPTION 'Physical payment records change only through correction records.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER physical_payment_records_append_only BEFORE UPDATE OR DELETE ON physical_payment_records FOR EACH ROW EXECUTE FUNCTION protect_physical_payment_records();
CREATE TRIGGER remittance_collections_append_only BEFORE UPDATE OR DELETE ON remittance_collections FOR EACH ROW EXECUTE FUNCTION prevent_phase_eleven_history_mutation();

-- A channel fee version is never rewritten; only its retirement time may be set once.
CREATE OR REPLACE FUNCTION protect_payment_channel_fee_versions() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Channel fee versions are retained.';
    END IF;
    IF OLD.effective_until IS NOT NULL OR (to_jsonb(NEW) - 'effective_until') IS DISTINCT FROM (to_jsonb(OLD) - 'effective_until') THEN
        RAISE EXCEPTION 'A channel fee version is immutable; publish a new version.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER payment_channel_fee_versions_protected BEFORE UPDATE OR DELETE ON payment_channel_fee_versions FOR EACH ROW EXECUTE FUNCTION protect_payment_channel_fee_versions();

-- Posted remittance amounts and FIN-04A snapshots are frozen; only the independent evidence, reconciliation
-- and posting state fields may advance. Corrections are tax_adjustments, never rewrites.
CREATE OR REPLACE FUNCTION protect_remittance_assessments() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Remittance assessments are retained.';
    END IF;
    IF (to_jsonb(NEW) - ARRAY['calculation_state','deduction_evidence_state','reconciliation_state','reported_withheld_centavos','posted_at','updated_at'])
        IS DISTINCT FROM (to_jsonb(OLD) - ARRAY['calculation_state','deduction_evidence_state','reconciliation_state','reported_withheld_centavos','posted_at','updated_at']) THEN
        RAISE EXCEPTION 'Posted remittance amounts are immutable; create a tax adjustment.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER remittance_assessments_protected BEFORE UPDATE OR DELETE ON remittance_assessments FOR EACH ROW EXECUTE FUNCTION protect_remittance_assessments();

-- The accumulator never forgets a crossing inside its taxable year and never lowers its posted total.
CREATE OR REPLACE FUNCTION protect_withholding_accumulators() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Withholding accumulators are retained.';
    END IF;
    IF (NEW.environment, NEW.taxpayer_key, NEW.taxable_year, NEW.organization_id, NEW.threshold_centavos) IS DISTINCT FROM (OLD.environment, OLD.taxpayer_key, OLD.taxable_year, OLD.organization_id, OLD.threshold_centavos) THEN
        RAISE EXCEPTION 'An accumulator key and threshold are fixed.';
    END IF;
    IF NEW.g_accumulated_centavos < OLD.g_accumulated_centavos THEN
        RAISE EXCEPTION 'The posted gross-remittance total never decreases; open an adjustment review.';
    END IF;
    IF OLD.crossed_at IS NOT NULL AND (NEW.crossed_at IS DISTINCT FROM OLD.crossed_at OR NEW.crossing_assessment_id IS DISTINCT FROM OLD.crossing_assessment_id OR NEW.withholding_status <> 'SUBJECT_THRESHOLD_BREACHED') THEN
        RAISE EXCEPTION 'A threshold crossing is final for the taxable year.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER vendor_withholding_accumulators_protected BEFORE UPDATE OR DELETE ON vendor_withholding_accumulators FOR EACH ROW EXECUTE FUNCTION protect_withholding_accumulators();
SQL);

        foreach ([
            "ALTER TABLE payment_channel_fee_versions ADD CONSTRAINT channel_fee_rules_check CHECK (environment IN ('TEST','DEMO','LIVE') AND channel_kind IN ('CARD','EWALLET','QR','OVER_THE_COUNTER','DIRECT_DEBIT','BANK_TRANSFER') AND rate_ppm < 1000000 AND fixed_centavos >= 0 AND fee_vat_basis_points <= 10000 AND fee_bearer IN ('BUYER','PLATFORM') AND (enabled = false OR refund_supported = true) AND (enabled OR disabled_reason IS NOT NULL) AND (minimum_amount_centavos IS NULL OR minimum_amount_centavos > 0) AND (maximum_amount_centavos IS NULL OR minimum_amount_centavos IS NULL OR maximum_amount_centavos >= minimum_amount_centavos) AND (effective_until IS NULL OR effective_until > effective_from))",
            'CREATE UNIQUE INDEX channel_fee_one_open_version ON payment_channel_fee_versions (environment, channel_code) WHERE effective_until IS NULL',
            "ALTER TABLE vendor_payment_accounts ADD CONSTRAINT vendor_payment_contract_check CHECK (provider_api_version IN ('XENDIT_ACCOUNTS_V2','XENDIT_ACCOUNTS_V3'))",
            "ALTER TABLE payments ADD CONSTRAINT payment_attempt_state_check CHECK (state IN ('CREATING','PENDING','UNCERTAIN','PAID','FAILED','EXPIRED','CANCELLED'))",
            "ALTER TABLE payments ADD CONSTRAINT payment_attempt_scope_check CHECK ((purpose = 'PLATFORM_FEE_PAYMENT' AND account_scope = 'PLATFORM_ACCOUNT' AND fee_statement_id IS NOT NULL AND order_id IS NULL AND processing_fee_centavos = 0) OR (purpose <> 'PLATFORM_FEE_PAYMENT' AND account_scope = 'VENDOR_SUB_ACCOUNT' AND order_id IS NOT NULL AND fee_statement_id IS NULL AND provider_account_id IS NOT NULL))",
            "ALTER TABLE payments ADD CONSTRAINT payment_attempt_origin_check CHECK (environment = 'TEST' AND gateway_mode IN ('XENDIT_TEST','SIMULATED') AND evidence_origin IN ('XENDIT_TEST','SIMULATED') AND (gateway_mode = 'XENDIT_TEST') = (evidence_origin = 'XENDIT_TEST'))",
            "ALTER TABLE payments ADD CONSTRAINT payment_attempt_reconciliation_check CHECK (reconciliation_state IN ('NOT_REQUIRED','PENDING','RECONCILED','EXCEPTION'))",
            "ALTER TABLE payments ADD CONSTRAINT payment_attempt_paid_check CHECK (state <> 'PAID' OR (paid_at IS NOT NULL AND provider_session_id IS NOT NULL))",
            'ALTER TABLE payments ADD CONSTRAINT payment_attempt_positive_check CHECK (principal_centavos > 0 AND attempt_number >= 1 AND (provider_charge_centavos IS NULL OR provider_charge_centavos >= 0))',
            "CREATE UNIQUE INDEX payments_one_open_order_attempt ON payments (order_id, purpose) WHERE order_id IS NOT NULL AND state IN ('CREATING','PENDING','UNCERTAIN')",
            "CREATE UNIQUE INDEX payments_one_paid_order_purpose ON payments (order_id, purpose) WHERE order_id IS NOT NULL AND purpose IN ('FULL_ORDER_PAYMENT','NRPC_ASSURANCE_PAYMENT') AND state = 'PAID' AND late_capture = false",
            "CREATE UNIQUE INDEX payments_one_open_statement_attempt ON payments (fee_statement_id) WHERE fee_statement_id IS NOT NULL AND state IN ('CREATING','PENDING','UNCERTAIN')",
            "ALTER TABLE payment_attempts ADD CONSTRAINT payment_attempt_operation_check CHECK (operation IN ('CREATE','RETRIEVE','CANCEL','ACCOUNT_CHECK','REFUND'))",
            "ALTER TABLE payment_events ADD CONSTRAINT payment_event_source_check CHECK (source IN ('WEBHOOK','RECONCILIATION','SYSTEM'))",
            "ALTER TABLE webhook_events ADD CONSTRAINT webhook_event_state_check CHECK (state IN ('RECEIVED','PROCESSED','REJECTED','IGNORED','FAILED'))",
            "ALTER TABLE refunds ADD CONSTRAINT refund_environment_check CHECK (environment IN ('TEST','DEMO','LIVE') AND (evidence_origin IS NULL OR evidence_origin IN ('XENDIT_TEST','SIMULATED')))",
            "CREATE UNIQUE INDEX refunds_one_compensation_per_payment ON refunds (source_payment_id) WHERE trigger = 'TECHNICAL_COMPENSATION'",
            "ALTER TABLE vendor_withholding_accumulators ADD CONSTRAINT withholding_accumulator_environment_check CHECK (environment IN ('DEMO','TEST','LIVE'))",
            'ALTER TABLE vendor_withholding_accumulators ADD CONSTRAINT withholding_accumulator_amounts_check CHECK (threshold_centavos > 0 AND g_accumulated_centavos >= 0 AND g_external_declared_centavos >= 0 AND g_external_overlap_centavos >= 0 AND g_external_overlap_centavos <= g_external_declared_centavos AND (prior_year_total_centavos IS NULL OR prior_year_total_centavos >= 0) AND year_end_at > year_start_at)',
            "ALTER TABLE vendor_withholding_accumulators ADD CONSTRAINT withholding_accumulator_status_check CHECK (withholding_status IN ('RELIEF_ACTIVE','SUBJECT_STANDARD','SUBJECT_THRESHOLD_BREACHED','SUBJECT_PRIOR_YEAR','UNDER_REVIEW') AND external_overlap_state IN ('NONE','UNRESOLVED','RESOLVED'))",
            "ALTER TABLE vendor_withholding_accumulators ADD CONSTRAINT withholding_accumulator_crossing_check CHECK ((crossed_at IS NULL OR withholding_status LIKE 'SUBJECT%') AND (withholding_status <> 'SUBJECT_THRESHOLD_BREACHED' OR crossed_at IS NOT NULL))",
            "ALTER TABLE vendor_withholding_status_events ADD CONSTRAINT withholding_status_event_check CHECK (to_status IN ('RELIEF_ACTIVE','SUBJECT_STANDARD','SUBJECT_THRESHOLD_BREACHED','SUBJECT_PRIOR_YEAR','UNDER_REVIEW') AND (from_status IS NULL OR from_status IN ('RELIEF_ACTIVE','SUBJECT_STANDARD','SUBJECT_THRESHOLD_BREACHED','SUBJECT_PRIOR_YEAR','UNDER_REVIEW')) AND actor_type IN ('SYSTEM','ADMIN','VENDOR') AND g_before_centavos >= 0 AND g_after_centavos >= 0)",
            "CREATE UNIQUE INDEX withholding_one_crossing_event ON vendor_withholding_status_events (accumulator_id) WHERE to_status = 'SUBJECT_THRESHOLD_BREACHED'",
            "ALTER TABLE remittance_assessments ADD CONSTRAINT remittance_threshold_snapshot_check CHECK ((threshold_status_before IS NULL OR threshold_status_before IN ('RELIEF_ACTIVE','SUBJECT_STANDARD','SUBJECT_THRESHOLD_BREACHED','SUBJECT_PRIOR_YEAR','UNDER_REVIEW')) AND (threshold_status_after IS NULL OR threshold_status_after IN ('RELIEF_ACTIVE','SUBJECT_STANDARD','SUBJECT_THRESHOLD_BREACHED','SUBJECT_PRIOR_YEAR','UNDER_REVIEW')) AND commission_deducted_centavos = 0 AND (g_effective_after_centavos IS NULL OR g_effective_after_centavos >= g_effective_before_centavos) AND (withholding_scenario IS NULL OR withholding_scenario IN ('DEMO_PLATFORM_WITHHOLDER','DEMO_PROVIDER_WITHHOLDER')))",
            'CREATE UNIQUE INDEX remittance_assessment_one_per_payment ON remittance_assessments (payment_id, obligation_type) WHERE payment_id IS NOT NULL',
            "ALTER TABLE tax_adjustments ADD CONSTRAINT tax_adjustment_opened_by_check CHECK (opened_by IN ('USER','SYSTEM') AND (opened_by = 'SYSTEM' OR prepared_by_user_id IS NOT NULL))",
            "CREATE UNIQUE INDEX tax_adjustment_one_system_case ON tax_adjustments (original_record_type, original_record_id, kind) WHERE opened_by = 'SYSTEM'",
            'ALTER TABLE physical_payment_records DROP CONSTRAINT physical_payment_kind_check',
            "ALTER TABLE physical_payment_records ADD CONSTRAINT physical_payment_kind_check CHECK (record_kind IN ('OBLIGATION_OPENED','COLLECTION','ONLINE_BALANCE_CREDIT','CORRECTION','CANCELLATION_RELEASE'))",
            'ALTER TABLE physical_payment_records DROP CONSTRAINT physical_payment_evidence_check',
            "ALTER TABLE physical_payment_records ADD CONSTRAINT physical_payment_evidence_check CHECK (amount_centavos = 0 OR (record_kind = 'ONLINE_BALANCE_CREDIT' AND online_payment_id IS NOT NULL) OR (record_kind <> 'ONLINE_BALANCE_CREDIT' AND evidence_file_id IS NOT NULL AND recorded_by_user_id IS NOT NULL))",
            "ALTER TABLE physical_payment_records ADD CONSTRAINT physical_payment_opening_check CHECK (record_kind <> 'OBLIGATION_OPENED' OR (state = 'UNPAID' AND amount_centavos = 0))",
            "CREATE UNIQUE INDEX physical_payment_one_opening ON physical_payment_records (order_id) WHERE record_kind = 'OBLIGATION_OPENED'",
            'CREATE UNIQUE INDEX physical_payment_one_online_credit ON physical_payment_records (online_payment_id) WHERE online_payment_id IS NOT NULL',
            'ALTER TABLE fee_statements ADD CONSTRAINT fee_statement_approval_check CHECK ((state IN (\'DRAFT\', \'VOIDED\')) = (approved_at IS NULL) AND (approved_at IS NULL OR approved_by_user_id IS NOT NULL))',
            "ALTER TABLE finance_review_items ADD CONSTRAINT finance_review_item_check CHECK (environment IN ('TEST','DEMO','LIVE') AND kind IN ('RECONCILIATION_EXCEPTION','PAYMENT_MISMATCH','LATE_CAPTURE_COMPENSATION','OVERLAP_UNRESOLVED','THRESHOLD_ADJUSTMENT_REQUIRED','BASE_REVIEW_REQUIRED','FEE_OVERPAYMENT','STATEMENT_OVERDUE','FEE_CREDIT_PROPOSAL','PAID_FEE_CREDIT_PAYABLE') AND state IN ('OPEN','RESOLVED') AND (state = 'OPEN') = (resolved_at IS NULL))",
        ] as $statement) {
            DB::statement($statement);
        }
    }

    private function seedChannelFees(): void
    {
        $source = 'Xendit published Philippine rates retrieved 2026-10-02 for the capstone TEST schedule (cards 3.2% + PHP 10.00; GCash 2.3%; Maya 1.8%; GrabPay 2.0%; ShopeePay 2.0%), treated as VAT-exclusive with 12% VAT on the fee. DEMO rate — validate against the active Xendit agreement before production. Approved as the TEST schedule by the project owner on 2026-10-02.';
        $disabled = 'Disabled for the MVP: no approved provider refund route for this channel.';
        $rows = [
            ['CARDS', 'Credit or debit card', 'CARD', 'CARDS', 32000, 1000, true, true, null, $source],
            ['GCASH', 'GCash', 'EWALLET', 'GCASH', 23000, 0, true, true, null, $source],
            ['MAYA', 'Maya', 'EWALLET', 'PAYMAYA', 18000, 0, true, true, null, $source],
            ['GRABPAY', 'GrabPay', 'EWALLET', 'GRABPAY', 20000, 0, true, true, null, $source],
            ['SHOPEEPAY', 'ShopeePay', 'EWALLET', 'SHOPEEPAY', 20000, 0, true, true, null, $source],
            ['QRPH', 'QR Ph', 'QR', 'QRPH', 0, 0, false, false, 'REFUND_ROUTE_UNAVAILABLE', $disabled],
            ['OVER_THE_COUNTER', 'Over-the-counter cash', 'OVER_THE_COUNTER', '7ELEVEN', 0, 0, false, false, 'REFUND_ROUTE_UNAVAILABLE', $disabled],
            ['DIRECT_DEBIT', 'Online banking direct debit', 'DIRECT_DEBIT', 'BPI_DIRECT_DEBIT', 0, 0, false, false, 'REFUND_ROUTE_UNAVAILABLE', $disabled],
            ['BANK_TRANSFER', 'Bank transfer', 'BANK_TRANSFER', 'BANK_TRANSFER', 0, 0, false, false, 'REFUND_ROUTE_UNAVAILABLE', $disabled],
        ];
        foreach ($rows as [$code, $name, $kind, $providerCode, $rate, $fixed, $refund, $enabled, $reason, $reference]) {
            DB::table('payment_channel_fee_versions')->insert([
                'id' => (string) Str::uuid7(), 'environment' => 'TEST', 'channel_code' => $code, 'version' => 1, 'display_name' => $name, 'channel_kind' => $kind,
                'provider_channel_code' => $providerCode, 'rate_ppm' => $rate, 'fixed_centavos' => $fixed, 'fee_vat_basis_points' => 1200, 'rate_includes_vat' => false,
                'fee_bearer' => 'BUYER', 'refund_supported' => $refund, 'enabled' => $enabled, 'disabled_reason' => $reason, 'rounding_basis' => 'HALF_UP_PER_COMPONENT',
                'source_type' => $enabled ? 'PUBLISHED_RATE_DEMO' : 'MVP_CHANNEL_POLICY', 'source_reference' => $reference, 'effective_from' => '2026-10-02 00:00:00+08', 'created_at' => now(),
            ]);
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared(<<<'SQL'
DROP TRIGGER IF EXISTS vendor_withholding_status_events_append_only ON vendor_withholding_status_events;
DROP TRIGGER IF EXISTS payment_events_append_only ON payment_events;
DROP TRIGGER IF EXISTS payment_attempts_append_only ON payment_attempts;
DROP TRIGGER IF EXISTS processing_fee_snapshots_append_only ON processing_fee_snapshots;
DROP TRIGGER IF EXISTS financial_ledger_entries_append_only ON financial_ledger_entries;
DROP TRIGGER IF EXISTS physical_payment_records_append_only ON physical_payment_records;
DROP TRIGGER IF EXISTS remittance_collections_append_only ON remittance_collections;
DROP TRIGGER IF EXISTS payment_channel_fee_versions_protected ON payment_channel_fee_versions;
DROP TRIGGER IF EXISTS remittance_assessments_protected ON remittance_assessments;
DROP TRIGGER IF EXISTS vendor_withholding_accumulators_protected ON vendor_withholding_accumulators;
DROP FUNCTION IF EXISTS prevent_phase_eleven_history_mutation();
DROP FUNCTION IF EXISTS protect_payment_channel_fee_versions();
DROP FUNCTION IF EXISTS protect_remittance_assessments();
DROP FUNCTION IF EXISTS protect_withholding_accumulators();
DROP FUNCTION IF EXISTS protect_physical_payment_records();
DROP INDEX IF EXISTS payments_one_open_order_attempt;
DROP INDEX IF EXISTS payments_one_paid_order_purpose;
DROP INDEX IF EXISTS payments_one_open_statement_attempt;
DROP INDEX IF EXISTS refunds_one_compensation_per_payment;
DROP INDEX IF EXISTS remittance_assessment_one_per_payment;
DROP INDEX IF EXISTS tax_adjustment_one_system_case;
DROP INDEX IF EXISTS physical_payment_one_opening;
DROP INDEX IF EXISTS physical_payment_one_online_credit;
ALTER TABLE payments DROP CONSTRAINT IF EXISTS payment_attempt_state_check, DROP CONSTRAINT IF EXISTS payment_attempt_scope_check, DROP CONSTRAINT IF EXISTS payment_attempt_origin_check,
    DROP CONSTRAINT IF EXISTS payment_attempt_reconciliation_check, DROP CONSTRAINT IF EXISTS payment_attempt_paid_check, DROP CONSTRAINT IF EXISTS payment_attempt_positive_check;
ALTER TABLE payment_attempts DROP CONSTRAINT IF EXISTS payment_attempt_operation_check;
ALTER TABLE payment_events DROP CONSTRAINT IF EXISTS payment_event_source_check;
ALTER TABLE webhook_events DROP CONSTRAINT IF EXISTS webhook_event_state_check;
ALTER TABLE refunds DROP CONSTRAINT IF EXISTS refund_environment_check;
ALTER TABLE vendor_payment_accounts DROP CONSTRAINT IF EXISTS vendor_payment_contract_check;
ALTER TABLE remittance_assessments DROP CONSTRAINT IF EXISTS remittance_threshold_snapshot_check;
ALTER TABLE tax_adjustments DROP CONSTRAINT IF EXISTS tax_adjustment_opened_by_check;
ALTER TABLE fee_statements DROP CONSTRAINT IF EXISTS fee_statement_approval_check;
ALTER TABLE physical_payment_records DROP CONSTRAINT IF EXISTS physical_payment_kind_check, DROP CONSTRAINT IF EXISTS physical_payment_evidence_check, DROP CONSTRAINT IF EXISTS physical_payment_opening_check;
ALTER TABLE physical_payment_records ADD CONSTRAINT physical_payment_kind_check CHECK (record_kind IN ('COLLECTION','CORRECTION','CANCELLATION_RELEASE'));
ALTER TABLE physical_payment_records ADD CONSTRAINT physical_payment_evidence_check CHECK (amount_centavos = 0 OR evidence_file_id IS NOT NULL);
SQL);
        }
        Schema::dropIfExists('finance_review_items');
        Schema::table('physical_payment_records', function (Blueprint $table): void {
            $table->dropIndex(['order_id', 'recorded_at']);
            $table->dropConstrainedForeignId('online_payment_id');
            $table->dropConstrainedForeignId('buyer_acknowledged_by_user_id');
            $table->dropColumn(['recorded_role', 'note']);
        });
        Schema::table('fee_assessments', fn (Blueprint $table) => $table->dropColumn('billed_at'));
        Schema::table('fee_statements', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('fee_policy_version_id');
            $table->dropConstrainedForeignId('approved_by_user_id');
            $table->dropUnique(['statement_reference']);
            $table->dropColumn(['statement_reference', 'drafted_at', 'issued_at', 'due_at', 'approved_at', 'disputed_held_centavos', 'overdue_notices_sent', 'last_overdue_notice_at', 'finance_review_at', 'lock_version']);
        });
        Schema::table('tax_adjustments', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('accumulator_id');
            $table->dropColumn('opened_by');
        });
        Schema::table('withholding_assignments', fn (Blueprint $table) => $table->dropColumn('scenario'));
        Schema::table('vendor_withholding_accumulators', fn (Blueprint $table) => $table->dropForeign(['crossing_assessment_id']));
        Schema::table('remittance_assessments', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('relief_basis_id');
            $table->dropConstrainedForeignId('accumulator_id');
            $table->dropConstrainedForeignId('payment_id');
            $table->dropColumn(['threshold_status_before', 'threshold_status_after', 'g_effective_before_centavos', 'g_effective_after_centavos', 'taxable_year', 'withholding_scenario',
                'deduction_actor', 'expected_vendor_cash_centavos', 'commission_deducted_centavos', 'reported_withheld_centavos', 'evidence_origin', 'correlation_id', 'posted_at']);
        });
        Schema::table('remittance_groups', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('payment_id');
            $table->dropColumn(['grouping_rule', 'evidence_origin']);
        });
        Schema::dropIfExists('vendor_withholding_status_events');
        Schema::dropIfExists('vendor_withholding_accumulators');
        Schema::table('webhook_events', function (Blueprint $table): void {
            $table->dropIndex(['state', 'received_at']);
            $table->dropColumn(['event_type', 'resource_reference', 'payload_encrypted', 'verification', 'received_at', 'attempts', 'result_code']);
        });
        Schema::table('refunds', fn (Blueprint $table) => $table->dropColumn(['environment', 'evidence_origin', 'reason_code', 'failure_code', 'requested_at', 'completed_at']));
        Schema::table('processing_fee_snapshots', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('channel_fee_version_id');
            $table->dropColumn(['principal_centavos', 'fee_bearer']);
        });
        Schema::table('payment_events', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('webhook_event_id');
            $table->dropColumn(['source', 'from_state', 'correlation_id']);
        });
        Schema::table('payment_attempts', fn (Blueprint $table) => $table->dropColumn(['operation', 'http_status', 'provider_request_id', 'correlation_id']));
        Schema::table('payments', function (Blueprint $table): void {
            $table->dropIndex(['state', 'expires_at']);
            $table->dropIndex(['vendor_organization_id', 'created_at']);
            foreach (['vendor_organization_id', 'buyer_profile_id', 'financial_snapshot_id', 'channel_fee_version_id', 'created_by_user_id'] as $foreign) {
                $table->dropConstrainedForeignId($foreign);
            }
            $table->dropUnique(['provider_session_id']);
            $table->dropUnique(['provider_payment_id']);
            $table->dropColumn(['attempt_number', 'account_scope', 'provider_account_id', 'account_contract_version', 'provider_api_version', 'gateway_mode', 'evidence_origin', 'channel_code',
                'amount_breakdown', 'provider_session_id', 'provider_payment_id', 'provider_payment_request_id', 'checkout_url_encrypted', 'provider_charge_centavos', 'provider_created_at',
                'paid_at', 'failed_at', 'expired_at', 'cancelled_at', 'failure_code', 'late_capture', 'reconciliation_state', 'last_reconciled_at', 'lock_version']);
        });
        Schema::table('orders', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('online_balance_approved_by_user_id');
            $table->dropColumn('online_balance_approved_at');
        });
        Schema::table('vendor_payment_accounts', fn (Blueprint $table) => $table->dropColumn('provider_api_version'));
        Schema::dropIfExists('vendor_payment_settings');
        Schema::dropIfExists('payment_channel_fee_versions');
    }
};
