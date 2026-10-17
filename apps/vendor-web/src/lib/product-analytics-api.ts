import {
  VendorProductAnalyticsApi,
  type ProductAnalyticsRow,
  type ProductAnalyticsSuggestion,
  type VendorProductAnalytics,
  type VendorProductAnalyticsDetail,
  type VendorProductAnalyticsSummaries,
  type VendorProductAnalyticsSummariesItemsInner,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'

export type { ProductAnalyticsRow, ProductAnalyticsSuggestion, VendorProductAnalytics, VendorProductAnalyticsDetail, VendorProductAnalyticsSummaries }
export type ProductSummary = VendorProductAnalyticsSummariesItemsInner
export type AnalyticsPeriod = 7 | 30 | 90
export type ProductSort = 'views' | 'orders' | 'conversion' | 'value'
export const ANALYTICS_PERIODS: AnalyticsPeriod[] = [7, 30, 90]

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const api = () => new VendorProductAnalyticsApi(createWebApiConfiguration(basePath, { refreshSession: true }))

/** Store-wide product analytics for the period; peso fields are null unless the member is the Owner. */
export async function getProductAnalytics(days: AnalyticsPeriod, sort: ProductSort = 'views', page = 1): Promise<VendorProductAnalytics> {
  return (await api().getVendorProductAnalytics({ days, sort, page })).data
}

export async function getProductAnalyticsDetail(listingId: string, days: AnalyticsPeriod): Promise<VendorProductAnalyticsDetail> {
  return (await api().getVendorProductAnalyticsDetail({ listingId, days })).data
}

/** Compact measures for up to 50 listings (one My Products page); listings outside the store are left out. */
export async function getProductSummaries(listingIds: string[], days: AnalyticsPeriod = 30): Promise<VendorProductAnalyticsSummaries> {
  return (await api().getVendorProductAnalyticsSummaries({ listingIds: listingIds.slice(0, 50).join(','), days })).data
}

export function parsePeriod(value: string | null): AnalyticsPeriod {
  const days = Number(value)
  return days === 7 || days === 90 ? days : 30
}
