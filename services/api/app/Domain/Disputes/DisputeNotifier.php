<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Operations\OutboxPublisher;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Mandatory dispute notices (category DISPUTES; they cannot be switched off). Messages carry the Case ID, the next
 * step and the deadline only, never evidence or private contacts. Vendor recipients are the Owner and Store
 * Managers, plus Store Staff and Customer Service only while the Owner's staff dispute flag is on. The email side
 * effect is queued with the recipient's user id and re-authorized at delivery, so a notice queued before the flag
 * was switched off is never delivered to staff who lost case access.
 */
final class DisputeNotifier
{
    public const CATEGORY = 'DISPUTES';

    public function __construct(private readonly OutboxPublisher $outbox) {}

    public function buyer(object $case, string $title, string $body): void
    {
        $recipient = DB::table('buyer_profiles as b')->join('users as u', 'u.id', '=', 'b.user_id')->where('b.id', $case->buyer_profile_id)->where('u.account_status', 'ACTIVE')->first(['u.id']);
        if ($recipient !== null) {
            $this->deliver((int) $recipient->id, $case, $title, $body);
        }
    }

    /**
     * @param  list<string>|null  $roles  null = every role that currently handles cases
     */
    public function vendor(object $case, string $title, string $body, ?array $roles = null): void
    {
        $flag = (bool) DB::table('vendor_organizations')->where('id', $case->vendor_organization_id)->value('staff_disputes_enabled');
        $handlers = $roles ?? ['OWNER', 'STORE_MANAGER', ...($flag ? AccountAccess::FLAG_CONTROLLED_DISPUTE_ROLES : [])];
        if (! $flag) {
            $handlers = array_values(array_diff($handlers, AccountAccess::FLAG_CONTROLLED_DISPUTE_ROLES));
        }
        $recipients = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $case->vendor_organization_id)
            ->where('m.status', 'ACTIVE')->whereIn('m.role', $handlers)->where('u.account_status', 'ACTIVE')->orderBy('u.id')->pluck('u.id');
        foreach ($recipients as $userId) {
            $this->deliver((int) $userId, $case, $title, $body);
        }
    }

    /** The Fulfillment Staff currently assigned to the case's order, for a fulfillment-evidence request only. */
    public function assignee(object $case, string $title, string $body): void
    {
        $userId = DB::table('order_fulfillment_assignments as a')->join('vendor_memberships as m', fn ($join) => $join->on('m.user_id', '=', 'a.user_id')->where('m.vendor_organization_id', $case->vendor_organization_id))
            ->where('a.order_id', $case->order_id)->whereNull('a.ended_at')->where('m.status', 'ACTIVE')->where('m.role', 'FULFILLMENT')->value('a.user_id');
        if ($userId !== null) {
            $this->deliver((int) $userId, $case, $title, $body);
        }
    }

    public function admin(object $case, string $title, string $body): void
    {
        if ($case->assigned_admin_user_id !== null) {
            $this->deliver((int) $case->assigned_admin_user_id, $case, $title, $body);
        }
    }

    private function deliver(int $userId, object $case, string $title, string $body): void
    {
        $id = (string) Str::uuid7();
        DB::table('notifications')->insert(['id' => $id, 'user_id' => $userId, 'category' => self::CATEGORY, 'title' => mb_substr($title, 0, 255), 'body' => $body,
            'resource_type' => 'DISPUTE_CASE', 'resource_id' => $case->id, 'created_at' => now(), 'updated_at' => now()]);
        $this->outbox->publish('DISPUTE_NOTICE', 'DISPUTE_CASE', (string) $case->id, ['user_id' => $userId, 'dispute_case_id' => (string) $case->id, 'subject' => $title, 'message' => $body, 'notification_id' => $id]);
    }
}
