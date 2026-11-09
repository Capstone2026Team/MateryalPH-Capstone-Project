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
        Schema::create('vendor_automated_responses', function (Blueprint $t): void {
            $t->foreignUuid('vendor_organization_id')->primary()->constrained('vendor_organizations')->restrictOnDelete();
            $t->boolean('enabled')->default(false);
            $t->text('welcome_message')->default('');
            $t->jsonb('options')->default('[]');
            $t->unsignedInteger('lock_version')->default(1);
            $t->timestampsTz();
        });
        Schema::table('conversations', function (Blueprint $t): void {
            $t->timestampTz('last_automated_response_at')->nullable();
            $t->uuid('automated_welcome_id')->nullable();
            $t->boolean('automated_sequence_active')->default(false);
            $t->boolean('needs_human_response')->default(false);
        });
        Schema::table('messages', fn (Blueprint $t) => $t->jsonb('automation')->nullable());
        Schema::create('conversation_automated_selections', function (Blueprint $t): void {
            $t->uuid('id')->primary();
            $t->foreignUuid('conversation_id')->constrained()->restrictOnDelete();
            $t->foreignUuid('welcome_message_id')->constrained('messages')->restrictOnDelete();
            $t->unsignedSmallInteger('option_index');
            $t->foreignUuid('buyer_message_id')->constrained('messages')->restrictOnDelete();
            $t->unique(['welcome_message_id', 'option_index']);
            $t->timestampsTz();
        });
        DB::statement("ALTER TABLE vendor_automated_responses ADD CONSTRAINT automated_response_rules_check CHECK (jsonb_typeof(options) = 'array' AND jsonb_array_length(options) <= 3 AND (NOT enabled OR length(trim(welcome_message)) > 0))");
        DB::statement('ALTER TABLE conversation_automated_selections ADD CONSTRAINT automated_option_index_check CHECK (option_index BETWEEN 0 AND 2)');
    }

    public function down(): void
    {
        if (DB::table('messages')->whereNotNull('automation')->exists()) {
            throw new RuntimeException('Automated messages and their saved choices retain conversation history and cannot be rolled back after use.');
        }
        Schema::dropIfExists('conversation_automated_selections');
        Schema::table('messages', fn (Blueprint $t) => $t->dropColumn('automation'));
        Schema::table('conversations', fn (Blueprint $t) => $t->dropColumn(['last_automated_response_at', 'automated_welcome_id', 'automated_sequence_active', 'needs_human_response']));
        Schema::dropIfExists('vendor_automated_responses');
    }
};
