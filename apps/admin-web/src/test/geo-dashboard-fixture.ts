import type { GeoDashboard } from '@materyalph/api-client-ts'

export function geoDashboardFixture(): GeoDashboard {
  const cell = (value: number) => ({ value, suppressed: false })
  const rate = { percent: '100.00', numerator: 6, denominator: 6, suppressed: false }
  const activity = { dau: cell(0), wau: cell(1), mau: cell(2) }
  return {
    scope: { code: null, name: 'Philippines', level: null, levelLabel: 'Country', label: 'Philippines', breadcrumbs: [{ code: null, name: 'Philippines', level: null }], childrenLabel: 'Regions', drillable: true },
    dataset: { environment: 'TEST', label: 'Recorded activity', demo: false, available: true, throughDate: '2026-10-31', revision: 1 },
    period: { from: new Date('2026-10-01T00:00:00Z'), to: new Date('2026-10-31T00:00:00Z'), granularity: 'WEEK' }, filters: {}, filterApplicability: [],
    disclosure: { minimumPersons: 5, method: 'ROLL_UP_TO_PARENT', description: 'Sample small-cell protection.' },
    kpis: {
      vendorCount: cell(23), registeredBuyers: cell(2), grossGmvCentavos: cell(3487020), netGmvCentavos: cell(3062275), orderVolume: cell(8),
      fulfillmentRate: rate, cancellationRate: rate, disputeRate: rate,
      responseTime: { suppressed: false, meanSeconds: 200, medianSeconds: 180, p90Seconds: 400, answered: 30, unanswered: 13 },
      activeUsers: { buyer: activity, vendor: activity },
    },
    children: [], trends: [], activityTrend: [], unresolved: { orders: 0, vendors: 0, registeredBuyers: 0, responses: 0, activity: 0 },
    definitions: { gross_gmv: 'Confirmed order value before cancellations and refunds.' },
  }
}
