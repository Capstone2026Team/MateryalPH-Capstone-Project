<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Authorization\AccountAccess;
use PHPUnit\Framework\TestCase;

final class FulfillmentWorkspacePermissionsTest extends TestCase
{
    public function test_workspace_is_exclusive_to_fulfillment_staff_without_product_or_invoice_authority(): void
    {
        $access = new AccountAccess;
        foreach (AccountAccess::VENDOR_ROLES as $role) {
            $permissions = $access->vendorPermissions($role);
            self::assertSame($role === 'FULFILLMENT', in_array('portal.fulfillment', $permissions, true), $role);
            if ($role === 'FULFILLMENT') {
                foreach (['portal.products', 'portal.invoices', 'invoices.view', 'fulfillment.assign', 'vehicles.manage'] as $forbidden) {
                    self::assertNotContains($forbidden, $permissions);
                }
            }
            if (in_array($role, ['OWNER', 'STORE_MANAGER'], true)) {
                self::assertContains('fulfillment.assign', $permissions);
                self::assertContains('fulfillment.record', $permissions);
            }
        }
    }
}
