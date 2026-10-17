import { EmailSecurityCheck } from '@materyalph/web-ui'
import type { ComponentProps } from 'react'
import { readableApiError, resendRiskChallenge, verifyRiskChallenge } from '../../lib/auth-api'

export function RiskOtpPanel(props: Omit<ComponentProps<typeof EmailSecurityCheck>, 'verifyRiskChallenge' | 'resendRiskChallenge' | 'readableApiError'>) {
  return <EmailSecurityCheck {...props} verifyRiskChallenge={verifyRiskChallenge} resendRiskChallenge={resendRiskChallenge} readableApiError={readableApiError} />
}
