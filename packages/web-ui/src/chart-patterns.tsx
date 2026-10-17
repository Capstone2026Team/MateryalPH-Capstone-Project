import { useId, useMemo, useState, type KeyboardEvent, type ReactNode } from 'react'
import { AlertTriangle, ArrowDownRight, ArrowRight, ArrowUpRight, CheckCircle2, Eye, Info, Minus, Sprout } from 'lucide-react'
import { niceCeiling, useMeasuredWidth, type VizColor } from './geo-analytics-patterns'
import { chartLeftInset, chartMinimumWidth, chartTicks } from './chart-layout'
import './geo-analytics.css'

/*
 * Dashboard chart primitives shared by the Vendor and Admin portals. Every chart states its values as text (printed
 * labels, a live focus line or a table view), so no meaning depends on colour; categorical colours follow the fixed
 * validated slot order in geo-analytics.css; status colours appear only beside an icon and a label.
 */

const compactPeso = new Intl.NumberFormat('en-PH', { style: 'currency', currency: 'PHP', notation: 'compact', maximumFractionDigits: 1 })
const compactNumber = new Intl.NumberFormat('en-PH', { notation: 'compact', maximumFractionDigits: 1 })
const wholeNumber = new Intl.NumberFormat('en-PH', { maximumFractionDigits: 1 })
const shortDay = new Intl.DateTimeFormat('en-PH', { month: 'short', day: 'numeric', timeZone: 'UTC' })
const shortMonth = new Intl.DateTimeFormat('en-PH', { month: 'short', year: 'numeric', timeZone: 'UTC' })

/** Integer centavos to a short axis label such as ₱1.2M; exact values use formatPesoCentavos. */
export function formatCompactCentavos(centavos: number | null | undefined): string {
  if (centavos === null || centavos === undefined) return '—'
  return compactPeso.format(centavos / 100)
}

export function formatCount(value: number | null | undefined, compact = false): string {
  if (value === null || value === undefined) return '—'
  return compact ? compactNumber.format(value) : wholeNumber.format(value)
}

/** A calendar day (YYYY-MM-DD) as "Oct 9"; the day is not shifted by the viewer's timezone. */
export function formatChartDay(day: string): string {
  const parsed = new Date(`${day.slice(0, 10)}T00:00:00Z`)
  return Number.isNaN(parsed.getTime()) ? day : shortDay.format(parsed)
}

/** A month bucket's first day (YYYY-MM-DD) as "Oct 2026"; the month is not shifted by the viewer's timezone. */
export function formatChartMonth(day: string): string {
  const parsed = new Date(`${day.slice(0, 7)}-01T00:00:00Z`)
  return Number.isNaN(parsed.getTime()) ? day : shortMonth.format(parsed)
}

/** Seconds as "45 min", "3.2 h" or "2.1 days". */
export function formatDurationSeconds(seconds: number | null | undefined): string {
  if (seconds === null || seconds === undefined) return '—'
  if (seconds < 3600) return `${Math.max(1, Math.round(seconds / 60))} min`
  if (seconds < 172800) return `${(seconds / 3600).toFixed(1)} h`
  return `${(seconds / 86400).toFixed(1)} days`
}

export type KpiDelta = { changePercent: number | null | undefined; periodLabel: string }

/** One line of a card's calculation. The amount is already formatted; a deduction carries its own minus sign, so the sum reads without colour. */
export type KpiBreakdownRow = { key: string; label: ReactNode; amount: string; total?: boolean }
export type KpiBreakdownData = { caption: string; rows: readonly KpiBreakdownRow[] }

/**
 * One headline number with its change against the previous equal period, an optional sparkline and, when given, the
 * calculation behind the number. The change is text plus an arrow icon in neutral ink: whether a rise is good depends
 * on the measure, so colour never judges it. The breakdown sits at the bottom so cards in one row line up.
 */
export function KpiCard({ label, value, hint, icon, delta, sparkline, breakdown, accent = false }: { label: string; value: ReactNode; hint?: ReactNode; icon?: ReactNode; delta?: KpiDelta | null; sparkline?: (number | null)[]; breakdown?: KpiBreakdownData; accent?: boolean }) {
  const change = delta?.changePercent
  const Icon = change === null || change === undefined || change === 0 ? Minus : change > 0 ? ArrowUpRight : ArrowDownRight
  return <div className={`mp-viz flex min-w-0 flex-col rounded-surface border border-border-default border-t-2 bg-surface-primary p-5 ${accent ? 'border-t-brand-orange-500' : 'border-t-border-default'}`}>
    <dt className="flex min-h-10 items-start justify-between gap-3 text-xs font-semibold leading-5 text-text-secondary"><span>{label}</span>{icon && <span className="grid h-8 w-8 shrink-0 place-items-center rounded-control bg-brand-orange-50 text-action-primary">{icon}</span>}</dt>
    <dd className="mt-2 break-words text-3xl font-semibold leading-tight tracking-tight text-text-strong">{value}</dd>
    {delta && <dd className="mt-2 inline-flex items-center gap-1 text-xs font-semibold text-text-strong"><Icon size={14} aria-hidden="true" />
      {change === null || change === undefined ? `No ${delta.periodLabel} to compare` : `${change > 0 ? '+' : ''}${change.toFixed(1)}% vs ${delta.periodLabel}`}</dd>}
    {hint && <dd className="mt-1 text-xs leading-5 text-text-secondary">{hint}</dd>}
    {sparkline && sparkline.some(point => point !== null) && <dd className="mt-3" aria-hidden="true"><Sparkline values={sparkline} /></dd>}
    {breakdown && <dd className="mt-auto pt-4"><KpiBreakdown {...breakdown} /></dd>}
  </div>
}

/** The lines that add up to a card's number: items, then a ruled total. Real table semantics so each amount stays tied to its label. */
export function KpiBreakdown({ caption, rows }: KpiBreakdownData) {
  return <table className="w-full border-collapse border-t border-border-default text-xs leading-5">
    <caption className="sr-only">{caption}</caption>
    <tbody>{rows.map(row => <tr key={row.key} className={row.total ? 'border-t border-border-default text-text-strong' : 'text-text-secondary'}>
      <th scope="row" className={`min-w-0 py-1.5 pr-3 text-left [overflow-wrap:anywhere] ${row.total ? 'font-semibold' : 'font-normal'}`}>{row.label}</th>
      <td className={`whitespace-nowrap py-1.5 text-right tabular-nums ${row.total ? 'font-semibold' : 'font-medium text-text-strong'}`}>{row.amount}</td>
    </tr>)}</tbody>
  </table>
}

/** Decorative trend line for a KPI card; the card's own text carries the value. */
export function Sparkline({ values, colorVar = '--mp-viz-series-1' }: { values: (number | null)[]; colorVar?: VizColor }) {
  const numeric = values.filter((value): value is number => value !== null)
  const high = Math.max(...numeric, 1)
  const width = 160, height = 32
  const x = (index: number) => (values.length === 1 ? width / 2 : (index * width) / (values.length - 1))
  let d = '', open = false
  values.forEach((value, index) => { if (value === null) { open = false; return } d += `${open ? 'L' : 'M'}${x(index).toFixed(1)},${(height - 2 - (value / high) * (height - 4)).toFixed(1)} `; open = true })
  return <svg viewBox={`0 0 ${width} ${height}`} className="mp-viz h-8 w-full" preserveAspectRatio="none" focusable="false"><path d={d} fill="none" stroke={`var(${colorVar})`} strokeWidth={2} vectorEffect="non-scaling-stroke" strokeLinejoin="round" /></svg>
}

export type BarListItem = { key: string; label: string; value: number; display: string; detail?: string | null }

/** Ranked horizontal bars. Each row prints its value, so the bar length only reinforces the text. */
export function BarList({ label, items, colorVar = '--mp-viz-series-1', empty }: { label: string; items: BarListItem[]; colorVar?: VizColor; empty: string }) {
  if (items.length === 0) return <p className="text-sm text-text-secondary">{empty}</p>
  const high = Math.max(...items.map(item => item.value), 1)
  return <ol aria-label={label} className="mp-viz grid gap-3">{items.map(item => <li key={item.key} className="grid gap-1">
    <div className="flex flex-wrap items-baseline justify-between gap-x-3 gap-y-1 text-sm"><span className="min-w-0 break-words font-medium text-text-strong">{item.label}</span><span className="min-w-0 break-words font-semibold tabular-nums text-text-strong">{item.display}</span></div>
    <div className="h-2 rounded-pill bg-surface-canvas" aria-hidden="true"><div className="h-2 rounded-pill" style={{ width: `${Math.max(2, (item.value / high) * 100)}%`, background: `var(${colorVar})` }} /></div>
    {item.detail && <p className="text-xs text-text-secondary">{item.detail}</p>}
  </li>)}</ol>
}

export type ShareSegment = { key: string; label: string; value: number; colorVar: VizColor; icon?: ReactNode }

/** Part-to-whole as one stacked bar with a 2 px gap between parts, plus a legend that prints each count and share. */
export function ShareBar({ label, segments, formatValue = value => formatCount(value), empty }: { label: string; segments: ShareSegment[]; formatValue?: (value: number) => string; empty: string }) {
  const total = segments.reduce((sum, segment) => sum + segment.value, 0)
  if (total <= 0) return <p className="text-sm text-text-secondary">{empty}</p>
  const share = (value: number) => `${((value / total) * 100).toFixed(1)}%`
  return <figure className="mp-viz m-0 grid gap-3">
    <figcaption className="sr-only">{label}: {segments.map(segment => `${segment.label} ${formatValue(segment.value)} (${share(segment.value)})`).join('; ')}.</figcaption>
    <div className="flex h-3 w-full gap-0.5 overflow-hidden rounded-pill" aria-hidden="true">{segments.filter(segment => segment.value > 0).map(segment => <span key={segment.key} style={{ flexGrow: segment.value, background: `var(${segment.colorVar})` }} />)}</div>
    <ul className="grid gap-2 sm:grid-cols-2">{segments.map(segment => <li key={segment.key} className="flex min-w-0 flex-wrap items-center justify-between gap-x-3 gap-y-1 text-sm">
      <span className="flex min-w-0 items-center gap-2"><span aria-hidden="true" className="h-3 w-3 shrink-0 rounded-sm" style={{ background: `var(${segment.colorVar})` }} />{segment.icon}<span className="min-w-0 break-words text-text-strong">{segment.label}</span></span>
      <span className="min-w-0 break-words tabular-nums text-text-secondary"><strong className="font-semibold text-text-strong">{formatValue(segment.value)}</strong> · {share(segment.value)}</span>
    </li>)}</ul>
  </figure>
}

const SHAPES = ['circle', 'square', 'triangle', 'diamond'] as const
const SLOTS: VizColor[] = ['--mp-viz-series-1', '--mp-viz-series-2', '--mp-viz-series-3', '--mp-viz-series-4']

function Marker({ shape, cx, cy, size, fill, focused }: { shape: typeof SHAPES[number]; cx: number; cy: number; size: number; fill: string; focused: boolean }) {
  const stroke = focused ? 'var(--mp-color-text-strong)' : 'var(--mp-color-surface-primary)'
  if (shape === 'square') return <rect x={cx - size} y={cy - size} width={size * 2} height={size * 2} rx={1.5} fill={fill} stroke={stroke} strokeWidth={2} />
  if (shape === 'triangle') return <path d={`M${cx},${cy - size * 1.2} L${cx + size * 1.15},${cy + size} L${cx - size * 1.15},${cy + size} Z`} fill={fill} stroke={stroke} strokeWidth={2} />
  if (shape === 'diamond') return <rect x={cx - size} y={cy - size} width={size * 2} height={size * 2} transform={`rotate(45 ${cx} ${cy})`} fill={fill} stroke={stroke} strokeWidth={2} />
  return <circle cx={cx} cy={cy} r={size} fill={fill} stroke={stroke} strokeWidth={2} />
}

export type ScatterPoint = { key: string; label: string; x: number; y: number; group: string }

/**
 * Segment scatter for clustering output. Each group has its own colour slot AND marker shape (circle, square, triangle,
 * diamond), so groups stay distinct without colour. The arrow keys step through points; the focused point is
 * described as text, and the caller offers the full table.
 */
export function SegmentScatter({ title, xLabel, yLabel, points, groups, formatX = value => formatCount(value), formatY = value => formatCount(value) }: {
  title: string; xLabel: string; yLabel: string; points: ScatterPoint[]; groups: string[]; formatX?: (value: number) => string; formatY?: (value: number) => string
}) {
  const summaryId = useId()
  const ordered = useMemo(() => [...points].sort((a, b) => a.x - b.x || a.y - b.y || a.label.localeCompare(b.label)), [points])
  const [focus, setFocus] = useState<number | null>(null)
  const [frame, measured] = useMeasuredWidth(640, 420)
  if (points.length === 0) return null
  const highX = niceCeiling(Math.max(...points.map(point => point.x), 1) * 1.05)
  const highY = niceCeiling(Math.max(...points.map(point => point.y), 1) * 1.05)
  const ticks = [0, 0.5, 1]
  const xLabels = ticks.map(f => formatX(highX * f))
  const yLabels = ticks.map(f => formatY(highY * f))
  const height = 260, left = chartLeftInset(yLabels), right = 24, top = 16, bottom = 36
  const minimumWidth = chartMinimumWidth(xLabels, left, right, 420)
  const width = Math.max(measured, minimumWidth)
  const xTicks = chartTicks(xLabels, left, width - right)
  const sx = (value: number) => left + (value / highX) * (width - left - right)
  const sy = (value: number) => top + (1 - value / highY) * (height - top - bottom)
  const groupIndex = (group: string) => Math.max(0, groups.indexOf(group)) % SHAPES.length
  const move = (event: KeyboardEvent<SVGSVGElement>) => {
    const step: Record<string, number> = { ArrowRight: 1, ArrowDown: 1, ArrowLeft: -1, ArrowUp: -1 }
    if (event.key === 'Home' || event.key === 'End') { event.preventDefault(); setFocus(event.key === 'Home' ? 0 : ordered.length - 1); return }
    if (!(event.key in step)) return
    event.preventDefault()
    setFocus(current => Math.min(ordered.length - 1, Math.max(0, (current ?? -1) + (step[event.key] ?? 0))))
  }
  const focused = focus === null ? null : ordered[focus]
  return <figure className="mp-viz m-0 min-w-0">
    <figcaption id={summaryId} className="sr-only">{title}: {points.length} points in {groups.length} groups, {xLabel} across and {yLabel} up. Use the arrow keys to read each point.</figcaption>
    <ul className="mb-3 flex flex-wrap gap-x-4 gap-y-2 text-[13px] text-text-secondary">{groups.map((group, index) => <li key={group} className="flex min-w-0 max-w-full items-center gap-2">
      <svg width="14" height="14" viewBox="0 0 14 14" aria-hidden="true" className="shrink-0"><Marker shape={SHAPES[index % SHAPES.length] ?? 'circle'} cx={7} cy={7} size={4.5} fill={`var(${SLOTS[index % SLOTS.length]})`} focused={false} /></svg><span className="min-w-0 break-words">{group}</span></li>)}</ul>
    <p className="mb-1 break-words text-xs text-text-secondary">{yLabel}</p>
    <div ref={frame} className="overflow-x-auto">
      <svg viewBox={`0 0 ${width} ${height}`} role="img" aria-labelledby={summaryId} tabIndex={0} onKeyDown={move} onBlur={() => setFocus(null)} onMouseLeave={() => setFocus(null)}
        style={{ minWidth: minimumWidth }} className="h-auto w-full rounded-control focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring">
        {ticks.map((f, index) => <g key={f}><line x1={left} x2={width - right} y1={sy(highY * f)} y2={sy(highY * f)} stroke="var(--mp-viz-grid)" />
          <text x={left - 8} y={sy(highY * f) + 4} textAnchor="end" fontSize={11} fill="var(--mp-color-text-secondary)">{yLabels[index]}</text></g>)}
        {xTicks.map(tick => <text key={tick.index} x={tick.x} y={height - 12} textAnchor={tick.textAnchor} fontSize={11} fill="var(--mp-color-text-secondary)">{tick.label}</text>)}
        {ordered.map((point, index) => { const g = groupIndex(point.group); return <g key={point.key} onMouseEnter={() => setFocus(index)}>
          <circle cx={sx(point.x)} cy={sy(point.y)} r={12} fill="transparent" />
          <Marker shape={SHAPES[g] ?? 'circle'} cx={sx(point.x)} cy={sy(point.y)} size={focus === index ? 7 : 5.5} fill={`var(${SLOTS[g]})`} focused={focus === index} /></g> })}
      </svg>
    </div>
    <p className="mt-1 break-words text-center text-xs text-text-secondary">{xLabel}</p>
    <p role="status" aria-live="polite" className="mt-2 min-h-11 text-sm text-text-strong">{focused ? `${focused.label} · ${focused.group} · ${xLabel} ${formatX(focused.x)} · ${yLabel} ${formatY(focused.y)}` : 'Hover a point or focus the chart and use the arrow keys to read each point.'}</p>
  </figure>
}

export type RuleRow = { antecedent: string[]; consequent: string[]; confidence: number; lift: number; supportCount: number }

/** Association rules as readable sentences: "A + B → C", with the confidence as a bar and lift and support as text. */
export function AssociationRuleList({ rules, countLabel, empty }: { rules: RuleRow[]; countLabel: string; empty: string }) {
  if (rules.length === 0) return <p className="text-sm text-text-secondary">{empty}</p>
  return <ol className="mp-viz grid gap-4" aria-label="Items ordered together">{rules.map(rule => <li key={`${rule.antecedent.join('+')}>${rule.consequent.join('+')}`} className="grid gap-1.5">
    <p className="flex flex-wrap items-center gap-1.5 text-sm font-semibold text-text-strong">{rule.antecedent.join(' + ')}<ArrowRight size={14} aria-label="often ordered with" />{rule.consequent.join(' + ')}</p>
    <div className="flex items-center gap-3"><div className="h-2 flex-1 rounded-pill bg-surface-canvas" aria-hidden="true"><div className="h-2 rounded-pill" style={{ width: `${Math.round(rule.confidence * 100)}%`, background: 'var(--mp-viz-series-1)' }} /></div>
      <span className="w-28 shrink-0 text-right text-xs tabular-nums text-text-strong">{Math.round(rule.confidence * 100)}% confidence</span></div>
    <p className="text-xs text-text-secondary">{rule.lift.toFixed(2)}× more often than chance · in {formatCount(rule.supportCount)} {countLabel}</p>
  </li>)}</ol>
}

export type ForecastView = { state: string; direction: string; changePercent?: number | null; expectedTotal?: number | null; points: { value: number; lower: number; upper: number }[]; weekdayStrength?: number | null; observedDays: number }

/** The forecast in words, beside its chart: direction, the expected total and its range, or why there is none. */
export function ForecastNote({ forecast, horizonDays, formatValue, unit }: { forecast: ForecastView; horizonDays: number; formatValue: (value: number) => string; unit: string }) {
  if (forecast.state !== 'OK') return <p className="flex items-start gap-2 rounded-control border border-dashed border-border-default bg-surface-canvas px-4 py-3 text-sm text-text-secondary"><Info size={16} className="mt-0.5 shrink-0" aria-hidden="true" />Not enough activity for a forecast yet. A forecast needs at least seven active days in the recent history.</p>
  const Icon = forecast.direction === 'INCREASING' ? ArrowUpRight : forecast.direction === 'DECREASING' ? ArrowDownRight : Minus
  const lower = forecast.points.reduce((sum, point) => sum + point.lower, 0)
  const upper = forecast.points.reduce((sum, point) => sum + point.upper, 0)
  const direction = forecast.direction === 'INCREASING' ? 'Rising trend' : forecast.direction === 'DECREASING' ? 'Falling trend' : 'No clear trend'
  return <div className="grid gap-1 border-l-4 border-border-default pl-4 text-sm">
    <p className="inline-flex items-center gap-1.5 font-semibold text-text-strong"><Icon size={16} aria-hidden="true" />{direction}{forecast.changePercent !== null && forecast.changePercent !== undefined && forecast.direction !== 'FLAT' ? ` (${forecast.changePercent > 0 ? '+' : ''}${forecast.changePercent.toFixed(1)}% over the history)` : ''}</p>
    <p className="text-text-strong">Next {horizonDays} days: about <strong>{formatValue(forecast.expectedTotal ?? 0)}</strong> {unit} (95% range {formatValue(lower)} to {formatValue(upper)}).</p>
    <p className="text-xs text-text-secondary">From {forecast.observedDays} days of history{forecast.weekdayStrength !== null && forecast.weekdayStrength !== undefined ? ` · weekday pattern explains ${Math.round(forecast.weekdayStrength * 100)}% of the day-to-day variation` : ''}. An estimate for planning, not a commitment.</p>
  </div>
}

const CLASS_META: Record<string, { icon: typeof CheckCircle2; className: string }> = {
  HEALTHY: { icon: CheckCircle2, className: 'border-status-success text-text-strong' },
  WATCH: { icon: Eye, className: 'border-status-warning text-text-strong' },
  BELOW_WATCH_LEVEL: { icon: AlertTriangle, className: 'border-status-error text-text-strong' },
  BUILDING_TRACK_RECORD: { icon: Sprout, className: 'border-border-default text-text-secondary' },
}

/** The workflow-threshold indicator class: always an icon and a label, never colour alone. */
export function IndicatorClassBadge({ value, label }: { value: string; label: string }) {
  const meta = CLASS_META[value] ?? { icon: Info, className: 'border-border-default text-text-secondary' }
  const Icon = meta.icon
  return <span className={`inline-flex min-h-8 items-center gap-1.5 rounded-pill border-2 bg-surface-primary px-3 text-xs font-semibold ${meta.className}`}><Icon size={14} aria-hidden="true" />{label}</span>
}

/** A collapsible plain-language explanation of how an insight is computed. */
export function MethodNote({ children, label = 'How this is calculated' }: { children: ReactNode; label?: string }) {
  return <details className="group rounded-control border border-border-default bg-surface-canvas px-4 py-2 text-xs leading-5 text-text-secondary">
    <summary className="flex min-h-11 cursor-pointer items-center gap-2 font-semibold text-text-strong"><Info size={14} aria-hidden="true" />{label}</summary>
    <div className="pb-2">{children}</div>
  </details>
}

export type ChartTableColumn = { key: string; header: string; values: (string | null)[] }

/** The table view of a chart, closed by default; every chart value is reachable without the graphic. */
export function ChartDataTable({ caption, rowHeader, rows, columns }: { caption: string; rowHeader: string; rows: string[]; columns: ChartTableColumn[] }) {
  return <details className="rounded-control border border-border-default">
    <summary className="flex min-h-11 cursor-pointer items-center px-4 text-sm font-semibold text-text-strong">View as table</summary>
    <div className="max-h-80 overflow-auto border-t border-border-default">
      <table className="w-full min-w-[420px] border-collapse text-sm"><caption className="sr-only">{caption}</caption>
        <thead className="sticky top-0 bg-surface-canvas text-xs uppercase tracking-[0.08em] text-text-secondary"><tr><th scope="col" className="px-3 py-2 text-left">{rowHeader}</th>{columns.map(column => <th key={column.key} scope="col" className="px-3 py-2 text-right">{column.header}</th>)}</tr></thead>
        <tbody className="divide-y divide-border-default">{rows.map((row, index) => <tr key={`${row}-${index}`}><th scope="row" className="px-3 py-2 text-left font-medium">{row}</th>{columns.map(column => <td key={column.key} className="px-3 py-2 text-right tabular-nums">{column.values[index] ?? '—'}</td>)}</tr>)}</tbody>
      </table>
    </div>
  </details>
}

/** A period selector rendered as a segmented control (radio semantics). */
export function PeriodSelector({ label, value, options, onChange, disabled = false }: { label: string; value: number; options: number[]; onChange: (value: number) => void; disabled?: boolean }) {
  const name = useId()
  return <fieldset className="inline-flex flex-wrap items-center gap-2" disabled={disabled}>
    <legend className="sr-only">{label}</legend>
    <span aria-hidden="true" className="text-xs font-semibold text-text-secondary">{label}</span>
    <span className="inline-flex rounded-control border border-border-default bg-surface-primary p-0.5">{options.map(option => <label key={option} className={`inline-flex min-h-11 min-w-11 cursor-pointer items-center justify-center rounded-[6px] px-3 text-sm font-semibold has-[:focus-visible]:outline-2 has-[:focus-visible]:outline-focus-ring ${value === option ? 'bg-action-primary text-white' : 'text-text-strong hover:bg-surface-canvas'}`}>
      <input className="sr-only" type="radio" name={name} value={option} checked={value === option} onChange={() => onChange(option)} />{option} days</label>)}</span>
  </fieldset>
}
