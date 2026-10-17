import { ResponseError, type VendorBotProtectionEvidence } from '@materyalph/api-client-ts'
import { useRef, useState } from 'react'
import { webBotEvidence, webCookieBotEvidence } from './recaptcha-enterprise'
import type { RecaptchaCheckboxRef } from './recaptcha-checkbox'

export type RiskChallenge = { id: string; expiresAt: string; resendAfterSeconds: number }

export class BotStepUpRequired extends Error {
  constructor(public readonly challenge: RiskChallenge) {
    super('Email risk verification is required.')
    this.name = 'BotStepUpRequired'
  }
}

export async function asBotStepUpRequired(error: unknown): Promise<BotStepUpRequired | null> {
  if (!(error instanceof ResponseError) || error.response.status !== 403) return null
  const payload: unknown = await error.response.clone().json().catch(() => null)
  if (typeof payload !== 'object' || payload === null || !('errors' in payload) || !Array.isArray(payload.errors)) return null
  const first: unknown = payload.errors[0]
  if (typeof first !== 'object' || first === null || !('code' in first) || first.code !== 'BOT_STEP_UP_REQUIRED' || !('details' in first)) return null
  const details = first.details
  if (typeof details !== 'object' || details === null || !('challenge_id' in details) || !('expires_at' in details) || !('resend_after_seconds' in details)) return null
  const { challenge_id: id, expires_at: expiresAt, resend_after_seconds: resendAfterSeconds } = details
  if (typeof id !== 'string' || typeof expiresAt !== 'string' || typeof resendAfterSeconds !== 'number' || !Number.isFinite(resendAfterSeconds) || resendAfterSeconds < 0) return null
  return new BotStepUpRequired({ id, expiresAt, resendAfterSeconds })
}

type ProtectedOperation = (evidence: VendorBotProtectionEvidence) => Promise<void>

export function useWebBotProtection(readableError: (error: unknown) => Promise<string>) {
  const checkboxRef = useRef<RecaptchaCheckboxRef>(null)
  const [token, setToken] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [stepUp, setStepUp] = useState<{ email: string; challenge: RiskChallenge } | null>(null)
  const pending = useRef<ProtectedOperation | null>(null)

  async function perform(email: string, operation: ProtectedOperation, evidence: () => VendorBotProtectionEvidence) {
    setBusy(true)
    setMessage(null)
    try {
      await operation(evidence())
      pending.current = null
      setStepUp(null)
    } catch (error) {
      const required = await asBotStepUpRequired(error)
      if (required) {
        pending.current = operation
        setStepUp({ email, challenge: required.challenge })
      } else {
        setMessage(await readableError(error))
      }
    } finally {
      checkboxRef.current?.reset()
      setToken(null)
      setBusy(false)
    }
  }

  return {
    checkboxRef, token, setToken, busy, message, stepUp,
    run(email: string, operation: ProtectedOperation, accessibleFallback = false) {
      return perform(email, operation, () => webBotEvidence(token, accessibleFallback))
    },
    async retry() {
      if (stepUp && pending.current) await perform(stepUp.email, pending.current, webCookieBotEvidence)
    },
    cancel() {
      pending.current = null
      setStepUp(null)
      setMessage(null)
      checkboxRef.current?.reset()
      setToken(null)
    },
  }
}
