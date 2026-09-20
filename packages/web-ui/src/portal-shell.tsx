import { RateLimitNotice } from './rate-limit-notice'
import { PortalAccountMenu } from './portal-account-menu'
import { useEffect, useState, type MouseEvent, type ReactNode } from 'react'
import { Menu, X } from 'lucide-react'
import './portal-shell.css'

export type PortalNavItem = { label: string; href: string; icon?: ReactNode; disabled?: boolean }
export type PortalNavSection = { label: string; items: PortalNavItem[] }

export function PortalShell({
  portalLabel,
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
  useEffect(() => {
    const desktop = window.matchMedia?.('(min-width: 1024px) and (min-height: 800px)')
    if (!desktop) return
    const closeDrawer = () => setNavigationOpen(false)
    desktop.addEventListener('change', closeDrawer)
    return () => desktop.removeEventListener('change', closeDrawer)
  }, [])

  function follow(event: MouseEvent<HTMLAnchorElement>, href: string) {
    setNavigationOpen(false)
    if (onNavigate && !event.ctrlKey && !event.metaKey && !event.shiftKey && !event.altKey && event.button === 0) { event.preventDefault(); onNavigate(href) }
  }

  return (
    <div className="portal-layout bg-surface-canvas text-text-strong">
      <aside className={`portal-sidebar ${navigationOpen ? 'is-open' : ''} bg-surface-primary`} aria-label={`${portalLabel} navigation`} onKeyDown={event => {
        if (event.key === 'Escape') { setNavigationOpen(false); requestAnimationFrame(() => document.getElementById('portal-navigation-toggle')?.focus()) }
        if (navigationOpen && event.key === 'Tab') {
          const targets = event.currentTarget.querySelectorAll<HTMLElement>('a[href], button:not(:disabled)')
          const first = targets[0], last = targets[targets.length - 1]
          if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last?.focus() }
          if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first?.focus() }
        }
      }}>
        <div className="portal-sidebar-content">
          <div className="flex min-h-14 items-center px-5">
            <a aria-label={`MateryalPH ${portalLabel}`} className="no-underline" href={homeHref} onClick={event => follow(event, homeHref)}><span className="block text-2xl font-bold tracking-tight text-text-strong">Materyal<span className="text-action-primary">PH</span></span><span className="mt-1 block text-[0.625rem] font-semibold tracking-[0.14em] text-text-secondary">{portalLabel}</span></a>
            <button className="portal-drawer-toggle ml-auto inline-flex min-h-11 min-w-11 items-center justify-center rounded-control text-text-secondary" type="button" aria-label="Close navigation" onClick={() => { setNavigationOpen(false); requestAnimationFrame(() => document.getElementById('portal-navigation-toggle')?.focus()) }}><X size={20} aria-hidden="true" /></button>
          </div>
          <nav className="portal-nav">
            {sections.filter(section => section.items.length > 0).map((section) => <section key={section.label} aria-label={section.label}>
              <h2 className="portal-nav-label">{section.label}</h2>
              <div>
                {section.items.map((item) => item.disabled ? <span key={item.href} aria-disabled="true" className="portal-nav-row text-text-secondary opacity-60">{item.icon}<span>{item.label}</span><span className="sr-only">Unavailable</span></span> : <a key={item.href} className={`portal-nav-row rounded-control no-underline transition-colors ${item.href === activeHref ? 'bg-brand-orange-50 font-semibold text-action-primary' : 'text-text-secondary hover:bg-surface-canvas hover:text-text-strong'}`} href={item.href} aria-current={item.href === activeHref ? 'page' : undefined} onClick={event => follow(event, item.href)}>{item.icon}<span>{item.label}</span></a>)}
              </div>
            </section>)}
          </nav>
          <div className="border-t border-border-default px-5 py-2">
            <p className="truncate text-sm font-semibold">{accountLabel}</p>
            {accountStatus && <p className="mt-1 text-xs text-text-secondary">{accountStatus}</p>}
          </div>
        </div>
      </aside>
      <div className="portal-workspace min-w-0" inert={navigationOpen}>
        <header className="sticky top-0 z-30 flex min-h-16 items-center justify-between gap-4 border-b border-border-default bg-surface-primary px-4 sm:px-6 lg:px-8">
          <div className="flex min-w-0 items-center gap-3">
            <button id="portal-navigation-toggle" className="portal-drawer-toggle inline-flex min-h-11 min-w-11 items-center justify-center rounded-control text-text-strong" type="button" aria-label="Open navigation" aria-expanded={navigationOpen} onClick={() => { setNavigationOpen(true); requestAnimationFrame(() => document.querySelector<HTMLButtonElement>('[aria-label="Close navigation"]')?.focus()) }}><Menu size={20} aria-hidden="true" /></button>
            {dateLabel && <p className="text-xs text-text-secondary" aria-label="System date">{dateLabel}</p>}
          </div>
          <div className="flex shrink-0 items-center gap-2">{apiBasePath ? <PortalAccountMenu portal={portalLabel.startsWith('ADMIN') ? 'admin' : 'vendors'} basePath={apiBasePath} onNavigate={onNavigate} onSignOut={onSignOut} /> : headerActions}</div>
        </header>
        <main id="main-content" className="mx-auto max-w-[96rem] px-4 py-6 sm:px-6 lg:px-8 lg:py-8"><RateLimitNotice />{children}</main>
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
