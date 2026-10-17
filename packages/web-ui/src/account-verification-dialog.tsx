import { useCallback, useEffect, useId, useRef, useState, type FormEvent } from 'react'
import type { AccountsApi } from '@materyalph/api-client-ts'
import { Button } from './button'
import { Field } from './field'
import { AuthenticatorCodeField } from './authenticator-code-field'
import { FormDialog } from './form-dialog'
import { StatusMessage } from './status-message'

export type RequestAccountVerification = (title: string) => Promise<boolean>

/** Each call requires a new successful verification; canceling never authorizes a change. */
export function useAccountVerification({ api, portal, explainError, enabled = true }: {
  api: () => AccountsApi; portal: 'vendors' | 'admin'; explainError: (error: unknown) => Promise<string>; enabled?: boolean
}) {
  type Pending = { title: string; resolve: (verified: boolean) => void }
  const pending = useRef<Pending | null>(null)
  const [request, setRequest] = useState<Pending | null>(null)
  const verify = useCallback<RequestAccountVerification>(title => {
    if (!enabled || pending.current) return Promise.resolve(false)
    return new Promise(resolve => {
      const next = { title, resolve }
      pending.current = next
      setRequest(next)
    })
  }, [enabled])
  function finish(current: Pending, verified: boolean) {
    if (pending.current !== current) return
    pending.current = null
    setRequest(null)
    current.resolve(verified)
  }
  useEffect(() => {
    if (!enabled && pending.current) {
      pending.current.resolve(false)
      pending.current = null
      setRequest(null)
    }
  }, [enabled])
  useEffect(() => () => { pending.current?.resolve(false); pending.current = null }, [])
  return {
    verify,
    dialog: request && <AccountVerificationDialog api={api} portal={portal} title={request.title} explainError={explainError} onClose={() => finish(request, false)} onVerified={async () => finish(request, true)} />,
  }
}

export function AccountVerificationDialog({ api, portal, title, onClose, onVerified, explainError }: {
  api: () => AccountsApi; portal: 'vendors' | 'admin'; title: string
  onClose: () => void; onVerified: () => Promise<void>; explainError: (error: unknown) => Promise<string>
}) {
  const [totp, setTotp] = useState<boolean | null>(null)
  const [email, setEmail] = useState(false)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [retry, setRetry] = useState(0)
  const lock = useRef(false)
  const formId = useId()
  useEffect(() => {
    let current = true
    setError(null)
    void api().getAccountSecurity({ accountPortal: portal }).then(response => { if (current) setTotp(response.data.totpEnrolled) }).catch(async cause => { const text = await explainError(cause); if (current) setError(text) })
    return () => { current = false }
  }, [api, portal, explainError, retry])
  async function verify(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (lock.current || totp === null) return
    lock.current = true; setBusy(true); setError(null)
    const data = new FormData(event.currentTarget)
    event.currentTarget.reset()
    try {
      await api().reauthenticateAccount({ accountPortal: portal, accountReauthentication: totp ? { code: String(data.get('code')) } : email ? { emailCode: String(data.get('email_code')) } : { password: String(data.get('password')) } })
      await onVerified()
    } catch (cause) { setError(await explainError(cause)) }
    finally { lock.current = false; setBusy(false) }
  }
  return <FormDialog open size="small" title={title} description="Verify your identity to continue with this protected action." busy={busy} onClose={onClose} footer={<div className="flex flex-col-reverse gap-3 sm:flex-row sm:justify-end"><Button className="w-full sm:w-auto" variant="secondary" disabled={busy} onClick={onClose}>Cancel</Button><Button className="w-full sm:w-auto" type="submit" form={formId} disabled={busy || totp === null}>{busy ? 'Verifying…' : 'Verify and continue'}</Button></div>}>
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    {totp === null ? <div className="py-4">{error ? <Button variant="secondary" onClick={() => setRetry(value => value + 1)}>Retry security check</Button> : <p role="status">Loading verification options…</p>}</div> : <form id={formId} onSubmit={event => void verify(event)} className="space-y-4">
      {totp ? <AuthenticatorCodeField label="Authenticator code" name="code" disabled={busy} required /> : email ? <Field label="Current-email verification code" name="email_code" inputMode="numeric" pattern="[0-9]{6}" maxLength={6} autoComplete="one-time-code" required /> : <Field label="Current password" name="password" type="password" autoComplete="current-password" required />}
      {!totp && !email && <Button variant="quiet" disabled={busy} onClick={async () => { if (lock.current) return; lock.current = true; setBusy(true); setError(null); try { await api().sendAccountReauthenticationEmail({ accountPortal: portal }); setEmail(true) } catch (cause) { setError(await explainError(cause)) } finally { lock.current = false; setBusy(false) } }}>Send email verification instead</Button>}
    </form>}
  </FormDialog>
}
