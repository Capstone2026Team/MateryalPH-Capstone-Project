<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuditRecorder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class ReadNotifications
{
    public function __construct(private readonly NotificationPolicy $policy, private readonly NotificationBroadcast $broadcast, private readonly AuditRecorder $audit, private readonly AccountAccess $access) {}

    /** @return array{read: bool, read_count: int, read_at: string} */
    public function filtered(Request $request, string $throughId, ?string $title, ?string $category = null): array
    {
        return DB::transaction(function () use ($request, $throughId, $title, $category): array {
            $user = $request->user()->refresh();
            $request->attributes->set('account_scope', $this->access->resolve($user));
            $at = now();
            $count = 0;
            $query = DB::table('notifications')->where('user_id', $user->getKey())->whereNull('read_at')->where('id', '<=', $throughId);
            if ($title !== null) {
                $query->where('title', $title);
            }
            if ($category !== null) {
                $query->where('category', $category);
            }
            // Bounded batches in one transaction; new arrivals beyond the captured view stay unread.
            $query->lockForUpdate()->chunkById(200, function ($rows) use ($user, $at, &$count): void {
                $ids = [];
                foreach ($rows as $notice) {
                    if ($this->policy->allows($user, $notice) && NotificationService::enabled($notice, 'in_app')) {
                        $ids[] = $notice->id;
                    }
                }
                if ($ids !== []) {
                    $count += DB::table('notifications')->whereIn('id', $ids)->whereNull('read_at')->update(['read_at' => $at, 'updated_at' => $at]);
                }
            });
            if ($count > 0) {
                $this->audit->account($request, 'NOTIFICATIONS_MARKED_READ', 'ACCOUNT', $user->public_id, [], ['read_count' => $count]);
                $this->broadcast->publish($user);
            }

            return ['read' => true, 'read_count' => $count, 'read_at' => $at->toIso8601String()];
        });
    }
}
