import { useCallback, useEffect, useId, useLayoutEffect, useMemo, useRef, useState, type KeyboardEvent, type ReactNode } from 'react'
import { AlertTriangle, ArrowDownRight, ArrowRight, ArrowUpRight, CheckCircle2, Eye, Info, Minus, Sprout } from 'lucide-react'
import { niceCeiling, useMeasuredWidth, type VizColor } from './geo-analytics-patterns'
import { chartLeftInset, chartMinimumWidth, chartTicks } from './chart-layout'
import { ChartEmptyFrame } from './chart-empty-frame'
import { MetricTrend } from './metric-trend'
import { MetricHeadingActions } from './calculation-help'
import './geo-analytics.css'
import './kpi-card.css'

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

/** Totals use every bucket; a missing amount keeps the total unavailable. */
export function sumChartAmounts(values: (number | null | undefined)[]): number | null {
  if (values.length === 0 || values.some(value => value == null)) return null
  return values.reduce<number>((sum, value) => sum + (value ?? 0), 0)
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
 * calculation behind the number. Change direction has both a signed value and an arrow; unavailable baselines never
 * become a percentage. All appearances share the portal metric design; calculations stay on a white surface.
 */
export function KpiCard({ label, value, hint, icon, delta, sparkline, breakdown, actions, calculation, collapsibleBreakdown = false, accent = false, density = 'comfortable', appearance = 'standard', className = '' }: { label: string; value: ReactNode; hint?: ReactNode; icon?: ReactNode; delta?: KpiDelta | null; sparkline?: (number | null)[]; breakdown?: KpiBreakdownData; actions?: ReactNode; calculation?: ReactNode; collapsibleBreakdown?: boolean; accent?: boolean; density?: 'comfortable' | 'compact'; appearance?: 'standard' | 'financial'; className?: string }) {
  const financial = appearance === 'financial'
  return <div data-density={density} className={`mp-metric-card mp-kpi-card mp-viz flex h-full min-w-0 flex-col self-stretch ${accent ? 'mp-metric-card-accent' : ''} ${financial ? `mp-financial-kpi ${accent ? 'mp-financial-kpi-accent' : ''}` : ''} ${className}`}>
    <dt className={`mp-kpi-label flex items-start justify-between text-xs font-semibold leading-5 text-text-secondary ${density === 'compact' ? 'gap-2' : 'min-h-10 gap-3'}`}><span>{label}</span><MetricHeadingActions title={label} icon={icon} calculation={calculation} /></dt>
    <dd className={`mp-kpi-value break-words font-semibold leading-tight tracking-tight text-text-strong ${density === 'compact' ? 'mt-1.5 text-xl sm:text-2xl' : 'mt-2 text-3xl'}`}>{value}</dd>
    {hint && <dd className="mp-kpi-hint mt-1 text-xs leading-5 text-text-secondary">{hint}</dd>}
    {delta && <MetricTrend changePercent={delta.changePercent} comparison={`vs ${delta.periodLabel}`} unavailable={`No ${delta.periodLabel} to compare`} />}
    {sparkline && <dd className="mt-2" aria-hidden="true"><Sparkline values={sparkline} /></dd>}
    {breakdown && <dd className="mp-kpi-breakdown mt-auto pt-4">{collapsibleBreakdown ? <details><summary className="flex min-h-11 cursor-pointer items-center text-sm font-semibold text-action-primary focus-visible:outline-2 focus-visible:outline-focus-ring">View breakdown<span className="sr-only"> for {label}</span></summary><KpiBreakdown {...breakdown} /></details> : <KpiBreakdown {...breakdown} />}</dd>}
    {actions && <dd className="mt-auto pt-4">{actions}</dd>}
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
  const low = Math.min(...numeric, 0)
  const width = 160, height = 32
  const x = (index: number) => (values.length === 1 ? width / 2 : (index * width) / (values.length - 1))
  let d = '', open = false
  values.forEach((value, index) => { if (value === null) { open = false; return } d += `${open ? 'L' : 'M'}${x(index).toFixed(1)},${(height - 2 - ((value - low) / (high - low)) * (height - 4)).toFixed(1)} `; open = true })
  const muted = numeric.length === 0 || numeric.every(value => value === 0)
  return <svg viewBox={`0 0 ${width} ${height}`} className={`mp-viz h-8 w-full ${muted ? 'mp-viz-muted' : ''}`} preserveAspectRatio="none" focusable="false"><path d={numeric.length ? d : `M0,${height - 2} H${width}`} fill="none" stroke={`var(${colorVar})`} strokeWidth={2} strokeDasharray={numeric.length ? undefined : '4 4'} vectorEffect="non-scaling-stroke" strokeLinejoin="round" /></svg>
}

export type BarListItem = { key: string; label: string; value: number; display: string; detail?: string | null }

/** Ranked horizontal bars. Each row prints its value, so the bar length only reinforces the text. */
export function BarList({ label, items, colorVar = '--mp-viz-series-1', empty }: { label: string; items: BarListItem[]; colorVar?: VizColor; empty: string }) {
  if (items.length === 0) return <ChartEmptyFrame title={label} reason={empty} variant="horizontal" />
  const high = Math.max(...items.map(item => item.value), 1)
  return <ol aria-label={label} className={`mp-viz grid gap-3 ${items.every(item => item.value === 0) ? 'mp-viz-muted' : ''}`}>{items.map(item => <li key={item.key} className="grid gap-1">
    <div className="flex flex-wrap items-baseline justify-between gap-x-3 gap-y-1 text-sm"><span className="min-w-0 break-words font-medium text-text-strong">{item.label}</span><span className="min-w-0 break-words font-semibold tabular-nums text-text-strong">{item.display}</span></div>
    <div className="h-2 rounded-pill bg-surface-canvas" aria-hidden="true"><div className="h-2 rounded-pill" style={{ width: `${item.value <= 0 ? 0 : Math.max(2, (item.value / high) * 100)}%`, background: `var(${colorVar})` }} /></div>
    {item.detail && <p className="text-xs text-text-secondary">{item.detail}</p>}
  </li>)}</ol>
}

export type ShareSegment = { key: string; label: string; value: number; colorVar: VizColor; icon?: ReactNode }

/** Part-to-whole as one stacked bar with a 2 px gap between parts, plus a legend that prints each count and share. */
export function ShareBar({ label, segments, formatValue = value => formatCount(value), formatTotal = formatValue, empty, variant = 'bar', totalLabel = 'Total', legendColumns = 2 }: { label: string; segments: ShareSegment[]; formatValue?: (value: number) => string; formatTotal?: (value: number) => string; empty: string; variant?: 'bar' | 'donut'; totalLabel?: string; legendColumns?: 1 | 2 }) {
  const total = segments.reduce((sum, segment) => sum + segment.value, 0)
  if (total <= 0) return <ChartEmptyFrame title={label} reason={empty} variant={variant === 'donut' ? 'donut' : 'horizontal'} />
  const share = (value: number) => `${((value / total) * 100).toFixed(1)}%`
  let offset = 0
  return <figure className={`mp-viz m-0 grid items-center gap-4 ${variant === 'donut' ? '@container' : ''}`} data-chart-variant={variant}>
    <figcaption className="sr-only">{label}: {segments.map(segment => `${segment.label} ${formatValue(segment.value)} (${share(segment.value)})`).join('; ')}.</figcaption>
    <div className={variant === 'donut' ? 'grid items-center gap-4 @min-[19rem]:grid-cols-[7.5rem_minmax(0,1fr)]' : 'grid gap-3'}>
    {variant === 'donut' ? <svg viewBox="0 0 180 180" className="mx-auto h-32 w-32 max-w-full" role="img" aria-label={`${label}, ${totalLabel.toLowerCase()} ${formatValue(total)}`}>
      <circle cx={90} cy={90} r={67} fill="none" stroke="var(--mp-viz-placeholder)" strokeWidth={16} />
      {segments.filter(segment => segment.value > 0).map(segment => {
        const start = offset
        const length = segment.value / total * 100
        offset += length
        return <circle key={segment.key} cx={90} cy={90} r={67} pathLength={100} fill="none" stroke={`var(${segment.colorVar})`} strokeWidth={16} strokeDasharray={`${Math.max(0, length - Math.min(1, length * 0.1))} ${100 - Math.max(0, length - Math.min(1, length * 0.1))}`} strokeDashoffset={-start} transform="rotate(-90 90 90)" />
      })}
      <text x={90} y={88} textAnchor="middle" fontSize={Math.min(20, 160 / Math.max(1, formatTotal(total).length))} fontWeight={600} fill="var(--mp-color-text-strong)">{formatTotal(total)}</text>
      <text x={90} y={108} textAnchor="middle" fontSize={11} fill="var(--mp-color-text-secondary)">{totalLabel}</text>
    </svg> : <div className="flex h-3 w-full gap-0.5 overflow-hidden rounded-pill" aria-hidden="true">{segments.filter(segment => segment.value > 0).map(segment => <span key={segment.key} style={{ flexGrow: segment.value, background: `var(${segment.colorVar})` }} />)}</div>}
    <ul className={`grid gap-3 ${variant === 'bar' && legendColumns === 2 ? 'sm:grid-cols-2' : ''}`}>{segments.map(segment => <li key={segment.key} className="grid min-w-0 gap-1 text-xs leading-5">
      <div className="flex min-w-0 flex-wrap items-baseline justify-between gap-x-3 gap-y-1"><span className="flex min-w-0 items-center gap-2">{segment.icon}<span className="min-w-0 break-words text-text-strong">{segment.label}</span></span>
      <span className="min-w-0 break-words tabular-nums text-text-secondary"><strong className="font-semibold text-text-strong">{formatValue(segment.value)}</strong> · {share(segment.value)}</span></div>
      {variant === 'donut' && <div aria-hidden="true" className="h-1.5 overflow-hidden rounded-pill bg-surface-canvas"><div className="h-full rounded-pill" style={{ width: `${segment.value / total * 100}%`, background: `var(${segment.colorVar})` }} /></div>}
    </li>)}</ul>
    </div>
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
export function SegmentScatter({ title, xLabel, yLabel, points, groups, formatX = value => formatCount(value), formatY = value => formatCount(value), emptyReason = 'Not enough data to show segments yet.', compact = false }: {
  title: string; xLabel: string; yLabel: string; points: ScatterPoint[]; groups: string[]; formatX?: (value: number) => string; formatY?: (value: number) => string; emptyReason?: string; compact?: boolean
}) {
  const summaryId = useId()
  const tooltipId = useId()
  const ordered = useMemo(() => [...points].sort((a, b) => a.x - b.x || a.y - b.y || a.label.localeCompare(b.label)), [points])
  const [focus, setFocus] = useState<string | null>(null)
  const plot = useRef<SVGSVGElement>(null)
  const tooltip = useRef<HTMLDivElement>(null)
  const hideTimer = useRef<ReturnType<typeof setTimeout> | null>(null)
  const touchSelection = useRef(false)
  const cancelHide = useCallback(() => { if (hideTimer.current !== null) clearTimeout(hideTimer.current) }, [])
  const dismiss = useCallback(() => { cancelHide(); touchSelection.current = false; setFocus(null) }, [cancelHide])
  const show = useCallback((key: string) => { cancelHide(); setFocus(key) }, [cancelHide])
  const hideSoon = useCallback(() => { if (touchSelection.current) return; cancelHide(); hideTimer.current = setTimeout(() => setFocus(null), 150) }, [cancelHide])
  const [frame, measured] = useMeasuredWidth(560, 240)
  const highX = niceCeiling(Math.max(...points.map(point => point.x), 1) * 1.05)
  const highY = niceCeiling(Math.max(...points.map(point => point.y), 1) * 1.05)
  const ticks = [0, 0.5, 1]
  const xLabels = ticks.map(f => formatX(highX * f))
  const yLabels = ticks.map(f => formatY(highY * f))
  const height = compact ? 176 : 216, left = chartLeftInset(yLabels), right = 24, top = 16, bottom = 36
  const minimumWidth = chartMinimumWidth(xLabels, left, right, 240, 120)
  const width = Math.max(measured, minimumWidth)
  const xTicks = chartTicks(xLabels, left, width - right)
  const sx = (value: number) => left + (value / highX) * (width - left - right)
  const sy = (value: number) => top + (1 - value / highY) * (height - top - bottom)
  const groupIndex = (group: string) => Math.max(0, groups.indexOf(group)) % SHAPES.length
  const move = (event: KeyboardEvent<SVGSVGElement>) => {
    touchSelection.current = false
    const step: Record<string, number> = { ArrowRight: 1, ArrowDown: 1, ArrowLeft: -1, ArrowUp: -1 }
    if (event.key === 'Home' || event.key === 'End') { event.preventDefault(); const point = event.key === 'Home' ? ordered[0] : ordered.at(-1); if (point) show(point.key); return }
    if (!(event.key in step)) return
    event.preventDefault()
    const index = ordered.findIndex(point => point.key === focus)
    const point = ordered[Math.min(ordered.length - 1, Math.max(0, index + (step[event.key] ?? 0)))]
    if (point) show(point.key)
  }
  const focused = ordered.find(point => point.key === focus)
  const pointX = focused ? sx(focused.x) / width : 0
  const pointY = focused ? sy(focused.y) / height : 0
  useLayoutEffect(() => {
    if (!focused || !plot.current || !tooltip.current) return
    const position = () => {
      if (!plot.current || !tooltip.current) return
      const chart = plot.current.getBoundingClientRect()
      const bounds = tooltip.current.getBoundingClientRect()
      const x = chart.left + chart.width * pointX, y = chart.top + chart.height * pointY
      const above = y - bounds.height - 12
      tooltip.current.style.left = `${Math.max(12, Math.min(x - bounds.width / 2, window.innerWidth - bounds.width - 12))}px`
      tooltip.current.style.top = `${Math.max(12, Math.min(above >= 12 ? above : y + 12, window.innerHeight - bounds.height - 12))}px`
    }
    tooltip.current.showPopover?.()
    position()
    window.addEventListener('resize', position)
    window.addEventListener('scroll', position, true)
    return () => { window.removeEventListener('resize', position); window.removeEventListener('scroll', position, true) }
  }, [focused, pointX, pointY, measured])
  useEffect(() => {
    if (!focused) return
    const outside = (event: PointerEvent) => { const target = event.target as Node; if (!plot.current?.contains(target) && !tooltip.current?.contains(target)) dismiss() }
    const escape = (event: globalThis.KeyboardEvent) => { if (event.key === 'Escape') dismiss() }
    document.addEventListener('pointerdown', outside)
    document.addEventListener('keydown', escape)
    return () => { document.removeEventListener('pointerdown', outside); document.removeEventListener('keydown', escape) }
  }, [focused, dismiss])
  useEffect(() => cancelHide, [cancelHide])
  if (points.length === 0) return <ChartEmptyFrame title={title} reason={emptyReason} variant="scatter" {...(compact ? { plotHeight: 96 } : {})} />
  return <figure className="mp-viz m-0 min-w-0">
    <figcaption id={summaryId} className="sr-only">{title}: {points.length} points in {groups.length} groups, {xLabel} across and {yLabel} up. Use the arrow keys to read each point.</figcaption>
    <ul className="mb-3 flex flex-wrap gap-x-4 gap-y-2 text-[13px] text-text-secondary">{groups.map((group, index) => <li key={group} className="flex min-w-0 max-w-full items-center gap-2">
      <svg width="14" height="14" viewBox="0 0 14 14" aria-hidden="true" className="shrink-0"><Marker shape={SHAPES[index % SHAPES.length] ?? 'circle'} cx={7} cy={7} size={4.5} fill={`var(${SLOTS[index % SLOTS.length]})`} focused={false} /></svg><span className="min-w-0 break-words">{group}</span></li>)}</ul>
    <p className="mb-1 break-words text-xs text-text-secondary">{yLabel}</p>
    <div ref={frame} className="overflow-x-auto">
      <svg ref={plot} viewBox={`0 0 ${width} ${height}`} role="img" aria-labelledby={summaryId} aria-describedby={focused ? tooltipId : undefined} tabIndex={0} onKeyDown={move} onFocus={() => { if (ordered[0]) show(ordered[0].key) }} onBlur={dismiss} onMouseLeave={hideSoon}
        style={{ minWidth: minimumWidth }} className="h-auto w-full rounded-control focus-visible:outline-2 focus-visible:-outline-offset-2 focus-visible:outline-focus-ring">
        {ticks.map((f, index) => <g key={f}><line x1={left} x2={width - right} y1={sy(highY * f)} y2={sy(highY * f)} stroke="var(--mp-viz-grid)" />
          <text x={left - 8} y={sy(highY * f) + 4} textAnchor="end" fontSize={11} fill="var(--mp-color-text-secondary)">{yLabels[index]}</text></g>)}
        {xTicks.map(tick => <text key={tick.index} x={tick.x} y={height - 12} textAnchor={tick.textAnchor} fontSize={11} fill="var(--mp-color-text-secondary)">{tick.label}</text>)}
        {ordered.map(point => { const g = groupIndex(point.group); return <g key={point.key} data-scatter-point={point.key} className="cursor-help" onMouseEnter={() => { if (!touchSelection.current) show(point.key) }} onClick={() => show(point.key)} onPointerDown={event => { if (event.pointerType === 'touch') { event.preventDefault(); show(point.key); touchSelection.current = true } }}>
          <circle cx={sx(point.x)} cy={sy(point.y)} r={12} fill="transparent" />
          <Marker shape={SHAPES[g] ?? 'circle'} cx={sx(point.x)} cy={sy(point.y)} size={focus === point.key ? 7 : 5.5} fill={`var(${SLOTS[g]})`} focused={focus === point.key} /></g> })}
      </svg>
    </div>
    <p className="mt-1 break-words text-center text-xs text-text-secondary">{xLabel}</p>
    <p role="status" aria-live="polite" className="mt-2 min-h-5 text-xs leading-5 text-text-secondary">{focused ? `${focused.label} · ${focused.group} · ${xLabel} ${formatX(focused.x)} · ${yLabel} ${formatY(focused.y)}` : 'Hover or tap a point for details. Keyboard: use the arrow keys.'}</p>
    {focused && <div ref={tooltip} id={tooltipId} role="tooltip" popover="manual" className="mp-scatter-tooltip" onMouseEnter={cancelHide} onMouseLeave={hideSoon}>
      <p className="mp-scatter-tooltip-name">{focused.label}</p>
      <p className="mp-scatter-tooltip-group"><svg width="14" height="14" viewBox="0 0 14 14" aria-hidden="true"><Marker shape={SHAPES[groupIndex(focused.group)] ?? 'circle'} cx={7} cy={7} size={4.5} fill={`var(${SLOTS[groupIndex(focused.group)]})`} focused={false} /></svg>{focused.group}</p>
      <dl><div><dt>{xLabel}</dt><dd>{formatX(focused.x)}</dd></div><div><dt>{yLabel}</dt><dd>{formatY(focused.y)}</dd></div></dl>
    </div>}
  </figure>
}

export type RuleRow = { antecedent: string[]; consequent: string[]; confidence: number; lift: number; supportCount: number }

/** Association rules as readable sentences: "A + B → C", with the confidence as a bar and lift and support as text. */
export function AssociationRuleList({ rules, countLabel, empty, compact = false }: { rules: RuleRow[]; countLabel: string; empty: string; compact?: boolean }) {
  if (rules.length === 0) return <ChartEmptyFrame title="Items ordered together" reason={empty} variant="horizontal" {...(compact ? { plotHeight: 80 } : {})} />
  return <ol className={`mp-viz grid ${compact ? 'divide-y divide-border-default' : 'gap-4'}`} aria-label="Items ordered together">{rules.map(rule => <li key={`${rule.antecedent.join('+')}>${rule.consequent.join('+')}`} className={`grid gap-1.5 ${compact ? 'py-3 first:pt-0 last:pb-0' : ''}`}>
    <p className={`flex flex-wrap items-center gap-1.5 font-semibold text-text-strong ${compact ? 'text-xs leading-5' : 'text-sm'}`}>{rule.antecedent.join(' + ')}<ArrowRight size={14} aria-label="often ordered with" />{rule.consequent.join(' + ')}</p>
    <div className="flex items-center gap-3"><div className="h-2 flex-1 rounded-pill bg-surface-canvas" aria-hidden="true"><div className="h-2 rounded-pill" style={{ width: `${Math.round(rule.confidence * 100)}%`, background: 'var(--mp-viz-series-1)' }} /></div>
      <span className="w-28 shrink-0 text-right text-xs tabular-nums text-text-strong">{Math.round(rule.confidence * 100)}% confidence</span></div>
    <p className="text-xs text-text-secondary">{rule.lift.toFixed(2)}× more often than chance · in {formatCount(rule.supportCount)} {countLabel}</p>
  </li>)}</ol>
}

export type ForecastView = { state: string; direction: string; changePercent?: number | null; expectedTotal?: number | null; points: { value: number; lower: number; upper: number }[]; weekdayStrength?: number | null; observedDays: number }

/** The forecast in words, beside its chart: direction, the expected total and its range, or why there is none. */
export function ForecastNote({ forecast, horizonDays, formatValue, unit }: { forecast: ForecastView; horizonDays: number; formatValue: (value: number) => string; unit: string }) {
  if (forecast.state !== 'OK') return <details className="border-t border-border-default text-xs text-text-secondary"><summary className="flex min-h-11 cursor-pointer items-center font-medium">{horizonDays}-day outlook · not enough history</summary><p className="pb-3 leading-5">Not enough activity for a forecast yet. A forecast needs at least seven active days in the recent history.</p></details>
  const Icon = forecast.direction === 'INCREASING' ? ArrowUpRight : forecast.direction === 'DECREASING' ? ArrowDownRight : Minus
  const lower = forecast.points.reduce((sum, point) => sum + point.lower, 0)
  const upper = forecast.points.reduce((sum, point) => sum + point.upper, 0)
  const direction = forecast.direction === 'INCREASING' ? 'Rising trend' : forecast.direction === 'DECREASING' ? 'Falling trend' : 'No clear trend'
  return <details className="border-t border-border-default text-xs"><summary className="flex min-h-11 cursor-pointer items-center font-medium text-text-secondary">{horizonDays}-day outlook</summary><div className="grid gap-1 pb-3 text-sm">
    <p className="inline-flex items-center gap-1.5 font-semibold text-text-strong"><Icon size={16} aria-hidden="true" />{direction}{forecast.changePercent !== null && forecast.changePercent !== undefined && forecast.direction !== 'FLAT' ? ` (${forecast.changePercent > 0 ? '+' : ''}${forecast.changePercent.toFixed(1)}% over the history)` : ''}</p>
    <p className="text-text-strong">Next {horizonDays} days: about <strong>{formatValue(forecast.expectedTotal ?? 0)}</strong> {unit} (95% range {formatValue(lower)} to {formatValue(upper)}).</p>
    <p className="text-xs text-text-secondary">From {forecast.observedDays} days of history{forecast.weekdayStrength !== null && forecast.weekdayStrength !== undefined ? ` · weekday pattern explains ${Math.round(forecast.weekdayStrength * 100)}% of the day-to-day variation` : ''}. An estimate for planning, not a commitment.</p>
  </div></details>
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
  return <details className="group border-t border-border-default text-xs leading-5 text-text-secondary">
    <summary className="flex min-h-11 cursor-pointer items-center gap-2 font-semibold text-text-strong"><Info size={14} aria-hidden="true" />{label}</summary>
    <div className="pb-2">{children}</div>
  </details>
}

export type ChartTableColumn = { key: string; header: string; values: (string | null)[] }

/** The table view of a chart, closed by default; every chart value is reachable without the graphic. */
export function ChartDataTable({ caption, rowHeader, rows, columns }: { caption: string; rowHeader: string; rows: string[]; columns: ChartTableColumn[] }) {
  return <details className="min-w-0 border-t border-border-default">
    <summary className="flex min-h-11 cursor-pointer items-center text-xs font-medium text-text-secondary">View as table</summary>
    <div className="max-h-80 overflow-auto border-t border-border-default">
      <table className="w-full min-w-[420px] border-collapse text-sm"><caption className="sr-only">{caption}</caption>
        <thead className="sticky top-0 bg-surface-canvas text-xs uppercase tracking-[0.08em] text-text-secondary"><tr><th scope="col" className="px-3 py-2 text-left">{rowHeader}</th>{columns.map(column => <th key={column.key} scope="col" className="px-3 py-2 text-right">{column.header}</th>)}</tr></thead>
        <tbody className="divide-y divide-border-default">{rows.map((row, index) => <tr key={`${row}-${index}`}><th scope="row" className="px-3 py-2 text-left font-medium">{row}</th>{columns.map(column => <td key={column.key} className="px-3 py-2 text-right tabular-nums">{column.values[index] ?? '—'}</td>)}</tr>)}</tbody>
      </table>
    </div>
  </details>
}

/** Visible, wrapping choices with native radio keyboard navigation. */
export function SegmentedControl<T extends string | number>({ label, value, options, onChange, disabled = false }: { label: string; value: T; options: { value: T; label: string }[]; onChange: (value: T) => void; disabled?: boolean }) {
  const name = useId()
  // Position each hidden input within its label so native focus cannot scroll outside the portal.
  return <fieldset className="inline-flex min-w-0 flex-wrap items-center gap-2" disabled={disabled}>
    <legend className="sr-only">{label}</legend>
    <span aria-hidden="true" className="text-xs font-semibold text-text-secondary">{label}</span>
    <span className="inline-flex max-w-full flex-wrap gap-0.5 rounded-control border border-border-default bg-surface-primary p-0.5">{options.map(option => <label key={option.value} className={`relative inline-flex min-h-11 min-w-11 cursor-pointer items-center justify-center rounded-[6px] px-3 text-sm font-semibold has-[:focus-visible]:outline-2 has-[:focus-visible]:outline-focus-ring ${value === option.value ? 'bg-action-primary text-white' : 'text-text-strong hover:bg-surface-canvas'}`}>
      <input className="sr-only" type="radio" name={name} value={option.value} checked={value === option.value} onChange={() => onChange(option.value)} />{option.label}</label>)}</span>
  </fieldset>
}

/** A period selector rendered as a segmented control (radio semantics). */
export function PeriodSelector({ label, value, options, onChange, disabled = false }: { label: string; value: number; options: number[]; onChange: (value: number) => void; disabled?: boolean }) {
  return <SegmentedControl label={label} value={value} options={options.map(option => ({ value: option, label: `${option} days` }))} onChange={onChange} disabled={disabled} />
}
