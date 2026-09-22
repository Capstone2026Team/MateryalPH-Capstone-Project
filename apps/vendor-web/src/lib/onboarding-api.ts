import { rateLimitMessage } from '@materyalph/web-ui'
import {
  ResponseError,
  VendorOnboardingApi,
  type VendorAddressGeocode,
  type VendorInvitationRequest,
  type VendorOnboardingSnapshot,
  type VendorPaymentConnection,
  type VendorSetupComplete,
  type VendorSetupDraft,
  type VendorStoreEmailConfirmation,
  type VendorVerificationDraft,
  type VendorVerificationSubmit,
  type UploadVendorVerificationDocumentRequirementKeyEnum,
} from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

function onboardingApi(): VendorOnboardingApi {
  return new VendorOnboardingApi(createWebApiConfiguration(basePath, { refreshSession: true }))
}

export type { VendorOnboardingSnapshot }

export function newIdempotencyKey(): string {
  return crypto.randomUUID()
}

export async function getVendorOnboarding(): Promise<VendorOnboardingSnapshot> {
  const response = await onboardingApi().getVendorOnboarding()
  return response.data
}

export async function saveVendorVerificationDraft(draft: VendorVerificationDraft): Promise<VendorOnboardingSnapshot> {
  const response = await onboardingApi().saveVendorVerificationDraft({ vendorVerificationDraft: draft })
  return response.data
}

export async function submitVendorVerification(input: VendorVerificationSubmit): Promise<VendorOnboardingSnapshot> {
  const response = await onboardingApi().submitVendorVerification({ idempotencyKey: newIdempotencyKey(), vendorVerificationSubmit: input })
  return response.data
}

export async function saveVendorSetupDraft(draft: VendorSetupDraft): Promise<VendorOnboardingSnapshot> {
  const response = await onboardingApi().saveVendorSetupDraft({ vendorSetupDraft: draft })
  return response.data
}

export async function completeVendorSetup(input: VendorSetupComplete): Promise<VendorOnboardingSnapshot> {
  const response = await onboardingApi().completeVendorSetup({ idempotencyKey: newIdempotencyKey(), vendorSetupComplete: input })
  return response.data
}

export async function dismissVendorWelcome(): Promise<VendorOnboardingSnapshot> {
  const response = await onboardingApi().dismissVendorOnboardingWelcome()
  return response.data
}

export async function reverseGeocodeVendorAddress(input: VendorAddressGeocode) {
  const response = await onboardingApi().reverseGeocodeVendorAddress({ vendorAddressGeocode: input })
  return response.data
}

export async function requestStoreEmailVerification(email: string) {
  const response = await onboardingApi().requestVendorStoreEmailVerification({ emailRequest: { email } })
  return response.data
}

export async function confirmStoreEmailVerification(input: VendorStoreEmailConfirmation): Promise<VendorOnboardingSnapshot> {
  const response = await onboardingApi().confirmVendorStoreEmailVerification({ vendorStoreEmailConfirmation: input })
  return response.data
}

export async function uploadVendorDocument(requirementKey: string, file: Blob, metadata: Record<string, string> = {}) {
  const response = await onboardingApi().uploadVendorVerificationDocument({
    requirementKey: requirementKey as UploadVendorVerificationDocumentRequirementKeyEnum,
    file,
    metadata,
  })
  return response.data
}

export async function uploadVendorMedia(kind: 'LOGO' | 'BANNER' | 'PROMOTIONAL_IMAGE' | 'PROMOTIONAL_VIDEO', file: Blob, altText?: string) {
  const response = await onboardingApi().uploadVendorStoreMedia({ kind, file, altText: altText ?? null })
  return response.data
}

export async function captureVendorPaymentConnection(input: VendorPaymentConnection) {
  const response = await onboardingApi().captureVendorPaymentConnection({ idempotencyKey: newIdempotencyKey(), vendorPaymentConnection: input })
  return response.data
}

export async function reconcileVendorPaymentConnection() {
  const response = await onboardingApi().reconcileVendorPaymentConnection()
  return response.data
}

export async function activateVendorStore(): Promise<VendorOnboardingSnapshot> {
  const response = await onboardingApi().activateVendorStore({ idempotencyKey: newIdempotencyKey() })
  return response.data
}

export async function getVendorPrivateFileUrl(fileId: string) {
  const response = await onboardingApi().getVendorPrivateFileUrl({ fileId })
  return response.data
}

export async function inviteVendorTeamMember(input: VendorInvitationRequest) {
  const response = await onboardingApi().inviteVendorTeamMember({ idempotencyKey: newIdempotencyKey(), vendorInvitationRequest: input })
  return response.data
}

export async function readableOnboardingError(error: unknown): Promise<string> {
  if (error instanceof ResponseError) {
    if (error.response.status === 429 && error.response.headers.has('Retry-After')) return rateLimitMessage(error.response)
    const payload: unknown = await error.response.clone().json().catch(() => null)
    const first = firstApiError(payload)
    if (error.response.status === 401) return first?.code === 'OTP_INVALID_OR_EXPIRED' ? (first.message ?? 'The code is invalid or expired.') : 'Your session has expired. Sign in again to continue.'
    if (typeof first?.message === 'string') {
      const details = first.details
      if (details && typeof details === 'object') {
        const values = details as Record<string, unknown>
        const blockers = Array.isArray(values.blockers) ? values.blockers : []
        const messages = blockers.flatMap((blocker: unknown) => {
          if (!blocker || typeof blocker !== 'object') return []
          const item = blocker as Record<string, unknown>
          return typeof item.key === 'string' && typeof item.reason === 'string' ? [`${item.key.replace(/[_.]/g, ' ')}: ${item.reason}`] : []
        })
        if (messages.length) return `${first.message} ${messages.join(' ')}`
        const fields = Object.values(values).flatMap(value => Array.isArray(value) ? value.filter((message): message is string => typeof message === 'string') : [])
        if (fields.length) return `${first.message} ${fields.join(' ')}`
      }
      return first.message
    }
  }
  return error instanceof Error ? error.message : 'The request could not be completed. Check your connection and try again.'
}

function firstApiError(value: unknown): { code?: string; message?: string; details?: unknown } | null {
  if (typeof value !== 'object' || value === null || !('errors' in value) || !Array.isArray(value.errors)) return null
  const first: unknown = value.errors[0]
  if (typeof first !== 'object' || first === null) return null
  const record = first as Record<string, unknown>
  const result: { code?: string; message?: string; details?: unknown } = {}
  if (typeof record.code === 'string') result.code = record.code
  if (typeof record.message === 'string') result.message = record.message
  result.details = record.details
  return result
}
