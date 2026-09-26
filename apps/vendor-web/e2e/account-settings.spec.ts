import { expect, test } from '@playwright/test'

for (const portal of ['vendors', 'admin'] as const) {
  test(`${portal} account settings reflow and preserve accessible security controls`, async ({ page }, testInfo) => {
    await page.emulateMedia({ reducedMotion: 'reduce' })
    await page.route('**/api/v1/**', async route => {
      const path = new URL(route.request().url()).pathname
      let data: unknown = { queued: true }
      if (path.endsWith('/csrf')) data = { csrf_token: 'preview-fixture' }
      if (path.endsWith('/profile')) data = {
        id: 'preview-account', full_name: 'Account preview', email: 'preview@example.test',
        account_type: portal === 'vendors' ? 'VENDOR' : 'ADMIN', account_status: 'ACTIVE', lock_version: 1,
        created_at: '2026-09-01T00:00:00Z', buyer_type: null, company_name: null,
        organization_name: portal === 'vendors' ? 'Preview hardware' : null,
        organization_id: null, membership_id: 'preview-membership', role: portal === 'vendors' ? 'STORE_STAFF' : 'ADMIN_SUPPORT',
        can_manage_staff: false, permissions: [],
      }
      if (path.endsWith('/security')) data = { totp_enrolled: portal === 'admin', recent_authentication_expires_at: null }
      if (path.endsWith('/sessions') || path.endsWith('/agreements')) data = []
      await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data, meta: {}, errors: [] }) })
    })
    await page.goto(portal === 'vendors' ? '/settings' : 'http://127.0.0.1:4174/workspace')
    await expect(page.getByRole('heading', { name: 'Settings', exact: true })).toBeVisible()
    await expect(page.getByRole('textbox', { name: 'Full name' })).toBeVisible()
    await expect(page.getByRole('button', { name: 'Admin accounts', exact: true })).toHaveCount(0)
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
    await page.screenshot({ path: testInfo.outputPath(`${portal}-profile.png`), fullPage: true })
    await page.getByRole('button', { name: 'Security', exact: true }).click()
    const verify = page.getByRole('button', { name: 'Verify for other settings', exact: true })
    await expect(verify).toBeEnabled()
    const target = await verify.boundingBox()
    expect(target?.height).toBeGreaterThanOrEqual(44)
    await verify.click()
    const dialog = page.getByRole('dialog', { name: 'Confirm other protected settings' })
    await expect(dialog.getByRole('button', { name: 'Verify and continue' })).toBeEnabled()
    if (portal === 'admin') {
      await expect(dialog.getByRole('textbox', { name: 'Authenticator code' })).toBeVisible()
      await expect(dialog.getByRole('button', { name: 'Send email verification instead' })).toHaveCount(0)
    } else {
      await expect(dialog.locator('input[name="password"]')).toHaveAttribute('type', 'password')
      await dialog.getByRole('button', { name: 'Send email verification instead' }).focus()
      await expect(dialog.getByRole('button', { name: 'Send email verification instead' })).toBeFocused()
    }
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
    await page.screenshot({ path: testInfo.outputPath(`${portal}-security.png`), fullPage: true })
    await page.keyboard.press('Escape')
    await expect(dialog).toHaveCount(0)
    await page.getByRole('button', { name: 'Sessions / Devices', exact: true }).click()
    await expect(page.getByText('No active sessions.')).toBeVisible()
  })
}
