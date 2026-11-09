<?php

declare(strict_types=1);

use App\Domain\Messaging\ConversationService;
use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;

return new class extends Migration
{
    public function up(): void
    {
        DB::table('orders as o')->whereExists(fn ($q) => $q->selectRaw('1')->from('conversations as f')
            ->whereColumn('f.order_id', 'o.id')->where('f.purpose', 'FULFILLMENT'))
            ->whereNotExists(fn ($q) => $q->selectRaw('1')->from('conversations as s')
                ->whereColumn('s.buyer_profile_id', 'o.buyer_profile_id')->whereColumn('s.vendor_organization_id', 'o.vendor_organization_id')
                ->where('s.purpose', 'SALES')->where('s.context_type', 'ITEM_BASED')->whereNull('s.canonical_conversation_id'))
            ->select('o.*')->chunkById(100, function ($orders): void {
                foreach ($orders as $order) {
                    app(ConversationService::class)->ensureOrderStoreChat($order);
                }
            }, 'o.id', 'id');
    }

    public function down(): void
    {
        // Retain chats and any messages written after the backfill.
    }
};
