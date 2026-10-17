import { ChatDraftContentToJSON, VendorOrderConfirmRequestToJSON, type ChatDraftContent, type OrderLine, type VendorOrderConfirmRequest } from '@materyalph/api-client-ts'
import { expect, test } from 'vitest'
import { materialPayablePreview } from '../../../../packages/web-ui/src/material-amounts'
import { nrpcPreparationAssessment, orderNrpcMaterialPreview, type NrpcPreparedMaterial } from '../../../../packages/web-ui/src/nrpc-preparation'
import { quotationDiscountPreview } from '../../../../packages/web-ui/src/quotation-discount'
import { parsePesoInput } from '../../../../packages/web-ui/src/money-input'
import { quotationDraftForSave } from './quotation-draft'

const reason = 'Cut steel bars to the Buyer’s specified lengths.'
const materials: NrpcPreparedMaterial[] = [{ id: 'a', name: 'Steel bar', payableCentavos: 10000 }, { id: 'b', name: 'Timber', payableCentavos: 5000 }]
const limits = { min: 10, max: 1000 }
const quote: ChatDraftContent = { lines: [{ variantId: 'a', quantity: '4', unitPriceCentavos: 1700 }], fulfillmentMethod: 'PICKUP', paymentMethod: 'ONLINE', fulfillmentDate: '2026-10-20' }

test('NRPC sums prepared-line principals exactly, with only selected materials eligible', () => {
  expect(nrpcPreparationAssessment(materials, { reason, allocations: { a: 5000, b: 2500 } }, limits)).toMatchObject({ valid: true, totalCentavos: 7500, eligibleSubtotalCentavos: 15000 })
  expect(nrpcPreparationAssessment(materials, { reason, allocations: { b: 2500 } }, limits)).toMatchObject({ valid: true, totalCentavos: 2500, eligibleSubtotalCentavos: 5000 })
})

test('a full prepared-material allocation is permitted and changing its payable value preserves editable input', () => {
  const value = { reason, allocations: { a: 10000 } }
  expect(nrpcPreparationAssessment(materials, value, limits)).toMatchObject({ valid: true, totalCentavos: 10000 })
  expect(nrpcPreparationAssessment([{ ...materials[0]!, payableCentavos: 8000 }], value, limits).valid).toBe(false)
  expect(value.allocations.a).toBe(10000)
  expect(nrpcPreparationAssessment(materials, value, limits).valid).toBe(true)
})

test('unsafe aggregate costs are rejected without losing or rounding their line allocations', () => {
  const materials = [{ id: 'a', name: 'Steel', payableCentavos: Number.MAX_SAFE_INTEGER }, { id: 'b', name: 'Timber', payableCentavos: Number.MAX_SAFE_INTEGER }]
  expect(nrpcPreparationAssessment(materials, { reason, allocations: { a: Number.MAX_SAFE_INTEGER, b: 1 } }, limits)).toMatchObject({ valid: false, totalCentavos: null, eligibleSubtotalCentavos: null })
})

test('cleared or invalid amounts stay invalid rather than being treated as a zero cost', () => {
  for (const amount of [null, 0, -1, 0.5, Number.NaN, Number.MAX_SAFE_INTEGER + 1]) {
    const assessment = nrpcPreparationAssessment(materials, { reason, allocations: { a: amount } }, limits)
    expect(assessment.valid).toBe(false)
    expect(assessment.totalCentavos).toBeNull()
    expect(assessment.lineErrors.a).toBeTruthy()
  }
})

test('removed materials, missing payable values and over-allocation cannot be submitted', () => {
  expect(nrpcPreparationAssessment(materials, { reason, allocations: { removed: 500 } }, limits).valid).toBe(false)
  expect(nrpcPreparationAssessment([{ ...materials[0]!, payableCentavos: null }], { reason, allocations: { a: 500 } }, limits).valid).toBe(false)
  expect(nrpcPreparationAssessment([{ ...materials[0]!, payableCentavos: 0 }], { reason, allocations: { a: 500 } }, limits).valid).toBe(false)
  expect(nrpcPreparationAssessment(materials, { reason, allocations: { a: 10001 } }, limits).valid).toBe(false)
  expect(nrpcPreparationAssessment(materials, { reason, allocations: {} }, limits).allocationError).toBeTruthy()
})

test('preparation reasons retain each existing flow’s validation bounds', () => {
  const value = { reason: 'Cut', allocations: { a: 500 } }
  expect(nrpcPreparationAssessment(materials, value, { min: 3, max: 2000 }).valid).toBe(true)
  expect(nrpcPreparationAssessment(materials, value, limits).reasonError).toBeTruthy()
  expect(nrpcPreparationAssessment(materials, { ...value, reason: 'a'.repeat(1001) }, limits).valid).toBe(false)
})

test('discount allocation ties use ascending line IDs and preserve all centavos', () => {
  const result = materialPayablePreview([{ id: 'b', quantity: '1', unitPriceCentavos: 10 }, { id: 'a', quantity: '1', unitPriceCentavos: 10 }], 1)
  expect(result).toMatchObject({ valid: true, grossCentavos: 20, payableCentavos: 19, linePayableCentavos: { a: 9, b: 10 } })
  expect(nrpcPreparationAssessment([{ id: 'a', name: 'Steel', payableCentavos: 9 }], { reason, allocations: { a: 10 } }, limits).valid).toBe(false)
})

test('fractional quantities use half-up line rounding, and zero confirmed lines keep no NRPC value', () => {
  expect(materialPayablePreview([{ id: 'a', quantity: '1.0005', unitPriceCentavos: 1000 }, { id: 'b', quantity: '0', unitPriceCentavos: 10 }], 1, true)).toMatchObject({ valid: true, grossCentavos: 1001, payableCentavos: 1000, linePayableCentavos: { a: 1000, b: 0 } })
  expect(materialPayablePreview([{ id: 'a', quantity: '0', unitPriceCentavos: 1000 }], 0).valid).toBe(false)
  expect(materialPayablePreview([{ id: 'a', quantity: '9999999999', unitPriceCentavos: 100000000000 }], 0).valid).toBe(false)
})

test('order preparation limits reapply frozen volume tiers to the confirmed quantity', () => {
  const line: Pick<OrderLine, 'id' | 'requestedQuantity' | 'volumeTiers' | 'ordinaryUnitPriceCentavos' | 'unitPriceCentavos'> = {
    id: 'a', requestedQuantity: '20', unitPriceCentavos: 700, ordinaryUnitPriceCentavos: 1000,
    volumeTiers: [{ priceVersionId: 'tier20', minimumQuantity: '20', amountCentavos: 700 }, { priceVersionId: 'tier10', minimumQuantity: '10', amountCentavos: 800 }],
  }
  expect(orderNrpcMaterialPreview([line], { a: '12' }, 1000)).toMatchObject({ valid: true, linePayableCentavos: { a: 8600 } })
  expect(orderNrpcMaterialPreview([line], { a: '9' }, 1000)).toMatchObject({ valid: true, linePayableCentavos: { a: 8000 } })
  expect(orderNrpcMaterialPreview([line], { a: '' }, 0).valid).toBe(false)
  expect(orderNrpcMaterialPreview([line], { a: '12' }, null).valid).toBe(false)
})

test('materials discounts reduce NRPC eligibility while delivery discounts leave it unchanged', () => {
  expect(quotationDiscountPreview({ ...quote, discount: { scope: 'MATERIALS', percent: '20' } })).toMatchObject({ valid: true, linePayableCentavos: { a: 5440 }, total: 5440 })
  expect(quotationDiscountPreview({ ...quote, fulfillmentMethod: 'DELIVERY', delivery: { final_fee_centavos: 60500 }, discount: { scope: 'DELIVERY', percent: '20' } })).toMatchObject({ valid: true, linePayableCentavos: { a: 6800 }, total: 55200 })
})

test('the same peso preparation values serialize through the existing order and quotation contracts', () => {
  const amount = parsePesoInput('1,234.50')
  expect(amount).toBe(123450)
  const assessment = nrpcPreparationAssessment([{ id: 'a', name: 'Steel', payableCentavos: 200000 }], { reason, allocations: { a: amount } }, limits)
  expect(assessment.valid).toBe(true)
  const order: VendorOrderConfirmRequest = { lockVersion: 1, lines: [{ orderLineId: 'a', confirmedQuantity: '1' }], nrpc: { amountCentavos: assessment.totalCentavos!, reason, lines: [{ orderLineId: 'a', principalCentavos: amount! }] } }
  expect(VendorOrderConfirmRequestToJSON(order)).toMatchObject({ nrpc: { amount_centavos: 123450, reason, lines: [{ order_line_id: 'a', principal_centavos: 123450 }] } })
  expect(ChatDraftContentToJSON(quotationDraftForSave({ ...quote, nrpc: { amount_centavos: assessment.totalCentavos, reason, allocations: { a: amount } } }))).toMatchObject({ nrpc: { amount_centavos: 123450, reason, allocations: { a: 123450 } } })
})

test('NRPC designates part of the materials value and does not increase the quotation total', () => {
  const withNrpc = { ...quote, nrpc: { amount_centavos: 1000, reason, allocations: { a: 1000 } } }
  expect(quotationDiscountPreview(withNrpc)).toMatchObject({ valid: true, materialsPayable: 6800, total: 6800 })
  expect(quotationDiscountPreview(quote)).toMatchObject({ valid: true, total: 6800 })
})
