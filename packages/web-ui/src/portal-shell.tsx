import { RateLimitNotice } from './rate-limit-notice'
import { PortalAccountMenu } from './portal-account-menu'
import { useEffect, useState, type MouseEvent, type ReactNode } from 'react'
import { Circle, Menu, PanelLeftClose, PanelLeftOpen, X } from 'lucide-react'
import type { PortalIdentity } from './portal-identity'
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
  accountAvatarUrl,
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
  accountAvatarUrl?: string | null
  children: ReactNode
  headerActions?: ReactNode
  homeHref?: string
  onNavigate?: (href: string) => void
}) {
  const isAdmin = portalLabel.startsWith('ADMIN')
  const sidebarPreferenceKey = `materyalph:${isAdmin ? 'admin' : 'vendor'}:sidebar-collapsed`
  const [navigationOpen, setNavigationOpen] = useState(false)
  const [collapsed, setCollapsed] = useState(() => {
    try { return window.sessionStorage.getItem(sidebarPreferenceKey) === 'true' } catch { return false }
  })
  const [profile, setProfile] = useState<PortalIdentity | null>(null)
  const [avatarFailed, setAvatarFailed] = useState(false)
  const [tooltip, setTooltip] = useState<{ label: string; top: number; left: number } | null>(null)
  const storeIdentity = !isAdmin && profile?.role === 'OWNER'
  const footerName = storeIdentity ? profile.organizationName || accountLabel : profile?.fullName || accountLabel
  const footerStatus = isAdmin ? profile?.role.replaceAll('_', ' ') || accountStatus : accountStatus
  const initials = footerName.trim().split(/\s+/).slice(0, 2).map(part => part[0]).join('').toUpperCase()
  useEffect(() => { setAvatarFailed(false) }, [accountAvatarUrl])
  function showTooltip(element: HTMLElement, label: string) {
    if (!collapsed || !window.matchMedia('(min-width: 1024px)').matches) return
    const box = element.getBoundingClientRect()
    setTooltip({ label, top: Math.min(box.top + box.height / 2, window.innerHeight - 24), left: box.right + 12 })
  }
  function toggleSidebar() {
    const next = !collapsed
    setCollapsed(next)
    setTooltip(null)
    // Store only this presentation preference; storage may be unavailable in private contexts.
    try { window.sessionStorage.setItem(sidebarPreferenceKey, String(next)) } catch { /* The current view still works without persistence. */ }
  }
  useEffect(() => {
    const desktop = window.matchMedia?.('(min-width: 1024px)')
    if (!desktop) return
    const closeDrawer = () => { setNavigationOpen(false); setTooltip(null) }
    desktop.addEventListener('change', closeDrawer)
    return () => desktop.removeEventListener('change', closeDrawer)
  }, [])

  function follow(event: MouseEvent<HTMLAnchorElement>, href: string) {
    setNavigationOpen(false)
    setTooltip(null)
    // Account sections on the current page listen for the native hash change.
    const samePageSection = href.includes('#') && href.split('#')[0] === window.location.pathname
    if (onNavigate && !samePageSection && !event.ctrlKey && !event.metaKey && !event.shiftKey && !event.altKey && event.button === 0) { event.preventDefault(); onNavigate(href) }
  }

  return (
    <div className={`portal-layout ${collapsed ? 'is-collapsed' : ''} bg-surface-canvas text-text-strong`}>
      <aside id="portal-sidebar" className={`portal-sidebar ${navigationOpen ? 'is-open' : ''} bg-surface-primary`} aria-label={`${portalLabel} navigation`} onKeyDown={event => {
        if (event.key === 'Escape') { setTooltip(null); if (!navigationOpen) return; setNavigationOpen(false); requestAnimationFrame(() => document.getElementById('portal-navigation-toggle')?.focus()) }
        if (navigationOpen && event.key === 'Tab') {
          const targets = event.currentTarget.querySelectorAll<HTMLElement>('a[href], button:not(:disabled), [tabindex="0"]')
          const visible = [...targets].filter(element => element.getClientRects().length > 0)
          const first = visible[0], last = visible[visible.length - 1]
          if (event.shiftKey && document.activeElement === first) { event.preventDefault(); last?.focus() }
          if (!event.shiftKey && document.activeElement === last) { event.preventDefault(); first?.focus() }
        }
      }}>
        <div className="portal-sidebar-content">
          <div className="portal-sidebar-header">
            <a aria-label={`MateryalPH ${portalLabel}`} className="portal-wordmark no-underline" href={homeHref} onClick={event => follow(event, homeHref)}>
              <span className="portal-brand-full"><span className="portal-brand-name">Materyal<span className="text-action-primary">PH</span></span><span className="portal-brand-label">{portalLabel}</span></span>
              <span className="portal-brand-short" aria-hidden="true">M<span className="text-action-primary">PH</span></span>
            </a>
            <button className="portal-collapse-toggle portal-icon-control" type="button" aria-label={collapsed ? 'Expand sidebar' : 'Collapse sidebar'} aria-expanded={!collapsed} aria-controls="portal-navigation" title={collapsed ? 'Expand sidebar' : undefined} onClick={toggleSidebar}>{collapsed ? <PanelLeftOpen size={18} aria-hidden="true" /> : <PanelLeftClose size={18} aria-hidden="true" />}</button>
            <button className="portal-drawer-toggle portal-icon-control" type="button" aria-label="Close navigation" onClick={() => { setNavigationOpen(false); requestAnimationFrame(() => document.getElementById('portal-navigation-toggle')?.focus()) }}><X size={20} aria-hidden="true" /></button>
          </div>
          <nav id="portal-navigation" className="portal-nav" aria-label={`${portalLabel} menu`} onScroll={() => setTooltip(null)}>
            {sections.filter(section => section.items.length > 0).map(section => <section key={section.label} aria-label={section.label}>
              <h2 className="portal-nav-label">{section.label}</h2>
              <div>
                {section.items.map(item => {
                  const content = <><span className="portal-nav-icon" aria-hidden="true">{item.icon ?? <Circle />}</span><span className="portal-nav-text">{item.label}</span></>
                  const hints = { onMouseEnter: (event: MouseEvent<HTMLElement>) => showTooltip(event.currentTarget, item.label), onMouseLeave: () => setTooltip(null), onBlur: () => setTooltip(null) }
                  return item.disabled
                    ? <span key={item.href} role="link" tabIndex={0} aria-label={`${item.label}, unavailable`} aria-disabled="true" className="portal-nav-row" {...hints}>{content}</span>
                    : <a key={item.href} className="portal-nav-row" href={item.href} aria-label={item.label} aria-current={item.href === activeHref ? 'page' : undefined} onClick={event => follow(event, item.href)} {...hints}>{content}</a>
                })}
              </div>
            </section>)}
          </nav>
          <div className="portal-sidebar-footer">
            <a className="portal-footer-account" href={isAdmin ? '/workspace#Profile' : '/settings#Profile'} aria-label={`Account profile: ${footerName}${footerStatus ? `, ${footerStatus}` : ''}`} onClick={event => follow(event, isAdmin ? '/workspace#Profile' : '/settings#Profile')} onMouseEnter={event => showTooltip(event.currentTarget, footerName)} onMouseLeave={() => setTooltip(null)} onBlur={() => setTooltip(null)}>
              <span className="portal-footer-avatar" aria-hidden="true">{accountAvatarUrl && !avatarFailed ? <img src={accountAvatarUrl} alt="" onError={() => setAvatarFailed(true)} /> : initials || '…'}</span>
              <span className="portal-footer-details"><span className="portal-footer-name">{footerName}</span>{footerStatus && <span className="portal-footer-status">{footerStatus}</span>}</span>
            </a>
          </div>
        </div>
      </aside>
      {collapsed && tooltip && <span className="portal-nav-tooltip" role="tooltip" style={{ top: tooltip.top, left: tooltip.left }}>{tooltip.label}</span>}
      <div className="portal-workspace min-w-0" inert={navigationOpen}>
        <header className="sticky top-0 z-30 flex min-h-16 items-center justify-between gap-4 border-b border-border-default bg-surface-primary px-4 sm:px-6 lg:px-8">
          <div className="flex min-w-0 items-center gap-3">
            <button id="portal-navigation-toggle" className="portal-drawer-toggle inline-flex min-h-11 min-w-11 items-center justify-center rounded-control text-text-strong" type="button" aria-label="Open navigation" aria-expanded={navigationOpen} aria-controls="portal-sidebar" onClick={() => { setNavigationOpen(true); requestAnimationFrame(() => document.querySelector<HTMLButtonElement>('[aria-label="Close navigation"]')?.focus()) }}><Menu size={20} aria-hidden="true" /></button>
            {dateLabel && <p className="text-xs text-text-secondary" aria-label="System date">{dateLabel}</p>}
          </div>
          <div className="flex shrink-0 items-center gap-2">{apiBasePath ? <PortalAccountMenu onProfileChange={setProfile} portal={portalLabel.startsWith('ADMIN') ? 'admin' : 'vendors'} basePath={apiBasePath} onNavigate={onNavigate} onSignOut={onSignOut} /> : headerActions}</div>
        </header>
        <main id="main-content" className="mx-auto max-w-[96rem] px-4 py-6 sm:px-6 lg:px-8 lg:py-8"><RateLimitNotice />{children}</main>
      </div>
    </div>
  )
}

export function StatusBadge({ label, tone = 'neutral', icon }: { label: string; tone?: 'neutral' | 'warning' | 'success' | 'error' | 'info'; icon?: ReactNode }) {
  const styles = {
    neutral: 'border-border-default bg-surface-primary text-text-secondary',
    warning: 'border-amber-300 bg-amber-50 text-amber-900',
    success: 'border-green-300 bg-green-50 text-green-900',
    error: 'border-red-300 bg-red-50 text-red-900',
    info: 'border-blue-300 bg-blue-50 text-blue-900',
  } as const
  return <span className={`inline-flex min-h-8 items-center gap-2 rounded-pill border px-3 text-xs font-semibold ${styles[tone]}`}>{icon ?? <span className="h-2 w-2 rounded-full bg-current" aria-hidden="true" />}{label}</span>
}

export function ProgressBar({ value, label }: { value: number; label: string }) {
  const bounded = Math.max(0, Math.min(100, value))
  return <div className="grid gap-2" aria-label={label}><div className="h-2 overflow-hidden rounded-pill bg-brand-orange-100"><div className="h-full rounded-pill bg-brand-orange-600 transition-[width] duration-200" style={{ width: `${bounded}%` }} /></div><p className="text-xs text-text-secondary">{label}</p></div>
}
