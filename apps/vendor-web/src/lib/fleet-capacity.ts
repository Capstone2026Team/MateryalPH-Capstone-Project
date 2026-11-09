import type { VehicleCapacitySource } from '@materyalph/web-ui'
import { getCatalogTaxonomy, getListing, listListings, type CatalogListing } from './catalog-api'
import { isReadyMixed } from './ready-mixed-concrete'

const positive = (value: string | null | undefined) => value && Number.isFinite(Number(value)) && Number(value) > 0 ? String(Number(value)) : ''

/** Batch supply is a proposed load only. A Vendor must verify the actual drum size before saving. */
export function listingCapacitySources(listing: CatalogListing): VehicleCapacitySource[] {
  if (!isReadyMixed(listing.material?.code, null)) return []
  return listing.variants.filter(variant => variant.active && variant.unitCode === 'CUM').map(variant => ({
    id: variant.id, label: `${listing.displayName} · ${variant.label || variant.sku}`,
    volumeM3: positive(variant.inventory?.availableToSell), kgPerM3: positive(variant.weightKg),
  }))
}

/** Existing authorized catalog endpoints supply suggestions; no fleet permissions grant catalog access. */
export async function loadFleetCapacitySources(listingId?: string): Promise<VehicleCapacitySource[]> {
  if (listingId) return listingCapacitySources(await getListing(listingId))
  const taxonomy = await getCatalogTaxonomy()
  const category = taxonomy.categories.find(item => item.code === 'READY_MIXED_CONCRETE')
  if (!category) return []
  const sources: VehicleCapacitySource[] = []
  let page = 1
  let lastPage = 1
  do {
    const result = await listListings({ categoryId: category.id, page })
    const details = await Promise.allSettled(result.items.map(item => getListing(item.id)))
    for (const detail of details) {
      if (detail.status === 'rejected') throw detail.reason
      sources.push(...listingCapacitySources(detail.value))
    }
    lastPage = result.meta.lastPage ?? 1
    page += 1
  } while (page <= lastPage)
  return sources
}
