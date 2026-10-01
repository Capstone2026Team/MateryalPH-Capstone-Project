<?php

declare(strict_types=1);

namespace App\Domain\Messaging;

use App\Models\User;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class ConversationChannel
{
    public function join(User $user, string $purpose, string $id, string $viewer, string $epoch): bool
    {
        if (! Str::isUuid($id) || (string) $user->id !== $viewer) {
            return false;
        }
        $c = DB::table('conversations')->where('id', $id)->where('purpose', $purpose)->first();
        $access = app(ConversationAccess::class);

        return $c !== null && $access->allows($user, $c) && hash_equals($access->channel($user, $c), "conversation.{$purpose}.{$id}.{$viewer}.{$epoch}");
    }
}
