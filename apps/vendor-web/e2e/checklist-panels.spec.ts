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
const organization = { store_name: 'Synthetic Supply', business_type: 'SOLE_PROPRIETORSHIP', store_email: 'store@example.test', lock_version: 1 }
const vendor = {
  step_completion: [], requirements: [], drafts: [], lock_version: 1, organization, permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit'], welcome_required: false,
  verification: { status: 'IN_PROGRESS', legal_identity: { id_type: 'NATIONAL_ID' }, documents, privacy_notice: { version: 1, content: 'Synthetic test notice.' } },
  setup: { status: 'IN_PROGRESS' }, activation: { status: 'NOT_READY', readiness: { ready: false, blockers: [] } },
  sections: {
    STORE_VERIFICATION: { key: 'STORE_VERIFICATION', label: 'Store Verification', status: 'PENDING_VERIFICATION', complete: 0, total: requirements.length, steps: requirements },
    STORE_SETUP: { key: 'STORE_SETUP', label: 'Store Setup', status: 'IN_PROGRESS', complete: 0, total: 1, steps: setupSteps },
  },
}
async function api(page: Page, admin = false) {
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
      data = { organization, sections: { STORE_VERIFICATION: requirements }, documents, reviews: [], readiness: { ready: false, blockers: [] } }
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

test('Admin groups each ID and preserves side-specific review decisions', async ({ page }) => {
  const decisions = await api(page, true)
  await page.goto('http://127.0.0.1:4174/vendor-verification/synthetic-organization')
  const checklist = page.getByRole('region', { name: 'Verification requirements' })
  await expect(checklist.getByRole('listitem')).toHaveCount(7)
  await checklist.getByRole('button', { name: 'Review Government ID — Registered legal identity' }).click()
  await checklist.getByRole('button', { name: /^Back / }).click()
  await expect(page.getByText('Reviewing Government ID back.', { exact: false })).toBeVisible()
  await page.getByRole('button', { name: 'Open private evidence' }).click()
  await expect(page.getByRole('dialog', { name: 'Submitted document preview' })).toBeVisible()
  await page.getByRole('button', { name: 'Close preview' }).click()
  await capture(page, 'admin')
  await page.getByRole('button', { name: 'Record requirement decision' }).click()
  await expect.poll(() => decisions).toEqual(['identity_back_evidence'])
})
