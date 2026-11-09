import type { FinanceKpis } from '../lib/finance-api'

export function marketplacePaymentsFixture(): FinanceKpis {
  return ({ label: 'Recorded transactions', scenario: 'Earnings and cash use event dates.', period: { from: null, to: null }, commerce: [
    { key: 'gross_gmv', label: 'Gross sales', valueCentavos: 3000000, definition: 'Confirmed order value.' }, { key: 'cancelled_gmv', label: 'Cancelled order value', valueCentavos: 500000, definition: 'Cancelled.' },
    { key: 'refunded_gmv', label: 'Refunded order value', valueCentavos: 100000, definition: 'Refunded.' }, { key: 'net_gmv', label: 'Net sales', valueCentavos: 2400000, definition: 'Net.' },
    { key: 'online_payments', label: 'Verified online payments', valueCentavos: 2050000, definition: 'Online.' }, { key: 'buyer_processing_fees', label: 'E-wallet transaction fees', valueCentavos: 50000, definition: 'Fees.' },
    { key: 'cash_on_delivery', label: 'Cash on Delivery collected', valueCentavos: 600000, definition: 'COD.' }, { key: 'in_store', label: 'In-Store payments collected', valueCentavos: 350000, definition: 'Store.' },
    { key: 'buyer_payments', label: 'Buyer payments received', valueCentavos: 3000000, definition: 'All received.' }, { key: 'cancellation_refunds', label: 'Cancellation refunds', valueCentavos: 200000, definition: 'Cancel.' },
    { key: 'dispute_refunds', label: 'Dispute-conclusion refunds', valueCentavos: 100000, definition: 'Dispute.' }, { key: 'other_refunds', label: 'Other online refunds', valueCentavos: 0, definition: 'Other.' },
    { key: 'cash_reimbursements', label: 'Cash reimbursements', valueCentavos: 50000, definition: 'Cash back.' }, { key: 'buyer_refunds', label: 'Refunds to Buyers', valueCentavos: 350000, definition: 'All refunds.' },
    { key: 'pending_buyer_refunds', label: 'Refunds in progress', valueCentavos: 25000, definition: 'Pending.' }, { key: 'net_buyer_payments', label: 'Net Vendor collections', valueCentavos: 2650000, definition: 'Kept.' },
  ], finance: [
    { key: 'earned_commission', label: 'Platform commission charges before credits', valueCentavos: 20000, definition: 'Earned at completion.' }, { key: 'fee_credits', label: 'Approved commission credits', valueCentavos: 3000, definition: 'Credits.' },
    { key: 'net_commission', label: 'Platform commission charges', valueCentavos: 17000, definition: 'Earnings less credits.' }, { key: 'platform_revenue', label: 'Commission revenue, excluding VAT', valueCentavos: 15179, definition: 'Posted revenue.' },
    { key: 'fee_vat', label: 'Output VAT on fees', valueCentavos: 1821, definition: 'VAT.' },
    { key: 'processing_expense', label: 'Platform processing costs', valueCentavos: 700, definition: 'Costs.' }, { key: 'net_platform_earnings', label: 'Net platform earnings', valueCentavos: 14479, definition: 'Revenue less costs.' },
    { key: 'collected', label: 'Collected commissions', valueCentavos: 9000, definition: 'Collected.' }, { key: 'refunded_commissions', label: 'Refunded commissions', valueCentavos: 1000, definition: 'Refunded.' },
    { key: 'net_collected', label: 'Net collected commissions', valueCentavos: 8000, definition: 'Collected less refunds.' }, { key: 'receivables', label: 'Outstanding receivables', valueCentavos: 6000, definition: 'Owed.' },
    { key: 'overdue', label: 'Overdue receivables', valueCentavos: 2500, definition: 'Past due.' }, { key: 'pending_commissions', label: 'Pending commissions', valueCentavos: 7000, definition: 'Pending.' },
  ], counts: { confirmed_orders: 3, pending_buyer_refunds: 1 }, paymentMethods: [
    { method: 'GCASH', label: 'GCash', kind: 'ONLINE', payments: 2, amountCentavos: 2050000 },
    { method: 'CASH_ON_DELIVERY', label: 'Cash on Delivery', kind: 'PHYSICAL', payments: 1, amountCentavos: 600000 },
    { method: 'IN_STORE', label: 'In-Store Payment', kind: 'PHYSICAL', payments: 1, amountCentavos: 350000 },
  ], trendGranularity: 'DAY', trend: [
    { period: new Date(2026, 9, 1), earnedCentavos: 20000, creditsCentavos: 3000, collectedCentavos: 0, refundedCentavos: 0, netEarningsCentavos: 14479, gmvCentavos: 3000000, buyerPaymentsCentavos: 2000000, buyerRefundsCentavos: 0 },
    { period: new Date(2026, 9, 2), earnedCentavos: 0, creditsCentavos: 0, collectedCentavos: 9000, refundedCentavos: 1000, netEarningsCentavos: 0, gmvCentavos: 0, buyerPaymentsCentavos: 1000000, buyerRefundsCentavos: 350000 }] })
}
