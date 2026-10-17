import { AdminNotificationsPage, AdminTaxPackagesPage, AdminDeliveryFailuresPage } from './pages/NotificationPages'
import { AdminPlaceholderPage } from './pages/AdminPlaceholderPage'
import { QRCodeSVG } from 'qrcode.react'
import { AccountType, ResponseError } from '@materyalph/api-client-ts'
import { AccountWorkspace, Button, Field, PasswordField, StatusMessage, PortalIdentityProvider, PortalResourceProvider, useWebBotProtection } from '@materyalph/web-ui'
import { ArrowRight } from 'lucide-react'
import { type FormEvent, useEffect, useState } from 'react'
import { BrowserRouter, Link, Navigate, Outlet, Route, Routes, useNavigate, useSearchParams } from 'react-router-dom'

import { AdminAuthShell } from './components/AdminAuthShell'
import { AdminEmailSecurityCheck, AdminSecurityFields } from './components/AdminBotProtection'
import { acceptAdminInvitation, getSession, readableApiError, signInAdmin } from './lib/auth-api'
import { AdminForgotPasswordPage, AdminMfaPage, AdminResetPasswordPage } from './pages/AuthSupportPages'
import { AdminShell, AdminVendorVerificationDetailPage, AdminVendorVerificationQueuePage } from './pages/PhaseThreeAdminPages'
import './App.css'
import { AdminDashboardPage } from './pages/AdminDashboardPage'
import { AdminAuditSearchPage } from './pages/AuditSearchPage'
import { AdminPlatformSettingsPage } from './pages/PlatformSettingsPage'
import { AdminEnforcementDetailPage, AdminEnforcementQueuePage } from './pages/EnforcementPages'
import { AdminPrivacyDetailPage, AdminPrivacyQueuePage } from './pages/PrivacyPages'
import { AdminIntegrationHealthPage } from './pages/IntegrationHealthPages'
import { AdminGeoAnalyticsPage } from './pages/GeoAnalyticsPage'
import { AdminProductComplianceCasePage, AdminProductComplianceQueuePage } from './pages/ProductCompliancePages'
import { AdminAccumulatorPage, AdminFinancePage } from './pages/FinancePages'
import { AdminOrderOperationsPage } from './pages/OrderOperationsPage'
import { AdminDisputeCasePage, AdminDisputeQueuePage } from './pages/DisputePages'
import { AdminInvoiceLogPage } from './pages/InvoiceLogPage'
import { AdminMaterialPriceDetailsPage, AdminReviewModerationDetailPage, AdminReviewModerationPage, AdminScoreDetailPage, AdminScoresPage } from './pages/TrustPages'

function App() {
  return <BrowserRouter><Routes><Route path="/" element={<AdminLoginEntry />} /><Route path="/login" element={<AdminLoginEntry />} /><Route path="/accept-invite" element={<AcceptInvite />} /><Route path="/forgot-password" element={<AdminForgotPasswordPage />} /><Route path="/reset-password" element={<AdminResetPasswordPage />} /><Route path="/auth/mfa" element={<AdminMfaPage />} /><Route element={<PortalResourceProvider><PortalIdentityProvider portal="admin" basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'}><Outlet /></PortalIdentityProvider></PortalResourceProvider>}><Route path="/preview/:module" element={<AdminPlaceholderPage />} /><Route path="/notifications" element={<AdminNotificationsPage />} /><Route path="/notifications/failures" element={<AdminDeliveryFailuresPage />} /><Route path="/reports/tax" element={<AdminTaxPackagesPage />} /><Route path="/reports/tax/:packageId" element={<AdminTaxPackagesPage />} /><Route path="/dashboard" element={<AdminDashboardPage />} /><Route path="/audit" element={<AdminAuditSearchPage />} /><Route path="/settings" element={<AdminPlatformSettingsPage />} /><Route path="/enforcement" element={<AdminEnforcementQueuePage />} /><Route path="/enforcement/:actionId" element={<AdminEnforcementDetailPage />} /><Route path="/buyer-management" element={<AdminEnforcementQueuePage subjectType="BUYER" activeHref="/buyer-management" />} /><Route path="/privacy" element={<AdminPrivacyQueuePage />} /><Route path="/privacy/:requestId" element={<AdminPrivacyDetailPage />} /><Route path="/integrations" element={<AdminIntegrationHealthPage />} /><Route path="/analytics" element={<AdminGeoAnalyticsPage />} /><Route path="/vendor-verification" element={<AdminVendorVerificationQueuePage />} /><Route path="/vendor-verification/:organizationId" element={<AdminVendorVerificationDetailPage />} /><Route path="/product-compliance" element={<AdminProductComplianceQueuePage />} /><Route path="/product-compliance/:submissionId" element={<AdminProductComplianceCasePage />} /><Route path="/finance" element={<AdminFinancePage />} /><Route path="/order-operations" element={<AdminOrderOperationsPage />} /><Route path="/disputes" element={<AdminDisputeQueuePage />} /><Route path="/disputes/:caseId" element={<AdminDisputeCasePage />} /><Route path="/invoices" element={<AdminInvoiceLogPage />} /><Route path="/analytics/materials" element={<Navigate to="/analytics?view=materials" replace />} /><Route path="/analytics/materials/:groupId" element={<AdminMaterialPriceDetailsPage />} /><Route path="/scores" element={<AdminScoresPage />} /><Route path="/scores/:vendorId" element={<AdminScoreDetailPage />} /><Route path="/reviews" element={<AdminReviewModerationPage />} /><Route path="/reviews/:reviewId" element={<AdminReviewModerationDetailPage />} /><Route path="/finance/accumulators/:accumulatorId" element={<AdminAccumulatorPage />} /><Route path="/workspace" element={<AdminShell activeHref="/workspace"><AccountWorkspace embedded portal="admin" basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} loginPath="/login" renderQr={uri => <QRCodeSVG value={uri} title="Authenticator setup QR code" />} /></AdminShell>} /><Route path="*" element={<AdminShell activeHref=""><h1 className="text-2xl font-semibold">Page not found</h1><Link to="/vendor-verification">Return to verification queue</Link></AdminShell>} /></Route></Routes></BrowserRouter>
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
  return <AdminAuthShell login title="Welcome back" description="Sign in with your invited Admin account.">
    {state === 'checking'
      ? <StatusMessage>Checking your Admin session…</StatusMessage>
      : <><StatusMessage tone="error">Could not check your Admin session. Check your connection and try again.</StatusMessage><Button onClick={() => { setState('checking'); setAttempt(value => value + 1) }}>Retry session check</Button></>}
  </AdminAuthShell>
}

function AdminLogin() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const check = useWebBotProtection(readableApiError)

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const form = event.currentTarget
    const data = new FormData(form)
    const email = String(data.get('email'))
    const password = String(data.get('password'))
    await check.run(email, async evidence => {
      const response = await signInAdmin(email, password, evidence)
      navigate(response.data.mfaRequired ? '/auth/mfa' : '/workspace')
    }, (event.nativeEvent as SubmitEvent).submitter?.getAttribute('data-email-check') === 'true')
  }

  const successMessage = searchParams.get('reset') === 'success' ? 'Password updated. Sign in with your new password.' : null
  return <AdminAuthShell login title="Welcome back" description="Sign in with your invited Admin account.">
    {check.message && <StatusMessage tone="error">{check.message}</StatusMessage>}
    {check.stepUp ? <AdminEmailSecurityCheck check={check} /> : <form aria-busy={check.busy} onSubmit={submit}>
      {successMessage && <StatusMessage tone="success">{successMessage}</StatusMessage>}
      <Field label="Email address" name="email" type="email" autoComplete="email" required />
      <Field label="Password" name="password" type="password" autoComplete="current-password" required />
      <div className="admin-help"><span>Access attempts are audited.</span><Link to="/forgot-password">Forgot password?</Link></div>
      <AdminSecurityFields action="admin_login" check={check}>
        <Button className="w-full" type="submit" disabled={check.busy}>{check.busy ? 'Verifying access…' : 'Sign in securely'} <ArrowRight aria-hidden="true" /></Button>
      </AdminSecurityFields>
    </form>}
    <p className="admin-footnote">Admin accounts are invitation-only. There is no public registration route.</p>
  </AdminAuthShell>
}

function AcceptInvite() {
  const [searchParams] = useSearchParams()
  const [token] = useState(() => searchParams.get('token') ?? '')
  useEffect(() => { window.history.replaceState({}, '', window.location.pathname) }, [])
  const check = useWebBotProtection(readableApiError)
  const [created, setCreated] = useState(false)

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const data = new FormData(event.currentTarget)
    const input = { token, email: String(data.get('email')), fullName: String(data.get('full_name')), password: String(data.get('password')), passwordConfirmation: String(data.get('password_confirmation')) }
    await check.run(input.email, async evidence => {
      await acceptAdminInvitation(input, evidence)
      setCreated(true)
    }, (event.nativeEvent as SubmitEvent).submitter?.getAttribute('data-email-check') === 'true')
  }

  return <AdminAuthShell title="Accept your Admin invitation" description="This one-time link creates an invited staff identity. Multi-factor enrollment is required next.">
    {check.message && <StatusMessage tone="error">{check.message}</StatusMessage>}
    {created ? <><StatusMessage tone="success">Admin account created. Continue to sign in and enroll multi-factor authentication.</StatusMessage><Link className="admin-return admin-return--centered" to="/login">Continue to sign in</Link></>
      : !token ? <><StatusMessage tone="error">The invitation token is missing. Open the complete link from your invitation email.</StatusMessage><Link className="admin-return admin-return--centered" to="/login">Return to sign in</Link></>
      : check.stepUp ? <AdminEmailSecurityCheck check={check} /> : <form onSubmit={submit} aria-busy={check.busy}>
        <Field label="Invited email address" name="email" type="email" autoComplete="email" required />
        <Field label="Full name" name="full_name" autoComplete="name" required />
        <PasswordField label="Password" name="password" autoComplete="new-password" minLength={14} required />
        <Field label="Confirm password" name="password_confirmation" type="password" autoComplete="new-password" minLength={14} required />
        <label className="admin-consent"><input type="checkbox" required /> I accept the versioned Terms of Service.</label>
        <label className="admin-consent"><input type="checkbox" required /> I acknowledge the separate Privacy Notice.</label>
        <AdminSecurityFields action="admin_invitation_accept" check={check}>
          <Button className="w-full" type="submit" disabled={check.busy}>{check.busy ? 'Creating account…' : 'Create Admin account'}</Button>
        </AdminSecurityFields>
      </form>}
  </AdminAuthShell>
}

export default App
