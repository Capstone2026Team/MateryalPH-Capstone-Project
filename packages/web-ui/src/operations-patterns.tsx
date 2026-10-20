import { useId, useState, type FormEvent, type ReactNode } from 'react'
import { AlertTriangle, CheckCircle2, CircleSlash, Clock3, HelpCircle, XCircle } from 'lucide-react'
import { Button } from './button'

export type HealthState = 'HEALTHY' | 'DEGRADED' | 'FAILING' | 'NOT_CONFIGURED' | 'UNKNOWN' | 'IDLE'

const HEALTH: Record<HealthState, { label: string; className: string; Icon: typeof CheckCircle2 }> = {
  HEALTHY: { label: 'Healthy', className: 'border-green-300 bg-green-50 text-green-900', Icon: CheckCircle2 },
  DEGRADED: { label: 'Degraded', className: 'border-amber-300 bg-amber-50 text-amber-900', Icon: AlertTriangle },
  FAILING: { label: 'Failing', className: 'border-red-300 bg-red-50 text-red-900', Icon: XCircle },
  NOT_CONFIGURED: { label: 'Not configured', className: 'border-border-default bg-surface-canvas text-text-secondary', Icon: CircleSlash },
  IDLE: { label: 'Idle', className: 'border-border-default bg-surface-primary text-text-secondary', Icon: Clock3 },
  UNKNOWN: { label: 'Unknown', className: 'border-border-default bg-surface-primary text-text-secondary', Icon: HelpCircle },
}

/** Health is always an icon and a word, never colour alone. */
export function HealthBadge({ state, label }: { state: string; label?: string }) {
  const health = HEALTH[(state in HEALTH ? state : 'UNKNOWN') as HealthState]
  const { Icon } = health
  return <span className={`inline-flex min-h-8 items-center gap-2 rounded-pill border px-3 text-xs font-semibold ${health.className}`}><Icon size={14} aria-hidden="true" />{label ?? health.label}</span>
}

/** Read-only label/value pairs; values wrap instead of truncating. */
export function FactList({ facts, columns = 2 }: { facts: { label: string; value: ReactNode }[]; columns?: 1 | 2 | 3 }) {
  const grid = columns === 3 ? 'sm:grid-cols-2 xl:grid-cols-3' : columns === 2 ? 'sm:grid-cols-2' : ''
  return <dl className={`grid min-w-0 gap-x-6 gap-y-4 ${grid}`}>
    {facts.map(fact => <div key={fact.label} className="min-w-0"><dt className="text-[13px] font-medium text-text-secondary">{fact.label}</dt><dd className="mt-1 break-words text-sm text-text-strong">{fact.value ?? '—'}</dd></div>)}
  </dl>
}

export type TimelineEvent = { id: string; title: string; at: string | Date; actor?: string | null; detail?: ReactNode; tone?: 'neutral' | 'success' | 'warning' | 'error' }

/** Append-only history, newest first as the API returns it. */
export function EventTimeline({ label, events, formatDate, empty = 'No events have been recorded.' }: { label: string; events: TimelineEvent[]; formatDate: (value: string | Date) => string; empty?: string }) {
  if (events.length === 0) return <p className="text-sm text-text-secondary">{empty}</p>
  const dot = { neutral: 'bg-text-secondary', success: 'bg-status-success', warning: 'bg-amber-500', error: 'bg-status-error' }
  return <ol aria-label={label} className="grid gap-0">
    {events.map((event, index) => <li key={event.id} className="relative grid grid-cols-[16px_minmax(0,1fr)] gap-3 pb-4">
      <span aria-hidden="true" className="relative flex justify-center"><span className={`mt-1.5 h-2.5 w-2.5 rounded-full ${dot[event.tone ?? 'neutral']}`} />{index < events.length - 1 && <span className="absolute top-5 bottom-[-4px] w-px bg-border-default" />}</span>
      <div className="min-w-0">
        <p className="break-words text-sm font-semibold text-text-strong">{event.title}</p>
        <p className="text-[13px] text-text-secondary"><time dateTime={new Date(event.at).toISOString()}>{formatDate(event.at)}</time>{event.actor ? ` · ${event.actor}` : ''}</p>
        {event.detail && <div className="mt-1 break-words text-sm text-text-strong">{event.detail}</div>}
      </div>
    </li>)}
  </ol>
}

/**
 * The single decision surface for Admin queues: it names the exact target and version being decided, shows the
 * before → after change, requires a written reason, and surfaces a stale-version conflict instead of retrying.
 * Authorization is enforced by the API; this form only reflects it.
 */
export function ReasonedDecisionForm({ title, target, version, before, after, submitLabel, variant = 'primary', minReason = 10, maxReason = 1000, busy = false, submitDisabled = false, error, conflict, onReload, onSubmit, children }: {
  title: string; target: string; version?: number | string | null; before?: ReactNode; after?: ReactNode; submitLabel: string; variant?: 'primary' | 'danger'
  minReason?: number; maxReason?: number; busy?: boolean; submitDisabled?: boolean; error?: string | null; conflict?: string | null; onReload?: () => void; onSubmit: (reason: string) => void; children?: ReactNode
}) {
  const [reason, setReason] = useState('')
  const [touched, setTouched] = useState(false)
  const reasonId = useId(), hintId = useId(), errorId = useId(), headingId = useId()
  const trimmed = reason.trim()
  const invalid = trimmed.length < minReason
  const submit = (event: FormEvent) => {
    event.preventDefault()
    setTouched(true)
    if (invalid || busy || submitDisabled) return
    onSubmit(trimmed)
  }
  return <form onSubmit={submit} aria-labelledby={headingId} noValidate className="grid min-w-0 gap-4 rounded-surface border border-border-default bg-surface-primary p-4">
    <div>
      <h3 id={headingId} className="text-base font-semibold text-text-strong">{title}</h3>
      <p className="mt-1 break-words text-sm text-text-secondary">Decision target: <span className="font-semibold text-text-strong">{target}</span>{version !== undefined && version !== null ? <> · version <span className="tabular-nums">{version}</span></> : null}</p>
    </div>
    {(before !== undefined || after !== undefined) && <dl className="grid min-w-0 gap-3 sm:grid-cols-2">
      <div className="min-w-0 rounded-control border border-border-default bg-surface-canvas p-3"><dt className="text-[13px] font-medium text-text-secondary">Before</dt><dd className="mt-1 break-words text-sm text-text-strong">{before ?? '—'}</dd></div>
      <div className="min-w-0 rounded-control border border-action-primary/40 bg-brand-orange-50 p-3"><dt className="text-[13px] font-medium text-text-secondary">After</dt><dd className="mt-1 break-words text-sm font-semibold text-text-strong">{after ?? '—'}</dd></div>
    </dl>}
    {children}
    <div className="grid gap-2">
      <label htmlFor={reasonId} className="text-sm font-semibold text-text-strong">Reason <span className="text-status-error" aria-hidden="true">*</span></label>
      <textarea id={reasonId} value={reason} maxLength={maxReason} rows={3} required disabled={busy} onBlur={() => setTouched(true)} onChange={event => setReason(event.target.value)}
        aria-invalid={touched && invalid} aria-describedby={touched && invalid ? errorId : hintId}
        className={`min-h-24 w-full min-w-0 rounded-control border bg-surface-primary px-3 py-2 text-base text-text-strong focus:border-focus-ring focus:ring-2 focus:ring-focus-ring/20 ${touched && invalid ? 'border-status-error' : 'border-border-default'}`} />
      {touched && invalid ? <span id={errorId} role="alert" className="text-sm text-status-error">Enter a reason of at least {minReason} characters.</span>
        : <span id={hintId} className="text-sm text-text-secondary">The reason is recorded in the audit history with your name. {trimmed.length}/{maxReason}</span>}
    </div>
    {conflict && <div role="alert" className="flex flex-wrap items-center justify-between gap-3 rounded-control border border-amber-300 bg-amber-50 px-4 py-3 text-sm text-amber-900">
      <span className="min-w-0 flex-1">{conflict}</span>{onReload && <Button variant="secondary" onClick={onReload}>Reload latest</Button>}
    </div>}
    {error && !conflict && <p role="alert" className="rounded-control border border-status-error/30 bg-red-50 px-4 py-3 text-sm text-red-900">{error}</p>}
    <div className="flex justify-end"><Button type="submit" variant={variant} disabled={busy || submitDisabled}>{busy ? 'Saving…' : submitLabel}</Button></div>
  </form>
}
