import { PortalResourceProvider } from '@materyalph/web-ui'
import { ResponseError } from '@materyalph/api-client-ts'
import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import * as verification from '../lib/vendor-verification-api'
import * as compliance from '../lib/product-compliance-api'
import * as disputes from '../lib/disputes-api'
import * as enforcement from '../lib/operations-api'
import { AdminVendorVerificationQueuePage } from './PhaseThreeAdminPages'
import { AdminProductComplianceQueuePage } from './ProductCompliancePages'
import { AdminDisputeQueuePage } from './DisputePages'
import { AdminEnforcementQueuePage } from './EnforcementPages'

vi.mock('../lib/vendor-verification-api', async original => ({ ...await original<typeof import('../lib/vendor-verification-api')>(), listVendorVerificationQueue: vi.fn() }))
vi.mock('../lib/product-compliance-api', async original => ({ ...await original<typeof import('../lib/product-compliance-api')>(), listComplianceQueue: vi.fn(), listRegisters: vi.fn() }))
vi.mock('../lib/disputes-api', async original => ({ ...await original<typeof import('../lib/disputes-api')>(), listQueue: vi.fn() }))
vi.mock('../lib/operations-api', async original => ({ ...await original<typeof import('../lib/operations-api')>(), listEnforcement: vi.fn() }))
vi.mock('@materyalph/web-ui', async original => ({ ...await original<typeof import('@materyalph/web-ui')>(), PortalShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main>, useNavigationUpdates: () => null }))

const row = { id: 'row-1', storeName: 'Fixture Supply', registeredName: 'Fixture Supply', displayName: 'Fixture material', publicStoreName: 'Fixture Supply', verificationStatus: 'PENDING_VERIFICATION', progress: {}, pendingRequirements: 3, setupStatus: 'IN_PROGRESS',
  version: 1, path: 'MANUAL', referenceResult: 'UNMATCHED', status: 'PENDING_ADMIN_REVIEW', submittedAt: new Date('2026-11-05T00:00:00Z'),
  reference: 'CASE-FIXTURE', orderReference: 'ORD-FIXTURE', vendorName: 'Fixture Supply', issueType: 'DEFECTIVE', requestedRemedy: 'REPLACEMENT', assignedToAdmin: false, refundState: 'NOT_REQUESTED',
  subjectName: 'Fixture Supply', subjectType: 'BUYER', action: 'WARNING', actionLabel: 'Warning', state: 'REFERRED', source: 'DIRECT', createdAt: new Date('2026-11-05T00:00:00Z'), lockVersion: 1 }
const queues = [
  { name: 'verification', path: '/vendor-verification', element: <AdminVendorVerificationQueuePage />, load: verification.listVendorVerificationQueue, response: { items: [row], meta: { total: 41, last_page: 3, status_counts: { PENDING_VERIFICATION: 41, APPROVED: 22 } } }, empty: { items: [], meta: { total: 0, last_page: 1, status_counts: { PENDING_VERIFICATION: 0 } } }, title: 'No cases match this view.' },
  { name: 'compliance', path: '/product-compliance', element: <AdminProductComplianceQueuePage />, load: compliance.listComplianceQueue, response: { items: [row], meta: { total: 41, last_page: 3, counts: { PENDING_ADMIN_REVIEW: 41, VERIFIED: 22 } } }, empty: { items: [], meta: { total: 0, last_page: 1 } }, title: 'No submissions match this view.' },
  { name: 'disputes', path: '/disputes', element: <AdminDisputeQueuePage />, load: disputes.listQueue, response: { items: [{ ...row, status: 'ESCALATED_ADMIN_REVIEW' }], meta: { total: 41, perPage: 20, counts: { NEEDS_ADMIN: 41, CONCLUDED: 2 } } }, empty: { items: [], meta: { total: 0, perPage: 20, counts: { NEEDS_ADMIN: 0 } } }, title: 'No cases in this queue.' },
  { name: 'enforcement', path: '/enforcement', element: <AdminEnforcementQueuePage />, load: enforcement.listEnforcement, response: { items: [row], total: 41, lastPage: 3, counts: { REFERRED: 41, APPLIED: 22 } }, empty: { items: [], total: 0, lastPage: 1 }, title: 'No enforcement records match this view.' },
]

function open(queue: typeof queues[number], query = '') {
  return render(<PortalResourceProvider><MemoryRouter initialEntries={[`${queue.path}${query}`]}><Routes><Route path={queue.path} element={queue.element} /></Routes></MemoryRouter></PortalResourceProvider>)
}

beforeEach(() => { vi.resetAllMocks(); vi.mocked(compliance.listRegisters).mockResolvedValue({ items: [], meta: {} }) })

test.each(queues)('$name keeps the header, filters and tab totals mounted while only the results load', async queue => {
  let finish!: (value: unknown) => void
  vi.mocked(queue.load).mockResolvedValueOnce(queue.response as never).mockImplementationOnce(() => new Promise(resolve => { finish = resolve }) as never)
  open(queue)
  await screen.findByText('41 records')
  const header = screen.getByRole('heading', { level: 1 })
  const tabs = screen.getByRole('tablist')
  const totals = tabs.textContent
  const dateFilter = screen.getByRole('button', { name: 'Last 30 days' })
  const nextTab = { verification: /^Approved/, compliance: /^Verified/, disputes: /^Concluded/, enforcement: /^Applied/ }[queue.name]!
  fireEvent.click(screen.getByRole('tab', { name: nextTab }))
  const loading = await screen.findByText('Loading queue…', { selector: '.mp-queue-loading p' })
  expect(loading.closest('.mp-queue-content')).toHaveAttribute('aria-busy', 'true')
  expect(screen.getByRole('heading', { level: 1 })).toBe(header)
  expect(screen.getByRole('tablist')).toBe(tabs)
  expect(tabs.textContent).toBe(totals)
  expect(screen.getByRole('button', { name: 'Last 30 days' })).toBe(dateFilter)
  expect(dateFilter).toBeEnabled()
  expect(screen.queryByText(/Fixture Supply/)).not.toBeInTheDocument()
  await act(async () => { finish(queue.empty) })
  expect(await screen.findByText(queue.title)).toBeVisible()
  expect(screen.getByRole('tab', { name: nextTab })).toHaveAttribute('aria-selected', 'true')
})

test.each(queues)('$name keeps its status sections and visible rows while refreshing without overview charts', async queue => {
  const pending: { finish?: (value: unknown) => void } = {}
  vi.mocked(queue.load).mockResolvedValueOnce(queue.response as never).mockImplementationOnce(() => new Promise(resolve => { pending.finish = resolve }) as never)
  open(queue)
  await screen.findByText('41 records')
  expect(screen.getAllByText(/Fixture Supply/).length).toBeGreaterThan(0)
  expect(screen.getByRole('tab', { selected: true })).toBeVisible()
  expect(screen.queryByRole('heading', { name: /overview$/i })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: queue.name === 'verification' || queue.name === 'compliance' ? 'Refresh queue' : 'Refresh' }))
  expect(screen.getAllByText(/Fixture Supply/).length).toBeGreaterThan(0)
  expect(screen.getByRole('button', { name: 'Refreshing…' })).toBeDisabled()
  expect(screen.queryByText('Loading queue…', { selector: '.sr-only' })).not.toBeInTheDocument()
  await waitFor(() => expect(pending.finish).toBeTypeOf('function'))
  await act(async () => { pending.finish!(queue.empty) })
  expect(await screen.findByText(queue.title)).toBeVisible()
  expect(screen.queryByRole('navigation', { name: 'Pagination' })).not.toBeInTheDocument()
})

test.each(queues)('$name shows a retryable failure without stale rows or fabricated zero measurements', async queue => {
  const failure = new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'TEMPORARILY_UNAVAILABLE', message: 'Queue unavailable for this request.', details: {} }] }), { status: 503, headers: { 'Content-Type': 'application/json' } }))
  vi.mocked(queue.load).mockResolvedValueOnce(queue.response as never).mockRejectedValueOnce(failure).mockResolvedValueOnce(queue.empty as never)
  open(queue)
  await screen.findByText('41 records')
  fireEvent.click(screen.getByRole('button', { name: queue.name === 'verification' || queue.name === 'compliance' ? 'Refresh queue' : 'Refresh' }))
  expect(await screen.findByRole('alert')).toHaveTextContent('Queue unavailable for this request.')
  expect(screen.queryByText(/Fixture Supply/)).not.toBeInTheDocument()
  expect(screen.queryByText('41 records')).not.toBeInTheDocument()
  expect(screen.queryByText('0 records')).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Try again' }))
  expect(await screen.findByText(queue.title)).toBeVisible()
})

test('enforcement reset restores a selected queue and its ordinary date scope', async () => {
  vi.mocked(enforcement.listEnforcement).mockResolvedValue(queues[3]!.empty as never)
  open(queues[3]!, '?state=LIFTED&source=DISPUTE_REFERRAL&subject=BUYER&page=3&from=2026-10-01')
  await screen.findByText('No enforcement records on this page.')
  fireEvent.click(screen.getByRole('button', { name: 'Reset filters' }))
  expect(screen.getByRole('tab', { name: 'Awaiting decision' })).toHaveAttribute('aria-selected', 'true')
  await waitFor(() => expect(enforcement.listEnforcement).toHaveBeenLastCalledWith(expect.objectContaining({ state: 'REFERRED', page: 1 })))
  expect(vi.mocked(enforcement.listEnforcement).mock.calls.at(-1)![0]).not.toHaveProperty('source')
  expect(vi.mocked(enforcement.listEnforcement).mock.calls.at(-1)![0]).not.toHaveProperty('subjectType')
})

test('verification day filters commit once and keep the full queue context in review links', async () => {
  vi.mocked(verification.listVendorVerificationQueue).mockResolvedValue(queues[0]!.response as never)
  open(queues[0]!, '?status=APPROVED&activation=ACTIVE&expiry=14&page=2&from=2026-10-01&to=2026-10-31')
  const review = (await screen.findAllByRole('link', { name: 'Review' }))[0]!
  expect(review).toHaveAttribute('href', '/vendor-verification/row-1?status=APPROVED&activation=ACTIVE&expiry=14&page=2&from=2026-10-01&to=2026-10-31')
  const calls = vi.mocked(verification.listVendorVerificationQueue).mock.calls.length
  fireEvent.change(screen.getByLabelText('Waiting at least (days)'), { target: { value: '12' } })
  expect(verification.listVendorVerificationQueue).toHaveBeenCalledTimes(calls)
  fireEvent.blur(screen.getByLabelText('Waiting at least (days)'))
  await waitFor(() => expect(verification.listVendorVerificationQueue).toHaveBeenLastCalledWith(expect.objectContaining({ status: 'APPROVED', activation: 'ACTIVE', expiryDays: 14, ageDays: 12, page: 1 })))
})
