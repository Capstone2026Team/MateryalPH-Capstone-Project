import type { ReactNode } from 'react'

import { Button } from './button'
import './bot-protection.css'

export function BotProtectionFields({ checkbox, children, disabled = false, emailCheckSelected, onEmailCheckClick, submitEmailCheck = false }: {
  checkbox: ReactNode
  children: ReactNode
  disabled?: boolean
  emailCheckSelected?: boolean
  onEmailCheckClick?: () => void
  submitEmailCheck?: boolean
}) {
  return <div className="bot-protection-fields">
    {checkbox}
    {children}
    <Button className="w-full" variant="quiet" disabled={disabled} type={submitEmailCheck ? 'submit' : 'button'} data-email-check={submitEmailCheck ? 'true' : undefined} aria-pressed={emailCheckSelected} onClick={onEmailCheckClick}>
      {emailCheckSelected ? 'Use the security checkbox instead' : 'Use an email security check instead'}
    </Button>
  </div>
}
