import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

const date = '2026-11-05T02:00:00Z'
const store = 'Northside Construction Materials and Hardware Supply'
const verification = { id: 'vendor-1', store_name: store, registered_name: 'Northside Materials Inc.', verification_status: 'PENDING_VERIFICATION', progress: { complete: 3, total: 8 }, pending_requirements: 5, setup_status: 'IN_PROGRESS', provider_status: 'CONNECTED_TEST', activation_status: 'NOT_READY', discoverability_status: 'NOT_DISCOVERABLE', region_name: 'National Capital Region', province: 'Metro Manila', city_municipality: 'Quezon City', submitted_at: date, oldest_pending_at: date }
const compliance = { id: 'submission-1', version: 2, path: 'MANUAL', status: 'PENDING_ADMIN_REVIEW', review_mode: 'MANUAL_REVIEW', listing_id: 'listing-1', display_name: 'Portland cement 40 kg — general purpose', public_store_name: store, product_name: 'Portland cement', reference_standard: 'PNS 07:2018', reference_result: 'UNMATCHED', submitted_at: date }
const dispute = { id: 'case-1', reference: 'CASE-2026-001', order_reference: 'ORD-2026-001', vendor_name: store, buyer_name: 'Juan Dela Cruz', status: 'ESCALATED_ADMIN_REVIEW', case_kind: 'TRANSACTION', issue_type: 'DEFECTIVE', requested_remedy: 'REPLACEMENT', assigned_to_admin: false, refund_state: 'NOT_REQUESTED', decisions: 0 }
const enforcement = { id: 'action-1', subject_type: 'VENDOR_ORGANIZATION', subject_id: 'vendor-1', subject_name: store, action: 'SUSPENSION', action_label: 'Suspension', state: 'REFERRED', source: 'DISPUTE_REFERRAL', case_reference: 'CASE-2026-001', reason: 'Refer the documented non-fulfillment for review.', scope: 'Marketplace activity', created_at: date, lock_version: 2 }

async function mock(page: Page) {
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url()), path = url.pathname
    const empty = url.searchParams.get('from') === '2020-01-01' || url.searchParams.get('submitted_from') === '2020-01-01'
    let data: unknown = {}, meta: Record<string, unknown> = {}
    if (path.endsWith('/profile')) data = { id: 'layout-admin', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'layout-compliance-csrf' }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    else if (path.endsWith('/admin/vendor-verification')) { data = empty ? [] : [{ ...verification, verification_status: url.searchParams.get('status') ?? verification.verification_status }]; meta = { total: empty ? 0 : 1, last_page: 1, status_counts: { PENDING_VERIFICATION: empty ? 0 : 1, CHANGES_REQUIRED: 0, REJECTED: 0, APPROVED: empty ? 0 : 22, EXPIRED: 0 } } }
    else if (path.endsWith('/admin/product-compliance/registers')) data = []
    else if (path.endsWith('/admin/product-compliance')) { data = empty ? [] : [{ ...compliance, status: url.searchParams.get('status') ?? compliance.status }]; meta = { total: empty ? 0 : 1, last_page: 1 } }
    else if (path.endsWith('/admin/disputes')) { data = empty ? [] : [dispute]; meta = { total: empty ? 0 : 1, per_page: 25, counts: { NEEDS_ADMIN: empty ? 0 : 1, WITH_PARTIES: 0, REMEDY_TRACKING: 0, CONCLUDED: empty ? 0 : 2 } } }
    else if (path.endsWith('/admin/enforcement')) { data = empty ? [] : [{ ...enforcement, state: url.searchParams.get('state') ?? 'REFERRED' }]; meta = { total: empty ? 0 : 1, last_page: 1 } }
    else if (path.endsWith('/admin/vendor-verification/vendor-1')) data = { organization: { store_name: store, registered_name: 'Northside Materials Inc.', business_type: 'CORPORATION', store_verification_status: 'PENDING_VERIFICATION', store_activation_status: 'NOT_READY' }, sections: { STORE_VERIFICATION: [{ key: 'bir_cor', label: 'BIR Certificate of Registration', level: 'REQUIRED', status: 'PENDING_VERIFICATION', lock_version: 1 }] }, readiness: { ready: false, blockers: [{ key: 'Verification', reason: 'Review current business requirements.' }] }, documents: [], reviews: [] }
    else if (path.endsWith('/admin/product-compliance/submission-1')) data = { submission: { id: 'submission-1', version: 2, lock_version: 1, rule_version: 1, status: 'PENDING_ADMIN_REVIEW', path: 'MANUAL', submitted_at: date, declared: { license_number: 'SAMPLE-PS-001', brand: 'Northside' } }, listing: { display_name: compliance.display_name, public_store_name: store, status: 'PENDING_COMPLIANCE', media_file_ids: [] }, rule: { product_name: 'Portland cement', reference_standard: 'PNS 07:2018', marking_requirements: [] }, evidence: [], extractions: [], previous_submissions: [], reviews: [], official_references: [], reference_match: { result: 'UNMATCHED', details: {} } }
    else if (path.endsWith('/admin/disputes/case-1')) data = { ...dispute, order_id: 'order-1', description: 'The Buyer reported damaged bags and requested replacement.', filed_by_party: 'BUYER', responsible_party: 'ADMIN', remedy_state: 'NONE', appeal_available: false, order: { id: 'order-1', reference: dispute.order_reference, order_state: 'DISPUTED', dispute_state: dispute.status, refund_state: 'NONE', payment_method: 'CASH_ON_DELIVERY' }, deadlines: [], server_time: date, timezone: 'Asia/Manila', handler: { admin_assigned: false, admin_is_me: false }, lock_version: 2, affected_lines: [], timeline: [], proposals: [], clarifications: [], decisions: [], remedies: [], refunds: [], reimbursements: [], available_actions: [], limited_view: false }
    else if (path.endsWith('/admin/enforcement/action-1')) data = { ...enforcement, allowed_actions: [], events: [], subject_review: { subject_type: 'VENDOR_ORGANIZATION', subject_id: 'vendor-1', display_name: store, account_status: 'ACTIVE', store_activation_status: 'ACTIVE', open_orders: 2, orders_total: 12, disputes_open: 1, disputes_total: 2 } }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
}

async function capture(page: Page, name: string) {
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), 'page stays inside the viewport').toBe(true)
  for (const panel of await page.locator('.mp-queue-workspace > .mp-card').all()) {
    const box = await panel.boundingBox()
    expect(box!.x).toBeGreaterThanOrEqual(0)
    expect(box!.x + box!.width).toBeLessThanOrEqual(page.viewportSize()!.width + 1)
  }
  const folder = resolve('../../.tmp/compliance-quality/screenshots')
  mkdirSync(folder, { recursive: true })
  await page.screenshot({ path: resolve(folder, `${page.viewportSize()!.width}-${name}.png`), fullPage: true })
}

const queues = [
  { path: 'vendor-verification', title: 'Vendor Verification', overview: 'Verification overview', detail: 'vendor-1', open: 'Review', back: 'Back to queue', empty: 'No cases match this view.' },
  { path: 'product-compliance', title: 'Product Compliance Queue', overview: 'Compliance overview', detail: 'submission-1', open: compliance.display_name, back: 'Back to queue', empty: 'No submissions match this view.' },
  { path: 'disputes', title: 'Disputes & Appeals', overview: 'Disputes overview', detail: 'case-1', open: 'Review case', back: 'Case queue', empty: 'No cases in this queue.' },
  { path: 'enforcement', title: 'Enforcement', overview: 'Enforcement overview', detail: 'action-1', open: `Open Suspension for ${store}`, back: 'Back to Enforcement', empty: 'No enforcement records match this view.' },
]

for (const queue of queues) test(`${queue.title} has consistent queues, sections and empty states`, async ({ page }) => {
  await page.emulateMedia({ reducedMotion: 'reduce' })
  await mock(page)
  await page.goto(`http://127.0.0.1:4174/${queue.path}`)
  await expect(page.getByRole('heading', { name: queue.title, level: 1 })).toBeVisible()
  await expect(page.getByRole('region', { name: queue.overview })).toHaveCount(0)
  await expect(page.getByText('1 record', { exact: true })).toBeVisible()
  await capture(page, `${queue.path}-queue`)
  for (const tab of await page.getByRole('tab').all()) {
    await tab.click()
    await expect(tab).toHaveAttribute('aria-selected', 'true')
    expect(await tab.evaluate(element => parseFloat(getComputedStyle(element).borderTopLeftRadius))).toBeGreaterThanOrEqual((await tab.boundingBox())!.height / 2)
    await expect(page.getByText('1 record', { exact: true })).toBeVisible()
  }
  if (queue.path === 'product-compliance') {
    await page.getByRole('tab', { name: 'Verified', exact: true }).click()
    await expect(page).toHaveURL(/status=VERIFIED/)
  }
  const previous = new URL(page.url()).search
  const open = page.getByRole('main').getByRole('link', { name: queue.open, exact: true }).filter({ visible: true }).first()
  await open.click()
  await expect(page).toHaveURL(new RegExp(`/${queue.path}/${queue.detail}`))
  const back = page.getByRole('main').getByRole(queue.path === 'enforcement' || queue.path === 'disputes' ? 'link' : 'button', { name: queue.back, exact: true })
  await expect(back).toBeVisible()
  const sectionLinks = page.getByRole('navigation', { name: 'Case sections' })
  if (queue.path === 'product-compliance') {
    const sections = page.getByRole('navigation', { name: 'Review sections' })
    for (const button of await sections.getByRole('button').all()) { await button.click(); await capture(page, `${queue.path}-${await button.textContent()}`) }
  } else {
    await expect(sectionLinks).toBeVisible()
    for (const link of await sectionLinks.getByRole('link').all()) { const href = await link.getAttribute('href'); await expect(page.locator(href!)).toHaveCount(1) }
  }
  await capture(page, `${queue.path}-detail`)
  await back.click()
  expect(new URL(page.url()).search).toBe(previous)
  await page.goto(`http://127.0.0.1:4174/${queue.path}?from=2020-01-01&to=2020-01-02`)
  await expect(page.getByRole('heading', { name: queue.empty, exact: true })).toBeVisible()
  await expect(page.getByRole('navigation', { name: 'Pagination' })).toHaveCount(0)
  await capture(page, `${queue.path}-empty`)
})
