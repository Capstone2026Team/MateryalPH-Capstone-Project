import { useId, type ReactNode } from 'react'
import type { BuyerRatingSummary } from '@materyalph/api-client-ts'
import { Activity, AlertTriangle, BadgeCheck, CheckCircle2, CircleX, ClipboardList, RotateCcw, ShieldAlert, ShieldCheck, Star, Truck, type LucideIcon } from 'lucide-react'
import { CalculationHelp } from './calculation-help'
import { SampleMeter } from './insight-patterns'
import { RatingRing } from './rating-ring'
import { publishedScoreValue, ScoreComponentBars, ScoreGauge, type PublishedScore } from './score-overview'
import './store-performance.css'

export function PerformanceRating({ value, label, empty }: { value: string | number | null | undefined; label: string; empty: string }) {
  return <span role="img" className="inline-flex items-center gap-1.5 whitespace-nowrap text-sm" aria-label={`${label}: ${value == null ? empty : `${Number(value).toFixed(2)} out of 5`}`}>
    <Star size={15} aria-hidden="true" className={value == null ? 'text-text-secondary' : 'text-action-primary'} />
    {value == null ? <span className="text-text-secondary">{empty}</span> : <><strong className="tabular-nums">{Number(value).toFixed(2)}</strong><span className="text-xs text-text-secondary">/ 5</span></>}
  </span>
}

export function BuyerPerformanceCard({ summary }: { summary: BuyerRatingSummary }) {
  return <PublishedRatingCard title="Buyer rating (CCS)" description="Contractor Community Score" icon={<Star size={26} />} score={{
    key: 'CCS', value: summary.score == null ? null : String(summary.score), published: summary.score != null,
    sampleCount: summary.count, minimumSample: summary.minimumCount, window: `Rolling ${summary.windowDays} days`,
    statusText: 'Building your rating — needs 5 eligible completed transactions',
  }} sampleLabel="eligible completed transactions" criteria={[
    { label: 'Inquiry seriousness', value: summary.inquirySeriousness },
    { label: 'Communication quality', value: summary.communicationQuality },
    { label: 'Payment reliability', value: summary.paymentReliability },
  ]} calculation="CCS = (Inquiry Seriousness + Communication Quality + Payment Reliability) ÷ 3. Uses eligible, visible Vendor ratings on completed transactions in the rolling 90-day window. Published after at least five eligible completed transactions. Disputed, moderated and excluded sources follow the existing eligibility rules."
    note={`Rolling ${summary.windowDays} days · Vendor ratings on eligible completed transactions.`} />
}

export function PublishedRatingCard({ title, description, icon, score, criteria, calculation, note, sampleLabel = 'eligible ratings', children }: { title: string; description?: string; icon?: ReactNode; score?: PublishedScore | undefined; criteria: { label: string; value: number | null; icon?: ReactNode }[]; calculation: ReactNode; note: string; sampleLabel?: string; children?: ReactNode }) {
  const id = useId()
  const value = publishedScoreValue(score)
  return <section className="mp-card mp-performance-rating" aria-labelledby={id}>
    <header className="mp-performance-card-heading"><div><h2 id={id}>{title}</h2>{description && <p>{description}</p>}</div><CalculationHelp title={title}>{calculation}</CalculationHelp></header>
    <div className="mp-performance-rating-summary"><RatingRing layout="summary" icon={icon} value={value} label={value === null ? 'Not yet published' : 'Published score'} detail={`${score?.sampleCount ?? 0} ${sampleLabel}`} precision={2} accessibleLabel={`${title}: ${value === null ? 'not published' : `${value.toFixed(2)} out of 5`}`} /></div>
    {value === null && score && <div className="mp-performance-eligibility"><p>{score.statusText}</p>{score.minimumSample > 0 && <SampleMeter label={`${score.key} sample`} value={score.sampleCount} minimum={score.minimumSample} />}</div>}
    {criteria.length > 0 && <div className="mp-performance-rating-body"><h3>Rating breakdown</h3><dl className="mp-performance-criteria">{criteria.map(criterion => {
      const available = criterion.value !== null && Number.isFinite(criterion.value)
      return <div key={criterion.label}><dt><span className="mp-performance-criterion-icon" aria-hidden="true">{criterion.icon ?? <Star size={15} />}</span>{criterion.label}</dt><dd><span className="mp-performance-criterion-value"><Star size={12} aria-hidden="true" />{available ? criterion.value!.toFixed(2) : '—'}<small>/ 5</small></span><span className="mp-performance-criterion-track" aria-hidden="true"><span style={{ width: `${available ? Math.max(0, Math.min(100, criterion.value! / 5 * 100)) : 0}%` }} /></span></dd></div>
    })}</dl></div>}
    {children}
    <p className="mp-performance-card-note">{note}</p>
  </section>
}

/** The same published Vendor MQS, wherever its existing score permission permits it. */
export function MaterialQualityCard({ score }: { score?: PublishedScore | undefined }) {
  return <PublishedRatingCard title="Material quality (MQS)" description="Quality across your sold materials" icon={<BadgeCheck size={26} />} score={score} criteria={[{ label: 'Product Quality', icon: <BadgeCheck size={15} />, value: publishedScoreValue(score) }]} calculation="Average of eligible Product Quality ratings across your sold products over a rolling 90 days. Published after at least five eligible product ratings. Separate from an individual product's rating." note="Rolling 90 days · Product Quality across your sold materials." />
}

export function VendorPerformanceCard({ score, publicLabel, facts, calculation, components = [] }: { score?: PublishedScore | undefined; publicLabel: string; facts: { label: string; value: ReactNode }[]; calculation: ReactNode; components?: PublishedScore[] }) {
  const value = publishedScoreValue(score)
  return <section aria-label="Public standing" className="mp-card mp-performance-vps mp-viz">
    <header className="mp-performance-card-heading"><h2>Vendor performance (VPS)</h2><CalculationHelp title="Vendor performance (VPS)">{calculation}</CalculationHelp></header>
    <figure className="mp-performance-vps-gauge" aria-label={`Vendor performance (VPS): ${value === null ? 'not published' : `${value.toFixed(2)} out of 5`}`}>
      <ScoreGauge score={score} star />
      <figcaption><strong>{value === null ? '—' : value.toFixed(2)}{value !== null && <small> / 5</small>}</strong><span className="mp-performance-publication">{value !== null && <CheckCircle2 size={13} aria-hidden="true" />}{value === null ? 'Not yet published' : 'Published score'}</span></figcaption>
    </figure>
    <p className="mp-performance-vps-status">{value === null ? publicLabel : 'What Buyers see on your storefront'}</p>
    <p className="mp-performance-vps-formula">50% community rating + 50% operational health</p>
    {components.length > 0 && <div className="mp-performance-vps-components"><ScoreComponentBars scores={components} compact illustrated showEligibility={false} /></div>}
    <dl className="mp-performance-vps-facts">{facts.map(fact => <div key={fact.label}><dt>{fact.label}</dt><dd>{fact.value}</dd></div>)}</dl>
  </section>
}

const OPERATION_ICONS: Record<string, LucideIcon> = { NFR: CircleX, LSR: Truck, RR: RotateCcw, ODR: ShieldAlert, LVD: ClipboardList }

export function ScoreBreakdown({ rows }: { rows: { key: string; label: string; value: string; detail: string }[] }) {
  return <div className="mp-performance-rating-body"><h3>Operational factors</h3><dl className="mp-performance-breakdown" aria-label="Operational health components">{rows.map(row => {
    const Icon = OPERATION_ICONS[row.key] ?? Activity
    return <div key={row.key}><dt><span className="mp-performance-factor-icon" aria-hidden="true"><Icon size={15} /></span>{row.label}</dt><dd><strong>{row.value}</strong><span>{row.detail}</span></dd></div>
  })}</dl></div>
}

export type StoreHealthClassification = { _class: string; label: string; path: string[] }

/** Display the server's decision tree without deriving a second classification. */
export function StoreHealthIndicator({ classification, asOf, pending, error, retry, density = 'comfortable' }: { classification?: StoreHealthClassification | null | undefined; asOf: string; pending?: boolean; error?: string | null; retry?: ReactNode; density?: 'comfortable' | 'compact' }) {
  const id = useId()
  const state = classification?._class
  const Icon = state === 'HEALTHY' ? CheckCircle2 : state === 'BELOW_WATCH_LEVEL' || state === 'WATCH' ? AlertTriangle : ShieldCheck
  return <section className="mp-card mp-performance-health" aria-labelledby={id} data-density={density}>
    <header className="mp-performance-card-heading"><div><h2 id={id}>Store health indicator</h2><p>Scores as of {asOf}</p></div><Activity size={18} aria-hidden="true" /></header>
    {classification ? <><p className="mp-performance-health-state" data-state={state}><Icon size={17} aria-hidden="true" />{classification.label}</p><ul className="mp-performance-health-reasons">{classification.path.map(reason => <li key={reason}>{reason}</li>)}</ul></> : <div className="mp-performance-health-unavailable"><p role={error ? 'alert' : 'status'}>{error ?? (pending ? 'Loading store health…' : 'Store health is unavailable.')}</p>{retry}</div>}
    <footer className="mp-performance-card-note mp-performance-health-help"><span>How this is calculated</span><CalculationHelp title="Store health indicator"><p>The server checks published VPS and OHS, their sample gates and the workflow's OHS penalty bands. VPS below 3.00 or OHS below 2.50 is below the workflow watch level; a rate outside its no-penalty band is Watch.</p><p>This planning indicator does not change scores, badges, discovery or sanctions.</p></CalculationHelp></footer>
  </section>
}
