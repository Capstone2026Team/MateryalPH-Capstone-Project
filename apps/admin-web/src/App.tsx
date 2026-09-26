import { AdminPlaceholderPage } from './pages/AdminPlaceholderPage'
import { QRCodeSVG } from 'qrcode.react'
import { AccountType, ResponseError } from '@materyalph/api-client-ts'
import { AccountWorkspace, Button, Field, StatusMessage } from '@materyalph/web-ui'
import { ArrowRight } from 'lucide-react'
import { type FormEvent, useEffect, useState } from 'react'
import { BrowserRouter, Link, Navigate, Route, Routes, useNavigate, useSearchParams } from 'react-router-dom'

import { AdminAuthShell } from './components/AdminAuthShell'
import { acceptAdminInvitation, getSession, readableApiError, signInAdmin } from './lib/auth-api'
import { AdminForgotPasswordPage, AdminMfaPage, AdminResetPasswordPage } from './pages/AuthSupportPages'
import { AdminShell, AdminVendorVerificationDetailPage, AdminVendorVerificationQueuePage } from './pages/PhaseThreeAdminPages'
import './App.css'
import { AdminDashboardPage, AdminAuditPage } from './pages/AdminDashboardPage'

function App() {
  return <BrowserRouter><Routes><Route path="/" element={<AdminLoginEntry />} /><Route path="/login" element={<AdminLoginEntry />} /><Route path="/accept-invite" element={<AcceptInvite />} /><Route path="/forgot-password" element={<AdminForgotPasswordPage />} /><Route path="/reset-password" element={<AdminResetPasswordPage />} /><Route path="/auth/mfa" element={<AdminMfaPage />} /><Route path="/preview/:module" element={<AdminPlaceholderPage />} /><Route path="/dashboard" element={<AdminDashboardPage />} /><Route path="/audit" element={<AdminAuditPage />} /><Route path="/vendor-verification" element={<AdminVendorVerificationQueuePage />} /><Route path="/vendor-verification/:organizationId" element={<AdminVendorVerificationDetailPage />} /><Route path="/workspace" element={<AdminShell activeHref="/workspace"><AccountWorkspace embedded portal="admin" basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} loginPath="/login" renderQr={uri => <QRCodeSVG value={uri} title="Authenticator setup QR code" />} /></AdminShell>} /><Route path="*" element={<AdminShell activeHref=""><h1 className="text-2xl font-semibold">Page not found</h1><Link to="/vendor-verification">Return to verification queue</Link></AdminShell>} /></Routes></BrowserRouter>
}

function AdminLoginEntry() {
  const [state, setState] = useState<'checking' | 'signed-out' | 'signed-in' | 'unavailable'>('checking')
  const [attempt, setAttempt] = useState(0)

  useEffect(() => {
    let active = true
    void getSession().then(response => {
      if (active) setState(response.data.user?.accountType === AccountType.Admin ? 'signed-in' : 'unavailable')
    }).catch(error => {
      if (active) setState(error instanceof ResponseError && error.response.status === 401 ? 'signed-out' : 'unavailable')
    })
    return () => { active = false }
  }, [attempt])

  if (state === 'signed-in') return <Navigate to="/dashboard" replace />
  if (state === 'signed-out') return <AdminLogin />
  return <AdminAuthShell title="Welcome back" description="Sign in with your invited Admin account.">
    {state === 'checking'
      ? <StatusMessage>Checking your Admin session…</StatusMessage>
      : <><StatusMessage tone="error">Could not check your Admin session. Check your connection and try again.</StatusMessage><Button onClick={() => { setState('checking'); setAttempt(value => value + 1) }}>Retry session check</Button></>}
  </AdminAuthShell>
}

function AdminLogin() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setMessage(null)
    const data = new FormData(event.currentTarget)
    try {
      const response = await signInAdmin(String(data.get('email')), String(data.get('password')))
      navigate(response.data.mfaRequired ? '/auth/mfa' : '/workspace')
    } catch (error) { setMessage(await readableApiError(error)) }
    finally { setBusy(false) }
  }

  const successMessage = searchParams.get('reset') === 'success' ? 'Password updated. Sign in with your new password.' : null
  return <AdminAuthShell title="Welcome back" description="Sign in with your invited Admin account."><form onSubmit={submit}>{successMessage && <StatusMessage tone="success">{successMessage}</StatusMessage>}{message && <StatusMessage tone="error">{message}</StatusMessage>}<Field label="Email address" name="email" type="email" autoComplete="email" required /><Field label="Password" name="password" type="password" autoComplete="current-password" required /><div className="admin-help"><span>Access attempts are audited.</span><Link to="/forgot-password">Forgot password?</Link></div><Button className="w-full" type="submit" disabled={busy}>{busy ? 'Verifying access…' : 'Sign in securely'} <ArrowRight aria-hidden="true" /></Button></form><p className="admin-footnote">Admin accounts are invitation-only. There is no public registration route.</p></AdminAuthShell>
}

function AcceptInvite() {
  const [searchParams] = useSearchParams()
  const navigate = useNavigate()
  const [token] = useState(() => searchParams.get('token') ?? '')
  useEffect(() => { window.history.replaceState({}, '', window.location.pathname) }, [])
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'error' | 'success'; text: string } | null>(null)
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setMessage(null)
    const data = new FormData(event.currentTarget)
    try {
      await acceptAdminInvitation({ token, fullName: String(data.get('full_name')), password: String(data.get('password')), passwordConfirmation: String(data.get('password_confirmation')) })
      setMessage({ tone: 'success', text: 'Admin account created. Continue to sign in and enroll multi-factor authentication.' })
      window.setTimeout(() => navigate('/login'), 1200)
    } catch (error) { setMessage({ tone: 'error', text: await readableApiError(error) }) }
    finally { setBusy(false) }
  }
return <AdminAuthShell title="Accept your Admin invitation" description="This one-time link creates an invited staff identity. Multi-factor enrollment is required next.">{token ? <form onSubmit={submit}>{message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}<Field label="Full name" name="full_name" autoComplete="name" required /><Field label="Password" name="password" type="password" autoComplete="new-password" minLength={14} hint="At least 14 characters with uppercase, lowercase, and a number." required /><Field label="Confirm password" name="password_confirmation" type="password" autoComplete="new-password" minLength={14} required /><label className="admin-consent"><input type="checkbox" required /> I accept the versioned Terms of Service.</label><label className="admin-consent"><input type="checkbox" required /> I acknowledge the separate Privacy Notice.</label><Button className="w-full" type="submit" disabled={busy}>{busy ? 'Creating account…' : 'Create Admin account'}</Button></form> : <><StatusMessage tone="error">The invitation token is missing. Open the complete link from your invitation email.</StatusMessage><Link className="admin-return admin-return--centered" to="/login">Return to sign in</Link></>}</AdminAuthShell>
}

export default App
