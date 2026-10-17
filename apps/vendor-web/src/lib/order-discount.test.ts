import { VendorOrderConfirmRequestToJSON, type ChatQuotationDiscount, type OrderLine } from '@materyalph/api-client-ts'
import { expect, test } from 'vitest'
import { orderDiscountForSave, orderDiscountPreview } from './order-discount'

const line: OrderLine = { id: 'a', lineNumber: 1, listingId: 'listing', listingVariantId: 'variant', displayName: 'Steel', variantLabel: null, brand: null, category: null, image: null, unitCode: 'PC', unitName: 'Piece', unitPrecision: 0, quantityStep: '1', requestedQuantity: '20', confirmedQuantity: null, unitPriceCentavos: 800, ordinaryUnitPriceCentavos: 1000, volumeTierApplied: true, volumeTiers: [{ priceVersionId: 'tier', minimumQuantity: '10', amountCentavos: 800 }], grossCentavos: 16000, discountCentavos: 0, lineTotalCentavos: 16000, includedVatCentavos: 0, taxCategory: 'NON_VAT', vatLabel: 'Non-VAT', change: null, priceVersionId: 'price' }

test('order materials discounts use confirmed quantities and the frozen volume price', () => {
  expect(orderDiscountPreview([line], { a: '12' }, { scope: 'MATERIALS', percent: '20' }, 'DELIVERY', 60500)).toMatchObject({ valid: true, basis: 9600, deduction: 1920, materialsPayable: 7680, deliveryPayable: 60500, total: 68180, linePayableCentavos: { a: 7680 } })
  expect(orderDiscountPreview([line], { a: '9' }, { scope: 'MATERIALS', percent: '20' }, 'PICKUP', 0)).toMatchObject({ valid: true, basis: 9000, deduction: 1800, total: 7200 })
})

test('delivery discounts preserve material and NRPC eligibility and allow a full fee waiver', () => {
  expect(orderDiscountPreview([line], { a: '12' }, { scope: 'DELIVERY', percent: '20' }, 'DELIVERY', 60500)).toMatchObject({ valid: true, deduction: 12100, materialsPayable: 9600, deliveryPayable: 48400, total: 58000, linePayableCentavos: { a: 9600 } })
  expect(orderDiscountPreview([line], { a: '12' }, { scope: 'DELIVERY', percent: '100' }, 'DELIVERY', 60500)).toMatchObject({ valid: true, deliveryPayable: 0, total: 9600 })
})

test('zero quantities are removed from pricing and incomplete amounts never produce an estimate', () => {
  expect(orderDiscountPreview([line, { ...line, id: 'b' }], { a: '1', b: '0.0000' }, { scope: 'MATERIALS', percent: '10' }, 'PICKUP', 0)).toMatchObject({ valid: true, materialsGross: 1000, linePayableCentavos: { a: 900 } })
  expect(orderDiscountPreview([line], { a: '' }, { scope: 'MATERIALS', percent: '10' }, 'PICKUP', 0).valid).toBe(false)
  expect(orderDiscountPreview([line], { a: '1' }, { scope: 'DELIVERY', percent: '10' }, 'PICKUP', 0).valid).toBe(false)
})

test('blank rates save zero while invalid precision and out-of-range values are rejected', () => {
  expect(orderDiscountForSave({ scope: 'MATERIALS', percent: '' })).toEqual({ scope: 'MATERIALS', percent: '0.00' })
  for (const percent of ['-1', '100.01', '1.001', '1e1']) expect(orderDiscountForSave({ scope: 'MATERIALS', percent })).toBeNull()
})

test('the generated confirmation request sends the percentage scope without a fixed discount', () => {
  const discount: ChatQuotationDiscount = { scope: 'DELIVERY', percent: '12.5' }
  const request = VendorOrderConfirmRequestToJSON({ lockVersion: 1, lines: [{ orderLineId: line.id, confirmedQuantity: '12' }], discount: orderDiscountForSave(discount)! })
  expect(request).toMatchObject({ discount: { scope: 'DELIVERY', percent: '12.50' } })
  expect(request).toHaveProperty('vendor_discount_centavos', undefined)
  expect(discount.percent).toBe('12.5')
})
