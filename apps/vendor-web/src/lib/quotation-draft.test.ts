import type { ChatDraftContent } from '@materyalph/api-client-ts'
import { ChatDraftContentFromJSON, ChatDraftContentToJSON } from '@materyalph/api-client-ts'
import { expect, test } from 'vitest'
import { quotationDraftForSave } from './quotation-draft'
import { parsePesoInput } from '../../../../packages/web-ui/src/money-input'
import { quotationDiscountPreview } from '../../../../packages/web-ui/src/quotation-discount'

const base: ChatDraftContent = { lines: [{ variantId: 'variant-1', quantity: '1', unitPriceCentavos: 28550 }], fulfillmentMethod: 'PICKUP', paymentMethod: 'ONLINE', fulfillmentDate: '2026-10-20' }

test('a Vendor draft never submits a payment preference for the Buyer', () => {
  expect(quotationDraftForSave({ ...base, paymentMethod: 'IN_STORE' })).not.toHaveProperty('paymentMethod')
  expect(JSON.stringify(ChatDraftContentToJSON(quotationDraftForSave(base)))).not.toContain('"payment_method"')
})

test('cleared optional details are omitted at save without changing unfinished editor input', () => {
  const draft = { ...base, lines: [{ ...base.lines[0]!, description: ' ', specifications: { thickness_mm: '', grade: '  Grade 40  ', note: 'plain text = accepted' } }] }
  const saved = quotationDraftForSave(draft)
  expect(saved.lines[0]).not.toHaveProperty('description')
  expect(saved.lines[0]?.specifications).toEqual({ grade: 'Grade 40', note: 'plain text = accepted' })
  expect(draft.lines[0]?.specifications).toEqual({ thickness_mm: '', grade: '  Grade 40  ', note: 'plain text = accepted' })
  expect(ChatDraftContentFromJSON(ChatDraftContentToJSON(saved))).toMatchObject(saved)
})

test('absent specifications keep the server product defaults while an explicitly cleared set stays empty', () => {
  expect(quotationDraftForSave(base).lines[0]).not.toHaveProperty('specifications')
  const saved = quotationDraftForSave({ ...base, lines: [{ ...base.lines[0]!, specifications: { grade: ' ' }, description: ' Steel bar ' }] })
  expect(saved.lines[0]).toMatchObject({ description: 'Steel bar', specifications: {} })
  expect(saved.lines[0]).toMatchObject(base.lines[0]!)
})

test('peso prices and discounts reach the generated quotation request as integer centavos', () => {
  const unitPrice = parsePesoInput('285.50')
  const discount = parsePesoInput('1,234.50')
  if (unitPrice === null || discount === null) throw new Error('Expected valid peso amounts')
  const draft = { ...base, vendorDiscountCentavos: discount, lines: [{ ...base.lines[0]!, quantity: '10', unitPriceCentavos: unitPrice }] }
  expect(ChatDraftContentToJSON(quotationDraftForSave(draft))).toMatchObject({
    vendor_discount_centavos: 123450,
    lines: [{ variant_id: 'variant-1', quantity: '10', unit_price_centavos: 28550 }],
  })
})

test('percentage drafts serialize exact percentages and replace the legacy fixed discount', () => {
  const draft: ChatDraftContent = { ...base, vendorDiscountCentavos: 20, discount: { scope: 'MATERIALS', percent: '10.5' } }
  const saved = quotationDraftForSave(draft)
  expect(saved).not.toHaveProperty('vendorDiscountCentavos')
  expect(saved.discount).toEqual({ scope: 'MATERIALS', percent: '10.50' })
  expect(ChatDraftContentFromJSON(ChatDraftContentToJSON(saved))).toMatchObject(saved)
  expect(ChatDraftContentToJSON(saved)).toMatchObject({ discount: { scope: 'MATERIALS', percent: '10.50' } })
  expect(draft.discount?.percent).toBe('10.5')
})

test('deleting a percentage keeps editor input empty and saves a zero discount', () => {
  const draft: ChatDraftContent = { ...base, discount: { scope: 'MATERIALS', percent: '' } }
  expect(quotationDiscountPreview(draft)).toMatchObject({ valid: true, deduction: 0, total: 28550 })
  expect(quotationDraftForSave(draft).discount?.percent).toBe('0.00')
  expect(draft.discount?.percent).toBe('')
})

test('materials discounts reduce only materials and the overall total', () => {
  expect(quotationDiscountPreview({ ...base, lines: [{ ...base.lines[0]!, quantity: '4', unitPriceCentavos: 1700 }], fulfillmentMethod: 'DELIVERY', delivery: { final_fee_centavos: 60500 }, discount: { scope: 'MATERIALS', percent: '20' } })).toMatchObject({ valid: true, basis: 6800, deduction: 1360, materialsPayable: 5440, deliveryPayable: 60500, total: 65940 })
})

test('delivery discounts use the gross fee and preserve materials prices', () => {
  expect(quotationDiscountPreview({ ...base, lines: [{ ...base.lines[0]!, quantity: '4', unitPriceCentavos: 1700 }], fulfillmentMethod: 'DELIVERY', delivery: { final_fee_centavos: 60500 }, discount: { scope: 'DELIVERY', percent: '20' } })).toMatchObject({ valid: true, basis: 60500, deduction: 12100, materialsPayable: 6800, deliveryPayable: 48400, total: 55200 })
})

test('line amounts and half-cent discount deductions round half up', () => {
  expect(quotationDiscountPreview({ ...base, lines: [{ ...base.lines[0]!, quantity: '1.0005', unitPriceCentavos: 1000 }], discount: { scope: 'MATERIALS', percent: '50' } })).toMatchObject({ valid: true, materialsGross: 1001, deduction: 501, total: 500 })
})

test('full delivery discounts are valid while full materials discounts leave no payable subtotal', () => {
  expect(quotationDiscountPreview({ ...base, discount: { scope: 'MATERIALS', percent: '100' } })).toMatchObject({ valid: false })
  expect(quotationDiscountPreview({ ...base, fulfillmentMethod: 'DELIVERY', delivery: { final_fee_centavos: 25000 }, discount: { scope: 'DELIVERY', percent: '100' } })).toMatchObject({ valid: true, deduction: 25000, deliveryPayable: 0, total: 28550 })
})

test('invalid rates, delivery scopes, amounts and quantities cannot produce a saveable estimate', () => {
  for (const percent of ['-1', '100.01', '1.001', '1e1', 'wrong']) expect(quotationDiscountPreview({ ...base, discount: { scope: 'MATERIALS', percent } }).valid).toBe(false)
  expect(quotationDiscountPreview({ ...base, discount: { scope: 'DELIVERY', percent: '10' } }).valid).toBe(false)
  expect(quotationDiscountPreview({ ...base, fulfillmentMethod: 'DELIVERY', delivery: { final_fee_centavos: -1 } }).valid).toBe(false)
  expect(quotationDiscountPreview({ ...base, lines: [{ ...base.lines[0]!, quantity: '0' }] }).valid).toBe(false)
  expect(quotationDiscountPreview({ ...base, lines: [{ ...base.lines[0]!, quantity: '9999999999', unitPriceCentavos: 100000000000 }] }).valid).toBe(false)
})

test('existing fixed-discount drafts retain their saved totals until explicitly replaced', () => {
  expect(quotationDiscountPreview({ ...base, vendorDiscountCentavos: 8550 })).toMatchObject({ valid: true, deduction: 8550, total: 20000 })
  expect(quotationDraftForSave({ ...base, vendorDiscountCentavos: 8550 }).vendorDiscountCentavos).toBe(8550)
})
