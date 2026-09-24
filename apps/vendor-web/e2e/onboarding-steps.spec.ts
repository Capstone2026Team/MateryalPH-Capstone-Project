import { expect, test, type Page } from '@playwright/test'
import { randomUUID } from 'node:crypto'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

test.beforeEach(async ({ page }) => {
  let commissionAccepted = false
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/verification/commission')) {
      expect(route.request().postDataJSON()).toMatchObject({ organization_lock_version: 1, agreement_version_id: '01990000-0000-7000-8000-000000000001', accepted: true })
      commissionAccepted = true
    }
    if (path.endsWith('/auth/csrf')) data = { csrf_token: randomUUID() }
    if (path.endsWith('/profile')) data = { id: 'preview-account', full_name: 'Vendor Owner', email: 'owner@example.test', account_type: 'VENDOR', account_status: 'ACTIVE', lock_version: 1, created_at: '2026-09-01T00:00:00Z', role: 'OWNER' }
    if (path.endsWith('/onboarding') || path.endsWith('/verification') || path.endsWith('/verification/commission') || path.includes('/documents/pending/')) data = {
      step_completion: [], requirements: [], drafts: [], lock_version: 1,
      organization: { store_name: 'Sample Building Supply', registered_name: 'Sample Building Supply', business_type: 'CORPORATION', store_email: 'store@example.test', store_email_verified: true, lock_version: 1 },
      welcome_required: false, permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit'],
      verification: { status: 'IN_PROGRESS', commission_terms: { can_accept: true, accepted: commissionAccepted, agreement: { id: '01990000-0000-7000-8000-000000000001', version: 1, content: ('Published TEST/DEMO commission terms. Vendor-paid 2% on completed materials after discounts excluding materials VAT. Monthly billing and credits follow the versioned policy.\n\n').repeat(12) } }, privacy_notice: { version: 1, content: 'Published TEST privacy notice.' }, documents: [{ id: 'registration-version', requirement_key: 'business_registration', document_type: 'SEC_REGISTRATION', status: 'APPROVED', version: 1, scan_state: 'CLEAN', original_name: 'registration.pdf', file_id: 'private-cross-vendor' }], address: { city_municipality: 'Sample City', province: 'Sample Province' } },
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
  await expect(page.getByRole('radio', { name: 'One Person Corporation (OPC)' })).toBeVisible()
  await expect(page.getByRole('group', { name: 'Business and Compliance Evidence' })).toBeVisible()
  await assertStepperFits(page, 'Store Verification', 4)
  const evidenceDirectory = resolve('../../docs/design/evidence/phase-3b-business-information')
  mkdirSync(evidenceDirectory, { recursive: true })
  await page.screenshot({ path: resolve(evidenceDirectory, `${testInfo.project.name}-header.png`) })
  const business = page.locator('#verification-draft')
  await expect(business.getByText('Verified', { exact: true })).toBeVisible()
  const email = business.getByRole('textbox', { name: 'Store email', exact: true })
  await expect(email).toHaveValue('store@example.test')
  await expect(email).toHaveAttribute('readonly', '')
  await expect(business.getByLabel('Email to verify')).toHaveCount(0)
  await expect(business.getByRole('button', { name: 'Send Code' })).toHaveCount(0)
  await business.screenshot({ path: testInfo.outputPath('business-information.png') })
  await page.getByRole('textbox', { name: 'Registered Business Name', exact: true }).scrollIntoViewIfNeeded()
  await page.screenshot({ path: resolve(evidenceDirectory, `${testInfo.project.name}-contact.png`) })
  await page.getByRole('region', { name: 'Store contact information' }).scrollIntoViewIfNeeded()
  await page.screenshot({ path: resolve(evidenceDirectory, `${testInfo.project.name}-email.png`) })
  const before = await email.boundingBox()
  if (page.viewportSize()!.width >= 768) {
    const registered = await business.getByRole('textbox', { name: 'Registered Business Name', exact: true }).boundingBox()
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
  await expect(page.getByRole('textbox', { name: 'Detailed Address', exact: true })).toBeVisible()
  await page.screenshot({ path: testInfo.outputPath('verification-address.png'), fullPage: true })
  await page.getByRole('button', { name: 'Back', exact: true }).click()
  await expect(page.getByRole('textbox', { name: 'Company registered name' })).toHaveValue('Retained draft name')
  await expect(page.getByLabel('Taxpayer Identification Number (TIN)', { exact: true })).toBeVisible()
  await assertStepperFits(page, 'Store Verification', 4)
  await page.evaluate(() => window.scrollTo(0, 0))
  await page.screenshot({ path: testInfo.outputPath('verification-tax-header.png') })
  await page.getByRole('button', { name: '4 Privacy, Review and Submit' }).click()
  await expect(page.getByRole('checkbox', { name: /I acknowledge/ })).toBeVisible()
  await expect(page.getByRole('textbox')).toHaveCount(0)
  await expect(page.getByRole('button', { name: 'Submit for Admin Review' })).toBeEnabled()
  await expect(page.getByRole('button', { name: 'Save verification draft' })).toHaveCount(0)
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
  await assertStepperFits(page, 'Store Setup', 5)
  await expect(page.getByLabel('Upload image')).toHaveCount(2)
  const labels = ['Fulfillment Configuration', 'Xendit TEST Connection', 'Team Accounts', 'Review and Complete']
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


test('Business Information email lifecycle, validation, guards and evidence stay recoverable', async ({ page }, testInfo) => {
  let requested = 0
  let confirmed = 0
  let conflict = 'RESOURCE_VERSION_CONFLICT'
  const drafts: Record<string, unknown>[] = []
  await page.route('**/api/v1/vendors/onboarding/store-email', async route => {
    requested++
    await route.fulfill({ status: requested === 1 ? 503 : 200, contentType: 'application/json', body: JSON.stringify(requested === 1 ? { errors: [{ code: 'MAIL_UNAVAILABLE', message: 'Email delivery unavailable. Retry.' }] } : { data: { sent: true, expires_at: '2026-09-22T12:00:00Z' }, meta: {}, errors: [] }) })
  })
  await page.route('**/api/v1/vendors/onboarding/store-email/confirm', async route => {
    confirmed++
    const email = route.request().postDataJSON().email
    await route.fulfill({ status: confirmed === 1 ? 422 : 200, contentType: 'application/json', body: JSON.stringify(confirmed === 1 ? { errors: [{ code: 'OTP_INVALID_OR_EXPIRED', message: 'Invalid or expired code. Try again.' }] } : { data: { step_completion: [], requirements: [], drafts: [{ workstream: 'STORE_VERIFICATION', lock_version: 3 }], lock_version: 9, organization: { business_type: 'CORPORATION', store_email: email, store_email_verified: true, store_name: 'Sample Building Supply', lock_version: 9 }, permissions: ['vendor.onboarding.manage'], verification: { status: 'IN_PROGRESS' }, setup: { status: 'IN_PROGRESS' }, sections: {}, activation: { status: 'NOT_READY' }, welcome_required: false }, meta: {}, errors: [] }) })
  })
  await page.route('**/api/v1/vendors/onboarding/verification', async route => {
    drafts.push(route.request().postDataJSON())
    await route.fulfill({ status: 409, contentType: 'application/json', body: JSON.stringify({ errors: [{ code: conflict, message: 'Stale record' }] }) })
  })
  await page.route('**/api/v1/vendors/onboarding/files/private-cross-vendor', async route => route.fulfill({ status: 403, contentType: 'application/json', body: JSON.stringify({ errors: [{ code: 'FORBIDDEN', message: 'This evidence is unavailable to your account.' }] }) }))
  await page.goto('/onboarding/verification')
  await page.getByRole('button', { name: 'View submitted document' }).click()
  await expect(page.getByText('Preview could not be opened. Try again.')).toBeVisible()
  for (const role of ['EMPLOYEE', 'ACCOUNTANT', 'AUTHORIZED_REPRESENTATIVE', 'OFFICER']) {
    await page.getByLabel('Relationship to the business').selectOption(role)
    await expect(page.getByRole('checkbox', { name: 'Use accepted registration evidence for this officer' })).toHaveCount(role === 'OFFICER' ? 1 : 0)
  }
  await expect(page.locator('input[name="store_email"]')).toHaveCount(1)
  const email = page.getByRole('textbox', { name: 'Store email', exact: true })
  const contacts = page.getByRole('region', { name: 'Store contact information' })
  const original = await email.boundingBox()
  await page.getByRole('button', { name: 'Change', exact: true }).click()
  expect((await email.boundingBox())!.width).toBe(original!.width)
  await email.fill('replacement@example.test')
  await expect(contacts.getByText('Verified', { exact: true })).toHaveCount(0)
  await page.getByRole('button', { name: 'Send Code', exact: true }).click()
  await expect(page.getByText('Email delivery unavailable. Retry.')).toBeVisible()
  await page.getByRole('button', { name: 'Send Code', exact: true }).click()
  await page.getByRole('textbox', { name: 'Six-digit code' }).fill('123456')
  await page.getByRole('button', { name: 'Confirm email', exact: true }).click()
  await expect(page.getByText('Invalid or expired code. Try again.')).toBeVisible()
  await email.fill('changed@example.test')
  await expect(page.getByRole('textbox', { name: 'Six-digit code' })).toHaveCount(0)
  await page.getByRole('button', { name: 'Send Code', exact: true }).click()
  await page.getByRole('textbox', { name: 'Six-digit code' }).fill('123456')
  await page.getByRole('button', { name: 'Confirm email', exact: true }).click()
  await expect(email).toHaveAttribute('readonly', '')
  await expect(contacts.getByText('Verified', { exact: true })).toBeVisible()
  await page.getByRole('button', { name: 'Change', exact: true }).click()
  await email.fill('pending@example.test')
  await expect(contacts.getByText('Verified', { exact: true })).toHaveCount(0)
  for (const label of ['Sole Proprietorship', 'Partnership', 'Corporation', 'One Person Corporation (OPC)', 'Cooperative']) {
    await page.getByRole('radio', { name: label, exact: true }).check()
    await expect(page.getByRole('textbox', { name: 'Company registered name' })).toHaveCount(label === 'Sole Proprietorship' ? 0 : 1)
    await expect(page.getByRole('textbox', { name: 'Surname', exact: true })).toHaveCount(['Sole Proprietorship', 'One Person Corporation (OPC)'].includes(label) ? 1 : 0)
  }
  await page.getByRole('radio', { name: 'Corporation', exact: true }).check()
  await expect(page.getByText('Updating applicable requirements…')).toHaveCount(0)
  await page.getByLabel('Taxpayer Identification Number (TIN)', { exact: true }).fill('123-456-789-000')
  await page.getByRole('button', { name: 'Finish Later' }).click()
  const stale = page.getByText('This draft changed in another session. Reload the latest version before saving again. Your unsaved edits are still on this page.')
  await expect(stale).toBeVisible()
  expect(drafts[0]).toMatchObject({ lock_version: 9, draft_lock_version: 3 })
  expect(JSON.parse(String(drafts[0]!.form_state))).toMatchObject({ tin: ['123-456-789-000'] })
  conflict = 'STALE_VERSION'
  await page.getByRole('button', { name: 'Finish Later' }).click()
  await expect(stale).toBeVisible()
  await expect.poll(() => drafts.length).toBe(2)
  await assertStepperFits(page, 'Store Verification', 4)
  const evidence = resolve('../../docs/design/evidence/phase-3b-business-information')
  mkdirSync(evidence, { recursive: true })
  await page.screenshot({ path: resolve(evidence, `${testInfo.project.name}.png`), fullPage: true })
})


test('tax information uses one combined TIN and reviews COR beside tax identity', async ({ page }) => {
  await page.goto('/onboarding/verification')
  const panel = page.getByRole('group', { name: 'Tax Information', exact: true })
  await expect(page.getByText('Office & Branch Details')).toHaveCount(0)
  await expect(page.getByLabel('Taxpayer Identification Number (TIN)', { exact: true })).toBeVisible()
  await page.getByRole('radio', { name: 'VAT Registered', exact: true }).check()
  await page.getByRole('radio', { name: 'Non-VAT Registered', exact: true }).check()
  await expect(panel.getByText(/Verified VAT status:/)).toHaveCount(0)
  await expect(panel.getByText('Withholding information · FIN-04A')).toHaveCount(0)
  await expect(page.getByText(/Verified VAT status:/)).toBeVisible()
  const cor = panel.locator('input[type=file]')
  await cor.setInputFiles({ name: 'registration.pdf', mimeType: 'application/pdf', buffer: Buffer.from('%PDF-1.4 test attachment') })
  await expect(panel.getByRole('button', { name: 'Preview document', exact: true })).toBeVisible()
  await expect(panel.getByRole('button', { name: 'Upload reviewed file' })).toHaveCount(0)
  await panel.getByRole('button', { name: 'Remove' }).click()
  await expect(panel.getByRole('button', { name: 'Preview document', exact: true })).toHaveCount(0)
})


test('supplier custom categories can be added and removed without duplicate subtitles', async ({ page }, testInfo) => {
  await page.goto('/onboarding/verification')
  await page.getByRole('button', { name: '3 Supplier Type / Classification' }).click()
  await expect(page.getByRole('heading', { name: 'Supplier Type / Classification', exact: true })).toBeVisible()
  await expect(page.getByText('Supplier classification', { exact: true })).toHaveCount(0)
  await page.getByRole('checkbox', { name: /^Other Category/ }).check()
  const input = page.getByRole('textbox', { name: 'Other category', exact: true })
  await input.fill('Acoustic panels')
  await page.getByRole('button', { name: 'Add category', exact: true }).click()
  await input.fill('Reclaimed bricks')
  await input.press('Enter')
  await expect(page.getByRole('list', { name: 'Added custom categories' }).getByRole('listitem')).toHaveCount(2)
  await page.getByRole('button', { name: 'Remove Acoustic panels' }).click()
  await page.getByRole('button', { name: 'Back', exact: true }).click()
  await page.getByRole('button', { name: 'Next', exact: true }).click()
  await expect(page.getByRole('button', { name: 'Remove Reclaimed bricks' })).toBeVisible()
  let classification: unknown
  await page.route('**/vendors/onboarding/verification', async route => {
    classification = JSON.parse(route.request().postDataJSON().form_state)
    await route.fulfill({ status: 409, contentType: 'application/json', body: JSON.stringify({ errors: [{ code: 'STALE_VERSION', message: 'Reload before saving.' }] }) })
  })
  await page.getByRole('radio', { name: 'Specialized Supplier' }).check()
  await page.getByRole('button', { name: 'Finish Later' }).click()
  await expect.poll(() => classification).toMatchObject({ supplier_type: ['SPECIALIZED_SUPPLIER'], niches: ['Other Category'], custom_labels: ['Reclaimed bricks'] })
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('supplier-classification.png'), fullPage: true })
})


test('pending evidence stays in its card without resizing tax columns and can be replaced or removed', async ({ page }, testInfo) => {
  await page.goto('/onboarding/verification')
  await page.getByRole('radio', { name: 'Sole Proprietorship', exact: true }).check()
  await expect(page.getByRole('textbox', { name: 'Registered Business Name', exact: true })).toHaveCount(0)
  await page.getByRole('combobox', { name: 'Government ID type', exact: true }).selectOption('DRIVERS_LICENSE')
  const input = page.getByLabel('Select Government ID — front', { exact: true })
  const longName = 'business-identification-'.repeat(9) + '.png'
  const png = Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAYAAAAfFcSJAAAADUlEQVQIHWP4z8DwHwAFgAI/ScLbtAAAAABJRU5ErkJggg==', 'base64')
  await input.setInputFiles({ name: longName, mimeType: 'image/png', buffer: png })
  await expect(page.getByAltText('Government ID — front selected preview')).toBeVisible()
  await expect(page.getByText(longName, { exact: false })).toBeVisible()
  await expect(page.getByRole('button', { name: 'Upload reviewed file' })).toHaveCount(0)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await input.setInputFiles({ name: 'replacement.pdf', mimeType: 'application/pdf', buffer: Buffer.from('%PDF-1.4 test preview') })
  await expect(page.getByText('replacement.pdf', { exact: false })).toBeVisible()
  await expect(page.getByAltText('Government ID — front selected preview')).toHaveCount(0)
  await page.getByRole('button', { name: 'Remove', exact: true }).click()
  await expect(page.getByText('replacement.pdf', { exact: false })).toHaveCount(0)
  const tin = page.getByLabel('Taxpayer Identification Number (TIN)', { exact: true })
  const bir = page.getByRole('heading', { name: 'BIR Certificate of Registration (BIR Form 2303)', exact: true })
  const references = page.getByText('Verification & References', { exact: true })
  const initial = await references.evaluate(el => ({ x: el.getBoundingClientRect().x, y: el.getBoundingClientRect().y + window.scrollY }))
  await page.getByLabel('Select BIR Certificate of Registration (BIR Form 2303)', { exact: true }).setInputFiles({ name: longName, mimeType: 'image/png', buffer: png })
  const after = await references.evaluate(el => ({ x: el.getBoundingClientRect().x, y: el.getBoundingClientRect().y + window.scrollY }))
  expect(after!.x).toBe(initial!.x)
  if (page.viewportSize()!.width >= 1024) expect(after!.y).toBe(initial!.y)
  expect((await tin.boundingBox())!.y).toBeLessThan((await bir.boundingBox())!.y)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await bir.scrollIntoViewIfNeeded()
  await page.screenshot({ path: testInfo.outputPath('pending-evidence-tax-layout.png') })
})


test('commission panel is above Privacy with explicit scroll-gated acceptance and absent from setup', async ({ page }, testInfo) => {
  await page.goto('/onboarding/verification')
  await page.getByRole('button', { name: '4 Privacy, Review and Submit' }).click()
  const commission = page.getByRole('region', { name: '2% Commission Terms', exact: true })
  await expect(commission).toBeVisible()
  const privacy = page.getByRole('heading', { name: 'Privacy Notice', exact: true })
  expect((await commission.boundingBox())!.y).toBeLessThan((await privacy.boundingBox())!.y)
  const checkbox = commission.getByRole('checkbox')
  await expect(checkbox).not.toBeChecked()
  await expect(checkbox).toBeDisabled()
  await commission.getByText('Read the full commission terms').click()
  const reader = commission.getByRole('region', { name: 'Current commission agreement' })
  await reader.evaluate(element => { element.scrollTop = element.scrollHeight; element.dispatchEvent(new Event('scroll', { bubbles: true })) })
  await expect(checkbox).toBeEnabled()
  await checkbox.check()
  await commission.getByRole('button', { name: 'Accept commission terms' }).click()
  await expect(commission.getByRole('status')).toHaveText('Current commission terms accepted for this organization.')
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('commission-panel.png'), fullPage: true })
  await page.goto('/onboarding/setup')
  await expect(page.getByRole('navigation', { name: 'Store Setup steps' }).getByRole('button')).toHaveCount(5)
  await expect(page.getByRole('heading', { name: '2% Commission Terms', exact: true })).toHaveCount(0)
})
