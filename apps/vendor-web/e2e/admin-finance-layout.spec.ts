import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'
import { marketplacePaymentsFixture } from '../../admin-web/src/test/marketplace-payments-fixture'
import { geoDashboardFixture } from '../../admin-web/src/test/geo-dashboard-fixture'
import { FinanceKpisToJSON, GeoDashboardToJSON } from '@materyalph/api-client-ts'

const adminUrl = process.env.ADMIN_FINANCE_PREVIEW_URL ?? 'http://127.0.0.1:4174'

async function mockFinance(page: Page, payments = false) {
  const statement = { id: '019d0000-0000-7000-8000-000000000001', reference: 'SAMPLE-STMT-202610-ABCD1234', vendor_name: 'BuildSphere Construction Supply', state: 'ISSUED', overdue: false,
    period_start: '2026-10-01', period_end: '2026-10-31', issued_on: '2026-11-01', due_on: '2026-11-15', charges_centavos: 52002, credits_centavos: 2000, paid_centavos: 0, outstanding_centavos: 50002, disputed_held_centavos: 0, lock_version: 1, sample_notice: 'SAMPLE / TEST', invoice_heading: 'Platform service invoice', invoice_message: '', email: { total: 1, sent: 1, failed: 0, queued: 0, blocked: 0 } }
  const writes: { body: Record<string, unknown>; key: string | undefined }[] = []
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    const path = url.pathname
    let data: unknown = []
    if (path.endsWith('/profile')) data = { id: 'finance-review', full_name: 'Finance Reviewer', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-finance-review' }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    else if (path.endsWith('/geo-analytics')) data = GeoDashboardToJSON(geoDashboardFixture())
    else if (path.endsWith('/geo-analytics/boundaries')) data = { type: 'FeatureCollection', features: [], missing_codes: [] }
    else if (path.endsWith('/admin/finance/kpis') && payments) data = FinanceKpisToJSON(marketplacePaymentsFixture())
    else if (path.endsWith('/admin/finance/kpis')) data = { label: 'Recorded transactions', scenario: 'SAMPLE / TEST commission records.', period: { from: url.searchParams.get('from'), to: url.searchParams.get('to') }, commerce: [], counts: { draft_statements: 1, pending_commission_credits: 2 },
      finance: Object.entries({ earned_commission: 52002, fee_credits: 2000, refundable_credits: 4500, net_commission: 50002, fee_vat: 0, platform_revenue: 50002, processing_expense: 1050, net_platform_earnings: 48952, collected: 30000, refunded_commissions: 1000, net_collected: 29000, receivables: 21002, overdue: 5000, billed: 50002 }).map(([key, value]) => ({ key, label: key, value_centavos: value, definition: key })),
      trend_granularity: 'DAY', trend: [{ period: '2026-10-20', earned_centavos: 52002, credits_centavos: 0, collected_centavos: 0, refunded_centavos: 0, net_earnings_centavos: 50952, gmv_centavos: 0, buyer_payments_centavos: 0, buyer_refunds_centavos: 0 }, { period: '2026-10-21', earned_centavos: 0, credits_centavos: 2000, collected_centavos: 30000, refunded_centavos: 1000, net_earnings_centavos: -2000, gmv_centavos: 0, buyer_payments_centavos: 0, buyer_refunds_centavos: 0 }] }
    else if (path.endsWith('/commission-policies')) data = { current: { id: statement.id, version: 1, commission_basis_points: 200, rate_label: '2.00%', effective_from: '2026-10-01T00:00:00Z', status: 'CURRENT', terms_version: 2, terms_content: 'Versioned TEST commission terms.' }, latest_version: 1, can_manage: true, can_export: true, min_notice_days: 30, eligible_vendor_count: 128, versions: [] }
    else if (path.endsWith('/statements')) data = [statement]
    else if (path.endsWith('/statements/'+statement.id)) data = { ...statement, can_export: true, can_resend: true, issuance_origin: 'SYSTEM', issued_at: '2026-11-01T00:05:00+08:00', rate_breakdown: [{ rate_label: '2.00%', basis_centavos: 2600100, commission_centavos: 52002 }], lines: { items: [], meta: {} }, payments: { items: [], meta: {} }, emails: [{ id: 'email-1', type: 'STATEMENT_ISSUED', state: 'SENT', attempts: 1, created_at: '2026-11-01T00:05:00+08:00', sent_at: '2026-11-01T00:06:00+08:00' }] }
    else if (path.endsWith('/invoice') && route.request().method() === 'PUT') {
      const body = route.request().postDataJSON()
      writes.push({ body, key: route.request().headers()['idempotency-key'] })
      Object.assign(statement, body, { lock_version: 2 })
      data = statement
    }
    else if (path.endsWith('/commission-transactions')) data = [{ id: 'payment-1', reference: statement.reference, vendor_name: statement.vendor_name, purpose: 'PLATFORM_FEE_PAYMENT', account_scope: 'PLATFORM_ACCOUNT', status: 'PAID', total_centavos: 30000, refunded_centavos: 1000, net_collected_centavos: 29000, paid_at: '2026-11-02T03:00:00Z', evidence_origin: 'XENDIT_TEST', gateway_mode: 'XENDIT_TEST', channel_name: 'GCash' }]
    else if (path.endsWith('/channel-fees')) data = [
      ['GCASH', 'GCash', true], ['GRABPAY', 'GrabPay', true], ['MAYA', 'Maya', true], ['SHOPEEPAY', 'ShopeePay', true], ['CARDS', 'Credit or debit card', true],
      ['BANK_TRANSFER', 'Bank transfer', false], ['DIRECT_DEBIT', 'Online banking direct debit', false], ['OTC', 'Over-the-counter cash', false], ['QRPH', 'QR Ph', false],
    ].map(([code, display_name, enabled]) => ({ code, display_name, kind: 'EWALLET', version: 1, rate_ppm: 23000, fixed_centavos: 0, fee_vat_basis_points: 1200, rate_includes_vat: false,
      refund_supported: Boolean(enabled), enabled, disabled_reason: enabled ? null : 'REFUND_ROUTE_UNAVAILABLE', source_type: 'PUBLISHED', source_reference: 'Published TEST rates', effective_from: '2026-10-01T00:00:00Z' }))
    if (path.endsWith('/admin/finance/kpis') && url.searchParams.get('from')?.endsWith('-01-01') && url.searchParams.get('to')?.endsWith('-12-31')) {
      const annual = data as { finance: { key: string; value_centavos: number }[] }
      annual.finance = annual.finance.map(figure => ({ ...figure, value_centavos: ({ collected: 125000, refunded_commissions: 25000, net_collected: 100000 } as Record<string, number>)[figure.key] ?? figure.value_centavos }))
    }
    await route.fulfill({ json: { data, meta: { page: 1, has_more: false, total: Array.isArray(data) ? data.length : 1, ...(path.endsWith('/statements') ? { totals: { charges_centavos: 52002, credits_centavos: 2000, after_credits_centavos: 50002, outstanding_centavos: 50002 } } : {}) }, errors: [] } })
  })
  return writes
}

async function capture(page: Page, name: string) {
  await page.evaluate(() => { document.querySelectorAll('*').forEach(element => { if (element.scrollTop > 0) element.scrollTop = 0 }); window.scrollTo(0, 0) })
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), 'No horizontal page overflow').toBe(true)
  const directory = resolve('../../.tmp/admin-finance-review')
  mkdirSync(directory, { recursive: true })
  const viewport = page.viewportSize()!
  const height = await page.getByRole('main').evaluate(element => element.scrollHeight + 100)
  await page.setViewportSize({ width: viewport.width, height: Math.min(9000, Math.max(viewport.height, height)) })
  await page.screenshot({ path: resolve(directory, `${viewport.width}-${name}.png`), fullPage: true })
  await page.setViewportSize(viewport)
}

test('Admin Finance shares Vendor layouts across overview, management, transactions and Xendit', async ({ page }) => {
  const writes = await mockFinance(page)
  await page.goto(`${adminUrl}/finance`)
  const main = page.getByRole('main')
  await expect(main.getByRole('heading', { name: 'Finance overview', level: 1 })).toBeVisible()
  await expect(main.getByRole('heading', { name: 'Financial calculations', exact: true })).toBeVisible()
  await expect(main.getByRole('table', { name: 'Net platform earnings calculation' })).toContainText('₱489.52')
  await expect(main.getByRole('tab', { name: 'Payments and refunds' })).toHaveCount(0)
  await expect(main.getByText('Finance actions', { exact: true })).toHaveCount(0)
  await expect(main.getByText('Draft commission statements', { exact: true })).toHaveCount(0)
  await expect(main.getByText('Marketplace payment records', { exact: true })).toHaveCount(0)
  await expect(main.getByRole('heading', { name: 'Marketplace payments', exact: true })).toHaveCount(0)
  const rows = main.locator('.mp-finance-overview > .mp-finance-main > .mp-finance-report-row')
  await expect(rows).toHaveCount(2)
  for (const row of await rows.all()) {
    const layout = await row.evaluate(element => {
      const panels = [...element.children].map(panel => panel.getBoundingClientRect())
      return { width: element.getBoundingClientRect().width, first: { top: panels[0]!.top, height: panels[0]!.height }, second: { top: panels[1]!.top, height: panels[1]!.height } }
    })
    if (layout.width >= 900) {
      expect(Math.abs(layout.first.top - layout.second.top)).toBeLessThan(2)
      expect(Math.abs(layout.first.height - layout.second.height)).toBeLessThan(2)
    } else expect(layout.second.top).toBeGreaterThan(layout.first.top)
  }
  await expect(main.getByRole('heading', { name: 'Online payment channels', exact: true })).toBeVisible()
  await expect(main.getByRole('list', { name: 'Commission payment channels' }).getByRole('listitem')).toHaveCount(9)
  if (page.viewportSize()!.width >= 1024) {
    expect(await main.locator('.mp-finance-overview > .mp-analytics-summary').evaluate(element => {
      const last = element.querySelector('.mp-analytics-stat:last-child')!
      return element.getBoundingClientRect().right - last.getBoundingClientRect().right
    }), 'Summary metrics fill their row').toBeLessThan(24)
  }
  await capture(page, 'overview')
  await main.getByRole('tab', { name: 'Commission management', exact: true }).click()
  await expect(main.getByRole('heading', { name: 'Commission terms', exact: true })).toBeVisible()
  await expect(main.getByRole('heading', { name: 'Commission credits', exact: true })).toBeVisible()
  await expect(main.getByText('TEST/DEMO billing', { exact: true })).toHaveCount(1)
  await expect(main.getByRole('button', { name: 'Last 30 days', exact: true })).toHaveCount(1)
  await main.getByRole('button', { name: 'How credits work: Commission credits', exact: true }).click()
  await expect(page.getByRole('dialog', { name: 'Commission credits', exact: true })).toContainText('An unpaid bill is reduced.')
  await page.keyboard.press('Escape')
  const cards = main.locator('.mp-commission-policy-row > section')
  const policyBounds = (await cards.nth(0).boundingBox())!
  const creditBounds = (await cards.nth(1).boundingBox())!
  if (page.viewportSize()!.width >= 1280) expect(Math.abs(policyBounds.y - creditBounds.y)).toBeLessThan(2)
  else expect(creditBounds.y).toBeGreaterThanOrEqual(policyBounds.y + policyBounds.height)
  await expect(main.getByRole('heading', { name: 'Commission credit approvals' })).toHaveCount(0)
  await expect(main.getByRole('button', { name: 'Edit e-invoice' })).toHaveCount(0)
  const bills = main.getByRole('table', { name: 'Commission statements' })
  await expect(bills).toContainText('Commission before credits')
  await expect(bills).toContainText('Commission after credits')
  await expect(bills).toContainText('₱520.02')
  await capture(page, 'management')
  const detailTrigger = main.getByRole('button', { name: 'BuildSphere Construction Supply', exact: true })
  await detailTrigger.click()
  const detail = page.getByRole('dialog', { name: 'Commission statement', exact: true })
  await expect(detail.getByRole('table', { name: 'Statement calculation' })).toContainText('₱500.02')
  await detail.getByRole('tab', { name: 'Activity and emails', exact: true }).click()
  await expect(detail.getByRole('button', { name: 'Resend email', exact: true })).toBeVisible()
  await page.keyboard.press('Escape')
  await expect(detailTrigger).toBeFocused()
  expect(writes).toHaveLength(0)
  await main.getByRole('tab', { name: 'Payments', exact: true }).click()
  const payments = main.getByRole('region', { name: 'Commission records' })
  await expect(payments.getByText('₱290.00', { exact: true })).toBeVisible()
  await expect(payments.getByRole('table', { name: 'Vendor commission payments' })).toContainText('BuildSphere Construction Supply')
  await main.getByText('Export', { exact: true }).click()
  await expect(main.getByRole('button', { name: 'Export PDF', exact: true })).toBeVisible()
  await expect(main.getByRole('button', { name: 'Export CSV', exact: true })).toBeVisible()
  await main.getByText('Export', { exact: true }).click()
  const filtered = page.waitForRequest(request => new URL(request.url()).pathname.endsWith('/commission-transactions') && new URL(request.url()).searchParams.get('statuses') === 'PAID_PARTIALLY_REFUNDED')
  await payments.locator('summary').filter({ hasText: 'Status' }).click()
  await payments.getByLabel('Partially refunded', { exact: true }).check()
  await filtered
  await payments.locator('summary').filter({ hasText: 'Status' }).click()
  await capture(page, 'commission-payments')
  await main.getByRole('tab', { name: 'Xendit cash revenue & remittance', exact: true }).click()
  await expect(main.getByRole('heading', { name: 'Platform Xendit account', exact: true })).toBeVisible()
  await expect(main.getByRole('link', { name: /Open Xendit dashboard/ })).toHaveAttribute('rel', 'noopener noreferrer')
  await expect(main.getByRole('button', { name: 'Last 30 days' })).toBeVisible()
  await capture(page, 'xendit')
})

test('Platform earnings use the attached Xendit summary, payment breakdown and annual collection records', async ({ page }) => {
  await mockFinance(page)
  await page.goto(`${adminUrl}/finance?view=xendit`)
  const main = page.getByRole('main')
  const account = main.getByRole('region', { name: 'Platform Xendit account', exact: true })
  await expect(account.getByRole('heading', { name: 'Platform earnings summary', exact: true })).toBeVisible()
  await expect(account.getByRole('table', { name: 'Net platform earnings calculation' })).toContainText('₱489.52')
  await expect(account.getByRole('table', { name: 'Net platform earnings calculation' })).toContainText('-₱10.50')
  await expect(main.getByRole('heading', { name: 'Commission collections', exact: true })).toHaveCount(0)
  await expect(main.getByRole('table', { name: 'Platform commission cash calculation' })).toHaveCount(0)
  await expect(main.getByRole('link', { name: 'View commission transactions', exact: true })).toHaveCount(0)
  await expect(main.getByRole('heading', { name: 'Remittance and withdrawals', exact: true })).toHaveCount(0)
  await expect(main.getByRole('heading', { name: 'Commission payment channels', exact: true })).toHaveCount(0)
  const threshold = main.getByRole('region', { name: 'Gross-remittance threshold', exact: true })
  await expect(threshold.getByText(/₱500,000.00 per taxable year/)).toBeVisible()
  await expect(threshold.locator('.mp-threshold-period')).toContainText(/Annual · \d{4}/)
  await expect(threshold.getByText('Full taxable year. Not affected by the date filter.', { exact: true })).toBeVisible()
  await expect(threshold.getByText('₱1,000.00', { exact: true }).first()).toBeVisible()
  await expect(threshold.getByText('Annual gross remittances', { exact: true })).toBeVisible()
  await expect(threshold.getByText('₱499,000.00', { exact: true })).toBeVisible()
  await expect(threshold.getByText('Remaining to threshold', { exact: true })).toBeVisible()
  await expect(threshold.getByText('0.2% of annual threshold · ₱500,000.00', { exact: true })).toBeVisible()
  await expect(threshold.getByRole('table', { name: 'Platform annual threshold calculation' })).toContainText('-₱250.00')
  const taxes = main.getByRole('table', { name: 'Platform tax amounts' })
  await expect(taxes.getByRole('row', { name: /^Output VAT on fees/ })).toContainText('₱0.00')
  await expect(taxes.getByRole('row', { name: /^Creditable withholding tax/ })).toContainText('Not available')
  await main.getByRole('button', { name: 'How this is calculated: VAT and withholding', exact: true }).click()
  const taxHelp = page.getByRole('dialog', { name: 'VAT and withholding', exact: true })
  await expect(taxHelp).toContainText('do not supply a confirmed withholding amount')
  await page.keyboard.press('Escape')
  await expect(threshold.getByRole('combobox')).toHaveCount(0)
  await expect(threshold.getByText(/Sworn Declaration|All stores with the same taxpayer identity/)).toHaveCount(0)
  const sections = await account.evaluate(element => {
    const summary = element.querySelector('.mp-finance-provider-summary')!.getBoundingClientRect()
    const header = element.querySelector(':scope > header')!.getBoundingClientRect()
    const breakdown = element.querySelector('.mp-finance-provider-content')!.getBoundingClientRect()
    return { summaryBottom: summary.bottom, headerTop: header.top, breakdownTop: breakdown.top, width: element.getBoundingClientRect().width, breakdownWidth: breakdown.width }
  })
  expect(sections.headerTop).toBeGreaterThanOrEqual(sections.summaryBottom)
  expect(sections.breakdownTop).toBeGreaterThan(sections.headerTop)
  expect(Math.abs(sections.width - sections.breakdownWidth)).toBeLessThan(3)
  expect(await page.evaluate(() => document.documentElement.scrollWidth - window.innerWidth)).toBeLessThanOrEqual(1)
  await capture(page, 'platform-earnings-xendit')
})

test('Marketplace payments stay compact below the persistent geographic analytics workspace', async ({ page }) => {
  await mockFinance(page, true)
  const requests: URL[] = []
  page.on('request', request => { if (request.url().includes('/admin/finance/kpis')) requests.push(new URL(request.url())) })
  await page.goto(`${adminUrl}/analytics?view=payments&area=1300000000&categoryId=steel&from=2026-10-01&to=2026-10-31`)
  const main = page.getByRole('main')
  await expect(main.getByRole('heading', { name: 'Philippine geographic analytics', level: 1 })).toBeVisible()
  await expect(main.getByRole('region', { name: 'Philippines overview', exact: true })).toBeVisible()
  await expect(main.getByRole('tab', { name: 'Marketplace payments', selected: true })).toBeVisible()
  await expect(main.getByText(/Philippines-wide/)).toBeVisible()
  await expect(main.getByRole('heading', { name: 'Payment calculations', exact: true })).toBeVisible()
  const payments = main.getByRole('region', { name: 'Marketplace payment analytics' })
  await expect(payments.locator('.mp-metric-card')).toHaveCount(4)
  const summary = await payments.locator('.mp-analytics-summary').evaluate(element => ({
    width: element.getBoundingClientRect().width,
    cells: [...element.querySelectorAll('.mp-metric-card')].map(cell => ({ top: cell.getBoundingClientRect().top, height: cell.getBoundingClientRect().height })),
  }))
  if (summary.width >= 740) {
    expect(Math.max(...summary.cells.map(cell => cell.top)) - Math.min(...summary.cells.map(cell => cell.top))).toBeLessThan(2)
    expect(Math.max(...summary.cells.map(cell => cell.height))).toBeLessThan(160)
  } else if (summary.width >= 440) expect(summary.cells[0]!.top).toBe(summary.cells[1]!.top)
  await expect(main.getByRole('list', { name: 'Buyer payments per method' }).getByRole('listitem')).toHaveCount(3)
  await expect(main.getByRole('table', { name: 'Net Vendor collections calculation' })).toContainText('₱26,500.00')
  expect(requests.at(-1)!.searchParams.get('from')).toBe('2026-10-01')
  expect(requests.at(-1)!.searchParams.has('area')).toBe(false)
  expect(requests.at(-1)!.searchParams.has('categoryId')).toBe(false)
  await capture(page, 'marketplace-payments')
  await payments.screenshot({ path: test.info().outputPath('compact-marketplace-payments.png') })
  await main.getByRole('button', { name: /Oct 1.*Oct 31/ }).click()
  await page.getByLabel('From', { exact: true }).fill('2026-10-04')
  await page.getByLabel('To', { exact: true }).fill('2026-10-10')
  await page.getByRole('button', { name: 'Apply', exact: true }).click()
  await expect.poll(() => requests.at(-1)?.searchParams.get('from')).toBe('2026-10-04')
  const selected = new URL(page.url())
  expect(selected.searchParams.get('area')).toBe('1300000000')
  expect(selected.searchParams.get('categoryId')).toBe('steel')
  expect(selected.searchParams.get('view')).toBe('payments')
})
