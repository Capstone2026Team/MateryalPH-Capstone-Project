import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { OrderDetailFromJSON, OrderSummaryFromJSON } from '@materyalph/api-client-ts'
import * as audit from '../lib/order-audit-api'
import * as operations from '../lib/order-operations-api'
import { orderAuditDetailWire, orderAuditSummaryWire } from '../test/order-audit-fixture'
import { AdminOrderAuditBrowser, AdminOrderAuditPage } from './OrderAuditPages'

vi.mock('../lib/order-audit-api', async original => ({ ...await original<typeof import('../lib/order-audit-api')>(), listAuditOrders: vi.fn(), getAuditOrder: vi.fn() }))
vi.mock('../lib/order-operations-api', async original => ({ ...await original<typeof import('../lib/order-operations-api')>(), listRefunds: vi.fn(), listAuditReimbursements: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

const at = (url: string) => render(<MemoryRouter initialEntries={[url]}><Routes><Route path="/audit" element={<AdminOrderAuditBrowser />} /><Route path="/audit/orders/:orderId" element={<AdminOrderAuditPage />} /></Routes></MemoryRouter>)
beforeEach(() => {
  vi.resetAllMocks()
  vi.mocked(audit.listAuditOrders).mockResolvedValue({ items: [OrderSummaryFromJSON(orderAuditSummaryWire)], meta: { group: 'ALL', counts: {}, page: 1, perPage: 20, total: 1, hasMore: false, currentAsOf: new Date() } })
  vi.mocked(audit.getAuditOrder).mockResolvedValue(OrderDetailFromJSON(orderAuditDetailWire))
  vi.mocked(operations.listRefunds).mockResolvedValue({ items: [], hasMore: false })
  vi.mocked(operations.listAuditReimbursements).mockResolvedValue({ items: [], hasMore: false })
})

test('all-history orders are searchable and open full read-only details with the return filters', async () => {
  at('/audit?view=transactions&state=CONFIRMED')
  expect(await screen.findByRole('table', { name: 'Platform orders' })).toBeInTheDocument()
  expect(audit.listAuditOrders).toHaveBeenCalledWith({ page: 1, orderState: 'CONFIRMED' })
  fireEvent.change(screen.getByRole('searchbox', { name: 'Order, Buyer or Vendor' }), { target: { value: 'Sample Supply' } })
  fireEvent.click(screen.getByRole('button', { name: 'Search orders' }))
  await waitFor(() => expect(audit.listAuditOrders).toHaveBeenLastCalledWith({ page: 1, orderState: 'CONFIRMED', q: 'Sample Supply' }))
  fireEvent.click(screen.getAllByRole('link', { name: 'View order' })[0]!)
  expect(await screen.findByRole('heading', { name: 'Recorded payment breakdown' })).toBeInTheDocument()
  const payments = screen.getByRole('region', { name: 'Payment transactions' })
  expect(within(payments).getAllByText('GCash · attempt 1').length).toBeGreaterThan(0)
  expect(within(payments).getAllByText(/₱2,800.00/).length).toBeGreaterThan(0)
  expect(screen.getByRole('region', { name: 'Cancellation and refunds' })).toHaveTextContent('Refund pending resolution.')
  expect(screen.queryByRole('button', { name: /Retry|Pay|Confirm|Cancel|Decline|Approve/ })).toBeNull()
  expect(screen.getByRole('link', { name: 'Return to orders & refunds' })).toHaveAttribute('href', '/audit?view=transactions&state=CONFIRMED&q=Sample+Supply')
})

test('online refunds and cash reimbursements use separate paginated records without mutation controls', async () => {
  at('/audit?view=transactions&records=refunds&page=2')
  expect(await screen.findByText('No refunds match these filters.')).toBeInTheDocument()
  expect(operations.listRefunds).toHaveBeenCalledWith(2, undefined, { label: 'All time', from: '', to: '' }, undefined)
  fireEvent.click(screen.getByRole('tab', { name: 'Cash reimbursements' }))
  expect(await screen.findByText('No cash reimbursements match these dates.')).toBeInTheDocument()
  expect(operations.listAuditReimbursements).toHaveBeenCalledWith(1, { label: 'All time', from: '', to: '' })
  expect(screen.queryByRole('button', { name: /Confirm reimbursement|Retry after funding/ })).toBeNull()
})

test('case-linked detail carries the case authorization and returns to the same dispute queue context', async () => {
  at('/audit/orders/order-layout?caseId=case-1&status=CONCLUDED&page=2')
  expect(await screen.findByRole('heading', { name: 'Recorded payment breakdown' })).toBeInTheDocument()
  expect(audit.getAuditOrder).toHaveBeenCalledWith('order-layout', 'case-1')
  expect(screen.getByRole('link', { name: 'Return to dispute' })).toHaveAttribute('href', '/disputes/case-1?status=CONCLUDED&page=2')
})

test('a denied order shows the error and retry without showing transaction data', async () => {
  vi.mocked(audit.getAuditOrder).mockRejectedValue(new Error('Not allowed'))
  at('/audit/orders/order-layout')
  expect(await screen.findByRole('alert')).toBeInTheDocument()
  expect(screen.queryByRole('region', { name: 'Payment transactions' })).toBeNull()
})
