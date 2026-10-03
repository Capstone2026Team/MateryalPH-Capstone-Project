import { act, fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import * as inventory from '../lib/inventory-api'
import type { FleetVehicle, FleetVehicleListMeta } from '../lib/inventory-api'
import * as onboarding from '../lib/onboarding-api'
import { VendorFleetPage } from './FleetPages'
import { watchConversation } from '../lib/messaging-api'

vi.mock('../lib/messaging-api', () => ({ watchConversation: vi.fn() }))

vi.mock('../lib/onboarding-api', async original => ({ ...await original<typeof import('../lib/onboarding-api')>(), getVendorOnboarding: vi.fn(), getVendorPrivateFileUrl: vi.fn() }))
vi.mock('../lib/inventory-api', async original => ({ ...await original<typeof import('../lib/inventory-api')>(), listFleet: vi.fn(), saveFleet: vi.fn(), uploadFleetImage: vi.fn(), fleetImageUrl: vi.fn() }))

function vehicle(overrides: Partial<FleetVehicle> = {}): FleetVehicle {
  return {
    id: 'vehicle-1', lockVersion: 3, configurationVersion: 2, vehicleCategory: 'TRUCK', vehicleType: 'BOX_TRUCK', customTypeName: null, name: 'Box truck', brand: 'Isuzu', imageFileId: 'image-1',
    numberAvailable: 2, capacityKg: 1000, cargoLengthM: 4, cargoWidthM: 2, cargoHeightM: 2, mixerCapacityM3: null, heavyClassification: 'HEAVY', active: true, available: true,
    rateVersion: 1, baseFeeCentavos: 50000, perKmCentavos: 2500, maximumDistanceKm: 40, eligibility: { eligible: true, reasons: [] }, updatedAt: null, ...overrides,
  }
}
const meta: FleetVehicleListMeta = { scope: 'ORGANIZATION', summary: { configurations: 2, totalVehicles: 4, activeVehicles: 4, availableVehicles: 2, outForDeliveryVehicleAssignments: 1, outForDeliveryOrders: 1 }, delivery: { fulfillmentMethod: 'BOTH', deliveryEnabled: true, serviceRadiusKm: 50 }, permissions: { canManage: true }, limits: { maxVehicles: 50 } }

function snapshot(permissions: string[]): Awaited<ReturnType<typeof onboarding.getVendorOnboarding>> {
  return ({ stepCompletion: [], lockVersion: 1, requirements: [], drafts: [], organization: { store_name: 'Test Supply' }, welcomeRequired: false, permissions, verification: {}, setup: { status: 'COMPLETED' }, activation: { status: 'ACTIVE', marketplaceDiscoverabilityStatus: 'DISCOVERABLE', readiness: { ready: true, blockers: [], status: 'READY', ruleVersion: 'test' } }, sections: {} }) as Awaited<ReturnType<typeof onboarding.getVendorOnboarding>>
}

function error(status: number, body: unknown): ResponseError {
  return new ResponseError(new Response(JSON.stringify(body), { status, headers: { 'Content-Type': 'application/json' } }), 'failed')
}

beforeEach(() => {
  vi.clearAllMocks()
  vi.mocked(watchConversation).mockResolvedValue(vi.fn())
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.vehicles', 'vehicles.manage']))
  vi.mocked(onboarding.getVendorPrivateFileUrl).mockResolvedValue({ url: 'https://example.test/logo', expiresAt: new Date() })
  vi.mocked(inventory.listFleet).mockResolvedValue({ items: [vehicle(), vehicle({ id: 'vehicle-2', name: 'Spare van', vehicleCategory: 'VAN', vehicleType: 'MID_SIZE_CARGO_VAN', available: false, lockVersion: 1, eligibility: { eligible: false, reasons: ['VEHICLE_UNAVAILABLE'] } })], meta })
  vi.mocked(inventory.fleetImageUrl).mockResolvedValue('https://example.test/truck.png')
})

function open() {
  return render(<MemoryRouter initialEntries={['/vehicles']}><Routes><Route path="/vehicles" element={<VendorFleetPage />} /></Routes></MemoryRouter>)
}

test('managers land on the vehicle overview and open one editor at a time', async () => {
  open()
  expect(await screen.findByText(/Eligible for delivery proposals \(configuration v2, rates v1\)/)).toBeInTheDocument()
  expect(screen.getByText(/Not offered for new deliveries: Marked unavailable now/)).toBeInTheDocument()
  expect(screen.getByRole('article', { name: 'Box truck' })).toHaveTextContent('1,000 kg')
  expect(screen.queryByLabelText('Vehicle Category')).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Save vehicles' })).not.toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: 'Edit Box truck' }))
  expect(screen.getByRole('heading', { name: 'Edit Box truck' })).toHaveFocus()
  expect(screen.getByLabelText('Maximum Delivery Distance (km)')).toHaveValue(40)
  fireEvent.click(screen.getByRole('button', { name: 'Back to vehicles' }))
  expect(screen.getByRole('heading', { name: 'Your vehicles' })).toHaveFocus()
  fireEvent.click(screen.getByRole('button', { name: 'Edit Spare van' }))
  expect(screen.getByRole('checkbox', { name: 'Available now' })).not.toBeChecked()
  expect(screen.getAllByRole('combobox', { name: 'Vehicle Category' })).toHaveLength(1)
})

test('per-vehicle validation stays on its own vehicle and only changed vehicles are saved with their versions', async () => {
  vi.mocked(inventory.saveFleet).mockResolvedValue({ items: [vehicle({ lockVersion: 4, baseFeeCentavos: 60000 })], meta })
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Edit Spare van' }))
  fireEvent.change(screen.getByLabelText('Maximum Weight Capacity (kg)'), { target: { value: '0' } })
  fireEvent.click(screen.getByRole('button', { name: 'Back to vehicles' }))
  fireEvent.click(screen.getByRole('button', { name: 'Save vehicles' }))
  expect(await screen.findByText('Enter a positive capacity or dimension.')).toBeInTheDocument()
  expect(screen.getAllByText('Enter a positive capacity or dimension.')).toHaveLength(1)
  expect(inventory.saveFleet).not.toHaveBeenCalled()
  expect(screen.getByRole('heading', { name: 'Edit Spare van' })).toHaveFocus()
  fireEvent.change(screen.getByRole('spinbutton', { name: 'Maximum Weight Capacity (kg)' }), { target: { value: '800' } })
  fireEvent.click(screen.getByRole('button', { name: 'Back to vehicles' }))
  fireEvent.click(screen.getByRole('button', { name: 'Edit Box truck' }))
  fireEvent.change(screen.getByRole('textbox', { name: 'Base Fee (₱)' }), { target: { value: '600.00' } })
  fireEvent.click(screen.getByRole('button', { name: 'Save vehicles' }))
  await waitFor(() => expect(inventory.saveFleet).toHaveBeenCalledTimes(1))
  const sent = vi.mocked(inventory.saveFleet).mock.calls[0]![0]
  expect(sent).toHaveLength(2)
  expect(sent[0]).toMatchObject({ id: 'vehicle-1', lockVersion: 3, baseFeeCentavos: 60000, maximumDistanceKm: 40, active: true, available: true })
  expect(sent[1]).toMatchObject({ id: 'vehicle-2', lockVersion: 1, capacityKg: 800, available: false })
  expect(await screen.findByText(/accepted orders keep their confirmed vehicle, rate and address/)).toBeInTheDocument()
})

test('removing a saved vehicle asks for confirmation and sends only its removal', async () => {
  vi.mocked(inventory.saveFleet).mockResolvedValueOnce({ items: [vehicle()], meta })
  open()
  const removeButtons = await screen.findAllByRole('button', { name: /Remove vehicle/ })
  fireEvent.click(removeButtons[1]!)
  const dialog = await screen.findByRole('dialog', { name: 'Remove this vehicle?' })
  expect(within(dialog).getByText(/Accepted orders keep their confirmed vehicle/)).toBeInTheDocument()
  fireEvent.click(within(dialog).getByRole('button', { name: 'Remove vehicle' }))
  await waitFor(() => expect(screen.getAllByRole('button', { name: /Remove vehicle/ })).toHaveLength(1))
  fireEvent.click(screen.getByRole('button', { name: 'Save vehicles' }))
  await waitFor(() => expect(inventory.saveFleet).toHaveBeenCalledWith([{ id: 'vehicle-2', lockVersion: 1, removed: true }]))
})

test('server field errors appear on the vehicle they belong to', async () => {
  vi.mocked(inventory.saveFleet).mockRejectedValueOnce(error(422, { data: null, meta: {}, errors: [{ code: 'VALIDATION_FAILED', message: 'Review the highlighted vehicle fields and try again.', details: { 'vehicles.0.image_file_id': ['Upload a vehicle image that passed the safety check.'] } }] }))
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Edit Spare van' }))
  fireEvent.change(screen.getByLabelText('Base Fee (₱)'), { target: { value: '450.00' } })
  fireEvent.click(screen.getByRole('button', { name: 'Back to vehicles' }))
  fireEvent.click(screen.getByRole('button', { name: 'Save vehicles' }))
  await waitFor(() => expect(inventory.saveFleet).toHaveBeenCalledWith([expect.objectContaining({ id: 'vehicle-2', baseFeeCentavos: 45000 })]))
  const secondVehicle = await screen.findByRole('group', { name: /Vehicle 2/ })
  expect(await within(secondVehicle).findByText('Upload a vehicle image that passed the safety check.')).toBeInTheDocument()
  expect(screen.queryByRole('group', { name: /Vehicle 1/ })).not.toBeInTheDocument()
})

test('a stale vehicle save shows the conflict banner and reloads on request', async () => {
  vi.mocked(inventory.saveFleet).mockRejectedValueOnce(error(409, { data: null, meta: {}, errors: [{ code: 'STALE_VERSION', message: 'Changed', details: { vehicle_id: 'vehicle-1' } }] }))
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Edit Box truck' }))
  fireEvent.change(screen.getByLabelText('Base Fee (₱)'), { target: { value: '700.00' } })
  fireEvent.click(screen.getByRole('button', { name: 'Save vehicles' }))
  const banner = await screen.findByText('A vehicle changed while you were editing')
  fireEvent.click(within(banner.closest('[role="alert"]') as HTMLElement).getByRole('button', { name: 'Reload saved vehicles' }))
  await waitFor(() => expect(inventory.listFleet).toHaveBeenCalledTimes(2))
})

test('fulfillment staff see only the assigned-vehicle view and roles without Vehicles are told so', async () => {
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.vehicles', 'vehicles.view_assigned']))
  vi.mocked(inventory.listFleet).mockResolvedValue({ items: [], meta: { scope: 'ASSIGNED_ONLY', delivery: null, permissions: { canManage: false } } })
  const first = open()
  expect(await screen.findByRole('heading', { name: 'No assigned vehicle yet.' })).toBeInTheDocument()
  expect(screen.queryByRole('region', { name: 'Fleet overview' })).not.toBeInTheDocument()
  expect(screen.queryByRole('button', { name: 'Save vehicles' })).not.toBeInTheDocument()
  first.unmount()
  vi.mocked(onboarding.getVendorOnboarding).mockResolvedValue(snapshot(['portal.products', 'catalog.manage']))
  open()
  expect(await screen.findByText(/Your role does not include Vehicles/)).toBeInTheDocument()
})

test('fleet metrics update immediately on an invalidation while preserving unsaved edits', async () => {
  open()
  const panel = await screen.findByRole('region', { name: 'Fleet overview' })
  const metric = (label: string) => within(panel).getByText(label).closest('dt')!.parentElement!
  expect(within(metric('Total vehicles')).getByText('4')).toBeVisible()
  expect(within(metric('Active vehicles')).getByText('4')).toBeVisible()
  expect(within(metric('Available vehicles')).getByText('2')).toBeVisible()
  expect(within(metric('In use')).getByText('1')).toBeVisible()
  expect(panel).toHaveTextContent('1 order Out for Delivery')
  fireEvent.click(screen.getByRole('button', { name: 'Edit Box truck' }))
  fireEvent.change(screen.getByLabelText('Number of Vehicles'), { target: { value: '8' } })
  expect(within(metric('Total vehicles')).getByText('4')).toBeVisible()
  expect(screen.queryByRole('button', { name: 'Refresh fleet' })).not.toBeInTheDocument()
  vi.mocked(inventory.listFleet).mockResolvedValue({ items: [vehicle({ numberAvailable: 5 })], meta: { ...meta, summary: { ...meta.summary!, totalVehicles: 5, outForDeliveryVehicleAssignments: 3 } } })
  act(() => { vi.mocked(watchConversation).mock.calls[0]![1]() })
  await waitFor(() => expect(within(metric('In use')).getByText('3')).toBeVisible())
  expect(screen.getByLabelText('Number of Vehicles')).toHaveValue(8)
  fireEvent.click(screen.getByRole('button', { name: 'Discard changes' }))
  fireEvent.click(screen.getByRole('button', { name: 'Edit Box truck' }))
  expect(screen.getByLabelText('Number of Vehicles')).toHaveValue(5)
  expect(inventory.listFleet).toHaveBeenCalledTimes(2)
})

test('missing fleet summary is unavailable rather than a fabricated zero', async () => {
  const { summary: _summary, ...withoutSummary } = meta
  vi.mocked(inventory.listFleet).mockResolvedValue({ items: [], meta: withoutSummary })
  open()
  const panel = await screen.findByRole('region', { name: 'Fleet overview' })
  expect(within(panel).getByText(/Fleet summary is temporarily unavailable/)).toBeVisible()
  expect(within(panel).getAllByText('—')).toHaveLength(4)
})

test('automatic updates preserve the last snapshot on network errors but clear it when access is revoked', async () => {
  open()
  await screen.findByRole('region', { name: 'Fleet overview' })
  vi.mocked(inventory.listFleet).mockRejectedValueOnce(new Error('Offline'))
  act(() => { vi.mocked(watchConversation).mock.calls[0]![1]() })
  expect(await screen.findByText(/Automatic updates are temporarily unavailable/)).toBeVisible()
  expect(screen.getByRole('article', { name: 'Box truck' })).toBeVisible()
  vi.mocked(inventory.listFleet).mockRejectedValueOnce(error(403, { errors: [{ code: 'PERMISSION_DENIED' }] }))
  act(() => { vi.mocked(watchConversation).mock.calls[0]![1]() })
  expect(await screen.findByText(/Vehicle management access has changed/)).toBeVisible()
  expect(screen.queryByRole('region', { name: 'Fleet overview' })).not.toBeInTheDocument()
  expect(screen.queryByRole('article', { name: 'Box truck' })).not.toBeInTheDocument()
})

test('invalidations during a fetch are coalesced and socket listeners stop on unmount', async () => {
  const stop = vi.fn()
  vi.mocked(watchConversation).mockResolvedValue(stop)
  const view = open()
  await screen.findByRole('region', { name: 'Fleet overview' })
  let complete!: (value: Awaited<ReturnType<typeof inventory.listFleet>>) => void
  vi.mocked(inventory.listFleet).mockImplementationOnce(() => new Promise(resolve => { complete = resolve }))
  const changed = vi.mocked(watchConversation).mock.calls[0]![1]
  act(() => { changed(); changed(); changed() })
  expect(inventory.listFleet).toHaveBeenCalledTimes(2)
  await act(async () => { complete({ items: [vehicle()], meta }) })
  await waitFor(() => expect(inventory.listFleet).toHaveBeenCalledTimes(3))
  view.unmount()
  expect(stop).toHaveBeenCalledTimes(1)
})

test('adding from an empty overview retains draft edits and discarding returns to the overview', async () => {
  vi.mocked(inventory.listFleet).mockResolvedValue({ items: [], meta })
  open()
  expect(await screen.findByText('No vehicles yet.')).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Add vehicle' }))
  fireEvent.change(screen.getByLabelText('Vehicle Category'), { target: { value: 'MOTORCYCLE' } })
  fireEvent.change(screen.getByLabelText('Vehicle Name'), { target: { value: 'Small deliveries' } })
  fireEvent.click(screen.getByRole('button', { name: 'Back to vehicles' }))
  expect(screen.getByRole('article', { name: 'Small deliveries' })).toHaveTextContent('Not saved')
  fireEvent.click(screen.getByRole('button', { name: 'Edit Small deliveries' }))
  expect(screen.getByRole('textbox', { name: 'Vehicle Name' })).toHaveValue('Small deliveries')
  fireEvent.click(screen.getByRole('button', { name: 'Discard changes' }))
  expect(screen.getByText('No vehicles yet.')).toBeVisible()
  expect(screen.queryByRole('textbox', { name: 'Vehicle Name' })).not.toBeInTheDocument()
  expect(inventory.saveFleet).not.toHaveBeenCalled()
})
