import { useState } from 'react'
import { DeliveryVehicles, emptyDeliveryVehicle, type DeliveryVehicleDraft } from '@materyalph/web-ui'
import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { expect, test, vi } from 'vitest'

test('vehicle image previews immediately, retains failed upload for retry, and calculator rounds per trip', async () => {
  const create = vi.fn(() => 'blob:vehicle-preview')
  Object.defineProperty(URL, 'createObjectURL', { configurable: true, value: create })
  Object.defineProperty(URL, 'revokeObjectURL', { configurable: true, value: vi.fn() })
  const upload = vi.fn().mockRejectedValueOnce(new Error('Upload unavailable')).mockResolvedValue('image-id')
  const resolve = vi.fn().mockResolvedValue('blob:saved-image')
  const pending = vi.fn()
  function Editor() {
    const [vehicles, setVehicles] = useState([{ ...emptyDeliveryVehicle(), category: 'TRUCK', type: 'FLATBED_TRUCK', baseFee: '500', perKm: '25.50' }])
    return <DeliveryVehicles vehicles={vehicles} onChange={setVehicles} uploadImage={upload} resolveImage={resolve} coverageKm={50} onImagePending={pending} />
  }
  render(<Editor />)
  expect(screen.queryByLabelText('Available for delivery')).not.toBeInTheDocument()
  expect(screen.queryByText(/Configured delivery coverage/)).not.toBeInTheDocument()
  fireEvent.change(screen.getByLabelText('Vehicle Image'), { target: { files: [new File(['image'], 'truck.png', { type: 'image/png' })] } })
  expect(screen.getByRole('img', { name: 'Vehicle image preview' })).toHaveAttribute('src', 'blob:vehicle-preview')
  await screen.findByText('Upload unavailable')
  fireEvent.click(screen.getByRole('button', { name: 'Retry vehicle image' }))
  await waitFor(() => expect(resolve).toHaveBeenCalledWith('image-id'))
  expect(pending).toHaveBeenLastCalledWith(expect.any(String), false)
  fireEvent.change(screen.getByRole('spinbutton', { name: 'Sample delivery distance (km)' }), { target: { value: '10' } })
  fireEvent.change(screen.getByRole('spinbutton', { name: 'Total vehicle trips' }), { target: { value: '2' } })
  expect(screen.getByText(/Estimated delivery charge/)).toHaveTextContent('1,510.00')
  fireEvent.change(screen.getByRole('textbox', { name: 'Base Fee (₱)' }), { target: { value: '0' } })
  fireEvent.change(screen.getByRole('textbox', { name: 'Per-Kilometer Rate (₱/km)' }), { target: { value: '0.01' } })
  fireEvent.change(screen.getByRole('spinbutton', { name: 'Sample delivery distance (km)' }), { target: { value: '0.5' } })
  expect(screen.getByText(/Estimated delivery charge/)).toHaveTextContent('0.02')
  fireEvent.change(screen.getByRole('spinbutton', { name: 'Total vehicle trips' }), { target: { value: '0' } })
  expect(screen.queryByText(/Estimated delivery charge/)).not.toBeInTheDocument()
})

test('removing a saved vehicle retains its ID as an inactive save record', () => {
  let saved: DeliveryVehicleDraft[] = [{ ...emptyDeliveryVehicle(), id: 'saved-vehicle', name: 'Existing truck' }]
  function Editor() {
    const [vehicles, setVehicles] = useState(saved)
    return <DeliveryVehicles vehicles={vehicles} onChange={next => { saved = next; setVehicles(next) }} uploadImage={async () => 'image-id'} resolveImage={async () => ''} coverageKm={50} />
  }
  render(<Editor />)
  fireEvent.click(screen.getByRole('button', { name: 'Remove vehicle 1' }))
  expect(saved).toEqual([expect.objectContaining({ id: 'saved-vehicle', active: false })])
  expect(screen.queryByRole('button', { name: 'Remove vehicle 1' })).not.toBeInTheDocument()
})
