import { expect, test } from '@playwright/test'
import { vendorInsights } from './fixtures/dashboard-insights'

test('Store Performance keeps score meaning, calculation controls and a compact responsive layout', async ({ page }, testInfo) => {
  let unpublished = false
  let pendingHealth = false
  const insightRequests: URL[] = []
  const assertScoreCardAlignment = async () => {
    const cards = await page.locator('.mp-performance-overview > section').evaluateAll(elements => elements.map(element => {
      const bounds = element.getBoundingClientRect()
      const note = element.querySelector('.mp-performance-card-note')!.getBoundingClientRect()
      return { top: bounds.top, height: bounds.height, width: bounds.width, noteBottom: note.bottom }
    }))
    for (const card of cards) for (const sibling of cards.filter(other => Math.abs(other.top - card.top) < 1)) {
      expect(card.width).toBeCloseTo(sibling.width, 0)
      expect(card.height).toBeCloseTo(sibling.height, 0)
      expect(card.noteBottom).toBeCloseTo(sibling.noteBottom, 0)
    }
  }
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    const insights = vendorInsights(false)
    const performance = {
      ...insights.performance, as_of: '2026-11-05', next_ohs_recalculation_on: '2026-11-09', ohs_calculated_on: '2026-11-02',
      rating_components: { service_quality: '4.50', speed: '4.39' }, completed_orders: { last_90_days: 124, total: 186 },
      operations: { ...insights.performance.operations, numerators: { NFR: 2, LSR: 6, RR: 1, ODR: 1 }, denominators: { NFR: 136, LSR: 136, RR: 128, ODR: 136 }, listing_violations: 0 },
      badges: [
        ['FAST_RESPONDER', 'Fast Responder', 'EARNED'], ['HIGHLY_RATED', 'Highly Rated', 'NOT_EARNED'], ['HIGH_QUALITY_MATERIALS', 'High-Quality Materials', 'NOT_EARNED'],
        ['MOST_ORDERED', 'Most Ordered', 'EARNED'], ['ON_TIME', 'On-Time', 'NOT_EARNED'], ['TRUSTED_SUPPLIER', 'Trusted Supplier', 'SUPPRESSED'],
      ].map(([code, name, status]) => ({ code, name, status, description: `${name} follows the published workflow thresholds.`, scopes: [] })),
    }
    if (pendingHealth && !unpublished) {
      performance.label = 'New Vendor — Building Track Record'
      performance.rating_components = { service_quality: '4.00', speed: '4.00' }
      performance.scores = performance.scores.map(score => score.key === 'VPS' || score.key === 'OHS'
        ? { ...score, value: null, published: false, sample_count: score.key === 'OHS' ? 7 : 0, status_text: 'New Vendor — Building Track Record — needs 10 eligible orders' }
        : { ...score, value: '4.00', sample_count: 6 })
      performance.operations = { ...performance.operations, rates: { NFR: '28.57', LSR: '16.67', RR: '0.00', ODR: '14.29' }, penalties: { NFR: '1.50', LSR: '1.25', RR: '0.00', ODR: '1.25', LVD: '0.00' }, numerators: { NFR: 2, LSR: 1, RR: 0, ODR: 1 }, denominators: { NFR: 7, LSR: 6, RR: 5, ODR: 7 } }
      insights.performance.classification = { class: 'BUILDING_TRACK_RECORD', label: 'New Vendor — Building Track Record', path: ['Neither VPS nor OHS is published yet.'], bands: {} }
    }
    if (unpublished) {
      performance.label = 'New Vendor — Building Track Record'
      performance.scores = performance.scores.map(score => ({ ...score, value: null, published: false, sample_count: score.key === 'VPS' ? 0 : 4, status_text: 'New Vendor — Building Track Record — waiting for eligible samples' }))
      performance.history = []
      insights.performance.classification = { class: 'BUILDING_TRACK_RECORD', label: 'New Vendor — Building Track Record', path: ['Neither VPS nor OHS is published yet.'], bands: {} }
    }
    insights.performance = { ...insights.performance, scores: performance.scores, as_of: performance.as_of }
    let data: unknown = {}, meta: unknown = {}
    if (url.pathname.endsWith('/auth/csrf')) data = { csrf_token: 'sample-csrf' }
    else if (url.pathname.endsWith('/profile')) data = { id: 'sample-user', full_name: 'Sample Vendor', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    else if (url.pathname.endsWith('/vendor/onboarding')) data = {
      step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1,
      organization: { store_name: 'Sample Supply', lock_version: 1 }, permissions: ['portal.performance', 'scores.view_store', 'orders.confirm'],
      welcome_required: false, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } },
    }
    else if (url.pathname.endsWith('/vendor/performance')) data = performance
    else if (url.pathname.endsWith('/vendor/dashboard/insights')) { data = insights; insightRequests.push(url) }
    else if (url.pathname.endsWith('/notifications')) { data = []; meta = { unread_count: 0 } }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  await page.goto('/performance')
  await expect(page.getByRole('figure', { name: 'Community rating (VCS): 4.47 out of 5' })).toBeVisible()
  await expect(page.getByRole('figure', { name: 'Material quality (MQS): 4.52 out of 5' })).toBeVisible()
  await expect(page.getByRole('figure', { name: 'Operational health (OHS): 4.25 out of 5' })).toBeVisible()
  await expect(page.locator('.mp-performance-overview > section')).toHaveCount(3)
  await expect(page.locator('.mp-performance-overview > section').nth(0)).toHaveAccessibleName('Community rating (VCS)')
  await expect(page.locator('.mp-performance-overview > section').nth(1)).toHaveAccessibleName('Material quality (MQS)')
  await expect(page.locator('.mp-performance-overview > section').nth(2)).toHaveAccessibleName('Operational health (OHS)')
  for (const icon of await page.locator('.mp-review-ring-icon > svg').all()) {
    const graphic = await icon.evaluate(element => ({ width: element.getBoundingClientRect().width, stroke: Number.parseFloat(getComputedStyle(element).strokeWidth) }))
    expect(graphic.width).toBeLessThanOrEqual(30)
    expect(graphic.stroke).toBeLessThanOrEqual(3)
  }
  await assertScoreCardAlignment()
  if (page.viewportSize()!.width >= 1280) {
    const vps = await page.getByRole('region', { name: 'Public standing' }).boundingBox()
    for (const title of ['Badges', 'Badge metrics']) {
      const panel = await page.getByRole('region', { name: title, exact: true }).boundingBox()
      expect(panel!.x).toBeGreaterThanOrEqual(vps!.x + vps!.width)
    }
  }
  const standing = page.getByRole('region', { name: 'Public standing' })
  const badges = page.getByRole('region', { name: 'Badges', exact: true })
  await expect(badges).toContainText('2 of 6 earned')
  await expect(badges.locator('.mp-performance-emblem')).toHaveCount(6)
  await expect(badges.getByText('Suppressed by review')).toBeVisible()
  await expect(page.getByRole('region', { name: 'Badge metrics', exact: true }).locator('.mp-performance-rate-graphic')).toHaveCount(2)
  await expect(standing.locator('[data-score-key="VCS"]')).toContainText('4.47 / 5')
  await expect(standing.locator('[data-score-key="OHS"]')).toContainText('4.25 / 5')
  await expect(page.getByRole('heading', { name: 'Store health indicator' })).toBeVisible()
  await expect(page.getByText('Outside the no-penalty band: LSR.')).toBeVisible()
  await expect(page.getByRole('region', { name: 'Operational performance' }).locator('.mp-kpi-card')).toHaveCount(4)
  await expect(page.getByText('On-time fulfillment (FRR)')).toBeVisible()
  const metrics = page.getByRole('region', { name: 'Operational performance' })
  for (const label of ['Order completion rate', 'Cancelled orders', 'Orders with disputes', 'Average order decision time']) await expect(metrics.getByText(label, { exact: true })).toBeVisible()
  const history = page.getByRole('region', { name: 'Score history', exact: true })
  const historyBox = await history.boundingBox()
  const metricCards = await metrics.locator('.mp-kpi-card').evaluateAll(elements => elements.map(element => { const bounds = element.getBoundingClientRect(); return { x: bounds.x, y: bounds.y, width: bounds.width, height: bounds.height } }))
  if (page.viewportSize()!.width >= 1280) {
    expect(metricCards[1]!.x).toBeGreaterThan(metricCards[0]!.x)
    expect(Math.abs(metricCards[1]!.y - metricCards[0]!.y)).toBeLessThan(1)
    expect(metricCards[2]!.y).toBeGreaterThan(metricCards[0]!.y)
    expect(Math.abs(metricCards[2]!.x - metricCards[0]!.x)).toBeLessThan(1)
    const values = await metrics.locator('.mp-kpi-value').evaluateAll(elements => elements.map(element => element.getBoundingClientRect().top))
    expect(Math.abs(values[0]! - values[1]!)).toBeLessThan(1)
    expect(Math.abs(values[2]! - values[3]!)).toBeLessThan(1)
    expect(historyBox!.x).toBeGreaterThanOrEqual((await metrics.boundingBox())!.x + (await metrics.boundingBox())!.width)
    expect(Math.abs(historyBox!.y - (await metrics.boundingBox())!.y)).toBeLessThan(1)
  }
  const metricsBottom = await page.getByRole('region', { name: 'Operational performance' }).evaluate(element => element.getBoundingClientRect().bottom)
  expect(await page.locator('.mp-performance-overview').evaluate(element => element.getBoundingClientRect().top)).toBeGreaterThanOrEqual(metricsBottom)
  expect(await page.locator('.mp-performance-overview').evaluate(element => element.getBoundingClientRect().top)).toBeGreaterThanOrEqual(historyBox!.y + historyBox!.height)
  const ohs = page.getByRole('region', { name: 'Operational health (OHS)' })
  await expect(ohs.getByText('Non-Fulfillment Rate (NFR)')).toBeVisible()
  await expect(ohs.getByText('2 of 136 · Penalty None')).toBeVisible()
  await expect(ohs.getByText('Listing Violation Deduction (LVD)')).toBeVisible()
  await expect(page.locator('[data-store-performance] details, [data-store-performance] summary, [data-store-performance] select')).toHaveCount(0)
  await expect(page.getByRole('table', { name: 'Published score history' })).toHaveCount(0)
  expect(insightRequests.every(url => url.searchParams.get('days') === '30')).toBe(true)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  for (const card of await page.locator('.mp-performance-rating, .mp-performance-health, .mp-performance-metrics > div').all()) expect(await card.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  const columns = await page.locator('.mp-performance-overview').evaluate(element => getComputedStyle(element).gridTemplateColumns.split(' ').length)
  expect(columns).toBe(page.viewportSize()!.width >= 1280 ? 3 : page.viewportSize()!.width >= 768 ? 2 : 1)
  await page.screenshot({ path: testInfo.outputPath('store-performance-published.png'), fullPage: true })
  await page.locator('.mp-performance-operations').screenshot({ path: testInfo.outputPath('store-performance-operations.png') })
  await page.getByRole('region', { name: 'Store health indicator', exact: true }).screenshot({ path: testInfo.outputPath('store-performance-health.png') })
  await page.locator('.mp-performance-overview').screenshot({ path: testInfo.outputPath('store-score-cards-published.png') })

  const trigger = page.getByRole('button', { name: 'How this is calculated: Store health indicator' })
  await trigger.focus()
  await page.keyboard.press('Enter')
  await expect(page.getByRole('dialog', { name: 'Store health indicator' })).toBeVisible()
  await expect(page.getByRole('dialog')).toContainText('does not change scores, badges, discovery or sanctions')
  expect(await page.getByRole('dialog').evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await page.keyboard.press('Escape')
  await expect(trigger).toBeFocused()
  await expect(page.getByText('Customer Response Rate (CRR)')).toBeVisible()

  pendingHealth = true
  await page.reload()
  await expect(page.getByRole('figure', { name: 'Community rating (VCS): 4.00 out of 5' })).toBeVisible()
  await expect(page.getByRole('figure', { name: 'Material quality (MQS): 4.00 out of 5' })).toBeVisible()
  await expect(page.getByRole('figure', { name: 'Operational health (OHS): not published' })).toBeVisible()
  await expect(page.getByRole('meter', { name: 'OHS sample' })).toHaveAttribute('aria-valuetext', '7 of 10')
  await expect(page.getByRole('region', { name: 'Operational health (OHS)' }).locator('.mp-review-ring-value')).toHaveCount(0)
  await assertScoreCardAlignment()
  await page.locator('.mp-performance-overview').screenshot({ path: testInfo.outputPath('store-score-cards-mixed.png') })

  unpublished = true
  await page.reload()
  await expect(page.getByRole('figure', { name: 'Community rating (VCS): not published' })).toBeVisible()
  await expect(page.getByRole('meter', { name: 'MQS sample' })).toHaveAttribute('aria-valuetext', '4 of 5')
  await expect(page.getByRole('meter', { name: 'OHS sample' })).toHaveAttribute('aria-valuetext', '4 of 10')
  await expect(page.getByRole('region', { name: 'Public standing' }).locator('[data-score-key="OHS"]')).toContainText('Not published')
  await expect(page.getByText('Neither VPS nor OHS is published yet.')).toBeVisible()
  await assertScoreCardAlignment()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('store-performance-building.png'), fullPage: true })
  await page.locator('.mp-performance-operations').screenshot({ path: testInfo.outputPath('store-performance-operations-building.png') })
  await page.locator('.mp-performance-overview').screenshot({ path: testInfo.outputPath('store-score-cards-building.png') })
})
