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
        Schema::table('conversations', function (Blueprint $table): void {
            $table->string('purpose', 16)->default('SALES');
            $table->foreignUuid('order_id')->nullable()->unique()->constrained()->restrictOnDelete();
            $table->foreignId('handler_user_id')->nullable()->constrained('users')->restrictOnDelete();
            $table->jsonb('locked_reference')->default('{}');
            $table->unsignedInteger('lock_version')->default(1);
            $table->index(['buyer_profile_id', 'updated_at']);
            $table->index(['vendor_organization_id', 'purpose', 'updated_at']);
        });
        Schema::table('conversation_participants', function (Blueprint $table): void {
            $table->timestampTz('revoked_at')->nullable();
        });
        Schema::table('conversation_assignments', function (Blueprint $table): void {
            $table->string('assigned_role', 32)->nullable();
            $table->string('reason', 500)->nullable();
        });
        Schema::table('messages', function (Blueprint $table): void {
            $table->string('kind', 24)->default('TEXT');
            $table->jsonb('public_sender')->default('{}');
            $table->index(['conversation_id', 'id']);
        });
        Schema::table('message_attachments', function (Blueprint $table): void {
            $table->string('disk')->nullable();
            $table->string('storage_key')->nullable();
            $table->string('media_type', 100)->nullable();
            $table->unsignedBigInteger('size_bytes')->nullable();
            $table->string('display_name')->nullable();
            $table->string('purpose', 24)->default('SALES');
        });
        Schema::create('order_fulfillment_assignments', function (Blueprint $table): void {
            $table->uuid('id')->primary();
            $table->foreignUuid('order_id')->constrained()->restrictOnDelete();
            $table->foreignId('user_id')->constrained()->restrictOnDelete();
            $table->foreignId('assigned_by_user_id')->constrained('users')->restrictOnDelete();
            $table->timestampTz('ended_at')->nullable();
            $table->timestampsTz();
        });
        Schema::table('quotations', function (Blueprint $table): void {
            $table->jsonb('draft')->nullable();
            $table->unsignedInteger('lock_version')->default(1);
            $table->timestampTz('response_due_at')->nullable()->index();
            $table->timestampTz('reminded_at')->nullable();
        });
        Schema::table('quotation_versions', function (Blueprint $table): void {
            $table->jsonb('content')->default('{}');
            $table->string('actor_role', 32)->nullable();
            $table->string('price_source', 32)->default('PRIVATE_TRANSACTION');
            $table->unsignedSmallInteger('deadline_hours')->default(24);
        });
        Schema::table('quotation_lines', function (Blueprint $table): void {
            $table->jsonb('source_snapshot')->default('{}');
        });
        Schema::table('financial_snapshots', function (Blueprint $table): void {
            $table->string('price_source', 32)->default('PRIVATE_TRANSACTION');
        });
        if (DB::getDriverName() === 'pgsql') {
            DB::unprepared(<<<'SQL'
CREATE UNIQUE INDEX conversation_one_handler ON conversation_assignments(conversation_id) WHERE ended_at IS NULL;
CREATE UNIQUE INDEX fulfillment_one_assignee ON order_fulfillment_assignments(order_id) WHERE ended_at IS NULL;
CREATE UNIQUE INDEX conversation_one_quotation ON quotations(conversation_id);
ALTER TABLE conversations ADD CONSTRAINT conversation_purpose_order CHECK ((purpose = 'SALES' AND order_id IS NULL AND context_type IN ('ITEM_BASED','PROJECT_BASED')) OR (purpose = 'FULFILLMENT' AND order_id IS NOT NULL));
ALTER TABLE quotation_versions ADD CONSTRAINT quotation_deadline_range CHECK (deadline_hours BETWEEN 1 AND 72 AND price_source = 'PRIVATE_TRANSACTION');
CREATE OR REPLACE FUNCTION prevent_phase_nine_history_mutation() RETURNS trigger LANGUAGE plpgsql AS $$
BEGIN RAISE EXCEPTION 'Conversation and published quotation history is append-only (%).', TG_TABLE_NAME; END;
$$;
CREATE TRIGGER quotation_versions_append_only BEFORE UPDATE OR DELETE ON quotation_versions FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();
CREATE TRIGGER quotation_lines_append_only BEFORE UPDATE OR DELETE ON quotation_lines FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();
CREATE TRIGGER quotation_changes_append_only BEFORE UPDATE OR DELETE ON quotation_changes FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();
CREATE TRIGGER quotation_events_append_only BEFORE UPDATE OR DELETE ON quotation_events FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();
CREATE TRIGGER messages_append_only BEFORE UPDATE OR DELETE ON messages FOR EACH ROW EXECUTE FUNCTION prevent_phase_nine_history_mutation();
SQL);
        }
    }

    public function down(): void
    {
        if (DB::getDriverName() === 'pgsql') {
            foreach (['quotation_versions', 'quotation_lines', 'quotation_changes', 'quotation_events', 'messages'] as $table) {
                DB::statement("DROP TRIGGER IF EXISTS {$table}_append_only ON {$table}");
            }
            DB::statement('DROP FUNCTION IF EXISTS prevent_phase_nine_history_mutation()');
            DB::statement('DROP INDEX IF EXISTS conversation_one_handler');
            DB::statement('DROP INDEX IF EXISTS conversation_one_quotation');
            DB::statement('ALTER TABLE conversations DROP CONSTRAINT conversation_purpose_order');
            DB::statement('ALTER TABLE quotation_versions DROP CONSTRAINT quotation_deadline_range');
        }
        Schema::dropIfExists('order_fulfillment_assignments');
        Schema::table('conversations', function (Blueprint $table): void {
            $table->dropForeign(['order_id']);
            $table->dropForeign(['handler_user_id']);
            $table->dropColumn(['purpose', 'order_id', 'handler_user_id', 'locked_reference', 'lock_version']);
        });
        Schema::table('conversation_participants', fn (Blueprint $t) => $t->dropColumn('revoked_at'));
        Schema::table('conversation_assignments', fn (Blueprint $t) => $t->dropColumn(['assigned_role', 'reason']));
        Schema::table('messages', fn (Blueprint $t) => $t->dropColumn(['kind', 'public_sender']));
        Schema::table('message_attachments', fn (Blueprint $t) => $t->dropColumn(['disk', 'storage_key', 'media_type', 'size_bytes', 'display_name', 'purpose']));
        Schema::table('quotations', fn (Blueprint $t) => $t->dropColumn(['draft', 'lock_version', 'response_due_at', 'reminded_at']));
        Schema::table('quotation_versions', fn (Blueprint $t) => $t->dropColumn(['content', 'actor_role', 'price_source', 'deadline_hours']));
        Schema::table('quotation_lines', fn (Blueprint $t) => $t->dropColumn('source_snapshot'));
        Schema::table('financial_snapshots', fn (Blueprint $t) => $t->dropColumn('price_source'));
    }
};
