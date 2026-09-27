import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

const requirements = [
  ['business_information', 'Business details'], ['legal_identity', 'Registered legal identity'],
  ['registered_business_address', 'Registered business address'], ['supplier_classification', 'Supplier classification'],
  ['tax_profile', 'Tax Profile'], ['authority_to_act', 'Authority to Act'],
  ['identity_evidence', 'Government ID front'], ['identity_back_evidence', 'Government ID back'],
  ['representative_identity', 'Representative ID front'], ['representative_identity_back', 'Representative ID back'],
  ['tax_relief_evidence', 'Sworn Declaration'], ['bir_cor', 'BIR COR'],
  ['business_registration', 'Registration'], ['lgu_permit', 'LGU permit evidence'],
].map(([key, label], index) => ({ id: String(index), key, label, level: 'REQUIRED', status: 'PENDING_VERIFICATION', lock_version: 1 }))
const documents = ['identity_evidence', 'identity_back_evidence'].map((key, index) => ({ id: key, requirement_key: key, file_id: `synthetic-${index}`, version: 1, scan_state: 'CLEAN', status: 'PENDING_VERIFICATION', original_name: 'synthetic-id.png' }))
const setupSteps = [{ id: 'setup', key: 'public_store_profile', label: 'Public store profile', level: 'REQUIRED', status: 'IN_PROGRESS', lock_version: 1 }]
const organization = { store_name: 'Synthetic Supply', registered_name: 'Juan Dela Cruz Trading', business_type: 'SOLE_PROPRIETORSHIP', store_email: 'store@example.test', store_phone: '+639171234567', lock_version: 1 }
const vendor = {
  step_completion: [], requirements: [], drafts: [], lock_version: 1, organization, permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit'], welcome_required: false,
  verification: { status: 'IN_PROGRESS', legal_identity: { id_type: 'NATIONAL_ID' }, documents, privacy_notice: { version: 1, content: 'Synthetic test notice.' } },
  setup: { status: 'IN_PROGRESS' }, activation: { status: 'NOT_READY', readiness: { ready: false, blockers: [] } },
  sections: {
    STORE_VERIFICATION: { key: 'STORE_VERIFICATION', label: 'Store Verification', status: 'PENDING_VERIFICATION', complete: 0, total: requirements.length, steps: requirements },
    STORE_SETUP: { key: 'STORE_SETUP', label: 'Store Setup', status: 'IN_PROGRESS', complete: 0, total: 1, steps: setupSteps },
  },
}
async function api(page: Page, admin = false, authorityReviews: Record<string, unknown>[] = []) {
  const decisions: string[] = []
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.includes('/vendor-onboarding-files/')) {
      expect(new URL(route.request().headers().origin ?? route.request().headers().referer!).origin).toBe(new URL(page.url()).origin)
      await route.fulfill({ contentType: 'image/png', body: Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=', 'base64') })
      return
    }
    if (path.includes('/files/')) data = { url: new URL('/api/v1/vendor-onboarding-files/synthetic/content?expires=123&signature=synthetic', route.request().url()).href, expires_at: '2030-01-01T00:00:00Z' }
    else if (path.endsWith('/csrf')) data = { csrf_token: 'synthetic-security-token' }
    else if (path.endsWith('/profile')) data = { id: 'synthetic-user', full_name: 'Test Reviewer', account_type: admin ? 'ADMIN' : 'VENDOR', account_status: 'ACTIVE', role: admin ? 'ADMIN' : 'OWNER' }
    else if (path.endsWith('/onboarding') || path.endsWith('/verification')) data = vendor
    else if (path.endsWith('/requirements')) data = { requirements: [] }
    else if (path.includes('/admin/vendor-verification/')) {
      if (path.endsWith('/decision')) decisions.push(path.split('/').at(-2)!)
      data = { organization, legal_identity: { first_name: 'Juan', surname: 'Dela Cruz', id_type: 'DRIVERS_LICENSE', id_number_last4: '1234' }, address: { formatted_address: 'Barangay San Antonio, Quezon City, Metro Manila' }, classification: { supplier_type: 'RETAIL_HARDWARE_STORE', niches: ['Cement and Concrete'] }, tax_profile: { entity_class: 'INDIVIDUAL', vat_category: 'NON_VAT', tin_last4: '6789', owner_attested: true }, sections: { STORE_VERIFICATION: requirements }, documents, reviews: [{ id: 'prior-review', requirement_key: 'bir_cor', version: 1, decision: 'APPROVED', reviewed_at: '2026-09-24T00:00:00Z' }], authority_reviews: authorityReviews, readiness: { ready: false, blockers: [] } }
    }
    await route.fulfill({ json: { data, meta: {}, errors: [] } })
  })
  return decisions
}
async function capture(page: Page, name: string) {
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const directory = resolve('../../docs/design/evidence/checklist-panels')
  mkdirSync(directory, { recursive: true })
  await page.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${name}.png`), fullPage: true })
}

test('verification and dashboard share seven grouped rows, setup uses the same panel', async ({ page }) => {
  await api(page)
  await page.goto('/onboarding/verification')
  await page.getByRole('button', { name: 'View submitted document' }).first().click()
  await expect(page.getByRole('dialog', { name: 'Submitted document preview' })).toBeVisible()
  await page.getByRole('button', { name: 'Close preview' }).click()
  await page.getByRole('button', { name: '4 Privacy, Review and Submit' }).click()
  const checklist = page.getByRole('region', { name: 'Verification checklist', exact: true })
  await expect(checklist.getByRole('listitem')).toHaveCount(7)
  await expect(checklist.getByText('Government ID — Registered legal identity', { exact: true })).toHaveCount(1)
  await expect(checklist.getByText('Front and back of the same ID')).toHaveCount(2)
  await expect(checklist.getByRole('button', { name: 'Review Authority to Act' })).toBeVisible()
  await capture(page, 'verification')
  await page.goto('/dashboard')
  await expect(page.getByRole('region', { name: 'Store Verification', exact: true }).getByRole('listitem')).toHaveCount(7)
  await capture(page, 'dashboard')
  await page.goto('/onboarding/setup')
  await page.getByRole('button', { name: '6 Review and Complete' }).click()
  await expect(page.getByRole('region', { name: 'Setup checklist' }).getByText('Public store profile')).toBeVisible()
  await capture(page, 'setup')
})

test('Admin reviews business information once and each ID with both sides in context', async ({ page }) => {
  const decisions = await api(page, true)
  await page.goto('http://127.0.0.1:4174/vendor-verification/synthetic-organization')
  const checklist = page.getByRole('region', { name: 'Verification requirements' })
  await expect(checklist.getByRole('listitem')).toHaveCount(8)
  await expect(page.getByRole('table', { name: 'Immutable Vendor verification decisions by requirement and evidence version' })).toBeVisible()
  await expect(page.getByRole('heading', { name: 'Authority decision history' })).toHaveCount(0)
  if (page.viewportSize()!.width >= 1024) {
    expect(await page.evaluate(() => document.documentElement.scrollHeight)).toBeLessThanOrEqual(page.viewportSize()!.height + 1)
    const workspace = page.locator('.portal-workspace')
    expect(await workspace.evaluate(el => el.scrollHeight)).toBeGreaterThan(page.viewportSize()!.height)
    await workspace.evaluate(el => { el.scrollTop = el.scrollHeight })
    await expect(page.getByRole('table', { name: 'Immutable Vendor verification decisions by requirement and evidence version' })).toBeInViewport()
    expect(await page.evaluate(() => document.documentElement.scrollTop)).toBe(0)
    await workspace.evaluate(el => { el.scrollTop = 0 })
  }
  await expect(checklist.getByText('business_information', { exact: true })).toHaveCount(0)
  await expect(checklist.getByRole('button', { name: 'Review Authority to Act' })).toBeVisible()
  await checklist.getByRole('button', { name: 'Review Business information' }).click()
  await expect(page.getByText('Business and legal details')).toBeVisible()
  await expect(page.locator('section[aria-labelledby="review-information-title"]').getByText('Juan Dela Cruz Trading').first()).toBeVisible()
  await expect(page.getByText('Supplier classification', { exact: true }).last()).toBeVisible()
  const information = page.locator('section[aria-labelledby="review-information-title"]')
  const decision = page.getByRole('region', { name: 'Record decision', exact: true })
  const restriction = page.getByRole('region', { name: 'Activation restriction', exact: true })
  const requirementsBox = (await checklist.boundingBox())!
  const informationBox = (await information.boundingBox())!
  const decisionBox = (await decision.boundingBox())!
  const restrictionBox = (await restriction.boundingBox())!
  expect(requirementsBox.y + requirementsBox.height).toBeLessThanOrEqual(informationBox.y)
  if (page.viewportSize()!.width >= 1280) {
    expect(informationBox.x + informationBox.width).toBeLessThan(decisionBox.x)
    expect(Math.abs(informationBox.y - decisionBox.y)).toBeLessThan(2)
    expect(restrictionBox.x).toBe(decisionBox.x)
    expect(restrictionBox.y).toBeGreaterThan(decisionBox.y + decisionBox.height)
  }
  await capture(page, 'admin-business')
  await checklist.getByRole('button', { name: 'Review Government ID — Registered legal identity' }).click()
  await expect(page.getByText('Juan Dela Cruz', { exact: true })).toBeVisible()
  await expect(page.getByRole('img', { name: 'Government ID — Front / identity page' })).toBeVisible()
  await expect(page.getByRole('img', { name: 'Government ID — Back' })).toBeVisible()
  await page.getByRole('button', { name: 'Enlarge Government ID — Front / identity page' }).last().click()
  await expect(page.getByRole('dialog', { name: 'Government ID — Front / identity page full preview' })).toBeVisible()
  await page.getByRole('button', { name: 'Close preview' }).click()
  await capture(page, 'admin')
  await page.getByLabel('Expiration').selectOption('NO_EXPIRATION')
  await page.getByRole('button', { name: 'Record requirement decision' }).click()
  await expect.poll(() => decisions).toEqual(['legal_identity_id'])
})

test('Admin shows authority decision history when a decision exists', async ({ page }) => {
  await api(page, true, [{ id: 'authority-review', version: 2, decision: 'APPROVED', scope: 'TAX_DECLARATIONS', reviewed_at: '2026-09-24T00:00:00Z' }])
  await page.goto('http://127.0.0.1:4174/vendor-verification/synthetic-organization')
  await expect(page.getByRole('heading', { name: 'Authority decision history' })).toBeVisible()
  await expect(page.getByText('Representative version 2')).toBeVisible()
})
