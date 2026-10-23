import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'
import { adminInsights, vendorInsights } from './fixtures/dashboard-insights'

async function mockDashboard(page: Page, portal: 'vendor' | 'admin', restricted = false) {
  const reads = { vendor: 0, admin: 0 }
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    if (path.endsWith('/onboarding')) reads.vendor += 1
    if (path.endsWith('/admin/dashboard')) reads.admin += 1
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'dashboard-review', full_name: 'Dashboard Reviewer', account_type: portal.toUpperCase(), account_status: 'ACTIVE', role: portal === 'admin' ? 'ADMIN_SUPERADMIN' : 'OWNER' }
    else if (path.endsWith('/onboarding')) data = {
      step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1,
      organization: { store_name: reads.vendor > 1 ? 'Updated Supply' : 'Sample Supply', lock_version: 1 },
      permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit'], welcome_required: false,
      verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'NO_ACTIVE_LISTINGS', readiness: { ready: true, blockers: [] } },
    }
    else if (path.endsWith('/admin/dashboard')) data = {
      generated_at: '2026-09-30T06:00:00Z', active_vendors: restricted ? null : 23 + reads.admin,
      inactive_vendors: restricted ? null : 8, active_buyers: restricted ? null : 128,
      pending_document_reviews: restricted ? null : 6, audit_events: restricted ? null : 340,
      can_view_audit: !restricted,
    }
    else if (path.endsWith('/admin/dashboard/audit')) data = []
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'dashboard-review-csrf-token' }
    else if (path.endsWith('/vendor/dashboard/insights')) data = vendorInsights()
    else if (path.endsWith('/admin/dashboard/insights')) data = restricted
      ? { generated_at: '2026-09-30T06:00:00Z', access: { marketplace: false, vendor_health: false }, definitions: {}, marketplace: null, marketplace_unavailable_reason: null, vendor_health: null }
      : adminInsights()
    await route.fulfill({ json: { data, meta: { last_page: 1 }, errors: [] } })
  })
  return reads
}

async function capture(page: Page, name: string) {
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const directory = resolve('../../docs/design/evidence/dashboard-layout')
  mkdirSync(directory, { recursive: true })
  await page.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${name}.png`), fullPage: true })
}

test('Vendor dashboard switches sections without stacking reports', async ({ page }) => {
  await page.clock.install()
  const reads = await mockDashboard(page, 'vendor')
  await page.goto('/dashboard')
  await expect(page.getByRole('heading', { name: 'Dashboard', exact: true })).toBeVisible()
  await expect(page.getByRole('button', { name: /Refresh/ })).toHaveCount(0)
  await expect(page.getByRole('region', { name: 'Store workspace', exact: true })).toBeVisible()
  await expect(page.getByRole('img', { name: /Orders confirmed per day/ })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Incoming order requests', exact: true })).toBeVisible()
  await capture(page, 'vendor-overview')
  const navigation = page.getByRole('tablist', { name: 'Workspace sections' })
  await navigation.getByRole('tab', { name: 'Sales & Revenue', exact: true }).click()
  await expect(page.getByRole('region', { name: 'Store workspace', exact: true })).toHaveCount(0)
  await expect(page.getByRole('region', { name: 'Sales and 7-day forecast', exact: true })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Frequently ordered together', exact: true })).toBeVisible()
  await expect(navigation.getByRole('tab', { name: 'Sales & Revenue', exact: true })).toHaveAttribute('aria-selected', 'true')
  await capture(page, 'vendor-sales')
  for (const [tab, region, name] of [['Performance', 'Store health indicator', 'vendor-performance'], ['Action Items & Alerts', 'Action items', 'vendor-actions'], ['Traffic & Volume', 'Demand funnel', 'vendor-traffic'], ['Disputes & Quality', 'Issue types', 'vendor-quality']] as const) {
    await navigation.getByRole('tab', { name: tab, exact: true }).click()
    await expect(page.getByRole('region', { name: region, exact: true })).toBeVisible()
    await capture(page, name)
  }
  await navigation.getByRole('tab', { name: 'Sales & Revenue', exact: true }).click()
  await page.clock.fastForward(30_000)
  await expect.poll(() => reads.vendor).toBe(2)
  await expect(page.getByRole('main').getByText('Updated Supply', { exact: true })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Sales and 7-day forecast', exact: true })).toBeVisible()
  await navigation.getByRole('tab', { name: 'Overview', exact: true }).focus()
  await page.keyboard.press('Enter')
  await expect(page.getByRole('region', { name: 'Store workspace', exact: true })).toBeVisible()
})

test('Admin dashboard uses current counts and isolated sections', async ({ page }) => {
  await page.clock.install()
  const reads = await mockDashboard(page, 'admin')
  await page.goto('http://127.0.0.1:4174/dashboard')
  await expect(page.getByRole('heading', { name: '6 business documents awaiting review' })).toBeVisible()
  await expect(page.getByRole('button', { name: /Refresh/ })).toHaveCount(0)
  await expect(page.getByRole('link', { name: 'Open Vendor Management', exact: true })).toHaveAttribute('href', '/vendor-verification')
  await expect(page.getByRole('img', { name: /Gross and net GMV per day/ })).toBeVisible()
  await capture(page, 'admin-overview')
  const navigation = page.getByRole('tablist', { name: 'Workspace sections' })
  await navigation.getByRole('tab', { name: 'User Activity', exact: true }).click()
  await expect(page.getByRole('region', { name: 'Review priorities', exact: true })).toHaveCount(0)
  await expect(page.getByRole('region', { name: 'Active Buyers and Vendor users', exact: true })).toBeVisible()
  await expect(page.getByRole('link', { name: 'Open Vendor Management', exact: true }).filter({ visible: true })).toHaveAttribute('href', '/vendor-verification')
  await expect(page.getByRole('region', { name: 'Vendor health indicator', exact: true })).toBeVisible()
  await capture(page, 'admin-user-activity')
  await navigation.getByRole('tab', { name: 'Transactions & Finance', exact: true }).click()
  await expect(page.getByRole('region', { name: 'Categories ordered together', exact: true })).toBeVisible()
  await capture(page, 'admin-finance')
  await navigation.getByRole('tab', { name: 'User Activity', exact: true }).click()
  await page.clock.fastForward(30_000)
  await expect.poll(() => reads.admin).toBe(2)
  await expect(page.getByRole('region', { name: 'User Activity', exact: true }).getByText('25', { exact: true }).filter({ visible: true }).first()).toBeVisible()
  await navigation.getByRole('tab', { name: 'Audit Logs & Tracking', exact: true }).click()
  await expect(page.getByText('No audit events recorded.')).toBeVisible()
  await capture(page, 'admin-health')
})

test('Admin dashboard preserves restricted counts and audit visibility', async ({ page }) => {
  await mockDashboard(page, 'admin', true)
  await page.goto('http://127.0.0.1:4174/dashboard')
  await expect(page.getByRole('heading', { name: 'Reviews outside your role scope' })).toBeVisible()
  await expect(page.getByRole('link', { name: 'Open Vendor Management', exact: true })).toHaveCount(0)
  await expect(page.getByRole('link', { name: 'View audit log', exact: true })).toHaveCount(0)
  await page.getByRole('tablist', { name: 'Workspace sections' }).getByRole('tab', { name: 'Audit Logs & Tracking' }).click()
  await expect(page.getByRole('region', { name: 'Recent platform activity', exact: true })).toHaveCount(0)
  await expect(page.getByText('Audit logs are outside your role scope.').filter({ visible: true })).toBeVisible()
  await expect(page.getByRole('img', { name: /GMV/ })).toHaveCount(0)
  await capture(page, 'admin-restricted')
})
