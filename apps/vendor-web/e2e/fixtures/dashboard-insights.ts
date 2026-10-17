/**
 * Deterministic API payloads (snake_case, as the server sends them) for the dashboard layout review. Values follow a
 * weekly pattern with a gentle rise so the forecast, anomaly marker and segments have something real to show.
 */
const day = (offset: number) => new Date(Date.UTC(2026, 8, 10 + offset)).toISOString().slice(0, 10)
const wave = (index: number) => [3, 5, 6, 6, 5, 2, 1][index % 7]! + Math.floor(index / 10)

export function vendorInsights(owner = true) {
  const series = Array.from({ length: 30 }, (_, index) => {
    const orders = index === 17 ? 14 : wave(index)
    return { date: day(index), orders, order_requests: orders + (index % 3), orders_average: 4.2 + index * 0.03,
      gross_sales_centavos: owner ? orders * 1_850_00 + (index % 4) * 320_00 : null, net_sales_centavos: owner ? orders * 1_790_00 : null, sales_average_centavos: owner ? 760_000 + index * 9_000 : null }
  })
  const points = (base: number, money: boolean) => Array.from({ length: 7 }, (_, index) => ({ date: day(30 + index), value: money ? base * 100 + index * 5_000 : base + index * 0.1, lower: money ? base * 60 : base * 0.6, upper: money ? base * 140 : base * 1.4 }))
  const forecast = (money: boolean) => ({ state: 'OK', observed_days: 90, direction: 'INCREASING', change_percent: 18.4, r_squared: 0.62, weekday_strength: 0.71, expected_total: money ? 5_600_000 : 41,
    points: points(money ? 8_000 : 5.6, money), anomalies: [] })
  return {
    generated_at: '2026-10-09T02:00:00Z', period: { days: 30, from: day(0), to: day(29), timezone: 'Asia/Manila' },
    access: { orders: true, sales_value: owner, performance: true, stock: true, disputes: true, assigned_fulfillment: false },
    definitions: {},
    orders: {
      kpis: { order_volume: { value: 142, previous: 118, change_percent: 20.3 }, gross_sales_centavos: owner ? { value: 26_710_400, previous: 22_105_000, change_percent: 20.8 } : null,
        net_sales_centavos: owner ? { value: 25_420_000, previous: 21_480_000, change_percent: 18.3 } : null, average_order_value_centavos: owner ? { value: 188_101, previous: 187_330 } : null,
        fulfillment_rate: { percent: '94.12', numerator: 128, denominator: 136 }, cancellation_rate: { percent: '2.82', numerator: 4, denominator: 142 }, dispute_rate: { percent: '1.41', numerator: 2, denominator: 142 },
        response_time: { mean_seconds: 6_120, median_seconds: 2_940, p90_seconds: 15_600, answered: 151, unanswered: 3 } },
      series,
      forecast: { horizon_days: 7, orders: forecast(false), sales: owner ? forecast(true) : null },
      pipeline: [['AWAITING_VENDOR_CONFIRMATION', 3], ['AWAITING_PAYMENT', 2], ['CONFIRMED', 4], ['PROCESSING', 6], ['READY_FOR_PICKUP', 2], ['OUT_FOR_DELIVERY', 3], ['DELIVERED', 1], ['DISPUTED', 1]].map(([state, count]) => ({ state, count })),
      incoming: [
        { order_id: '0192f000-0000-7000-8000-000000000101', reference: 'MP-ORD-24081', procurement_type: 'PROJECT_BASED', fulfillment_method: 'DELIVERY', line_count: 8, total_centavos: 20_048_500, submitted_at: '2026-10-09T00:10:00Z', due_at: '2026-10-10T00:10:00Z' },
        { order_id: '0192f000-0000-7000-8000-000000000102', reference: 'MP-ORD-24079', procurement_type: 'ITEM_BASED', fulfillment_method: 'DELIVERY', line_count: 6, total_centavos: 8_840_000, submitted_at: '2026-10-08T22:40:00Z', due_at: '2026-10-09T22:40:00Z' },
        { order_id: '0192f000-0000-7000-8000-000000000103', reference: 'MP-ORD-24077', procurement_type: 'ITEM_BASED', fulfillment_method: 'PICKUP', line_count: 4, total_centavos: 3_420_000, submitted_at: '2026-10-08T21:05:00Z', due_at: '2026-10-09T21:05:00Z' },
      ],
      funnel: [{ key: 'INQUIRIES', label: 'Buyer inquiries', count: 96 }, { key: 'QUOTATIONS', label: 'Quotations published', count: 41 }, { key: 'ORDER_REQUESTS', label: 'Order requests', count: 154 },
        { key: 'CONFIRMED', label: 'Orders confirmed', count: 142 }, { key: 'COMPLETED', label: 'Orders completed', count: 121 }],
      mix: { procurement: [{ key: 'ITEM_BASED', count: 118 }, { key: 'PROJECT_BASED', count: 24 }], fulfillment: [{ key: 'DELIVERY', count: 97 }, { key: 'PICKUP', count: 45 }],
        payment: [{ key: 'ONLINE', count: 88 }, { key: 'CASH_ON_DELIVERY', count: 39 }, { key: 'IN_STORE', count: 15 }] },
      products: {
        top: [['Portland Cement Type 1 (40 kg)', 'Cement', 61, 38, 9_820_000], ['Deformed Bar 10 mm × 6 m', 'Steel', 44, 27, 6_512_000], ['Washed Sand (per m³)', 'Aggregates', 39, 25, 4_290_000],
          ['Concrete Hollow Block 4"', 'Masonry', 33, 19, 2_640_000], ['Marine Plywood ¾"', 'Wood', 18, 12, 1_980_000]]
          .map(([name, category, orders, buyers, value]) => ({ name, category, orders, buyers, value_centavos: owner ? value : null })),
        categories: [['Cement', 61, 9_820_000], ['Steel', 44, 6_512_000], ['Aggregates', 39, 4_290_000], ['Masonry', 33, 2_640_000], ['Wood', 18, 1_980_000]].map(([category, orders, value]) => ({ category, orders, value_centavos: owner ? value : null })),
        segments: { state: 'OK', reason: null, k: 3, silhouette: 0.68, features: owner ? ['Orders', 'Distinct Buyers', 'Value'] : ['Orders', 'Distinct Buyers'],
          segments: [
            { id: 0, label: 'High demand', size: 3, average_orders: 48, average_buyers: 30, average_value_centavos: owner ? 6_874_000 : null, examples: ['Portland Cement Type 1 (40 kg)', 'Deformed Bar 10 mm × 6 m', 'Washed Sand (per m³)'] },
            { id: 1, label: 'Moderate demand', size: 4, average_orders: 22, average_buyers: 14, average_value_centavos: owner ? 2_150_000 : null, examples: ['Concrete Hollow Block 4"', 'Marine Plywood ¾"'] },
            { id: 2, label: 'Low demand', size: 6, average_orders: 5, average_buyers: 4, average_value_centavos: owner ? 380_000 : null, examples: ['GI Wire #16', 'Tie Wire', 'Common Nails 3"'] },
          ],
          points: [[61, 38, 'High demand'], [44, 27, 'High demand'], [39, 25, 'High demand'], [33, 19, 'Moderate demand'], [18, 12, 'Moderate demand'], [24, 15, 'Moderate demand'], [14, 10, 'Moderate demand'],
            [7, 6, 'Low demand'], [5, 4, 'Low demand'], [6, 3, 'Low demand'], [3, 3, 'Low demand'], [4, 2, 'Low demand'], [2, 2, 'Low demand']].map(([orders, buyers, segment], index) => ({ name: `Product ${index + 1}`, orders, buyers, segment })) },
        basket_rules: { baskets: 362, window_days: 90, rules: [
          { antecedent: ['Washed Sand (per m³)'], consequent: ['Portland Cement Type 1 (40 kg)'], support: 0.18, support_count: 64, confidence: 0.82, lift: 1.71 },
          { antecedent: ['Deformed Bar 10 mm × 6 m'], consequent: ['GI Wire #16'], support: 0.09, support_count: 33, confidence: 0.61, lift: 2.4 },
          { antecedent: ['Portland Cement Type 1 (40 kg)', 'Washed Sand (per m³)'], consequent: ['Gravel ¾" (per m³)'], support: 0.07, support_count: 25, confidence: 0.44, lift: 1.93 },
        ] },
      },
      unusual_days: { state: 'OK', epsilon: 1.4, days: [{ date: day(17), orders: 14, gross_sales_centavos: owner ? 2_590_000 : null }] },
    },
    performance: {
      calculated: true, as_of: day(29), label: 'VPS 4.36 of 5',
      scores: [['VPS', '4.36', 0, 0, 'Daily: VCS 50% + OHS 50%'], ['VCS', '4.47', 31, 5, 'Rolling 90 days'], ['MQS', '4.52', 44, 5, 'Rolling 90 days'], ['OHS', '4.25', 136, 10, 'Trailing 30 days, recalculated weekly']]
        .map(([key, value, sample, minimum, window]) => ({ key, value, published: true, sample_count: sample, minimum_sample: minimum, window, status_text: 'Published' })),
      badge_metrics: [{ key: 'CRR', value: '91.20', sample_count: 96, window: 'Trailing 30 days', definition: 'Eligible inquiries answered by a person within 12 hours ÷ eligible inquiries × 100' },
        { key: 'FRR', value: '94.10', sample_count: 128, window: 'Trailing 90 days', definition: 'Orders fulfilled on or before the confirmed date ÷ eligible fulfilled orders × 100' }],
      operations: { rates: { NFR: '1.47', LSR: '4.41', RR: '0.74', ODR: '0.74' }, penalties: { NFR: '0.00', LSR: '0.25', RR: '0.00', ODR: '0.00' } },
      history: Array.from({ length: 30 }, (_, index) => ({ date: day(index), vps: (4.1 + index * 0.009).toFixed(2), vcs: '4.47', mqs: '4.52', ohs: index < 14 ? '4.00' : '4.25' })),
      classification: { class: 'WATCH', label: 'Watch', path: ['Outside the no-penalty band: LSR.'], bands: { NFR: 'NONE', LSR: 'LOW', RR: 'NONE', ODR: 'NONE' } },
      badges: [],
    },
    stock: { variants: 64, in_stock: 51, limited_stock: 9, out_of_stock: 4, attention: [
      { name: 'Deformed Bar 12 mm × 6 m', variant: 'Grade 40', available: '0', reorder_level: '50', status: 'OUT_OF_STOCK' },
      { name: 'Portland Cement Type 1 (40 kg)', variant: null, available: '35', reorder_level: '80', status: 'LIMITED_STOCK' } ] },
    disputes: { open: 2, awaiting_response: 1, next_response_due_at: '2026-10-10T04:00:00Z', filed_in_period: 3, series: series.map((point, index) => ({ date: point.date, cases: [6, 19, 24].includes(index) ? 1 : 0 })),
      issue_types: [{ key: 'DEFECTIVE', count: 2 }, { key: 'LATE_OR_MISSING', count: 1 }], statuses: [{ key: 'OPEN_AWAITING_RESPONSE', count: 1 }, { key: 'MUTUAL_RESOLUTION', count: 1 }], fulfillment_issues: 2, validated_returns: 1 },
    actions: [
      { key: 'ORDER_CONFIRMATION', label: 'Order requests awaiting your decision', count: 3, severity: 'ACTION', href: '/orders', detail: 'Earliest response due Oct 9, 6:40 AM (Asia/Manila)' },
      { key: 'FULFILLMENT_OVERDUE', label: 'Orders past their expected fulfillment date', count: 1, severity: 'ALERT', href: '/orders', detail: null },
      { key: 'FULFILLMENT_DUE_TODAY', label: 'Orders due for fulfillment today', count: 4, severity: 'ACTION', href: '/orders', detail: null },
      { key: 'DISPUTE_RESPONSE', label: 'Cases awaiting your response', count: 1, severity: 'ALERT', href: '/disputes', detail: 'Earliest response due Oct 10, 12:00 PM (Asia/Manila)' },
      { key: 'OUT_OF_STOCK', label: 'Variants out of stock', count: 4, severity: 'ALERT', href: '/products/inventory', detail: null },
      { key: 'LIMITED_STOCK', label: 'Variants at or below reorder level', count: 9, severity: 'ACTION', href: '/products/inventory', detail: null },
    ],
    traffic: { store_visits: { tracked: false, reason: 'MateryalPH does not record storefront visits or listing views, so none are shown.' } },
  }
}

const cell = (value: number | null) => ({ value, suppressed: value === null, reason: value === null ? 'Suppressed: fewer than 5 distinct Buyers or users. The value is counted in the Philippines total.' : null })

export function adminInsights() {
  const series = Array.from({ length: 30 }, (_, index) => {
    const suppressed = index === 5 || index === 12
    const orders = wave(index) * 7 + index
    return { date: day(index), gross_gmv_centavos: suppressed ? null : orders * 2_140_00 * 10, net_gmv_centavos: suppressed ? null : orders * 2_050_00 * 10, order_volume: suppressed ? null : orders, suppressed,
      gross_average_centavos: 7_900_000 + index * 60_000, volume_average: 36 + index * 0.4 }
  })
  const forecast = (money: boolean) => ({ state: 'OK', observed_days: 28, direction: 'INCREASING', change_percent: 42.6, r_squared: 0.71, weekday_strength: 0.64, expected_total: money ? 1_281_000_000 : 598,
    points: Array.from({ length: 7 }, (_, index) => ({ date: day(30 + index), value: money ? 177_000_000 + index * 1_500_000 + (index % 7 === 5 ? -60_000_000 : 0) : 83 + index * 0.7 + (index % 7 === 5 ? -28 : 0),
      lower: money ? 120_000_000 + index * 1_500_000 + (index % 7 === 5 ? -60_000_000 : 0) : 56 + index * 0.7, upper: money ? 234_000_000 + index * 1_500_000 + (index % 7 === 5 ? -60_000_000 : 0) : 110 + index * 0.7 })),
    anomalies: money ? [{ date: day(22), value: 189_000_000, expected: 150_000_000, deviation: 3.2 }] : [] })
  return {
    generated_at: '2026-10-09T02:00:00Z', access: { marketplace: true, vendor_health: true }, definitions: {}, marketplace_unavailable_reason: null,
    marketplace: {
      scope: { code: null, name: 'Philippines', level: null, level_label: 'Country', label: 'Philippines', breadcrumbs: [{ code: null, name: 'Philippines', level: null }], children_label: 'Regions', drillable: true, psgc_version: null },
      dataset: { environment: 'DEMO', label: 'DEMO — Simulated Marketplace Data', demo: true, last_aggregated_at: '2026-10-08T17:00:00Z', through_date: day(29), revision: 1, available: true },
      period: { from: day(0), to: day(29), granularity: 'DAY', days: 30 },
      disclosure: { minimum_persons: 5, method: 'ROLL_UP_TO_PARENT', description: 'Person-derived cells with fewer than 5 distinct Buyers or users are suppressed and counted in the parent total.' },
      kpis: { vendor_count: cell(42), registered_buyers: cell(1_284), gross_gmv_centavos: cell(2_485_600_000), net_gmv_centavos: cell(2_391_200_000), order_volume: cell(1_163),
        fulfillment_rate: { percent: '95.40', numerator: 1_041, denominator: 1_091, suppressed: false, reason: null }, cancellation_rate: { percent: '2.15', numerator: 25, denominator: 1_163, suppressed: false, reason: null },
        dispute_rate: { percent: '0.95', numerator: 11, denominator: 1_163, suppressed: false, reason: null },
        response_time: { suppressed: false, reason: null, mean_seconds: 8_100, median_seconds: 3_300, p90_seconds: 21_600, answered: 1_210, unanswered: 34 },
        active_users: { buyer: { dau: cell(96), wau: cell(410), mau: cell(902) }, vendor: { dau: cell(31), wau: cell(39), mau: cell(41) } } },
      series,
      forecast: { horizon_days: 7, gross_gmv: forecast(true), order_volume: forecast(false) },
      activity: series.map((point, index) => ({ date: point.date, buyer_dau: 70 + wave(index) * 6, vendor_dau: 22 + wave(index), buyer_mau: 880 + index, vendor_mau: 40 })),
      areas: { children_label: 'Regions', considered: 11, excluded_suppressed: 3, features: ['Active Vendors', 'Registered Buyers', 'Orders', 'Gross GMV'], state: 'OK', reason: null, k: 3, silhouette: 0.63,
        segments: [
          { id: 0, label: 'Established markets', size: 2, average_vendors: 14, average_buyers: 410, average_orders: 380, average_gmv_centavos: 820_000_000, examples: ['National Capital Region (NCR)', 'Region IV-A (CALABARZON)'] },
          { id: 1, label: 'Developing markets', size: 4, average_vendors: 2.5, average_buyers: 88, average_orders: 62, average_gmv_centavos: 128_000_000, examples: ['Region III (Central Luzon)', 'Region VII (Central Visayas)', 'Region XI (Davao Region)'] },
          { id: 2, label: 'Emerging markets', size: 5, average_vendors: 0.6, average_buyers: 21, average_orders: 9, average_gmv_centavos: 18_000_000, examples: ['Region II (Cagayan Valley)', 'Region VIII (Eastern Visayas)'] },
        ],
        unusual: [{ code: '1300000000', name: 'National Capital Region (NCR)', vendors: 17, orders: 452, gmv_centavos: 990_000_000 }],
        recruitment: [{ code: '0300000000', name: 'Region III (Central Luzon)', vendors: 2, orders: 96, orders_per_vendor: 48 }, { code: '1100000000', name: 'Region XI (Davao Region)', vendors: 2, orders: 71, orders_per_vendor: 35.5 },
          { code: '0700000000', name: 'Region VII (Central Visayas)', vendors: 3, orders: 64, orders_per_vendor: 21.3 }],
        points: [[17, 452, 'Established markets', 'NCR'], [11, 308, 'Established markets', 'CALABARZON'], [2, 96, 'Developing markets', 'Central Luzon'], [3, 64, 'Developing markets', 'Central Visayas'], [2, 71, 'Developing markets', 'Davao'], [3, 17, 'Developing markets', 'Western Visayas'],
          [1, 14, 'Emerging markets', 'Cagayan Valley'], [0, 9, 'Emerging markets', 'Eastern Visayas'], [1, 11, 'Emerging markets', 'Bicol'], [0, 6, 'Emerging markets', 'MIMAROPA'], [1, 5, 'Emerging markets', 'Caraga']].map(([vendors, orders, segment, name]) => ({ name, vendors, orders, segment })) },
      categories: { demand: [['Cement', 642], ['Steel', 488], ['Aggregates', 451], ['Masonry', 302], ['Wood', 187], ['Electrical', 96]].map(([category, orders]) => ({ category, orders })), suppressed_categories: 2, baskets: 1_163, minimum_buyers: 5,
        rules: [{ antecedent: ['Aggregates'], consequent: ['Cement'], support: 0.31, support_count: 361, confidence: 0.8, lift: 1.45 }, { antecedent: ['Steel'], consequent: ['Masonry'], support: 0.12, support_count: 140, confidence: 0.29, lift: 1.12 },
          { antecedent: ['Cement', 'Steel'], consequent: ['Aggregates'], support: 0.14, support_count: 163, confidence: 0.62, lift: 1.6 }] },
    },
    vendor_health: { total: 42, classes: [{ key: 'HEALTHY', label: 'Healthy', count: 23 }, { key: 'WATCH', label: 'Watch', count: 8 }, { key: 'BELOW_WATCH_LEVEL', label: 'Below workflow watch level', count: 2 }, { key: 'BUILDING_TRACK_RECORD', label: 'New Vendor — Building Track Record', count: 9 }],
      attention: [{ vendor_id: '0192f000-0000-7000-8000-000000000201', store_name: 'Northpoint Hardware', class: 'BELOW_WATCH_LEVEL', label: 'Below workflow watch level', vps: '2.84', ohs: '2.40', reasons: ['Published VPS is below 3.00.', 'Published OHS is below 2.50.'] },
        { vendor_id: '0192f000-0000-7000-8000-000000000202', store_name: 'Bayside Builders Depot', class: 'WATCH', label: 'Watch', vps: '3.92', ohs: '3.75', reasons: ['Outside the no-penalty band: LSR, RR.'] }],
      segments: { state: 'OK', reason: null, considered: 33, features: ['VPS', 'OHS', 'Completed orders (90 days)'], k: 3, silhouette: 0.57,
        segments: [{ id: 0, label: 'Higher performing, higher volume', size: 11, average_vps: 4.52, average_ohs: 4.71, average_completed_orders: 96 }, { id: 1, label: 'Middle group', size: 17, average_vps: 4.05, average_ohs: 4.2, average_completed_orders: 31 },
          { id: 2, label: 'Lower performing, lower volume', size: 5, average_vps: 3.21, average_ohs: 3.05, average_completed_orders: 12 }] } },
  }
}
