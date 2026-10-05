import {
  VendorMaterialsAnalyticsApi,
  VendorReviewsApi,
  VendorStorePerformanceApi,
  type ListVendorReviewsTypeEnum,
  type ReviewFlagRequestReasonCodeEnum,
  type ReviewListMeta,
  type StorePerformance,
  type VendorMaterialsAnalyticsDetail,
  type VendorMaterialsAnalyticsList,
  type VendorOrderReviews,
  type VendorReviewRow,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { newIdempotencyKey } from './onboarding-api'

export type { StorePerformance, VendorMaterialsAnalyticsDetail, VendorMaterialsAnalyticsList, VendorOrderReviews, VendorReviewRow, ReviewListMeta }
export type ReviewTab = ListVendorReviewsTypeEnum
export type FlagReason = ReviewFlagRequestReasonCodeEnum

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const analytics = () => new VendorMaterialsAnalyticsApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const reviews = () => new VendorReviewsApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const performance = () => new VendorStorePerformanceApi(createWebApiConfiguration(basePath, { refreshSession: true }))

/** The allowlisted Vendor analytics filters; there is no origin, competitor or Buyer-detail option. */
export type VendorAnalyticsFilters = { radiusKm: number; presetDays: number | null; startDate: string | null; endDate: string | null; categoryId?: string | undefined; q?: string | undefined }

function windowParams(filters: VendorAnalyticsFilters) {
  return {
    radiusKm: filters.radiusKm as 5 | 10 | 20 | 30 | 40 | 50,
    ...(filters.startDate && filters.endDate ? { startDate: new Date(`${filters.startDate}T00:00:00Z`), endDate: new Date(`${filters.endDate}T00:00:00Z`) } : { presetDays: (filters.presetDays ?? 30) as 7 | 30 | 90 }),
  }
}

export async function listVendorAnalytics(filters: VendorAnalyticsFilters, cursor?: string | null): Promise<VendorMaterialsAnalyticsList> {
  return (await analytics().listVendorMaterialsAnalytics({ ...windowParams(filters), ...(filters.categoryId ? { categoryId: filters.categoryId } : {}), ...(filters.q ? { q: filters.q } : {}), ...(cursor ? { cursor } : {}), perPage: 20 })).data
}

export async function getVendorAnalyticsDetail(groupId: string, filters: VendorAnalyticsFilters): Promise<VendorMaterialsAnalyticsDetail> {
  return (await analytics().getVendorMaterialPriceDetails({ groupId, ...windowParams(filters) })).data
}

export async function exportVendorAnalytics(filters: VendorAnalyticsFilters): Promise<Blob> {
  return analytics().exportVendorMaterialsAnalytics(windowParams(filters))
}

export async function getStorePerformance(): Promise<StorePerformance> {
  return (await performance().getVendorStorePerformance()).data
}

export async function listReviews(type: ReviewTab, page = 1): Promise<{ items: VendorReviewRow[]; meta: ReviewListMeta }> {
  const response = await reviews().listVendorReviews({ type, page })
  return { items: response.data, meta: response.meta }
}

export async function getOrderReviews(orderId: string): Promise<VendorOrderReviews> {
  return (await reviews().getVendorOrderReviews({ orderId })).data
}

export async function rateBuyer(orderId: string, ratings: { inquirySeriousness: number; communicationQuality: number; paymentReliability: number; comment: string | null }, key = newIdempotencyKey()): Promise<VendorOrderReviews> {
  return (await reviews().submitVendorBuyerRating({ orderId, idempotencyKey: key, vendorBuyerRatingRequest: withoutNullComment(ratings) })).data
}

export async function editBuyerRating(reviewId: string, lockVersion: number, ratings: { inquirySeriousness: number; communicationQuality: number; paymentReliability: number; comment: string | null }): Promise<VendorOrderReviews> {
  return (await reviews().editVendorBuyerRating({ reviewId, vendorReviewEditRequest: { lockVersion, ...withoutNullComment(ratings) } })).data
}

export async function reportReview(reviewId: string, reasonCode: FlagReason, details: string | null, key = newIdempotencyKey()): Promise<void> {
  await reviews().reportVendorReview({ reviewId, idempotencyKey: key, reviewFlagRequest: { reasonCode, ...(details ? { details } : {}) } })
}

function withoutNullComment<T extends { comment: string | null }>(ratings: T): Omit<T, 'comment'> & { comment?: string } {
  const { comment, ...rest } = ratings
  return comment ? { ...rest, comment } : rest
}
