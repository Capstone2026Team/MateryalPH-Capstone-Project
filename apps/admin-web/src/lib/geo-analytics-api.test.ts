import { clearWebSessionTransport } from '@materyalph/web-ui'
import { afterEach, expect, test, vi } from 'vitest'
import { getGeoDashboard, getGeoDemand, getGeoFilterOptions, type GeoFilters } from './geo-analytics-api'

afterEach(() => { clearWebSessionTransport(); vi.unstubAllGlobals() })

test('loads all category and material pages through the credentialed generated client', async () => {
  const fetchMock = vi.fn(async (input: RequestInfo | URL, _init?: RequestInit) => {
    const url = new URL(String(input))
    if (url.pathname.endsWith('/auth/csrf')) return new Response(JSON.stringify({ data: { csrf_token: 'synthetic-geo-filter-test' }, meta: {}, errors: [] }), { headers: { 'Content-Type': 'application/json' } })
    const page = Number(url.searchParams.get('page'))
    return new Response(JSON.stringify({ data: [{ id: `option-${page}`, name: `Category ${page}` }], meta: { current_page: page, last_page: 2, total: 2 }, errors: [] }), { headers: { 'Content-Type': 'application/json' } })
  })
  vi.stubGlobal('fetch', fetchMock)
  expect(await getGeoFilterOptions()).toEqual([{ id: 'option-1', name: 'Category 1' }, { id: 'option-2', name: 'Category 2' }])
  expect(await getGeoFilterOptions('category-id')).toHaveLength(2)
  expect(fetchMock.mock.calls.filter(([input]) => !String(input).endsWith('/auth/csrf')).map(([input]) => new URL(String(input)).search)).toEqual(['?page=1', '?page=2', '?category_id=category-id&page=1', '?category_id=category-id&page=2'])
  for (const [, init] of fetchMock.mock.calls) expect(init?.credentials).toBe('include')
})

test('dashboard and demand send the same category, material, geography and transaction filters', async () => {
  const fetchMock = vi.fn(async (input: RequestInfo | URL, _init?: RequestInit) => new Response(JSON.stringify({ data: String(input).endsWith('/auth/csrf') ? { csrf_token: 'synthetic-geo-filter-test' } : { filter_applicability: [], trends: [], activity_trend: [], children: [], columns: [], rows: [] }, meta: {}, errors: [] }), { headers: { 'Content-Type': 'application/json' } }))
  vi.stubGlobal('fetch', fetchMock)
  const filters: GeoFilters = { dataset: 'TEST', area: '1300000000', from: '2026-10-01', to: '2026-10-27', granularity: 'WEEK', categoryId: 'category-id', materialId: 'material-id', procurementType: 'ITEM_BASED', fulfillmentMethod: 'PICKUP', paymentMethod: 'ONLINE', orderState: 'CONFIRMED' }
  await getGeoDashboard(filters)
  await getGeoDemand(filters, 'VALUE')
  const queries = fetchMock.mock.calls.filter(([input]) => !String(input).endsWith('/auth/csrf')).map(([input]) => new URL(String(input)).searchParams)
  for (const query of queries) {
    expect(query.get('category_id')).toBe('category-id')
    expect(query.get('material_id')).toBe('material-id')
    expect(query.get('area')).toBe('1300000000')
    expect(query.get('payment_method')).toBe('ONLINE')
  }
  queries[1]!.delete('measure')
  expect(queries[1]!.get('page')).toBe('1')
  queries[1]!.delete('page')
  expect(queries[1]!.toString()).toBe(queries[0]!.toString())
})
