<?php

declare(strict_types=1);

namespace Tests\Unit;

use App\Domain\Authorization\AccountAccess;
use PHPUnit\Framework\TestCase;

final class VendorFixedRolePermissionsTest extends TestCase
{
    public function test_employees_never_receive_owner_financial_or_onboarding_access(): void
    {
        $access = new AccountAccess;
        foreach (array_diff(AccountAccess::VENDOR_ROLES, ['OWNER']) as $role) {
            foreach (['finance.view', 'finance.pay', 'payments.configure', 'portal.wallet', 'portal.earnings', 'vendor.onboarding.manage', 'vendor.onboarding.private_documents', 'vendor.activation'] as $permission) {
                self::assertNotContains($permission, $access->vendorPermissions($role, true), $role.': '.$permission);
                self::assertContains($permission, $access->vendorPermissions('OWNER'));
            }
        }
    }

    public function test_staff_delegation_does_not_grant_manager_or_owner_powers(): void
    {
        $access = new AccountAccess;
        self::assertNotContains('staff.manage', $access->vendorPermissions('STORE_MANAGER'));
        self::assertContains('staff.manage', $access->vendorPermissions('STORE_MANAGER', true));
        self::assertContains('portal.tracking', $access->vendorPermissions('STORE_MANAGER', true));
        self::assertNotContains('staff.delegate', $access->vendorPermissions('STORE_MANAGER', true));
        foreach (['STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT'] as $role) {
            self::assertNotContains('staff.manage', $access->vendorPermissions($role, true));
        }
    }

    public function test_sales_inventory_and_fulfillment_capabilities_remain_separate(): void
    {
        $access = new AccountAccess;
        self::assertNotContains('inventory.manage', $access->vendorPermissions('CUSTOMER_SERVICE'));
        self::assertNotContains('orders.confirm', $access->vendorPermissions('INVENTORY'));
        self::assertNotContains('portal.messages', $access->vendorPermissions('INVENTORY'));
        self::assertNotContains('fulfillment.record', $access->vendorPermissions('STORE_STAFF'));
        self::assertNotContains('catalog.manage', $access->vendorPermissions('FULFILLMENT'));
        self::assertSame([], $access->vendorPermissions('UNKNOWN'));
    }
}
