import { expectPortalCardDesign } from './fixtures/card-design'
import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

// Layout evidence for Earnings: cards with their calculation lines, the product list and the top sellers.
// Every API call is mocked with realistic values so the review needs no backend.
const days = Array.from({ length: 15 }, (_, index) => new Date(Date.UTC(2026, 9, 2 + index)).toISOString().slice(0, 10))
const wave = (scale: number) => days.map((_, index) => (index % 5 === 3 ? scale * 2 : index % 4 === 0 ? 0 : Math.round(scale * ((index * 7) % 5) / 4)))
const figures = {
  commercial_sales_centavos: wave(25000), online_collections_centavos: wave(25000), online_refunds_centavos: days.map(() => 0), buyer_processing_fees_centavos: wave(600),
  physical_collections_centavos: days.map(() => 0), provider_charges_centavos: wave(700), simulated_cwt_centavos: wave(80), estimated_remittance_cash_centavos: wave(24000), earned_commission_centavos: days.map(() => 0),
}
const products = [
  ['Portland Cement Type I 40kg', 'Cement and Concrete', 'CEM-40', 6, 53000], ['Deformed Steel Bar 10mm × 6m', 'Steel and Rebar', 'RB-10', 4, 31275], ['Concrete Hollow Block 4"', 'Masonry', null, 3, 17200],
  ['Marine Plywood 3/4" 4×8', 'Lumber and Wood', 'PLY-34', 2, 12850], ['Washed Sand (per cu.m.)', 'Aggregates', null, 2, 9400], ['GI Tie Wire #16', 'Steel and Rebar', 'GI-16', 1, 5400],
  ['Roofing Nails 2.5"', 'Hardware', null, 1, 3100], ['PVC Pipe 2" × 3m', 'Plumbing', 'PVC-2', 1, 2750], ['Common Wire Nails 3"', 'Hardware', null, 1, 2300], ['Cement Mixer Rental', 'Equipment', null, 1, 1800],
  ['Sandpaper 80 grit', 'Hardware', null, 1, 900], ['Paint Brush 4"', 'Paint', null, 1, 650],
].map(([name, category, sku, orders, value], index) => ({ listing_id: `0192a000-0000-7000-8000-0000000000${String(index + 10)}`, name, category, sku, orders, value_centavos: value, vat_centavos: Math.round(Number(value) * 12 / 112) }))
const productValue = products.reduce((sum, item) => sum + item.value_centavos, 0)
const delivery = 42825
const earnings = {
  demo: true, environment: 'TEST', notice: 'Internal Operational Report — Not a Tax Invoice. Cash receipts do not equal taxable income; this does not replace your books or BIR returns.',
  commercial_sales_centavos: productValue + delivery, included_vat_centavos: 9177, online_collections_centavos: productValue + delivery, online_refunds_centavos: 73272, buyer_processing_fees_centavos: 3397,
  physical_collections_centavos: 0, provider_charges_centavos: 3397, simulated_cwt_centavos: 381, estimated_remittance_cash_centavos: 128094, remittance_collections_centavos: 205144, remittance_refunds_centavos: 73272,
  earned_commission_centavos: 0, estimated_commission_centavos: 2000, unpaid_statements_centavos: 0,
  breakdown: {
    sales: { orders: 14, materials_before_discount_centavos: productValue + 5000, vendor_discounts_centavos: 5000, materials_after_discount_centavos: productValue, delivery_centavos: delivery, refunds_centavos: 0 },
    online: { payments: 15, principal_paid_centavos: productValue + delivery + 71000, refunded_principal_centavos: 71000 },
    physical: { records: 0, cash_on_delivery_centavos: 0, in_store_centavos: 0 },
  },
  products: { total: products.length, truncated: false, items: products },
  trend: { granularity: 'DAY', timezone: 'Asia/Manila', from: days[0], to: days.at(-1), days: days.length, points: days.map((date, index) => ({ date, ...Object.fromEntries(Object.entries(figures).map(([key, values]) => [key, values[index]])) })), previous: null },
}

const previousTotals = {
  commercial_sales_centavos: Math.round(earnings.commercial_sales_centavos / 1.124),
  online_collections_centavos: Math.round(earnings.online_collections_centavos / 0.968),
  online_refunds_centavos: 0, buyer_processing_fees_centavos: 0, physical_collections_centavos: 0,
  provider_charges_centavos: 0, simulated_cwt_centavos: 0, estimated_remittance_cash_centavos: earnings.estimated_remittance_cash_centavos, earned_commission_centavos: 0,
}
const previous = { from: '2026-09-17', to: '2026-10-01', totals: previousTotals,
  change_percent: { commercial_sales_centavos: 12.4, online_collections_centavos: -3.2, online_refunds_centavos: null, buyer_processing_fees_centavos: null, physical_collections_centavos: null,
    provider_charges_centavos: null, simulated_cwt_centavos: null, estimated_remittance_cash_centavos: 0, earned_commission_centavos: null } }

async function mock(page: Page, { singleProduct = false, longChannels = false } = {}) {
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'review', full_name: 'Store Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    else if (path.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Sample Supply', lock_version: 1 }, welcome_required: false,
      permissions: ['portal.earnings', 'portal.wallet', 'portal.products', 'catalog.manage', 'finance.view'], verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } } }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'review-csrf-token' }
    else if (path.endsWith('/vendor/finance/earnings')) data = { ...earnings, ...(singleProduct ? { products: { total: 1, truncated: false, items: [{ ...products[0], orders: 14, value_centavos: productValue }] } } : {}), trend: { ...earnings.trend, previous: new URL(route.request().url()).searchParams.has('from') ? previous : null } }
    else if (path.endsWith('/vendor/finance')) data = {
      xendit_connection: { status: 'CONNECTED_TEST', label: 'Connected — TEST', environment: 'TEST', account_contract: 'XENDIT_ACCOUNTS_V2', payment_api: 'XENDIT_PAYMENT_SESSIONS', last_reconciled_at: '2026-10-16T04:00:00Z', note: 'TEST connection from Store Setup. No live funds or production readiness.' },
      online_channels: { fee_note: 'E-wallet transaction fees use the configured DEMO rate.', channels: [
        { code: 'GCASH', display_name: 'GCash', available: true, refund_supported: true, rate_label: '2.3% + VAT on fee' },
        { code: 'MAYA', display_name: 'Maya', available: true, refund_supported: true, rate_label: '1.8% + VAT on fee' },
        { code: 'CARDS', display_name: 'Cards', available: true, refund_supported: true, rate_label: '3.2% + ₱10 + VAT on fee' },
        { code: 'QRPH', display_name: 'QR Ph', available: false, refund_supported: false, unavailable_reason: 'REFUND_ROUTE_UNAVAILABLE', rate_label: '0%' },
        ...(longChannels ? Array.from({ length: 6 }, (_, index) => ({ code: `SAMPLE_${index}`, display_name: `Sample payment channel ${index + 1}`, available: false, refund_supported: false, unavailable_reason: 'REFUND_ROUTE_UNAVAILABLE', rate_label: '0%' })) : []),
      ] }, notices: [],
    }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta: { last_page: 1 }, errors: [] } })
  })
}

async function capture(page: Page, name: string) {
  await expectPortalCardDesign(page)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), 'no horizontal page scroll').toBe(true)
  const directory = resolve('../../.tmp/analytics-review/earnings')
  mkdirSync(directory, { recursive: true })
  // The portal scrolls inside its shell, so the evidence grows the viewport to the content height for one capture.
  const viewport = page.viewportSize()!
  const height = await page.evaluate(() => Math.max(...[...document.querySelectorAll('*')].map(element => element.scrollHeight)))
  await page.setViewportSize({ width: viewport.width, height: Math.min(9000, Math.max(viewport.height, height)) })
  await page.screenshot({ path: resolve(directory, `${viewport.width}-${name}.png`), fullPage: true })
  await page.setViewportSize(viewport)
}

test('Finance overview keeps sales and channels while payout summary and connection move together', async ({ page }) => {
  await mock(page)
  await page.goto('/finance?from=2026-10-02&to=2026-10-16')
  await expect(page.getByRole('region', { name: 'Sales and collections', exact: true })).toBeVisible()
  const summary = page.getByRole('region', { name: 'At a glance', exact: true })
  await expect(summary).toHaveAttribute('data-density', 'compact')
  await expect(page.getByRole('tab', { name: 'Xendit & payment channels' })).toHaveCount(0)
  await expect(page.getByRole('heading', { name: 'Xendit connection', exact: true })).toHaveCount(0)
  await expect(page.getByRole('heading', { name: 'Online payment channels' })).toBeVisible()
  await expect(summary.getByText('Balance', { exact: true })).toHaveCount(0)
  for (const name of ['Earnings calculation', 'Online collections calculation', 'Physical collections calculation']) await expect(page.getByRole('table', { name })).toBeVisible()
  await expect(page.getByRole('table', { name: 'Estimated remittance calculation' })).toHaveCount(0)
  await expect(page.getByText('View financial calculations', { exact: true })).toHaveCount(0)
  await expect(page.getByText('Fees and deductions', { exact: true })).toHaveCount(0)
  await expect(page.getByLabel(/Chart details for/)).toHaveCount(0)
  await capture(page, 'finance-overview')
  const mainBox = (await page.locator('.mp-finance-main').boundingBox())!
  const asideBox = (await page.getByRole('complementary', { name: 'Online payment channels' }).boundingBox())!
  expect(asideBox.y, 'channels follow the financial reports without reserving an empty side column').toBeCloseTo(mainBox.y + mainBox.height + 12, 0)
  expect(asideBox.width, 'channels use the full report width').toBeCloseTo(mainBox.width, 0)
  const summaryBox = (await summary.boundingBox())!
  const metrics = await summary.locator(':scope > dl').all()
  const metricBoxes = await Promise.all(metrics.map(metric => metric.boundingBox()))
  const lastMetric = metricBoxes.at(-1)!
  expect(lastMetric!.x + lastMetric!.width, 'the summary has no unused fourth column').toBeCloseTo(summaryBox.x + summaryBox.width - 13, 0)
  if (summaryBox.width >= 600) {
    for (const box of metricBoxes) expect(box!.y, 'all three metrics share a row').toBeCloseTo(metricBoxes[0]!.y, 0)
  }
  const channelList = page.getByRole('list', { name: 'Configured online channels' })
  const channelRows = await channelList.locator(':scope > li').all()
  if (mainBox.width >= 600) {
    const first = (await channelRows[0]!.boundingBox())!
    const second = (await channelRows[1]!.boundingBox())!
    expect(second.x, 'channels use compact columns on wider screens').toBeGreaterThan(first.x + first.width)
    expect(second.y).toBeCloseTo(first.y, 0)
  }
  await page.getByRole('tab', { name: 'Xendit cash revenue & remittance', exact: true }).click()
  await expect(page).toHaveURL(/from=2026-10-02&to=2026-10-16&section=threshold/)
  const payout = page.getByLabel('Xendit cash revenue estimate', { exact: true })
  await expect(payout).toBeVisible()
  await expect(payout.locator('.mp-kpi-value')).toHaveCSS('color', 'rgb(31, 41, 55)')
  await expect(payout.getByText('Xendit cash revenue', { exact: true })).toHaveCSS('color', 'rgb(71, 85, 105)')
  await expect(page.getByRole('region', { name: 'Xendit connection', exact: true })).toBeVisible()
  const payment = page.getByRole('table', { name: 'Estimated remittance calculation' })
  await expect(payment.getByRole('row', { name: /Order payments after refunds/ })).toContainText('₱1,284.75')
  await expect(payment.getByRole('row', { name: /^Xendit cash revenue/ })).toContainText('₱1,280.94')
  await expect(payment.getByRole('row', { name: /Provider charges|E-wallet transaction fees|Confirmed refunds/ })).toHaveCount(0)
  await expect(payout.getByText('₱2,051.44', { exact: true })).toHaveCount(0)
  const payoutRail = page.getByRole('complementary', { name: 'Xendit cash revenue and connection', exact: true })
  const taxBounds = (await page.locator('.mp-threshold-workspace').boundingBox())!
  const railBounds = (await payoutRail.boundingBox())!
  const connection = payoutRail.getByRole('region', { name: 'Xendit connection', exact: true })
  await expect(connection.getByLabel('Xendit cash revenue estimate', { exact: true })).toBeVisible()
  await expect(payout.getByRole('region', { name: 'At a glance', exact: true })).toHaveAttribute('data-embedded', 'true')
  const dateFilter = payout.getByRole('button', { name: 'Oct 2, 2026 – Oct 16, 2026', exact: true })
  await expect(dateFilter).toBeVisible()
  await expect(page.getByRole('button', { name: 'Oct 2, 2026 – Oct 16, 2026', exact: true })).toHaveCount(1)
  const embeddedBreakdown = connection.getByRole('region', { name: 'Payment breakdown', exact: true })
  await expect(embeddedBreakdown).toHaveAttribute('data-embedded', 'true')
  const connectionBounds = (await connection.boundingBox())!
  const breakdownBounds = (await embeddedBreakdown.boundingBox())!
  const accountActionBounds = (await connection.getByRole('button', { name: 'Open Xendit account (demo)' }).boundingBox())!
  expect(breakdownBounds.y, 'breakdown is below the connection details and account action').toBeGreaterThan(accountActionBounds.y + accountActionBounds.height)
  expect(breakdownBounds.x).toBeCloseTo(connectionBounds.x + 1, 0)
  expect(breakdownBounds.width).toBeCloseTo(connectionBounds.width - 2, 0)
  expect(breakdownBounds.y + breakdownBounds.height, 'breakdown finishes inside the same card').toBeCloseTo(connectionBounds.y + connectionBounds.height - 1, 0)
  const summaryBounds = (await payout.boundingBox())!
  const connectionHeadingBounds = (await connection.getByRole('heading', { name: 'Xendit connection', exact: true }).boundingBox())!
  expect(connectionBounds.x, 'one combined card fills the payout rail').toBeCloseTo(railBounds.x, 0)
  expect(connectionBounds.width).toBeCloseTo(railBounds.width, 0)
  expect(summaryBounds.x).toBeCloseTo(connectionBounds.x + 1, 0)
  expect(summaryBounds.y).toBeCloseTo(connectionBounds.y + 1, 0)
  expect(summaryBounds.width).toBeCloseTo(connectionBounds.width - 2, 0)
  expect(summaryBounds.y + summaryBounds.height, 'summary precedes the connection details inside the same card').toBeLessThan(connectionHeadingBounds.y)
  if (page.viewportSize()!.width >= 1100) {
    expect(railBounds.x, 'payout stack is right of the annual tax details').toBeGreaterThanOrEqual(taxBounds.x + taxBounds.width)
    expect(railBounds.y, 'main details and payout rail align at the top').toBeCloseTo(taxBounds.y, 0)
  } else expect(railBounds.y, 'narrow screens retain one content column').toBeGreaterThanOrEqual(taxBounds.y + taxBounds.height)
  await capture(page, 'xendit-online-payout')
  await dateFilter.click()
  await expect(page.getByRole('dialog', { name: 'Earnings dates', exact: true })).toBeVisible()
  await page.getByRole('button', { name: 'Cancel', exact: true }).click()
  await expect(dateFilter).toBeFocused()
  await page.getByRole('button', { name: 'Open Xendit account (demo)' }).click()
  await expect(page.getByRole('dialog', { name: 'Xendit account demo' })).toContainText('Xendit TEST mode')
  await page.getByRole('button', { name: 'Got it' }).click()
  await expect(page.getByRole('button', { name: 'Open Xendit account (demo)' })).toBeFocused()
})

test('Legacy Earnings URLs retain period, comparisons, chart tables and the combined layout', async ({ page }) => {
  await mock(page)
  await page.goto('/finance/earnings?from=2026-10-02&to=2026-10-16&section=xendit')
  const summary = page.getByRole('region', { name: 'At a glance', exact: true })
  const heading = summary.getByRole('heading', { name: 'Sales overview' })
  const period = summary.getByText('Oct 2 – Oct 16', { exact: true })
  await expect(period).toBeVisible()
  if (page.viewportSize()!.width >= 768) {
    const titleBox = (await heading.boundingBox())!
    const periodBox = (await period.boundingBox())!
    expect(periodBox.x).toBeGreaterThan(titleBox.x + titleBox.width)
    expect(Math.abs(periodBox.y - titleBox.y)).toBeLessThan(8)
  }
  for (const value of ['+12.4%', '-3.2%', 'No comparison']) await expect(summary.getByText(value, { exact: true })).toBeVisible()
  const sales = page.getByRole('region', { name: 'Sales and collections', exact: true })
  await sales.getByText('View as table', { exact: true }).click()
  await expect(sales.getByRole('table', { name: 'Sales and collections per day' })).toBeVisible()
  await expect(page.getByRole('heading', { name: 'Xendit connection', exact: true })).toHaveCount(0)
  await expect(page.getByRole('button', { name: 'Export PDF' })).toBeEnabled()
  await capture(page, 'earnings-trends')
})

test('paired finance reports stay compact before product sales and a long channel list', async ({ page }) => {
  await mock(page, { singleProduct: true, longChannels: true })
  await page.goto('/finance')
  const product = page.getByRole('region', { name: 'Product sales value', exact: true })
  await expect(product).toBeVisible()
  await expect(page.getByRole('region', { name: 'Xendit cash revenue', exact: true })).toHaveCount(0)
  const main = (await page.locator('.mp-finance-main').boundingBox())!
  let bottom: number | undefined
  for (const [chart, calculation] of [['Sales and collections', 'Financial calculations'], ['Deductions and commission', 'Deductions and fees']]) {
    const chartBox = (await page.getByRole('region', { name: chart, exact: true }).boundingBox())!
    const calculationBox = (await page.getByRole('region', { name: calculation, exact: true }).boundingBox())!
    expect(chartBox.x).toBeCloseTo(main.x, 0)
    if (bottom !== undefined) expect(chartBox.y - bottom, 'report pairs retain the shared 12px gap').toBeCloseTo(12, 0)
    if (main.width >= 900) {
      expect(calculationBox.y, 'the chart and its calculation share a row').toBeCloseTo(chartBox.y, 0)
      expect(calculationBox.x - chartBox.x - chartBox.width, 'paired cards have a 12px gap').toBeCloseTo(12, 0)
      expect(calculationBox.height, 'paired cards align at the bottom').toBeCloseTo(chartBox.height, 0)
      expect(calculationBox.x + calculationBox.width).toBeCloseTo(main.x + main.width, 0)
    } else {
      expect(calculationBox.x).toBeCloseTo(main.x, 0)
      expect(calculationBox.y - chartBox.y - chartBox.height, 'narrow screens stack each pair in reading order').toBeCloseTo(12, 0)
      expect(calculationBox.width).toBeCloseTo(main.width, 0)
    }
    bottom = calculationBox.y + calculationBox.height
  }
  const productBox = (await product.boundingBox())!
  expect(productBox.y - bottom!, 'product sales follow both report pairs without a gap').toBeCloseTo(12, 0)
  expect(productBox.x).toBeCloseTo(main.x, 0)
  expect(productBox.width).toBeCloseTo(main.width, 0)
  await expect(page.getByRole('region', { name: 'How these figures are calculated', exact: true })).toHaveCount(0)
  await capture(page, 'finance-no-gaps')
})

test('each figure opens dashboard-style calculation help without moving its card', async ({ page }) => {
  await mock(page)
  await page.goto('/finance')
  const summary = page.getByRole('region', { name: 'At a glance', exact: true })
  await expect(summary).toBeVisible()
  const height = (await summary.boundingBox())!.height
  for (const title of ['Earnings', 'Online collections', 'Physical collections']) {
    const trigger = summary.getByRole('button', { name: `How this is calculated: ${title}`, exact: true })
    await trigger.click()
    const dialog = page.getByRole('dialog', { name: title, exact: true })
    await expect(dialog).toBeVisible()
    await expect(dialog.getByText('How this is calculated', { exact: true })).toBeVisible()
    const box = (await dialog.boundingBox())!
    const viewport = page.viewportSize()!
    expect(box.x).toBeGreaterThanOrEqual(12)
    expect(box.y).toBeGreaterThanOrEqual(12)
    expect(box.x + box.width).toBeLessThanOrEqual(viewport.width - 12)
    expect(box.y + box.height).toBeLessThanOrEqual(viewport.height - 12)
    expect((await summary.boundingBox())!.height).toBeCloseTo(height, 0)
    if (title === 'Earnings') {
      const directory = resolve('../../.tmp/analytics-review/earnings')
      mkdirSync(directory, { recursive: true })
      await page.screenshot({ path: resolve(directory, `${viewport.width}-calculation-help.png`) })
    }
    await page.keyboard.press('Escape')
    await expect(dialog).toHaveCount(0)
    await expect(trigger).toBeFocused()
  }
  const breakdown = page.getByLabel('Earnings summary', { exact: true })
  await breakdown.getByRole('button', { name: 'How this is calculated: Online collections', exact: true }).click()
  await expect(page.getByRole('dialog', { name: 'Online collections', exact: true })).toContainText('original payment date')
  await page.getByRole('button', { name: 'Close calculation explanation' }).click()
  await page.getByRole('region', { name: 'Product sales value', exact: true }).getByRole('button', { name: 'How this is calculated: Product sales value', exact: true }).click()
  await expect(page.getByRole('dialog', { name: 'Product sales value', exact: true })).toContainText('Product sales value + delivery − completed refunds = earnings')
  await page.getByRole('heading', { name: 'Product sales value', exact: true }).first().click()
  await expect(page.getByRole('dialog')).toHaveCount(0)
})
