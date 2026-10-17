import { rateLimitMessage, webRequestErrorMessage } from '@materyalph/web-ui'
import {
  AccountType,
  AccountsApi,
  AuthenticationApi,
  ResponseError,
  type VendorBotProtectionEvidence,
  type RegisterRequest,
  type VendorInvitationAcceptance,
} from '@materyalph/api-client-ts'
import { clearWebSessionTransport, createWebApiConfiguration } from '@materyalph/web-ui'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

export async function withWebAuthApi<T>(operation: (api: AuthenticationApi) => Promise<T>): Promise<T> {
  return operation(new AuthenticationApi(createWebApiConfiguration(basePath)))
}

export { asBotStepUpRequired, BotStepUpRequired, type RiskChallenge } from '@materyalph/web-ui'

export type ValidationFieldErrors = Readonly<Record<string, readonly string[]>>

export type ValidationFailure = {
  message: string
  fieldErrors: ValidationFieldErrors
}

export async function signIn(email: string, password: string, botProtection?: VendorBotProtectionEvidence) {
  return withWebAuthApi((api) => api.login({
    loginRequest: { email, password, portal: AccountType.Vendor, botProtection: botProtection ?? null },
  }))
}

export function getMfaStatus() {
  return new AuthenticationApi(createWebApiConfiguration(basePath)).getMfaChallengeStatus()
}

export function getSession() {
  return new AuthenticationApi(createWebApiConfiguration(basePath, { refreshSession: true })).getSession()
}

export async function signOut() {
  const result = await withWebAuthApi((api) => api.logout())
  clearWebSessionTransport(basePath)
  return result
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
    passwordRecoveryRequest: {
      email,
      portal: AccountType.Vendor,
      botProtection: botProtection ?? null,
    },
  }))
}

export function verifyRiskChallenge(challengeId: string, email: string, code: string) {
  return withWebAuthApi((api) => api.verifyWebBotChallenge({
    challengeId,
    webVerifyBotChallengeRequest: { email, code },
  }))
}

export function resendRiskChallenge(challengeId: string, email: string) {
  return withWebAuthApi((api) => api.resendWebBotChallenge({
    challengeId,
    webResendBotChallengeRequest: { email },
  }))
}

export function resetPassword(email: string, code: string, password: string, passwordConfirmation: string) {
  return withWebAuthApi((api) => api.resetPassword({ passwordResetRequest: { email, code, password, passwordConfirmation } }))
}

export function verifyVendorEmail(email: string, code: string) {
  return withWebAuthApi((api) => api.verifyEmail({ verifyEmailRequest: { email, code } }))
}

export function resendVendorVerification(email: string) {
  return withWebAuthApi((api) => api.resendEmailVerification({ emailRequest: { email } }))
}

export async function startGoogleRegistration(input: { mobileE164: string }) {
  const response = await withWebAuthApi((api) => api.startGoogleOidc({
    googleOidcStartRequest: {
      portal: AccountType.Vendor,
      mode: 'SIGN_UP',
      mobileE164: input.mobileE164,
      termsAccepted: true,
      privacyAccepted: true,
    },
  }))
  const authorizationUrl = response.data.authorization_url
  if (typeof authorizationUrl !== 'string') throw new Error('Google registration did not return a destination.')
  window.location.assign(authorizationUrl)
}

export async function registerVendor(request: Omit<RegisterRequest, 'botProtection'>, botProtection?: VendorBotProtectionEvidence) {
  return withWebAuthApi((api) => api.registerAccount({
    registerRequest: { ...request, botProtection: botProtection ?? null },
  }))
}

export function acceptVendorStaffInvitation(request: Omit<VendorInvitationAcceptance, 'botProtection'>, botProtection: VendorBotProtectionEvidence) {
  return new AccountsApi(createWebApiConfiguration(basePath)).acceptVendorStaffInvitation({
    vendorInvitationAcceptance: { ...request, botProtection },
  })
}

export async function startGoogleSignIn() {
  const response = await withWebAuthApi((api) => api.startGoogleOidc({
    googleOidcStartRequest: { portal: AccountType.Vendor, mode: 'SIGN_IN' },
  }))
  const authorizationUrl = response.data.authorization_url
  if (typeof authorizationUrl !== 'string') throw new Error('Google sign-in did not return a destination.')
  window.location.assign(authorizationUrl)
}

export async function readableApiError(error: unknown): Promise<string> {
  const transportMessage = webRequestErrorMessage(error)
  if (transportMessage) return transportMessage
  if (error instanceof ResponseError) {
    if (error.response.status === 429 && error.response.headers.has('Retry-After')) return rateLimitMessage(error.response)
    const payload: unknown = await error.response.clone().json().catch(() => null)
    const first = firstApiError(payload)
    if (error.response.status === 401) {
      if (first && typeof first.message === 'string' && ['MFA_CODE_INVALID', 'MFA_RECOVERY_CODE_INVALID', 'UNAUTHENTICATED'].includes(String(first.code))) return first.message
      return 'Your session has expired. Sign in again to continue.'
    }
    if (first && typeof first.message === 'string') return first.message
  }
  if (error instanceof Error) return error.message
  return 'The request could not be completed. Check your connection and try again.'
}

export async function asValidationFailure(error: unknown): Promise<ValidationFailure | null> {
  if (!(error instanceof ResponseError) || error.response.status !== 422) return null
  const payload: unknown = await error.response.clone().json().catch(() => null)
  const first = firstApiError(payload)
  if (!first || first.code !== 'VALIDATION_FAILED' || typeof first.message !== 'string') return null

  return {
    message: first.message,
    fieldErrors: safeValidationFieldErrors(first.details),
  }
}

function isApiErrorEnvelope(value: unknown): value is { errors: Array<{ message: string }> } {
  return typeof value === 'object' && value !== null && 'errors' in value && Array.isArray(value.errors)
}

function firstApiError(value: unknown): { code?: unknown; message?: unknown; details?: unknown } | null {
  if (!isApiErrorEnvelope(value)) return null
  const first: unknown = value.errors[0]
  return typeof first === 'object' && first !== null ? first : null
}

function safeValidationFieldErrors(details: unknown): ValidationFieldErrors {
  if (typeof details !== 'object' || details === null || Array.isArray(details)) return {}

  const fieldErrors: Record<string, readonly string[]> = Object.create(null) as Record<string, readonly string[]>
  for (const [field, value] of Object.entries(details)) {
    if (!/^[A-Za-z0-9_.-]{1,128}$/.test(field) || !Array.isArray(value)) continue
    const messages = value.filter((message): message is string => typeof message === 'string' && message.trim() !== '')
    if (messages.length > 0) fieldErrors[field] = messages
  }

  return fieldErrors
}

