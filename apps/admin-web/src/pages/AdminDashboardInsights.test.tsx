import { fireEvent, render, screen, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { expect, test } from 'vitest'
import type { AdminDashboardMarketplace, AdminDashboardVendorHealth, GeoCell } from '@materyalph/api-client-ts'
import { ActiveUsersPanel, AdminOverviewKpis, AreaSegmentsPanel, CaseRatesPanel, CategoryDemandCard, CategoryInsights, GmvTrendPanel, OrderVolumePanel, MarketplacePerformancePanel, MarketplaceUnavailable, QueueLoadChart, UserPopulationPanel, VendorHealthPanel } from './AdminDashboardInsights'

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
    areas: { childrenLabel: 'Regions', considered: 5, excludedSuppressed: 2, features: ['Active Vendors', 'Registered Buyers', 'Orders', 'Gross sales'], state: 'OK', reason: null, k: 2, silhouette: 0.74,
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
const overviewAmounts = { range: { from: '2026-09-10', to: '2026-10-09' }, platformEarningsCentavos: 38400, platformEarningsChangePercent: 12.4, previousMarketplace: marketplace(), platformEarningsUnavailableReason: 'Needs Finance access.', marketplaceUnavailableReason: 'Needs aggregate analytics access.' }

test('overview uses the shared Vendor summary for accounts, collected commissions and net marketplace value', () => {
  wrap(<AdminOverviewKpis {...overviewAmounts} marketplace={marketplace()} activeBuyers={128} activeVendors={23} inactiveVendors={0} />)
  const summary = screen.getByRole('region', { name: 'At a glance' })
  expect(summary).toHaveAttribute('data-density', 'compact')
  expect(within(summary).getAllByRole('term').map(item => item.textContent)).toEqual(['Platform earnings', 'Net marketplace value', 'Active Buyers', 'Active Tier 2 Vendors'])
  expect(within(summary).getByText('Platform earnings').closest('dl')).toHaveClass('mp-metric-card-accent')
  expect(within(summary).getByText('Active Buyers').closest('dl')).not.toHaveClass('mp-metric-card-accent')
  expect(within(summary).getByText('0 more stores not yet active', { exact: false })).toBeVisible()
  expect(summary.querySelectorAll('.mp-kpi-value')).toHaveLength(4)
  expect(Array.from(summary.querySelectorAll('.mp-kpi-value')).map(item => item.textContent)).toEqual(['₱384.00', '₱1,200,000.00', '128', '23'])
  expect(summary).toHaveTextContent('Amounts: Sep 10 – Oct 9 · Asia/Manila')
  expect(within(summary).getAllByRole('button', { name: /How this is calculated/ })).toHaveLength(4)
  expect(summary).not.toHaveTextContent('Monthly active')
  expect(summary).not.toHaveTextContent('Gross sales')
  expect(summary).not.toHaveTextContent('Pending business-document reviews')
  expect(summary).toHaveTextContent('+12.4%')
  expect(within(summary).getAllByText('vs previous 30 days')).toHaveLength(2)
})

test('overview keeps suppressed marketplace money private while showing recorded zero accounts and commissions', () => {
  const current = marketplace()
  const hidden = marketplace({ kpis: { ...current.kpis, netGmvCentavos: cell(123456789, true) } })
  wrap(<AdminOverviewKpis {...overviewAmounts} platformEarningsCentavos={0} platformEarningsChangePercent={-100} marketplace={hidden} activeBuyers={0} activeVendors={0} inactiveVendors={null} />)
  expect(screen.getByText('Suppressed')).toBeVisible()
  expect(screen.getAllByText('0')).toHaveLength(2)
  expect(screen.getByText('₱0.00')).toBeVisible()
  expect(screen.queryByText('₱1,234,567.89')).not.toBeInTheDocument()
  expect(screen.getByText('Hidden by privacy controls.')).toBeVisible()
})

test('overview preserves negative commission collections and explains money separately from marketplace sales', () => {
  wrap(<AdminOverviewKpis {...overviewAmounts} platformEarningsCentavos={-400} platformEarningsChangePercent={-110} marketplace={marketplace()} activeBuyers={128} activeVendors={23} inactiveVendors={0} />)
  expect(screen.getByText('-₱4.00')).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Platform earnings' }))
  expect(screen.getByRole('dialog')).toHaveTextContent('verified Vendor commission payments allocated to monthly bills − confirmed commission refunds')
  expect(screen.getByRole('dialog')).toHaveTextContent('separate from accrued Net platform earnings, Buyer payments and marketplace sales')
  fireEvent.keyDown(document, { key: 'Escape' })
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Net marketplace value' }))
  expect(screen.getByRole('dialog')).toHaveTextContent('without deducting cancellation refunds twice')
})

test('net marketplace comparison uses visible totals and hides a suppressed previous baseline', () => {
  const current = marketplace()
  const previous = marketplace({ kpis: { ...current.kpis, netGmvCentavos: cell(1_000_000_00) } })
  const { rerender } = wrap(<AdminOverviewKpis {...overviewAmounts} marketplace={current} previousMarketplace={previous} activeBuyers={128} activeVendors={23} inactiveVendors={0} />)
  expect(screen.getByText('Net marketplace value').closest('dl')).toHaveTextContent('+20.0%')
  const suppressed = marketplace({ kpis: { ...previous.kpis, netGmvCentavos: cell(1_000_000_00, true) } })
  rerender(<AdminOverviewKpis {...overviewAmounts} marketplace={current} previousMarketplace={suppressed} activeBuyers={128} activeVendors={23} inactiveVendors={0} />)
  expect(screen.getByText('Net marketplace value').closest('dl')).not.toHaveTextContent('%')
  expect(screen.getByText('Hidden by privacy controls.')).toBeVisible()
})

test('the GMV chart keeps suppressed days as gaps, prints the forecast and marks anomalies', () => {
  wrap(<GmvTrendPanel marketplace={marketplace()} />)
  const chart = screen.getByRole('img', { name: /Gross and net sales per day/ })
  expect(chart.closest('figure')).toHaveTextContent('1 suppressed or empty periods')
  fireEvent.keyDown(chart, { key: 'Home' })
  fireEvent.keyDown(chart, { key: 'ArrowRight' }); fireEvent.keyDown(chart, { key: 'ArrowRight' }); fireEvent.keyDown(chart, { key: 'ArrowRight' })
  expect(within(chart.closest('figure')!).getByRole('status')).toHaveTextContent('Gross sales suppressed or no value')
  fireEvent.click(screen.getByRole('button', { name: 'Show forecast' }))
  expect(screen.queryByLabelText('Chart details for Marketplace value')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Marketplace value' }))
  fireEvent.click(screen.getByText('7-day outlook'))
  expect(screen.getByText(/Rising trend/)).toBeVisible()
  expect(screen.getByText('Marked period')).toBeVisible()
  fireEvent.keyDown(document, { key: 'Escape' })
  fireEvent.click(screen.getByText('View as table'))
  expect(within(screen.getByRole('table', { name: 'GMV per day' })).getAllByText('Suppressed').length).toBeGreaterThanOrEqual(3)
})

test('participant chart keeps active Buyer accounts and Vendor stores separate and never fills denied counts with zero', () => {
  wrap(<UserPopulationPanel buyers={128} vendors={null} />)
  expect(screen.getByText('Buyer accounts').closest('div')).toHaveTextContent('128')
  expect(screen.queryByRole('img')).not.toBeInTheDocument()
  expect(screen.getByText('Tier 2 Vendor stores: outside your role scope.')).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Marketplace participants' }))
  expect(screen.getByText(/different units, so these counts are shown separately/)).toBeVisible()
})

test('participant and category donuts state the correct unit without treating overlapping category matches as unique orders', () => {
  wrap(<><UserPopulationPanel buyers={2} vendors={23} /><CategoryDemandCard marketplace={marketplace()} /></>)
  expect(screen.getByRole('img', { name: 'Active marketplace participants by type, records 25' })).toBeVisible()
  const rows = within(screen.getByRole('region', { name: 'Marketplace participants' })).getAllByRole('listitem')
  expect(rows.map(row => row.textContent)).toEqual(['Buyer accounts2 · 8.0%', 'Tier 2 Vendor stores23 · 92.0%'])
  expect(screen.getByRole('img', { name: /Category demand, shown matches/ })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Category demand' }))
  expect(screen.getByText(/An order can appear in more than one category/)).toBeVisible()
})

test('simplified order chart uses whole-order bars while retaining the 7-day average in its optional table', () => {
  wrap(<OrderVolumePanel marketplace={marketplace()} />)
  const chart = screen.getByRole('img', { name: /Confirmed orders per day/ })
  expect(chart.closest('figure')).not.toHaveTextContent('7-day average')
  fireEvent.click(screen.getByText('View as table'))
  expect(screen.getByRole('table', { name: 'Order activity per day' })).toHaveTextContent('7-day average')
})

test.each([
  { gross: cell(1001), orders: cell(2), expected: '₱5.01' },
  { gross: cell(1001, true), orders: cell(2), expected: 'Suppressed' },
  { gross: cell(1001), orders: cell(2, true), expected: 'Suppressed' },
  { gross: cell(0), orders: cell(0), expected: '—' },
  { gross: cell(0), orders: cell(2), expected: '₱0.00' },
])('average order value respects privacy and zero denominators: $expected', ({ gross, orders, expected }) => {
  const base = marketplace()
  wrap(<MarketplacePerformancePanel marketplace={marketplace({ kpis: { ...base.kpis, grossGmvCentavos: gross, orderVolume: orders } })} />)
  expect(screen.getByText('Average confirmed order value').closest('div')).toHaveTextContent(expected)
})

test('user activity keeps Buyers and Vendor users as separate figures and says when a count is suppressed', () => {
  const base = marketplace()
  const suppressed = marketplace({ kpis: { ...base.kpis, activeUsers: { buyer: base.kpis.activeUsers.buyer, vendor: { dau: cell(null, true), wau: cell(null, true), mau: cell(12) } } } })
  wrap(<><AdminOverviewKpis {...overviewAmounts} activeBuyers={128} activeVendors={25} inactiveVendors={8} marketplace={suppressed} /><ActiveUsersPanel marketplace={suppressed} /></>)
  const kpis = screen.getByRole('region', { name: 'At a glance' })
  expect(within(kpis).getByText('Active Buyers').closest('dl')).toHaveTextContent('128')
  expect(within(kpis).getByText('Active Tier 2 Vendors').closest('dl')).toHaveTextContent('25')
  expect(kpis).not.toHaveTextContent('Monthly active Buyers')
  const panel = screen.getByRole('region', { name: 'Active Buyers and Vendor users' })
  expect(panel).toHaveAttribute('data-wide', 'true')
  expect(within(screen.getByRole('region', { name: 'Buyers activity' })).getAllByRole('definition').map(item => item.textContent)).toEqual(['40', '120', '260'])
  expect(within(screen.getByRole('region', { name: 'Vendor users activity' })).getAllByRole('definition').map(item => item.textContent)).toEqual(['Suppressed', 'Suppressed', '12'])
  expect(screen.getByRole('img', { name: /Daily active Buyers and Vendor users/ })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: '30-day activity' }))
  expect(screen.getByRole('img', { name: /Rolling 30-day active Buyers and Vendor users/ })).toBeInTheDocument()
  expect(screen.queryByRole('img', { name: /Daily active Buyers and Vendor users/ })).not.toBeInTheDocument()
  fireEvent.click(within(panel).getByText('View as table'))
  expect(screen.getByRole('table', { name: 'Active Buyers and Vendor users per day' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Active Buyers and Vendor users' }))
  expect(screen.getByText(/App opens, page views, automated jobs and auto-accept never count/)).toBeVisible()
})

test('activity summaries distinguish real zero counts from suppressed values and retain suppressed chart gaps', () => {
  const base = marketplace()
  const cellHidden = cell(3, true)
  wrap(<ActiveUsersPanel marketplace={marketplace({ kpis: { ...base.kpis, activeUsers: {
    buyer: { dau: cell(0), wau: cell(0), mau: cell(0) }, vendor: { dau: cellHidden, wau: cellHidden, mau: cellHidden },
  } }, activity: [{ date: dates[0]!, buyerDau: 0, vendorDau: null, buyerMau: 0, vendorMau: null }] })} />)
  expect(within(screen.getByRole('region', { name: 'Buyers activity' })).getAllByRole('definition').map(item => item.textContent)).toEqual(['0', '0', '0'])
  expect(within(screen.getByRole('region', { name: 'Vendor users activity' })).getAllByRole('definition').map(item => item.textContent)).toEqual(['Suppressed', 'Suppressed', 'Suppressed'])
  const chart = screen.getByRole('img', { name: /Daily active Buyers and Vendor users/ })
  fireEvent.keyDown(chart, { key: 'Home' })
  expect(within(chart.closest('figure')!).getByRole('status')).toHaveTextContent('Vendor users suppressed or no value')
  fireEvent.click(screen.getByText('View as table'))
  expect(within(screen.getByRole('table', { name: 'Active Buyers and Vendor users per day' })).getAllByText('Suppressed')).toHaveLength(2)
})

test('low activity charts use whole-person axis labels', () => {
  wrap(<ActiveUsersPanel marketplace={marketplace({ activity: [{ date: dates[0]!, buyerDau: 1, vendorDau: 1, buyerMau: 1, vendorMau: 1 }] })} />)
  const chart = screen.getByRole('img', { name: /Daily active Buyers and Vendor users/ })
  expect([...chart.querySelectorAll('g > text')].map(item => item.textContent)).toEqual(['0', '1'])
})

test('overview money and accounts outside the Admin role scope are not shown as zero', () => {
  wrap(<AdminOverviewKpis {...overviewAmounts} platformEarningsCentavos={null} activeBuyers={null} activeVendors={null} inactiveVendors={null} marketplace={null} />)
  expect(screen.getAllByText('Outside your role scope.')).toHaveLength(2)
  expect(screen.getByText('Needs aggregate analytics access.')).toBeVisible()
  expect(screen.getByText('Needs Finance access.')).toBeVisible()
  expect(screen.getAllByText('—')).toHaveLength(4)
  expect(screen.queryByText('0')).not.toBeInTheDocument()
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
  fireEvent.click(screen.getByText('Categories ordered together', { selector: 'summary' }))
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
  fireEvent.click(screen.getByText('Vendor performance groups'))
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
