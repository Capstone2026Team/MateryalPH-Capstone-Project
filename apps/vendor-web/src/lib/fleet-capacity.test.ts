import { beforeEach, expect, test, vi } from 'vitest'
import { getCatalogTaxonomy, getListing, listListings, type CatalogListing, type CatalogTaxonomy } from './catalog-api'
import { listingCapacitySources, loadFleetCapacitySources } from './fleet-capacity'

vi.mock('./catalog-api', () => ({ getCatalogTaxonomy: vi.fn(), getListing: vi.fn(), listListings: vi.fn() }))

const concrete = { id: 'listing', displayName: 'Concrete', material: { code: 'READY_MIXED_CONCRETE' }, variants: [
  { id: 'v1', active: true, unitCode: 'CUM', label: '3000 PSI', weightKg: '2350.000', inventory: { availableToSell: '6.000' } },
  { id: 'v2', active: false, unitCode: 'CUM', weightKg: '2400', inventory: { availableToSell: '8' } },
  { id: 'v3', active: true, unitCode: 'BAG', weightKg: '40', inventory: { availableToSell: '50' } },
] } as CatalogListing

beforeEach(() => vi.clearAllMocks())

test('concrete guidance uses the saved mix density and available batch volume, excluding other cargo', () => {
  expect(listingCapacitySources(concrete)).toEqual([{ id: 'v1', label: 'Concrete · 3000 PSI', volumeM3: '6', kgPerM3: '2350' }])
  expect(listingCapacitySources({ ...concrete, material: { ...concrete.material!, code: 'PORTLAND_CEMENT' } })).toEqual([])
  const invalid = { ...concrete, variants: [{ ...concrete.variants[0]!, weightKg: 'NaN', inventory: { ...concrete.variants[0]!.inventory!, availableToSell: '-1' } }] }
  expect(listingCapacitySources(invalid)).toMatchObject([{ volumeM3: '', kgPerM3: '' }])
})

test('listing-specific setup reads only the authorized listing, and catalog-wide suggestions follow pagination', async () => {
  vi.mocked(getListing).mockResolvedValue(concrete)
  expect(await loadFleetCapacitySources('listing')).toHaveLength(1)
  expect(getListing).toHaveBeenCalledWith('listing')
  expect(getCatalogTaxonomy).not.toHaveBeenCalled()
  vi.mocked(getCatalogTaxonomy).mockResolvedValue({ categories: [{ id: 'rmc', code: 'READY_MIXED_CONCRETE' }] } as CatalogTaxonomy)
  vi.mocked(listListings).mockResolvedValueOnce({ items: [{ id: 'first' }], meta: { lastPage: 2 } } as Awaited<ReturnType<typeof listListings>>).mockResolvedValueOnce({ items: [{ id: 'second' }], meta: { lastPage: 2 } } as Awaited<ReturnType<typeof listListings>>)
  expect(await loadFleetCapacitySources()).toHaveLength(2)
  expect(listListings).toHaveBeenNthCalledWith(1, { categoryId: 'rmc', page: 1 })
  expect(listListings).toHaveBeenNthCalledWith(2, { categoryId: 'rmc', page: 2 })
})
