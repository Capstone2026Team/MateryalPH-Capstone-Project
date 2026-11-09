import { Award, BadgeCheck, CheckCircle2, MessageCircle, ShieldCheck, Star, Timer, TrendingUp } from 'lucide-react'
import { DashboardPanel } from './dashboard-patterns'
import { StatusBadge } from './portal-shell'
import './store-performance.css'

type PerformanceBadge = { code: string; name: string; status: string; description: string; scopes: { scopeLabel?: string | null | undefined }[] }
const BADGE_ICONS: Record<string, typeof Award> = { FAST_RESPONDER: MessageCircle, HIGHLY_RATED: Star, HIGH_QUALITY_MATERIALS: BadgeCheck, MOST_ORDERED: TrendingUp, ON_TIME: Timer, TRUSTED_SUPPLIER: ShieldCheck }

/** A decorative award graphic; the adjacent text always states the actual server status. */
function BadgeEmblem({ code, status }: { code: string; status: string }) {
  const Icon = BADGE_ICONS[code] ?? Award
  return <span className="mp-performance-emblem" data-status={status} aria-hidden="true">
    <svg viewBox="0 0 64 76" className="mp-performance-emblem-frame"><path className="mp-performance-emblem-ribbon" d="M18 46 15 71 32 62 49 71 46 46Z" /><path className="mp-performance-emblem-seal" d="m32 3 8 5 9 1 4 8 6 7-2 10 1 9-8 6-6 8-12-1-10 1-7-8-8-6 1-9-2-10 6-7 4-8 9-1Z" /><circle cx="32" cy="30" r="18" className="mp-performance-emblem-inner" /></svg>
    <Icon className="mp-performance-emblem-symbol" size={24} strokeWidth={1.7} />
    {status === 'EARNED' && <CheckCircle2 className="mp-performance-emblem-check" size={16} />}
  </span>
}

/** Read-only collection. A count summarizes statuses; it never assigns or predicts a badge. */
export function PerformanceBadges({ badges }: { badges: PerformanceBadge[] }) {
  const earned = badges.filter(badge => badge.status === 'EARNED').length
  return <DashboardPanel title="Badges" density="compact" description="Earned from your performance. Updated daily on your storefront." action={badges.length > 0 ? <span className="mp-performance-earned-count"><Award size={16} aria-hidden="true" /><strong>{earned} <span>of {badges.length}</span></strong> earned</span> : undefined}>
    {badges.length === 0 ? <p className="text-sm text-text-secondary">No badge records yet. Eligibility updates with the daily calculation.</p> : <ul className="mp-performance-badges" aria-label="Store badges">{badges.map(badge => <li key={badge.code} data-earned={badge.status === 'EARNED'}>
      <BadgeEmblem code={badge.code} status={badge.status} />
      <div className="mp-performance-badge-copy"><h3>{badge.name}</h3>
        <div className="w-fit"><StatusBadge label={badge.status === 'EARNED' ? 'Earned' : badge.status === 'SUPPRESSED' ? 'Suppressed by review' : 'Not earned'} tone={badge.status === 'EARNED' ? 'success' : badge.status === 'SUPPRESSED' ? 'warning' : 'neutral'} /></div>
        {badge.scopes.length > 0 && <p>{badge.scopes.map(scope => scope.scopeLabel).filter(Boolean).join(' · ')}</p>}
        <p>{badge.description}</p></div>
    </li>)}</ul>}
    <p className="mp-performance-badges-note">Badges follow the published thresholds. They cannot be requested or assigned manually.</p>
  </DashboardPanel>
}

/** The server percentage on a fixed 0–100 scale, with a decorative criterion-specific ring. */
export function PerformanceRateMetric({ kind, label, value, detail }: { kind: 'CRR' | 'FRR'; label: string; value?: string | null | undefined; detail: string }) {
  const parsed = value == null ? NaN : Number(value)
  const percent = Number.isFinite(parsed) && parsed >= 0 && parsed <= 100 ? parsed : null
  const Icon = kind === 'CRR' ? MessageCircle : Timer
  return <div className="mp-performance-rate-metric" data-available={percent !== null}>
    <dt>{label}</dt><dd className="mp-performance-rate-value">{percent === null ? '—' : `${value}%`}</dd><dd className="mp-performance-rate-detail">{detail}</dd>
    <dd className="mp-performance-rate-graphic" aria-hidden="true"><svg viewBox="0 0 64 64"><circle className="mp-performance-rate-track" cx="32" cy="32" r="26" />{percent !== null && percent > 0 && <circle className="mp-performance-rate-arc" cx="32" cy="32" r="26" pathLength={100} strokeDasharray={`${percent} 100`} />}</svg><Icon size={20} strokeWidth={1.7} /></dd>
  </div>
}
