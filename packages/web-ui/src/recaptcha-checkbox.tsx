import { forwardRef, useEffect, useImperativeHandle, useRef, useState } from 'react'
import './bot-protection.css'

import {
  RecaptchaRenderCancelledError,
  renderWebCheckbox,
  type EnterpriseCheckboxHandle,
  type WebBotAction,
} from './recaptcha-enterprise'

export type RecaptchaCheckboxRef = {
  reset(): void
}

export type RecaptchaCheckboxProps = {
  siteKey: string | undefined
  action: WebBotAction
  disabled?: boolean
  id?: string
  onTokenChange(token: string | null): void
  validationError?: string
}

export const RecaptchaCheckbox = forwardRef<RecaptchaCheckboxRef, RecaptchaCheckboxProps>(
  function RecaptchaCheckbox({ siteKey, action, disabled = false, id, onTokenChange, validationError }, ref) {
    const hostRef = useRef<HTMLDivElement>(null)
    const handleRef = useRef<EnterpriseCheckboxHandle | null>(null)
    const onTokenChangeRef = useRef(onTokenChange)
    const [message, setMessage] = useState('Complete the security checkbox to continue.')

    useEffect(() => {
      onTokenChangeRef.current = onTokenChange
    }, [onTokenChange])

    useImperativeHandle(ref, () => ({
      reset() {
        handleRef.current?.reset()
      },
    }), [])

    useEffect(() => {
      let active = true
      const abortController = new AbortController()
      const host = hostRef.current
      if (!host) return
      const container = document.createElement('div')
      host.replaceChildren(container)

      onTokenChangeRef.current(null)
      void renderWebCheckbox(container, siteKey, action, {
        onToken(token) {
          if (!active) return
          onTokenChangeRef.current(token)
          setMessage(token ? 'Security checkbox completed.' : 'Complete the security checkbox to continue.')
        },
        onError(error) {
          if (!active) return
          onTokenChangeRef.current(null)
          setMessage(error)
        },
      }, abortController.signal).then((handle) => {
        if (!active) {
          handle.reset()
          return
        }
        handleRef.current = handle
      }).catch((error: unknown) => {
        if (!active || error instanceof RecaptchaRenderCancelledError) return
        onTokenChangeRef.current(null)
        setMessage(error instanceof Error ? error.message : 'The security checkbox could not be loaded.')
      })

      return () => {
        active = false
        abortController.abort()
        handleRef.current?.reset()
        handleRef.current = null
        if (host.contains(container)) host.replaceChildren()
      }
    }, [action, siteKey])

    return (
      <div
        aria-describedby={validationError && id ? `${id}-error` : undefined}
        aria-disabled={disabled || undefined}
        aria-invalid={validationError ? true : undefined}
        className="recaptcha-checkbox"
        id={id}
        tabIndex={validationError ? -1 : undefined}
      >
        <div ref={hostRef} />
        <p className="recaptcha-notice" aria-live="polite">{message}</p>
        {validationError && id && <p className="text-sm text-status-error" id={`${id}-error`} role="alert">{validationError}</p>}
      </div>
    )
  },
)
