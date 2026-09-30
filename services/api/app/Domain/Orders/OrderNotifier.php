<?php

declare(strict_types=1);

namespace App\Domain\Orders;

use App\Domain\Operations\OutboxPublisher;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * In-app order notifications plus post-commit email outbox events, written in the order transaction. Messages
 * carry the order reference and next step only: no exact Vendor inventory, Buyer coordinates or private files.
 */
final class OrderNotifier
{
    /** Vendor roles that act on or follow order requests. */
    public const VENDOR_ROLES = ['OWNER', 'STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE'];

    public function __construct(private readonly OutboxPublisher $outbox) {}

    public function buyer(object $order, string $title, string $body): void
    {
        $recipient = DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')->where('b.id', $order->buyer_profile_id)->where('u.account_status', 'ACTIVE')->first(['u.id', 'u.email']);
        if ($recipient !== null) {
            $this->deliver((int) $recipient->id, $recipient->email, $order, $title, $body);
        }
    }

    /** @param list<string> $roles */
    public function vendor(object $order, string $title, string $body, array $roles = self::VENDOR_ROLES): void
    {
        $recipients = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $order->vendor_organization_id)
            ->where('m.status', 'ACTIVE')->whereIn('m.role', $roles)->where('u.account_status', 'ACTIVE')->orderBy('u.id')->get(['u.id', 'u.email']);
        foreach ($recipients as $recipient) {
            $this->deliver((int) $recipient->id, $recipient->email, $order, $title, $body);
        }
    }

    private function deliver(int $userId, mixed $email, object $order, string $title, string $body): void
    {
        $notificationId = (string) Str::uuid7();
        DB::table('notifications')->insert(['id' => $notificationId, 'user_id' => $userId, 'category' => 'ORDERS', 'title' => mb_substr($title, 0, 255), 'body' => $body,
            'resource_type' => 'ORDER', 'resource_id' => $order->id, 'created_at' => now(), 'updated_at' => now()]);
        if (is_string($email) && $email !== '') {
            $this->outbox->publish('ORDER_NOTICE', 'ORDER', (string) $order->id, ['recipient' => $email, 'subject' => $title, 'message' => $body, 'notification_id' => $notificationId]);
        }
    }
}
