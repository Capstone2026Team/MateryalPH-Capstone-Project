import type { ChatDraftContent } from '@materyalph/api-client-ts'
import { parsePesoInput } from './money-input'
import { materialPayablePreview } from './material-amounts'

type Preview = { valid: false; message: string } | {
  valid: true
  scope: 'MATERIALS' | 'DELIVERY'
  materialsGross: number
  deliveryGross: number
  basis: number
  deduction: number
  materialsPayable: number
  deliveryPayable: number
  total: number
  linePayableCentavos: Record<string, number>
}

/** Advisory draft totals follow FIN-02 half-up rounding without floating-point money arithmetic. */
export function quotationDiscountPreview(draft: Pick<ChatDraftContent, 'lines' | 'discount' | 'vendorDiscountCentavos' | 'fulfillmentMethod' | 'delivery'>): Preview {
  const invalid = (message: string): Preview => ({ valid: false, message })
  if (!draft.lines.length) return invalid('Add materials to see the deduction and total.')
  if (draft.lines.some(line => line.unitPriceCentavos > 100000000000)) return invalid('Enter valid material quantities and unit prices.')
  const lines = draft.lines.map(line => ({ id: line.variantId, quantity: line.quantity, unitPriceCentavos: line.unitPriceCentavos }))
  const gross = materialPayablePreview(lines, 0)
  if (!gross.valid) return gross
  const materials = BigInt(gross.grossCentavos)
  const rawDelivery = draft.fulfillmentMethod === 'DELIVERY' ? draft.delivery?.final_fee_centavos ?? 0 : 0
  if (typeof rawDelivery !== 'number' || !Number.isSafeInteger(rawDelivery) || rawDelivery < 0) return invalid('Enter a valid delivery fee.')
  const delivery = BigInt(rawDelivery)
  const scope = draft.discount?.scope ?? 'MATERIALS'
  if (scope === 'DELIVERY' && draft.fulfillmentMethod !== 'DELIVERY') return invalid('Delivery discounts require Site Delivery.')
  const basis = scope === 'MATERIALS' ? materials : delivery
  let deduction: bigint
  if (draft.discount) {
    const percent = draft.discount.percent.trim()
    const points = percent === '' ? 0 : parsePesoInput(percent)
    if (points === null || points > 10000) return invalid('Enter a discount from 0 to 100%, with up to 2 decimal places.')
    deduction = (basis * BigInt(points) + 5000n) / 10000n
  } else {
    const legacy = draft.vendorDiscountCentavos ?? 0
    if (!Number.isSafeInteger(legacy) || legacy < 0) return invalid('Enter a valid discount.')
    deduction = BigInt(legacy)
  }
  if (scope === 'MATERIALS' && deduction >= materials) return invalid('The materials discount must leave a positive subtotal.')
  const materialsPayable = materials - (scope === 'MATERIALS' ? deduction : 0n)
  const deliveryPayable = delivery - (scope === 'DELIVERY' ? deduction : 0n)
  const total = materialsPayable + deliveryPayable
  if (materials + delivery > BigInt(Number.MAX_SAFE_INTEGER)) return invalid('The amount exceeds the supported display range.')
  const payable = scope === 'MATERIALS' ? materialPayablePreview(lines, Number(deduction)) : gross
  if (!payable.valid) return payable
  return { valid: true, scope, materialsGross: Number(materials), deliveryGross: rawDelivery, basis: Number(basis), deduction: Number(deduction), materialsPayable: Number(materialsPayable), deliveryPayable: Number(deliveryPayable), total: Number(total), linePayableCentavos: payable.linePayableCentavos }
}
