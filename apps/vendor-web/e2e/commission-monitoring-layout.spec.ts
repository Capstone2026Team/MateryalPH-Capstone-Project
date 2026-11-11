import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

const assessments = Array.from({ length: 12 }, (_, index) => ({
  id: `sample-assessment-${index}`, order_reference: index === 0 ? 'ORD-2026-LONG-REFERENCE-1234567890' : `ORD-2026-SAMPLE-${index + 1}`,
  state: index === 1 ? 'ESTIMATED' : index === 2 ? 'CANCELLED' : 'EARNED',
  commission_basis_centavos: 25491, commission_basis_points: index === 0 ? 200 : 325,
  estimated_centavos: index === 1 ? 828 : 0, earned_centavos: index === 1 || index === 2 ? 0 : 510,
  credited_centavos: index === 0 ? 100 : 0, net_centavos: index === 0 ? 410 : index === 1 || index === 2 ? 0 : 510,
  dispute_hold: index === 3, earned_at: index === 1 || index === 2 ? null : '2026-11-06T04:30:00Z',
}))

const statementRows = ['PAID', 'ISSUED', 'PARTIALLY_PAID'].map((state, index) => ({
  id: `sample-statement-${index + 1}`, reference: `SAMPLE-STMT-202610-${index + 1}`, state, overdue: index === 2,
  period_start: '2026-10-01', period_end: '2026-10-31', issued_on: '2026-11-01', due_on: '2026-11-15',
  charges_centavos: 6120, credits_centavos: 1000, paid_centavos: index === 0 ? 5120 : index === 2 ? 3000 : 0,
  outstanding_centavos: index === 0 ? 0 : index === 2 ? 2120 : 5120, disputed_held_centavos: 0, lock_version: 2,
  sample_notice: 'SAMPLE statement — not an official invoice. TEST/DEMO billing.',
}))

const annualPayments = { label: '2026', starts_on: '2026-01-01', ends_on: '2026-12-31', resets_at: '2026-12-31T16:00:00Z', collected_centavos: 9000, refunded_centavos: 1000, net_collected_centavos: 8000 }
const monthlyPayments = { ...annualPayments, label: 'November 2026', starts_on: '2026-11-01', ends_on: '2026-11-30', resets_at: '2026-11-30T16:00:00Z', collected_centavos: 4000, net_collected_centavos: 3000 }

async function mock(page: Page, { empty = false, owner = true } = {}) {
  const requests: number[] = []
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    const path = url.pathname
    let data: unknown = {}
    let meta = {}
    if (path.endsWith('/profile')) data = { id: 'sample-owner', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: owner ? 'OWNER' : 'STORE_MANAGER' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'sample-csrf-for-layout-test' }
    else if (path.endsWith('/onboarding')) data = {
      step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Sample Supply', lock_version: 1 }, welcome_required: false,
      permissions: owner ? ['portal.wallet', 'portal.earnings', 'finance.view'] : ['portal.orders'], verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', readiness: { ready: true, blockers: [] } },
    }
    else if (path.endsWith('/vendor/finance/transactions')) {
      const filter = url.searchParams.get('statement_state')
      const rows = statementRows.filter(row => (filter === 'PAID' ? row.state === 'PAID' : filter === 'NOT_PAID' ? row.state !== 'PAID' : true)
        && (!url.searchParams.get('from') || row.issued_on >= url.searchParams.get('from')!)
        && (!url.searchParams.get('to') || row.issued_on <= url.searchParams.get('to')!))
      data = url.searchParams.get('tab') === 'STATEMENTS' ? rows : []
      meta = { page: Number(url.searchParams.get('page') ?? 1), total: rows.length, has_more: false }
    }
    else if (path.includes('/vendor/finance/statements/')) {
      const statement = statementRows.find(row => path.endsWith(row.id)) ?? statementRows[0]
      data = { ...statement, lines: [...assessments.map(row => ({ type: 'EARNED_COMMISSION', amount_centavos: 510, description: 'Earned commission on completed order', order_reference: row.order_reference, basis_centavos: row.commission_basis_centavos, commission_basis_points: 200 })), { type: 'CREDIT', amount_centavos: 1000, description: 'Approved commission credit' }],
        payments: statement.state === 'PAID' ? [{ id: 'sample-fee-payment', purpose: 'PLATFORM_FEE_PAYMENT', status: 'PAID', attempt_number: 1, principal_centavos: 5120, processing_fee_centavos: 0, total_centavos: 5120, channel_name: 'Maya', channel_code: 'MAYA', fee_bearer: 'PLATFORM', environment: 'TEST', evidence_origin: 'PROVIDER_TEST', can_check_status: false, created_at: '2026-11-02T09:00:00Z', message: 'Payment verified by the provider (TEST — no real charge).' }] : [],
        channels: statement.state === 'PAID' ? [] : [{ code: 'GCASH', display_name: 'GCash', kind: 'EWALLET', available: true, refund_supported: true, fee_version: 1, rate_label: '0%', fee_centavos: 0, total_centavos: statement.outstanding_centavos, fee_bearer: 'PLATFORM', rate_source: 'DEMO_PUBLISHED_RATE' }],
      }
    }
    else if (path.endsWith('/vendor/finance/commissions')) {
      const requestedPage = Number(url.searchParams.get('page') ?? 1)
      requests.push(requestedPage)
      data = {
        current_policy: { id: 'sample-current', version: 2, commission_basis_points: 325, rate_label: '3.25%', effective_from: '2026-10-19T00:00:00Z', status: 'CURRENT' },
        next_policy: { id: 'sample-next', version: 3, commission_basis_points: 350, rate_label: '3.50%', effective_from: '2026-12-01T00:00:00Z', status: 'SCHEDULED' },
        terms_accepted: true,
        annual_payments: annualPayments, monthly_payments: monthlyPayments,
        payment_history: { items: empty ? [] : [{ ...annualPayments, label: '2025' }], page: 1, per_page: 10, total: empty ? 0 : 1, has_more: false },
        summary: { estimated_centavos: 828, earned_centavos: 5100, credited_centavos: 100, net_earned_centavos: 5000, unbilled_centavos: 3022, draft_centavos: 1000, outstanding_centavos: 2000, overdue_centavos: 500, collected_centavos: 9000, refunded_centavos: 1000, net_collected_centavos: 8000 },
        assessments: empty ? [] : requestedPage === 1 ? assessments : [{ ...assessments[0], id: 'sample-second-page', order_reference: 'ORD-SECOND-PAGE' }],
      }
      meta = { page: requestedPage, per_page: 20, total: empty ? 0 : 21, has_more: !empty && requestedPage === 1 }
    }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  return requests
}

test('commission records keep rates, credits and statuses readable at every viewport', async ({ page }) => {
  const requests = await mock(page)
  await page.goto('/finance/commissions')
  const billing = page.getByRole('region', { name: 'Monthly commission payment', exact: true })
  const orders = page.getByRole('region', { name: 'Commission by order', exact: true }).first()
  await expect(billing).toBeVisible()
  const overview = page.getByRole('region', { name: 'Annual total commission payment', exact: true })
  const overviewBox = (await overview.boundingBox())!
  const billingBox = (await billing.boundingBox())!
  const contentWidth = (await page.locator('.mp-commission-monitoring').boundingBox())!.width
  if (contentWidth >= 1040) {
    expect(billingBox.x).toBeGreaterThan(overviewBox.x + overviewBox.width)
    expect(Math.abs(billingBox.y - overviewBox.y)).toBeLessThan(2)
  } else expect(billingBox.y).toBeGreaterThan(overviewBox.y)
  await expect(overview.getByText('₱80.00', { exact: true })).toBeVisible()
  await expect(billing.getByText('₱30.00', { exact: true })).toBeVisible()
  await expect(overview.getByText('Calendar year · 2026', { exact: true })).toBeVisible()
  await expect(billing.getByText('Calendar month · November 2026', { exact: true })).toBeVisible()
  await expect(page.getByText('Scheduled: 3.50%', { exact: false })).toBeVisible()
  await expect(page.getByRole('table', { name: 'Monthly commission payments' }).getByRole('row', { name: 'Completed refunds -₱10.00' })).toBeVisible()
  await expect(orders.getByText(assessments[0].order_reference, { exact: true })).toBeVisible()
  await expect(orders.getByText('2.00%', { exact: true })).toBeVisible()
  await expect(orders.getByText('Fee reduction -₱1.00', { exact: true })).toBeVisible()
  const statusColors = []
  for (const status of ['Charged', 'Estimated', 'Cancelled', 'Dispute hold']) {
    const badge = orders.getByText(status, { exact: true }).first()
    await expect(badge).toBeVisible()
    statusColors.push(await badge.evaluate(element => getComputedStyle(element).backgroundColor))
  }
  expect(new Set(statusColors).size, 'each commission status has its own background color').toBe(4)
  await expect(orders.getByText(/-₱0\.00/)).toHaveCount(0)
  if (page.viewportSize()!.width >= 1024) {
    await expect(orders.getByRole('columnheader')).toHaveCount(6)
    await expect(orders.getByRole('region', { name: 'Commission by order' })).toHaveAttribute('tabindex', '0')
  } else {
    await expect(orders.getByRole('article')).toHaveCount(12)
    await expect(orders.getByRole('table')).toHaveCount(0)
  }
  const balances = page.getByRole('region', { name: 'Current commission balances', exact: true })
  const groups = await balances.locator('.mp-finance-summary-columns > section').all()
  const first = (await groups[0].boundingBox())!
  const second = (await groups[1].boundingBox())!
  if ((await balances.boundingBox())!.width >= 520) expect(second.x).toBeGreaterThan(first.x + first.width)
  else expect(second.y).toBeGreaterThan(first.y)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const directory = resolve('../../.tmp/commission-monitoring-review')
  mkdirSync(directory, { recursive: true })
  await page.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-commission.png`), fullPage: true })
  await billing.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-billing.png`) })
  await orders.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-orders.png`) })
  await orders.getByRole('button', { name: 'Next', exact: true }).click()
  await expect(orders.getByText('ORD-SECOND-PAGE', { exact: true })).toBeVisible()
  expect(requests).toEqual([1, 2])
  await page.getByRole('button', { name: 'Refresh', exact: true }).click()
  await expect.poll(() => requests).toEqual([1, 2, 2])
  await expect(page.getByRole('link', { name: 'View and pay commission statements' })).toHaveAttribute('href', '#commission-statements')
})

test('annual payment history retains prior years in a separate responsive dialog', async ({ page }) => {
  await mock(page)
  await page.goto('/finance/commissions')
  const trigger = page.getByRole('button', { name: 'Annual history', exact: true })
  await trigger.click()
  const history = page.getByRole('dialog', { name: 'Annual total commission payment history', exact: true })
  await expect(history.getByText('2025', { exact: true })).toBeVisible()
  await expect(history.getByText('₱80.00', { exact: true })).toBeVisible()
  expect(await history.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  const directory = resolve('../../.tmp/commission-monitoring-review')
  mkdirSync(directory, { recursive: true })
  await page.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-annual-history.png`) })
  await page.keyboard.press('Escape')
  await expect(history).toHaveCount(0)
  await expect(trigger).toBeFocused()
})

test('commission monitoring recovers from a failed load and shows an empty record state', async ({ page }) => {
  await mock(page, { empty: true })
  let unavailable = true
  await page.route('**/api/v1/vendor/finance/commissions*', async route => {
    if (!unavailable) return route.fallback()
    await route.fulfill({ status: 503, json: { data: null, meta: {}, errors: [{ code: 'SERVICE_UNAVAILABLE', message: 'Commission monitoring is temporarily unavailable.' }] } })
  })
  await page.goto('/finance/commissions')
  await expect(page.getByRole('button', { name: 'Try again' })).toBeVisible()
  unavailable = false
  await page.getByRole('button', { name: 'Try again' }).click()
  await expect(page.getByText(/No commission assessments yet/)).toBeVisible()
  await expect(page.getByRole('region', { name: 'Monthly commission payment', exact: true })).toBeVisible()
  await expect(page.getByRole('navigation', { name: 'Pagination' })).toHaveCount(0)
})

test('commission monitoring keeps store finance restricted to the Owner', async ({ page }) => {
  const requests = await mock(page, { owner: false })
  await page.goto('/finance/commissions')
  await expect(page.getByText('Store-wide finance is Owner-only', { exact: true })).toBeVisible()
  expect(requests).toEqual([])
})

test('one billing help icon opens all six explanations without expanding the panel', async ({ page }) => {
  await mock(page, { empty: true })
  await page.goto('/finance/commissions')
  const billing = page.getByRole('region', { name: 'Current commission balances', exact: true })
  await expect(billing).toBeVisible()
  const height = (await billing.boundingBox())!.height
  const titles = ['Not yet billed', 'Draft bills awaiting issue', 'Approved commission credits', 'Unpaid statements', 'Overdue', 'Estimated commission']
  await expect(billing.getByRole('button', { name: /^How this is calculated:/ })).toHaveCount(1)
  const trigger = billing.getByRole('button', { name: 'How this is calculated: Current commission balances', exact: true })
  const target = (await trigger.boundingBox())!
  expect(target.width).toBeGreaterThanOrEqual(44)
  expect(target.height).toBeGreaterThanOrEqual(44)
  await trigger.click()
  const dialog = page.getByRole('dialog', { name: 'Current commission balances', exact: true })
  await expect(dialog).toBeVisible()
  for (const title of titles) await expect(dialog.getByRole('heading', { name: title, exact: true })).toBeVisible()
  await expect(dialog).toContainText('These balances carry forward when the payment totals reset.')
  const bounds = (await dialog.boundingBox())!
  const viewport = page.viewportSize()!
  expect(bounds.x).toBeGreaterThanOrEqual(12)
  expect(bounds.y).toBeGreaterThanOrEqual(12)
  expect(bounds.x + bounds.width).toBeLessThanOrEqual(viewport.width - 12)
  expect(bounds.y + bounds.height).toBeLessThanOrEqual(viewport.height - 12)
  expect((await billing.boundingBox())!.height).toBeCloseTo(height, 0)
  const directory = resolve('../../.tmp/commission-monitoring-review')
  mkdirSync(directory, { recursive: true })
  await page.screenshot({ path: resolve(directory, `${viewport.width}-billing-explanation.png`) })
  const lastExplanation = dialog.getByRole('heading', { name: 'Estimated commission', exact: true })
  await lastExplanation.scrollIntoViewIfNeeded()
  await expect(lastExplanation).toBeInViewport()
  await page.keyboard.press('Escape')
  await expect(dialog).toHaveCount(0)
  await expect(trigger).toBeFocused()
  await trigger.click()
  await dialog.getByRole('button', { name: 'Close calculation explanation' }).click()
  await expect(dialog).toHaveCount(0)
  await expect(trigger).toBeFocused()
})

test('statements sit beside monitoring panels and old links open compact paid and unpaid details', async ({ page }) => {
  await mock(page)
  await page.goto('/finance/transactions')
  await expect(page.getByRole('tab', { name: 'Commission statements', exact: true })).toHaveCount(0)
  await page.goto('/finance/transactions?tab=STATEMENTS&page=2&from=2026-10-01')
  await expect(page).toHaveURL(/finance\/commissions\?from=2026-10-01&statement_page=2#commission-statements/)
  const statements = page.getByRole('region', { name: 'Commission statements', exact: true })
  await expect(statements.getByRole('link', { name: /SAMPLE-STMT-202610-2/ })).toBeVisible()
  await expect(statements.getByRole('link', { name: /SAMPLE-STMT-202610-1/ })).toHaveCount(0)
  await expect(statements.getByRole('button', { name: 'History', exact: true })).toBeVisible()
  const contentWidth = (await page.locator('.mp-commission-monitoring').boundingBox())!.width
  if (contentWidth >= 1040) {
    const overview = (await page.getByRole('region', { name: 'Annual total commission payment', exact: true }).boundingBox())!
    const billing = (await page.getByRole('region', { name: 'Monthly commission payment', exact: true }).boundingBox())!
    const box = (await statements.boundingBox())!
    expect(box.x).toBeGreaterThan(billing.x + billing.width)
    expect(Math.abs(box.y - overview.y)).toBeLessThan(2)
  }
  await statements.getByRole('button', { name: 'History', exact: true }).click()
  const history = page.getByRole('dialog', { name: 'Commission statement history', exact: true })
  await expect(history).toBeVisible()
  await expect(history.getByRole('link', { name: 'SAMPLE-STMT-202610-1', exact: true })).toBeVisible()
  await expect(history.getByRole('link', { name: /SAMPLE-STMT-202610-2/ })).toHaveCount(0)
  expect(await history.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await history.getByRole('button', { name: 'From Oct 1, 2026', exact: true }).click()
  const dateDialog = page.getByRole('dialog', { name: 'Statement issue dates', exact: true })
  await expect(dateDialog).toBeVisible()
  await page.keyboard.press('Escape')
  await expect(dateDialog).not.toBeVisible()
  await expect(history).toBeVisible()
  expect(await page.evaluate(() => document.body.style.overflow)).toBe('hidden')
  await page.keyboard.press('Escape')
  await expect(history).toHaveCount(0)
  await expect(statements.getByRole('button', { name: 'History', exact: true })).toBeFocused()
  await statements.getByRole('button', { name: 'History', exact: true }).click()
  const directory = resolve('../../.tmp/commission-monitoring-review')
  mkdirSync(directory, { recursive: true })
  const viewport = page.viewportSize()!
  await page.screenshot({ path: resolve(directory, `${viewport.width}-statement-history.png`) })
  await history.getByRole('link', { name: 'SAMPLE-STMT-202610-1', exact: true }).click()
  await expect(page.getByRole('heading', { name: 'SAMPLE-STMT-202610-1', exact: true })).toBeVisible()
  await expect(page.getByText('Statement settled. No payment is due.', { exact: true })).toBeVisible()
  await expect(page.getByRole('complementary', { name: 'Pay statement', exact: true })).toHaveCount(0)
  await expect(page.getByRole('region', { name: 'Payment history', exact: true })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Statement breakdown', exact: true }).first().getByText('-₱10.00', { exact: true })).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.setViewportSize({ width: viewport.width, height: Math.max(viewport.height, 1500) })
  await page.screenshot({ path: resolve(directory, `${viewport.width}-statement-paid.png`), fullPage: true })
  await page.setViewportSize(viewport)
  await page.getByRole('link', { name: 'Commission statements', exact: true }).click()
  await expect(page).toHaveURL(/finance\/commissions\?from=2026-10-01&statement_page=2&statement_history=1#commission-statements/)
  await expect(history).toBeVisible()
  await page.keyboard.press('Escape')
  await page.getByRole('region', { name: 'Commission statements', exact: true }).getByRole('link', { name: /SAMPLE-STMT-202610-2/ }).click()
  await expect(page.getByRole('heading', { name: 'Pay statement', exact: true })).toBeVisible()
  await expect(page.getByLabel('GCash', { exact: true })).toBeVisible()
  await expect(page.getByRole('button', { name: /^Pay / })).toBeEnabled()
  await page.screenshot({ path: resolve(directory, `${viewport.width}-statement-unpaid.png`), fullPage: true })
})
