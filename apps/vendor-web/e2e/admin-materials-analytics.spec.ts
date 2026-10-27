import { expect, test } from '@playwright/test'

// Synthetic public-price aggregates exercise the Admin layout without account or provider mutations.
const scope = { code: '1300000000', name: 'National Capital Region (NCR)', level: 'REGION', level_label: 'Region', label: 'NCR', breadcrumbs: [], children_label: 'Cities', drillable: false, psgc_version: null }
const dataset = { environment: 'TEST', label: 'Recorded Marketplace Prices', demo: false, available: true }
const cell = { value: 0, suppressed: false, reason: null }
const rate = { percent: null, numerator: 0, denominator: 0, suppressed: false, reason: null }
const materialNames = ['THHN building wire · Phelps Dodge · Nominal size 2.0 mm', 'uPVC electrical conduit · Neltex · Nominal size 20 mm', 'Portland cement · Sample brand · 40 kg bag', 'Steel reinforcement · Sample brand · Grade 60 · 16 mm']

test('Materials Analytics keeps prices, dates and controls readable across screen sizes', async ({ page }) => {
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    const path = url.pathname
    let data: unknown = {}
    let meta = {}
    if (path.endsWith('/profile')) data = { id: 'sample-admin', full_name: 'Sample Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-materials-layout-csrf' }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    else if (path.endsWith('/geo-analytics/filter-options')) { data = []; meta = { current_page: 1, last_page: 1, total: 0 } }
    else if (path.endsWith('/geo-analytics/boundaries')) data = { type: 'FeatureCollection', features: [], missing_codes: [], psgc_version: null }
    else if (path.endsWith('/materials-analytics/runs')) data = Array.from({ length: 10 }, (_, i) => ({ id: `sample-run-${i}`, snapshot_date: `2026-10-${27 - i}`, revision: 1, state: 'PUBLISHED', observed_at: `2026-10-${26 - i}T16:10:00Z`, observations: 24, selected: 12, vendors: 3, delayed: false }))
    else if (path.endsWith('/materials-analytics')) {
      const query = (url.searchParams.get('q') ?? '').toLowerCase()
      data = {
        audience: 'ADMIN', source_kind: 'PUBLIC_LISTING', scope, dataset,
        window: { preset_days: 30, start_date: '2026-09-27', end_date: '2026-10-27', latest_available_date: '2026-10-27', max_days: 366, presets: [7, 30, 90] },
        current_as_of: '2026-10-27T13:00:00Z', snapshot: { date: '2026-10-27', observed_at: '2026-10-26T16:10:00Z', revision: 1 },
        update_schedule: 'Updated daily at 00:10 Asia/Manila', explanation: 'Public Tier 2 listed prices, including materials VAT where applicable. Equal weight per Vendor; not an official price index.',
        items: materialNames.map((name, i) => ({
          group_id: `sample-${i}`, display_name: name, material: { id: `material-${i}`, name }, category: { id: 'electrical', code: 'ELECTRICAL_SUPPLIES', name: 'Electrical Supplies' }, specification: { attributes: [] }, unit: { code: 'PC', name: 'Piece' }, image: null,
          start_point: { date: '2026-09-27', status: 'MISSING_DAY', average_php: null, vendor_count: null },
          end_point: { date: '2026-10-27', status: i === 1 ? 'LIMITED_DATA' : i === 3 ? 'MISSING_DAY' : 'OK', average_php: i === 3 ? null : ['32.00', '98.00', '225.00'][i], vendor_count: i === 1 ? 1 : i === 3 ? null : 3, label: i === 3 ? 'No snapshot on endpoint date' : null },
          trend: i === 2 ? { change_percent: '12.50', direction: 'INCREASING', composition_changed: true } : { change_percent: null, label: 'Insufficient Local Data — no snapshot on an endpoint date' },
          current: { vendor_count: i === 1 ? 1 : i === 3 ? 0 : 3, listing_count: i === 1 ? 1 : i === 3 ? 0 : 3, status: 'AVAILABLE' },
        })).filter(row => row.display_name.toLowerCase().includes(query)),
      }
    } else if (path.endsWith('/geo-analytics')) data = {
      scope, dataset, period: { from: '2026-10-01', to: '2026-10-27', granularity: 'WEEK' }, filters: {}, filter_applicability: [], disclosure: { minimum_persons: 1, method: 'ROLL_UP_TO_PARENT', description: 'Sample disclosure rule.' },
      kpis: { vendor_count: cell, registered_buyers: cell, gross_gmv_centavos: cell, net_gmv_centavos: cell, order_volume: cell, fulfillment_rate: rate, cancellation_rate: rate, dispute_rate: rate,
        response_time: { suppressed: false, mean_seconds: null, median_seconds: null, p90_seconds: null, answered: 0, unanswered: 0 }, active_users: { buyer: { dau: cell, wau: cell, mau: cell }, vendor: { dau: cell, wau: cell, mau: cell } } },
      children: [], trends: [], activity_trend: [], unresolved: { orders: 0, vendors: 0, registered_buyers: 0, responses: 0, activity: 0 }, definitions: {},
    }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  await page.goto('http://127.0.0.1:4174/analytics?view=materials&area=1300000000&paymentMethod=ONLINE')
  const section = page.getByRole('region', { name: 'Materials Analytics', exact: true })
  const table = section.getByRole('table', { name: 'Comparable material averages' })
  await expect(table).toBeVisible()
  await expect(table.getByRole('columnheader', { name: 'Snapshot Vendors' })).toHaveCount(1)
  await expect(table.getByText('Limited Local Data — 1 Vendor', { exact: true })).toBeVisible()
  await expect(table.getByText('+12.50% · Increasing', { exact: true })).toBeVisible()
  await expect(table.getByText('No snapshot on endpoint date', { exact: true })).toBeVisible()
  const timestamps = section.getByRole('region', { name: 'Recorded Marketplace Prices' })
  await expect(timestamps.getByText('Last successful capture', { exact: true })).toBeVisible()
  await expect(timestamps.getByText('Current offers as of', { exact: true })).toBeVisible()
  expect(await timestamps.locator('time').evaluateAll(elements => elements.map(element => element.getAttribute('datetime')))).toEqual(['2026-10-26T16:10:00.000Z', '2026-10-27T13:00:00.000Z'])
  await expect(section.getByRole('button', { name: 'Export PDF', exact: true })).toBeVisible()
  await expect(section.getByRole('button', { name: 'Export CSV', exact: true })).toBeVisible()
  await expect(section.getByRole('link', { name: `View details for ${materialNames[0]}` })).toHaveAttribute('href', /days=30&psgc=1300000000/)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  expect(await table.getByRole('cell').evaluateAll(elements => elements.every(element => {
    const bounds = element.getBoundingClientRect()
    return bounds.left >= 0 && bounds.right <= innerWidth
  }))).toBe(true)
  const health = section.getByRole('button', { name: 'Daily snapshot health', exact: true })
  await expect(health).toHaveAttribute('aria-expanded', 'false')
  await expect(page.getByRole('dialog', { name: 'Daily snapshot health' })).toHaveCount(0)
  await section.scrollIntoViewIfNeeded()
  await section.screenshot({ path: test.info().outputPath('materials-analytics.png') })
  await health.click()
  const dialog = page.getByRole('dialog', { name: 'Daily snapshot health' })
  await expect(dialog).toBeVisible()
  await expect(dialog.getByRole('listitem')).toHaveCount(10)
  await expect(dialog.getByRole('listitem').first().getByText('PUBLISHED · rev 1', { exact: true })).toBeVisible()
  await expect(dialog.getByRole('listitem').first().getByText('3 Vendors · 12 selected of 24 observations', { exact: true })).toBeVisible()
  await dialog.screenshot({ path: test.info().outputPath('snapshot-health-dialog.png') })
  expect(await dialog.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await dialog.getByRole('listitem').last().scrollIntoViewIfNeeded()
  await expect(dialog.getByRole('listitem').last()).toBeInViewport()
  await expect(dialog.getByRole('button', { name: 'Close', exact: true })).toBeInViewport()
  await page.keyboard.press('Escape')
  await expect(dialog).not.toBeVisible()
  await expect(health).toBeFocused()

  await section.getByRole('searchbox', { name: 'Search materials' }).fill('conduit')
  await section.getByRole('button', { name: 'Search', exact: true }).click()
  await expect(table.getByRole('row')).toHaveCount(2)
  await expect(table.getByText(materialNames[1]!, { exact: true })).toBeVisible()
  await section.getByRole('button', { name: 'Reset filters', exact: true }).click()
  await expect(table.getByRole('row')).toHaveCount(5)
  await expect(section.getByRole('searchbox', { name: 'Search materials' })).toHaveValue('')
  expect(new URL(page.url()).searchParams.get('area')).toBe('1300000000')
  expect(new URL(page.url()).searchParams.get('paymentMethod')).toBe('ONLINE')
})
