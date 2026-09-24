import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import { VendorAddressMapSelector } from './VendorAddressMapSelector'

afterEach(() => { vi.unstubAllEnvs(); vi.unstubAllGlobals(); vi.useRealTimers() })

test('shows a useful unavailable state without a browser key', () => {
  vi.stubEnv('VITE_GOOGLE_MAPS_BROWSER_KEY', '')
  render(<VendorAddressMapSelector />)
  expect(screen.getByRole('status')).toHaveTextContent('Interactive map is unavailable')
  expect(screen.getByRole('button', { name: 'Retry map' })).toBeVisible()
})

test('keeps Google-owned DOM and updates the existing map when coordinates change', async () => {
  vi.stubEnv('VITE_GOOGLE_MAPS_BROWSER_KEY', 'test-browser-key')
  const setCenter = vi.fn()
  const setPosition = vi.fn()
  const handlers: Record<string, (event: { latLng: { lat: () => number; lng: () => number } }) => void> = {}
  const Map = vi.fn(function (element: HTMLElement) { element.appendChild(document.createElement('canvas')); return { setCenter, setZoom: vi.fn() } })
  const Marker = vi.fn(function () { return { setPosition, getPosition: () => ({ lat: () => 14.6, lng: () => 121 }) } })
  vi.stubGlobal('google', { maps: { Map, Marker, event: { addListener: (_target: unknown, name: string, handler: typeof handlers[string]) => { handlers[name] = handler; return { remove: vi.fn() } } } } })
  const select = vi.fn()
  const { rerender } = render(<VendorAddressMapSelector latitude={14.5} longitude={121} onCoordinatesChange={select} />)
  await waitFor(() => expect(screen.queryByText('Loading Google Maps…')).not.toBeInTheDocument())
  expect(screen.getByLabelText('Interactive business address map').querySelector('canvas')).not.toBeNull()
  rerender(<VendorAddressMapSelector latitude={14.7} longitude={121.1} onCoordinatesChange={select} />)
  expect(Map).toHaveBeenCalledTimes(1)
  expect(setCenter).toHaveBeenLastCalledWith({ lat: 14.7, lng: 121.1 })
  act(() => handlers.click?.({ latLng: { lat: () => 14.6, lng: () => 121 } }))
  expect(select).toHaveBeenCalledWith({ latitude: 14.6, longitude: 121 })
  act(() => { (window as Window & { gm_authFailure?: () => void }).gm_authFailure?.() })
  expect(screen.getByRole('status')).toHaveTextContent('authorization failed')
})

test('times out an API script that never initializes and offers retry', async () => {
  vi.useFakeTimers()
  vi.stubEnv('VITE_GOOGLE_MAPS_BROWSER_KEY', 'test-browser-key')
  vi.stubGlobal('google', undefined)
  render(<VendorAddressMapSelector />)
  await act(async () => { await vi.advanceTimersByTimeAsync(15001) })
  expect(screen.getByRole('status')).toHaveTextContent('Interactive map is unavailable')
  fireEvent.click(screen.getByRole('button', { name: 'Retry map' }))
  expect(screen.getByRole('status')).toHaveTextContent('Loading Google Maps')
  await act(async () => { await vi.advanceTimersByTimeAsync(15001) })
})
