import { parseDate } from '@materyalph/api-client-ts'
import {
  AdminMaterialsAnalyticsApi,
  AdminReviewModerationApi,
  AdminScoreMonitoringApi,
  type AdminMaterialsAnalyticsDetail,
  type AdminMaterialsAnalyticsList,
  type AdminScoreDetail,
  type AdminScoreRow,
  type AnalyticsRun,
  type AnalyticsSource,
  type ListAdminReviewModerationStateEnum,
  type ModerationDetail,
  type ModerationQueueRow,
  type ReviewModerationRequestActionEnum,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'
import { dateQuery, type CalendarRange } from './admin-format'

export type { AdminMaterialsAnalyticsDetail, AdminMaterialsAnalyticsList, AdminScoreDetail, AdminScoreRow, AnalyticsRun, AnalyticsSource, ModerationDetail, ModerationQueueRow }
export type ModerationState = ListAdminReviewModerationStateEnum
export type ModerationAction = ReviewModerationRequestActionEnum

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const config = () => createWebApiConfiguration(basePath, { refreshSession: true })
const key = () => crypto.randomUUID()

export type AdminAnalyticsFilters = { presetDays: number | null; startDate: string | null; endDate: string | null; psgcCode?: string | undefined; q?: string | undefined }
const windowParams = (filters: AdminAnalyticsFilters) => ({
  ...(filters.psgcCode ? { psgcCode: filters.psgcCode } : {}),
  ...(filters.startDate && filters.endDate ? { startDate: parseDate(filters.startDate), endDate: parseDate(filters.endDate) } : { presetDays: (filters.presetDays ?? 30) as 7 | 30 | 90 }),
})

export async function listAdminAnalytics(filters: AdminAnalyticsFilters): Promise<AdminMaterialsAnalyticsList> {
  return (await new AdminMaterialsAnalyticsApi(config()).listAdminMaterialsAnalytics({ ...windowParams(filters), ...(filters.q ? { q: filters.q } : {}), perPage: 50 })).data
}
export async function getAdminAnalyticsDetail(groupId: string, filters: AdminAnalyticsFilters): Promise<AdminMaterialsAnalyticsDetail> {
  return (await new AdminMaterialsAnalyticsApi(config()).getAdminMaterialPriceDetails({ groupId, ...windowParams(filters) })).data
}
export async function exportAdminAnalytics(filters: AdminAnalyticsFilters): Promise<Blob> {
  return new AdminMaterialsAnalyticsApi(config()).exportAdminMaterialsAnalytics(windowParams(filters))
}
export async function listRuns(): Promise<AnalyticsRun[]> {
  return (await new AdminMaterialsAnalyticsApi(config()).listAdminMaterialPriceRuns()).data
}
export async function listSources(groupId: string, snapshotDate: string, reason: string, psgcCode?: string): Promise<{ items: AnalyticsSource[]; runId: string }> {
  const response = await new AdminMaterialsAnalyticsApi(config()).listAdminMaterialPriceSources({ groupId, snapshotDate: parseDate(snapshotDate), reason, ...(psgcCode ? { psgcCode } : {}) })
  return { items: response.data, runId: String((response.meta as Record<string, unknown>).run_id ?? (response.meta as Record<string, unknown>).runId ?? '') }
}
export async function correctRun(runId: string, excludedObservationIds: string[], reason: string): Promise<void> {
  await new AdminMaterialsAnalyticsApi(config()).correctAdminMaterialPriceRun({ runId, idempotencyKey: key(), analyticsCorrectionRequest: { excludedObservationIds, reason } })
}

export async function listScores(q?: string, page = 1): Promise<{ items: AdminScoreRow[]; total: number; perPage: number }> {
  const response = await new AdminScoreMonitoringApi(config()).listAdminScores({ ...(q ? { q } : {}), page })
  return { items: response.data, total: Number(response.meta.total ?? 0), perPage: response.meta.perPage ?? 20 }
}
export async function getScore(vendorId: string, page = 1): Promise<AdminScoreDetail> {
  return (await new AdminScoreMonitoringApi(config()).getAdminScore({ vendorId, page })).data
}
export async function excludeSource(vendorId: string, orderId: string, reasonCode: 'FRAUD' | 'DUPLICATE' | 'TEST' | 'INVALID_SOURCE', note: string): Promise<AdminScoreDetail> {
  return (await new AdminScoreMonitoringApi(config()).excludeAdminScoreSource({ vendorId, idempotencyKey: key(), scoreExclusionRequest: { orderId, reasonCode, note } })).data
}
export async function revokeExclusion(exclusionId: string, reason: string): Promise<void> {
  await new AdminScoreMonitoringApi(config()).revokeAdminScoreExclusion({ exclusionId, idempotencyKey: key(), investigationReasonRequest: { reason } })
}
export async function suppressBadge(vendorId: string, badgeCode: string, reasonCode: 'FRAUD' | 'COMPLIANCE', caseReference: string, note: string): Promise<AdminScoreDetail> {
  return (await new AdminScoreMonitoringApi(config()).suppressAdminBadge({ vendorId, idempotencyKey: key(), badgeSuppressionRequest: { badgeCode: badgeCode as never, reasonCode, caseReference, note } })).data
}
export async function liftSuppression(suppressionId: string, reason: string): Promise<void> {
  await new AdminScoreMonitoringApi(config()).liftAdminBadgeSuppression({ suppressionId, idempotencyKey: key(), investigationReasonRequest: { reason } })
}

export async function listModeration(state: ModerationState, page = 1, range?: CalendarRange): Promise<{ items: ModerationQueueRow[]; total: number; perPage: number }> {
  const response = await new AdminReviewModerationApi(config()).listAdminReviewModeration({ state, page, ...dateQuery(range) })
  return { items: response.data, total: Number(response.meta.total ?? 0), perPage: response.meta.perPage ?? 20 }
}
export async function getModeration(reviewId: string): Promise<ModerationDetail> {
  return (await new AdminReviewModerationApi(config()).getAdminReviewModeration({ reviewId })).data
}
export async function moderate(reviewId: string, action: ModerationAction, reason: string, lockVersion: number): Promise<ModerationDetail> {
  return (await new AdminReviewModerationApi(config()).moderateAdminReview({ reviewId, idempotencyKey: key(), reviewModerationRequest: { action, reason, lockVersion } })).data
}
