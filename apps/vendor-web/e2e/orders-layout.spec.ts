import { expect, test } from '@playwright/test'

test('order cards reflow and retain search, filters and review navigation', async ({ page }) => {
  await page.clock.setFixedTime(new Date('2026-10-06T02:00:00Z'))
  await page.route('**/api/v1/**', async route => {
    const url = new URL(route.request().url())
    let data: unknown = {}
    let meta: unknown = {}
    if (url.pathname.endsWith('/vendor/orders/order-layout')) data = {
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
    if (url.pathname.endsWith('/orders/order-layout/conversation')) data = { id: 'order-chat' }
    if (url.pathname.endsWith('/profile')) data = { id: 'layout-review', full_name: 'Layout Reviewer', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
    if (url.pathname.endsWith('/onboarding')) data = {
      step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1,
      organization: { store_name: 'Sample Supply', lock_version: 1 },
      permissions: ['portal.orders', 'portal.messages'], welcome_required: false, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' },
      activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } },
    }
    if (url.pathname.endsWith('/vendor/orders')) {
      data = url.searchParams.get('q') ? [] : [{
        id: 'order-layout', reference: 'ORD-2026-LAYOUT', vendor: { id: 'vendor-layout', name: 'Sample Supply' },
        submitted_at: '2026-10-06T01:00:00Z', procurement_type: 'ITEM_BASED', confirmation_source: null,
        states: [{ family: 'ORDER', state: 'AWAITING_VENDOR_CONFIRMATION' }, { family: 'PAYMENT', state: 'NOT_REQUIRED' }, { family: 'FULFILLMENT', state: 'NOT_STARTED' }, { family: 'REFUND', state: 'NOT_REQUESTED' }, { family: 'DISPUTE', state: 'NONE' }],
        fulfillment_method: 'DELIVERY', payment_method: 'ONLINE', line_count: 8,
        first_line: { display_name: 'Concrete and formworks materials', image: null },
        materials_centavos: 20068500, delivery_centavos: null, commercial_total_centavos: 20068500, delivery_pending: true,
        deadline: { kind: 'VENDOR_RESPONSE', at: '2026-10-07T01:00:00Z' }, expected_fulfillment_date: null,
        buyer: { display_name: 'Sample Buyer' }, primary_action: 'CONFIRM', nrpc_indicator: false,
      }]
      meta = { group: url.searchParams.get('group') ?? 'NEW', counts: { ALL: 13, NEW: 3, WAITING_ON_BUYER: 2, AWAITING_PAYMENT: 2, CONFIRMED: 2, CLOSED: 4 }, page: 1, per_page: 20, total: 1, has_more: false, current_as_of: '2026-10-06T02:00:00Z' }
    }
    await route.fulfill({ json: { data, meta, errors: [] } })
  })
  await page.goto('/orders')
  const card = page.getByRole('article', { name: 'ORD-2026-LAYOUT' })
  await expect(card).toBeVisible()
  await expect(card.getByText('Site Delivery', { exact: true })).toBeVisible()
  await expect(card.getByText('Online payment', { exact: true })).toBeVisible()
  await expect(card.getByRole('link', { name: 'Review request' })).toHaveAttribute('href', '/orders/order-layout')
  expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
  await page.screenshot({ path: `test-results/orders-${page.viewportSize()!.width}.png`, fullPage: true })
  const trigger = card.getByRole('link', { name: 'Review request' })
  await trigger.click()
  const panel = page.getByRole('dialog', { name: 'ORD-2026-LAYOUT' })
  await expect(panel.getByRole('button', { name: 'Message', exact: true })).toBeVisible()
  await expect(panel.getByRole('list', { name: 'Order progress' })).toBeVisible()
  await expect(panel.getByRole('table', { name: 'Ordered materials and prices' })).toBeVisible()
  await expect(panel.getByRole('button', { name: 'Review & confirm order' })).toBeVisible()
  await expect(panel).toHaveCSS('animation-name', 'mp-panel-enter')
  await expect(panel).toHaveCSS('transform', 'matrix(1, 0, 0, 1, 0, 0)')
  expect(await panel.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await page.screenshot({ path: `test-results/order-panel-${page.viewportSize()!.width}.png` })
  await panel.getByRole('button', { name: 'Decline request', exact: true }).click()
  await expect(page.getByRole('dialog', { name: 'Decline this request?' })).toBeVisible()
  await page.keyboard.press('Escape')
  await expect(panel).toBeVisible()
  await panel.getByRole('button', { name: 'Review & confirm order' }).click()
  await expect(page.getByRole('dialog', { name: 'Review and confirm', exact: true })).toBeVisible()
  await page.keyboard.press('Escape')
  await expect(panel).toBeVisible()
  expect(await panel.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
  await page.keyboard.press('Escape')
  await expect(panel).toHaveCount(0)
  await expect(trigger).toBeFocused()
  await page.emulateMedia({ reducedMotion: 'reduce' })
  await trigger.click()
  await expect(panel).toHaveCSS('animation-name', 'none')
  await panel.getByRole('button', { name: 'Close order details' }).click()
  await expect(panel).toHaveCount(0)
  await page.getByRole('button', { name: /^All\s+13$/ }).click()
  await expect(page).toHaveURL(/group=ALL/)
  await page.getByLabel('Search by Order ID or Buyer').fill('Missing buyer')
  await page.getByRole('button', { name: 'Search orders', exact: true }).click()
  await expect(page.getByText('No orders match “Missing buyer”.')).toBeVisible()
})
