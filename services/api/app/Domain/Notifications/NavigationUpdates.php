<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Disputes\DisputeQueries;
use App\Domain\Geography\BuyerProfiles;
use App\Domain\Messaging\ConversationService;
use App\Domain\Operations\OperationsQueueService;
use App\Domain\Orders\OrderQueries;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

/** Counts are authorized read models, independent of notification delivery or list pagination. */
final class NavigationUpdates
{
    /** @return array{sections: array<string, int>, cart_quantity?: string, cart_version?: int} */
    public function summary(Request $request): array
    {
        $user = $request->user();
        if ($user->account_type === 'VENDOR') {
            return app(VendorNavigationUpdates::class)->summary($request);
        }
        $sections = ['/notifications' => app(NotificationService::class)->unreadCount($user)];
        if ($user->account_type === 'BUYER') {
            $buyerId = app(BuyerProfiles::class)->idFor($request);
            // Quantity and its version share one PostgreSQL snapshot; a concurrent mutation cannot mix them.
            $cart = DB::table('carts as c')->where('c.buyer_profile_id', $buyerId)->where('c.state', 'ACTIVE')->select('c.lock_version')
                ->selectSub(fn (Builder $lines) => $lines->from('cart_items')->whereColumn('cart_id', 'c.id')->whereNull('saved_for_later_at')
                    ->selectRaw('COALESCE(SUM(quantity), 0)'), 'quantity')->first();
            $quantity = (string) ($cart->quantity ?? '0');
            $quantity = str_contains($quantity, '.') ? rtrim(rtrim($quantity, '0'), '.') : $quantity;

            return ['sections' => $sections + [
                '/messages' => app(ConversationService::class)->unreadInboxCount($request),
                '/orders' => app(OrderQueries::class)->activeBuyerCount($request),
                '/disputes' => app(DisputeQueries::class)->activeCount($request),
            ], 'cart_quantity' => $quantity, 'cart_version' => (int) ($cart->lock_version ?? 0)];
        }
        $scope = app(AccountAccess::class)->resolve($user);
        // Only pending work belongs on navigation. Informational dashboard metrics stay on the dashboard.
        $keys = ['vendor_verification', 'product_compliance', 'disputes', 'appeals', 'enforcement', 'review_moderation',
            'invoices', 'privacy', 'refund_failures', 'refunds_pending', 'reimbursements', 'jobs'];
        foreach (app(OperationsQueueService::class)->queues($scope['permissions']) as $queue) {
            if (in_array($queue['key'], $keys, true)) {
                $path = explode('?', (string) $queue['href'], 2)[0];
                $sections[$path] = ($sections[$path] ?? 0) + (int) $queue['count'];
            }
        }

        return ['sections' => $sections];
    }
}
