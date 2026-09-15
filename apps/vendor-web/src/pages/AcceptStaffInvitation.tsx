import { AccountsApi, AuthenticationApi, Configuration } from '@materyalph/api-client-ts'
import { Button, Field, StatusMessage } from '@materyalph/web-ui'
import { useEffect, useState, type FormEvent } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { VendorAuthShell } from '../components/auth/VendorAuthShell'
import { readableApiError } from '../lib/auth-api'

export function AcceptStaffInvitation() {
  const [params] = useSearchParams()
  const [token] = useState(() => params.get('token') ?? '')
  const [busy, setBusy] = useState(false)
  const [complete, setComplete] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  useEffect(() => { window.history.replaceState(null, '', window.location.pathname) }, [])
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const form = event.currentTarget
    const data = new FormData(form)
    setBusy(true); setMessage(null)
    try {
      const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
      const csrf = await new AuthenticationApi(new Configuration({basePath,credentials:'include'})).issueWebCsrfToken()
      await new AccountsApi(new Configuration({basePath,credentials:'include',apiKey:csrf.data.csrfToken})).acceptVendorStaffInvitation({vendorInvitationAcceptance:{token,email:String(data.get('email')),fullName:String(data.get('name')),password:String(data.get('password')),passwordConfirmation:String(data.get('confirmation'))}})
      form.reset();setComplete(true)
    } catch(error) { setMessage(await readableApiError(error)) }
    finally { setBusy(false) }
  }
  return <VendorAuthShell title="Accept your staff invitation" description="Your invitation assigns one fixed role in the inviting store. Privileged roles require authenticator enrollment.">{message&&<StatusMessage tone="error">{message}</StatusMessage>}{complete?<><StatusMessage tone="success">Invitation accepted. New accounts must verify their email before signing in.</StatusMessage><Link to="/verify-email">Verify email</Link><Link to="/login">Continue to sign in</Link></>:token?<form className="auth-form" onSubmit={submit}><Field label="Invited email" name="email" type="email" required/><Field label="Full name" name="name" autoComplete="name" maxLength={160} required/><Field label="Password" name="password" type="password" minLength={14} autoComplete="new-password" hint="Use your current password if you already have an eligible Vendor identity." required/><Field label="Confirm password" name="confirmation" type="password" minLength={14} autoComplete="new-password" required/><Button type="submit" disabled={busy}>{busy?'Accepting…':'Accept invitation'}</Button></form>:<StatusMessage tone="error">Open the complete invitation link from your email.</StatusMessage>}</VendorAuthShell>
}
