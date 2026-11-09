import { expect, test } from '@playwright/test'

test('Store Profile reflows and keeps business evidence and location accessible', async ({ page }, testInfo) => {
  let deletionEligible = false
  let deletionCalls = 0
  let deleted = false
  const snapshot = {
    lock_version: 1, requirements: [], drafts: [], step_completion: [], welcome_required: false,
    organization: { store_name: 'Sample Construction Supply', business_type: 'CORPORATION', lock_version: 1 },
    permissions: ['vendor.onboarding.submit', 'vendor.onboarding.manage', 'vendor.onboarding.private_documents', 'portal.vehicles', 'vehicles.manage', 'organization.delete'],
    activation: { status: 'ACTIVE' },
    verification: { status: 'APPROVED', address: { street: '200 Example Street', barangay: 'Sample Barangay', city_municipality: 'Quezon City', province: 'Metro Manila', postal_code: '1100', latitude: 14.65, longitude: 121.05 }, documents: [{ requirement_key: 'lgu_permit', original_name: 'sample-permit.pdf', file_id: 'fixture-file', version: 1, review: { expiration_kind: 'DATE', verified_expiration_date: '2027-12-31', remarks: 'Verified sample evidence' } }] },
    setup: { status: 'COMPLETED', vacation_mode: false, vacation_status: 'OFF', vacation_starts_on: null as string | null, vacation_ends_on: null as string | null, operating_schedule: Array.from({ length: 7 }, (_, index) => ({ day_of_week: index + 1, status: index === 6 ? 'CLOSED' : 'OPEN', opens_at: index === 6 ? null : '09:00', closes_at: index === 6 ? null : '22:00' })), media: [{ id: 'logo-media', kind: 'LOGO', file_id: 'logo-file', status: 'READY' }], profile: { public_store_name: 'Sample Construction Supply', description: 'Materials for your next project.', public_email: 'store@example.test', public_phone: '09170000000', bulk_capability: true, fulfillment_method: 'VENDOR_DELIVERY' } },
    sections: { STORE_VERIFICATION: { key: 'STORE_VERIFICATION', label: 'Verification', status: 'APPROVED', steps: [{ id: 'permit', key: 'lgu_permit', label: 'LGU permit', status: 'APPROVED', level: 'REQUIRED', lock_version: 1 }] } },
  }
  await page.route('https://example.test/logo.svg', route => route.fulfill({ status: 200, contentType: 'image/svg+xml', body: '<svg xmlns="http://www.w3.org/2000/svg" width="64" height="64"><rect width="64" height="64" fill="#c2410c"/><text x="10" y="40" fill="white">SC</text></svg>' }))
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    if (deleted && (path.endsWith('/auth/session') || path.endsWith('/auth/refresh') || path.endsWith('/account/profile'))) {
      await route.fulfill({ status: 401, contentType: 'application/json', body: JSON.stringify({ data: null, meta: {}, errors: [{ code: 'UNAUTHENTICATED', message: 'Sign in to continue.' }] }) })
      return
    }
    let data: unknown = snapshot
    if (path.endsWith('/csrf')) data = { csrf_token: 'store-profile-fixture' }
    if (path.endsWith('/profile')) data = { id: 'fixture', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', permissions: snapshot.permissions }
    if (path.endsWith('/account/security')) data = { totp_enrolled: true }
    if (path.endsWith('/account/reauthentication')) data = { changed: true }
    if (path.endsWith('/account/deletion')) {
      if (route.request().method() === 'POST') {
        deletionCalls++
        deleted = true
        expect(route.request().headers()['idempotency-key']).toMatch(/^[0-9a-f-]{36}$/)
        expect(route.request().postDataJSON()).toEqual({ confirmation: 'DELETE' })
        data = { reference: 'AD-2026-FIXTURE', deleted_at: '2026-11-07T00:00:00Z', sign_in_required: true }
      } else data = { can_delete: deletionEligible, confirmation_phrase: 'DELETE',
        retained_records: [
          { category: 'Orders, quotations and invoices', purpose: 'Accounting, contractual obligations and legal claims' },
          { category: 'Payments, refunds, commission and tax records', purpose: 'Financial reconciliation and tax requirements' },
          { category: 'Business verification, disputes, reviews and reports', purpose: 'Compliance, marketplace safety and legal claims' },
          { category: 'Security, team activity and audit records', purpose: 'Security investigation and historical attribution' },
          { category: 'Agreement acceptances', purpose: 'Evidence of accepted agreements and privacy notices' },
        ],
        blockers: { active_orders: deletionEligible ? 0 : 2, pending_payments: 0, unresolved_disputes: 0, pending_refunds: 0, uncollected_payments: 0, outstanding_statements: deletionEligible ? 0 : 1, unbilled_commissions: 0, finance_reviews: 0 } }
    }
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
  if (page.viewportSize()!.width < 1024) await page.getByRole('button', { name: 'Close navigation', exact: true }).click()
  await nav.getByRole('tab', { name: 'Account Deletion', exact: true }).click()
  await expect(page.getByRole('link', { name: 'Review active orders' })).toBeVisible()
  await expect(page.getByRole('link', { name: 'Review unpaid commission statements' })).toBeVisible()
  await expect(page.getByRole('button', { name: 'Delete account', exact: true })).toBeDisabled()
  await expect(page.getByRole('region', { name: 'Before you leave' })).toContainText('This cannot be undone.')
  await expect(page.getByRole('region', { name: 'What happens to your data' }).locator('dt')).toHaveCount(5)
  for (const control of [page.getByRole('button', { name: 'Check again' }), page.getByRole('link', { name: 'Review unpaid commission statements' }), page.getByRole('button', { name: 'Delete account', exact: true })]) {
    const bounds = await control.boundingBox()
    expect(bounds!.height).toBeGreaterThanOrEqual(44)
    expect(bounds!.x + bounds!.width).toBeLessThanOrEqual(page.viewportSize()!.width)
  }
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('account-deletion-blocked.png'), fullPage: true })
  await page.getByRole('button', { name: 'Delete account', exact: true }).scrollIntoViewIfNeeded()
  await page.screenshot({ path: testInfo.outputPath('account-deletion-data.png'), fullPage: true })
  deletionEligible = true
  await page.getByRole('button', { name: 'Check again' }).click()
  await expect(page.getByRole('button', { name: 'Delete account', exact: true })).toBeEnabled()
  await page.getByRole('button', { name: 'Delete account', exact: true }).click()
  const confirmation = page.getByRole('dialog', { name: 'Delete account permanently?' })
  await expect(confirmation.getByRole('button', { name: 'Delete account permanently', exact: true })).toBeDisabled()
  await confirmation.getByLabel('Type DELETE to confirm').fill('DELETE')
  await page.screenshot({ path: testInfo.outputPath('account-deletion-confirmation.png') })
  await confirmation.getByRole('button', { name: 'Delete account permanently', exact: true }).click()
  const verification = page.getByRole('dialog', { name: 'Verify account deletion' })
  await verification.getByLabel('Authenticator code').fill('123456')
  await verification.getByRole('button', { name: 'Verify and continue' }).click()
  await expect(page).toHaveURL(/\/login\?deleted=success$/)
  await expect(page.getByText('Your Vendor account has been deleted. Your store is closed and all team sessions have been signed out.')).toBeVisible()
  expect(deletionCalls).toBe(1)
})
