<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use App\Models\User;
use App\Support\PortalDateRange;
use Illuminate\Support\Facades\Crypt;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

final class NotificationService
{
    public function record(int $userId, string $category, string $title, string $body, string $resourceType, ?string $resourceId, string $eventKey, ?string $organizationId = null, ?string $resumeKey = null): string
    {
        return DB::transaction(function () use ($userId, $category, $title, $body, $resourceType, $resourceId, $eventKey, $organizationId, $resumeKey): string {
            $key = hash('sha256', $eventKey);
            $id = (string) Str::uuid7();
            $inserted = DB::table('notifications')->insertOrIgnore(['id' => $id, 'user_id' => $userId, 'category' => $category,
                'title' => $title, 'body' => $body, 'resource_type' => $resourceType, 'resource_id' => $resourceId, 'event_key' => $key,
                'vendor_organization_id' => $organizationId, 'resume_key' => $resumeKey, 'created_at' => now(), 'updated_at' => now()]);
            if ($inserted === 0) {
                return (string) DB::table('notifications')->where('user_id', $userId)->where('event_key', $key)->value('id');
            }
            app(OutboxPublisher::class)->publish('NOTIFICATION_READY', 'NOTIFICATION', $id, ['notification_id' => $id]);

            return $id;
        });
    }

    /** Existing domain events already persist their authoritative notice in the business transaction. */
    public function enqueue(string $id, string $template = 'ORDER_NOTICE', ?string $securityRecipient = null): void
    {
        $notice = DB::table('notifications')->where('id', $id)->first();
        if ($notice === null) {
            return;
        }
        $user = User::query()->find($notice->user_id);
        if (! $user instanceof User || ! app(NotificationPolicy::class)->allows($user, $notice)) {
            return;
        }
        if ($notice->category === 'MESSAGES' && $notice->read_at !== null) {
            return;
        }
        $destinations = $notice->category === 'MESSAGES' && ! self::enabled($notice, 'EMAIL') ? [] : [['EMAIL', 'EMAIL', null]];
        foreach (DB::table('notification_devices')->where('user_id', $user->getKey())->whereNull('revoked_at')->where('environment', app()->environment())->get() as $device) {
            $destinations[] = ['PUSH', (string) $device->id, (string) $device->id];
        }
        DB::transaction(function () use ($destinations, $notice, $template, $securityRecipient): void {
            foreach ($destinations as [$channel, $key, $deviceId]) {
                $deliveryId = (string) Str::uuid7();
                $created = DB::table('notification_deliveries')->insertOrIgnore(['id' => $deliveryId, 'notification_id' => $notice->id, 'channel' => $channel,
                    'destination_key' => $key, 'device_id' => $deviceId, 'template' => $template, 'sealed_recipient' => $securityRecipient === null ? null : Crypt::encryptString($securityRecipient),
                    'state' => 'QUEUED', 'attempt_count' => 0, 'available_at' => now(), 'created_at' => now(), 'updated_at' => now()]);
                if ($created > 0) {
                    app(OutboxPublisher::class)->publish('NOTIFICATION_DELIVERY', 'NOTIFICATION_DELIVERY', $deliveryId, ['delivery_id' => $deliveryId]);
                }
            }
        });
    }

    public static function enabled(object $notice, string $channel): bool
    {
        if (NotificationPolicy::mandatory($notice->category)) {
            return true;
        }
        $value = DB::table('notification_preferences')->where('user_id', $notice->user_id)->where('category', $notice->category)->value(strtolower($channel));

        return $value === null ? NotificationPolicy::defaultEnabled($notice->category, $channel) : (bool) $value;
    }

    public function unreadCount(User $user): int
    {
        $count = 0;
        $policy = app(NotificationPolicy::class);
        $preferences = DB::table('notification_preferences')->where('user_id', $user->getKey())->pluck('in_app', 'category');
        foreach (DB::table('notifications')->where('user_id', $user->getKey())->whereNull('read_at')->lazyById(200) as $notice) {
            if ($policy->allows($user, $notice) && (NotificationPolicy::mandatory($notice->category) || ($preferences[$notice->category] ?? true))) {
                $count++;
            }
        }

        return $count;
    }

    /**
     * @param  array<string, mixed>  $filters
     * @return array<string, mixed>
     */
    public function feed(User $user, ?string $cursor, array $filters = []): array
    {
        $query = DB::table('notifications')->where('user_id', $user->getKey())->orderByDesc('id');
        if ($cursor !== null) {
            if (! Str::isUuid($cursor)) {
                throw new AuthenticationException('INVALID_CURSOR', 'The notification cursor is invalid.', 422);
            }
            $query->where('id', '<', $cursor);
        }
        PortalDateRange::apply($query, 'created_at', $filters);
        // Advance across revoked rows without disclosing either their count or contents.
        $rows = $query->limit(51)->get();
        $hasMore = $rows->count() > 50;
        $page = $rows->take(50);
        $items = [];
        foreach ($page as $notice) {
            if (app(NotificationPolicy::class)->allows($user, $notice) && self::enabled($notice, 'in_app')) {
                $items[] = ['id' => $notice->id, 'category' => $notice->category, 'title' => $notice->title, 'body' => $notice->body,
                    'mandatory' => NotificationPolicy::mandatory($notice->category), 'read_at' => $notice->read_at, 'created_at' => $notice->created_at];
            }
        }

        return ['items' => $items, 'next_cursor' => $hasMore ? $page->last()->id : null];
    }
}
