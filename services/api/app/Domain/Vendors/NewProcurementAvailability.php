<?php

declare(strict_types=1);

namespace App\Domain\Vendors;

use App\Domain\Identity\AuthenticationException;
use Illuminate\Support\Facades\DB;

/** Use inside each future new-order, inquiry or quotation-acceptance transaction. */
final class NewProcurementAvailability
{
    public function assertAvailable(string $organizationId): void
    {
        if (DB::transactionLevel() < 1) {
            throw new \LogicException('Check procurement availability inside the procurement transaction.');
        }
        // Same lock order as profile updates prevents a concurrent vacation toggle bypass.
        $organization = DB::table('vendor_organizations')->where('id', $organizationId)->lockForUpdate()->first();
        $profile = DB::table('store_profiles')->where('vendor_organization_id', $organizationId)->first();
        if ($organization === null || $organization->account_status !== 'ACTIVE' || $organization->store_activation_status !== 'ACTIVE' || $profile === null) {
            throw new AuthenticationException('STORE_UNAVAILABLE', 'This store is unavailable for new procurement.', 409);
        }
        if ($profile->vacation_mode) {
            throw new AuthenticationException('STORE_ON_VACATION', 'This store has paused new procurement.', 409);
        }
    }
}
