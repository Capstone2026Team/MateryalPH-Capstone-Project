import { expect, test } from '@playwright/test'

const orderId = '00000000-0000-7000-8000-000000000001'
const store = { latitude: 14.6, longitude: 121.1, label: 'Sample store, Quezon City, Metro Manila' }
const destination = { latitude: 14.62, longitude: 121.12, label: 'Sample north gate, Quezon City, Metro Manila' }
const states = [{ family: 'ORDER', state: 'AWAITING_VENDOR_CONFIRMATION' }, { family: 'PAYMENT', state: 'NOT_REQUIRED' }, { family: 'FULFILLMENT', state: 'NOT_STARTED' }, { family: 'REFUND', state: 'NOT_REQUESTED' }, { family: 'DISPUTE', state: 'NONE' }]

for (const delivery of [true, false]) for (const drawer of [true, false]) {
  test(`${delivery ? 'delivery' : 'pickup'} ${drawer ? 'drawer' : 'full order'} shows buyer identity and a responsive location map`, async ({ page }, testInfo) => {
    // Deterministic SDK layout fixture. This does not verify live Google tiles or route accuracy.
    await page.addInitScript(() => {
      const state = window as unknown as { google: object }
      state.google = { maps: {
        Map: class {
          constructor(element: HTMLElement) {
            element.style.background = 'repeating-linear-gradient(25deg, #f1f5f9 0 45px, #fff 46px 52px)'
            element.innerHTML = '<p style="padding:16px;font:14px sans-serif;color:#334155">Map layout fixture · saved order locations</p>'
          }
          fitBounds() {}
        },
        Marker: class { setMap() {} }, Polyline: class { setMap() {} }, LatLngBounds: class { extend() {} }, event: { clearInstanceListeners() {} },
      } }
    })
    let photoReads = 0
    await page.route('**/api/v1/**', async route => {
      const path = new URL(route.request().url()).pathname
      let data: unknown = {}, meta: unknown = {}
      const summary = { id: orderId, reference: 'ORD-2026-MAPTEST', vendor: { id: 'sample-store', name: 'Sample Supply' }, submitted_at: '2026-11-06T01:00:00Z', procurement_type: 'ITEM_BASED', states,
        fulfillment_method: delivery ? 'DELIVERY' : 'PICKUP', payment_method: 'ONLINE', line_count: 1, first_line: { display_name: 'Sample cement', image: null }, materials_centavos: 275000, delivery_centavos: 0, commercial_total_centavos: 275000, delivery_pending: false, buyer: { display_name: 'Sample Buyer' }, primary_action: 'NONE' }
      if (path.endsWith('/buyer-photo')) {
        photoReads++
        await route.fulfill({ contentType: 'image/png', body: Buffer.from('iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAIAAAD8GO2jAAAAK0lEQVR4nO3NMQ0AAAgDMPzr4d6NLFRwkDTp3+rMqRIIBAKBQCAQCAR5EixmL+h5p+dnAwAAAABJRU5ErkJggg==', 'base64') })
        return
      }
      if (path.endsWith('/profile')) data = { id: 'sample-viewer', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
      else if (path.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Sample Supply', lock_version: 1 }, permissions: ['portal.orders'], welcome_required: false, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } } }
      else if (path.endsWith('/route')) data = { origin: store, destination, encoded_polyline: '_p~iF~ps|U_ulLnnqC_mqNvxq`@', distance_meters: 4200, duration_seconds: 660, duration_basis: 'TRAFFIC_AWARE', computed_at: '2026-11-06T01:00:00Z' }
      else if (path.endsWith('/vendor/orders')) { data = [summary]; meta = { group: 'NEW', counts: { NEW: 1 }, page: 1, per_page: 20, total: 1, has_more: false, current_as_of: '2026-11-06T01:00:00Z' } }
      else if (path.endsWith(`/orders/${orderId}`)) data = { ...summary, checkout: { id: 'sample-checkout', reference: 'CHK-SAMPLE' }, submitted_at: '2026-11-06T01:00:00Z', accepted_at: null, closed_at: null, confirmation_source: null,
        deadlines: { vendor_response_due_at: null, buyer_response_due_at: null, payment_expires_at: null, server_time: '2026-11-06T01:00:00Z', timezone: 'Asia/Manila' }, commercial_version: { current: 1, accepted: null }, changes: [], expected_fulfillment_date: null,
        lines: [{ id: 'sample-line', line_number: 1, listing_id: 'sample-listing', listing_variant_id: 'sample-variant', display_name: 'Sample cement', variant_label: '40 kg', unit_code: 'BAG', unit_name: 'bag', unit_precision: 0, quantity_step: '1', requested_quantity: '10', confirmed_quantity: null, unit_price_centavos: 27500, ordinary_unit_price_centavos: 27500, volume_tier_applied: false, volume_tiers: [], gross_centavos: 275000, discount_centavos: 0, line_total_centavos: 275000, included_vat_centavos: 0, tax_category: 'NON_VAT', price_version_id: 'sample-price' }],
        destination: delivery ? { type: 'DELIVERY', heavy_vehicle_restriction: 'YES', intended: { label: 'Project site', formatted_address: 'Sample intended project site' }, alternate_drop_off: { label: 'North gate', formatted_address: destination.label }, vehicle_endpoint: 'ALTERNATE_DROP_OFF', access_instructions: 'Use the north gate.' } : { type: 'PICKUP', store_address: store.label },
        location_map: { store, destination: delivery ? destination : null }, delivery: { status: 'NOT_APPLICABLE', estimate: null, confirmed: null }, nrpc: null,
        money: { currency: 'PHP', calculation_version: 'fin02.order.v1', status: 'ADVISORY_UNTIL_VENDOR_CONFIRMATION', materials_gross_centavos: 275000, vendor_discount_centavos: 0, materials_subtotal_centavos: 275000, included_vat_centavos: 0, vat_exclusive_centavos: 275000, vat_treatment: 'NO_INCLUDED_VAT', delivery: { status: 'NOT_APPLICABLE', amount_centavos: 0, estimate: null }, nrpc: { amount_centavos: 0, within_order_value: true, status: null }, processing_fee: { status: 'PENDING_PAYMENT_CHANNEL', amount_centavos: null }, commercial_total_centavos: 275000, amount_due_online_centavos: null, online_principal_centavos: 275000, physical_balance_centavos: 0, payment_purpose: 'FULL_ORDER_PAYMENT', excludes: ['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'] },
        buyer: { display_name: 'Sample Buyer', profile_photo_path: `/vendor/orders/${orderId}/buyer-photo?version=1` }, timeline: [], lock_version: 1, auto_accept: null, reservations: [], nrpc_terms: null, decline_reasons: [], permissions: { can_confirm: false, can_revise: false, can_set_nrpc: false, can_confirm_delivery: false, can_decline: false, can_view_inventory: false } }
      await route.fulfill({ json: { data, meta, errors: [] } })
    })
    await page.goto(drawer ? `/orders?order=${orderId}` : `/orders/${orderId}`)
    const area = drawer ? page.getByRole('dialog') : page.getByRole('main')
    const avatar = area.locator('.chat-avatar img')
    await expect(avatar).toBeVisible({ timeout: 15000 })
    await expect.poll(() => avatar.evaluate(image => (image as HTMLImageElement).naturalWidth)).toBeGreaterThan(0)
    expect(photoReads).toBe(1)
    const map = area.getByRole('region', { name: delivery ? 'Order delivery map' : 'Order pickup map' })
    await expect(map).toBeVisible()
    await expect(map).toHaveAttribute('aria-busy', 'false')
    if (delivery) {
      await expect(area.getByText('4.2 km · 11 min estimated drive')).toBeVisible()
      await expect(area.getByText('Sample intended project site')).toBeVisible()
      await expect(area.getByRole('link', { name: 'Open directions' })).toHaveAttribute('href', /destination=14.62%2C121.12/)
    } else await expect(area.getByRole('link', { name: 'Open in Google Maps' })).toHaveAttribute('href', /query=14.6%2C121.1/)
    expect(await area.evaluate(element => element.scrollWidth <= element.clientWidth + 1)).toBe(true)
    await map.scrollIntoViewIfNeeded()
    await page.screenshot({ path: testInfo.outputPath('order-location.png'), fullPage: true })
  })
}
