import { parseDate } from '@materyalph/api-client-ts'
import {
  AdminGeographicAnalyticsApi,
  type GeoBoundaryCollection,
  type GeoDashboard,
  type GeoDemand,
  type GetGeoAnalyticsDashboardRequest,
  type GetGeoDemandHeatmapMeasureEnum,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'

export type { GeoBoundaryCollection, GeoDashboard, GeoDemand }

/** Every dashboard filter; the PSGC area filters the whole page and there is no radius filter. */
export type GeoFilters = {
  dataset: 'TEST' | 'DEMO'; area: string | null; from: string; to: string; granularity: 'DAY' | 'WEEK' | 'MONTH'
  procurementType: string; categoryId: string; materialId: string; fulfillmentMethod: string; paymentMethod: string; orderState: string
}

export const TRANSACTION_FILTER_KEYS = ['procurementType', 'categoryId', 'materialId', 'fulfillmentMethod', 'paymentMethod', 'orderState'] as const

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const api = () => new AdminGeographicAnalyticsApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const day = (value: string) => parseDate(value)

function params(filters: GeoFilters): GetGeoAnalyticsDashboardRequest {
  return {
    dataset: filters.dataset, from: day(filters.from), to: day(filters.to), granularity: filters.granularity,
    ...(filters.area ? { area: filters.area } : {}),
    ...(filters.procurementType ? { procurementType: filters.procurementType as never } : {}),
    ...(filters.categoryId ? { categoryId: filters.categoryId } : {}),
    ...(filters.materialId ? { materialId: filters.materialId } : {}),
    ...(filters.fulfillmentMethod ? { fulfillmentMethod: filters.fulfillmentMethod as never } : {}),
    ...(filters.paymentMethod ? { paymentMethod: filters.paymentMethod as never } : {}),
    ...(filters.orderState ? { orderState: filters.orderState as never } : {}),
  }
}

/** The snake_case filter object the export snapshot validates against the same allowlist as the dashboard. */
export function exportFilters(filters: GeoFilters): Record<string, string> {
  const map: Record<string, string> = { dataset: filters.dataset, from: filters.from, to: filters.to, granularity: filters.granularity }
  if (filters.area) map.area = filters.area
  const snake: Record<(typeof TRANSACTION_FILTER_KEYS)[number], string> = { procurementType: 'procurement_type', categoryId: 'category_id', materialId: 'material_id', fulfillmentMethod: 'fulfillment_method', paymentMethod: 'payment_method', orderState: 'order_state' }
  for (const key of TRANSACTION_FILTER_KEYS) if (filters[key]) map[snake[key]] = filters[key]
  return map
}

export async function getGeoDashboard(filters: GeoFilters): Promise<GeoDashboard> {
  return (await api().getGeoAnalyticsDashboard(params(filters))).data
}

export async function getGeoDemand(filters: GeoFilters, measure: GetGeoDemandHeatmapMeasureEnum): Promise<GeoDemand> {
  return (await api().getGeoDemandHeatmap({ ...params(filters), measure } as never)).data
}

export async function getGeoBoundaries(area: string | null): Promise<GeoBoundaryCollection> {
  return (await api().getGeoBoundaries(area ? { area } : {})).data
}
