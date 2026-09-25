import { AccountsApi, AuthenticationApi, Configuration } from '@materyalph/api-client-ts'
import { Button, Field, StatusMessage } from '@materyalph/web-ui'
import { useEffect, useState, type FormEvent } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { VendorAuthShell } from '../components/auth/VendorAuthShell'
import { asValidationFailure, readableApiError } from '../lib/auth-api'

export function AcceptStaffInvitation() {
  const [params] = useSearchParams()
  const [token] = useState(() => params.get('token') ?? '')
  const [busy, setBusy] = useState(false)
  const [complete, setComplete] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({})
  useEffect(() => { window.history.replaceState(null, '', window.location.pathname) }, [])
  function clearFieldError(field: string) {
    setFieldErrors(previous => {
      if (!previous[field]) return previous
      const next = { ...previous }
      delete next[field]
      return next
    })
  }
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const form = event.currentTarget
    const data = new FormData(form)
    if (data.get('password') !== data.get('confirmation')) {
      setFieldErrors({ confirmation: 'Passwords do not match.' })
      setMessage('Review the highlighted fields and try again.')
      return
    }
    setBusy(true); setMessage(null); setFieldErrors({})
    try {
      const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
      const csrf = await new AuthenticationApi(new Configuration({basePath,credentials:'include'})).issueWebCsrfToken()
      await new AccountsApi(new Configuration({basePath,credentials:'include',apiKey:csrf.data.csrfToken})).acceptVendorStaffInvitation({vendorInvitationAcceptance:{token,email:String(data.get('email')),fullName:String(data.get('name')),password:String(data.get('password')),passwordConfirmation:String(data.get('confirmation'))}})
      form.reset();setComplete(true)
    } catch(error) {
      const validation = await asValidationFailure(error)
      if (validation) {
        setFieldErrors({
          email: validation.fieldErrors.email?.[0] ?? '',
          name: validation.fieldErrors.full_name?.[0] ?? '',
          password: validation.fieldErrors.password?.[0] ?? '',
          confirmation: validation.fieldErrors.password_confirmation?.[0] ?? '',
        })
        setMessage(validation.message)
      } else {
        setMessage(await readableApiError(error))
      }
    }
    finally { setBusy(false) }
  }
  return <VendorAuthShell title="Accept your staff invitation" description="Your invitation assigns one fixed role in the inviting store. Privileged roles require authenticator enrollment.">{message&&<StatusMessage tone="error">{message}</StatusMessage>}{complete?<><StatusMessage tone="success">Invitation accepted. New accounts must verify their email before signing in.</StatusMessage><Link to="/verify-email">Verify email</Link><Link to="/login">Continue to sign in</Link></>:token?<form className="auth-form" onSubmit={submit}><Field label="Invited email" name="email" type="email" error={fieldErrors.email ?? ''} onChange={() => clearFieldError('email')} required/><Field label="Full name" name="name" autoComplete="name" maxLength={160} error={fieldErrors.name ?? ''} onChange={() => clearFieldError('name')} required/><Field label="Password" name="password" type="password" autoComplete="new-password" hint="Use your current password if you already have an eligible Vendor identity. New passwords need at least 14 characters, uppercase and lowercase letters, and a number." error={fieldErrors.password ?? ''} onChange={() => clearFieldError('password')} required/><Field label="Confirm password" name="confirmation" type="password" autoComplete="new-password" error={fieldErrors.confirmation ?? ''} onChange={() => clearFieldError('confirmation')} required/><Button type="submit" disabled={busy}>{busy?'Accepting…':'Accept invitation'}</Button></form>:<StatusMessage tone="error">Open the complete invitation link from your email.</StatusMessage>}</VendorAuthShell>
}
