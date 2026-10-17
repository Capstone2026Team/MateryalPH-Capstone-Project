import { describe, expect, it } from 'vitest'
import { addCustomTag, mergeSavedRows, variantInputs, type VariantRow } from './catalog-form'
import { manualSaveReason } from './listing-autosave'
import type { CatalogListing } from './catalog-api'

const row = (patch: Partial<VariantRow> = {}): VariantRow => ({ sku: 'SKU-1', label: '', unitId: 'unit-1', packQuantity: '1', price: '10', taxCategory: 'NON_VAT', taxBasis: '', weightKg: '', lengthCm: '', widthCm: '', heightCm: '', quantityOnHand: '5', tiers: [], attributes: {}, ...patch })

describe('custom search tags', () => {
  it('trims, collapses spaces and ignores repeats regardless of case', () => {
    const first = addCustomTag([], '  rebar   10mm ')
    expect(first).toEqual({ tags: ['rebar 10mm'], error: null })
    expect(addCustomTag(first.tags, 'REBAR 10MM')).toEqual({ tags: ['rebar 10mm'], error: '“REBAR 10MM” is already added.' })
    expect(addCustomTag(first.tags, '   ')).toEqual({ tags: first.tags, error: null })
  })

  it('rejects text the server would refuse', () => {
    expect(addCustomTag([], 'a').error).toContain('2 to 40')
    expect(addCustomTag([], '<script>').error).toContain('letters')
    expect(addCustomTag([], 'x'.repeat(41)).error).toContain('2 to 40')
    expect(addCustomTag(Array.from({ length: 50 }, (_, index) => `tag ${index}`), 'one more').error).toContain('up to 50')
  })
})

describe('saving variants', () => {
  it('leaves out the stock count of an existing row that did not change, but sends new or edited counts', () => {
    const saved = [row({ id: 'v1', quantityOnHand: '5' }), row({ id: 'v2', sku: 'SKU-2', quantityOnHand: '7' })]
    const edited = [row({ id: 'v1', quantityOnHand: '5' }), row({ id: 'v2', sku: 'SKU-2', quantityOnHand: '9' }), row({ sku: 'SKU-3', quantityOnHand: '2' })]
    expect(variantInputs(edited, saved).map(input => input.quantityOnHand)).toEqual([null, '9', '2'])
    expect(variantInputs(edited).map(input => input.quantityOnHand)).toEqual(['5', '9', '2'])
  })

  it('gives sent rows the server identity without touching rows that changed meanwhile', () => {
    const sent = [row({ sku: 'A' }), row({ sku: 'B' })]
    const savedRows = [row({ sku: 'A', id: 'id-a', priceVersion: 1, includedVat: 100, publicAvailability: 'IN_STOCK' }), row({ sku: 'B', id: 'id-b', priceVersion: 2 })]
    const typedSince = [row({ sku: 'A', price: '12' }), row({ sku: 'B2' })]
    const merged = mergeSavedRows(typedSince, sent, savedRows)
    expect(merged[0]).toMatchObject({ id: 'id-a', priceVersion: 1, includedVat: 100, price: '12' })
    expect(merged[1]).toBe(typedSince[1])
  })
})

describe('when a listing is saved by hand', () => {
  const listing = (patch: Partial<CatalogListing>) => ({ status: 'DRAFT', regulated: false, complianceStatus: 'NOT_REQUIRED', ...patch }) as CatalogListing
  it('only for live listings and regulated listings with verified or pending evidence', () => {
    expect(manualSaveReason(listing({}))).toBeNull()
    expect(manualSaveReason(listing({ status: 'ACTIVE' }))).toBe('LIVE')
    expect(manualSaveReason(listing({ regulated: true, complianceStatus: 'VERIFIED' }))).toBe('REGULATED')
    expect(manualSaveReason(listing({ regulated: true, complianceStatus: 'PENDING_ADMIN_REVIEW' }))).toBe('REGULATED')
    expect(manualSaveReason(listing({ regulated: true, complianceStatus: 'NOT_SUBMITTED' }))).toBeNull()
  })
})
