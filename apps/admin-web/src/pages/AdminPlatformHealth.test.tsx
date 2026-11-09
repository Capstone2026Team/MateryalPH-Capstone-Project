import { fireEvent, render, screen, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { afterEach, expect, test, vi } from 'vitest'
import { ResponseError, type IntegrationOverview } from '@materyalph/api-client-ts'
import { integrationOverview } from '../lib/operations-api'
import { AdminPlatformHealth, PlatformHealthSnapshot } from './AdminPlatformHealth'

vi.mock('../lib/operations-api', () => ({ integrationOverview: vi.fn() }))
afterEach(() => vi.resetAllMocks())
const snapshot: IntegrationOverview = {
  generatedAt: new Date('2026-11-06T04:00:00Z'), environment: { app: 'LOCAL' }, queues: {}, scheduledTasks: [], analytics: {}, canRetry: false,
  integrations: [
    { key: 'payments', label: 'Xendit payments', status: 'SIMULATED', detail: 'Test adapter.', environment: 'Xendit TEST' },
    { key: 'mail', label: 'Email delivery', status: 'HEALTHY', detail: 'No recorded failure.' },
    { key: 'maps', label: 'Google Maps', status: 'NOT_CONFIGURED', detail: 'Not configured.' },
    { key: 'push', label: 'Push notifications', status: 'DEGRADED', detail: 'A recorded failure.' },
  ],
}
const wrap = (node: React.ReactNode) => render(<MemoryRouter>{node}</MemoryRouter>)

test('every monitored service shows its reported status, separating test adapters and configuration gaps', () => {
  wrap(<PlatformHealthSnapshot data={snapshot} />)
  const services = screen.getByRole('list', { name: 'API services and integrations' })
  expect(within(services).getAllByRole('listitem')).toHaveLength(4)
  expect(within(services).getByText('Simulated')).toBeVisible()
  expect(within(services).getByText('Not configured')).toBeVisible()
  expect(within(services).getByText('Degraded')).toBeVisible()
  expect(within(services).getByText('Xendit TEST')).toBeVisible()
  expect(screen.queryByText(/uptime/i)).not.toBeInTheDocument()
})

test('health loads independently and offers an accessible explanation and monitoring link', async () => {
  vi.mocked(integrationOverview).mockResolvedValue(snapshot)
  wrap(<AdminPlatformHealth />)
  expect(await screen.findByRole('list', { name: 'API services and integrations' })).toBeVisible()
  expect(integrationOverview).toHaveBeenCalledWith({ localForbidden: true })
  expect(screen.getByRole('link', { name: 'Service details' })).toHaveAttribute('href', '/integrations')
  fireEvent.click(screen.getByRole('button', { name: 'How this is calculated: Platform health' }))
  expect(screen.getByText(/snapshot, not uptime or a live connectivity test/)).toBeVisible()
  fireEvent.keyDown(document, { key: 'Escape' })
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
})

test('monitoring denial stays within its card and never renders service data or a retry loop', async () => {
  vi.mocked(integrationOverview).mockRejectedValue(new ResponseError(new Response(null, { status: 403 })))
  wrap(<AdminPlatformHealth />)
  expect(await screen.findByText(/Platform health is outside your role scope/)).toBeVisible()
  expect(screen.queryByRole('list', { name: 'API services and integrations' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Retry platform health' })).not.toBeInTheDocument()
})

test('a failed health request has a retry and recovers without replacing the dashboard', async () => {
  vi.mocked(integrationOverview).mockRejectedValueOnce(new Error('Unavailable')).mockResolvedValueOnce(snapshot)
  wrap(<AdminPlatformHealth />)
  fireEvent.click(await screen.findByRole('button', { name: 'Retry platform health' }))
  expect(await screen.findByRole('list', { name: 'API services and integrations' })).toBeVisible()
})
