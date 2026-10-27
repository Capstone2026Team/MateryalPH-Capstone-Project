import { expect, test } from '@playwright/test'
import reference from '../../../packages/web-ui/src/geography/philippines-regions.json' with { type: 'json' }

// Synthetic authorized aggregates; actual reference shapes test the key-free national map.
const cell = (value: number | null, suppressed = false) => ({ value, suppressed, reason: suppressed ? 'Sample small-cell protection.' : null })
const rate = { percent: '100.00', numerator: 6, denominator: 6, suppressed: false, reason: null }
const activity = { dau: cell(0), wau: cell(1), mau: cell(2) }
const country = { code: null, name: 'Philippines', level: null, level_label: 'Country', label: 'Philippines', breadcrumbs: [{ code: null, name: 'Philippines', level: null }], children_label: 'Regions', drillable: true, psgc_version: null }
const children = reference.features.map(feature => ({ code: feature.properties.code, name: feature.properties.name, level: 'REGION', level_label: 'Region', drillable: true, vendor_count: 3,
  registered_buyers: cell(null, true), gross_gmv_centavos: cell(feature.properties.code === '1300000000' ? 3487020 : 0), net_gmv_centavos: cell(0), order_volume: cell(feature.properties.code === '0300000000' ? null : 8, feature.properties.code === '0300000000'),
  fulfillment_rate: rate, cancellation_rate: rate, dispute_rate: rate, median_response_seconds: 180, response_suppressed: false, suppressed: false, suppression_note: 'Sample small-cell protection.' }))

test('the compact Philippine map aligns with the header beside KPIs and stacks cleanly on smaller screens', async ({ page }) => {
  let basemapRequests = 0
  await page.route('https://maps.googleapis.com/**', route => { basemapRequests++; return route.abort() })
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    const path = url.pathname
    const area = url.searchParams.get('area')
    let data: unknown = {}
    let meta = {}
    if (path.endsWith('/profile')) data = { id: 'sample-admin', full_name: 'Sample Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-overview-csrf' }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    else if (path.endsWith('/geo-analytics/filter-options')) { data = []; meta = { current_page: 1, last_page: 1, total: 0 } }
    else if (path.endsWith('/geo-analytics/boundaries')) data = { type: 'FeatureCollection', features: [], missing_codes: area ? ['1380600000'] : children.map(child => child.code), psgc_version: { id: 'sample', label: 'Sample PSGC' } }
    else if (path.endsWith('/geo-analytics')) {
      const selected = children.find(child => child.code === area)
      const scope = selected ? { ...country, code: area, name: selected.name, level: 'REGION', level_label: 'Region', children_label: 'Cities', breadcrumbs: [...country.breadcrumbs, { code: area, name: selected.name, level: 'REGION' }] } : country
      data = {
        scope, dataset: { environment: 'TEST', label: 'Recorded activity', demo: false, available: true, last_aggregated_at: '2026-10-27T12:00:00Z', through_date: '2026-10-27', revision: 1 },
        period: { from: '2026-07-30', to: '2026-10-27', granularity: 'WEEK' }, filters: {}, filter_applicability: [], disclosure: { minimum_persons: 5, method: 'ROLL_UP_TO_PARENT', description: 'Sample small-cell protection.' },
        kpis: { vendor_count: cell(23), registered_buyers: cell(2), gross_gmv_centavos: cell(selected ? 100000 : 3487020), net_gmv_centavos: cell(3062275), order_volume: cell(8), fulfillment_rate: rate, cancellation_rate: rate, dispute_rate: rate,
          response_time: { suppressed: false, mean_seconds: 200, median_seconds: 180, p90_seconds: 400, answered: 30, unanswered: 13 }, active_users: { buyer: activity, vendor: activity } },
        children: selected ? selected.code === '1800000000' ? [] : [{ ...children[0], code: '1380600000', name: 'Sample city', level: 'CITY', level_label: 'City', drillable: false }] : children,
        trends: [], activity_trend: [], unresolved: { orders: 0, vendors: 0, registered_buyers: 0, responses: 0, activity: 0 }, definitions: {},
      }
    }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  await page.goto('http://127.0.0.1:4174/analytics?paymentMethod=ONLINE')
  const overview = page.getByRole('region', { name: 'Philippines overview', exact: true })
  const metrics = overview.getByRole('region', { name: 'Key metrics for Philippines', exact: true })
  const header = page.getByRole('region', { name: 'Analytics header', exact: true })
  const mapPanel = overview.getByRole('region', { name: 'Interactive map for Philippines', exact: true })
  const map = mapPanel.getByRole('group', { name: 'Interactive Philippine map: Gross GMV by area', exact: true })
  await expect(map).toBeVisible()
  await expect(page.getByRole('heading', { name: 'Philippines overview', exact: true })).toHaveCount(0)
  await expect(page.getByText('The selected area applies to every panel, including Materials Analytics.', { exact: true })).toHaveCount(0)
  await expect(map.getByRole('button')).toHaveCount(18)
  await expect(map.locator('[data-area-label]')).toHaveCount(18)
  await expect(map.locator('[data-area-label="0200000000"] text')).toContainText('Cagayan Valley')
  const portraitBounds = (await map.boundingBox())!
  expect(portraitBounds.height).toBeGreaterThan(portraitBounds.width * 1.2)
  const nationalShapeBounds = await map.locator('path[role="button"]').evaluateAll(elements => {
    const boxes = elements.map(element => element.getBoundingClientRect())
    return Math.max(...boxes.map(box => box.right)) - Math.min(...boxes.map(box => box.left))
  })
  expect(nationalShapeBounds).toBeGreaterThan(portraitBounds.width * 0.85)
  await expect(metrics.getByText('₱34,870.20', { exact: true })).toBeVisible()
  const metricBounds = (await metrics.boundingBox())!, mapBounds = (await mapPanel.boundingBox())!, headerBounds = (await header.boundingBox())!
  if (page.viewportSize()!.width >= 1280) {
    expect(metricBounds.x + metricBounds.width).toBeLessThanOrEqual(mapBounds.x)
    expect(Math.abs(headerBounds.y - mapBounds.y)).toBeLessThanOrEqual(2)
    expect(metricBounds.y).toBeGreaterThan(headerBounds.y + headerBounds.height)
    expect(mapBounds.width / (metricBounds.width + mapBounds.width)).toBeLessThanOrEqual(0.46)
    expect(mapBounds.width).toBeLessThan(metricBounds.width)
    if (page.viewportSize()!.width >= 1536) expect(mapBounds.width).toBeLessThanOrEqual(512)
  } else {
    expect(headerBounds.y + headerBounds.height).toBeLessThanOrEqual(mapBounds.y)
    expect(mapBounds.y + mapBounds.height).toBeLessThanOrEqual(metricBounds.y)
  }
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.screenshot({ path: test.info().outputPath('analytics-top-layout.png') })
  await overview.screenshot({ path: test.info().outputPath('geographic-overview.png') })

  await mapPanel.getByRole('combobox', { name: 'Map metric', exact: true }).selectOption('orders')
  const orderMap = mapPanel.getByRole('group', { name: 'Interactive Philippine map: Orders by area' })
  await orderMap.getByRole('button', { name: /^Region III \(Central Luzon\)/ }).focus()
  await expect(mapPanel.getByRole('status')).toContainText('Suppressed small cell')
  const ncr = orderMap.getByRole('button', { name: /^National Capital Region/ })
  const countryPath = await ncr.getAttribute('d')
  await ncr.focus()
  await page.keyboard.press('Enter')
  await expect(page).toHaveURL(/area=1300000000/)
  await expect(page.getByRole('navigation', { name: 'Geographic level', exact: true })).toHaveCount(0)
  expect(new URL(page.url()).searchParams.get('paymentMethod')).toBe('ONLINE')
  await expect(page.getByRole('region', { name: 'Key metrics for National Capital Region (NCR)' }).getByText('₱1,000.00', { exact: true })).toBeVisible()
  const regionalPanel = page.getByRole('region', { name: 'Interactive map for National Capital Region (NCR)', exact: true })
  const regionalMap = regionalPanel.getByRole('group', { name: 'Interactive National Capital Region (NCR) map: Gross GMV by area', exact: true })
  const outline = regionalMap.getByRole('img', { name: 'Outline of National Capital Region (NCR)' })
  await expect(outline).toBeVisible()
  expect((await outline.boundingBox())!.height).toBeGreaterThan((await regionalMap.boundingBox())!.height * 0.75)
  expect(await outline.getAttribute('d')).not.toBe(countryPath)
  expect(await outline.evaluate(element => {
    const bounds = (element as SVGGraphicsElement).getBBox()
    return bounds.width > 200 && bounds.height > 200
  })).toBe(true)
  await expect(regionalMap.getByRole('button', { name: /^Sample city:/ })).toBeVisible()
  await expect(regionalMap.getByRole('img', { name: /^Boundary of / })).toHaveCount(16)
  await expect(regionalMap.getByRole('img', { name: 'Boundary of Quezon City' })).toBeVisible()
  await expect(regionalMap.locator('[data-area-label="1381300000"] text')).toContainText('Quezon')
  await expect(regionalMap.locator('[data-area-label]')).toHaveCount(17)
  await regionalPanel.screenshot({ path: test.info().outputPath('selected-region-map.png') })
  await expect(page.getByText(/Boundary outlines are unavailable for 1 area/)).toHaveCount(0)
  await regionalPanel.getByRole('button', { name: 'Back to Philippines', exact: true }).click()
  await expect(map).toBeVisible()
  await mapPanel.getByRole('combobox', { name: 'Select an area', exact: true }).selectOption('1800000000')
  await mapPanel.getByRole('button', { name: 'Explore area', exact: true }).click()
  await expect(page).toHaveURL(/area=1800000000/)
  await expect(page.getByRole('heading', { name: 'Negros Island Region (NIR)', exact: true })).toBeVisible()
  await expect(page.getByRole('img', { name: 'Outline of Negros Island Region (NIR)' })).toBeVisible()
  await expect(page.getByRole('img', { name: /^Boundary of / })).toHaveCount(3)
  await page.getByRole('button', { name: 'Back to Philippines', exact: true }).click()
  await expect(map).toBeVisible()
  await mapPanel.getByRole('combobox', { name: 'Select an area', exact: true }).selectOption('0200000000')
  await mapPanel.getByRole('button', { name: 'Explore area', exact: true }).click()
  await expect(page.getByRole('heading', { name: 'Region II (Cagayan Valley)', exact: true })).toBeVisible()
  await expect(page.getByRole('img', { name: /^Boundary of / })).toHaveCount(5)
  await expect(page.getByRole('img', { name: 'Boundary of Cagayan' })).toBeVisible()
  await expect(page.locator('[data-area-label="0201500000"] text')).toContainText('Cagayan')
  expect(basemapRequests).toBe(0)
})
