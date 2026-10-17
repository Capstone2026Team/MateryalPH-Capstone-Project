<?php

declare(strict_types=1);

namespace App\Domain\Invoices;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Orders\OrderAccess;
use App\Models\User;
use Illuminate\Support\Facades\DB;

/**
 * Narrow invoice-file access, re-resolved on every download. The Buyer reaches their own orders' copies; the Owner,
 * Store Manager and Store Staff reach their store's copies; assigned Fulfillment Staff reach the copy needed for an
 * assigned delivery; Customer Service sees request status and metadata only; Inventory Staff see nothing; Admins
 * need invoices.view. None of this grants Earnings, store-wide Transaction History or any other protected finance.
 */
final class InvoiceAccess
{
    public const FILE_ROLES = ['OWNER', 'STORE_MANAGER', 'STORE_STAFF'];

    public static function canDownload(User $user, string $audience, object $order): bool
    {
        try {
            $scope = app(AccountAccess::class)->resolve($user);
        } catch (AuthenticationException) {
            return false;
        }

        return match ($audience) {
            'BUYER' => $user->account_type === 'BUYER' && DB::table('buyer_profiles')->where('id', $order->buyer_profile_id)->value('user_id') === $user->getKey(),
            'VENDOR' => $user->account_type === 'VENDOR' && $scope['organization_id'] === $order->vendor_organization_id && in_array(InvoiceService::VIEW, $scope['permissions'], true)
                && (in_array($scope['role'], self::FILE_ROLES, true) || ($scope['role'] === 'FULFILLMENT' && OrderAccess::assignedTo((string) $order->id, (int) $user->getKey()))),
            'ADMIN' => $user->account_type === 'ADMIN' && in_array(InvoiceService::VIEW, $scope['permissions'], true),
            default => false,
        };
    }

    public static function roleCanOpenFiles(string $role): bool
    {
        return in_array($role, [...self::FILE_ROLES, 'FULFILLMENT'], true);
    }
}
