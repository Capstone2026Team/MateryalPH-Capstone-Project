import { RateLimitNotice } from './rate-limit-notice'
import { PortalAccountMenu } from './portal-account-menu'
import { useState, type MouseEvent, type ReactNode } from 'react'

export type PortalNavItem = { label: string; href: string; icon?: ReactNode; disabled?: boolean }
export type PortalNavSection = { label: string; items: PortalNavItem[] }

export function PortalShell({
  portalLabel,
  pageTitle,
  dateLabel,
  sections,
  activeHref,
  accountLabel,
  accountStatus,
  children,
  headerActions,
  homeHref = '/dashboard',
  onNavigate,
  apiBasePath,
  onSignOut,
}: {
  apiBasePath?: string
  onSignOut?: () => Promise<void>
  portalLabel: string
  pageTitle: string
  dateLabel?: string
  sections: PortalNavSection[]
  activeHref: string
  accountLabel: string
  accountStatus?: string
  children: ReactNode
  headerActions?: ReactNode
  homeHref?: string
  onNavigate?: (href: string) => void
}) {
  const [navigationOpen, setNavigationOpen] = useState(false)

  function follow(event: MouseEvent<HTMLAnchorElement>, href: string) {
    setNavigationOpen(false)
    if (onNavigate && !event.ctrlKey && !event.metaKey && !event.shiftKey && !event.altKey && event.button === 0) { event.preventDefault(); onNavigate(href) }
  }

  return (
    <div className="min-h-screen bg-surface-canvas text-text-strong md:grid md:grid-cols-[14rem_minmax(0,1fr)]">
      <aside className={`${navigationOpen ? 'block' : 'hidden'} fixed inset-0 z-40 bg-surface-primary overflow-y-auto md:overflow-y-visible md:sticky md:top-0 md:h-screen md:block md:border-r md:border-border-default`} aria-label={`${portalLabel} navigation`}>
        <div className="flex min-h-full flex-col">
          <div className="flex min-h-20 items-center border-b border-border-default px-6">
            <a aria-label={`MateryalPH ${portalLabel}`} className="no-underline" href={homeHref} onClick={event => follow(event, homeHref)}><span className="block text-2xl font-bold tracking-tight text-text-strong">Materyal<span className="text-action-primary">PH</span></span><span className="mt-1 block text-[0.625rem] font-semibold tracking-[0.14em] text-text-secondary">{portalLabel}</span></a>
            <button className="ml-auto inline-flex min-h-11 items-center justify-center rounded-control px-3 text-sm font-semibold text-text-secondary md:hidden" type="button" aria-label="Close navigation" onClick={() => setNavigationOpen(false)}>Close</button>
          </div>
          <nav className="flex-1 space-y-3 px-3 py-4">
            {sections.map((section) => <div key={section.label}>
              <p className="px-3 text-[0.6875rem] font-semibold uppercase tracking-[0.12em] text-text-secondary">{section.label}</p>
              <div className="mt-1 grid gap-0.5">
                {section.items.map((item) => item.disabled ? <span key={item.href} aria-disabled="true" className="flex min-h-11 items-center gap-3 px-3 text-sm text-text-secondary opacity-60">{item.icon}<span>{item.label}</span><span className="sr-only">Unavailable</span></span> : <a key={item.href} className={`flex min-h-11 items-center gap-3 rounded-control px-3 text-sm font-semibold no-underline transition-colors ${item.href === activeHref ? 'bg-action-primary text-white' : 'text-text-secondary hover:bg-brand-orange-50 hover:text-text-strong'}`} href={item.href} aria-current={item.href === activeHref ? 'page' : undefined} onClick={event => follow(event, item.href)}>{item.icon}<span>{item.label}</span></a>)}
              </div>
            </div>)}
          </nav>
          <div className="border-t border-border-default p-4">
            <p className="truncate text-sm font-semibold">{accountLabel}</p>
            {accountStatus && <p className="mt-1 text-xs text-text-secondary">{accountStatus}</p>}
          </div>
        </div>
      </aside>
      <div className="min-w-0">
        <header className="sticky top-0 z-30 flex min-h-16 items-center justify-between gap-4 border-b border-border-default bg-surface-primary px-4 sm:px-6 lg:px-8">
          <div className="flex min-w-0 items-center gap-3">
            <button className="inline-flex min-h-11 items-center justify-center rounded-control border border-border-default px-3 text-sm font-semibold text-text-strong md:hidden" type="button" aria-label="Open navigation" aria-expanded={navigationOpen} onClick={() => setNavigationOpen(true)}>Menu</button>
            <div className="min-w-0 lg:flex lg:items-center lg:gap-3"><p className="truncate text-sm font-semibold">{pageTitle}</p>{dateLabel && <p className="truncate text-xs text-text-secondary">{dateLabel}</p>}</div>
          </div>
          <div className="flex shrink-0 items-center gap-2">{apiBasePath ? <PortalAccountMenu portal={portalLabel.startsWith('ADMIN') ? 'admin' : 'vendors'} basePath={apiBasePath} onNavigate={onNavigate} onSignOut={onSignOut} /> : headerActions}</div>
        </header>
        <main id="main-content" className="mx-auto max-w-[96rem] px-4 py-8 sm:px-6 lg:px-10 lg:py-10"><RateLimitNotice />{children}</main>
      </div>
    </div>
  )
}

export function StatusBadge({ label, tone = 'neutral' }: { label: string; tone?: 'neutral' | 'warning' | 'success' | 'error' | 'info' }) {
  const styles = {
    neutral: 'border-border-default bg-surface-primary text-text-secondary',
    warning: 'border-amber-300 bg-amber-50 text-amber-900',
    success: 'border-green-300 bg-green-50 text-green-900',
    error: 'border-red-300 bg-red-50 text-red-900',
    info: 'border-blue-300 bg-blue-50 text-blue-900',
  } as const
  return <span className={`inline-flex min-h-8 items-center gap-2 rounded-pill border px-3 text-xs font-semibold ${styles[tone]}`}><span className="h-2 w-2 rounded-full bg-current" aria-hidden="true" />{label}</span>
}

export function ProgressBar({ value, label }: { value: number; label: string }) {
  const bounded = Math.max(0, Math.min(100, value))
  return <div className="grid gap-2" aria-label={label}><div className="h-2 overflow-hidden rounded-pill bg-brand-orange-100"><div className="h-full rounded-pill bg-brand-orange-600 transition-[width] duration-200" style={{ width: `${bounded}%` }} /></div><p className="text-xs text-text-secondary">{label}</p></div>
}
