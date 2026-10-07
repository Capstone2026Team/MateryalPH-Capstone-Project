<?php

declare(strict_types=1);

namespace App\Domain\Reporting;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Identity\AuthenticationException;
use App\Domain\Notifications\NotificationPolicy;
use App\Models\User;
use Illuminate\Support\Facades\DB;

final class ExportAccess
{
    public function allows(User $user, string $type, ?string $resourceId, ?string $organizationId = null): bool
    {
        try {
            $scope = app(AccountAccess::class)->resolve($user);
        } catch (AuthenticationException) {
            return false;
        }
        if ($organizationId !== null && $user->account_type === 'VENDOR' && $scope['organization_id'] !== $organizationId) {
            return false;
        }
        if ($type === 'MATERIALS_ANALYTICS') {
            return ($user->account_type === 'VENDOR' && in_array('materials_analytics.view_competitors', $scope['permissions'], true))
                || ($user->account_type === 'ADMIN' && in_array('analytics.view_aggregates', $scope['permissions'], true) && in_array('analytics.export', $scope['permissions'], true));
        }
        if (in_array($type, ['PURCHASE_ORDER', 'PAYMENT_CONFIRMATION', 'OPERATIONAL_ORDER'], true)) {
            return $resourceId !== null && app(NotificationPolicy::class)->allows($user, (object) ['user_id' => $user->getKey(), 'category' => 'ORDERS', 'resource_type' => 'ORDER', 'resource_id' => $resourceId]);
        }
        if (in_array($type, ['PROJECT_SUMMARY', 'BUDGET_REPORT'], true)) {
            return $resourceId !== null && app(NotificationPolicy::class)->allows($user, (object) ['user_id' => $user->getKey(), 'category' => 'PROJECTS', 'resource_type' => 'PROJECT', 'resource_id' => $resourceId]);
        }
        if ($type === 'FEE_STATEMENT') {
            $statement = DB::table('fee_statements')->where('id', $resourceId)->first();

            return $statement !== null && (($user->account_type === 'VENDOR' && $scope['role'] === 'OWNER' && $scope['organization_id'] === $statement->vendor_organization_id)
                || ($user->account_type === 'ADMIN' && in_array('finance.export', $scope['permissions'], true) && in_array('finance.view', $scope['permissions'], true)));
        }
        if ($type === 'TAX_PACKAGE') {
            $package = DB::table('tax_report_packages')->where('id', $resourceId)->first();
            if ($package === null || ! in_array($package->state, ['REVIEWED', 'EXPORTED'], true) || $package->due_date_reviewer_id === null) {
                return false;
            }

            return ($user->account_type === 'ADMIN' && in_array('finance.export', $scope['permissions'], true) && in_array('finance.view', $scope['permissions'], true))
                || ($user->account_type === 'VENDOR' && $scope['role'] === 'OWNER' && $package->package_type === '2307' && $scope['organization_id'] === $package->vendor_organization_id);
        }

        return false;
    }
}
