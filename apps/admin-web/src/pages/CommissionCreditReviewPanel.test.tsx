import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { beforeEach, expect, test, vi } from 'vitest'
import * as finance from '../lib/finance-api'
import { CommissionCreditReviewPanel } from './CommissionCreditReviewPanel'
vi.mock('../lib/finance-api', async original => ({ ...await original<typeof import('../lib/finance-api')>(), listReviewItems: vi.fn(), approveFeeCredit: vi.fn() }))
const credit: finance.FinanceReviewItem = { id: 'credit-1', kind: 'FEE_CREDIT_PROPOSAL', state: 'OPEN', reasonCode: 'RETURNED_MATERIALS', summary: 'Review the recorded commission credit.', vendor: { id: 'v1', name: 'Sample Supply' }, sourceType: 'FEE_CREDIT', sourceId: 'proposal-1', expected: { credit_centavos: 3059 }, reported: {}, createdAt: new Date() }
const onChanged = vi.fn()
beforeEach(() => { vi.resetAllMocks(); vi.mocked(finance.listReviewItems).mockResolvedValue({ items: [credit], hasMore: false, total: 1 }) })
test('commission review reads only open credit proposals and preserves the existing approval action', async () => {
  vi.mocked(finance.approveFeeCredit).mockResolvedValue()
  render(<CommissionCreditReviewPanel onClose={() => {}} onChanged={onChanged} />)
  expect(await screen.findByRole('heading', { name: 'Sample Supply' })).toBeInTheDocument()
  expect(finance.listReviewItems).toHaveBeenCalledWith(1, 'OPEN', 'FEE_CREDIT_PROPOSAL')
  fireEvent.click(screen.getByRole('button', { name: 'Approve credit (different reviewer)' }))
  await waitFor(() => expect(finance.approveFeeCredit).toHaveBeenCalledWith('credit-1'))
  expect(onChanged).toHaveBeenCalledTimes(1)
})
test('a denied or failed approval stays open and requires explicit retry', async () => {
  vi.mocked(finance.approveFeeCredit).mockRejectedValueOnce(new Error('Temporary interruption')).mockResolvedValueOnce()
  render(<CommissionCreditReviewPanel onClose={() => {}} onChanged={onChanged} />)
  fireEvent.click(await screen.findByRole('button', { name: 'Approve credit (different reviewer)' }))
  expect(await screen.findByText('Temporary interruption')).toBeInTheDocument()
  expect(onChanged).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Approve credit (different reviewer)' }))
  await waitFor(() => expect(onChanged).toHaveBeenCalledTimes(1))
})
test('empty credit review does not expose approval controls', async () => {
  vi.mocked(finance.listReviewItems).mockResolvedValue({ items: [], hasMore: false, total: 0 })
  render(<CommissionCreditReviewPanel onClose={() => {}} onChanged={onChanged} />)
  expect(await screen.findByText('No commission credits need review.')).toBeInTheDocument()
  expect(screen.queryByRole('button', { name: /Approve/ })).not.toBeInTheDocument()
})
