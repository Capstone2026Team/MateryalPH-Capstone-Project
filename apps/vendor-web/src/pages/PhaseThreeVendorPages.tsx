import { useParams } from 'react-router-dom'
import { ProfileDetails, DashboardHeader, SectionWorkspace, PreviewMetrics, CustomLabelInput, OnboardingReview, ChecklistPanel, verificationChecklist, checklistProgress, PrivateEvidenceButton, readWebPrivateFile, XenditConnection, StoreOperationSchedule, StoreHours, emptyStoreSchedule, storeScheduleErrors, type StoreOperatingDay } from '@materyalph/web-ui'
import {
  Activity,
  Bell,
  ChartNoAxesCombined,
  MessageSquare,
  ReceiptText,
  Scale,
  Truck,
  Wallet,
  AlertCircle,
  ArrowRight,
  ArrowLeft,
  CheckCircle2,
  CreditCard,
  FileCheck2,
  FileText,
  ImagePlus,
  LayoutDashboard,
  Package,
  RefreshCw,
  Store,
  UploadCloud,
  Users,
} from 'lucide-react'
import { type FormEvent, type ReactNode, createContext, useContext, useCallback, useEffect, useRef, useState } from 'react'
import { Link, Navigate, useNavigate } from 'react-router-dom'

import {
  AccountWorkspace, VersionedAgreementPanel, VendorTeamInvitations, VendorTeamActivity,
  DeliveryVehicles, emptyDeliveryVehicle, ChoiceField, FieldRow, OnboardingFormSection, EmailVerificationPanel, AuthorityScopePanel, DocumentUploadField,
  Button,
  Field, FormErrors,
  PortalShell,
  PortalAccountMenu,
  ProgressBar,
  StatusBadge,
  StatusMessage,
  type DeliveryVehicleDraft,
  type PortalNavSection,
} from '@materyalph/web-ui'
import { QRCodeSVG } from 'qrcode.react'
import { ResponseError } from '@materyalph/api-client-ts'
import { signOut } from '../lib/auth-api'
import { vehicleDraft, vehiclePayload, vehicleErrors } from '../lib/delivery-vehicles'
import { vendorLoginDestination } from '../lib/vendor-destination'
import type { VendorOnboardingSection } from '@materyalph/api-client-ts'
import { OnboardingFlow, OnboardingStepContent } from '../components/OnboardingFlow'
import { verificationSteps, setupSteps } from '../lib/onboarding-steps'
import { StoreBusinessInformation, StoreLocation, StoreVacationMode } from '../components/StoreProfileSections'
import { VendorBusinessAddress } from '../components/VendorBusinessAddress'
import {
  activateVendorStore, acceptVendorCommission,
  connectVendorPayment,
  reconcileVendorPaymentConnection,
  completeVendorSetup,
  confirmStoreEmailVerification,
  dismissVendorWelcome,
  getVendorOnboarding,
  previewVendorRequirements,
  getVendorPrivateFileUrl,
  inviteVendorTeamMember, listVendorTeamInvitations, listVendorTeamActivity, changeVendorStaffDisputes,
  readableOnboardingError, onboardingFieldErrors, removePendingVendorDocument,
  removeVendorMedia,
  requestStoreEmailVerification,
  saveVendorSetupDraft,
  saveVendorVerificationDraft,
  submitVendorVerification,
  uploadVendorDocument,
  uploadVendorMedia,
  type VendorOnboardingSnapshot,
} from '../lib/onboarding-api'

type JsonRecord = Record<string, ReactNode>
type OnboardingSectionKey = 'STORE_VERIFICATION' | 'STORE_SETUP'

const vendorModules: Record<string, string> = { orders: 'Orders', fulfillment: 'Fulfillment', messages: 'Messages', invoices: 'E-Invoices', notifications: 'Notifications', disputes: 'Disputes & Appeals', products: 'My Products', vehicles: 'Vehicles', wallet: 'Wallet', tracking: 'Team Tracking', performance: 'Store Performance', earnings: 'Earnings' }
const vendorModuleIcons = { orders: FileText, fulfillment: Truck, messages: MessageSquare, invoices: ReceiptText, notifications: Bell, disputes: Scale, products: Package, vehicles: Truck, wallet: Wallet, performance: ChartNoAxesCombined, earnings: CreditCard }
const vendorNavigation: PortalNavSection[] = [
  { label: 'Overview', items: [{ label: 'Dashboard', href: '/dashboard', icon: <LayoutDashboard size={16} aria-hidden="true" /> }] },
  ...[['Store Operations', ['orders', 'fulfillment', 'messages', 'invoices', 'notifications', 'disputes']], ['Store Management', ['products', 'vehicles', 'wallet']], ['Analytics', ['performance', 'earnings']]].map(([label, keys]) => ({ label: label as string, items: (keys as string[]).map(key => ({ label: vendorModules[key] ?? key, href: `/preview/${key}`, icon: (() => { const Icon = vendorModuleIcons[key as keyof typeof vendorModuleIcons]; return <Icon size={18} aria-hidden="true" /> })() })) })),
  { label: 'Vendor Team Accounts', items: [{ label: 'Team Accounts', href: '/team', icon: <Users size={16} aria-hidden="true" /> }, { label: 'Team Tracking', href: '/preview/tracking', icon: <Activity size={16} aria-hidden="true" /> }] },
  { label: 'Store Profile', items: [{ label: 'Store Profile', href: '/store-profile', icon: <Store size={16} aria-hidden="true" /> }] },
]

export function VendorPlaceholderPage() {
  const { module = '' } = useParams()
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  if (loading) return <LoadingState />
  if (error) return <ErrorState message={error} onRetry={() => void refresh()} />
  if (!snapshot) return null
  if (module === 'tracking' && snapshot.permissions.includes('staff.manage')) return <VendorShell navigationData={snapshot} activeHref="/preview/tracking" accountLabel={stringValue(record(snapshot.organization).storeName, 'Vendor')}><VendorTeamActivity list={listVendorTeamActivity} explainError={readableOnboardingError} /></VendorShell>
  if (record(snapshot.activation).status !== 'ACTIVE' || !vendorModules[module] || !snapshot.permissions.includes(`portal.${module}`)) return <Navigate to="/dashboard" replace />
  return <VendorShell navigationData={snapshot} activeHref={`/preview/${module}`} accountLabel={stringValue(record(snapshot.organization).storeName, 'Vendor')}><h1 className="text-3xl font-semibold">{vendorModules[module]}</h1><p className="mt-6 text-text-secondary">Not yet implemented</p></VendorShell>
}

function portalDate(): string {
  return new Intl.DateTimeFormat('en-PH', { dateStyle: 'full', timeZone: 'Asia/Manila' }).format(new Date())
}

function camelCaseKey(key: string): string {
  return key.replace(/_([a-z])/g, (_, letter: string) => letter.toUpperCase())
}

function record(value: unknown): JsonRecord {
  if (typeof value !== 'object' || value === null || Array.isArray(value)) return {}

  const source = value as Record<string, unknown>
  const normalized: Record<string, unknown> = { ...source }
  Object.entries(source).forEach(([key, entry]) => {
    const camelKey = camelCaseKey(key)
    if (!(camelKey in normalized)) normalized[camelKey] = entry
  })
  return normalized as JsonRecord
}

function stringValue(value: unknown, fallback = ''): string {
  if (typeof value === 'string') return value
  if (typeof value === 'number' && Number.isFinite(value)) return String(value)
  if (typeof value === 'boolean') return value ? 'true' : 'false'
  return fallback
}

function numberValue(value: unknown, fallback = 0): number {
  return typeof value === 'number' && Number.isFinite(value) ? value : fallback
}



function booleanValue(value: unknown, fallback = false): boolean {
  return typeof value === 'boolean' ? value : fallback
}

function arrayValue(value: unknown): JsonRecord[] {
  return Array.isArray(value) ? value.map(record) : []
}

function sectionFor(snapshot: VendorOnboardingSnapshot, key: OnboardingSectionKey): VendorOnboardingSection {
  return snapshot.sections[key] ?? { key, label: key === 'STORE_VERIFICATION' ? 'Store Verification' : 'Store Setup', status: 'NOT_STARTED', complete: 0, total: 0, progress: { complete: 0, total: 0 }, steps: [] }
}

function statusTone(status: string): 'neutral' | 'warning' | 'success' | 'error' | 'info' {
  if (['APPROVED', 'COMPLETED', 'COMPLETE', 'ACTIVE', 'CONNECTED', 'CONNECTED_TEST', 'READY'].includes(status)) return 'success'
  if (['CHANGES_REQUIRED', 'IN_PROGRESS', 'PENDING_VERIFICATION', 'PENDING', 'NOT_READY', 'UNVERIFIED'].includes(status)) return 'warning'
  if (['REJECTED', 'EXPIRED', 'FAILED', 'RESTRICTED', 'SUSPENDED'].includes(status)) return 'error'
  if (['SUBMITTED', 'SUBMITTED'].includes(status)) return 'info'
  return 'neutral'
}

function statusLabel(status: string): string {
  return status.replaceAll('_', ' ').toLowerCase().replace(/(^|\s)\S/g, (letter) => letter.toUpperCase())
}

function dateInput(value: unknown): string {
  const raw = stringValue(value)
  return raw.length >= 10 ? raw.slice(0, 10) : raw
}

function LoadingState({ label = 'Loading onboarding workspace…' }: { label?: string }) {
  return <div className="grid min-h-64 place-items-center rounded-surface border border-border-default bg-surface-primary p-8 text-center"><RefreshCw className="animate-spin text-action-primary" size={24} aria-hidden="true" /><p className="mt-3 text-sm text-text-secondary">{label}</p></div>
}

function ErrorState({ message, onRetry }: { message: string; onRetry: () => void }) {
  return <div className="grid gap-4 rounded-surface border border-status-error/30 bg-red-50 p-6 text-sm text-red-900" role="alert"><div className="flex items-start gap-3"><AlertCircle className="mt-0.5 shrink-0" size={20} aria-hidden="true" /><p>{message}</p></div><Button className="w-fit" variant="secondary" onClick={onRetry}><RefreshCw size={16} aria-hidden="true" /> Try again</Button></div>
}

function PageHeader({ eyebrow, title, description, status, actions }: { eyebrow: string; title: string; description: string; status?: string; actions?: ReactNode }) {
  return <div className="flex flex-col gap-5 border-b border-border-default pb-7 lg:flex-row lg:items-end lg:justify-between"><div className="max-w-3xl"><p className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">{eyebrow}</p><div className="mt-3 flex flex-wrap items-center gap-3"><h1 className="text-3xl font-semibold tracking-tight text-text-strong sm:text-4xl">{title}</h1>{status && <StatusBadge label={statusLabel(status)} tone={statusTone(status)} />}</div><p className="mt-3 max-w-2xl text-base leading-7 text-text-secondary">{description}</p></div>{actions && <div className="flex shrink-0 flex-wrap gap-3">{actions}</div>}</div>
}

function Checklist({ title, section }: { title: string; section: ReturnType<typeof sectionFor> }) {
  const steps = section.steps.filter(item => item.status !== 'NOT_APPLICABLE')
  const items = section.key === 'STORE_VERIFICATION' ? verificationChecklist(steps) : steps.map(item => ({ ...item, requirements: [item] }))
  const { complete } = checklistProgress(section)
  return <ChecklistPanel title={title} items={items}><p className="mt-2 text-sm text-text-secondary">{complete} of {items.length} checklist items complete.</p><div className="mt-3"><ProgressBar value={items.length ? complete / items.length * 100 : 0} label={`${complete} of ${items.length} complete`} /></div></ChecklistPanel>
}


export function VendorShell({ activeHref, accountLabel, accountStatus, children, navigationData, refreshError }: { refreshError?: string | null; navigationData?: VendorOnboardingSnapshot | null; activeHref: string; accountLabel: string; accountStatus?: string; children: ReactNode }) {
  const navigate = useNavigate()
  const { snapshot: shellSnapshot } = useOnboardingSnapshot(navigationData === undefined)
  const navigationSnapshot = navigationData === undefined ? shellSnapshot : navigationData
  const logoFileId = stringValue(arrayValue(record(navigationSnapshot?.setup).media).filter(item => item.kind === 'LOGO').at(-1)?.fileId)
  const [storeLogoUrl, setStoreLogoUrl] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    setStoreLogoUrl(null)
    if (logoFileId) void getVendorPrivateFileUrl(logoFileId).then(result => { if (active) setStoreLogoUrl(result.url) }).catch(() => { if (active) setStoreLogoUrl(null) })
    return () => { active = false }
  }, [logoFileId])
  const navigation = vendorNavigation.map(section => ({
    ...section, items: section.items.filter(item => {
      if (!navigationSnapshot) return item.href === '/dashboard'
      if (item.href === '/team') return navigationSnapshot.permissions.includes('staff.manage')
      if (item.href.startsWith('/preview/')) return navigationSnapshot.permissions.includes(`portal.${item.href.split('/').at(-1)}`)
      return true
    }).map(item => ({
      ...item, disabled: item.disabled || (item.href.startsWith('/preview/') && item.href !== '/preview/tracking' && record(navigationSnapshot?.activation).status !== 'ACTIVE'),
    })),
  })).filter(section => section.items.length > 0)
  const [logoutError, setLogoutError] = useState<string | null>(null)
  const [signingOut, setSigningOut] = useState(false)
  async function logout() {
    setSigningOut(true); setLogoutError(null)
    try { await signOut(); navigate('/login', { replace: true }) }
    catch (cause) { setLogoutError(await readableOnboardingError(cause)) }
    finally { setSigningOut(false) }
  }
  if (activeHref === '/welcome' || activeHref.startsWith('/onboarding')) return <div className="min-h-screen bg-surface-canvas text-text-strong"><header className="flex flex-wrap items-center justify-between gap-3 border-b border-border-default bg-surface-primary px-6 py-4"><Link to="/dashboard" className="text-xl font-bold">Materyal<span className="text-action-primary">PH</span></Link><p className="text-xs text-text-secondary" aria-label="System date">{portalDate()}</p><PortalAccountMenu portal="vendors" basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} onNavigate={navigate} onSignOut={logout} /></header><main className="mx-auto max-w-7xl p-5 sm:p-8">{refreshError && <StatusMessage tone="error">{refreshError}</StatusMessage>}{children}</main></div>
  return <PortalShell apiBasePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} onSignOut={logout} onNavigate={navigate} portalLabel="VENDOR PORTAL" pageTitle={activeHref === '/settings' ? 'Settings' : activeHref === '/store-profile' ? 'Store Profile' : activeHref.includes('onboarding') ? 'Vendor Onboarding' : vendorNavigation.flatMap(section => section.items).find(item => item.href === activeHref)?.label ?? 'Dashboard'} dateLabel={portalDate()} sections={navigation} activeHref={activeHref} accountLabel={accountLabel} accountStatus={accountStatus ?? 'Vendor account'} accountAvatarUrl={storeLogoUrl} headerActions={<><Link className="inline-flex min-h-11 items-center px-3 text-sm font-semibold" to="/settings">Account</Link><Button variant="secondary" disabled={signingOut} onClick={() => void logout()}>{signingOut ? 'Signing out…' : 'Sign out'}</Button></>}>{logoutError && <StatusMessage tone="error">{logoutError}</StatusMessage>}{refreshError && navigationSnapshot && <StatusMessage tone="error">{refreshError}</StatusMessage>}{children}</PortalShell>
}

function useOnboardingSnapshot(enabled = true) {
  const navigate = useNavigate()
  const [snapshot, setSnapshot] = useState<VendorOnboardingSnapshot | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const publish = useCallback((updated: VendorOnboardingSnapshot) => {
    setSnapshot(current => current && numberValue(current.lockVersion, 0) > numberValue(updated.lockVersion, 0) ? current : updated)
  }, [])

  const refresh = useCallback(async () => {
    setLoading(true)
    setError(null)
    try {
      publish(await getVendorOnboarding())
    } catch (cause) {
      if (cause instanceof ResponseError && cause.response.status === 401) navigate('/login', { replace: true })
      else setError(await readableOnboardingError(cause))
    } finally {
      setLoading(false)
    }
  }, [navigate, publish])

  useEffect(() => { if (enabled) void refresh() }, [refresh, enabled])
  return { snapshot, loading, error, refresh, setSnapshot: publish }
}

export function VendorWelcomePage() {
  const navigate = useNavigate()
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  const [busy, setBusy] = useState(false)

  useEffect(() => {
    if (snapshot && !snapshot.welcomeRequired) navigate(vendorLoginDestination(snapshot), { replace: true })
  }, [navigate, snapshot])

  async function continueOnboarding() {
    setBusy(true)
    try { await dismissVendorWelcome(); navigate('/onboarding/verification', { replace: true }) } catch (cause) { window.alert(await readableOnboardingError(cause)) } finally { setBusy(false) }
  }

  if (loading && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/welcome" accountLabel="Vendor Owner"><LoadingState /></VendorShell>
  if (error && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/welcome" accountLabel="Vendor Owner"><ErrorState message={error} onRetry={() => void refresh()} /></VendorShell>
  if (!snapshot) return null

  const org = record(snapshot.organization)
  return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/welcome" accountLabel={stringValue(org.storeName, 'Vendor Owner')} accountStatus="Pending onboarding"><div className="mx-auto flex min-h-[calc(100vh-10rem)] max-w-3xl items-center justify-center"><section className="w-full border-y border-border-default py-12 text-center sm:py-16"><div className="mx-auto grid h-16 w-16 place-items-center rounded-full bg-brand-orange-50 text-action-primary"><Store size={30} aria-hidden="true" /></div><p className="mt-7 text-xs font-semibold uppercase tracking-[0.15em] text-action-primary">Welcome to MateryalPH</p><h1 className="mt-3 text-4xl font-semibold tracking-tight sm:text-5xl">Let’s prepare your store for review.</h1><p className="mx-auto mt-5 max-w-2xl text-base leading-7 text-text-secondary">Complete Store Verification for business review, then finish Store Setup so Buyers see an accurate, trustworthy store when your activation is approved.</p><div className="mx-auto mt-8 grid max-w-2xl gap-3 text-left sm:grid-cols-2"><WelcomeTrack icon={<FileCheck2 size={20} aria-hidden="true" />} title="Store Verification" text="Business identity, address, classification, tax profile, and private evidence." /><WelcomeTrack icon={<Store size={20} aria-hidden="true" />} title="Store Setup" text="Public profile, fulfillment, payment connection, and the TEST commission terms." /></div><div className="mt-9 flex flex-wrap justify-center gap-3"><Button disabled={busy} onClick={() => void continueOnboarding()}>{busy ? 'Saving…' : 'Continue'} <ArrowRight size={16} aria-hidden="true" /></Button></div><p className="mx-auto mt-5 max-w-xl text-xs leading-5 text-text-secondary">You can save drafts and return later. Store Setup can be completed while Store Verification is pending, but Store Activation stays gated until all required decisions are complete.</p></section></div></VendorShell>
}

function WelcomeTrack({ icon, title, text }: { icon: ReactNode; title: string; text: string }) {
  return <div className="flex gap-3 border border-border-default bg-surface-primary p-4"><div className="mt-0.5 text-action-primary">{icon}</div><div><h2 className="font-semibold">{title}</h2><p className="mt-1 text-sm leading-6 text-text-secondary">{text}</p></div></div>
}

export function VendorDashboardPage() {
  const { snapshot, loading, error, refresh, setSnapshot } = useOnboardingSnapshot()
  const [actionMessage, setActionMessage] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)

  async function activate() {
    setBusy(true); setActionMessage(null)
    try { setSnapshot(await activateVendorStore()); setActionMessage('Activation request recorded. Discoverability remains independently gated.') } catch (cause) { setActionMessage(await readableOnboardingError(cause)) } finally { setBusy(false) }
  }

  if (loading && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/dashboard" accountLabel="Vendor Owner"><LoadingState /></VendorShell>
  if (error && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/dashboard" accountLabel="Vendor Owner"><ErrorState message={error} onRetry={() => void refresh()} /></VendorShell>
  if (!snapshot) return null
  if (snapshot.welcomeRequired) return <Navigate to="/welcome" replace />
  const org = record(snapshot.organization)
  const activation = record(snapshot.activation)
  const readiness = record(activation.readiness)
  const verificationSection = sectionFor(snapshot, 'STORE_VERIFICATION')
  const setupSection = sectionFor(snapshot, 'STORE_SETUP')
  const verificationStatus = stringValue(record(snapshot.verification).status, 'NOT_STARTED')
  const setupStatus = stringValue(record(snapshot.setup).status, 'NOT_STARTED')
  const setupProgress = checklistProgress(setupSection)
  const activationBlockers = arrayValue(readiness.blockers)
  const accountLabel = stringValue(org.storeName, stringValue(org.legalName, 'Vendor Owner'))
  if (!snapshot.permissions.includes('vendor.onboarding.submit')) return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/dashboard" accountLabel={accountLabel} accountStatus={activation.status === 'ACTIVE' ? 'Store Active' : 'Limited access'}><div className="space-y-6"><DashboardHeader eyebrow={accountLabel} title="Your team dashboard" description={activation.status === 'ACTIVE' ? 'Use the sections available for your assigned role. Organization and assignment restrictions apply to every action.' : 'This store is not yet active for marketplace participation. Required onboarding and verification must be completed before marketplace features become available.'} /><p className="text-sm text-text-secondary">Your individual account is connected to this store. The Vendor Owner manages onboarding and protected store settings.</p><Link to="/settings" className="inline-flex min-h-11 items-center text-action-primary underline">My Account Profile</Link></div></VendorShell>
  if (activation.status === 'ACTIVE') return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/dashboard" accountLabel={accountLabel} accountStatus="Store Active"><div className="space-y-6"><DashboardHeader eyebrow={accountLabel} title="Dashboard" description="Your store is active. Operational metrics below are design previews, not live results." status={<StatusBadge label="Active" tone="success" />} /><SectionWorkspace dateFilter sections={[
    { label: 'Overview', content: <PreviewMetrics labels={['Response time', 'Pending fulfillment', 'Sales & revenue', 'Store visitors', 'Quality summary', 'Important tasks']} /> },
    { label: 'Performance', content: <PreviewMetrics labels={['Response rate / time', 'Order processing time', 'Cancellation rate', 'Return rate']} /> },
    { label: 'Action Items & Alerts', content: <PreviewMetrics labels={['Pending fulfillment', 'To-do checklist', 'System notifications']} /> },
    { label: 'Sales & Revenue', content: <PreviewMetrics labels={['Earnings', 'Sales', 'Average order value', 'Revenue trend']} /> },
    { label: 'Traffic & Volume', content: <PreviewMetrics labels={['Store visitors', 'Listing views', 'Engagement', 'Traffic trend']} /> },
    { label: 'Disputes & Quality', content: <PreviewMetrics labels={['Open disputes', 'Refund-related cases', 'Returns', 'Complaints', 'Product issues', 'Fulfillment issues']} /> },
  ]} /><p className="text-sm text-text-secondary">Marketplace discoverability: {statusLabel(stringValue(activation.marketplaceDiscoverabilityStatus, 'NO_ACTIVE_LISTINGS'))}. Eligible published listings remain required.</p></div></VendorShell>

  return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/dashboard" accountLabel={accountLabel} accountStatus={`${statusLabel(stringValue(activation.status, 'NOT_READY'))} activation`}>
    <div className="phase3-page space-y-6">
      <DashboardHeader eyebrow="Limited-Access Vendor Dashboard" title={`Welcome back, ${accountLabel}.`} description={booleanValue(readiness.ready) ? 'Your store meets the activation requirements. Request Store Activation to unlock the marketplace features allowed for your role.' : 'Your store is not active yet. Review the activation requirements below; checklist progress alone does not grant marketplace access.'} status={<StatusBadge label={statusLabel(stringValue(activation.status, 'NOT_READY'))} tone="warning" />} />
      {actionMessage && <StatusMessage tone={actionMessage.includes('recorded') ? 'success' : 'error'}>{actionMessage}</StatusMessage>}
      {!booleanValue(readiness.ready) && <section aria-label="Store activation requirements" className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-6"><h2 className="text-lg font-semibold">Store activation requirements</h2>{activationBlockers.length ? <><p className="mt-2 text-sm text-text-secondary">The server reports these items before your store can be activated:</p><ul className="mt-4 list-disc space-y-2 pl-5 text-sm text-text-strong">{activationBlockers.map((blocker, index) => <li key={`${stringValue(blocker.key)}-${index}`}>{stringValue(blocker.reason, 'An activation requirement needs attention.')}</li>)}</ul></> : <p className="mt-2 text-sm text-text-secondary">Activation readiness is unavailable. Refresh the dashboard to check the current requirements.</p>}<Button className="mt-4" variant="secondary" disabled={loading} onClick={() => void refresh()}><RefreshCw size={16} aria-hidden="true" /> Refresh status</Button></section>}
      {booleanValue(readiness.ready) && <Button className="w-fit" disabled={busy} onClick={() => void activate()}>{busy ? 'Recording…' : 'Request Store Activation'} <ArrowRight size={16} aria-hidden="true" /></Button>}
      <div className="grid gap-5 lg:grid-cols-2">
        <div className="space-y-3"><Checklist title="Store Verification" section={verificationSection} /><p className="text-sm text-text-secondary">Review status: <strong className="text-text-strong">{statusLabel(verificationStatus)}</strong></p><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary" to="/onboarding/verification">{verificationStatus === 'APPROVED' ? 'Review Store Verification' : 'Continue Store Verification / Review requirements'}</Link></div>
        <div className="space-y-3"><Checklist title="Store Setup" section={setupSection} /><p className="text-sm text-text-secondary">Setup status: <strong className="text-text-strong">{statusLabel(setupStatus)}</strong></p><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary" to="/onboarding/setup">{setupStatus === 'COMPLETED' ? 'Review Store Setup' : setupProgress.total > 0 && setupProgress.complete === setupProgress.total ? 'Complete Store Setup' : 'Continue Store Setup'}</Link></div>
      </div>
    </div>
  </VendorShell>
}

export function VendorVerificationPage() {
  return <VendorOnboardingPage initialSection="STORE_VERIFICATION" />
}

export function VendorSetupPage() {
  return <VendorOnboardingPage initialSection="STORE_SETUP" />
}

function VendorOnboardingPage({ initialSection }: { initialSection: OnboardingSectionKey }) {
  const { snapshot, loading, error, refresh, setSnapshot } = useOnboardingSnapshot()
  const activeSection = initialSection

  if (loading && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref={initialSection === 'STORE_SETUP' ? '/onboarding/setup' : '/onboarding/verification'} accountLabel="Vendor Owner"><LoadingState /></VendorShell>
  if (error && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref={initialSection === 'STORE_SETUP' ? '/onboarding/setup' : '/onboarding/verification'} accountLabel="Vendor Owner"><ErrorState message={error} onRetry={() => void refresh()} /></VendorShell>
  if (!snapshot) return null
  const org = record(snapshot.organization)
  if (!snapshot.permissions.includes('vendor.onboarding.manage')) return <Navigate to="/dashboard" replace />
  const accountLabel = stringValue(org.storeName, 'Vendor Owner')
  const verificationSection = sectionFor(snapshot, 'STORE_VERIFICATION')
  const setupSection = sectionFor(snapshot, 'STORE_SETUP')
  const activeHref = activeSection === 'STORE_SETUP' ? '/onboarding/setup' : '/onboarding/verification'

  return <VendorShell refreshError={error} navigationData={snapshot} activeHref={activeHref} accountLabel={accountLabel} accountStatus="Onboarding in progress"><div className="phase3-page mx-auto max-w-[1120px] space-y-8"><header className="space-y-4">
        <Link className="inline-flex min-h-11 items-center gap-2 text-sm font-medium text-text-secondary hover:text-action-primary" to="/dashboard"><ArrowLeft size={16} aria-hidden="true" />Back to dashboard</Link>
        <div className="grid items-start gap-6 lg:grid-cols-[minmax(0,1fr)_22rem] lg:gap-10">
          <div className="min-w-0">
            <p className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">Store onboarding</p>
            <div className="mt-2 flex flex-wrap items-center gap-x-4 gap-y-2">
              <h1 className="text-3xl font-semibold tracking-tight text-text-strong sm:text-4xl">{activeSection === 'STORE_SETUP' ? 'Store Setup' : 'Store Verification'}</h1>
              <StatusBadge label={statusLabel(stringValue(record(activeSection === 'STORE_SETUP' ? snapshot.setup : snapshot.verification).status, 'NOT_STARTED'))} tone={statusTone(stringValue(record(activeSection === 'STORE_SETUP' ? snapshot.setup : snapshot.verification).status, 'NOT_STARTED'))} />
            </div>
            <p className="mt-3 max-w-2xl text-base leading-7 text-text-secondary">{activeSection === 'STORE_SETUP' ? 'Configure your public store profile, fulfillment and TEST payment connection. Store Setup is separate from Admin business verification.' : 'Provide your business information and private evidence for Admin review before Store Activation.'}</p>
          </div>
          <div className="min-w-0 space-y-2">
            <p className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Onboarding area</p>
            <nav aria-label="Onboarding area" className="grid grid-cols-2 gap-1 rounded-surface border border-border-default bg-surface-primary p-1">
              <SectionTab active={activeSection === 'STORE_VERIFICATION'} href="/onboarding/verification" label="Store Verification" description={`${checklistProgress(verificationSection).complete}/${checklistProgress(verificationSection).total} checklist items complete`} />
              <SectionTab active={activeSection === 'STORE_SETUP'} href="/onboarding/setup" label="Store Setup" description={`${checklistProgress(setupSection).complete}/${checklistProgress(setupSection).total} checklist items complete`} />
            </nav>
          </div>
        </div>
      </header>{activeSection === 'STORE_VERIFICATION' ? <VerificationWorkspace snapshot={snapshot} onSaved={setSnapshot} onRefresh={refresh} /> : <SetupWorkspace snapshot={snapshot} onSaved={setSnapshot} onRefresh={refresh} />}</div></VendorShell>
}

function SectionTab({ active, href, label, description }: { active: boolean; href: string; label: string; description: string }) {
  return <Link className={`grid min-h-16 min-w-0 content-center gap-1 rounded-control border px-3 py-3 text-sm leading-5 no-underline transition-colors ${active ? 'border-action-primary bg-brand-orange-50 text-action-primary' : 'border-transparent text-text-secondary hover:bg-surface-canvas hover:text-text-strong'}`} aria-current={active ? 'page' : undefined} to={href}><span className="font-semibold">{label}</span><span className="text-xs text-text-secondary">{description}</span></Link>
}

function VerificationWorkspace({ snapshot, onSaved, onRefresh }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; onRefresh: () => Promise<void> }) {
  const [reviewing, setReviewing] = useState(false)
  if (record(snapshot.verification).status === 'PENDING_VERIFICATION' && !reviewing) return <section className="mx-auto max-w-2xl space-y-6 border-y border-border-default py-10 text-center"><CheckCircle2 className="mx-auto text-status-success" size={40} aria-hidden="true" /><h2 className="text-2xl font-semibold">Business information and documentation successfully submitted.</h2><p className="text-text-secondary">Your Store Verification is awaiting Admin review. You may start Store Setup now; Store Activation remains subject to all required approvals.</p><PendingTaxAttestation snapshot={snapshot} onSaved={onSaved} /><div className="flex flex-wrap justify-center gap-4"><Link className="inline-flex min-h-11 items-center rounded-control bg-action-primary px-5 font-semibold text-white" to="/onboarding/setup">Proceed to Store Setup</Link><Button variant="secondary" onClick={() => setReviewing(true)}>Review submitted information</Button></div></section>
  return <VerificationForm key={['PENDING_VERIFICATION', 'APPROVED'].includes(stringValue(record(snapshot.verification).status)) ? 'submitted' : 'editable'} snapshot={snapshot} onSaved={onSaved} onRefresh={onRefresh} />
}

function PendingTaxAttestation({ snapshot, onSaved }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void }) {
  const verification = record(snapshot.verification)
  const review = record(verification.authorityReview)
  const tax = record(verification.taxProfile)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const approved = sectionFor(snapshot, 'STORE_VERIFICATION').steps.some(step => step.key === 'authority_to_act' && step.status === 'APPROVED')
  if (tax.ownerAttested || !snapshot.permissions.includes('vendor.onboarding.submit') || !record(verification.representative).sameAsOwner || !approved || review.decision !== 'APPROVED' || !stringValue(review.scope).split(',').includes('TAX_DECLARATIONS')) return null
  async function attest() {
    setBusy(true); setError('')
    try { onSaved(await saveVendorVerificationDraft({ lockVersion: numberValue(record(snapshot.organization).lockVersion, 1), taxProfile: { ownerAttested: true } })) }
    catch (cause) { setError(await readableOnboardingError(cause)) }
    finally { setBusy(false) }
  }
  return <div className="grid gap-3 rounded-control border border-border-default p-4 text-left"><p>Admin approved your Authority to Act. Confirm that the submitted tax information is accurate to complete your declaration.</p><Button type="button" disabled={busy} onClick={() => void attest()}>{busy ? 'Confirming…' : 'Confirm tax declaration'}</Button>{error && <p role="alert" className="text-sm text-status-error">{error}</p>}</div>
}

type PendingDocumentContext = {
  editing?: boolean; files: Record<string, File>; pending: JsonRecord[]; errors: Record<string, string>; busy: boolean; select: (key: string, file: File | null) => void }
const PendingDocuments = createContext<PendingDocumentContext>({ files: {}, pending: [], errors: {}, busy: false, select: () => {} })

function InlineError({ name }: { name: string }) {
  const errors = useContext(FormErrors)
  return errors[name] ? <p id={`${name}-error`} role="alert" className="text-sm text-status-error">{errors[name]}</p> : null
}

function verificationErrorName(key: string): string {
  const aliases: Record<string, string> = {
    'legal_identity.individual_registered_surname': 'individual_surname', 'legal_identity.surname': 'individual_surname',
    'legal_identity.individual_registered_first_name': 'individual_first_name', 'legal_identity.first_name': 'individual_first_name',
    'legal_identity.identity_id_type': 'identity_id_type', 'legal_identity.id_type': 'identity_id_type',
    'legal_identity.identity_id_number_last4': 'identity_id_number', 'legal_identity.id_number': 'identity_id_number',
    'legal_identity.company_registered_name': 'company_registered_name', 'representative.full_name': 'representative_name',
    'representative.relationship': 'representative_relationship', 'representative.id_number_last4': 'representative_id_number',
    'store_email_verified_at': 'store_email', 'tax_profile': 'tin', 'supplier_classification': 'supplier_type',
    'privacy_acknowledgement': 'privacy_acknowledged', 'registered_name': 'legal_business_name',
  }
  return aliases[key] ?? (key.startsWith('tax_profile.') ? key.slice(12) : key.startsWith('representative.') ? key.replace('representative.', 'representative_') : key.startsWith('address.') || key.startsWith('registered_business_address.') ? 'address_payload' : key.startsWith('classification.custom') ? 'custom_labels' : key === 'classification.niches' ? 'niches' : key.startsWith('classification.') ? 'supplier_type' : key)
}

function VerificationForm({ snapshot, onSaved, onRefresh, editing = false, registerBeforeLeave }: { registerBeforeLeave?: (save: (() => Promise<boolean>) | null) => void; editing?: boolean; snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; onRefresh: () => Promise<void> }) {
  const initialState = useRef(record(record(snapshot.verification).formState)).current
  const savedValue = (name: string, fallback = '') => Array.isArray(initialState[name]) ? String(initialState[name][0] ?? fallback) : fallback
  const org = record(snapshot.organization)
  const verification = record(snapshot.verification)
  const classification = { ...record(verification.classification), supplierType: savedValue('supplier_type', stringValue(record(verification.classification).supplierType)), ...(Array.isArray(initialState.niches) ? { niches: initialState.niches } : {}), ...(Array.isArray(initialState.custom_labels) ? { customLabels: initialState.custom_labels } : {}) }
  const address = savedValue('address_payload') ? record(JSON.parse(savedValue('address_payload'))) : record(verification.address)
  const currentAddressDraft = record(verification.formState).address_payload
  const reviewAddress = Array.isArray(currentAddressDraft) && currentAddressDraft[0] ? record(JSON.parse(String(currentAddressDraft[0]))) : address
  const tax = record(verification.taxProfile)
  const details = { ...record(tax.details), ...(savedValue('tax_relief_claimed') ? { taxReliefClaimed: savedValue('tax_relief_claimed') === 'yes' } : {}) }
  const legalIdentity = record(verification.legalIdentity)
  const [selectedBusinessType, setSelectedBusinessType] = useState(savedValue('business_type', stringValue(org.businessType)))
  const [representativeRole, setRepresentativeRole] = useState(savedValue('representative_relationship', stringValue(record(verification.representative).relationship, 'PROPRIETOR')))
  const [identityType, setIdentityType] = useState(savedValue('identity_id_type', stringValue(legalIdentity.idType)))
  const [representativeIdType, setRepresentativeIdType] = useState(savedValue('representative_id_type', stringValue(record(verification.representative).idType)))
  const [preview, setPreview] = useState<JsonRecord>({})
  const [previewError, setPreviewError] = useState('')
  const [fieldErrors, setFieldErrors] = useState<Record<string, string>>({})
  const [previewPending, setPreviewPending] = useState(false)
  const [previewRetry, setPreviewRetry] = useState(0)
  const [declarationClaim, setDeclarationClaim] = useState(booleanValue(details.taxReliefClaimed))
  useEffect(() => {
    if (!selectedBusinessType) return
    let current = true
    setPreview({}); setPreviewError(''); setPreviewPending(true)
    void previewVendorRequirements(selectedBusinessType, representativeRole, identityType, representativeIdType).then(result => { if (current) setPreview(record(result)) }).catch(() => { if (current) setPreviewError('Requirements could not be refreshed. Retry before saving.') }).finally(() => { if (current) setPreviewPending(false) })
    return () => { current = false }
  }, [selectedBusinessType, representativeRole, identityType, representativeIdType, previewRetry])
  const [step, setStep] = useState(0)
  const [privacyAcknowledged, setPrivacyAcknowledged] = useState(false)
  const [dirty, setDirty] = useState(false)
  const [editedFields, setEditedFields] = useState<string[]>([])
  const companyIdentityRequired = ['PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'].includes(selectedBusinessType)
  const individualIdentityRequired = ['SOLE_PROPRIETORSHIP', 'ONE_PERSON_CORPORATION'].includes(selectedBusinessType)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const navigate = useNavigate()
  const formRef = useRef<HTMLFormElement>(null)

  const [files, setFiles] = useState<Record<string, File>>({})
  const [removedFiles, setRemovedFiles] = useState<Set<string>>(new Set())
  const latest = useRef(snapshot)
  latest.current = snapshot
  const staged = useRef<Record<string, File>>({})
  const working = useRef(false)
  const restored = useRef(false)
  useEffect(() => {
    if (restored.current || !formRef.current) return
    restored.current = true
    for (const field of Array.from(formRef.current.elements)) {
      if (!(field instanceof HTMLInputElement || field instanceof HTMLSelectElement) || field.type === 'file') continue
      const values = initialState[field.name]
      if (!Array.isArray(values)) continue
      if (field instanceof HTMLInputElement && ['radio', 'checkbox'].includes(field.type)) field.checked = values.includes(field.value)
      else field.value = String(values[0] ?? '')
    }
  }, [initialState])
  useEffect(() => {
    if (!(verification.status === 'PENDING_VERIFICATION' || (!editing && verification.status === 'APPROVED')) || !formRef.current) return
    // Keep submitted fields read-only while allowing authorized document previews.
    for (const field of Array.from(formRef.current.elements)) {
      if (field instanceof HTMLInputElement || field instanceof HTMLSelectElement || (field instanceof HTMLButtonElement && !field.hasAttribute('data-review-action'))) field.disabled = true
    }
  }, [snapshot, verification.status, editing])
  function publish(updated: VendorOnboardingSnapshot) { latest.current = updated; onSaved(updated) }
  async function showError(cause: unknown, documentKey?: string) {
    const fields = await onboardingFieldErrors(cause)
    const mapped = Object.fromEntries(Object.entries(fields).map(([key, value]) => [documentKey ?? verificationErrorName(key.replace(/^draft\./, '')), value]))
    if (documentKey && !Object.keys(mapped).length) mapped[documentKey] = await readableOnboardingError(cause)
    setFieldErrors(mapped)
    setMessage({ tone: 'error', text: Object.keys(mapped).length ? 'Please correct the highlighted fields.' : await readableOnboardingError(cause) })
    const first = Object.keys(mapped)[0]
    if (first) {
      setStep(first === 'address_payload' ? 1 : ['supplier_type', 'niches', 'custom_labels'].includes(first) ? 2 : first === 'privacy_acknowledged' ? 3 : 0)
      requestAnimationFrame(() => requestAnimationFrame(() => {
        const field = document.getElementById(first) ?? document.querySelector<HTMLElement>(`[name="${first}"]`)
        field?.focus(); field?.scrollIntoView({ block: 'center' })
      }))
    }
  }
  async function persistFiles() {
    for (const [key, file] of Object.entries(files)) {
      if (staged.current[key] === file) continue
      try { await uploadVendorDocument(key, file); staged.current[key] = file }
      catch (cause) { await showError(cause, key); return false }
    }
    publish(await getVendorOnboarding())
    return true
  }
  async function saveProgress(): Promise<boolean> {
    if ((verification.status === 'PENDING_VERIFICATION' || (!editing && verification.status === 'APPROVED'))) return true
    if (working.current || !formRef.current) return false
    working.current = true; setBusy(true); setMessage(null)
    try {
      const data = new FormData(formRef.current)
      const state: Record<string, string[]> = {}
      for (const field of Array.from(formRef.current.elements)) {
        if ((field instanceof HTMLInputElement || field instanceof HTMLSelectElement) && field.name && field.type !== 'file') state[field.name] = data.getAll(field.name).filter((value): value is string => typeof value === 'string')
      }
      state.representative_relationship = [representativeRole]
      const current = latest.current
      publish(await saveVendorVerificationDraft({ lockVersion: numberValue(record(current.organization).lockVersion, 1), draftLockVersion: numberValue(arrayValue(current.drafts).find(item => item.workstream === 'STORE_VERIFICATION')?.lockVersion, 0), formState: JSON.stringify(state) }))
      if (!await persistFiles()) return false
      setDirty(false); setEditedFields([])
      return true
    } catch (cause) { await showError(cause); return false }
    finally { working.current = false; setBusy(false) }
  }
  const leave = useRef(saveProgress)
  leave.current = saveProgress
  useEffect(() => {
    registerBeforeLeave?.(() => leave.current())
    return () => registerBeforeLeave?.(null)
  }, [registerBeforeLeave])
  useEffect(() => {
    const click = (event: MouseEvent) => {
      const link = event.target instanceof Element ? event.target.closest('a[href]') : null
      if (!(link instanceof HTMLAnchorElement) || link.origin !== location.origin || link.pathname === location.pathname || event.ctrlKey || event.metaKey || event.shiftKey || event.button !== 0) return
      event.preventDefault(); event.stopPropagation()
      void leave.current().then(saved => { if (saved) navigate(link.pathname + link.search) })
    }
    document.addEventListener('click', click, true)
    return () => document.removeEventListener('click', click, true)
  }, [navigate])
  useEffect(() => {
    const warn = (event: BeforeUnloadEvent) => { if (dirty || Object.entries(files).some(([key, file]) => staged.current[key] !== file)) event.preventDefault() }
    window.addEventListener('beforeunload', warn)
    return () => window.removeEventListener('beforeunload', warn)
  }, [dirty, files])
  async function save() {
    if (!formRef.current || working.current) return
    if (!await saveProgress()) return
    if (previewPending || previewError) { setMessage({ tone: 'error', text: 'Wait for the applicable requirements to refresh, or retry.' }); return }
    working.current = true; setBusy(true); setMessage(null); setFieldErrors({})
    const data = new FormData(formRef.current)
    const draft: import('@materyalph/api-client-ts').VendorVerificationDraft = { lockVersion: numberValue(record(latest.current.organization).lockVersion, 1), draftLockVersion: numberValue(arrayValue(latest.current.drafts).find(item => item.workstream === 'STORE_VERIFICATION')?.lockVersion, 0) }
    const businessType = stringValue(data.get('business_type'))
    const registeredName = stringValue(data.get('legal_business_name')).trim()
    const storeName = stringValue(data.get('store_name')).trim()
    const established = stringValue(data.get('date_established'))
    const storePhone = stringValue(data.get('store_phone')).trim()
    const candidateEmail = stringValue(data.get('store_email')).trim().toLowerCase()
    const companyIdentityRequired = ['PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'].includes(businessType)
    const individualIdentityRequired = ['SOLE_PROPRIETORSHIP', 'ONE_PERSON_CORPORATION'].includes(businessType)
    if (businessType) draft.businessType = businessType as NonNullable<import('@materyalph/api-client-ts').VendorVerificationDraft['businessType']>
    if (companyIdentityRequired && registeredName) draft.legalBusinessName = registeredName
    if (storeName) draft.storeName = storeName
    if (established) draft.dateEstablished = new Date(`${established}T00:00:00Z`)
    if (candidateEmail) draft.storeEmail = candidateEmail
    if (storePhone) draft.storePhone = storePhone
    if (companyIdentityRequired || individualIdentityRequired) draft.legalIdentity = { sameAsOwner: data.get('same_as_owner') === 'on', surname: stringValue(data.get('individual_surname')).trim() || null, firstName: stringValue(data.get('individual_first_name')).trim() || null, middleName: stringValue(data.get('individual_middle_name')).trim() || null, suffix: stringValue(data.get('individual_suffix')).trim() || null, companyRegisteredName: stringValue(data.get('company_registered_name')).trim() || null, idType: stringValue(data.get('identity_id_type')).trim() || null, ...(stringValue(data.get('identity_id_number')).trim() ? { idNumber: stringValue(data.get('identity_id_number')).trim() } : {}) }
    const representativeName = stringValue(data.get('representative_name')).trim()
    if ((companyIdentityRequired || representativeRole !== 'PROPRIETOR') && representativeName) draft.representative = { fullName: representativeName, sameAsOwner: data.get('representative_same_as_owner') === 'on', position: stringValue(data.get('representative_position')).trim() || null, email: stringValue(data.get('representative_email')).trim() || null, phone: stringValue(data.get('representative_phone')).trim() || null, relationship: stringValue(data.get('representative_relationship')).trim() || null,
      relationshipOther: stringValue(data.get('representative_relationship_other')) || null,
      authorityEvidenceSource: stringValue(data.get('authority_evidence_source'), 'SEPARATE_AUTHORITY_DOCUMENT') as NonNullable<import('@materyalph/api-client-ts').VendorVerificationDraftRepresentative['authorityEvidenceSource']>,
      authorityEvidenceVersionId: stringValue(data.get('authority_evidence_version_id')) || null,
      authorityDocumentType: (stringValue(data.get('authority_document_type')) || null) as Exclude<import('@materyalph/api-client-ts').VendorVerificationDraftRepresentative['authorityDocumentType'], undefined>,
      authorityDocumentDate: data.get('authority_document_date') ? new Date(`${data.get('authority_document_date')}T00:00:00Z`) : null,
      authorityScopes: new Set(data.getAll('authority_scopes').map(String) as import('@materyalph/api-client-ts').VendorVerificationDraftRepresentativeAuthorityScopesEnum[]), idType: stringValue(data.get('representative_id_type')) as NonNullable<import('@materyalph/api-client-ts').VendorVerificationDraftRepresentative['idType']>, ...(data.get('representative_id_number') ? { idNumber: stringValue(data.get('representative_id_number')) } : {}) }
    if (businessType === 'SOLE_PROPRIETORSHIP' && representativeRole === 'PROPRIETOR' && record(verification.representative).id) draft.representative = { fullName: stringValue(record(verification.owner).fullName, stringValue(record(verification.representative).fullName)), sameAsOwner: true, relationship: 'PROPRIETOR' }
    const supplierType = stringValue(data.get('supplier_type'))
    if (supplierType) draft.classification = { supplierType: supplierType, niches: data.getAll('niches').map(String), customLabels: new Set(data.getAll('custom_labels').map(String)) }
    const addressPayload = stringValue(data.get('address_payload'))
    if (addressPayload) {
      const selected = JSON.parse(addressPayload) as Record<string, string>
      if (!selected.province_code || !selected.city_code || !selected.psgc_code || !selected.street?.trim() || !selected.postal_code?.trim() || (selected.source !== 'MANUAL' && !selected.resolution_token)) {
        setFieldErrors({ address_payload: 'Complete the structured address. For map selection, wait for resolution or choose Manual Address Entry.' }); setStep(1); setBusy(false); working.current = false; return
      }
      draft.address = selected
    }
    const taxpayerKey = stringValue(data.get('taxpayer_key')).trim()
    const tin = stringValue(data.get('tin')).trim()
    const declarationChoice = stringValue(data.get('tax_relief_claimed'))
    const taxReliefClaimed = declarationChoice === 'yes'
    const ownerAttested = data.get('owner_attested') === 'on'
    const taxFieldsPresent = taxpayerKey || tin || stringValue(data.get('vat_category')) || declarationChoice || stringValue(data.get('bir_cor_reference')).trim() || stringValue(data.get('declaration_type')).trim() || stringValue(data.get('threshold_position')).trim() || stringValue(data.get('submission_date')) || stringValue(data.get('outside_platform_as_of')) || taxReliefClaimed || ownerAttested || numberValue(tax.version, 0) > 0
    if (taxFieldsPresent) {
      const birCorReference = stringValue(data.get('bir_cor_reference')).trim()
      const entityClass = businessType === 'SOLE_PROPRIETORSHIP' ? 'INDIVIDUAL' : businessType === 'ONE_PERSON_CORPORATION' ? 'CORPORATION' : businessType
      const registrationCategory = stringValue(data.get('registration_category')).trim()
      const vatCategory = stringValue(data.get('vat_category'))
      const fiscalYearStartMonth = Number(data.get('fiscal_year_start_month'))
      const declarationType = stringValue(data.get('declaration_type')).trim()
      const thresholdPosition = stringValue(data.get('threshold_position')).trim()
      const submissionDate = stringValue(data.get('submission_date'))
      const outsidePlatformAsOf = stringValue(data.get('outside_platform_as_of'))
      const withholdingScenario = stringValue(data.get('withholding_scenario'))
      draft.taxProfile = {
        ...(taxpayerKey ? { taxpayerKey } : {}),
        ...(tin ? { tin } : {}),
        ...(birCorReference ? { birCorReference } : {}),
        ...(entityClass ? { entityClass: entityClass as NonNullable<import('@materyalph/api-client-ts').VendorVerificationDraftTaxProfile['entityClass']> } : {}),
        ...(registrationCategory ? { registrationCategory } : {}),
        ...(vatCategory ? { vatCategory: vatCategory as NonNullable<import('@materyalph/api-client-ts').VendorVerificationDraftTaxProfile['vatCategory']> } : {}),
        ...(Number.isFinite(fiscalYearStartMonth) ? { fiscalYearStartMonth } : {}),
        declarationType: declarationType || null,
        thresholdPosition: thresholdPosition || null,
        submissionDate: submissionDate ? new Date(`${submissionDate}T00:00:00Z`) : null,
        outsidePlatformAsOf: outsidePlatformAsOf ? new Date(`${outsidePlatformAsOf}T00:00:00Z`) : null,
        ...(withholdingScenario ? { withholdingScenario: withholdingScenario as NonNullable<import('@materyalph/api-client-ts').VendorVerificationDraftTaxProfile['withholdingScenario']> } : {}),
        ...(declarationChoice ? { taxReliefClaimed } : {}),
        declarationYear: data.get('declaration_year') ? Number(data.get('declaration_year')) : null,
        ownerAttested,
      }
    }
    const invalidFields: Record<string, string> = {}
    for (const field of Array.from(formRef.current.elements)) {
      if (!(field instanceof HTMLInputElement || field instanceof HTMLSelectElement) || !field.name || field.type === 'file' || field.disabled || field.checkValidity()) continue
      invalidFields[field.name] = field.name === 'tin' ? 'Enter your 9-digit TIN followed by a 3- to 5-digit branch code (for example, 123-456-789-000).' : field.validity.valueMissing ? 'Please complete this field.' : 'Check this value.'
    }
    if (!privacyAcknowledged) invalidFields.privacy_acknowledged = 'Acknowledge the Privacy Notice.'
    if (Object.keys(invalidFields).length || !privacyAcknowledged) {
      setFieldErrors(invalidFields); setMessage({ tone: 'error', text: 'Please correct the highlighted fields.' }); setBusy(false); working.current = false
      const name = Object.keys(invalidFields)[0]!
      setStep(name === 'privacy_acknowledged' ? 3 : ['street', 'postal_code'].includes(name) ? 1 : ['supplier_type', 'niches', 'custom_labels'].includes(name) ? 2 : 0)
      requestAnimationFrame(() => { const field = document.getElementById(name); field?.focus(); field?.scrollIntoView({ block: 'center' }) })
      return
    }
    try {
      publish(await submitVendorVerification({ lockVersion: numberValue(record(latest.current.organization).lockVersion, 1), privacyAcknowledged, draft }))
      setDirty(false)
    } catch (cause) { await showError(cause) } finally { setBusy(false); working.current = false }

  }

  return <FormErrors.Provider value={fieldErrors}><PendingDocuments.Provider value={{ files, pending: arrayValue(record(snapshot.verification).pendingDocuments).filter(doc => !removedFiles.has(stringValue(doc.requirementKey))), errors: fieldErrors, busy, editing, select: (key, file) => {
    setFieldErrors(current => { const next = { ...current }; delete next[key]; return next })
    setFiles(current => { const next = { ...current }; if (file) next[key] = file; else delete next[key]; return next }); setDirty(true)
    if (file) setRemovedFiles(current => { const next = new Set(current); next.delete(key); return next })
    else {
      const saved = Boolean(staged.current[key]) || arrayValue(record(latest.current.verification).pendingDocuments).some(doc => doc.requirementKey === key)
      delete staged.current[key]
      setRemovedFiles(current => new Set(current).add(key))
      if (!saved) return
      working.current = true; setBusy(true)
      void removePendingVendorDocument(key).then(publish).catch(cause => {
        setRemovedFiles(current => { const next = new Set(current); next.delete(key); return next })
        return showError(cause, key)
      }).finally(() => { working.current = false; setBusy(false) })
    }
  } }}><OnboardingFlow autosave steps={verificationSteps} current={step} onStep={next => { void saveProgress().then(saved => { if (saved) setStep(next) }) }} section={sectionFor(snapshot, 'STORE_VERIFICATION')} busy={busy} actions={<>
      <Button type="button" variant="secondary" disabled={busy} onClick={() => { void saveProgress().then(saved => { if (saved) navigate('/dashboard') }) }}>Finish Later</Button>
      {step === 3 && <Button type="button" disabled={busy || (verification.status === 'PENDING_VERIFICATION' || (!editing && verification.status === 'APPROVED'))} onClick={() => void save()}>{busy ? 'Submitting…' : 'Submit for Admin Review'}</Button>}</>}>
    {message && <p role={message.tone === 'error' ? 'alert' : 'status'} className={`mb-4 text-sm ${message.tone === 'error' ? 'text-status-error' : 'text-text-secondary'}`}>{message.text}{message.text.startsWith('This draft changed') && <Button type="button" variant="quiet" onClick={() => { void getVendorOnboarding().then(publish).catch(showError) }}>Reload latest version</Button>}</p>}
    <form id="verification-draft" noValidate ref={formRef} onChange={(event) => { if (event.target instanceof HTMLInputElement && event.target.type === 'file') return; setDirty(true); if (event.target instanceof HTMLSelectElement || event.target instanceof HTMLInputElement) {
      const title = event.target.labels?.[0]?.textContent?.trim() || statusLabel(event.target.name)
      if (title) setEditedFields(fields => [...new Set([...fields, title])])
      if (event.target.name === 'business_type') setSelectedBusinessType(event.target.value)
      if (event.target.name === 'tax_relief_claimed') setDeclarationClaim(event.target.value === 'yes')
      if (event.target.name === 'representative_relationship') setRepresentativeRole(event.target.value)
      if (event.target.name === 'identity_id_type') setIdentityType(event.target.value)
      if (event.target.name === 'representative_id_type') setRepresentativeIdType(event.target.value)
    } }} onSubmit={event => { event.preventDefault(); void save() }}><fieldset className="min-w-0">
      <OnboardingStepContent active={step === 0}><div className="grid min-w-0 gap-6">
        <FormSection panel title="Business Type" description="Choose the legal structure shown on your registration evidence."><div className="grid gap-2 sm:grid-cols-2">{['SOLE_PROPRIETORSHIP', 'PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'].map(type => <label key={type} className="flex min-h-11 items-center gap-3 text-sm"><input type="radio" name="business_type" value={type} checked={selectedBusinessType === type} onChange={() => setSelectedBusinessType(type)} aria-invalid={Boolean(fieldErrors.business_type)} className="h-5 w-5 accent-action-primary" />{type === 'ONE_PERSON_CORPORATION' ? 'One Person Corporation (OPC)' : statusLabel(type)}</label>)}</div><InlineError name="business_type" /></FormSection>
        {previewPending && <p role="status">Updating applicable requirements…</p>}{previewError && <StatusMessage tone="error">{previewError} <Button type="button" variant="secondary" onClick={() => setPreviewRetry(value => value + 1)}>Retry requirements</Button></StatusMessage>}
        {(individualIdentityRequired || companyIdentityRequired) && <FormSection panel title="Registered Legal Identity" description="Review these names against the applicable government identification and registration records. Prefill does not verify your identity.">
          {individualIdentityRequired && <><label className="flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" name="same_as_owner" defaultChecked={booleanValue(legalIdentity.sameAsOwner)} onChange={event => { if (event.target.checked) { const owner = stringValue(record(verification.owner).fullName).trim().split(/\s+/); const surname = owner.pop() ?? ''; for (const [name, value] of [['individual_surname', surname], ['individual_first_name', owner.join(' ')]] as const) { const field = event.target.form?.elements.namedItem(name); if (field instanceof HTMLInputElement) field.value = value } } }} />Same as Vendor Owner’s full legal name</label><FieldRow><Field label="Surname" name="individual_surname" required maxLength={100} defaultValue={stringValue(legalIdentity.surname)} /><Field label="First name" name="individual_first_name" required maxLength={100} defaultValue={stringValue(legalIdentity.firstName)} /></FieldRow><FieldRow><Field label="Middle name" name="individual_middle_name" maxLength={100} defaultValue={stringValue(legalIdentity.middleName)} /><Field label="Suffix" name="individual_suffix" maxLength={10} defaultValue={stringValue(legalIdentity.suffix)} /></FieldRow></>}
          {companyIdentityRequired && <Field label="Company registered name" name="company_registered_name" required maxLength={200} defaultValue={stringValue(legalIdentity.companyRegisteredName)} hint="The official legal name recorded by the government registration authority." />}
          {individualIdentityRequired && <FormSection title="Government-Issued Identification" description="Private identification must correspond to the legally relevant person named in this application.">
          {individualIdentityRequired && <><FieldRow><SelectField label="Government ID type" name="identity_id_type" defaultValue={identityType} options={['NATIONAL_ID', 'DRIVERS_LICENSE', 'PASSPORT', 'UMID', 'OTHER']} />{identityType && <Field placeholder={`Enter your ${statusLabel(identityType).toLowerCase()} number`} label="Government ID number" name="identity_id_number" type="password" autoComplete="off" hint={stringValue(legalIdentity.idNumberLast4) ? `Current ID ends in ${legalIdentity.idNumberLast4}. Leave blank to retain it.` : 'Stored encrypted and masked on read.'} />}</FieldRow>{!identityType && <p className="text-sm text-text-secondary">Select your Government ID type to enter its number and upload the required sides.</p>}{identityType && <DocumentChecklist key={identityType} identityLayout embedded keys={['identity_evidence', ...(identityType !== 'PASSPORT' ? ['identity_back_evidence'] : [])]} snapshot={snapshot} onRefresh={onRefresh} preview={preview} pendingChanges={selectedBusinessType !== stringValue(org.businessType)} />}</>}
          </FormSection>}
        </FormSection>}
        {selectedBusinessType === 'SOLE_PROPRIETORSHIP' && <FormSection panel title="Authorized Representative and Authority to Act" description="A proprietor representing their own business does not need separate Authority Evidence."><label className="flex min-h-11 items-center gap-3"><input type="checkbox" checked={representativeRole !== 'PROPRIETOR'} onChange={event => setRepresentativeRole(event.target.checked ? 'AUTHORIZED_REPRESENTATIVE' : 'PROPRIETOR')} />Someone other than the proprietor represents the business</label>{representativeRole === 'PROPRIETOR' && <p>Not applicable — the sole proprietor is the representative.</p>}{representativeRole !== 'PROPRIETOR' && <RepresentativeInformation embedded representative={{ ...record(verification.representative), ...(savedValue('authority_document_type') ? { authorityDocumentType: savedValue('authority_document_type') } : {}) }} owner={record(verification.owner)} documents={arrayValue(verification.documents)} review={record(verification.authorityReview)} role={representativeRole} idType={representativeIdType} authorityEvidence={<DocumentChecklist embedded reviewUploads keys={['authority_to_act']} snapshot={snapshot} onRefresh={onRefresh} preview={preview} pendingChanges={selectedBusinessType !== stringValue(org.businessType)} />} identityEvidence={representativeIdType ? <DocumentChecklist key={representativeIdType} identityLayout embedded keys={['representative_identity', ...(representativeIdType !== 'PASSPORT' ? ['representative_identity_back'] : [])]} snapshot={snapshot} onRefresh={onRefresh} preview={preview} pendingChanges={dirty || busy || selectedBusinessType !== stringValue(org.businessType)} /> : null} />}</FormSection>}
        {companyIdentityRequired && <RepresentativeInformation representative={{ ...record(verification.representative), ...(savedValue('authority_document_type') ? { authorityDocumentType: savedValue('authority_document_type') } : {}) }} owner={record(verification.owner)} documents={arrayValue(verification.documents)} review={record(verification.authorityReview)} role={representativeRole} idType={representativeIdType} authorityEvidence={<DocumentChecklist embedded reviewUploads keys={['authority_to_act']} snapshot={snapshot} onRefresh={onRefresh} preview={preview} pendingChanges={selectedBusinessType !== stringValue(org.businessType)} />} identityEvidence={representativeIdType ? <DocumentChecklist key={representativeIdType} identityLayout embedded keys={['representative_identity', ...(representativeIdType !== 'PASSPORT' ? ['representative_identity_back'] : [])]} snapshot={snapshot} onRefresh={onRefresh} preview={preview} pendingChanges={dirty || busy || selectedBusinessType !== stringValue(org.businessType)} /> : null} />}
        <FormSection panel title="Business identity" description="The registered business name and public Store name are separate values."><FieldRow>{companyIdentityRequired && <Field label="Registered Business Name" name="legal_business_name" required maxLength={200} defaultValue={stringValue(org.legalBusinessName, stringValue(org.registeredName))} />}<Field label="Date established" name="date_established" required type="date" max={new Intl.DateTimeFormat('en-CA', { year: 'numeric', month: '2-digit', day: '2-digit', timeZone: 'Asia/Manila' }).format(new Date())} defaultValue={dateInput(org.dateEstablished)} /></FieldRow><Field label="Public Store Name" name="store_name" required maxLength={100} defaultValue={stringValue(org.storeName)} /></FormSection>
        <StoreContactInformation snapshot={snapshot} onSaved={onSaved} initialEmail={savedValue('store_email', stringValue(org.storeEmail))} />
        <BusinessTaxInformation tax={tax} details={details} businessType={selectedBusinessType} canAttest={(selectedBusinessType === 'SOLE_PROPRIETORSHIP' && representativeRole === 'PROPRIETOR') || (record(verification.authorityReview).decision === 'APPROVED' && stringValue(record(verification.authorityReview).scope).split(',').includes('TAX_DECLARATIONS'))} errors={fieldErrors} evidence={<DocumentChecklist embedded reviewUploads keys={['bir_cor']} declarationClaim={declarationClaim} snapshot={snapshot} onRefresh={onRefresh} preview={preview} pendingChanges={selectedBusinessType !== stringValue(org.businessType)} />} declarationEvidence={<DocumentChecklist embedded reviewUploads keys={['tax_relief_evidence']} declarationClaim={declarationClaim} snapshot={snapshot} onRefresh={onRefresh} preview={preview} pendingChanges={selectedBusinessType !== stringValue(org.businessType)} />} />
        <FormSection panel title="Business and Compliance Evidence" description="Select the required documents. They stay pending until you submit for Admin Review."><DocumentChecklist embedded reviewUploads keys={['business_registration', 'lgu_permit']} snapshot={snapshot} onRefresh={onRefresh} preview={preview} pendingChanges={selectedBusinessType !== stringValue(org.businessType)} /></FormSection>
      </div></OnboardingStepContent>
      <OnboardingStepContent active={step === 1}><div className="grid gap-5"><p className="text-sm text-text-secondary">Select your official Philippine address, then add the street and building details. Use Manual Address Entry or review a resolved map location before submitting.</p><InlineError name="address_payload" /><VendorBusinessAddress initial={address} restoreDraft={Boolean(savedValue('address_payload'))} active={step === 1} onDirty={() => setDirty(true)} /></div></OnboardingStepContent>
      <OnboardingStepContent active={step === 2}><SupplierClassification classification={classification} onDirty={() => setDirty(true)} /></OnboardingStepContent>

    </fieldset></form>

    <OnboardingStepContent active={step === 3}><p className="mb-5 mt-6 text-sm leading-6 text-text-secondary">Review your information and selected documents before submitting. Submission sends the current evidence for manual Admin review and does not activate your store.</p><ReviewDetails items={[["Public Store Name", stringValue((record(verification.formState).store_name as string[] | undefined)?.[0], stringValue(org.storeName))], ["Business type", statusLabel(selectedBusinessType)], ["Registered location", [reviewAddress.street, reviewAddress.cityMunicipality ?? reviewAddress.city_municipality, reviewAddress.province].filter(Boolean).join(', ')], ["Privacy acknowledgement", privacyAcknowledged ? 'Acknowledged for this submission' : 'Not acknowledged']]} /><OnboardingReview groups={verificationSteps.map((group, index) => ({ label: group.label, items: sectionFor(snapshot, 'STORE_VERIFICATION').steps.filter(item => group.requirements.includes(item.key) || (index === 0 && !verificationSteps.some(step => step.requirements.includes(item.key)))).map(item => { const requirement = arrayValue(snapshot.requirements).find(value => value.key === item.key); return { ...item, reason: stringValue(requirement?.correctionReason) || stringValue(requirement?.applicabilityReason) || stringValue(requirement?.blockingReason) || item.reason || null } }) }))} busy={busy} onJump={next => { void saveProgress().then(saved => { if (saved) setStep(next) }) }} unsaved={dirty ? (editedFields.length ? editedFields : ['Current form or document selections']) : []} pending={[...(Object.keys(record(verification.formState)).length ? ['Verification form details'] : []), ...arrayValue(verification.pendingDocuments).map(doc => statusLabel(stringValue(doc.requirementKey)))]} /></OnboardingStepContent>
    <OnboardingStepContent active={step === 3}>
      <div className="mt-8 grid gap-6">
        <CommissionTerms snapshot={snapshot} onSaved={publish} disabled={busy || dirty} />
        <PrivacyNotice notice={record(verification.privacyNotice)}>
          <div className="grid gap-5 border-t border-border-default pt-5">
            <p className="max-w-2xl text-sm leading-6 text-text-secondary">Your business details and evidence remain private during review. This acknowledgement is recorded when you submit Store Verification.</p>
            <label className="flex min-h-11 max-w-2xl items-start gap-3 text-sm leading-6"><input id="privacy_acknowledged" className="mt-1 h-5 w-5 shrink-0 accent-action-primary" type="checkbox" disabled={!stringValue(record(verification.privacyNotice).content)} checked={privacyAcknowledged} onChange={event => { setPrivacyAcknowledged(event.target.checked); setFieldErrors(current => { const next = { ...current }; delete next.privacy_acknowledged; return next }); if (Object.keys(fieldErrors).every(key => key === 'privacy_acknowledged')) setMessage(null) }} /><span>I acknowledge the current Privacy Notice and authorize MateryalPH to review these Vendor business details and private evidence.</span></label><InlineError name="privacy_acknowledged" />
          </div>
        </PrivacyNotice>
      </div>
    </OnboardingStepContent>
  </OnboardingFlow></PendingDocuments.Provider></FormErrors.Provider>
}

function CommissionTerms({ snapshot, onSaved, disabled }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; disabled: boolean }) {
  const terms = record(record(snapshot.verification).commissionTerms)
  const agreement = record(terms.agreement)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  async function accept() {
    setBusy(true); setError('')
    try { onSaved(await acceptVendorCommission({ organizationLockVersion: numberValue(record(snapshot.organization).lockVersion, 1), agreementVersionId: stringValue(agreement.id), accepted: true })) }
    catch (cause) { setError(await readableOnboardingError(cause)) }
    finally { setBusy(false) }
  }
  return <VersionedAgreementPanel key={stringValue(agreement.id)} title="2% Commission Terms" version={numberValue(agreement.version)} content={stringValue(agreement.content)} accepted={terms.accepted === true} eligible={terms.canAccept === true} busy={busy || disabled} error={error} onAccept={() => void accept()}>
    <p className="max-w-3xl text-sm leading-6 text-text-secondary">A versioned agreement for the Vendor-paid commission on completed materials. Review the full terms before accepting for your organization.</p>
    <dl className="grid gap-4 sm:grid-cols-2">
      {[["Commission base", "2% of completed materials after Vendor discounts, excluding included materials VAT."], ["Monthly collection", "Collected monthly, with VAT-inclusive commission fee treatment where applicable."], ["Credits and disputes", "Cancellation and partial-refund credits, statement due dates, and the dispute process follow the versioned terms."], ["Authorized acceptance", "The Vendor Owner or an Admin-approved Owner-linked representative with the COMMISSION_AGREEMENT scope."]].map(([label, detail]) => <div key={label} className="rounded-control border border-border-default p-4"><dt className="text-sm font-semibold">{label}</dt><dd className="mt-2 text-sm leading-6 text-text-secondary">{detail}</dd></div>)}
    </dl>
    <p className="rounded-control bg-surface-canvas p-4 text-sm leading-6">Changing settings never adds a fee to an already accepted order.</p>
  </VersionedAgreementPanel>
}

function PrivacyNotice({ notice, children }: { notice: JsonRecord; children?: ReactNode }) {
  return <FormSection panel region title="Privacy Notice" description={notice.version ? `Version ${numberValue(notice.version)}` : ''}>
    {stringValue(notice.content) ? <div className="max-h-96 overflow-y-auto whitespace-pre-wrap break-words text-sm leading-6" tabIndex={0}>{stringValue(notice.content)}</div> : <p className="text-sm text-text-secondary">The current Privacy Notice could not be loaded. Refresh this page before acknowledging and submitting.</p>}
    {children}
  </FormSection>
}

const supplierNiches = ['Construction Materials', 'Electrical Supplies', 'Plumbing and Sanitary', 'Tools and Equipment', 'Finishing Materials', 'Fasteners and Hardware', 'Cement and Concrete', 'Roofing Materials', 'Formworks and Scaffolding', 'Wood and Lumber', 'Landscaping and Exterior', 'Steel and Reinforcement', 'Tools and Accessories', 'Masonry', 'Insulation and Waterproofing', 'Aggregates', 'Drainage and Septic Materials', 'Construction Chemicals', 'Flooring Materials', 'Wall and Ceiling Materials', 'HVAC Materials', 'Sanitary Fixtures', 'Fire Protection Materials', 'Paints and Finishes', 'Adhesives and Sealants', 'Doors, Windows, and Glass', 'Other Category']

const supplierNicheDescriptions = ["General building and construction supplies.", "Wiring, switches, outlets and electrical components.", "Pipes, fittings and water-system supplies.", "Tools and equipment sold as products; rental services are excluded.", "Materials for finished interior and exterior surfaces.", "Screws, bolts, hinges and general hardware.", "Cement, concrete mixes and related products.", "Roof sheets, tiles, flashing and accessories.", "Formwork and scaffolding products.", "Timber, lumber and wood-based products.", "Outdoor, garden and landscape materials.", "Rebar, steel sections and reinforcement products.", "Tool attachments, consumables and accessories.", "Blocks, bricks and masonry supplies.", "Thermal insulation and moisture protection.", "Sand, gravel and crushed stone.", "Drainage pipes, channels and septic materials.", "Admixtures, treatments and construction chemicals.", "Tiles, boards and other floor finishes.", "Wall panels, ceiling boards and framing.", "Heating, ventilation and air-conditioning materials.", "Toilets, basins, faucets and fixtures.", "Fire-protection system materials and components.", "Paints, coatings and surface finishes.", "Bonding, joint-filling and sealing products.", "Doors, windows, glazing and related fittings.", "Describe another supported construction-material niche."]

function SupplierClassification({ classification, onDirty }: { classification: JsonRecord; onDirty: () => void }) {
  const [selected, setSelected] = useState<string[]>(Array.isArray(classification.niches) ? classification.niches.filter((item): item is string => typeof item === 'string') : [])
  const [customLabels, setCustomLabels] = useState<string[]>(() => Array.isArray(classification.customLabels) ? classification.customLabels.filter((item): item is string => typeof item === 'string') : stringValue(classification.customLabel) ? [stringValue(classification.customLabel)] : [])
  return <div className="grid min-w-0 gap-6">
    <p className="max-w-3xl text-sm leading-6 text-text-secondary">Select your supplier type and one or more construction-material niches. Vehicle and equipment rental services are not supported.</p>
    <fieldset className="min-w-0" aria-describedby="supplier_type-error"><legend className="mb-2 font-semibold">Supplier type</legend><div className="grid gap-3 sm:grid-cols-3">{[['WHOLESALER_DISTRIBUTOR', 'Wholesaler or Distributor'], ['RETAIL_HARDWARE_STORE', 'Retail Hardware Store'], ['SPECIALIZED_SUPPLIER', 'Specialized Supplier']].map(([value, label]) => <label key={value} className="flex min-h-11 items-center gap-3 rounded-control border border-border-default p-3 text-sm"><input type="radio" name="supplier_type" value={value} defaultChecked={classification.supplierType === value} required />{label}</label>)}</div><InlineError name="supplier_type" /></fieldset>
    <fieldset className="min-w-0"><legend className="mb-3 font-semibold">Supplier Niches</legend><div className="grid gap-2 sm:grid-cols-2">{supplierNiches.map(niche => <label key={niche} className={`flex min-h-11 cursor-pointer items-center gap-3 rounded-control border px-3 py-2 text-sm ${selected.includes(niche) ? 'border-action-primary bg-brand-orange-50' : 'border-border-default hover:bg-surface-canvas'}`}><input type="checkbox" className="h-5 w-5 shrink-0 accent-action-primary" name="niches" value={niche} checked={selected.includes(niche)} onChange={event => { setSelected(event.target.checked ? [...selected, niche] : selected.filter(item => item !== niche)); onDirty() }} /><span><span className="block font-medium">{niche}</span><span className="mt-1 block text-xs text-text-secondary">{supplierNicheDescriptions[supplierNiches.indexOf(niche)]}</span></span></label>)}</div><InlineError name="niches" /></fieldset>
    {selected.includes('Other Category') && <div><CustomLabelInput values={customLabels} onChange={labels => { setCustomLabels(labels); onDirty() }} /><InlineError name="custom_labels" /></div>}
  </div>
}

function RepresentativeInformation({ representative, owner, documents, role, review, idType, identityEvidence, authorityEvidence, embedded = false }: { representative: JsonRecord; owner: JsonRecord; documents: JsonRecord[]; role: string; review: JsonRecord; idType: string; identityEvidence: ReactNode; authorityEvidence: ReactNode; embedded?: boolean }) {
  const [documentType, setDocumentType] = useState(stringValue(representative.authorityDocumentType))
  const [source, setSource] = useState(stringValue(representative.authorityEvidenceSource, 'SEPARATE_AUTHORITY_DOCUMENT'))
  const accepted = documents.filter(doc => doc.requirementKey === 'business_registration' && !doc.supersededAt && doc.status === 'APPROVED')
  const existingAllowed = role === 'OFFICER' && accepted.length > 0
  function fillOwner(event: React.ChangeEvent<HTMLInputElement>) {
    if (!event.target.checked) return
    for (const [name, value] of [['representative_name', owner.fullName], ['representative_email', owner.email], ['representative_phone', owner.phone]]) { const field = event.target.form?.elements.namedItem(String(name)); if (field instanceof HTMLInputElement) field.value = stringValue(value) }
  }
  return <FormSection panel={!embedded} title="Authorized Representative / Authorized Signatory" description="The Vendor Owner account and legal authority are separate. Changes create a new version and reopen Admin review.">
    <label className="flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" name="representative_same_as_owner" defaultChecked={booleanValue(representative.sameAsOwner)} onChange={fillOwner} />This representative is the Vendor Owner account holder</label>
    <FieldRow><Field label="Representative full legal name" name="representative_name" required defaultValue={stringValue(representative.fullName)} maxLength={150} /><Field label="Position / Title" name="representative_position" required defaultValue={stringValue(representative.position)} maxLength={100} /></FieldRow>
    <FieldRow><Field label="Representative email" name="representative_email" required type="email" defaultValue={stringValue(representative.email)} /><Field label="Representative phone" name="representative_phone" required inputMode="tel" defaultValue={stringValue(representative.phone)} /></FieldRow>
    <SelectField label="Relationship to the business" name="representative_relationship" defaultValue={role === 'PROPRIETOR' ? '' : role} options={['OFFICER', 'EMPLOYEE', 'ACCOUNTANT', 'AUTHORIZED_REPRESENTATIVE', 'CORPORATE_REPRESENTATIVE', 'COOPERATIVE_REPRESENTATIVE', 'OTHER']} />
    {role === 'OTHER' && <Field label="Other relationship" name="representative_relationship_other" defaultValue={stringValue(representative.relationshipOther)} />}
    <FieldRow><SelectField label="Representative government ID type" name="representative_id_type" defaultValue={idType} options={['NATIONAL_ID', 'DRIVERS_LICENSE', 'PASSPORT', 'UMID', 'OTHER']} />{idType && <Field placeholder={`Enter your ${statusLabel(idType).toLowerCase()} number`} label="Representative government ID number" name="representative_id_number" type="password" autoComplete="off" hint={representative.idNumberLast4 ? `Current ID ends in ${representative.idNumberLast4}. Leave blank to retain it.` : 'Private verification information.'} />}</FieldRow>
    {!idType && <p className="text-sm text-text-secondary">Select the representative’s Government ID type to enter its number and upload the required sides.</p>}
    {identityEvidence}
    <fieldset className="grid gap-5 border-t border-border-default pt-5" onChange={event => { const target = event.target; if (target instanceof HTMLSelectElement && target.name === 'authority_document_type') setDocumentType(target.value) }}><legend className="font-semibold">Authority to Act for the Organization</legend>
      {existingAllowed && <label className="flex min-h-11 items-center gap-3"><input type="checkbox" checked={source === 'EXISTING_REGISTRATION_EVIDENCE'} onChange={event => setSource(event.target.checked ? 'EXISTING_REGISTRATION_EVIDENCE' : 'SEPARATE_AUTHORITY_DOCUMENT')} />Use accepted registration evidence for this officer</label>}
      <input type="hidden" name="authority_evidence_source" value={existingAllowed ? source : 'SEPARATE_AUTHORITY_DOCUMENT'} />
      {existingAllowed && source === 'EXISTING_REGISTRATION_EVIDENCE' ? <label className="grid gap-2">Accepted registration evidence<select name="authority_evidence_version_id" defaultValue={stringValue(representative.authorityEvidenceVersionId)} className="min-h-12 border border-border-default rounded-control px-3"><option value="">Select evidence</option>{accepted.map(doc => <option key={stringValue(doc.id)} value={stringValue(doc.id)}>{stringValue(doc.originalName)} · Version {numberValue(doc.version)}</option>)}</select><span className="text-sm">The Admin must confirm these records establish this officer’s authority.</span></label> : <><p className="text-sm">Required — upload separate Authority Evidence for an employee, accountant or representative whose authority is not established.</p><FieldRow><SelectField label="Authority document type" name="authority_document_type" defaultValue={documentType} options={['SECRETARYS_CERTIFICATE', 'BOARD_RESOLUTION', 'SPECIAL_POWER_OF_ATTORNEY', 'PARTNERSHIP_AUTHORIZATION', 'COOPERATIVE_BOARD_RESOLUTION', 'OTHER_APPROVED']} />{documentType && <Field label="Authority document date" name="authority_document_date" type="date" max={new Intl.DateTimeFormat('en-CA', { year: 'numeric', month: '2-digit', day: '2-digit', timeZone: 'Asia/Manila' }).format(new Date())} defaultValue={dateInput(representative.authorityDocumentDate)} />}</FieldRow>{!documentType && <p className="text-sm text-text-secondary">Select an Authority document type to add its date, request authority scopes and upload evidence for review.</p>}</>}
      {((existingAllowed && source === 'EXISTING_REGISTRATION_EVIDENCE') || documentType) && <AuthorityScopePanel selected={Array.isArray(representative.authorityScopes) ? representative.authorityScopes.map(String) : []} />}
      {!(existingAllowed && source === 'EXISTING_REGISTRATION_EVIDENCE') && documentType && <div key={documentType}>{authorityEvidence}</div>}
    </fieldset>
    <p role="status" className="text-sm">Admin authority decision: {statusLabel(stringValue(review.decision, 'PENDING_VERIFICATION'))}{review.scope ? ` · ${String(review.scope).replaceAll('_', ' ')}` : ''}</p>{review.reason && <p className="text-sm text-status-error">{String(review.reason)}</p>}
    <p className="text-sm">Final attestation requires the current Owner-linked representative and explicit Admin approval for the applicable scope.</p>
  </FormSection>
}

function BusinessTaxInformation({ tax, details, businessType, canAttest, errors, evidence, declarationEvidence }: { tax: JsonRecord; details: JsonRecord; businessType: string; canAttest: boolean; errors: Record<string, string>; evidence: ReactNode; declarationEvidence: ReactNode }) {
  const [declaration, setDeclaration] = useState(typeof details.taxReliefClaimed === 'boolean' ? (details.taxReliefClaimed ? 'yes' : 'no') : '')
  return <><FormSection panel title="Tax Information" description="Your tax information is reviewed with Business Information. Payment Configuration references this Tax Profile; you will not need to enter it again. Only masked TIN values are returned after saving.">
    <FormSection title="Tax Identity" description="Use the identifiers shown on your BIR registration record.">
      <div className="grid min-w-0 items-start gap-6 lg:grid-cols-2">
      <Field label="Taxpayer Identification Number (TIN)" name="tin" id="tin" error={errors.tin ?? ''} type="password" inputMode="numeric" pattern="([0-9]{12,14}|[0-9]{3}-[0-9]{3}-[0-9]{3}-[0-9]{3,5})" minLength={12} maxLength={17} autoComplete="off" placeholder="123-456-789-000" hint={`Your 9-digit TIN and 3 to 5 digit branch code. Please use “000” as your branch code if you don’t have one (e.g. 999-999-999-000).${tax.tinLast4 ? ' A TIN is saved. Leave blank to retain it.' : ''}`} />
      <fieldset><legend className="text-sm font-semibold">Value Added Tax Registration Status</legend><div className="flex flex-wrap gap-6">{[['VAT', 'VAT Registered'], ['NON_VAT', 'Non-VAT Registered']].map(([value, label]) => <label key={value} className="flex min-h-11 items-center gap-3 text-sm"><input type="radio" aria-describedby="vat_category-error" name="vat_category" value={value} defaultChecked={tax.vatCategory === value} className="h-5 w-5 accent-action-primary" />{label}</label>)}</div><InlineError name="vat_category" /></fieldset>
      </div>
    </FormSection>
    <div className="grid min-w-0 items-start gap-6 lg:grid-cols-2">
    <div className="min-w-0">{evidence}</div>
    <FormSection title="Verification & References" description="Provide the supporting registration reference and fiscal year details.">
      <div className="grid max-w-xl gap-5">
      <Field label="BIR Certificate of Registration (BIR Form 2303) reference" name="bir_cor_reference" defaultValue={stringValue(tax.birCorReference)} />
      <Field label="Fiscal year start month" name="fiscal_year_start_month" type="number" min="1" max="12" hint="Month number from 1 (January) to 12 (December)." defaultValue={String(numberValue(tax.fiscalYearStartMonth, 1))} />
      </div>
    </FormSection>
    </div>
    <FormSection panel title="Sworn Declaration">
      <StatusMessage tone="info" dismissLabel="Dismiss Sworn Declaration guidance"><ul className="list-disc space-y-2 pl-5"><li>A BIR-received declaration may be submitted when applicable annual gross remittances are expected not to exceed ₱500,000.00.</li><li>Admin review and applicable BIR rules apply. Selecting Yes does not grant tax relief.</li><li>Standard withholding is 1% of one-half of applicable gross remittances (equivalent to 0.5%), subject to configured rules.</li></ul></StatusMessage>
      <p className="font-medium">Will you submit the applicable BIR-received Sworn Declaration?</p>
      <div className="flex flex-wrap gap-6">{([['yes', 'Yes'], ['no', 'No — use applicable standard withholding']] as const).map(([value, label]) => <label key={value} className="flex min-h-11 items-center gap-3 text-sm"><input type="radio" name="tax_relief_claimed" value={value} checked={declaration === value} onChange={() => setDeclaration(value)} className="h-5 w-5 accent-action-primary" />{label}</label>)}</div>
      <InlineError name="tax_relief_claimed" />
      {declaration === 'yes' && <><div className="max-w-xl"><Field label="Declaration taxable year" name="declaration_year" type="number" min="2000" max="2100" defaultValue={stringValue(details.declarationYear, String(new Date().getFullYear()))} /></div><p className="text-sm text-text-secondary">Select the BIR-received / BIR-stamped PDF to include with your submission.</p>{declarationEvidence}</>}
    </FormSection>
    <label className="flex min-h-11 items-start gap-3 text-sm leading-6"><input disabled={!canAttest} className="mt-1 h-5 w-5 accent-action-primary" type="checkbox" id="owner_attested" aria-invalid={Boolean(errors.owner_attested)} name="owner_attested" defaultChecked={false} />I am the Vendor Owner and attest that this tax information is accurate.</label><InlineError name="owner_attested" />{booleanValue(tax.ownerAttested) && <p className="text-sm text-text-secondary">Your saved tax version is already attested. A correction creates a new version and requires a new attestation.</p>}
    {businessType && !canAttest && <p className="text-sm text-text-secondary">Organizational tax attestation requires Admin-approved Authority to Act for the current representative. You can save draft information and submit evidence for review first.</p>}
  </FormSection>
      <StatusMessage tone="info"><div className="grid gap-2"><span className="font-semibold">Verified VAT status: {statusLabel(stringValue(tax.vatVerifiedCategory, 'PENDING_VERIFICATION'))}</span><p>Admin reviews your declared VAT status against your BIR Certificate of Registration. Uploading a COR does not verify this Tax Profile. Expiration may be Not Applicable.</p></div></StatusMessage>
    <StatusMessage tone="info" dismissLabel="Dismiss withholding information"><p className="font-semibold">Withholding information · FIN-04A</p><ul className="mt-2 list-disc space-y-2 pl-5"><li>Cumulative gross remittances reaching ₱500,000.01 in a taxable year make the entire crossing remittance and every later remittance that year subject to withholding.</li><li>This applies regardless of an uploaded declaration. Uploading a declaration grants no exemption, reduced withholding or threshold relief.</li></ul></StatusMessage>
  </>
}

const FormSection = OnboardingFormSection

function SelectField({ label, name, defaultValue, options }: { label: string; name: string; defaultValue: string; options: string[] }) {
  const errors = useContext(FormErrors)
  return <div className="grid gap-2 text-sm font-semibold"><label htmlFor={name}>{label}</label><select aria-invalid={Boolean(errors[name])} aria-describedby={errors[name] ? `${name}-error` : undefined} className="min-h-12 w-full rounded-control border border-border-default aria-invalid:border-status-error bg-surface-primary px-3 text-base font-normal text-text-strong" id={name} name={name} defaultValue={defaultValue}><option value="">Select an option</option>{options.map((option) => <option key={option} value={option}>{statusLabel(option)}</option>)}</select><InlineError name={name} /></div>
}

function StoreContactInformation({ snapshot, onSaved, initialEmail }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; initialEmail: string }) {
  const org = record(snapshot.organization)
  return <EmailVerificationPanel panel initialEmail={initialEmail} email={stringValue(org.storeEmail)} verified={booleanValue(org.storeEmailVerified)} canChange={snapshot.permissions.includes('vendor.onboarding.manage')} explainError={readableOnboardingError}
    requestCode={async email => { const result = record(await requestStoreEmailVerification(email)); return result.expiresAt ? `Expires at ${String(result.expiresAt)}.` : '' }}
    confirmCode={async (email, code) => { const updated = await confirmStoreEmailVerification({ email, code }); onSaved(updated); return stringValue(record(updated.organization).storeEmail) }}
    phone={<div className="min-w-0"><Field label="Store phone" name="store_phone" required defaultValue={stringValue(org.storePhone)} inputMode="tel" /><label className="mt-2 flex min-h-11 items-center gap-3 text-sm"><input className="h-5 w-5 accent-action-primary" type="checkbox" onChange={event => { if (event.target.checked) { const field = event.target.form?.elements.namedItem('store_phone'); if (field instanceof HTMLInputElement) field.value = stringValue(record(record(snapshot.verification).owner).phone) } }} />Same as Vendor Owner phone number</label></div>} />
}

function DocumentChecklist({ snapshot, embedded = false, keys, preview = {}, declarationClaim, identityLayout = false }: { snapshot: VendorOnboardingSnapshot; onRefresh: () => Promise<void>; embedded?: boolean; keys?: string[]; preview?: JsonRecord; pendingChanges?: boolean; declarationClaim?: boolean; identityLayout?: boolean; reviewUploads?: boolean }) {
  const context = useContext(PendingDocuments)
  const section = sectionFor(snapshot, 'STORE_VERIFICATION')
  const documents = arrayValue(record(snapshot.verification).documents)
  return <section className={`grid min-w-0 items-start gap-6 ${identityLayout ? 'md:grid-cols-2' : ''}`} aria-label={embedded ? 'Required evidence' : 'Documents'}>
    {(keys ?? ['business_registration', 'lgu_permit']).map(key => {
      const requirement = section.steps.find(item => item.key === key)
      const resolved = record(preview[key])
      if (key === 'tax_relief_evidence' ? !declarationClaim : resolved.applicable === false || (!Object.keys(resolved).length && requirement?.status === 'NOT_APPLICABLE')) return null
      const label = key === 'bir_cor' ? 'BIR Certificate of Registration (BIR Form 2303)' : identityLayout ? `${key.startsWith('representative_identity') ? 'Representative government ID' : 'Government ID'} — ${key.includes('back') ? 'back' : 'front'}` : stringValue(resolved.label, requirement?.label ?? statusLabel(key))
      const current = documents.find(doc => doc.requirementKey === key && !doc.supersededAt)
      const pending = context.pending.find(doc => doc.requirementKey === key)
      const correction = ['CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'].includes(stringValue(current?.status, requirement?.status))
      const locked = ['SUBMITTED', 'PENDING_VERIFICATION', ...(context.editing ? [] : ['APPROVED'])].includes(stringValue(current?.status, requirement?.status))
      const error = context.errors[key]
      return <div key={key} className={`grid min-w-0 content-start gap-3 border-t pt-4 ${error || correction ? 'border-status-error' : 'border-border-default'}`}>
        <h3 className="font-semibold">{label}</h3>
        <p className="text-sm">{statusLabel(stringValue(resolved.level, requirement?.level ?? 'REQUIRED'))} · {pending || context.files[key] ? 'Pending Submission' : correction ? 'Correction Required' : current ? statusLabel(stringValue(current.status)) : 'Not selected'}</p>
        {correction && requirement?.reason && <p className="text-sm text-status-error">Admin reason: {requirement.reason}</p>}
        <p className="text-sm text-text-secondary">Private {key === 'tax_relief_evidence' ? 'PDF' : 'JPG, JPEG, PNG or PDF'}, up to 10 MB. Admin checks the document after submission.</p>
        {current && <div className="grid min-w-0 gap-2 text-sm"><p className="break-all">{stringValue(current.originalName)} · {correction ? 'Previous submitted version' : 'Version'} {numberValue(current.version)}</p><PrivateEvidenceButton apiBasePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} loadUrl={() => getVendorPrivateFileUrl(stringValue(current.fileId))}>View submitted document</PrivateEvidenceButton></div>}
        {!locked && <><DocumentUploadField label={label} name={key} file={context.files[key] ?? null} savedFile={pending ? { name: stringValue(pending.originalName), size: numberValue(pending.byteSize) } : undefined} pdfOnly={key === 'tax_relief_evidence'} busy={context.busy} error={error} onChange={file => context.select(key, file)} />{pending && <PrivateEvidenceButton apiBasePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} loadUrl={() => getVendorPrivateFileUrl(stringValue(pending.fileId))}>View saved document</PrivateEvidenceButton>}{correction && (pending || context.files[key]) && <p className="text-sm">Replacement for version {numberValue(current?.version)}. Submit for Admin Review to send the new version.</p>}</>}
        {locked && error && <p role="alert" className="text-sm text-status-error">{error}</p>}
      </div>
    })}
  </section>
}

async function uploadVehicleImage(file: File): Promise<string> {
  try {
    const result = record(await uploadVendorMedia('VEHICLE_IMAGE', file, 'Delivery vehicle'))
    const id = stringValue(result.fileId, stringValue(result.id))
    if (!id) throw new Error('The upload did not return a vehicle image. Try again.')
    return id
  } catch (cause) { throw new Error(await readableOnboardingError(cause)) }
}

async function resolveVehicleImage(id: string): Promise<string> {
  const url = stringValue(record(await getVendorPrivateFileUrl(id)).url)
  const blob = await readWebPrivateFile(import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1', url)
  if (!['image/jpeg', 'image/png', 'image/webp'].includes(blob.type)) throw new Error('Unsupported vehicle image.')
  return URL.createObjectURL(blob)
}

function SetupWorkspace({ snapshot, onSaved, onRefresh }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; onRefresh: () => Promise<void> }) {
  return <SetupForm snapshot={snapshot} onSaved={onSaved} onRefresh={onRefresh} />
}

function operatingDays(value: unknown): StoreOperatingDay[] {
  const saved = Array.isArray(value) ? value : []
  return emptyStoreSchedule().map(day => {
    const item = saved.find(row => row && typeof row === 'object' && ('dayOfWeek' in row ? row.dayOfWeek : 'day_of_week' in row ? row.day_of_week : null) === day.dayOfWeek)
    if (!item || typeof item !== 'object') return day
    const row = record(item)
    const status = stringValue(row.status)
    return { ...day, status: status === 'OPEN' || status === 'CLOSED' ? status : '', opensAt: stringValue(row.opensAt, stringValue(row.opens_at)), closesAt: stringValue(row.closesAt, stringValue(row.closes_at)) }
  })
}

function SetupForm({ snapshot, onSaved, onRefresh }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; onRefresh: () => Promise<void> }) {
  const org = record(snapshot.organization)
  const setup = record(snapshot.setup)
  const progress = record(setup.formState)
  const profile = record(setup.profile)
  const formRef = useRef<HTMLFormElement>(null)
  const saving = useRef(false)
  const editRevision = useRef(0)
  const failedRevision = useRef(-1)
  const pendingImages = useRef(new Set<string>())
  const delivery = record(setup.delivery)
  const [deliveryErrors, setDeliveryErrors] = useState<Record<string, Record<string, string>>>({})
  const [vehicles, setVehicles] = useState(() => Array.isArray(progress.vehicles) ? arrayValue(progress.vehicles).map(row => {
    const vehicle = emptyDeliveryVehicle()
    for (const key of Object.keys(vehicle) as (keyof typeof vehicle)[]) {
      if (key === 'active') vehicle.active = row.active !== false
      else if (typeof row[key] === 'string') Object.assign(vehicle, { [key]: row[key] })
    }
    if (typeof row.id === 'string') vehicle.id = row.id
    return vehicle
  }) : arrayValue(setup.vehicles).length ? arrayValue(setup.vehicles).map(vehicleDraft) : [emptyDeliveryVehicle()])
  const [vehiclesTouched, setVehiclesTouched] = useState(false)
  const payment = record(setup.payment)
  const [step, setStep] = useState(0)
  const [dirty, setDirty] = useState(false)
  const [schedule, setSchedule] = useState<StoreOperatingDay[]>(() => operatingDays(progress.operatingScheduleDraft ?? setup.operating_schedule))
  const [scheduleTouched, setScheduleTouched] = useState(false)
  const [scheduleErrors, setScheduleErrors] = useState<Record<number, string>>({})
  const [servicesCapability, setServicesCapability] = useState(stringValue(profile.fulfillmentMethod))
  const [bulkCapability, setBulkCapability] = useState(profile.bulkCapability === true ? 'yes' : profile.bulkCapability === false ? 'no' : '')
  const deliveryRequired = ['VENDOR_DELIVERY', 'BOTH'].includes(servicesCapability)
  const verificationName = record(record(snapshot.verification).formState).store_name
  const initialStoreName = stringValue(profile.publicStoreName).trim() || (Array.isArray(verificationName) ? stringValue(verificationName[0]).trim() : '') || stringValue(org.storeName)
  const [preview, setPreview] = useState({ name: initialStoreName, description: stringValue(profile.description) })
  const [busy, setBusy] = useState(false)
  const navigate = useNavigate()
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)

  async function save(force = false): Promise<boolean> {
    if (!dirty && !force) return true
    if (saving.current || !formRef.current) return false
    if (vehicles.some(vehicle => pendingImages.current.has(vehicle.key))) { setMessage({ tone: 'error', text: 'Wait for the vehicle image upload to finish, or retry the failed upload before leaving.' }); return false }
    const scheduleIssues = scheduleTouched ? storeScheduleErrors(schedule) : {}
    if (scheduleTouched) setScheduleErrors(scheduleIssues)
    const revision = editRevision.current
    saving.current = true; setBusy(true); setMessage(null)
    const data = new FormData(formRef.current)
    const fulfillment = stringValue(data.get('fulfillment_method'))
    const draft: import('@materyalph/api-client-ts').VendorSetupDraft = { organizationLockVersion: numberValue(org.lockVersion, 1), draftLockVersion: numberValue(arrayValue(snapshot.drafts).find(item => item.workstream === 'STORE_SETUP')?.lockVersion, 0), publicStoreName: stringValue(data.get('public_store_name')).trim(), description: stringValue(data.get('description')).trim() || null, bulkCapability: data.get('bulk_capability') === 'yes', fulfillmentMethod: fulfillment as NonNullable<import('@materyalph/api-client-ts').VendorSetupDraft['fulfillmentMethod']> }
    if (!fulfillment) delete draft.fulfillmentMethod
    if (!data.has('bulk_capability')) delete draft.bulkCapability
    if (scheduleTouched && !Object.keys(scheduleIssues).length) draft.operatingSchedule = schedule.map(day => ({ dayOfWeek: day.dayOfWeek, status: day.status as 'OPEN' | 'CLOSED', opensAt: day.status === 'OPEN' ? day.opensAt : null, closesAt: day.status === 'OPEN' ? day.closesAt : null }))
    if (['VENDOR_DELIVERY', 'BOTH'].includes(fulfillment)) {
      draft.delivery = { coverageNotes: stringValue(delivery.coverageNotes) || null }
      if (vehiclesTouched) {
        const issues = Object.fromEntries(vehicles.map(vehicle => [vehicle.key, vehicleErrors(vehicle)]))
        if (Object.values(issues).every(errors => Object.keys(errors).length === 0)) draft.vehicles = vehicles.map(vehiclePayload)
      }
    }
    draft.formState = JSON.stringify({ ...(!draft.vehicles && (vehiclesTouched || Array.isArray(progress.vehicles)) ? { vehicles } : {}), ...(scheduleTouched && Object.keys(scheduleIssues).length ? { operatingScheduleDraft: schedule } : {}) })
    try { const updated = await saveVendorSetupDraft(draft); onSaved(updated); if (editRevision.current === revision) { if (draft.vehicles) { setVehicles(arrayValue(record(updated.setup).vehicles).map(vehicleDraft)); setVehiclesTouched(false) } setDirty(false); if (!Object.keys(scheduleIssues).length) { setScheduleTouched(false); setScheduleErrors({}) } setMessage({ tone: 'success', text: Object.keys(scheduleIssues).length ? 'Draft saved; complete Store Operation to apply its hours.' : 'Saved' }) }; return editRevision.current === revision } catch (cause) {
      failedRevision.current = revision
      if (cause instanceof ResponseError && cause.response.status === 409) await onRefresh()
      const fields = await onboardingFieldErrors(cause)
      const mapping: Record<string, string> = { vehicle_category: 'category', vehicle_type: 'type', custom_type_name: 'customType', name: 'name', brand: 'brand', capacity_kg: 'weight', number_available: 'count', mixer_capacity_m3: 'mixer', cargo_length_m: 'length', cargo_width_m: 'width', cargo_height_m: 'height', heavy_classification: 'heavy', base_fee_centavos: 'baseFee', per_km_centavos: 'perKm', image_file_id: 'imageId' }
      const errors: Record<string, Record<string, string>> = {}
      for (const [field, message] of Object.entries(fields)) {
        const match = /^vehicles\.(\d+)\.(.+)$/.exec(field)
        const vehicle = match ? vehicles[Number(match[1])] : undefined
        const name = match?.[2] ? mapping[match[2]] : undefined
        if (vehicle && name) errors[vehicle.key] = { ...errors[vehicle.key], [name]: message }
      }
      if (Object.keys(errors).length) { setDeliveryErrors(errors); setStep(1) }
      setMessage({ tone: 'error', text: `Failed to save. ${await readableOnboardingError(cause)}` })
      return false
    } finally { saving.current = false; setBusy(false) }
  }

  const leave = useRef(save)
  leave.current = save
  const autoSave = useRef(save)
  autoSave.current = save
  useEffect(() => {
    if (!dirty || busy || pendingImages.current.size || failedRevision.current === editRevision.current) return
    const timer = window.setTimeout(() => { void autoSave.current() }, 650)
    return () => window.clearTimeout(timer)
  }, [dirty, busy, preview, vehicles, vehiclesTouched, servicesCapability, bulkCapability, schedule])
  useEffect(() => {
    const click = (event: MouseEvent) => {
      const link = event.target instanceof Element ? event.target.closest('a[href]') : null
      if (!(link instanceof HTMLAnchorElement) || link.origin !== location.origin || link.pathname === location.pathname || event.ctrlKey || event.metaKey || event.shiftKey || event.button !== 0) return
      event.preventDefault(); event.stopPropagation()
      void leave.current().then(saved => { if (saved) navigate(link.pathname + link.search) })
    }
    document.addEventListener('click', click, true)
    return () => document.removeEventListener('click', click, true)
  }, [navigate])
  useEffect(() => {
    const warn = (event: BeforeUnloadEvent) => { if (dirty || saving.current || pendingImages.current.size) event.preventDefault() }
    window.addEventListener('beforeunload', warn)
    return () => window.removeEventListener('beforeunload', warn)
  }, [dirty])

  return <OnboardingFlow autosave steps={setupSteps} current={step} onStep={next => { if (step === 4 && next > step && Object.keys(storeScheduleErrors(schedule)).length) { setScheduleErrors(storeScheduleErrors(schedule)); setMessage({ tone: 'error', text: 'Set a valid state and hours for every day before reviewing Store Setup.' }); return } if (!dirty) { setStep(next); return }; void save().then(saved => { if (saved) setStep(next) }) }} section={sectionFor(snapshot, 'STORE_SETUP')} busy={busy} actions={<><Button type="button" variant="secondary" disabled={busy} onClick={() => { void leave.current().then(saved => { if (saved) navigate('/dashboard') }) }}>{busy ? 'Saving…' : 'Finish Later'}</Button>
      {step === 5 && <SetupCompletion snapshot={snapshot} onSaved={onSaved} dirty={dirty || busy || (deliveryRequired && vehicles.some(vehicle => Object.keys(vehicleErrors(vehicle)).length > 0))} />}</>}>
    {(busy || message) && <div className="mb-5" role="status" aria-live="polite">{busy ? <StatusMessage tone="info">Saving...</StatusMessage> : message && <><StatusMessage tone={message.tone}>{message.text}</StatusMessage>{message.tone === 'error' && <Button type="button" variant="secondary" className="mt-3" onClick={() => void save()}>Retry save</Button>}</>}</div>}
    <form ref={formRef} id="setup-draft" noValidate onChange={event => { if (event.target instanceof HTMLInputElement && event.target.type === 'file') return; editRevision.current += 1; setDirty(true); const data = new FormData(event.currentTarget); setPreview({ name: stringValue(data.get('public_store_name')), description: stringValue(data.get('description')) }) }} onSubmit={event => { event.preventDefault(); void save() }}><fieldset className="min-w-0">
      <OnboardingStepContent active={step === 0}><div className="grid items-start gap-8 xl:grid-cols-[minmax(0,1.15fr)_minmax(0,1fr)]"><div className="min-w-0"><FormSection title="Store information" description="Introduce your store to Buyers. Your profile appears after Store Activation."><div className="grid gap-5"><Field label="Public store name" name="public_store_name" defaultValue={initialStoreName} required /><div className="grid gap-2 text-sm font-semibold"><label htmlFor="description">Store description</label><p className="text-xs font-normal text-text-secondary">Required for Public Store Profile completion.</p><textarea className="min-h-32 w-full rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="description" name="description" defaultValue={stringValue(profile.description)} /></div></div></FormSection><div className="mt-8 border-t border-border-default pt-6"><MediaUploader embedded snapshot={snapshot} onRefresh={onRefresh} beforeUpload={() => save(dirty || !profile.publicStoreName)} /></div></div><StoreProfilePreview snapshot={snapshot} profile={preview} /></div></OnboardingStepContent>
      <OnboardingStepContent active={step === 1}>
        <div className="grid gap-8">
          <div>
            <ChoiceField legend="Bulk Order Capability" description="Choose the procurement types your store can support." name="bulk_capability" value={bulkCapability} onChange={setBulkCapability} required options={[
              { value: 'yes', label: 'Yes', description: 'Eligible for Item-Based and Project-Based procurement.' },
              { value: 'no', label: 'No', description: 'Eligible for Item-Based procurement only.' },
            ]} />
            <p className="mt-3 text-sm leading-6 text-text-secondary">Changes apply to future procurement eligibility. Accepted orders stay unchanged. Bulk capability does not enable competitive RFQ bidding, auctions or automatic vendor competition.</p>
          </div>
          <div className="border-t border-border-default pt-6">
            <ChoiceField legend="Services Capability" description="Choose how Buyers can receive their orders." name="fulfillment_method" value={servicesCapability} onChange={setServicesCapability} required options={[
              { value: 'SELF_PICKUP', label: 'Self-Pickup', description: 'Buyers collect their orders. Delivery Configuration is not applicable.' },
              { value: 'VENDOR_DELIVERY', label: 'Vendor Delivery', description: 'Your store delivers orders. Delivery Configuration is required.' },
              { value: 'BOTH', label: 'Both', description: 'Offer pickup and delivery. Delivery Configuration is required.' },
            ]} />
            <p className="mt-4 text-sm leading-6 text-text-secondary" role="status">{servicesCapability === 'SELF_PICKUP' ? 'Delivery Configuration: Not applicable for Self-Pickup only.' : deliveryRequired ? 'Complete Delivery Configuration below before Store Activation.' : 'Select a service to see whether Delivery Configuration is required.'}</p>
          </div>
        </div>
      </OnboardingStepContent>
      <OnboardingStepContent active={step === 1}><fieldset hidden={!deliveryRequired} disabled={!deliveryRequired} className="mt-8 min-w-0"><DeliveryVehicles onImagePending={(key, pending) => { if (pending) pendingImages.current.add(key); else pendingImages.current.delete(key) }} errors={deliveryErrors} vehicles={vehicles} onChange={next => { editRevision.current += 1; setVehicles(next); setVehiclesTouched(true); setDirty(true) }} uploadImage={uploadVehicleImage} resolveImage={resolveVehicleImage} coverageKm={numberValue(delivery.maximumDistanceKm, 50)} /></fieldset></OnboardingStepContent>
    </fieldset></form>

    <OnboardingStepContent active={step === 2}><XenditConnection
      status={stringValue(payment.connectionStatus, 'NOT_CONNECTED')}
      providerStatus={stringValue(payment.providerStatus)}
      lastError={stringValue(payment.lastErrorCode)}
      accountSuffix={stringValue(payment.accountSuffix)}
      canConfigure={snapshot.permissions.includes('vendor.payment.configure')}
      describeError={readableOnboardingError}
      connect={async () => {
        if (dirty && !await save()) throw new Error('Save your Store Setup changes before connecting Xendit.')
        try { return await connectVendorPayment() } finally { await onRefresh() }
      }}
      reconcile={async () => {
        try { return await reconcileVendorPaymentConnection() } finally { await onRefresh() }
      }}
    /></OnboardingStepContent>
    <OnboardingStepContent active={step === 3}>{snapshot.permissions.includes('staff.manage') ? <VendorTeamInvitations organizationName={stringValue(record(snapshot.organization).storeName, 'Your store')} canInviteManager={snapshot.permissions.includes('managers.manage')} invite={inviteVendorTeamMember} list={listVendorTeamInvitations} explainError={readableOnboardingError} /> : <p>Team Accounts are optional. The Vendor Owner can invite employees before or after Store Activation.</p>}</OnboardingStepContent>
    <OnboardingStepContent active={step === 4}><StoreOperationSchedule days={schedule} errors={scheduleErrors} onChange={next => { editRevision.current += 1; setSchedule(next); setScheduleTouched(true); setDirty(true); setScheduleErrors({}) }} /></OnboardingStepContent>
    <OnboardingStepContent active={step === 5}><p className="mb-5 text-sm leading-6 text-text-secondary">Review the saved setup below. Completion requires a valid weekly schedule and confirmed TEST payment connection. Store Activation remains a separate gate.</p>{dirty && <StatusMessage tone="info">Your changes will save when you continue or finish later.</StatusMessage>}<ReviewDetails items={[["Public store name", stringValue(profile.publicStoreName)], ["Services Capability", statusLabel(stringValue(profile.fulfillmentMethod))], ["Bulk Order Capability", profile.bulkCapability === true ? 'Yes — Item-Based and Project-Based' : profile.bulkCapability === false ? 'No — Item-Based only' : 'Not configured'], ["TEST payment connection", statusLabel(stringValue(payment.connectionStatus, 'UNVERIFIED'))]]} /><StoreHours days={operatingDays(record(snapshot.setup).operating_schedule)} /><Checklist title="Setup checklist" section={sectionFor(snapshot, 'STORE_SETUP')} /></OnboardingStepContent>
  </OnboardingFlow>
}

function MediaUploader({ snapshot, onRefresh, beforeUpload, embedded = false }: { snapshot: VendorOnboardingSnapshot; onRefresh: () => Promise<void>; beforeUpload?: () => Promise<boolean>; embedded?: boolean }) {
  const setup = record(snapshot.setup)
  const media = arrayValue(setup.media)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const [retry, setRetry] = useState<{ kind: 'LOGO' | 'BANNER'; file: File } | null>(null)
  async function upload(kind: 'LOGO' | 'BANNER', file: File | undefined, input?: HTMLInputElement) {
    if (!file) return
    setBusy(true); setMessage(null); setRetry(null)
    try {
      if (beforeUpload && !await beforeUpload()) { setRetry({ kind, file }); setMessage('Save the current profile changes, then retry the upload.'); return }
      await uploadVendorMedia(kind, file, kind === 'LOGO' ? 'Store logo' : 'Store banner'); await onRefresh(); setMessage(`${statusLabel(kind)} uploaded.`)
    } catch (cause) { setRetry({ kind, file }); setMessage(await readableOnboardingError(cause)) } finally { setBusy(false); if (input) input.value = '' }
  }
  async function remove(mediaId: string) {
    setBusy(true); setMessage(null)
    try { await removeVendorMedia(mediaId); await onRefresh(); setMessage('Image removed.') }
    catch (cause) { setMessage(`Failed to remove image. ${await readableOnboardingError(cause)}`) }
    finally { setBusy(false) }
  }
  return <section className={embedded ? '' : 'rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7'} aria-labelledby="media-title"><div className="flex items-start gap-3"><ImagePlus className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="media-title" className="text-lg font-semibold">Store media</h2><p className="mt-2 text-sm leading-6 text-text-secondary">A logo and banner are required for Public Store Profile completion. Save your profile details before uploading. JPEG, PNG or WebP images are supported.</p></div></div><div className="mt-6 grid gap-4 sm:grid-cols-2">{(['LOGO', 'BANNER'] as const).map((kind) => { const current = media.filter(item => stringValue(item.kind) === kind).at(-1); return <div className="min-w-0 rounded-control border border-border-default p-4" key={kind}><p className="font-semibold">{statusLabel(kind)}</p><StoreMediaPreview media={current} kind={kind} /><p className="mt-1 text-sm text-text-secondary">{current ? 'Asset uploaded' : 'No asset uploaded'}</p><div className="mt-4 flex flex-wrap gap-2"><label className="inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-control border border-border-default px-4 text-sm font-semibold hover:bg-brand-orange-50 focus-within:ring-2 focus-within:ring-focus-ring"><UploadCloud size={16} aria-hidden="true" />{busy ? 'Uploading…' : 'Upload image'}<input className="sr-only" type="file" accept="image/jpeg,image/png,image/webp" disabled={busy} onChange={(event) => void upload(kind, event.target.files?.[0], event.currentTarget)} /></label>{current && <Button type="button" variant="secondary" disabled={busy} onClick={() => void remove(stringValue(current.id))}>Remove {kind.toLowerCase()}</Button>}</div></div> })}</div>{message && <div className="mt-4"><StatusMessage tone={retry || message.startsWith('Failed') ? 'error' : 'success'}>{message}</StatusMessage>{retry && <Button className="mt-3" type="button" variant="secondary" disabled={busy} onClick={() => void upload(retry.kind, retry.file)}>Retry {retry.kind.toLowerCase()} upload</Button>}</div>}</section>
}

function SetupCompletion({ snapshot, onSaved, dirty }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; dirty: boolean }) {
  const navigate = useNavigate()
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const setup = record(snapshot.setup)
  const status = stringValue(setup.status, 'NOT_STARTED')
  async function complete() {
    setBusy(true); setMessage(null)
    try { onSaved(await completeVendorSetup({ organizationLockVersion: numberValue(record(snapshot.organization).lockVersion, 1) })); setMessage('Store Setup completed. Activation remains a separate gate.'); navigate('/dashboard') } catch (cause) { setMessage(await readableOnboardingError(cause)) } finally { setBusy(false) }
  }
  return <>{message && <div className="w-full"><StatusMessage tone={message.includes('completed') ? 'success' : 'error'}>{message}</StatusMessage></div>}<Button disabled={busy || dirty || status === 'COMPLETED'} onClick={() => void complete()}>{busy ? 'Completing…' : status === 'COMPLETED' ? 'Setup completed' : 'Complete Store Setup'} <ArrowRight size={16} aria-hidden="true" /></Button></>
}

export function VendorTeamPage() {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  if (loading && !snapshot) return <VendorShell navigationData={snapshot} activeHref="/team" accountLabel="Vendor team"><LoadingState /></VendorShell>
  if (error && !snapshot) return <VendorShell navigationData={snapshot} activeHref="/team" accountLabel="Vendor team"><ErrorState message={error} onRetry={() => void refresh()} /></VendorShell>
  if (!snapshot) return null
  if (!snapshot.permissions.includes('staff.manage')) return <Navigate to="/dashboard" replace />
  return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/team" accountLabel="Vendor team"><div className="mx-auto max-w-6xl space-y-7"><PageHeader eyebrow="Team accounts" title="Your store team" description="Invite individual employees and assign one fixed role. The Vendor Owner retains control and oversight of the store." /><section className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7"><VendorTeamInvitations organizationName={stringValue(record(snapshot.organization).storeName, 'Your store')} canInviteManager={snapshot.permissions.includes('managers.manage')} invite={inviteVendorTeamMember} list={listVendorTeamInvitations} explainError={readableOnboardingError} /></section>{snapshot.permissions.includes('staff.delegate') && <StaffDisputeSetting snapshot={snapshot} refresh={refresh} />}<Link to="/settings" className="inline-flex min-h-11 items-center text-action-primary underline">Manage existing staff access in Account Settings</Link></div></VendorShell>
}
function StaffDisputeSetting({ snapshot, refresh }: { snapshot: VendorOnboardingSnapshot; refresh: () => Promise<unknown> }) {
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const org = record(snapshot.organization)
  return <section className="space-y-3 border-t border-border-default pt-6"><h2 className="text-lg font-semibold">Staff dispute access</h2><label className="flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={booleanValue(org.staffDisputesEnabled, true)} disabled={busy} onChange={async event => { setBusy(true); setMessage(null); try { await changeVendorStaffDisputes(event.target.checked, numberValue(org.lockVersion, snapshot.lockVersion)); await refresh() } catch (error) { setMessage(await readableOnboardingError(error)) } finally { setBusy(false) } }} />Allow staff to handle disputes and appeals</label><p className="text-sm text-text-secondary">Applies to Store Staff and Customer Service Staff. Enabled by default. Verify your identity in Account Settings → Security before changing this setting.</p>{message && <StatusMessage tone="error">{message}</StatusMessage>}</section>
}

export function VendorAccountPage() {
  return <VendorShell activeHref="/settings" accountLabel="Vendor account"><AccountWorkspace embedded portal="vendors" basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} loginPath="/login" renderQr={uri => <QRCodeSVG value={uri} title="Authenticator setup QR code" />} /></VendorShell>
}

export function VendorStoreProfilePage() {
  const businessSave = useRef<(() => Promise<boolean>) | null>(null)
  const configurationSave = useRef<(() => Promise<boolean>) | null>(null)
  const registerBeforeLeave = useCallback((save: (() => Promise<boolean>) | null) => { businessSave.current = save }, [])
  const registerConfigurationSave = useCallback((save: (() => Promise<boolean>) | null) => { configurationSave.current = save }, [])
  const { snapshot, loading, error, refresh, setSnapshot } = useOnboardingSnapshot()
  if (loading && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/store-profile" accountLabel="Vendor account"><LoadingState /></VendorShell>
  if (error && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/store-profile" accountLabel="Vendor account"><ErrorState message={error} onRetry={() => void refresh()} /></VendorShell>
  if (!snapshot) return null
  if (!snapshot.permissions.includes('vendor.onboarding.submit')) return <VendorShell navigationData={snapshot} activeHref="/store-profile" accountLabel="Store Profile"><h1 className="text-3xl font-semibold">Store Profile</h1><p className="mt-4">{stringValue(record(snapshot.organization).storeName, 'Your store')}</p><p className="mt-3 text-text-secondary">Your individual account belongs to this Vendor organization. Protected business and ownership details are managed by the Vendor Owner.</p></VendorShell>
  if (record(snapshot.activation).status !== 'ACTIVE') return <Navigate to="/dashboard" replace />
  const org = record(snapshot.organization)
  const profile = record(record(snapshot.setup).profile)
  return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/store-profile" accountLabel={stringValue(org.storeName, 'Your store')}><div className="mx-auto max-w-[1600px] space-y-6"><header className="rounded-surface border border-border-default bg-surface-primary p-6"><div className="mb-5 min-h-24 rounded-control bg-surface-canvas"><StoreMediaPreview media={arrayValue(record(snapshot.setup).media).filter(item => stringValue(item.kind) === 'BANNER').at(-1)} kind="BANNER" /></div><div className="flex flex-col gap-5 sm:flex-row sm:items-center"><div className="w-24 shrink-0"><StoreMediaPreview media={arrayValue(record(snapshot.setup).media).filter(item => stringValue(item.kind) === 'LOGO').at(-1)} kind="LOGO" /></div><div className="min-w-0 flex-1"><p className="text-xs font-semibold uppercase tracking-widest text-text-secondary">Store profile</p><h1 className="mt-2 break-words text-2xl font-semibold sm:text-3xl">{stringValue(profile.publicStoreName, stringValue(org.storeName, 'Store Profile'))}</h1><p className="mt-2 break-words text-text-secondary">{stringValue(profile.description, 'Your marketplace business profile')}</p></div><StatusBadge label={record(snapshot.setup).vacationMode === true ? 'Vacation Mode on' : 'Active store'} /></div></header><div className="rounded-surface border border-border-default bg-surface-primary p-4 sm:p-7"><SectionWorkspace beforeSectionChange={() => businessSave.current?.() ?? configurationSave.current?.() ?? true} sections={[
    { label: 'Store Information', content: <div className="grid items-start gap-8 xl:grid-cols-[minmax(0,1.2fr)_minmax(0,1fr)]"><PublicStoreProfileEditor snapshot={snapshot} onSaved={setSnapshot} /><MediaUploader embedded snapshot={snapshot} onRefresh={refresh} /></div> },
    { label: 'Business Information', content: <StoreBusinessInformation snapshot={snapshot} renderEditor={() => <VerificationForm editing registerBeforeLeave={registerBeforeLeave} snapshot={snapshot} onSaved={setSnapshot} onRefresh={refresh} />} /> },
    { label: 'Store Location', content: <StoreLocation snapshot={snapshot} /> },
    { label: 'Vacation Mode', content: <StoreVacationMode snapshot={snapshot} onSaved={setSnapshot} /> },
    { label: 'Operating Hours', content: <StoreOperationEditor snapshot={snapshot} onSaved={setSnapshot} /> },
    { label: 'Fulfillment Configuration', content: <StoreFulfillmentEditor snapshot={snapshot} onSaved={setSnapshot} registerBeforeLeave={registerConfigurationSave} /> },
    { label: 'Vehicles Management', content: <StoreVehiclesEditor snapshot={snapshot} onSaved={setSnapshot} registerBeforeLeave={registerConfigurationSave} /> },
  ]} /></div></div></VendorShell>
}
type ProfileSectionEditorProps = { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; registerBeforeLeave: (save: (() => Promise<boolean>) | null) => void }

function StoreFulfillmentEditor({ snapshot, onSaved, registerBeforeLeave }: ProfileSectionEditorProps) {
  const profile = record(record(snapshot.setup).profile)
  const delivery = record(record(snapshot.setup).delivery)
  const [bulk, setBulk] = useState(profile.bulkCapability === true ? 'yes' : profile.bulkCapability === false ? 'no' : '')
  const [method, setMethod] = useState(stringValue(profile.fulfillmentMethod))
  const [coverageNotes, setCoverageNotes] = useState(stringValue(delivery.coverageNotes))
  const [dirty, setDirty] = useState(false)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const editRevision = useRef(0)
  const save = async (): Promise<boolean> => {
    if (!dirty) return true
    if (busy) return false
    if (!bulk || !method) { setMessage({ tone: 'error', text: 'Choose bulk order capability and a fulfillment method.' }); return false }
    const revision = editRevision.current
    setBusy(true); setMessage(null)
    try {
      onSaved(await saveVendorSetupDraft({ organizationLockVersion: numberValue(record(snapshot.organization).lockVersion, 1), draftLockVersion: numberValue(arrayValue(snapshot.drafts).find(item => item.workstream === 'STORE_SETUP')?.lockVersion, 0), bulkCapability: bulk === 'yes', fulfillmentMethod: method as 'SELF_PICKUP' | 'VENDOR_DELIVERY' | 'BOTH', ...(method !== 'SELF_PICKUP' ? { delivery: { coverageNotes: coverageNotes.trim() || null } } : {}) }))
      if (editRevision.current === revision) { setDirty(false); setMessage({ tone: 'success', text: 'Fulfillment configuration saved. Changes apply to future procurement.' }) }
      return editRevision.current === revision
    } catch (cause) { setMessage({ tone: 'error', text: await readableOnboardingError(cause) }); return false }
    finally { setBusy(false) }
  }
  const saveRef = useRef(save)
  saveRef.current = save
  useEffect(() => { registerBeforeLeave(() => saveRef.current()); return () => registerBeforeLeave(null) }, [registerBeforeLeave])
  return <div className="max-w-4xl space-y-7"><div><h2 className="text-xl font-semibold">Fulfillment and delivery</h2><p className="mt-2 text-sm text-text-secondary">Update how Buyers can procure and receive materials. Existing accepted orders and quotations stay unchanged.</p></div>{message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
    <ChoiceField legend="Bulk Order Capability" description="Choose the procurement types your store can support." name="bulk_capability" value={bulk} onChange={value => { editRevision.current += 1; setBulk(value); setDirty(true) }} required options={[{ value: 'yes', label: 'Yes', description: 'Eligible for Item-Based and Project-Based procurement.' }, { value: 'no', label: 'No', description: 'Eligible for Item-Based procurement only.' }]} />
    <div className="border-t border-border-default pt-6"><ChoiceField legend="Services Capability" description="Choose how Buyers can receive their orders." name="fulfillment_method" value={method} onChange={value => { editRevision.current += 1; setMethod(value); setDirty(true) }} required options={[{ value: 'SELF_PICKUP', label: 'Self-Pickup', description: 'Buyers collect their orders. Delivery Configuration is not applicable.' }, { value: 'VENDOR_DELIVERY', label: 'Vendor Delivery', description: 'Your store delivers orders. Delivery Configuration is required.' }, { value: 'BOTH', label: 'Both', description: 'Offer pickup and delivery. Delivery Configuration is required.' }]} /></div>
    {method === 'SELF_PICKUP' ? <StatusMessage tone="info">Delivery Configuration is not applicable for Self-Pickup only.</StatusMessage> : <div className="space-y-4 border-t border-border-default pt-6"><ProfileDetails title="Service coverage" items={[["Maximum delivery distance", `${numberValue(delivery.maximumDistanceKm, 50)} km`]]} /><label className="grid gap-2 text-sm font-semibold" htmlFor="coverage-notes">Coverage notes<textarea id="coverage-notes" maxLength={1000} value={coverageNotes} onChange={event => { editRevision.current += 1; setCoverageNotes(event.target.value); setDirty(true) }} className="min-h-28 rounded-control border border-border-default bg-surface-primary p-3 font-normal" /></label><p className="text-sm text-text-secondary">Configure operated vehicles and delivery rates in Vehicles Management.</p></div>}
    <Button disabled={busy || !dirty} onClick={() => void save()}>{busy ? 'Saving…' : 'Save fulfillment configuration'}</Button>
  </div>
}

function StoreVehiclesEditor({ snapshot, onSaved, registerBeforeLeave }: ProfileSectionEditorProps) {
  const setup = record(snapshot.setup)
  const [vehicles, setVehicles] = useState<DeliveryVehicleDraft[]>(() => arrayValue(setup.vehicles).map(vehicleDraft))
  const [dirty, setDirty] = useState(false)
  const [busy, setBusy] = useState(false)
  const [errors, setErrors] = useState<Record<string, Record<string, string>>>({})
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const pendingImages = useRef(new Set<string>())
  const editRevision = useRef(0)
  const deliveryEnabled = ['VENDOR_DELIVERY', 'BOTH'].includes(stringValue(record(setup.profile).fulfillmentMethod))
  const save = async (): Promise<boolean> => {
    if (!dirty) return true
    if (busy) return false
    if (pendingImages.current.size) { setMessage({ tone: 'error', text: 'Wait for vehicle image uploads to finish or retry failed uploads.' }); return false }
    const issues = Object.fromEntries(vehicles.map(vehicle => [vehicle.key, vehicleErrors(vehicle)]))
    setErrors(issues)
    if (Object.values(issues).some(fields => Object.keys(fields).length)) { setMessage({ tone: 'error', text: 'Complete the highlighted vehicle details before saving.' }); return false }
    const revision = editRevision.current
    setBusy(true); setMessage(null)
    try {
      const updated = await saveVendorSetupDraft({ organizationLockVersion: numberValue(record(snapshot.organization).lockVersion, 1), draftLockVersion: numberValue(arrayValue(snapshot.drafts).find(item => item.workstream === 'STORE_SETUP')?.lockVersion, 0), vehicles: vehicles.map(vehiclePayload) })
      onSaved(updated)
      if (editRevision.current === revision) { setVehicles(arrayValue(record(updated.setup).vehicles).map(vehicleDraft)); setDirty(false); setErrors({}); setMessage({ tone: 'success', text: 'Vehicle configuration saved. Existing accepted orders stay unchanged.' }) }
      return editRevision.current === revision
    } catch (cause) {
      const fields = await onboardingFieldErrors(cause)
      const mapping: Record<string, string> = { vehicle_category: 'category', vehicle_type: 'type', custom_type_name: 'customType', name: 'name', brand: 'brand', capacity_kg: 'weight', number_available: 'count', mixer_capacity_m3: 'mixer', cargo_length_m: 'length', cargo_width_m: 'width', cargo_height_m: 'height', heavy_classification: 'heavy', base_fee_centavos: 'baseFee', per_km_centavos: 'perKm', image_file_id: 'imageId' }
      for (const [field, error] of Object.entries(fields)) {
        const match = /^vehicles\.(\d+)\.(.+)$/.exec(field)
        const vehicle = match ? vehicles[Number(match[1])] : undefined
        const name = match?.[2] ? mapping[match[2]] : undefined
        if (vehicle && name) issues[vehicle.key] = { ...issues[vehicle.key], [name]: error }
      }
      setErrors(issues); setMessage({ tone: 'error', text: await readableOnboardingError(cause) }); return false
    } finally { setBusy(false) }
  }
  const saveRef = useRef(save)
  saveRef.current = save
  useEffect(() => { registerBeforeLeave(() => saveRef.current()); return () => registerBeforeLeave(null) }, [registerBeforeLeave])
  return <div className="space-y-6"><div><h2 className="text-xl font-semibold">Registered vehicles</h2><p className="mt-2 text-sm text-text-secondary">{vehicles.filter(vehicle => vehicle.active).length} active vehicles configured for your store. Changes affect future delivery recommendations only.</p></div>{message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}{!deliveryEnabled && <StatusMessage tone="info">Select Vendor Delivery or Both in Fulfillment Configuration to use delivery vehicles.</StatusMessage>}
    {deliveryEnabled && <><DeliveryVehicles vehicles={vehicles} errors={errors} onChange={next => { editRevision.current += 1; setVehicles(next); setDirty(true); setErrors({}) }} onImagePending={(key, pending) => { if (pending) pendingImages.current.add(key); else pendingImages.current.delete(key) }} uploadImage={uploadVehicleImage} resolveImage={resolveVehicleImage} coverageKm={numberValue(record(setup.delivery).maximumDistanceKm, 50)} /><Button disabled={busy || !dirty} onClick={() => void save()}>{busy ? 'Saving…' : 'Save vehicles'}</Button></>}
  </div>
}

function StoreOperationEditor({ snapshot, onSaved }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void }) {
  const [days, setDays] = useState<StoreOperatingDay[]>(() => operatingDays(record(snapshot.setup).operating_schedule))
  const [errors, setErrors] = useState<Record<number, string>>({})
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  async function save() {
    const nextErrors = storeScheduleErrors(days)
    setErrors(nextErrors)
    if (Object.keys(nextErrors).length) return
    setBusy(true); setMessage(null)
    try {
      onSaved(await saveVendorSetupDraft({ organizationLockVersion: numberValue(record(snapshot.organization).lockVersion, 1), draftLockVersion: numberValue(arrayValue(snapshot.drafts).find(item => item.workstream === 'STORE_SETUP')?.lockVersion, 0), operatingSchedule: days.map(day => ({ dayOfWeek: day.dayOfWeek, status: day.status as 'OPEN' | 'CLOSED', opensAt: day.status === 'OPEN' ? day.opensAt : null, closesAt: day.status === 'OPEN' ? day.closesAt : null })) }))
      setMessage({ tone: 'success', text: 'Store Hours saved to your public Store Profile.' })
    } catch (cause) { setMessage({ tone: 'error', text: await readableOnboardingError(cause) }) }
    finally { setBusy(false) }
  }
  return <div className="space-y-5">{message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}<StoreHours days={operatingDays(record(snapshot.setup).operating_schedule)} /><StoreOperationSchedule days={days} errors={errors} onChange={next => { setDays(next); setErrors({}) }} /><Button disabled={busy} onClick={() => void save()}>{busy ? 'Saving…' : 'Save Store Hours'}</Button></div>
}
function PublicStoreProfileEditor({ snapshot, onSaved }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void }) {
  const profile = record(record(snapshot.setup).profile)
  const org = record(snapshot.organization)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  async function save(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const data = new FormData(event.currentTarget)
    setBusy(true); setMessage(null)
    try {
      onSaved(await saveVendorSetupDraft({ organizationLockVersion: numberValue(org.lockVersion, 1), draftLockVersion: numberValue(arrayValue(snapshot.drafts).find(item => item.workstream === 'STORE_SETUP')?.lockVersion, 0), publicStoreName: String(data.get('public_store_name')).trim(), description: String(data.get('description')).trim() || null, publicEmail: String(data.get('public_email')).trim() || null, publicPhone: String(data.get('public_phone')).trim() || null }))
      setMessage({ tone: 'success', text: 'Store Profile saved.' })
    } catch (cause) { setMessage({ tone: 'error', text: await readableOnboardingError(cause) }) }
    finally { setBusy(false) }
  }
  return <form className="grid min-w-0 gap-5" onSubmit={event => void save(event)}><h2 className="text-xl font-semibold">Public store information</h2>{message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}<Field label="Store display name" name="public_store_name" defaultValue={stringValue(profile.publicStoreName, stringValue(org.storeName))} maxLength={180} required /><label className="grid gap-2 font-semibold">Store description<textarea name="description" className="min-h-32 rounded-control border border-border-default bg-surface-primary p-3 font-normal" maxLength={3000} defaultValue={stringValue(profile.description)} /></label><div className="grid gap-5 sm:grid-cols-2"><Field label="Public store email" name="public_email" type="email" defaultValue={stringValue(profile.publicEmail)} /><Field label="Public store phone" name="public_phone" defaultValue={stringValue(profile.publicPhone)} maxLength={24} /></div><Button className="w-fit" disabled={busy} type="submit">{busy ? 'Saving…' : 'Save Store Profile'}</Button></form>
}
function ReviewDetails({ items }: { items: [string, string][] }) {
  return <dl className="my-6 grid gap-5 border-y border-border-default py-5 sm:grid-cols-2">{items.map(([label, value]) => <div key={label} className="min-w-0"><dt className="text-sm text-text-secondary">{label}</dt><dd className="mt-1 break-words font-semibold">{value || 'Not configured'}</dd></div>)}</dl>
}

function StoreProfilePreview({ snapshot, profile }: { snapshot: VendorOnboardingSnapshot; profile: { name: string; description: string } }) {
  const media = arrayValue(record(snapshot.setup).media)
  return <aside className="min-w-0 xl:sticky xl:top-6" aria-labelledby="store-preview-title">
    <h3 id="store-preview-title" className="text-lg font-semibold">Store Profile Preview</h3>
    <p className="mt-2 text-sm leading-6 text-text-secondary">Preview how your Store Profile may appear to Buyers after Store Activation.</p>
    <div className="mt-5 overflow-hidden rounded-surface border border-border-default bg-surface-primary">
      <StoreMediaPreview media={media.filter(item => stringValue(item.kind) === 'BANNER').at(-1)} kind="BANNER" storefront />
      <div className="px-5 pb-6">
        <div className="relative -mt-9 mb-4 w-24 rounded-control border-4 border-surface-primary bg-surface-primary"><StoreMediaPreview media={media.filter(item => stringValue(item.kind) === 'LOGO').at(-1)} kind="LOGO" storefront /></div>
        <h4 className="break-words text-xl font-semibold">{profile.name.trim() || 'Your store name'}</h4>
        <p className="mt-3 whitespace-pre-wrap break-words text-sm leading-6 text-text-secondary">{profile.description.trim() || 'Your store description will appear here.'}</p>
      </div>
    </div>
    <p className="mt-3 text-xs leading-5 text-text-secondary">Only your store name, description and images appear in this preview.</p>
  </aside>
}

function StoreMediaPreview({ media, kind, storefront = false }: { media: JsonRecord | undefined; kind: string; storefront?: boolean }) {
  const fileId = stringValue(media?.fileId)
  const [url, setUrl] = useState<string | null>(null)
  const [failed, setFailed] = useState(false)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setUrl(null); setFailed(false)
    if (fileId) void getVendorPrivateFileUrl(fileId).then(result => { if (active) setUrl(result.url) }).catch(() => { if (active) setFailed(true) })
    return () => { active = false }
  }, [fileId, attempt])
  if (!storefront) {
    if (!fileId) return null
    return <div className="my-3">{url && !failed ? <img src={url} alt={stringValue(media?.altText, `Store ${kind.toLowerCase()}`)} className={kind === 'LOGO' ? 'h-24 w-24 object-contain' : 'max-h-48 w-full object-contain'} onError={() => setFailed(true)} /> : failed ? <Button type="button" variant="secondary" onClick={() => setAttempt(value => value + 1)}>Reload image</Button> : <p role="status">Loading image…</p>}</div>
  }
  const size = kind === 'LOGO' ? 'aspect-square w-full max-w-24' : 'aspect-[3/1] w-full'
  return <div className={`${storefront ? '' : 'my-3'} ${size} flex items-center justify-center overflow-hidden bg-surface-canvas`}>
    {fileId && url && !failed ? <img src={url} alt={stringValue(media?.altText, `Store ${kind.toLowerCase()}`)} className={`h-full w-full ${kind === 'LOGO' ? 'object-contain' : 'object-cover'}`} onError={() => setFailed(true)} /> : <div className="grid justify-items-center gap-2 p-2 text-center text-xs text-text-secondary">{kind === 'LOGO' ? <Store size={24} aria-hidden="true" /> : <ImagePlus size={28} aria-hidden="true" />}{!fileId ? <span>{kind === 'LOGO' ? 'Store logo' : 'Store banner'}</span> : failed ? <button type="button" className="min-h-11 px-2 font-semibold text-action-primary underline" onClick={() => setAttempt(value => value + 1)}>Reload {kind.toLowerCase()}</button> : <span role="status">Loading image…</span>}</div>}
  </div>
}
