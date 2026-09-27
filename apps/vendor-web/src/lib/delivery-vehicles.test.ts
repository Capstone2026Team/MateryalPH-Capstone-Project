import { expect, test } from 'vitest'
import { emptyDeliveryVehicle } from '@materyalph/web-ui'
import { pesosToCentavos, vehiclePayload, vehicleErrors } from './delivery-vehicles'

test('peso inputs convert exactly into integer centavos and reject malformed amounts', () => {
  expect(pesosToCentavos('25.50')).toBe(2550)
  expect(pesosToCentavos('0.29')).toBe(29)
  expect(pesosToCentavos('500')).toBe(50000)
  for (const value of ['', '-1', '1.001', '1e3', 'Infinity', '10000000.01']) expect(pesosToCentavos(value)).toBeNull()
})
test('mixer serialization clears cargo dimensions and validates specialized capacity', () => {
  const vehicle = { ...emptyDeliveryVehicle(), category: 'TRUCK', type: 'CONCRETE_MIXER', name: 'Mixer', heavy: 'HEAVY', imageId: 'image', baseFee: '500.25', perKm: '20.10', count: '2', weight: '24000', mixer: '6', length: '4', width: '2', height: '2' }
  expect(vehicleErrors(vehicle)).toEqual({})
  expect(vehiclePayload(vehicle)).toMatchObject({ mixerCapacityM3: 6, cargoLengthM: null, cargoWidthM: null, cargoHeightM: null, baseFeeCentavos: 50025, perKmCentavos: 2010 })
  expect(vehicleErrors({ ...vehicle, mixer: '' })).toHaveProperty('mixer')
})
