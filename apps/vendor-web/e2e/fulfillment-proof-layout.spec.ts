import { expect, test } from '@playwright/test'
import { readFileSync } from 'node:fs'

// Synthetic, order-scoped fixtures: these checks never read real order evidence.
const orderId = '019a4b41-0000-7000-8000-000000000001'
const fileId = '019a4b41-0000-7000-8000-000000000002'
const proofPath = `/vendor/orders/${orderId}/files/${fileId}`
const at = '2026-10-13T01:00:00Z'
const image = readFileSync(new URL('../public/media/vendor-landing/materials-store-mobile.jpg', import.meta.url))

for (const method of ['PICKUP', 'DELIVERY'] as const) {
  test(`${method} fulfillment and proof popup reflow without losing order context`, async ({ page, context }) => {
    const delivery = method === 'DELIVERY'
    const proofImage = delivery ? image : Buffer.from(await page.evaluate(() => {
      const canvas = document.createElement('canvas')
      canvas.width = 256
      canvas.height = 256
      const drawing = canvas.getContext('2d')!
      drawing.fillStyle = '#f8fafc'
      drawing.fillRect(0, 0, 256, 256)
      drawing.fillStyle = '#c2410c'
      drawing.fillRect(32, 64, 192, 128)
      drawing.fillStyle = '#ffffff'
      drawing.font = 'bold 20px sans-serif'
      drawing.fillText('SAMPLE PROOF', 46, 138)
      return canvas.toDataURL('image/jpeg').split(',')[1]!
    }), 'base64')
    const handover = delivery ? 'DELIVERED' : 'PICKED_UP'
    const proof = { milestone: handover, receiver_name: 'Sample Buyer', receiver_kind: 'BUYER', handover_confirmed: true, recorded_by: 'Sample Staff', photo_path: proofPath,
      additional_photo_paths: delivery ? [proofPath.replace(fileId, '019a4b41-0000-7000-8000-000000000003')] : [], signature_path: null, vehicle: delivery ? { name: 'Accepted truck', trip_number: 1 } : null, note: 'Materials received in good condition.' }
    const states = [{ family: 'ORDER', state: 'COMPLETED' }, { family: 'PAYMENT', state: 'PAID' }, { family: 'FULFILLMENT', state: handover }, { family: 'REFUND', state: 'NOT_REQUESTED' }, { family: 'DISPUTE', state: 'NONE' }]
    const order = {
      id: orderId, reference: `ORD-SAMPLE-${method}`, checkout: { id: 'checkout-layout', reference: 'CHK-SAMPLE' }, vendor: { id: 'vendor-layout', name: 'Sample Supply' }, procurement_type: 'ITEM_BASED',
      fulfillment_method: method, payment_method: 'ONLINE', submitted_at: at, accepted_at: at, closed_at: at, terminal_reason_code: null, confirmation_source: 'MANUAL',
      states, deadlines: { vendor_response_due_at: null, buyer_response_due_at: null, payment_expires_at: null, server_time: at, timezone: 'Asia/Manila' },
      commercial_version: { current: 1, accepted: 1, kind: 'ACCEPTED', content_hash: 'fixture', recorded_at: at }, changes: [], expected_fulfillment_date: '2026-10-13',
      lines: [{ id: 'line-1', line_number: 1, listing_id: 'listing-1', listing_variant_id: 'variant-1', display_name: 'Portland cement', variant_label: '40 kg bag', brand: 'Sample', category: 'Cement', image: null, unit_code: 'BAG', unit_name: 'bag', unit_precision: 0, quantity_step: '1', requested_quantity: '10', confirmed_quantity: '10', unit_price_centavos: 27500, ordinary_unit_price_centavos: 27500, volume_tier_applied: false, volume_tiers: [], gross_centavos: 275000, discount_centavos: 0, line_total_centavos: 275000, included_vat_centavos: 0, tax_category: 'NON_VAT', vat_label: 'Non-VAT seller', change: null, price_version_id: 'price-1' }],
      destination: { type: method, store_address: 'Sample store address' }, delivery: { status: 'NOT_APPLICABLE', estimate: null, confirmed: null }, nrpc: null,
      money: { currency: 'PHP', calculation_version: 'fin02.order.v1', status: 'ACCEPTED', materials_gross_centavos: 275000, vendor_discount_centavos: 0, materials_subtotal_centavos: 275000, included_vat_centavos: 0, vat_exclusive_centavos: 275000, vat_treatment: 'NO_INCLUDED_VAT', delivery: { status: 'NOT_APPLICABLE', amount_centavos: 0, estimate: null }, nrpc: { amount_centavos: 0, within_order_value: true, status: null }, processing_fee: { status: 'NOT_APPLICABLE', amount_centavos: 0 }, commercial_total_centavos: 275000, amount_due_online_centavos: 0, online_principal_centavos: 275000, physical_balance_centavos: 0, payment_purpose: 'FULL_ORDER_PAYMENT', excludes: ['VENDOR_COMMISSION', 'MERCHANT_WITHHOLDING'] },
      timeline: [], lock_version: 7, buyer: { display_name: 'Sample Buyer' }, auto_accept: null, reservations: [], primary_action: 'NONE', nrpc_terms: null, decline_reasons: [], permissions: { can_confirm: false, can_revise: false, can_set_nrpc: false, can_confirm_delivery: false, can_decline: false, can_view_inventory: false, can_record_milestone: false, can_assign_fulfillment: false },
      fulfillment: { method, state: handover, expected_date: '2026-10-13', late: false, tracking_notice: 'There is no live GPS tracking. Status changes when the Vendor records each milestone.', next_action: 'NONE',
        steps: ['CONFIRMED', 'PROCESSING', delivery ? 'OUT_FOR_DELIVERY' : 'READY_FOR_PICKUP', handover, 'COMPLETED'].map((key, index) => ({ key, label: ['Confirmed', 'Preparing', delivery ? 'Out for delivery' : 'Ready for pickup', delivery ? 'Delivered' : 'Picked up', 'Receipt confirmed'][index], status: 'COMPLETE', at, actor_role: index === 4 ? 'BUYER' : 'OWNER', proof_required: false, proof_requirements: [], ...(key === handover ? { proof } : {}) })),
        receipt: { paused: false, window_hours: 48 }, thread: { available: false, read_only: true }, trips: delivery ? [{ vehicle_index: 0, trip_number: 1, total_vehicle_trips: 1, name: 'Accepted truck', dispatched_at: at }] : [], vehicle_issues: [],
        assignment: delivery ? { display_name: 'Sample Staff', user_id: 12, role: 'FULFILLMENT', assigned_at: at, acknowledged_at: at, vehicle: { name: 'Accepted truck', vehicle_index: 0 } } : null,
        accepted_arrangement: delivery ? { vehicles: [{ vehicle_index: 0, name: 'Accepted truck', number_of_vehicles: 1, total_vehicle_trips: 1 }], final_fee_centavos: 42825, endpoint: 'INTENDED_DESTINATION', arrangement: 'Call on arrival at the confirmed unloading area.', notice: 'Accepted when the order was confirmed. Later vehicle, rate or store-hour changes never change this arrangement or its fee.' } : null,
        assignment_history: delivery ? [{ event: 'ASSIGNED', display_name: 'Sample Staff', vehicle_name: 'Accepted truck', at, actor_role: 'OWNER', reason: 'Confirmed delivery dispatch' }, { event: 'ASSIGNMENT_ACKNOWLEDGED', at, actor_role: 'FULFILLMENT' }] : [],
      },
    }
    let failedProof = false
    let evidenceReads = 0
    await page.route('**/api/v1/**', async route => {
      const url = new URL(route.request().url())
      if (/\/vendor\/orders\/[^/]+\/files\//.test(url.pathname)) {
        evidenceReads++
        return failedProof ? route.fulfill({ status: 503, json: { data: null, errors: [{ code: 'FILE_UNAVAILABLE' }] } }) : route.fulfill({ contentType: 'image/jpeg', body: proofImage })
      }
      let data: unknown = {}
      let meta: unknown = {}
      if (url.pathname.endsWith(`/vendor/orders/${orderId}`)) data = order
      else if (url.pathname.endsWith('/vendor/orders')) {
        data = [{ ...order, line_count: 1, first_line: { display_name: 'Portland cement', image: null }, materials_centavos: 275000, delivery_centavos: 0, commercial_total_centavos: 275000, delivery_pending: false, deadline: null, nrpc_indicator: false }]
        meta = { group: 'CLOSED', counts: { CLOSED: 1 }, page: 1, per_page: 20, total: 1, has_more: false, current_as_of: at }
      } else if (url.pathname.endsWith('/profile')) data = { id: 'layout-review', full_name: 'Layout Reviewer', account_type: 'VENDOR', account_status: 'ACTIVE', role: 'OWNER' }
      else if (url.pathname.endsWith('/onboarding')) data = { step_completion: [], requirements: [], drafts: [], sections: {}, lock_version: 1, organization: { store_name: 'Sample Supply', lock_version: 1 }, permissions: ['portal.orders'], welcome_required: false, verification: { status: 'APPROVED' }, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', marketplace_discoverability_status: 'DISCOVERABLE', readiness: { ready: true, blockers: [] } } }
      await route.fulfill({ json: { data, meta, errors: [] } })
    })
    await page.goto('/orders?group=CLOSED')
    await page.getByRole('link', { name: 'View order', exact: true }).click()
    const panel = page.getByRole('dialog', { name: order.reference })
    await panel.getByRole('link', { name: 'Open full order' }).click()
    const workspace = page.getByRole('region', { name: 'Fulfillment', exact: true })
    await expect(workspace.getByText(delivery ? 'Site Delivery' : 'Self-Pickup', { exact: true })).toBeVisible()
    await expect(workspace.getByRole('img', { name: 'Proof photo', exact: true })).toBeVisible()
    await expect.poll(() => workspace.getByRole('img', { name: 'Proof photo', exact: true }).evaluate(element => (element as HTMLImageElement).complete && (element as HTMLImageElement).naturalWidth > 0)).toBe(true)
    expect(await workspace.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
    expect(await page.evaluate(() => document.documentElement.scrollWidth <= innerWidth)).toBe(true)
    if (delivery) {
      await expect(workspace.getByRole('heading', { name: 'Accepted delivery arrangement' })).toBeVisible()
      await expect(workspace.getByText('₱428.25', { exact: true })).toBeVisible()
      await expect(workspace.getByRole('region', { name: 'Staff assignment history' })).toBeVisible()
    }
    await workspace.screenshot({ path: `test-results/fulfillment-${method.toLowerCase()}-${page.viewportSize()!.width}.png`,
      style: 'html, body { overflow: visible !important; } .portal-layout { height: auto !important; overflow: visible !important; } .portal-workspace { overflow: visible !important; } .portal-workspace > header { position: static !important; }' })
    const trigger = workspace.getByRole('button', { name: 'View proof photo', exact: true })
    await trigger.click()
    const popup = page.getByRole('dialog', { name: 'Proof photo full preview' })
    await expect(popup).toBeVisible()
    await expect(popup.getByRole('img', { name: 'Proof photo', exact: true })).toBeVisible()
    const fullImage = popup.getByRole('img', { name: 'Proof photo', exact: true })
    await expect.poll(() => fullImage.evaluate(element => (element as HTMLImageElement).naturalWidth)).toBeGreaterThan(0)
    const fittedFrame = await fullImage.boundingBox()
    const fitted = await fullImage.evaluate(element => {
      const image = element as HTMLImageElement
      const bounds = image.getBoundingClientRect()
      const scale = Math.min(bounds.width / image.naturalWidth, bounds.height / image.naturalHeight)
      return { width: image.naturalWidth * scale, height: image.naturalHeight * scale }
    })
    await popup.getByRole('button', { name: 'Zoom in' }).click()
    await expect(popup.getByRole('button', { name: 'Fit image' })).toHaveAttribute('aria-pressed', 'true')
    const enlarged = await fullImage.boundingBox()
    expect(enlarged!.width).toBeCloseTo(fitted.width * 2, 0)
    expect(enlarged!.height).toBeCloseTo(fitted.height * 2, 0)
    const imageArea = popup.getByRole('region', { name: 'Proof photo image area' })
    const scroll = await imageArea.evaluate(element => ({ left: element.scrollLeft, top: element.scrollTop, maxLeft: element.scrollWidth - element.clientWidth, maxTop: element.scrollHeight - element.clientHeight }))
    expect(Math.abs(scroll.left - scroll.maxLeft / 2)).toBeLessThanOrEqual(1)
    expect(Math.abs(scroll.top - scroll.maxTop / 2)).toBeLessThanOrEqual(1)
    expect(await popup.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
    await page.screenshot({ path: `test-results/fulfillment-zoom-${method.toLowerCase()}-${page.viewportSize()!.width}.png` })
    await popup.getByRole('button', { name: 'Fit image' }).click()
    const restored = await fullImage.boundingBox()
    expect(restored!.width).toBeCloseTo(fittedFrame!.width, 0)
    expect(restored!.height).toBeCloseTo(fittedFrame!.height, 0)
    expect(await popup.evaluate(element => element.scrollWidth <= element.clientWidth)).toBe(true)
    await page.screenshot({ path: `test-results/fulfillment-popup-${method.toLowerCase()}-${page.viewportSize()!.width}.png` })
    await page.keyboard.press('Escape')
    await expect(popup).toHaveCount(0)
    await expect(page.getByRole('heading', { name: order.reference, exact: true })).toBeVisible()
    await expect(trigger).toBeFocused()
    await trigger.press('Enter')
    await expect(popup).toBeVisible()
    await popup.getByRole('button', { name: 'Close preview', exact: true }).click()
    await expect(trigger).toBeFocused()
    expect(context.pages()).toHaveLength(1)
    expect(evidenceReads).toBe(delivery ? 2 : 1)

    // An explicit retry recovers an unavailable preview; no automatic private-file replay.
    failedProof = true
    const previousReads = evidenceReads
    await page.goto(`/orders/${orderId}`)
    const proofSummary = page.getByRole('region', { name: delivery ? 'Delivery proof' : 'Handover proof', exact: true })
    await expect(proofSummary.getByRole('alert').first()).toContainText('Preview could not be loaded')
    expect(evidenceReads - previousReads).toBe(delivery ? 2 : 1)
    failedProof = false
    await proofSummary.getByRole('button', { name: 'Retry preview' }).first().click()
    await expect(proofSummary.getByRole('img', { name: 'Proof photo', exact: true })).toBeVisible()
  })
}
