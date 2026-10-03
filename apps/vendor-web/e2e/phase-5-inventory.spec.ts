import { expect, test, type Page, type Route } from '@playwright/test'
import { mkdirSync } from 'node:fs'
import { resolve } from 'node:path'

// Layout evidence only: every /api/v1 call is served by a synthetic fixture, so these runs say nothing
// about live stock, delivery routing or provider readiness.
const TRUCK = '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 320 240"><rect width="320" height="240" fill="#e7e5e4"/><rect x="40" y="80" width="170" height="90" fill="#a8a29e"/><rect x="210" y="110" width="70" height="60" fill="#78716c"/><circle cx="90" cy="180" r="18" fill="#44403c"/><circle cx="240" cy="180" r="18" fill="#44403c"/></svg>'
const envelope = (data: unknown, meta: Record<string, unknown> = {}) => ({ data, meta, errors: [] })
const fulfil = (route: Route, data: unknown, meta: Record<string, unknown> = {}, status = 200) => route.fulfill({ status, contentType: 'application/json', body: JSON.stringify(envelope(data, meta)) })

const schedule = (state: string, confirmed: string, hide: string) => ({ state, confirmed_at: confirmed, first_reminder_at: null, final_reminder_at: null, hide_at: hide, days_since_confirmation: 8 })
const policy = (overrides: Record<string, unknown> = {}) => ({ status: 'DISABLED', enabled: false, paused: false, pause_reason: null, paused_at: null, allotment_quantity: '0', remaining_allotment_quantity: '0', max_unit_count: null, max_order_amount_centavos: null, current_version: 0, lock_version: 0, updated_at: null, ...overrides })
function row(id: string, name: string, label: string, onHand: string, reserved: string, reorder: string | null, publicLabel: string, autoAccept = policy()) {
  const available = String(Number(onHand) - Number(reserved))
  return {
    listing_variant_id: id, listing_id: `listing-${id}`, listing_name: name, listing_status: 'ACTIVE', variant_label: label, sku: `${id.toUpperCase()}-SKU`, unit_code: 'BAG', lock_version: 4,
    inventory: { quantity_on_hand: `${onHand}.0000`, hard_reserved_quantity: `${reserved}.0000`, soft_held_quantity: '12.0000', available_to_sell: `${available}.0000`, reorder_level: reorder, confirmed_at: '2026-09-20T00:00:00Z', updated_at: null },
    public_label: publicLabel, stock_confirmation: schedule('REMINDER', '2026-09-20T00:00:00Z', '2026-10-05T00:00:00Z'), listing_confirmation: schedule('REMINDER', '2026-09-20T00:00:00Z', '2026-10-05T00:00:00Z'),
    price: { price_version_id: `price-${id}`, version: 2, amount_centavos: 28550, tax_category: 'NON_VAT', effective_at: null },
    comparability: { status: 'NOT_YET_COMPARABLE', group_version_id: null, rule_version: 'mat03.exact-key.v1' }, auto_accept: autoAccept,
  }
}
const rows = [
  row('v1', 'Portland cement Type I with a deliberately long display name', '40 kg bag', '120', '20', '100.0000', 'LIMITED_STOCK', policy({ status: 'PAUSED', enabled: true, paused: true, pause_reason: 'ALLOTMENT_EXHAUSTED', remaining_allotment_quantity: '12', allotment_quantity: '12', lock_version: 3 })),
  row('v2', 'Concrete hollow block', '4 inch', '800', '0', null, 'IN_STOCK', policy({ status: 'ACTIVE', enabled: true, remaining_allotment_quantity: '40', allotment_quantity: '40', lock_version: 2 })),
  row('v3', 'Deformed steel bar', '10 mm × 6 m', '0', '0', '5.0000', 'OUT_OF_STOCK'),
]
const ledgerMeta = {
  current_page: 1, last_page: 1, total: 3, page_size: 25, label_rule_version: 'stock-label.reorder-level.v1', timezone: 'Asia/Manila',
  summary: { variants: 3, out_of_stock: 1, limited_stock: 1, confirmation_due: 2, stale: 0 },
  stale_listings: { count: 2, items: [{ listing_id: 'listing-v1', listing_name: 'Portland cement Type I', listing_status: 'ACTIVE', confirmation: schedule('FINAL_REMINDER', '2026-09-20T00:00:00Z', '2026-10-05T00:00:00Z') }, { listing_id: 'listing-v4', listing_name: 'Washed sand', listing_status: 'TEMPORARILY_HIDDEN_STOCK_NOT_CONFIRMED', confirmation: schedule('OVERDUE', '2026-09-10T00:00:00Z', '2026-09-25T00:00:00Z') }] },
  permissions: { can_adjust: true, can_change_price: true, can_configure_auto_accept: true, can_update_allotment: true, can_view_auto_accept: true, can_edit_settings: true },
}
const vehicle = (id: string, name: string, overrides: Record<string, unknown> = {}) => ({
  id, lock_version: 3, configuration_version: 2, vehicle_category: 'TRUCK', vehicle_type: 'BOX_TRUCK', custom_type_name: null, name, brand: 'Isuzu', image_file_id: `image-${id}`,
  number_available: 2, capacity_kg: 1000, cargo_length_m: 4, cargo_width_m: 2, cargo_height_m: 2, mixer_capacity_m3: null, heavy_classification: 'HEAVY', active: true, available: true,
  rate_version: 1, base_fee_centavos: 50000, per_km_centavos: 2500, maximum_distance_km: 40, eligibility: { eligible: true, reasons: [] }, updated_at: null, ...overrides,
})

async function vendorFixture(page: Page) {
  const calls: { method: string; path: string; body: unknown }[] = []
  await page.route('**/maps.googleapis.com/**', route => route.abort())
  await page.route('https://files.example.test/**', route => route.fulfill({ status: 200, contentType: 'image/svg+xml', body: TRUCK }))
  await page.route('**/api/v1/**', async route => {
    const request = route.request()
    const path = new URL(request.url()).pathname.replace(/^.*\/api\/v1/, '')
    const method = request.method()
    if (method !== 'GET') calls.push({ method, path, body: request.postDataJSON() })
    if (path.endsWith('/csrf')) return fulfil(route, { csrf_token: 'layout-fixture' })
    if (path.endsWith('/profile')) return fulfil(route, { id: 'fixture-owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', full_name: 'Test Owner', email: 'owner@example.test', organization_name: 'Sample Supply', lock_version: 1, created_at: '2026-09-01T00:00:00Z', permissions: [] })
    if (path.endsWith('/onboarding')) return fulfil(route, {
      step_completion: [], requirements: [], drafts: [], lock_version: 1, organization: { store_name: 'Sample Supply', lock_version: 1 }, welcome_required: false,
      permissions: ['portal.products', 'portal.vehicles', 'catalog.manage', 'inventory.view', 'inventory.manage', 'inventory.settings', 'auto_accept.configure', 'vehicles.manage'],
      verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE' }, sections: {},
    })
    if (path === '/vendor/inventory/items' && method === 'GET') return fulfil(route, rows, ledgerMeta)
    if (path === '/vendor/inventory/settings') return fulfil(route, { reminder_local_time: '08:00', email_reminders: true, in_app_reminders: true, timezone: 'Asia/Manila', reminder_days: [7, 12], hide_after_days: 15, lock_version: 1, can_edit: true })
    if (path === '/vendor/inventory/items/v1' && method === 'PATCH') {
      return route.fulfill({ status: 409, contentType: 'application/json', body: JSON.stringify({ data: null, meta: {}, errors: [{ code: 'STALE_VERSION', message: 'Someone else changed this row.', details: { current: { ...rows[0], lock_version: 5, inventory: { ...rows[0]!.inventory, quantity_on_hand: '140.0000', available_to_sell: '120.0000' } } } }] }) })
    }
    if (path === '/vendor/auto-accept/policies/v1') return fulfil(route, { listing_variant_id: 'v1', listing_id: 'listing-v1', listing_name: rows[0]!.listing_name, listing_status: 'ACTIVE', variant_label: '40 kg bag', sku: 'V1-SKU', unit_code: 'BAG', stock: { quantity_on_hand: '120.0000', hard_reserved_quantity: '20.0000', soft_held_quantity: '12.0000', available_to_sell: '100.0000' }, policy: { ...rows[0]!.auto_accept, last_editor: 'Test Owner' }, versions: [], scope: { item_based_only: true, nrpc_excluded: true, project_based_excluded: true, rule_version: 'auto-accept.item-based.v1' }, permissions: { can_configure: true, can_update_allotment: true } })
    if (path === '/vendor/fleet/vehicles' && method === 'GET') return fulfil(route, [vehicle('truck-1', 'Box truck'), vehicle('mixer-1', 'Transit mixer', { vehicle_type: 'CONCRETE_MIXER', capacity_kg: 24000, mixer_capacity_m3: 6, cargo_length_m: null, cargo_width_m: null, cargo_height_m: null }), vehicle('van-1', 'Spare van', { vehicle_category: 'VAN', vehicle_type: 'MID_SIZE_CARGO_VAN', heavy_classification: 'NOT_HEAVY', available: false, eligibility: { eligible: false, reasons: ['VEHICLE_UNAVAILABLE'] } })], { scope: 'ORGANIZATION', summary: { configurations: 3, total_vehicles: 6, active_vehicles: 6, available_vehicles: 4, out_for_delivery_vehicle_assignments: 2, out_for_delivery_orders: 1 }, delivery: { fulfillment_method: 'BOTH', delivery_enabled: true, service_radius_km: 50 }, permissions: { can_manage: true }, limits: { max_vehicles: 50 } })
    if (path.startsWith('/vendor/fleet/vehicle-images/')) return fulfil(route, { url: 'https://files.example.test/truck.svg', expires_at: '2026-10-01T00:05:00Z' })
    return fulfil(route, {})
  })
  return calls
}

/** Page-level reflow check. Wide ledger content may scroll only inside its own labelled region. */
async function fits(page: Page) {
  const overflow = await page.evaluate(() => {
    const limit = document.documentElement.clientWidth
    const wide = [...document.querySelectorAll<HTMLElement>('main *')]
      .filter(element => element.getBoundingClientRect().right > limit + 1 && getComputedStyle(element).position !== 'fixed' && !element.closest('[role="region"][tabindex="0"]') && !element.closest('[class*="overflow-x-auto"]'))
      .map(element => `${element.tagName.toLowerCase()}.${String(element.className).split(' ').slice(0, 3).join('.')} right=${Math.round(element.getBoundingClientRect().right)}`)
    return { page: document.documentElement.scrollWidth > innerWidth, wide: wide.slice(0, 5) }
  })
  expect(overflow, `horizontal overflow at ${page.viewportSize()!.width}px`).toEqual({ page: false, wide: [] })
}

async function capture(page: Page, name: string) {
  const directory = resolve('../../docs/design/evidence/phase-5')
  mkdirSync(directory, { recursive: true })
  await page.addStyleTag({ content: 'html, body, .portal-layout, .portal-workspace { height: auto !important; max-height: none !important; overflow: visible !important; } .portal-workspace > header { position: static !important; }' })
  await page.screenshot({ path: resolve(directory, `${page.viewportSize()!.width}-${name}.png`), fullPage: true })
}

test('the inventory ledger keeps its header and identifiers fixed and scrolls only inside its own region', async ({ page }) => {
  await vendorFixture(page)
  await page.goto('/products/inventory')
  const ledger = page.getByRole('table', { name: 'Inventory ledger' })
  await expect(ledger).toBeVisible()
  await expect(page.getByRole('link', { name: 'Inventory' })).toHaveAttribute('aria-current', 'page')
  const band = page.getByRole('region', { name: /need a stock confirmation/ })
  await expect(band.getByText('Hidden from Buyers', { exact: true })).toBeVisible()
  await expect(band.getByText(/\(Asia\/Manila\)/).first()).toBeVisible()
  await expect(ledger.getByText('Limited Stock')).toBeVisible()
  await expect(ledger.getByText('Paused')).toBeVisible()
  const layout = await page.evaluate(() => {
    const region = document.querySelector<HTMLElement>('[role="region"][aria-label="Inventory ledger"]')!
    const head = region.querySelector('thead')!
    const firstCell = region.querySelector('tbody th')!
    return { headPosition: getComputedStyle(head).position, firstColumnPosition: getComputedStyle(firstCell).position, scrolls: region.scrollWidth > region.clientWidth }
  })
  expect(layout.headPosition).toBe('sticky')
  expect(layout.firstColumnPosition).toBe('sticky')
  if (page.viewportSize()!.width <= 1024) expect(layout.scrolls, 'narrow widths scroll the ledger inside its own region').toBe(true)
  await fits(page)
  await capture(page, 'inventory-ledger')
})

test('an inline edit conflict keeps typed values and shows the saved row', async ({ page }) => {
  const calls = await vendorFixture(page)
  await page.goto('/products/inventory')
  await page.getByRole('button', { name: /^Edit Portland cement Type I/ }).click()
  const form = page.getByRole('form', { name: /^Edit Portland cement Type I/ })
  await form.getByLabel('Quantity on hand (BAG)').fill('150')
  await form.getByRole('button', { name: 'Save row' }).click()
  const banner = form.getByRole('alert')
  await expect(banner).toContainText('This row changed while you were editing')
  await expect(banner.getByText('140 BAG')).toBeVisible()
  await expect(form.getByLabel('Quantity on hand (BAG)')).toHaveValue('150')
  expect(calls.find(call => call.method === 'PATCH')?.body).toMatchObject({ lock_version: 4, quantity_on_hand: '150', reason_code: 'COUNT' })
  await fits(page)
  await capture(page, 'inventory-conflict')
})

test('auto-accept shows its pause state in text and asks to confirm the allotment it restores', async ({ page }) => {
  await vendorFixture(page)
  await page.goto('/products/inventory')
  await page.getByRole('button', { name: /^Auto-accept for Portland cement Type I/ }).click()
  const panel = page.getByRole('region', { name: 'Item-Based auto-accept' })
  await expect(panel.getByText('Paused — the allotment reached zero')).toBeVisible()
  await expect(panel.getByRole('switch', { name: 'Enable auto-accept' })).toHaveAttribute('aria-checked', 'true')
  for (const label of ['Allotment (BAG)', 'Max units per order (BAG)', 'Max order amount (₱)']) await expect(panel.getByLabel(label)).toBeVisible()
  await fits(page)
  await capture(page, 'auto-accept-paused')
  await panel.getByRole('button', { name: 'Resume' }).click()
  const dialog = page.getByRole('dialog', { name: 'Resume auto-accept?' })
  await expect(dialog.getByRole('button', { name: 'Resume with 12 BAG' })).toBeVisible()
  await expect(dialog.getByRole('button', { name: 'Cancel' })).toBeFocused()
  await capture(page, 'auto-accept-resume-confirmation')
})

test('vehicles open with an overview and retain per-vehicle editing and validation', async ({ page }) => {
  await vendorFixture(page)
  await page.goto('/vehicles')
  await expect(page.getByRole('heading', { name: 'Vehicles', exact: true })).toBeVisible()
  const summary = page.getByRole('region', { name: 'Fleet overview' })
  await expect(summary.getByText('Total vehicles', { exact: true })).toBeVisible()
  await expect(summary.getByText('Vehicle assignments across 1 order Out for Delivery')).toBeVisible()
  await expect(summary.getByText('6', { exact: true })).toHaveCount(2)
  await expect(summary.getByText('4', { exact: true })).toBeVisible()
  await expect(summary.getByText('2', { exact: true })).toBeVisible()
  await expect(page.getByRole('article', { name: 'Spare van' }).getByText(/Marked unavailable now/)).toBeVisible()
  await expect(page.getByRole('combobox', { name: 'Vehicle Category' })).toHaveCount(0)
  await expect(page.getByRole('button', { name: 'Add vehicle', exact: true })).toBeVisible()
  await fits(page)
  await page.screenshot({ path: test.info().outputPath('vehicles-overview.png'), fullPage: true })
  await page.getByRole('button', { name: 'Edit Transit mixer' }).click()
  await expect(page.getByRole('group', { name: /Vehicle 2/ }).getByText(/Cargo dimensions: Not applicable/)).toBeVisible()
  await page.getByRole('button', { name: 'Back to vehicles' }).click()
  await page.getByRole('button', { name: 'Edit Box truck' }).click()
  await page.getByRole('group', { name: /Vehicle 1/ }).getByLabel('Maximum Delivery Distance (km)').fill('0')
  await page.getByRole('button', { name: 'Save vehicles' }).click()
  await expect(page.getByRole('group', { name: /Vehicle 1/ }).getByText('Enter a whole number of kilometers from 1 to 1,000.')).toBeVisible()
  await expect(page.getByRole('group', { name: /Vehicle 2/ }).getByText('Enter a whole number of kilometers from 1 to 1,000.')).toHaveCount(0)
  await fits(page)
  await page.screenshot({ path: test.info().outputPath('vehicles-editor.png'), fullPage: true })
  await page.getByRole('button', { name: 'Back to vehicles' }).click()
  await page.getByRole('button', { name: 'Add vehicle', exact: true }).click()
  await expect(page.getByRole('heading', { name: 'Add vehicle', exact: true })).toBeFocused()
  await page.getByLabel('Vehicle Category').last().selectOption('MOTORCYCLE')
  await fits(page)
  await page.getByRole('button', { name: 'Discard changes' }).click()
  await expect(page.getByRole('heading', { name: 'Your vehicles' })).toBeVisible()
  await expect(page.getByRole('article')).toHaveCount(3)
})
