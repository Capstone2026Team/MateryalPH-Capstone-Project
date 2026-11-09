import { expect, test, type Page } from '@playwright/test'

// Synthetic portal responses verify navigation and routing without provider calls.
async function fixture(page: Page) {
  const retiredRequests: string[] = []
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    if (path.includes('/admin/order-operations/') || path.endsWith('/admin/invoices')) retiredRequests.push(path)
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'layout-review', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-layout-csrf' }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta: { has_more: false }, errors: [] } })
  })
  return retiredRequests
}

for (const path of ['/order-operations', '/invoices']) {
  test(`retired Admin page ${path} is unavailable and Tracking keeps Audit Log`, async ({ page }) => {
    const retiredRequests = await fixture(page)
    await page.goto(`http://127.0.0.1:4174${path}`)
    await expect(page.getByRole('heading', { name: 'Page not found', level: 1 })).toBeVisible()
    await expect(page.getByRole('heading', { name: /Orders & Refunds|Invoice Request Log/ })).toHaveCount(0)
    const mobile = page.viewportSize()!.width < 1024
    if (mobile) await page.getByRole('button', { name: 'Open navigation' }).click()
    const sidebar = page.getByRole('complementary', { name: 'ADMIN PORTAL navigation' })
    const tracking = sidebar.getByRole('region', { name: 'Tracking' })
    await expect(tracking.getByRole('link')).toHaveCount(1)
    await expect(tracking.getByRole('link', { name: 'Audit Log' })).toHaveAttribute('href', '/audit')
    await expect(sidebar.getByRole('link', { name: /Orders & Refunds|Invoice Request Log/ })).toHaveCount(0)
    if (mobile) await page.getByRole('button', { name: 'Close navigation' }).click()
    await expect(page.getByRole('link', { name: 'Invoice Request Log' })).toHaveCount(0)
    expect(retiredRequests).toEqual([])
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
    await page.screenshot({ path: test.info().outputPath('admin-tracking.png'), fullPage: true })
  })
}
