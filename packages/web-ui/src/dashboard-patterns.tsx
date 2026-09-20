import type { ReactNode } from 'react'

import { ChartNoAxesCombined } from 'lucide-react'

export function DashboardHeader({ eyebrow, title = 'Dashboard', description, actions, status }: { eyebrow: string; title?: string; description: string; actions?: ReactNode; status?: ReactNode }) {
  return <header className="flex min-h-32 flex-col justify-center gap-5 border-b border-border-default pb-6 lg:flex-row lg:items-center lg:justify-between"><div className="min-w-0 max-w-3xl"><p className="text-xs font-semibold uppercase tracking-widest text-action-primary">{eyebrow}</p><div className="mt-2 flex flex-wrap items-center gap-3"><h1 className="text-3xl font-semibold tracking-tight text-text-strong">{title}</h1>{status}</div><p className="mt-3 text-sm leading-6 text-text-secondary">{description}</p></div>{actions && <div className="flex shrink-0 flex-wrap items-center gap-3">{actions}</div>}</header>
}

export function MetricCard({ label, value, description }: { label: string; value: ReactNode; description: string }) {
  return <div className="flex min-h-44 flex-col rounded-surface border border-border-default bg-surface-primary p-5 shadow-sm"><dt className="flex min-h-10 items-start justify-between gap-3 text-sm font-semibold leading-5"><span>{label}</span><span className="grid h-8 w-8 shrink-0 place-items-center rounded-full bg-brand-orange-50"><ChartNoAxesCombined size={18} aria-hidden="true" /></span></dt><dd className="mt-3 text-3xl font-semibold leading-none tabular-nums tracking-tight">{value}</dd><p className="mt-4 text-xs leading-5 text-text-secondary">{description}</p></div>
}
