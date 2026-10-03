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
        Schema::table('messages', function (Blueprint $table): void {
            // Opaque reference deliberately survives physical deletion of a listing.
            $table->uuid('product_id')->nullable();
            $table->jsonb('product_snapshot')->nullable();
        });
        Schema::table('conversations', function (Blueprint $table): void {
            $table->foreignUuid('canonical_conversation_id')->nullable()->constrained('conversations')->restrictOnDelete();
        });
        // Retain every immutable message, quotation, receipt, attachment and assignment.
        // Duplicate legacy inquiries remain addressable, with a link from the canonical thread.
        DB::statement(<<<'SQL'
WITH ranked AS (
 SELECT id, first_value(id) OVER (PARTITION BY buyer_profile_id, vendor_organization_id ORDER BY created_at, id) AS canonical
 FROM conversations WHERE purpose = 'SALES' AND context_type = 'ITEM_BASED'
)
UPDATE conversations c SET canonical_conversation_id = ranked.canonical
FROM ranked WHERE c.id = ranked.id AND ranked.id <> ranked.canonical
SQL);
        DB::statement("CREATE UNIQUE INDEX conversation_one_store_inquiry ON conversations(buyer_profile_id, vendor_organization_id) WHERE purpose = 'SALES' AND context_type = 'ITEM_BASED' AND canonical_conversation_id IS NULL");
        DB::statement('ALTER TABLE messages ADD CONSTRAINT message_product_snapshot_pair CHECK ((product_id IS NULL) = (product_snapshot IS NULL))');
    }

    public function down(): void
    {
        DB::statement('DROP INDEX IF EXISTS conversation_one_store_inquiry');
        DB::statement('ALTER TABLE messages DROP CONSTRAINT message_product_snapshot_pair');
        Schema::table('conversations', fn (Blueprint $t) => $t->dropConstrainedForeignId('canonical_conversation_id'));
        Schema::table('messages', fn (Blueprint $t) => $t->dropColumn(['product_id', 'product_snapshot']));
    }
};
