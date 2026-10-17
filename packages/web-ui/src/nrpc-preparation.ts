import type { OrderLine } from '@materyalph/api-client-ts'
import { materialPayablePreview, materialQuantity } from './material-amounts'

export type NrpcPreparedMaterial = { id: string; name: string; detail?: string; payableCentavos: number | null }
export type NrpcPreparationValue = { reason: string; allocations: Record<string, number | null> }
export type NrpcReasonLimits = { min: number; max: number }

/** Validate editable principals without rounding invalid input or adding NRPC to the order total. */
export function nrpcPreparationAssessment(materials: NrpcPreparedMaterial[], value: NrpcPreparationValue, reasonLimits: NrpcReasonLimits) {
  const lineErrors: Record<string, string> = {}
  const reason = value.reason.trim()
  const reasonError = reason.length < reasonLimits.min ? `Describe the irreversible preparation in at least ${reasonLimits.min} characters.` : reason.length > reasonLimits.max ? `Keep the reason within ${reasonLimits.max} characters.` : null
  let total = 0n
  let eligible = 0n
  let completeAmounts = true
  for (const [id, amount] of Object.entries(value.allocations)) {
    const material = materials.find(line => line.id === id)
    if (!material) lineErrors[id] = 'Remove this material; it is no longer in the order or quotation.'
    else if (material.payableCentavos === null || !Number.isSafeInteger(material.payableCentavos) || material.payableCentavos < 0) lineErrors[id] = 'Complete the quantities, prices and discount to calculate this material’s payable value.'
    else {
      eligible += BigInt(material.payableCentavos)
      if (material.payableCentavos === 0) lineErrors[id] = 'This material has no payable value. Remove it from the prepared materials.'
      else if (amount !== null && Number.isSafeInteger(amount) && amount > material.payableCentavos) lineErrors[id] = 'Preparation cost cannot exceed this material’s payable value.'
    }
    if (amount === null || !Number.isSafeInteger(amount) || amount <= 0) {
      lineErrors[id] ??= 'Enter a preparation cost above zero for this material.'
      completeAmounts = false
    } else total += BigInt(amount)
  }
  const inRange = total <= BigInt(Number.MAX_SAFE_INTEGER) && eligible <= BigInt(Number.MAX_SAFE_INTEGER)
  const allocationError = Object.keys(value.allocations).length === 0 ? 'Select the materials that require irreversible preparation.' : !inRange ? 'The amount exceeds the supported display range.' : null
  return { valid: !reasonError && !allocationError && Object.keys(lineErrors).length === 0, reasonError, allocationError, lineErrors, totalCentavos: completeAmounts && inRange ? Number(total) : null, eligibleSubtotalCentavos: inRange ? Number(eligible) : null }
}

/** Order confirmation reuses frozen volume tiers for its proposed quantities, matching OrderCommercial. */
export function orderNrpcMaterialPreview(lines: Pick<OrderLine, 'id' | 'requestedQuantity' | 'volumeTiers' | 'ordinaryUnitPriceCentavos' | 'unitPriceCentavos'>[], quantities: Record<string, string>, discountCentavos: number | null) {
  if (discountCentavos === null) return { valid: false as const, message: 'Enter a valid materials discount.' }
  return materialPayablePreview(orderMaterialAmountLines(lines, quantities), discountCentavos, true)
}

export function orderMaterialAmountLines(lines: Pick<OrderLine, 'id' | 'requestedQuantity' | 'volumeTiers' | 'ordinaryUnitPriceCentavos' | 'unitPriceCentavos'>[], quantities: Record<string, string>) {
  return lines.map(line => {
    const quantity = quantities[line.id] ?? line.requestedQuantity
    const scaled = materialQuantity(quantity)
    const tiers = line.volumeTiers.flatMap(tier => {
      const minimum = materialQuantity(tier.minimumQuantity)
      return minimum !== null && scaled !== null && scaled >= minimum ? [{ minimum, amount: tier.amountCentavos }] : []
    }).sort((a, b) => a.minimum > b.minimum ? -1 : a.minimum < b.minimum ? 1 : 0)
    return { id: line.id, quantity, unitPriceCentavos: tiers[0]?.amount ?? line.ordinaryUnitPriceCentavos ?? line.unitPriceCentavos }
  })
}
