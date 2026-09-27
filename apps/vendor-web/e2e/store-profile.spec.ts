import { expect, test } from '@playwright/test'

test('Store Profile reflows and keeps business evidence and location accessible', async ({ page }, testInfo) => {
  const snapshot = {
    lock_version: 1, requirements: [], drafts: [], step_completion: [], welcome_required: false,
    organization: { store_name: 'Sample Construction Supply', business_type: 'CORPORATION', lock_version: 1 },
    permissions: ['vendor.onboarding.submit', 'vendor.onboarding.manage', 'vendor.onboarding.private_documents'],
    activation: { status: 'ACTIVE' },
    verification: { status: 'APPROVED', address: { street: '200 Example Street', barangay: 'Sample Barangay', city_municipality: 'Quezon City', province: 'Metro Manila', postal_code: '1100', latitude: 14.65, longitude: 121.05 }, documents: [{ requirement_key: 'lgu_permit', original_name: 'sample-permit.pdf', file_id: 'fixture-file', version: 1, review: { expiration_kind: 'DATE', verified_expiration_date: '2027-12-31', remarks: 'Verified sample evidence' } }] },
    setup: { status: 'COMPLETED', vacation_mode: false, media: [{ id: 'logo-media', kind: 'LOGO', file_id: 'logo-file', status: 'READY' }], profile: { public_store_name: 'Sample Construction Supply', description: 'Materials for your next project.', public_email: 'store@example.test', public_phone: '09170000000', bulk_capability: true, fulfillment_method: 'VENDOR_DELIVERY' } },
    sections: { STORE_VERIFICATION: { key: 'STORE_VERIFICATION', label: 'Verification', status: 'APPROVED', steps: [{ id: 'permit', key: 'lgu_permit', label: 'LGU permit', status: 'APPROVED', level: 'REQUIRED', lock_version: 1 }] } },
  }
  await page.route('https://example.test/logo.svg', route => route.fulfill({ status: 200, contentType: 'image/svg+xml', body: '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64"><rect width="64" height="64" fill="#c2410c"/><text x="10" y="40" fill="white">SC</text></svg>' }))
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = snapshot
    if (path.endsWith('/csrf')) data = { csrf_token: 'store-profile-fixture' }
    if (path.endsWith('/profile')) data = { id: 'fixture', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', permissions: snapshot.permissions }
    if (path.endsWith('/files/logo-file')) data = { url: 'https://example.test/logo.svg', expires_at: '2027-09-26T00:00:00Z' }
    if (path.endsWith('/setup') && route.request().method() === 'PATCH') { snapshot.setup.vacation_mode = true; data = snapshot }
    await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data, meta: {}, errors: [] }) })
  })
  await page.goto('/store-profile')
  await expect(page.getByRole('heading', { name: 'Sample Construction Supply', exact: true })).toBeVisible()
  await expect(page.locator('.portal-footer-avatar img')).toHaveAttribute('src', 'https://example.test/logo.svg')
  const nav = page.getByRole('navigation', { name: 'Workspace sections' })
  await expect(nav.getByRole('button', { name: 'Primary Contact', exact: true })).toHaveCount(0)
  await expect(nav.getByRole('button', { name: 'Documents', exact: true })).toHaveCount(0)
  for (const section of ['Store Information', 'Business Information', 'Store Location', 'Vacation Mode', 'Operating Hours', 'Fulfillment Configuration', 'Vehicles Management']) {
    await nav.getByRole('button', { name: section, exact: true }).click()
    await expect(page.getByRole('region', { name: section, exact: true })).toBeVisible()
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
    if (section === 'Business Information') {
      await expect(page.getByText('2027-12-31')).toBeVisible()
      await expect(page.getByRole('button', { name: 'View document' })).toBeVisible()
      await page.screenshot({ path: testInfo.outputPath('business-information.png'), fullPage: true })
    }
    if (section === 'Store Location') await expect(page.getByText('200 Example Street', { exact: true })).toBeVisible()
    if (section === 'Vacation Mode') {
      await page.getByRole('button', { name: 'Turn on Vacation Mode' }).click()
      await expect(page.getByRole('button', { name: 'Turn off Vacation Mode' })).toBeVisible()
    }
    if (section === 'Fulfillment Configuration') {
      await expect(page.getByRole('radio', { name: 'Vendor Delivery' })).toBeChecked()
      await expect(page.getByRole('button', { name: 'Save fulfillment configuration' })).toBeVisible()
      await expect(page.getByRole('link', { name: 'Update fulfillment configuration' })).toHaveCount(0)
    }
    if (section === 'Vehicles Management') {
      await expect(page.getByRole('button', { name: 'Add delivery vehicle' })).toBeVisible()
      await expect(page.getByRole('link', { name: 'Update vehicle configuration' })).toHaveCount(0)
    }
  }
})
