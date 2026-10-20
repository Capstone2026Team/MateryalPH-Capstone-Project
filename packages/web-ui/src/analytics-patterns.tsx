import { useId, useMemo, useRef, useState, type KeyboardEvent, type ReactNode } from 'react'
import { AlertTriangle, ArrowDownRight, ArrowUpRight, Award, BadgeCheck, Clock, EyeOff, Minus, ShieldCheck, Star, Tag, ThumbsUp, Timer, TrendingUp, Users } from 'lucide-react'
import { chartLeftInset, chartMinimumWidth, chartTicks } from './chart-layout'
import { useMeasuredWidth } from './geo-analytics-patterns'
import { StatusBadge } from './portal-shell'

/** One graph/table day. A null value is a gap (missing day, suppressed or no local observation) — never zero. */
export type PricePoint = {
  date: string
  value: string | null
  status: string
  label?: string | null
  count?: number | null
  participantsChanged?: boolean | null
}

export type TrendValue = {
  changePercent?: string | null | undefined
  direction?: string | null | undefined
  reason?: string | null | undefined
  label?: string | null | undefined
  compositionChanged?: boolean | null | undefined
  compositionNote?: string | null | undefined
  startDate?: string | Date | null | undefined
  endDate?: string | Date | null | undefined
}

/**
 * Generated clients may hand dates over as Date objects; analytics dates are calendar days. The generated runtime
 * parses a date-only value as local midnight (and serializes with local getters), so the day is read with local
 * getters too: toISOString() would turn local midnight in Asia/Manila (UTC+8) into the previous day.
 */
export function analyticsDay(value: string | Date | null | undefined): string | null {
  if (value === null || value === undefined) return null
  if (!(value instanceof Date)) return value.slice(0, 10)
  if (Number.isNaN(value.getTime())) return null
  return `${String(value.getFullYear()).padStart(4, '0')}-${String(value.getMonth() + 1).padStart(2, '0')}-${String(value.getDate()).padStart(2, '0')}`
}

const dayFormat = new Intl.DateTimeFormat('en-PH', { month: 'short', day: 'numeric', timeZone: 'UTC' })
const longDay = new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeZone: 'UTC' })
const peso = new Intl.NumberFormat('en-PH', { style: 'currency', currency: 'PHP', minimumFractionDigits: 2 })

export function formatAnalyticsDate(input: string | Date | null | undefined, long = false): string {
  const date = analyticsDay(input)
  if (date === null) return '—'
  const parsed = new Date(`${date}T00:00:00Z`)
  return Number.isNaN(parsed.getTime()) ? date : (long ? longDay : dayFormat).format(parsed)
}

export function formatPhpDecimal(value: string | null | undefined): string {
  if (value === null || value === undefined || value === '') return '—'
  const number = Number(value)
  return Number.isFinite(number) ? peso.format(number) : value
}

/**
 * MAT-06 price graph: one line with breaks at every missing or suppressed day (no line is drawn across a gap), exact
 * values on focus, a participant-change flag and a keyboard-operable focus that stays synchronized with the table.
 * When no day has a displayable value the chart is replaced by an explicit null state carrying the reason.
 */
export function PriceTrendChart({ title, unit, points, focusedDate, onFocusDate, emptyReason }: {
  title: string; unit: string; points: PricePoint[]; focusedDate: string | null; onFocusDate: (date: string | null) => void; emptyReason: string
}) {
  const summaryId = useId()
  const [frame, measured] = useMeasuredWidth(720)
  const values = points.map(point => (point.value === null ? null : Number(point.value)))
  const numeric = values.filter((value): value is number => value !== null && Number.isFinite(value))
  if (numeric.length === 0) return <AnalyticsNullState title="No graph for this period" reason={emptyReason} />
  const min = Math.min(...numeric), max = Math.max(...numeric)
  const pad = max === min ? Math.max(1, max * 0.05) : (max - min) * 0.12
  const low = Math.max(0, min - pad), high = max + pad
  const ticks = [low, (low + high) / 2, high]
  const tickLabels = ticks.map(tick => formatPhpDecimal(tick.toFixed(2)))
  const dateLabels = points.map(point => formatAnalyticsDate(point.date))
  const height = 240, left = chartLeftInset(tickLabels, 64), right = 24, top = 16, bottom = 40
  const minimumWidth = chartMinimumWidth(dateLabels, left, right)
  const width = Math.max(measured, minimumWidth)
  const dateTicks = chartTicks(dateLabels, left, width - right)
  const x = (index: number) => left + (points.length === 1 ? (width - left - right) / 2 : index * (width - left - right) / (points.length - 1))
  const y = (value: number) => top + (1 - (value - low) / (high - low)) * (height - top - bottom)
  const segments: string[] = []
  let current = ''
  values.forEach((value, index) => {
    if (value === null) { if (current) segments.push(current); current = ''; return }
    current += `${current ? 'L' : 'M'}${x(index).toFixed(1)},${y(value).toFixed(1)} `
  })
  if (current) segments.push(current)
  const focusIndex = focusedDate === null ? -1 : points.findIndex(point => point.date === focusedDate)
  const focus = focusIndex >= 0 ? points[focusIndex] : undefined
  const gaps = points.filter(point => point.value === null).length
  const move = (event: KeyboardEvent<SVGSVGElement>) => {
    const keys: Record<string, number> = { ArrowRight: 1, ArrowLeft: -1, Home: -Infinity, End: Infinity }
    if (!(event.key in keys)) return
    event.preventDefault()
    const step = keys[event.key] ?? 0
    const next = step === -Infinity ? 0 : step === Infinity ? points.length - 1 : Math.min(points.length - 1, Math.max(0, (focusIndex < 0 ? 0 : focusIndex) + step))
    onFocusDate(points[next]?.date ?? null)
  }
  return <figure className="m-0 min-w-0">
    <figcaption className="sr-only" id={summaryId}>{title}. {numeric.length} days with an average and {gaps} days without one, in {unit}. Use the arrow keys to move between days; the table below lists every value.</figcaption>
    <div ref={frame} className="overflow-x-auto">
      <svg viewBox={`0 0 ${width} ${height}`} style={{ minWidth: minimumWidth }} className="h-auto w-full rounded-control focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring" role="img" aria-labelledby={summaryId}
        tabIndex={0} onKeyDown={move} onMouseLeave={() => onFocusDate(null)} onBlur={() => onFocusDate(null)}>
        {ticks.map((tick, index) => <g key={tick}>
          <line x1={left} x2={width - right} y1={y(tick)} y2={y(tick)} stroke="var(--mp-color-border-default)" strokeWidth={1} />
          <text x={left - 8} y={y(tick) + 4} textAnchor="end" fontSize={11} fill="var(--mp-color-text-secondary)">{tickLabels[index]}</text>
        </g>)}
        {points.map((point, index) => point.value === null && <g key={`gap-${point.date}`}>
          <rect x={x(index) - 5} y={top} width={10} height={height - top - bottom} fill="url(#analytics-gap)" opacity={0.6} />
        </g>)}
        <defs><pattern id="analytics-gap" width="6" height="6" patternUnits="userSpaceOnUse" patternTransform="rotate(45)"><line x1="0" y1="0" x2="0" y2="6" stroke="var(--mp-color-border-default)" strokeWidth="2" /></pattern></defs>
        {segments.map(path => <path key={path} d={path} fill="none" stroke="var(--mp-color-action-primary)" strokeWidth={2} strokeLinejoin="round" strokeLinecap="round" />)}
        {points.map((point, index) => point.value !== null && <g key={point.date}>
          <circle cx={x(index)} cy={y(Number(point.value))} r={index === focusIndex ? 6 : 4} fill="var(--mp-color-surface-primary)" stroke="var(--mp-color-action-primary)" strokeWidth={2} />
          {point.participantsChanged && <path d={`M${x(index)},${y(Number(point.value)) - 14} l5,8 h-10 z`} fill="var(--mp-color-text-strong)" aria-hidden="true" />}
        </g>)}
        {dateTicks.map(tick => <text key={tick.index} x={tick.x} y={height - 16} textAnchor={tick.textAnchor} fontSize={11} fill="var(--mp-color-text-secondary)">{tick.label}</text>)}
        {focus && <line x1={x(focusIndex)} x2={x(focusIndex)} y1={top} y2={height - bottom} stroke="var(--mp-color-text-secondary)" strokeDasharray="3 3" strokeWidth={1} />}
        {points.map((point, index) => <rect key={`hit-${point.date}`} x={x(index) - (width - left - right) / Math.max(1, points.length - 1) / 2} y={top} width={Math.max(12, (width - left - right) / Math.max(1, points.length - 1))} height={height - top - bottom}
          fill="transparent" onMouseEnter={() => onFocusDate(point.date)} />)}
      </svg>
    </div>
    <p className="mt-2 min-h-11 text-sm text-text-strong" aria-live="polite">
      {focus ? <><strong>{formatAnalyticsDate(focus.date, true)}</strong>{' · '}{focus.value === null ? (focus.label ?? 'No value for this date') : `${formatPhpDecimal(focus.value)} per ${unit}`}
        {focus.count !== null && focus.count !== undefined && focus.value !== null ? ` · ${focus.count} Vendor${focus.count === 1 ? '' : 's'}` : ''}{focus.participantsChanged ? ' · Participating Vendors changed from the previous day' : ''}</>
        : <span className="text-text-secondary">Hover, tap or use the arrow keys on the graph to read exact values. Hatched bands are days without a value; ▲ marks a change in participating Vendors.</span>}
    </p>
  </figure>
}

/** The synchronized, sortable equivalent of the graph. Selecting a row focuses that day on the graph. */
export function PriceTrendTable({ caption, unit, points, focusedDate, onFocusDate, countLabel = 'Vendors' }: {
  caption: string; unit: string; points: PricePoint[]; focusedDate: string | null; onFocusDate: (date: string | null) => void; countLabel?: string | undefined
}) {
  const [sort, setSort] = useState<{ key: 'date' | 'value'; direction: 'ascending' | 'descending' }>({ key: 'date', direction: 'descending' })
  const rows = useMemo(() => [...points].sort((a, b) => {
    const order = sort.key === 'date' ? a.date.localeCompare(b.date) : (a.value === null ? Infinity : Number(a.value)) - (b.value === null ? Infinity : Number(b.value))
    return sort.direction === 'ascending' ? order : -order
  }), [points, sort])
  const header = (key: 'date' | 'value', label: string) => <th scope="col" aria-sort={sort.key === key ? sort.direction : 'none'} className="px-3 py-2 text-left">
    <button type="button" className="inline-flex min-h-11 items-center gap-1 font-semibold" onClick={() => setSort(previous => ({ key, direction: previous.key === key && previous.direction === 'ascending' ? 'descending' : 'ascending' }))}>
      {label}<span aria-hidden="true">{sort.key === key ? (sort.direction === 'ascending' ? '↑' : '↓') : '↕'}</span>
    </button>
  </th>
  return <div className="max-h-96 overflow-auto rounded-control border border-border-default">
    <table className="w-full min-w-[520px] border-collapse text-sm">
      <caption className="sr-only">{caption}</caption>
      <thead className="sticky top-0 bg-surface-canvas text-xs uppercase tracking-[0.08em] text-text-secondary"><tr>{header('date', 'Date')}{header('value', `Average per ${unit}`)}<th scope="col" className="px-3 py-2 text-left font-semibold">{countLabel}</th><th scope="col" className="px-3 py-2 text-left font-semibold">Note</th></tr></thead>
      <tbody className="divide-y divide-border-default">{rows.map(point => <tr key={point.date} aria-selected={point.date === focusedDate} className={point.date === focusedDate ? 'bg-brand-orange-50' : undefined}>
        <td className="px-3 py-1"><button type="button" className="min-h-11 text-left font-semibold underline-offset-4 hover:underline" onClick={() => onFocusDate(point.date)} aria-label={`Show ${formatAnalyticsDate(point.date, true)} on the graph`}>{formatAnalyticsDate(point.date, true)}</button></td>
        <td className="px-3 py-1 tabular-nums">{point.value === null ? <span className="text-text-secondary">—</span> : formatPhpDecimal(point.value)}</td>
        <td className="px-3 py-1 tabular-nums">{point.count ?? <span className="text-text-secondary">—</span>}</td>
        <td className="px-3 py-1 text-text-secondary">{[point.label, point.participantsChanged ? 'Participants changed' : null].filter(Boolean).join(' · ') || '—'}</td>
      </tr>)}</tbody>
    </table>
  </div>
}

/** Graph and table bound to one focused date. */
export function PriceTrendPanel({ title, unit, points, emptyReason, countLabel }: { title: string; unit: string; points: PricePoint[]; emptyReason: string; countLabel?: string | undefined }) {
  const [focusedDate, setFocusedDate] = useState<string | null>(null)
  return <div className="grid min-w-0 gap-4">
    <PriceTrendChart title={title} unit={unit} points={points} focusedDate={focusedDate} onFocusDate={setFocusedDate} emptyReason={emptyReason} />
    <PriceTrendTable caption={`${title} — daily values`} unit={unit} points={points} focusedDate={focusedDate} onFocusDate={setFocusedDate} countLabel={countLabel} />
  </div>
}

/** Direction as text plus an icon; a null percentage shows its reason instead of a number. */
export function TrendSummary({ trend, compact = false }: { trend: TrendValue; compact?: boolean }) {
  if (trend.changePercent === null || trend.changePercent === undefined) {
    return <span className="inline-flex items-center gap-1.5 text-sm text-text-secondary"><Minus size={16} aria-hidden="true" />{trend.label ?? 'Insufficient Local Data'}</span>
  }
  const direction = trend.direction ?? 'NO_MATERIAL_CHANGE'
  const Icon = direction === 'INCREASING' ? ArrowUpRight : direction === 'DECREASING' ? ArrowDownRight : Minus
  const text = direction === 'INCREASING' ? 'Increasing' : direction === 'DECREASING' ? 'Decreasing' : 'No material change at display precision'
  const sign = trend.changePercent.startsWith('-') || trend.changePercent === '0.00' ? '' : '+'
  return <span className="inline-grid gap-0.5">
    <span className="inline-flex items-center gap-1.5 text-sm font-semibold text-text-strong"><Icon size={16} aria-hidden="true" />{sign}{trend.changePercent}% · {text}</span>
    {!compact && trend.startDate && trend.endDate && <span className="text-xs text-text-secondary">{formatAnalyticsDate(trend.startDate, true)} → {formatAnalyticsDate(trend.endDate, true)}</span>}
    {trend.compositionChanged && <span className="inline-flex items-center gap-1 text-xs text-text-secondary"><Users size={12} aria-hidden="true" />{compact ? 'Participants changed' : (trend.compositionNote ?? 'Participating Vendors changed between the dates.')}</span>}
  </span>
}

/** Explicit null state: never an empty chart or a fabricated line. */
export function AnalyticsNullState({ title, reason, action }: { title: string; reason: string; action?: ReactNode }) {
  return <section className="grid gap-2 rounded-control border border-dashed border-border-default bg-surface-canvas p-5" aria-label={title}>
    <p className="inline-flex items-center gap-2 font-semibold text-text-strong"><EyeOff size={18} aria-hidden="true" />{title}</p>
    <p className="text-sm text-text-secondary">{reason}</p>
    {action}
  </section>
}

/** Vendor competitor suppression: states the reason, never a count or identity. */
export function SuppressionNotice({ label = 'Insufficient Competitor Data' }: { label?: string }) {
  return <span className="inline-flex items-center gap-1.5 rounded-pill border border-border-default bg-surface-canvas px-2.5 py-1 text-xs font-semibold text-text-secondary">
    <ShieldCheck size={14} aria-hidden="true" />{label}<span className="sr-only"> — fewer than three competing Vendors; values and counts are withheld.</span>
  </span>
}

export function DatasetNotice({ label, updateSchedule, snapshotAt, currentAsOf, explanation }: { label: string; updateSchedule?: string | null; snapshotAt?: string | null; currentAsOf?: string | null; explanation?: string | null }) {
  const time = new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' })
  return <div className="grid gap-1 border-l-4 border-brand-orange-500 bg-brand-orange-50 px-4 py-3 text-sm text-text-strong">
    <p className="font-semibold">{label}</p>
    <p className="inline-flex flex-wrap items-center gap-x-3 gap-y-1 text-text-secondary"><span className="inline-flex items-center gap-1"><Clock size={14} aria-hidden="true" />{updateSchedule ?? 'Updated daily'}</span>
      {snapshotAt && <span>Last successful capture: {time.format(new Date(snapshotAt))} (Asia/Manila)</span>}
      {currentAsOf && <span>Current offers as of {time.format(new Date(currentAsOf))}</span>}</p>
    {explanation && <p className="text-text-secondary">{explanation}</p>}
  </div>
}

const BADGE_ICONS: Record<string, typeof Award> = { FAST_RESPONDER: Timer, ON_TIME: Clock, MOST_ORDERED: TrendingUp, HIGHLY_RATED: ThumbsUp, HIGH_QUALITY_MATERIALS: BadgeCheck, TRUSTED_SUPPLIER: ShieldCheck, BEST_PRICE: Tag }

/** Badge state is always text plus an icon. */
export function BadgeList({ badges, empty = 'No badges earned yet.' }: { badges: { code: string; name: string; scopeLabel?: string | null; description?: string | null }[]; empty?: string }) {
  if (badges.length === 0) return <p className="text-sm text-text-secondary">{empty}</p>
  return <ul className="flex flex-wrap gap-2" aria-label="Earned badges">{badges.map(badge => {
    const Icon = BADGE_ICONS[badge.code] ?? Award
    return <li key={`${badge.code}-${badge.scopeLabel ?? ''}`} title={badge.description ?? undefined} className="inline-flex min-h-8 items-center gap-1.5 rounded-pill border border-border-default bg-surface-primary px-3 text-xs font-semibold text-text-strong">
      <Icon size={14} className="text-action-primary" aria-hidden="true" />{badge.name}{badge.scopeLabel ? <span className="font-normal text-text-secondary"> · {badge.scopeLabel}</span> : null}
    </li>
  })}</ul>
}

export function StarRatingDisplay({ value, label }: { value: number; label: string }) {
  return <span className="inline-flex items-center gap-1" aria-label={`${label}: ${value} of 5`} role="img">
    {[1, 2, 3, 4, 5].map(star => <Star key={star} size={16} aria-hidden="true" className={star <= value ? 'fill-brand-orange-500 text-brand-orange-500' : 'text-border-default'} />)}
    <span className="ml-1 text-xs font-semibold text-text-strong" aria-hidden="true">{value}/5</span>
  </span>
}

/** A 1–5 radio group; score selection never submits its enclosing form. */
export function StarRatingInput({ legend, name, value, onChange, error, disabled = false, descriptionId, hideLegend = false }: { legend: string; name: string; value: number | null; onChange: (value: number) => void; error?: string | null; disabled?: boolean; descriptionId?: string; hideLegend?: boolean }) {
  const id = useId()
  const errorId = `${id}-error`
  const buttons = useRef<(HTMLButtonElement | null)[]>([])
  const describedBy = [descriptionId, error ? errorId : null].filter(Boolean).join(' ') || undefined
  function move(event: KeyboardEvent<HTMLButtonElement>, star: number) {
    const next = event.key === 'ArrowRight' || event.key === 'ArrowDown' ? star % 5 + 1
      : event.key === 'ArrowLeft' || event.key === 'ArrowUp' ? (star + 3) % 5 + 1
        : event.key === 'Home' ? 1 : event.key === 'End' ? 5 : null
    if (next === null || disabled) return
    event.preventDefault()
    event.stopPropagation()
    onChange(next)
    buttons.current[next - 1]?.focus()
  }
  return <fieldset className="grid min-w-0 gap-2" disabled={disabled}>
    <legend id={`${id}-legend`} className={hideLegend ? 'sr-only' : 'text-sm font-semibold text-text-strong'}>{legend}</legend>
    <div role="radiogroup" aria-labelledby={`${id}-legend`} aria-describedby={describedBy} aria-invalid={Boolean(error)} className="flex flex-wrap gap-1">
      {[1, 2, 3, 4, 5].map(star => <button key={star} ref={element => { buttons.current[star - 1] = element }} type="button" role="radio" name={name} value={star}
        aria-label={`${star} of 5`} aria-checked={value === star} tabIndex={star === (value ?? 1) ? 0 : -1} disabled={disabled}
        onClick={event => { event.preventDefault(); event.stopPropagation(); onChange(star) }} onKeyDown={event => move(event, star)}
        className={`inline-flex min-h-11 min-w-11 items-center justify-center rounded-control border transition-colors motion-reduce:transition-none hover:border-action-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring disabled:cursor-not-allowed disabled:opacity-60 ${value !== null && star <= value ? 'border-action-primary bg-brand-orange-50' : 'border-border-default bg-surface-primary'}`}>
        <Star size={20} aria-hidden="true" className={value !== null && star <= value ? 'fill-action-primary text-action-primary' : 'text-text-secondary'} />
      </button>)}
    </div>
    <p className="text-xs text-text-secondary">{value === null ? 'Choose a score' : `${value} of 5 selected`}</p>
    {error && <p id={errorId} className="text-sm text-status-error" role="alert">{error}</p>}
  </fieldset>
}

/** Published score or its sample-gate status — the neutral internal ranking value is never shown. */
export function ScoreTile({ name, value, published, sample, minimum, window: windowText, status }: { name: string; value: string | null; published: boolean; sample?: number; minimum?: number; window: string; status: string }) {
  return <div className="grid min-w-0 gap-1 border-l-2 border-border-default pl-4">
    <p className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">{name}</p>
    <p className="text-2xl font-semibold text-text-strong tabular-nums">{published && value ? value : <span className="inline-flex items-center gap-1.5 text-base"><AlertTriangle size={16} aria-hidden="true" />Not published</span>}</p>
    <p className="text-xs text-text-secondary">{windowText}{minimum ? ` · ${sample ?? 0} of ${minimum} needed` : ''}</p>
    {!published && <p className="text-xs text-text-secondary">{status}</p>}
  </div>
}

const SCORE_NAMES: Record<string, string> = { VPS: 'Vendor Performance Score', VCS: 'Vendor Community Score', MQS: 'Material Quality Score', OHS: 'Operational Health Score' }

/** Snapshot values and eligibility come from the API; this component never calculates a score. */
export function ScoreSummaryGrid({ scores }: { scores: { key: string; value?: string | null; published: boolean; sampleCount: number; minimumSample: number; window: string; statusText: string }[] }) {
  return <ul className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{scores.map(score => <li key={score.key} className="flex min-w-0 flex-col gap-3 rounded-surface border border-border-default bg-surface-primary p-5">
    <div className="flex flex-wrap items-center justify-between gap-2"><span className="text-sm font-semibold text-text-strong">{score.key}</span><StatusBadge label={score.published ? 'Published' : 'Building track record'} tone={score.published ? 'success' : 'neutral'} /></div>
    <p className="text-xs text-text-secondary">{SCORE_NAMES[score.key] ?? score.key}</p>
    <p className="text-3xl font-semibold tabular-nums text-text-strong">{score.published && score.value != null ? <>{score.value}<span className="ml-1 text-sm font-normal text-text-secondary">/ 5</span></> : <span className="text-xl">Not published</span>}</p>
    {score.minimumSample > 0 && <p className="text-sm text-text-secondary"><span className="font-semibold tabular-nums text-text-strong">{score.sampleCount}</span> eligible samples · {score.minimumSample} minimum</p>}
    <p className="mt-auto text-xs leading-5 text-text-secondary">{score.window}</p>
    {!score.published && <p className="border-t border-border-default pt-3 text-xs leading-5 text-text-secondary">{score.statusText}</p>}
  </li>)}</ul>
}

/** Eligibility descriptions and scope are kept visible, including for unearned badges. */
export function BadgeStatusList({ badges }: { badges: { code: string; name: string; description: string; status: string; scopes: { scopeLabel?: string | null }[] }[] }) {
  if (!badges.length) return <p className="text-sm text-text-secondary">No badge information is available.</p>
  return <ul className="grid gap-x-6 sm:grid-cols-2">{badges.map(badge => {
    const Icon = BADGE_ICONS[badge.code] ?? Award
    return <li key={badge.code} className="flex min-w-0 gap-3 border-b border-border-default py-4 last:border-b-0">
      <span className="flex size-10 shrink-0 items-center justify-center rounded-control bg-surface-canvas"><Icon size={20} aria-hidden="true" className={badge.status === 'EARNED' ? 'text-action-primary' : 'text-text-secondary'} /></span>
      <div className="min-w-0 space-y-2"><div className="flex flex-wrap items-center gap-2"><h3 className="text-sm font-semibold">{badge.name}</h3><StatusBadge label={badge.status === 'EARNED' ? 'Earned' : badge.status === 'SUPPRESSED' ? 'Suppressed' : 'Not earned'} tone={badge.status === 'EARNED' ? 'success' : badge.status === 'SUPPRESSED' ? 'warning' : 'neutral'} /></div>
        <p className="text-xs leading-5 text-text-secondary">{badge.description}</p>
        {badge.scopes.some(scope => scope.scopeLabel) && <p className="text-xs text-text-secondary">{badge.scopes.map(scope => scope.scopeLabel).filter(Boolean).join(' · ')}</p>}
      </div>
    </li>
  })}</ul>
}
