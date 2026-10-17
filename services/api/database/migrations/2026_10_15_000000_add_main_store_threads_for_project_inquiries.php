<?php

declare(strict_types=1);

use Illuminate\Database\Migrations\Migration;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

return new class extends Migration
{
    public function up(): void
    {
        // Add an empty main chat for existing project-only pairs. Never move commercial history.
        $pairs = DB::table('conversations as c')->where('c.purpose', 'SALES')->where('c.context_type', 'PROJECT_BASED')
            ->join('buyer_profiles as b', 'b.id', '=', 'c.buyer_profile_id')
            ->join('vendor_memberships as m', fn ($q) => $q->on('m.vendor_organization_id', '=', 'c.vendor_organization_id')->where('m.role', 'OWNER')->where('m.status', 'ACTIVE'))
            ->whereNotExists(fn ($q) => $q->selectRaw('1')->from('conversations as main')->whereColumn('main.buyer_profile_id', 'c.buyer_profile_id')
                ->whereColumn('main.vendor_organization_id', 'c.vendor_organization_id')->where('main.purpose', 'SALES')->where('main.context_type', 'ITEM_BASED')->whereNull('main.canonical_conversation_id'))
            ->select('c.buyer_profile_id', 'c.vendor_organization_id', 'b.user_id as buyer_user_id', 'm.user_id as owner_user_id')->distinct()->get();
        foreach ($pairs as $pair) {
            $id = (string) Str::uuid7();
            $threads = DB::table('conversations')->where('buyer_profile_id', $pair->buyer_profile_id)->where('vendor_organization_id', $pair->vendor_organization_id)
                ->where('purpose', 'SALES')->whereNull('canonical_conversation_id');
            $timestamps = (clone $threads)->selectRaw('MIN(created_at) AS created_at, MAX(updated_at) AS updated_at')->first();
            $allArchived = ! (clone $threads)->whereNotIn('id', DB::table('conversation_archives')->where('user_id', $pair->buyer_user_id)->select('conversation_id'))->exists();
            DB::table('conversations')->insert(['id' => $id, 'buyer_profile_id' => $pair->buyer_profile_id, 'vendor_organization_id' => $pair->vendor_organization_id,
                'purpose' => 'SALES', 'context_type' => 'ITEM_BASED', 'handler_user_id' => $pair->owner_user_id, 'locked_reference' => '{}', 'created_at' => $timestamps->created_at, 'updated_at' => $timestamps->updated_at]);
            if ($allArchived) {
                DB::table('conversation_archives')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'user_id' => $pair->buyer_user_id,
                    'archived_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
            }
            foreach ([$pair->buyer_user_id => 'BUYER', $pair->owner_user_id => 'OWNER'] as $userId => $role) {
                DB::table('conversation_participants')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'user_id' => $userId,
                    'participant_role' => $role, 'created_at' => now(), 'updated_at' => now()]);
            }
            DB::table('conversation_assignments')->insert(['id' => (string) Str::uuid7(), 'conversation_id' => $id, 'assigned_user_id' => $pair->owner_user_id,
                'assigned_role' => 'OWNER', 'created_at' => now(), 'updated_at' => now()]);
        }
    }

    public function down(): void
    {
        // These chats may now contain messages or quotations; retain them on rollback.
    }
};
