import { expect, test } from '@playwright/test'

// Synthetic display fixture; no live route/provider claims.
const sampleOrder = {
      id: 'order-layout', reference: 'ORD-2026-LAYOUT', checkout: { id: 'checkout-layout', reference: 'CHK-LAYOUT' }, vendor: { id: 'vendor-layout', name: 'Sample Supply' }, procurement_type: 'ITEM_BASED',
      fulfillment_method: 'PICKUP', payment_method: 'ONLINE', submitted_at: '2026-10-06T01:00:00Z', accepted_at: null, closed_at: null, terminal_reason_code: null, confirmation_source: null,
      states: [{ family: 'ORDER', state: 'AWAITING_VENDOR_CONFIRMATION' }, { family: 'PAYMENT', state: 'NOT_REQUIRED' }, { family: 'FULFILLMENT', state: 'NOT_STARTED' }, { family: 'REFUND', state: 'NOT_REQUESTED' }, { family: 'DISPUTE', state: 'NONE' }],
      deadlines: { vendor_response_due_at: '2026-10-07T01:00:00Z', buyer_response_due_at: null, payment_expires_at: null, server_time: '2026-10-06T02:00:00Z', timezone: 'Asia/Manila' },
      commercial_version: { current: 1, accepted: null, kind: 'SUBMITTED', content_hash: 'fixture', recorded_at: '2026-10-06T01:00:00Z' }, changes: [], expected_fulfillment_date: null,
      lines: [{ id: 'line-1', line_number: 1, listing_id: 'listing-1', listing_variant_id: 'variant-1', display_name: 'Portland cement', variant_label: '40 kg bag', brand: 'Sample', category: 'Cement', image: null, unit_code: 'BAG', unit_name: 'bag', unit_precision: 0, quantity_step: '1', requested_quantity: '10', confirmed_quantity: null, unit_price_centavos: 27500, ordinary_unit_price_centavos: 27500, volume_tier_applied: false, volume_tiers: [], gross_centavos: 275000, discount_centavos: 0, line_total_centavos: 275000, included_vat_centavos: 0, tax_category: 'NON_VAT', vat_label: 'Non-VAT seller', change: null, price_version_id: 'price-1' }],
      destination: { type: 'PICKUP', store_address: 'Sample store address' }, delivery: { status: 'NOT_APPLICABLE', estimate: null, confirmed: null }, nrpc: null,
      money: { currency: 'PHP', calculation_version: 'fin02.order.v1', status: 'ADVISORY_UNTIL_VENDOR_CONFIRMATION', materials_gross_centavos: 275000, vendor_discount_centavos: 0, materials_subtotal_centavos: 275000, included_vat_centavos: 0, vat_exclusive_centavos: 275000, vat_treatment: 'NO_INCLUDED_VAT', delivery: { status: 'NOT_APPLICABLE', amount_centavos: 0, estimate: null }, nrpc: { amount_centavos: 0, within_order_value: true, status: null }, processing_fee: { status: 'PENDING_PAYMENT_CHANNEL', amount_centavos: null }, commercial_total_centavos: 275000, amount_due_online_centavos: null, online_principal_centavos: 275000, physical_balance_centavos: 0, payment_purpose: 'FULL_ORDER_PAYMENT', excludes: ['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'] },
      timeline: [], lock_version: 1, buyer: { display_name: 'Sample Buyer' }, auto_accept: null, reservations: [], primary_action: 'CONFIRM', nrpc_terms: null, decline_reasons: ['STOCK_UNAVAILABLE', 'OTHER'], permissions: { can_confirm: true, can_revise: false, can_set_nrpc: false, can_confirm_delivery: false, can_decline: true, can_view_inventory: false },
    }
const profile = { name: 'Transit mixer A', brand: 'Isuzu', vehicle_type: 'CONCRETE_MIXER', vehicle_category: 'TRUCK', image_file_id: '01a0fb55-e5f2-7081-a9ee-314ee8596f70', capacity_kg: '14400', mixer_capacity_m3: '6', heavy_classification: 'HEAVY' }
const candidate = { vehicle_id: 'mixer-a', name: profile.name, vehicle_category: 'TRUCK', vehicle_type: 'CONCRETE_MIXER', custom_type_name: null, brand: 'Isuzu', number_available: 1, capacity_kg: '14400', mixer_capacity_m3: '6', heavy_classification: 'HEAVY', maximum_distance_km: 50, base_fee_centavos: 50000, per_km_centavos: 2500, per_trip_centavos: 60500, within_range: true, rate_version: 1, configuration_version: 1, number_of_vehicles: 1, total_vehicle_trips: 2, estimated_charge_centavos: 121000, recommended: true, vehicle_details: profile }

test('Site Delivery recommendations show vehicle photos, physical details and eligibility status', async ({ page }, testInfo) => {
  await page.clock.setFixedTime(new Date('2026-10-06T02:00:00Z'))
  await page.route('https://images.example.test/mixer.svg', route => route.fulfill({ contentType: 'image/svg+xml', body: '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 240 140"><rect width="240" height="140" fill="#f1f5f9"/><path d="M25 85h190v30H25z" fill="#64748b"/><ellipse cx="100" cy="65" rx="60" ry="40" fill="#cbd5e1"/><circle cx="60" cy="118" r="15" fill="#334155"/><circle cx="185" cy="118" r="15" fill="#334155"/></svg>' }))
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/csrf')) data = { csrf_token: 'vehicle-layout-fixture' }
    else if (path.endsWith('/profile')) data = { id: 'sample-owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', full_name: 'Sample Owner' }
    else if (path.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, welcome_required: false, organization: { store_name: 'Sample Supply' }, permissions: ['portal.orders', 'orders.confirm', 'vehicles.manage'], verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE' } }
    else if (path.endsWith('/vendor/orders/order-layout')) data = { ...sampleOrder, fulfillment_method: 'DELIVERY', destination: { type: 'DELIVERY', intended: { label: 'Sample site', formatted_address: 'Sample delivery site', location_id: 'site', kind: 'DELIVERY' }, heavy_vehicle_restriction: 'NO', vehicle_endpoint: 'INTENDED_LOCATION' }, delivery: { status: 'PENDING_VENDOR_REVIEW', estimate: null, confirmed: null }, permissions: { can_view: true, can_confirm: true, can_decline: true, can_revise: true, can_set_nrpc: false, can_confirm_delivery: true }, lines: sampleOrder.lines.map(line => ({ ...line, display_name: 'Ready-mixed concrete', variant_label: '3000 PSI', unit_code: 'CUM', unit_name: 'cubic meter' })) }
    else if (path.endsWith('/delivery-recommendations')) data = { advisory: true, status: 'CANDIDATES_AVAILABLE', reason: 'Eligible vehicles available', route: { distance_meters: 4200, duration_seconds: 600, basis: 'ROAD_ROUTE_STORE_TO_VEHICLE_DROP_OFF', source: 'GOOGLE_ROUTES' }, endpoint: { kind: 'INTENDED_LOCATION', heavy_vehicle_restriction: 'NO', intended: null, alternate_drop_off: null }, groups: [{ key: 'line-1', label: 'Ready-mixed concrete', status: 'CANDIDATES_AVAILABLE', manual_review_reasons: [], candidates: [candidate] }], eligible_vehicles: [candidate], fee_formula: { calculation_version: 'fixture', rounding: 'HALF_UP', final_fee_rule: 'FORMULA' }, notice: 'The Buyer approves the confirmed arrangement before payment.' }
    else if (path.includes('/fleet/vehicle-images/')) data = { url: 'https://images.example.test/mixer.svg', expires_at: '2026-10-06T02:05:00Z' }
    await route.fulfill({ json: { data, meta: {}, errors: [] } })
  })
  await page.goto('/orders/order-layout')
  const radio = page.getByRole('radio')
  await expect(radio).toBeChecked()
  const option = radio.locator('..')
  await expect(option.getByRole('img', { name: 'Transit mixer A vehicle photo' })).toBeVisible()
  await expect(option).toContainText('14,400 kg payload · 6 m³ mixer · Heavy vehicle')
  await expect(option).toContainText('Concrete Mixer Truck / Transit Mixer · Isuzu')
  await expect(option).toContainText('Recommended · Eligible for this delivery')
  await expect(page.getByLabel('Vehicles used')).toHaveValue('1')
  await expect(page.getByLabel('Total trips')).toHaveValue('2')
  const overflow = await page.evaluate(() => [...document.querySelectorAll('main *')].filter(element => element.getBoundingClientRect().right > innerWidth + 1).map(element => ({ tag: element.tagName, class: element.className, width: element.getBoundingClientRect().width, text: element.textContent?.slice(0, 70) })).slice(0, 20))
  expect(overflow).toEqual([])
  await option.screenshot({ path: testInfo.outputPath('order-vehicle-recommendation.png') })
})
