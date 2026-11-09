export const orderAuditWire = {
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

export const orderAuditDetailWire = {
  ...orderAuditWire,
  available_actions: [],
  payment: { available: false, reason: null, notice: 'Read-only records.', attempts: [
    { id: 'payment-1', purpose: 'FULL_ORDER_PAYMENT', status: 'PAID', attempt_number: 1, channel_code: 'GCASH', channel_name: 'GCash', principal_centavos: 275000, processing_fee_centavos: 5000, total_centavos: 280000, created_at: '2026-11-07T01:00:00Z', paid_at: '2026-11-07T01:05:00Z', expires_at: null, environment: 'TEST', evidence_origin: 'SIMULATED', checkout_url: null, can_check_status: false, message: 'Recorded provider evidence.' },
  ] },
  refund_timeline: { refunds: [{ id: 'refund-1', trigger: 'CANCELLATION', state: 'REFUND_FAILED', display_state: 'FAILED', amount_centavos: 280000, processing_fee_centavos: 5000, payment_purpose: 'FULL_ORDER_PAYMENT', original_method: 'GCash', attempt_number: 1, can_retry: true, message: 'Refund pending resolution.', evidence_origin: 'SIMULATED' }], reimbursements: [], no_longer_due_centavos: 0 },
}
export const orderAuditSummaryWire = {
  ...orderAuditWire,
  line_count: 1, first_line: { display_name: 'Portland cement', image: null }, materials_centavos: 275000, delivery_centavos: 0, commercial_total_centavos: 275000, delivery_pending: false, deadline: null,
}
