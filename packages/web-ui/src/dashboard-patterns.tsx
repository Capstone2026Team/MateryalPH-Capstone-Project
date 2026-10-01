import type { ReactNode } from 'react'

import { ChartNoAxesCombined } from 'lucide-react'

export function DashboardHeader({ eyebrow, title = 'Dashboard', description, actions, status }: { eyebrow: string; title?: string; description: string; actions?: ReactNode; status?: ReactNode }) {
  return <header className="flex flex-col justify-center gap-5 rounded-surface border border-border-default border-l-4 border-l-brand-orange-500 bg-surface-primary p-5 sm:p-6 lg:flex-row lg:items-center lg:justify-between"><div className="min-w-0 max-w-3xl"><p className="text-xs font-semibold uppercase tracking-widest text-action-primary">{eyebrow}</p><div className="mt-2 flex flex-wrap items-center gap-3"><h1 className="break-words text-2xl font-semibold tracking-tight text-text-strong sm:text-3xl">{title}</h1>{status}</div><p className="mt-2 text-sm leading-6 text-text-secondary">{description}</p></div>{actions && <div className="flex shrink-0 flex-wrap items-center gap-3">{actions}</div>}</header>
}

export function MetricCard({ label, value, description, icon, accent = false }: { label: string; value: ReactNode; description: string; icon?: ReactNode; accent?: boolean }) {
  return <div className={`flex min-w-0 flex-col rounded-surface border border-border-default border-t-2 bg-surface-primary p-5 ${accent ? 'border-t-brand-orange-500' : 'border-t-border-default'}`}><dt className="flex min-h-10 items-start justify-between gap-3 text-xs font-semibold leading-5 text-text-secondary"><span>{label}</span><span className="grid h-8 w-8 shrink-0 place-items-center rounded-control bg-brand-orange-50 text-action-primary">{icon ?? <ChartNoAxesCombined size={16} aria-hidden="true" />}</span></dt><dd className="mt-3 break-words text-3xl font-semibold leading-tight tabular-nums tracking-tight text-text-strong">{value}</dd><dd className="mt-2 text-xs leading-5 text-text-secondary">{description}</dd></div>
}

export function DashboardPanel({ title, description, action, children }: { title: string; description?: string; action?: ReactNode; children: ReactNode }) {
  return <section aria-label={title} className="min-w-0 rounded-surface border border-border-default bg-surface-primary"><header className="flex flex-wrap items-start justify-between gap-3 border-b border-border-default px-5 py-4"><div className="min-w-0"><h2 className="text-sm font-semibold text-text-strong">{title}</h2>{description && <p className="mt-1 text-xs leading-5 text-text-secondary">{description}</p>}</div>{action}</header><div className="p-5">{children}</div></section>
}

export function DashboardEmptyState({ title, description }: { title: string; description: string }) {
  return <div className="flex min-h-40 flex-col items-center justify-center gap-3 rounded-control border border-dashed border-border-default bg-surface-canvas p-5 text-center"><span className="grid h-10 w-10 place-items-center rounded-control border border-border-default bg-surface-primary text-text-secondary"><ChartNoAxesCombined size={20} aria-hidden="true" /></span><div><p className="text-sm font-semibold">{title}</p><p className="mx-auto mt-1 max-w-md text-xs leading-5 text-text-secondary">{description}</p></div></div>
}

export function DashboardPreviewSection({ title, description, labels }: { title: string; description: string; labels: string[] }) {
  return <><p className="text-xs leading-5 text-text-secondary">Dashboard reporting is not yet available. Unavailable metrics are shown as —.</p><dl className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{labels.map(label => <MetricCard key={label} label={label} value="—" description="Reporting not yet available" />)}</dl><DashboardPanel title={title} description={description}><DashboardEmptyState title="Reporting not yet available" description="This dashboard summary is not connected to live operational data yet." /></DashboardPanel></>
}
