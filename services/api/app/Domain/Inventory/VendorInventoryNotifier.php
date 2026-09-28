<?php

declare(strict_types=1);

namespace App\Domain\Inventory;

use App\Domain\Operations\OutboxPublisher;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * In-app notification rows plus post-commit email outbox events for inventory and auto-accept notices.
 * Messages carry listing names and dates only; exact private quantities are never emailed.
 */
final class VendorInventoryNotifier
{
    public function __construct(private readonly OutboxPublisher $outbox) {}

    /** @param list<string> $roles */
    public function notify(string $organizationId, array $roles, string $category, string $title, string $body, string $resourceType, string $resourceId, bool $email = true): int
    {
        $recipients = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')
            ->where('m.vendor_organization_id', $organizationId)->where('m.status', 'ACTIVE')->whereIn('m.role', $roles)
            ->where('u.account_status', 'ACTIVE')->orderBy('u.id')->get(['u.id', 'u.email']);
        foreach ($recipients as $recipient) {
            $notificationId = (string) Str::uuid7();
            DB::table('notifications')->insert(['id' => $notificationId, 'user_id' => $recipient->id, 'category' => $category, 'title' => $title, 'body' => $body, 'resource_type' => $resourceType, 'resource_id' => $resourceId, 'created_at' => now(), 'updated_at' => now()]);
            if ($email && is_string($recipient->email) && $recipient->email !== '') {
                $this->outbox->publish('VENDOR_INVENTORY_NOTICE', 'VENDOR_ORGANIZATION', $organizationId, ['recipient' => $recipient->email, 'subject' => $title, 'message' => $body, 'notification_id' => $notificationId]);
            }
        }

        return $recipients->count();
    }
}
