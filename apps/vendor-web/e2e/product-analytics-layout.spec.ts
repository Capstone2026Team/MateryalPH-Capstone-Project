import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

// Layout evidence for Store Performance (scores and Product analytics), the product page and My Products analytics.
// Every API call is mocked with realistic values so the review needs no backend.
const days = Array.from({ length: 30 }, (_, index) => { const date = new Date(Date.UTC(2026, 8, 11 + index)); return date.toISOString().slice(0, 10) })
const views = days.map((_, index) => 18 + ((index * 7) % 11) + (index % 7 === 5 ? 9 : 0) + Math.round(index / 3))
const orders = days.map((_, index) => 2 + ((index * 5) % 4))
const rate = (numerator: number, denominator: number) => ({ percent: denominator === 0 ? null : ((numerator / denominator) * 100).toFixed(2), numerator, denominator })
const delta = (value: number, previous: number) => ({ value, previous, change_percent: previous === 0 ? null : Math.round(((value - previous) / previous) * 1000) / 10 })
const forecast = { state: 'OK', observed_days: 30, direction: 'INCREASING', change_percent: 18.4, r_squared: 0.62, weekday_strength: 0.31, expected_total: 236,
  points: Array.from({ length: 7 }, (_, index) => ({ date: new Date(Date.UTC(2026, 9, 11 + index)).toISOString().slice(0, 10), value: 33 + index, lower: 24 + index, upper: 42 + index })), anomalies: [] }
const products = [
  ['p1', 'Portland Cement Type I 40kg', 'Cement and Concrete', 'IN_STOCK', 248, 160, 61, 74, 58, 1428000, 'Popular and converting'],
  ['p2', 'Deformed Steel Bar 10mm × 6m', 'Steel and Rebar', 'LIMITED_STOCK', 196, 130, 19, 21, 17, 986000, 'Viewed but rarely ordered'],
  ['p3', 'Concrete Hollow Block 4"', 'Masonry', 'IN_STOCK', 122, 88, 30, 41, 29, 512500, 'Popular and converting'],
  ['p4', 'Marine Plywood 3/4" 4×8', 'Lumber and Wood', 'OUT_OF_STOCK', 97, 70, 8, 9, 8, 410400, 'Viewed but rarely ordered'],
  ['p5', 'Washed Sand (per cu.m.)', 'Aggregates', 'IN_STOCK', 41, 30, 14, 16, 13, 268000, 'Converts when found'],
  ['p6', 'GI Tie Wire #16', 'Steel and Rebar', 'IN_STOCK', 22, 18, 7, 9, 7, 54000, 'Converts when found'],
  ['p7', 'Roofing Nails 2.5"', 'Hardware', 'IN_STOCK', 9, 8, 0, 0, 0, 0, 'Low visibility'],
] as const
function row([id, name, category, stock, viewCount, viewers, converted, orderCount, buyers, value, segment]: typeof products[number], index: number) {
  const lower = viewers === 0 ? null : Math.max(0, (converted / viewers) - 1.96 * Math.sqrt((converted / viewers) * (1 - converted / viewers) / viewers))
  return { listing_id: `0192a000-0000-7000-8000-00000000000${index + 1}`, key: id, name, sku: `SKU-${index + 101}`, category, status: 'ACTIVE', stock_status: stock, views: viewCount, previous_views: Math.round(viewCount * 0.8), views_change_percent: 25,
    viewers, converted, conversion: rate(converted, viewers), conversion_lower_bound: lower === null ? null : Math.round(lower * 10000) / 10000, orders: orderCount, previous_orders: Math.round(orderCount * 0.9), buyers,
    value_centavos: value, segment, rank_views: viewCount > 0 ? index + 1 : null, rank_orders: orderCount > 0 ? index + 1 : null }
}
const rows = products.map(row)
const definitions = { views: 'Product views: one signed-in Buyer opening a product’s Product Details on one Asia/Manila day counts once.', viewers: 'Distinct Buyers.', orders: 'Confirmed orders that contain the product.', value: 'Line value before cancellations and refunds.',
  conversion: 'Distinct viewers who also placed an order request containing the product, divided by distinct viewers.', top_selling: 'Ranked by order value.', top_performing: 'Ranked by the Wilson 95% lower bound of conversion.', most_viewed: 'Ranked by views.',
  categories: 'Summed by category.', forecast: 'Least-squares trend plus weekday pattern with a 95% band.', segments: 'K-Means groups over views, conversion and orders.', basket_rules: 'Apriori over 90 days.', unusual_days: 'DBSCAN.', suggestions: 'Planning suggestions.', stock: 'Stock rules.' }
const suggestions = [
  { key: 'RESTOCK_VIEWED:p4', kind: 'RESTOCK_VIEWED', priority: 'HIGH', title: 'Restock Marine Plywood 3/4" 4×8', detail: '70 Buyers viewed it in this period, but no variant has stock available to sell.', technique: 'Product views × stock status (available = on hand − hard reserved).', href: '/products/inventory', listing_id: rows[3]!.listing_id, product: rows[3]!.name },
  { key: 'REORDER_SOON:p2', kind: 'REORDER_SOON', priority: 'MEDIUM', title: 'Reorder Deformed Steel Bar 10mm × 6m soon', detail: 'A variant is at or below your reorder level while Buyers are still viewing (196 views) and ordering (21 orders) it.', technique: 'Product views and orders × the reorder level you set.', href: '/products/inventory', listing_id: rows[1]!.listing_id, product: rows[1]!.name },
  { key: 'LOW_CONVERSION:p2', kind: 'LOW_CONVERSION', priority: 'MEDIUM', title: 'Turn views of Deformed Steel Bar 10mm × 6m into orders', detail: '130 Buyers viewed it but 19 ordered (14.62%; store 27.09%). Compare your price in Materials Analytics and check its photos, specifications and stock.', technique: 'K-Means segment “Viewed but rarely ordered”: views above and conversion below your store average.', href: `/products/${rows[1]!.listing_id}`, listing_id: rows[1]!.listing_id, product: rows[1]!.name },
  { key: 'BUNDLE', kind: 'BUNDLE', priority: 'MEDIUM', title: 'Stock Portland Cement Type I 40kg with Washed Sand (per cu.m.)', detail: '46% of orders with Portland Cement Type I 40kg also include Washed Sand (per cu.m.) (2.10× more often than chance, 12 orders).', technique: 'Apriori association rule over the last 90 days of confirmed orders.', href: `/performance/products/${rows[0]!.listing_id}`, listing_id: rows[0]!.listing_id, product: rows[0]!.name },
  { key: 'CONVERTS_WHEN_FOUND:p5', kind: 'CONVERTS_WHEN_FOUND', priority: 'LOW', title: 'Keep Washed Sand (per cu.m.) ready to sell', detail: 'Buyers who open it often order it (46.67%; store 27.09%), but few see it (41 views).', technique: 'K-Means segment “Converts when found”.', href: `/performance/products/${rows[4]!.listing_id}`, listing_id: rows[4]!.listing_id, product: rows[4]!.name },
  { key: 'VIEWS_TREND', kind: 'VIEWS_RISING', priority: 'MEDIUM', title: 'Views are rising (+18.4% over the history)', detail: 'About 236 views are expected in the next 7 days. Check stock for your most-viewed products before demand arrives.', technique: 'Least-squares trend plus weekday pattern (95% band) on daily views.', href: '/products/inventory', listing_id: null, product: null },
]
const rules = [{ antecedent: [rows[0]!.name], consequent: [rows[4]!.name], support: 0.12, support_count: 12, confidence: 0.46, lift: 2.1 }, { antecedent: [rows[2]!.name], consequent: [rows[0]!.name], support: 0.09, support_count: 9, confidence: 0.38, lift: 1.4 }]
const period = { days: 30, from: days[0], to: days.at(-1), timezone: 'Asia/Manila' }
const overview = {
  generated_at: '2026-10-10T03:00:00Z', period, access: { sales_value: true }, definitions, tracking: { views_since: '2026-08-01' },
  kpis: { views: delta(735, 598), viewers: delta(412, 350), products_viewed: { value: 7, total: 8 }, orders: delta(170, 142), conversion: rate(139, 513), value_centavos: delta(3658900, 3120000) },
  series: days.map((date, index) => ({ date, views: views[index], orders: orders[index], value_centavos: orders[index]! * 21500 })), forecast: { horizon_days: 7, views: forecast },
  top_selling: rows.slice(0, 5), top_performing: [rows[0], rows[4], rows[2], rows[5], rows[1]], most_viewed: rows.slice(0, 5),
  categories: [['Cement and Concrete', 248, 74, 1428000], ['Steel and Rebar', 218, 30, 1040000], ['Masonry', 122, 41, 512500], ['Lumber and Wood', 97, 9, 410400], ['Aggregates', 41, 16, 268000]].map(([category, v, o, value]) => ({ category, views: v, orders: o, value_centavos: value })),
  segments: { state: 'OK', reason: null, k: 4, silhouette: 0.58, features: ['Product views', 'Conversion %', 'Orders'], mean_conversion_percent: 24.3,
    segments: [{ id: 0, label: 'Popular and converting', kind: 'POPULAR_CONVERTING', size: 2, average_views: 185, average_conversion_percent: 36.1, average_orders: 57.5, examples: [rows[0]!.name, rows[2]!.name] },
      { id: 1, label: 'Viewed but rarely ordered', kind: 'VIEWED_NOT_ORDERED', size: 2, average_views: 146.5, average_conversion_percent: 13, average_orders: 15, examples: [rows[1]!.name, rows[3]!.name] },
      { id: 2, label: 'Converts when found', kind: 'CONVERTS_WHEN_FOUND', size: 2, average_views: 31.5, average_conversion_percent: 42.8, average_orders: 12.5, examples: [rows[4]!.name, rows[5]!.name] },
      { id: 3, label: 'Low visibility', kind: 'LOW_VISIBILITY', size: 1, average_views: 9, average_conversion_percent: 0, average_orders: 0, examples: [rows[6]!.name] }],
    points: rows.map(item => ({ listing_id: item.listing_id, name: item.name, views: item.views, conversion_percent: item.viewers === 0 ? 0 : Math.round((item.converted / item.viewers) * 1000) / 10, orders: item.orders, segment: item.segment })) },
  basket_rules: { baskets: 152, rules, window_days: 90 }, suggestions,
  products: { items: rows, meta: { page: 1, per_page: 20, total: rows.length, last_page: 1, sort: 'views' } },
}
const detail = {
  generated_at: overview.generated_at, period, access: { sales_value: true }, definitions, tracking: overview.tracking, product: rows[0],
  kpis: { views: delta(248, 198), viewers: delta(160, 131), orders: delta(74, 66), buyers: 58, conversion: rate(61, 160), store_conversion: rate(139, 513), value_centavos: delta(1428000, 1210000), products: 8 },
  series: days.map((date, index) => ({ date, views: Math.round(views[index]! / 3), orders: Math.max(0, orders[index]! - 1), value_centavos: Math.max(0, orders[index]! - 1) * 28550 })), forecast: { horizon_days: 7, views: { ...forecast, expected_total: 78, points: forecast.points.map(point => ({ ...point, value: Math.round(point.value / 3), lower: Math.round(point.lower / 3), upper: Math.round(point.upper / 3) })) } },
  unusual_days: { state: 'OK', epsilon: 1.2, days: [{ date: days[19], views: 18, orders: 6 }] }, basket_rules: { baskets: 152, rules, window_days: 90 }, suggestions: suggestions.filter(item => item.key === 'BUNDLE'),
}
const performance = {
  calculated: true, as_of: '2026-10-09', calculated_at: '2026-10-08T16:30:00Z', label: 'VPS 4.62 of 5', next_ohs_recalculation_on: '2026-10-12', ohs_calculated_on: '2026-10-05',
  scores: [{ key: 'VPS', value: '4.62', published: true, sample_count: 0, minimum_sample: 0, window: 'Daily: VCS 50% + OHS 50%', status_text: 'Published' },
    { key: 'VCS', value: '4.49', published: true, sample_count: 23, minimum_sample: 5, window: 'Rolling 90 days', status_text: 'Published' },
    { key: 'MQS', value: '4.58', published: true, sample_count: 31, minimum_sample: 5, window: 'Rolling 90 days', status_text: 'Published' },
    { key: 'OHS', value: null, published: false, sample_count: 7, minimum_sample: 10, window: 'Trailing 30 days, recalculated weekly', status_text: 'New Vendor — Building Track Record — needs 10 eligible orders' }],
  rating_components: { service_quality: '4.50', speed: '4.40' },
  operations: { rates: { NFR: '0.00', LSR: '14.29', RR: '0.00', ODR: '0.00' }, penalties: { NFR: '0.00', LSR: '0.75', RR: '0.00', ODR: '0.00', LVD: '0.00' }, numerators: { NFR: 0, LSR: 1, RR: 0, ODR: 0 }, denominators: { NFR: 7, LSR: 7, RR: 7, ODR: 7 }, listing_violations: 0 },
  badge_metrics: [{ key: 'CRR', value: '80.00', sample_count: 5, window: 'Trailing 30 days', definition: 'Eligible inquiries answered by a person within 12 hours ÷ eligible inquiries × 100' }, { key: 'FRR', value: '92.31', sample_count: 13, window: 'Trailing 90 days', definition: 'Orders fulfilled on or before the confirmed date ÷ eligible fulfilled orders × 100' }],
  completed_orders: { last_90_days: 18, total: 41 },
  history: days.slice(-14).map((date, index) => ({ date, vps: (4.4 + index * 0.015).toFixed(2), vcs: (4.38 + index * 0.008).toFixed(2), mqs: (4.5 + index * 0.006).toFixed(2), ohs: null })),
  badges: [['FAST_RESPONDER', 'Fast Responder', 'NOT_EARNED', 'Answers at least 85% of inquiries within 12 hours (last 30 days, 10+ inquiries).'], ['HIGHLY_RATED', 'Highly Rated', 'NOT_EARNED', 'Vendor Community Score of 4.50 or higher from 10+ verified ratings (last 90 days).'],
    ['HIGH_QUALITY', 'High-Quality Materials', 'EARNED', 'Material Quality Score of 4.60 or higher from 10+ verified product ratings (last 90 days).'], ['ON_TIME', 'On-Time', 'NOT_EARNED', 'Fulfills at least 95% of orders on or before the confirmed date (last 90 days, 10+ orders).'],
    ['MOST_ORDERED', 'Most Ordered', 'NOT_EARNED', 'Top 10% by completed orders in this category and province (last 90 days, 20+ orders).'], ['TRUSTED_SUPPLIER', 'Trusted Supplier', 'NOT_EARNED', 'Verified for 90+ days with VCS and OHS of 4.50 or higher and 25+ completed orders.']]
    .map(([code, name, status, description]) => ({ code, name, status, description, scopes: [] })),
}
const listings = rows.map((item, index) => ({ id: item.listing_id, display_name: item.name, vendor_sku: item.sku, status: 'ACTIVE', compliance_status: 'NOT_REQUIRED', regulated: false, category_name: item.category, lock_version: 2, variant_count: 1,
  min_price_centavos: 28550 + index * 1000, max_price_centavos: 28550 + index * 1000, public_availability: item.stock_status, available_quantity: item.stock_status === 'OUT_OF_STOCK' ? '0.0000' : '120.0000', unit_code: 'PC', deletable: false, primary_image_url: null }))

async function mock(page: Page) {
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    let meta: Record<string, unknown> = { last_page: 1 }
    if (path.endsWith('/profile')) data = { id: 'review', full_name: 'Store Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    else if (path.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Sample Supply', lock_version: 1 }, welcome_required: false,
      permissions: ['portal.performance', 'portal.products', 'scores.view_store', 'catalog.manage', 'finance.view', 'inventory.view'], verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } } }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'review-csrf-token' }
    else if (path.endsWith('/vendor/performance')) data = performance
    else if (path.endsWith('/vendor/product-analytics')) data = overview
    else if (path.includes('/vendor/product-analytics/listings/')) data = detail
    else if (path.endsWith('/vendor/product-analytics/summaries')) data = { period, items: rows.map(item => ({ listing_id: item.listing_id, views: item.views, previous_views: item.previous_views, views_change_percent: item.views_change_percent, viewers: item.viewers, orders: item.orders, conversion: item.conversion, daily_views: views.map(value => Math.round(value * item.views / 735)) })) }
    else if (path.endsWith('/vendor/catalog/listings')) { data = listings; meta = { total: listings.length, last_page: 1, status_counts: { ACTIVE: listings.length }, active_out_of_stock: 1 } }
    else if (path.endsWith('/vendor/catalog/taxonomy')) data = { categories: [], units: [{ id: 'u', code: 'PC', name: 'Piece', dimension: 'COUNT', precision: 0 }], tags: [], attribute_definitions: [], tax_categories: [], allowed_tax_categories: [], limits: { max_variants: 50, max_media: 8, max_listing_image_kb: 5120, image_types: [] } }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
}

async function capture(page: Page, name: string) {
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), 'no horizontal page scroll').toBe(true)
  const directory = resolve('../../docs/design/evidence/product-analytics')
  mkdirSync(directory, { recursive: true })
  // The portal scrolls inside its shell, so the evidence grows the viewport to the content height for one capture.
  const viewport = page.viewportSize()!
  const height = await page.evaluate(() => Math.max(...[...document.querySelectorAll('*')].map(element => element.scrollHeight)))
  await page.setViewportSize({ width: viewport.width, height: Math.min(9000, Math.max(viewport.height, height)) })
  await page.screenshot({ path: resolve(directory, `${viewport.width}-${name}.png`), fullPage: true })
  await page.setViewportSize(viewport)
}

test('Store Performance scores, Product analytics, a product page and My Products analytics lay out cleanly', async ({ page }) => {
  await mock(page)
  await page.goto('/performance')
  await expect(page.getByRole('region', { name: 'Published scores' })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Operational health (trailing 30 days)' })).toBeVisible()
  await capture(page, 'store-performance-scores')
  await page.getByRole('tab', { name: 'Product analytics' }).click()
  await expect(page.getByRole('region', { name: 'Top selling products' })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Suggestions' })).toBeVisible()
  await capture(page, 'product-analytics')
  await page.getByRole('region', { name: 'Top selling products' }).getByRole('link', { name: 'Portland Cement Type I 40kg' }).click()
  await expect(page.getByRole('heading', { name: 'Portland Cement Type I 40kg' })).toBeVisible()
  await expect(page.getByRole('region', { name: 'From view to order' })).toBeVisible()
  await capture(page, 'product-detail')
  await page.goto('/products')
  await expect(page.getByRole('link', { name: 'Product analytics' })).toBeVisible()
  await expect(page.getByRole('link', { name: 'View product analytics' }).first()).toBeVisible()
  await capture(page, 'my-products')
})
