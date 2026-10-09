<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use App\Domain\Messaging\BuyerInboxChannel;
use App\Domain\Operations\OutboxPublisher;
use App\Models\User;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\DB;

/** Private invalidations carry no notice contents; the REST feed reauthorizes every item. */
final class NotificationBroadcast
{
    public function publish(User $user): void
    {
        app(OutboxPublisher::class)->publish('NOTIFICATIONS_CHANGED', 'USER', $user->public_id, ['user_id' => (int) $user->getKey()]);
    }

    public function created(string $id): void
    {
        $notice = DB::table('notifications')->where('id', $id)->first();
        $user = $notice === null ? null : User::query()->find($notice->user_id);
        if ($user instanceof User && app(NotificationPolicy::class)->allows($user, $notice) && NotificationService::enabled($notice, 'in_app')) {
            $this->deliver((int) $user->getKey());
        }
    }

    public function deliver(int $userId): void
    {
        if (config('broadcasting.default') !== 'reverb') {
            return;
        }
        $user = User::query()->find($userId);
        $channel = $user instanceof User ? app(NotificationChannel::class)->name($user) : null;
        if ($channel !== null) {
            $channels = ['private-'.$channel];
            $legacy = app(BuyerInboxChannel::class)->name($user);
            if ($legacy !== null) {
                $channels[] = 'private-'.$legacy;
            }
            Broadcast::connection('reverb')->broadcast($channels, 'notifications.changed', []);
        }
    }
}
