<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/**
 * Phase 16 — Admin operations and Philippine geographic analytics.
 *
 * Extends existing records instead of creating parallel ones: `platform_settings` keeps the effective value and
 * gains an append-only `platform_setting_versions` history; Phase 13 `enforcement_actions` gain the User Management
 * lifecycle (apply, expire, lift) with an append-only `enforcement_events` trail; Phase 1 `privacy_requests` gain the
 * handling fields with `privacy_request_events`; `psgc_boundaries` gains PostGIS geometry for the Admin map.
 *
 * Geographic analytics facts are derived projections rebuilt by an idempotent daily job. They hold PSGC codes,
 * pseudonymous person keys and integer centavos only — never coordinates, names or contact details. The Phase 1
 * generic `analytics_*_facts` jsonb tables remain unused placeholders; typed fact tables are needed for indexed
 * PSGC/date filtering and distinct-person disclosure control.
 */
return new class extends Migration
{
    /** Approved non-secret defaults as of 2026-10-09 (Admin Workflow §12); later changes are new versions. */
    private const SETTING_DEFAULTS = [
        'discovery.buyer_default_radius_km' => 5,
        'discovery.vendor_default_radius_km' => 50,
        'discovery.radius_expansion_threshold' => 3,
        'orders.vendor_response_hours' => 24,
        'orders.pending_payment_window_hours' => 24,
        'reminders.payment_hours_before' => [12, 1],
        'quotations.deadline_limits' => ['min_hours' => 1, 'max_hours' => 72, 'default_hours' => 24],
        'reminders.quotation_before_minutes' => ['long_deadline_from_hours' => 8, 'long_minutes' => 240, 'short_minutes' => 30],
        'reminders.receipt_hours_before' => ['first_hours' => 24, 'second_hours' => 2],
        'disputes.deadlines' => ['response_hours' => 48, 'mutual_resolution_hours' => 72, 'clarification_hours' => 24, 'appeal_business_days' => 5, 'post_completion_filing_days' => 7],
        'reviews.windows' => ['rating_window_days' => 14, 'edit_hours' => 24, 'correction_days' => 7],
        'badges.thresholds' => [
            'fast_responder' => ['min_crr_percent' => '85.00', 'min_inquiries' => 10],
            'on_time' => ['min_frr_percent' => '95.00', 'min_fulfilled_orders' => 10],
            'highly_rated' => ['min_vcs' => '4.50', 'min_vendor_ratings' => 10],
            'high_quality_materials' => ['min_mqs' => '4.60', 'min_product_ratings' => 10],
            'trusted_supplier' => ['min_vcs' => '4.50', 'min_ohs' => '4.50', 'min_completed_orders' => 25, 'min_active_days' => 90],
        ],
        'projects.budget_warning_percent' => 90,
        'invoices.request_service_target_business_days' => 3,
        'analytics.disclosure_min_persons' => 5,
        'uploads.limits_kb' => ['vendor_document' => 10240, 'store_media' => 20480, 'listing_image' => 5120, 'compliance_evidence' => 10240,
            'case_evidence' => 10240, 'review_photo' => 10240, 'review_video' => 102400],
        'features.flags' => ['materials_analytics' => true, 'geo_analytics' => true],
    ];

    public function up(): void
    {
        $this->settings();
        $this->enforcement();
        $this->privacy();
        $this->operations();
        $this->geography();
        $this->facts();
        $this->grants();
        if (DB::getDriverName() === 'pgsql') {
            $this->postgresRules();
        }
    }

    private function settings(): void
    {
        Schema::create('platform_setting_versions', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->string('setting_key', 96);
            $t->unsignedInteger('version');
            $t->jsonb('value');
            $t->jsonb('previous_value')->nullable();
            $t->string('source', 16);
            $t->text('reason');
            $t->foreignId('changed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->string('changed_role', 48)->nullable();
            $t->string('correlation_id', 64)->nullable();
            $t->timestampTz('effective_from');
            $t->timestampTz('created_at');
            $t->unique(['setting_key', 'version']);
            $t->index(['setting_key', 'created_at']);
        });
        $now = now();
        foreach (DB::table('platform_settings')->whereIn('key', ['ranking.srs.default_weights', 'ranking.fms.default_weights'])->get() as $row) {
            DB::table('platform_setting_versions')->insert(['id' => (string) Str::uuid7(), 'setting_key' => $row->key, 'version' => (int) $row->version, 'value' => $row->value,
                'previous_value' => null, 'source' => 'SEED', 'reason' => 'Existing approved default recorded by the Phase 16 settings history.', 'effective_from' => $row->updated_at ?? $now, 'created_at' => $now]);
        }
        foreach (self::SETTING_DEFAULTS as $key => $value) {
            if (DB::table('platform_settings')->where('key', $key)->exists()) {
                continue;
            }
            $json = json_encode($value, JSON_THROW_ON_ERROR);
            DB::table('platform_settings')->insert(['id' => (string) Str::uuid7(), 'key' => $key, 'value' => $json, 'version' => 1, 'updated_by_user_id' => null, 'created_at' => $now, 'updated_at' => $now]);
            DB::table('platform_setting_versions')->insert(['id' => (string) Str::uuid7(), 'setting_key' => $key, 'version' => 1, 'value' => $json, 'previous_value' => null,
                'source' => 'SEED', 'reason' => 'Approved non-secret default seeded by Phase 16.', 'effective_from' => $now, 'created_at' => $now]);
        }
    }

    private function enforcement(): void
    {
        Schema::table('enforcement_actions', function (Blueprint $t): void {
            $t->string('source', 24)->default('DISPUTE_REFERRAL');
            $t->string('continuation_plan', 32)->nullable();
            $t->text('continuation_note')->nullable();
            $t->jsonb('prior_subject_state')->nullable();
            $t->timestampTz('applied_at')->nullable();
            $t->foreignId('applied_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->string('applied_role', 48)->nullable();
            $t->timestampTz('expires_at')->nullable();
            $t->timestampTz('lifted_at')->nullable();
            $t->foreignId('lifted_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->text('lift_reason')->nullable();
            $t->string('correlation_id', 64)->nullable();
            $t->unsignedInteger('lock_version')->default(1);
            $t->index(['state', 'created_at']);
            $t->index(['state', 'expires_at']);
        });
        Schema::create('enforcement_events', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('enforcement_action_id')->constrained()->restrictOnDelete();
            $t->string('event', 24);
            $t->string('from_state', 16)->nullable();
            $t->string('to_state', 16);
            $t->jsonb('before')->nullable();
            $t->jsonb('after')->nullable();
            $t->text('reason');
            $t->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->string('actor_role', 48);
            $t->string('correlation_id', 64);
            $t->timestampTz('occurred_at');
            $t->index(['enforcement_action_id', 'occurred_at']);
        });
    }

    private function privacy(): void
    {
        Schema::table('privacy_requests', function (Blueprint $t): void {
            $t->string('reference', 24)->nullable()->unique();
            $t->string('subject_account_type', 16)->nullable();
            $t->string('intake_channel', 24)->nullable();
            $t->timestampTz('received_at')->nullable();
            $t->text('scope')->nullable();
            $t->string('identity_verification_method', 32)->nullable();
            $t->timestampTz('identity_verified_at')->nullable();
            $t->foreignId('identity_verified_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->foreignId('handler_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->timestampTz('assigned_at')->nullable();
            $t->date('target_date')->nullable();
            $t->text('response_summary')->nullable();
            $t->foreignId('recorded_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->unsignedInteger('lock_version')->default(1);
            $t->index(['state', 'created_at']);
            $t->index(['handler_user_id', 'state']);
        });
        Schema::create('privacy_request_events', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('privacy_request_id')->constrained()->restrictOnDelete();
            $t->string('event', 32);
            $t->string('from_state', 24)->nullable();
            $t->string('to_state', 24);
            $t->text('note');
            $t->foreignId('actor_user_id')->constrained('users')->restrictOnDelete();
            $t->string('actor_role', 48);
            $t->string('correlation_id', 64);
            $t->timestampTz('occurred_at');
            $t->index(['privacy_request_id', 'occurred_at']);
        });
    }

    private function operations(): void
    {
        Schema::create('scheduled_task_runs', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->string('task', 160);
            $t->string('outcome', 16);
            $t->smallInteger('exit_code')->nullable();
            $t->unsignedInteger('duration_ms')->nullable();
            $t->timestampTz('started_at');
            $t->timestampTz('finished_at')->nullable();
            $t->index(['task', 'started_at']);
        });
        Schema::create('operation_retries', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->string('target_type', 24);
            $t->string('target_reference', 80);
            $t->string('target_label', 120);
            $t->text('reason');
            $t->string('outcome', 16);
            $t->foreignId('actor_user_id')->constrained('users')->restrictOnDelete();
            $t->string('actor_role', 48);
            $t->string('correlation_id', 64);
            $t->timestampTz('created_at');
            $t->index(['target_type', 'target_reference']);
        });
        Schema::table('audit_logs', function (Blueprint $t): void {
            $t->index(['created_at', 'id'], 'audit_logs_recent_idx');
            $t->index(['actor_user_id', 'created_at'], 'audit_logs_actor_idx');
            $t->index(['action', 'created_at'], 'audit_logs_action_idx');
            $t->index(['vendor_organization_id', 'created_at'], 'audit_logs_organization_idx');
        });
    }

    private function geography(): void
    {
        Schema::table('psgc_boundaries', function (Blueprint $t): void {
            $t->text('simplified_geojson')->nullable();
            $t->string('source_reference')->nullable();
            $t->foreignUuid('psgc_boundary_import_id')->nullable();
        });
        Schema::create('psgc_boundary_imports', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('psgc_version_id')->constrained()->restrictOnDelete();
            $t->string('source_reference');
            $t->string('content_hash', 64);
            $t->unsignedInteger('feature_count');
            $t->unsignedInteger('matched_count');
            $t->unsignedInteger('replaced_count')->default(0);
            $t->jsonb('unmatched_codes');
            $t->string('code_property', 64);
            $t->timestampTz('imported_at');
            $t->timestampsTz();
            $t->unique(['psgc_version_id', 'content_hash']);
        });
        Schema::table('psgc_boundaries', function (Blueprint $t): void {
            $t->foreign('psgc_boundary_import_id')->references('id')->on('psgc_boundary_imports')->restrictOnDelete();
        });
    }

    private function facts(): void
    {
        Schema::create('analytics_geo_runs', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->string('environment', 8);
            $t->date('through_date');
            $t->unsignedInteger('revision');
            $t->string('state', 16);
            $t->string('trigger', 16);
            $t->foreignUuid('psgc_version_id')->nullable()->constrained()->restrictOnDelete();
            $t->jsonb('counts')->nullable();
            $t->string('error_code', 48)->nullable();
            $t->foreignId('requested_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $t->timestampTz('started_at');
            $t->timestampTz('published_at')->nullable();
            $t->timestampsTz();
            $t->unique(['environment', 'through_date', 'revision']);
        });
        $geo = static function (Blueprint $t): void {
            $t->foreignUuid('psgc_version_id')->nullable()->constrained()->restrictOnDelete();
            $t->string('region_code', 16)->nullable();
            $t->string('area_code', 16)->nullable();
            $t->string('locality_code', 16)->nullable();
            $t->string('geo_resolution', 16);
        };
        Schema::create('analytics_order_facts', function (Blueprint $t) use ($geo): void {
            $t->uuid('id')->primary();
            $t->string('environment', 8);
            $t->string('source_key', 80);
            $t->foreignUuid('analytics_geo_run_id')->constrained()->restrictOnDelete();
            $t->date('confirmed_on');
            $t->string('buyer_key', 64);
            $t->string('geo_basis', 16);
            $geo($t);
            $t->string('procurement_type', 16);
            $t->string('fulfillment_method', 16);
            $t->string('payment_method', 24);
            $t->string('order_state', 32);
            $t->bigInteger('gross_value_centavos');
            $t->bigInteger('cancelled_value_centavos');
            $t->bigInteger('refunded_value_centavos');
            $t->bigInteger('net_value_centavos');
            $t->date('due_on')->nullable();
            $t->date('completed_on')->nullable();
            $t->boolean('cancelled');
            $t->boolean('disputed');
            $t->timestampTz('created_at');
            $t->unique(['environment', 'source_key']);
            $t->index(['environment', 'confirmed_on']);
            $t->index(['environment', 'region_code', 'confirmed_on']);
            $t->index(['environment', 'area_code', 'confirmed_on']);
            $t->index(['environment', 'locality_code', 'confirmed_on']);
        });
        Schema::create('analytics_order_line_facts', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('analytics_order_fact_id')->constrained()->restrictOnDelete();
            $t->foreignUuid('material_category_id')->nullable()->constrained()->restrictOnDelete();
            $t->foreignUuid('material_id')->nullable()->constrained()->restrictOnDelete();
            $t->foreignUuid('unit_id')->nullable()->constrained()->restrictOnDelete();
            $t->decimal('quantity', 18, 4);
            // Quantity in the material's canonical unit when the line unit is that unit or has an approved conversion.
            $t->decimal('normalized_quantity', 20, 4)->nullable();
            $t->bigInteger('value_centavos');
            $t->index(['analytics_order_fact_id']);
            $t->index(['material_category_id']);
            $t->index(['material_id']);
        });
        Schema::create('analytics_activity_facts', function (Blueprint $t) use ($geo): void {
            $t->uuid('id')->primary();
            $t->string('environment', 8);
            $t->string('source_key', 96);
            $t->foreignUuid('analytics_geo_run_id')->constrained()->restrictOnDelete();
            $t->date('activity_on');
            $t->string('audience', 8);
            $t->string('actor_key', 64);
            $t->string('action_kind', 32);
            $geo($t);
            $t->timestampTz('created_at');
            $t->unique(['environment', 'source_key']);
            $t->index(['environment', 'audience', 'activity_on']);
        });
        Schema::create('analytics_response_facts', function (Blueprint $t) use ($geo): void {
            $t->uuid('id')->primary();
            $t->string('environment', 8);
            $t->string('source_key', 96);
            $t->foreignUuid('analytics_geo_run_id')->constrained()->restrictOnDelete();
            $t->date('available_on');
            $t->string('request_kind', 24);
            $t->string('buyer_key', 64);
            $geo($t);
            $t->timestampTz('available_at');
            $t->timestampTz('responded_at')->nullable();
            $t->unsignedInteger('response_seconds')->nullable();
            $t->timestampTz('created_at');
            $t->unique(['environment', 'source_key']);
            $t->index(['environment', 'available_on']);
        });
        Schema::create('analytics_presence_facts', function (Blueprint $t) use ($geo): void {
            $t->uuid('id')->primary();
            $t->string('environment', 8);
            $t->foreignUuid('analytics_geo_run_id')->constrained()->restrictOnDelete();
            $t->date('snapshot_on');
            $t->string('audience', 8);
            $t->string('subject_key', 64);
            $geo($t);
            $t->timestampTz('created_at');
            $t->unique(['environment', 'snapshot_on', 'audience', 'subject_key']);
            $t->index(['environment', 'audience', 'snapshot_on']);
        });
    }

    private function grants(): void
    {
        $grants = [
            'audit.view' => ['Search the append-only audit log (safe projection)', ['ADMIN_SUPERADMIN']],
            'audit.view_sensitive' => ['Open redacted before/after audit detail; each opening is itself audited', ['ADMIN_SUPERADMIN']],
            'audit.export' => ['Export filtered audit search results with a recorded reason', ['ADMIN_SUPERADMIN']],
            'platform_settings.view' => ['View versioned non-secret platform settings', ['ADMIN_SUPERADMIN']],
            'platform_settings.manage' => ['Change versioned non-secret platform settings with a reason and recent re-authentication', ['ADMIN_SUPERADMIN']],
            'enforcement.view' => ['View Buyer and Vendor enforcement cases and account-review history', ['ADMIN_SUPERADMIN', 'ADMIN_USER_MANAGEMENT', 'ADMIN_ORDER_DISPUTE']],
            'enforcement.apply' => ['Record, apply and lift warnings, temporary restrictions and suspensions with a reason', ['ADMIN_SUPERADMIN', 'ADMIN_USER_MANAGEMENT']],
            'enforcement.ban' => ['Apply or reverse a Permanent Ban with recent re-authentication', ['ADMIN_SUPERADMIN']],
            'privacy.manage' => ['Record verified privacy requests, assign handlers and view every request', ['ADMIN_SUPERADMIN']],
            'privacy.handle' => ['Handle privacy requests assigned to you', ['ADMIN_SUPERADMIN', 'ADMIN_USER_MANAGEMENT']],
            'jobs.retry' => ['Retry an allowlisted idempotent failed job, outbox delivery or analytics run with a reason', ['ADMIN_SUPERADMIN']],
            'budget_overrides.view' => ['Read the Buyer budget override audit log', ['ADMIN_SUPERADMIN', 'ADMIN_ORDER_DISPUTE']],
        ];
        foreach ($grants as $code => [$description, $roleCodes]) {
            $permissionId = DB::table('permissions')->where('code', $code)->value('id');
            if ($permissionId === null) {
                $permissionId = (string) Str::uuid7();
                DB::table('permissions')->insert(['id' => $permissionId, 'code' => $code, 'description' => $description, 'created_at' => now(), 'updated_at' => now()]);
            }
            foreach ($roleCodes as $roleCode) {
                $roleId = DB::table('platform_roles')->where('code', $roleCode)->value('id');
                if ($roleId !== null && ! DB::table('role_permissions')->where('platform_role_id', $roleId)->where('permission_id', $permissionId)->exists()) {
                    DB::table('role_permissions')->insert(['id' => (string) Str::uuid7(), 'platform_role_id' => $roleId, 'permission_id' => $permissionId, 'created_at' => now(), 'updated_at' => now()]);
                }
            }
        }
    }

    private function postgresRules(): void
    {
        foreach ([
            "ALTER TABLE platform_setting_versions ADD CONSTRAINT platform_setting_version_check CHECK (version >= 1 AND source IN ('SEED','ADMIN') AND length(trim(reason)) >= 10 AND (source = 'SEED' OR changed_by_user_id IS NOT NULL))",
            'ALTER TABLE enforcement_actions DROP CONSTRAINT enforcement_action_check',
            "ALTER TABLE enforcement_actions ADD CONSTRAINT enforcement_action_check CHECK (subject_type IN ('VENDOR_ORGANIZATION','BUYER') AND action IN ('WARNING','TEMPORARY_RESTRICTION','SUSPENSION','PERMANENT_BAN')
                AND state IN ('EFFECTIVE','REFERRED','APPLIED','LIFTED','DECLINED') AND length(trim(reason)) >= 10 AND (action <> 'TEMPORARY_RESTRICTION' OR duration_days > 0)
                AND (action = 'WARNING' OR restoration_condition IS NOT NULL OR action = 'PERMANENT_BAN') AND source IN ('DISPUTE_REFERRAL','DIRECT')
                AND (continuation_plan IS NULL OR continuation_plan IN ('CONTINUE','MONITORED_FULFILLMENT','CANCELLATION_REVIEW','REPLACEMENT','REFUND','NO_OPEN_ORDERS'))
                AND (state <> 'APPLIED' OR (applied_at IS NOT NULL AND continuation_plan IS NOT NULL)) AND ((state = 'LIFTED') = (lifted_at IS NOT NULL))
                AND (action <> 'TEMPORARY_RESTRICTION' OR state NOT IN ('APPLIED','LIFTED') OR expires_at IS NOT NULL))",
            "CREATE UNIQUE INDEX enforcement_one_applied_per_subject ON enforcement_actions (subject_type, subject_id) WHERE state = 'APPLIED' AND action <> 'WARNING'",
            "ALTER TABLE enforcement_events ADD CONSTRAINT enforcement_event_check CHECK (event IN ('RECORDED','REFERRED','APPLIED','DECLINED','LIFTED','EXPIRED','SUPERSEDED') AND length(trim(reason)) >= 3)",
            "ALTER TABLE privacy_requests ADD CONSTRAINT privacy_request_check CHECK (request_type IN ('ACCESS','CORRECTION','OBJECTION','DELETION','RESTRICTION','PORTABILITY','OTHER')
                AND state IN ('RECEIVED','IDENTITY_VERIFIED','IN_PROGRESS','COMPLETED','REJECTED','WITHDRAWN')
                AND (intake_channel IS NULL OR intake_channel IN ('DPO_EMAIL','SUPPORT_CASE','WRITTEN_LETTER','IN_APP'))
                AND (state IN ('RECEIVED','WITHDRAWN','REJECTED') OR identity_verified_at IS NOT NULL)
                AND ((state IN ('COMPLETED','REJECTED','WITHDRAWN')) = (completed_at IS NOT NULL)))",
            'ALTER TABLE privacy_request_events ADD CONSTRAINT privacy_request_event_check CHECK (length(trim(note)) >= 3)',
            "ALTER TABLE scheduled_task_runs ADD CONSTRAINT scheduled_task_outcome_check CHECK (outcome IN ('RUNNING','SUCCEEDED','FAILED','SKIPPED'))",
            "ALTER TABLE operation_retries ADD CONSTRAINT operation_retry_check CHECK (target_type IN ('FAILED_JOB','OUTBOX_EVENT','GEO_FACTS_RUN','MATERIAL_SNAPSHOT') AND outcome IN ('QUEUED','REJECTED') AND length(trim(reason)) >= 10)",
            "ALTER TABLE analytics_geo_runs ADD CONSTRAINT analytics_geo_run_check CHECK (environment IN ('TEST','DEMO') AND state IN ('RUNNING','PUBLISHED','FAILED','SUPERSEDED') AND trigger IN ('SCHEDULE','ADMIN_RETRY','DEMO_SEED','COMMAND')
                AND ((state = 'FAILED') = (error_code IS NOT NULL)) AND (state <> 'PUBLISHED' OR published_at IS NOT NULL))",
            "ALTER TABLE analytics_order_facts ADD CONSTRAINT analytics_order_fact_check CHECK (environment IN ('TEST','DEMO') AND geo_basis IN ('DELIVERY_SITE','PICKUP_STORE','PROJECT_SITE')
                AND geo_resolution IN ('RESOLVED','PARTIAL','UNRESOLVED') AND gross_value_centavos >= 0 AND cancelled_value_centavos >= 0 AND refunded_value_centavos >= 0
                AND net_value_centavos = gross_value_centavos - cancelled_value_centavos - refunded_value_centavos AND net_value_centavos >= 0)",
            "ALTER TABLE analytics_activity_facts ADD CONSTRAINT analytics_activity_fact_check CHECK (environment IN ('TEST','DEMO') AND audience IN ('BUYER','VENDOR') AND geo_resolution IN ('RESOLVED','PARTIAL','UNRESOLVED'))",
            "ALTER TABLE analytics_response_facts ADD CONSTRAINT analytics_response_fact_check CHECK (environment IN ('TEST','DEMO') AND request_kind IN ('INQUIRY','PACKAGE_REQUEST','ORDER_REQUEST','COUNTER_OFFER')
                AND geo_resolution IN ('RESOLVED','PARTIAL','UNRESOLVED') AND ((responded_at IS NULL) = (response_seconds IS NULL)))",
            "ALTER TABLE analytics_presence_facts ADD CONSTRAINT analytics_presence_fact_check CHECK (environment IN ('TEST','DEMO') AND audience IN ('BUYER','VENDOR') AND geo_resolution IN ('RESOLVED','PARTIAL','UNRESOLVED'))",
            'ALTER TABLE psgc_boundaries ADD COLUMN IF NOT EXISTS geom geometry(MultiPolygon, 4326)',
            'CREATE INDEX psgc_boundaries_geom_gist ON psgc_boundaries USING GIST (geom)',
            'CREATE INDEX audit_logs_reason_trgm ON audit_logs USING GIN (reason gin_trgm_ops)',
            'CREATE INDEX enforcement_subject_state_idx ON enforcement_actions (subject_type, subject_id, state)',
        ] as $statement) {
            DB::statement($statement);
        }

        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION prevent_phase_sixteen_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Phase 16 history is append-only (%).', TG_TABLE_NAME;
END;
$$;
CREATE TRIGGER platform_setting_versions_append_only BEFORE UPDATE OR DELETE ON platform_setting_versions FOR EACH ROW EXECUTE FUNCTION prevent_phase_sixteen_history_mutation();
CREATE TRIGGER enforcement_events_append_only BEFORE UPDATE OR DELETE ON enforcement_events FOR EACH ROW EXECUTE FUNCTION prevent_phase_sixteen_history_mutation();
CREATE TRIGGER privacy_request_events_append_only BEFORE UPDATE OR DELETE ON privacy_request_events FOR EACH ROW EXECUTE FUNCTION prevent_phase_sixteen_history_mutation();
CREATE TRIGGER operation_retries_append_only BEFORE UPDATE OR DELETE ON operation_retries FOR EACH ROW EXECUTE FUNCTION prevent_phase_sixteen_history_mutation();

-- A sanction keeps its subject, kind, reason and issuer; only its lifecycle fields advance.
CREATE OR REPLACE FUNCTION protect_phase_sixteen_enforcement() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
    progress text[] := ARRAY['state','continuation_plan','continuation_note','prior_subject_state','applied_at','applied_by_user_id','applied_role','expires_at',
        'lifted_at','lifted_by_user_id','lift_reason','effective_at','correlation_id','lock_version','updated_at'];
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Enforcement history is retained.';
    END IF;
    IF (to_jsonb(NEW) - progress) IS DISTINCT FROM (to_jsonb(OLD) - progress) THEN
        RAISE EXCEPTION 'A recorded sanction is immutable; record a new action instead.';
    END IF;
    IF OLD.state = 'LIFTED' AND NEW.state <> 'LIFTED' THEN
        RAISE EXCEPTION 'A lifted sanction is final.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER enforcement_actions_protected BEFORE UPDATE OR DELETE ON enforcement_actions FOR EACH ROW EXECUTE FUNCTION protect_phase_sixteen_enforcement();

CREATE OR REPLACE FUNCTION protect_phase_sixteen_privacy() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION 'Privacy request records are retained.';
    END IF;
    IF NEW.user_id IS DISTINCT FROM OLD.user_id OR NEW.request_type IS DISTINCT FROM OLD.request_type OR NEW.reference IS DISTINCT FROM OLD.reference
        OR NEW.received_at IS DISTINCT FROM OLD.received_at OR NEW.intake_channel IS DISTINCT FROM OLD.intake_channel THEN
        RAISE EXCEPTION 'The privacy request subject, type and intake are immutable.';
    END IF;
    IF OLD.state IN ('COMPLETED','REJECTED','WITHDRAWN') THEN
        RAISE EXCEPTION 'A closed privacy request is final.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER privacy_requests_protected BEFORE UPDATE OR DELETE ON privacy_requests FOR EACH ROW EXECUTE FUNCTION protect_phase_sixteen_privacy();
SQL);
    }

    public function down(): void
    {
        // Settings history, sanctions, privacy handling and job retries are audit evidence; this migration is forward-only.
    }
};
