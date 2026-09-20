import { expect, test } from '@playwright/test'

for (const portal of ['vendors', 'admin'] as const) {
  test(`${portal} flat navigation fits desktop and uses an accessible drawer on short screens`, async ({ page }, testInfo) => {
    await page.route('**/api/v1/**', async route => {
      const path = new URL(route.request().url()).pathname
      let data: unknown = { queued: true }
      if (path.endsWith('/csrf')) data = { csrf_token: 'preview-fixture' }
      if (path.endsWith('/profile')) data = {
        id: 'preview-account', full_name: 'Account preview', email: 'preview@example.test',
        account_type: portal === 'vendors' ? 'VENDOR' : 'ADMIN', account_status: 'ACTIVE', lock_version: 1,
        created_at: '2026-09-01T00:00:00Z', role: portal === 'vendors' ? 'OWNER' : 'ADMIN_SUPPORT',
        can_manage_staff: false, permissions: ['vendor.onboarding.submit', 'staff.manage'],
      }
      if (path.endsWith('/onboarding')) data = {
        organization: { store_name: 'Preview hardware', lock_version: 1 }, welcome_required: false,
        permissions: ['vendor.onboarding.submit', 'staff.manage'], verification: { status: 'APPROVED' },
        setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE' }, sections: {},
      }
      if (path.endsWith('/agreements')) data = [{ id: 'terms-v1', code: 'TERMS_OF_SERVICE', title: 'Terms of Service', version: '1.0', accepted_at: null, requires_acceptance: true, content_available: true, content: 'Published terms for this account.\n\nPlease review the complete agreement before accepting.' }]
      await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data, meta: {}, errors: [] }) })
    })
    const href = portal === 'vendors' ? '/settings' : 'http://127.0.0.1:4174/workspace'
    await page.goto(href)
    await expect(page.getByRole('heading', { name: 'Settings', exact: true })).toBeVisible()
    const topbar = page.locator('.portal-workspace > header')
    await expect(topbar.getByLabel('System date')).toBeVisible()
    await expect(topbar.getByRole('link', { name: 'Settings', exact: true })).toHaveCount(0)
    await expect(topbar.getByText('Dashboard', { exact: true })).toHaveCount(0)
    await expect(page.getByRole('link', { name: 'Vendor Dashboard', exact: true })).toHaveCount(0)
    const desktop = page.viewportSize()!.width >= 1024 && page.viewportSize()!.height >= 800
    if (!desktop) await page.getByRole('button', { name: 'Open navigation' }).click()
    const sidebar = page.locator('.portal-sidebar')
    await expect(sidebar).toBeVisible()
    await expect(sidebar.locator('details, summary')).toHaveCount(0)
    if (desktop) {
      expect(await sidebar.evaluate(el => el.scrollHeight <= el.clientHeight)).toBe(true)
      expect(await sidebar.evaluate(el => getComputedStyle(el).overflowY)).not.toBe('auto')
      const last = sidebar.locator('.portal-nav-row').last()
      await expect(last).toBeInViewport()
      const before = await sidebar.boundingBox()
      await page.locator('.portal-workspace').evaluate(el => { el.scrollTop = 200 })
      expect(await sidebar.boundingBox()).toEqual(before)
    } else {
      await expect(page.getByRole('button', { name: 'Close navigation' })).toBeFocused()
      await page.keyboard.press('Escape')
      await expect(page.getByRole('button', { name: 'Open navigation' })).toBeFocused()
      await expect(sidebar).not.toBeVisible()
    }
    await page.getByRole('button', { name: 'Account profile options' }).click()
    await expect(topbar.getByRole('link', { name: 'Settings', exact: true })).toHaveAttribute('href', `${portal === 'vendors' ? '/settings' : '/workspace'}#Account`)
    await topbar.getByRole('link', { name: 'Agreements' }).click()
    await expect(page.getByRole('heading', { name: 'Terms of Service', exact: true })).toBeVisible()
    await expect(page.getByRole('button', { name: 'Accept this version' })).toBeEnabled()
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
    await page.screenshot({ path: testInfo.outputPath(`${portal}-agreements-navigation.png`), fullPage: true })
  })
}
