import { act, cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import type { ChatDraftContent, ChatQuotation } from '@materyalph/api-client-ts'
import { ChatDraftContentToJSON, DeliveryPlanFromJSON } from '@materyalph/api-client-ts'
import { chatApi } from '../lib/messaging-api'
import { QuotationDraftEditor } from './ConversationThread'

vi.mock('../lib/messaging-api', async original => ({
  ...await original<typeof import('../lib/messaging-api')>(),
  chatApi: { draft: vi.fn(), publish: vi.fn(), quotationLocation: vi.fn(), quotationDelivery: vi.fn() },
  readableChatError: async () => 'Unable to save. Please retry.',
}))

const draft: ChatDraftContent = { lines: [{ variantId: 'variant', quantity: '2', unitPriceCentavos: 10000 }], fulfillmentMethod: 'PICKUP', fulfillmentDate: '2099-01-01', deadlineHours: 24 }
const quotation: ChatQuotation = { id: 'quote', lockVersion: 1, state: 'DRAFT', canDraft: true, canPublish: true, draft: ChatDraftContentToJSON(draft) }
const props = () => ({ open: true, conversationId: 'conversation', quotation, role: 'PUBLISHER', onSaved: vi.fn(async () => {}), onClose: vi.fn() })

beforeEach(() => {
  vi.mocked(chatApi.draft).mockReset().mockImplementation(async (_id, version) => ({ quotation: { ...quotation, lockVersion: version + 1 }, versions: [], hasMore: false }))
  vi.mocked(chatApi.publish).mockReset().mockResolvedValue({ data: { versions: [], hasMore: false }, meta: {}, errors: [] })
  vi.mocked(chatApi.quotationLocation).mockReset().mockResolvedValue({ id: 'searched-address', formattedAddress: 'Confirmed site, Quezon City' })
  vi.mocked(chatApi.quotationDelivery).mockReset().mockResolvedValue(DeliveryPlanFromJSON({ advisory: true, status: 'CANDIDATES_AVAILABLE', reason: 'Available', route: { distance_meters: 4200, duration_seconds: 600, source: 'GOOGLE_ROUTES', basis: 'ROAD' }, endpoint: { kind: 'INTENDED_LOCATION', heavy_vehicle_restriction: 'NO', intended: null, alternate_drop_off: null }, groups: [{ key: 'variant', label: 'Blocks', status: 'CANDIDATES_AVAILABLE', candidates: [{ vehicle_id: 'truck', name: 'Box truck', number_of_vehicles: 1, total_vehicle_trips: 1, estimated_charge_centavos: 60500, per_trip_centavos: 60500 }], manual_review_reasons: [] }], eligible_vehicles: [{ vehicle_id: 'truck', name: 'Box truck', heavy_classification: 'HEAVY', number_available: 2, per_trip_centavos: 60500 }], fee_formula: { calculation_version: 'test', rounding: 'HALF_UP', final_fee_rule: 'FORMULA' }, notice: 'Review before publication.' }))
  vi.spyOn(window, 'confirm').mockReturnValue(true)
})
afterEach(() => { cleanup(); vi.restoreAllMocks() })

test('autosaves the optional message without a Save draft button', async () => {
  render(<QuotationDraftEditor {...props()} />)
  expect(screen.queryByRole('button', { name: 'Save draft' })).not.toBeInTheDocument()
  fireEvent.change(screen.getByRole('textbox', { name: /Message to Buyer/ }), { target: { value: '  A discount is included.  ' } })
  await waitFor(() => expect(chatApi.draft).toHaveBeenCalledWith('conversation', 1, expect.objectContaining({ message: 'A discount is included.' })))
  expect(await screen.findByText('All changes saved')).toBeInTheDocument()
})

test('publish flushes the newest edit and closes only after publication succeeds', async () => {
  const options = props()
  render(<QuotationDraftEditor {...options} />)
  fireEvent.change(screen.getByRole('textbox', { name: /Message to Buyer/ }), { target: { value: 'My final offer.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Publish quotation' }))
  await waitFor(() => expect(options.onClose).toHaveBeenCalledOnce())
  expect(chatApi.draft).toHaveBeenCalledWith('conversation', 1, expect.objectContaining({ message: 'My final offer.' }))
  expect(chatApi.publish).toHaveBeenCalledWith('conversation', 2, expect.any(String))
  expect(options.onSaved).toHaveBeenCalledOnce()
})

test('edits made during autosave are saved with the next lock version', async () => {
  let resolve!: () => void
  const gate = new Promise<void>(done => { resolve = done })
  vi.mocked(chatApi.draft).mockImplementationOnce(async () => { await gate; return { quotation: { ...quotation, lockVersion: 2 }, versions: [], hasMore: false } })
  render(<QuotationDraftEditor {...props()} />)
  const input = screen.getByRole('textbox', { name: /Message to Buyer/ })
  fireEvent.change(input, { target: { value: 'First edit' } })
  await waitFor(() => expect(chatApi.draft).toHaveBeenCalledTimes(1))
  fireEvent.change(input, { target: { value: 'Latest edit' } })
  await act(async () => resolve())
  await waitFor(() => expect(chatApi.draft).toHaveBeenCalledWith('conversation', 2, expect.objectContaining({ message: 'Latest edit' })))
  expect(input).toHaveValue('Latest edit')
})

test('failed saves keep the editor open and a retry preserves the message', async () => {
  vi.mocked(chatApi.draft).mockRejectedValueOnce(new Error('offline'))
  const options = props()
  render(<QuotationDraftEditor {...options} />)
  fireEvent.change(screen.getByRole('textbox', { name: /Message to Buyer/ }), { target: { value: 'Keep this offer' } })
  fireEvent.click(screen.getByRole('button', { name: /^Close$/ }))
  expect(await screen.findByText('Unable to save. Please retry.')).toBeInTheDocument()
  expect(options.onClose).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Retry saving' }))
  expect(await screen.findByText('All changes saved')).toBeInTheDocument()
  expect(screen.getByRole('textbox', { name: /Message to Buyer/ })).toHaveValue('Keep this offer')
})

test('Customer Service autosaves drafts without a publish action', async () => {
  render(<QuotationDraftEditor {...props()} role="CUSTOMER_SERVICE" />)
  expect(screen.queryByRole('button', { name: 'Publish quotation' })).not.toBeInTheDocument()
  fireEvent.change(screen.getByRole('textbox', { name: /Message to Buyer/ }), { target: { value: 'For review' } })
  await waitFor(() => expect(chatApi.draft).toHaveBeenCalledTimes(1))
})

test('delivery draft searches a destination, records access and automatically calculates the fee and total', async () => {
  render(<QuotationDraftEditor {...props()} />)
  fireEvent.change(screen.getByRole('combobox', { name: 'Fulfillment' }), { target: { value: 'DELIVERY' } })
  expect(screen.getByText('Quotation order total: Awaiting delivery fee')).toBeInTheDocument()
  fireEvent.change(screen.getByRole('textbox', { name: 'Search delivery destination' }), { target: { value: 'Confirmed site, Quezon City' } })
  fireEvent.click(screen.getByRole('button', { name: 'Find destination' }))
  expect(await screen.findByText('Confirmed site, Quezon City')).toBeInTheDocument()
  fireEvent.change(screen.getByRole('combobox', { name: 'Does the Buyer know of a heavy-vehicle restriction?' }), { target: { value: 'NO' } })
  fireEvent.click(screen.getByRole('checkbox', { name: 'Drop-off access confirmed with Buyer' }))
  fireEvent.click(screen.getByRole('checkbox', { name: 'Heavy vehicle access confirmed' }))
  fireEvent.change(screen.getByRole('textbox', { name: 'Arrangement shown to the Buyer' }), { target: { value: 'One truck trip to the site.' } })
  expect(await screen.findByText('Quotation order total: ₱805.00')).toBeInTheDocument()
  expect(screen.getByRole('textbox', { name: 'Delivery fee before discount (₱)' })).toBeDisabled()
  await waitFor(() => expect(chatApi.draft).toHaveBeenLastCalledWith('conversation', expect.any(Number), expect.objectContaining({ destination: expect.objectContaining({ intendedAddressId: 'searched-address', heavyVehicleRestriction: 'NO' }), delivery: expect.objectContaining({ final_fee_centavos: 60500, vehicles: [{ vehicle_id: 'truck', group_key: 'variant', number_of_vehicles: 1, total_vehicle_trips: 1 }] }) })))
  expect(screen.getByRole('button', { name: 'Publish quotation' })).toBeEnabled()
  fireEvent.click(screen.getByRole('checkbox', { name: 'Enter delivery fee manually' }))
  fireEvent.change(screen.getByRole('textbox', { name: 'Delivery fee before discount (₱)' }), { target: { value: '700.00' } })
  expect(screen.getByText('Quotation order total: ₱900.00')).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Publish quotation' })).toBeDisabled()
  fireEvent.change(screen.getByRole('textbox', { name: /Reason for changing the system recommendation/ }), { target: { value: 'Includes the agreed unloading assistance.' } })
  expect(screen.getByRole('button', { name: 'Publish quotation' })).toBeEnabled()
})

test('shared Buyer location can be restored and a heavy restriction exposes the alternative endpoint', async () => {
  const deliveryDraft = { ...draft, fulfillmentMethod: 'DELIVERY' as const, destination: { intendedAddressId: 'other', intendedAddress: 'Previously searched address' } }
  render(<QuotationDraftEditor {...props()} quotation={{ ...quotation, draft: ChatDraftContentToJSON(deliveryDraft) }} reference={{ destination: { intended: { formatted_address: 'Buyer shared site' }, heavy_vehicle_restriction: 'NO' } }} />)
  fireEvent.click(screen.getByRole('button', { name: 'Use Buyer’s shared location' }))
  expect(screen.getByText('Buyer shared site')).toBeInTheDocument()
  fireEvent.change(screen.getByRole('combobox', { name: 'Does the Buyer know of a heavy-vehicle restriction?' }), { target: { value: 'YES' } })
  expect(screen.getByRole('textbox', { name: 'Search alternative vehicle drop-off' })).toBeInTheDocument()
  expect(screen.getByRole('textbox', { name: 'Access & unloading instructions (required)' })).toBeInTheDocument()
})

test('unavailable delivery route keeps publication disabled while allowing the unfinished draft to save', async () => {
  vi.mocked(chatApi.quotationDelivery).mockRejectedValue(new Error('provider unavailable'))
  render(<QuotationDraftEditor {...props()} />)
  fireEvent.change(screen.getByRole('combobox', { name: 'Fulfillment' }), { target: { value: 'DELIVERY' } })
  expect(await screen.findByRole('button', { name: 'Retry delivery calculation' })).toBeInTheDocument()
  expect(screen.getByText('Quotation order total: Awaiting delivery fee')).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Publish quotation' })).toBeDisabled()
  await waitFor(() => expect(chatApi.draft).toHaveBeenCalled())
  expect(screen.getByText('All changes saved')).toBeInTheDocument()
})
