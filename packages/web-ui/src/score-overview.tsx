import { useId } from 'react'
import { ShieldCheck, Star, UsersRound } from 'lucide-react'
import { AnalyticsDetails, SampleMeter } from './insight-patterns'
import './geo-analytics.css'

export type PublishedScore = { key: string; value?: string | null; published: boolean; sampleCount: number; minimumSample: number; window: string; statusText: string }
const NAMES: Record<string, string> = { VPS: 'Vendor performance', VCS: 'Community rating', MQS: 'Material quality', OHS: 'Operational health' }
export const publishedScoreValue = (score: PublishedScore | undefined) => {
  const value = score?.value == null ? NaN : Number(score.value)
  return score?.published && Number.isFinite(value) && value >= 1 && value <= 5 ? value : null
}

/** Published component values on a fixed five-point scale; missing scores remain unfilled. */
export function ScoreComponentBars({ scores, compact = false, showEligibility = true, illustrated = false }: { scores: PublishedScore[]; compact?: boolean; showEligibility?: boolean; illustrated?: boolean }) {
  return <ul className="grid min-w-0 gap-3">{scores.map(score => {
    const number = publishedScoreValue(score)
    const Icon = score.key === 'OHS' ? ShieldCheck : UsersRound
    return <li key={score.key} data-score-key={score.key} className={`grid min-w-0 gap-1.5${illustrated ? ' mp-performance-component-row' : ''}`}>
      {illustrated && <span className="mp-performance-component-icon" aria-hidden="true"><Icon size={18} strokeWidth={1.7} /></span>}
      <div className={`flex flex-wrap items-baseline justify-between gap-x-3 gap-y-1 ${compact ? 'text-xs' : 'text-[10px]'}`}><span className="font-medium text-text-strong">{NAMES[score.key] ?? score.key} <span className="text-text-secondary">({score.key})</span></span><span className="shrink-0 tabular-nums text-text-strong">{number === null ? 'Not published' : `${number.toFixed(2)} / 5`}</span></div>
      <div aria-hidden="true" className="h-2 overflow-hidden rounded-pill bg-surface-canvas"><div className="h-full rounded-pill" style={{ width: `${number === null ? 0 : number / 5 * 100}%`, background: 'var(--mp-viz-series-1)' }} /></div>
      {number === null && <p className="text-xs leading-5 text-text-secondary">{score.statusText}</p>}
      {showEligibility && number === null && score.minimumSample > 0 && <SampleMeter label={`${score.key} sample`} value={score.sampleCount} minimum={score.minimumSample} />}
    </li>
  })}</ul>
}

/** The same five-point gauge, with a star treatment for the public VPS card. */
export function ScoreGauge({ score, star = false }: { score?: PublishedScore | undefined; star?: boolean }) {
  const titleId = useId()
  const value = publishedScoreValue(score)
  return <svg viewBox="0 0 200 112" role="img" aria-labelledby={titleId} className={star ? 'mp-performance-star-gauge mx-auto max-w-full' : 'mx-auto h-24 w-44 max-w-full'}>
    <title id={titleId}>{score ? `${score.key}: ${value === null ? 'Not published' : `${value.toFixed(2)} out of 5`}` : 'No published score'}</title>
    <path d="M20 100 A80 80 0 0 1 180 100" pathLength={100} fill="none" stroke="var(--mp-viz-placeholder)" strokeWidth={17} strokeLinecap="round" />
    {value !== null && <path d="M20 100 A80 80 0 0 1 180 100" pathLength={100} fill="none" stroke="var(--mp-viz-series-1)" strokeWidth={17} strokeLinecap="round" strokeDasharray={`${value / 5 * 100} 100`} />}
    {star ? <g aria-hidden="true">
      {Array.from({ length: 6 }, (_, index) => { const angle = Math.PI + index / 5 * Math.PI; return <line key={index} x1={100 + Math.cos(angle) * 61} y1={100 + Math.sin(angle) * 61} x2={100 + Math.cos(angle) * 68} y2={100 + Math.sin(angle) * 68} stroke="var(--mp-color-border-default)" strokeWidth={2} strokeLinecap="round" /> })}
      <circle cx={100} cy={83} r={23} fill="var(--mp-color-brand-orange-50)" />
      <Star x={85} y={68} width={30} height={30} fill={value === null ? 'none' : 'var(--mp-color-action-primary)'} strokeWidth={1.7} color="var(--mp-color-action-primary)" />
    </g> : value !== null && <g transform={`rotate(${value / 5 * 180 - 90} 100 100)`}><path d="M94 100 Q100 87 106 100 L100 49 Z" fill="var(--mp-color-text-strong)" /><circle cx={100} cy={100} r={6} fill="var(--mp-viz-series-1)" stroke="var(--mp-color-surface-primary)" strokeWidth={3} /></g>}
  </svg>
}

/** Published values only. A gauge and fixed /5 bars never calculate or infer a score. */
export function ScoreOverview({ scores, compact = false }: { scores: PublishedScore[]; compact?: boolean }) {
  const primary = scores.find(score => score.key === 'VPS') ?? scores[0]
  const value = publishedScoreValue(primary)
  const secondary = scores.filter(score => score !== primary)
  return <div className="mp-viz min-w-0">
    <div className="grid items-center gap-3 @container">
      <div className="grid items-center gap-4 @min-[19rem]:grid-cols-[8rem_minmax(0,1fr)]">
        <figure className="m-0 text-center">
          <ScoreGauge score={primary} />
          <p className="mt-1 text-xl font-semibold tabular-nums" style={{ color: 'var(--mp-viz-series-1)' }}>{value === null ? '—' : value.toFixed(2)}{value !== null && <span className="text-xs font-normal"> / 5.00</span>}</p>
          {value === null && <p className="text-xs text-text-secondary">Not yet published</p>}
          <figcaption className="mt-1 text-xs font-semibold text-text-strong">{primary ? NAMES[primary.key] ?? primary.key : 'Published scores'}</figcaption>
          {!compact && primary && value === null && <p className="mt-1 text-xs leading-5 text-text-secondary">{primary.statusText}</p>}
          {!compact && primary && value === null && primary.minimumSample > 0 && <div className="mt-2"><SampleMeter label={`${primary.key} sample`} value={primary.sampleCount} minimum={primary.minimumSample} /></div>}
        </figure>
        <ScoreComponentBars scores={secondary} compact={compact} />
      </div>
    </div>
    {compact && primary && value === null && <div className="mt-4 grid gap-2 rounded-control bg-surface-canvas px-3 py-2.5"><p className="text-xs leading-5 text-text-secondary">{primary.statusText}</p>{primary.minimumSample > 0 && <SampleMeter label={`${primary.key} sample`} value={primary.sampleCount} minimum={primary.minimumSample} />}</div>}
    {!compact && <AnalyticsDetails title="Score details"><dl className="grid gap-4 sm:grid-cols-2">{scores.map(score => <div key={score.key} className="min-w-0 text-xs leading-5"><dt className="font-semibold text-text-strong">{score.key}</dt><dd className="text-text-secondary">{score.window}{score.minimumSample > 0 ? ` · ${score.sampleCount} eligible samples · ${score.minimumSample} minimum` : ''}</dd></div>)}</dl></AnalyticsDetails>}
  </div>
}

const SCORE_METHODS: Record<string, string> = {
  VPS: '50% Community rating (VCS) + 50% Operational health (OHS). Published only when both are eligible.',
  VCS: 'Average of Service Quality, Delivery/Processing Speed and Material Quality (MQS). Requires at least five eligible Vendor ratings and an eligible MQS.',
  MQS: 'Average of eligible Product Quality ratings across your sold products. Requires at least five eligible product ratings.',
  OHS: 'Starts at 5.00, with the workflow penalties for non-fulfillment, late shipment, returns, order defects and confirmed listing violations deducted. Limited to 1.00–5.00; requires at least ten eligible orders in 30 days.',
}

export function ScoreCalculationDetails({ scores }: { scores: PublishedScore[] }) {
  return <div className="grid gap-4"><p className="text-xs leading-5 text-text-secondary">Scores are calculated by the system. Unpublished scores stay hidden until their eligibility requirements are met.</p><dl className="grid gap-4">{scores.map(score => <div key={score.key} className="min-w-0 text-xs leading-5"><dt className="font-semibold text-text-strong">{NAMES[score.key] ?? score.key} ({score.key})</dt><dd className="mt-1 text-text-secondary">{SCORE_METHODS[score.key] ?? score.statusText}</dd><dd className="mt-1 text-text-secondary">{score.window}{score.minimumSample > 0 ? ` · ${score.sampleCount} eligible samples · ${score.minimumSample} minimum` : ''}</dd></div>)}</dl></div>
}
