import type { ReactNode } from 'react'
import { AlertTriangle, Info, Lightbulb } from 'lucide-react'
import { DashboardPanel } from './dashboard-patterns'
import { MethodNote } from './chart-patterns'
import type { VizColor } from './geo-analytics-patterns'

/*
 * Analytics building blocks shared by the portals' insight pages. Every panel states what it is for (purpose) and how
 * it is calculated (method), every ranked value is printed as text, and priority is always an icon plus a word.
 */

/** A dashboard panel that always explains itself: the purpose under the title and the method in a collapsible note. */
export function InsightPanel({ title, purpose, method, action, children }: { title: string; purpose: string; method?: ReactNode; action?: ReactNode; children: ReactNode }) {
  return <DashboardPanel title={title} description={purpose} action={action}>
    <div className="grid gap-4">{children}{method && <MethodNote>{method}</MethodNote>}</div>
  </DashboardPanel>
}

export type RankedItem = { key: string; label: ReactNode; title: string; meta?: string | null; value: string; detail?: string | null; share?: number | null }

/**
 * A numbered top-N list. The rank, the name and the value are text; the optional bar shows each value's share of the
 * leader and only reinforces the printed number.
 */
export function RankedList({ label, items, empty, colorVar = '--mp-viz-series-1' }: { label: string; items: RankedItem[]; empty: string; colorVar?: VizColor }) {
  if (items.length === 0) return <p className="rounded-control border border-dashed border-border-default px-4 py-6 text-center text-sm text-text-secondary">{empty}</p>
  return <ol aria-label={label} className="mp-viz grid gap-2">{items.map((item, index) => <li key={item.key} className="grid grid-cols-[auto_minmax(0,1fr)_auto] items-center gap-x-3 gap-y-1 rounded-control bg-surface-canvas px-3 py-2.5">
    <span aria-hidden="true" className="grid h-7 w-7 place-items-center rounded-pill bg-brand-orange-50 text-xs font-semibold tabular-nums text-action-primary">{index + 1}</span>
    <span className="min-w-0"><span className="sr-only">Rank {index + 1}: </span><span className="line-clamp-2 wrap-break-word text-sm font-semibold leading-5 text-text-strong" title={item.title}>{item.label}</span>
      {item.meta && <span className="block truncate text-xs text-text-secondary">{item.meta}</span>}</span>
    <span className="shrink-0 whitespace-nowrap text-right"><span className="block text-sm font-semibold tabular-nums text-text-strong">{item.value}</span>{item.detail && <span className="block text-xs tabular-nums text-text-secondary">{item.detail}</span>}</span>
    {item.share !== null && item.share !== undefined && <span aria-hidden="true" className="col-span-3 col-start-1 h-1.5 rounded-pill bg-surface-primary"><span className="block h-1.5 rounded-pill" style={{ width: `${Math.max(2, Math.min(100, item.share * 100))}%`, background: `var(${colorVar})` }} /></span>}
  </li>)}</ol>
}

export type InsightPriority = 'HIGH' | 'MEDIUM' | 'LOW'
export type InsightItem = { key: string; priority: InsightPriority; title: string; detail: string; technique: string; action?: ReactNode }

const PRIORITY: Record<InsightPriority, { label: string; icon: typeof Info; className: string }> = {
  HIGH: { label: 'Act now', icon: AlertTriangle, className: 'border-status-error text-text-strong' },
  MEDIUM: { label: 'Worth doing', icon: Lightbulb, className: 'border-brand-orange-500 text-text-strong' },
  LOW: { label: 'Consider', icon: Info, className: 'border-border-default text-text-secondary' },
}

/** Data-driven suggestions, most urgent first, each naming the technique it came from and linking to where to act. */
export function InsightList({ items, empty }: { items: InsightItem[]; empty: string }) {
  if (items.length === 0) return <p className="rounded-control border border-dashed border-border-default px-4 py-6 text-center text-sm text-text-secondary">{empty}</p>
  return <ul className="grid gap-3 md:grid-cols-2">{items.map(item => {
    const meta = PRIORITY[item.priority]
    const Icon = meta.icon
    return <li key={item.key} className="flex min-w-0 flex-col gap-2 rounded-control border border-border-default bg-surface-primary p-4">
      <span className={`inline-flex w-fit items-center gap-1.5 rounded-pill border-2 px-2.5 py-0.5 text-xs font-semibold ${meta.className}`}><Icon size={14} aria-hidden="true" />{meta.label}</span>
      <p className="text-sm font-semibold text-text-strong">{item.title}</p>
      <p className="text-sm leading-6 text-text-secondary">{item.detail}</p>
      <p className="text-xs text-text-secondary"><span className="font-semibold text-text-strong">Based on:</span> {item.technique}</p>
      {item.action && <div className="mt-auto pt-1">{item.action}</div>}
    </li>
  })}</ul>
}

/** Progress toward a published minimum (for example ratings needed before a score appears), with the count as text. */
export function SampleMeter({ label, value, minimum }: { label: string; value: number; minimum: number }) {
  const ratio = minimum <= 0 ? 1 : Math.min(1, value / minimum)
  return <div className="grid gap-1">
    <div role="meter" aria-label={label} aria-valuemin={0} aria-valuemax={minimum} aria-valuenow={Math.min(value, minimum)} aria-valuetext={`${value} of ${minimum}`} className="h-1.5 rounded-pill bg-surface-canvas">
      <div className="h-1.5 rounded-pill bg-action-primary" style={{ width: `${Math.max(ratio > 0 ? 4 : 0, ratio * 100)}%` }} />
    </div>
    <p className="text-xs tabular-nums text-text-secondary">{value >= minimum ? `Minimum met (${value} of ${minimum})` : `${value} of ${minimum} needed`}</p>
  </div>
}
