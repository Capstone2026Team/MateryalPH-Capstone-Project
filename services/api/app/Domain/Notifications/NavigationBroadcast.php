<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Operations\OutboxPublisher;
use App\Models\User;
use Illuminate\Support\Facades\Broadcast;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

/** Reuses the current notification channel; no counts, identities or resource contents are broadcast. */
final class NavigationBroadcast
{
    public function fromAudit(string $action, string $type, ?string $id): void
    {
        $permission = match (true) {
            str_starts_with($action, 'VENDOR_VERIFICATION_') || $action === 'VENDOR_EVIDENCE_SUBMITTED' => 'vendor_verification.review',
            $type === 'COMPLIANCE_SUBMISSION' || $action === 'CATALOG_LISTING_DELETED' => 'product_compliance.review',
            $type === 'REVIEW' && in_array($action, ['REVIEW_REPORTED', 'REVIEW_MODERATED', 'REVIEW_CORRECTED'], true) => 'reviews.moderate',
            $type === 'ENFORCEMENT_ACTION' => 'enforcement.view',
            $action === 'OPERATION_RETRY_QUEUED' => 'integrations.view',
            $action === 'ORDER_FULFILLMENT_ASSIGNED' => 'orders.operations.view',
            str_starts_with($action, 'INVOICE_REQUEST') || $action === 'INVOICE_UPLOADED' => 'invoices.view',
            default => null,
        };
        if ($permission !== null) {
            app(OutboxPublisher::class)->publish('NAVIGATION_CHANGED', $type, $id !== null && Str::isUuid($id) ? $id : (string) Str::uuid7(), ['permission' => $permission]);
        }
    }

    /** Invoked by the durable outbox after commit, including retries and scheduled state changes. */
    public function deliver(string $type, string $id, ?string $permission = null): void
    {
        if (config('broadcasting.default') !== 'reverb') {
            return;
        }
        $row = match ($type) {
            'ORDER' => DB::table('orders')->where('id', $id)->first(),
            'CONVERSATION' => DB::table('conversations')->where('id', $id)->first(),
            'DISPUTE_CASE' => DB::table('dispute_cases')->where('id', $id)->first(),
            'CART' => DB::table('carts')->where('id', $id)->first(),
            'INVOICE_RECORD' => DB::table('invoice_records')->where('id', $id)->first(),
            default => null,
        };
        $permission ??= match ($type) {
            'ORDER' => 'orders.operations.view', 'DISPUTE_CASE' => 'disputes.view', default => null,
        };
        $ids = [];
        if ($row !== null) {
            if (isset($row->vendor_organization_id)) {
                $ids = DB::table('vendor_memberships')->where('vendor_organization_id', $row->vendor_organization_id)->where('status', 'ACTIVE')->pluck('user_id')->all();
            }
            if (isset($row->buyer_profile_id)) {
                $ids[] = DB::table('buyer_profiles')->where('id', $row->buyer_profile_id)->value('user_id');
            }
        }
        $query = User::query()->whereIn('id', array_filter($ids));
        if ($permission !== null) {
            $query->orWhere('account_type', 'ADMIN');
        }
        foreach ($query->cursor() as $user) {
            try {
                $scope = app(AccountAccess::class)->resolve($user);
            } catch (AuthenticationException) {
                continue;
            }
            if ($user->account_type === 'ADMIN' && ($permission === null || ! in_array($permission, $scope['permissions'], true))) {
                continue;
            }
            if ($user->account_type === 'VENDOR') {
                $allowed = match ($type) {
                    'CONVERSATION' => in_array('portal.messages', $scope['permissions'], true),
                    'ORDER' => in_array('portal.orders', $scope['permissions'], true),
                    'DISPUTE_CASE' => count(array_intersect(['portal.disputes', 'disputes.fulfillment_evidence'], $scope['permissions'])) > 0,
                    'INVOICE_RECORD' => in_array('invoices.view', $scope['permissions'], true),
                    default => false,
                };
                if (! $allowed) {
                    continue;
                }
            }
            $channel = app(NotificationChannel::class)->name($user);
            if ($channel !== null) {
                Broadcast::connection('reverb')->broadcast(['private-'.$channel], 'navigation.changed', []);
            }
        }
    }
}
