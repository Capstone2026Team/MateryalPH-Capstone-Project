import { AuthenticatorCodeField, Button, Field, PasswordRecoveryFlow, StatusMessage } from '@materyalph/web-ui'
import { QRCodeSVG } from 'qrcode.react'
import { downloadRecoveryCodes } from '../lib/recovery-codes'
import { ShieldCheck } from 'lucide-react'
import { type FormEvent, useEffect, useState } from 'react'
import { Link, useLocation, useNavigate, useSearchParams } from 'react-router-dom'

import { AdminAuthShell } from '../components/AdminAuthShell'
import {
  completeMfaChallenge,
  confirmMfaEnrollment,
  completePasswordRecovery,
  getMfaStatus,
  readableApiError,
  recoverMfaChallenge,
  requestPasswordRecovery,
  resendRiskChallenge,
  startMfaEnrollment,
  verifyPasswordRecovery,
} from '../lib/auth-api'

type Enrollment = { secret: string; provisioningUri: string }

export function AdminMfaPage() {
  const navigate = useNavigate(); const [loading, setLoading] = useState(true); const [busy, setBusy] = useState(false); const [recoveryMode, setRecoveryMode] = useState(false); const [enrollment, setEnrollment] = useState<Enrollment | null>(null); const [recoveryCodes, setRecoveryCodes] = useState<string[] | null>(null); const [message, setMessage] = useState<string | null>(null)
  useEffect(() => { let active = true; void (async () => { try { const status = await getMfaStatus(); if (status.data.mfaEnrollmentRequired) { const result = await startMfaEnrollment(); if (active) setEnrollment({ secret: result.data.secret, provisioningUri: result.data.provisioningUri }) } } catch (error) { if (active) setMessage(await readableApiError(error)) } finally { if (active) setLoading(false) } })(); return () => { active = false } }, [])
  async function submit(event: FormEvent<HTMLFormElement>) { event.preventDefault(); setBusy(true); setMessage(null); const data = new FormData(event.currentTarget); try { const response = recoveryMode ? await recoverMfaChallenge(String(data.get('recovery_code'))) : enrollment ? await confirmMfaEnrollment(String(data.get('code'))) : await completeMfaChallenge(String(data.get('code'))); const codes = response.data.recoveryCodes; if (codes?.length) setRecoveryCodes(codes); else navigate('/dashboard', { replace: true }) } catch (error) { setMessage(await readableApiError(error)) } finally { setBusy(false) } }
  if (recoveryCodes) return <AdminAuthShell title="Save your recovery codes" description="Each code works once. Store this replacement set offline; it will not be shown again."><div className="recovery-codes" aria-label="One-time recovery codes">{recoveryCodes.map((code) => <code key={code}>{code}</code>)}</div><Button className="w-full" variant="secondary" onClick={() => downloadRecoveryCodes(recoveryCodes)}>Download recovery codes (.txt)</Button><Button className="w-full" onClick={() => navigate('/dashboard', { replace: true })}>I saved these codes</Button></AdminAuthShell>
  return <AdminAuthShell title={enrollment ? 'Secure your Admin account' : 'Verify it is you'} description={enrollment ? 'All Admin accounts require an authenticator before portal access.' : 'Enter the current code from your authenticator app.'}>{loading ? <StatusMessage>Loading your security step…</StatusMessage> : <form onSubmit={submit}>{message && <StatusMessage tone="error">{message}</StatusMessage>}{enrollment && !recoveryMode && <div className="enrollment-secret"><ShieldCheck aria-hidden="true" /><p>Add this account in your authenticator app, then enter its six-digit code.</p><div className="flex justify-center bg-white p-4"><QRCodeSVG value={enrollment.provisioningUri} size={208} level="M" marginSize={4} title="Authenticator setup QR code" role="img" /></div><p>Or enter this manual setup key:</p><code>{enrollment.secret}</code><details><summary>Manual provisioning address</summary><code>{enrollment.provisioningUri}</code></details></div>}{recoveryMode ? <Field label="Recovery code" name="recovery_code" autoComplete="one-time-code" required /> : <AuthenticatorCodeField error={message ?? ''} label="Six-digit authenticator code" name="code" disabled={busy} required />}<Button className="w-full" type="submit" disabled={busy}>{busy ? 'Verifying…' : enrollment ? 'Enroll and continue' : 'Verify and continue'}</Button>{!enrollment && <Button className="w-full" variant="quiet" onClick={() => { setRecoveryMode((value) => !value); setMessage(null) }}>{recoveryMode ? 'Use authenticator code' : 'Use a recovery code'}</Button>}<Link className="admin-return admin-return--centered" to="/login">Cancel and sign in again</Link></form>}</AdminAuthShell>
}

export function AdminForgotPasswordPage() {
  return <AdminPasswordRecovery />
}

export function AdminResetPasswordPage() {
  return <AdminPasswordRecovery initialCodeEntry />
}

function AdminPasswordRecovery({ initialCodeEntry = false }: { initialCodeEntry?: boolean }) {
  const navigate = useNavigate()
  const location = useLocation()
  const [searchParams] = useSearchParams()
  const state: unknown = location.state
  const email = typeof state === 'object' && state !== null && 'email' in state && typeof state.email === 'string' ? state.email : searchParams.get('email') ?? ''

  return <AdminAuthShell title="Recover Admin access" description="Verify your identity and set a new password for your invited Admin account.">
    <PasswordRecoveryFlow portal="admin" initialEmail={email} initialCodeEntry={initialCodeEntry} siteKey={import.meta.env.VITE_RECAPTCHA_SITE_KEY}
      requestCode={async (address, evidence) => (await requestPasswordRecovery(address, evidence)).data}
      verifyIdentity={async input => {
        const result = await verifyPasswordRecovery(input)
        if (!result.data.verified) throw new Error('Your identity could not be verified. Try again.')
        return result.data
      }}
      completePassword={completePasswordRecovery} resendSecurityCode={resendRiskChallenge} readableError={readableApiError}
      onDownloadCodes={downloadRecoveryCodes} onComplete={() => navigate('/login?reset=success', { replace: true })} />
    <Link className="admin-return admin-return--centered" to="/login">Back to sign in</Link>
  </AdminAuthShell>
}
