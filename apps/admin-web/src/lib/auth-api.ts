import { AccountType, AuthenticationApi, ResponseError } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

async function withWebAuthApi<T>(operation: (api: AuthenticationApi) => Promise<T>): Promise<T> {
  return operation(new AuthenticationApi(createWebApiConfiguration(basePath)))
}

export function signInAdmin(email: string, password: string) {
  return withWebAuthApi((api) => api.login({ loginRequest: { email, password, portal: AccountType.Admin } }))
}

export function acceptAdminInvitation(input: { token: string; fullName: string; password: string; passwordConfirmation: string }) {
  return withWebAuthApi((api) => api.acceptAdminInvitation({ adminInvitationRequest: { ...input, termsAccepted: true, privacyAccepted: true } }))
}

export function getMfaStatus() {
  return new AuthenticationApi(createWebApiConfiguration(basePath)).getMfaChallengeStatus()
}

export function getSession() {
  return new AuthenticationApi(createWebApiConfiguration(basePath, { refreshSession: true })).getSession()
}

export function startMfaEnrollment() {
  return withWebAuthApi((api) => api.startMfaEnrollment())
}

export function confirmMfaEnrollment(code: string) {
  return withWebAuthApi((api) => api.confirmMfaEnrollment({ mfaCodeRequest: { code } }))
}

export function completeMfaChallenge(code: string) {
  return withWebAuthApi((api) => api.completeMfaChallenge({ mfaCodeRequest: { code } }))
}

export function recoverMfaChallenge(recoveryCode: string) {
  return withWebAuthApi((api) => api.recoverMfaChallenge({ mfaRecoveryRequest: { recoveryCode } }))
}

export function requestPasswordRecovery(email: string) {
  return withWebAuthApi((api) => api.requestPasswordRecovery({
    passwordRecoveryRequest: { email, portal: AccountType.Admin },
  }))
}

export function resetPassword(email: string, code: string, password: string, passwordConfirmation: string) {
  return withWebAuthApi((api) => api.resetPassword({ passwordResetRequest: { email, code, password, passwordConfirmation } }))
}

export async function readableApiError(error: unknown): Promise<string> {
  if (error instanceof ResponseError) {
    if (error.response.status === 429) return 'Too many requests were sent. Please wait a moment and try again.'
    const payload: unknown = await error.response.clone().json().catch(() => null)
    if (typeof payload === 'object' && payload !== null && 'errors' in payload && Array.isArray(payload.errors)) {
      const first = payload.errors[0] as { code?: unknown; message?: unknown } | undefined
      if (typeof first?.message === 'string' && (error.response.status !== 401 || ['MFA_CODE_INVALID', 'MFA_RECOVERY_CODE_INVALID', 'UNAUTHENTICATED'].includes(String(first.code)))) return first.message
    }
    if (error.response.status === 401) return 'Your session has expired. Sign in again to continue.'
  }
  return error instanceof Error ? error.message : 'The request could not be completed. Check your connection and try again.'
}
