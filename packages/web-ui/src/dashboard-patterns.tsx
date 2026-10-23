import { EmptyState, PageHeader, StatCard, PortalPagePatterns } from './page-patterns'
import { usePortalIdentity } from './portal-identity'
import { useContext, type ReactNode } from 'react'

import { ChartNoAxesCombined } from 'lucide-react'

/** Greets the signed-in person; falls back to a nameless greeting until the profile loads. */
export function DashboardHeader({ eyebrow, title, description, actions, status }: { eyebrow: string; title?: string; description: string; actions?: ReactNode; status?: ReactNode }) {
  const name = usePortalIdentity()?.profile?.fullName?.trim()
  return <PageHeader compact eyebrow={eyebrow} title={title ?? (name ? `Welcome back, ${name}` : 'Welcome back')} description={description} actions={actions} status={status} />
}

export function MetricCard({ label, value, description, icon, accent = false, compact = false }: { label: string; value: ReactNode; description: string; icon?: ReactNode; accent?: boolean; compact?: boolean }) {
  const consistent = useContext(PortalPagePatterns)
  if (consistent) return <StatCard label={label} value={value} hint={description} icon={icon} />
  return <div className={`flex min-w-0 flex-col rounded-surface border border-border-default border-t-2 bg-surface-primary ${compact ? 'p-4' : 'p-5'} ${accent ? 'border-t-brand-orange-500' : 'border-t-border-default'}`}><dt className={`flex items-start justify-between gap-3 text-xs font-semibold leading-5 text-text-secondary ${compact ? '' : 'min-h-10'}`}><span>{label}</span>{!compact && <span className="grid h-8 w-8 shrink-0 place-items-center rounded-control bg-brand-orange-50 text-action-primary">{icon ?? <ChartNoAxesCombined size={16} aria-hidden="true" />}</span>}</dt><dd className={`${compact ? 'mt-1 text-2xl' : 'mt-3 text-3xl'} break-words font-semibold leading-tight tabular-nums tracking-tight text-text-strong`}>{value}</dd><dd className="mt-2 text-xs leading-5 text-text-secondary">{description}</dd></div>
}

export function DashboardPanel({ title, description, action, children }: { title: string; description?: string; action?: ReactNode; children: ReactNode }) {
  return <section aria-label={title} className="min-w-0 rounded-surface border border-border-default bg-surface-primary"><header className="flex flex-wrap items-start justify-between gap-3 border-b border-border-default px-5 py-4"><div className="min-w-0"><h2 className="text-sm font-semibold text-text-strong">{title}</h2>{description && <p className="mt-1 text-xs leading-5 text-text-secondary">{description}</p>}</div>{action}</header><div className="p-5">{children}</div></section>
}

export function DashboardEmptyState({ title, description }: { title: string; description: string }) {
  const consistent = useContext(PortalPagePatterns)
  if (consistent) return <EmptyState message={description} />
  return <div className="flex min-h-40 flex-col items-center justify-center gap-3 rounded-control border border-dashed border-border-default bg-surface-canvas p-5 text-center"><span className="grid h-10 w-10 place-items-center rounded-control border border-border-default bg-surface-primary text-text-secondary"><ChartNoAxesCombined size={20} aria-hidden="true" /></span><div><p className="text-sm font-semibold">{title}</p><p className="mx-auto mt-1 max-w-md text-xs leading-5 text-text-secondary">{description}</p></div></div>
}

export function DashboardPreviewSection({ title, description, labels }: { title: string; description: string; labels: string[] }) {
  const consistent = useContext(PortalPagePatterns)
  if (consistent) return <><dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{labels.slice(0, 4).map(label => <StatCard key={label} label={label} value="—" hint="Reporting not yet available" />)}</dl>{labels.length > 4 && <dl className="flex flex-wrap gap-4 text-sm">{labels.slice(4).map(label => <div key={label}><dt>{label}</dt><dd>—</dd></div>)}</dl>}<DashboardPanel title={title}><EmptyState message={description + ' Reporting is not yet available.'} /></DashboardPanel></>
  return <><p className="text-xs leading-5 text-text-secondary">Dashboard reporting is not yet available. Unavailable metrics are shown as —.</p><dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{labels.map(label => <MetricCard key={label} label={label} value="—" description="Reporting not yet available" />)}</dl><DashboardPanel title={title} description={description}><DashboardEmptyState title="Reporting not yet available" description="This dashboard summary is not connected to live operational data yet." /></DashboardPanel></>
}
