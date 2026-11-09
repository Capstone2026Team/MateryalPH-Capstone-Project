import { CreditCard, ExternalLink, HardDrive, Info, Landmark, Layers3, MapPinned, MessagesSquare, ScanText, Server, ShieldCheck, type LucideIcon } from 'lucide-react'
import type { ReactNode } from 'react'
import { HealthBadge } from './operations-patterns'
import './service-consoles.css'

const logos = {
  hostinger: new URL('./assets/service-logos/hostinger.svg', import.meta.url).href,
  duckdns: new URL('./assets/service-logos/duckdns.png', import.meta.url).href,
  backblaze: new URL('./assets/service-logos/backblaze.svg', import.meta.url).href,
  googlecloud: new URL('./assets/service-logos/googlecloud.svg', import.meta.url).href,
  google: new URL('./assets/service-logos/google.svg', import.meta.url).href,
  xendit: new URL('./assets/service-logos/xendit.svg', import.meta.url).href,
  firebase: new URL('./assets/service-logos/firebase.svg', import.meta.url).href,
  laravel: new URL('./assets/service-logos/laravel.svg', import.meta.url).href,
  brevo: new URL('./assets/service-logos/brevo.svg', import.meta.url).href,
  cloudinary: new URL('./assets/service-logos/cloudinary.svg', import.meta.url).href,
  bouncer: new URL('./assets/service-logos/bouncer.svg', import.meta.url).href,
}

export type ServiceBrand = keyof typeof logos

/** Local assets avoid third-party image requests from authenticated portal pages. */
export function ServiceLogo({ service, fallback, compact = false }: { service?: ServiceBrand | undefined; fallback?: ReactNode; compact?: boolean }) {
  return <span className={`flex shrink-0 items-center justify-center rounded-control border border-border-default bg-surface-primary ${compact ? 'size-8' : 'size-10'}`} aria-hidden="true">
    {service ? <img src={logos[service]} alt="" className={`${compact ? 'size-5' : 'size-6'} object-contain`} width={compact ? 20 : 24} height={compact ? 20 : 24} /> : fallback ?? <Server size={20} className="text-text-secondary" />}
  </span>
}

type ServiceRole = 'infrastructure' | 'payments' | 'storage' | 'identity' | 'communication' | 'verification' | 'other'

export const VPS_SERVICE_CONSOLES: { brand: ServiceBrand; role: ServiceRole; label: string; purpose: string; description: string; href: string; integrationKeys: string[] }[] = [
  { brand: 'hostinger', role: 'infrastructure', label: 'Hostinger', purpose: 'Server · hPanel', description: 'VPS hosting for the API, portals and background services.', href: 'https://hpanel.hostinger.com/', integrationKeys: [] },
  { brand: 'duckdns', role: 'infrastructure', label: 'Duck DNS', purpose: 'Domain & DNS', description: 'Public addresses for the API, portals and realtime connection.', href: 'https://www.duckdns.org/', integrationKeys: [] },
  { brand: 'backblaze', role: 'storage', label: 'Backblaze B2', purpose: 'Private storage & backups', description: 'Private file storage and encrypted offsite backups.', href: 'https://secure.backblaze.com/', integrationKeys: ['backblaze'] },
  { brand: 'brevo', role: 'communication', label: 'Brevo', purpose: 'Transactional email', description: 'Account, order and other transactional email over SMTP.', href: 'https://app.brevo.com/', integrationKeys: ['email'] },
  { brand: 'cloudinary', role: 'storage', label: 'Cloudinary', purpose: 'Images & media', description: 'Hosted images, media transformations and delivery.', href: 'https://console.cloudinary.com/users/login', integrationKeys: ['cloudinary'] },
  { brand: 'bouncer', role: 'storage', label: 'Bouncer', purpose: 'Malware scanning', description: 'Scans uploaded files before they can be used.', href: 'https://usebouncer.dev/dashboard/', integrationKeys: ['bouncer'] },
  { brand: 'googlecloud', role: 'identity', label: 'Google Cloud', purpose: 'Maps, sign-in & reCAPTCHA', description: 'Maps, Places, Routes, Google sign-in and reCAPTCHA Enterprise.', href: 'https://console.cloud.google.com/', integrationKeys: ['google_maps', 'google_oidc', 'recaptcha'] },
  { brand: 'firebase', role: 'communication', label: 'Firebase', purpose: 'Push notifications', description: 'Firebase Cloud Messaging for Buyer push notifications.', href: 'https://console.firebase.google.com/', integrationKeys: ['push'] },
  { brand: 'xendit', role: 'payments', label: 'Xendit', purpose: 'Payments & webhooks', description: 'TEST payments, verified webhooks and Vendor account onboarding.', href: 'https://dashboard.xendit.co/', integrationKeys: ['xendit_payments', 'xendit_accounts'] },
]

type ReportedIntegration = { key: string; status: string; detail: string; environment?: string | null }
export type VpsServiceSnapshot = { brand: ServiceBrand; label: string; purpose: string; description: string; href: string; status: string; detail: string }

/** A local/Render response must never become a claim about VPS provider health. */
export function vpsServiceSnapshot(integrations: readonly ReportedIntegration[], deployed: boolean): VpsServiceSnapshot[] {
  const severity = ['DEGRADED', 'NOT_CONFIGURED', 'SIMULATED']
  return VPS_SERVICE_CONSOLES.map(service => {
    const reports = service.integrationKeys.map(key => integrations.find(item => item.key === key))
    const reported = reports.filter((item): item is ReportedIntegration => Boolean(item))
    const status = !deployed ? 'VPS_REFERENCE' : reports.length === 0 ? 'CONSOLE_ONLY'
      : severity.find(state => reported.some(item => item.status === state))
        ?? (reports.some(item => !item || item.status !== 'HEALTHY') ? 'UNKNOWN' : 'HEALTHY')
    return { brand: service.brand, label: service.label, purpose: service.purpose, description: service.description, href: service.href, status,
      detail: deployed ? [...new Set(reported.filter(item => item.status !== 'HEALTHY').map(item => item.detail))].join(' ') : '' }
  })
}

const serviceStatuses: Record<string, { state: string; label: string }> = {
  HEALTHY: { state: 'HEALTHY', label: 'Healthy' }, DEGRADED: { state: 'DEGRADED', label: 'Degraded' },
  NOT_CONFIGURED: { state: 'NOT_CONFIGURED', label: 'Not configured' }, SIMULATED: { state: 'IDLE', label: 'Simulated' },
  VPS_REFERENCE: { state: 'IDLE', label: 'VPS reference' }, CONSOLE_ONLY: { state: 'IDLE', label: 'Manage in console' },
}

type ServiceIntegration = ReportedIntegration & { label: string; lastEventAt?: Date | null }

const checkLabels: Record<string, string> = {
  xendit_payments: 'Xendit payments and webhooks', xendit_accounts: 'Xendit sub-account onboarding',
  google_maps: 'Google Maps, Places and Routes', google_oidc: 'Google sign-in', recaptcha: 'Google reCAPTCHA Enterprise',
}

const serviceRoles: { key: ServiceRole; label: string; icon: LucideIcon }[] = [
  { key: 'infrastructure', label: 'Infrastructure', icon: Server }, { key: 'payments', label: 'Payments & onboarding', icon: CreditCard },
  { key: 'storage', label: 'Storage & media', icon: HardDrive }, { key: 'identity', label: 'Maps & identity', icon: MapPinned },
  { key: 'communication', label: 'Communication', icon: MessagesSquare }, { key: 'verification', label: 'Verification & reference', icon: ShieldCheck },
  { key: 'other', label: 'Other platform services', icon: Layers3 },
]

type DirectoryService = { key: string; role: ServiceRole; label: string; purpose: string; brand?: ServiceBrand | undefined; href?: string | undefined; linkLabel?: string | undefined; icon: LucideIcon; checks: ServiceIntegration[] }

const backendServices: Omit<DirectoryService, 'checks'>[] = [
  { key: 'reverb', role: 'communication', label: 'Laravel Reverb', purpose: 'Realtime connections', brand: 'laravel', icon: Server },
  { key: 'ocr', role: 'verification', label: 'OCR assistance', purpose: 'Document reading', icon: ScanText },
  { key: 'dti_bps_registers', role: 'verification', label: 'DTI-BPS registers', purpose: 'PS and ICC reference data', href: 'https://bps.dti.gov.ph/product-certification/certified-products', linkLabel: 'Certified products', icon: Landmark },
]

function serviceStatus(status: string) {
  return serviceStatuses[status] ?? { state: status === 'FAILED' ? 'FAILING' : ['DELAYED', 'STALE', 'OVERDUE'].includes(status) ? 'DEGRADED' : status === 'NO_RUN_RECORDED' ? 'NOT_CONFIGURED' : status === 'UNKNOWN' ? 'UNKNOWN' : 'IDLE',
    label: status === 'UNKNOWN' ? 'Not reported' : status.toLowerCase().replaceAll('_', ' ').replace(/^./, char => char.toUpperCase()) }
}

function ServiceChecks({ service, formatDateTime }: { service: DirectoryService; formatDateTime: (date: Date) => string }) {
  const Icon = service.icon
  const single = service.checks.length === 1 && service.checks[0]?.label === service.label
  return <li className="mp-service-entry" aria-label={`${service.label} service`}>
    <div className="mp-service-entry-heading">
      <ServiceLogo compact service={service.brand} fallback={<Icon size={18} className="text-text-secondary" />} />
      <div className="min-w-0"><h4 className="break-words text-sm font-semibold text-text-strong">{service.label}</h4><p className="text-xs leading-4 text-text-secondary">{service.purpose}</p></div>
      {service.href && <a href={service.href} target="_blank" rel="noopener noreferrer" aria-label={`${service.linkLabel ?? `Open ${service.label} console`} (new tab)`}
        className="mp-service-console inline-flex min-h-11 items-center justify-center gap-1 rounded-control border border-border-default bg-surface-primary px-2 text-xs font-medium text-text-strong transition-colors hover:bg-surface-canvas focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring motion-reduce:transition-none">{service.linkLabel ?? 'Console'}<ExternalLink size={13} aria-hidden="true" /></a>}
    </div>
    <ul aria-label={`${service.label} checks`} className="divide-y divide-border-default">
      {service.checks.map(item => {
        const status = serviceStatus(item.status)
        return <li key={item.key} aria-label={item.label} className="mp-service-check">
          <div className="mp-service-check-heading">{!single && <h5 className="min-w-0 break-words text-xs font-medium leading-4 text-text-strong">{item.label}</h5>}<HealthBadge density="compact" state={status.state} label={status.label} /></div>
          <p className="text-xs leading-[18px] text-text-secondary">{item.detail}</p>
          {(item.environment || item.lastEventAt) && <p className="mp-service-check-meta text-xs leading-[18px] text-text-secondary">{item.environment && <span>{item.environment}</span>}{item.lastEventAt && <time dateTime={item.lastEventAt.toISOString()}>Last event {formatDateTime(item.lastEventAt)}</time>}</p>}
        </li>
      })}
    </ul>
  </li>
}

/** Group by platform responsibility, then service, without replacing individual diagnostic states. */
export function ServiceDirectory({ integrations, deployed, formatDateTime }: {
  integrations: readonly ServiceIntegration[]; deployed: boolean; formatDateTime: (date: Date) => string
}) {
  const entries: ServiceIntegration[] = [...integrations]
  for (const provider of VPS_SERVICE_CONSOLES) {
    const keys = provider.integrationKeys.length ? provider.integrationKeys : [`provider_${provider.brand}`]
    for (const key of keys) {
      if (!entries.some(item => item.key === key)) entries.push({ key,
        label: checkLabels[key] ?? provider.label,
        status: !deployed ? 'VPS_REFERENCE' : provider.integrationKeys.length ? 'UNKNOWN' : 'CONSOLE_ONLY',
        detail: provider.description })
    }
  }
  const services: DirectoryService[] = VPS_SERVICE_CONSOLES.map(provider => ({ key: provider.brand, role: provider.role, label: provider.label,
    purpose: provider.purpose, brand: provider.brand, href: provider.href, icon: Server,
    checks: entries.filter(item => provider.integrationKeys.includes(item.key) || item.key === `provider_${provider.brand}` || (item.key === 'file_storage' && provider.brand === 'backblaze')) }))
  for (const service of backendServices) {
    const checks = entries.filter(item => item.key === service.key)
    if (checks.length) services.push({ ...service, checks })
  }
  for (const item of entries) {
    if (!services.some(service => service.checks.includes(item))) services.push({ key: item.key, role: 'other', label: item.label, purpose: 'Platform integration', icon: Server, checks: [item] })
  }
  return <div role="group" aria-label="Services and integrations" className="mp-service-directory">
    {!deployed && <p role="note" aria-label="Service status scope" className="mp-service-scope"><Info size={16} aria-hidden="true" /><span><strong>VPS reference consoles.</strong> Checks below describe the current runtime, not deployed provider health.</span></p>}
    <div className="mp-service-directory-columns">
    {serviceRoles.map(role => {
      const grouped = services.filter(service => service.role === role.key)
      if (!grouped.length) return null
      const Icon = role.icon
      return <section key={role.key} aria-label={role.label} data-service-role={role.key} className="mp-service-group mp-card">
        <div className="mp-service-group-heading"><span className="mp-service-role-icon" aria-hidden="true"><Icon size={16} /></span><h3 className="text-sm font-semibold text-text-strong">{role.label}</h3><span className="mp-service-count text-xs text-text-secondary">{grouped.length}<span className="sr-only"> {grouped.length === 1 ? 'service' : 'services'}</span></span></div>
        <ul aria-label={`${role.label} services`} className="divide-y divide-border-default">{grouped.map(service => <ServiceChecks key={service.key} service={service} formatDateTime={formatDateTime} />)}</ul>
      </section>
    })}
  </div></div>
}
