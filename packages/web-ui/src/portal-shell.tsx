import { useState, type ReactNode } from 'react'

export type PortalNavItem = { label: string; href: string; icon?: ReactNode }
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
}: {
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
}) {
  const [navigationOpen, setNavigationOpen] = useState(false)

  return (
    <div className="min-h-screen bg-surface-canvas text-text-strong md:grid md:grid-cols-[16rem_minmax(0,1fr)]">
      <aside className={`${navigationOpen ? 'block' : 'hidden'} fixed inset-0 z-40 bg-surface-primary md:static md:block md:border-r md:border-border-default`} aria-label={`${portalLabel} navigation`}>
        <div className="flex min-h-full flex-col">
          <div className="flex min-h-24 items-center border-b border-border-default px-6">
            <a className="no-underline" href={homeHref} onClick={() => setNavigationOpen(false)}><span className="inline-flex items-center gap-3 text-sm font-semibold text-text-strong"><img className="h-10 w-10 shrink-0 object-contain" src="/brand/materyalph-logo.png" alt="MateryalPH" width={40} height={40} /><span className="border-l border-border-default pl-3">{portalLabel}</span></span></a>
            <button className="ml-auto inline-flex min-h-11 items-center justify-center rounded-control px-3 text-sm font-semibold text-text-secondary md:hidden" type="button" aria-label="Close navigation" onClick={() => setNavigationOpen(false)}>Close</button>
          </div>
          <nav className="flex-1 space-y-6 px-4 py-6">
            {sections.map((section) => <div key={section.label}>
              <p className="px-3 text-[0.6875rem] font-semibold uppercase tracking-[0.12em] text-text-secondary">{section.label}</p>
              <div className="mt-2 grid gap-1">
                {section.items.map((item) => <a key={item.href} className={`flex min-h-11 items-center gap-3 rounded-control px-3 text-sm font-semibold no-underline transition-colors ${item.href === activeHref ? 'bg-brand-orange-500 text-white' : 'text-text-secondary hover:bg-brand-orange-50 hover:text-text-strong'}`} href={item.href} aria-current={item.href === activeHref ? 'page' : undefined} onClick={() => setNavigationOpen(false)}>{item.icon}<span>{item.label}</span></a>)}
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
        <header className="sticky top-0 z-30 flex min-h-20 items-center justify-between gap-4 border-b border-border-default bg-surface-primary px-4 sm:px-6 lg:px-8">
          <div className="flex min-w-0 items-center gap-3">
            <button className="inline-flex min-h-11 items-center justify-center rounded-control border border-border-default px-3 text-sm font-semibold text-text-strong md:hidden" type="button" aria-label="Open navigation" aria-expanded={navigationOpen} onClick={() => setNavigationOpen(true)}>Menu</button>
            <div className="min-w-0"><p className="truncate text-sm font-semibold">{pageTitle}</p>{dateLabel && <p className="truncate text-xs text-text-secondary">{dateLabel}</p>}</div>
          </div>
          {headerActions && <div className="flex shrink-0 items-center gap-2">{headerActions}</div>}
        </header>
        <main id="main-content" className="mx-auto max-w-[96rem] px-4 py-8 sm:px-6 lg:px-10 lg:py-10">{children}</main>
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
