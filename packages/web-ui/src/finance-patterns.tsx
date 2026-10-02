import type { ReactNode } from 'react'
import { AlertOctagon, BadgeCheck, CircleDashed, Clock, FlaskConical, History, Percent, Search, ShieldCheck, XCircle } from 'lucide-react'
import { formatPesoCentavos } from './order-patterns'
import { StatusBadge } from './portal-shell'
import { formatManilaDateTime, type DateLike } from './stock-ledger'

type Tone = 'success' | 'warning' | 'error' | 'info' | 'neutral'

/** Visible label for every simulated figure (FIN-12). Text, not color, carries the meaning. */
export function DemoLabel({ children = 'DEMO — simulated figures' }: { children?: ReactNode }) {
  return <span className="inline-flex min-h-7 items-center gap-1.5 rounded-pill border border-amber-300 bg-amber-50 px-2.5 text-xs font-semibold uppercase tracking-wide text-amber-900">
    <FlaskConical size={14} aria-hidden="true" />{children}
  </span>
}

const withholdingStatus: Record<string, { label: string; tone: Tone; icon: typeof ShieldCheck }> = {
  RELIEF_ACTIVE: { label: 'Relief active — no withholding', tone: 'success', icon: ShieldCheck },
  SUBJECT_STANDARD: { label: 'Subject to withholding — standard', tone: 'warning', icon: Percent },
  SUBJECT_THRESHOLD_BREACHED: { label: 'Subject to withholding — threshold crossed', tone: 'error', icon: AlertOctagon },
  SUBJECT_PRIOR_YEAR: { label: 'Subject to withholding — prior year above threshold', tone: 'warning', icon: History },
  UNDER_REVIEW: { label: 'Under review — standard rate applies', tone: 'info', icon: Search },
  NOT_STARTED: { label: 'No remittance assessed this taxable year', tone: 'neutral', icon: CircleDashed },
}

/** FIN-04A status as text plus icon; the canonical value is never shown as EXEMPT or SUBJECT_TO_WITHHOLDING. */
export function WithholdingStatusBadge({ status }: { status: string }) {
  const meta = withholdingStatus[status] ?? withholdingStatus.NOT_STARTED!
  const Icon = meta.icon
  return <StatusBadge label={meta.label} tone={meta.tone} icon={<Icon size={14} aria-hidden="true" />} />
}

export type ThresholdPanelData = {
  taxableYear: number
  thresholdCentavos: number
  cumulativeGrossCentavos: number
  remainingAllowanceCentavos: number
  localGrossCentavos: number
  externalDeclaredCentavos: number
  externalOverlapCentavos: number
  externalOverlapState: string
  percentOfThreshold: number
  advisory: boolean
  status: string
  reasonCode?: string | null | undefined
  crossedAt?: DateLike
  priorYearTotalCentavos?: number | null | undefined
  finalForYearNotice: string
}

/**
 * FIN-04A threshold panel: taxable year, cumulative gross remittances in pesos, the remaining allowance floored at
 * zero, status as text and icon, the crossing date and time in Asia/Manila, and the plain sentence that crossing
 * is final for the year. The meter is decorative reinforcement of the stated numbers, never the only signal.
 */
export function ThresholdPanel({ data, headingLevel = 2 }: { data: ThresholdPanelData; headingLevel?: 2 | 3 }) {
  const Heading = headingLevel === 2 ? 'h2' : 'h3'
  const percent = Math.max(0, Math.min(100, data.percentOfThreshold))
  const breached = data.crossedAt !== null && data.crossedAt !== undefined
  const meterTone = breached ? 'bg-red-700' : data.advisory ? 'bg-amber-600' : 'bg-action-primary'
  return <section className="grid gap-4" aria-labelledby="threshold-heading">
    <div className="flex flex-wrap items-center justify-between gap-3">
      <div>
        <Heading id="threshold-heading" className="text-lg font-semibold text-text-strong">Gross-remittance threshold — taxable year {data.taxableYear}</Heading>
        <p className="mt-1 text-sm text-text-secondary">₱500,000.00 cumulative gross remittances per taxpayer per taxable year (FIN-04A).</p>
      </div>
      <div className="flex flex-wrap gap-2"><WithholdingStatusBadge status={data.status} /><DemoLabel /></div>
    </div>
    {breached && <div role="status" className="flex gap-3 rounded-control border border-red-300 bg-red-50 p-3 text-sm text-red-900"><AlertOctagon className="mt-0.5 shrink-0" size={18} aria-hidden="true" />
      <p><strong>Threshold crossed on {formatManilaDateTime(data.crossedAt)} (Asia/Manila).</strong> {data.finalForYearNotice}</p></div>}
    {!breached && data.advisory && <div role="status" className="flex gap-3 rounded-control border border-amber-300 bg-amber-50 p-3 text-sm text-amber-900"><Clock className="mt-0.5 shrink-0" size={18} aria-hidden="true" />
      <p><strong>Advisory: 80% of the threshold reached.</strong> Withholding will apply to the whole remittance that crosses ₱500,000.00 and to every later one this taxable year.</p></div>}
    <dl className="grid gap-x-6 gap-y-4 sm:grid-cols-2 lg:grid-cols-4">
      <Figure label="Cumulative gross remittances" value={formatPesoCentavos(data.cumulativeGrossCentavos)} />
      <Figure label="Remaining allowance" value={formatPesoCentavos(Math.max(0, data.remainingAllowanceCentavos))} hint="Never below ₱0.00" />
      <Figure label="Threshold" value={formatPesoCentavos(data.thresholdCentavos)} />
      <Figure label="Crossing date and time" value={breached ? `${formatManilaDateTime(data.crossedAt)} (Asia/Manila)` : 'Not crossed'} />
    </dl>
    <div className="grid gap-1.5">
      <div className="flex justify-between text-xs font-semibold text-text-secondary"><span>{percent}% of threshold</span><span>{formatPesoCentavos(data.thresholdCentavos)}</span></div>
      <div className="h-2.5 overflow-hidden rounded-full bg-surface-canvas ring-1 ring-border-default" aria-hidden="true"><div className={`h-full ${meterTone}`} style={{ width: `${percent}%` }} /></div>
    </div>
    <dl className="grid gap-x-6 gap-y-2 border-t border-border-default pt-3 text-sm sm:grid-cols-2">
      <SmallFigure label="On-platform gross" value={formatPesoCentavos(data.localGrossCentavos)} />
      <SmallFigure label="Declared outside-platform" value={`${formatPesoCentavos(data.externalDeclaredCentavos)}${data.externalOverlapState === 'UNRESOLVED' ? ' (overlap under review)' : data.externalOverlapCentavos > 0 ? ` less ${formatPesoCentavos(data.externalOverlapCentavos)} already counted` : ''}`} />
      {data.priorYearTotalCentavos !== null && data.priorYearTotalCentavos !== undefined && <SmallFigure label="Prior taxable year total" value={formatPesoCentavos(data.priorYearTotalCentavos)} />}
      {data.reasonCode && <SmallFigure label="Status reason" value={data.reasonCode.replaceAll('_', ' ').toLowerCase()} />}
    </dl>
    <p className="text-sm text-text-secondary">{data.finalForYearNotice}</p>
  </section>
}

function Figure({ label, value, hint }: { label: string; value: string; hint?: string }) {
  return <div className="grid gap-1"><dt className="text-xs font-semibold uppercase tracking-wide text-text-secondary">{label}</dt><dd className="text-xl font-semibold tabular-nums text-text-strong">{value}</dd>{hint && <dd className="text-xs text-text-secondary">{hint}</dd>}</div>
}

function SmallFigure({ label, value }: { label: string; value: string }) {
  return <div className="flex min-w-0 flex-wrap justify-between gap-x-3"><dt className="text-text-secondary">{label}</dt><dd className="font-semibold tabular-nums">{value}</dd></div>
}

const attemptStatus: Record<string, { label: string; tone: Tone; icon: typeof ShieldCheck }> = {
  PENDING: { label: 'Pending verification', tone: 'warning', icon: Clock },
  PAID: { label: 'Paid — verified by provider', tone: 'success', icon: BadgeCheck },
  FAILED: { label: 'Failed — not charged', tone: 'error', icon: XCircle },
  EXPIRED: { label: 'Expired — not charged', tone: 'neutral', icon: CircleDashed },
  CAPTURED_LATE_REFUND_PENDING: { label: 'Late capture — refund queued', tone: 'info', icon: History },
}

/** One payment attempt's status as text plus icon. Pending is never shown as success. */
export function PaymentAttemptBadge({ status }: { status: string }) {
  const meta = attemptStatus[status] ?? attemptStatus.PENDING!
  const Icon = meta.icon
  return <StatusBadge label={meta.label} tone={meta.tone} icon={<Icon size={14} aria-hidden="true" />} />
}

export type PaymentChannelRow = { code: string; displayName: string; available: boolean; unavailableReason?: string | null | undefined; refundSupported: boolean; rateLabel: string; feeCentavos?: number | null | undefined; totalCentavos?: number | null | undefined }

const unavailableText: Record<string, string> = {
  REFUND_ROUTE_UNAVAILABLE: 'Not offered: no approved refund route', PROVIDER_NOT_CONFIGURED: 'Provider not configured',
  ADAPTER_UNSUPPORTED: 'Not supported by the provider configuration', BELOW_CHANNEL_MINIMUM: 'Below channel minimum', ABOVE_CHANNEL_MAXIMUM: 'Above channel maximum',
}

/** Configured online channels with their DEMO rate and availability reason; amounts show only when quoted. */
export function PaymentChannelList({ channels, caption, showAmounts = false }: { channels: PaymentChannelRow[]; caption: string; showAmounts?: boolean }) {
  return <ul className="grid divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary" aria-label={caption}>
    {channels.map(channel => <li key={channel.code} className="flex min-h-11 flex-wrap items-center justify-between gap-x-4 gap-y-1 px-4 py-2.5 text-sm">
      <span className="grid gap-0.5"><span className="font-semibold text-text-strong">{channel.displayName}</span><span className="text-xs text-text-secondary">{channel.available ? `${channel.rateLabel} · DEMO rate` : (unavailableText[channel.unavailableReason ?? ''] ?? 'Unavailable')}</span></span>
      {channel.available
        ? <span className="flex items-center gap-2 text-sm font-semibold text-green-800"><BadgeCheck size={16} aria-hidden="true" />{showAmounts && channel.totalCentavos !== null && channel.totalCentavos !== undefined ? `${formatPesoCentavos(channel.totalCentavos)} incl. ${formatPesoCentavos(channel.feeCentavos ?? 0)} fee` : 'Available'}</span>
        : <span className="flex items-center gap-2 text-sm font-semibold text-text-secondary"><XCircle size={16} aria-hidden="true" />Disabled</span>}
    </li>)}
  </ul>
}

/** A titled section introduced by a heading and a 1px rule (no nested card). */
export function FinanceSection({ id, title, description, badge, children }: { id: string; title: string; description?: string; badge?: ReactNode; children: ReactNode }) {
  return <section aria-labelledby={`${id}-heading`} className="grid gap-4 border-t border-border-default pt-6 first:border-t-0 first:pt-0">
    <div className="flex flex-wrap items-start justify-between gap-3">
      <div className="max-w-3xl"><h2 id={`${id}-heading`} className="text-lg font-semibold text-text-strong">{title}</h2>{description && <p className="mt-1 text-sm text-text-secondary">{description}</p>}</div>
      {badge}
    </div>
    {children}
  </section>
}
