export const tutorialEarnings = {
      demo: true, environment: 'TEST', commercial_sales_centavos: 157025, online_collections_centavos: 99925, physical_collections_centavos: 0,
      included_vat_centavos: 12236, simulated_cwt_centavos: 254, estimated_remittance_cash_centavos: 99671,
      remittance_collections_centavos: 99925, remittance_refunds_centavos: 0, provider_charges_centavos: 0,
      buyer_processing_fees_centavos: 4152, online_refunds_centavos: 0, earned_commission_centavos: 0, estimated_commission_centavos: 0, unpaid_statements_centavos: 0,
      breakdown: { sales: { orders: 4, materials_before_discount_centavos: 114200, vendor_discounts_centavos: 0, materials_after_discount_centavos: 114200, delivery_centavos: 42825, refunds_centavos: 0 },
        online: { payments: 4, principal_paid_centavos: 99925, refunded_principal_centavos: 0 }, physical: { records: 0, cash_on_delivery_centavos: 0, in_store_centavos: 0 } },
      products: { total: 0, truncated: false, items: [] }, trend: { from: '2026-10-08', to: '2026-11-06', days: 30, granularity: 'DAY', timezone: 'Asia/Manila', points: [], previous: null },
    }

export const tutorialFinance = { demo_label: 'DEMO — No real funds or BIR filing', notices: [], threshold: null, tax_profile: { available: false }, withholding_arrangement: {}, xendit_connection: { status: 'CONNECTED_TEST', label: 'Connected — TEST', environment: 'TEST' }, online_channels: { provider_ready: true, channels: [] }, statements: { outstanding_centavos: 0 }, commission_terms: { accepted: true } }

export const tutorialCommission = { terms_accepted: true, assessments: [], current_policy: null, next_policy: null,
  annual_payments: { label: '2026', starts_on: '2026-01-01', ends_on: '2026-12-31', resets_at: '2026-12-31T16:00:00Z', collected_centavos: 0, refunded_centavos: 0, net_collected_centavos: 0 },
  monthly_payments: { label: 'November 2026', starts_on: '2026-11-01', ends_on: '2026-11-30', resets_at: '2026-11-30T16:00:00Z', collected_centavos: 0, refunded_centavos: 0, net_collected_centavos: 0 },
  payment_history: { items: [], page: 1, per_page: 10, total: 0, has_more: false },
  summary: Object.fromEntries(['estimated', 'earned', 'credited', 'net_earned', 'unbilled', 'draft', 'outstanding', 'overdue', 'collected', 'refunded', 'net_collected'].map(key => [`${key}_centavos`, 0])),
}
