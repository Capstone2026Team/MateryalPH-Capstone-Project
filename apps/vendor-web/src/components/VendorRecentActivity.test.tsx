import { act, fireEvent, render, screen, within } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { ResponseError, type VendorTeamActivity, type VendorTeamActivityEnvelope } from '@materyalph/api-client-ts'
import { VendorRecentActivity } from '@materyalph/web-ui'

const event: VendorTeamActivity = {
  id: 'activity-1', actorName: 'Sample Staff', actorRole: 'INVENTORY', category: 'INVENTORY',
  action: 'INVENTORY_ROW_UPDATED', resourceType: 'INVENTORY', resourceId: 'private-resource-id',
  createdAt: new Date('2026-11-04T02:42:00Z'), succeeded: true, correlationId: 'private-correlation-id',
  before: {}, after: { status: 'IN_STOCK', private_document: 'private-field-must-not-render' },
}
const envelope = (events: VendorTeamActivity[] = [event]): VendorTeamActivityEnvelope => ({
  data: events, meta: { currentPage: 1, lastPage: 1, total: events.length, totalEvents: events.length, succeededEvents: events.length, failedEvents: 0, categories: [] }, errors: [],
})
const explainError = async () => 'Activity is temporarily unavailable.'

afterEach(() => { vi.useRealTimers(); vi.restoreAllMocks() })

test('previews only the latest five authorized events, with safe details and Manila timestamps', async () => {
  const list = vi.fn().mockResolvedValue(envelope([
    event,
    { ...event, id: 'activity-2', action: 'ORDER_CONFIRMED', category: 'SALES', resourceType: 'ORDER', after: { status: 'CONFIRMED' } },
    { ...event, id: 'activity-3', action: 'QUOTATION_PUBLISHED', category: 'SALES', resourceType: 'QUOTATION', after: {} },
    { ...event, id: 'activity-4', action: 'ORDER_MILESTONE_RECORDED', category: 'FULFILLMENT', resourceType: 'ORDER', after: { milestone: 'READY_FOR_PICKUP' } },
    { ...event, id: 'activity-5', action: 'INVOICE_ISSUED', category: 'DISPUTES', resourceType: 'INVOICE', succeeded: false, after: { status: 'ISSUED' } },
    { ...event, id: 'activity-6', action: 'OLDER_EVENT' },
  ]))
  render(<VendorRecentActivity list={list} explainError={explainError} />)
  const history = within(await screen.findByRole('list', { name: 'Recent store activity' }))
  expect(history.getAllByRole('listitem')).toHaveLength(5)
  expect(screen.getByRole('list', { name: 'Recent store activity' })).toHaveClass('mp-analytics-activity')
  expect(screen.getByRole('list', { name: 'Recent store activity' }).querySelectorAll('.mp-dashboard-activity-icon > svg')).toHaveLength(5)
  expect(screen.getByText('Latest 5')).toBeVisible()
  expect(history.getByText('Inventory row updated:')).toBeVisible()
  expect(history.getByText('In stock').closest('p')).toHaveTextContent('Sample Staff · In stock')
  expect(history.getByText('Ready for pickup').closest('p')).toHaveTextContent('Sample Staff · Ready for pickup')
  expect(history.getByText('Unsuccessful')).toBeVisible()
  const firstTime = history.getAllByText(/Nov 4, 2026/)[0]!
  expect(firstTime).toHaveTextContent(/10:42\s?am/i)
  expect(firstTime).toHaveAttribute('datetime', '2026-11-04T02:42:00.000Z')
  expect(firstTime).toHaveAttribute('title', expect.stringContaining('Asia/Manila'))
  for (const hidden of ['Older event', 'private-resource-id', 'private-correlation-id', 'private-field-must-not-render', 'Sample Staff · Issued']) expect(screen.queryByText(hidden)).not.toBeInTheDocument()
  expect(list).toHaveBeenCalledWith({ page: 1 })
})

test('loading and an empty history have distinct messages', async () => {
  let resolve!: (value: VendorTeamActivityEnvelope) => void
  const list = vi.fn(() => new Promise<VendorTeamActivityEnvelope>(done => { resolve = done }))
  render(<VendorRecentActivity list={list} explainError={explainError} />)
  expect(screen.getByRole('status')).toHaveTextContent('Loading recent activity…')
  await vi.waitFor(() => expect(list).toHaveBeenCalledOnce())
  await act(async () => { resolve(envelope([])) })
  expect(screen.getByText('No activity recorded yet. Store updates will appear here.')).toBeVisible()
  expect(screen.queryByRole('list')).not.toBeInTheDocument()
  expect(screen.queryByText('Loading recent activity…')).not.toBeInTheDocument()
})

test('a failed initial read stays recoverable without reporting an empty history', async () => {
  const list = vi.fn().mockRejectedValueOnce(new TypeError('Offline')).mockResolvedValueOnce(envelope())
  render(<VendorRecentActivity list={list} explainError={explainError} />)
  expect(await screen.findByRole('alert')).toHaveTextContent('Activity is temporarily unavailable.')
  expect(screen.queryByText(/No activity recorded yet/)).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Retry activity' }))
  expect(await screen.findByText('Inventory row updated:')).toBeVisible()
  expect(screen.queryByRole('alert')).not.toBeInTheDocument()
})

test('automatic updates retain history on transient errors and clear it after access is revoked', async () => {
  vi.useFakeTimers()
  vi.spyOn(document, 'visibilityState', 'get').mockReturnValue('visible')
  vi.spyOn(navigator, 'onLine', 'get').mockReturnValue(true)
  const list = vi.fn().mockResolvedValueOnce(envelope())
    .mockRejectedValueOnce(new TypeError('Offline'))
    .mockRejectedValueOnce(new ResponseError(new Response(null, { status: 403 })))
  render(<VendorRecentActivity list={list} explainError={explainError} />)
  await act(async () => { await vi.advanceTimersByTimeAsync(0) })
  expect(screen.getByText('Inventory row updated:')).toBeVisible()
  await act(async () => { await vi.advanceTimersByTimeAsync(60_000) })
  expect(screen.getByRole('alert')).toHaveTextContent('Showing the last successful update.')
  expect(screen.getByText('Inventory row updated:')).toBeVisible()
  await act(async () => { await vi.advanceTimersByTimeAsync(120_000) })
  expect(screen.queryByText('Inventory row updated:')).not.toBeInTheDocument()
  expect(screen.queryByRole('list')).not.toBeInTheDocument()
  await act(async () => { await vi.advanceTimersByTimeAsync(120_000) })
  expect(list).toHaveBeenCalledTimes(3)
})

test('clearing the session removes previously loaded activity', async () => {
  const list = vi.fn().mockResolvedValue(envelope())
  render(<VendorRecentActivity list={list} explainError={explainError} />)
  await screen.findByText('Inventory row updated:')
  act(() => { window.dispatchEvent(new Event('materyalph:session-cleared')) })
  expect(screen.queryByRole('list')).not.toBeInTheDocument()
  expect(screen.queryByText('Sample Staff · In stock')).not.toBeInTheDocument()
})
