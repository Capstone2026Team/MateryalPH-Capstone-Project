import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

// Layout evidence for Admin Transactions and finance: Platform earnings analytics and Channel fees.
// Every API call is mocked with realistic values so the review needs no backend. The Admin portal is served on port 4174.
const days = Array.from({ length: 30 }, (_, index) => new Date(Date.UTC(2026, 8, 17 + index)).toISOString().slice(0, 10))
const spread = (scale: number, offset: number) => days.map((_, index) => ((index + offset) % 6 === 0 ? 0 : Math.round(scale * (1 + ((index * 5 + offset) % 7) / 4))))
const earned = spread(1800, 1), credits = days.map((_, index) => (index % 11 === 4 ? 600 : 0)), collected = spread(1400, 3), refunded = days.map((_, index) => (index % 13 === 7 ? 500 : 0))
const sum = (values: number[]) => values.reduce((total, value) => total + value, 0)
const point = (index: number) => ({ period: days[index], earned_centavos: earned[index], credits_centavos: credits[index], collected_centavos: collected[index], refunded_centavos: refunded[index],
  net_earnings_centavos: Math.round((earned[index]! - credits[index]!) * 0.89) - (collected[index]! > 0 ? 35 : 0) })
const trend = days.map((_, index) => point(index))
const netEarnings = sum(trend.map(item => item.net_earnings_centavos))
const item = (key: string, label: string, value: number, definition: string) => ({ key, label, value_centavos: value, definition })
const finance = [
  item('assessed_cwt', 'Assessed CWT (simulated)', 381, 'Posted FIN-05 withholding W. Never platform revenue.'), item('reported_deductions', 'Provider-reported deductions', 0, 'Imported simulated deductions.'),
  item('earned_commission', 'Total commission earned', sum(earned), 'Original 2% commission earned at completion in this period, before approved credits.'),
  item('fee_credits', 'Approved commission credits', sum(credits), 'Commission reversals approved in this period.'),
  item('net_commission', 'Net commission earned', sum(earned) - sum(credits), 'Earnings less approved credits.'),
  item('platform_revenue', 'Commission revenue, excluding VAT', netEarnings + 1130, 'Posted fee revenue after approved credits.'),
  item('processing_expense', 'Platform processing costs', 1130, 'Recorded charges on platform commission payments.'), item('net_platform_earnings', 'Net platform earnings', netEarnings, 'Revenue less processing costs.'),
  item('fee_vat', 'Output VAT on fees', 5120, 'VAT portion of earned fees.'), item('billed', 'Issued commission bills', sum(earned) - sum(credits), 'Approved statement charges less credits.'),
  item('collected', 'Collected commissions', sum(collected), 'Verified payments allocated once to commission bills.'), item('refunded_commissions', 'Refunded commissions', sum(refunded), 'Confirmed returns of collected commissions.'),
  item('net_collected', 'Net collected commissions', sum(collected) - sum(refunded), 'Collected less confirmed refunds.'), item('pending_commissions', 'Pending commissions', 18400, 'Current unpaid earned fees.'),
  item('receivables', 'Outstanding receivables', 12600, 'Issued, unpaid statement balances.'), item('overdue', 'Overdue receivables', 4100, 'Outstanding balances past their due date.'),
]
const kpis = { label: 'Recorded transactions', scenario: 'Earnings and cash use event dates; debt uses statement issue dates and current balances. Dates are Asia/Manila.', period: { from: null, to: null },
  commerce: [], finance, counts: { unreconciled_remittances: 0, draft_statements: 1, pending_commission_credits: 0 }, trend, trend_granularity: 'DAY' }
const channels = [['GCASH', 'GCash', 23000, 0, true, true], ['GRABPAY', 'GrabPay', 20000, 0, true, true], ['PAYMAYA', 'Maya', 18000, 0, true, true], ['SHOPEEPAY', 'ShopeePay', 20000, 0, true, true], ['CARD', 'Credit or debit card', 32000, 1000, true, true],
  ['BANK', 'Bank transfer', 0, 0, false, false], ['DD', 'Online banking direct debit', 0, 0, false, false], ['OTC', 'Over-the-counter cash', 0, 0, false, false], ['QRPH', 'QR Ph', 0, 0, false, false]]
  .map(([code, display_name, rate_ppm, fixed_centavos, refund_supported, enabled]) => ({ code, display_name, kind: 'ONLINE', version: 1, rate_ppm, fixed_centavos, fee_vat_basis_points: 1200, rate_includes_vat: false, refund_supported, enabled,
    source_type: 'PUBLISHED_RATE', source_reference: 'Xendit published Philippine rates retrieved 2026-10-02 for the capstone TEST schedule; treated as VAT-exclusive with 12% VAT on the fee. DEMO rate — validate against the active Xendit agreement before production.' }))

async function mock(page: Page) {
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'review', full_name: 'Platform Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'review-csrf-token' }
    else if (path.endsWith('/admin/finance/kpis')) data = kpis
    else if (path.endsWith('/admin/finance/channel-fees')) data = channels
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta: { last_page: 1 }, errors: [] } })
  })
}

async function capture(page: Page, name: string) {
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), 'no horizontal page scroll').toBe(true)
  const directory = resolve('../../docs/design/evidence/admin-finance')
  mkdirSync(directory, { recursive: true })
  // The portal scrolls inside its shell, so the evidence grows the viewport to the content height for one capture.
  const viewport = page.viewportSize()!
  const height = await page.evaluate(() => Math.max(...[...document.querySelectorAll('*')].map(element => element.scrollHeight)))
  await page.setViewportSize({ width: viewport.width, height: Math.min(9000, Math.max(viewport.height, height)) })
  await page.screenshot({ path: resolve(directory, `${viewport.width}-${name}.png`), fullPage: true })
  await page.setViewportSize(viewport)
}

test('Admin Platform earnings analytics and Channel fees lay out cleanly', async ({ page }) => {
  await mock(page)
  await page.goto('http://127.0.0.1:4174/finance')
  await expect(page.getByRole('heading', { name: 'Platform earnings analytics' })).toBeVisible()
  // Each KPI keeps its calculation behind a View breakdown disclosure.
  const toggles = page.locator('summary', { hasText: 'View breakdown' })
  await expect(toggles).toHaveCount(4)
  for (let index = 0; index < 4; index++) await toggles.nth(index).click()
  for (const name of ['Net platform earnings calculation', 'Net commission earned calculation', 'Net collected commissions calculation', 'Outstanding receivables calculation']) await expect(page.getByRole('table', { name })).toBeVisible()
  await expect(page.locator('dl[aria-label="Platform earnings summary"]')).toBeVisible()
  await capture(page, 'platform-earnings')
  // Channel fees is a Payments and refunds sub-view.
  await page.goto('http://127.0.0.1:4174/finance?view=channels')
  const link = page.getByRole('link', { name: /Open Xendit dashboard/ })
  await expect(link).toHaveAttribute('href', 'https://dashboard.xendit.co/')
  await expect(link).toHaveAttribute('target', '_blank')
  await capture(page, 'channel-fees')
})
