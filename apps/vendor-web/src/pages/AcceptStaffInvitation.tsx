import type { VendorInvitationAcceptance } from '@materyalph/api-client-ts'
import { Button, Field, PasswordField, StatusMessage } from '@materyalph/web-ui'
import { ArrowRight } from 'lucide-react'
import { useEffect, useRef, useState, type FormEvent } from 'react'
import { Link, useSearchParams } from 'react-router-dom'
import { RiskOtpPanel } from '../components/auth/RiskOtpPanel'
import { VendorAuthShell } from '../components/auth/VendorAuthShell'
import { VendorRecaptchaCheckbox, type VendorRecaptchaCheckboxRef } from '../components/auth/VendorRecaptchaCheckbox'
import { acceptVendorStaffInvitation, asBotStepUpRequired, asValidationFailure, readableApiError, type RiskChallenge } from '../lib/auth-api'
import { vendorBotEvidence, webCookieBotEvidence } from '../lib/recaptcha-enterprise'

type InvitationDetails = Omit<VendorInvitationAcceptance, 'botProtection'>

export function AcceptStaffInvitation() {
  const [params] = useSearchParams()
  const [token, setToken] = useState(() => params.get('token') ?? '')
  const [busy, setBusy] = useState(false)
  const [complete, setComplete] = useState(false)
  const [acceptedEmail, setAcceptedEmail] = useState('')
  const [message, setMessage] = useState<string | null>(null)
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({})
  const [useEmailCheck, setUseEmailCheck] = useState(false)
  const [captchaToken, setCaptchaToken] = useState<string | null>(null)
  const [challenge, setChallenge] = useState<RiskChallenge | null>(null)
  const [pending, setPending] = useState<InvitationDetails | null>(null)
  const captchaRef = useRef<VendorRecaptchaCheckboxRef>(null)
  const formRef = useRef<HTMLFormElement>(null)

  useEffect(() => { window.history.replaceState(null, '', window.location.pathname) }, [])

  function clearFieldErrors(...fields: string[]) {
    setFieldErrors(previous => {
      if (!fields.some(field => previous[field])) return previous
      const next = { ...previous }
      fields.forEach(field => delete next[field])
      return next
    })
  }

  async function attempt(details: InvitationDetails, verified = false) {
    const evidence = verified ? webCookieBotEvidence() : vendorBotEvidence(captchaToken, useEmailCheck)
    await acceptVendorStaffInvitation(details, evidence)
    setAcceptedEmail(details.email.trim())
    formRef.current?.reset()
    setPending(null)
    setChallenge(null)
    setCaptchaToken(null)
    setToken('')
    setComplete(true)
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (busy) return
    const data = new FormData(event.currentTarget)
    if (data.get('password') !== data.get('confirmation')) {
      setFieldErrors({ confirmation: 'Passwords do not match.' })
      setMessage('Review the highlighted fields and try again.')
      return
    }
    const details: InvitationDetails = {
      token,
      email: String(data.get('email')).trim(),
      fullName: String(data.get('name')),
      password: String(data.get('password')),
      passwordConfirmation: String(data.get('confirmation')),
    }
    setBusy(true)
    setMessage(null)
    setFieldErrors({})
    setPending(details)
    try {
      await attempt(details)
    } catch (error) {
      const stepUp = await asBotStepUpRequired(error)
      if (stepUp) {
        setChallenge(stepUp.challenge)
      } else {
        setPending(null)
        const validation = await asValidationFailure(error)
        if (validation) {
          setFieldErrors({
            email: validation.fieldErrors.email?.[0] ?? '',
            name: validation.fieldErrors.full_name?.[0] ?? '',
            password: validation.fieldErrors.password?.[0] ?? '',
            confirmation: validation.fieldErrors.password_confirmation?.[0] ?? '',
            bot: validation.fieldErrors.bot_protection?.[0] ?? validation.fieldErrors['bot_protection.recaptcha_token']?.[0] ?? '',
          })
          setMessage(validation.message)
        } else {
          setMessage(await readableApiError(error))
        }
      }
    } finally {
      captchaRef.current?.reset()
      setBusy(false)
    }
  }

  return <VendorAuthShell
    scrollPanel
    title={complete ? 'Your invitation is accepted' : 'Accept your staff invitation'}
    description={complete ? 'Complete email verification to securely access your team account.' : 'Create or connect your individual account. Your invitation assigns one fixed role in the inviting store.'}
    storyDescription="Join your store’s team with your own account and securely access the tools for your role."
  >
    {complete ? <div className="grid gap-5">
      <StatusMessage tone="success">Invitation accepted. If your account is unverified, check your inbox for the verification code.</StatusMessage>
      <div className="grid gap-3">
        <Link className="button button--primary w-full" to="/verify-email" state={{ email: acceptedEmail }}>Verify email <ArrowRight size={18} aria-hidden="true" /></Link>
        <Link className="auth-cancel" to="/login">Already verified? Continue to sign in</Link>
      </div>
    </div> : token ? <>
      {challenge && pending && <RiskOtpPanel challenge={challenge} email={pending.email} onCancel={() => { setChallenge(null); setPending(null) }} onVerified={() => attempt(pending, true)} />}
      <form ref={formRef} hidden={Boolean(challenge)} className={challenge ? 'hidden' : 'auth-form'} onSubmit={submit}>
        {message && <StatusMessage tone="error">{message}</StatusMessage>}
        <Field label="Invited email" name="email" type="email" autoComplete="email" error={fieldErrors.email ?? ''} onChange={() => clearFieldErrors('email')} required />
        <Field label="Full name" name="name" autoComplete="name" maxLength={160} error={fieldErrors.name ?? ''} onChange={() => clearFieldErrors('name')} required />
        <PasswordField label="Password" name="password" autoComplete="new-password" minLength={14} note="Already have a Vendor account? Enter your current password instead. The requirements below apply to new accounts." error={fieldErrors.password ?? ''} onChange={() => clearFieldErrors('password')} required />
        <Field label="Confirm password" name="confirmation" type="password" autoComplete="new-password" error={fieldErrors.confirmation ?? ''} onChange={() => clearFieldErrors('confirmation')} required />
        <div className="grid gap-3 border-t border-border-default pt-5">
          {!useEmailCheck && <VendorRecaptchaCheckbox ref={captchaRef} action="vendor_invitation_accept" disabled={busy} id="vendor-invitation-captcha" validationError={fieldErrors.bot ?? ''} onTokenChange={value => { setCaptchaToken(value); if (value) clearFieldErrors('bot') }} />}
          <button className="accessible-fallback" type="button" disabled={busy} aria-pressed={useEmailCheck} onClick={() => { captchaRef.current?.reset(); clearFieldErrors('bot'); setUseEmailCheck(value => !value) }}>{useEmailCheck ? 'Use the security checkbox instead' : 'Use an email security check instead'}</button>
          <Button className="w-full" type="submit" disabled={busy}>{busy ? 'Accepting…' : 'Accept invitation'}</Button>
        </div>
        <p className="text-sm leading-relaxed text-text-secondary">Privileged roles require authenticator enrollment after signing in.</p>
      </form>
    </> : <StatusMessage tone="error">Open the complete invitation link from your email.</StatusMessage>}
  </VendorAuthShell>
}
