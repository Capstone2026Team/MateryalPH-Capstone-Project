<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use App\Models\User;

final class NotificationMailAction
{
    /** @return array{actionLabel: string, noticeUrl: ?string} */
    public function for(User $user, object $notice): array
    {
        $label = match ($notice->resource_type) {
            'SUPPORT_TICKET' => 'View support request', 'CONVERSATION' => 'View conversation',
            'INVOICE_RECORD' => 'View invoice', 'ORDER' => 'View order', 'DISPUTE_CASE' => 'View dispute',
            'PROJECT' => 'View project', 'FEE_STATEMENT' => 'View statement', 'TAX_REPORT_PACKAGE' => 'View tax package',
            'VENDOR_LISTING', 'LISTING_VARIANT' => 'Review inventory', 'PLATFORM_SETTING' => 'View settings',
            'ENFORCEMENT_ACTION' => 'Review account action',
            'VENDOR_ORGANIZATION' => match ($notice->category) {
                'TEAM' => 'View team', 'INVENTORY', 'AUTO_ACCEPT', 'STOCK_CONFIRMATION' => 'Review inventory',
                'PRODUCT_COMPLIANCE' => 'Review products', default => 'Review store setup',
            },
            default => str_starts_with((string) $notice->category, 'FINANCE') ? 'View finance details' : 'Review account',
        };
        // Buyer actions remain in the mobile app; do not invent a public web route or expiring file link.
        $url = null;
        if (in_array($user->account_type, ['VENDOR', 'ADMIN'], true)) {
            $base = (string) config($user->account_type === 'VENDOR' ? 'app.vendor_frontend_url' : 'app.admin_frontend_url');
            $url = rtrim($base, '/').app(NotificationPolicy::class)->target($user, $notice);
        }

        return ['actionLabel' => $label, 'noticeUrl' => $url];
    }
}
