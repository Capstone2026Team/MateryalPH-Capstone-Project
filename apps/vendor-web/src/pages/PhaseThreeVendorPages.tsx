import { useParams } from 'react-router-dom'
import { DashboardHeader, SectionWorkspace, PreviewMetrics } from '@materyalph/web-ui'
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
  BadgeCheck,
  CircleDollarSign,
  MailCheck,
  Check,
  CheckCircle2,
  ClipboardCheck,
  Clock3,
  CreditCard,
  FileCheck2,
  FileText,
  ImagePlus,
  LayoutDashboard,
  LockKeyhole,
  MapPin,
  Package,
  RefreshCw,
  Send,
  ShieldCheck,
  Store,
  UploadCloud,
  Users,
} from 'lucide-react'
import { type FormEvent, type ReactNode, useCallback, useEffect, useRef, useState } from 'react'
import { Link, Navigate, useNavigate } from 'react-router-dom'

import {
  AccountWorkspace,
  Button,
  Field,
  PortalShell,
  PortalAccountMenu,
  ProgressBar,
  StatusBadge,
  StatusMessage,
  type PortalNavSection,
} from '@materyalph/web-ui'
import { QRCodeSVG } from 'qrcode.react'
import { ResponseError } from '@materyalph/api-client-ts'
import { signOut } from '../lib/auth-api'
import { vendorLoginDestination } from '../lib/vendor-destination'
import type { VendorOnboardingSection } from '@materyalph/api-client-ts'
import { VendorAddressMapSelector } from '../components/VendorAddressMapSelector'
import {
  activateVendorStore,
  captureVendorPaymentConnection,
  completeVendorSetup,
  confirmStoreEmailVerification,
  dismissVendorWelcome,
  getVendorOnboarding,
  getVendorPrivateFileUrl,
  inviteVendorTeamMember,
  readableOnboardingError,
  requestStoreEmailVerification,
  reverseGeocodeVendorAddress,
  saveVendorSetupDraft,
  saveVendorVerificationDraft,
  submitVendorVerification,
  reconcileVendorPaymentConnection,
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
  if (record(snapshot.activation).status !== 'ACTIVE' || !vendorModules[module]) return <Navigate to="/dashboard" replace />
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

function numberInputValue(value: unknown, fallback = ''): string {
  if (typeof value === 'number' && Number.isFinite(value)) return String(value)
  return typeof value === 'string' ? value : fallback
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
  if (['APPROVED', 'COMPLETED', 'COMPLETE', 'ACTIVE', 'CONNECTED', 'READY'].includes(status)) return 'success'
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

function Checklist({ title, section, compact = false }: { title: string; section: ReturnType<typeof sectionFor>; compact?: boolean }) {
  const steps = section?.steps ?? []
  return <section className={`grid gap-4 ${compact ? '' : 'rounded-surface border border-border-default bg-surface-primary p-5 sm:p-6'}`} aria-labelledby={`${section.key}-checklist`}><div className="flex flex-wrap items-end justify-between gap-3"><div><h2 id={`${section.key}-checklist`} className="text-lg font-semibold">{title}</h2><p className="mt-1 text-sm text-text-secondary">{section.complete} of {section.total} required items complete.</p></div><StatusBadge label={statusLabel(section.status)} tone={statusTone(section.status)} /></div><ProgressBar value={section.total > 0 ? (section.complete / section.total) * 100 : 0} label={`${section.complete} of ${section.total} complete`} /><div className="divide-y divide-border-default border-y border-border-default">{steps.map((step) => <div className="flex flex-wrap items-center justify-between gap-3 py-3" key={step.key}><div className="flex min-w-0 items-start gap-3"><StepIcon status={step.status} /><div className="min-w-0"><p className="font-semibold">{step.label}</p>{step.reason && <p className="mt-1 text-sm text-text-secondary">{step.reason}</p>}</div></div><div className="flex items-center gap-2"><span className="text-xs font-semibold uppercase tracking-wide text-text-secondary">{step.level === 'OPTIONAL' ? 'Optional' : step.level === 'CONDITIONALLY_REQUIRED' ? 'Conditional' : 'Required'}</span><StatusBadge label={statusLabel(step.status)} tone={statusTone(step.status)} /></div></div>)}</div></section>
}

function StepIcon({ status }: { status: string }) {
  if (['APPROVED', 'COMPLETED', 'NOT_APPLICABLE'].includes(status)) return <CheckCircle2 className="mt-0.5 shrink-0 text-status-success" size={20} aria-hidden="true" />
  if (['CHANGES_REQUIRED', 'REJECTED', 'EXPIRED'].includes(status)) return <AlertCircle className="mt-0.5 shrink-0 text-status-error" size={20} aria-hidden="true" />
  if (['PENDING_VERIFICATION', 'SUBMITTED'].includes(status)) return <Clock3 className="mt-0.5 shrink-0 text-status-warning" size={20} aria-hidden="true" />
  return <div className="mt-1 h-4 w-4 shrink-0 rounded-full border-2 border-border-default" aria-hidden="true" />
}

export function VendorShell({ activeHref, accountLabel, accountStatus, children, navigationData, refreshError }: { refreshError?: string | null; navigationData?: VendorOnboardingSnapshot | null; activeHref: string; accountLabel: string; accountStatus?: string; children: ReactNode }) {
  const navigate = useNavigate()
  const { snapshot: shellSnapshot } = useOnboardingSnapshot(navigationData === undefined)
  const navigationSnapshot = navigationData === undefined ? shellSnapshot : navigationData
  const navigation = vendorNavigation.map(section => ({
    ...section, items: section.items.filter(item => item.href !== '/store-profile' || navigationSnapshot?.permissions.includes('vendor.onboarding.submit')).map(item => ({
      ...item, disabled: item.disabled || (item.href === '/store-profile' && record(navigationSnapshot?.activation).status !== 'ACTIVE') || (item.href.startsWith('/preview/') && record(navigationSnapshot?.activation).status !== 'ACTIVE') || (item.href === '/team' && (navigationSnapshot?.setup.status !== 'COMPLETED' || !navigationSnapshot.permissions.includes('staff.manage'))) || (item.href.startsWith('/onboarding') && !navigationSnapshot?.permissions.includes('vendor.onboarding.manage')),
    })),
  }))
  const [logoutError, setLogoutError] = useState<string | null>(null)
  const [signingOut, setSigningOut] = useState(false)
  async function logout() {
    setSigningOut(true); setLogoutError(null)
    try { await signOut(); navigate('/login', { replace: true }) }
    catch (cause) { setLogoutError(await readableOnboardingError(cause)) }
    finally { setSigningOut(false) }
  }
  if (activeHref === '/welcome' || activeHref.startsWith('/onboarding')) return <div className="min-h-screen bg-surface-canvas text-text-strong"><header className="flex flex-wrap items-center justify-between gap-3 border-b border-border-default bg-surface-primary px-6 py-4"><Link to="/dashboard" className="text-xl font-bold">Materyal<span className="text-action-primary">PH</span></Link><p className="text-xs text-text-secondary" aria-label="System date">{portalDate()}</p><PortalAccountMenu portal="vendors" basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} onNavigate={navigate} onSignOut={logout} /></header><main className="mx-auto max-w-7xl p-5 sm:p-8">{refreshError && <StatusMessage tone="error">{refreshError}</StatusMessage>}{children}</main></div>
  return <PortalShell apiBasePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} onSignOut={logout} onNavigate={navigate} portalLabel="VENDOR PORTAL" pageTitle={activeHref === '/settings' ? 'Settings' : activeHref === '/store-profile' ? 'Store Profile' : activeHref.includes('onboarding') ? 'Vendor Onboarding' : vendorNavigation.flatMap(section => section.items).find(item => item.href === activeHref)?.label ?? 'Dashboard'} dateLabel={portalDate()} sections={navigation} activeHref={activeHref} accountLabel={accountLabel} accountStatus={accountStatus ?? 'Vendor account'} headerActions={<><Link className="inline-flex min-h-11 items-center px-3 text-sm font-semibold" to="/settings">Account</Link><Button variant="secondary" disabled={signingOut} onClick={() => void logout()}>{signingOut ? 'Signing out…' : 'Sign out'}</Button></>}>{logoutError && <StatusMessage tone="error">{logoutError}</StatusMessage>}{refreshError && navigationSnapshot && <StatusMessage tone="error">{refreshError}</StatusMessage>}{children}</PortalShell>
}

function useOnboardingSnapshot(enabled = true) {
  const navigate = useNavigate()
  const [snapshot, setSnapshot] = useState<VendorOnboardingSnapshot | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)

  const refresh = useCallback(async () => {
    setLoading(true)
    setError(null)
    try {
      setSnapshot(await getVendorOnboarding())
    } catch (cause) {
      if (cause instanceof ResponseError && cause.response.status === 401) navigate('/login', { replace: true })
      else setError(await readableOnboardingError(cause))
    } finally {
      setLoading(false)
    }
  }, [navigate])

  useEffect(() => { if (enabled) void refresh() }, [refresh, enabled])
  return { snapshot, loading, error, refresh, setSnapshot }
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
  const navigate = useNavigate()
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
  const blockers = arrayValue(readiness.blockers)
  const verificationSection = sectionFor(snapshot, 'STORE_VERIFICATION')
  const setupSection = sectionFor(snapshot, 'STORE_SETUP')
  const accountLabel = stringValue(org.storeName, stringValue(org.legalName, 'Vendor Owner'))
  if (activation.status === 'ACTIVE') return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/dashboard" accountLabel={accountLabel} accountStatus="Store Active"><div className="space-y-6"><DashboardHeader eyebrow={accountLabel} title="Dashboard" description="Your store is active. Operational metrics below are design previews, not live results." status={<StatusBadge label="Active" tone="success" />} /><SectionWorkspace dateFilter sections={[
    { label: 'Overview', content: <PreviewMetrics labels={['Response time', 'Pending fulfillment', 'Sales & revenue', 'Store visitors', 'Quality summary', 'Important tasks']} /> },
    { label: 'Performance', content: <PreviewMetrics labels={['Response rate / time', 'Order processing time', 'Cancellation rate', 'Return rate']} /> },
    { label: 'Action Items & Alerts', content: <PreviewMetrics labels={['Pending fulfillment', 'To-do checklist', 'System notifications']} /> },
    { label: 'Sales & Revenue', content: <PreviewMetrics labels={['Earnings', 'Sales', 'Average order value', 'Revenue trend']} /> },
    { label: 'Traffic & Volume', content: <PreviewMetrics labels={['Store visitors', 'Listing views', 'Engagement', 'Traffic trend']} /> },
    { label: 'Disputes & Quality', content: <PreviewMetrics labels={['Open disputes', 'Refund-related cases', 'Returns', 'Complaints', 'Product issues', 'Fulfillment issues']} /> },
  ]} /><p className="text-sm text-text-secondary">Marketplace discoverability: {statusLabel(stringValue(activation.marketplaceDiscoverabilityStatus, 'NO_ACTIVE_LISTINGS'))}. Eligible published listings remain required.</p></div></VendorShell>

  return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/dashboard" accountLabel={accountLabel} accountStatus={`${statusLabel(stringValue(activation.status, 'NOT_READY'))} activation`}><div className="phase3-page space-y-6"><DashboardHeader eyebrow={activation.status === 'ACTIVE' ? 'Vendor Dashboard' : 'Limited-Access Vendor Dashboard'} title={`Welcome back, ${accountLabel}.`} description={activation.status === 'ACTIVE' ? 'Your store is active. Marketplace discoverability requires eligible published listings.' : 'Store not yet active for marketplace participation. Complete all required onboarding requirements to activate your store. You may continue Store Setup while Admin review is pending.'} status={<StatusBadge label={statusLabel(stringValue(activation.status, 'NOT_READY'))} tone="warning" />} actions={<><Button variant="secondary" onClick={() => navigate('/onboarding/verification')}>Continue verification <ArrowRight size={16} aria-hidden="true" /></Button><Button onClick={() => navigate('/onboarding/setup')}>Continue setup <ArrowRight size={16} aria-hidden="true" /></Button></>} />{actionMessage && <StatusMessage tone={actionMessage.includes('recorded') ? 'success' : 'error'}>{actionMessage}</StatusMessage>}<section aria-label="Overall onboarding progress"><h2 className="mb-3 text-lg font-semibold">Overall onboarding progress</h2><ProgressBar value={(verificationSection.total + setupSection.total) > 0 ? ((verificationSection.complete + setupSection.complete) / (verificationSection.total + setupSection.total)) * 100 : 0} label={`${verificationSection.complete + setupSection.complete} of ${verificationSection.total + setupSection.total} required items complete`} /></section><div className="grid gap-5 lg:grid-cols-2"><div className="space-y-3"><Checklist title="Store Verification" section={verificationSection} /><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary" to="/onboarding/verification">Continue Store Verification / Review requirements</Link></div><div className="space-y-3"><Checklist title="Store Setup" section={setupSection} /><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary" to="/onboarding/setup">Continue Store Setup</Link></div></div><section className="grid gap-6 border-y border-border-default py-6 lg:grid-cols-[1fr_1.2fr] lg:items-start"><div><p className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">Activation gate</p><h2 className="mt-2 text-2xl font-semibold">{booleanValue(readiness.ready) ? 'Your store is ready for activation.' : 'Activation still needs attention.'}</h2><p className="mt-3 max-w-xl text-sm leading-6 text-text-secondary">Activation requires approved Store Verification, completed Store Setup, the connected Xendit TEST account, current commission terms, and no active restriction.</p>{booleanValue(readiness.ready) && <Button className="mt-5" disabled={busy || stringValue(activation.status) === 'ACTIVE'} onClick={() => void activate()}>{busy ? 'Recording…' : stringValue(activation.status) === 'ACTIVE' ? 'Store Active' : 'Request Store Activation'} <ArrowRight size={16} aria-hidden="true" /></Button>}</div><div className="grid gap-3">{blockers.length === 0 ? <div className="flex items-start gap-3 border border-status-success/30 bg-green-50 p-4 text-sm text-green-900"><CheckCircle2 className="mt-0.5 shrink-0" size={20} aria-hidden="true" /><p>No activation blockers are currently reported.</p></div> : blockers.map((blocker) => <div className="flex items-start gap-3 border border-border-default bg-surface-primary p-4" key={`${stringValue(blocker.key)}-${stringValue(blocker.reason)}`}><AlertCircle className="mt-0.5 shrink-0 text-status-warning" size={20} aria-hidden="true" /><div><p className="font-semibold">{stringValue(blocker.key, 'Requirement')}</p><p className="mt-1 text-sm leading-6 text-text-secondary">{stringValue(blocker.reason)}</p></div></div>)}</div></section></div></VendorShell>
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

  return <VendorShell refreshError={error} navigationData={snapshot} activeHref={activeHref} accountLabel={accountLabel} accountStatus="Onboarding in progress"><div className="phase3-page space-y-8"><PageHeader eyebrow="Store onboarding" title={activeSection === 'STORE_SETUP' ? 'Store Setup' : 'Store Verification'} description={activeSection === 'STORE_SETUP' ? 'Configure the public store experience, fulfillment choices, and TEST payment connection. These settings are separate from Admin business verification.' : 'Tell us who your business is and submit the private evidence that an Admin must review before activation.'} status={activeSection === 'STORE_SETUP' ? stringValue(record(snapshot.setup).status, 'NOT_STARTED') : stringValue(record(snapshot.verification).status, 'NOT_STARTED')} actions={<Link className="inline-flex min-h-11 items-center gap-2 font-semibold text-action-primary underline-offset-4 hover:underline" to="/dashboard">Back to dashboard <ArrowRight size={16} aria-hidden="true" /></Link>} /><div className="grid gap-2 border-b border-border-default sm:grid-cols-2"><SectionTab active={activeSection === 'STORE_VERIFICATION'} href="/onboarding/verification" label="1. Store Verification" description={`${verificationSection.complete}/${verificationSection.total} required complete`} /><SectionTab active={activeSection === 'STORE_SETUP'} href="/onboarding/setup" label="2. Store Setup" description={`${setupSection.complete}/${setupSection.total} required complete`} /></div>{activeSection === 'STORE_VERIFICATION' ? <VerificationWorkspace snapshot={snapshot} onSaved={setSnapshot} onRefresh={refresh} /> : <SetupWorkspace snapshot={snapshot} onSaved={setSnapshot} onRefresh={refresh} />}</div></VendorShell>
}

function SectionTab({ active, href, label, description }: { active: boolean; href: string; label: string; description: string }) {
  return <Link className={`grid gap-1 border-b-2 px-2 py-4 no-underline transition-colors ${active ? 'border-action-primary text-text-strong' : 'border-transparent text-text-secondary hover:border-brand-orange-300 hover:text-text-strong'}`} aria-current={active ? 'page' : undefined} to={href}><span className="font-semibold">{label}</span><span className="text-sm">{description}</span></Link>
}

function VerificationWorkspace({ snapshot, onSaved, onRefresh }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; onRefresh: () => Promise<void> }) {
  return <div className="grid gap-8 xl:grid-cols-[minmax(0,1.35fr)_minmax(20rem,.65fr)]"><div className="grid gap-8"><VerificationForm snapshot={snapshot} onSaved={onSaved} /><DocumentChecklist snapshot={snapshot} onRefresh={onRefresh} /><VerificationSubmit snapshot={snapshot} onSaved={onSaved} /></div><div className="grid content-start gap-5"><Checklist title="Verification checklist" section={sectionFor(snapshot, 'STORE_VERIFICATION')} compact /><InformationRail title="Review boundary" icon={<ShieldCheck size={20} aria-hidden="true" />} text="Admins review only the evidence and fields submitted for this organization. A correction creates a new evidence version; previous reviews remain immutable." /><InformationRail title="Private evidence" icon={<LockKeyhole size={20} aria-hidden="true" />} text="Upload only the document needed for the named requirement. Files remain private and are delivered through short-lived authorized URLs." /></div></div>
}

function InformationRail({ title, text, icon }: { title: string; text: string; icon: ReactNode }) {
  return <section className="border-t border-border-default pt-4"><div className="flex items-center gap-2 text-action-primary">{icon}<h2 className="font-semibold text-text-strong">{title}</h2></div><p className="mt-2 text-sm leading-6 text-text-secondary">{text}</p></section>
}

function VerificationForm({ snapshot, onSaved }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void }) {
  const org = record(snapshot.organization)
  const verification = record(snapshot.verification)
  const classification = record(verification.classification)
  const address = record(verification.address)
  const tax = record(verification.taxProfile)
  const details = record(tax.details)
  const contacts = arrayValue(verification.contacts)
  const primaryContact = contacts[0] ?? {}
  const legalIdentity = record(verification.legalIdentity)
  const selectedBusinessType = stringValue(org.businessType)
  const companyIdentityRequired = ['PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'].includes(selectedBusinessType)
  const individualIdentityRequired = ['SOLE_PROPRIETORSHIP', 'ONE_PERSON_CORPORATION'].includes(selectedBusinessType)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [mapMessage, setMapMessage] = useState<string | null>(null)
  const navigate = useNavigate()
  const formRef = useRef<HTMLFormElement>(null)

  async function save(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setMessage(null)
    const continueLater = (event.nativeEvent as SubmitEvent).submitter?.getAttribute('data-continue-later') === 'true'
    const data = new FormData(event.currentTarget)
    const draft: import('@materyalph/api-client-ts').VendorVerificationDraft = { lockVersion: numberValue(org.lockVersion, 1) }
    const businessType = stringValue(data.get('business_type'))
    const registeredName = stringValue(data.get('registered_name')).trim()
    const storeName = stringValue(data.get('store_name')).trim()
    const established = stringValue(data.get('date_established'))
    const storePhone = stringValue(data.get('store_phone')).trim()
    const candidateEmail = stringValue(data.get('store_email')).trim().toLowerCase()
    const companyIdentityRequired = ['PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE'].includes(businessType)
    const individualIdentityRequired = ['SOLE_PROPRIETORSHIP', 'ONE_PERSON_CORPORATION'].includes(businessType)
    if (businessType) draft.businessType = businessType as NonNullable<import('@materyalph/api-client-ts').VendorVerificationDraft['businessType']>
    if (registeredName) draft.registeredName = registeredName
    if (storeName) draft.storeName = storeName
    if (established) draft.dateEstablished = new Date(`${established}T00:00:00Z`)
    if (candidateEmail) draft.storeEmail = candidateEmail
    if (storePhone) draft.storePhone = storePhone
    const fullName = stringValue(data.get('contact_name')).trim()
    if (fullName) draft.contacts = [{ full_name: fullName, title: stringValue(data.get('contact_title')).trim() || null, email: stringValue(data.get('contact_email')).trim().toLowerCase() || null, phone: stringValue(data.get('contact_phone')).trim() || null, is_primary: true, is_public: data.get('contact_public') === 'on', is_authorized: true }]
    if (companyIdentityRequired || individualIdentityRequired) draft.legalIdentity = { sameAsOwner: data.get('same_as_owner') === 'on', surname: stringValue(data.get('individual_surname')).trim() || null, firstName: stringValue(data.get('individual_first_name')).trim() || null, middleName: stringValue(data.get('individual_middle_name')).trim() || null, suffix: stringValue(data.get('individual_suffix')).trim() || null, companyRegisteredName: stringValue(data.get('company_registered_name')).trim() || null, idType: stringValue(data.get('identity_id_type')).trim() || null, ...(stringValue(data.get('identity_id_number')).trim() ? { idNumber: stringValue(data.get('identity_id_number')).trim() } : {}) }
    const supplierType = stringValue(data.get('supplier_type'))
    if (supplierType) draft.classification = { supplier_type: supplierType, niches: stringValue(data.get('niches')).split(',').map((item) => item.trim()).filter(Boolean), custom_label: stringValue(data.get('custom_label')).trim() || null }
    const street = stringValue(data.get('street')).trim()
    if (street) draft.address = { street, unit: stringValue(data.get('unit')).trim() || null, barangay: stringValue(data.get('barangay')).trim(), city_municipality: stringValue(data.get('city_municipality')).trim(), province: stringValue(data.get('province')).trim(), postal_code: stringValue(data.get('postal_code')).trim(), formatted_address: stringValue(data.get('formatted_address')).trim() || null, latitude: Number(data.get('latitude')), longitude: Number(data.get('longitude')), source: stringValue(data.get('address_source')) || 'MANUAL', provider: stringValue(data.get('provider')).trim() || null, provider_place_id: stringValue(data.get('provider_place_id')).trim() || null }
    const taxpayerKey = stringValue(data.get('taxpayer_key')).trim()
    const tin = stringValue(data.get('tin')).trim()
    const taxReliefClaimed = data.get('tax_relief_claimed') === 'on'
    const ownerAttested = data.get('owner_attested') === 'on'
    const taxFieldsPresent = taxpayerKey || tin || stringValue(data.get('branch_code')).trim() || stringValue(data.get('bir_cor_reference')).trim() || stringValue(data.get('declaration_type')).trim() || stringValue(data.get('threshold_position')).trim() || stringValue(data.get('submission_date')) || stringValue(data.get('outside_platform_as_of')) || taxReliefClaimed || ownerAttested || numberValue(tax.version, 0) > 0
    if (taxFieldsPresent) {
      const branchCode = stringValue(data.get('branch_code')).trim()
      const birCorReference = stringValue(data.get('bir_cor_reference')).trim()
      const entityClass = stringValue(data.get('entity_class'))
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
        ...(branchCode ? { branchCode } : {}),
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
        taxReliefClaimed,
        ownerAttested,
      }
    }
    try { onSaved(await saveVendorVerificationDraft(draft)); if (continueLater) navigate('/dashboard'); setMessage({ tone: 'success', text: 'Verification draft saved. You can continue from this point later.' }) } catch (cause) { setMessage({ tone: 'error', text: await readableOnboardingError(cause) }) } finally { setBusy(false) }
  }

  async function geocode() {
    const form = formRef.current
    if (!form) return
    const data = new FormData(form)
    const latitude = Number(data.get('latitude'))
    const longitude = Number(data.get('longitude'))
    await resolveAddress(latitude, longitude)
  }

  async function resolveAddress(latitude: number, longitude: number) {
    const form = formRef.current
    if (!form) return
    if (!Number.isFinite(latitude) || !Number.isFinite(longitude)) { setMapMessage('Enter latitude and longitude first, or complete the structured address manually.'); return }
    setMapMessage('Looking up the address…')
    try {
      const result = record(await reverseGeocodeVendorAddress({ latitude, longitude }))
      const returnedAddress = record(result.address)
      if (booleanValue(result.available)) {
        const resolvedFields: Record<string, string> = { street: stringValue(returnedAddress.street), unit: stringValue(returnedAddress.unit), barangay: stringValue(returnedAddress.barangay), city_municipality: stringValue(returnedAddress.cityMunicipality, stringValue(returnedAddress.city_municipality)), province: stringValue(returnedAddress.province), postal_code: stringValue(returnedAddress.postalCode, stringValue(returnedAddress.postal_code)), formatted_address: stringValue(returnedAddress.formattedAddress, stringValue(returnedAddress.formatted_address)), provider: stringValue(returnedAddress.provider), provider_place_id: stringValue(returnedAddress.providerPlaceId, stringValue(returnedAddress.provider_place_id)) }
        Object.entries(resolvedFields).forEach(([name, value]) => { const field = form.elements.namedItem(name); if (field instanceof HTMLInputElement && value) field.value = value }); const sourceField = form.elements.namedItem('address_source'); if (sourceField instanceof HTMLInputElement) sourceField.value = 'MAP'
        setMapMessage(`Map result available: ${stringValue(returnedAddress.formattedAddress, stringValue(returnedAddress.formatted_address, 'Review the returned address and save the structured fields.'))}`)
      }
      else setMapMessage(stringValue(result.message, 'Map lookup is unavailable. Complete the structured address manually.'))
    } catch (cause) {
      setMapMessage(await readableOnboardingError(cause))
    }
  }

  function selectMapCoordinates({ latitude, longitude }: { latitude: number; longitude: number }) {
    const form = formRef.current
    if (!form) return
    const latitudeField = form.elements.namedItem('latitude')
    const longitudeField = form.elements.namedItem('longitude')
    if (latitudeField instanceof HTMLInputElement) latitudeField.value = latitude.toFixed(6)
    if (longitudeField instanceof HTMLInputElement) longitudeField.value = longitude.toFixed(6)
    void resolveAddress(latitude, longitude)
  }

  return <section className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7" aria-labelledby="verification-form-title"><div className="flex flex-wrap items-start justify-between gap-4"><div><p className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">Step 1 of 2</p><h2 id="verification-form-title" className="mt-2 text-2xl font-semibold">Business identity and compliance</h2><p className="mt-2 max-w-2xl text-sm leading-6 text-text-secondary">Save a draft after each section. Store email verification is a separate action so an unverified or expired attempt never replaces an existing verified address.</p></div><StatusBadge label={statusLabel(stringValue(verification.status, 'NOT_STARTED'))} tone={statusTone(stringValue(verification.status, 'NOT_STARTED'))} /></div>{message && <div className="mt-5"><StatusMessage tone={message.tone}>{message.text}</StatusMessage></div>}<form noValidate ref={formRef} className="mt-7 grid gap-8" onSubmit={(event) => void save(event)}><FormSection title="Business information" description="Use the legal name and establishment date shown on your business evidence."><div className="grid gap-5 sm:grid-cols-2"><SelectField label="Business type" name="business_type" defaultValue={stringValue(org.businessType)} options={['SOLE_PROPRIETORSHIP', 'PARTNERSHIP', 'CORPORATION', 'ONE_PERSON_CORPORATION', 'COOPERATIVE']} /><Field label="Registered business name" name="registered_name" defaultValue={stringValue(org.registeredName, stringValue(org.legalName))} required /><Field label="Store name" name="store_name" defaultValue={stringValue(org.storeName)} required /><Field label="Date established" name="date_established" type="date" defaultValue={dateInput(org.dateEstablished)} required /><Field label="Store phone" name="store_phone" defaultValue={stringValue(org.storePhone)} inputMode="tel" /><Field label="Store email" name="store_email" type="email" defaultValue={stringValue(org.pendingStoreEmail, stringValue(org.storeEmail))} required /></div><EmailVerificationPanel snapshot={snapshot} initialEmail={stringValue(org.pendingStoreEmail, stringValue(org.storeEmail))} onSaved={onSaved} /></FormSection>{(companyIdentityRequired || individualIdentityRequired) && <FormSection title="Legal identity" description="Use the exact legal identity and government record. Identity evidence remains private and is available only to authorized Admin reviewers."><div className="grid gap-5 sm:grid-cols-2">{companyIdentityRequired && <Field className="sm:col-span-2" label="Company registered name" name="company_registered_name" defaultValue={stringValue(legalIdentity.companyRegisteredName, stringValue(org.registeredName))} required />}{individualIdentityRequired && <><label className="flex min-h-11 items-center gap-3 text-sm text-text-secondary sm:col-span-2"><input className="h-5 w-5 accent-action-primary" type="checkbox" name="same_as_owner" defaultChecked={booleanValue(legalIdentity.sameAsOwner)} /> Same as Vendor Owner’s full legal name</label><Field label="Surname" name="individual_surname" defaultValue={stringValue(legalIdentity.surname)} required /><Field label="First name" name="individual_first_name" defaultValue={stringValue(legalIdentity.firstName)} required /><Field label="Middle name" name="individual_middle_name" defaultValue={stringValue(legalIdentity.middleName)} /><Field label="Suffix" name="individual_suffix" defaultValue={stringValue(legalIdentity.suffix)} /><SelectField label="Government ID type" name="identity_id_type" defaultValue={stringValue(legalIdentity.idType)} options={['NATIONAL_ID', 'DRIVERS_LICENSE', 'PASSPORT', 'UMID', 'OTHER']} /><Field label="Government ID number" name="identity_id_number" type="password" autoComplete="off" hint={stringValue(legalIdentity.idNumberLast4) ? `Current ID ends in ${stringValue(legalIdentity.idNumberLast4)}. Re-enter only to replace it.` : 'Stored privately; only the last four digits are shown after saving.'} required /></>}</div></FormSection>}<FormSection title="Primary Vendor contact" description="Exactly one active primary contact is required for review. Staff roles cannot replace the Vendor Owner’s attestation."><div className="grid gap-5 sm:grid-cols-2"><Field label="Full name" name="contact_name" defaultValue={stringValue(primaryContact.fullName)} required /><Field label="Title" name="contact_title" defaultValue={stringValue(primaryContact.title)} /><Field label="Contact email" name="contact_email" type="email" defaultValue={stringValue(primaryContact.email)} /><Field label="Contact phone" name="contact_phone" defaultValue={stringValue(primaryContact.phone)} inputMode="tel" /></div><label className="flex min-h-11 items-center gap-3 text-sm text-text-secondary"><input className="h-5 w-5 accent-action-primary" type="checkbox" name="contact_public" defaultChecked={booleanValue(primaryContact.isPublic)} /> Show this contact in the approved public store profile</label></FormSection><FormSection title="Supplier classification" description="Choose the closest approved supplier type and list the material niches you serve."><div className="grid gap-5 sm:grid-cols-2"><SelectField label="Supplier type" name="supplier_type" defaultValue={stringValue(classification.supplierType)} options={['WHOLESALER_DISTRIBUTOR', 'RETAIL_HARDWARE_STORE', 'SPECIALIZED_SUPPLIER', 'OTHER']} /><Field label="Custom classification label" name="custom_label" defaultValue={stringValue(classification.customLabel)} /><Field className="sm:col-span-2" label="Material niches" name="niches" defaultValue={(Array.isArray(classification.niches) ? classification.niches.filter((item): item is string => typeof item === 'string') : []).join(', ')} hint="Separate niches with commas." /></div></FormSection><FormSection title="Registered business address" description="Use the interactive map when configured, or complete the labeled address fields manually. Review the result before saving for Admin review."><div className="grid gap-5 sm:grid-cols-2"><Field className="sm:col-span-2" label="Street" name="street" defaultValue={stringValue(address.street)} required /><Field label="Unit or building" name="unit" defaultValue={stringValue(address.unit)} /><Field label="Barangay" name="barangay" defaultValue={stringValue(address.barangay)} required /><Field label="City or municipality" name="city_municipality" defaultValue={stringValue(address.cityMunicipality)} required /><Field label="Province" name="province" defaultValue={stringValue(address.province)} required /><Field label="Postal code" name="postal_code" defaultValue={stringValue(address.postalCode)} required /><Field label="Latitude" name="latitude" type="number" step="any" defaultValue={stringValue(address.latitude)} required /><Field label="Longitude" name="longitude" type="number" step="any" defaultValue={stringValue(address.longitude)} required /></div><input type="hidden" name="formatted_address" defaultValue={stringValue(address.formattedAddress)} /><input type="hidden" name="address_source" defaultValue={stringValue(address.source, 'MANUAL')} /><input type="hidden" name="provider" defaultValue={stringValue(address.provider)} /><input type="hidden" name="provider_place_id" defaultValue={stringValue(address.providerPlaceId, stringValue(address.provider_place_id))} /><div className="mt-5 flex flex-wrap items-center gap-3"><Button type="button" variant="secondary" onClick={() => void geocode()}><MapPin size={16} aria-hidden="true" /> Use map lookup</Button><span className="text-sm text-text-secondary">Coordinates do not imply live GPS tracking.</span></div><VendorAddressMapSelector latitude={numberValue(address.latitude, Number.NaN)} longitude={numberValue(address.longitude, Number.NaN)} onCoordinatesChange={selectMapCoordinates} />{mapMessage && <p className="mt-3 text-sm text-text-secondary" role="status">{mapMessage}</p>}</FormSection><FormSection title="Tax profile" description="TEST-only taxpayer data is protected. The API protects full values and returns only masked metadata; the full taxpayer key and TIN are not returned to the browser."><div className="grid gap-5 sm:grid-cols-2"><Field label="TEST taxpayer key" name="taxpayer_key" type="password" autoComplete="off" hint={stringValue(tax.taxpayerKeyLast4) ? `Current key ends in ${stringValue(tax.taxpayerKeyLast4)}. Re-enter only to replace it.` : 'Use the synthetic TEST key supplied for your environment.'} /><Field label="TIN" name="tin" type="password" autoComplete="off" hint={stringValue(tax.tinLast4) ? `Current TIN ends in ${stringValue(tax.tinLast4)}.` : 'Only the last four digits are displayed.'} /><Field label="TIN branch code" name="branch_code" defaultValue={stringValue(tax.tinBranchCode)} hint="Enter it exactly as shown on the BIR registration record." /><Field label="BIR COR reference" name="bir_cor_reference" defaultValue={stringValue(tax.birCorReference)} /><SelectField label="Entity class" name="entity_class" defaultValue={stringValue(tax.entityClass, 'INDIVIDUAL')} options={['INDIVIDUAL', 'CORPORATION', 'PARTNERSHIP', 'COOPERATIVE']} /><Field label="Registration category" name="registration_category" defaultValue={stringValue(tax.registrationCategory)} /><SelectField label="VAT category declared" name="vat_category" defaultValue={stringValue(tax.vatCategory, 'NON_VAT')} options={['VAT', 'NON_VAT', 'VAT_ZERO', 'VAT_EXEMPT']} /><SelectField label="TEST withholding scenario" name="withholding_scenario" defaultValue={stringValue(details.withholdingScenario, stringValue(details.withholding_scenario, 'DEMO_PLATFORM_WITHHOLDER'))} options={['DEMO_PLATFORM_WITHHOLDER', 'DEMO_PROVIDER_WITHHOLDER']} /><Field label="Fiscal year start month" name="fiscal_year_start_month" type="number" min="1" max="12" defaultValue={String(numberValue(tax.fiscalYearStartMonth, 1))} /><Field label="Declaration type" name="declaration_type" defaultValue={stringValue(details.declarationType)} /><Field label="Threshold position" name="threshold_position" defaultValue={stringValue(details.thresholdPosition)} /><Field label="Declaration submission date" name="submission_date" type="date" defaultValue={dateInput(details.submissionDate)} /><Field label="Outside-platform position as of" name="outside_platform_as_of" type="date" defaultValue={dateInput(details.outsidePlatformAsOf)} /></div><div className="mt-5 grid gap-4 border-t border-border-default pt-5"><label className="flex min-h-11 items-start gap-3 text-sm leading-6 text-text-secondary"><input className="mt-1 h-5 w-5 accent-action-primary" type="checkbox" name="tax_relief_claimed" defaultChecked={booleanValue(details.taxReliefClaimed)} /> The Vendor is claiming a tax relief treatment and will upload supporting evidence.</label><label className="flex min-h-11 items-start gap-3 text-sm leading-6 text-text-secondary"><input className="mt-1 h-5 w-5 accent-action-primary" type="checkbox" name="owner_attested" defaultChecked={booleanValue(tax.ownerAttested)} /> I am the Vendor Owner and attest that this TEST tax profile is accurate.</label></div></FormSection><div className="flex flex-wrap items-center justify-between gap-3 border-t border-border-default pt-6"><p className="max-w-xl text-sm leading-6 text-text-secondary">Draft saves are version-checked. If another session edits this case, reload before trying again.</p><Button type="submit" variant="secondary" formNoValidate data-continue-later="true" disabled={busy}>Finish Later</Button><Button type="submit" disabled={busy}>{busy ? 'Saving draft…' : 'Save verification draft'} <Check size={16} aria-hidden="true" /></Button></div></form></section>
}

function FormSection({ title, description, children }: { title: string; description: string; children: ReactNode }) {
  return <fieldset className="grid gap-5 border-t border-border-default pt-6"><legend className="text-lg font-semibold">{title}</legend><p className="-mt-2 max-w-2xl text-sm leading-6 text-text-secondary">{description}</p>{children}</fieldset>
}

function SelectField({ label, name, defaultValue, options }: { label: string; name: string; defaultValue: string; options: string[] }) {
  return <div className="grid gap-2 text-sm font-semibold"><label htmlFor={name}>{label}</label><select className="min-h-12 w-full rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal text-text-strong" id={name} name={name} defaultValue={defaultValue}><option value="">Select an option</option>{options.map((option) => <option key={option} value={option}>{statusLabel(option)}</option>)}</select></div>
}

function EmailVerificationPanel({ snapshot, initialEmail, onSaved }: { snapshot: VendorOnboardingSnapshot; initialEmail: string; onSaved: (snapshot: VendorOnboardingSnapshot) => void }) {
  const [email, setEmail] = useState(initialEmail)
  const [code, setCode] = useState('')
  const [sent, setSent] = useState(false)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const org = record(snapshot.organization)
  const verified = booleanValue(org.storeEmailVerified)

  async function send() {
    if (!email.trim()) { setMessage('Enter the store email before requesting a code.'); return }
    setBusy(true); setMessage(null)
    try { const result = record(await requestStoreEmailVerification(email.trim())); setSent(true); setMessage(`Verification code sent. It expires at ${stringValue(result.expiresAt, 'the displayed expiry time')}.`) } catch (cause) { setMessage(await readableOnboardingError(cause)) } finally { setBusy(false) }
  }

  async function confirm() {
    if (!/^\d{6}$/.test(code)) { setMessage('Enter the six-digit code from the email.'); return }
    setBusy(true); setMessage(null)
    try { onSaved(await confirmStoreEmailVerification({ email: email.trim(), code })); setSent(false); setCode(''); setMessage('Store email verified.') } catch (cause) { setMessage(await readableOnboardingError(cause)) } finally { setBusy(false) }
  }

  return <div className="mt-6 grid gap-4 border-t border-border-default pt-5"><div className="flex flex-wrap items-center gap-3"><MailCheck size={18} className="text-action-primary" aria-hidden="true" /><p className="font-semibold">Store email verification</p>{verified && <StatusBadge label="Verified" tone="success" />}{booleanValue(org.storeEmailPending) && !verified && <StatusBadge label="Code pending" tone="warning" />}</div><div className="flex flex-col gap-3 sm:flex-row sm:items-end"><div className="min-w-0 flex-1"><label className="grid gap-2 text-sm font-semibold" htmlFor="verification_email">Email to verify<input className="min-h-12 w-full rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal" id="verification_email" type="email" value={email} onChange={(event) => setEmail(event.target.value)} /></label></div><Button type="button" variant="secondary" disabled={busy} onClick={() => void send()}>{busy ? 'Sending…' : 'Send code'}</Button></div>{sent && <div className="flex flex-col gap-3 sm:flex-row sm:items-end"><div className="min-w-0 flex-1"><label className="grid gap-2 text-sm font-semibold" htmlFor="verification_code">Six-digit code<input className="min-h-12 w-full rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal tracking-[0.18em]" id="verification_code" inputMode="numeric" autoComplete="one-time-code" maxLength={6} value={code} onChange={(event) => setCode(event.target.value.replace(/\D/g, '').slice(0, 6))} /></label></div><Button type="button" disabled={busy} onClick={() => void confirm()}>{busy ? 'Checking…' : 'Confirm email'} <CheckCircle2 size={16} aria-hidden="true" /></Button></div>}{message && <p className="text-sm leading-6 text-text-secondary" role="status">{message}</p>}</div>
}

function DocumentChecklist({ snapshot, onRefresh }: { snapshot: VendorOnboardingSnapshot; onRefresh: () => Promise<void> }) {
  const section = sectionFor(snapshot, 'STORE_VERIFICATION')
  const documentKeys = ['business_registration', 'lgu_permit', 'bir_cor', 'tax_relief_evidence']
  const businessType = stringValue(record(snapshot.organization).businessType)
  if (['SOLE_PROPRIETORSHIP', 'ONE_PERSON_CORPORATION'].includes(businessType)) documentKeys.push('identity_evidence')
  const tax = record(record(snapshot.verification).taxProfile)
  const taxDetails = record(tax.details)
  const steps = section.steps.filter((step) => documentKeys.includes(step.key) && (step.key !== 'tax_relief_evidence' || booleanValue(taxDetails.taxReliefClaimed)))
  const [busyKey, setBusyKey] = useState<string | null>(null)
  const [message, setMessage] = useState<string | null>(null)

  async function upload(key: string, file: File | undefined, input: HTMLInputElement) {
    if (!file) return
    setBusyKey(key); setMessage(null)
    try { await uploadVendorDocument(key, file, { source: 'VENDOR_PORTAL' }); await onRefresh(); setMessage(`${statusLabel(key)} uploaded and queued for review.`) } catch (cause) { setMessage(await readableOnboardingError(cause)) } finally { setBusyKey(null); input.value = '' }
  }

  return <section className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7" aria-labelledby="evidence-title"><div className="flex items-start gap-3"><FileText className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="evidence-title" className="text-2xl font-semibold">Private evidence</h2><p className="mt-2 max-w-2xl text-sm leading-6 text-text-secondary">Upload the current evidence for each required item. A replacement creates a new immutable version; Admin approval never edits the old version.</p></div></div>{message && <div className="mt-5"><StatusMessage tone={message.includes('uploaded') ? 'success' : 'error'}>{message}</StatusMessage></div>}<div className="mt-6 grid gap-4">{steps.map((step) => <div className="flex flex-col gap-4 border-t border-border-default pt-4 sm:flex-row sm:items-center sm:justify-between" key={step.key}><div className="flex min-w-0 items-start gap-3"><StepIcon status={step.status} /><div><p className="font-semibold">{step.label}</p><p className="mt-1 text-sm text-text-secondary">JPG, PNG, or PDF. The scan status is shown here before submission.</p></div></div><label className="inline-flex min-h-11 shrink-0 cursor-pointer items-center justify-center gap-2 rounded-control border border-border-default px-4 text-sm font-semibold text-text-strong hover:bg-brand-orange-50"><UploadCloud size={16} aria-hidden="true" />{busyKey === step.key ? 'Uploading…' : 'Upload evidence'}<input className="sr-only" type="file" accept="image/jpeg,image/png,application/pdf" disabled={busyKey !== null} onChange={(event) => void upload(step.key, event.target.files?.[0], event.currentTarget)} /></label></div>)}</div></section>
}

function VerificationSubmit({ snapshot, onSaved }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void }) {
  const [privacyAcknowledged, setPrivacyAcknowledged] = useState(false)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const verification = record(snapshot.verification)
  const status = stringValue(verification.status, 'NOT_STARTED')
  async function submit() {
    if (!privacyAcknowledged) { setMessage('Acknowledge the Privacy Notice before submitting.'); return }
    setBusy(true); setMessage(null)
    try { onSaved(await submitVendorVerification({ lockVersion: numberValue(record(snapshot.organization).lockVersion, 1), privacyAcknowledged: true })); setMessage('Store Verification submitted. Admin review is now pending.') } catch (cause) { setMessage(await readableOnboardingError(cause)) } finally { setBusy(false) }
  }
  return <section className="rounded-surface border border-action-primary/30 bg-brand-orange-50 p-5 sm:p-7" aria-labelledby="submit-verification-title"><div className="flex items-start gap-3"><BadgeCheck className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="submit-verification-title" className="text-2xl font-semibold">Submit for Admin review</h2><p className="mt-2 max-w-2xl text-sm leading-6 text-text-secondary">Submitting freezes the current verification evidence for review. If Admin requests changes, upload a replacement or update the named field and submit again.</p></div></div><label className="mt-6 flex min-h-11 items-start gap-3 text-sm leading-6 text-text-strong"><input className="mt-1 h-5 w-5 accent-action-primary" type="checkbox" checked={privacyAcknowledged} onChange={(event) => setPrivacyAcknowledged(event.target.checked)} /><span>I acknowledge the current Privacy Notice and authorize MateryalPH to review these Vendor business details and private evidence.</span></label>{message && <div className="mt-5"><StatusMessage tone={message.includes('submitted') ? 'success' : 'error'}>{message}</StatusMessage></div>}<Button className="mt-6" disabled={busy || ['PENDING_VERIFICATION', 'APPROVED'].includes(status)} onClick={() => void submit()}>{busy ? 'Submitting…' : status === 'PENDING_VERIFICATION' ? 'Awaiting Admin review' : status === 'APPROVED' ? 'Verification approved' : 'Submit Store Verification'} <Send size={16} aria-hidden="true" /></Button>{['PENDING_VERIFICATION', 'APPROVED'].includes(status) && <Link className="ml-4 inline-flex min-h-11 items-center font-semibold text-action-primary underline" to="/onboarding/setup">Proceed to Store Setup</Link>}</section>
}

function SetupWorkspace({ snapshot, onSaved, onRefresh }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; onRefresh: () => Promise<void> }) {
  return <div className="grid gap-8 xl:grid-cols-[minmax(0,1.35fr)_minmax(20rem,.65fr)]"><div className="grid gap-8"><SetupForm snapshot={snapshot} onSaved={onSaved} onRefresh={onRefresh} /><SetupCompletion snapshot={snapshot} onSaved={onSaved} /></div><div className="grid content-start gap-5"><Checklist title="Setup checklist" section={sectionFor(snapshot, 'STORE_SETUP')} compact /><InformationRail title="Separate from verification" icon={<ClipboardCheck size={20} aria-hidden="true" />} text="You may configure Store Setup while Store Verification is pending. This does not approve the business or make the store discoverable." /><InformationRail title="TEST payment boundary" icon={<CreditCard size={20} aria-hidden="true" />} text="Only the configured Xendit TEST environment is accepted in Phase 3. Provider confirmation, not a browser redirect, controls the connection status." /></div></div>
}

function SetupForm({ snapshot, onSaved, onRefresh }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void; onRefresh: () => Promise<void> }) {
  const org = record(snapshot.organization)
  const setup = record(snapshot.setup)
  const profile = record(setup.profile)
  const delivery = record(setup.delivery)
  const vehicle = arrayValue(setup.vehicles)[0] ?? {}
  const payment = record(setup.payment)
  const [busy, setBusy] = useState(false)
  const navigate = useNavigate()
  const [paymentBusy, setPaymentBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [paymentMessage, setPaymentMessage] = useState<string | null>(null)

  async function save(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setMessage(null)
    const data = new FormData(event.currentTarget)
    const continueLater = (event.nativeEvent as SubmitEvent).submitter?.getAttribute('data-continue-later') === 'true'
    const fulfillment = stringValue(data.get('fulfillment_method'))
    const draft: import('@materyalph/api-client-ts').VendorSetupDraft = { organizationLockVersion: numberValue(org.lockVersion, 1), publicStoreName: stringValue(data.get('public_store_name')).trim(), description: stringValue(data.get('description')).trim() || null, bulkCapability: data.get('bulk_capability') === 'yes', fulfillmentMethod: fulfillment as NonNullable<import('@materyalph/api-client-ts').VendorSetupDraft['fulfillmentMethod']>, publicEmail: stringValue(data.get('public_email')).trim().toLowerCase() || null, publicPhone: stringValue(data.get('public_phone')).trim() || null }
    if (!draft.publicStoreName) delete draft.publicStoreName
    if (!fulfillment) delete draft.fulfillmentMethod
    if (!data.has('bulk_capability')) delete draft.bulkCapability
    if (['VENDOR_DELIVERY', 'BOTH'].includes(fulfillment)) draft.delivery = { maximumDistanceKm: Number(data.get('maximum_distance_km')), coverageNotes: stringValue(data.get('coverage_notes')).trim() || null }
    const vehicleName = stringValue(data.get('vehicle_name')).trim()
    if (vehicleName) draft.vehicles = [{ ...(stringValue(vehicle.id) ? { id: stringValue(vehicle.id) } : {}), vehicleType: stringValue(data.get('vehicle_type')).trim(), name: vehicleName, capacityKg: Number(data.get('capacity_kg')), numberAvailable: Number(data.get('number_available')), cargoLengthM: Number(data.get('cargo_length_m')) || null, cargoWidthM: Number(data.get('cargo_width_m')) || null, cargoHeightM: Number(data.get('cargo_height_m')) || null, heavyClassification: stringValue(data.get('heavy_classification')).trim() || null, ...(stringValue(data.get('base_fee_centavos')).trim() !== '' ? { baseFeeCentavos: Number(data.get('base_fee_centavos')) } : {}), ...(stringValue(data.get('per_km_centavos')).trim() !== '' ? { perKmCentavos: Number(data.get('per_km_centavos')) } : {}), ...(stringValue(data.get('vehicle_maximum_distance_km')).trim() !== '' ? { maximumDistanceKm: Number(data.get('vehicle_maximum_distance_km')) } : {}) }]
    try { onSaved(await saveVendorSetupDraft(draft)); if (continueLater) navigate('/dashboard'); setMessage({ tone: 'success', text: 'Store Setup draft saved.' }) } catch (cause) { setMessage({ tone: 'error', text: await readableOnboardingError(cause) }) } finally { setBusy(false) }
  }

  async function capturePayment(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setPaymentBusy(true); setPaymentMessage(null)
    const data = new FormData(event.currentTarget)
    try { onSaved(await captureVendorPaymentConnection({ invitationUrl: stringValue(data.get('invitation_url')).trim(), providerAccountId: stringValue(data.get('provider_account_id')).trim() })); setPaymentMessage('TEST connection captured. Reconcile it to confirm the exact provider account.') } catch (cause) { setPaymentMessage(await readableOnboardingError(cause)) } finally { setPaymentBusy(false) }
  }

  async function reconcile() {
    setPaymentBusy(true); setPaymentMessage(null)
    try { const result = record(await reconcileVendorPaymentConnection()); await onRefresh(); setPaymentMessage(booleanValue(result.providerAvailable) ? `Provider status: ${statusLabel(stringValue(result.providerStatus, stringValue(result.status, 'PENDING')))}.` : stringValue(result.message, 'The provider is unavailable; the connection remains unverified.')) } catch (cause) { setPaymentMessage(await readableOnboardingError(cause)) } finally { setPaymentBusy(false) }
  }

  return <><section className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7" aria-labelledby="setup-form-title"><div><p className="text-xs font-semibold uppercase tracking-[0.14em] text-action-primary">Step 2 of 2</p><h2 id="setup-form-title" className="mt-2 text-2xl font-semibold">Public profile and fulfillment</h2><p className="mt-2 max-w-2xl text-sm leading-6 text-text-secondary">These settings become the reviewed store setup snapshot. Exact product inventory and Buyer coordinates stay outside this onboarding surface.</p></div>{message && <div className="mt-5"><StatusMessage tone={message.tone}>{message.text}</StatusMessage></div>}<form noValidate className="mt-7 grid gap-8" onSubmit={(event) => void save(event)}><FormSection title="Public store profile" description="Write the clear, customer-facing description that will appear after activation is approved."><div className="grid gap-5 sm:grid-cols-2"><Field className="sm:col-span-2" label="Public store name" name="public_store_name" defaultValue={stringValue(profile.publicStoreName, stringValue(org.storeName))} required /><div className="grid gap-2 text-sm font-semibold sm:col-span-2"><label htmlFor="description">Store description</label><textarea className="min-h-32 w-full rounded-control border border-border-default bg-surface-primary px-3 py-3 text-base font-normal" id="description" name="description" defaultValue={stringValue(profile.description)} /></div><Field label="Public email" name="public_email" type="email" defaultValue={stringValue(profile.publicEmail)} /><Field label="Public phone" name="public_phone" defaultValue={stringValue(profile.publicPhone)} inputMode="tel" /></div></FormSection><FormSection title="Bulk capability and fulfillment" description="Declare whether the store supports larger material orders, then choose how orders can be fulfilled."><div className="grid gap-5 sm:grid-cols-2"><fieldset className="grid gap-2 text-sm font-semibold"><legend>Bulk capability</legend><label className="flex min-h-11 items-center gap-3 font-normal"><input className="h-5 w-5 accent-action-primary" type="radio" name="bulk_capability" value="yes" defaultChecked={profile.bulkCapability === true} required /> Yes, we support bulk orders</label><label className="flex min-h-11 items-center gap-3 font-normal"><input className="h-5 w-5 accent-action-primary" type="radio" name="bulk_capability" value="no" defaultChecked={profile.bulkCapability === false} /> Not currently</label></fieldset><SelectField label="Fulfillment method" name="fulfillment_method" defaultValue={stringValue(profile.fulfillmentMethod)} options={['SELF_PICKUP', 'VENDOR_DELIVERY', 'BOTH']} /><Field label="Delivery radius (km)" name="maximum_distance_km" type="number" min="1" max="1000" defaultValue={String(numberValue(delivery.maximumDistanceKm, 1))} hint="Required for Vendor Delivery or Both." /><Field label="Coverage notes" name="coverage_notes" defaultValue={stringValue(delivery.coverageNotes)} hint="Describe practical coverage limits." /></div></FormSection><FormSection title="Fulfillment vehicle readiness" description="Record each vehicle you legitimately operate or control. A Vendor Delivery setup needs at least one active vehicle with a current rate version."><div className="grid gap-5 sm:grid-cols-2"><Field label="Vehicle name" name="vehicle_name" defaultValue={stringValue(vehicle.name)} hint="Required when Vendor Delivery or Both is selected." /><Field label="Vehicle type" name="vehicle_type" defaultValue={stringValue(vehicle.vehicleType, 'DELIVERY_VEHICLE')} /><Field label="Capacity (kg)" name="capacity_kg" type="number" min="1" defaultValue={String(numberValue(vehicle.capacityKg, 1))} /><Field label="Number available" name="number_available" type="number" min="1" defaultValue={String(numberValue(vehicle.numberAvailable, 1))} /><Field label="Cargo length (m)" name="cargo_length_m" type="number" min="0" step="any" defaultValue={numberInputValue(vehicle.cargoLengthM)} /><Field label="Cargo width (m)" name="cargo_width_m" type="number" min="0" step="any" defaultValue={numberInputValue(vehicle.cargoWidthM)} /><Field label="Cargo height (m)" name="cargo_height_m" type="number" min="0" step="any" defaultValue={numberInputValue(vehicle.cargoHeightM)} /><Field label="Heavy classification" name="heavy_classification" defaultValue={stringValue(vehicle.heavyClassification)} /><Field label="Base fee (centavos)" name="base_fee_centavos" type="number" min="0" defaultValue={numberInputValue(vehicle.baseFeeCentavos)} hint="Stored as integer centavos for later delivery quotes." /><Field label="Per-kilometer rate (centavos)" name="per_km_centavos" type="number" min="0" defaultValue={numberInputValue(vehicle.perKmCentavos)} /><Field label="Vehicle maximum distance (km)" name="vehicle_maximum_distance_km" type="number" min="1" max="1000" defaultValue={numberInputValue(vehicle.maximumDistanceKm, String(numberValue(delivery.maximumDistanceKm, 1)))} /></div></FormSection><div className="flex flex-wrap items-center justify-between gap-3 border-t border-border-default pt-6"><p className="max-w-xl text-sm leading-6 text-text-secondary">Store Setup can be drafted even while verification is pending. Completion still requires a confirmed TEST payment connection.</p><Button type="submit" variant="secondary" formNoValidate data-continue-later="true" disabled={busy}>Finish Later</Button><Button type="submit" disabled={busy}>{busy ? 'Saving draft…' : 'Save setup draft'} <Check size={16} aria-hidden="true" /></Button></div></form></section><section className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7" aria-labelledby="payment-title"><div className="flex items-start gap-3"><CreditCard className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="payment-title" className="text-2xl font-semibold">Xendit TEST connection</h2><p className="mt-2 max-w-2xl text-sm leading-6 text-text-secondary">Capture the exact invitation URL and TEST sub-account identifier. A captured link is not proof of payment readiness until the provider account is reconciled.</p></div></div><form className="mt-6 grid gap-5 sm:grid-cols-2" onSubmit={(event) => void capturePayment(event)}><Field className="sm:col-span-2" label="Exact HTTPS invitation URL" name="invitation_url" type="url" defaultValue="" placeholder="https://…" required /><Field label="TEST sub-account ID" name="provider_account_id" defaultValue={stringValue(payment.providerAccountId)} required /><div className="flex items-end"><Button type="submit" disabled={paymentBusy}>{paymentBusy ? 'Capturing…' : 'Capture TEST connection'} <CreditCard size={16} aria-hidden="true" /></Button></div></form><div className="mt-5 flex flex-wrap items-center gap-3 border-t border-border-default pt-5"><StatusBadge label={statusLabel(stringValue(payment.connectionStatus, 'UNVERIFIED'))} tone={statusTone(stringValue(payment.connectionStatus, 'UNVERIFIED'))} />{payment.providerStatus && <span className="text-sm text-text-secondary">Provider: {stringValue(payment.providerStatus)}</span>}<Button type="button" variant="secondary" disabled={paymentBusy || !payment.providerAccountId} onClick={() => void reconcile()}><RefreshCw size={16} aria-hidden="true" /> Reconcile TEST account</Button></div>{paymentMessage && <p className="mt-4 text-sm leading-6 text-text-secondary" role="status">{paymentMessage}</p>}</section><MediaUploader snapshot={snapshot} onRefresh={onRefresh} /></>
}

function MediaUploader({ snapshot, onRefresh }: { snapshot: VendorOnboardingSnapshot; onRefresh: () => Promise<void> }) {
  const setup = record(snapshot.setup)
  const media = arrayValue(setup.media)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  async function upload(kind: 'LOGO' | 'BANNER', file: File | undefined, input: HTMLInputElement) {
    if (!file) return
    setBusy(true); setMessage(null)
    try { await uploadVendorMedia(kind, file, kind === 'LOGO' ? 'Store logo' : 'Store banner'); await onRefresh(); setMessage(`${statusLabel(kind)} uploaded.`) } catch (cause) { setMessage(await readableOnboardingError(cause)) } finally { setBusy(false); input.value = '' }
  }
  return <section className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7" aria-labelledby="media-title"><div className="flex items-start gap-3"><ImagePlus className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="media-title" className="text-2xl font-semibold">Store media</h2><p className="mt-2 text-sm leading-6 text-text-secondary">Logo and banner media are optional for Phase 3 setup, but each uploaded asset needs accessible alt text.</p></div></div><div className="mt-6 grid gap-4 sm:grid-cols-2">{(['LOGO', 'BANNER'] as const).map((kind) => <div className="border-t border-border-default pt-4" key={kind}><p className="font-semibold">{statusLabel(kind)}</p><StoreMediaPreview media={media.filter(item => stringValue(item.kind) === kind).at(-1)} kind={kind} /><p className="mt-1 text-sm text-text-secondary">{media.filter((item) => stringValue(item.kind) === kind).length > 0 ? 'Asset uploaded' : 'No asset uploaded'}</p><label className="mt-4 inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-control border border-border-default px-4 text-sm font-semibold hover:bg-brand-orange-50"><UploadCloud size={16} aria-hidden="true" />{busy ? 'Uploading…' : 'Upload image'}<input className="sr-only" type="file" accept="image/jpeg,image/png,image/webp" disabled={busy} onChange={(event) => void upload(kind, event.target.files?.[0], event.currentTarget)} /></label></div>)}</div>{message && <p className="mt-4 text-sm text-text-secondary" role="status">{message}</p>}</section>
}

function SetupCompletion({ snapshot, onSaved }: { snapshot: VendorOnboardingSnapshot; onSaved: (snapshot: VendorOnboardingSnapshot) => void }) {
  const navigate = useNavigate()
  const [accepted, setAccepted] = useState(false)
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<string | null>(null)
  const setup = record(snapshot.setup)
  const status = stringValue(setup.status, 'NOT_STARTED')
  async function complete() {
    if (!accepted) { setMessage('Review and accept the current TEST commission terms before completing setup.'); return }
    setBusy(true); setMessage(null)
    try { onSaved(await completeVendorSetup({ organizationLockVersion: numberValue(record(snapshot.organization).lockVersion, 1), commissionTermsAccepted: true })); setMessage('Store Setup completed. Activation remains a separate gate.'); navigate('/dashboard') } catch (cause) { setMessage(await readableOnboardingError(cause)) } finally { setBusy(false) }
  }
  return <section className="rounded-surface border border-action-primary/30 bg-brand-orange-50 p-5 sm:p-7" aria-labelledby="complete-setup-title"><div className="flex items-start gap-3"><CircleDollarSign className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 id="complete-setup-title" className="text-2xl font-semibold">Complete Store Setup</h2><p className="mt-2 max-w-2xl text-sm leading-6 text-text-secondary">The TEST agreement is a Vendor-paid 2% platform commission assessed after Vendor discounts and excluding included Vendor VAT. Buyer totals and provider fees remain separate records.</p><p className="mt-3 text-sm font-semibold"><Link className="text-action-primary underline-offset-4 hover:underline" to="/legal/vendor-commission-test">Read the TEST commission terms</Link></p></div></div><label className="mt-6 flex min-h-11 items-start gap-3 text-sm leading-6 text-text-strong"><input className="mt-1 h-5 w-5 accent-action-primary" type="checkbox" checked={accepted} onChange={(event) => setAccepted(event.target.checked)} /><span>I accept the current version of the TEST Vendor commission terms for this organization.</span></label>{message && <div className="mt-5"><StatusMessage tone={message.includes('completed') ? 'success' : 'error'}>{message}</StatusMessage></div>}<Button className="mt-6" disabled={busy || status === 'COMPLETED'} onClick={() => void complete()}>{busy ? 'Completing…' : status === 'COMPLETED' ? 'Setup completed' : 'Complete Store Setup'} <ArrowRight size={16} aria-hidden="true" /></Button></section>
}

export function VendorTeamPage() {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  async function invite(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setBusy(true); setMessage(null)
    const form = event.currentTarget
    const data = new FormData(form)
    try { await inviteVendorTeamMember({ email: stringValue(data.get('email')).trim().toLowerCase(), inviteeName: stringValue(data.get('invitee_name')).trim(), inviteeMobile: stringValue(data.get('invitee_mobile')).trim() || null, role: stringValue(data.get('role')) as import('@materyalph/api-client-ts').VendorInvitationRequest['role'] }); setMessage({ tone: 'success', text: 'Invitation queued. The recipient will receive a one-time acceptance link.' }); form.reset() } catch (cause) { setMessage({ tone: 'error', text: await readableOnboardingError(cause) }) } finally { setBusy(false) }
  }
  if (loading && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/team" accountLabel="Vendor team"><LoadingState /></VendorShell>
  if (error && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/team" accountLabel="Vendor team"><ErrorState message={error} onRetry={() => void refresh()} /></VendorShell>
  if (!snapshot) return null
  if (snapshot.setup.status !== 'COMPLETED' || !snapshot.permissions.includes('staff.manage')) return <Navigate to="/dashboard" replace />
  return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/team" accountLabel="Vendor team" accountStatus="Fixed-role access"><div className="phase3-page mx-auto max-w-4xl space-y-8"><PageHeader eyebrow="Team accounts" title="Invite the people who keep the store moving." description="Every invitation is assigned one fixed operational role. Store Manager invitations cannot create another Manager unless the Vendor Owner sends them." /><section className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7"><div className="flex items-start gap-3"><Users className="mt-1 shrink-0 text-action-primary" size={22} aria-hidden="true" /><div><h2 className="text-2xl font-semibold">Invite a team member</h2><p className="mt-2 text-sm leading-6 text-text-secondary">Never share an invitation token in chat. The API stores only a hash and sends the one-time link through the protected outbox.</p></div></div>{message && <div className="mt-5"><StatusMessage tone={message.tone}>{message.text}</StatusMessage></div>}<form className="mt-7 grid gap-5 sm:grid-cols-2" onSubmit={(event) => void invite(event)}><Field label="Name" name="invitee_name" autoComplete="name" required /><Field label="Email" name="email" type="email" autoComplete="email" required /><Field label="Mobile" name="invitee_mobile" inputMode="tel" /><SelectField label="Fixed role" name="role" defaultValue="STORE_STAFF" options={['STORE_MANAGER', 'STORE_STAFF', 'CUSTOMER_SERVICE', 'INVENTORY', 'FULFILLMENT']} /><div className="flex items-center gap-3 border-t border-border-default pt-5 sm:col-span-2"><Button type="submit" disabled={busy}>{busy ? 'Sending invitation…' : 'Send invitation'} <Send size={16} aria-hidden="true" /></Button><span className="text-sm text-text-secondary">Invitations expire according to the server policy.</span></div></form></section><section className="grid gap-4 sm:grid-cols-2"><InformationRail title="Least privilege" icon={<ShieldCheck size={20} aria-hidden="true" />} text="Role permissions are enforced on every protected request. A delegated Manager cannot elevate their own role or invite another Manager." /><InformationRail title="Audit trail" icon={<FileCheck2 size={20} aria-hidden="true" />} text="Invitation issuance and acceptance are recorded without exposing raw invitation tokens or credentials." /></section></div></VendorShell>
}
export function VendorAccountPage() {
  return <VendorShell activeHref="/settings" accountLabel="Vendor account"><AccountWorkspace embedded portal="vendors" basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} loginPath="/login" renderQr={uri => <QRCodeSVG value={uri} title="Authenticator setup QR code" />} /></VendorShell>
}

export function VendorStoreProfilePage() {
  const { snapshot, loading, error, refresh, setSnapshot } = useOnboardingSnapshot()
  if (loading && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/store-profile" accountLabel="Vendor account"><LoadingState /></VendorShell>
  if (error && !snapshot) return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/store-profile" accountLabel="Vendor account"><ErrorState message={error} onRetry={() => void refresh()} /></VendorShell>
  if (!snapshot) return null
  if (!snapshot.permissions.includes('vendor.onboarding.submit')) return <Navigate to="/settings" replace />
  if (record(snapshot.activation).status !== 'ACTIVE') return <Navigate to="/dashboard" replace />
  const org = record(snapshot.organization)
  const address = record(record(snapshot.verification).address)
  const profile = record(record(snapshot.setup).profile)
  return <VendorShell refreshError={error} navigationData={snapshot} activeHref="/store-profile" accountLabel={stringValue(org.storeName, 'Your store')}><div className="space-y-6"><header className="rounded-surface border border-border-default bg-surface-primary p-6"><div className="mb-5 min-h-24 rounded-control bg-surface-canvas"><StoreMediaPreview media={arrayValue(record(snapshot.setup).media).filter(item => stringValue(item.kind) === 'BANNER').at(-1)} kind="BANNER" /></div><div className="mb-4 max-w-32"><StoreMediaPreview media={arrayValue(record(snapshot.setup).media).filter(item => stringValue(item.kind) === 'LOGO').at(-1)} kind="LOGO" /></div><h1 className="text-3xl font-semibold">{stringValue(profile.publicStoreName, stringValue(org.storeName, 'Store Profile'))}</h1><p className="mt-3 text-text-secondary">{stringValue(profile.description, 'Your marketplace business profile')}</p></header><SectionWorkspace sections={[
    { label: 'Store Information', content: <div className="space-y-6"><PublicStoreProfileEditor snapshot={snapshot} onSaved={setSnapshot} /><MediaUploader snapshot={snapshot} onRefresh={refresh} /></div> },
    { label: 'Primary Contact', content: <dl className="grid gap-5 sm:grid-cols-2"><div><dt>Public email</dt><dd>{stringValue(profile.publicEmail, 'Not configured')}</dd></div><div><dt>Public phone</dt><dd>{stringValue(profile.publicPhone, 'Not configured')}</dd></div></dl> },
    { label: 'Business Information', content: <div className="space-y-4"><h2 className="text-xl font-semibold">Registered location</h2><p>{stringValue(address.formattedAddress, [address.street, address.barangay, address.cityMunicipality, address.province].filter(Boolean).join(', ') || 'Not recorded')}</p><StatusBadge label={statusLabel(snapshot.verification.status)} /><Link className="inline-flex min-h-11 items-center text-action-primary underline" to="/onboarding/verification">Review verified business information</Link></div> },
    { label: 'Documents', content: <DocumentChecklist snapshot={snapshot} onRefresh={refresh} /> },
    { label: 'Operating Hours', content: <p>Not yet implemented. No operating schedule is currently available.</p> },
    { label: 'Fulfillment Configuration', content: <div className="space-y-4"><h2 className="text-xl font-semibold">Bulk capability and fulfillment</h2><p>Bulk orders: {profile.bulkCapability === true ? 'Supported' : 'Not configured'}</p><p>Fulfillment: {statusLabel(stringValue(profile.fulfillmentMethod, 'NOT_CONFIGURED'))}</p><Link className="inline-flex min-h-11 items-center text-action-primary underline" to="/onboarding/setup">Manage existing fulfillment configuration</Link></div> },
    { label: 'Vehicles Management', content: <div className="space-y-4"><h2 className="text-xl font-semibold">Registered vehicles</h2><p>{arrayValue(record(snapshot.setup).vehicles).length} registered vehicles</p><ul className="divide-y divide-border-default">{arrayValue(record(snapshot.setup).vehicles).map((vehicle, index) => <li className="py-3" key={index}>{stringValue(vehicle.name, 'Vehicle')} · {stringValue(vehicle.vehicleType, stringValue(vehicle.vehicle_type))}</li>)}</ul><Link className="inline-flex min-h-11 items-center text-action-primary underline" to="/onboarding/setup">Manage vehicle configuration</Link></div> },
  ]} /></div></VendorShell>
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
      onSaved(await saveVendorSetupDraft({ organizationLockVersion: numberValue(org.lockVersion, 1), publicStoreName: String(data.get('public_store_name')).trim(), description: String(data.get('description')).trim() || null, publicEmail: String(data.get('public_email')).trim() || null, publicPhone: String(data.get('public_phone')).trim() || null }))
      setMessage({ tone: 'success', text: 'Store Profile saved.' })
    } catch (cause) { setMessage({ tone: 'error', text: await readableOnboardingError(cause) }) }
    finally { setBusy(false) }
  }
  return <form className="grid max-w-3xl gap-5" onSubmit={event => void save(event)}><h2 className="text-xl font-semibold">Public store information</h2>{message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}<Field label="Store display name" name="public_store_name" defaultValue={stringValue(profile.publicStoreName, stringValue(org.storeName))} maxLength={180} required /><label className="grid gap-2 font-semibold">Store description<textarea name="description" className="min-h-32 rounded-control border border-border-default bg-surface-primary p-3 font-normal" maxLength={3000} defaultValue={stringValue(profile.description)} /></label><div className="grid gap-5 sm:grid-cols-2"><Field label="Public store email" name="public_email" type="email" defaultValue={stringValue(profile.publicEmail)} /><Field label="Public store phone" name="public_phone" defaultValue={stringValue(profile.publicPhone)} maxLength={24} /></div><Button className="w-fit" disabled={busy} type="submit">{busy ? 'Saving…' : 'Save Store Profile'}</Button></form>
}
function StoreMediaPreview({ media, kind }: { media: JsonRecord | undefined; kind: string }) {
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
  if (!fileId) return null
  return <div className="my-3">{url && !failed ? <img src={url} alt={stringValue(media?.altText, `Store ${kind.toLowerCase()}`)} className={kind === 'LOGO' ? 'h-24 w-24 object-contain' : 'max-h-48 w-full object-contain'} onError={() => setFailed(true)} /> : failed ? <Button type="button" variant="secondary" onClick={() => setAttempt(value => value + 1)}>Reload image</Button> : <p role="status">Loading image…</p>}</div>
}
