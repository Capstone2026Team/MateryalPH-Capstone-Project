import { dateFilterPreset } from '@materyalph/web-ui'
import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import type { IntegrationOverview } from '@materyalph/api-client-ts'
import * as operations from '../lib/operations-api'
import { AdminIntegrationHealthPage } from './IntegrationHealthPages'

vi.mock('../lib/operations-api', async original => ({ ...await original<typeof import('../lib/operations-api')>(), integrationOverview: vi.fn(), operationFailures: vi.fn(), operationRetryPreview: vi.fn(), operationRetries: vi.fn(), retryOperation: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

function snapshot(overrides: Partial<IntegrationOverview> = {}): IntegrationOverview {
  return { generatedAt: new Date('2026-10-27T02:00:00Z'), environment: { app: 'STAGING', deployment: 'HOSTINGER_VPS', commerce: 'TEST — LIVE commerce disabled' }, canRetry: false,
    integrations: [
      { key: 'email', label: 'Email delivery', status: 'HEALTHY', detail: 'No failed deliveries in 24 h.' },
      { key: 'google_maps', label: 'Google Maps', status: 'NOT_CONFIGURED', detail: 'Manual fallback available.' },
      { key: 'xendit_payments', label: 'Xendit payments', status: 'SIMULATED', detail: 'No provider calls.' },
    ], queues: { status: 'DEGRADED', connection: 'Redis', outbox_backlog: 8, dead_letters: 3, failed_jobs: 0 },
    automaticRecovery: { status: 'HEALTHY', maxCycles: 3, delaysMinutes: [15, 60, 360], lastStartedAt: new Date('2026-11-07T03:00:00Z') },
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
  expect(within(metrics).getByText('VPS third-party services').closest('div')).toHaveTextContent('9')
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
  await waitFor(() => expect(operations.operationFailures).toHaveBeenLastCalledWith('JOBS', 1, dateFilterPreset(30)))
  fireEvent.click(screen.getByRole('tab', { name: 'Overview' }))
  expect(screen.queryByRole('button', { name: 'Re-run aggregation' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Retry eligible deliveries' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Retry eligible jobs' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('tab', { name: 'Recovery activity' }))
  expect(screen.getByRole('tab', { name: 'Failed jobs', selected: true })).toBeInTheDocument()
  expect(operations.retryOperation).not.toHaveBeenCalled()
})

test('service consoles use local logos and safe external links; recovery has no manual queue controls', async () => {
  vi.mocked(operations.integrationOverview).mockResolvedValue(snapshot({ canRetry: true }))
  vi.mocked(operations.operationFailures).mockResolvedValue({ items: [{ kind: 'OUTBOX_EVENT', reference: 'event-1', label: 'Notification delivery', queue: 'notifications', failure: 'Delivery attempts exhausted', attempts: 5, failedAt: new Date(), retryable: true,
    recoveryStatus: 'SCHEDULED', recoveryAttempts: 1, nextRetryAt: new Date('2026-11-07T04:00:00Z') }], lastPage: 1, total: 1 })
  open()
  expect(await screen.findByRole('heading', { name: 'Platform Monitoring' })).toBeInTheDocument()
  await screen.findByLabelText('Operational summary')
  const consoles = screen.getByRole('group', { name: 'Services and integrations' })
  const links = within(consoles).getAllByRole('link')
  expect(links).toHaveLength(9)
  expect([...new Set(links.map(link => link.getAttribute('href')))].sort()).toEqual(['https://hpanel.hostinger.com/', 'https://www.duckdns.org/', 'https://secure.backblaze.com/', 'https://app.brevo.com/', 'https://console.cloudinary.com/users/login', 'https://usebouncer.dev/dashboard/', 'https://console.cloud.google.com/', 'https://console.firebase.google.com/', 'https://dashboard.xendit.co/'].sort())
  links.forEach(link => {
    expect(link).toHaveAttribute('target', '_blank')
    expect(link).toHaveAttribute('rel', 'noopener noreferrer')
  })
  consoles.querySelectorAll('img').forEach(logo => {
    const source = logo.getAttribute('src')!
    expect(source.startsWith('data:') || new URL(source, window.location.href).origin === window.location.origin).toBe(true)
  })
  expect(screen.getByRole('region', { name: 'Automatic recovery' })).toHaveTextContent('3 cycles per event')
  expect(screen.queryByRole('button', { name: /Retry eligible/ })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Review failures' }))
  expect(await screen.findByText('Automatic retry scheduled')).toBeInTheDocument()
  expect(screen.getByText('Recovery 1 of 3 used')).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Retry' })).not.toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'Dead-lettered deliveries', selected: true })).toBeInTheDocument()
  expect(operations.retryOperation).not.toHaveBeenCalled()
})

test('local or Render checks stay visible without becoming VPS provider health and every provider has a link', async () => {
  vi.mocked(operations.integrationOverview).mockResolvedValue(snapshot({ environment: { app: 'DEVELOPMENT', deployment: 'OTHER' }, integrations: [
    { key: 'email', label: 'Mailpit', status: 'HEALTHY', detail: 'Local-only mail details' },
    { key: 'file_storage', label: 'MinIO', status: 'HEALTHY', detail: 'Local-only storage details' },
    { key: 'reverb', label: 'Local Reverb', status: 'HEALTHY', detail: 'Local-only realtime details' },
  ] }))
  open()
  const providers = await screen.findByRole('group', { name: 'Services and integrations' })
  for (const provider of ['Hostinger', 'Duck DNS', 'Backblaze B2', 'Brevo', 'Cloudinary', 'Bouncer', 'Google Cloud', 'Firebase', 'Xendit']) {
    expect(within(providers).getByRole('link', { name: `Open ${provider} console (new tab)` })).toBeInTheDocument()
  }
  for (const label of ['Mailpit', 'MinIO', 'Local Reverb']) {
    expect(within(providers).getByRole('heading', { name: label }).closest('li')).toHaveTextContent('Healthy')
  }
  expect(within(providers).getAllByRole('note', { name: 'Service status scope' })).toHaveLength(1)
  expect(within(providers).getByRole('note', { name: 'Service status scope' })).toHaveTextContent('Checks below describe the current runtime, not deployed provider health.')
  expect(within(providers).getByRole('heading', { name: 'Hostinger' }).closest('li')).toHaveTextContent('VPS reference')
  expect(within(providers).getByRole('heading', { name: 'Cloudinary' }).closest('li')).not.toHaveTextContent('Healthy')
  expect(screen.getByRole('region', { name: 'Integration status' })).toHaveTextContent('VPS reference')
})

test('individual Google diagnostics remain visible and unreported infrastructure has no invented health', async () => {
  vi.mocked(operations.integrationOverview).mockResolvedValue(snapshot({ integrations: [
    { key: 'google_maps', label: 'Maps', status: 'HEALTHY', detail: 'Maps configured.' },
    { key: 'google_oidc', label: 'Sign-in', status: 'HEALTHY', detail: 'Sign-in configured.' },
    { key: 'recaptcha', label: 'reCAPTCHA', status: 'NOT_CONFIGURED', detail: 'Bot protection is disabled.' },
  ] }))
  open()
  const providers = await screen.findByRole('group', { name: 'Services and integrations' })
  expect(within(providers).getByRole('heading', { name: 'Maps' }).closest('li')).toHaveTextContent('Healthy')
  expect(within(providers).getByRole('heading', { name: 'Sign-in' }).closest('li')).toHaveTextContent('Healthy')
  expect(within(providers).getByRole('heading', { name: 'reCAPTCHA' }).closest('li')).toHaveTextContent('Not configured')
  expect(within(providers).getByRole('heading', { name: 'reCAPTCHA' }).closest('li')).toHaveTextContent('Bot protection is disabled.')
  expect(within(providers).getByRole('heading', { name: 'Cloudinary' }).closest('li')).toHaveTextContent('Not reported')
  expect(within(providers).getByRole('heading', { name: 'Hostinger' }).closest('li')).toHaveTextContent('Manage in console')
})

test('retry limits and scheduler outages remain visible', async () => {
  vi.mocked(operations.integrationOverview).mockResolvedValue(snapshot({ automaticRecovery: { status: 'OVERDUE', maxCycles: 3, delaysMinutes: [15, 60, 360], lastStartedAt: null } }))
  vi.mocked(operations.operationFailures).mockResolvedValue({ items: [{ kind: 'OUTBOX_EVENT', reference: 'event-2', label: 'Notification delivery', queue: 'notifications', failure: 'Delivery attempts exhausted', failedAt: new Date(), retryable: true, recoveryStatus: 'LIMIT_REACHED', recoveryAttempts: 3 }], total: 1, lastPage: 1 })
  open()
  await screen.findByLabelText('Operational summary')
  expect(screen.getByRole('region', { name: 'Automatic recovery' })).toHaveTextContent('Overdue')
  fireEvent.click(screen.getByRole('tab', { name: 'Recovery activity' }))
  expect(await screen.findByText('Retry limit reached · needs investigation')).toBeInTheDocument()
})

test('retains every original integration, its complete diagnostics and provider metadata with a logo or service icon', async () => {
  const originalEntries = [
    ['xendit_payments', 'Xendit payments and webhooks'], ['xendit_accounts', 'Xendit sub-account onboarding'],
    ['google_maps', 'Google Maps, Places and Routes'], ['google_oidc', 'Google sign-in'],
    ['email', 'Email delivery'], ['push', 'Push notifications'], ['file_storage', 'Private file storage and scanning'],
    ['reverb', 'Laravel Reverb realtime'], ['ocr', 'OCR assistance'], ['dti_bps_registers', 'DTI-BPS PS and ICC registers'],
  ] as const
  const integrations: IntegrationOverview['integrations'] = originalEntries.map(([key, label]) => ({ key, label, status: 'HEALTHY',
    detail: `Complete recorded diagnostics for ${key}.`, environment: `Provider metadata for ${key}`,
    ...(key === 'xendit_payments' ? { lastEventAt: new Date('2026-11-07T03:00:00Z') } : {}) }))
  vi.mocked(operations.integrationOverview).mockResolvedValue(snapshot({ integrations }))
  open()
  const checks = await screen.findByRole('group', { name: 'Services and integrations' })
  const diagnosticRows = within(checks).getAllByRole('list', { name: / checks$/ }).flatMap(list => within(list).getAllByRole('listitem'))
  expect(diagnosticRows).toHaveLength(16)
  for (const entry of integrations) {
    const row = within(checks).getByRole('listitem', { name: entry.label })
    expect(row).toHaveTextContent(entry.detail)
    expect(row).toHaveTextContent(entry.environment!)
    expect(row).toHaveTextContent('Healthy')
    expect(row.closest('ul')!.closest('li')!.querySelector('img, svg')).not.toBeNull()
  }
  expect(checks.querySelectorAll('img')).toHaveLength(10)
  expect(checks).toHaveTextContent(/Last event .+2026/)
  expect(screen.getByRole('heading', { name: 'Services & integrations' })).toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: 'Connected services' })).not.toBeInTheDocument()
  expect(screen.queryByRole('heading', { name: /^Integrations$/ })).not.toBeInTheDocument()
  expect(new Set(within(checks).getAllByRole('link').map(link => link.getAttribute('href'))).size).toBe(10)
  const certifiedProducts = within(checks).getByRole('link', { name: 'Certified products (new tab)' })
  expect(certifiedProducts).toHaveAttribute('href', 'https://bps.dti.gov.ph/product-certification/certified-products')
  expect(certifiedProducts).toHaveAttribute('target', '_blank')
  expect(certifiedProducts).toHaveAttribute('rel', 'noopener noreferrer')
})

test('groups services by responsibility and keeps related checks under one service and console', async () => {
  vi.mocked(operations.integrationOverview).mockResolvedValue(snapshot({ integrations: [
    { key: 'xendit_payments', label: 'Payments', status: 'SIMULATED', detail: 'Payment diagnostics.' },
    { key: 'xendit_accounts', label: 'Onboarding', status: 'HEALTHY', detail: 'Account diagnostics.' },
    { key: 'reverb', label: 'Reverb realtime', status: 'NOT_CONFIGURED', detail: 'Polling fallback.' },
    { key: 'ocr', label: 'OCR assistance', status: 'HEALTHY', detail: 'Vendor confirmation required.' },
    { key: 'dti_bps_registers', label: 'DTI-BPS PS and ICC registers', status: 'HEALTHY', detail: 'Register diagnostics.' },
    { key: 'additional_adapter', label: 'Additional adapter', status: 'DEGRADED', detail: 'Keep new server checks visible.' },
  ] }))
  open()
  const directory = await screen.findByRole('group', { name: 'Services and integrations' })
  const expected = {
    Infrastructure: ['Hostinger', 'Duck DNS'],
    'Payments & onboarding': ['Xendit'],
    'Storage & media': ['Backblaze B2', 'Cloudinary', 'Bouncer'],
    'Maps & identity': ['Google Cloud'],
    Communication: ['Brevo', 'Firebase', 'Laravel Reverb'],
    'Verification & reference': ['OCR assistance', 'DTI-BPS registers'],
    'Other platform services': ['Additional adapter'],
  }
  for (const [role, services] of Object.entries(expected)) {
    const group = within(directory).getByRole('region', { name: role })
    for (const service of services) expect(within(group).getByRole('heading', { name: service, level: 4 })).toBeInTheDocument()
  }
  const payments = within(directory).getByRole('list', { name: 'Xendit checks' })
  expect(within(payments).getAllByRole('listitem')).toHaveLength(2)
  expect(within(payments).getByRole('listitem', { name: 'Payments' })).toHaveTextContent('Simulated')
  expect(within(payments).getByRole('listitem', { name: 'Onboarding' })).toHaveTextContent('Healthy')
  expect(within(directory).getAllByRole('link', { name: 'Open Xendit console (new tab)' })).toHaveLength(1)
  expect(within(directory).getByRole('listitem', { name: 'Additional adapter' })).toHaveTextContent('Keep new server checks visible.')
})
