import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import * as finance from '../lib/finance-api'
import type { FinanceReviewItem, WithholdingAccumulatorDetail } from '../lib/finance-api'
import { AdminAccumulatorPage, AdminFinancePage } from './FinancePages'

vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), listReviewItems: vi.fn(), resolveReviewItem: vi.fn(), approveFeeCredit: vi.fn(),
  listPayments: vi.fn(), getAccumulator: vi.fn(), resolveOverlap: vi.fn(), listAccumulators: vi.fn(), listStatements: vi.fn(), approveStatement: vi.fn(), draftStatements: vi.fn(), listChannelFees: vi.fn(), runReconciliation: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const item = (overrides: Partial<FinanceReviewItem> = {}): FinanceReviewItem => ({ id: 'item-1', kind: 'PAYMENT_MISMATCH', state: 'OPEN', reasonCode: 'AMOUNT_MISMATCH', summary: 'A provider webhook did not match the stored payment attempt; nothing was marked paid.',
  vendor: { id: 'v1', name: 'Test Supply' }, sourceType: 'PAYMENT', sourceId: 'pay-1', expected: { total_centavos: 1026441 }, reported: { amount_centavos: 100 }, createdAt: new Date(), ...overrides })

const page = <T,>(items: T[]) => ({ items, hasMore: false, total: items.length })
const at = (path: string, element: React.ReactNode, pattern = path) => render(<MemoryRouter initialEntries={[path]}><Routes><Route path={pattern} element={element} /></Routes></MemoryRouter>)

beforeEach(() => vi.clearAllMocks())

test('the work queue shows the mismatch and requires a reasoned resolution', async () => {
  vi.mocked(finance.listReviewItems).mockResolvedValue(page([item()]))
  vi.mocked(finance.resolveReviewItem).mockResolvedValue()
  at('/finance', <AdminFinancePage />)
  expect(await screen.findByText('Payment mismatch')).toBeInTheDocument()
  expect(screen.getByText(/nothing was marked paid/)).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Resolve' }))
  expect(await screen.findByText(/at least 10 characters/)).toBeInTheDocument()
  fireEvent.change(screen.getByLabelText('Resolution'), { target: { value: 'Provider confirmed the forged amount; no capture exists.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Resolve' }))
  await waitFor(() => expect(finance.resolveReviewItem).toHaveBeenCalledWith('item-1', 'Provider confirmed the forged amount; no capture exists.'))
})

test('a role without finance.view sees the server explanation instead of data', async () => {
  vi.mocked(finance.listReviewItems).mockRejectedValue(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED', message: 'This finance action is not available to your Admin role.', details: {} }] }), { status: 403, headers: { 'Content-Type': 'application/json' } }), 'denied'))
  at('/finance', <AdminFinancePage />)
  expect(await screen.findByText('This finance action is not available to your Admin role.')).toBeInTheDocument()
})

const accumulator: WithholdingAccumulatorDetail = {
  id: 'acc-1', vendor: { id: 'v1', name: 'Test Supply' }, environment: 'TEST', taxpayerKeySuffix: 'abc123', taxableYear: 2026, thresholdCentavos: 50000000, gAccumulatedCentavos: 100000,
  gExternalDeclaredCentavos: 30000000, gExternalOverlapCentavos: 0, gEffectiveCentavos: 30100000, remainingAllowanceCentavos: 19900000, externalOverlapState: 'UNRESOLVED', status: 'UNDER_REVIEW',
  statusLabel: 'Under review', reasonCode: 'OVERLAP_UNRESOLVED', breached: false, lockVersion: 2, demo: true,
  taxProfile: { tin_masked: '•••-•••-123', declaration_year: 2026 }, events: [{ from_status: null, to_status: 'UNDER_REVIEW', reason_code: 'OVERLAP_UNRESOLVED', g_before_centavos: 0, g_after_centavos: 30000000, actor_type: 'SYSTEM', occurred_at: '2026-10-02T00:00:00Z' }],
  assessments: [],
} as WithholdingAccumulatorDetail

test('the overlap form validates against the declared total and sends the lock version', async () => {
  vi.mocked(finance.getAccumulator).mockResolvedValue(accumulator)
  vi.mocked(finance.resolveOverlap).mockResolvedValue({ ...accumulator, status: 'RELIEF_ACTIVE', externalOverlapState: 'RESOLVED' })
  at('/finance/accumulators/acc-1', <AdminAccumulatorPage />, '/finance/accumulators/:accumulatorId')
  expect(await screen.findByRole('heading', { name: /Test Supply — taxable year 2026/ })).toBeInTheDocument()
  expect(screen.getAllByText('Under review — standard rate applies').length).toBeGreaterThan(0)
  fireEvent.change(screen.getByLabelText(/Overlap already counted/), { target: { value: '400000' } })
  fireEvent.change(screen.getByLabelText('Evidence basis'), { target: { value: 'Declared total includes MateryalPH remittances.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record overlap' }))
  expect(await screen.findByText(/cannot exceed the declared/)).toBeInTheDocument()
  fireEvent.change(screen.getByLabelText(/Overlap already counted/), { target: { value: '1,000.00' } })
  fireEvent.click(screen.getByRole('button', { name: 'Record overlap' }))
  await waitFor(() => expect(finance.resolveOverlap).toHaveBeenCalledWith('acc-1', 100000, 2, 'Declared total includes MateryalPH remittances.'))
})
