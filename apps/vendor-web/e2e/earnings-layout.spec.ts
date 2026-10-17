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
    sales: { orders: 14, materials_before_discount_centavos: productValue + 5000, vendor_discounts_centavos: 5000, materials_after_discount_centavos: productValue, delivery_centavos: delivery },
    online: { payments: 15, principal_paid_centavos: productValue + delivery + 71000, refunded_principal_centavos: 71000 },
    physical: { records: 0, cash_on_delivery_centavos: 0, in_store_centavos: 0 },
  },
  products: { total: products.length, truncated: false, items: products },
  trend: { granularity: 'DAY', timezone: 'Asia/Manila', from: days[0], to: days.at(-1), days: days.length, points: days.map((date, index) => ({ date, ...Object.fromEntries(Object.entries(figures).map(([key, values]) => [key, values[index]])) })), previous: null },
}

async function mock(page: Page) {
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/profile')) data = { id: 'review', full_name: 'Store Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    else if (path.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Sample Supply', lock_version: 1 }, welcome_required: false,
      permissions: ['portal.earnings', 'portal.wallet', 'portal.products', 'catalog.manage', 'finance.view'], verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } } }
    else if (path.endsWith('/auth/csrf')) data = { csrf_token: 'review-csrf-token' }
    else if (path.endsWith('/vendor/finance/earnings')) data = earnings
    else if (path.endsWith('/notifications/unread-count')) data = { count: 0 }
    await route.fulfill({ json: { data, meta: { last_page: 1 }, errors: [] } })
  })
}

async function capture(page: Page, name: string) {
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth), 'no horizontal page scroll').toBe(true)
  const directory = resolve('../../docs/design/evidence/earnings')
  mkdirSync(directory, { recursive: true })
  // The portal scrolls inside its shell, so the evidence grows the viewport to the content height for one capture.
  const viewport = page.viewportSize()!
  const height = await page.evaluate(() => Math.max(...[...document.querySelectorAll('*')].map(element => element.scrollHeight)))
  await page.setViewportSize({ width: viewport.width, height: Math.min(9000, Math.max(viewport.height, height)) })
  await page.screenshot({ path: resolve(directory, `${viewport.width}-${name}.png`), fullPage: true })
  await page.setViewportSize(viewport)
}

test('Earnings cards show their calculation and the product list lays out cleanly', async ({ page }) => {
  await mock(page)
  await page.goto('/finance/earnings')
  for (const name of ['Commercial sales calculation', 'Online collections calculation', 'Physical collections calculation', 'Estimated remittance calculation']) await expect(page.getByRole('table', { name })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Product sales value' })).toBeVisible()
  await expect(page.getByRole('region', { name: 'Top selling products' })).toBeVisible()
  await capture(page, 'earnings')
})
