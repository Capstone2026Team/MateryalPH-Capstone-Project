import { describe, expect, it } from 'vitest'
import { deliveryChoiceFee, mobilizationLabel, mobilizationTotal } from './delivery-fee'

describe('delivery fee formula', () => {
  const choice = { perTrip: 96800, trips: 5, numberOfVehicles: 2 }

  it('charges per-trip fees only when no mobilization is configured', () => {
    expect(deliveryChoiceFee(choice)).toBe(484000)
    expect(deliveryChoiceFee({ ...choice, mobilizationFee: 150000, mobilizationBasis: null })).toBe(484000)
  })

  it('adds mobilization once per truck or once per trip as the Vendor chose', () => {
    expect(mobilizationTotal({ ...choice, mobilizationFee: 150000, mobilizationBasis: 'PER_TRUCK' })).toBe(300000)
    expect(deliveryChoiceFee({ ...choice, mobilizationFee: 150000, mobilizationBasis: 'PER_TRIP' })).toBe(484000 + 750000)
    expect(mobilizationLabel('PER_TRUCK')).toBe('per truck')
  })
})
