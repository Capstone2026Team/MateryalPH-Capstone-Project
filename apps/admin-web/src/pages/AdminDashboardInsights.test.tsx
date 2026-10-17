import { fireEvent, render, screen, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { expect, test } from 'vitest'
import type { AdminDashboardMarketplace, AdminDashboardVendorHealth, GeoCell } from '@materyalph/api-client-ts'
import { AreaSegmentsPanel, CaseRatesPanel, CategoryInsights, GmvTrendPanel, MarketplaceUnavailable, QueueLoadChart, VendorHealthPanel } from './AdminDashboardInsights'

const cell = (value: number | null, suppressed = false): GeoCell => ({ value, suppressed, reason: suppressed ? 'Suppressed: fewer than 5 distinct Buyers or users.' : null })
const dates = Array.from({ length: 30 }, (_, index) => new Date(Date.UTC(2026, 8, 10 + index)))

function marketplace(overrides: Partial<AdminDashboardMarketplace> = {}): AdminDashboardMarketplace {
  return {
    scope: { code: null, name: 'Philippines', level: null, levelLabel: 'Country', label: 'Philippines', breadcrumbs: [], childrenLabel: 'Regions', drillable: true, psgcVersion: null },
    dataset: { environment: 'DEMO', label: 'DEMO — Simulated Marketplace Data', demo: true, lastAggregatedAt: new Date('2026-10-09T01:00:00Z'), throughDate: '2026-10-08', revision: 1, available: true },
    period: { from: dates[0]!, to: dates[29]!, granularity: 'DAY', days: 30 },
    disclosure: { minimumPersons: 5, method: 'ROLL_UP_TO_PARENT', description: 'Person-derived cells with fewer than 5 distinct Buyers or users are suppressed.' },
    kpis: { vendorCount: cell(12), registeredBuyers: cell(300), grossGmvCentavos: cell(1_250_000_00), netGmvCentavos: cell(1_200_000_00), orderVolume: cell(420),
      fulfillmentRate: { percent: '96.50', numerator: 386, denominator: 400, suppressed: false, reason: null }, cancellationRate: { percent: '2.00', numerator: 8, denominator: 420, suppressed: false, reason: null },
      disputeRate: { percent: null, numerator: null, denominator: null, suppressed: true, reason: 'Suppressed: fewer than 5 distinct Buyers or users.' },
      responseTime: { suppressed: false, reason: null, meanSeconds: 7200, medianSeconds: 3600, p90Seconds: 18_000, answered: 400, unanswered: 20 },
      activeUsers: { buyer: { dau: cell(40), wau: cell(120), mau: cell(260) }, vendor: { dau: cell(9), wau: cell(11), mau: cell(12) } } },
    series: dates.map((date, index) => index === 3 ? { date, grossGmvCentavos: null, netGmvCentavos: null, orderVolume: null, suppressed: true, grossAverageCentavos: null, volumeAverage: null }
      : { date, grossGmvCentavos: 40_000_00 + index * 1_000_00, netGmvCentavos: 38_000_00 + index * 1_000_00, orderVolume: 14, suppressed: false, grossAverageCentavos: 40_000_00, volumeAverage: 14 }),
    forecast: {
      horizonDays: 7,
      grossGmv: { state: 'OK', observedDays: 29, direction: 'INCREASING', changePercent: 60, rSquared: 0.9, weekdayStrength: 0.2, expectedTotal: 490_000_00, anomalies: [{ date: dates[10]!, value: 99_000_00, expected: 50_000_00, deviation: 3.4 }],
        points: Array.from({ length: 7 }, (_, index) => ({ date: new Date(Date.UTC(2026, 9, 10 + index)), value: 70_000_00, lower: 60_000_00, upper: 80_000_00 })) },
      orderVolume: { state: 'INSUFFICIENT_DATA', observedDays: 29, direction: 'UNKNOWN', changePercent: null, rSquared: null, weekdayStrength: null, expectedTotal: null, anomalies: [], points: [] },
    },
    activity: dates.map(date => ({ date, buyerDau: 40, vendorDau: 9, buyerMau: 260, vendorMau: 12 })),
    areas: { childrenLabel: 'Regions', considered: 5, excludedSuppressed: 2, features: ['Active Vendors', 'Registered Buyers', 'Orders', 'Gross GMV'], state: 'OK', reason: null, k: 2, silhouette: 0.74,
      segments: [{ id: 0, label: 'Established markets', size: 2, averageVendors: 5, averageBuyers: 120, averageOrders: 180, averageGmvCentavos: 500_000_00, examples: ['NCR', 'Region IV-A'] },
        { id: 1, label: 'Emerging markets', size: 3, averageVendors: 0.7, averageBuyers: 20, averageOrders: 20, averageGmvCentavos: 60_000_00, examples: ['Region II'] }],
      unusual: [{ code: '1300000000', name: 'NCR', vendors: 8, orders: 300, gmvCentavos: 900_000_00 }],
      recruitment: [{ code: '0200000000', name: 'Region II', vendors: 0, orders: 30, ordersPerVendor: 30 }],
      points: [{ name: 'NCR', vendors: 8, orders: 300, segment: 'Established markets' }, { name: 'Region II', vendors: 0, orders: 30, segment: 'Emerging markets' }] },
    categories: { demand: [{ category: 'Cement', orders: 200 }, { category: 'Aggregates', orders: 120 }], suppressedCategories: 3, baskets: 420, minimumBuyers: 5,
      rules: [{ antecedent: ['Aggregates'], consequent: ['Cement'], support: 0.25, supportCount: 105, confidence: 0.875, lift: 1.84 }] },
    ...overrides,
  }
}

const wrap = (node: React.ReactNode) => render(<MemoryRouter>{node}</MemoryRouter>)

test('the GMV chart keeps suppressed days as gaps, prints the forecast and marks anomalies', () => {
  wrap(<GmvTrendPanel marketplace={marketplace()} />)
  const chart = screen.getByRole('img', { name: /Gross and net GMV per day/ })
  expect(chart.closest('figure')).toHaveTextContent('1 suppressed or empty periods')
  fireEvent.keyDown(chart, { key: 'Home' })
  fireEvent.keyDown(chart, { key: 'ArrowRight' }); fireEvent.keyDown(chart, { key: 'ArrowRight' }); fireEvent.keyDown(chart, { key: 'ArrowRight' })
  expect(within(chart.closest('figure')!).getByRole('status')).toHaveTextContent('Gross GMV suppressed or no value')
  expect(screen.getByText(/Rising trend/)).toBeVisible()
  expect(screen.getByText('Marked period')).toBeVisible()
  fireEvent.click(screen.getByText('View as table'))
  expect(within(screen.getByRole('table', { name: 'GMV per day' })).getAllByText('Suppressed').length).toBeGreaterThanOrEqual(3)
})

test('case rates say when a rate is suppressed instead of showing a number', () => {
  wrap(<CaseRatesPanel marketplace={marketplace()} />)
  expect(screen.getByText('Dispute rate').closest('div')).toHaveTextContent('Suppressed')
  expect(screen.getByText('2.00%')).toBeVisible()
  expect(screen.getByText('1.0 h')).toBeVisible()
})

test('area segments show clusters, recruitment signals and unusual areas, or the reason there are none', () => {
  const { unmount } = wrap(<AreaSegmentsPanel marketplace={marketplace()} />)
  expect(screen.getByRole('img', { name: /Areas by active Vendors and confirmed orders/ })).toBeInTheDocument()
  expect(screen.getAllByText('Established markets').length).toBeGreaterThan(0)
  expect(screen.getByText('30 per Vendor')).toBeVisible()
  expect(screen.getByText('8 Vendors · 300 orders')).toBeVisible()
  expect(screen.getByText(/2 with a suppressed cell left out/)).toBeInTheDocument()
  unmount()
  const base = marketplace()
  wrap(<AreaSegmentsPanel marketplace={marketplace({ areas: { ...base.areas, state: 'INSUFFICIENT_DATA', reason: 'At least four areas with visible supply or demand are needed to group them.', segments: [], points: [] } })} />)
  expect(screen.getByText(/At least four areas/)).toBeVisible()
})

test('category rules read as sentences and respect the small-cell minimum', () => {
  wrap(<CategoryInsights marketplace={marketplace()} />)
  expect(screen.getByText('88% confidence')).toBeVisible()
  expect(screen.getByText(/1.84× more often than chance · in 105 orders/)).toBeVisible()
  expect(screen.getByText(/3 categories with fewer than 5 distinct Buyers are not shown/)).toBeVisible()
})

test('vendor health shows each class with text and the reason for attention', () => {
  const health: AdminDashboardVendorHealth = { total: 4, classes: [{ key: 'HEALTHY', label: 'Healthy', count: 2 }, { key: 'WATCH', label: 'Watch', count: 1 }, { key: 'BELOW_WATCH_LEVEL', label: 'Below workflow watch level', count: 1 }, { key: 'BUILDING_TRACK_RECORD', label: 'New Vendor — Building Track Record', count: 0 }],
    attention: [{ vendorId: '0192f000-0000-7000-8000-000000000009', storeName: 'Slow Hardware', _class: 'BELOW_WATCH_LEVEL', label: 'Below workflow watch level', vps: '2.80', ohs: '3.10', reasons: ['Published VPS is below 3.00.'] }],
    segments: { state: 'INSUFFICIENT_DATA', reason: 'At least four Vendors with a published VPS are needed to group them.', considered: 3, features: ['VPS', 'OHS', 'Completed orders (90 days)'], k: null, silhouette: null, segments: [] } }
  wrap(<VendorHealthPanel health={health} />)
  expect(screen.getByRole('link', { name: 'Slow Hardware' })).toHaveAttribute('href', '/scores/0192f000-0000-7000-8000-000000000009')
  expect(screen.getAllByText('Below workflow watch level').length).toBeGreaterThanOrEqual(2)
  expect(screen.getByText(/VPS 2.80 · OHS 3.10 · Published VPS is below 3.00./)).toBeVisible()
  expect(screen.getByText(/At least four Vendors/)).toBeVisible()
})

test('queue load ranks pending queues and unavailable marketplace data explains itself', () => {
  wrap(<><QueueLoadChart queues={[{ key: 'a', label: 'Disputes under Admin review', group: 'Disputes and appeals', count: 2, href: '/disputes', description: '', oldestAt: null },
    { key: 'b', label: 'Product compliance reviews', group: 'Compliance and quality', count: 7, href: '/product-compliance', description: '', oldestAt: null }, { key: 'c', label: 'Open appeals', group: 'Disputes and appeals', count: 0, href: '/disputes', description: '', oldestAt: null }]} />
    <MarketplaceUnavailable allowed={false} reason={null} /><MarketplaceUnavailable allowed reason="Geographic analytics is turned off in Platform Settings." /></>)
  const items = within(screen.getByRole('list', { name: 'Queue load' })).getAllByRole('listitem')
  expect(items).toHaveLength(2)
  expect(items[0]).toHaveTextContent('Product compliance reviews')
  expect(screen.getByText(/need aggregate analytics access/)).toBeVisible()
  expect(screen.getByText('Geographic analytics is turned off in Platform Settings.')).toBeVisible()
})
