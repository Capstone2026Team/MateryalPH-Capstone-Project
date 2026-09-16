import {
  AdminVendorVerificationApi,
  ResponseError,
  type AdminVendorVerificationDecision,
  type AdminVendorVerificationQueueItem,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

function verificationApi(): AdminVendorVerificationApi {
  return new AdminVendorVerificationApi(createWebApiConfiguration(basePath, { refreshSession: true }))
}

export type VerificationDetail = Record<string, unknown>

export async function listVendorVerificationQueue(filters: { status?: string; businessType?: string; page?: number } = {}): Promise<{ items: AdminVendorVerificationQueueItem[]; meta: Record<string, unknown> }> {
  const response = await verificationApi().listVendorVerificationQueue(filters)
  return { items: response.data, meta: response.meta as Record<string, unknown> }
}

export async function getVendorVerificationCase(organizationId: string): Promise<VerificationDetail> {
  const response = await verificationApi().getVendorVerificationCase({ organizationId })
  return response.data as VerificationDetail
}

export async function decideVendorVerificationRequirement(organizationId: string, requirementKey: string, input: AdminVendorVerificationDecision): Promise<VerificationDetail> {
  const response = await verificationApi().decideVendorVerificationRequirement({ organizationId, requirementKey, idempotencyKey: crypto.randomUUID(), adminVendorVerificationDecision: input })
  return response.data as VerificationDetail
}

export async function getAdminVendorEvidenceUrl(fileId: string) {
  const response = await verificationApi().getAdminVendorEvidenceUrl({ fileId })
  return response.data
}

export async function restrictVendorActivation(organizationId: string, reason: string) {
  const response = await verificationApi().restrictVendorActivation({ organizationId, idempotencyKey: crypto.randomUUID(), vendorRestriction: { reason } })
  return response.data
}

export async function restoreVendorActivation(organizationId: string, reason: string) {
  const response = await verificationApi().restoreVendorActivation({ organizationId, idempotencyKey: crypto.randomUUID(), vendorRestriction: { reason } })
  return response.data
}

export async function readableVerificationError(error: unknown): Promise<string> {
  if (error instanceof ResponseError) {
    if (error.response.status === 429) return 'Too many requests were sent. Please wait a moment and try again.'
    const payload: unknown = await error.response.clone().json().catch(() => null)
    const first = firstApiError(payload)
    if (error.response.status === 401) return 'Your session has expired. Sign in again to continue.'
    if (typeof first?.message === 'string') return first.message
  }
  return error instanceof Error ? error.message : 'The request could not be completed. Check your connection and try again.'
}

function firstApiError(value: unknown): { message?: string } | null {
  if (typeof value !== 'object' || value === null || !('errors' in value) || !Array.isArray(value.errors)) return null
  const first: unknown = value.errors[0]
  if (typeof first !== 'object' || first === null) return null
  const record = first as Record<string, unknown>
  const result: { message?: string } = {}
  if (typeof record.message === 'string') result.message = record.message
  return result
}
