/**
 * The disclosed delivery formula the server enforces on confirmation (delivery-advisory.v5): the per-trip
 * fee for every trip, plus a mixer's mobilization fee once per truck (PER_TRUCK) or once per trip (PER_TRIP),
 * as the Vendor configured it. The server rejects any other total with DELIVERY_FEE_CHANGED.
 */
export type MobilizationBasis = 'PER_TRUCK' | 'PER_TRIP'

export type DeliveryFeeChoice = {
  perTrip: number
  trips: number
  numberOfVehicles: number
  mobilizationFee?: number
  mobilizationBasis?: string | null
}

export function mobilizationTotal(choice: DeliveryFeeChoice): number {
  const fee = choice.mobilizationFee ?? 0
  if (fee <= 0) return 0
  if (choice.mobilizationBasis === 'PER_TRIP') return fee * choice.trips
  if (choice.mobilizationBasis === 'PER_TRUCK') return fee * choice.numberOfVehicles
  return 0
}

export function deliveryChoiceFee(choice: DeliveryFeeChoice): number {
  return choice.perTrip * choice.trips + mobilizationTotal(choice)
}

export function mobilizationLabel(basis: string | null | undefined): string {
  return basis === 'PER_TRIP' ? 'per trip' : basis === 'PER_TRUCK' ? 'per truck' : ''
}
