import { expectPortalCardDesign } from './fixtures/card-design'
import { expect, test, type Page } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

// Layout evidence for Store Performance, standalone Product Analytics, the product page and My Products analytics.
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
  { key: 'LOW_CONVERSION:p2', kind: 'LOW_CONVERSION', priority: 'MEDIUM', title: 'Turn views of Deformed Steel Bar 10mm × 6m into orders', detail: '130 Buyers viewed it but 19 ordered (14.62%; store 27.09%). Review its price, photos, specifications and stock.', technique: 'K-Means segment “Viewed but rarely ordered”: views above and conversion below your store average.', href: `/products/${rows[1]!.listing_id}`, listing_id: rows[1]!.listing_id, product: rows[1]!.name },
  { key: 'BUNDLE', kind: 'BUNDLE', priority: 'MEDIUM', title: 'Stock Portland Cement Type I 40kg with Washed Sand (per cu.m.)', detail: '46% of orders with Portland Cement Type I 40kg also include Washed Sand (per cu.m.) (2.10× more often than chance, 12 orders).', technique: 'Apriori association rule over the last 90 days of confirmed orders.', href: `/analytics/products/${rows[0]!.listing_id}`, listing_id: rows[0]!.listing_id, product: rows[0]!.name },
  { key: 'CONVERTS_WHEN_FOUND:p5', kind: 'CONVERTS_WHEN_FOUND', priority: 'LOW', title: 'Keep Washed Sand (per cu.m.) ready to sell', detail: 'Buyers who open it often order it (46.67%; store 27.09%), but few see it (41 views).', technique: 'K-Means segment “Converts when found”.', href: `/analytics/products/${rows[4]!.listing_id}`, listing_id: rows[4]!.listing_id, product: rows[4]!.name },
  { key: 'VIEWS_TREND', kind: 'VIEWS_RISING', priority: 'MEDIUM', title: 'Views are rising (+18.4% over the history)', detail: 'About 236 views are expected in the next 7 days. Check stock for your most-viewed products before demand arrives.', technique: 'Least-squares trend plus weekday pattern (95% band) on daily views.', href: '/products/inventory', listing_id: null, product: null },
]
const rules = [{ antecedent: [rows[0]!.name], consequent: [rows[4]!.name], support: 0.12, support_count: 12, confidence: 0.46, lift: 2.1 }, { antecedent: [rows[2]!.name], consequent: [rows[0]!.name], support: 0.09, support_count: 9, confidence: 0.38, lift: 1.4 }]
const period = { days: 30, from: days[0], to: days.at(-1), timezone: 'Asia/Manila' }
const overview = {
  generated_at: '2026-10-10T03:00:00Z', period, access: { sales_value: true }, definitions, tracking: { views_since: '2026-08-01' },
  kpis: { views: delta(735, 598), viewers: delta(412, 350), products_viewed: { value: 7, total: 8 }, orders: delta(170, 142), conversion: rate(139, 513), value_centavos: delta(3658900, 3120000) },
  series: days.map((date, index) => ({ date, views: views[index], orders: orders[index], value_centavos: orders[index]! * 21500 })), forecast: { horizon_days: 7, views: forecast },
  top_selling: rows.slice(0, 5), top_performing: [rows[0], rows[4], rows[2], rows[5], rows[1]], most_viewed: rows.slice(0, 5),
  top_rated: rows.slice(0, 5).map((product, index) => ({ listing_id: product.listing_id, name: product.name, category: product.category, average: (4.8 - index * 0.1).toFixed(2), count: 25 - index * 4 })),
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

const catalogProduct = {
  id: rows[0]!.listing_id, display_name: rows[0]!.name, vendor_sku: rows[0]!.sku, status: 'ACTIVE', lock_version: 2, material_match: 'EXACT',
  description: 'Type I Portland cement for general construction, concrete works and masonry. Store in a dry area and keep bags sealed until ready to use.',
  material: { id: 'sample-material', code: 'CEMENT', name: 'Portland cement', regulated: true }, brand: 'Sample Cement', manufacturer: 'Sample Cement Manufacturing', country_of_manufacture: 'Philippines',
  technical_attributes: { cement_type: 'Type I', application: 'General construction' }, tag_ids: [], custom_tags: [], regulated: true, compliance_status: 'VERIFIED', publication_version: 2,
  variants: [{ id: 'sample-variant', sku: 'CEM-40-BAG', label: '40 kg bag', unit_id: 'u', unit_code: 'BAG', pack_quantity: '1', active: true, attributes: { weight_kg: '40' }, lock_version: 1, volume_tiers: [], public_availability: 'IN_STOCK', comparability: 'COMPARABLE', price: { price_version_id: 'sample-price', version: 1, amount_centavos: 28550, tax_category: 'VAT_INCLUSIVE', included_vat_centavos: 3059 } }],
  media: [1, 2, 3].map(index => ({ id: `sample-photo-${index}`, file_id: `sample-file-${index}`, alt_text: index === 1 ? 'Cement bag front view' : index === 2 ? 'Cement bag side view' : 'Cement bag label detail', status: 'READY', version: 1, content_type: 'image/png', byte_size: 1024, scan_state: 'CLEAN' })),
  compliance_submissions: [], status_history: [], blockers: [], completion: { key: 'product', label: 'Product', steps: [] }, permissions: { can_manage: true, can_submit_compliance: true, can_publish: true, can_deactivate: true, can_delete: false },
}
const reviews = ['Alex Reyes', 'Morgan Brown'].map((name, index) => ({
  id: `0199aa10-0000-7000-8000-00000000000${index}`, type: 'PRODUCT', display_name: name, ratings: { product_quality: index === 0 ? 5 : 4 }, verified_purchase: true, edited: false,
  comment: index === 0 ? 'Good quality cement, and the bags arrived dry and properly sealed. The store kept us updated before pickup.' : 'As described and ready on the agreed date. Helpful staff and clear updates.',
  submitted_at: '2026-10-09T06:00:00Z', media: [], can_report: true, order_id: `sample-order-${index}`, order_reference: `ORD-2026-SAMPLE${index + 1}`,
  product: { listing_id: rows[0]!.listing_id, name: rows[0]!.name, variant_label: '40 kg bag' },
}))
// Clearly labelled sample product imagery for deterministic browser layout evidence.
const productPhoto = (side: boolean) => `<svg xmlns="http://www.w3.org/2000/svg" width="600" height="750" viewBox="0 0 600 750"><rect width="600" height="750" fill="#f5f6f7"/><path d="M${side ? '210 110h180l30 530H180' : '140 100h320l20 550H120'}z" fill="#e5dfd2" stroke="#b9b1a1" stroke-width="4"/><path d="M145 120h310M130 625h340" stroke="#b9b1a1" stroke-width="8"/><rect x="${side ? 215 : 145}" y="245" width="${side ? 170 : 310}" height="260" rx="3" fill="#315b53"/><text x="300" y="300" fill="white" font-size="22" font-family="Arial" text-anchor="middle">SAMPLE</text><text x="300" y="355" fill="white" font-size="${side ? 24 : 40}" font-weight="bold" font-family="Arial" text-anchor="middle">CEMENT</text><text x="300" y="400" fill="white" font-size="20" font-family="Arial" text-anchor="middle">PORTLAND TYPE I</text><text x="300" y="465" fill="white" font-size="30" font-family="Arial" text-anchor="middle">40 kg</text></svg>`

async function mock(page: Page) {
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    const path = url.pathname
    if (path.includes('/catalog-files/')) { await route.fulfill({ contentType: 'image/svg+xml', body: productPhoto(path.includes('2')) }); return }
    let data: unknown = {}
    let meta: Record<string, unknown> = { last_page: 1 }
    if (path.endsWith('/profile')) data = { id: 'review', full_name: 'Store Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    else if (path.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Sample Supply', lock_version: 1 }, welcome_required: false,
      permissions: ['portal.performance', 'portal.products', 'scores.view_store', 'catalog.manage', 'finance.view', 'inventory.view', 'reviews.view', 'reviews.report'], verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } } }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'review-csrf-token' }
    else if (path.endsWith('/vendor/performance')) data = performance
    else if (path.endsWith('/vendor/product-analytics')) data = overview
    else if (path.includes('/vendor/product-analytics/listings/')) data = { ...detail, period: { ...detail.period, days: Number(url.searchParams.get('days') ?? 30) } }
    else if (path.endsWith('/vendor/product-analytics/summaries')) data = { period, items: rows.map(item => ({ listing_id: item.listing_id, views: item.views, previous_views: item.previous_views, views_change_percent: item.views_change_percent, viewers: item.viewers, orders: item.orders, conversion: item.conversion, daily_views: views.map(value => Math.round(value * item.views / 735)) })) }
    else if (path.endsWith('/vendor/catalog/listings')) { data = listings; meta = { total: listings.length, last_page: 1, status_counts: { ACTIVE: listings.length }, active_out_of_stock: 1 } }
    else if (path.endsWith(`/vendor/catalog/listings/${rows[0]!.listing_id}`)) data = catalogProduct
    else if (path.includes('/vendor/catalog/files/')) data = { url: `${url.origin}/api/v1/catalog-files/${path.split('/').at(-1)}/content` }
    else if (path.endsWith('/vendor/reviews')) { data = reviews; meta = { page: Number(url.searchParams.get('page') ?? 1), per_page: 20, total: 24, type: 'PRODUCT', summary: { count: 24, average: 4.5, distribution: [5, 4, 3, 2, 1].map(stars => ({ stars, count: stars >= 4 ? 12 : 0 })) } } }
    else if (/\/vendor\/reviews\/[0-9a-f-]{36}$/.test(path)) data = reviews[0]
    else if (path.endsWith('/vendor/catalog/taxonomy')) data = { categories: [], units: [{ id: 'u', code: 'PC', name: 'Piece', dimension: 'COUNT', precision: 0 }], tags: [], attribute_definitions: [], tax_categories: [], allowed_tax_categories: [], limits: { max_variants: 50, max_media: 8, max_listing_image_kb: 5120, image_types: [] } }
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
}

async function capture(page: Page, name: string) {
  await expectPortalCardDesign(page)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), 'no horizontal page scroll').toBe(true)
  const directory = resolve('../../.tmp/analytics-review/products')
  mkdirSync(directory, { recursive: true })
  // The portal scrolls inside its shell, so the evidence grows the viewport to the content height for one capture.
  const viewport = page.viewportSize()!
  const height = await page.evaluate(() => Math.max(...[...document.querySelectorAll('*')].map(element => element.scrollHeight)))
  await page.setViewportSize({ width: viewport.width, height: Math.min(9000, Math.max(viewport.height, height)) })
  await page.locator('.mp-product-analytics-trend [data-scroll-body] .mp-dashboard-panel-body').evaluateAll(elements => { for (const element of elements) element.scrollTop = 0 })
  await page.screenshot({ path: resolve(directory, `${viewport.width}-${name}.png`), fullPage: true })
  await page.setViewportSize(viewport)
}

test('Product Analytics has its own navigation and preserves former analytics links', async ({ page }) => {
  await mock(page)
  await page.goto('/performance')
  await expect(page.getByRole('heading', { name: 'Store Performance', exact: true })).toBeVisible()
  await expect(page.getByRole('tab', { name: 'Product analytics' })).toHaveCount(0)
  const openNavigation = page.getByRole('button', { name: 'Open navigation' })
  if (await openNavigation.isVisible()) await openNavigation.click()
  const navigation = page.getByRole('navigation', { name: 'VENDOR PORTAL menu' })
  await expect(navigation.getByText('Materials Analytics', { exact: true })).toHaveCount(0)
  await navigation.getByRole('link', { name: 'Product Analytics', exact: true }).click()
  await expect(page).toHaveURL(/\/analytics\/products$/)
  await expect(page.getByRole('heading', { name: 'Product Analytics', exact: true })).toBeVisible()
  const quality = page.getByRole('region', { name: 'Product quality', exact: true })
  const materialQuality = quality.getByRole('region', { name: 'Material quality (MQS)', exact: true })
  const topRated = page.getByRole('region', { name: 'Top-rated products', exact: true })
  await expect(materialQuality.getByRole('figure', { name: 'Material quality (MQS): 4.58 out of 5' })).toBeVisible()
  await expect(topRated.getByRole('list', { name: 'Top-rated products' }).getByText('4.80 / 5', { exact: true })).toBeVisible()
  await expect(topRated.getByRole('link', { name: rows[0]!.name, exact: true })).toHaveAttribute('href', `/analytics/products/${rows[0]!.listing_id}`)
  await materialQuality.getByRole('button', { name: 'How this is calculated: Material quality (MQS)' }).click()
  await expect(page.getByRole('dialog', { name: 'Material quality (MQS)', exact: true })).toBeVisible()
  await page.keyboard.press('Escape')
  if (page.viewportSize()!.width >= 1280) {
    const scoreBounds = await materialQuality.boundingBox()
    const summaryBounds = await page.getByRole('region', { name: 'At a glance', exact: true }).boundingBox()
    expect(scoreBounds!.x).toBeGreaterThanOrEqual(summaryBounds!.x + summaryBounds!.width)
    expect(Math.abs(scoreBounds!.y - summaryBounds!.y)).toBeLessThan(2)
    expect(Math.abs(scoreBounds!.height - summaryBounds!.height)).toBeLessThan(2)
  }
  const productsPanel = page.getByRole('region', { name: 'All products', exact: true })
  await expect(productsPanel.getByRole('combobox')).toHaveCount(0)
  await expect(productsPanel.getByRole('radio', { name: 'Most viewed', exact: true })).toBeChecked()
  const sortChoices = productsPanel.getByRole('group', { name: 'Sort products' })
  await sortChoices.getByRole('radio', { name: 'Most viewed', exact: true }).focus()
  await page.keyboard.press('ArrowRight')
  await expect(page).toHaveURL(/sort=orders/)
  await expect(sortChoices.getByRole('radio', { name: 'Most ordered', exact: true })).toBeChecked()
  await productsPanel.getByText('Highest sales value', { exact: true }).click()
  await expect(page).toHaveURL(/sort=value/)
  const demand = page.getByRole('region', { name: 'Product demand patterns', exact: true })
  await expect(demand.getByRole('region', { name: 'Product performance segments', exact: true })).toBeVisible()
  expect(await demand.evaluate(element => element.closest('details') === null)).toBe(true)
  await expect(demand.getByRole('region', { name: 'Views by category', exact: true })).toBeVisible()
  const chart = await page.getByRole('region', { name: 'Product views and orders', exact: true }).boundingBox()
  const suggestionsPanel = await page.getByRole('region', { name: 'Suggestions', exact: true }).boundingBox()
  expect(suggestionsPanel!.y).toBeGreaterThanOrEqual(chart!.y + chart!.height)
  expect(Math.abs(suggestionsPanel!.x - chart!.x)).toBeLessThan(2)
  if (page.viewportSize()!.width >= 1440) {
    const table = await productsPanel.boundingBox()
    expect(table!.width).toBeGreaterThan(chart!.width)
    const cards = await Promise.all(['Top-rated products', 'Top selling products', 'Top performing products', 'Category share'].map(title => page.getByRole('region', { name: title, exact: true }).boundingBox()))
    for (const card of cards) expect(card!.x).toBeGreaterThanOrEqual(chart!.x + chart!.width)
    expect(Math.abs(cards[0]!.y - chart!.y)).toBeLessThan(2)
    expect(Math.abs(cards[0]!.y - cards[1]!.y)).toBeLessThan(2)
    expect(cards[1]!.x).toBeGreaterThan(cards[0]!.x)
    expect(cards[2]!.y).toBeGreaterThanOrEqual(cards[0]!.y + cards[0]!.height)
    expect(Math.abs(cards[2]!.y - cards[3]!.y)).toBeLessThan(2)
    expect(Math.abs(cards[3]!.y + cards[3]!.height - suggestionsPanel!.y - suggestionsPanel!.height)).toBeLessThan(2)
    const suggestionsList = page.getByRole('region', { name: 'Suggestions list', exact: true })
    await suggestionsList.focus()
    await page.keyboard.press('End')
    expect(await suggestionsList.evaluate(element => element.scrollTop)).toBeGreaterThan(0)
    await suggestionsList.evaluate(element => { element.scrollTop = 0 })
  } else {
    const ratingBounds = await topRated.boundingBox()
    expect(ratingBounds!.y).toBeGreaterThanOrEqual(suggestionsPanel!.y + suggestionsPanel!.height)
  }
  await page.getByRole('heading', { name: 'Product Analytics', exact: true }).click()
  await capture(page, 'product-analytics-overview')
  await page.getByRole('list', { name: 'Top selling products' }).getByRole('link', { name: rows[0]!.name }).click()
  await expect(page).toHaveURL(new RegExp(`/analytics/products/${rows[0]!.listing_id}$`))
  await expect(page.getByRole('heading', { name: rows[0]!.name, exact: true })).toBeVisible()
  if (await openNavigation.isVisible()) await openNavigation.click()
  await expect(navigation.getByRole('link', { name: 'Product Analytics', exact: true })).toHaveAttribute('aria-current', 'page')
  await page.goto('/performance?tab=products&days=90')
  await expect(page).toHaveURL(/\/analytics\/products\?days=90$/)
  await expect(page.getByRole('heading', { name: 'Product Analytics', exact: true })).toBeVisible()
  await page.goto('/analytics/materials/legacy-group')
  await expect(page).toHaveURL(/\/analytics\/products$/)
  await expect(page.getByRole('heading', { name: 'Product Analytics', exact: true })).toBeVisible()
  await page.route(url => url.pathname.endsWith('/vendor/product-analytics'), route => route.fulfill({ json: { data: {
    ...overview, kpis: { views: delta(0, 0), viewers: delta(0, 0), products_viewed: { value: 0, total: 0 }, orders: delta(0, 0), conversion: rate(0, 0), value_centavos: delta(0, 0) },
    series: days.map(date => ({ date, views: 0, orders: 0, value_centavos: 0 })), forecast: { horizon_days: 7, views: { state: 'INSUFFICIENT_DATA', observed_days: 0, direction: 'UNKNOWN', points: [], anomalies: [] } },
    top_selling: [], top_performing: [], most_viewed: [], top_rated: [], categories: [], suggestions: [],
    segments: { state: 'INSUFFICIENT_DATA', reason: 'Not enough products with activity to group yet.', features: [], segments: [], points: [] },
    basket_rules: { baskets: 0, rules: [], window_days: 90 }, products: { items: [], meta: { page: 1, per_page: 20, total: 0, last_page: 1, sort: 'views' } },
  }, meta: {}, errors: [] } }))
  await page.reload()
  await expect(page.getByText('No published products yet. Products appear here after you publish them.')).toBeVisible()
  await expect(page.getByText(/No rated products yet/)).toBeVisible()
  await expect(page.getByRole('region', { name: 'Suggestions', exact: true })).toHaveCount(0)
  await expect(page.getByText('Not enough products with activity to group yet.')).toBeVisible()
  await capture(page, 'product-analytics-empty')
})

test('Store Performance scores, Product analytics, a product page and My Products analytics lay out cleanly', async ({ page }) => {
  await mock(page)
  await page.goto('/performance')
  await expect(page.getByRole('region', { name: 'Published scores' })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Operational health (trailing 30 days)' })).not.toBeVisible()
  await expect(page.getByRole('region', { name: 'Badges', exact: true })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Badge metrics', exact: true })).not.toBeVisible()
  await page.getByText('Badge eligibility and response metrics', { exact: true }).click()
  await expect(page.getByRole('region', { name: 'Badge metrics', exact: true })).toBeVisible()
  await page.getByText('Badge eligibility and response metrics', { exact: true }).click()
  await capture(page, 'store-performance-scores')
  await page.goto('/analytics/products')
  await expect(page.getByRole('region', { name: 'Top selling products' })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Suggestions' })).toBeVisible()
  await capture(page, 'product-analytics')
  await page.getByRole('region', { name: 'Top selling products' }).getByRole('link', { name: 'Portland Cement Type I 40kg' }).click()
  await expect(page.getByRole('heading', { name: 'Portland Cement Type I 40kg' })).toBeVisible()
  await page.getByText('More product insights', { exact: true }).click()
  await expect(page.getByRole('region', { name: 'From view to order' })).toBeVisible()
  await capture(page, 'product-detail')
  await page.goto('/products')
  await expect(page.getByRole('main').getByRole('link', { name: 'Product analytics', exact: true })).toBeVisible()
  await expect(page.getByRole('list', { name: 'Store products' }).getByRole('link', { name: rows[0]!.name, exact: true })).toHaveAttribute('href', `/analytics/products/${rows[0]!.listing_id}`)
  await expect(page.getByRole('list', { name: 'Store products' }).getByRole('link', { name: 'View product analytics' })).toHaveCount(0)
  await capture(page, 'my-products')
})

test('product gallery, details, analytics and reviews follow the requested layout and retain their interactions', async ({ page }) => {
  await mock(page)
  const productPath = `/analytics/products/${rows[0]!.listing_id}?days=7&reviews_page=2`
  await page.goto(productPath)
  const information = page.getByRole('region', { name: 'Product information', exact: true })
  const analytics = page.getByRole('region', { name: 'Product analytics and reviews', exact: true })
  const mainPhoto = information.getByRole('img', { name: 'Cement bag front view', exact: true })
  await expect(mainPhoto).toBeVisible()
  await expect.poll(() => mainPhoto.evaluate((image: HTMLImageElement) => image.complete && image.naturalWidth > 0)).toBe(true)
  await expect(analytics.getByText('Alex Reyes', { exact: true })).toBeVisible()
  const picture = await page.locator('.mp-product-gallery-main').boundingBox()
  const heading = await information.getByRole('heading', { name: rows[0]!.name }).boundingBox()
  const left = await information.boundingBox()
  const right = await analytics.boundingBox()
  expect(heading!.y).toBeGreaterThan(picture!.y + picture!.height)
  if (page.viewportSize()!.width >= 1280) {
    expect(right!.x).toBeGreaterThanOrEqual(left!.x + left!.width - 1)
    expect(Math.abs(right!.y - left!.y)).toBeLessThan(2)
  } else expect(right!.y).toBeGreaterThanOrEqual(left!.y + left!.height - 1)
  await information.getByRole('button', { name: 'View product photo 2 of 3' }).focus()
  await page.keyboard.press('Enter')
  await expect(information.getByRole('img', { name: 'Cement bag side view', exact: true })).toBeVisible()
  await analytics.getByText('90 days', { exact: true }).click()
  await expect(page).toHaveURL(/days=90.*reviews_page=2/)
  await expect(information.getByRole('button', { name: 'View product photo 2 of 3' })).toHaveAttribute('aria-pressed', 'true')
  await analytics.getByRole('button', { name: /Previous/ }).click()
  await expect(page).toHaveURL(/reviews_page=1/)
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  for (const panel of [information, analytics]) expect(await panel.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await capture(page, 'product-detail-gallery')
  const returnPath = new URL(page.url()).pathname + new URL(page.url()).search
  await analytics.getByRole('button', { name: `View ${rows[0]!.name} details by Alex Reyes` }).click()
  await expect(page.getByRole('heading', { name: 'Review details' })).toBeVisible()
  await expect(page.getByRole('main').getByRole('link', { name: 'Product analytics', exact: true })).toHaveAttribute('href', returnPath)
})

test('product cards open analytics from their full surface and Return restores catalog filters', async ({ page }) => {
  await mock(page)
  const catalogPath = '/products?q=cement&status=ACTIVE&page=2'
  const detailPath = `/analytics/products/${rows[0]!.listing_id}`
  await page.goto(catalogPath)
  const card = page.getByRole('list', { name: 'Store products' }).getByRole('listitem').first()
  const name = card.getByRole('link', { name: rows[0]!.name, exact: true })
  await expect(name).toHaveAttribute('href', detailPath)
  await expect(card.getByRole('link', { name: 'Analytics', exact: true })).toHaveCount(0)
  await expect(card.getByRole('link', { name: 'View product analytics' })).toHaveCount(0)
  // The picture, measures and stock footer all activate the same semantic link.
  for (const target of [card.locator(':scope > div').first(), card.getByText('Last 30 days', { exact: true }), card.getByText('Available:', { exact: false })]) {
    await target.scrollIntoViewIfNeeded()
    const bounds = await target.boundingBox()
    expect(bounds).not.toBeNull()
    // Click the visible area as a user would; its stretched link owns the hit target.
    const point = { x: bounds!.x + bounds!.width / 2, y: bounds!.y + bounds!.height / 2 }
    if (page.viewportSize()!.width <= 390) await page.touchscreen.tap(point.x, point.y)
    else await page.mouse.click(point.x, point.y)
    await expect(page).toHaveURL(detailPath)
    await expect(page.getByRole('heading', { name: rows[0]!.name, exact: true })).toBeVisible()
    const main = page.getByRole('main')
    await expect(main.getByRole('link', { name: 'My Products', exact: true })).toHaveCount(0)
    await main.getByRole('button', { name: 'Return', exact: true }).click()
    await expect(page).toHaveURL(catalogPath)
  }
  await name.focus()
  await page.keyboard.press('Enter')
  await expect(page).toHaveURL(detailPath)
  await page.getByRole('main').getByRole('button', { name: 'Return', exact: true }).click()
  await expect(page).toHaveURL(catalogPath)
  await expect(card.getByRole('link', { name: `Edit ${rows[0]!.name}` })).toHaveAttribute('href', `/products/${rows[0]!.listing_id}`)
  await card.getByRole('link', { name: `Edit ${rows[0]!.name}` }).click()
  await expect(page).toHaveURL(`/products/${rows[0]!.listing_id}`)
})
