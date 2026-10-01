import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

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
  await capture(page, 'vendor-overview')
  const navigation = page.getByRole('navigation', { name: 'Workspace sections' })
  await navigation.getByRole('button', { name: 'Sales & Revenue', exact: true }).click()
  await expect(page.getByRole('region', { name: 'Store workspace', exact: true })).toHaveCount(0)
  await expect(page.getByRole('region', { name: 'Revenue overview', exact: true })).toBeVisible()
  await expect(navigation.getByRole('button', { name: 'Sales & Revenue', exact: true })).toHaveAttribute('aria-pressed', 'true')
  await capture(page, 'vendor-sales')
  await page.clock.fastForward(30_000)
  await expect.poll(() => reads.vendor).toBe(2)
  await expect(page.getByRole('main').getByText('Updated Supply', { exact: true })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Revenue overview', exact: true })).toBeVisible()
  await navigation.getByRole('button', { name: 'Overview', exact: true }).focus()
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
  await capture(page, 'admin-overview')
  const navigation = page.getByRole('navigation', { name: 'Workspace sections' })
  await navigation.getByRole('button', { name: 'Vendor Activity', exact: true }).click()
  await expect(page.getByRole('region', { name: 'Review priorities', exact: true })).toHaveCount(0)
  await expect(page.getByRole('region', { name: 'Vendor verification', exact: true })).toBeVisible()
  await page.clock.fastForward(30_000)
  await expect.poll(() => reads.admin).toBe(2)
  await expect(page.getByRole('region', { name: 'Vendor Activity', exact: true }).getByText('25', { exact: true })).toBeVisible()
  await navigation.getByRole('button', { name: 'Platform Health', exact: true }).click()
  await expect(page.getByText('No audit events recorded.')).toBeVisible()
  await capture(page, 'admin-health')
})

test('Admin dashboard preserves restricted counts and audit visibility', async ({ page }) => {
  await mockDashboard(page, 'admin', true)
  await page.goto('http://127.0.0.1:4174/dashboard')
  await expect(page.getByRole('heading', { name: 'Reviews outside your role scope' })).toBeVisible()
  await expect(page.getByRole('link', { name: 'Open Vendor Management', exact: true })).toHaveCount(0)
  await expect(page.getByRole('link', { name: 'View audit log', exact: true })).toHaveCount(0)
  await page.getByRole('navigation', { name: 'Workspace sections' }).getByRole('button', { name: 'Platform Health' }).click()
  await expect(page.getByRole('region', { name: 'Recent platform activity', exact: true })).toHaveCount(0)
  await capture(page, 'admin-restricted')
})
