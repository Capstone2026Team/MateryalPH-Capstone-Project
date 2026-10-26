import { quotationChangeNotes } from '../../../../packages/web-ui/src/quotation-changes'
import { CatalogUnitFromJSON, ChatQuotationContentFromJSON } from '@materyalph/api-client-ts'
import { describe, expect, it } from 'vitest'
import { sellingQuantityLabel, validSellingQuantity } from '@materyalph/web-ui'

describe('selling quantities', () => {
  it('labels measurements in the selected unit', () => {
    expect(sellingQuantityLabel('CUM')).toBe('Volume (m³)')
    expect(sellingQuantityLabel('US_GAL')).toBe('Volume (US gal)')
    expect(sellingQuantityLabel('GAL')).toBe('Gallon cans')
    const wire = { id: '01995000-0000-7000-8000-000000000003', code: 'CUM', name: 'Cubic meter', dimension: 'VOLUME', precision: 3 }
    expect(CatalogUnitFromJSON(wire).quantityPolicy).toBeUndefined()
    expect(CatalogUnitFromJSON({ ...wire, quantity_policy: { mode: 'MEASURED', dimension: 'VOLUME', precision: 3, step: '0.001' } }).quantityPolicy?.step).toBe('0.001')
  })
  it('validates decimal text without rounding or truncation', () => {
    expect(validSellingQuantity('2.0000', 0)).toBe(true)
    expect(validSellingQuantity('2.5', 0)).toBe(false)
    expect(validSellingQuantity('1.1250', 3)).toBe(true)
    expect(validSellingQuantity('1.1251', 3)).toBe(false)
    expect(validSellingQuantity('1.00001', 4)).toBe(false)
    expect(validSellingQuantity('1e3', 3)).toBe(false)
  })
})

it('shows original and proposed units independently in Buyer quotation comparisons', () => {
  const content = ChatQuotationContentFromJSON({
    lines: [{ description: 'Gravel', quantity: '5', unit_code: 'BAG' }],
    original_changes: [],
    changes: [
      { path: 'lines.0.quantity', before: '1.25', after: '5', label: 'Quantity changed' },
      { path: 'lines.0.unit_code', before: 'CUM', after: 'BAG', label: 'Unit changed' },
    ],
  })
  expect(quotationChangeNotes(content)).toContainEqual({ title: 'Gravel · Quantity', before: '1.25 CUM', after: '5 BAG' })
})
