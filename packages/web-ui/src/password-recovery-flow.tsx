import { ArrowLeft, ArrowRight, Check, KeyRound, Mail, ShieldCheck } from 'lucide-react'
import { type FormEvent, useEffect, useRef, useState } from 'react'
import type { VendorBotProtectionEvidence } from '@materyalph/api-client-ts'
import { AuthenticatorCodeField } from './authenticator-code-field'
import { Button } from './button'
import { Field } from './field'
import { PasswordField } from './password-field'
import { RecaptchaCheckbox } from './recaptcha-checkbox'
import { StatusMessage } from './status-message'
import { useWebBotProtection } from './web-bot-protection'
import './password-recovery-flow.css'

type Stage = 'method' | 'email' | 'code' | 'password' | 'saved'
type Method = 'email' | 'recovery'
type Verification = { email: string; code?: string; recoveryCode?: string; challengeId?: string }

export function PasswordRecoveryFlow({ portal, initialEmail = '', initialCodeEntry = false, requestCode, verifyIdentity, completePassword, resendSecurityCode, readableError, onDownloadCodes, onComplete, siteKey }: {
  portal: 'admin' | 'vendor'
  initialEmail?: string
  initialCodeEntry?: boolean
  siteKey: string | undefined
  requestCode: (email: string, evidence: VendorBotProtectionEvidence) => Promise<{ resendAfterSeconds: number; expiresIn: number }>
  verifyIdentity: (input: Verification) => Promise<{ expiresIn: number; recoveryCodes?: string[] | null }>
  completePassword: (email: string, password: string, confirmation: string) => Promise<unknown>
  resendSecurityCode: (challengeId: string, email: string) => Promise<unknown>
  readableError: (error: unknown) => Promise<string>
  onDownloadCodes: (codes: readonly string[]) => void
  onComplete: () => void
}) {
  const check = useWebBotProtection(readableError)
  const minPasswordLength = portal === 'admin' ? 14 : 12
  const [email, setEmail] = useState(initialEmail.trim())
  const [method, setMethod] = useState<Method>('email')
  const [stage, setStage] = useState<Stage>(initialCodeEntry ? initialEmail.trim() ? 'code' : 'email' : 'method')
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [notice, setNotice] = useState<string | null>(null)
  const [recoveryCodes, setRecoveryCodes] = useState<string[] | null>(null)
  const [requestedAt, setRequestedAt] = useState(0)
  const [resendAt, setResendAt] = useState(0)
  const [expiresAt, setExpiresAt] = useState<string | null>(null)
  const [now, setNow] = useState(Date.now)
  const heading = useRef<HTMLHeadingElement>(null)
  const verifyingSecurityCheck = check.stepUp !== null
  const currentStage = verifyingSecurityCheck ? 'code' : stage
  const working = busy || check.busy
  const resendDeadline = check.stepUp ? requestedAt + check.stepUp.challenge.resendAfterSeconds * 1000 : resendAt
  const resendIn = Math.max(0, Math.ceil((resendDeadline - now) / 1000))
  const codeExpiry = check.stepUp?.challenge.expiresAt ?? expiresAt
  const step = currentStage === 'password' || currentStage === 'saved' ? 2 : currentStage === 'code' ? 1 : 0

  useEffect(() => {
    heading.current?.focus()
  }, [currentStage, method])

  useEffect(() => {
    if (currentStage !== 'code' || method !== 'email') return
    const timer = window.setInterval(() => setNow(Date.now()), 1000)
    return () => window.clearInterval(timer)
  }, [currentStage, method])

  async function sendCode() {
    setMessage(null)
    setNotice(null)
    setRequestedAt(Date.now())
    await check.run(email, async evidence => {
      const result = await requestCode(email, evidence)
      setResendAt(Date.now() + result.resendAfterSeconds * 1000)
      setExpiresAt(new Date(Date.now() + result.expiresIn * 1000).toISOString())
      setStage('code')
    }, !check.token)
    setNow(Date.now())
  }

  function chooseRecovery() {
    check.cancel()
    setMessage(null)
    setNotice(null)
    setMethod('recovery')
    setStage(email ? 'code' : 'email')
  }

  async function submitEmail(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (method === 'recovery' || initialCodeEntry) setStage('code')
    else await sendCode()
  }

  async function verify(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const data = new FormData(event.currentTarget)
    setBusy(true)
    setMessage(null)
    setNotice(null)
    try {
      const result = await verifyIdentity(method === 'recovery'
        ? { email, recoveryCode: String(data.get('recovery_code')).trim() }
        : { email, code: String(data.get('code')), ...(check.stepUp ? { challengeId: check.stepUp.challenge.id } : {}) })
      setRecoveryCodes(result.recoveryCodes ?? null)
      setExpiresAt(new Date(Date.now() + result.expiresIn * 1000).toISOString())
      check.cancel()
      setStage('password')
    } catch (error) {
      setMessage(await readableError(error))
    } finally {
      setBusy(false)
    }
  }

  async function resend() {
    if (resendIn > 0 || working) return
    if (!check.stepUp) { await sendCode(); return }
    setBusy(true)
    setMessage(null)
    try {
      await resendSecurityCode(check.stepUp.challenge.id, email)
      setRequestedAt(Date.now())
      setNow(Date.now())
      setNotice('A new authentication code is being delivered. The previous code no longer works.')
    } catch (error) {
      setMessage(await readableError(error))
    } finally {
      setBusy(false)
    }
  }

  async function savePassword(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const data = new FormData(event.currentTarget)
    const password = String(data.get('password'))
    const confirmation = String(data.get('password_confirmation'))
    setMessage(null)
    if (password !== confirmation) { setMessage('The passwords do not match. Enter the same password in both fields.'); return }
    setBusy(true)
    try {
      await completePassword(email, password, confirmation)
      if (recoveryCodes) setStage('saved')
      else onComplete()
    } catch (error) {
      setMessage(await readableError(error))
    } finally {
      setBusy(false)
    }
  }

  function startOver() {
    check.cancel()
    setMessage(null)
    setNotice(null)
    setStage('method')
    setMethod('email')
  }

  const titles: Record<Stage, string> = {
    method: 'Choose a recovery method', email: 'Confirm your account email',
    code: method === 'recovery' ? 'Use a saved recovery code' : 'Check your email',
    password: 'Create a new password', saved: 'Save your new recovery codes',
  }

  return <div className="recovery-flow">
    <ol className="recovery-flow__steps" aria-label="Password recovery progress">
      {['Recovery method', 'Verify identity', 'New password'].map((label, index) => <li key={label} aria-current={index === step ? 'step' : undefined} data-complete={index < step || currentStage === 'saved'}>
        <span aria-hidden="true">{index < step || currentStage === 'saved' ? <Check size={14} /> : index + 1}</span>{label}
      </li>)}
    </ol>
    <div className={currentStage === 'method' ? 'sr-only' : 'recovery-flow__heading'}>
      <span className="recovery-flow__icon" aria-hidden="true">{method === 'recovery' ? <KeyRound /> : currentStage === 'code' ? <Mail /> : <ShieldCheck />}</span>
      <div><h2 ref={heading} tabIndex={-1}>{titles[currentStage]}</h2><p>{currentStage === 'method' ? 'Verify your identity to securely reset your password.' : currentStage === 'password' ? 'Your identity is verified. Choose a strong, unique password.' : currentStage === 'saved' ? 'Your password is updated. These codes replace your previous set and are shown only once.' : method === 'recovery' ? 'Enter one unused backup code saved when you set up your authenticator.' : `Use the email address linked to your ${portal === 'admin' ? 'invited Admin' : 'Vendor'} account.`}</p></div>
    </div>
    {email && currentStage !== 'email' && currentStage !== 'saved' && <div className="recovery-flow__account"><span><Mail size={16} aria-hidden="true" />{maskedEmail(email)}</span>{currentStage === 'method' && <Button variant="quiet" onClick={() => { setEmail(''); setStage('email') }} disabled={working}>Change</Button>}</div>}
    {(message || check.message) && <StatusMessage tone="error">{message || check.message}</StatusMessage>}
    {notice && <StatusMessage tone="success">{notice}</StatusMessage>}
    {currentStage === 'method' && <>
      <div className="recovery-flow__methods">
        <Button className="w-full" disabled={working} onClick={() => { setMethod('email'); if (email) void sendCode(); else setStage('email') }}><Mail size={18} aria-hidden="true" />{working ? 'Sending…' : 'Send authentication code'}<ArrowRight size={18} aria-hidden="true" /></Button>
        <div className="recovery-flow__divider"><span>or</span></div>
        <Button className="w-full" variant="secondary" disabled={working} onClick={chooseRecovery}><KeyRound size={18} aria-hidden="true" />Use recovery codes</Button>
      </div>
      <SecurityCheckbox portal={portal} check={check} siteKey={siteKey} />
    </>}
    {currentStage === 'email' && <form onSubmit={submitEmail} aria-busy={working}>
      <Field label="Account email" name="email" type="email" autoComplete="email" value={email} onChange={event => setEmail(event.currentTarget.value)} autoFocus required disabled={working} />
      <Button className="w-full" type="submit" disabled={working}>{working ? 'Sending…' : method === 'recovery' || initialCodeEntry ? 'Continue' : 'Send authentication code'}<ArrowRight size={18} aria-hidden="true" /></Button>
      {method === 'email' && !initialCodeEntry && <SecurityCheckbox portal={portal} check={check} siteKey={siteKey} />}
      <Button variant="quiet" disabled={working} onClick={startOver}><ArrowLeft size={16} aria-hidden="true" />Back to recovery methods</Button>
    </form>}
    {currentStage === 'code' && <form onSubmit={verify} aria-busy={working}>
      {method === 'email' && <StatusMessage>If this {portal === 'admin' ? 'Admin' : 'Vendor'} account exists, a six-digit authentication code is being delivered to {maskedEmail(email)}.</StatusMessage>}
      {method === 'recovery'
        ? <Field label="Recovery code" name="recovery_code" autoComplete="off" autoCapitalize="characters" spellCheck={false} maxLength={128} autoFocus disabled={working} required hint="Each code works once. Using one replaces all previous recovery codes and signs out existing sessions." />
        : <AuthenticatorCodeField key={check.stepUp ? `${check.stepUp.challenge.id}:${requestedAt}` : String(resendAt)} label="Authentication code" name="code" hint="Enter the code from your email, or paste all 6 digits." autoFocus disabled={working} required />}
      {method === 'email' && codeExpiry && <p className="recovery-flow__expiry">Code expires <time dateTime={codeExpiry}>{formatExpiry(codeExpiry)}</time> (Manila).</p>}
      <Button className="w-full" type="submit" disabled={working}>{busy ? 'Verifying…' : 'Verify and continue'}<ArrowRight size={18} aria-hidden="true" /></Button>
      {method === 'email' && <Button className="w-full" variant="quiet" disabled={working || resendIn > 0} onClick={() => void resend()}>{resendIn > 0 ? `Request another code in ${resendIn}s` : 'Request another code'}</Button>}
      <Button className="w-full" variant="quiet" disabled={working} onClick={startOver}><ArrowLeft size={16} aria-hidden="true" />Back to recovery methods</Button>
    </form>}
    {currentStage === 'password' && <form onSubmit={savePassword} aria-busy={busy}>
      <PasswordField label="New password" name="password" autoComplete="new-password" minLength={minPasswordLength} required autoFocus disabled={busy} />
      <Field label="Confirm new password" name="password_confirmation" type="password" autoComplete="new-password" minLength={minPasswordLength} required disabled={busy} />
      {recoveryCodes && <StatusMessage>Your previous recovery codes have been replaced. <button className="recovery-flow__download" type="button" onClick={() => onDownloadCodes(recoveryCodes)}>Download the new codes</button> before leaving this page.</StatusMessage>}
      <Button className="w-full" type="submit" disabled={busy}>{busy ? 'Updating password…' : 'Update password'}<ArrowRight size={18} aria-hidden="true" /></Button>
      <p className="recovery-flow__expiry">All existing sessions will be signed out. Sign in again with your new password{portal === 'admin' ? ' and authenticator' : ''}.</p>
      <Button variant="quiet" disabled={busy} onClick={startOver}>Verify again</Button>
    </form>}
    {currentStage === 'saved' && recoveryCodes && <>
      <div className="recovery-codes" aria-label="Replacement recovery codes">{recoveryCodes.map(code => <code key={code}>{code}</code>)}</div>
      <Button variant="secondary" onClick={() => onDownloadCodes(recoveryCodes)}>Download recovery codes (.txt)</Button>
      <Button onClick={onComplete}>I saved these codes. Continue to sign in</Button>
    </>}
  </div>
}

function SecurityCheckbox({ portal, check, siteKey }: { portal: 'admin' | 'vendor'; check: ReturnType<typeof useWebBotProtection>; siteKey: string | undefined }) {
  return <div className="recovery-flow__security">
    <RecaptchaCheckbox ref={check.checkboxRef} siteKey={siteKey} action={portal === 'admin' ? 'admin_password_recovery' : 'vendor_password_recovery'} disabled={check.busy} onTokenChange={check.setToken} />
    <p>If you cannot use the checkbox, “Send authentication code” continues with an email security check.</p>
  </div>
}

function maskedEmail(email: string): string {
  const [local, domain] = email.split('@')
  return local && domain ? `${local[0]}${'•'.repeat(Math.min(4, Math.max(1, local.length - 1)))}@${domain}` : 'your account email'
}

function formatExpiry(value: string): string {
  return new Intl.DateTimeFormat('en-PH', { timeZone: 'Asia/Manila', month: 'short', day: 'numeric', hour: 'numeric', minute: '2-digit' }).format(new Date(value))
}
