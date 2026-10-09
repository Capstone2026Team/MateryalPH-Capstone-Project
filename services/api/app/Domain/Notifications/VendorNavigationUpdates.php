<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use App\Domain\Authorization\VendorTeamMembersQuery;
use App\Domain\Messaging\ConversationService;
use App\Domain\Orders\OrderQueries;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/** Counts authorized active orders, active team members and unread updates; never returns protected resource details. */
final class VendorNavigationUpdates
{
    public function __construct(private readonly NotificationPolicy $policy, private readonly ConversationService $conversations, private readonly OrderQueries $orders, private readonly VendorTeamMembersQuery $members) {}

    /** @return array{sections: array<string, int>} */
    public function summary(Request $request): array
    {
        $user = $request->user();
        $sections = ['/orders' => $this->orders->activeVendorCount($request), '/team' => $this->members->activeCount($request), '/notifications' => 0, '/messages' => $this->conversations->unreadInboxCount($request)];
        $preferences = DB::table('notification_preferences')->where('user_id', $user->getKey())->pluck('in_app', 'category');
        $notices = DB::table('notifications')->where('user_id', $user->getKey())->whereNull('read_at')->lazyById(200);
        foreach ($notices as $notice) {
            if (! $this->policy->allows($user, $notice)
                || (! NotificationPolicy::mandatory($notice->category) && ! ($preferences[$notice->category] ?? true))) {
                continue;
            }
            $sections['/notifications']++;
            $path = explode('?', $this->policy->target($user, $notice), 2)[0];
            // Match the existing destination hierarchy, rather than guessing from notice titles.
            $section = match (true) {
                $notice->category === 'INVOICES' && str_starts_with($path, '/orders/') => '/invoices',
                str_starts_with($path, '/products') => '/products',
                str_starts_with($path, '/disputes/') => '/disputes',
                str_starts_with($path, '/finance') => '/finance',
                in_array($path, ['/dashboard', '/invoices'], true) => $path,
                default => null,
            };
            if ($section !== null) {
                $sections[$section] = ($sections[$section] ?? 0) + 1;
            }
        }

        return ['sections' => $sections];
    }
}
