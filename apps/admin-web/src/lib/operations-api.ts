import {
  AdminAuditLogApi,
  AdminEnforcementApi,
  AdminIntegrationHealthApi,
  AdminPlatformSettingsApi,
  AdminPrivacyRequestsApi,
  ReportingApi,
  ResponseError,
  type AuditEvent,
  type AuditEventDetail,
  type DocumentExportInputTypeEnum,
  type EnforcementApplyRequest,
  type EnforcementDetail,
  type EnforcementRecordRequest,
  type EnforcementSubjectMatch,
  type EnforcementSummary,
  type FixedSetting,
  type IntegrationOverview,
  type ListEnforcementActionsRequest,
  type ListPrivacyRequestsRequest,
  type OperationFailure,
  type OperationRetryRecord,
  type OperationRetryRequest,
  type OperationRetryResult,
  type PlatformSetting,
  type PlatformSettingVersion,
  type PrivacyRequestCreateRequest,
  type PrivacyRequestDetail,
  type PrivacyRequestSummary,
  type PrivacyTransitionRequest,
  type SearchAuditLogRequest,
  type SubjectReview,
  type TransitionPrivacyRequestCommandEnum,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration, rateLimitMessage } from '@materyalph/web-ui'
import { dateQuery, type CalendarRange } from './admin-format'

export type {
  AuditEvent, AuditEventDetail, EnforcementDetail, EnforcementSubjectMatch, EnforcementSummary, FixedSetting, IntegrationOverview, OperationFailure,
  OperationRetryRecord, PlatformSetting, PlatformSettingVersion, PrivacyRequestDetail, PrivacyRequestSummary, SubjectReview,
}
export type Page<T> = { items: T[]; total: number; lastPage: number }

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const config = () => createWebApiConfiguration(basePath, { refreshSession: true })
export const newKey = (): string => crypto.randomUUID()

const pageOf = <T>(items: T[], meta: unknown): Page<T> => {
  const value = (meta ?? {}) as { total?: number; last_page?: number }
  return { items, total: Number(value.total ?? items.length), lastPage: Math.max(1, Number(value.last_page ?? 1)) }
}

/** A structured API failure: the stable code drives conflict and re-authentication handling, never the message text. */
export type ApiProblem = { status: number; code: string; message: string; fields: Record<string, string>; correlationId: string | null }

function fieldMessages(value: unknown): Record<string, string> {
  if (typeof value !== 'object' || value === null || Array.isArray(value)) return {}
  return Object.fromEntries(Object.entries(value).flatMap(([field, messages]) => {
    const first: unknown = Array.isArray(messages) ? messages[0] : messages
    return typeof first === 'string' ? [[field, first]] : []
  }))
}

export async function apiProblem(error: unknown): Promise<ApiProblem> {
  if (error instanceof ResponseError) {
    const status = error.response.status
    const payload = await error.response.clone().json().catch(() => null) as { meta?: { correlation_id?: unknown }; errors?: { code?: unknown; message?: unknown; details?: Record<string, unknown> }[] } | null
    const correlationId = typeof payload?.meta?.correlation_id === 'string' ? payload.meta.correlation_id : null
    if (status === 429 && error.response.headers.has('Retry-After')) return { status, code: 'RATE_LIMITED', message: rateLimitMessage(error.response), fields: {}, correlationId }
    const first = Array.isArray(payload?.errors) ? payload.errors[0] : undefined
    const code = typeof first?.code === 'string' ? first.code : `HTTP_${status}`
    const fields = fieldMessages(first?.details?.fields ?? (code === 'VALIDATION_FAILED' ? first?.details : undefined))
    if (status === 401) return { status, code: 'UNAUTHENTICATED', message: 'Your session has expired. Sign in again to continue.', fields, correlationId }
    return { status, code, message: typeof first?.message === 'string' ? first.message : 'The request could not be completed.', fields, correlationId }
  }
  return { status: 0, code: 'NETWORK', message: 'The request could not be completed. Check your connection and try again.', fields: {}, correlationId: null }
}

export const problemText = (problem: ApiProblem) => problem.correlationId ? `${problem.message} Reference: ${problem.correlationId}` : problem.message

export const isConflict = (problem: ApiProblem) => problem.status === 409 && /VERSION|STALE|CONFLICT/.test(problem.code)
export const needsReauthentication = (problem: ApiProblem) => problem.code === 'RECENT_AUTHENTICATION_REQUIRED' || problem.code === 'REAUTHENTICATION_REQUIRED'

// Platform Settings
export async function listSettings(): Promise<{ items: PlatformSetting[]; fixed: FixedSetting[]; canManage: boolean }> {
  const response = await new AdminPlatformSettingsApi(config()).listPlatformSettings()
  return { items: response.data, fixed: response.meta.fixed ?? [], canManage: Boolean(response.meta.canManage) }
}
export async function settingHistory(key: string): Promise<PlatformSettingVersion[]> {
  return (await new AdminPlatformSettingsApi(config()).listPlatformSettingHistory({ key })).data
}
export async function updateSetting(key: string, value: unknown, expectedVersion: number, reason: string): Promise<PlatformSetting> {
  return (await new AdminPlatformSettingsApi(config()).updatePlatformSetting({ key, platformSettingUpdateRequest: { value, expectedVersion, reason } })).data
}

// Enforcement
export async function listEnforcement(filters: ListEnforcementActionsRequest): Promise<Page<EnforcementSummary>> {
  const response = await new AdminEnforcementApi(config()).listEnforcementActions(filters)
  return pageOf(response.data, response.meta)
}
export async function getEnforcement(actionId: string): Promise<EnforcementDetail> {
  return (await new AdminEnforcementApi(config()).getEnforcementAction({ actionId })).data
}
export async function searchSubjects(type: 'BUYER' | 'VENDOR_ORGANIZATION', q: string): Promise<EnforcementSubjectMatch[]> {
  return (await new AdminEnforcementApi(config()).searchEnforcementSubjects({ type, q })).data
}
export async function getSubject(type: 'BUYER' | 'VENDOR_ORGANIZATION', subjectId: string): Promise<SubjectReview & { sanctions: EnforcementSummary[] }> {
  return (await new AdminEnforcementApi(config()).getEnforcementSubject({ type, subjectId })).data as SubjectReview & { sanctions: EnforcementSummary[] }
}
export async function recordEnforcement(input: EnforcementRecordRequest, idempotencyKey: string): Promise<EnforcementDetail> {
  return (await new AdminEnforcementApi(config()).recordEnforcementAction({ idempotencyKey, enforcementRecordRequest: input })).data
}
export async function applyEnforcement(actionId: string, input: EnforcementApplyRequest): Promise<EnforcementDetail> {
  return (await new AdminEnforcementApi(config()).applyEnforcementAction({ actionId, enforcementApplyRequest: input })).data
}
export async function declineEnforcement(actionId: string, lockVersion: number, reason: string): Promise<EnforcementDetail> {
  return (await new AdminEnforcementApi(config()).declineEnforcementAction({ actionId, reasonedVersionRequest: { lockVersion, reason } })).data
}
export async function liftEnforcement(actionId: string, lockVersion: number, reason: string): Promise<EnforcementDetail> {
  return (await new AdminEnforcementApi(config()).liftEnforcementAction({ actionId, reasonedVersionRequest: { lockVersion, reason } })).data
}

// Privacy requests
export async function listPrivacy(filters: ListPrivacyRequestsRequest): Promise<Page<PrivacyRequestSummary>> {
  const response = await new AdminPrivacyRequestsApi(config()).listPrivacyRequests(filters)
  return pageOf(response.data, response.meta)
}
export async function getPrivacy(requestId: string): Promise<PrivacyRequestDetail> {
  return (await new AdminPrivacyRequestsApi(config()).getPrivacyRequest({ requestId })).data
}
export async function recordPrivacy(input: PrivacyRequestCreateRequest, idempotencyKey: string): Promise<PrivacyRequestDetail> {
  return (await new AdminPrivacyRequestsApi(config()).recordPrivacyRequest({ idempotencyKey, privacyRequestCreateRequest: input })).data
}
export async function transitionPrivacy(requestId: string, command: TransitionPrivacyRequestCommandEnum, input: PrivacyTransitionRequest): Promise<PrivacyRequestDetail> {
  return (await new AdminPrivacyRequestsApi(config()).transitionPrivacyRequest({ requestId, command, privacyTransitionRequest: input })).data
}

// Audit search (append-only; there is no edit or delete operation)
export async function searchAudit(filters: SearchAuditLogRequest): Promise<{ items: AuditEvent[]; nextCursor: string | null; canViewDetail: boolean; canExport: boolean }> {
  const response = await new AdminAuditLogApi(config()).searchAuditLog(filters)
  return { items: response.data, nextCursor: response.meta.nextCursor ?? null, canViewDetail: Boolean(response.meta.canViewDetail), canExport: Boolean(response.meta.canExport) }
}
export async function getAudit(auditId: string): Promise<AuditEventDetail> {
  return (await new AdminAuditLogApi(config()).getAuditEvent({ auditId })).data
}
export async function auditActions(): Promise<string[]> {
  return (await new AdminAuditLogApi(config()).listAuditActions()).data
}

// Integration and job health
export async function integrationOverview(): Promise<IntegrationOverview> {
  return (await new AdminIntegrationHealthApi(config()).getIntegrationHealth()).data
}
export async function operationFailures(kind: 'OUTBOX' | 'JOBS', page = 1, range?: CalendarRange): Promise<Page<OperationFailure>> {
  const response = await new AdminIntegrationHealthApi(config()).listOperationFailures({ kind, page, ...dateQuery(range) })
  return pageOf(response.data, response.meta)
}
export async function operationRetries(): Promise<OperationRetryRecord[]> {
  return (await new AdminIntegrationHealthApi(config()).listOperationRetries()).data
}
export async function retryOperation(input: OperationRetryRequest, idempotencyKey: string): Promise<OperationRetryResult> {
  return (await new AdminIntegrationHealthApi(config()).retryOperation({ idempotencyKey, operationRetryRequest: input })).data
}

/**
 * Requests an authorized export snapshot and downloads it once generated. The server re-checks the export permission
 * and the filter allowlist; a slow job leaves the export listed for later download.
 */
export async function requestExport(type: DocumentExportInputTypeEnum, filters: Record<string, unknown>, purpose: string, idempotencyKey: string): Promise<'DOWNLOADED' | 'QUEUED'> {
  const api = new ReportingApi(config())
  const created = await api.requestDocumentExport({ audience: 'admin', idempotencyKey, documentExportInput: { type, format: 'CSV', purpose, filters } })
  for (let attempt = 0; attempt < 10; attempt++) {
    const list = await api.listDocumentExports({ audience: 'admin', page: 1 })
    const current = list.data.find(item => item.id === created.data.id)
    if (current?.state === 'READY') {
      const file = await api.downloadDocumentExportRaw({ audience: 'admin', exportId: current.id })
      const url = URL.createObjectURL(await file.raw.blob())
      const anchor = document.createElement('a')
      anchor.href = url
      anchor.download = `materyalph-${type.toLowerCase().replaceAll('_', '-')}.csv`
      anchor.click()
      URL.revokeObjectURL(url)
      return 'DOWNLOADED'
    }
    if (current && current.state !== 'QUEUED') throw new Error(current.failureCode ? `The export failed (${current.failureCode}).` : 'The export could not be generated.')
    await new Promise(resolve => window.setTimeout(resolve, 1500))
  }
  return 'QUEUED'
}
