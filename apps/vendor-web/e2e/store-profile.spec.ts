import { expect, test } from '@playwright/test'

test('Store Profile reflows and keeps business evidence and location accessible', async ({ page }, testInfo) => {
  const snapshot = {
    lock_version: 1, requirements: [], drafts: [], step_completion: [], welcome_required: false,
    organization: { store_name: 'Sample Construction Supply', business_type: 'CORPORATION', lock_version: 1 },
    permissions: ['vendor.onboarding.submit', 'vendor.onboarding.manage', 'vendor.onboarding.private_documents', 'portal.vehicles', 'vehicles.manage'],
    activation: { status: 'ACTIVE' },
    verification: { status: 'APPROVED', address: { street: '200 Example Street', barangay: 'Sample Barangay', city_municipality: 'Quezon City', province: 'Metro Manila', postal_code: '1100', latitude: 14.65, longitude: 121.05 }, documents: [{ requirement_key: 'lgu_permit', original_name: 'sample-permit.pdf', file_id: 'fixture-file', version: 1, review: { expiration_kind: 'DATE', verified_expiration_date: '2027-12-31', remarks: 'Verified sample evidence' } }] },
    setup: { status: 'COMPLETED', vacation_mode: false, vacation_status: 'OFF', vacation_starts_on: null as string | null, vacation_ends_on: null as string | null, operating_schedule: Array.from({ length: 7 }, (_, index) => ({ day_of_week: index + 1, status: index === 6 ? 'CLOSED' : 'OPEN', opens_at: index === 6 ? null : '09:00', closes_at: index === 6 ? null : '22:00' })), media: [{ id: 'logo-media', kind: 'LOGO', file_id: 'logo-file', status: 'READY' }], profile: { public_store_name: 'Sample Construction Supply', description: 'Materials for your next project.', public_email: 'store@example.test', public_phone: '09170000000', bulk_capability: true, fulfillment_method: 'VENDOR_DELIVERY' } },
    sections: { STORE_VERIFICATION: { key: 'STORE_VERIFICATION', label: 'Verification', status: 'APPROVED', steps: [{ id: 'permit', key: 'lgu_permit', label: 'LGU permit', status: 'APPROVED', level: 'REQUIRED', lock_version: 1 }] } },
  }
  await page.route('https://example.test/logo.svg', route => route.fulfill({ status: 200, contentType: 'image/svg+xml', body: '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64"><rect width="64" height="64" fill="#c2410c"/><text x="10" y="40" fill="white">SC</text></svg>' }))
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = snapshot
    if (path.endsWith('/csrf')) data = { csrf_token: 'store-profile-fixture' }
    if (path.endsWith('/profile')) data = { id: 'fixture', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', permissions: snapshot.permissions }
    if (path.endsWith('/files/logo-file')) data = { url: 'https://example.test/logo.svg', expires_at: '2027-09-26T00:00:00Z' }
    if (path.endsWith('/setup') && route.request().method() === 'PATCH') {
      const body = route.request().postDataJSON() as { vacation_mode?: boolean; vacation_starts_on?: string; vacation_ends_on?: string }
      if (body.vacation_mode !== undefined) Object.assign(snapshot.setup, { vacation_status: body.vacation_mode ? 'SCHEDULED' : 'OFF', vacation_starts_on: body.vacation_starts_on ?? null, vacation_ends_on: body.vacation_ends_on ?? null })
      data = snapshot
    }
    await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data, meta: {}, errors: [] }) })
  })
  await page.goto('/store-profile')
  await expect(page.getByRole('heading', { name: 'Sample Construction Supply', exact: true })).toBeVisible()
  await expect(page.locator('.portal-footer-avatar img')).toHaveAttribute('src', 'https://example.test/logo.svg')
  const nav = page.getByRole('tablist', { name: 'Workspace sections' })
  await expect(nav.getByRole('tab', { name: 'Primary Contact', exact: true })).toHaveCount(0)
  await expect(nav.getByRole('tab', { name: 'Documents', exact: true })).toHaveCount(0)
  for (const section of ['Store Information', 'Business Information', 'Store Location', 'Vacation Mode', 'Operating Hours', 'Fulfillment Configuration']) {
    await nav.getByRole('tab', { name: section, exact: true }).click()
    await expect(page.getByRole('region', { name: section, exact: true })).toBeVisible()
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
    if (section === 'Business Information') {
      await expect(page.getByText('2027-12-31')).toBeVisible()
      await expect(page.getByRole('button', { name: 'View document' })).toBeVisible()
      await page.screenshot({ path: testInfo.outputPath('business-information.png'), fullPage: true })
    }
    if (section === 'Store Location') await expect(page.getByText('200 Example Street', { exact: true })).toBeVisible()
    if (section === 'Vacation Mode') {
      await page.screenshot({ path: testInfo.outputPath('vacation-off.png'), fullPage: true })
      await page.getByRole('button', { name: 'Turn on Vacation Mode' }).click()
      const dialog = page.getByRole('dialog', { name: 'Set up Vacation Mode' })
      await dialog.getByRole('button', { name: 'Turn on Vacation Mode' }).click()
      await expect(dialog.getByText('Choose the first day of Vacation Mode.')).toBeVisible()
      await dialog.getByLabel('First day').fill('2099-01-12')
      await dialog.getByLabel('Last day').fill('2099-01-14')
      await page.screenshot({ path: testInfo.outputPath('vacation-dialog.png') })
      await dialog.getByRole('button', { name: 'Turn on Vacation Mode' }).click()
      await expect(dialog).toBeHidden()
      await expect(page.getByRole('button', { name: 'Cancel Vacation Mode' })).toBeVisible()
      await expect(page.getByText('January 12, 2099', { exact: true })).toBeVisible()
      await page.screenshot({ path: testInfo.outputPath('vacation-scheduled.png'), fullPage: true })
    }
    if (section === 'Operating Hours') {
      await expect(page.getByRole('combobox', { name: 'Monday status' })).toBeHidden()
      await page.screenshot({ path: testInfo.outputPath('operating-hours.png'), fullPage: true })
      await page.getByRole('button', { name: 'Edit Store Hours' }).click()
      const dialog = page.getByRole('dialog', { name: 'Edit Store Hours' })
      await expect(dialog.getByRole('combobox', { name: 'Monday status' })).toBeVisible()
      await page.screenshot({ path: testInfo.outputPath('operating-hours-dialog.png') })
      await dialog.getByRole('button', { name: 'Cancel' }).click()
      await expect(dialog).toBeHidden()
    }
    if (section === 'Fulfillment Configuration') {
      await expect(page.getByRole('radio', { name: 'Vendor Delivery Only', exact: true })).toBeChecked()
      await expect(page.getByRole('button', { name: 'Save fulfillment configuration' })).toBeVisible()
      await expect(page.getByRole('link', { name: 'Update fulfillment configuration' })).toHaveCount(0)
      await page.screenshot({ path: testInfo.outputPath('fulfillment.png'), fullPage: true })
    }
  }
  if (page.viewportSize()!.width < 1024) await page.getByRole('button', { name: 'Open navigation' }).click()
  await expect(page.getByRole('link', { name: 'Vehicles', exact: true })).toHaveAttribute('href', '/vehicles')
})
