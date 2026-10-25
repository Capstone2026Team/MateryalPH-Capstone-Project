import { rateLimitMessage, webRequestErrorMessage } from '@materyalph/web-ui'
import { AccountType, AuthenticationApi, ResponseError, type VendorBotProtectionEvidence } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from '@materyalph/web-ui'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

async function withWebAuthApi<T>(operation: (api: AuthenticationApi) => Promise<T>): Promise<T> {
  return operation(new AuthenticationApi(createWebApiConfiguration(basePath)))
}

export function signInAdmin(email: string, password: string, botProtection?: VendorBotProtectionEvidence) {
  return withWebAuthApi((api) => api.login({ loginRequest: { email, password, portal: AccountType.Admin, botProtection: botProtection ?? null } }))
}

export function acceptAdminInvitation(input: { token: string; email?: string; fullName: string; password: string; passwordConfirmation: string }, botProtection?: VendorBotProtectionEvidence) {
  return withWebAuthApi((api) => api.acceptAdminInvitation({ adminInvitationRequest: { ...input, botProtection: botProtection ?? null, termsAccepted: true, privacyAccepted: true } }))
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

export function requestPasswordRecovery(email: string, botProtection?: VendorBotProtectionEvidence) {
  return withWebAuthApi((api) => api.requestPasswordRecovery({
    passwordRecoveryRequest: { email, portal: AccountType.Admin, botProtection: botProtection ?? null },
  }))
}

export function verifyRiskChallenge(challengeId: string, email: string, code: string) {
  return withWebAuthApi((api) => api.verifyWebBotChallenge({
    challengeId, webVerifyBotChallengeRequest: { email, code, portal: 'ADMIN' },
  }))
}

export function resendRiskChallenge(challengeId: string, email: string) {
  return withWebAuthApi((api) => api.resendWebBotChallenge({
    challengeId, webResendBotChallengeRequest: { email, portal: 'ADMIN' },
  }))
}

export function resetPassword(email: string, code: string, password: string, passwordConfirmation: string) {
  return withWebAuthApi((api) => api.resetPassword({ passwordResetRequest: { email, code, password, passwordConfirmation } }))
}

export function verifyPasswordRecovery(input: { email: string; code?: string; recoveryCode?: string; challengeId?: string }) {
  return withWebAuthApi(api => api.verifyWebPasswordRecovery({ verifyWebPasswordRecoveryRequest: { ...input, portal: 'ADMIN' } }))
}

export function completePasswordRecovery(email: string, password: string, passwordConfirmation: string) {
  return withWebAuthApi(api => api.completeWebPasswordRecovery({ completeWebPasswordRecoveryRequest: { email, password, passwordConfirmation, portal: 'ADMIN' } }))
}

export async function readableApiError(error: unknown): Promise<string> {
  const transportMessage = webRequestErrorMessage(error)
  if (transportMessage) return transportMessage
  if (error instanceof ResponseError) {
    if (error.response.status === 429 && error.response.headers.has('Retry-After')) return rateLimitMessage(error.response)
    const payload: unknown = await error.response.clone().json().catch(() => null)
    if (typeof payload === 'object' && payload !== null && 'errors' in payload && Array.isArray(payload.errors)) {
      const first = payload.errors[0] as { code?: unknown; message?: unknown } | undefined
      if (typeof first?.message === 'string' && (error.response.status !== 401 || ['INVALID_CREDENTIALS', 'MFA_CODE_INVALID', 'MFA_RECOVERY_CODE_INVALID', 'UNAUTHENTICATED'].includes(String(first.code)))) return first.message
    }
    if (error.response.status === 401) return 'Your session has expired. Sign in again to continue.'
  }
  return error instanceof Error ? error.message : 'The request could not be completed. Check your connection and try again.'
}
