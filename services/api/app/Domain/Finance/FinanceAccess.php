<?php

declare(strict_types=1);

namespace App\Domain\Finance;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use Illuminate\Http\Request;

/**
 * Deny-by-default finance authorization. Store-wide Earnings, protected Transaction History, withholding and
 * commission statements, finance exports, notices and dashboard fields are Vendor Owner only (finance.view held
 * by the OWNER role); a Store Manager's operational order/invoice access never reaches them. Paying a statement
 * needs finance.pay. Admin finance uses the existing finance.* permissions; preparer and reviewer must differ.
 * The membership is re-resolved from the database on every request; a hidden control is never the guard.
 */
final class FinanceAccess
{
    public function __construct(private readonly AccountAccess $access) {}

    /** @return array{organization_id: string, user_id: int, role: string} */
    public function owner(Request $request, string $permission = 'finance.view'): array
    {
        $user = $request->user();
        if ($user === null || $user->account_type !== 'VENDOR') {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot access Vendor finance.', 403);
        }
        $current = $this->access->resolve($user);
        $scope = $request->attributes->get('account_scope');
        if (is_array($scope) && is_string($scope['organization_id'] ?? null) && $scope['organization_id'] !== $current['organization_id']) {
            throw new AuthenticationException('PORTAL_ACCESS_DENIED', 'This account cannot access Vendor finance.', 403);
        }
        if ($current['role'] !== 'OWNER' || ! in_array($permission, $current['permissions'], true)) {
            throw new AuthenticationException('FINANCE_OWNER_ONLY', 'Store-wide finance is available to the Vendor Owner only.', 403);
        }

        return ['organization_id' => (string) $current['organization_id'], 'user_id' => (int) $user->getKey(), 'role' => 'OWNER'];
    }

    public function admin(Request $request, string $permission): int
    {
        $user = $request->user();
        if ($user === null || $user->account_type !== 'ADMIN' || ! in_array($permission, $this->access->resolve($user)['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'This finance action is not available to your Admin role.', 403);
        }

        return (int) $user->getKey();
    }
}
