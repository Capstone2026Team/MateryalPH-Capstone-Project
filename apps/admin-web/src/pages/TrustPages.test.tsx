import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes, useLocation } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { parseDate } from '@materyalph/api-client-ts'
import * as api from '../lib/trust-api'
import type { AdminScoreDetail, ModerationDetail, ModerationQueueRow } from '../lib/trust-api'
import { AdminMaterialPriceDetailsPage, AdminReviewModerationDetailPage, AdminReviewModerationPage, AdminScoreDetailPage, AdminScoresPage, MaterialsAnalyticsSection } from './TrustPages'

vi.mock('../lib/trust-api', async original => ({ ...await original<typeof import('../lib/trust-api')>(), getModeration: vi.fn(), listModeration: vi.fn(), moderate: vi.fn(), getScore: vi.fn(), listScores: vi.fn(), excludeSource: vi.fn(), suppressBadge: vi.fn(), revokeExclusion: vi.fn(), liftSuppression: vi.fn(), getAdminAnalyticsDetail: vi.fn(), listSources: vi.fn(), correctRun: vi.fn(), listAdminAnalytics: vi.fn(), listRuns: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const review = (overrides: Partial<ModerationDetail> = {}): ModerationDetail => ({
  id: 'r1', type: 'PRODUCT', ratings: { productQuality: 1 }, comment: 'Call me at 0917', displayName: 'Juan C.', moderationState: 'FLAGGED', reviewerParty: 'BUYER', authorDisplayRule: 'First name and last initial',
  verifiedPurchase: { store_name: 'Demo Store' }, availableActions: ['DISMISS_FLAG', 'HIDE_PENDING_REVIEW', 'REQUEST_CORRECTION', 'REMOVE'], lockVersion: 2, visibility: 'PUBLIC',
  history: [{ action: 'FLAG_RAISED', actor_role: 'OWNER', at: '2026-10-04T02:00:00Z', reason: 'PERSONAL_INFORMATION' }], revisions: [{ revision: 1, reason: 'SUBMITTED', content: { comment: 'Call me at 0917' } }], ...overrides,
}) as ModerationDetail

beforeEach(() => { vi.clearAllMocks() })

function LocationProbe() { const location = useLocation(); return <output data-testid="material-location">{location.search}</output> }

test('Materials presets stay anchored to the latest published snapshot and custom dates preserve geographic filters', async () => {
  vi.mocked(api.listRuns).mockResolvedValue([])
  vi.mocked(api.listAdminAnalytics).mockResolvedValue({ dataset: { kind: 'TEST', label: 'TEST' }, window: { presetDays: 30, startDate: parseDate('2026-08-31'), endDate: parseDate('2026-09-30'), latestAvailableDate: parseDate('2026-09-30'), maxDays: 365, presets: [7, 30, 90] }, currentAsOf: new Date('2026-10-09T00:00:00Z'), snapshot: null, updateSchedule: 'Daily', explanation: 'Public prices.', items: [] } as never)
  render(<MemoryRouter initialEntries={['/analytics?view=materials&area=1300000000&paymentMethod=ONLINE']}><MaterialsAnalyticsSection psgcCode="1300000000" areaLabel="NCR" /><LocationProbe /></MemoryRouter>)
  await screen.findByText('No comparable materials in this scope')
  fireEvent.click(screen.getByRole('button', { name: '30-day comparison' }))
  expect(screen.getByLabelText('From')).toHaveValue('2026-08-31')
  expect(screen.getByLabelText('To')).toHaveValue('2026-09-30')
  fireEvent.click(screen.getByRole('button', { name: '7-day comparison' }))
  expect(screen.getByLabelText('From')).toHaveValue('2026-09-23')
  fireEvent.click(within(screen.getByRole('dialog', { name: 'Listed price dates' })).getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(api.listAdminAnalytics).toHaveBeenLastCalledWith(expect.objectContaining({ presetDays: 7, startDate: null, endDate: null, psgcCode: '1300000000' })))
  fireEvent.click(screen.getByRole('button', { name: '7-day comparison' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-09-01' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-09-10' } })
  fireEvent.click(within(screen.getByRole('dialog', { name: 'Listed price dates' })).getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(api.listAdminAnalytics).toHaveBeenLastCalledWith(expect.objectContaining({ startDate: '2026-09-01', endDate: '2026-09-10', psgcCode: '1300000000' })))
  expect(screen.getByTestId('material-location')).toHaveTextContent('area=1300000000')
  expect(screen.getByTestId('material-location')).toHaveTextContent('paymentMethod=ONLINE')
  expect(screen.getByTestId('material-location')).toHaveTextContent('priceFrom=2026-09-01')
})

test('material rows show the permitted listing photo or fall back to the category icon', async () => {
  vi.mocked(api.listRuns).mockResolvedValue([])
  const point = { date: parseDate('2026-09-30'), status: 'OK', averagePhp: '18.42', vendorCount: 3 }
  const row = { groupId: 'g1', displayName: 'CHB 100', material: { id: 'm', name: 'CHB' }, category: { id: 'c', code: 'MASONRY', name: 'Masonry' }, specification: { attributes: [] }, unit: { code: 'PC', name: 'Piece' },
    startPoint: point, endPoint: point, trend: {}, current: { vendorCount: 3, listingCount: 3, status: 'AVAILABLE' } }
  vi.mocked(api.listAdminAnalytics).mockResolvedValue({ dataset: { kind: 'TEST', label: 'TEST' }, window: { presetDays: 30, maxDays: 365, presets: [7, 30, 90] }, currentAsOf: new Date('2026-10-09T00:00:00Z'), snapshot: null, updateSchedule: 'Daily', explanation: 'Public prices.',
    items: [{ ...row, image: { url: 'https://cdn.example.test/chb.jpg', altText: null } }, { ...row, groupId: 'g2', displayName: 'CHB 150', image: null }] } as never)
  render(<MemoryRouter><MaterialsAnalyticsSection psgcCode={null} areaLabel="Philippines" /></MemoryRouter>)
  await screen.findByText('CHB 150')
  const [photographed, plain] = screen.getAllByTestId('material-thumbnail')
  expect(photographed!.querySelector('img')).toHaveAttribute('src', 'https://cdn.example.test/chb.jpg')
  expect(plain!.querySelector('img')).toBeNull()
})

test('daily snapshot health stays collapsed until opened and restores focus after closing the popup', async () => {
  vi.mocked(api.listRuns).mockResolvedValue([{ id: 'run-1', snapshotDate: parseDate('2026-10-27'), revision: 1, state: 'PUBLISHED', observedAt: new Date('2026-10-26T16:10:00Z'), vendors: 23, selected: 304, observations: 364, delayed: false }])
  vi.mocked(api.listAdminAnalytics).mockResolvedValue({ dataset: { label: 'Recorded Marketplace Prices' }, window: {}, currentAsOf: new Date('2026-10-27T12:00:00Z'), snapshot: null, updateSchedule: 'Daily', explanation: 'Public prices.', items: [] } as never)
  render(<MemoryRouter><MaterialsAnalyticsSection psgcCode={null} areaLabel="Philippines" /></MemoryRouter>)
  await screen.findByText('No comparable materials in this scope')
  const trigger = screen.getByRole('button', { name: 'Daily snapshot health' })
  expect(trigger).toHaveAttribute('aria-expanded', 'false')
  expect(screen.queryByRole('dialog', { name: 'Daily snapshot health' })).not.toBeInTheDocument()
  trigger.focus()
  fireEvent.click(trigger)
  const dialog = screen.getByRole('dialog', { name: 'Daily snapshot health' })
  expect(trigger).toHaveAttribute('aria-expanded', 'true')
  expect(within(dialog).getByText('23 Vendors · 304 selected of 364 observations')).toBeVisible()
  expect(within(dialog).getByText('PUBLISHED · rev 1')).toBeVisible()
  expect(api.listRuns).toHaveBeenCalledTimes(1)
  fireEvent.click(within(dialog).getByRole('button', { name: 'Close' }))
  expect(screen.queryByRole('dialog', { name: 'Daily snapshot health' })).not.toBeInTheDocument()
  expect(trigger).toHaveAttribute('aria-expanded', 'false')
  expect(trigger).toHaveFocus()
})

test('moderation offers only server-allowed actions (never delete) and requires a recorded reason', async () => {
  vi.mocked(api.getModeration).mockResolvedValue(review())
  vi.mocked(api.moderate).mockResolvedValue(review({ moderationState: 'CORRECTION_REQUESTED', availableActions: ['REMOVE', 'RESTORE'], lockVersion: 3 }))
  render(<MemoryRouter initialEntries={['/reviews/r1']}><Routes><Route path="/reviews/:reviewId" element={<AdminReviewModerationDetailPage />} /></Routes></MemoryRouter>)
  const decision = await screen.findByRole('combobox', { name: 'Decision' })
  expect(screen.getByRole('button', { name: 'Record decision' })).toBeDisabled()
  expect(within(decision).queryByRole('option', { name: /delete/i })).not.toBeInTheDocument()
  fireEvent.change(decision, { target: { value: 'REQUEST_CORRECTION' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record decision' }))
  expect(await screen.findByText(/at least 10 characters/)).toBeInTheDocument()
  expect(api.moderate).not.toHaveBeenCalled()
  fireEvent.change(screen.getByRole('textbox', { name: /Reason/ }), { target: { value: 'Contains a personal phone number.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record decision' }))
  await waitFor(() => expect(api.moderate).toHaveBeenCalledWith('r1', 'REQUEST_CORRECTION', 'Contains a personal phone number.', 2))
  expect(screen.getByText('Revision 1 · submitted')).toBeInTheDocument()
})

const queueRow: ModerationQueueRow = { id: 'r1', type: 'PRODUCT', storeName: 'Demo Store', displayName: 'Juan C.', moderationState: 'NONE', orderReference: 'ORD-2026-TEST', openFlags: 0, ratings: { productQuality: 4 }, submittedAt: new Date('2026-10-04T02:00:00Z') }

function moderationRoutes(path = '/reviews') {
  return <MemoryRouter initialEntries={[path]}><Routes><Route path="/reviews" element={<AdminReviewModerationPage />} /><Route path="/reviews/:reviewId" element={<AdminReviewModerationDetailPage />} /></Routes></MemoryRouter>
}

test('empty moderation queues explain the scope and offer all reviews without zero-record pagination', async () => {
  vi.mocked(api.listModeration).mockImplementation(async state => ({ items: state === 'ALL' ? [queueRow] : [], total: state === 'ALL' ? 1 : 0, perPage: 20 }))
  render(moderationRoutes())
  expect(await screen.findByText('No reviews need action')).toBeInTheDocument()
  expect(screen.queryByRole('navigation', { name: 'Pagination' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Browse all reviews' }))
  expect(await screen.findByText('No moderation action')).toBeInTheDocument()
  expect(screen.getByRole('tab', { name: 'All reviews' })).toHaveAttribute('aria-selected', 'true')
  expect(screen.queryByText('none', { exact: true })).not.toBeInTheDocument()
  expect(screen.getByText('Product Quality')).toBeInTheDocument()
})

test('opening and returning from a review preserves the queue, submission dates and page', async () => {
  vi.mocked(api.listModeration).mockResolvedValue({ items: [queueRow], total: 21, perPage: 20 })
  vi.mocked(api.getModeration).mockResolvedValue(review())
  const query = '?state=ALL&from=2026-10-01&to=2026-10-10&page=2'
  render(moderationRoutes(`/reviews${query}`))
  const open = await screen.findByRole('link', { name: /View product review by Juan C/ })
  expect(open).toHaveAttribute('href', `/reviews/r1${query}`)
  expect(api.listModeration).toHaveBeenCalledWith('ALL', 2, expect.objectContaining({ from: '2026-10-01', to: '2026-10-10' }))
  fireEvent.click(open)
  const back = await screen.findByRole('link', { name: 'Review Moderation' })
  expect(back).toHaveAttribute('href', `/reviews${query}`)
  fireEvent.click(back)
  expect(await screen.findByText('Page 2 of 2 · 21 records')).toBeInTheDocument()
})

test('a filtered empty queue resets dates and page while retaining the selected queue', async () => {
  vi.mocked(api.listModeration).mockResolvedValue({ items: [], total: 0, perPage: 20 })
  render(moderationRoutes('/reviews?state=REMOVED&from=2026-10-01&page=2'))
  expect(await screen.findByText('No reviews in this date range')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'View all dates' }))
  expect(await screen.findByText('No removed reviews')).toBeInTheDocument()
  expect(api.listModeration).toHaveBeenLastCalledWith('REMOVED', 1, expect.objectContaining({ from: '', to: '' }))
})

test('moderation details show report evidence, private video controls, order context and original revision ratings', async () => {
  vi.mocked(api.getModeration).mockResolvedValue(review({
    comment: '', moderationState: 'NONE', visibility: 'WITHHELD_ACTIVE_DISPUTE', verifiedPurchase: { store_name: 'Demo Store', order_reference: 'ORD-2026-TEST' },
    relatedDispute: { reference: 'CASE-TEST', status: 'UNDER_REVIEW' },
    flags: [{ id: 'f1', reporter_party: 'VENDOR', reason_code: 'FALSE_CLAIM', details: 'The reported product was not supplied.', state: 'DISMISSED', created_at: '2026-10-04T02:00:00Z' }],
    revisions: [{ revision: 1, reason: 'SUBMITTED', created_at: '2026-10-04T01:00:00Z', content: { rating: 2, comment: 'Original review text.' } }],
    media: [{ id: 'media1', url: '/private-video', contentType: 'video/mp4', expiresAt: new Date('2026-10-04T02:05:00Z') }],
  }))
  render(moderationRoutes('/reviews/r1'))
  expect(await screen.findByText('Withheld during an active dispute')).toBeInTheDocument()
  expect(screen.getByText('No moderation action')).toBeInTheDocument()
  expect(screen.getByText('The reported product was not supplied.')).toBeInTheDocument()
  expect(screen.getByText('CASE-TEST')).toBeInTheDocument()
  expect(screen.getByText('ORD-2026-TEST')).toBeInTheDocument()
  expect(screen.getByText('No written comment was included with this review.')).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Load video' })).toBeInTheDocument()
  expect(screen.getByText('Original review text.')).toBeInTheDocument()
  const revisions = screen.getByRole('region', { name: 'Revisions (original preserved)' })
  expect(within(revisions).getByRole('img', { name: 'Product Quality: 2 of 5' })).toBeInTheDocument()
})

test('final removal displays a read-only decision status and an empty history', async () => {
  vi.mocked(api.getModeration).mockResolvedValue(review({ moderationState: 'REMOVED', visibility: 'REMOVED', availableActions: [], history: [], revisions: [] }))
  render(moderationRoutes('/reviews/r1'))
  expect(await screen.findByText(/The decision is final/)).toBeInTheDocument()
  expect(screen.queryByRole('combobox', { name: 'Decision' })).not.toBeInTheDocument()
  expect(screen.getByText('No moderation decisions have been recorded.')).toBeInTheDocument()
  expect(screen.getByText('No revision snapshots are available.')).toBeInTheDocument()
})

test('decision failures preserve the reason and review refresh picks up server-allowed actions', async () => {
  vi.mocked(api.getModeration).mockResolvedValueOnce(review()).mockResolvedValueOnce(review({ lockVersion: 3, availableActions: ['REMOVE', 'RESTORE'], moderationState: 'CORRECTION_REQUESTED' }))
  vi.mocked(api.moderate).mockRejectedValue(new Error('This review changed. Refresh before deciding.'))
  render(moderationRoutes('/reviews/r1'))
  fireEvent.change(await screen.findByRole('combobox', { name: 'Decision' }), { target: { value: 'REMOVE' } })
  expect(screen.getByText(/Permanently remove this review/)).toBeInTheDocument()
  const reason = screen.getByRole('textbox', { name: /Reason/ })
  fireEvent.change(reason, { target: { value: 'Documented guideline violation.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record decision' }))
  expect(await screen.findByText(/This review changed/)).toBeInTheDocument()
  expect(reason).toHaveValue('Documented guideline violation.')
  fireEvent.click(screen.getByRole('button', { name: 'Refresh review' }))
  await waitFor(() => expect(within(screen.getByRole('combobox', { name: 'Decision' })).queryByRole('option', { name: 'Dismiss flag' })).not.toBeInTheDocument())
  expect(screen.getByRole('textbox', { name: /Reason/ })).toHaveValue('')
})

test('a pending decision blocks repeat submission and resets the form after success', async () => {
  vi.mocked(api.getModeration).mockResolvedValue(review())
  let finish!: (value: ModerationDetail) => void
  vi.mocked(api.moderate).mockImplementation(() => new Promise(resolve => { finish = resolve }))
  render(moderationRoutes('/reviews/r1'))
  fireEvent.change(await screen.findByRole('combobox', { name: 'Decision' }), { target: { value: 'REQUEST_CORRECTION' } })
  fireEvent.change(screen.getByRole('textbox', { name: /Reason/ }), { target: { value: 'Please remove personal information.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record decision' }))
  const saving = screen.getByRole('button', { name: 'Saving…' })
  expect(saving).toBeDisabled()
  expect(screen.getByRole('textbox', { name: /Reason/ })).toBeDisabled()
  expect(screen.getByRole('button', { name: 'Refresh review' })).toBeDisabled()
  fireEvent.click(saving)
  expect(api.moderate).toHaveBeenCalledTimes(1)
  finish(review({ moderationState: 'CORRECTION_REQUESTED', lockVersion: 3, availableActions: ['RESTORE', 'REMOVE'] }))
  expect(await screen.findByText(/Decision recorded\. The original review/)).toBeInTheDocument()
  expect(screen.getByRole('textbox', { name: /Reason/ })).toHaveValue('')
  expect(screen.getByRole('combobox', { name: 'Decision' })).toHaveValue('')
})

test('score monitoring never offers a manual award or score control and hides investigation without permission', async () => {
  vi.mocked(api.getScore).mockResolvedValue({ vendorId: 'v1', storeName: 'Demo Store', label: 'VPS 4.40 of 5', asOf: new Date('2026-10-04'), scores: [], badges: [{ code: 'FAST_RESPONDER', name: 'Fast Responder', description: '', status: 'EARNED', scopes: [] }],
    suppressions: [], exclusions: [], sourceEvents: { items: [] }, canInvestigate: false } as unknown as AdminScoreDetail)
  render(<MemoryRouter initialEntries={['/scores/v1']}><Routes><Route path="/scores/:vendorId" element={<AdminScoreDetailPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByText('Fast Responder')).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /award|assign|set score/i })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Suppress badge' })).not.toBeInTheDocument()
  expect(screen.queryByRole('tablist', { name: 'Investigation type' })).not.toBeInTheDocument()
})

const scoreDetail = (overrides: Partial<AdminScoreDetail> = {}): AdminScoreDetail => ({
  vendorId: 'v1', storeName: 'Demo Store', calculated: true, label: 'New Vendor — Building Track Record', asOf: parseDate('2026-10-04'),
  scores: [{ key: 'MQS', published: false, sampleCount: 2, minimumSample: 5, window: 'Rolling 90 days', statusText: 'Needs 5 eligible product ratings' }],
  badgeMetrics: [{ key: 'FRR', value: '0.00', sampleCount: 3, window: 'Trailing 90 days', definition: 'On-time orders divided by fulfilled orders.' }],
  badges: [{ code: 'FAST_RESPONDER', name: 'Fast Responder', description: 'Responds to eligible inquiries within 12 hours.', status: 'NOT_EARNED', scopes: [] }],
  sourceEvents: { items: [], meta: { page: 1, per_page: 20, total: 0 } }, exclusions: [], suppressions: [], badgeHistory: [], canInvestigate: true, ...overrides,
})

function scoreRoutes(entry = '/scores/v1') {
  return <MemoryRouter initialEntries={[entry]}><Routes><Route path="/scores" element={<AdminScoresPage />} /><Route path="/scores/:vendorId" element={<AdminScoreDetailPage />} /></Routes></MemoryRouter>
}

test('score directory preserves search and page through detail navigation and distinguishes zero rates from missing data', async () => {
  vi.mocked(api.listScores).mockResolvedValue({ items: [{ vendorId: 'v1', storeName: 'Demo Store', scores: { label: 'New Vendor — Building Track Record', vps: null, vcs: null, mqs: null, ohs: null, badges: [] }, crr: '0.00', frr: null, sampleCounts: {}, activeSuppressions: 0, activeExclusions: 0 }], total: 21, perPage: 20 } as unknown as Awaited<ReturnType<typeof api.listScores>>)
  vi.mocked(api.getScore).mockResolvedValue(scoreDetail())
  render(scoreRoutes('/scores?q=Demo&page=2'))
  const open = await screen.findByRole('link', { name: 'View performance for Demo Store' })
  expect(api.listScores).toHaveBeenCalledWith('Demo', 2)
  expect(screen.getByText('0.00%')).toBeInTheDocument()
  fireEvent.click(open)
  const back = await screen.findByRole('link', { name: 'Score & Badge Monitoring' })
  expect(back).toHaveAttribute('href', '/scores?q=Demo&page=2')
  fireEvent.click(back)
  expect(await screen.findByRole('searchbox', { name: 'Search stores' })).toHaveValue('Demo')
})

test('score search empty state can reset to all stores without empty pagination', async () => {
  vi.mocked(api.listScores).mockResolvedValue({ items: [], total: 0, perPage: 20 })
  render(scoreRoutes('/scores?q=Unknown'))
  expect(await screen.findByText('No matching stores')).toBeInTheDocument()
  expect(screen.queryByRole('navigation', { name: 'Pagination' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'View all stores' }))
  expect(await screen.findByText('No active stores yet')).toBeInTheDocument()
  expect(api.listScores).toHaveBeenLastCalledWith('', 1)
})

test('score details expose eligibility and supporting metrics and request subsequent source pages', async () => {
  vi.mocked(api.getScore).mockResolvedValue(scoreDetail({ sourceEvents: { items: [{ id: 'e1', metric: 'PRODUCT_QUALITY', value: '4', order_reference: 'ORD-TEST', occurred_at: '2026-10-04T02:00:00Z', excluded: true }], meta: { total: 21, per_page: 20 } } }))
  render(scoreRoutes('/scores/v1?q=Demo&page=2'))
  expect(await screen.findByText('Needs 5 eligible product ratings')).toBeInTheDocument()
  expect(screen.getByText('Responds to eligible inquiries within 12 hours.')).toBeInTheDocument()
  expect(screen.getByText('0.00%')).toBeInTheDocument()
  expect(screen.getByText('Excluded', { exact: true })).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  await waitFor(() => expect(api.getScore).toHaveBeenLastCalledWith('v1', 2))
  expect(await screen.findByRole('link', { name: 'Score & Badge Monitoring' })).toHaveAttribute('href', '/scores?q=Demo&page=2')
})

test('source exclusions validate identifiers, retain failed findings, block repeats and preserve success across refresh', async () => {
  vi.mocked(api.getScore).mockResolvedValue(scoreDetail())
  vi.mocked(api.excludeSource).mockRejectedValueOnce(new Error('Source service unavailable.'))
  render(scoreRoutes())
  const form = await screen.findByRole('form', { name: 'Exclude a score source order' })
  fireEvent.change(within(form).getByRole('textbox', { name: /Reason/ }), { target: { value: 'Confirmed duplicate order evidence.' } })
  fireEvent.change(within(form).getByRole('textbox', { name: 'Order ID' }), { target: { value: 'ORD-reference' } })
  fireEvent.click(within(form).getByRole('button', { name: 'Record exclusion' }))
  expect(await screen.findByText(/Enter a valid Order ID/)).toBeInTheDocument()
  expect(api.excludeSource).not.toHaveBeenCalled()
  const orderId = '019a1234-1234-7123-8123-123456789012'
  fireEvent.change(within(form).getByRole('textbox', { name: 'Order ID' }), { target: { value: orderId } })
  fireEvent.click(within(form).getByRole('button', { name: 'Record exclusion' }))
  expect(await screen.findByText('Source service unavailable.')).toBeInTheDocument()
  expect(within(form).getByRole('textbox', { name: /Reason/ })).toHaveValue('Confirmed duplicate order evidence.')
  let finish!: (value: AdminScoreDetail) => void
  vi.mocked(api.excludeSource).mockImplementation(() => new Promise(resolve => { finish = resolve }))
  fireEvent.click(within(form).getByRole('button', { name: 'Record exclusion' }))
  expect(await screen.findByRole('button', { name: 'Saving…' })).toBeDisabled()
  expect(screen.getByRole('tab', { name: 'Suppress badge' })).toBeDisabled()
  expect(api.excludeSource).toHaveBeenCalledTimes(2)
  finish(scoreDetail())
  expect(await screen.findByText(/Source exclusion recorded/)).toBeInTheDocument()
  await waitFor(() => expect(api.getScore).toHaveBeenCalledTimes(2))
  expect(await screen.findByRole('textbox', { name: 'Order ID' })).toHaveValue('')
})

test('badge suppression requires a case reference and submits the selected documented finding', async () => {
  vi.mocked(api.getScore).mockResolvedValue(scoreDetail())
  vi.mocked(api.suppressBadge).mockResolvedValue(scoreDetail())
  render(scoreRoutes())
  fireEvent.click(await screen.findByRole('tab', { name: 'Suppress badge' }))
  const form = screen.getByRole('form', { name: 'Suppress a badge' })
  fireEvent.change(within(form).getByRole('textbox', { name: /Reason/ }), { target: { value: 'Documented compliance investigation.' } })
  fireEvent.click(within(form).getByRole('button', { name: 'Record suppression' }))
  expect(await screen.findByText(/case reference of at least 3/)).toBeInTheDocument()
  expect(api.suppressBadge).not.toHaveBeenCalled()
  fireEvent.change(within(form).getByRole('textbox', { name: 'Case reference' }), { target: { value: 'CASE-10' } })
  fireEvent.change(within(form).getByRole('combobox', { name: 'Finding category' }), { target: { value: 'COMPLIANCE' } })
  fireEvent.click(within(form).getByRole('button', { name: 'Record suppression' }))
  await waitFor(() => expect(api.suppressBadge).toHaveBeenCalledWith('v1', 'FAST_RESPONDER', 'COMPLIANCE', 'CASE-10', 'Documented compliance investigation.'))
  expect(await screen.findByText(/Badge suppression recorded/)).toBeInTheDocument()
})

test('failed reversals keep the audited reason visible and lifted restrictions retain their history', async () => {
  vi.mocked(api.getScore).mockResolvedValue(scoreDetail({
    exclusions: [{ id: 'x1', order_reference: 'ORD-EXCLUDED', reason_code: 'TEST', note: 'Confirmed test purchase.', created_at: '2026-10-04T02:00:00Z' }],
    suppressions: [{ id: 's1', badge_name: 'Fast Responder', case_reference: 'CASE-OLD', reason_code: 'FRAUD', note: 'Original documented finding.', created_at: '2026-10-04T02:00:00Z', lifted_at: '2026-10-05T02:00:00Z', lift_reason: 'The investigation was resolved.' }],
  }))
  vi.mocked(api.revokeExclusion).mockRejectedValue(new Error('Please retry the reversal.'))
  render(scoreRoutes())
  const restrictions = await screen.findByRole('region', { name: 'Badge suppressions' })
  expect(within(restrictions).getByText('The investigation was resolved.')).toBeInTheDocument()
  expect(within(restrictions).queryByRole('button', { name: 'Lift suppression' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Reverse exclusion' }))
  const form = screen.getByRole('form', { name: 'Reverse exclusion' })
  fireEvent.change(within(form).getByRole('textbox', { name: /Reason/ }), { target: { value: 'Verified legitimate source order.' } })
  fireEvent.click(within(form).getByRole('button', { name: 'Confirm reversal' }))
  expect(await screen.findByText('Please retry the reversal.')).toBeInTheDocument()
  expect(within(form).getByRole('textbox', { name: /Reason/ })).toHaveValue('Verified legitimate source order.')
  expect(api.revokeExclusion).toHaveBeenCalledWith('x1', 'Verified legitimate source order.')
})

test('source inspection requires an audited reason before any request', async () => {
  vi.mocked(api.getAdminAnalyticsDetail).mockResolvedValue({ dataset: { kind: 'TEST', label: 'TEST' }, window: {}, currentAsOf: new Date(), canInspectSources: true, variants: [],
    group: { groupId: 'g1', displayName: 'CHB 100', material: { id: 'm', name: 'CHB' }, category: { id: 'c', code: 'MASONRY', name: 'Masonry' }, specification: { attributes: [] }, unit: { code: 'PC', name: 'Piece' },
      trend: { reason: 'INSUFFICIENT_LOCAL_DATA', label: 'Insufficient Local Data' }, current: { vendorCount: 1, listingCount: 1, status: 'AVAILABLE' }, startPoint: {}, endPoint: {} },
    series: [{ date: new Date('2026-10-04'), status: 'LIMITED_DATA', averagePhp: '100.00', vendorCount: 1, label: 'Limited Local Data — 1 Vendor' }] } as never)
  render(<MemoryRouter initialEntries={['/analytics/materials/g1']}><Routes><Route path="/analytics/materials/:groupId" element={<AdminMaterialPriceDetailsPage />} /></Routes></MemoryRouter>)
  fireEvent.click(await screen.findByRole('button', { name: 'Inspect' }))
  expect(await screen.findByText(/inspections are audited/)).toBeInTheDocument()
  expect(api.listSources).not.toHaveBeenCalled()
  expect(screen.getAllByText('Limited Local Data — 1 Vendor').length).toBeGreaterThan(0)
})
