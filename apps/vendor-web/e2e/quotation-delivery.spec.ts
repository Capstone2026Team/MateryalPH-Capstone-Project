import { expect, test } from '@playwright/test'

test('delivery quotation exposes access, calculated and manual fees, and a persistent total', async ({ page }, testInfo) => {
  await page.addInitScript(() => {
    type MapEvent = { latLng: { lat: () => number; lng: () => number } }
    type Target = { listeners: Record<string, (event: MapEvent) => void> }
    class SampleMap {
      listeners: Target['listeners'] = {}
      constructor(element: HTMLElement) {
        element.style.background = '#f4f4f5'
        const button = document.createElement('button')
        button.textContent = 'TEST map: pin Buyer delivery point'
        button.style.cssText = 'margin:32px;padding:16px;background:white;border:1px solid #bbb;border-radius:8px'
        button.onclick = () => this.listeners.click?.({ latLng: { lat: () => 14.65, lng: () => 121.02 } })
        element.appendChild(button)
      }
      setCenter() {}
      setZoom() {}
    }
    class SampleMarker {
      listeners: Target['listeners'] = {}
      setPosition() {}
      getPosition() { return { lat: () => 14.65, lng: () => 121.02 } }
    }
    ;(window as unknown as { google: unknown }).google = { maps: { Map: SampleMap, Marker: SampleMarker, event: { addListener(target: Target, name: string, handler: (event: MapEvent) => void) { target.listeners[name] = handler; return { remove() { delete target.listeners[name] } } } } } }
  })
  const permissions = ['portal.messages', 'quotations.publish', 'orders.confirm']
  const draft = { lines: [{ variant_id: 'variant', description: 'Rerolled steel bar · 15×12', specifications: { grade: 'Grade 170', length_m: '12', diameter_mm: '15' }, quantity: '200', unit_price_centavos: 28550 }], message: 'Hello po, please review the materials and delivery arrangement. Thank you for choosing Sample Hardware.', fulfillment_method: 'DELIVERY', fulfillment_date: '2099-01-01', delivery: { access_confirmed: true, heavy_vehicle_access_confirmed: true, arrangement: 'One truck trip to the Buyer-confirmed site.' } }
  const quotation: Record<string, unknown> = { id: 'quote', state: 'DRAFT', lock_version: 1, draft, can_draft: true, can_publish: true }
  const conversation = { id: 'conversation', purpose: 'SALES', context_type: 'ITEM_BASED', lock_version: 1, store: { id: 'store', name: 'Sample Hardware', verified: true }, handler: { display_name: 'Sample Owner', role: 'OWNER', avatar_path: null }, unread_count: 0, channel: 'fixture', can_transfer: false, updated_at: '2026-10-28T00:00:00Z', locked_reference: { destination: { intended: { formatted_address: 'Buyer-confirmed site, Quezon City' }, heavy_vehicle_restriction: 'NO' } } }
  const vehicle = { vehicle_id: 'truck', name: 'Sample flatbed truck', vehicle_category: 'TRUCK', vehicle_type: 'FLATBED_TRUCK', brand: 'Sample brand', number_available: 2, capacity_kg: '10000', mixer_capacity_m3: null, heavy_classification: 'HEAVY', maximum_distance_km: 50, base_fee_centavos: 50000, per_km_centavos: 2500, per_trip_centavos: 60500, within_range: true, rate_version: 1, configuration_version: 1, number_of_vehicles: 1, total_vehicle_trips: 1, estimated_charge_centavos: 60500, recommended: true }
  await page.route('**/api/v1/**', async route => {
    const path = new URL(route.request().url()).pathname
    let data: unknown = {}
    if (path.endsWith('/csrf')) data = { csrf_token: 'quotation-layout-fixture' }
    else if (path.endsWith('/profile')) data = { id: 'fixture', full_name: 'Sample Owner', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER', permissions }
    else if (path.includes('/onboarding')) data = { lock_version: 1, requirements: [], drafts: [], step_completion: [], welcome_required: false, organization: { store_name: 'Sample Hardware', business_type: 'CORPORATION', lock_version: 1 }, permissions, activation: { status: 'ACTIVE' }, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED', vacation_mode: false, media: [], profile: { public_store_name: 'Sample Hardware' } }, sections: {} }
    else if (path.endsWith('/messaging/realtime')) data = { enabled: false, key: null, host: null, port: 443, scheme: 'https' }
    else if (path.endsWith('/conversations')) data = { items: [conversation], has_more: false, page: 1 }
    else if (path.endsWith('/quotation/location')) {
      const selection = route.request().postDataJSON() as { query?: string; latitude?: number; longitude?: number; address_id?: string }
      data = { id: selection.query ? 'searched-location' : 'pinned-location', formatted_address: selection.query ? 'Searched Buyer address, Quezon City' : 'Pinned Buyer delivery point, Quezon City', latitude: selection.latitude ?? 14.61, longitude: selection.longitude ?? 121.01 }
    }
    else if (path.endsWith('/quotation/delivery-plan')) data = { advisory: true, status: 'CANDIDATES_AVAILABLE', reason: 'Vehicles available', route: { distance_meters: 4200, duration_seconds: 600, source: 'GOOGLE_ROUTES', basis: 'ROAD' }, endpoint: { kind: 'INTENDED_LOCATION', heavy_vehicle_restriction: 'NO', intended: null, alternate_drop_off: null }, groups: [{ key: 'variant', label: 'Reinforcing steel bar', status: 'CANDIDATES_AVAILABLE', candidates: [vehicle], manual_review_reasons: [] }], eligible_vehicles: [vehicle], fee_formula: { calculation_version: 'fixture', rounding: 'HALF_UP', final_fee_rule: 'FORMULA' }, notice: 'Review before publishing.' }
    else if (path.endsWith('/quotation/draft')) {
      const body = route.request().postDataJSON() as { draft: unknown; lock_version: number }
      quotation.draft = body.draft; quotation.lock_version = body.lock_version + 1
      data = { quotation, versions: [], has_more: false, page: 1 }
    } else if (path.endsWith('/conversations/conversation')) data = { conversation, messages: { items: [], has_more: false, next_before: null }, quotations: { quotation, versions: [], has_more: false, page: 1 } }
    else if (path.includes('/catalog/listings')) data = { items: [], page: 1, has_more: false }
    await route.fulfill({ status: 200, contentType: 'application/json', body: JSON.stringify({ data, meta: {}, errors: [] }) })
  })
  await page.goto('/messages?conversation=conversation')
  await page.getByRole('button', { name: 'Prepare quotation', exact: true }).click()
  await expect(page.getByText('Quotation order total: ₱57,705.00')).toBeVisible()
  const editor = page.getByRole('dialog', { name: 'Prepare quotation', exact: true })
  await expect(editor.getByRole('heading', { name: 'Materials', exact: true })).toBeVisible()
  await expect(editor.getByLabel('Subtotal for Rerolled steel bar · 15×12')).toContainText('₱57,100.00')
  await expect(editor.getByRole('button', { name: 'Publish quotation' })).toBeVisible()
  expect(await editor.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  expect(await editor.locator('section, aside').evaluateAll(elements => elements.filter(element => element.clientWidth > 0 && element.scrollWidth > element.clientWidth + 1).map(element => element.getAttribute('aria-label')))).toEqual([])
  await page.screenshot({ path: testInfo.outputPath('quotation-editor-overview.png'), fullPage: true })
  const access = page.getByRole('combobox', { name: 'Does the Buyer know of a heavy-vehicle restriction?' })
  await access.scrollIntoViewIfNeeded()
  await expect(access).toHaveValue('NO')
  await expect(page.getByText('Buyer-confirmed site, Quezon City', { exact: true })).toBeVisible()
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= window.innerWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('quotation-destination.png'), fullPage: true })
  await expect(page.getByRole('button', { name: 'Current location', exact: true })).toHaveAttribute('aria-pressed', 'true')
  await expect(page.getByRole('textbox', { name: 'Search Buyer location' })).toHaveCount(0)
  await page.getByRole('button', { name: 'Alternate Buyer Location', exact: true }).click()
  let picker = page.getByRole('dialog', { name: 'Alternate Buyer Location', exact: true })
  await picker.getByRole('textbox', { name: 'Search Buyer location' }).fill('School near the Buyer site')
  await picker.getByRole('button', { name: 'Search address' }).click()
  await expect(picker.getByText('Searched Buyer address, Quezon City', { exact: true })).toBeVisible()
  await picker.getByRole('button', { name: 'Cancel', exact: true }).click()
  await expect(page.getByText('Buyer-confirmed site, Quezon City', { exact: true })).toBeVisible()
  await page.getByRole('button', { name: 'Alternate Buyer Location', exact: true }).click()
  picker = page.getByRole('dialog', { name: 'Alternate Buyer Location', exact: true })
  await picker.getByRole('button', { name: 'TEST map: pin Buyer delivery point' }).click()
  await expect(picker.getByText('Pinned Buyer delivery point, Quezon City', { exact: true })).toBeVisible()
  expect(await picker.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await page.screenshot({ path: testInfo.outputPath('quotation-map-popup.png'), fullPage: true })
  await picker.getByRole('button', { name: 'Use this location' }).click()
  await expect(page.getByRole('dialog', { name: 'Alternate Buyer Location', exact: true })).toHaveCount(0)
  await expect(page.getByText('Pinned Buyer delivery point, Quezon City', { exact: true })).toBeVisible()
  await page.getByRole('checkbox', { name: 'Drop-off access confirmed with Buyer' }).check()
  await page.getByRole('checkbox', { name: 'Heavy vehicle access confirmed' }).check()
  await expect(page.getByText('Quotation order total: ₱57,705.00')).toBeVisible()
  const manual = page.getByRole('checkbox', { name: 'Enter delivery fee manually' })
  const fulfillment = editor.getByRole('region', { name: 'Fulfillment', exact: true })
  await expect(fulfillment.getByRole('region', { name: 'Delivery arrangement', exact: true })).toBeAttached()
  await fulfillment.getByRole('heading', { name: 'Delivery arrangement & fee' }).scrollIntoViewIfNeeded()
  await page.screenshot({ path: testInfo.outputPath('quotation-delivery-card.png'), fullPage: true })
  await manual.check()
  await page.getByRole('textbox', { name: 'Delivery fee before discount (₱)' }).fill('700.00')
  await expect(page.getByText('Quotation order total: ₱57,800.00')).toBeVisible()
  await expect(page.getByRole('button', { name: 'Publish quotation' })).toBeDisabled()
  await page.getByRole('textbox', { name: /Reason for changing the system recommendation/ }).fill('Includes the Buyer-confirmed unloading assistance.')
  await expect(page.getByRole('button', { name: 'Publish quotation' })).toBeEnabled()
  await page.screenshot({ path: testInfo.outputPath('quotation-manual-fee.png'), fullPage: true })
  await page.getByRole('combobox', { name: 'Fulfillment', exact: true }).selectOption('PICKUP')
  await editor.getByRole('complementary', { name: 'Quotation order summary' }).scrollIntoViewIfNeeded()
  await page.getByRole('textbox', { name: 'Vendor discount (%)' }).fill('5')
  await expect(page.getByText('Quotation order total: ₱54,245.00')).toBeVisible()
  await page.screenshot({ path: testInfo.outputPath('quotation-pickup-summary.png'), fullPage: true })
})
