import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { beforeEach, expect, test, vi } from 'vitest'
import { OrderLocationPanel } from './OrderLocationPanel'
import * as orders from '../lib/orders-api'
import type { OrderDetail } from '../lib/orders-api'

vi.mock('../lib/orders-api', async original => ({ ...await original<typeof import('../lib/orders-api')>(), getOrderRoute: vi.fn(), readableOrderError: vi.fn().mockResolvedValue('Route provider unavailable.') }))
const store = { latitude: 14.6, longitude: 121.1, label: 'Registered store address' }
const dropOff = { latitude: 14.62, longitude: 121.12, label: 'North gate drop-off address' }
const route = { origin: store, destination: dropOff, encodedPolyline: '', distanceMeters: 4200, durationSeconds: 660, durationBasis: 'TRAFFIC_AWARE', computedAt: new Date('2026-11-06T01:00:00Z') }
function order(overrides: Partial<OrderDetail> = {}): OrderDetail {
  return { id: 'order-map-1', fulfillmentMethod: 'DELIVERY', locationMap: { store, destination: dropOff },
    destination: { type: 'DELIVERY', heavyVehicleRestriction: 'YES', intended: { label: 'Project site', formattedAddress: 'Intended construction site' }, alternateDropOff: { label: 'North gate', formattedAddress: dropOff.label }, accessInstructions: 'Unload beside the gate.' }, ...overrides } as OrderDetail
}
beforeEach(() => { vi.clearAllMocks(); vi.mocked(orders.getOrderRoute).mockResolvedValue(route) })

test('delivery keeps the actual drop-off separate from the intended site and opens the actual route', async () => {
  render(<OrderLocationPanel order={order()} />)
  expect(await screen.findByText('4.2 km · 11 min estimated drive')).toBeVisible()
  expect(screen.getByText('Actual vehicle drop-off (heavy-vehicle restriction)')).toBeVisible()
  expect(screen.getByText(dropOff.label)).toBeVisible()
  expect(screen.getByText('Intended construction site')).toBeVisible()
  expect(screen.getByText('Unload beside the gate.')).toBeVisible()
  expect(screen.getByRole('link', { name: 'Open directions' })).toHaveAttribute('href', expect.stringContaining('destination=14.62%2C121.12'))
})

test('pickup opens the store and makes no delivery route request', () => {
  render(<OrderLocationPanel order={order({ fulfillmentMethod: 'PICKUP', locationMap: { store, destination: null }, destination: { type: 'PICKUP', storeAddress: store.label } })} />)
  expect(screen.getByText('Pickup at your store')).toBeVisible()
  expect(screen.queryByText('Actual vehicle drop-off')).not.toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Open in Google Maps' })).toHaveAttribute('href', expect.stringContaining('query=14.6%2C121.1'))
  expect(orders.getOrderRoute).not.toHaveBeenCalled()
})

test('route failure retains addresses and navigation and retries the driving estimate', async () => {
  vi.mocked(orders.getOrderRoute).mockRejectedValueOnce(new Error('Offline'))
  render(<OrderLocationPanel order={order()} />)
  fireEvent.click(await screen.findByRole('button', { name: 'Retry route' }))
  expect(screen.getByText(dropOff.label)).toBeVisible()
  expect(screen.getByRole('link', { name: 'Open directions' })).toBeVisible()
  expect(await screen.findByText('4.2 km · 11 min estimated drive')).toBeVisible()
})

test('a response from the previously opened order cannot replace the current route', async () => {
  let complete!: (value: typeof route) => void
  vi.mocked(orders.getOrderRoute).mockImplementationOnce(() => new Promise(resolve => { complete = resolve }))
  const { rerender } = render(<OrderLocationPanel order={order()} />)
  rerender(<OrderLocationPanel order={order({ id: 'order-map-2' })} />)
  expect(await screen.findByText('4.2 km · 11 min estimated drive')).toBeVisible()
  await act(async () => { complete({ ...route, distanceMeters: 99000 }) })
  await waitFor(() => expect(screen.queryByText(/99.0 km/)).not.toBeInTheDocument())
})
