import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'
import { randomUUID } from 'node:crypto'

const address = { street: '12 Test Street', unit: '', barangay: 'Alicia', city_municipality: 'Quezon City', province: 'National Capital Region (NCR)', postal_code: '1100', province_code: '1300000000', city_code: '1381300000', psgc_code: '1381300001', source: 'MANUAL' }
const requirements = [
  { key: 'business_information', label: 'Business information', level: 'REQUIRED', status: 'IN_PROGRESS' },
  { key: 'authority_to_act', label: 'Authority to Act', level: 'CONDITIONALLY_REQUIRED', status: 'NOT_APPLICABLE', reason: 'Proprietor represents the business.' },
  { key: 'registered_business_address', label: 'Registered business address', level: 'REQUIRED', status: 'IN_PROGRESS' },
  { key: 'supplier_classification', label: 'Supplier classification', level: 'REQUIRED', status: 'IN_PROGRESS' },
  { key: 'privacy_acknowledgement', label: 'Privacy acknowledgment', level: 'REQUIRED', status: 'NOT_STARTED' },
].map((item, index) => ({ ...item, id: String(index), lock_version: 1 }))

async function fixture(page: Page, reject = false) {
  let submitted = false
  let formState: Record<string, string[]> = {}
  const mutations: { path: string; body: Record<string, unknown> }[] = []
  const snapshot = () => ({
    step_completion: [], requirements, drafts: [], lock_version: 1,
    organization: { store_name: 'Sample Supply', business_type: 'SOLE_PROPRIETORSHIP', date_established: '2020-01-01', store_email: 'store@example.test', store_email_verified: true, store_phone: '+639171234567', lock_version: 1 },
    permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit'], welcome_required: false,
    verification: { status: submitted ? 'PENDING_VERIFICATION' : 'IN_PROGRESS', form_state: formState, legal_identity: { surname: 'Owner', first_name: 'Test', id_type: 'PASSPORT' }, address, classification: { supplier_type: 'RETAIL_HARDWARE_STORE', niches: ['Construction Materials'], custom_labels: [] }, privacy_notice: { version: 2, content: 'Test Privacy Notice. Business information is used for Store Verification. Contact support to exercise your privacy rights.' }, pending_documents: [{ requirement_key: 'business_registration', file_id: 'pending-example', original_name: 'registration.pdf', byte_size: 100 }] },
    setup: { status: 'NOT_STARTED' }, activation: { status: 'NOT_READY' }, sections: {
      STORE_VERIFICATION: { key: 'STORE_VERIFICATION', label: 'Store Verification', status: 'IN_PROGRESS', complete: 0, total: 4, progress: { complete: 0, total: 4 }, steps: requirements },
      STORE_SETUP: { key: 'STORE_SETUP', label: 'Store Setup', status: 'NOT_STARTED', complete: 0, total: 6, progress: { complete: 0, total: 6 }, steps: [] },
    },
  })
  await page.route('**/maps.googleapis.com/**', route => route.abort())
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    const body = route.request().postDataJSON() as Record<string, unknown> | null
    let data: unknown = {}
    if (path.endsWith('/csrf')) data = { csrf_token: randomUUID() }
    if (path.endsWith('/profile')) data = { id: 'fixture-owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', full_name: 'Test Owner', email: 'owner@example.test', lock_version: 1 }
    if (body) mutations.push({ path, body })
    if (path.endsWith('/verification') && body?.form_state) formState = JSON.parse(String(body.form_state))
    if (path.endsWith('/verification/submit')) {
      if (reject) {
        await route.fulfill({ status: 422, json: { data: null, meta: {}, errors: [{ code: 'CLASSIFICATION_UNSUPPORTED', message: 'Unsupported rental label.', details: { blockers: [{ key: 'classification.custom_labels', reason: '“Equipment Rental”: Vehicle and equipment rental services are not currently supported by MateryalPH.' }] } }] } })
        return
      }
      submitted = true
    }
    if (path.endsWith('/onboarding') || path.endsWith('/verification') || path.endsWith('/verification/submit')) data = snapshot()
    if (path.endsWith('/requirements')) data = { requirements: [] }
    if (path.endsWith('/address/resolve')) { await route.fulfill({ status: 503, json: { data: null, meta: {}, errors: [{ code: 'PROVIDER_UNAVAILABLE', message: 'Address lookup unavailable. Use manual entry.' }] } }); return }
    if (path.endsWith('/address/areas')) data = { items: [], page: 1, has_more: false, version_id: 'fixture' }
    await route.fulfill({ status: submitted && path.endsWith('/submit') ? 202 : 200, json: { data, meta: {}, errors: [] } })
  })
  return mutations
}

async function fits(page: Page) {
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const steps = page.getByRole('navigation', { name: 'Store Verification steps' })
  expect(await steps.evaluate(element => element.scrollWidth <= element.clientWidth && [...element.querySelectorAll('ol, li, button')].every(item => item.scrollWidth <= item.clientWidth + 1))).toBe(true)
}

async function capture(page: Page, name: string) {
  const directory = resolve('../../docs/design/evidence/phase-3c')
  mkdirSync(directory, { recursive: true })
  await page.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${name}.png`), fullPage: true })
}

test('Phase 3C manual address, classification, grouped review and confirmation', async ({ page }) => {
  const mutations = await fixture(page)
  await page.goto('/onboarding/verification')
  await expect(page.getByRole('heading', { name: 'Business Information', exact: true })).toBeVisible()
  await page.getByRole('button', { name: '2 Registered Business Address' }).click()
  await expect(page.getByRole('radio', { name: 'Manual Address Entry' })).toBeChecked()
  await page.getByRole('textbox', { name: 'Detailed Address' }).fill('34 Manually Entered Street')
  await expect(page.getByRole('textbox', { name: 'Latitude' })).toHaveCount(0)
  await expect(page.getByRole('textbox', { name: 'Longitude' })).toHaveCount(0)
  const fields = await page.getByRole('combobox', { name: 'Province / Region' }).boundingBox()
  const map = await page.getByText('Map', { exact: true }).boundingBox()
  expect(map!.y).toBeGreaterThan(fields!.y)
  await fits(page)
  await capture(page, 'address')
  await page.getByRole('button', { name: 'Next', exact: true }).click()
  await expect(page.getByRole('group', { name: 'Supplier type', exact: true }).getByRole('radio')).toHaveCount(3)
  await page.getByRole('radio', { name: 'Specialized Supplier' }).check()
  await expect(page.getByRole('group', { name: 'Supplier Niches' }).getByRole('checkbox')).toHaveCount(27)
  await page.getByRole('checkbox', { name: /^Tools and Equipment/ }).check()
  await page.getByRole('checkbox', { name: /^Other Category/ }).check()
  for (const label of ['Acoustic panels', 'Reclaimed bricks']) {
    await page.getByRole('textbox', { name: 'Other category' }).fill(label)
    await page.getByRole('button', { name: 'Add category' }).click()
  }
  await fits(page)
  await capture(page, 'classification')
  await page.getByRole('button', { name: 'Next', exact: true }).click()
  const checklist = page.getByRole('region', { name: 'Verification checklist', exact: true })
  await expect(checklist.getByRole('listitem')).toHaveCount(1)
  await expect(checklist.getByText('Proprietor represents the business.')).toHaveCount(0)
  await expect(page.getByText('No unsaved edits.')).toBeVisible()
  await expect(page.getByText('Saved progress awaiting submission')).toBeVisible()
  await expect(page.getByText('34 Manually Entered Street', { exact: false })).toBeVisible()
  await checklist.getByRole('button', { name: 'Review Supplier classification' }).click()
  await expect(page.getByRole('radio', { name: 'Specialized Supplier' })).toBeChecked()
  await expect(page.getByRole('list', { name: 'Added custom categories' }).getByRole('listitem')).toHaveCount(2)
  await page.getByRole('button', { name: 'Next', exact: true }).click()
  await page.getByRole('button', { name: 'Submit for Admin Review' }).click()
  await expect(page.getByText('Acknowledge the Privacy Notice.', { exact: true })).toBeVisible()
  expect(mutations.filter(item => item.path.endsWith('/submit'))).toHaveLength(0)
  await page.getByRole('checkbox', { name: /I acknowledge/ }).check()
  await fits(page)
  await capture(page, 'review')
  await page.getByRole('button', { name: 'Submit for Admin Review' }).click()
  await expect(page.getByRole('heading', { name: 'Business information and documentation successfully submitted.' })).toBeVisible()
  const submission = mutations.find(item => item.path.endsWith('/submit'))!.body
  expect(submission).toMatchObject({ privacy_acknowledged: true, draft: { address: { source: 'MANUAL', street: '34 Manually Entered Street' }, classification: { supplier_type: 'SPECIALIZED_SUPPLIER', niches: ['Construction Materials', 'Tools and Equipment', 'Other Category'], custom_labels: ['Acoustic panels', 'Reclaimed bricks'] } } })
  expect(mutations.filter(item => item.path.includes('/address/'))).toHaveLength(0)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await capture(page, 'confirmation')
  await page.getByRole('link', { name: 'Proceed to Store Setup' }).click()
  await expect(page).toHaveURL(/onboarding\/setup/)
  await expect(page.getByRole('heading', { name: 'Public Store Profile', exact: true })).toBeVisible()
})

test('Phase 3C failed geocoding permits manual fallback and classification errors remain inline', async ({ page }) => {
  await fixture(page, true)
  await page.goto('/onboarding/verification')
  await page.getByRole('button', { name: '2 Registered Business Address' }).click()
  await page.getByRole('radio', { name: 'Interactive Map Selection' }).check()
  await expect(page.getByText('Address lookup unavailable. Use manual entry.')).toBeVisible()
  await page.getByRole('button', { name: 'Continue with manual address' }).click()
  await expect(page.getByRole('radio', { name: 'Manual Address Entry' })).toBeChecked()
  await page.getByRole('button', { name: 'Next', exact: true }).click()
  await page.getByRole('checkbox', { name: /^Other Category/ }).check()
  await page.getByRole('textbox', { name: 'Other category' }).fill('Equipment Rental')
  await page.getByRole('button', { name: 'Add category' }).click()
  await page.getByRole('button', { name: 'Next', exact: true }).click()
  await page.getByRole('checkbox', { name: /I acknowledge/ }).check()
  await page.getByRole('button', { name: 'Submit for Admin Review' }).click()
  await expect(page.getByRole('heading', { name: 'Supplier Type / Classification', exact: true })).toBeVisible()
  await expect(page.getByText('“Equipment Rental”: Vehicle and equipment rental services are not currently supported by MateryalPH.')).toBeVisible()
  await expect(page.getByRole('list', { name: 'Added custom categories' })).toContainText('Equipment Rental')
  await fits(page)
})


test('Phase 3C pin coordinates, incomplete geocode and stale response protection', async ({ page }) => {
  await page.addInitScript(() => {
    const callbacks: Record<string, (event: unknown) => void> = {}
    let selected = 0
    const maps = {
      Map: class {
        constructor(element: HTMLElement) {
          const button = document.createElement('button')
          button.type = 'button'; button.textContent = 'Select synthetic pin'; button.style.minHeight = '44px'
          button.onclick = () => { selected++; callbacks.click?.({ latLng: { lat: () => 14.65 + selected / 1000, lng: () => 121.02 } }) }
          element.appendChild(button)
        }
        setCenter() {} setZoom() {}
      },
      Marker: class { setPosition() {} getPosition() { return { lat: () => 14.65, lng: () => 121.02 } } },
      event: { addListener: (_target: unknown, name: string, callback: (event: unknown) => void) => { callbacks[name] = callback; return { remove() {} } } },
    }
    Object.assign(window, { google: { maps } })
  })
  await fixture(page)
  let releaseFirst!: () => void
  let calls = 0
  const pinAddress = { ...address, street: 'Current pin street', postal_code: '', psgc_code: null, barangay: '', latitude: 14.652, longitude: 121.02 }
  await page.route('**/onboarding/address/pin', async route => {
    calls++
    if (calls === 1) {
      await new Promise<void>(resolve => { releaseFirst = resolve })
      await route.fulfill({ json: { data: { address: { ...address, street: 'Stale pin street', latitude: 14.651, longitude: 121.02 }, pin_token: 'old-test-pin' }, meta: {}, errors: [] } })
    } else await route.fulfill({ json: { data: { address: pinAddress, pin_token: 'current-test-pin', message: 'Select the unmatched barangay and complete the postal code.' }, meta: {}, errors: [] } })
  })
  await page.route('**/onboarding/address/areas?**', route => route.fulfill({ json: { data: { items: [{ code: address.psgc_code, name: 'Alicia', level: 'BARANGAY' }], page: 1, has_more: false, version_id: 'fixture' }, meta: {}, errors: [] } }))
  await page.route('**/onboarding/address/resolve', route => route.fulfill({ json: { data: { address: { ...pinAddress, barangay: 'Alicia', psgc_code: address.psgc_code, postal_code: '1100' }, resolution_token: 'test-resolution' }, meta: {}, errors: [] } }))
  await page.goto('/onboarding/verification')
  await expect(page.getByRole('button', { name: 'Select synthetic pin' })).toHaveCount(0)
  await page.getByRole('button', { name: '2 Registered Business Address' }).click()
  await page.getByRole('button', { name: 'Select synthetic pin' }).click()
  await expect.poll(() => calls).toBe(1)
  await page.getByRole('button', { name: 'Select synthetic pin' }).click()
  await expect(page.getByRole('textbox', { name: 'Detailed Address' })).toHaveValue('Current pin street')
  await expect(page.getByRole('textbox', { name: 'Latitude' })).toHaveCount(0)
  await expect(page.getByRole('textbox', { name: 'Longitude' })).toHaveCount(0)
  const lateResponse = page.waitForResponse(response => response.url().endsWith('/address/pin'))
  releaseFirst()
  await lateResponse
  await expect(page.getByRole('textbox', { name: 'Detailed Address' })).toHaveValue('Current pin street')
  await expect(page.getByRole('combobox', { name: 'Barangay' })).toHaveValue('')
  await page.getByRole('combobox', { name: 'Barangay' }).click()
  await page.getByRole('option', { name: 'Alicia', exact: true }).click()
  await page.getByRole('textbox', { name: 'Postal code' }).fill('1100')
  await expect(page.getByText('Location resolved. Review your address before saving.')).toBeVisible()
  const payload = JSON.parse(await page.locator('[name=address_payload]').inputValue())
  expect(payload).toMatchObject({ source: 'MAP', resolution_token: 'test-resolution', psgc_code: address.psgc_code })
  expect(payload).not.toHaveProperty('latitude')
  await fits(page)
  await capture(page, 'resolved-pin')
})


test('saved private evidence previews inside the authenticated portal and releases its object URL', async ({ page }) => {
  await fixture(page)
  let source = ''
  await page.route('**/vendors/onboarding/files/pending-example', route => route.fulfill({ json: { data: { url: new URL('/api/v1/vendor-onboarding-files/pending-example/content?expires=123&signature=synthetic', route.request().url()).href, expires_at: '2030-01-01T00:00:00Z' }, meta: {}, errors: [] } }))
  await page.route('**/vendor-onboarding-files/pending-example/content?**', route => {
    source = route.request().headers().origin ?? route.request().headers().referer ?? ''
    return route.fulfill({ contentType: 'image/png', body: Buffer.from('iVBORw0KGgoAAAANSUhEUgAAAAEAAAABCAQAAAC1HAwCAAAAC0lEQVR42mP8/x8AAwMCAO+jRZkAAAAASUVORK5CYII=', 'base64') })
  })
  await page.goto('/onboarding/verification')
  await page.getByRole('button', { name: 'View saved document' }).click()
  const dialog = page.getByRole('dialog', { name: 'Submitted document preview' })
  await expect(dialog).toBeVisible()
  await expect(dialog.getByRole('img')).toHaveAttribute('src', /^blob:/)
  expect(new URL(source).origin).toBe(new URL(page.url()).origin)
  const objectUrl = await dialog.getByRole('img').getAttribute('src')
  await page.getByRole('button', { name: 'Close preview' }).click()
  await expect(dialog).toHaveCount(0)
  expect(await page.evaluate(async url => { try { await fetch(url!); return true } catch { return false } }, objectUrl)).toBe(false)
  await fits(page)
})
