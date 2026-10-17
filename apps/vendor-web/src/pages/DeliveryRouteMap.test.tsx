import { render, screen, waitFor } from '@testing-library/react'
import { beforeEach, expect, test, vi } from 'vitest'
import { DeliveryRouteMap } from '../../../../packages/web-ui/src/delivery-route-map'
import { loadGoogleMaps } from '../../../../packages/web-ui/src/google-maps'

vi.mock('../../../../packages/web-ui/src/google-maps', () => ({ loadGoogleMaps: vi.fn() }))
const origin = { latitude: 38.5, longitude: -120.2, label: 'Registered store' }
const destination = { latitude: 43.252, longitude: -126.453, label: 'Confirmed drop-off' }
beforeEach(() => vi.clearAllMocks())

test('the interactive map uses the provider route and keeps an accessible address alternative', async () => {
  const remove = vi.fn(), clear = vi.fn(), fitBounds = vi.fn(), extend = vi.fn()
  const polyline = vi.fn(function () { return { setMap: remove } })
  vi.mocked(loadGoogleMaps).mockResolvedValue({ maps: {
    Map: vi.fn(function () { return { fitBounds } }), Marker: vi.fn(function () { return { setMap: remove } }),
    Polyline: polyline, LatLngBounds: vi.fn(function () { return { extend } }), event: { clearInstanceListeners: clear },
  } })
  const { unmount } = render(<DeliveryRouteMap origin={origin} destination={destination} encodedPolyline="_p~iF~ps|U_ulLnnqC_mqNvxq`@" browserKey="fixture" />)
  await waitFor(() => expect(polyline).toHaveBeenCalledWith(expect.objectContaining({ path: [{ lat: 38.5, lng: -120.2 }, { lat: 40.7, lng: -120.95 }, { lat: 43.252, lng: -126.453 }] })))
  expect(screen.getByRole('region', { name: 'Delivery route map' })).toBeVisible()
  expect(screen.getByText('Registered store')).toBeVisible()
  expect(screen.getByText('Confirmed drop-off', { selector: 'dd' })).toBeVisible()
  expect(fitBounds).toHaveBeenCalled()
  unmount()
  expect(remove).toHaveBeenCalledTimes(3)
  expect(clear).toHaveBeenCalledTimes(1)
})

test('a map-provider failure retains readable store and destination addresses', async () => {
  vi.mocked(loadGoogleMaps).mockRejectedValue(new Error('Provider unavailable'))
  render(<DeliveryRouteMap origin={origin} destination={destination} encodedPolyline="" browserKey="fixture" />)
  expect(await screen.findByText(/The map could not load/)).toBeVisible()
  expect(screen.getByText('Registered store')).toBeVisible()
  expect(screen.getByText('Confirmed drop-off', { selector: 'dd' })).toBeVisible()
})
