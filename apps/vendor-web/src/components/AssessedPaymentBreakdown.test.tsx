import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { AssessedPaymentBreakdown, type AssessedPaymentPage } from '@materyalph/web-ui'
import { expect, test, vi } from 'vitest'

const totals = { assessedPayments: 4, paymentPrincipalCentavos: 157025, buyerProcessingFeesCentavos: 4152, collectionsCentavos: 161177, withheldCentavos: 508 }
const sources: AssessedPaymentPage = { hasMore: false, total: 4, data: { taxableYear: 2026, totals, otherStoreTotals: null, payments: [
  { id: 'a', orderReference: 'ORD-2026-AZ5YXGDX', assessedAt: new Date('2026-10-02T10:00:00Z'), paymentPrincipalCentavos: 28550, buyerProcessingFeesCentavos: 755, collectionsCentavos: 29305 },
  { id: 'b', orderReference: 'ORD-2026-WKRIWRHJ', assessedAt: new Date('2026-10-07T10:00:00Z'), paymentPrincipalCentavos: 28550, buyerProcessingFeesCentavos: 755, collectionsCentavos: 29305 },
  { id: 'c', orderReference: 'ORD-2026-QOJYQLNH', assessedAt: new Date('2026-10-13T10:00:00Z'), paymentPrincipalCentavos: 71375, buyerProcessingFeesCentavos: 1887, collectionsCentavos: 73262 },
  { id: 'd', orderReference: 'ORD-2026-BCZHVR6Q', assessedAt: new Date('2026-10-20T10:00:00Z'), paymentPrincipalCentavos: 28550, buyerProcessingFeesCentavos: 755, collectionsCentavos: 29305 },
].map(payment => ({ ...payment, assessedPaymentCentavos: payment.paymentPrincipalCentavos, deliveryCentavos: payment.paymentPrincipalCentavos === 71375 ? 42825 : 0, materialVatCentavos: 3059, grossBasisCentavos: 25491, rateBasisPoints: 50, withheldCentavos: 127 })) } }
const readError = async () => 'Payment records are temporarily unavailable.'

test('displays each retained payment with its original deduction and withholding breakdown', async () => {
  const load = vi.fn().mockResolvedValue(sources)
  render(<AssessedPaymentBreakdown load={load} readError={readError} />)
  const list = within(await screen.findByRole('list', { name: 'Retained online payment sources' }))
  expect(load).toHaveBeenCalledWith(1)
  const payment = within(list.getByRole('article', { name: 'ORD-2026-QOJYQLNH' }))
  expect(payment.getByText('Order amount after refunds').parentElement).toHaveTextContent('₱713.75')
  const basis = within(payment.getByRole('table', { name: 'Tax basis · ORD-2026-QOJYQLNH' }))
  expect(basis.getByRole('row', { name: /^Online payment at assessment/ })).toHaveTextContent('₱713.75')
  expect(basis.getByRole('row', { name: /^Delivery/ })).toHaveTextContent('-₱428.25')
  expect(basis.getByRole('row', { name: /^Material VAT/ })).toHaveTextContent('-₱30.59')
  expect(basis.getByRole('row', { name: /^Tax basis/ })).toHaveTextContent('₱254.91')
  const withholding = within(payment.getByRole('region', { name: 'Recorded withholding · ORD-2026-QOJYQLNH' }))
  expect(withholding.getByText('Tax basis').parentElement).toHaveTextContent('₱254.91')
  expect(withholding.getByText('× Applied rate').parentElement).toHaveTextContent('0.5%')
  expect(withholding.getByText('Withholding tax').parentElement).toHaveTextContent('₱1.27')
  expect(screen.getByText('Total withholding tax').parentElement).toHaveTextContent('₱5.08')
  expect(screen.getByText('Total withholding tax').parentElement).not.toHaveTextContent('₱5.10')
  expect(payment.queryByText('₱18.87')).not.toBeInTheDocument()
  expect(list.getByRole('article', { name: 'ORD-2026-QOJYQLNH' })).not.toHaveTextContent('₱732.62')
  expect(list.getAllByRole('article')).toHaveLength(4)
  expect(screen.queryByText('All 4 retained payments')).not.toBeInTheDocument()
  expect(screen.getByText(/Fully refunded payments are omitted/)).toBeInTheDocument()
  expect(screen.getByRole('heading', { name: 'Annual retained online payments (4)' })).toBeInTheDocument()
  expect(screen.getByRole('region', { name: 'Annual retained online payments' }).querySelector('details, summary')).toBeNull()
  expect(screen.getByText('Full taxable year, regardless of the selected Xendit cash revenue or Transactions dates.')).toBeInTheDocument()
})

test('shows retry after a failed request and an explicit empty state', async () => {
  const load = vi.fn().mockRejectedValueOnce(new Error('offline')).mockResolvedValueOnce({ ...sources, total: 0, data: { ...sources.data, payments: [], totals: { assessedPayments: 0, paymentPrincipalCentavos: 0, buyerProcessingFeesCentavos: 0, collectionsCentavos: 0, withheldCentavos: 0 } } })
  render(<AssessedPaymentBreakdown load={load} readError={readError} />)
  expect(await screen.findByRole('alert')).toHaveTextContent('Payment records are temporarily unavailable.')
  fireEvent.click(screen.getByRole('button', { name: 'Retry payment breakdown' }))
  expect(await screen.findByText('No retained online payments from this store.')).toBeInTheDocument()
  expect(screen.getByText('Total withholding tax').parentElement).toHaveTextContent('₱0.00')
})

test('paginates own records while retaining the full total and aggregate amounts from other stores', async () => {
  const page = { ...sources, hasMore: true, total: 21, data: { ...sources.data, payments: [sources.data.payments[0]!], otherStoreTotals: { assessedPayments: 1, paymentPrincipalCentavos: 28550, buyerProcessingFeesCentavos: 755, collectionsCentavos: 29305, withheldCentavos: 127 } } }
  const load = vi.fn().mockResolvedValueOnce(page).mockResolvedValueOnce({ ...page, hasMore: false })
  render(<AssessedPaymentBreakdown load={load} readError={readError} />)
  expect(await screen.findByText('Other stores under this taxpayer (1 payment)')).toBeInTheDocument()
  expect(screen.getByText('₱1.27 withholding tax')).toBeInTheDocument()
  expect(screen.getByText('Total withholding tax').parentElement).toHaveTextContent('₱5.08')
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  await waitFor(() => expect(load).toHaveBeenLastCalledWith(2))
  expect(await screen.findByText('Page 2 · 21 records')).toBeInTheDocument()
  expect(screen.getByText('All 4 retained payments').parentElement).toHaveTextContent('₱1,570.25')
  expect(screen.getByText('Total withholding tax').parentElement).toHaveTextContent('₱5.08')
})

test('shows the recorded zero rate and preserves assessed tax after a partial principal refund', async () => {
  const original = sources.data.payments[0]!
  const payments = [{ ...original, paymentPrincipalCentavos: 10000 }, { ...original, id: 'relief', orderReference: 'ORD-RELIEF', rateBasisPoints: 0, withheldCentavos: 0 }]
  const load = vi.fn().mockResolvedValue({ ...sources, total: 2, data: { ...sources.data, payments, totals: { ...totals, assessedPayments: 2, withheldCentavos: 127 } } })
  render(<AssessedPaymentBreakdown load={load} readError={readError} />)
  const list = within(await screen.findByRole('list', { name: 'Retained online payment sources' }))
  const partial = within(list.getByRole('article', { name: 'ORD-2026-AZ5YXGDX' }))
  expect(partial.getByText('Order amount after refunds').parentElement).toHaveTextContent('₱100.00')
  expect(partial.getByRole('row', { name: /^Online payment at assessment/ })).toHaveTextContent('₱285.50')
  expect(partial.getByRole('row', { name: /^Tax basis/ })).toHaveTextContent('₱254.91')
  expect(partial.getByText('Withholding tax').parentElement).toHaveTextContent('₱1.27')
  const relief = within(list.getByRole('article', { name: 'ORD-RELIEF' }))
  expect(relief.getByText('× Applied rate').parentElement).toHaveTextContent('0%')
  expect(relief.getByText('Withholding tax').parentElement).toHaveTextContent('₱0.00')
  expect(screen.getByText('Total withholding tax').parentElement).toHaveTextContent('₱1.27')
})
