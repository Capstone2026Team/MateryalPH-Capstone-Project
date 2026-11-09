import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { expect, test, vi } from 'vitest'
import { DeliveryVehicleCard } from '@materyalph/web-ui'

test('vehicle photos, capacity and status stay stable when a recommendation rerenders', async () => {
  const profile = { name: 'Mixer A', vehicleType: 'CONCRETE_MIXER', brand: 'Isuzu', imageFileId: 'photo', capacityKg: '14400', mixerCapacityM3: '6', heavyClassification: 'HEAVY' }
  const load = vi.fn().mockResolvedValue('https://example.test/mixer.png')
  const view = render(<DeliveryVehicleCard profile={profile} status="Recommended · Eligible" imageScope="fleet" loadImage={load} vehicles={1} trips={2} />)
  const photo = await screen.findByRole('img', { name: 'Mixer A vehicle photo' })
  expect(screen.getByText(/14,400 kg payload · 6 m³ mixer · Heavy vehicle/)).toBeVisible()
  expect(screen.getByText('Recommended · Eligible')).toBeVisible()
  expect(screen.getByText('1 vehicle · 2 trips')).toBeVisible()
  view.rerender(<DeliveryVehicleCard profile={{ ...profile }} status="Vendor confirmed" imageScope="fleet" loadImage={id => load(id)} vehicles={1} trips={2} />)
  expect(screen.getByRole('img', { name: 'Mixer A vehicle photo' })).toBe(photo)
  expect(load).toHaveBeenCalledTimes(1)
  fireEvent.error(photo)
  fireEvent.click(screen.getByRole('button', { name: 'Retry vehicle photo' }))
  await waitFor(() => expect(load).toHaveBeenCalledTimes(2))
})

test('historical records with no image retain the vehicle name and arrangement status', () => {
  render(<DeliveryVehicleCard name="Historical truck" status="Vendor confirmed" imageScope="order" />)
  expect(screen.getByText('Historical truck')).toBeVisible()
  expect(screen.getByLabelText('Vehicle photo not recorded')).toBeVisible()
})
