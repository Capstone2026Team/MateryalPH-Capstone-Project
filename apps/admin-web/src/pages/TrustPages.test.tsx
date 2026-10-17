import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes, useLocation } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { parseDate } from '@materyalph/api-client-ts'
import * as api from '../lib/trust-api'
import type { AdminScoreDetail, ModerationDetail } from '../lib/trust-api'
import { AdminMaterialPriceDetailsPage, AdminReviewModerationDetailPage, AdminScoreDetailPage, MaterialsAnalyticsSection } from './TrustPages'

vi.mock('../lib/trust-api', async original => ({ ...await original<typeof import('../lib/trust-api')>(), getModeration: vi.fn(), moderate: vi.fn(), getScore: vi.fn(), getAdminAnalyticsDetail: vi.fn(), listSources: vi.fn(), correctRun: vi.fn(), listAdminAnalytics: vi.fn(), listRuns: vi.fn() }))
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

test('moderation offers only server-allowed actions (never delete) and requires a recorded reason', async () => {
  vi.mocked(api.getModeration).mockResolvedValue(review())
  vi.mocked(api.moderate).mockResolvedValue(review({ moderationState: 'CORRECTION_REQUESTED', availableActions: ['REMOVE', 'RESTORE'], lockVersion: 3 }))
  render(<MemoryRouter initialEntries={['/reviews/r1']}><Routes><Route path="/reviews/:reviewId" element={<AdminReviewModerationDetailPage />} /></Routes></MemoryRouter>)
  const decision = await screen.findByRole('combobox', { name: 'Decision' })
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

test('score monitoring never offers a manual award or score control and hides investigation without permission', async () => {
  vi.mocked(api.getScore).mockResolvedValue({ vendorId: 'v1', storeName: 'Demo Store', label: 'VPS 4.40 of 5', asOf: new Date('2026-10-04'), scores: [], badges: [{ code: 'FAST_RESPONDER', name: 'Fast Responder', description: '', status: 'EARNED', scopes: [] }],
    suppressions: [], exclusions: [], sourceEvents: { items: [] }, canInvestigate: false } as unknown as AdminScoreDetail)
  render(<MemoryRouter initialEntries={['/scores/v1']}><Routes><Route path="/scores/:vendorId" element={<AdminScoreDetailPage />} /></Routes></MemoryRouter>)
  expect(await screen.findByText('Fast Responder')).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /award|assign|set score/i })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Suppress badge' })).not.toBeInTheDocument()
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
