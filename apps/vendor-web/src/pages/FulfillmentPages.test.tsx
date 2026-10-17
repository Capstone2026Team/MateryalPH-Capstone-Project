import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import type { OrderDetail } from '../lib/orders-api'
import * as api from '../lib/orders-api'
import { VendorFulfillmentPage } from './FulfillmentPages'
import { decodeDeliveryPolyline } from '@materyalph/web-ui'

vi.mock('../lib/orders-api', async original => ({ ...await original<typeof import('../lib/orders-api')>(), listAssignedFulfillments: vi.fn(), getOrder: vi.fn(), acknowledgeAssignment: vi.fn(), getDeliveryDirections: vi.fn(), recordMilestone: vi.fn() }))
const account = vi.hoisted(() => ({ permissions: ['portal.fulfillment'] }))
vi.mock('../lib/vendor-status', () => ({ useOnboardingSnapshot: () => ({ snapshot: { permissions: account.permissions, organization: { storeName: 'Delivery Store' } }, loading: false, error: null, refresh: vi.fn() }) }))
vi.mock('./PhaseThreeVendorPages', () => ({ VendorShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main>, PageHeader: ({ title, description }: { title: string; description: string }) => <header><h1>{title}</h1><p>{description}</p></header>, LoadingState: ({ label }: { label: string }) => <p>{label}</p>, ErrorState: ({ message }: { message: string }) => <p role="alert">{message}</p> }))
vi.mock('./FulfillmentConversationDialog', () => ({ FulfillmentConversationDialog: ({ conversationId }: { conversationId: string }) => <div role="dialog" aria-label="Fulfillment messages">{conversationId}</div> }))

const order = {
  id: 'delivery-one', reference: 'ORD-DELIVERY-ONE', lockVersion: 3, fulfillmentMethod: 'DELIVERY', buyer: { displayName: 'Delivery Buyer' },
  destination: { type: 'DELIVERY', intended: { formattedAddress: 'Intended site' }, alternateDropOff: { formattedAddress: 'Confirmed north gate' }, heavyVehicleRestriction: 'YES', accessInstructions: 'Call at the gate' },
  states: [{ family: 'ORDER', state: 'OUT_FOR_DELIVERY' }], permissions: { canRecordMilestone: true, canReportVehicleIssue: false, canAssignFulfillment: false },
  fulfillment: { method: 'DELIVERY', state: 'OUT_FOR_DELIVERY', expectedDate: '2026-10-14', trackingNotice: 'No live GPS tracking.', nextAction: 'RECORD_DELIVERY', late: false, trips: [], steps: [{ key: 'DELIVERED', label: 'Delivered', status: 'CURRENT', proofRequired: true, proofRequirements: [] }], receipt: { paused: false, windowHours: 48 }, vehicleIssues: [],
    assignment: { displayName: 'Assigned Staff', assignedAt: new Date('2026-10-13T01:00:00Z'), vehicle: { name: 'Accepted truck', vehicleIndex: 0 } }, thread: { available: true, conversationId: 'delivery-thread', readOnly: false, unreadCount: 2 } },
} as unknown as OrderDetail
const page = { data: [order], meta: { page: 1, perPage: 20, total: 1, hasMore: false } }
function mount(path = '/fulfillment') { return render(<MemoryRouter initialEntries={[path]}><Routes><Route path="/fulfillment" element={<VendorFulfillmentPage />} /><Route path="/fulfillment/:orderId" element={<VendorFulfillmentPage />} /></Routes></MemoryRouter>) }
beforeEach(() => {
  vi.clearAllMocks(); account.permissions = ['portal.fulfillment']
  vi.mocked(api.listAssignedFulfillments).mockResolvedValue(page)
  vi.mocked(api.getOrder).mockResolvedValue(order)
  vi.mocked(api.getDeliveryDirections).mockRejectedValue(new Error('Route unavailable'))
  vi.mocked(api.acknowledgeAssignment).mockResolvedValue({ ...order, fulfillment: { ...order.fulfillment!, assignment: { ...order.fulfillment!.assignment!, acknowledgedAt: new Date() } } })
})

test('assigned deliveries show the actual drop-off and vehicle, and search/status/sort are server filters', async () => {
  mount()
  expect(await screen.findByText('Confirmed north gate')).toBeVisible()
  expect(screen.getByText('Accepted truck')).toBeVisible()
  fireEvent.click(screen.getByRole('tab', { name: 'Delivery issues' }))
  await waitFor(() => expect(api.listAssignedFulfillments).toHaveBeenLastCalledWith({ status: 'ISSUES', sort: 'SCHEDULED', page: 1 }))
  fireEvent.change(screen.getByRole('searchbox', { name: 'Search deliveries' }), { target: { value: 'Buyer' } })
  fireEvent.click(screen.getByRole('button', { name: 'Search' }))
  await waitFor(() => expect(api.listAssignedFulfillments).toHaveBeenLastCalledWith({ status: 'ISSUES', sort: 'SCHEDULED', page: 1, q: 'Buyer' }))
  fireEvent.change(screen.getByRole('combobox', { name: 'Sort' }), { target: { value: 'NEWEST' } })
  await waitFor(() => expect(api.listAssignedFulfillments).toHaveBeenLastCalledWith({ status: 'ISSUES', sort: 'NEWEST', page: 1, q: 'Buyer' }))
})

test('Owner workspace access is denied without requesting assigned deliveries', () => {
  account.permissions = ['fulfillment.assign', 'portal.orders']
  mount()
  expect(screen.getByText(/This workspace is available to Fulfillment Staff/)).toBeVisible()
  expect(api.listAssignedFulfillments).not.toHaveBeenCalled()
})

test('a new delivery assignment appears after a private invalidation while retaining the staff filters', async () => {
  vi.mocked(api.listAssignedFulfillments).mockResolvedValueOnce({ data: [], meta: { page: 1, perPage: 20, total: 0, hasMore: false } })
  mount('/fulfillment?status=OUT_FOR_DELIVERY&sort=NEWEST&q=Delivery')
  expect(await screen.findByText(/No assigned deliveries/)).toBeVisible()
  fireEvent(window, new Event('materyalph:domain-refresh'))
  expect(await screen.findByRole('link', { name: 'ORD-DELIVERY-ONE' })).toBeVisible()
  expect(api.listAssignedFulfillments).toHaveBeenLastCalledWith({ status: 'OUT_FOR_DELIVERY', sort: 'NEWEST', page: 1, q: 'Delivery' })
  expect(screen.getByRole('searchbox', { name: 'Search deliveries' })).toHaveValue('Delivery')
})

test('resubmitting an unchanged search retains results and assignment navigation retains all filters', async () => {
  mount('/fulfillment?status=OUT_FOR_DELIVERY&sort=NEWEST&q=Delivery&page=2')
  const assignment = await screen.findByRole('link', { name: 'ORD-DELIVERY-ONE' })
  expect(assignment).toHaveAttribute('href', '/fulfillment/delivery-one?status=OUT_FOR_DELIVERY&sort=NEWEST&q=Delivery&page=2')
  fireEvent.click(screen.getByRole('button', { name: 'Search' }))
  // A new search starts at page one; repeating that search must leave the result in place.
  await waitFor(() => expect(api.listAssignedFulfillments).toHaveBeenLastCalledWith({ status: 'OUT_FOR_DELIVERY', sort: 'NEWEST', page: 1, q: 'Delivery' }))
  await screen.findByRole('link', { name: 'ORD-DELIVERY-ONE' })
  fireEvent.click(screen.getByRole('button', { name: 'Search' }))
  expect(screen.getByRole('link', { name: 'ORD-DELIVERY-ONE' })).toBeVisible()
  fireEvent.click(screen.getByRole('link', { name: 'ORD-DELIVERY-ONE' }))
  expect(await screen.findByRole('link', { name: '← Assigned deliveries' })).toHaveAttribute('href', '/fulfillment?status=OUT_FOR_DELIVERY&sort=NEWEST&q=Delivery')
})

test('staff acknowledge, open the order thread, and cannot deliver without submitted proof', async () => {
  mount('/fulfillment/delivery-one')
  fireEvent.click(await screen.findByRole('button', { name: 'Acknowledge assignment' }))
  await waitFor(() => expect(api.acknowledgeAssignment).toHaveBeenCalledWith('delivery-one', expect.any(String)))
  fireEvent.click(screen.getByRole('button', { name: /Message Buyer/ }))
  expect(screen.getByRole('dialog', { name: 'Fulfillment messages' })).toHaveTextContent('delivery-thread')
  fireEvent.click(screen.getByRole('button', { name: 'Record delivery' }))
  expect(await screen.findByText('Add a delivery photo.')).toBeVisible()
  expect(api.recordMilestone).not.toHaveBeenCalled()
  expect(screen.getByLabelText('Take delivery photo')).toHaveAttribute('capture', 'environment')
  expect(screen.getByRole('link', { name: 'Open directions' })).toHaveAttribute('href', expect.stringContaining('Confirmed%20north%20gate'))
  expect(await screen.findByRole('button', { name: 'Retry route' })).toBeVisible()
})

test('assignment items use confirmed quantities and omit removed lines and financial figures', async () => {
  const lines = [
    { id: 'cement', displayName: 'Cement bags', variantLabel: '40 kg', unitName: 'bag', requestedQuantity: '10.0000', confirmedQuantity: '8.0000', change: 'QUANTITY_REDUCED', unitPriceCentavos: 12000 },
    { id: 'removed', displayName: 'Removed load', unitName: 'piece', requestedQuantity: '2.0000', confirmedQuantity: '0.0000', change: 'LINE_REMOVED', unitPriceCentavos: 10000 },
  ] as unknown as OrderDetail['lines']
  vi.mocked(api.getOrder).mockResolvedValue({ ...order, lines })
  mount('/fulfillment/delivery-one')
  expect(await screen.findByText('Cement bags')).toBeVisible()
  expect(screen.getByText('8 bag')).toBeVisible()
  expect(screen.queryByText('Removed load')).not.toBeInTheDocument()
  expect(screen.queryByText(/₱/)).not.toBeInTheDocument()
})

test('staff submit delivery proof and an older automatic read cannot restore the delivery form', async () => {
  let completeRead!: (value: OrderDetail) => void
  const oldRead = new Promise<OrderDetail>(resolve => { completeRead = resolve })
  vi.mocked(api.getOrder).mockResolvedValueOnce(order).mockReturnValueOnce(oldRead)
  const proof = { milestone: 'DELIVERED', receiverName: 'Site Foreman', handoverConfirmed: true, photoPath: '/vendor/orders/delivery-one/files/proof-photo', additionalPhotoPaths: [] }
  const delivered = { ...order, lockVersion: 4, states: [{ family: 'ORDER', state: 'DELIVERED' }], fulfillment: { ...order.fulfillment!, state: 'DELIVERED', nextAction: 'AWAIT_RECEIPT', proof, steps: [{ key: 'DELIVERED', label: 'Delivered', status: 'COMPLETE', proofRequired: true, proofRequirements: [], proof }] } } as OrderDetail
  vi.mocked(api.recordMilestone).mockResolvedValue(delivered)
  mount('/fulfillment/delivery-one')
  fireEvent.change(await screen.findByRole('textbox', { name: /Receiver name/ }), { target: { value: 'Site Foreman' } })
  const photo = new File(['synthetic delivery image'], 'delivery.jpg', { type: 'image/jpeg' })
  fireEvent.change(screen.getByLabelText('Take delivery photo'), { target: { files: [photo] } })
  fireEvent(window, new Event('materyalph:domain-refresh'))
  await waitFor(() => expect(api.getOrder).toHaveBeenCalledTimes(2))
  expect(screen.getByRole('textbox', { name: /Receiver name/ })).toHaveValue('Site Foreman')
  fireEvent.click(screen.getByRole('button', { name: 'Record delivery' }))
  await waitFor(() => expect(api.recordMilestone).toHaveBeenCalledWith('delivery-one', { milestone: 'DELIVERED', lockVersion: 3, receiverName: 'Site Foreman', file: photo }, expect.any(String)))
  expect(await screen.findByText('Site Foreman')).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Record delivery' })).not.toBeInTheDocument()
  await act(async () => { completeRead(order); await oldRead })
  expect(screen.getByText('Site Foreman')).toBeVisible()
  expect(screen.getByRole('button', { name: 'View proof photo' })).toBeVisible()
  expect(screen.queryByRole('textbox', { name: /Receiver name/ })).not.toBeInTheDocument()
})

test('an older acknowledgment response cannot overwrite a submitted Delivered milestone', async () => {
  let completeAcknowledgment!: (value: OrderDetail) => void
  const pendingAcknowledgment = new Promise<OrderDetail>(resolve => { completeAcknowledgment = resolve })
  vi.mocked(api.acknowledgeAssignment).mockReturnValueOnce(pendingAcknowledgment)
  const proof = { milestone: 'DELIVERED', receiverName: 'Site Foreman', handoverConfirmed: true, photoPath: '/vendor/orders/delivery-one/files/proof-photo', additionalPhotoPaths: [] }
  const delivered = { ...order, lockVersion: 4, states: [{ family: 'ORDER', state: 'DELIVERED' }], fulfillment: { ...order.fulfillment!, state: 'DELIVERED', nextAction: 'AWAIT_RECEIPT', proof, steps: [{ key: 'DELIVERED', label: 'Delivered', status: 'COMPLETE', proofRequired: true, proofRequirements: [], proof }] } } as OrderDetail
  vi.mocked(api.recordMilestone).mockResolvedValue(delivered)
  mount('/fulfillment/delivery-one')
  fireEvent.click(await screen.findByRole('button', { name: 'Acknowledge assignment' }))
  fireEvent.change(screen.getByRole('textbox', { name: /Receiver name/ }), { target: { value: 'Site Foreman' } })
  fireEvent.change(screen.getByLabelText('Take delivery photo'), { target: { files: [new File(['synthetic image'], 'delivery.jpg', { type: 'image/jpeg' })] } })
  fireEvent.click(screen.getByRole('button', { name: 'Record delivery' }))
  expect(await screen.findByText('Site Foreman')).toBeVisible()
  await act(async () => {
    completeAcknowledgment({ ...order, fulfillment: { ...order.fulfillment!, assignment: { ...order.fulfillment!.assignment!, acknowledgedAt: new Date() } } })
    await pendingAcknowledgment
  })
  expect(screen.getByText('Site Foreman')).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Record delivery' })).not.toBeInTheDocument()
})

test('route geometry decodes actual provider points and rejects incomplete geometry', () => {
  expect(decodeDeliveryPolyline('_p~iF~ps|U_ulLnnqC_mqNvxq`@')).toEqual([{ lat: 38.5, lng: -120.2 }, { lat: 40.7, lng: -120.95 }, { lat: 43.252, lng: -126.453 }])
  expect(() => decodeDeliveryPolyline('_')).toThrow('Invalid route geometry')
})
