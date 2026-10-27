import { expect, test } from '@playwright/test'

// Synthetic responses exercise the real Admin page and shared heatmap, without signing in or changing data.
const categories = ['Cement and Concrete', 'Steel and Reinforcement', 'Aggregates', 'Electrical Supplies', 'Plumbing and Sanitary', 'Roofing Materials', 'Wood and Lumber', 'Masonry', 'Paints and Finishes']
const scope = { code: null, name: 'Philippines', level: null, level_label: 'Country', label: 'Philippines', breadcrumbs: [], children_label: 'Regions', drillable: false, psgc_version: null }
const dataset = { environment: 'TEST', label: 'Sample marketplace activity', demo: false, last_aggregated_at: '2026-10-27T02:00:00Z', through_date: '2026-10-27', revision: 1, available: true }
const cell = (value = 0) => ({ value, suppressed: false, reason: null })
const rate = { percent: null, numerator: 0, denominator: 0, suppressed: false, reason: null }

test('demand taxonomy columns, paging and readable table work across screen sizes', async ({ page }) => {
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    const path = url.pathname
    let data: unknown = {}
    let meta = {}
    if (path.endsWith('/profile')) data = { id: 'sample-layout-admin', full_name: 'Sample Admin', account_type: 'ADMIN', account_status: 'ACTIVE', role: 'ADMIN_SUPERADMIN' }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'synthetic-geographic-layout-csrf' }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    else if (path.endsWith('/geo-analytics/filter-options')) {
      data = categories.map((name, i) => ({ id: `category-${i}`, name }))
      meta = { current_page: 1, last_page: 1, total: categories.length }
    } else if (path.endsWith('/geo-analytics/boundaries')) data = { type: 'FeatureCollection', features: [], missing_codes: [], psgc_version: { id: 'sample-psgc', label: 'Sample PSGC' } }
    else if (path.endsWith('/geo-analytics/demand')) {
      const current = Number(url.searchParams.get('page') ?? 1)
      const columns = categories.slice((current - 1) * 8, current * 8).map((name, i) => ({ id: `category-${(current - 1) * 8 + i}`, name }))
      data = {
        scope, dataset, measure: url.searchParams.get('measure'), dimension: 'CATEGORY', unit: null, columns,
        column_pagination: { current_page: current, last_page: 2, total: categories.length },
        rows: Array.from({ length: 18 }, (_, i) => ({ code: String(i), name: i === 12 ? 'National Capital Region (NCR)' : i === 17 ? 'Bangsamoro Autonomous Region in Muslim Mindanao (BARMM)' : `Sample Region ${i + 1}`, level: 'REGION',
          cells: columns.map(column => ({ column: column.id, value: i === 12 && column.id === 'category-1' ? 8 : 0, suppressed: false, reason: null })) })),
        not_comparable_lines: 0, definition: 'Sample confirmed order demand, attributed to the order delivery or pickup area. Quantities require approved canonical unit conversions.',
      }
    } else if (path.endsWith('/geo-analytics')) data = {
      scope, dataset, period: { from: '2026-10-01', to: '2026-10-27', granularity: 'WEEK' }, filters: {}, filter_applicability: [], disclosure: { minimum_persons: 1, method: 'ROLL_UP_TO_PARENT', description: 'Sample disclosure rule.' },
      kpis: { vendor_count: cell(), registered_buyers: cell(), gross_gmv_centavos: cell(80000), net_gmv_centavos: cell(80000), order_volume: cell(8), fulfillment_rate: rate, cancellation_rate: rate, dispute_rate: rate,
        response_time: { suppressed: false, reason: null, mean_seconds: null, median_seconds: null, p90_seconds: null, answered: 0, unanswered: 0 }, active_users: { buyer: { dau: cell(), wau: cell(), mau: cell() }, vendor: { dau: cell(), wau: cell(), mau: cell() } } },
      children: [], trends: [], activity_trend: [], unresolved: { orders: 0, vendors: 0, registered_buyers: 0, responses: 0, activity: 0 }, definitions: {},
    }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  await page.goto('http://127.0.0.1:4174/analytics')
  const filters = page.getByRole('region', { name: 'Filters panel', exact: true })
  const toggle = filters.getByRole('button', { name: 'Filters', exact: true })
  const form = filters.getByRole('form', { name: 'Dashboard filters' })
  await expect(toggle).toHaveAttribute('aria-expanded', 'false')
  await expect(form).toBeHidden()
  await expect(page.getByText('Updates automatically', { exact: true })).toBeVisible()
  await page.screenshot({ path: test.info().outputPath('geographic-header-collapsed.png') })
  await toggle.focus()
  await page.keyboard.press('Enter')
  await expect(form).toBeVisible()
  await expect(form.getByRole('group', { name: 'Trend and materials' })).toBeVisible()
  await expect(form.getByRole('group', { name: 'Order filters' })).toBeVisible()
  await form.getByRole('combobox', { name: 'Payment', exact: true }).selectOption('IN_STORE')
  await toggle.click()
  await expect(form).toBeHidden()
  await toggle.click()
  await expect(form.getByRole('combobox', { name: 'Payment', exact: true })).toHaveValue('IN_STORE')
  await filters.screenshot({ path: test.info().outputPath('geographic-filters-expanded.png') })
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await form.getByRole('button', { name: 'Apply filters', exact: true }).click()
  await expect(page).toHaveURL(/paymentMethod=IN_STORE/)
  await toggle.click()
  await expect(filters.getByText('1 refinement', { exact: true })).toBeVisible()
  await page.getByRole('tab', { name: 'Category & material demand', exact: true }).click()
  const section = page.getByRole('region', { name: 'Category demand by area', exact: true })
  await expect(section.getByRole('columnheader', { name: 'Cement and Concrete', exact: true })).toBeVisible()
  await expect(section.getByRole('columnheader', { name: 'Steel and Reinforcement', exact: true })).toBeVisible()
  const scroll = section.getByRole('region', { name: 'Category demand by regions', exact: true })
  expect(await scroll.evaluate(element => element.clientHeight)).toBeLessThanOrEqual(page.viewportSize()!.width >= 640 ? 448 : 384)
  expect(await scroll.evaluate(element => {
    const bounds = element.getBoundingClientRect()
    const firstValue = element.querySelector('tbody td')!.getBoundingClientRect()
    return Math.min(bounds.right, firstValue.right) - Math.max(bounds.left, firstValue.left)
  })).toBeGreaterThanOrEqual(120)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await section.scrollIntoViewIfNeeded()
  await section.screenshot({ path: test.info().outputPath('demand-compact.png') })
  await scroll.evaluate(element => { element.scrollLeft = 200; element.scrollTop = 80 })
  expect(await scroll.evaluate(element => {
    const bounds = element.getBoundingClientRect()
    const areaHeader = element.querySelector('thead th')!.getBoundingClientRect()
    const rowLabel = element.querySelector('tbody th')!.getBoundingClientRect()
    return Math.abs(areaHeader.top - bounds.top) <= 1 && Math.abs(rowLabel.left - bounds.left) <= 1
  })).toBe(true)
  await scroll.evaluate(element => { element.scrollLeft = 0; element.scrollTop = 0 })
  await section.getByRole('checkbox', { name: 'Hide zero-demand areas' }).check()
  await expect(section.getByRole('rowheader', { name: 'National Capital Region (NCR)' })).toBeVisible()
  await expect(section.getByRole('status')).toContainText('1 of 18 areas')
  await section.screenshot({ path: test.info().outputPath('demand-filtered.png') })
  await expect(section.getByRole('cell', { name: '8', exact: true })).toBeVisible()
  await section.getByRole('button', { name: 'Next', exact: true }).click()
  await expect(section.getByRole('columnheader', { name: 'Paints and Finishes', exact: true })).toBeVisible()
  await expect(section.getByText('No confirmed demand in this view')).toBeVisible()
  await section.screenshot({ path: test.info().outputPath('demand-zero.png') })
  await expect(section.getByRole('button', { name: 'Next', exact: true })).toBeDisabled()
  await section.getByRole('checkbox', { name: 'Hide zero-demand areas' }).uncheck()
  await expect(section.getByRole('status')).toContainText('18 of 18 areas')
  await section.getByText('How demand is measured', { exact: true }).click()
  await expect(section.getByText(/Sample confirmed order demand/)).toBeVisible()
})
