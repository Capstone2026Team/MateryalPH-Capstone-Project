import { AuthenticatorCodeField } from './authenticator-code-field'
import { Button } from './button'
import { StatusMessage } from './status-message'
import './bot-protection.css'
import { ShieldCheck } from 'lucide-react'
import { type FormEvent, useEffect, useState } from 'react'

import type { RiskChallenge } from './web-bot-protection'

export function EmailSecurityCheck({
  challenge,
  email,
  verifyRiskChallenge,
  resendRiskChallenge,
  readableApiError,
  onVerified,
  onCancel,
}: {
  challenge: RiskChallenge
  email: string
  verifyRiskChallenge: (challengeId: string, email: string, code: string) => Promise<unknown>
  resendRiskChallenge: (challengeId: string, email: string) => Promise<unknown>
  readableApiError: (error: unknown) => Promise<string>
  onVerified: () => Promise<void>
  onCancel: () => void
}) {
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [resendIn, setResendIn] = useState(challenge.resendAfterSeconds)

  useEffect(() => {
    if (resendIn <= 0) return
    const timer = window.setInterval(() => setResendIn((value) => Math.max(0, value - 1)), 1000)
    return () => window.clearInterval(timer)
  }, [resendIn])

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setBusy(true)
    setMessage(null)
    const code = String(new FormData(event.currentTarget).get('risk_code'))
    try {
      await verifyRiskChallenge(challenge.id, email, code)
      await onVerified()
    } catch (error) {
      setMessage(await readableApiError(error))
    } finally {
      setBusy(false)
    }
  }

  async function resend() {
    setBusy(true)
    setMessage(null)
    try {
      await resendRiskChallenge(challenge.id, email)
      setResendIn(challenge.resendAfterSeconds)
      setMessage('A new risk-verification code is being delivered. The previous code no longer works.')
    } catch (error) {
      setMessage(await readableApiError(error))
    } finally {
      setBusy(false)
    }
  }

  return (
    <form className="auth-form risk-step-up" onSubmit={submit} aria-labelledby="risk-step-up-title">
      <div className="risk-step-up__heading">
        <ShieldCheck aria-hidden="true" />
        <div>
          <h3 id="risk-step-up-title">Confirm this request</h3>
          <p>This is a security check, separate from account email verification or a password-reset code.</p>
        </div>
      </div>
      <StatusMessage>A six-digit risk-verification code is being delivered to {maskEmail(email)}.</StatusMessage>
      {message && <StatusMessage tone="error">{message}</StatusMessage>}
      <AuthenticatorCodeField
        label="Risk-verification code"
        name="risk_code"
        hint="Enter the security code from your email, or paste all 6 digits."
        required
        disabled={busy}
        autoFocus
      />
      <Button className="w-full" type="submit" disabled={busy}>{busy ? 'Verifying…' : 'Verify and continue'}</Button>
      <Button className="w-full" variant="quiet" onClick={() => void resend()} disabled={busy || resendIn > 0}>
        {resendIn > 0 ? `Request another code in ${resendIn}s` : 'Request another code'}
      </Button>
      <Button className="w-full" variant="quiet" onClick={onCancel} disabled={busy}>Cancel security check</Button>
    </form>
  )
}

function maskEmail(email: string): string {
  const [local, domain] = email.split('@')
  if (!local || !domain) return 'your email address'
  return `${local.slice(0, 1)}${'•'.repeat(Math.min(4, Math.max(1, local.length - 1)))}@${domain}`
}
