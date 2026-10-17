import { fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError, type OrderDetail } from '@materyalph/api-client-ts'
import { VendorStaffDashboard } from './VendorStaffDashboard'
import * as deliveries from '../lib/orders-api'
import * as insights from '../lib/dashboard-api'
import { vendorInsightsFixture } from '../test/dashboard-insights-fixture'

vi.mock('../lib/orders-api', async original => ({ ...await original<typeof import('../lib/orders-api')>(), listAssignedFulfillments: vi.fn() }))
vi.mock('../lib/dashboard-api', async original => ({ ...await original<typeof import('../lib/dashboard-api')>(), getVendorDashboardInsights: vi.fn() }))

const order = { id: 'assigned-order', reference: 'ORD-ASSIGNED', fulfillmentMethod: 'DELIVERY', buyer: { displayName: 'Assigned Buyer' }, destination: { type: 'DELIVERY', intended: { formattedAddress: 'Confirmed site' } }, fulfillment: { state: 'OUT_FOR_DELIVERY', expectedDate: '2026-10-14', vehicleIssues: [], assignment: { vehicle: { name: 'Accepted truck' } }, thread: { unreadCount: 1 } } } as unknown as OrderDetail
const totals = { ALL: 52, PENDING: 28, OUT_FOR_DELIVERY: 21, DELIVERED: 3, ISSUES: 2 }
const mount = (permissions: string[]) => render(<MemoryRouter><VendorStaffDashboard permissions={permissions} /></MemoryRouter>)

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(insights.getVendorDashboardInsights).mockResolvedValue(vendorInsightsFixture())
  vi.mocked(deliveries.listAssignedFulfillments).mockImplementation(async input => ({ data: input?.status === 'OUT_FOR_DELIVERY' ? [order] : [], meta: { page: 1, perPage: 20, total: totals[input?.status ?? 'ALL'], hasMore: true } }))
})

test('Fulfillment dashboard uses full server totals, current assignments and status links without store analytics', async () => {
  mount(['portal.fulfillment'])
  expect(await screen.findByRole('link', { name: 'Assigned orders: 52. View assignments' })).toHaveAttribute('href', '/fulfillment?status=ALL')
  expect(screen.getByRole('link', { name: 'Out for delivery: 21. View assignments' })).toHaveAttribute('href', '/fulfillment?status=OUT_FOR_DELIVERY')
  expect(screen.getByRole('link', { name: 'Handover complete: 3. View assignments' })).toHaveAttribute('href', '/fulfillment?status=DELIVERED')
  expect(screen.getByRole('link', { name: /Review delivery issues/ })).toHaveAttribute('href', '/fulfillment?status=ISSUES')
  expect(within(screen.getByRole('region', { name: 'Active deliveries' })).getByText('Confirmed site')).toBeVisible()
  expect(screen.queryByText('Gross sales')).not.toBeInTheDocument()
  expect(screen.queryByText('Store-wide order trends')).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'All dates' })).not.toBeInTheDocument()
  expect(insights.getVendorDashboardInsights).not.toHaveBeenCalled()
  expect(deliveries.listAssignedFulfillments).toHaveBeenCalledTimes(5)
})

test('private invalidation refreshes counts and authorization failure removes the assignment preview', async () => {
  mount(['portal.fulfillment'])
  await screen.findByText('Confirmed site')
  vi.mocked(deliveries.listAssignedFulfillments).mockRejectedValue(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'PERMISSION_DENIED', message: 'Assignment access has ended.' }] }), { status: 403 })))
  fireEvent(window, new Event('materyalph:domain-refresh'))
  expect(await screen.findByText('Assignment access has ended.')).toBeVisible()
  expect(screen.queryByText('Confirmed site')).not.toBeInTheDocument()
  expect(screen.queryByRole('link', { name: 'ORD-ASSIGNED' })).not.toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Retry dashboard' })).toBeVisible()
})

test('a failed dashboard load retries the authorized assignment requests', async () => {
  vi.mocked(deliveries.listAssignedFulfillments).mockRejectedValueOnce(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'SERVICE_UNAVAILABLE', message: 'Deliveries are temporarily unavailable.' }] }), { status: 503 })))
  mount(['portal.fulfillment'])
  expect(await screen.findByText('Deliveries are temporarily unavailable.')).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Retry dashboard' }))
  expect(await screen.findByText('Confirmed site')).toBeVisible()
})

test('Inventory Staff see replenishment and catalog work without order handling or analytic sections', async () => {
  mount(['catalog.manage', 'inventory.manage', 'inventory.view', 'portal.products', 'portal.orders'])
  await screen.findByText('In stock')
  expect(screen.getByRole('link', { name: /Inventory Maintain stock/ })).toHaveAttribute('href', '/products/inventory')
  expect(screen.queryByText('Pending order decisions')).not.toBeInTheDocument()
  expect(screen.queryByText('Gross sales')).not.toBeInTheDocument()
  expect(screen.queryByRole('link', { name: /Orders Review requests/ })).not.toBeInTheDocument()
  expect(deliveries.listAssignedFulfillments).not.toHaveBeenCalled()
})

test('Customer Service sees permitted order and messaging work without inventory management or disabled disputes', async () => {
  mount(['orders.confirm', 'inventory.view', 'portal.messages', 'portal.invoices'])
  await screen.findByText('Pending order decisions')
  const workspace = screen.getByRole('region', { name: 'Your workspace' })
  expect(within(workspace).getByRole('link', { name: /Messages/ })).toHaveAttribute('href', '/messages')
  expect(within(workspace).queryByRole('link', { name: /Inventory|Products|Disputes|Vehicles/ })).not.toBeInTheDocument()
  expect(screen.queryByText('Cases awaiting your response')).not.toBeInTheDocument()
  expect(screen.queryByText('Low stock')).not.toBeInTheDocument()
})

test('Store Manager and Store Staff use operational actions and permitted modules with no full analytics tabs', async () => {
  const manager = mount(['orders.confirm', 'inventory.manage', 'catalog.manage', 'vehicles.manage', 'portal.disputes', 'scores.view_store'])
  await screen.findByText('Pending order decisions')
  expect(screen.getByRole('link', { name: /Vehicles Manage/ })).toHaveAttribute('href', '/vehicles')
  expect(screen.queryByRole('button', { name: 'Sales & Revenue' })).not.toBeInTheDocument()
  manager.unmount()
  mount(['orders.confirm', 'inventory.manage', 'catalog.manage', 'portal.invoices', 'portal.disputes'])
  await waitFor(() => expect(insights.getVendorDashboardInsights).toHaveBeenCalledTimes(2))
  expect(await screen.findByRole('link', { name: /E-Invoices/ })).toHaveAttribute('href', '/invoices')
  expect(screen.queryByRole('link', { name: /Vehicles Manage/ })).not.toBeInTheDocument()
})
