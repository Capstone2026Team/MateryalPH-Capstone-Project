import { expect, test } from '@playwright/test'
const adminUrl = process.env.ADMIN_FINANCE_PREVIEW_URL ?? 'http://127.0.0.1:4174'
test('Tax Management is removed from navigation and old URLs return to Platform Finance', async ({ page }) => {
  const taxRequests: string[] = []
  const pageErrors: string[] = []
  page.on('pageerror', error => pageErrors.push(error.message))
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    if (/withholding-register|tax-issues|reports\/tax|withholding-accumulators/.test(path)) taxRequests.push(path)
    let data: unknown = []
    if (path.endsWith('/profile')) data = { id: 'sample-admin', full_name: 'Sample Finance Reviewer', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-tax-removal-check' }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    else if (path.endsWith('/finance/kpis')) data = { label: 'Recorded finance', scenario: 'Sample figures', period: { from: null, to: null }, finance: [], commerce: [], counts: {}, trend: [], trend_granularity: 'MONTH' }
    else if (path.endsWith('/commission-policy')) data = { current: null, latest_version: 0, can_manage: false, can_export: false, versions: [] }
    await route.fulfill({ json: { data, meta: { page: 1, has_more: false, total: 0 }, errors: [] } })
  })
  for (const path of ['/tax-management', '/tax-management/packages/old-report', '/reports/tax', '/reports/tax/old-report', '/finance/tax/packages/old-report', '/finance/accumulators/old-year', '/finance?view=tax-remittance', '/finance?view=withholding']) {
    await page.goto(`${adminUrl}${path}`)
    await expect(page).toHaveURL(`${adminUrl}/finance`)
    await expect(page.getByRole('heading', { name: 'Finance overview', exact: true, level: 1 })).toBeVisible()
    await expect(page.getByRole('link', { name: 'Tax Management', exact: true, includeHidden: true })).toHaveCount(0)
    await expect(page.getByRole('tab')).toHaveCount(3)
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  }
  expect(taxRequests).toEqual([])
  expect(pageErrors).toEqual([])
})
