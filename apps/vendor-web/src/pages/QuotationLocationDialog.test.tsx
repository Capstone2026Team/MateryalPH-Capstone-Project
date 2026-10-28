import { act, cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, expect, test, vi } from 'vitest'
import type { QuotationLocation } from '@materyalph/api-client-ts'
import { QuotationLocationDialog } from '../../../../packages/web-ui/src/quotation-location-dialog'

vi.mock('../../../../packages/web-ui/src/location-pin-map', () => ({
  LocationPinMap: ({ onCoordinatesChange }: { onCoordinatesChange: (point: { latitude: number; longitude: number }) => void }) => <button type="button" onClick={() => onCoordinatesChange({ latitude: 14.65, longitude: 121.02 })}>Choose test map pin</button>,
}))
afterEach(cleanup)
const location: QuotationLocation = { id: 'point', formattedAddress: 'Buyer-confirmed north gate', latitude: 14.65, longitude: 121.02 }
const props = () => ({ title: 'Alternate Buyer Location', resolve: vi.fn(async () => location), readableError: async () => 'Address unavailable.', onConfirm: vi.fn(), onClose: vi.fn() })

test('search stays inside the popup and applies only after explicit confirmation', async () => {
  const options = props()
  render(<QuotationLocationDialog {...options} />)
  expect(screen.getByRole('button', { name: 'Use this location' })).toBeDisabled()
  fireEvent.change(screen.getByRole('textbox', { name: 'Search Buyer location' }), { target: { value: 'North gate, Manila' } })
  fireEvent.click(screen.getByRole('button', { name: 'Search address' }))
  expect(await screen.findByText(location.formattedAddress)).toBeInTheDocument()
  expect(options.resolve).toHaveBeenCalledWith({ query: 'North gate, Manila' })
  expect(options.onConfirm).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Use this location' }))
  expect(options.onConfirm).toHaveBeenCalledWith(location)
})

test('selecting a map pin resolves the exact coordinates and cancellation applies nothing', async () => {
  const options = props()
  render(<QuotationLocationDialog {...options} />)
  fireEvent.click(screen.getByRole('button', { name: 'Choose test map pin' }))
  expect(await screen.findByText(location.formattedAddress)).toBeInTheDocument()
  expect(options.resolve).toHaveBeenCalledWith({ latitude: 14.65, longitude: 121.02 })
  fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
  expect(options.onClose).toHaveBeenCalledOnce()
  expect(options.onConfirm).not.toHaveBeenCalled()
})

test('an existing proposed address reopens at its saved point and lookup failure remains retryable', async () => {
  const options = props()
  options.resolve.mockRejectedValueOnce(new Error('offline'))
  render(<QuotationLocationDialog {...options} initialAddressId="saved-point" />)
  expect(await screen.findByText(/Address unavailable/)).toBeInTheDocument()
  expect(options.resolve).toHaveBeenCalledWith({ addressId: 'saved-point' })
  expect(screen.getByRole('button', { name: 'Use this location' })).toBeDisabled()
  fireEvent.click(screen.getByRole('button', { name: 'Choose test map pin' }))
  expect(await screen.findByText(location.formattedAddress)).toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Use this location' })).toBeEnabled()
})

test('a late search response cannot replace a newer pin or edited search', async () => {
  let finish!: (value: QuotationLocation) => void
  const options = props()
  options.resolve.mockImplementationOnce(() => new Promise<QuotationLocation>(resolve => { finish = resolve }))
  render(<QuotationLocationDialog {...options} />)
  fireEvent.change(screen.getByRole('textbox', { name: 'Search Buyer location' }), { target: { value: 'Old address' } })
  fireEvent.click(screen.getByRole('button', { name: 'Search address' }))
  fireEvent.click(screen.getByRole('button', { name: 'Choose test map pin' }))
  expect(await screen.findByText(location.formattedAddress)).toBeInTheDocument()
  await act(async () => finish({ ...location, formattedAddress: 'Stale result' }))
  expect(screen.queryByText('Stale result')).not.toBeInTheDocument()
  fireEvent.change(screen.getByRole('textbox', { name: 'Search Buyer location' }), { target: { value: 'Unresolved new address' } })
  await waitFor(() => expect(screen.getByRole('button', { name: 'Use this location' })).toBeDisabled())
})
