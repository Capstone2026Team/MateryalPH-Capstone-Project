import { VendorContactPage, VendorSupportRequestsPage, VendorSupportTicketPage, GuestSupportAccessPage, GuestSupportTicketPage } from './pages/SupportPages'
import { AcceptStaffInvitation } from './pages/AcceptStaffInvitation'
import { BackNavigation, BotProtectionFields, Button, Field, GoogleButton, GoogleMark, googleButtonClassName, PasswordField, PhoneField, StatusMessage, PortalIdentityProvider, PortalResourceProvider, lazyPortalPage, PortalPageLoading, useCommissionPolicy } from '@materyalph/web-ui'
import { ArrowRight } from 'lucide-react'
import { type FormEvent, type ReactNode, useEffect, useRef, useState } from 'react'
import { BrowserRouter, Navigate, Link, Outlet, Route, Routes, useNavigate, useSearchParams } from 'react-router-dom'

import './App.css'
import { AuthenticatedPublicPage } from './pages/AuthenticatedPublicPage'
import { VendorEntryPage } from './pages/VendorEntryPage'
import { BrandHeader } from './components/BrandHeader'
import { SiteFooter } from './components/SiteFooter'
import { RiskOtpPanel } from './components/auth/RiskOtpPanel'
import { VendorAuthShell } from './components/auth/VendorAuthShell'
import { VendorRecaptchaCheckbox, type VendorRecaptchaCheckboxRef } from './components/auth/VendorRecaptchaCheckbox'
import { asBotStepUpRequired, asValidationFailure, readableApiError, registerVendor, signIn, startGoogleSignIn, type RiskChallenge, type ValidationFieldErrors } from './lib/auth-api'
import { vendorBotEvidence, webCookieBotEvidence } from './lib/recaptcha-enterprise'
import {
  VendorAuthCallbackPage,
  VendorForgotPasswordPage,
  VendorGoogleRegisterPage,
  VendorMfaPage,
  VendorResetPasswordPage,
  VendorVerifyEmailPage,
} from './pages/AuthSupportPages'
import { VendorLandingPage } from './pages/VendorLandingPage'
import { VendorLegalPage } from './pages/VendorLegalPage'
import { CommissionTermsPage } from './pages/CommissionTermsPage'

const VendorNotificationsPage = lazyPortalPage(() => import('./pages/NotificationPages').then(module => ({ default: module.VendorNotificationsPage })))
const VendorPlaceholderPage = lazyPortalPage(() => import('./pages/PhaseThreeVendorPages').then(module => ({ default: module.VendorPlaceholderPage })))
const VendorCatalogImportPage = lazyPortalPage(() => import('./pages/CatalogPages').then(module => ({ default: module.VendorCatalogImportPage })))
const VendorCatalogPage = lazyPortalPage(() => import('./pages/CatalogPages').then(module => ({ default: module.VendorCatalogPage })))
const VendorListingEditorPage = lazyPortalPage(() => import('./pages/CatalogPages').then(module => ({ default: module.VendorListingEditorPage })))
const VendorInventoryPage = lazyPortalPage(() => import('./pages/InventoryPages').then(module => ({ default: module.VendorInventoryPage })))
const VendorFleetPage = lazyPortalPage(() => import('./pages/FleetPages').then(module => ({ default: module.VendorFleetPage })))
const VendorMessagesPage = lazyPortalPage(() => import('./pages/MessagingPage').then(module => ({ default: module.VendorMessagesPage })))
const VendorOrderDetailPage = lazyPortalPage(() => import('./pages/OrderPages').then(module => ({ default: module.VendorOrderDetailPage })))
const VendorOrdersPage = lazyPortalPage(() => import('./pages/OrderPages').then(module => ({ default: module.VendorOrdersPage })))
const VendorFulfillmentPage = lazyPortalPage(() => import('./pages/FulfillmentPages').then(module => ({ default: module.VendorFulfillmentPage })))
const VendorDisputeDetailPage = lazyPortalPage(() => import('./pages/DisputePages').then(module => ({ default: module.VendorDisputeDetailPage })))
const VendorDisputesPage = lazyPortalPage(() => import('./pages/DisputePages').then(module => ({ default: module.VendorDisputesPage })))
const VendorFileDisputePage = lazyPortalPage(() => import('./pages/DisputePages').then(module => ({ default: module.VendorFileDisputePage })))
const VendorInvoicesPage = lazyPortalPage(() => import('./pages/InvoicePages').then(module => ({ default: module.VendorInvoicesPage })))
const VendorProductAnalyticsOverviewPage = lazyPortalPage(() => import('./pages/TrustPages').then(module => ({ default: module.VendorProductAnalyticsOverviewPage })))
const VendorProductAnalyticsPage = lazyPortalPage(() => import('./pages/TrustPages').then(module => ({ default: module.VendorProductAnalyticsPage })))
const VendorReviewDetailPage = lazyPortalPage(() => import('./pages/TrustPages').then(module => ({ default: module.VendorReviewDetailPage })))
const VendorReviewsPage = lazyPortalPage(() => import('./pages/TrustPages').then(module => ({ default: module.VendorReviewsPage })))
const VendorStorePerformancePage = lazyPortalPage(() => import('./pages/TrustPages').then(module => ({ default: module.VendorStorePerformancePage })))
const VendorCommissionPage = lazyPortalPage(() => import('./pages/FinancePages').then(module => ({ default: module.VendorCommissionPage })))
const VendorEarningsPage = lazyPortalPage(() => import('./pages/FinancePages').then(module => ({ default: module.VendorEarningsPage })))
const VendorFinancePage = lazyPortalPage(() => import('./pages/FinancePages').then(module => ({ default: module.VendorFinancePage })))
const VendorStatementPage = lazyPortalPage(() => import('./pages/FinancePages').then(module => ({ default: module.VendorStatementPage })))
const VendorTransactionHistoryPage = lazyPortalPage(() => import('./pages/FinancePages').then(module => ({ default: module.VendorTransactionHistoryPage })))
const VendorAccountPage = lazyPortalPage(() => import('./pages/PhaseThreeVendorPages').then(module => ({ default: module.VendorAccountPage })))
const VendorStoreProfilePage = lazyPortalPage(() => import('./pages/PhaseThreeVendorPages').then(module => ({ default: module.VendorStoreProfilePage })))
const VendorDashboardPage = lazyPortalPage(() => import('./pages/PhaseThreeVendorPages').then(module => ({ default: module.VendorDashboardPage })))
const VendorSetupPage = lazyPortalPage(() => import('./pages/PhaseThreeVendorPages').then(module => ({ default: module.VendorSetupPage })))
const VendorTeamPage = lazyPortalPage(() => import('./pages/PhaseThreeVendorPages').then(module => ({ default: module.VendorTeamPage })))
const VendorVerificationPage = lazyPortalPage(() => import('./pages/PhaseThreeVendorPages').then(module => ({ default: module.VendorVerificationPage })))
const VendorWelcomePage = lazyPortalPage(() => import('./pages/PhaseThreeVendorPages').then(module => ({ default: module.VendorWelcomePage })))

function App() {
  return (
    <BrowserRouter>
      <PortalPageLoading><Routes>
        <Route path="/" element={<AuthenticatedPublicPage><VendorLandingPage /></AuthenticatedPublicPage>} />
        <Route path="/login" element={<AuthenticatedPublicPage><LoginPage /></AuthenticatedPublicPage>} />
        <Route path="/register" element={<RegisterPage />} />
        <Route path="/accept-invite" element={<AcceptStaffInvitation />} />
        <Route path="/register/google" element={<VendorGoogleRegisterPage />} />
        <Route path="/verify-email" element={<VendorVerifyEmailPage />} />
        <Route path="/forgot-password" element={<VendorForgotPasswordPage />} />
        <Route path="/reset-password" element={<VendorResetPasswordPage />} />
        <Route path="/auth/mfa" element={<VendorMfaPage />} />
        <Route path="/auth/callback" element={<VendorAuthCallbackPage />} />
        <Route path="/entry" element={<VendorEntryPage />} />
        <Route element={<PortalResourceProvider><PortalIdentityProvider portal="vendors" basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'}><Outlet /></PortalIdentityProvider></PortalResourceProvider>}>
          <Route path="/welcome" element={<VendorWelcomePage />} />
          <Route path="/preview/:module" element={<VendorPlaceholderPage />} />
          <Route path="/dashboard" element={<VendorDashboardPage />} />
          <Route path="/onboarding/verification" element={<VendorVerificationPage />} />
          <Route path="/onboarding/setup" element={<VendorSetupPage />} />
          <Route path="/team" element={<VendorTeamPage />} />
          <Route path="/settings" element={<VendorAccountPage />} />
          <Route path="/store-profile" element={<VendorStoreProfilePage />} />
          <Route path="/products" element={<VendorCatalogPage />} />
          <Route path="/products/new" element={<VendorListingEditorPage />} />
          <Route path="/products/inventory" element={<VendorInventoryPage />} />
          <Route path="/vehicles" element={<VendorFleetPage />} />
          <Route path="/messages" element={<VendorMessagesPage />} />
          <Route path="/notifications" element={<VendorNotificationsPage />} /><Route path="/orders" element={<VendorOrdersPage />} />
          <Route path="/orders/:orderId" element={<VendorOrderDetailPage />} />
          <Route path="/fulfillment" element={<VendorFulfillmentPage />} />
          <Route path="/fulfillment/:orderId" element={<VendorFulfillmentPage />} />
          <Route path="/preview/fulfillment" element={<VendorFulfillmentPage />} />
          <Route path="/disputes" element={<VendorDisputesPage />} />
          <Route path="/disputes/new" element={<VendorFileDisputePage />} />
          <Route path="/disputes/:caseId" element={<VendorDisputeDetailPage />} />
          <Route path="/invoices" element={<VendorInvoicesPage />} />
          <Route path="/reviews" element={<VendorReviewsPage />} />
          <Route path="/reviews/:reviewId" element={<VendorReviewDetailPage />} />
          <Route path="/performance" element={<VendorStorePerformancePage />} />
          <Route path="/performance/products/:listingId" element={<VendorProductAnalyticsPage />} />
          <Route path="/analytics/products" element={<VendorProductAnalyticsOverviewPage />} />
          <Route path="/analytics/products/:listingId" element={<VendorProductAnalyticsPage />} />
          <Route path="/analytics/materials/*" element={<Navigate to="/analytics/products" replace />} />
          <Route path="/finance" element={<VendorFinancePage />} />
          <Route path="/finance/commissions" element={<VendorCommissionPage />} />
          <Route path="/finance/transactions" element={<VendorTransactionHistoryPage />} />
          <Route path="/finance/statements/:statementId" element={<VendorStatementPage />} />
          <Route path="/finance/earnings" element={<VendorEarningsPage />} />
          <Route path="/products/import" element={<VendorCatalogImportPage />} />
          <Route path="/products/:listingId" element={<VendorListingEditorPage />} />
        </Route>
        <Route path="/fees" element={<InfoPage title="Payments and fees"><FeesContent /></InfoPage>} />
        <Route path="/verification" element={<InfoPage title="Vendor verification"><VerificationContent /></InfoPage>} />
        <Route path="/opportunities" element={<InfoPage title="Marketplace opportunities"><OpportunitiesContent /></InfoPage>} />
        <Route path="/support" element={<VendorContactPage />} />
        <Route path="/contact" element={<VendorContactPage />} />
        <Route path="/support/requests" element={<VendorSupportRequestsPage />} />
        <Route path="/support/:ticketId" element={<VendorSupportTicketPage />} />
        <Route path="/contact/access" element={<GuestSupportAccessPage />} />
        <Route path="/contact/tickets/:ticketId" element={<GuestSupportTicketPage />} />
        <Route path="/legal/:document" element={<VendorLegalPage />} />
        <Route path="/commission-terms" element={<CommissionTermsPage />} />
        <Route path="*" element={<NotFound />} />
      </Routes></PortalPageLoading>
    </BrowserRouter>
  )
}

function LoginPage() {
  const navigate = useNavigate()
  const [searchParams] = useSearchParams()
  const [email, setEmail] = useState('')
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [useEmailCheck, setUseEmailCheck] = useState(false)
  const [captchaToken, setCaptchaToken] = useState<string | null>(null)
  const captchaRef = useRef<VendorRecaptchaCheckboxRef>(null)
  const [challenge, setChallenge] = useState<RiskChallenge | null>(null)
  const [pending, setPending] = useState<{ email: string; password: string } | null>(null)

  async function attempt(credentials: { email: string; password: string }, verified = false) {
    const evidence = verified
      ? webCookieBotEvidence()
      : vendorBotEvidence(captchaToken, useEmailCheck)
    const response = await signIn(credentials.email, credentials.password, evidence)
    if (response.data.mfaRequired) {
      navigate('/auth/mfa', {
        state: { mfaMode: response.data.mfaEnrollmentRequired ? 'enrollment' : 'challenge' },
      })
      return
    }

    navigate('/entry')
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setBusy(true)
    setMessage(null)
    const data = new FormData(event.currentTarget)
    const credentials = { email: String(data.get('email')), password: String(data.get('password')) }
    setPending(credentials)
    try {
      await attempt(credentials)
    } catch (error) {
      const stepUp = await asBotStepUpRequired(error)
      if (stepUp) setChallenge(stepUp.challenge)
      else setMessage(await readableApiError(error))
    } finally {
      captchaRef.current?.reset()
      setBusy(false)
    }
  }

  async function googleSignIn() {
    setBusy(true)
    setMessage(null)
    try { await startGoogleSignIn() }
    catch (error) { setMessage(await readableApiError(error)); setBusy(false) }
  }

  const successMessage = searchParams.get('deleted') === 'success' ? 'Your Vendor account has been deleted. Your store is closed and all team sessions have been signed out.' : searchParams.get('logout') === 'success' ? 'You have signed out securely.' : searchParams.get('verified') === 'success'
    ? 'Email verified. You can now sign in.'
    : searchParams.get('reset') === 'success'
      ? 'Password updated. Sign in with your new password.'
      : null

  return (
    <VendorAuthShell login title="Welcome back" description="Sign in to your Vendor account. Store activation is reviewed separately.">
      {challenge && pending
        ? <RiskOtpPanel challenge={challenge} email={pending.email} onCancel={() => { setChallenge(null); setPending(null) }} onVerified={() => attempt(pending, true)} />
        : <form className="auth-form" aria-busy={busy} onSubmit={submit}>
            {successMessage && <StatusMessage tone="success">{successMessage}</StatusMessage>}
            {message && <StatusMessage tone="error">{message}</StatusMessage>}
            <GoogleButton onClick={() => void googleSignIn()} disabled={busy}>Continue with Google</GoogleButton>
            <div className="auth-divider"><span>or sign in with email</span></div>
            <Field label="Email address" name="email" type="email" autoComplete="email" value={email} onChange={event => setEmail(event.currentTarget.value)} required />
            <Field label="Password" name="password" type="password" autoComplete="current-password" required />
            <div className="form-row"><span>Your account, securely accessed.</span><Link to="/forgot-password" state={{ email }}>Forgot password?</Link></div>
            <BotProtectionFields disabled={busy} emailCheckSelected={useEmailCheck} onEmailCheckClick={() => { captchaRef.current?.reset(); setUseEmailCheck((value) => !value) }} checkbox={
              !useEmailCheck && <VendorRecaptchaCheckbox ref={captchaRef} action="vendor_login" disabled={busy} onTokenChange={setCaptchaToken} />
            }>
              <Button className="w-full" type="submit" disabled={busy}>{busy ? 'Signing in…' : 'Sign in'} <ArrowRight aria-hidden="true" /></Button>
            </BotProtectionFields>
            <p className="auth-switch">New to MateryalPH? <Link to="/register">Register your store</Link></p>
          </form>}
    </VendorAuthShell>
  )
}

function RegisterPage() {
  const navigate = useNavigate()
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'error' | 'success'; text: string } | null>(null)
  const [fieldErrors, setFieldErrors] = useState<ValidationFieldErrors>({})
  const [validationFallback, setValidationFallback] = useState<string | null>(null)
  const [useEmailCheck, setUseEmailCheck] = useState(false)
  const [captchaToken, setCaptchaToken] = useState<string | null>(null)
  const captchaRef = useRef<VendorRecaptchaCheckboxRef>(null)
  const focusValidationOnRender = useRef(false)
  const [challenge, setChallenge] = useState<RiskChallenge | null>(null)
  const [pending, setPending] = useState<Parameters<typeof registerVendor>[0] | null>(null)

  useEffect(() => {
    if (!focusValidationOnRender.current) return
    focusValidationOnRender.current = false
    const firstField = registerValidationFocusOrder.find((field) => fieldErrors[field]?.length)
    const target = firstField ? registerValidationTargets[firstField] ?? 'registration-form-error' : 'registration-form-error'
    window.requestAnimationFrame(() => document.getElementById(target)?.focus())
  }, [fieldErrors])

  function clearFieldErrors(...fields: string[]) {
    if (!fields.some((field) => fieldErrors[field]?.length)) return
    const next = { ...fieldErrors }
    fields.forEach((field) => delete next[field])
    setFieldErrors(next)
    if (Object.keys(next).length === 0) setValidationFallback(null)
  }

  const fieldError = (field: string) => fieldErrors[field]?.[0] ?? ''
  const captchaErrors = [...new Set([
    ...(fieldErrors.bot_protection ?? []),
    ...(fieldErrors['bot_protection.recaptcha_token'] ?? []),
  ])]
  const validationMessage = validationFallback ? validationSummary(validationFallback, fieldErrors) : null
  const displayedMessage = validationMessage ? { tone: 'error' as const, text: validationMessage } : message

  async function attempt(request: Parameters<typeof registerVendor>[0], verified = false) {
    const evidence = verified
      ? webCookieBotEvidence()
      : vendorBotEvidence(captchaToken, useEmailCheck)
    await registerVendor(request, evidence)
    navigate('/verify-email', { state: { email: request.email.trim() } })
  }

  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    setBusy(true)
    setMessage(null)
    setFieldErrors({})
    setValidationFallback(null)
    const data = new FormData(event.currentTarget)
    const request = {
      fullName: String(data.get('full_name')),
      email: String(data.get('email')),
      mobileE164: String(data.get('mobile')),
      password: String(data.get('password')),
      passwordConfirmation: String(data.get('password_confirmation')),
      termsAccepted: true,
      privacyAccepted: true,
    } as Parameters<typeof registerVendor>[0]
    setPending(request)
    try {
      await attempt(request)
    } catch (error) {
      const stepUp = await asBotStepUpRequired(error)
      if (stepUp) setChallenge(stepUp.challenge)
      else {
        const validation = await asValidationFailure(error)
        if (validation) {
          focusValidationOnRender.current = true
          setValidationFallback(validation.message)
          setFieldErrors(validation.fieldErrors)
        } else {
          setMessage({ tone: 'error', text: await readableApiError(error) })
        }
      }
    } finally {
      captchaRef.current?.reset()
      setBusy(false)
    }
  }

  return (
    <VendorAuthShell scrollPanel title="Register your store" description="Create the Vendor Owner account first. Store activation follows a separate reviewed process.">
      {challenge && pending
        ? <RiskOtpPanel challenge={challenge} email={pending.email} onCancel={() => { setChallenge(null); setPending(null) }} onVerified={() => attempt(pending, true)} />
        : <form className="auth-form" onSubmit={submit}>
            {displayedMessage && <div id="registration-form-error" tabIndex={displayedMessage.tone === 'error' ? -1 : undefined}><StatusMessage tone={displayedMessage.tone}>{displayedMessage.text}</StatusMessage></div>}
            <Link className={googleButtonClassName} to="/register/google"><GoogleMark />Register with Google</Link>
            <div className="auth-divider"><span>or register with email</span></div>
            <Field error={fieldError('full_name')} label="Account Owner Name" name="full_name" autoComplete="name" maxLength={160} onChange={() => clearFieldErrors('full_name')} required />
            <Field error={fieldError('email')} label="Email address" name="email" type="email" autoComplete="email" onChange={() => clearFieldErrors('email')} required />
            <PhoneField id="mobile" error={fieldError('mobile_e164')} label="Mobile number" name="mobile" onChange={() => clearFieldErrors('mobile_e164')} required />
            <PasswordField error={fieldError('password')} label="Password" name="password" autoComplete="new-password" minLength={12} onChange={() => clearFieldErrors('password', 'password_confirmation')} required />
            <Field error={fieldError('password_confirmation')} label="Confirm password" name="password_confirmation" type="password" autoComplete="new-password" minLength={12} onChange={() => clearFieldErrors('password_confirmation', 'password')} required />
            <div className="grid gap-2">
              <label className="consent"><input aria-describedby={fieldError('terms_accepted') ? 'terms_accepted-error' : undefined} aria-invalid={fieldError('terms_accepted') ? true : undefined} id="terms_accepted" name="terms_accepted" type="checkbox" onChange={() => clearFieldErrors('terms_accepted')} required /><span>I accept the versioned <Link to="/legal/terms-of-service" target="_blank" rel="noopener noreferrer" aria-label="Terms of Service (opens in a new tab)">Terms of Service</Link>.</span></label>
              {fieldError('terms_accepted') && <p className="text-sm text-status-error" id="terms_accepted-error" role="alert">{fieldError('terms_accepted')}</p>}
            </div>
            <div className="grid gap-2">
              <label className="consent"><input aria-describedby={fieldError('privacy_accepted') ? 'privacy_accepted-error' : undefined} aria-invalid={fieldError('privacy_accepted') ? true : undefined} id="privacy_accepted" name="privacy_accepted" type="checkbox" onChange={() => clearFieldErrors('privacy_accepted')} required /><span>I acknowledge the separate <Link to="/legal/privacy-notice" target="_blank" rel="noopener noreferrer" aria-label="Privacy Notice (opens in a new tab)">Privacy Notice</Link>.</span></label>
              {fieldError('privacy_accepted') && <p className="text-sm text-status-error" id="privacy_accepted-error" role="alert">{fieldError('privacy_accepted')}</p>}
            </div>
            <BotProtectionFields disabled={busy} emailCheckSelected={useEmailCheck} onEmailCheckClick={() => { captchaRef.current?.reset(); clearFieldErrors('bot_protection', 'bot_protection.recaptcha_token'); setUseEmailCheck((value) => !value) }} checkbox={
              !useEmailCheck && <VendorRecaptchaCheckbox ref={captchaRef} action="vendor_register" disabled={busy} id="vendor-registration-captcha" validationError={captchaErrors.join(' ')} onTokenChange={(token) => { setCaptchaToken(token); if (token) clearFieldErrors('bot_protection', 'bot_protection.recaptcha_token') }} />
            }>
              <Button className="w-full" type="submit" disabled={busy}>{busy ? 'Creating account…' : 'Create Owner account'} <ArrowRight aria-hidden="true" /></Button>
            </BotProtectionFields>
            <p className="auth-switch">Already registered? <Link to="/login">Sign in</Link></p>
          </form>}
    </VendorAuthShell>
  )
}

const registerValidationTargets: Readonly<Record<string, string>> = {
  full_name: 'full_name',
  email: 'email',
  mobile_e164: 'mobile',
  password: 'password',
  password_confirmation: 'password_confirmation',
  terms_accepted: 'terms_accepted',
  privacy_accepted: 'privacy_accepted',
  bot_protection: 'vendor-registration-captcha',
  'bot_protection.recaptcha_token': 'vendor-registration-captcha',
}

const registerValidationFocusOrder = Object.keys(registerValidationTargets)

function validationSummary(fallback: string, fieldErrors: ValidationFieldErrors): string {
  const entries = Object.entries(fieldErrors)
  const unknownMessages = entries
    .filter(([field]) => !(field in registerValidationTargets))
    .flatMap(([, messages]) => messages)
  const messages = unknownMessages.length > 0 ? unknownMessages : entries.flatMap(([, values]) => values)
  return [...new Set(messages)].join(' ') || fallback
}

function InfoPage({ title, children }: { title: string; children: ReactNode }) {
  return (
    <>
      <BrandHeader />
      <main className="info-page" id="main-content">
        <h1>{title}</h1>
        {children}
        <Link className="button button--primary" to="/register">Register your store <ArrowRight aria-hidden="true" /></Link>
      </main>
      <SiteFooter />
    </>
  )
}

function FeesContent() {
  const policy = useCommissionPolicy(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1')
  return <div className="info-copy"><p><strong>Vendor-paid monthly platform commission:</strong> current rate {policy.data?.current?.rateLabel ?? 'unavailable'}. <Link to="/commission-terms">Review the effective Commission Terms</Link>. It applies only to completed materials after Vendor discounts and excluding included materials VAT.</p>{policy.error && <p role="alert">{policy.error} <Button variant="secondary" onClick={policy.reload}>Retry policy</Button></p>}<p>E-wallet transaction fees, Vendor commission liability, monthly settlement, withholding scenarios, refunds, and dispute adjustments remain separate records. Commission and e-wallet transaction fees are explained separately so you can understand each charge.</p></div>
}

function VerificationContent() {
  return <div className="info-copy"><p>Activation requires an eligible Vendor Owner, verified email, store and business details, address, required private evidence, and an approved Admin review. Regulated product evidence is a later listing-level decision.</p><p>Exact requirements depend on Vendor classification and reviewed policy; the onboarding checklist shows what is required, optional, in review, or needs action.</p></div>
}

function OpportunitiesContent() {
  return <div className="info-copy"><p>Eligible Vendors can receive Item-Based orders from published listings and direct inquiries from Buyers for Project Work Packages.</p><p>MateryalPH does not provide a public Vendor RFQ bidding queue. A Work Package may have many inquiries but only one selected Vendor outcome.</p></div>
}

function NotFound() {
  return <InfoPage title="Page not found"><div className="info-copy"><p>The requested Vendor page is not available.</p><BackNavigation><Link to="/">Return to the Vendor home page</Link></BackNavigation></div></InfoPage>
}

export default App

