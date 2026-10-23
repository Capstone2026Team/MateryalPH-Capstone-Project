import { BotProtectionFields, EmailSecurityCheck, RecaptchaCheckbox, type WebBotAction, type useWebBotProtection } from '@materyalph/web-ui'
import { readableApiError, resendRiskChallenge, verifyRiskChallenge } from '../lib/auth-api'
import type { ReactNode } from 'react'

type SecurityCheck = ReturnType<typeof useWebBotProtection>

export function AdminSecurityFields({ action, check, children }: {
  action: Extract<WebBotAction, `admin_${string}`>
  check: SecurityCheck
  children: ReactNode
}) {
  return <BotProtectionFields disabled={check.busy} submitEmailCheck checkbox={
    <RecaptchaCheckbox ref={check.checkboxRef} siteKey={import.meta.env.VITE_RECAPTCHA_SITE_KEY} action={action} disabled={check.busy} onTokenChange={check.setToken} />
  }>
    {children}
  </BotProtectionFields>
}

export function AdminEmailSecurityCheck({ check }: { check: SecurityCheck }) {
  if (!check.stepUp) return null
  return <EmailSecurityCheck key={check.stepUp.challenge.id} {...check.stepUp} onVerified={check.retry} onCancel={check.cancel}
    readableApiError={readableApiError} verifyRiskChallenge={verifyRiskChallenge} resendRiskChallenge={resendRiskChallenge} />
}
