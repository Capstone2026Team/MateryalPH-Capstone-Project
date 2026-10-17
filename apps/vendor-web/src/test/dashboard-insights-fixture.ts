import type { VendorDashboardInsights } from '../lib/dashboard-api'

const days = (count: number) => Array.from({ length: count }, (_, index) => new Date(Date.UTC(2026, 8, 10 + index)))

/** A typed Owner payload for component tests: 30 days, a 7-day forecast, two segments and one basket rule. */
export function vendorInsightsFixture(overrides: Partial<VendorDashboardInsights> = {}): VendorDashboardInsights {
  const dates = days(30)
  const orders = dates.map((_, index) => (index % 7 === 5 ? 0 : 2 + (index % 3)))
  return {
    generatedAt: new Date('2026-10-09T02:00:00Z'),
    period: { days: 30, from: dates[0]!, to: dates[29]!, timezone: 'Asia/Manila' },
    access: { orders: true, salesValue: true, performance: true, stock: true, disputes: true, assignedFulfillment: false },
    definitions: { forecast: 'Least-squares trend.' },
    orders: {
      kpis: {
        orderVolume: { value: 72, previous: 60, changePercent: 20 },
        grossSalesCentavos: { value: 72_000_00, previous: 60_000_00, changePercent: 20 },
        netSalesCentavos: { value: 70_000_00, previous: 59_000_00, changePercent: 18.6 },
        averageOrderValueCentavos: { value: 1_000_00, previous: 1_000_00 },
        fulfillmentRate: { percent: '95.00', numerator: 57, denominator: 60 },
        cancellationRate: { percent: '2.78', numerator: 2, denominator: 72 },
        disputeRate: { percent: '1.39', numerator: 1, denominator: 72 },
        responseTime: { meanSeconds: 5400, medianSeconds: 2700, p90Seconds: 14_400, answered: 70, unanswered: 2 },
      },
      series: dates.map((date, index) => ({ date, orders: orders[index]!, orderRequests: orders[index]! + 1, ordersAverage: 2.5, grossSalesCentavos: orders[index]! * 1_000_00, netSalesCentavos: orders[index]! * 950_00, salesAverageCentavos: 250_000 })),
      forecast: {
        horizonDays: 7,
        orders: { state: 'OK', observedDays: 90, direction: 'INCREASING', changePercent: 12.5, rSquared: 0.4, weekdayStrength: 0.6, expectedTotal: 19, anomalies: [],
          points: days(7).map((date, index) => ({ date: new Date(date.getTime() + 30 * 86_400_000), value: 2.7 + index * 0.05, lower: 1, upper: 4.5 })) },
        sales: { state: 'INSUFFICIENT_DATA', observedDays: 90, direction: 'UNKNOWN', changePercent: null, rSquared: null, weekdayStrength: null, expectedTotal: null, anomalies: [], points: [] },
      },
      pipeline: [{ state: 'AWAITING_VENDOR_CONFIRMATION', count: 2 }, { state: 'PROCESSING', count: 3 }, { state: 'COMPLETED', count: 0 }],
      incoming: [{ orderId: '0192f000-0000-7000-8000-000000000001', reference: 'MP-ORD-1001', procurementType: 'ITEM_BASED', fulfillmentMethod: 'DELIVERY', lineCount: 3, totalCentavos: 12_500_00, submittedAt: new Date('2026-10-09T00:00:00Z'), dueAt: new Date('2026-10-10T00:00:00Z') }],
      funnel: [{ key: 'INQUIRIES', label: 'Buyer inquiries', count: 40 }, { key: 'QUOTATIONS', label: 'Quotations published', count: 20 }, { key: 'ORDER_REQUESTS', label: 'Order requests', count: 80 },
        { key: 'CONFIRMED', label: 'Orders confirmed', count: 72 }, { key: 'COMPLETED', label: 'Orders completed', count: 60 }],
      mix: { procurement: [{ key: 'ITEM_BASED', count: 60 }, { key: 'PROJECT_BASED', count: 12 }], fulfillment: [{ key: 'DELIVERY', count: 50 }, { key: 'PICKUP', count: 22 }], payment: [{ key: 'ONLINE', count: 72 }] },
      products: {
        top: [{ name: 'Portland Cement Type 1', category: 'Cement', orders: 40, buyers: 22, valueCentavos: 40_000_00 }, { name: 'Washed Sand', category: 'Aggregates', orders: 20, buyers: 12, valueCentavos: 15_000_00 }],
        categories: [{ category: 'Cement', orders: 40, valueCentavos: 40_000_00 }, { category: 'Aggregates', orders: 20, valueCentavos: 15_000_00 }],
        segments: { state: 'OK', reason: null, k: 2, silhouette: 0.81, features: ['Orders', 'Distinct Buyers', 'Value'],
          segments: [{ id: 0, label: 'High demand', size: 1, averageOrders: 40, averageBuyers: 22, averageValueCentavos: 40_000_00, examples: ['Portland Cement Type 1'] }, { id: 1, label: 'Low demand', size: 1, averageOrders: 20, averageBuyers: 12, averageValueCentavos: 15_000_00, examples: ['Washed Sand'] }],
          points: [{ name: 'Portland Cement Type 1', orders: 40, buyers: 22, segment: 'High demand' }, { name: 'Washed Sand', orders: 20, buyers: 12, segment: 'Low demand' }] },
        basketRules: { baskets: 72, windowDays: 90, rules: [{ antecedent: ['Washed Sand'], consequent: ['Portland Cement Type 1'], support: 0.2, supportCount: 14, confidence: 0.7, lift: 1.6 }] },
      },
      unusualDays: { state: 'OK', epsilon: 1.2, days: [{ date: dates[12]!, orders: 9, grossSalesCentavos: 9_000_00 }] },
    },
    performance: {
      calculated: true, asOf: dates[29]!, label: 'VPS 4.20 of 5',
      scores: [{ key: 'VPS', value: '4.20', published: true, sampleCount: 0, minimumSample: 0, window: 'Daily', statusText: 'Published' }, { key: 'OHS', value: '4.75', published: true, sampleCount: 12, minimumSample: 10, window: 'Trailing 30 days', statusText: 'Published' }],
      badgeMetrics: [{ key: 'CRR', value: '92.00', sampleCount: 25, window: 'Trailing 30 days', definition: 'Answered within 12 hours.' }],
      operations: { rates: { NFR: '1.00', LSR: '4.00', RR: '0.00', ODR: '0.00' }, penalties: { NFR: '0.00', LSR: '0.25', RR: '0.00', ODR: '0.00' } },
      history: [{ date: dates[28]!, vps: '4.10', ohs: '4.75' }, { date: dates[29]!, vps: '4.20', ohs: '4.75' }],
      classification: { _class: 'WATCH', label: 'Watch', path: ['Outside the no-penalty band: LSR.'], bands: { NFR: 'NONE', LSR: 'LOW', RR: 'NONE', ODR: 'NONE' } },
      badges: [],
    },
    stock: { variants: 10, inStock: 7, limitedStock: 2, outOfStock: 1, attention: [{ name: 'Rebar 10mm', variant: '6 m', available: '0', reorderLevel: '20', status: 'OUT_OF_STOCK' }] },
    disputes: { open: 1, awaitingResponse: 1, nextResponseDueAt: new Date('2026-10-10T04:00:00Z'), filedInPeriod: 1, series: dates.map(date => ({ date, cases: 0 })), issueTypes: [{ key: 'DEFECTIVE', count: 1 }],
      statuses: [{ key: 'OPEN_AWAITING_RESPONSE', count: 1 }], fulfillmentIssues: 0, validatedReturns: 0 },
    actions: [
      { key: 'ORDER_CONFIRMATION', label: 'Order requests awaiting your decision', count: 2, severity: 'ACTION', href: '/orders', detail: 'Earliest response due Oct 10, 8:00 AM (Asia/Manila)' },
      { key: 'FULFILLMENT_OVERDUE', label: 'Orders past their expected fulfillment date', count: 0, severity: 'ACTION', href: '/orders', detail: null },
      { key: 'DISPUTE_RESPONSE', label: 'Cases awaiting your response', count: 1, severity: 'ALERT', href: '/disputes', detail: null },
      { key: 'OUT_OF_STOCK', label: 'Variants out of stock', count: 1, severity: 'ALERT', href: '/products/inventory', detail: null },
    ],
    traffic: { storeVisits: { tracked: false, reason: 'MateryalPH does not record storefront visits or listing views, so none are shown.' } },
    ...overrides,
  }
}
