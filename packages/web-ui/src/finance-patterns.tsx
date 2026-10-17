import type { ReactNode } from 'react'
import { AlertOctagon, BadgeCheck, CircleDashed, Clock, FlaskConical, Gauge, History, Percent, Search, ShieldCheck, XCircle } from 'lucide-react'
import { formatPesoCentavos } from './order-patterns'
import { StatusBadge } from './portal-shell'
import { formatManilaDateTime, type DateLike } from './stock-ledger'

type Tone = 'success' | 'warning' | 'error' | 'info' | 'neutral'

export type FinanceCalculationRow = { key: string; label: string; amountCentavos: number; deduction?: boolean }

/** Display recorded calculation components; the authoritative total is supplied by the API. */
export function FinanceCalculationBreakdown({ caption, rows, totalLabel, totalCentavos }: {
  caption: string; rows: readonly FinanceCalculationRow[]; totalLabel: string; totalCentavos: number
}) {
  return <div className="overflow-hidden rounded-control border border-border-default">
    <table className="w-full border-collapse text-sm">
      <caption className="sr-only">{caption}</caption>
      <thead className="bg-surface-canvas text-xs text-text-secondary"><tr><th scope="col" className="px-4 py-2.5 text-left font-semibold">Item</th><th scope="col" className="px-4 py-2.5 text-right font-semibold">Amount</th></tr></thead>
      <tbody>{rows.map(row => <tr key={row.key} className="border-t border-border-default">
        <th scope="row" className="px-4 py-3 text-left font-normal text-text-secondary">{row.label}</th>
        <td className="whitespace-nowrap px-4 py-3 text-right font-medium tabular-nums text-text-strong">{formatPesoCentavos(row.deduction && row.amountCentavos !== 0 ? -row.amountCentavos : row.amountCentavos)}</td>
      </tr>)}</tbody>
      <tfoot><tr className="border-t border-border-default bg-surface-canvas text-text-strong"><th scope="row" className="px-4 py-3.5 text-left font-semibold">{totalLabel}</th><td className="whitespace-nowrap px-4 py-3.5 text-right font-semibold tabular-nums">{formatPesoCentavos(totalCentavos)}</td></tr></tfoot>
    </table>
  </div>
}

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
  calculationBreakdown?: {
    collectionsCentavos: number; refundsCentavos: number; deliveryCentavos: number; materialVatCentavos: number
    providerChargesCentavos: number; grossBasisCentavos: number; withheldCentavos: number; assessedCashCentavos: number
  } | null | undefined
}

/**
 * FIN-04A threshold panel: taxable year, cumulative gross remittances in pesos, the remaining allowance floored at
 * zero, status as text and icon, the crossing date and time in Asia/Manila, and the plain sentence that crossing
 * is final for the year. The meter is decorative reinforcement of the stated numbers, never the only signal.
 */
export function ThresholdPanel({ data, headingLevel = 2, showDemoLabel = true, layout = 'standard' }: { data: ThresholdPanelData; headingLevel?: 2 | 3; showDemoLabel?: boolean; layout?: 'standard' | 'overview' }) {
  const Heading = headingLevel === 2 ? 'h2' : 'h3'
  const overview = layout === 'overview'
  const percent = Math.max(0, Math.min(100, data.percentOfThreshold))
  const breached = data.crossedAt !== null && data.crossedAt !== undefined
  const meterTone = breached ? 'bg-red-700' : data.advisory ? 'bg-amber-600' : 'bg-action-primary'
  const calculation = data.calculationBreakdown
  return <section className={`grid min-w-0 ${overview ? 'gap-6' : 'gap-4'}`} aria-labelledby="threshold-heading">
    <div className={overview ? 'flex min-w-0 flex-col gap-4 lg:flex-row lg:items-start lg:justify-between' : 'flex flex-wrap items-center justify-between gap-3'}>
      <div className={`flex min-w-0 items-start gap-3 ${overview ? 'flex-1' : ''}`}>
        {overview && <span className="grid size-10 shrink-0 place-items-center rounded-control bg-surface-canvas text-text-secondary"><Gauge size={20} aria-hidden="true" /></span>}
        <div className="min-w-0">
        <Heading id="threshold-heading" className="text-lg font-semibold text-text-strong">Gross-remittance threshold — taxable year {data.taxableYear}</Heading>
        <p className="mt-1 text-sm leading-6 text-text-secondary">₱500,000.00 cumulative gross remittances per taxpayer per taxable year (FIN-04A).</p>
        </div>
      </div>
      <div className="flex min-w-0 max-w-full flex-wrap gap-2 [&>span]:max-w-full [&>span]:whitespace-normal"><WithholdingStatusBadge status={data.status} />{showDemoLabel && <DemoLabel />}</div>
    </div>
    {breached && <div role="status" className="flex gap-3 rounded-control border border-red-300 bg-red-50 p-3 text-sm text-red-900"><AlertOctagon className="mt-0.5 shrink-0" size={18} aria-hidden="true" />
      <p><strong>Threshold crossed on {formatManilaDateTime(data.crossedAt)} (Asia/Manila).</strong> {data.finalForYearNotice}</p></div>}
    {!breached && data.advisory && <div role="status" className="flex gap-3 rounded-control border border-amber-300 bg-amber-50 p-3 text-sm text-amber-900"><Clock className="mt-0.5 shrink-0" size={18} aria-hidden="true" />
      <p><strong>Advisory: 80% of the threshold reached.</strong> Withholding will apply to the whole remittance that crosses ₱500,000.00 and to every later one this taxable year.</p></div>}
    <dl className={`grid min-w-0 gap-x-8 gap-y-5 sm:grid-cols-2 ${overview ? 'rounded-control bg-surface-canvas p-5 sm:p-6' : 'lg:grid-cols-4'}`}>
      <Figure label="Cumulative gross remittances" value={formatPesoCentavos(data.cumulativeGrossCentavos)} prominent={overview} />
      <Figure label="Remaining allowance" value={formatPesoCentavos(Math.max(0, data.remainingAllowanceCentavos))} hint="Never below ₱0.00" prominent={overview} />
      {!overview && <><Figure label="Threshold" value={formatPesoCentavos(data.thresholdCentavos)} />
        <Figure label="Crossing date and time" value={breached ? `${formatManilaDateTime(data.crossedAt)} (Asia/Manila)` : 'Not crossed'} /></>}
    </dl>
    <div className="grid gap-1.5">
      <div className="flex flex-wrap justify-between gap-2 text-xs font-semibold text-text-secondary"><span>{percent}% of threshold</span><span>{formatPesoCentavos(data.thresholdCentavos)}</span></div>
      <div className="h-2.5 overflow-hidden rounded-full bg-surface-canvas ring-1 ring-border-default" aria-hidden="true"><div className={`h-full ${meterTone}`} style={{ width: `${percent}%` }} /></div>
    </div>
    <dl className={`grid gap-x-8 border-t border-border-default text-sm sm:grid-cols-2 ${overview ? 'gap-y-4 pt-5' : 'gap-y-2 pt-3'}`}>
      {overview && <><SmallFigure label="Threshold" value={formatPesoCentavos(data.thresholdCentavos)} />
        <SmallFigure label="Crossing date and time" value={breached ? `${formatManilaDateTime(data.crossedAt)} (Asia/Manila)` : 'Not crossed'} /></>}
      <SmallFigure label="On-platform gross" value={formatPesoCentavos(data.localGrossCentavos)} />
      <SmallFigure label="Declared outside-platform" value={`${formatPesoCentavos(data.externalDeclaredCentavos)}${data.externalOverlapState === 'UNRESOLVED' ? ' (overlap under review)' : data.externalOverlapCentavos > 0 ? ` less ${formatPesoCentavos(data.externalOverlapCentavos)} already counted` : ''}`} />
      {data.priorYearTotalCentavos !== null && data.priorYearTotalCentavos !== undefined && <SmallFigure label="Prior taxable year total" value={formatPesoCentavos(data.priorYearTotalCentavos)} />}
      {data.reasonCode && <SmallFigure label="Status reason" value={data.reasonCode.replaceAll('_', ' ').toLowerCase()} />}
    </dl>
    <p className="text-sm leading-6 text-text-secondary">{data.finalForYearNotice}</p>
    {calculation && <div className="grid min-w-0 gap-6 lg:grid-cols-2">
      <div className="min-w-0">
        <p className="font-semibold text-text-strong">On-platform threshold calculation</p>
        <FinanceCalculationBreakdown caption="On-platform threshold calculation" rows={[
          { key: 'collected', label: 'Assessed collections, including Buyer fees', amountCentavos: calculation.collectionsCentavos },
          { key: 'refunds', label: 'Refunds allocated before assessment', amountCentavos: calculation.refundsCentavos, deduction: true },
          { key: 'delivery', label: 'Separately billed delivery', amountCentavos: calculation.deliveryCentavos, deduction: true },
          { key: 'vat', label: 'Included material VAT', amountCentavos: calculation.materialVatCentavos, deduction: true },
          { key: 'provider', label: 'Provider charges', amountCentavos: calculation.providerChargesCentavos, deduction: true },
        ]} totalLabel="On-platform gross toward threshold" totalCentavos={data.localGrossCentavos} />
      </div>
      <div className="min-w-0">
        <p className="font-semibold text-text-strong">Remittance cash for these assessments</p>
        <FinanceCalculationBreakdown caption="Remittance cash for these assessments" rows={[
          { key: 'gross', label: 'On-platform gross toward threshold', amountCentavos: calculation.grossBasisCentavos },
          { key: 'delivery', label: 'Add back delivery', amountCentavos: calculation.deliveryCentavos },
          { key: 'vat', label: 'Add back material VAT', amountCentavos: calculation.materialVatCentavos },
          { key: 'withheld', label: 'Assessed withholding', amountCentavos: calculation.withheldCentavos, deduction: true },
        ]} totalLabel="Estimated cash at assessment" totalCentavos={calculation.assessedCashCentavos} />
      </div>
    </div>}
    <div className={`rounded-control bg-surface-canvas text-sm leading-6 text-text-secondary ${overview ? 'border-l-2 border-action-primary p-4 sm:p-5' : 'border border-border-default p-3'}`}>
      <p className="font-semibold text-text-strong">How this is calculated</p>
      <p className="mt-1">The threshold measures the qualifying gross basis. Estimated remittance cash includes delivery and material VAT, and deducts withholding. Withholding does not reduce the threshold basis. Commission is billed separately.</p>
      <p className="mt-2">This panel covers taxable year {data.taxableYear} across stores with the same taxpayer identity, regardless of the Earnings date filter. Cumulative gross is on-platform gross plus declared outside-platform gross, less confirmed overlap.</p>
      <p className="mt-2">These are the amounts recorded at assessment. Earnings reflects later confirmed refunds. Before the year crosses {formatPesoCentavos(data.thresholdCentavos)}, a fully refunded collection is voided and removed from this threshold total; a partial refund does not change the posted basis. After crossing, refunds do not reduce this counter or restore relief.</p>
    </div>
  </section>
}

function Figure({ label, value, hint, prominent = false }: { label: string; value: string; hint?: string; prominent?: boolean }) {
  return <div className="grid min-w-0 content-start gap-2"><dt className={`text-xs font-semibold text-text-secondary ${prominent ? '' : 'uppercase tracking-wide'}`}>{label}</dt><dd className={`font-semibold tabular-nums text-text-strong [overflow-wrap:anywhere] ${prominent ? 'text-[28px] leading-9' : 'text-xl'}`}>{value}</dd>{hint && <dd className="text-xs text-text-secondary">{hint}</dd>}</div>
}

function SmallFigure({ label, value }: { label: string; value: string }) {
  return <div className="flex min-w-0 flex-wrap justify-between gap-x-3 gap-y-1"><dt className="text-text-secondary">{label}</dt><dd className="max-w-full font-semibold tabular-nums text-text-strong [overflow-wrap:anywhere]">{value}</dd></div>
}

const attemptStatus: Record<string, { label: string; tone: Tone; icon: typeof ShieldCheck }> = {
  PENDING: { label: 'Pending verification', tone: 'warning', icon: Clock },
  PAID: { label: 'Paid — verified by provider', tone: 'success', icon: BadgeCheck },
  FAILED: { label: 'Failed — not charged', tone: 'error', icon: XCircle },
  EXPIRED: { label: 'Expired — not charged', tone: 'neutral', icon: CircleDashed },
  CAPTURED_LATE_REFUND_PENDING: { label: 'Late capture — refund queued', tone: 'info', icon: History },
}

const paidRefundStatus: Record<string, { label: string; tone: Tone; icon: typeof ShieldCheck }> = {
  REFUNDED: { label: 'Paid — refunded', tone: 'neutral', icon: History },
  PARTIALLY_REFUNDED: { label: 'Paid — partially refunded', tone: 'info', icon: History },
  REFUND_PENDING: { label: 'Paid — refund pending', tone: 'warning', icon: Clock },
  REFUND_FAILED: { label: 'Paid — refund failed', tone: 'error', icon: XCircle },
}

const lateRefundStatus: Record<string, { label: string; tone: Tone; icon: typeof ShieldCheck }> = {
  REFUNDED: { label: 'Late capture — refunded', tone: 'neutral', icon: History },
  REFUND_FAILED: { label: 'Late capture — refund failed', tone: 'error', icon: XCircle },
}

/** One payment attempt's status as text plus icon. Pending is never shown as success. */
export function PaymentAttemptBadge({ status, refundStatus }: { status: string; refundStatus?: string | undefined }) {
  const meta = (refundStatus ? (status === 'PAID' ? paidRefundStatus[refundStatus] : status === 'CAPTURED_LATE_REFUND_PENDING' ? lateRefundStatus[refundStatus] : undefined) : undefined)
    ?? attemptStatus[status] ?? attemptStatus.PENDING!
  const Icon = meta.icon
  return <StatusBadge label={meta.label} tone={meta.tone} icon={<Icon size={14} aria-hidden="true" />} />
}

export type PaymentChannelRow = { code: string; displayName: string; available: boolean; unavailableReason?: string | null | undefined; refundSupported: boolean; rateLabel: string; feeCentavos?: number | null | undefined; totalCentavos?: number | null | undefined }

const unavailableText: Record<string, string> = {
  REFUND_ROUTE_UNAVAILABLE: 'Not offered: no approved refund route', PROVIDER_NOT_CONFIGURED: 'Provider not configured',
  ADAPTER_UNSUPPORTED: 'Not supported by the provider configuration', BELOW_CHANNEL_MINIMUM: 'Below channel minimum', ABOVE_CHANNEL_MAXIMUM: 'Above channel maximum',
}

/** Configured online channels with their DEMO rate and availability reason; amounts show only when quoted. */
export function PaymentChannelList({ channels, caption, showAmounts = false, layout = 'compact' }: { channels: PaymentChannelRow[]; caption: string; showAmounts?: boolean; layout?: 'compact' | 'columns' }) {
  const columns = layout === 'columns'
  const rate = (channel: PaymentChannelRow) => channel.available ? `${channel.rateLabel} · DEMO rate` : (unavailableText[channel.unavailableReason ?? ''] ?? 'Unavailable')
  return <div className="min-w-0">
    {columns && <div aria-hidden="true" className="hidden grid-cols-[minmax(0,1fr)_minmax(0,1.5fr)_auto] gap-4 border-b border-border-default pb-3 text-xs font-semibold text-text-secondary md:grid"><span>Payment channel</span><span>Published DEMO rate</span><span>Availability</span></div>}
    <ul className={`grid divide-y divide-border-default ${columns ? '' : 'rounded-surface border border-border-default bg-surface-primary'}`} aria-label={caption}>
    {columns && channels.length === 0 && <li className="py-5 text-sm text-text-secondary">No online payment channels are configured.</li>}
    {channels.map(channel => <li key={channel.code} className={columns ? 'grid min-w-0 grid-cols-[minmax(0,1fr)_auto] items-start gap-x-4 gap-y-1 py-4 text-sm md:grid-cols-[minmax(0,1fr)_minmax(0,1.5fr)_auto]' : 'flex min-h-11 flex-wrap items-center justify-between gap-x-4 gap-y-1 px-4 py-2.5 text-sm'}>
      <span className="grid min-w-0 gap-0.5"><span className="font-semibold text-text-strong [overflow-wrap:anywhere]">{channel.displayName}</span>{!columns && <span className="text-xs text-text-secondary">{rate(channel)}</span>}</span>
      {columns && <span className="col-start-1 row-start-2 text-xs leading-5 text-text-secondary [overflow-wrap:anywhere] md:col-start-2 md:row-start-1">{rate(channel)}</span>}
      {channel.available
        ? <span className={`flex items-center gap-2 text-sm font-semibold text-green-800 ${columns ? 'col-start-2 row-start-1 md:col-start-3' : ''}`}><BadgeCheck className="shrink-0" size={16} aria-hidden="true" />{showAmounts && channel.totalCentavos !== null && channel.totalCentavos !== undefined ? `${formatPesoCentavos(channel.totalCentavos)} incl. ${formatPesoCentavos(channel.feeCentavos ?? 0)} fee` : 'Available'}</span>
        : <span className={`flex items-center gap-2 text-sm font-semibold text-text-secondary ${columns ? 'col-start-2 row-start-1 md:col-start-3' : ''}`}><XCircle className="shrink-0" size={16} aria-hidden="true" />Disabled</span>}
    </li>)}
    </ul>
  </div>
}

/** A titled section with a divider; split layout keeps settings context beside its details on wide screens. */
export function FinanceSection({ id, title, description, badge, icon, children, layout = 'stacked' }: { id: string; title: string; description?: string; badge?: ReactNode; icon?: ReactNode; children: ReactNode; layout?: 'stacked' | 'split' }) {
  const split = layout === 'split'
  return <section aria-labelledby={`${id}-heading`} className={`grid min-w-0 gap-5 border-t border-border-default pt-6 first:border-t-0 first:pt-0 ${split ? 'xl:grid-cols-[minmax(0,1fr)_minmax(0,2fr)] xl:gap-10 xl:pt-8' : ''}`}>
    <div className={split ? (icon ? 'grid min-w-0 content-start grid-cols-[2.5rem_minmax(0,1fr)] gap-3' : 'min-w-0 space-y-3') : 'flex min-w-0 flex-wrap items-start justify-between gap-3'}>
      <div className={`flex min-w-0 max-w-3xl items-start gap-3 ${icon && split ? 'col-span-2' : ''}`}>
        {icon && <span aria-hidden="true" className="grid size-10 shrink-0 place-items-center rounded-control bg-surface-canvas text-text-secondary">{icon}</span>}
        <div className="min-w-0"><h2 id={`${id}-heading`} className="text-lg font-semibold leading-7 text-text-strong">{title}</h2>{description && <p className="mt-2 text-sm leading-6 text-text-secondary">{description}</p>}</div>
      </div>
      {badge && <div className={`min-w-0 max-w-full [&>span]:max-w-full [&>span]:whitespace-normal ${icon && split ? 'col-start-2' : ''}`}>{badge}</div>}
    </div>
    <div className="grid min-w-0 content-start gap-4">{children}</div>
  </section>
}

/** Readable finance facts with consistent spacing and wrapping for provider names and reconciliation times. */
export function FinanceDetails({ items, appearance = 'plain' }: { items: [string, ReactNode][]; appearance?: 'plain' | 'rows' }) {
  const rows = appearance === 'rows'
  return <dl className="grid min-w-0 gap-x-8 gap-y-5 sm:grid-cols-2">{items.map(([label, value]) => <div key={label} className={`min-w-0 space-y-2 ${rows ? 'border-b border-border-default pb-4' : ''}`}>
    <dt className={`text-xs text-text-secondary ${rows ? 'font-semibold' : 'font-medium'}`}>{label}</dt>
    <dd className="text-sm font-semibold leading-6 text-text-strong [overflow-wrap:anywhere]">{value}</dd>
  </div>)}</dl>
}
