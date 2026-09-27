import { expect, test } from '@playwright/test'

for (const portal of ['vendors', 'admin'] as const) {
  test(`${portal} sidebar pins branding and identity around independently scrolling navigation`, async ({ page }, testInfo) => {
    await page.route('**/api/v1/**', async route => {
      const path = new URL(route.request().url()).pathname
      let data: unknown = { queued: true }
      if (path.endsWith('/csrf')) data = { csrf_token: 'preview-fixture' }
      if (path.endsWith('/profile')) data = {
        id: 'preview-account', full_name: 'Account preview', email: 'preview@example.test',
        account_type: portal === 'vendors' ? 'VENDOR' : 'ADMIN', account_status: 'ACTIVE', lock_version: 1,
        created_at: '2026-09-01T00:00:00Z', role: portal === 'vendors' ? 'OWNER' : 'ADMIN_SUPPORT',
        organization_name: 'Preview hardware', can_manage_staff: false, permissions: ['vendor.onboarding.submit', 'staff.manage'],
      }
      if (path.endsWith('/onboarding')) data = {
        step_completion: [], requirements: [], drafts: [], lock_version: 1,
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
    const desktop = page.viewportSize()!.width >= 1024
    if (!desktop) await page.getByRole('button', { name: 'Open navigation' }).click()
    const sidebar = page.locator('.portal-sidebar')
    await expect(sidebar).toBeVisible()
    await expect(sidebar.locator('details, summary')).toHaveCount(0)
    const menu = sidebar.locator('.portal-nav')
    const branding = sidebar.locator('.portal-sidebar-header')
    const footer = sidebar.locator('.portal-sidebar-footer')
    await expect(footer).toContainText(portal === 'vendors' ? 'Preview hardware' : 'Account preview')
    const headerBefore = await branding.boundingBox()
    const footerBefore = await footer.boundingBox()
    await menu.evaluate(el => { el.scrollTop = el.scrollHeight })
    expect(await branding.boundingBox()).toEqual(headerBefore)
    expect(await footer.boundingBox()).toEqual(footerBefore)
    await expect(sidebar.locator('.portal-nav-row').last()).toBeInViewport()
    expect(await sidebar.evaluate(el => getComputedStyle(el).overflowY)).toBe('hidden')
    await page.screenshot({ path: testInfo.outputPath(`${portal}-navigation.png`) })
    if (desktop) {
      await expect(page.locator('html')).toHaveCSS('overflow-y', 'hidden')
      await expect(page.locator('body')).toHaveCSS('overflow-y', 'hidden')
      await expect(page.locator('.portal-workspace')).toHaveCSS('overflow-y', 'auto')
      expect(await page.evaluate(() => document.documentElement.scrollHeight <= innerHeight)).toBe(true)
      await menu.locator('.portal-nav-row').last().hover()
      await expect(page.getByRole('tooltip')).toHaveCount(0)
      await expect(sidebar.locator('[title]')).toHaveCount(0)
      const expanded = await sidebar.boundingBox()
      const destinations = await menu.locator('.portal-nav-row').evaluateAll(rows => rows.map(row => row.getAttribute('href')))
      await page.getByRole('button', { name: 'Collapse sidebar' }).click()
      await expect(sidebar).toHaveCSS('width', '72px')
      await expect(page.getByRole('button', { name: 'Expand sidebar' })).toHaveAttribute('aria-expanded', 'false')
      await expect(menu.locator('.portal-nav-label').first()).toHaveCSS('height', '0px')
      expect(await menu.locator('.portal-nav-row').evaluateAll(rows => rows.map(row => row.getAttribute('href')))).toEqual(destinations)
      const geometry = await menu.evaluate(el => ({
        rows: [...el.querySelectorAll('.portal-nav-row')].map(row => { const box = row.getBoundingClientRect(); return { top: box.top, bottom: box.bottom, height: box.height, width: box.width } }),
        dividers: [...el.querySelectorAll('section + section')].map(section => { const style = getComputedStyle(section, '::before'); return { height: style.height, opacity: style.opacity } }),
      }))
      for (const [index, row] of geometry.rows.entries()) {
        expect(row.height).toBe(36)
        expect(row.width).toBeGreaterThanOrEqual(44)
        if (index > 0) expect(row.top - geometry.rows[index - 1]!.bottom).toBeLessThanOrEqual(10)
      }
      for (const divider of geometry.dividers) expect(divider).toEqual({ height: '1px', opacity: '1' })
      const last = sidebar.locator('.portal-nav-row').last()
      await last.focus()
      await expect(page.getByRole('tooltip')).toHaveCount(0)
      await last.hover()
      await expect(page.getByRole('tooltip')).toContainText(await last.getAttribute('aria-label') ?? '')
      await page.keyboard.press('Escape')
      await expect(page.getByRole('tooltip')).toHaveCount(0)
      expect((await page.locator('.portal-workspace').boundingBox())!.x).toBe(72)
      await page.screenshot({ path: testInfo.outputPath(`${portal}-collapsed.png`) })
      await page.reload()
      await expect(sidebar).toHaveCSS('width', '72px')
      await expect(footer).toContainText(portal === 'vendors' ? 'Preview hardware' : 'Account preview')
      await page.getByRole('button', { name: 'Expand sidebar' }).click()
      await expect(sidebar).toHaveCSS('width', `${expanded!.width}px`)
      await menu.locator('.portal-nav-row').last().hover()
      await expect(page.getByRole('tooltip')).toHaveCount(0)
      await footer.locator('a').hover()
      await expect(page.getByRole('tooltip')).toHaveCount(0)
      await page.emulateMedia({ reducedMotion: 'reduce' })
      await expect(page.locator('.portal-layout')).toHaveCSS('transition-duration', '0s')
      await page.screenshot({ path: testInfo.outputPath(`${portal}-expanded.png`) })
      const before = await sidebar.boundingBox()
      await page.locator('.portal-workspace').evaluate(el => { el.scrollTop = 200 })
      expect(await sidebar.boundingBox()).toEqual(before)
    } else {
      await page.getByRole('button', { name: 'Close navigation' }).focus()
      await page.keyboard.press('Tab')
      await expect(sidebar.locator('.portal-nav-row').first()).toBeFocused()
      await page.keyboard.press('Escape')
      await expect(page.getByRole('button', { name: 'Open navigation' })).toBeFocused()
      await expect(sidebar).not.toBeVisible()
    }
    if (portal === 'vendors' && desktop) {
      await page.goto('/store-profile')
      await expect(page.getByRole('heading', { name: 'Public store information' })).toBeVisible()
      expect(await page.evaluate(() => document.documentElement.scrollHeight <= innerHeight)).toBe(true)
      await page.getByRole('button', { name: 'Save Store Profile' }).focus()
      await expect(page.getByRole('button', { name: 'Save Store Profile' })).toBeInViewport()
      expect(await page.evaluate(() => scrollY)).toBe(0)
    }
    await page.getByRole('button', { name: 'Account profile options' }).click()
    await expect(topbar.getByRole('link', { name: 'Settings', exact: true })).toHaveAttribute('href', `${portal === 'vendors' ? '/settings' : '/workspace'}#Account`)
    await topbar.getByRole('link', { name: 'Agreements' }).click()
    await expect(page.getByRole('heading', { name: 'Terms of Service', exact: true })).toBeVisible()
    await expect(page.getByRole('button', { name: 'Accept this version' })).toBeEnabled()
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
    await page.screenshot({ path: testInfo.outputPath(`${portal}-agreements-navigation.png`), fullPage: true })
    if (!desktop) await page.getByRole('button', { name: 'Open navigation' }).click()
    await footer.getByRole('link').click()
    await expect(page.getByRole('heading', { name: 'Profile picture', exact: true })).toBeVisible()
    await expect(page).toHaveURL(/#Profile$/)
  })
}
