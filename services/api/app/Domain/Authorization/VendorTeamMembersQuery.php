<?php

declare(strict_types=1);

namespace App\Domain\Authorization;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Database\Query\Builder;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\DB;

final class VendorTeamMembersQuery
{
    public function __construct(private readonly AccountAccess $access) {}

    public function visible(Request $request): Builder
    {
        $scope = $this->access->resolve($request->user());
        if (! in_array('staff.manage', $scope['permissions'], true)) {
            throw new AuthenticationException('PERMISSION_DENIED', 'Staff management is not delegated to this account.', 403);
        }

        return $this->scopedQuery($scope);
    }

    public function activeCount(Request $request): int
    {
        $scope = $this->access->resolve($request->user());
        if (! in_array('staff.manage', $scope['permissions'], true)) {
            return 0;
        }

        return $this->scopedQuery($scope)->where('m.status', 'ACTIVE')->where('u.account_status', 'ACTIVE')->count();
    }

    /** @param array{role: string, organization_id: ?string} $scope */
    private function scopedQuery(array $scope): Builder
    {
        $query = DB::table('vendor_memberships as m')->join('users as u', 'u.id', '=', 'm.user_id')
            ->where('m.vendor_organization_id', $scope['organization_id'])->where('m.role', '!=', 'OWNER')->whereNull('m.deleted_at');
        if ($scope['role'] !== 'OWNER') {
            $query->where('m.role', '!=', 'STORE_MANAGER');
        }

        return $query;
    }
}
