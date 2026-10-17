import type { DeliveryPlanGroup, DeliveryPlanVehicle } from '@materyalph/api-client-ts'

export function deliveryPlanVehicleOptions(group: DeliveryPlanGroup): DeliveryPlanVehicle[] {
  return group.status === 'MANUAL_REVIEW_REQUIRED' ? group.manualReviewVehicles ?? [] : group.candidates
}
