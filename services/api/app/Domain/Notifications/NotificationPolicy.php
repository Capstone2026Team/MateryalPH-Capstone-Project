<?php

declare(strict_types=1);

namespace App\Domain\Notifications;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Disputes\DisputeAccess;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class NotificationPolicy
{
    public const OPTIONAL = ['INVENTORY', 'MARKETING', 'PROJECTS'];

    public const CATEGORIES = ['SECURITY', 'LEGAL', 'SUSPENSION', 'PAYMENT', 'REFUND', 'DISPUTES', 'FINANCE_MANDATORY', 'ORDERS', 'VENDOR_VERIFICATION', 'INVENTORY', 'MARKETING', 'PROJECTS'];

    public static function mandatory(string $category): bool
    {
        // Unknown existing domain categories fail closed; newly added optional classes need explicit approval.
        return ! in_array($category, self::OPTIONAL, true);
    }

    public function allows(User $user, object $notice): bool
    {
        if ((int) $notice->user_id !== (int) $user->getKey() || $user->account_status !== 'ACTIVE') {
            return false;
        }
        if ($notice->category === 'SECURITY' && $notice->resource_type === 'ACCOUNT') {
            return true;
        }
        try {
            $scope = app(AccountAccess::class)->resolve($user);
        } catch (AuthenticationException) {
            return false;
        }
        $type = $notice->resource_type;
        $id = $notice->resource_id;
        if (in_array($type, ['VENDOR_LISTING', 'LISTING_VARIANT'], true)) {
            $listingId = $type === 'VENDOR_LISTING' ? $id : DB::table('listing_variants')->where('id', $id)->value('vendor_listing_id');
            $organization = DB::table('vendor_listings')->where('id', $listingId)->value('vendor_organization_id');

            return $user->account_type === 'VENDOR' && $organization !== null && $scope['organization_id'] === $organization
                && in_array('inventory.view', $scope['permissions'], true);
        }
        if ($type === 'DISPUTE_CASE') {
            $case = DB::table('dispute_cases')->where('id', $id)->first();

            return $case !== null && app(DisputeAccess::class)->userCanAccessCase($user, $case);
        }
        if (str_starts_with((string) $notice->category, 'FINANCE') || in_array($type, ['FEE_STATEMENT', 'WITHHOLDING_ACCUMULATOR', 'TAX_REPORT_PACKAGE'], true)) {
            if ($user->account_type === 'ADMIN') {
                return in_array('finance.view', $scope['permissions'], true);
            }
            $organization = $notice->vendor_organization_id ?? null;
            if ($organization === null && $type === 'FEE_STATEMENT') {
                $organization = DB::table('fee_statements')->where('id', $id)->value('vendor_organization_id');
            }

            return $organization !== null && $scope['role'] === 'OWNER' && $scope['organization_id'] === $organization;
        }
        if ($type === 'ORDER') {
            $order = DB::table('orders')->where('id', $id)->first();
            if ($order === null) {
                return false;
            }
            if ($user->account_type === 'BUYER') {
                return DB::table('buyer_profiles')->where('id', $order->buyer_profile_id)->where('user_id', $user->getKey())->exists();
            }
            if ($user->account_type === 'ADMIN') {
                return in_array('orders.view', $scope['permissions'], true);
            }

            return $scope['organization_id'] === $order->vendor_organization_id && in_array('portal.orders', $scope['permissions'], true)
                && OrderAccess::visibleToRole($scope['role'], $order->order_state)
                && ($scope['role'] !== 'FULFILLMENT' || OrderAccess::assignedTo((string) $id, (int) $user->getKey()));
        }
        if ($type === 'VENDOR_ORGANIZATION') {
            if ($scope['organization_id'] !== $id) {
                return false;
            }
            if ($notice->category === 'TEAM') {
                return in_array('staff.manage', $scope['permissions'], true);
            }
            if (in_array($notice->category, ['INVENTORY', 'PRODUCT_COMPLIANCE', 'AUTO_ACCEPT', 'STOCK_CONFIRMATION'], true)) {
                return in_array('inventory.view', $scope['permissions'], true);
            }

            return $scope['role'] === 'OWNER';
        }
        if ($type === 'PROJECT') {
            return $user->account_type === 'BUYER' && DB::table('projects as p')->join('buyer_profiles as b', 'b.id', '=', 'p.buyer_profile_id')->where('p.id', $id)->where('b.user_id', $user->getKey())->exists();
        }

        return $type === 'ACCOUNT';
    }

    public function target(User $user, object $notice): string
    {
        if (! $this->allows($user, $notice)) {
            throw new AuthenticationException('NOTICE_ACCESS_REVOKED', 'You no longer have permission to open this notification.', 403);
        }

        return match ($notice->resource_type) {
            'VENDOR_LISTING', 'LISTING_VARIANT' => '/products/inventory',
            'ORDER' => $user->account_type === 'ADMIN' ? '/order-operations' : '/orders/'.$notice->resource_id,
            'DISPUTE_CASE' => '/disputes/'.$notice->resource_id,
            'PROJECT' => '/projects/'.$notice->resource_id,
            'FEE_STATEMENT' => $user->account_type === 'ADMIN' ? '/finance' : '/finance/statements/'.$notice->resource_id,
            'TAX_REPORT_PACKAGE' => '/reports/tax/'.$notice->resource_id,
            'VENDOR_ORGANIZATION' => match ($notice->category) {
                'TEAM' => '/team',
                'VENDOR_PAYMENT_CONNECTION' => '/onboarding/setup?step=S3',
                'VENDOR_SETUP' => '/onboarding/setup?step='.match ($notice->resume_key) {
                    'public_store_profile' => 'S1', 'bulk_capability' => 'S2', 'payment_connection' => 'S3',
                    'fulfillment_method', 'delivery_configuration' => 'S2', 'store_operation' => 'S5', default => 'S6',
                },
                'VENDOR_ACTIVATION' => '/onboarding/setup?step=S6',
                'INVENTORY', 'AUTO_ACCEPT', 'STOCK_CONFIRMATION' => '/products/inventory',
                'PRODUCT_COMPLIANCE' => '/products',
                default => '/onboarding/verification'.($notice->resume_key === null ? '' : '?requirement='.rawurlencode($notice->resume_key)),
            },
            default => str_starts_with((string) $notice->category, 'FINANCE') ? '/finance' : ($user->account_type === 'ADMIN' ? '/workspace' : '/settings'),
        };
    }
}
