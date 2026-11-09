import { expectPortalCardDesign } from './fixtures/card-design'
import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'
import { adminInsights, vendorInsights } from './fixtures/dashboard-insights'

function platformCommissionFigures(from: string, to: string, scale = 1) {
  const days = Math.round((Date.parse(to) - Date.parse(from)) / 86_400_000) + 1
  const monthly = days > 92
  const periods = monthly ? [from.slice(0, 7) + '-01', to.slice(0, 7) + '-01'] : Array.from({ length: days }, (_, index) => new Date(Date.parse(from) + index * 86_400_000).toISOString().slice(0, 10))
  return {
    label: 'Recorded transactions', scenario: 'Commission payments and refunds by their event dates in Asia/Manila.', period: { from, to }, commerce: [], counts: {},
    finance: [
      { key: 'collected', label: 'Collected commissions', value_centavos: 42000 * scale, definition: 'Verified commission allocations.' },
      { key: 'refunded_commissions', label: 'Refunded commissions', value_centavos: 3600 * scale, definition: 'Confirmed fee refunds.' },
      { key: 'net_collected', label: 'Net collected commissions', value_centavos: 38400 * scale, definition: 'Payments less refunds.' },
      { key: 'net_platform_earnings', label: 'Net platform earnings', value_centavos: 987650, definition: 'Accrued revenue less costs.' },
    ],
    trend_granularity: monthly ? 'MONTH' : 'DAY',
    trend: periods.map((period, index) => ({ period, collected_centavos: index === Math.min(18, periods.length - 1) ? 42000 * scale : 0, refunded_centavos: index === Math.min(20, periods.length - 1) ? 3600 * scale : 0,
      earned_centavos: 888000, credits_centavos: 0, net_earnings_centavos: 987650, gmv_centavos: 100000000, buyer_payments_centavos: 90000000, buyer_refunds_centavos: 0 })),
  }
}

async function mockDashboard(page: Page, portal: 'vendor' | 'admin', restricted = false, empty: boolean | 'mixed' = false, productAnalytics = false, singleProduct = false) {
  const reads = { vendor: 0, admin: 0, insights: [] as URL[], finance: [] as URL[] }
  const today = await page.evaluate(() => new Date(Date.now() + 8 * 60 * 60 * 1000).toISOString().slice(0, 10))
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    const path = url.pathname
    if (path.endsWith('/onboarding')) reads.vendor += 1
    if (path.endsWith('/admin/dashboard')) reads.admin += 1
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'dashboard-review', full_name: 'Dashboard Reviewer', account_type: portal.toUpperCase(), account_status: 'ACTIVE', role: portal === 'admin' ? 'ADMIN_SUPERADMIN' : 'OWNER' }
    else if (path.endsWith('/onboarding')) data = {
      step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1,
      organization: { store_name: reads.vendor > 1 ? 'Updated Supply' : 'Sample Supply', lock_version: 1 },
      permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit', ...(productAnalytics ? ['catalog.manage'] : [])], welcome_required: false,
      verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'NO_ACTIVE_LISTINGS', readiness: { ready: true, blockers: [] } },
    }
    else if (path.endsWith('/admin/dashboard')) data = {
      generated_at: '2026-09-30T06:00:00Z', active_vendors: restricted ? null : 23 + reads.admin,
      inactive_vendors: restricted ? null : 8, active_buyers: restricted ? null : 128,
      pending_document_reviews: restricted ? null : 6, audit_events: restricted ? null : 340,
      can_view_audit: !restricted,
      queues: restricted ? [] : [
        { key: 'documents', label: 'Business document reviews', group: 'Vendor Management', count: 6, href: '/vendor-verification', oldest_at: '2026-11-02T03:00:00Z', description: 'Submitted Vendor business documents.' },
        { key: 'compliance', label: 'Product compliance reviews', group: 'Compliance and quality', count: 4, href: '/product-compliance', oldest_at: '2026-11-02T06:00:00Z', description: 'Product documents awaiting review.' },
        { key: 'disputes', label: 'Open disputes', group: 'Disputes and appeals', count: 2, href: '/disputes', oldest_at: '2026-11-02T08:00:00Z', description: 'Disputes awaiting an Admin decision.' },
      ],
    }
    else if (path.endsWith('/admin/dashboard/audit')) data = []
    else if (path.endsWith('/admin/integrations')) {
      if (restricted) {
        await route.fulfill({ status: 403, json: { data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED', message: 'Integration access is required.' }] } })
        return
      }
      data = { generated_at: '2026-11-06T04:00:00Z', environment: { app: 'LOCAL' }, queues: {}, scheduled_tasks: [], analytics: {}, can_retry: false,
        integrations: [
          ['payments', 'Xendit payments and webhooks', 'SIMULATED'], ['accounts', 'Xendit sub-account onboarding', 'HEALTHY'],
          ['maps', 'Google Maps, Places and Routes', 'HEALTHY'], ['signin', 'Google sign-in', 'NOT_CONFIGURED'],
          ['email', 'Email delivery', 'DEGRADED'], ['push', 'Push notifications', 'HEALTHY'], ['files', 'Private file storage and scanning', 'HEALTHY'],
          ['reverb', 'Laravel Reverb realtime', 'HEALTHY'], ['ocr', 'OCR assistance', 'NOT_CONFIGURED'], ['registers', 'DTI-BPS PS and ICC registers', 'HEALTHY'],
        ].map(([key, label, status]) => ({ key, label, status, detail: 'Synthetic monitoring fixture.', ...(key === 'payments' ? { environment: 'Xendit TEST' } : {}) })) }
    }
    else if (path.endsWith('/admin/finance/kpis')) {
      reads.finance.push(url)
      if (restricted) {
        await route.fulfill({ status: 403, json: { data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED', message: 'Finance access is required.' }] } })
        return
      }
      data = platformCommissionFigures(url.searchParams.get('from')!, url.searchParams.get('to')!, url.searchParams.get('to')! < today ? 0.5 : 1)
    }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'dashboard-review-csrf-token' }
    else if (path.endsWith('/vendor/dashboard/insights')) {
      const insights = vendorInsights()
      if (singleProduct) {
        insights.period = { ...insights.period, from: '2026-10-07', to: '2026-11-05' }
        insights.orders.products.top = [{ name: 'Rerolled steel bar', category: 'Steel and Reinforcement', orders: 4, buyers: 2, value_centavos: 2940650 }]
        insights.orders.products.categories = [{ category: 'Steel and Reinforcement', orders: 4, value_centavos: 2940650 }]
        insights.orders.products.sales_breakdown = { product_sales_centavos: 2940650, delivery_centavos: 93075, refunds_centavos: 0, net_sales_centavos: 3033725 }
        insights.orders.kpis.net_sales_centavos = { value: 3033725, previous: 0, change_percent: null }
      }
      if (empty === true) {
        insights.orders.series = []
        insights.orders.pipeline = []
        insights.orders.incoming = []
        insights.orders.forecast.orders = { ...insights.orders.forecast.orders, state: 'INSUFFICIENT_DATA', points: [] }
        insights.orders.forecast.sales = { ...insights.orders.forecast.sales!, state: 'INSUFFICIENT_DATA', points: [] }
        insights.orders.products.categories = []
        insights.orders.products.top = []
        insights.orders.products.segments = { ...insights.orders.products.segments, state: 'INSUFFICIENT_DATA', points: [], segments: [] }
        insights.orders.products.basket_rules.rules = []
        insights.stock = { variants: 0, in_stock: 0, limited_stock: 0, out_of_stock: 0, attention: [] }
        insights.performance.history = []
      } else if (empty === 'mixed') {
        insights.orders.series.forEach(point => { point.gross_sales_centavos = null; point.sales_average_centavos = null; point.net_sales_centavos = null; point.refunds_centavos = null; point.cancellation_deductions_centavos = null })
        insights.orders.forecast.sales = { ...insights.orders.forecast.sales!, state: 'INSUFFICIENT_DATA', points: [] }
      }
      data = insights
    }
    else if (path.endsWith('/admin/dashboard/insights')) {
      reads.insights.push(url)
      if (restricted) data = { generated_at: '2026-09-30T06:00:00Z', access: { marketplace: false, vendor_health: false }, definitions: {}, marketplace: null, marketplace_unavailable_reason: null, vendor_health: null }
      else {
        const insights = adminInsights()
        const from = url.searchParams.get('from') ?? insights.marketplace.period.from
        const to = url.searchParams.get('to') ?? insights.marketplace.period.to
        const previous = to < today
        insights.marketplace.period = { ...insights.marketplace.period, from, to, days: (Date.parse(to) - Date.parse(from)) / 86_400_000 + 1 }
        insights.marketplace.kpis.gross_gmv_centavos.value = previous ? 1_000_000 : 1_124_000
        insights.marketplace.kpis.net_gmv_centavos.value = previous ? 1_195_600_000 : 2_391_200_000
        insights.marketplace.kpis.order_volume.value = previous ? 125 : 121
        data = insights
      }
    }
    await route.fulfill({ json: { data, meta: { last_page: 1 }, errors: [] } })
  })
  return reads
}

async function capture(page: Page, name: string) {
  await expectPortalCardDesign(page)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const directory = resolve('../../.tmp/dashboard-card-layout')
  mkdirSync(directory, { recursive: true })
  await page.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${name}.png`), fullPage: true })
}

async function captureSummary(page: Page, portal: 'admin' | 'vendor') {
  if (![320, 1440].includes(page.viewportSize()!.width)) return
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const directory = resolve('../../.tmp/summary-trends')
  mkdirSync(directory, { recursive: true })
  await page.getByRole('region', { name: 'At a glance', exact: true }).screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${portal}-summary.png`) })
  if (page.viewportSize()!.width === 320) {
    await page.evaluate(() => window.scrollTo(0, 0))
    await page.screenshot({ path: resolve(directory, `320-${portal}-dashboard.png`), fullPage: true })
  }
}

async function expectEqualCardRows(page: Page) {
  const rows = await page.locator('main .mp-dashboard-panel').evaluateAll(panels => {
    const rows = new Map<string, { title: string | null; height: number }[]>()
    for (const panel of panels) {
      const bounds = panel.getBoundingClientRect()
      if (bounds.width === 0 || bounds.height === 0 || !panel.parentElement) continue
      if (panel.parentElement.classList.contains('mp-product-patterns')) continue
      const key = `${Array.from(document.querySelectorAll('*')).indexOf(panel.parentElement)}:${Math.round(bounds.top)}`
      const row = rows.get(key) ?? []
      row.push({ title: panel.getAttribute('aria-label'), height: bounds.height })
      rows.set(key, row)
    }
    return [...rows.values()].filter(row => row.length > 1)
  })
  for (const row of rows) expect(Math.max(...row.map(card => card.height)) - Math.min(...row.map(card => card.height)), `Equal card heights: ${row.map(card => card.title).join(', ')}`).toBeLessThanOrEqual(1)
}

test('Vendor product cards keep top-aligned lists and stable heights as sales grow', async ({ page }) => {
  await mockDashboard(page, 'vendor', false, false, true, true)
  await page.goto('/dashboard?from=2026-10-07&to=2026-11-05')
  const categories = page.getByRole('region', { name: 'Sales by category', exact: true })
  const top = page.getByRole('region', { name: 'Top products', exact: true })
  await expect(categories.getByRole('listitem')).toContainText('₱29,406.50')
  await expect(categories.getByRole('table')).toHaveCount(0)
  await expect(top.getByRole('listitem')).toContainText('₱29,406.50')
  await expect(top.getByRole('link', { name: 'Product analytics' })).toHaveAttribute('href', '/analytics/products?from=2026-10-07&to=2026-11-05')
  const initialHeights = await Promise.all([categories, top].map(async card => (await card.boundingBox())!.height))
  for (const card of [categories, top]) {
    const body = card.locator('.mp-dashboard-panel-body')
    const bodyBounds = (await body.boundingBox())!
    const contentBounds = (await body.locator(':scope > :first-child').boundingBox())!
    expect(contentBounds.y - bodyBounds.y).toBeLessThanOrEqual(24)
  }
  if (page.viewportSize()!.width >= 768) {
    const activity = page.getByRole('region', { name: 'Order activity', exact: true })
    const performance = page.getByRole('region', { name: 'Store performance', exact: true })
    for (const [card, neighbor] of [[categories, activity], [top, performance]]) {
      const bounds = (await card!.boundingBox())!
      const neighborBounds = (await neighbor!.boundingBox())!
      expect(Math.abs(bounds.y - neighborBounds.y)).toBeLessThanOrEqual(1)
      expect(Math.abs(bounds.height - neighborBounds.height)).toBeLessThanOrEqual(1)
    }
  }
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBeTruthy()
  const directory = resolve('../../.tmp/analytics-review/dashboard-top-scroll')
  mkdirSync(directory, { recursive: true })
  await categories.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-categories.png`) })
  await top.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-top-products.png`) })
  const crowded = vendorInsights()
  crowded.orders.products.categories = Array.from({ length: 6 }, (_, index) => ({ category: `Category ${index + 1}: steel and reinforcement, construction materials and building supplies`, orders: 10 + index, value_centavos: index === 5 ? 440650 : 500000 }))
  crowded.orders.products.top = Array.from({ length: 8 }, (_, index) => ({ name: `Product ${index + 1}: reinforced construction material in multiple sizes and lengths`, category: 'Steel and Reinforcement', orders: 20 - index, buyers: 10 - index, value_centavos: 200000 - index * 10000 }))
  await page.route('**/api/v1/vendor/dashboard/insights**', route => route.fulfill({ json: { data: crowded, meta: {}, errors: [] } }))
  await page.reload()
  await expect(categories.getByRole('listitem')).toHaveCount(6)
  await expect(top.getByRole('listitem')).toHaveCount(5)
  for (const [index, card] of [categories, top].entries()) {
    const dimensions = await card.evaluate(panel => {
      const body = panel.querySelector('.mp-dashboard-panel-body')!
      const styles = getComputedStyle(body)
      return { card: panel.getBoundingClientRect().height, body: body.getBoundingClientRect().height, scroll: body.scrollHeight, minHeight: styles.minHeight, height: styles.height, containment: styles.contain, overflow: styles.overflowY }
    })
    expect(Math.abs(dimensions.card - initialHeights[index]!), JSON.stringify({ initial: initialHeights[index], ...dimensions })).toBeLessThanOrEqual(1)
    await card.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${index === 0 ? 'categories' : 'top-products'}-populated.png`) })
  }
  const categoryList = categories.getByRole('region', { name: 'Sales by category list', exact: true })
  expect(await categoryList.evaluate(element => element.scrollHeight > element.clientHeight)).toBe(true)
  await categoryList.focus()
  await page.keyboard.press('PageDown')
  await expect.poll(() => categoryList.evaluate(element => element.scrollTop)).toBeGreaterThan(0)
  await page.keyboard.press('End')
  await expect(categoryList.getByText(/^Category 6:/)).toBeInViewport()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
})

for (const empty of [false, true]) test(`Vendor product insights are compact in Overview (${empty ? 'insufficient data' : 'populated'})`, async ({ page }) => {
  await mockDashboard(page, 'vendor', false, empty, true)
  await page.goto('/dashboard')
  const products = page.getByRole('region', { name: 'Top products', exact: true })
  const segments = page.getByRole('region', { name: 'Product demand segments', exact: true })
  const together = page.getByRole('region', { name: 'Frequently ordered together', exact: true })
  await expect(products.getByRole('link', { name: 'Product analytics' })).toHaveAttribute('href', '/analytics/products?from=2026-09-10&to=2026-10-09')
  const performanceLink = page.getByRole('region', { name: 'Store performance', exact: true }).getByRole('link', { name: 'View performance' })
  await expect(performanceLink).toHaveAttribute('href', '/performance')
  await expect(performanceLink).toBeVisible()
  expect((await performanceLink.boundingBox())!.height).toBeGreaterThanOrEqual(44)
  for (const card of [products, segments, together]) await expect(card).toBeVisible()
  await expect(page.getByRole('tab', { name: 'Sales & Revenue', exact: true })).toHaveCount(0)
  if (empty) {
    await expect(products.getByText('No product sales in this period.', { exact: true })).toBeVisible()
    await expect(together.getByText(/No pattern yet/)).toBeVisible()
    for (const card of [segments, together]) expect((await card.boundingBox())!.height).toBeLessThan(350)
    expect(await segments.locator('[data-chart-empty="scatter"] > svg').evaluate(element => element.getBoundingClientRect().height)).toBe(96)
    expect(await together.locator('[data-chart-empty="horizontal"] > svg').evaluate(element => element.getBoundingClientRect().height)).toBe(80)
  } else {
    await expect(products.getByRole('listitem')).toHaveCount(5)
    await expect(products.getByRole('listitem').first()).toContainText('₱98,200.00')
    const graph = segments.getByRole('img', { name: /Products by orders and distinct Buyers/ })
    await graph.focus()
    await page.keyboard.press('Home')
    await expect(segments.getByRole('status')).toContainText('Product')
    await page.keyboard.press('Escape')
    await graph.evaluate(element => (element as HTMLElement).blur())
    await expect(together.getByRole('listitem')).toHaveCount(3)
    await expect(together.getByText('82% confidence', { exact: true })).toBeVisible()
  }
  const [performanceBounds, productBounds] = await page.locator('.mp-analytics-overview > section:is([aria-label="Store performance"], [aria-label="Top products"])').evaluateAll(cards => cards.map(card => {
    const { x, y, width, height } = card.getBoundingClientRect()
    return { x, y, width, height }
  }))
  if (page.viewportSize()!.width >= 768) {
    expect(Math.abs(performanceBounds!.y - productBounds!.y)).toBeLessThanOrEqual(1)
    expect(performanceBounds!.x + performanceBounds!.width).toBeLessThan(productBounds!.x)
    expect(Math.abs(productBounds!.height - performanceBounds!.height)).toBeLessThanOrEqual(1)
  } else {
    expect(productBounds!.y).toBeGreaterThanOrEqual(performanceBounds!.y + performanceBounds!.height)
  }
  const patternBounds = await page.locator('.mp-product-patterns > .mp-dashboard-panel').evaluateAll(cards => cards.map(card => {
    const { x, y, width, height } = card.getBoundingClientRect()
    return { x, y, width, height }
  }))
  if (page.viewportSize()!.width >= 768) {
    expect(Math.abs(patternBounds[0]!.y - patternBounds[1]!.y)).toBeLessThanOrEqual(1)
    expect(patternBounds[0]!.x + patternBounds[0]!.width).toBeLessThan(patternBounds[1]!.x)
  }
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const directory = resolve('../../.tmp/product-overview')
  mkdirSync(directory, { recursive: true })
  const overview = page.locator('.mp-product-overview')
  const cards = page.locator('.mp-analytics-overview')
  const captureHeight = Math.ceil(Math.max((await overview.boundingBox())!.height, (await cards.boundingBox())!.height) + 160)
  await page.setViewportSize({ width: page.viewportSize()!.width, height: Math.max(page.viewportSize()!.height, captureHeight) })
  await overview.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${empty ? 'empty' : 'populated'}.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
  await cards.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-cards-${empty ? 'empty' : 'populated'}.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
})

test('Vendor demand points show product details on hover, touch and keyboard focus', async ({ page }) => {
  await mockDashboard(page, 'vendor')
  const insights = vendorInsights()
  insights.orders.products.segments.points = [
    { name: 'Deformed steel bar 10 mm', orders: 44, buyers: 27, segment: 'High demand' },
    { name: 'Washed sand', orders: 18, buyers: 12, segment: 'Moderate demand' },
    { name: 'Common nails 3 inches', orders: 3, buyers: 2, segment: 'Low demand' },
    { name: 'Portland cement Type 1', orders: 61, buyers: 38, segment: 'High demand' },
  ]
  await page.route('**/api/v1/vendor/dashboard/insights*', route => route.fulfill({ json: { data: insights, meta: {}, errors: [] } }))
  await page.goto('/dashboard')
  const panel = page.getByRole('region', { name: 'Product demand segments', exact: true })
  const chart = panel.getByRole('img', { name: /Products by orders and distinct Buyers/ })
  const point = chart.locator('[data-scatter-point]').filter({ has: page.locator('circle[fill="transparent"]') }).nth(2)
  await point.scrollIntoViewIfNeeded()
  const before = (await panel.boundingBox())!
  if (page.viewportSize()!.width <= 390) await point.tap()
  else await point.hover()
  const tooltip = page.getByRole('tooltip')
  await expect(tooltip.getByText('Deformed steel bar 10 mm', { exact: true })).toBeVisible()
  await expect(tooltip.getByText('High demand', { exact: true })).toBeVisible()
  await expect(tooltip.getByText('44', { exact: true })).toBeVisible()
  await expect(tooltip.getByText('27', { exact: true })).toBeVisible()
  expect(await tooltip.evaluate(element => element.matches(':popover-open'))).toBe(true)
  const bounds = (await tooltip.boundingBox())!
  expect(bounds.x).toBeGreaterThanOrEqual(12)
  expect(bounds.y).toBeGreaterThanOrEqual(12)
  expect(bounds.x + bounds.width).toBeLessThanOrEqual(page.viewportSize()!.width - 11)
  expect(bounds.y + bounds.height).toBeLessThanOrEqual(page.viewportSize()!.height - 11)
  expect((await panel.boundingBox())!.height).toBe(before.height)
  if (page.viewportSize()!.width > 390) {
    await tooltip.hover()
    await expect(tooltip).toBeVisible()
  }
  const directory = resolve('../../.tmp/demand-point-tooltip')
  mkdirSync(directory, { recursive: true })
  await page.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-hover.png`) })
  await page.keyboard.press('Escape')
  await expect(tooltip).toHaveCount(0)
  await chart.focus()
  await page.keyboard.press('Home')
  await expect(tooltip.getByText('Common nails 3 inches', { exact: true })).toBeVisible()
  await page.keyboard.press('End')
  await expect(tooltip.getByText('Portland cement Type 1', { exact: true })).toBeVisible()
  await page.keyboard.press('Tab')
  await expect(tooltip).toHaveCount(0)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
})

test('Vendor secondary dashboard cards explain calculations without resizing or overflowing', async ({ page }) => {
  test.setTimeout(60_000)
  await mockDashboard(page, 'vendor')
  await page.goto('/dashboard')
  const directory = resolve('../../.tmp/dashboard-secondary-cards')
  mkdirSync(directory, { recursive: true })
  for (const [tab, titles] of [
    ['Overview', ['Earnings', 'Gross sales', 'Average order value', 'Orders confirmed']],
    ['Traffic & Volume', ['Demand funnel', 'Order mix', 'Requests and confirmations per day']],
    ['Disputes & Quality', ['Open cases', 'Dispute rate', 'Validated returns', 'Fulfillment issues reported', 'Cases filed per day', 'Issue types', 'Open cases by status', 'Cancellation']],
  ] as const) {
    await page.getByRole('tab', { name: tab, exact: true }).click()
    for (const title of titles) {
      const trigger = page.getByRole('button', { name: `How this is calculated: ${title}`, exact: true })
      const card = trigger.locator('xpath=ancestor::*[contains(concat(" ", normalize-space(@class), " "), " mp-metric-card ") or contains(concat(" ", normalize-space(@class), " "), " mp-dashboard-panel ")][1]')
      await trigger.scrollIntoViewIfNeeded()
      const before = (await card.boundingBox())!
      expect((await trigger.boundingBox())!.height).toBeGreaterThanOrEqual(44)
      expect((await trigger.boundingBox())!.width).toBeGreaterThanOrEqual(44)
      await expect(trigger).toHaveText('')
      if (await card.evaluate(element => element.classList.contains('mp-metric-card'))) {
        expect(await trigger.evaluate(element => Boolean(element.closest('.mp-kpi-label')))).toBe(true)
        await expect(card.locator('.mp-kpi-icon > svg')).toHaveCount(1)
        const bounds = (await trigger.boundingBox())!
        expect(before.x + before.width - bounds.x - bounds.width).toBeLessThanOrEqual(17)
        expect(bounds.y - before.y).toBeLessThanOrEqual(17)
      } else {
        expect(await trigger.evaluate(element => element.parentElement?.matches('.mp-card-header'))).toBe(true)
        const bounds = (await trigger.boundingBox())!
        expect(before.x + before.width - bounds.x - bounds.width).toBeLessThanOrEqual(9)
        expect(bounds.y - before.y).toBeLessThanOrEqual(9)
      }
      await trigger.focus()
      await page.keyboard.press('Enter')
      const explanation = page.getByRole('dialog', { name: title, exact: true })
      await expect(explanation).toBeVisible()
      await expect(explanation).toBeFocused()
      const bounds = (await explanation.boundingBox())!
      expect(bounds.x).toBeGreaterThanOrEqual(12)
      expect(bounds.y).toBeGreaterThanOrEqual(12)
      expect(bounds.x + bounds.width).toBeLessThanOrEqual(page.viewportSize()!.width - 11)
      expect(bounds.y + bounds.height).toBeLessThanOrEqual(page.viewportSize()!.height - 11)
      expect((await card.boundingBox())!.height).toBe(before.height)
      if (title === 'Dispute rate') await explanation.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-calculation.png`) })
      await page.keyboard.press('Escape')
      await expect(explanation).toHaveCount(0)
      await expect(trigger).toBeFocused()
    }
    await expectPortalCardDesign(page)
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
    await expectEqualCardRows(page)
    await page.evaluate(() => (document.activeElement as HTMLElement | null)?.blur())
    await page.mouse.move(0, 0)
    if (tab !== 'Overview') {
      await page.locator('.mp-analytics-detail:visible').screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${tab === 'Traffic & Volume' ? 'traffic' : 'quality'}.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
    } else {
      await page.getByRole('region', { name: 'At a glance', exact: true }).screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-summary.png`) })
    }
  }
})

test('Vendor closed cases keep period activity and show an honest current-status empty state', async ({ page }) => {
  await mockDashboard(page, 'vendor')
  const insights = vendorInsights()
  insights.disputes = { ...insights.disputes, open: 0, awaiting_response: 0, statuses: [], filed_in_period: 1,
    issue_types: [{ key: 'DEFECTIVE', count: 1 }], series: insights.disputes.series.map((point, index) => ({ ...point, cases: index === 6 ? 1 : 0 })) }
  await page.route('**/api/v1/vendor/dashboard/insights*', route => route.fulfill({ json: { data: insights, meta: {}, errors: [] } }))
  await page.goto('/dashboard')
  await page.getByRole('tab', { name: 'Disputes & Quality' }).click()
  const status = page.getByRole('region', { name: 'Open cases by status', exact: true })
  await expect(status.getByText('No open cases. There are no active cases to group by status.')).toBeVisible()
  await expect(status.getByRole('img')).toHaveCount(0)
  const chart = page.getByRole('img', { name: /Dispute cases filed per day/ })
  expect(await chart.locator('g > text').allTextContents()).toEqual(['0', '1'])
  await expect(page.getByRole('region', { name: 'Issue types', exact: true }).getByText('Defective or damaged')).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const directory = resolve('../../.tmp/dashboard-secondary-cards')
  mkdirSync(directory, { recursive: true })
  await page.locator('.mp-analytics-detail:visible').screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-quality-no-open.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
})

test('Vendor calculation explanations float over the dashboard and stay within the viewport', async ({ page }) => {
  await mockDashboard(page, 'vendor')
  await page.goto('/dashboard')
  const directory = resolve('../../.tmp/dashboard-calculation-help')
  mkdirSync(directory, { recursive: true })
  for (const title of ['Sales trend', 'Order activity', 'Sales by category', 'Store performance', 'Top products', 'Product demand segments', 'Frequently ordered together', 'Stock status']) {
    const card = page.getByRole('region', { name: title, exact: true })
    const trigger = card.getByRole('button', { name: `How this is calculated: ${title}` })
    await trigger.scrollIntoViewIfNeeded()
    const before = await card.boundingBox()
    expect(await trigger.evaluate(element => element.parentElement?.matches('.mp-card-header'))).toBe(true)
    const controlBounds = (await trigger.boundingBox())!
    expect(before!.x + before!.width - controlBounds.x - controlBounds.width).toBeLessThanOrEqual(9)
    expect(controlBounds.y - before!.y).toBeLessThanOrEqual(9)
    await trigger.click()
    const explanation = page.getByRole('dialog', { name: title, exact: true })
    await expect(explanation).toBeVisible()
    await expect(explanation).toBeFocused()
    expect(await explanation.evaluate(element => element.matches(':popover-open'))).toBe(true)
    expect(await explanation.evaluate(element => getComputedStyle(element).position)).toBe('fixed')
    const bounds = (await explanation.boundingBox())!
    expect(bounds.x).toBeGreaterThanOrEqual(12)
    expect(bounds.y).toBeGreaterThanOrEqual(12)
    expect(bounds.x + bounds.width).toBeLessThanOrEqual(page.viewportSize()!.width - 11)
    expect(bounds.y + bounds.height).toBeLessThanOrEqual(page.viewportSize()!.height - 11)
    const after = (await card.boundingBox())!
    expect(after.height).toBe(before!.height)
    expect(after.width).toBe(before!.width)
    if (title === 'Sales trend') await explanation.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-calculation.png`) })
    await page.keyboard.press('Escape')
    await expect(explanation).toHaveCount(0)
    await expect(trigger).toBeFocused()
  }
  const salesHelp = page.getByRole('button', { name: 'How this is calculated: Sales trend' })
  await salesHelp.click()
  await page.getByRole('button', { name: 'Close calculation explanation' }).click()
  await expect(page.getByRole('dialog')).toHaveCount(0)
  await expect(salesHelp).toBeFocused()
  await salesHelp.click()
  await page.mouse.click(page.viewportSize()!.width - 3, page.viewportSize()!.height - 3)
  await expect(page.getByRole('dialog')).toHaveCount(0)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  if (page.viewportSize()!.width >= 768) {
    await salesHelp.evaluate(element => (element as HTMLElement).blur())
    await page.locator('.mp-analytics-overview').screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-cards.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
  }
})

for (const empty of [false, true]) test(`Vendor Priority actions shows every queue (${empty ? 'nothing waiting' : 'pending work'})`, async ({ page }) => {
  await mockDashboard(page, 'vendor')
  const insights = vendorInsights()
  if (empty) insights.actions = insights.actions.map(action => ({ ...action, count: 0, severity: 'ACTION', detail: null }))
  await page.route('**/api/v1/vendor/dashboard/insights*', route => route.fulfill({ json: { data: insights, meta: {}, errors: [] } }))
  await page.goto('/dashboard')
  const panel = page.getByRole('region', { name: 'Priority actions', exact: true })
  await expect(panel.getByText('Work waiting for your role, most urgent first.')).toBeVisible()
  await expect(panel.getByRole('listitem')).toHaveCount(6)
  const links = panel.getByRole('link')
  for (const action of insights.actions) await expect(panel.getByRole('link', { name: new RegExp(action.label) })).toHaveAttribute('href', action.href)
  if (empty) {
    await expect(panel.getByText('Nothing waiting.', { exact: true })).toHaveCount(6)
    await expect(panel.getByText('0', { exact: true })).toHaveCount(6)
    await expect(links.first()).toContainText('Order requests awaiting your decision')
  } else {
    await expect(links.first()).toContainText('Variants out of stock')
    await expect(panel.getByText(/Needs attention now\./)).toHaveCount(3)
  }
  await links.first().focus()
  await expect(links.first()).toBeFocused()
  const rows = await links.evaluateAll(elements => elements.map(element => ({ height: element.getBoundingClientRect().height, labelSize: getComputedStyle(element.querySelector('strong')!).fontSize, icons: element.querySelectorAll('svg').length })))
  for (const row of rows) {
    expect(row.height).toBeGreaterThanOrEqual(44)
    expect(row.labelSize).toBe('11px')
    expect(row.icons).toBe(0)
  }
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.evaluate(() => document.fonts.ready)
  const directory = resolve('../../.tmp/priority-actions')
  mkdirSync(directory, { recursive: true })
  await panel.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${empty ? 'empty' : 'pending'}.png`) })
})

test('Vendor dashboard switches sections without stacking reports', async ({ page }) => {
  await page.clock.install()
  const reads = await mockDashboard(page, 'vendor')
  await page.goto('/dashboard')
  await expect(page.getByRole('heading', { name: 'Welcome back, Dashboard Reviewer', level: 1 })).toBeVisible()
  await expect(page.getByRole('heading', { name: /^Hi,/ })).toHaveCount(0)
  await expect(page.getByRole('main').getByText('Your store at a glance. Switch sections to focus on the work that matters today.', { exact: true })).toBeVisible()
  await expect(page.getByRole('button', { name: /Refresh/ })).toHaveCount(0)
  await expect(page.getByRole('button', { name: 'Last 30 days', exact: true })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Store workspace', exact: true })).toHaveCount(0)
  await expect(page.getByRole('region', { name: 'Priority actions', exact: true })).toBeVisible()
  await expect(page.getByRole('img', { name: /Orders confirmed per day/ })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Incoming order requests', exact: true })).toBeVisible()
  const chartCards = ['Sales trend', 'Order activity', 'Sales by category', 'Store performance'].map(name => page.getByRole('region', { name, exact: true }))
  for (const card of chartCards) await expect(card).toBeVisible()
  const bounds = await Promise.all(chartCards.map(card => card.boundingBox()))
  if (page.viewportSize()!.width >= 768) {
    const gridWidth = await chartCards[0]!.locator('..').evaluate(element => {
      const style = getComputedStyle(element)
      return element.clientWidth - parseFloat(style.paddingLeft) - parseFloat(style.paddingRight)
    })
    expect(Math.abs(bounds[0]!.width - gridWidth)).toBeLessThanOrEqual(1)
    expect(bounds[1]!.y).toBeGreaterThanOrEqual(bounds[0]!.y + bounds[0]!.height)
    expect(Math.abs(bounds[1]!.y - bounds[2]!.y)).toBeLessThanOrEqual(1)
    expect(bounds[3]!.y).toBeGreaterThan(bounds[1]!.y)
  }
  const rail = page.getByRole('complementary', { name: 'Operations and activity' })
  await expect(rail.getByRole('region', { name: 'Stock status', exact: true })).toBeVisible()
  await expect(rail.getByRole('region', { name: 'Priority actions', exact: true })).toBeVisible()
  await expectEqualCardRows(page)
  await capture(page, 'vendor-overview')
  const sales = page.getByRole('region', { name: 'Sales trend', exact: true })
  await expect(sales.getByLabel('Chart details for Sales trend')).toHaveCount(0)
  const tableTrigger = sales.getByText('View as table', { exact: true })
  await tableTrigger.click()
  await expect(sales.getByRole('table', { name: 'Sales per day' })).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await tableTrigger.click()
  await expect(sales.getByRole('table', { name: 'Sales per day' })).toBeHidden()
  await expect(tableTrigger).toBeFocused()
  const navigation = page.getByRole('tablist', { name: 'Workspace sections' })
  await expect(navigation.getByRole('tab')).toHaveText(['Overview', 'Traffic & Volume', 'Disputes & Quality'])
  for (const [tab, region, name] of [['Traffic & Volume', 'Demand funnel', 'vendor-traffic'], ['Disputes & Quality', 'Issue types', 'vendor-quality']] as const) {
    await navigation.getByRole('tab', { name: tab, exact: true }).click()
    await expect(page.getByRole('region', { name: region, exact: true })).toBeVisible()
    await expectEqualCardRows(page)
    await capture(page, name)
  }
  await navigation.getByRole('tab', { name: 'Traffic & Volume', exact: true }).click()
  await page.clock.fastForward(30_000)
  await expect.poll(() => reads.vendor).toBe(2)
  await expect(page.getByRole('main').getByText('Updated Supply', { exact: true })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Demand funnel', exact: true })).toBeVisible()
  await navigation.getByRole('tab', { name: 'Overview', exact: true }).focus()
  await page.keyboard.press('Enter')
  await expect(page.getByRole('region', { name: 'Incoming order requests', exact: true })).toBeVisible()
})

test('Vendor dashboard uses shared compact activity rows and consistent distribution donuts', async ({ page }) => {
  await mockDashboard(page, 'vendor')
  await page.route('**/api/v1/vendor/onboarding', async route => {
    await route.fulfill({ json: { data: { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1,
      organization: { store_name: 'Sample Supply', lock_version: 1 }, permissions: ['vendor.onboarding.manage', 'vendor.onboarding.submit', 'staff.manage'], welcome_required: false,
      verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', marketplace_discoverability_status: 'NO_ACTIVE_LISTINGS', readiness: { ready: true, blockers: [] } } }, meta: {}, errors: [] } })
  })
  await page.route('**/api/v1/vendors/account/activity*', route => route.fulfill({ json: { data: [
    ['ORDER_CONFIRMED', 'ORDER', 'CONFIRMED'], ['INVENTORY_ROW_UPDATED', 'INVENTORY', 'IN_STOCK'], ['INVOICE_ISSUED', 'INVOICE', 'ISSUED'], ['PRODUCT_PUBLISHED', 'PRODUCT', 'PUBLISHED'], ['QUOTATION_PUBLISHED', 'QUOTATION', 'PUBLISHED'],
  ].map(([action, resource_type, status], index) => ({ id: `activity-preview-${index}`, actor_name: 'Sample Manager', actor_role: 'MANAGER', category: 'SALES', action, resource_type, resource_id: 'private-resource', created_at: '2026-11-07T02:00:00Z', succeeded: true, correlation_id: 'private-correlation', before: {}, after: { status, private_field: 'must-not-render' } })), meta: { current_page: 1, last_page: 1, total: 5, total_events: 5, succeeded_events: 5, failed_events: 0, categories: [] }, errors: [] } }))
  await page.goto('/dashboard')
  const priority = page.getByRole('region', { name: 'Priority actions', exact: true })
  await expect(priority.locator('.mp-analytics-queue')).toBeVisible()
  const recent = page.getByRole('region', { name: 'Recent activity', exact: true })
  await expect(recent.locator('.mp-analytics-activity')).toBeVisible()
  await expect(recent.getByRole('link', { name: 'View all' })).toHaveAttribute('href', '/preview/tracking')
  await expect(recent.locator('.mp-dashboard-activity-icon > svg')).toHaveCount(5)
  await expect(recent.locator('.mp-dashboard-activity-content > strong').first()).toHaveText('Order confirmed:')
  await expect(recent).not.toContainText('private-resource')
  await expect(recent).not.toContainText('must-not-render')
  const icons = await recent.locator('.mp-dashboard-activity-icon').evaluateAll(elements => elements.map(element => ({ width: element.getBoundingClientRect().width, height: element.getBoundingClientRect().height })))
  for (const icon of icons) expect(icon).toEqual({ width: 36, height: 36 })
  for (const title of ['Stock status', 'Sales by category']) await expect(page.getByRole('region', { name: title, exact: true }).locator('[data-chart-variant="donut"]')).toHaveCount(1)
  await recent.screenshot({ path: test.info().outputPath('vendor-recent-activity.png') })
  await page.getByRole('region', { name: 'Sales by category', exact: true }).screenshot({ path: test.info().outputPath('vendor-category-donut.png'), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
  await page.getByRole('tab', { name: 'Traffic & Volume', exact: true }).click()
  await expect(page.getByRole('region', { name: 'Order mix', exact: true }).locator('[data-chart-variant="donut"]')).toHaveCount(3)
  await page.getByRole('tab', { name: 'Disputes & Quality', exact: true }).click()
  for (const title of ['Issue types', 'Open cases by status']) await expect(page.getByRole('region', { name: title, exact: true }).locator('[data-chart-variant="donut"]')).toHaveCount(1)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
})

test('Vendor sales overview groups earnings and both deductions with exact, dismissible daily tooltips', async ({ page }) => {
  await mockDashboard(page, 'vendor')
  await page.goto('/dashboard')
  const card = page.getByRole('region', { name: 'Sales trend', exact: true })
  await expect(card.getByText('Total gross sales', { exact: true })).toBeVisible()
  await expect(card.getByRole('list', { name: 'Selected period totals' })).toBeVisible()
  await expect(card.getByLabel('Chart details for Sales trend')).toHaveCount(0)
  expect(await card.locator('.mp-trend-total dd').evaluate(element => { const range = document.createRange(); range.selectNodeContents(element); return range.getClientRects().length })).toBe(1)
  const fixture = vendorInsights()
  const peso = (amount: number) => new Intl.NumberFormat('en-PH', { style: 'currency', currency: 'PHP', minimumFractionDigits: 2 }).format(amount / 100)
  await expect(card.locator('.mp-trend-series-value')).toHaveText([peso(fixture.orders.kpis.net_sales_centavos!.value), `-${peso(fixture.orders.series.reduce((sum, point) => sum + (point.refunds_centavos ?? 0), 0))}`, `-${peso(fixture.orders.series.reduce((sum, point) => sum + (point.cancellation_deductions_centavos ?? 0), 0))}`])
  await expect(card.locator('.mp-trend-overview-legend').getByText('Cancelled sales')).toBeVisible()
  const amountLines = await card.locator('.mp-trend-series-value').evaluateAll(amounts => amounts.map(amount => { const range = document.createRange(); range.selectNodeContents(amount); return range.getClientRects().length }))
  expect(amountLines).toEqual([1, 1, 1])
  const legend = card.locator('.mp-trend-overview-legend')
  const overviewBounds = (await card.locator('.mp-trend-overview').boundingBox())!
  const grossBounds = (await card.locator('.mp-trend-total').boundingBox())!
  const legendBounds = (await legend.boundingBox())!
  if (overviewBounds.width >= 480) {
    expect(Math.abs(grossBounds.y - legendBounds.y)).toBeLessThanOrEqual(1)
    expect(legendBounds.x).toBeGreaterThanOrEqual(grossBounds.x + grossBounds.width + 23)
    expect(Math.abs(legendBounds.x + legendBounds.width - overviewBounds.x - overviewBounds.width)).toBeLessThanOrEqual(1)
  } else {
    expect(legendBounds.y).toBeGreaterThan(grossBounds.y + grossBounds.height)
  }
  const items = await legend.locator('li').evaluateAll(elements => elements.map(element => { const bounds = element.getBoundingClientRect(); return { x: bounds.x, y: bounds.y, right: bounds.right } }))
  if (overviewBounds.width >= 480) expect(new Set(items.map(item => Math.round(item.y))).size).toBe(1)
  for (let index = 1; index < items.length; index++) {
    const previous = items[index - 1]!, current = items[index]!
    if (Math.abs(current.y - previous.y) <= 1) expect(current.x - previous.right).toBeLessThanOrEqual(17)
  }
  await expect(card.locator('span').filter({ hasText: /^Other cancellation deductions$/ })).toHaveCount(0)
  const chart = card.getByRole('img', { name: /Earnings, refunds and cancelled sales per day/ })
  await expect(chart).toBeVisible()
  expect((await chart.boundingBox())!.height).toBeLessThanOrEqual(180)
  expect(await chart.locator('[data-bar-series="net"]').count()).toBeGreaterThan(0)
  expect(await chart.locator('[data-bar-series="refunds"]').count()).toBeGreaterThan(0)
  expect(await chart.locator('[data-bar-series="cancellations"]').count()).toBeGreaterThan(0)
  const barGroups = await chart.evaluate(element => {
    const buckets = Array.from(element.querySelectorAll<SVGRectElement>('[data-trend-bucket]'))
    return buckets.map(bucket => {
      const bounds = bucket.getBBox()
      const bars = Array.from(element.querySelectorAll<SVGPathElement>(`[data-bar-index="${bucket.dataset.trendBucket}"]`)).map(bar => bar.getBBox()).sort((left, right) => left.x - right.x)
      return { bounds: { x: bounds.x, width: bounds.width }, bars: bars.map(bar => ({ x: bar.x, width: bar.width })) }
    }).filter(group => group.bars.length > 0)
  })
  for (const group of barGroups) {
    group.bars.forEach((bar, index) => {
      expect(bar.width).toBeGreaterThan(group.bounds.width / 4)
      expect(bar.x).toBeGreaterThanOrEqual(group.bounds.x)
      expect(bar.x + bar.width).toBeLessThanOrEqual(group.bounds.x + group.bounds.width)
      if (index > 0) expect(bar.x).toBeGreaterThanOrEqual(group.bars[index - 1]!.x + group.bars[index - 1]!.width)
    })
  }
  await chart.focus()
  await page.keyboard.press('Home')
  const tooltip = card.getByRole('tooltip')
  await expect(tooltip.getByText('Earnings', { exact: true })).toBeVisible()
  await expect(tooltip.getByText('Refunds', { exact: true })).toBeVisible()
  await expect(tooltip.getByText('Cancelled sales', { exact: true })).toBeVisible()
  await expect(tooltip.locator('dd').first()).toHaveText(/^₱[\d,]+\.\d{2}$/)
  await expect(tooltip.locator('dd').last()).toHaveText(/^-₱[\d,]+\.\d{2}$/)
  const tooltipBounds = (await tooltip.boundingBox())!
  const cardBounds = (await card.boundingBox())!
  expect(tooltipBounds.x).toBeGreaterThanOrEqual(cardBounds.x)
  expect(tooltipBounds.x + tooltipBounds.width).toBeLessThanOrEqual(cardBounds.x + cardBounds.width)
  if (page.viewportSize()!.width > 390) {
    await tooltip.hover()
    await expect(tooltip).toBeVisible()
  }
  await chart.focus()
  await page.keyboard.press('Home')
  const cancellationDay = fixture.orders.series.findIndex(point => (point.cancellation_deductions_centavos ?? 0) > 0)
  expect(cancellationDay).toBeGreaterThanOrEqual(0)
  for (let index = 0; index < cancellationDay; index++) await page.keyboard.press('ArrowRight')
  await expect(tooltip.getByText(`-${peso(fixture.orders.series[cancellationDay]!.cancellation_deductions_centavos!)}`, { exact: true })).toBeVisible()
  const directory = resolve('../../.tmp/sales-overview')
  mkdirSync(directory, { recursive: true })
  await card.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-tooltip.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
  await page.keyboard.press('Escape')
  await expect(tooltip).toHaveCount(0)
  const bucket = chart.locator('[data-trend-bucket="1"]')
  await chart.focus()
  await page.keyboard.press('Home')
  await page.keyboard.press('Escape')
  if (page.viewportSize()!.width <= 390) await bucket.tap({ force: true })
  else await bucket.click({ force: true })
  await expect(tooltip).toBeVisible()
  await page.getByRole('heading', { name: 'Sales trend', exact: true }).click()
  await expect(tooltip).toHaveCount(0)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await card.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-card.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
})

test('sparse sales fit every date in a compact full-width plot without scrolling', async ({ page }) => {
  await mockDashboard(page, 'vendor')
  const fixture = vendorInsights()
  fixture.orders.series = Array.from({ length: 35 }, (_, index) => ({ ...fixture.orders.series[0]!,
    date: new Date(Date.UTC(2026, 9, 2 + index)).toISOString().slice(0, 10), orders: index === 18 ? 5 : 0, order_requests: index === 18 ? 5 : 0,
    gross_sales_centavos: index === 18 ? 3169800 : index === 19 ? 117360 : 0,
    net_sales_centavos: index === 18 ? 2933800 : 0, refunds_centavos: index === 18 ? 236000 : 0,
    cancellation_deductions_centavos: index === 19 ? 117360 : 0,
  }))
  fixture.orders.kpis.gross_sales_centavos!.value = fixture.orders.series.reduce((sum, point) => sum + (point.gross_sales_centavos ?? 0), 0)
  fixture.orders.kpis.net_sales_centavos!.value = fixture.orders.series.reduce((sum, point) => sum + (point.net_sales_centavos ?? 0), 0)
  await page.route('**/api/v1/vendor/dashboard/insights*', route => route.fulfill({ json: { data: fixture, meta: {}, errors: [] } }))
  await page.goto('/dashboard')
  const card = page.getByRole('region', { name: 'Sales trend', exact: true })
  const chart = card.getByRole('img', { name: /Earnings, refunds and cancelled sales per day/ })
  const viewport = chart.locator('..')
  const peak = chart.locator('[data-bar-series="net"][data-bar-index="18"]')
  await expect(peak).toBeAttached()
  expect(await viewport.evaluate(element => element.scrollWidth <= element.clientWidth + 1)).toBe(true)
  const viewportBounds = (await viewport.boundingBox())!
  const peakBounds = (await peak.boundingBox())!
  expect(peakBounds.width).toBeGreaterThan(1)
  expect(peakBounds.x).toBeGreaterThanOrEqual(viewportBounds.x + 48)
  expect(peakBounds.x + peakBounds.width).toBeLessThanOrEqual(viewportBounds.x + viewportBounds.width)
  expect((await chart.boundingBox())!.height).toBeLessThanOrEqual(180)
  await expect(chart).toContainText('₱40K')
  await expect(card.getByText('Scroll to view all dates')).toHaveCount(0)
  const first = (await chart.locator('[data-trend-bucket="0"]').boundingBox())!
  const final = (await chart.locator('[data-trend-bucket="34"]').boundingBox())!
  expect(first.x).toBeGreaterThanOrEqual(viewportBounds.x)
  expect(final.x + final.width).toBeLessThanOrEqual(viewportBounds.x + viewportBounds.width + 1)
  const parentBounds = (await card.locator('..').boundingBox())!
  expect((await card.boundingBox())!.width).toBeGreaterThan(parentBounds.width - 40)
  const directory = resolve('../../.tmp/sales-overview')
  mkdirSync(directory, { recursive: true })
  await card.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-sparse-bars.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
  await chart.focus()
  await page.keyboard.press('End')
  await expect(card.getByRole('tooltip')).toContainText('Nov 5')
  const last = (await chart.locator('[data-trend-bucket="34"]').boundingBox())!
  expect(last.x + last.width).toBeLessThanOrEqual(viewportBounds.x + viewportBounds.width + 1)
  await page.keyboard.press('Home')
  expect(await viewport.evaluate(element => element.scrollLeft)).toBe(0)
  await expect(card.getByRole('tooltip')).toContainText('Oct 2')
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
})

test('Admin recent activity uses the shared icon layout and safe event descriptions', async ({ page }) => {
  await mockDashboard(page, 'admin')
  await page.route('**/admin/dashboard/audit*', route => route.fulfill({ json: { data: [
    ['ORDER_STATUS_UPDATED', 'ORDER'], ['INVENTORY_ADJUSTED', 'INVENTORY'], ['INVOICE_GENERATED', 'INVOICE'], ['PRODUCT_REVIEWED', 'PRODUCT'], ['VENDOR_VERIFICATION_REVIEWED', 'VENDOR_ORGANIZATION'], ['OLDER_EVENT', 'ORDER'],
  ].map(([action, resource_type], index) => ({ id: `audit-${index}`, action, resource_type, actor_role: 'ADMIN_SUPERADMIN', succeeded: index !== 4, created_at: '2026-11-07T02:42:00Z', correlation_id: 'private-correlation', payload: 'must-not-render' })), meta: { last_page: 2 }, errors: [] } }))
  await page.goto('http://127.0.0.1:4174/dashboard')
  const recent = page.getByRole('region', { name: 'Recent activity', exact: true })
  await expect(recent.getByRole('listitem')).toHaveCount(5)
  await expect(recent.locator('.mp-dashboard-activity-icon > svg')).toHaveCount(5)
  await expect(recent.locator('.mp-dashboard-activity-content > strong').first()).toHaveText('Order status updated:')
  await expect(recent).toContainText('Failed')
  await expect(recent).not.toContainText('Older event')
  await expect(recent).not.toContainText('must-not-render')
  await expect(recent).not.toContainText('private-correlation')
  await expect(recent.getByRole('link', { name: 'View all' })).toHaveAttribute('href', '/audit')
  await expect(recent.locator('time').first()).toHaveAttribute('title', /Asia\/Manila/)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await recent.screenshot({ path: test.info().outputPath('admin-recent-activity.png'), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
})

test('Admin dashboard uses current counts and isolated sections', async ({ page }) => {
  await page.clock.install()
  const reads = await mockDashboard(page, 'admin')
  await page.goto('http://127.0.0.1:4174/dashboard')
  await expect(page.getByRole('heading', { name: 'Welcome back, Dashboard Reviewer', level: 1 })).toBeVisible()
  await expect(page.getByRole('heading', { name: /^Hi,/ })).toHaveCount(0)
  await expect(page.getByRole('main').getByText('Platform overview', { exact: true })).toBeVisible()
  await expect(page.getByRole('main').getByText('A clear view of marketplace activity and the reviews that need your attention.', { exact: true })).toBeVisible()
  const priority = page.getByRole('region', { name: 'Priority actions', exact: true })
  await expect(priority.getByRole('link', { name: /Business document reviews/ })).toContainText('6')
  await expect(priority.getByRole('link', { name: /Product compliance reviews/ })).toHaveAttribute('href', '/product-compliance')
  await expect(page.getByRole('tab', { name: 'Compliance & Moderation', exact: true })).toHaveCount(0)
  await expect(page.getByRole('button', { name: /Refresh/ })).toHaveCount(0)
  await expect(page.getByRole('button', { name: 'Last 30 days', exact: true })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Review priorities', exact: true })).toHaveCount(0)
  await expect(page.getByRole('img', { name: /Commission payments and refunds per day/ })).toBeVisible()
  const marketplace = page.getByRole('region', { name: 'Marketplace value', exact: true })
  await expect(marketplace.getByRole('img', { name: /Gross and net sales per day/ })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Order activity', exact: true })).toBeVisible()
  await expect(page.getByLabel('Chart details for Marketplace value')).toHaveCount(0)
  await marketplace.getByRole('button', { name: 'How this is calculated: Marketplace value' }).click()
  await expect(page.getByRole('dialog', { name: 'Marketplace value', exact: true })).toBeVisible()
  await page.keyboard.press('Escape')
  const health = page.getByRole('region', { name: 'Platform health', exact: true })
  await expect(health.getByRole('list', { name: 'API services and integrations' }).getByRole('listitem')).toHaveCount(10)
  await expect(health.getByText('Xendit TEST')).toBeVisible()
  await expect(page.getByRole('region', { name: 'Marketplace participants', exact: true })).toContainText('Buyer accounts')
  await expect(page.getByRole('region', { name: 'Marketplace at a glance', exact: true })).toContainText('Average confirmed order value')
  for (const title of ['Marketplace participants', 'Category demand']) {
    const panel = page.getByRole('region', { name: title, exact: true })
    await expect(panel.locator('[data-chart-variant="donut"]')).toHaveCount(1)
    await panel.screenshot({ path: test.info().outputPath(`${title.toLowerCase().replaceAll(' ', '-')}.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
  }
  const earningsBounds = (await page.getByRole('region', { name: 'Platform earnings', exact: true }).boundingBox())!
  const marketplaceBounds = (await marketplace.boundingBox())!
  const glanceBounds = (await page.getByRole('region', { name: 'Marketplace at a glance', exact: true }).boundingBox())!
  expect(glanceBounds.y).toBeGreaterThanOrEqual(marketplaceBounds.y + marketplaceBounds.height)
  expect(marketplaceBounds.y).toBeGreaterThanOrEqual(earningsBounds.y + earningsBounds.height)
  if (page.viewportSize()!.width >= 1100) {
    const healthBounds = (await health.boundingBox())!
    expect(Math.abs(marketplaceBounds.y - healthBounds.y)).toBeLessThanOrEqual(1)
    expect(Math.abs(glanceBounds.y + glanceBounds.height - healthBounds.y - healthBounds.height)).toBeLessThanOrEqual(1)
    expect(Math.abs(marketplaceBounds.width - healthBounds.width)).toBeLessThanOrEqual(1)
    expect(Math.abs(glanceBounds.width - healthBounds.width)).toBeLessThanOrEqual(1)
  }
  await page.locator('.mp-analytics-panel-columns').screenshot({ path: test.info().outputPath('marketplace-health-columns.png') })
  await expectEqualCardRows(page)
  await capture(page, 'admin-overview')
  const navigation = page.getByRole('tablist', { name: 'Workspace sections' })
  await expect(navigation.getByRole('tab')).toHaveText(['Overview', 'Disputes & Appeals', 'Audit Logs & Tracking'])
  const activity = page.getByRole('region', { name: 'Active Buyers and Vendor users', exact: true })
  await expect(activity.getByRole('img', { name: /Daily active Buyers and Vendor users/ })).toBeVisible()
  const activityBounds = (await activity.boundingBox())!
  const earnings = (await page.getByRole('region', { name: 'Platform earnings', exact: true }).boundingBox())!
  expect(Math.abs(activityBounds.width - earnings.width)).toBeLessThanOrEqual(1)
  expect(activityBounds.y).toBeGreaterThan(marketplaceBounds.y)
  await expect(activity.getByRole('region', { name: 'Buyers activity', exact: true }).getByRole('definition')).toHaveText(['96', '410', '902'])
  await expect(activity.getByRole('region', { name: 'Vendor users activity', exact: true }).getByRole('definition')).toHaveText(['31', '39', '41'])
  await activity.getByRole('tab', { name: '30-day activity', exact: true }).click()
  await expect(activity.getByRole('img', { name: /Rolling 30-day active Buyers and Vendor users/ })).toBeVisible()
  await expect(activity.getByRole('img', { name: /Daily active Buyers and Vendor users/ })).toHaveCount(0)
  await activity.getByText('View as table', { exact: true }).click()
  await expect(activity.getByRole('table', { name: 'Active Buyers and Vendor users per day' })).toBeVisible()
  await activity.getByRole('button', { name: 'How this is calculated: Active Buyers and Vendor users' }).click()
  await expect(page.getByText(/App opens, page views, automated jobs and auto-accept never count/)).toBeVisible()
  await page.keyboard.press('Escape')
  await activity.getByRole('tab', { name: 'Daily activity', exact: true }).click()
  await activity.getByText('View as table', { exact: true }).click()
  await activity.getByRole('heading', { name: 'Active Buyers and Vendor users', exact: true }).click()
  await page.keyboard.press('Escape')
  const directory = resolve('../../.tmp/admin-activity-overview')
  mkdirSync(directory, { recursive: true })
  await activity.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-activity.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
  await page.clock.fastForward(30_000)
  await expect.poll(() => reads.admin).toBe(2)
  await expect(page.getByRole('region', { name: 'At a glance', exact: true }).getByText('25', { exact: true })).toBeVisible()
  await navigation.getByRole('tab', { name: 'Disputes & Appeals', exact: true }).click()
  await expect(page.getByRole('region', { name: 'Active Buyers and Vendor users', exact: true })).toHaveCount(0)
  await expect(page.getByRole('region', { name: 'Review queues', exact: true })).toContainText('Open disputes')
  await expect(page.getByRole('link', { name: 'Open case queue', exact: true })).toHaveAttribute('href', '/disputes')
  await navigation.getByRole('tab', { name: 'Audit Logs & Tracking', exact: true }).click()
  await expect(page.getByText('No audit events recorded.')).toBeVisible()
  await capture(page, 'admin-health')
})

test('Admin case queue uses clear responsive records and keeps server status filters', async ({ page }) => {
  await mockDashboard(page, 'admin')
  const statuses: string[] = []
  await page.route('**/admin/disputes?**', async route => {
    statuses.push(new URL(route.request().url()).searchParams.get('status') ?? '')
    await route.fulfill({ json: { data: [{ id: 'case-review', reference: 'CASE-REVIEW-001', order_id: 'order-review', order_reference: 'ORD-REVIEW-001', status: 'ESCALATED_ADMIN_REVIEW',
      case_kind: 'TRANSACTION', issue_type: 'DEFECTIVE', requested_remedy: 'PARTIAL_REFUND', requested_amount_centavos: 150000, filed_by_party: 'BUYER', responsible_party: 'ADMIN',
      next_deadline: null, refund_state: 'NOT_REQUESTED', remedy_state: 'NONE', appeal_available: false, vendor_name: 'Sample Supply', buyer_name: 'Sample Buyer', assigned_to_admin: true, decisions: 0 }],
      meta: { counts: { NEEDS_ADMIN: 1 }, total: 1, per_page: 25, has_more: false }, errors: [] } })
  })
  await page.goto('http://127.0.0.1:4174/disputes')
  const main = page.getByRole('main')
  const records = page.viewportSize()!.width >= 1024 ? main.getByRole('table', { name: 'Admin dispute and appeal cases' }) : main.getByRole('list', { name: 'Admin dispute and appeal cases' })
  await expect(records).toContainText('Sample Buyer v. Sample Supply')
  await expect(records).toContainText('Assigned to Admin')
  await expect(records.getByRole('link', { name: 'Review case' })).toHaveAttribute('href', '/disputes/case-review')
  await main.getByRole('tab', { name: 'With the parties', exact: true }).click()
  await expect.poll(() => statuses.at(-1)).toBe('WITH_PARTIES')
  await expect(records).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.screenshot({ path: test.info().outputPath('admin-case-queue.png'), fullPage: true })
})

test('Admin dashboard preserves restricted counts and audit visibility', async ({ page }) => {
  await mockDashboard(page, 'admin', true)
  await page.goto('http://127.0.0.1:4174/dashboard')
  const summary = page.getByRole('region', { name: 'At a glance', exact: true })
  await expect(summary.getByText('Outside your role scope.')).toHaveCount(2)
  await expect(page.getByRole('region', { name: 'Priority actions', exact: true })).toContainText('No work queues are assigned to your role.')
  await expect(page.getByRole('region', { name: 'Recent activity', exact: true })).toHaveCount(0)
  await expect(page.getByRole('region', { name: 'Platform earnings', exact: true })).toContainText('Platform earnings is outside your role scope.')
  await expect(page.getByRole('region', { name: 'Platform health', exact: true })).toContainText('Platform health is outside your role scope.')
  await expect(summary.locator('.mp-analytics-change[data-direction]')).toHaveCount(0)
  await expect(summary.locator('.mp-analytics-stat-value')).toHaveText(['—', '—', '—', '—'])
  await expect(page.getByRole('region', { name: 'Active Buyers and Vendor users', exact: true })).toHaveCount(0)
  await expect(page.getByRole('img', { name: /Daily active Buyers and Vendor users/ })).toHaveCount(0)
  await expect(page.getByRole('link', { name: 'Open Vendor Management', exact: true })).toHaveCount(0)
  await expect(page.getByRole('link', { name: 'View audit log', exact: true })).toHaveCount(0)
  await page.getByRole('tablist', { name: 'Workspace sections' }).getByRole('tab', { name: 'Audit Logs & Tracking' }).click()
  await expect(page.getByRole('region', { name: 'Recent platform activity', exact: true })).toHaveCount(0)
  await expect(page.getByText('Audit logs are outside your role scope.').filter({ visible: true })).toBeVisible()
  await expect(page.getByRole('img', { name: /Gross and net sales/ })).toHaveCount(0)
  await capture(page, 'admin-restricted')
})

test('Admin dashboard uses account and money cards with the Vendor overview layout', async ({ page }) => {
  await page.clock.install({ time: new Date('2026-11-03T04:00:00Z') })
  const reads = await mockDashboard(page, 'admin')
  await page.goto('http://127.0.0.1:4174/dashboard')
  const summary = page.getByRole('region', { name: 'At a glance', exact: true })
  for (const [label, value, hint] of [
    ['Platform earnings', '₱384.00', 'Net collected commissions · TEST.'],
    ['Net marketplace value', '₱23,912,000.00', 'After cancellations and completed refunds.'],
    ['Active Buyers', '128', 'Buyer accounts with ACTIVE status.'],
    ['Active Tier 2 Vendors', '24', 'Active account and activated store'],
  ] as const) {
    const metric = summary.getByRole('term').filter({ hasText: new RegExp(`^${label}$`) }).locator('..')
    await expect(metric.locator('.mp-analytics-stat-value')).toHaveText(value)
    await expect(metric).toContainText(hint)
    await expect(metric.locator('.mp-analytics-change')).toHaveCount(label === 'Platform earnings' || label === 'Net marketplace value' ? 1 : 0)
  }
  await expect(summary.locator('.mp-metric-card-accent')).toContainText('Platform earnings')
  await expect(summary.locator('.mp-analytics-stat-value')).toHaveText(['₱384.00', '₱23,912,000.00', '128', '24'])
  await expect(summary.getByText('vs previous 30 days', { exact: true })).toHaveCount(2)
  await expect(summary.locator('.mp-analytics-change[data-direction="up"]')).toHaveCount(2)
  await expect(summary.getByText('+100.0%', { exact: true })).toHaveCount(2)
  expect(await summary.locator('.mp-analytics-stat-value').evaluateAll(elements => elements.every(element => element.scrollHeight <= Number.parseFloat(getComputedStyle(element).lineHeight) + 1))).toBe(true)
  await expect(summary.getByText('Monthly active Buyers', { exact: true })).toHaveCount(0)
  await expect(summary.getByText('Monthly active Vendor users', { exact: true })).toHaveCount(0)
  await expect(summary.getByRole('button', { name: /How this is calculated/ })).toHaveCount(4)
  const chart = page.getByRole('region', { name: 'Platform earnings', exact: true })
  const main = page.locator('.mp-analytics-layout > .mp-analytics-main')
  const rail = page.getByRole('complementary', { name: 'Operations and activity' })
  await expect(main.getByRole('region', { name: 'At a glance', exact: true })).toBeVisible()
  await expect(rail.getByRole('region', { name: 'Priority actions', exact: true })).toBeVisible()
  await expect(rail.getByRole('region', { name: 'Recent activity', exact: true })).toBeVisible()
  const chartBounds = (await chart.boundingBox())!
  const chartContentWidth = await chart.locator('..').evaluate(element => {
    const styles = getComputedStyle(element)
    return element.clientWidth - Number.parseFloat(styles.paddingLeft) - Number.parseFloat(styles.paddingRight)
  })
  expect(Math.abs(chartBounds.width - chartContentWidth)).toBeLessThanOrEqual(1)
  if (page.viewportSize()!.width >= 1100) {
    const summaryBounds = (await summary.boundingBox())!
    const railBounds = (await rail.boundingBox())!
    expect(Math.abs(summaryBounds.y - railBounds.y)).toBeLessThanOrEqual(1)
    expect(railBounds.x).toBeGreaterThan(summaryBounds.x + summaryBounds.width)
  }
  await captureSummary(page, 'admin')

  const assertPeriod = (days: number) => {
    const current = reads.insights.find(url => url.searchParams.get('to') === '2026-11-03' && (Date.parse(url.searchParams.get('to')!) - Date.parse(url.searchParams.get('from')!)) / 86_400_000 + 1 === days)
    expect(current, `Current ${days}-day request`).toBeDefined()
  }
  assertPeriod(30)
  expect(reads.insights).toHaveLength(2)
  await expect.poll(() => reads.finance.length).toBe(2)
  expect(reads.finance[0]!.searchParams.get('from')).toBe(reads.insights[0]!.searchParams.get('from'))
  expect(reads.finance[0]!.searchParams.get('to')).toBe('2026-11-03')
  await page.getByRole('button', { name: 'Last 30 days', exact: true }).click()
  const dateDialog = page.getByRole('dialog', { name: 'Marketplace activity dates', exact: true })
  await dateDialog.getByRole('button', { name: 'Last 90 days', exact: true }).click()
  await dateDialog.getByRole('button', { name: 'Apply', exact: true }).click()
  await expect(page.getByRole('button', { name: 'Last 90 days', exact: true })).toBeVisible()
  await expect.poll(() => reads.insights.length).toBe(4)
  assertPeriod(90)
  await expect.poll(() => reads.finance.length).toBe(4)
  expect(reads.finance[2]!.searchParams.get('from')).toBe(reads.insights[2]!.searchParams.get('from'))
  expect(reads.finance[2]!.searchParams.get('to')).toBe('2026-11-03')
  await expect(summary.locator('.mp-analytics-stat-value')).toHaveText(['₱384.00', '₱23,912,000.00', '128', '24'])
  await expect(summary.getByText('vs previous 90 days', { exact: true })).toHaveCount(2)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
})

test('Admin platform earnings shows paid commissions with refund tooltips, help and a table', async ({ page }) => {
  await page.clock.install({ time: new Date('2026-11-06T04:00:00Z') })
  const reads = await mockDashboard(page, 'admin')
  await page.goto('http://127.0.0.1:4174/dashboard')
  const card = page.getByRole('region', { name: 'Platform earnings', exact: true })
  await expect(card.locator('.mp-trend-total')).toHaveText('Net collected commissions₱384.00')
  const legend = card.getByRole('list', { name: 'Selected period commission totals' })
  await expect(legend).toContainText('Commission payments₱420.00')
  await expect(legend).toContainText('Commission refunds-₱36.00')
  await expect(card.getByText('₱9,876.50', { exact: true })).toHaveCount(0)
  const chart = card.getByRole('img', { name: /Commission payments and refunds per day/ })
  await expect(chart.locator('[data-bar-series="collected"]')).toHaveCount(1)
  await expect(chart.locator('[data-bar-series="refunds"]')).toHaveCount(1)
  await chart.focus()
  await page.keyboard.press('Home')
  for (let index = 0; index < 20; index++) await page.keyboard.press('ArrowRight')
  await expect(card.getByRole('tooltip')).toContainText('-₱36.00')
  await page.keyboard.press('Escape')
  await card.getByText('View as table', { exact: true }).click()
  const table = card.getByRole('table', { name: 'Commission payments per day' })
  await expect(table.getByRole('row', { name: /Oct 28/ })).toContainText('₱0.00-₱36.00-₱36.00')
  await card.getByRole('button', { name: 'How this is calculated: Platform earnings' }).click()
  await expect(page.getByRole('table', { name: 'Collected commission calculation' })).toContainText('₱384.00')
  await page.keyboard.press('Escape')
  await page.clock.fastForward(30_000)
  await expect.poll(() => reads.finance.length).toBeGreaterThanOrEqual(2)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const directory = resolve('../../.tmp/admin-platform-earnings')
  mkdirSync(directory, { recursive: true })
  await card.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-commission-table.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
  await card.getByText('View as table', { exact: true }).click()
  await card.getByRole('heading', { name: 'Platform earnings', exact: true }).click()
  await card.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-paid-commissions.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
})

test('Admin platform earnings finance denial stays local to the card', async ({ page }) => {
  await page.clock.install()
  await mockDashboard(page, 'admin')
  let deny = false
  await page.route('**/admin/finance/kpis*', route => deny
    ? route.fulfill({ status: 403, json: { data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED' }] } })
    : route.fallback())
  await page.goto('http://127.0.0.1:4174/dashboard')
  const card = page.getByRole('region', { name: 'Platform earnings', exact: true })
  await expect(card.locator('.mp-trend-total')).toContainText('₱384.00')
  deny = true
  await page.clock.fastForward(30_000)
  await expect(card).toContainText('Platform earnings is outside your role scope.')
  await expect(card.locator('.mp-trend-total')).toHaveCount(0)
  const summary = page.getByRole('region', { name: 'At a glance', exact: true })
  await expect(summary).toContainText('Active Buyers')
  await expect(summary).toContainText('Needs Finance access.')
  await expect(summary.getByText('₱384.00', { exact: true })).toHaveCount(0)
  await expect(page.getByRole('region', { name: 'Marketplace value', exact: true })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Priority actions', exact: true })).toContainText('Business document reviews')
})

test('Vendor dashboard summary preserves API trend indicators', async ({ page }) => {
  await mockDashboard(page, 'vendor')
  await page.goto('/dashboard')
  const summary = page.getByRole('region', { name: 'At a glance', exact: true })
  const sales = summary.getByRole('term').filter({ hasText: 'Gross sales' }).locator('..')
  const earnings = summary.getByRole('term').filter({ hasText: 'Earnings' }).locator('..')
  await expect(summary.getByRole('term')).toHaveText(['Earnings', 'Gross sales', 'Average order value', 'Orders confirmed'])
  await expect(summary.locator('.mp-metric-card-accent')).toHaveCount(1)
  await expect(sales).not.toHaveClass(/mp-metric-card-accent/)
  await expect(earnings).toHaveClass(/mp-metric-card-accent/)
  await expect(earnings).toHaveCSS('background-color', 'rgb(194, 65, 12)')
  const orders = summary.getByRole('term').filter({ hasText: 'Orders confirmed' }).locator('..')
  await expect(sales.locator('.mp-analytics-change[data-direction="up"]')).toContainText('Increase: +20.8%')
  await expect(orders.locator('.mp-analytics-change[data-direction="up"]')).toContainText('Increase: +20.3%')
  await expect(summary.getByText('vs previous 30 days', { exact: true })).toHaveCount(3)
  await captureSummary(page, 'vendor')
})

test('Vendor summary retains indicators for the screenshot amounts with no previous activity', async ({ page }) => {
  await mockDashboard(page, 'vendor')
  await page.route('**/api/v1/vendor/dashboard/insights**', async route => {
    const fixture = vendorInsights()
    const insights = { ...fixture, period: { ...fixture.period, days: 33, from: '2026-10-02', to: '2026-11-03' },
      orders: { ...fixture.orders, kpis: { ...fixture.orders.kpis,
        gross_sales_centavos: { value: 3487020, previous: 0, change_percent: null }, order_volume: { value: 8, previous: 0, change_percent: null },
        net_sales_centavos: { value: 3062275, previous: 0, change_percent: null }, average_order_value_centavos: { value: 435878, previous: 0 },
      } },
    }
    await route.fulfill({ json: { data: insights, meta: {}, errors: [] } })
  })
  await page.goto('/dashboard')
  const summary = page.getByRole('region', { name: 'At a glance', exact: true })
  await expect(summary.getByText('₱34,870.20', { exact: true })).toBeVisible()
  await expect(summary.getByText('₱30,622.75', { exact: true })).toBeVisible()
  await expect(summary.getByText('₱4,358.78', { exact: true })).toBeVisible()
  await expect(summary.getByRole('term')).toHaveText(['Earnings', 'Gross sales', 'Average order value', 'Orders confirmed'])
  for (const [label, reason] of [['Gross sales', 'No sales in previous 33 days'], ['Earnings', 'No earnings in previous 33 days'], ['Orders confirmed', 'No confirmed orders in previous 33 days']] as const) {
    const card = summary.getByRole('term').filter({ hasText: label }).locator('..')
    await expect(card.getByText('No comparison', { exact: true })).toBeVisible()
    await expect(card.getByText(reason, { exact: true })).toBeVisible()
    await expect(card.locator('.mp-analytics-change[data-direction]')).toHaveCount(0)
  }
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const rail = page.getByRole('complementary', { name: 'Operations and activity' })
  if (page.viewportSize()!.width >= 1100) {
    const [summaryBounds, railBounds] = await Promise.all([summary.boundingBox(), rail.boundingBox()])
    expect(Math.abs(summaryBounds!.y - railBounds!.y)).toBeLessThanOrEqual(1)
    expect(summaryBounds!.x + summaryBounds!.width).toBeLessThan(railBounds!.x)
    expect(summaryBounds!.height).toBeLessThan(360)
  }
  const contentWidth = await summary.evaluate(element => element.closest('.mp-analytics-main')!.getBoundingClientRect().width)
  const valueSize = contentWidth >= 740 && contentWidth <= 919 ? '18px' : '22px'
  for (const value of await summary.locator('.mp-kpi-value').evaluateAll(elements => elements.map(element => ({ height: element.getBoundingClientRect().height, size: getComputedStyle(element).fontSize })))) {
    expect(value.size).toBe(valueSize)
    expect(value.height).toBeLessThanOrEqual(29)
  }
  const directory = resolve('../../.tmp/vendor-summary-indicators')
  mkdirSync(directory, { recursive: true })
  await summary.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-zero-baseline.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
  if (page.viewportSize()!.width >= 1100) await page.locator('.mp-analytics-layout').screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-overview.png`), style: 'header:has(a[href="/notifications"]) { visibility: hidden; }' })
})

test('empty analytics retain grey graph frames and the dashboard date filter', async ({ page }) => {
  await mockDashboard(page, 'vendor', false, true)
  await page.goto('/dashboard')
  await expect(page.getByRole('img', { name: 'Earnings, refunds and cancelled sales per day: No sales in this period.' })).toBeVisible()
  await expect(page.getByRole('img', { name: 'Orders confirmed per day: No orders in this period.' })).toBeVisible()
  await expect(page.getByRole('img', { name: 'Variants by stock status: No active variants yet.' })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Incoming order requests', exact: true })).toContainText('No order requests are waiting for a decision.')
  await expect(page.getByRole('button', { name: 'Last 30 days', exact: true })).toBeVisible()
  await expectEqualCardRows(page)
  await capture(page, 'vendor-empty-overview')
  await expect(page.getByRole('img', { name: 'Category share: No categories sold in this period.' })).toBeVisible()
  await expect(page.getByRole('tab', { name: 'Sales & Revenue', exact: true })).toHaveCount(0)
})

test('an empty sales card matches the populated order card in the same row', async ({ page }) => {
  await mockDashboard(page, 'vendor', false, 'mixed')
  await page.goto('/dashboard')
  const sales = page.getByRole('region', { name: 'Sales trend', exact: true })
  const orders = page.getByRole('region', { name: 'Order activity', exact: true })
  await expect(sales.getByRole('img', { name: 'Earnings, refunds and cancelled sales per day: No sales in this period.' })).toBeVisible()
  await expect(orders.getByRole('img', { name: /Orders confirmed per day/ })).toBeVisible()
  await expectEqualCardRows(page)
  const salesBounds = await sales.boundingBox(), orderBounds = await orders.boundingBox()
  if (salesBounds && orderBounds && Math.abs(salesBounds.y - orderBounds.y) < 1) {
    expect(Math.abs(salesBounds.height - orderBounds.height)).toBeLessThanOrEqual(1)
    const salesChart = await sales.getByRole('img').boundingBox(), orderChart = await orders.getByRole('img').boundingBox()
    expect(Math.abs(salesChart!.height - orderChart!.height)).toBeLessThanOrEqual(1)
  }
  await capture(page, 'vendor-mixed-data')
})


for (const portal of ['vendor', 'admin'] as const) test(`${portal} dates default to 30 days without duplicate clear controls`, async ({ page }) => {
  await page.clock.install({ time: new Date('2026-11-05T04:00:00Z') })
  const requests: URL[] = []
  page.on('request', request => { if (request.url().includes(`/${portal}/dashboard/insights`)) requests.push(new URL(request.url())) })
  await mockDashboard(page, portal)
  await page.goto(portal === 'admin' ? 'http://127.0.0.1:4174/dashboard' : '/dashboard')
  await expect(page.getByRole('region', { name: 'At a glance', exact: true })).toBeVisible()
  await expect(page.getByRole('button', { name: 'Last 30 days', exact: true })).toBeVisible()
  await expect(page.getByRole('button', { name: 'Clear all', exact: true })).toHaveCount(0)
  await expect(page.getByRole('button', { name: /Remove .* filter/ })).toHaveCount(0)
  expect(requests.some(url => url.searchParams.get('from') === '2026-10-07' && url.searchParams.get('to') === '2026-11-05')).toBe(true)
  if (portal === 'vendor') await expect(page.getByRole('region', { name: 'At a glance', exact: true }).getByText('Sep 10 – Oct 9', { exact: true })).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  const directory = resolve('../../.tmp/dashboard-date-defaults')
  mkdirSync(directory, { recursive: true })
  await page.screenshot({ path: resolve(directory, `${portal}-${page.viewportSize()!.width}.png`) })
})
