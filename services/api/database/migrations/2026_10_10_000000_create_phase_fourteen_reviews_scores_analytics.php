<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Facades\Schema;
use Illuminate\Support\Str;

/**
 * Phase 14: verified-purchase reviews (14-day window, blind reveal, 24-hour correction, dispute withholding,
 * append-only revisions and moderation), metric events projected from authoritative order/fulfillment/dispute/
 * message facts, reversible score exclusions, daily score snapshots, automatic badges with Admin suppression, and
 * MAT-04 immutable price observations that keep the captured store geography. Extends the Phase 1 tables in place.
 */
return new class extends Migration
{
    private const BADGES = [
        'FAST_RESPONDER' => ['Fast Responder', ['crr_min_percent' => '85.00', 'min_inquiries' => 10, 'window_days' => 30]],
        'ON_TIME' => ['On-Time', ['frr_min_percent' => '95.00', 'min_fulfilled_orders' => 10, 'window_days' => 90]],
        'MOST_ORDERED' => ['Most Ordered', ['top_percent' => 10, 'min_completed_orders' => 20, 'window_days' => 90, 'scope' => 'CANONICAL_CATEGORY_AND_REGISTERED_PROVINCE']],
        'HIGHLY_RATED' => ['Highly Rated', ['vcs_min' => '4.50', 'min_vendor_ratings' => 10, 'window_days' => 90]],
        'HIGH_QUALITY_MATERIALS' => ['High-Quality Materials', ['mqs_min' => '4.60', 'min_product_ratings' => 10, 'window_days' => 90]],
        'TRUSTED_SUPPLIER' => ['Trusted Supplier', ['verified_min_days' => 90, 'vcs_min' => '4.50', 'ohs_min' => '4.50', 'min_completed_orders' => 25]],
        'BEST_PRICE' => ['Best Price', ['basis' => 'LOWEST_ACTIVE_COMPARABLE_UNIT_PRICE_IN_SELECTED_RADIUS', 'evaluated' => 'AT_QUERY_TIME']],
    ];

    public function up(): void
    {
        Schema::table('reviews', function (Blueprint $table): void {
            $table->foreignUuid('vendor_organization_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('buyer_profile_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_listing_id')->nullable()->constrained()->restrictOnDelete();
            $table->string('reviewer_party', 8)->default('BUYER');
            $table->string('reviewer_role', 32)->nullable();
            $table->unsignedTinyInteger('service_quality')->nullable();
            $table->unsignedTinyInteger('speed_rating')->nullable();
            $table->string('speed_kind', 24)->nullable();
            $table->unsignedTinyInteger('inquiry_seriousness')->nullable();
            $table->unsignedTinyInteger('communication_quality')->nullable();
            $table->unsignedTinyInteger('payment_reliability')->nullable();
            $table->string('display_name_choice', 32)->default('FIRST_NAME_LAST_INITIAL');
            $table->string('public_display_name', 80)->nullable();
            $table->timestampTz('submitted_at')->nullable();
            $table->timestampTz('editable_until')->nullable();
            $table->timestampTz('edited_at')->nullable();
            $table->unsignedInteger('revision')->default(1);
            $table->string('moderation_state', 32)->default('NONE');
            $table->timestampTz('correction_due_at')->nullable();
            $table->timestampTz('corrected_at')->nullable();
            $table->string('environment', 8)->default('TEST');
            $table->unsignedInteger('lock_version')->default(1);
            $table->index(['vendor_organization_id', 'review_type', 'submitted_at']);
            $table->index(['vendor_listing_id', 'review_type']);
            $table->index(['moderation_state', 'updated_at']);
        });
        Schema::create('review_windows', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_id')->unique()->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('buyer_profile_id')->constrained()->restrictOnDelete();
            $table->timestampTz('completed_at');
            $table->timestampTz('closes_at');
            $table->timestampTz('revealed_at')->nullable();
            $table->string('reveal_reason', 24)->nullable();
            $table->timestampsTz();
            $table->index(['revealed_at', 'closes_at']);
        });
        Schema::create('review_revisions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('review_id')->constrained()->restrictOnDelete();
            $table->unsignedInteger('revision');
            $table->jsonb('content');
            $table->foreignId('actor_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->string('reason', 32);
            $table->timestampTz('created_at');
            $table->unique(['review_id', 'revision']);
        });
        Schema::table('review_media', function (Blueprint $table): void {
            $table->foreignUuid('file_id')->nullable()->constrained('files')->restrictOnDelete();
            $table->unsignedSmallInteger('sort_order')->default(0);
            $table->timestampTz('retired_at')->nullable();
        });
        Schema::table('review_moderation', function (Blueprint $table): void {
            $table->string('action', 32)->nullable();
            $table->string('from_state', 32)->nullable();
            $table->string('to_state', 32)->nullable();
            $table->text('reason')->nullable();
            $table->string('actor_role', 48)->nullable();
            $table->foreignUuid('review_flag_id')->nullable();
            $table->string('correlation_id', 64)->nullable();
            $table->index(['review_id', 'created_at']);
        });
        Schema::create('review_flags', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('review_id')->constrained()->restrictOnDelete();
            $table->foreignId('reporter_user_id')->constrained('users')->restrictOnDelete();
            $table->string('reporter_party', 8);
            $table->string('reason_code', 32);
            $table->text('details')->nullable();
            $table->string('state', 16)->default('OPEN');
            $table->foreignId('resolved_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->timestampTz('resolved_at')->nullable();
            $table->timestampsTz();
            $table->unique(['review_id', 'reporter_user_id']);
            $table->index(['state', 'created_at']);
        });
        Schema::table('review_moderation', fn (Blueprint $table) => $table->foreign('review_flag_id')->references('id')->on('review_flags')->restrictOnDelete());

        Schema::table('metric_events', function (Blueprint $table): void {
            $table->foreignUuid('order_id')->nullable()->constrained()->restrictOnDelete();
            $table->timestampTz('occurred_at')->nullable();
            $table->string('environment', 8)->default('TEST');
            $table->string('source_kind', 32)->default('DISPUTE_DECISION');
            $table->jsonb('details')->nullable();
            $table->index(['vendor_organization_id', 'metric', 'occurred_at']);
        });
        Schema::create('score_exclusions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->string('reason_code', 24);
            $table->text('note');
            $table->foreignId('created_by_user_id')->constrained('users')->restrictOnDelete();
            $table->string('created_role', 48);
            $table->timestampTz('revoked_at')->nullable();
            $table->foreignId('revoked_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->text('revoke_reason')->nullable();
            $table->string('correlation_id', 64)->nullable();
            $table->timestampsTz();
            $table->index(['vendor_organization_id', 'created_at']);
        });
        Schema::table('score_snapshots', function (Blueprint $table): void {
            $table->decimal('crr', 5, 2)->nullable();
            $table->decimal('frr', 5, 2)->nullable();
            $table->date('ohs_calculated_on')->nullable();
            $table->jsonb('components')->nullable();
            $table->string('algorithm_version', 32)->default('scores.v1');
            $table->string('environment', 8)->default('TEST');
            $table->timestampTz('calculated_at')->nullable();
        });
        Schema::table('vendor_badge_history', function (Blueprint $table): void {
            $table->string('scope_key', 96)->default('');
            $table->string('scope_label')->nullable();
            $table->string('revocation_reason', 32)->nullable();
            $table->jsonb('evidence')->nullable();
            $table->index(['vendor_organization_id', 'revoked_at']);
        });
        Schema::create('badge_suppressions', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('vendor_organization_id')->constrained()->restrictOnDelete();
            $table->foreignUuid('badge_definition_id')->constrained()->restrictOnDelete();
            $table->string('reason_code', 24);
            $table->string('case_reference', 120);
            $table->text('note');
            $table->foreignId('created_by_user_id')->constrained('users')->restrictOnDelete();
            $table->string('created_role', 48);
            $table->timestampTz('lifted_at')->nullable();
            $table->foreignId('lifted_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->text('lift_reason')->nullable();
            $table->string('correlation_id', 64)->nullable();
            $table->timestampsTz();
        });

        Schema::table('price_observations', function (Blueprint $table): void {
            $table->foreignUuid('vendor_listing_id')->nullable()->constrained()->restrictOnDelete();
            $table->foreignUuid('comparable_group_id')->nullable()->constrained('material_comparable_groups')->restrictOnDelete();
            // The captured address version is an immutable reference; the observation keeps its own point and PSGC codes.
            $table->uuid('vendor_address_version_id')->nullable()->index();
            $table->string('psgc_region_code', 16)->nullable();
            $table->string('psgc_province_code', 16)->nullable();
            $table->string('psgc_city_code', 16)->nullable();
        });
        Schema::table('analytics_refresh_runs', function (Blueprint $table): void {
            $table->foreignId('reviewed_by_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->unsignedInteger('selected_vendor_count')->default(0);
        });

        $this->seedBadges();
        $this->grantAdminPermissions();

        if (DB::getDriverName() !== 'pgsql') {
            return;
        }
        DB::statement('UPDATE metric_events SET occurred_at = created_at WHERE occurred_at IS NULL');
        DB::statement('ALTER TABLE metric_events ALTER COLUMN occurred_at SET DEFAULT now()');
        DB::statement('ALTER TABLE metric_events ALTER COLUMN occurred_at SET NOT NULL');
        DB::statement('ALTER TABLE metric_events ALTER COLUMN metric TYPE varchar(40)');
        DB::statement('UPDATE metric_events m SET order_id = c.order_id FROM dispute_decisions d JOIN dispute_cases c ON c.id = d.dispute_case_id WHERE m.order_id IS NULL AND m.source_id = d.id');
        DB::statement('ALTER TABLE reviews ALTER COLUMN rating DROP NOT NULL');
        DB::statement('ALTER TABLE price_observations ALTER COLUMN address_id DROP NOT NULL');
        DB::statement('ALTER TABLE price_observations ADD COLUMN store_location geography(Point,4326)');
        DB::statement('CREATE INDEX price_observations_store_location_gist ON price_observations USING gist (store_location)');
        DB::statement('CREATE INDEX price_observations_series_index ON price_observations (environment, dataset_id, comparable_group_id, local_snapshot_date) WHERE selected_for_average');

        $statements = [
            "ALTER TABLE reviews ADD CONSTRAINT review_type_check CHECK (review_type IN ('VENDOR','PRODUCT','BUYER'))",
            "ALTER TABLE reviews ADD CONSTRAINT review_party_check CHECK ((review_type = 'BUYER') = (reviewer_party = 'VENDOR'))",
            'ALTER TABLE reviews ADD CONSTRAINT review_scores_range_check CHECK ((rating IS NULL OR rating BETWEEN 1 AND 5) AND (service_quality IS NULL OR service_quality BETWEEN 1 AND 5) AND (speed_rating IS NULL OR speed_rating BETWEEN 1 AND 5)
                AND (inquiry_seriousness IS NULL OR inquiry_seriousness BETWEEN 1 AND 5) AND (communication_quality IS NULL OR communication_quality BETWEEN 1 AND 5) AND (payment_reliability IS NULL OR payment_reliability BETWEEN 1 AND 5))',
            "ALTER TABLE reviews ADD CONSTRAINT review_shape_check CHECK (submitted_at IS NULL
                OR (review_type = 'PRODUCT' AND rating IS NOT NULL AND order_line_id IS NOT NULL AND vendor_listing_id IS NOT NULL)
                OR (review_type = 'VENDOR' AND service_quality IS NOT NULL AND speed_rating IS NOT NULL AND speed_kind IN ('DELIVERY_SPEED','PROCESSING_SPEED') AND order_line_id IS NULL)
                OR (review_type = 'BUYER' AND inquiry_seriousness IS NOT NULL AND communication_quality IS NOT NULL AND payment_reliability IS NOT NULL AND order_line_id IS NULL))",
            'ALTER TABLE reviews ADD CONSTRAINT review_comment_length_check CHECK (comment IS NULL OR char_length(comment) <= 1000)',
            "ALTER TABLE reviews ADD CONSTRAINT review_display_choice_check CHECK (display_name_choice IN ('FIRST_NAME_LAST_INITIAL','VERIFIED_BUYER','STORE_NAME'))",
            "ALTER TABLE reviews ADD CONSTRAINT review_moderation_state_check CHECK (moderation_state IN ('NONE','FLAGGED','HIDDEN_PENDING_REVIEW','CORRECTION_REQUESTED','REMOVED'))",
            'ALTER TABLE reviews ADD CONSTRAINT review_edit_window_check CHECK (editable_until IS NULL OR submitted_at IS NULL OR editable_until = submitted_at + interval \'24 hours\')',
            "CREATE UNIQUE INDEX reviews_one_party_rating_per_order ON reviews (order_id, review_type) WHERE review_type IN ('VENDOR','BUYER')",
            "CREATE UNIQUE INDEX reviews_one_product_review_per_line ON reviews (order_id, order_line_id) WHERE review_type = 'PRODUCT'",
            "ALTER TABLE review_windows ADD CONSTRAINT review_window_check CHECK (closes_at = completed_at + interval '14 days' AND (revealed_at IS NULL) = (reveal_reason IS NULL) AND (reveal_reason IS NULL OR reveal_reason IN ('BOTH_SUBMITTED','WINDOW_EXPIRED')))",
            "ALTER TABLE review_revisions ADD CONSTRAINT review_revision_reason_check CHECK (reason IN ('SUBMITTED','EDITED','CORRECTED'))",
            "ALTER TABLE review_moderation ADD CONSTRAINT review_moderation_action_check CHECK (action IS NULL OR action IN ('FLAG_RAISED','DISMISS_FLAG','REQUEST_CORRECTION','HIDE_PENDING_REVIEW','REMOVE','CORRECTION_SUBMITTED','RESTORE'))",
            "ALTER TABLE review_flags ADD CONSTRAINT review_flag_check CHECK (reporter_party IN ('BUYER','VENDOR') AND state IN ('OPEN','DISMISSED','ACTIONED') AND reason_code IN ('OFFENSIVE','PERSONAL_INFORMATION','SPAM','IRRELEVANT','CONFLICT_OF_INTEREST','FALSE_CLAIM','OTHER')
                AND ((state = 'OPEN') = (resolved_at IS NULL)))",
            "ALTER TABLE metric_events ADD CONSTRAINT metric_event_environment_check CHECK (environment IN ('TEST','DEMO','LIVE'))",
            "ALTER TABLE score_exclusions ADD CONSTRAINT score_exclusion_check CHECK (reason_code IN ('FRAUD','DUPLICATE','TEST','INVALID_SOURCE') AND char_length(note) >= 10 AND ((revoked_at IS NULL) = (revoked_by_user_id IS NULL)) AND (revoked_at IS NULL OR revoke_reason IS NOT NULL))",
            'CREATE UNIQUE INDEX score_exclusions_one_active_per_order ON score_exclusions (order_id) WHERE revoked_at IS NULL',
            "ALTER TABLE vendor_badge_history ADD CONSTRAINT badge_history_revocation_check CHECK ((revoked_at IS NULL) = (revocation_reason IS NULL) AND (revocation_reason IS NULL OR revocation_reason IN ('CRITERIA_NOT_MET')))",
            'CREATE UNIQUE INDEX vendor_badge_one_active_award ON vendor_badge_history (vendor_organization_id, badge_definition_id, scope_key) WHERE revoked_at IS NULL',
            "ALTER TABLE badge_suppressions ADD CONSTRAINT badge_suppression_check CHECK (reason_code IN ('FRAUD','COMPLIANCE') AND char_length(note) >= 10 AND char_length(case_reference) >= 3 AND ((lifted_at IS NULL) = (lifted_by_user_id IS NULL)) AND (lifted_at IS NULL OR lift_reason IS NOT NULL))",
            'CREATE UNIQUE INDEX badge_suppressions_one_active ON badge_suppressions (vendor_organization_id, badge_definition_id) WHERE lifted_at IS NULL',
            'ALTER TABLE score_snapshots ADD CONSTRAINT score_snapshot_range_check CHECK ((vcs IS NULL OR vcs BETWEEN 1 AND 5) AND (mqs IS NULL OR mqs BETWEEN 1 AND 5) AND (ohs IS NULL OR ohs BETWEEN 1 AND 5) AND (vps IS NULL OR vps BETWEEN 1 AND 5)
                AND (crr IS NULL OR crr BETWEEN 0 AND 100) AND (frr IS NULL OR frr BETWEEN 0 AND 100) AND (vps IS NULL OR (vcs IS NOT NULL AND ohs IS NOT NULL)))',
        ];
        foreach ($statements as $statement) {
            DB::statement($statement);
        }

        DB::unprepared(<<<'SQL'
CREATE OR REPLACE FUNCTION prevent_phase_fourteen_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Review, score and price history is append-only (%).', TG_TABLE_NAME;
END;
$$;
CREATE TRIGGER review_revisions_append_only BEFORE UPDATE OR DELETE ON review_revisions FOR EACH ROW EXECUTE FUNCTION prevent_phase_fourteen_history_mutation();
CREATE TRIGGER review_moderation_append_only BEFORE UPDATE OR DELETE ON review_moderation FOR EACH ROW EXECUTE FUNCTION prevent_phase_fourteen_history_mutation();
CREATE TRIGGER metric_events_append_only BEFORE UPDATE OR DELETE ON metric_events FOR EACH ROW EXECUTE FUNCTION prevent_phase_fourteen_history_mutation();
CREATE TRIGGER score_snapshots_append_only BEFORE UPDATE OR DELETE ON score_snapshots FOR EACH ROW EXECUTE FUNCTION prevent_phase_fourteen_history_mutation();
CREATE TRIGGER price_observations_append_only BEFORE UPDATE OR DELETE ON price_observations FOR EACH ROW EXECUTE FUNCTION prevent_phase_fourteen_history_mutation();

-- A Buyer review is never deleted; only moderation state changes, and only its author's content fields change during
-- the 24-hour correction window or an Admin-requested correction (enforced by the service and the revision log).
CREATE OR REPLACE FUNCTION prevent_review_deletion() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN
    RAISE EXCEPTION 'Reviews are never deleted; moderation hides or removes them with a recorded reason.';
END;
$$;
CREATE TRIGGER reviews_never_deleted BEFORE DELETE ON reviews FOR EACH ROW EXECUTE FUNCTION prevent_review_deletion();
CREATE TRIGGER review_windows_never_deleted BEFORE DELETE ON review_windows FOR EACH ROW EXECUTE FUNCTION prevent_review_deletion();

-- Exclusions and suppressions may only gain their single revocation/lift; nothing else changes and nothing is deleted.
CREATE OR REPLACE FUNCTION guard_phase_fourteen_reversal() RETURNS trigger LANGUAGE plpgsql AS $$
DECLARE
    allowed text[];
BEGIN
    IF TG_OP = 'DELETE' THEN
        RAISE EXCEPTION '% rows are retained for audit.', TG_TABLE_NAME;
    END IF;
    allowed := CASE TG_TABLE_NAME
        WHEN 'score_exclusions' THEN ARRAY['revoked_at','revoked_by_user_id','revoke_reason','updated_at']
        WHEN 'badge_suppressions' THEN ARRAY['lifted_at','lifted_by_user_id','lift_reason','updated_at']
        ELSE ARRAY['revoked_at','revocation_reason','updated_at'] END;
    IF (to_jsonb(NEW) - allowed) IS DISTINCT FROM (to_jsonb(OLD) - allowed) THEN
        RAISE EXCEPTION 'Only the recorded reversal may change on %.', TG_TABLE_NAME;
    END IF;
    -- Field access goes through jsonb because PL/pgSQL does not short-circuit across differently shaped tables.
    IF TG_TABLE_NAME IN ('score_exclusions', 'vendor_badge_history') AND (to_jsonb(OLD) ->> 'revoked_at') IS NOT NULL THEN
        RAISE EXCEPTION 'A reversal on % is final; a new record is required.', TG_TABLE_NAME;
    END IF;
    IF TG_TABLE_NAME = 'badge_suppressions' AND (to_jsonb(OLD) ->> 'lifted_at') IS NOT NULL THEN
        RAISE EXCEPTION 'A lifted badge suppression is final.';
    END IF;
    RETURN NEW;
END;
$$;
CREATE TRIGGER score_exclusions_reversal_only BEFORE UPDATE OR DELETE ON score_exclusions FOR EACH ROW EXECUTE FUNCTION guard_phase_fourteen_reversal();
CREATE TRIGGER badge_suppressions_reversal_only BEFORE UPDATE OR DELETE ON badge_suppressions FOR EACH ROW EXECUTE FUNCTION guard_phase_fourteen_reversal();
CREATE TRIGGER vendor_badge_history_reversal_only BEFORE UPDATE OR DELETE ON vendor_badge_history FOR EACH ROW EXECUTE FUNCTION guard_phase_fourteen_reversal();
SQL);
    }

    private function seedBadges(): void
    {
        foreach (self::BADGES as $code => [$name, $rule]) {
            if (! DB::table('badge_definitions')->where('code', $code)->exists()) {
                DB::table('badge_definitions')->insert(['id' => (string) Str::uuid7(), 'code' => $code, 'name' => $name, 'rule' => json_encode($rule, JSON_THROW_ON_ERROR), 'version' => 1, 'created_at' => now(), 'updated_at' => now()]);
            }
        }
    }

    private function grantAdminPermissions(): void
    {
        // Review moderation and score investigation: Super Admin and User Management Staff (approved by the project
        // owner on 2026-10-04); Order and Dispute Staff monitor scores read-only. Analytics export is Super Admin only.
        $grants = [
            'reviews.moderate' => ['Moderate Product Reviews and Vendor ratings with a recorded reason', ['ADMIN_SUPERADMIN', 'ADMIN_USER_MANAGEMENT']],
            'scores.view' => ['View Vendor scores, badges, sample sizes and source events', ['ADMIN_SUPERADMIN', 'ADMIN_USER_MANAGEMENT', 'ADMIN_ORDER_DISPUTE']],
            'scores.investigate' => ['Exclude or restore score source orders and suppress badges for documented fraud or compliance cases', ['ADMIN_SUPERADMIN', 'ADMIN_USER_MANAGEMENT']],
            'analytics.export' => ['Export authorized aggregate analytics', ['ADMIN_SUPERADMIN']],
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

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared(<<<'SQL'
DROP TRIGGER IF EXISTS review_revisions_append_only ON review_revisions;
DROP TRIGGER IF EXISTS review_moderation_append_only ON review_moderation;
DROP TRIGGER IF EXISTS metric_events_append_only ON metric_events;
DROP TRIGGER IF EXISTS score_snapshots_append_only ON score_snapshots;
DROP TRIGGER IF EXISTS price_observations_append_only ON price_observations;
DROP TRIGGER IF EXISTS reviews_never_deleted ON reviews;
DROP TRIGGER IF EXISTS review_windows_never_deleted ON review_windows;
DROP TRIGGER IF EXISTS score_exclusions_reversal_only ON score_exclusions;
DROP TRIGGER IF EXISTS badge_suppressions_reversal_only ON badge_suppressions;
DROP TRIGGER IF EXISTS vendor_badge_history_reversal_only ON vendor_badge_history;
DROP FUNCTION IF EXISTS prevent_phase_fourteen_history_mutation();
DROP FUNCTION IF EXISTS prevent_review_deletion();
DROP FUNCTION IF EXISTS guard_phase_fourteen_reversal();
SQL);
            foreach (['review_type_check', 'review_party_check', 'review_scores_range_check', 'review_shape_check', 'review_comment_length_check', 'review_display_choice_check', 'review_moderation_state_check', 'review_edit_window_check'] as $constraint) {
                DB::statement("ALTER TABLE reviews DROP CONSTRAINT IF EXISTS {$constraint}");
            }
            DB::statement('DROP INDEX IF EXISTS reviews_one_party_rating_per_order');
            DB::statement('DROP INDEX IF EXISTS reviews_one_product_review_per_line');
            DB::statement('ALTER TABLE metric_events DROP CONSTRAINT IF EXISTS metric_event_environment_check');
            DB::statement('ALTER TABLE score_snapshots DROP CONSTRAINT IF EXISTS score_snapshot_range_check');
            DB::statement('ALTER TABLE vendor_badge_history DROP CONSTRAINT IF EXISTS badge_history_revocation_check');
            DB::statement('DROP INDEX IF EXISTS vendor_badge_one_active_award');
            DB::statement('DROP INDEX IF EXISTS price_observations_series_index');
            DB::statement('DROP INDEX IF EXISTS price_observations_store_location_gist');
            DB::statement('ALTER TABLE price_observations DROP COLUMN IF EXISTS store_location');
        }
        Schema::table('analytics_refresh_runs', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('reviewed_by_user_id');
            $table->dropColumn('selected_vendor_count');
        });
        Schema::table('price_observations', function (Blueprint $table): void {
            $table->dropColumn('vendor_address_version_id');
            foreach (['vendor_listing_id', 'comparable_group_id'] as $foreign) {
                $table->dropConstrainedForeignId($foreign);
            }
            $table->dropColumn(['psgc_region_code', 'psgc_province_code', 'psgc_city_code']);
        });
        Schema::dropIfExists('badge_suppressions');
        Schema::table('vendor_badge_history', function (Blueprint $table): void {
            $table->dropIndex(['vendor_organization_id', 'revoked_at']);
            $table->dropColumn(['scope_key', 'scope_label', 'revocation_reason', 'evidence']);
        });
        Schema::table('score_snapshots', fn (Blueprint $table) => $table->dropColumn(['crr', 'frr', 'ohs_calculated_on', 'components', 'algorithm_version', 'environment', 'calculated_at']));
        Schema::dropIfExists('score_exclusions');
        Schema::table('metric_events', function (Blueprint $table): void {
            $table->dropIndex(['vendor_organization_id', 'metric', 'occurred_at']);
            $table->dropConstrainedForeignId('order_id');
            $table->dropColumn(['occurred_at', 'environment', 'source_kind', 'details']);
        });
        Schema::table('review_moderation', function (Blueprint $table): void {
            $table->dropForeign(['review_flag_id']);
            $table->dropIndex(['review_id', 'created_at']);
            $table->dropColumn(['action', 'from_state', 'to_state', 'reason', 'actor_role', 'review_flag_id', 'correlation_id']);
        });
        Schema::dropIfExists('review_flags');
        Schema::table('review_media', function (Blueprint $table): void {
            $table->dropConstrainedForeignId('file_id');
            $table->dropColumn(['sort_order', 'retired_at']);
        });
        Schema::dropIfExists('review_revisions');
        Schema::dropIfExists('review_windows');
        Schema::table('reviews', function (Blueprint $table): void {
            $table->dropIndex(['vendor_organization_id', 'review_type', 'submitted_at']);
            $table->dropIndex(['vendor_listing_id', 'review_type']);
            $table->dropIndex(['moderation_state', 'updated_at']);
            foreach (['vendor_organization_id', 'buyer_profile_id', 'vendor_listing_id'] as $foreign) {
                $table->dropConstrainedForeignId($foreign);
            }
            $table->dropColumn(['reviewer_party', 'reviewer_role', 'service_quality', 'speed_rating', 'speed_kind', 'inquiry_seriousness', 'communication_quality', 'payment_reliability',
                'display_name_choice', 'public_display_name', 'submitted_at', 'editable_until', 'edited_at', 'revision', 'moderation_state', 'correction_due_at', 'corrected_at', 'environment', 'lock_version']);
        });
        // Badge definitions and permission grants may already be referenced by history and audit records.
    }
};
