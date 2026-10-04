<?php

declare(strict_types=1);

namespace App\Domain\Disputes;

use App\Domain\Authorization\AccountAccess;
use App\Domain\Orders\OrderActor;
use Illuminate\Support\Facades\DB;

/**
 * Consequences of the Owner's "Allow staff to handle disputes and appeals" flag, applied in the same transaction
 * as the flag change (organization lock held; then each order and case lock).
 *
 *   disabled   every active case handled by Store Staff or Customer Service is reassigned to the Owner (Owner and
 *              Store Managers are told), their queued or ready case exports are revoked, and from this moment the
 *              permission resolver denies them navigation, API, files, exports, realtime and queued notices. Their
 *              earlier submissions keep their original author and role.
 *   enabled    nothing is restored retroactively: access follows the current flag, and reassigned cases stay with
 *              their current handler.
 */
final class DisputeStaffAccess
{
    public function __construct(private readonly DisputeTimeline $timeline, private readonly DisputeNotifier $notifier) {}

    /** @return array{reassigned: int, exports_revoked: int} */
    public function flagChanged(string $organizationId, bool $enabled, OrderActor $owner): array
    {
        if ($enabled) {
            return ['reassigned' => 0, 'exports_revoked' => 0];
        }
        $ownerId = DB::table('vendor_memberships')->where('vendor_organization_id', $organizationId)->where('role', 'OWNER')->where('status', 'ACTIVE')->value('user_id');
        $reassigned = 0;
        $cases = DB::table('dispute_cases')->where('vendor_organization_id', $organizationId)->whereIn('status', DisputeRules::ACTIVE)
            ->whereIn('vendor_handler_role', AccountAccess::FLAG_CONTROLLED_DISPUTE_ROLES)->orderBy('order_id')->get(['id', 'order_id']);
        foreach ($cases as $row) {
            DB::table('orders')->where('id', $row->order_id)->lockForUpdate()->first();
            $case = DB::table('dispute_cases')->where('id', $row->id)->lockForUpdate()->first();
            if ($case === null || ! in_array($case->vendor_handler_role, AccountAccess::FLAG_CONTROLLED_DISPUTE_ROLES, true)) {
                continue;
            }
            DB::table('dispute_cases')->where('id', $case->id)->update(['vendor_handler_user_id' => $ownerId, 'vendor_handler_role' => 'OWNER', 'updated_at' => now()]);
            $this->timeline->append($case, 'HANDLER_REASSIGNED', $owner, 'VENDOR', 'Staff dispute handling was switched off by the store Owner; this case moved to the Owner. Earlier staff actions keep their original attribution.',
                ['from_role' => (string) $case->vendor_handler_role, 'to_role' => 'OWNER']);
            $this->notifier->vendor($case, 'Case '.$case->reference.' moved to the Owner', 'Staff dispute handling was switched off. This open case now routes to the Owner and Store Managers.', ['OWNER', 'STORE_MANAGER']);
            $reassigned++;
        }
        $revoked = DB::table('data_exports')->where('vendor_organization_id', $organizationId)->where('export_type', DisputeExportService::TYPE)->whereIn('state', ['QUEUED', 'READY'])
            ->whereIn('requested_role', AccountAccess::FLAG_CONTROLLED_DISPUTE_ROLES)
            ->update(['state' => 'REVOKED', 'revoked_at' => now(), 'revocation_reason' => 'STAFF_DISPUTE_ACCESS_DISABLED', 'updated_at' => now()]);

        return ['reassigned' => $reassigned, 'exports_revoked' => $revoked];
    }
}
