<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Models\User;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\DB;

final class ConversationBroadcast
{
    public function deliver(string $id): void
    {
        if (config('broadcasting.default') !== 'reverb') {
            return; // REST synchronization remains available when realtime is not configured.
        }
        $c = DB::table('conversations')->where('id', $id)->first();
        if ($c === null) {
            return;
        }
        $buyerId = DB::table('buyer_profiles')->where('id', $c->buyer_profile_id)->value('user_id');
        $ids = DB::table('vendor_memberships')->where('vendor_organization_id', $c->vendor_organization_id)->where('status', 'ACTIVE')->pluck('user_id')->all();
        $ids[] = $buyerId;
        $access = app(ConversationAccess::class);
        foreach (User::query()->whereIn('id', $ids)->cursor() as $user) {
            if ($access->allows($user, $c)) {
                // No message text, commercial data or files are ever sent to a socket. REST reauthorizes each fetch.
                Broadcast::connection('reverb')->broadcast(['private-'.$access->channel($user, $c)], 'conversation.changed', ['conversation_id' => $id]);
                $inbox = app(BuyerInboxChannel::class)->name($user);
                if ($inbox !== null) {
                    Broadcast::connection('reverb')->broadcast(['private-'.$inbox], 'inbox.changed', []);
                }
            }
        }
    }
}
