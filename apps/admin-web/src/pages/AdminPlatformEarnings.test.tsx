import { act, fireEvent, render, renderHook, screen, waitFor, within } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { ResponseError, type FinanceKpis } from '@materyalph/api-client-ts'
import { AdminPlatformEarnings, PlatformEarningsChart } from './AdminPlatformEarnings'
import { useAdminPlatformEarnings } from '../lib/use-admin-platform-earnings'
import { financeKpis } from '../lib/finance-api'

vi.mock('../lib/finance-api', () => ({ financeKpis: vi.fn() }))
afterEach(() => vi.resetAllMocks())

const range = { from: '2026-11-01', to: '2026-11-02' }
function EarningsPanel({ range: selected }: { range: typeof range }) {
  const resource = useAdminPlatformEarnings(selected)
  return <AdminPlatformEarnings resource={resource} />
}
const figures = (collected = 5000, refunded = 400, selected = range): FinanceKpis => ({
  label: 'Recorded transactions', scenario: 'Commission event dates in Asia/Manila.', period: { from: new Date(`${selected.from}T00:00:00Z`), to: new Date(`${selected.to}T00:00:00Z`) }, commerce: [], counts: {},
  finance: [
    { key: 'collected', label: 'Collected commissions', valueCentavos: collected, definition: 'Verified allocations.' },
    { key: 'refunded_commissions', label: 'Refunded commissions', valueCentavos: refunded, definition: 'Confirmed fee refunds.' },
    { key: 'net_collected', label: 'Net collected commissions', valueCentavos: collected - refunded, definition: 'Collections less refunds.' },
    { key: 'earned_commission', label: 'Earned commission', valueCentavos: 999000, definition: 'Earned, not collected.' },
    { key: 'net_platform_earnings', label: 'Net platform earnings', valueCentavos: 888000, definition: 'Accrued revenue less costs.' },
  ],
  trendGranularity: 'DAY', trend: [
    { period: new Date('2026-11-01T00:00:00Z'), collectedCentavos: collected, refundedCentavos: 0, earnedCentavos: 999000, creditsCentavos: 0, netEarningsCentavos: 888000, gmvCentavos: 100000000, buyerPaymentsCentavos: 90000000, buyerRefundsCentavos: 0 },
    { period: new Date('2026-11-02T00:00:00Z'), collectedCentavos: 0, refundedCentavos: refunded, earnedCentavos: 0, creditsCentavos: 0, netEarningsCentavos: 0, gmvCentavos: 0, buyerPaymentsCentavos: 0, buyerRefundsCentavos: 0 },
  ],
})

test('paid commissions use the shared bar layout, exact totals and signed refunds, independently of marketplace sales', () => {
  render(<PlatformEarningsChart data={figures()} />)
  const card = screen.getByRole('region', { name: 'Platform earnings' })
  expect(card).toHaveAttribute('data-wide', 'true')
  expect(within(card).getByRole('term').closest('dl')).toHaveTextContent('₱46.00')
  const legend = within(card).getByRole('list', { name: 'Selected period commission totals' })
  expect(legend).toHaveTextContent('Commission payments₱50.00')
  expect(legend).toHaveTextContent('Commission refunds-₱4.00')
  expect(within(card).getByRole('img', { name: /Commission payments and refunds per day/ })).toBeVisible()
  expect(card.querySelectorAll('[data-bar-series="collected"]')).toHaveLength(1)
  expect(card.querySelectorAll('[data-bar-series="refunds"]')).toHaveLength(1)
  expect(card).not.toHaveTextContent('₱9,990.00')
  expect(card).not.toHaveTextContent('₱8,880.00')
  fireEvent.click(within(card).getByText('View as table'))
  const table = within(card).getByRole('table', { name: 'Commission payments per day' })
  expect(within(table).getByRole('row', { name: /Nov 1/ })).not.toHaveTextContent('-₱0.00')
  expect(within(table).getByRole('row', { name: /Nov 2/ })).toHaveTextContent('₱0.00-₱4.00-₱4.00')
  fireEvent.click(within(card).getByRole('button', { name: 'How this is calculated: Platform earnings' }))
  expect(screen.getByRole('table', { name: 'Collected commission calculation' })).toHaveTextContent('₱46.00')
  expect(screen.getByText(/Unpaid bills, pending or failed payments/)).toBeVisible()
  expect(screen.getByText(/separate from Finance’s earned commission revenue/)).toBeVisible()
})

test('a refund-only period shows a negative net collection without drawing negative bars as income', () => {
  render(<PlatformEarningsChart data={figures(0, 400)} />)
  expect(screen.getByRole('term').closest('dl')).toHaveTextContent('-₱4.00')
  expect(document.querySelectorAll('[data-bar-series="collected"]')).toHaveLength(0)
  expect(document.querySelectorAll('[data-bar-series="refunds"]')).toHaveLength(1)
})

test('zero collections stay zero while a missing total stays unavailable', () => {
  const data = figures(0, 0)
  const { rerender } = render(<PlatformEarningsChart data={data} />)
  expect(screen.getByRole('term').closest('dl')).toHaveTextContent('₱0.00')
  rerender(<PlatformEarningsChart data={{ ...data, finance: [] }} />)
  expect(screen.getByRole('term').closest('dl')).toHaveTextContent('—')
})

test('long periods use the server monthly granularity and matching table labels', () => {
  render(<PlatformEarningsChart data={{ ...figures(), trendGranularity: 'MONTH' }} />)
  expect(screen.getByRole('img', { name: /Commission payments and refunds per month/ })).toBeVisible()
  fireEvent.click(screen.getByText('View as table'))
  expect(screen.getByRole('table', { name: 'Commission payments per month' })).toHaveTextContent('Month')
})

test('the panel loads only the selected dates through the authorized Finance client', async () => {
  vi.mocked(financeKpis).mockResolvedValue(figures())
  render(<EarningsPanel range={range} />)
  expect(screen.getByRole('status')).toHaveTextContent('Loading platform earnings')
  await screen.findByRole('img', { name: /Commission payments and refunds per day/ })
  expect(financeKpis).toHaveBeenCalledWith(range.from, range.to, { localForbidden: true })
  expect(financeKpis).toHaveBeenCalledWith('2026-10-30', '2026-10-31', { localForbidden: true })
  expect(financeKpis).toHaveBeenCalledTimes(2)
})

test('an older date response cannot replace the current chart', async () => {
  let finishOld: (data: FinanceKpis) => void = () => undefined
  vi.mocked(financeKpis).mockImplementation((from, to) => from === range.from
    ? new Promise(resolve => { finishOld = resolve }) : Promise.resolve(figures(7000, 0, { from, to })))
  const { rerender } = render(<EarningsPanel range={range} />)
  await waitFor(() => expect(financeKpis).toHaveBeenCalledTimes(2))
  rerender(<EarningsPanel range={{ from: '2026-10-01', to: '2026-10-31' }} />)
  await waitFor(() => expect(screen.getByRole('term').closest('dl')).toHaveTextContent('₱70.00'))
  await act(async () => finishOld(figures()))
  expect(screen.getByRole('term').closest('dl')).toHaveTextContent('₱70.00')
})

test('finance permission failures show no amounts or retry control', async () => {
  vi.mocked(financeKpis).mockRejectedValue(new ResponseError(new Response('{}', { status: 403 })))
  render(<EarningsPanel range={range} />)
  expect(await screen.findByText(/Platform earnings is outside your role scope/)).toBeVisible()
  expect(screen.queryByText('Net collected commissions')).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Retry platform earnings' })).not.toBeInTheDocument()
})

test('a failed Finance read stays unavailable and can be retried', async () => {
  vi.mocked(financeKpis).mockRejectedValueOnce(new Error('The connection is offline.')).mockResolvedValue(figures())
  render(<EarningsPanel range={range} />)
  expect(await screen.findByText('The connection is offline.')).toBeVisible()
  expect(screen.queryByText('₱0.00')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Retry platform earnings' }))
  await screen.findByRole('img', { name: /Commission payments and refunds per day/ })
})

test('commission percentage compares actual net collections with the preceding equal-length period', async () => {
  vi.mocked(financeKpis).mockImplementation((from, to) => Promise.resolve(figures(from === range.from ? 5000 : 2000, 0, { from, to })))
  const { result } = renderHook(() => useAdminPlatformEarnings(range))
  await waitFor(() => expect(result.current.netCollectedCentavos).toBe(5000))
  expect(result.current.changePercent).toBe(150)
})

test.each([0, -200])('a previous net commission total of %s has no invented percentage', async previous => {
  vi.mocked(financeKpis).mockImplementation((from, to) => Promise.resolve(figures(from === range.from ? 5000 : previous, 0, { from, to })))
  const { result } = renderHook(() => useAdminPlatformEarnings(range))
  await waitFor(() => expect(result.current.netCollectedCentavos).toBe(5000))
  expect(result.current.changePercent).toBeNull()
})

test('an unavailable commission comparison preserves current money without treating the missing period as zero', async () => {
  vi.mocked(financeKpis).mockImplementation((from, to) => from === range.from ? Promise.resolve(figures(5000, 400, { from, to })) : Promise.reject(new Error('Previous period offline.')))
  const { result } = renderHook(() => useAdminPlatformEarnings(range))
  await waitFor(() => expect(result.current.netCollectedCentavos).toBe(4600))
  expect(result.current.changePercent).toBeNull()
  expect(result.current.error).toBeNull()
})

test.each([401, 403])('a commission comparison HTTP %s cannot retain current financial amounts', async status => {
  const failure = new ResponseError(new Response('{}', { status }))
  vi.mocked(financeKpis).mockImplementation(from => from === range.from ? Promise.resolve(figures()) : Promise.reject(failure))
  const { result } = renderHook(() => useAdminPlatformEarnings(range))
  await waitFor(() => expect(result.current.error).toBe(failure))
  expect(result.current.netCollectedCentavos).toBeNull()
  expect(result.current.changePercent).toBeNull()
})
