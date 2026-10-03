<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Operations\OutboxPublisher;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/**
 * Protected finance notices go to the active Vendor Owner only (Vendor Workflow: finance notices are Owner-only;
 * a Manager never receives statement, earnings, tax or payout detail). Mandatory notices — every flip to a
 * SUBJECT_* withholding status, statement issue and overdue — use category FINANCE_MANDATORY, which no
 * notification preference can disable. The in-app row is written in the caller's transaction; email leaves only
 * through the post-commit outbox, so no network call happens under a finance lock.
 */
final class FinanceNotifier
{
    public const MANDATORY = 'FINANCE_MANDATORY';

    public const ADVISORY = 'FINANCE';

    public function __construct(private readonly OutboxPublisher $outbox) {}

    public function owner(string $organizationId, string $title, string $body, bool $mandatory, string $resourceType, ?string $resourceId): int
    {
        $owners = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')->where('m.vendor_organization_id', $organizationId)
            ->where('m.role', 'OWNER')->where('m.status', 'ACTIVE')->where('u.account_status', 'ACTIVE')->get(['u.id', 'u.email']);
        foreach ($owners as $owner) {
            $notificationId = (string) Str::uuid7();
            DB::table('notifications')->insert(['id' => $notificationId, 'user_id' => $owner->id, 'category' => $mandatory ? self::MANDATORY : self::ADVISORY,
                'title' => mb_substr($title, 0, 255), 'body' => $body, 'resource_type' => $resourceType, 'resource_id' => $resourceId, 'created_at' => now(), 'updated_at' => now()]);
            if (is_string($owner->email) && $owner->email !== '') {
                $this->outbox->publish('FINANCE_NOTICE', 'VENDOR_ORGANIZATION', $organizationId, ['recipient' => $owner->email, 'subject' => $title, 'message' => $body, 'notification_id' => $notificationId]);
            }
        }

        return $owners->count();
    }
}
