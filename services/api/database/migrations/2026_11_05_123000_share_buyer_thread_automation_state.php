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
        Schema::create('buyer_thread_automation_states', function (Blueprint $table): void {
            $table->foreignUuid('buyer_profile_id')->constrained('buyer_profiles')->restrictOnDelete();
            $table->foreignUuid('vendor_organization_id')->constrained('vendor_organizations')->restrictOnDelete();
            $table->timestampTz('last_automated_response_at')->nullable();
            $table->foreignUuid('active_welcome_message_id')->nullable()->constrained('messages')->restrictOnDelete();
            $table->boolean('sequence_active')->default(false);
            $table->timestampsTz();
            $table->primary(['buyer_profile_id', 'vendor_organization_id']);
        });
        // Preserve the rolling cap and human takeover when upgrading conversations with existing bot messages.
        DB::statement(<<<'SQL'
INSERT INTO buyer_thread_automation_states
 (buyer_profile_id, vendor_organization_id, last_automated_response_at, active_welcome_message_id, sequence_active, created_at, updated_at)
SELECT DISTINCT ON (c.buyer_profile_id, c.vendor_organization_id)
 c.buyer_profile_id, c.vendor_organization_id, c.last_automated_response_at, c.automated_welcome_id,
 c.automated_sequence_active AND NOT EXISTS (
  SELECT 1 FROM messages m JOIN conversations s ON s.id = m.conversation_id JOIN users u ON u.id = m.sender_user_id
  WHERE s.buyer_profile_id = c.buyer_profile_id AND s.vendor_organization_id = c.vendor_organization_id
   AND u.account_type = 'VENDOR' AND m.kind <> 'SYSTEM' AND m.sent_at >= c.last_automated_response_at
 ), NOW(), NOW()
FROM conversations c WHERE c.last_automated_response_at IS NOT NULL
ORDER BY c.buyer_profile_id, c.vendor_organization_id, c.last_automated_response_at DESC, c.id DESC
SQL);
    }

    public function down(): void
    {
        // Thread timestamps are retained on conversations; no message or commercial history is removed.
        Schema::dropIfExists('buyer_thread_automation_states');
    }
};
