import { EmptyState, PageHeader, StatCard, PortalPagePatterns } from './page-patterns'
import { usePortalIdentity } from './portal-identity'
import { useContext, type ReactNode } from 'react'
import { KpiCard } from './chart-patterns'
import { CalculationHelp } from './calculation-help'
import './portal-card.css'

import { ChartNoAxesCombined } from 'lucide-react'

/** Greets the signed-in person; falls back to a nameless greeting until the profile loads. */
export function DashboardHeader({ eyebrow, title, description, actions, status, minimal = false }: { eyebrow: string; title?: string; description: string; actions?: ReactNode; status?: ReactNode; minimal?: boolean }) {
  const name = usePortalIdentity()?.profile?.fullName?.trim()
  if (minimal) return <header className="flex min-w-0 flex-wrap items-center justify-between gap-3"><div className="flex min-w-0 items-center gap-3"><h1 className="text-xl font-semibold tracking-tight text-text-strong">{title ?? 'Dashboard'}</h1>{status}<span className="max-w-48 truncate text-xs text-text-secondary">{eyebrow}</span></div>{actions}</header>
  return <PageHeader compact eyebrow={eyebrow} title={title ?? (name ? `Welcome back, ${name}` : 'Welcome back')} description={description} actions={actions} status={status} />
}

export function MetricCard({ label, value, description, icon, accent = false, compact = false }: { label: string; value: ReactNode; description: string; icon?: ReactNode; accent?: boolean; compact?: boolean }) {
  return <KpiCard label={label} value={value} hint={description} icon={icon ?? <ChartNoAxesCombined size={16} />} accent={accent} density={compact ? 'compact' : 'comfortable'} />
}

export function DashboardPanel({ title, description, action, calculation, children, footer, density = 'comfortable', divided = false, wide = false, contentSized = false, scrollBody = false, embedded = false }: { title: string; description?: string; action?: ReactNode; calculation?: ReactNode; children: ReactNode; footer?: ReactNode; density?: 'comfortable' | 'compact'; divided?: boolean; wide?: boolean; contentSized?: boolean; scrollBody?: boolean; embedded?: boolean }) {
  return <section aria-label={title} data-density={density} data-wide={wide || undefined} data-content-sized={contentSized || undefined} data-scroll-body={scrollBody || undefined} data-header-divider={divided || undefined} data-embedded={embedded || undefined} className={`${embedded ? '' : 'mp-card '}mp-dashboard-panel flex h-full min-w-0 flex-col self-stretch`}><header data-calculation={calculation ? true : undefined} className="mp-card-header flex shrink-0 flex-wrap content-start items-start justify-between gap-3"><div className="min-w-0 flex-1"><h2 className="mp-card-heading">{title}</h2>{description && <p className="mt-1 text-xs leading-5 text-text-secondary">{description}</p>}</div>{action}{calculation && <CalculationHelp title={title}>{calculation}</CalculationHelp>}</header><div role={scrollBody ? 'region' : undefined} aria-label={scrollBody ? `${title} list` : undefined} tabIndex={scrollBody ? 0 : undefined} className={`mp-card-body mp-dashboard-panel-body min-w-0 flex-1${scrollBody ? ' focus-visible:outline-2 focus-visible:outline-offset-[-2px] focus-visible:outline-focus-ring' : ''}`}>{children}</div>{footer && <footer className="mp-card-footer">{footer}</footer>}</section>
}

export function DashboardEmptyState({ title, description }: { title: string; description: string }) {
  const consistent = useContext(PortalPagePatterns)
  if (consistent) return <EmptyState message={description} />
  return <div className="flex min-h-40 flex-col items-center justify-center gap-3 rounded-control border border-dashed border-border-default bg-surface-canvas p-5 text-center"><span className="grid h-10 w-10 place-items-center rounded-control border border-border-default bg-surface-primary text-text-secondary"><ChartNoAxesCombined size={20} aria-hidden="true" /></span><div><p className="text-sm font-semibold">{title}</p><p className="mx-auto mt-1 max-w-md text-xs leading-5 text-text-secondary">{description}</p></div></div>
}

export function DashboardPreviewSection({ title, description, labels }: { title: string; description: string; labels: string[] }) {
  const consistent = useContext(PortalPagePatterns)
  if (consistent) return <><dl className="mp-card-group grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{labels.slice(0, 4).map(label => <StatCard key={label} label={label} value="—" hint="Reporting not yet available" />)}</dl>{labels.length > 4 && <dl className="flex flex-wrap gap-4 text-sm">{labels.slice(4).map(label => <div key={label}><dt>{label}</dt><dd>—</dd></div>)}</dl>}<DashboardPanel title={title}><EmptyState message={description + ' Reporting is not yet available.'} /></DashboardPanel></>
  return <><p className="text-xs leading-5 text-text-secondary">Dashboard reporting is not yet available. Unavailable metrics are shown as —.</p><dl className="mp-card-group grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{labels.map(label => <MetricCard key={label} label={label} value="—" description="Reporting not yet available" />)}</dl><DashboardPanel title={title} description={description}><DashboardEmptyState title="Reporting not yet available" description="This dashboard summary is not connected to live operational data yet." /></DashboardPanel></>
}
