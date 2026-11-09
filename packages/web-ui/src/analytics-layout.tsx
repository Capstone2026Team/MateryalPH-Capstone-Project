import { useEffect, useId, useRef, useState, type ReactNode } from 'react'
import { MoreHorizontal } from 'lucide-react'
import { DashboardPanel } from './dashboard-patterns'
import { MetricTrend } from './metric-trend'
import { MetricHeadingActions } from './calculation-help'
import './analytics-layout.css'
import './kpi-card.css'
import './portal-card.css'

export type AnalyticsMetric = { label: string; value: ReactNode; hint?: ReactNode; icon?: ReactNode; changePercent?: number | null | undefined; comparison?: string; comparisonUnavailable?: string; calculation?: ReactNode }

/** Headline metrics share the same grouped surface as the rest of the portals. */
export function AnalyticsSummary({ featured, metrics, context, title, actions, embedded = false, density = 'comfortable' }: { featured: AnalyticsMetric; metrics: AnalyticsMetric[]; context?: ReactNode; title?: string; actions?: ReactNode; embedded?: boolean; density?: 'comfortable' | 'compact' }) {
  return <section aria-label="At a glance" data-density={density} data-embedded={embedded || undefined} className={`${embedded ? '' : 'mp-card mp-card-group '}mp-analytics-summary mp-viz`}>
    {(title || context || actions) && <header className="mp-analytics-summary-heading">{title && <h2>{title}</h2>}{context && <p>{context}</p>}{actions && <div className="mp-analytics-summary-actions">{actions}</div>}</header>}
    <dl className="mp-metric-card mp-metric-card-accent mp-analytics-feature"><dt className="mp-kpi-label"><span>{featured.label}</span><MetricHeadingActions title={featured.label} icon={featured.icon} calculation={featured.calculation} /></dt><dd className="mp-kpi-value mp-analytics-stat-value">{featured.value}</dd>{featured.hint && <dd className="mp-kpi-hint mp-analytics-metric-hint">{featured.hint}</dd>}<MetricChange metric={featured} /></dl>
    {metrics.map(metric => <dl key={metric.label} className="mp-metric-card mp-analytics-stat">
      <dt className="mp-kpi-label"><span>{metric.label}</span><MetricHeadingActions title={metric.label} icon={metric.icon} calculation={metric.calculation} /></dt><dd className="mp-kpi-value mp-analytics-stat-value">{metric.value}</dd>
      {metric.hint && <dd className="mp-kpi-hint mp-analytics-metric-hint">{metric.hint}</dd>}<MetricChange metric={metric} />
    </dl>)}
  </section>
}

function MetricChange({ metric }: { metric: AnalyticsMetric }) {
  return <MetricTrend changePercent={metric.changePercent} comparison={metric.comparison} unavailable={metric.comparisonUnavailable} />
}

/** Chart options stay attached to their chart without taking a permanent row for every explanation. */
export function AnalyticsControls({ title, children }: { title: string; children: ReactNode }) {
  const ref = useRef<HTMLDetailsElement>(null)
  const [open, setOpen] = useState(false)
  const id = useId()
  useEffect(() => {
    if (!open) return
    const dismiss = (event: PointerEvent) => { if (ref.current && !ref.current.contains(event.target as Node)) ref.current.open = false }
    document.addEventListener('pointerdown', dismiss)
    return () => document.removeEventListener('pointerdown', dismiss)
  }, [open])
  return <details ref={ref} className="mp-analytics-options" onToggle={event => setOpen(event.currentTarget.open)} onKeyDown={event => { if (event.key === 'Escape' && ref.current) { ref.current.open = false; ref.current.querySelector('summary')?.focus() } }}>
    <summary aria-label={`Chart details for ${title}`} aria-controls={id}><MoreHorizontal size={18} aria-hidden="true" /></summary>
    <div id={id} className="mp-analytics-options-panel"><p className="mp-analytics-options-title">{title} · Data &amp; details</p>{children}</div>
  </details>
}

export function AnalyticsChartCard({ title, description, details, calculation, children, wide = false }: { title: string; description?: string; details?: ReactNode; calculation?: ReactNode; children: ReactNode; wide?: boolean }) {
  return <DashboardPanel density="compact" wide={wide} title={title} {...(description ? { description } : {})} action={details ? <AnalyticsControls title={title}>{details}</AnalyticsControls> : undefined} calculation={calculation}>{children}</DashboardPanel>
}

/** The reference's two-column chart area and narrower operations column. Both stack in reading order. */
export function AnalyticsDashboardLayout({ children, aside, stretchAside = false }: { children: ReactNode; aside: ReactNode; stretchAside?: boolean }) {
  return <div data-stretch-aside={stretchAside || undefined} className={aside ? 'mp-analytics-layout' : 'mp-analytics-main'}><div className="mp-analytics-main">{children}</div>{aside && <aside className="mp-card-group mp-analytics-rail" aria-label="Operations and activity">{aside}</aside>}</div>
}

/** Stack related panels beside one tall panel, keeping both columns aligned when they fit. */
export function AnalyticsPanelColumns({ main, aside }: { main: ReactNode; aside: ReactNode }) {
  return <div className="mp-analytics-panel-columns" data-wide data-panel-columns><div>{main}</div><div>{aside}</div></div>
}
