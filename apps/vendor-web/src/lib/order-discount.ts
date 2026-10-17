import type { ChatQuotationDiscount, OrderLine } from '@materyalph/api-client-ts'
import { orderMaterialAmountLines } from '../../../../packages/web-ui/src/nrpc-preparation'
import { quotationDiscountPreview } from '../../../../packages/web-ui/src/quotation-discount'
import { parsePesoInput, pesoInputFromCentavos } from '../../../../packages/web-ui/src/money-input'

export function orderDiscountPreview(lines: OrderLine[], quantities: Record<string, string>, discount: ChatQuotationDiscount, fulfillmentMethod: 'PICKUP' | 'DELIVERY', grossDeliveryCentavos: number) {
  return quotationDiscountPreview({
    lines: orderMaterialAmountLines(lines, quantities).filter(line => !/^0+(\.0+)?$/.test(line.quantity)).map(line => ({ variantId: line.id, quantity: line.quantity, unitPriceCentavos: line.unitPriceCentavos })),
    fulfillmentMethod, delivery: { final_fee_centavos: grossDeliveryCentavos }, discount,
  })
}

export function orderDiscountForSave(discount: ChatQuotationDiscount): ChatQuotationDiscount | null {
  const points = parsePesoInput(discount.percent.trim() || '0')
  return points === null || points > 10000 ? null : { ...discount, percent: pesoInputFromCentavos(points) }
}
