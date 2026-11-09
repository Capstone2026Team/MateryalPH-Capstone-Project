import { AccountType, ResponseError } from '@materyalph/api-client-ts'
import { BackNavigation, Button, Field, PasswordField, StatusMessage, PortalIdentityProvider, PortalResourceProvider, useWebBotProtection } from '@materyalph/web-ui'
import { ArrowRight } from 'lucide-react'
import { AsyncLoading, lazyPortalPage, PortalPageLoading } from '@materyalph/web-ui'
import { type FormEvent, useEffect, useState } from 'react'
import { BrowserRouter, Link, Navigate, Outlet, Route, Routes, useNavigate, useSearchParams } from 'react-router-dom'

import { AdminAuthShell } from './components/AdminAuthShell'
import { AdminEmailSecurityCheck, AdminSecurityFields } from './components/AdminBotProtection'
import { acceptAdminInvitation, getSession, readableApiError, signInAdmin } from './lib/auth-api'
import { AdminForgotPasswordPage, AdminMfaPage, AdminResetPasswordPage } from './pages/AuthSupportPages'
import './App.css'

const AdminDashboardPage = lazyPortalPage(() => import('./pages/AdminDashboardPage').then(module => ({ default: module.AdminDashboardPage })))
const AdminSupportRequestsPage = lazyPortalPage(() => import('./pages/SupportPages').then(module => ({ default: module.AdminSupportRequestsPage })))
const AdminSupportTicketPage = lazyPortalPage(() => import('./pages/SupportPages').then(module => ({ default: module.AdminSupportTicketPage })))
const AdminVendorVerificationDetailPage = lazyPortalPage(() => import('./pages/PhaseThreeAdminPages').then(module => ({ default: module.AdminVendorVerificationDetailPage })))
const AdminVendorVerificationQueuePage = lazyPortalPage(() => import('./pages/PhaseThreeAdminPages').then(module => ({ default: module.AdminVendorVerificationQueuePage })))
const AdminAccountWorkspacePage = lazyPortalPage(() => import('./pages/AdminWorkspacePages').then(module => ({ default: module.AdminAccountWorkspacePage })))
const AdminNotFoundPage = lazyPortalPage(() => import('./pages/AdminWorkspacePages').then(module => ({ default: module.AdminNotFoundPage })))
const AdminPlaceholderPage = lazyPortalPage(() => import('./pages/AdminPlaceholderPage').then(module => ({ default: module.AdminPlaceholderPage })))
const AdminNotificationsPage = lazyPortalPage(() => import('./pages/NotificationPages').then(module => ({ default: module.AdminNotificationsPage })))
const AdminDeliveryFailuresPage = lazyPortalPage(() => import('./pages/NotificationPages').then(module => ({ default: module.AdminDeliveryFailuresPage })))
const AdminAuditSearchPage = lazyPortalPage(() => import('./pages/AuditSearchPage').then(module => ({ default: module.AdminAuditSearchPage })))
const AdminOrderAuditPage = lazyPortalPage(() => import('./pages/OrderAuditPages').then(module => ({ default: module.AdminOrderAuditPage })))
const AdminPlatformSettingsPage = lazyPortalPage(() => import('./pages/PlatformSettingsPage').then(module => ({ default: module.AdminPlatformSettingsPage })))
const AdminEnforcementDetailPage = lazyPortalPage(() => import('./pages/EnforcementPages').then(module => ({ default: module.AdminEnforcementDetailPage })))
const AdminEnforcementQueuePage = lazyPortalPage(() => import('./pages/EnforcementPages').then(module => ({ default: module.AdminEnforcementQueuePage })))
const AdminBuyerUserDetailPage = lazyPortalPage(() => import('./pages/UserDirectoryPages').then(module => ({ default: module.AdminBuyerUserDetailPage })))
const AdminBuyerUsersPage = lazyPortalPage(() => import('./pages/UserDirectoryPages').then(module => ({ default: module.AdminBuyerUsersPage })))
const AdminVendorUserDetailPage = lazyPortalPage(() => import('./pages/UserDirectoryPages').then(module => ({ default: module.AdminVendorUserDetailPage })))
const AdminVendorUsersPage = lazyPortalPage(() => import('./pages/UserDirectoryPages').then(module => ({ default: module.AdminVendorUsersPage })))
const AdminIntegrationHealthPage = lazyPortalPage(() => import('./pages/IntegrationHealthPages').then(module => ({ default: module.AdminIntegrationHealthPage })))
const AdminGeoAnalyticsPage = lazyPortalPage(() => import('./pages/GeoAnalyticsPage').then(module => ({ default: module.AdminGeoAnalyticsPage })))
const AdminProductComplianceCasePage = lazyPortalPage(() => import('./pages/ProductCompliancePages').then(module => ({ default: module.AdminProductComplianceCasePage })))
const AdminProductComplianceQueuePage = lazyPortalPage(() => import('./pages/ProductCompliancePages').then(module => ({ default: module.AdminProductComplianceQueuePage })))
const AdminFinancePage = lazyPortalPage(() => import('./pages/FinancePages').then(module => ({ default: module.AdminFinancePage })))
const AdminDisputeCasePage = lazyPortalPage(() => import('./pages/DisputePages').then(module => ({ default: module.AdminDisputeCasePage })))
const AdminDisputeQueuePage = lazyPortalPage(() => import('./pages/DisputePages').then(module => ({ default: module.AdminDisputeQueuePage })))
const AdminMaterialPriceDetailsPage = lazyPortalPage(() => import('./pages/TrustPages').then(module => ({ default: module.AdminMaterialPriceDetailsPage })))
const AdminReviewModerationDetailPage = lazyPortalPage(() => import('./pages/TrustPages').then(module => ({ default: module.AdminReviewModerationDetailPage })))
const AdminReviewModerationPage = lazyPortalPage(() => import('./pages/TrustPages').then(module => ({ default: module.AdminReviewModerationPage })))
const AdminScoreDetailPage = lazyPortalPage(() => import('./pages/TrustPages').then(module => ({ default: module.AdminScoreDetailPage })))
const AdminScoresPage = lazyPortalPage(() => import('./pages/TrustPages').then(module => ({ default: module.AdminScoresPage })))

function App() {
  return <BrowserRouter><PortalPageLoading><Routes><Route path="/" element={<AdminLoginEntry />} /><Route path="/login" element={<AdminLoginEntry />} /><Route path="/accept-invite" element={<AcceptInvite />} /><Route path="/forgot-password" element={<AdminForgotPasswordPage />} /><Route path="/reset-password" element={<AdminResetPasswordPage />} /><Route path="/auth/mfa" element={<AdminMfaPage />} /><Route element={<PortalResourceProvider><PortalIdentityProvider portal="admin" basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'}><Outlet /></PortalIdentityProvider></PortalResourceProvider>}><Route path="/preview/:module" element={<AdminPlaceholderPage />} /><Route path="/notifications" element={<AdminNotificationsPage />} /><Route path="/notifications/failures" element={<AdminDeliveryFailuresPage />} /><Route path="/reports/tax/*" element={<Navigate to="/finance" replace />} /><Route path="/support" element={<AdminSupportRequestsPage />} /><Route path="/support/:ticketId" element={<AdminSupportTicketPage />} /><Route path="/dashboard" element={<AdminDashboardPage />} /><Route path="/audit" element={<AdminAuditSearchPage />} /><Route path="/audit/orders/:orderId" element={<AdminOrderAuditPage />} /><Route path="/settings" element={<AdminPlatformSettingsPage />} /><Route path="/enforcement" element={<AdminEnforcementQueuePage />} /><Route path="/enforcement/:actionId" element={<AdminEnforcementDetailPage />} /><Route path="/buyer-management" element={<Navigate to="/enforcement" replace />} /><Route path="/buyer-users" element={<AdminBuyerUsersPage />} /><Route path="/buyer-users/:buyerId" element={<AdminBuyerUserDetailPage />} /><Route path="/vendor-users" element={<AdminVendorUsersPage />} /><Route path="/vendor-users/:vendorId" element={<AdminVendorUserDetailPage />} /><Route path="/integrations" element={<AdminIntegrationHealthPage />} /><Route path="/analytics" element={<AdminGeoAnalyticsPage />} /><Route path="/vendor-verification" element={<AdminVendorVerificationQueuePage />} /><Route path="/vendor-verification/:organizationId" element={<AdminVendorVerificationDetailPage />} /><Route path="/product-compliance" element={<AdminProductComplianceQueuePage />} /><Route path="/product-compliance/:submissionId" element={<AdminProductComplianceCasePage />} /><Route path="/finance" element={<AdminFinancePage />} /><Route path="/tax-management/*" element={<Navigate to="/finance" replace />} /><Route path="/finance/tax/*" element={<Navigate to="/finance" replace />} /><Route path="/finance/accumulators/*" element={<Navigate to="/finance" replace />} /><Route path="/disputes" element={<AdminDisputeQueuePage />} /><Route path="/disputes/:caseId" element={<AdminDisputeCasePage />} /><Route path="/analytics/materials" element={<Navigate to="/analytics?view=materials" replace />} /><Route path="/analytics/materials/:groupId" element={<AdminMaterialPriceDetailsPage />} /><Route path="/scores" element={<AdminScoresPage />} /><Route path="/scores/:vendorId" element={<AdminScoreDetailPage />} /><Route path="/reviews" element={<AdminReviewModerationPage />} /><Route path="/reviews/:reviewId" element={<AdminReviewModerationDetailPage />} /><Route path="/workspace" element={<AdminAccountWorkspacePage />} /><Route path="*" element={<AdminNotFoundPage />} /></Route></Routes></PortalPageLoading></BrowserRouter>
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
      ? <AsyncLoading compact label="Checking your Admin session…" />
      : <><StatusMessage tone="error">Could not check your Admin session. Check your connection and try again.</StatusMessage><Button onClick={() => { setState('checking'); setAttempt(value => value + 1) }}>Retry session check</Button></>}
  </AdminAuthShell>
}

function AdminLogin() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const check = useWebBotProtection(readableApiError)
  const [email, setEmail] = useState('')

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
      <Field label="Email address" name="email" type="email" autoComplete="email" value={email} onChange={event => setEmail(event.currentTarget.value)} required />
      <Field label="Password" name="password" type="password" autoComplete="current-password" required />
      <div className="admin-help"><span>Access attempts are audited.</span><Link to="/forgot-password" state={{ email }}>Forgot password?</Link></div>
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
      : !token ? <><StatusMessage tone="error">The invitation token is missing. Open the complete link from your invitation email.</StatusMessage><BackNavigation><Link className="admin-return admin-return--centered" to="/login">Return to sign in</Link></BackNavigation></>
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
