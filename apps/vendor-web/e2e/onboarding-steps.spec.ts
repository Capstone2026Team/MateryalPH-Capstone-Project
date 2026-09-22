import { expect, test, type Page } from '@playwright/test'

test.beforeEach(async ({ page }) => {
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'preview-account', full_name: 'Vendor Owner', email: 'owner@example.test', account_type: 'VENDOR', account_status: 'ACTIVE', lock_version: 1, created_at: '2026-09-01T00:00:00Z', role: 'OWNER' }
    if (path.endsWith('/onboarding')) data = {
      organization: { store_name: 'Sample Building Supply', registered_name: 'Sample Building Supply', business_type: 'CORPORATION', store_email: 'store@example.test', store_email_verified: true, lock_version: 1 },
      welcome_required: false, permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit'],
      verification: { status: 'IN_PROGRESS', address: { city_municipality: 'Sample City', province: 'Sample Province' } },
      setup: { status: 'IN_PROGRESS', profile: { public_store_name: 'Sample Building Supply', description: 'Construction materials for projects of every size.', public_email: 'store@example.test', public_phone: '+639170000000' }, media: [{ kind: 'BANNER', file_id: 'banner', alt_text: 'Sample store banner' }, { kind: 'LOGO', file_id: 'logo', alt_text: 'Sample store logo' }] },
      activation: { status: 'NOT_READY' }, sections: {
        STORE_VERIFICATION: { key: 'STORE_VERIFICATION', label: 'Store Verification', status: 'IN_PROGRESS', complete: 0, total: 10, progress: { complete: 0, total: 10 }, steps: [] },
        STORE_SETUP: { key: 'STORE_SETUP', label: 'Store Setup', status: 'IN_PROGRESS', complete: 0, total: 6, progress: { complete: 0, total: 6 }, steps: [] },
      },
    }
    if (path.includes('/files/')) data = { url: `http://127.0.0.1:4173/preview-media/${path.includes('banner') ? 'banner' : 'logo'}.svg`, expires_at: '2026-09-20T15:00:00Z' }
    await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data, meta: {}, errors: [] }) })
  })
  await page.route('**/preview-media/*.svg', async route => {
    const banner = route.request().url().includes('banner')
    await route.fulfill({ contentType: 'image/svg+xml', body: `<svg xmlns="http://www.w3.org/2000/svg" width="${banner ? 900 : 200}" height="${banner ? 300 : 200}" viewBox="0 0 ${banner ? '900 300' : '200 200'}"><rect width="100%" height="100%" fill="#334155"/><text x="50%" y="55%" text-anchor="middle" font-size="${banner ? 44 : 64}" font-family="sans-serif" fill="white">${banner ? 'SAMPLE BUILDING SUPPLY' : 'SB'}</text></svg>` })
  })
})

test('verification steps reflow and keep only the selected requirement area visible', async ({ page }, testInfo) => {
  const errors: string[] = []
  page.on('pageerror', error => errors.push(error.message))
  await page.goto('/onboarding/verification')
  await expect(page.getByRole('heading', { name: 'Business Information', exact: true })).toBeVisible()
  await expect(page.getByRole('combobox', { name: 'Business type' })).toBeVisible()
  await expect(page.getByRole('heading', { name: 'Private evidence' })).toBeVisible()
  await assertStepperFits(page, 'Store Verification', 4)
  const business = page.getByRole('group', { name: 'Business information', exact: true })
  await expect(business.getByText('Verified', { exact: true })).toBeVisible()
  const email = business.getByRole('textbox', { name: 'Store email', exact: true })
  await expect(email).toHaveValue('store@example.test')
  await expect(email).toHaveAttribute('readonly', '')
  await expect(business.getByLabel('Email to verify')).toHaveCount(0)
  await expect(business.getByRole('button', { name: 'Send Code' })).toHaveCount(0)
  await business.screenshot({ path: testInfo.outputPath('business-information.png') })
  const before = await email.boundingBox()
  if (page.viewportSize()!.width >= 640) {
    const registered = await business.getByLabel('Company registered name').boundingBox()
    const date = await business.getByLabel('Date established').boundingBox()
    const name = await business.getByRole('textbox', { name: 'Public Store Name', exact: true }).boundingBox()
    const phone = await business.getByLabel('Store phone').boundingBox()
    expect(registered!.y).toBe(date!.y)
    expect(name!.x).toBe(registered!.x)
    expect(name!.width).toBeCloseTo(date!.x + date!.width - registered!.x, 0)
    expect(phone!.y).toBe(before!.y)
    expect(phone!.height).toBe(before!.height)
    expect(phone!.width).toBeCloseTo(before!.width, 0)
  }
  await business.getByRole('button', { name: 'Change', exact: true }).click()
  await expect(email).toBeEditable()
  await expect(email).toBeFocused()
  await expect(business.getByRole('button', { name: 'Send Code' })).toBeVisible()
  const after = await email.boundingBox()
  expect(after!.width).toBe(before!.width)
  expect(after!.height).toBe(before!.height)
  await email.fill('replacement@example.test')
  await expect(business.getByText('Verified', { exact: true })).toHaveCount(0)
  await business.screenshot({ path: testInfo.outputPath('business-information-editing.png') })
  await email.fill('store@example.test')

  await page.screenshot({ path: testInfo.outputPath('verification-business-type.png'), fullPage: true })
  await page.getByRole('textbox', { name: 'Company registered name' }).fill('Retained draft name')
  await page.getByRole('button', { name: 'Next', exact: true }).click()
  await expect(page.getByRole('heading', { name: 'Registered Business Address', exact: true })).toBeFocused()
  await expect(page.getByRole('textbox', { name: 'Company registered name' })).toHaveCount(0)
  await expect(page.getByRole('textbox', { name: 'Street', exact: true })).toBeVisible()
  await page.screenshot({ path: testInfo.outputPath('verification-address.png'), fullPage: true })
  await page.getByRole('button', { name: 'Back', exact: true }).click()
  await expect(page.getByRole('textbox', { name: 'Company registered name' })).toHaveValue('Retained draft name')
  await expect(page.getByLabel('Core TIN', { exact: true })).toBeVisible()
  await assertStepperFits(page, 'Store Verification', 4)
  await page.evaluate(() => window.scrollTo(0, 0))
  await page.screenshot({ path: testInfo.outputPath('verification-tax-header.png') })
  await page.getByRole('button', { name: '4 Privacy, Review and Submit' }).click()
  await expect(page.getByRole('checkbox', { name: /I acknowledge/ })).toBeVisible()
  await expect(page.getByRole('textbox')).toHaveCount(0)
  await expect(page.getByRole('button', { name: 'Submit Store Verification' })).toBeDisabled()
  await expect(page.getByRole('checkbox', { name: /I acknowledge/ })).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  expect(errors).toEqual([])
})

test('setup previews media and switches every operational section without page overflow', async ({ page }, testInfo) => {
  await page.goto('/onboarding/setup')
  const preview = page.getByRole('complementary', { name: 'Store Profile Preview' })
  await expect(preview.getByRole('img', { name: 'Sample store banner' })).toBeVisible()
  await expect(preview.getByRole('img', { name: 'Sample store logo' })).toBeVisible()
  await page.getByRole('textbox', { name: 'Public store name' }).fill('Updated Supply Store')
  await expect(preview.getByRole('heading', { name: 'Updated Supply Store' })).toBeVisible()
  await page.screenshot({ path: testInfo.outputPath('setup-public-preview.png'), fullPage: true })
  await assertStepperFits(page, 'Store Setup', 6)
  await expect(page.getByLabel('Upload image')).toHaveCount(2)
  const labels = ['Fulfillment Configuration', 'Xendit TEST Connection', '2% Commission Terms', 'Team Accounts', 'Review and Complete']
  for (const label of labels) {
    await page.getByRole('button', { name: 'Next', exact: true }).click()
    await expect(page.locator('#onboarding-section-title')).toHaveText(label)
    await expect(preview).not.toBeVisible()
    if (label === 'Fulfillment Configuration') {
      await expect(page.getByRole('radio', { name: 'Not currently' })).toBeVisible()
      await expect(page.getByRole('combobox', { name: 'Fulfillment method' })).toBeVisible()
      await expect(page.getByRole('spinbutton', { name: 'Delivery radius (km)' })).toBeVisible()
      await expect(page.getByRole('textbox', { name: 'Vehicle name' })).toBeVisible()
    }
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  }
  await expect(page.getByRole('button', { name: 'Complete Store Setup' })).toBeDisabled()
  await page.getByRole('button', { name: '1 Public Store Profile' }).click()
  await expect(page.getByRole('textbox', { name: 'Public store name' })).toHaveValue('Updated Supply Store')
  await page.emulateMedia({ reducedMotion: 'reduce' })
  await page.getByRole('button', { name: '2 Fulfillment Configuration' }).focus()
  await page.keyboard.press('Enter')
  await expect(page.locator('#onboarding-section-title')).toBeFocused()
  await page.screenshot({ path: testInfo.outputPath('setup-fulfillment.png'), fullPage: true })
})

async function assertStepperFits(page: Page, area: string, count: number) {
  const nav = page.getByRole('navigation', { name: `${area} steps` })
  const buttons = nav.getByRole('button')
  await expect(buttons).toHaveCount(count)
  const geometry = await nav.evaluate(el => {
    const list = el.querySelector('ol')!
    const bounds = list.getBoundingClientRect()
    return { overflow: list.scrollWidth > list.clientWidth, rows: [...el.querySelectorAll('button')].map(button => {
      const box = button.getBoundingClientRect()
      return { top: box.top, height: box.height, fits: box.left >= bounds.left && box.right <= bounds.right + 1, fontSize: parseFloat(getComputedStyle(button).fontSize) }
    }) }
  })
  expect(geometry.overflow).toBe(false)
  for (const row of geometry.rows) { expect(row.fits).toBe(true); expect(row.fontSize).toBeGreaterThanOrEqual(14) }
  if (page.viewportSize()!.width >= 1024) {
    expect(new Set(geometry.rows.map(row => row.top)).size).toBe(1)
    expect(new Set(geometry.rows.map(row => row.height)).size).toBe(1)
  }
  const areas = page.getByRole('navigation', { name: 'Onboarding area' })
  await expect(areas.getByRole('link')).toHaveCount(2)
  await expect(areas.getByRole('link', { name: new RegExp(area) })).toHaveAttribute('aria-current', 'page')
}
