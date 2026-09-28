import { useCallback, useEffect, useRef, useState } from 'react'
import type { TaxCategory } from '@materyalph/api-client-ts'
import { centavosToPeso, getCatalogFileUrl, pesoToCentavos, readableCatalogError, searchMaterials, type CatalogListing, type CatalogMaterialMatch, type CatalogTaxonomy, type CatalogVariantInput } from './catalog-api'

/** Listing wizard form state, client pre-validation and presentation helpers shared by the catalog pages. */

export const IMAGE_TYPES = ['image/jpeg', 'image/png', 'image/webp']

/** Four wizard steps over the server's six completion requirements. */
export const listingSteps = [
  { label: 'Material selection', description: 'Name matching and tags', requirements: ['material_classification'] },
  { label: 'Product information', description: 'Details, pricing and variants', requirements: ['product_details', 'variants_pricing'] },
  { label: 'Photos and compliance', description: 'Product photos and PS/ICC marking', requirements: ['media', 'product_compliance'] },
  { label: 'Review and publish', description: 'Confirm and publish', requirements: ['review_publish'] },
]

export type DetailsForm = { displayName: string; vendorSku: string; description: string; materialId: string | null; materialMatch: 'EXACT' | 'ALIAS' | 'FUZZY_CONFIRMED'; otherLabel: string; categoryId: string; tagIds: string[]; brand: string; model: string; manufacturer: string; manufacturerAddress: string; countryOfManufacture: string; technicalAttributes: Record<string, string> }
export type TierRow = { minimum: string; price: string }
export type VariantRow = { id?: string; sku: string; label: string; unitId: string; packQuantity: string; price: string; taxCategory: string; taxBasis: string; weightKg: string; lengthCm: string; widthCm: string; heightCm: string; quantityOnHand: string; tiers: TierRow[]; publicAvailability?: string; priceVersion?: number; includedVat?: number }

export const MAX_TIERS = 5
const QUANTITY = /^\d{1,14}(\.\d{1,4})?$/

export function formFromListing(listing: CatalogListing): DetailsForm {
  return { displayName: listing.displayName, vendorSku: listing.vendorSku, description: listing.description ?? '', materialId: listing.material?.id ?? null, materialMatch: listing.materialMatch === 'UNMATCHED' ? 'EXACT' : listing.materialMatch, otherLabel: listing.otherLabel ?? '', categoryId: listing.materialCategoryId ?? '', tagIds: listing.tagIds, brand: listing.brand ?? '', model: listing.model ?? '', manufacturer: listing.manufacturer ?? '', manufacturerAddress: listing.manufacturerAddress ?? '', countryOfManufacture: listing.countryOfManufacture ?? '', technicalAttributes: { ...listing.technicalAttributes } }
}

export function rowsFromListing(listing: CatalogListing): VariantRow[] {
  const rows = listing.variants.filter(variant => variant.active).map(variant => ({ id: variant.id, sku: variant.sku, label: variant.label ?? '', unitId: variant.unitId, packQuantity: quantityText(variant.packQuantity), price: centavosToPeso(variant.price?.amountCentavos), taxCategory: variant.price?.taxCategory ?? '', taxBasis: variant.price?.taxBasis ?? '', weightKg: variant.weightKg ?? '', lengthCm: variant.lengthCm ?? '', widthCm: variant.widthCm ?? '', heightCm: variant.heightCm ?? '', quantityOnHand: quantityText(variant.inventory?.quantityOnHand), tiers: (variant.volumeTiers ?? []).map(tier => ({ minimum: quantityText(tier.minimumQuantity), price: centavosToPeso(tier.amountCentavos) })), publicAvailability: variant.publicAvailability, ...(variant.price ? { priceVersion: variant.price.version, includedVat: variant.price.includedVatCentavos } : {}) }))
  return rows.length ? rows : [emptyVariant(listing.vendorSku)]
}

export function emptyVariant(sku: string, index = 1): VariantRow {
  return { sku: `${sku}-${index}`, label: '', unitId: '', packQuantity: '1', price: '', taxCategory: '', taxBasis: '', weightKg: '', lengthCm: '', widthCm: '', heightCm: '', quantityOnHand: '', tiers: [] }
}

/** Mirrors the server rules so problems show per row before any request; the server stays authoritative. */
export function variantClientErrors(rows: VariantRow[]): Record<string, string> {
  const errors: Record<string, string> = {}
  rows.forEach((row, index) => {
    const add = (field: string, message: string) => { errors[`variants.${index}.${field}`] ??= message }
    if (!row.sku.trim()) add('sku', 'Enter a variant SKU.')
    if (!row.unitId) add('unit_id', 'Choose a sale unit.')
    if (!(Number(row.packQuantity) > 0)) add('pack_quantity', 'Enter a pack quantity greater than zero.')
    const ordinary = pesoToCentavos(row.price)
    if (ordinary === null) add('price_centavos', 'Enter a price in pesos, for example 285.50.')
    if (!row.taxCategory) add('tax_category', 'Choose a tax classification.')
    if (['VAT_ZERO', 'VAT_EXEMPT'].includes(row.taxCategory) && row.taxBasis.trim().length < 3) add('tax_basis', 'Zero-rated and exempt lines need their supporting basis.')
    if (row.quantityOnHand && !QUANTITY.test(row.quantityOnHand)) add('quantity_on_hand', 'Enter a counted quantity of zero or more.')
    let previousMinimum: number | null = null
    let previousPrice: number | null = null
    row.tiers.forEach((tier, position) => {
      const minimumValid = QUANTITY.test(tier.minimum) && Number(tier.minimum) > 1
      if (!minimumValid) add(`volume_tiers.${position}.minimum_quantity`, 'Enter a minimum quantity greater than 1, with up to four decimals.')
      else if (previousMinimum !== null && Number(tier.minimum) <= previousMinimum) add(`volume_tiers.${position}.minimum_quantity`, 'Each tier needs a higher minimum quantity than the tier before it.')
      const price = pesoToCentavos(tier.price)
      if (price === null) add(`volume_tiers.${position}.price_centavos`, 'Enter a tier price in pesos.')
      else if (ordinary !== null && price >= ordinary) add(`volume_tiers.${position}.price_centavos`, 'A tier price must be lower than the ordinary price.')
      else if (previousPrice !== null && price >= previousPrice) add(`volume_tiers.${position}.price_centavos`, 'Each tier needs a lower price than the tier before it.')
      if (minimumValid) previousMinimum = Number(tier.minimum)
      if (price !== null) previousPrice = price
    })
  })
  return errors
}

export function variantInputs(rows: VariantRow[]): CatalogVariantInput[] {
  return rows.map(row => ({ ...(row.id ? { id: row.id } : {}), sku: row.sku.trim(), label: row.label.trim() || null, unitId: row.unitId, packQuantity: row.packQuantity, priceCentavos: pesoToCentavos(row.price) ?? 0, taxCategory: row.taxCategory as TaxCategory, taxBasis: row.taxBasis.trim() || null, weightKg: row.weightKg || null, lengthCm: row.lengthCm || null, widthCm: row.widthCm || null, heightCm: row.heightCm || null, quantityOnHand: row.quantityOnHand || null, volumeTiers: row.tiers.map(tier => ({ minimumQuantity: tier.minimum.trim(), priceCentavos: pesoToCentavos(tier.price) ?? 0 })) }))
}

/** "50–99 bags" for whole numbers; otherwise "50.5 to under 100". */
export function tierRange(tiers: TierRow[], index: number, unit: string): string {
  const minimum = tiers[index]?.minimum.trim() ?? ''
  const next = tiers[index + 1]?.minimum.trim()
  if (!QUANTITY.test(minimum)) return '—'
  if (!next || !QUANTITY.test(next)) return `${minimum}+ ${unit}`.trim()
  return Number.isInteger(Number(minimum)) && Number.isInteger(Number(next)) && Number(next) - 1 >= Number(minimum) ? `${minimum}–${Number(next) - 1} ${unit}`.trim() : `${minimum} to under ${next} ${unit}`.trim()
}

export function usePhotoPreviews(listing: CatalogListing): Record<string, string> {
  const [previews, setPreviews] = useState<Record<string, string>>({})
  useEffect(() => {
    let active = true
    for (const item of listing.media.filter(media => media.status === 'READY' && !previews[media.fileId])) {
      void getCatalogFileUrl(item.fileId).then(url => { if (active) setPreviews(current => ({ ...current, [item.fileId]: url })) }).catch(() => undefined)
    }
    return () => { active = false }
  }, [listing.media, previews])
  return previews
}


type GroupedBlockers = { index: number; label: string; blockers: CatalogListing['blockers'] }[]

export function groupedBlockers(listing: CatalogListing): GroupedBlockers {
  return listingSteps.map((step, index) => ({ index, label: step.label, blockers: listing.blockers.filter(blocker => step.requirements.includes(blocker.step)) })).filter(group => group.blockers.length > 0)
}


/** Human unit name from a unit code, for example `BAG` → `bag`. */
export function unitName(taxonomy: CatalogTaxonomy | null, code: string | null | undefined): string {
  if (!code) return ''
  return (taxonomy?.units.find(unit => unit.code === code)?.name ?? code).toLowerCase()
}

/** Trims trailing zero decimals from a four-decimal quantity string. */
export function quantityText(value: string | null | undefined): string {
  if (value === null || value === undefined) return ''
  return value.includes('.') ? value.replace(/\.?0+$/, '') : value
}

/**
 * Canonical-material matching as the Vendor types: waits for a pause so fast typing sends one
 * request, ignores stale responses, and needs at least two characters.
 */
export function useMaterialSearch(query: string, enabled = true) {
  const [results, setResults] = useState<CatalogMaterialMatch[] | null>(null)
  const [searching, setSearching] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const request = useRef(0)
  const search = useCallback(async (term: string) => {
    const id = ++request.current
    setSearching(true); setError(null)
    try { const found = await searchMaterials(term); if (id === request.current) setResults(found) }
    catch (cause) { if (id === request.current) setError(await readableCatalogError(cause)) }
    finally { if (id === request.current) setSearching(false) }
  }, [])
  useEffect(() => {
    const term = query.trim()
    if (!enabled || term.length < 2) { request.current += 1; setResults(null); setSearching(false); return undefined }
    const timer = window.setTimeout(() => void search(term), 400)
    return () => window.clearTimeout(timer)
  }, [query, enabled, search])
  return { results, searching, error, searchNow: () => { if (query.trim().length >= 2) void search(query.trim()) } }
}