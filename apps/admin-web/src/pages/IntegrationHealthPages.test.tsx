import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import type { IntegrationOverview } from '@materyalph/api-client-ts'
import * as operations from '../lib/operations-api'
import { AdminIntegrationHealthPage } from './IntegrationHealthPages'

vi.mock('../lib/operations-api', async original => ({ ...await original<typeof import('../lib/operations-api')>(), integrationOverview: vi.fn(), operationFailures: vi.fn(), operationRetryPreview: vi.fn(), operationRetries: vi.fn(), retryOperation: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

function snapshot(overrides: Partial<IntegrationOverview> = {}): IntegrationOverview {
  return { generatedAt: new Date('2026-10-27T02:00:00Z'), environment: { app: 'TEST', commerce: 'TEST — LIVE commerce disabled' }, canRetry: false,
    integrations: [
      { key: 'email', label: 'Email delivery', status: 'HEALTHY', detail: 'No failed deliveries in 24 h.' },
      { key: 'maps', label: 'Google Maps', status: 'NOT_CONFIGURED', detail: 'Manual fallback available.' },
      { key: 'payments', label: 'Xendit payments', status: 'SIMULATED', detail: 'No provider calls.' },
    ], queues: { status: 'DEGRADED', connection: 'Redis', outbox_backlog: 8, dead_letters: 3, failed_jobs: 0 },
    scheduledTasks: [
      { task: 'materyalph:outbox-dispatch', status: 'HEALTHY', durationMs: 45, lastStartedAt: new Date('2026-10-27T01:59:00Z'), expectedWithinMinutes: 5 },
      { task: 'analytics:capture-material-prices', status: 'FAILED', durationMs: 12000, expectedWithinMinutes: 1500 },
      { task: 'materyalph:orders-expire', status: 'NO_RUN_RECORDED', durationMs: null, expectedWithinMinutes: 5 },
      { task: 'materyalph:reviews-sweep', status: 'RUNNING', durationMs: 0, expectedWithinMinutes: 45 },
    ], analytics: {}, ...overrides }
}
const open = () => render(<MemoryRouter><AdminIntegrationHealthPage /></MemoryRouter>)

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(operations.integrationOverview).mockResolvedValue(snapshot())
  vi.mocked(operations.operationFailures).mockResolvedValue({ items: [], lastPage: 1, total: 0 })
  vi.mocked(operations.operationRetries).mockResolvedValue([])
})

test('snapshot charts distinguish simulated and unconfigured integrations and print exact queue counts', async () => {
  open()
  const metrics = await screen.findByLabelText('Operational summary')
  expect(within(metrics).getByText('1 / 3')).toBeInTheDocument()
  expect(within(metrics).getByText('Tasks needing attention').closest('div')).toHaveTextContent('2')
  expect(screen.getByText(/Configuration presence does not confirm live provider availability/)).toBeInTheDocument()
  const chart = screen.getByRole('list', { name: 'Queue exception counts' })
  expect(within(chart).getByText('8')).toBeInTheDocument()
  expect(within(chart).getByText('3')).toBeInTheDocument()
  const zero = within(chart).getByText('Failed jobs').closest('li')!
  expect(zero).toHaveTextContent('0')
  expect(zero.querySelector('[style]')).toHaveStyle({ width: '0%' })
  expect(screen.getByRole('region', { name: 'Integration status' })).toHaveTextContent('Simulated')
})

test('task charts keep missing durations separate from zero and retain exact schedule expectations', async () => {
  open()
  await screen.findByLabelText('Operational summary')
  fireEvent.click(screen.getByRole('tab', { name: 'Scheduled tasks' }))
  const durations = screen.getByRole('list', { name: 'Latest scheduled task durations' })
  expect(within(durations).getByText('0.045 s')).toBeInTheDocument()
  expect(within(durations).getByText('0 s')).toBeInTheDocument()
  expect(within(durations).queryByText('Orders Expire')).not.toBeInTheDocument()
  expect(screen.getByText('1 of 4 tasks have no recorded duration.')).toBeInTheDocument()
  expect(screen.getByRole('table', { name: 'Scheduled task health' })).toHaveTextContent('25 h')
  expect(screen.getByRole('region', { name: 'Scheduled task status' })).toHaveTextContent('No Run Recorded')
  expect(operations.retryOperation).not.toHaveBeenCalled()
})

test('missing queue measurements are unavailable and empty charts show an explicit empty state', async () => {
  vi.mocked(operations.integrationOverview).mockResolvedValue(snapshot({ integrations: [], queues: {}, scheduledTasks: [] }))
  open()
  await screen.findByLabelText('Operational summary')
  expect(screen.getByText('Queue counts have not been recorded.')).toBeInTheDocument()
  expect(screen.queryByRole('list', { name: 'Queue exception counts' })).not.toBeInTheDocument()
  expect(within(screen.getByLabelText('Operational summary')).getAllByText('Not recorded')).toHaveLength(2)
  fireEvent.click(screen.getByRole('tab', { name: 'Scheduled tasks' }))
  expect(screen.getByText('No task durations have been recorded yet.')).toBeInTheDocument()
  expect(screen.queryByRole('table', { name: 'Scheduled task health' })).not.toBeInTheDocument()
})

test('read-only users can inspect failures without retry controls and switching sections retains the failure category', async () => {
  vi.mocked(operations.operationFailures).mockResolvedValue({ items: [{ kind: 'OUTBOX_EVENT', reference: 'event-1', label: 'Notification delivery', queue: 'notifications', failure: 'Delivery attempts exhausted', attempts: 5, failedAt: new Date(), retryable: true }], lastPage: 1, total: 1 })
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Review failures' }))
  await screen.findByRole('table', { name: 'Failures' })
  expect(screen.queryByRole('button', { name: 'Retry' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Failed jobs' }))
  await waitFor(() => expect(operations.operationFailures).toHaveBeenLastCalledWith('JOBS', 1, { label: 'All dates', from: '', to: '' }))
  fireEvent.click(screen.getByRole('tab', { name: 'Overview' }))
  expect(screen.queryByRole('button', { name: 'Re-run aggregation' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Retry eligible deliveries' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Retry eligible jobs' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Failures & retries' }))
  expect(screen.getByRole('tab', { name: 'Failed jobs', selected: true })).toBeInTheDocument()
  expect(operations.retryOperation).not.toHaveBeenCalled()
})

test('card retry actions preview their own category and disable categories with no recorded failures', async () => {
  vi.mocked(operations.integrationOverview).mockResolvedValue(snapshot({ canRetry: true }))
  vi.mocked(operations.operationRetryPreview).mockResolvedValue([])
  open()
  expect(await screen.findByRole('button', { name: 'Retry eligible jobs' })).toBeDisabled()
  fireEvent.click(screen.getByRole('button', { name: 'Retry eligible deliveries' }))
  expect(await screen.findByText('No eligible deliveries are available. Open the failure list to review the required next steps.')).toBeInTheDocument()
  expect(operations.operationRetryPreview).toHaveBeenCalledWith('OUTBOX')
  expect(operations.retryOperation).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Review failure list' }))
  expect(screen.getByRole('tab', { name: 'Dead-lettered deliveries', selected: true })).toBeInTheDocument()
})
