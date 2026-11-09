import type { ReactNode } from 'react'
import './rating-ring.css'

/** A fixed five-point scale. The caller supplies the value, eligibility and scope. */
export function RatingRing({ value, label, detail, accessibleLabel, precision = 1, layout = 'centered', icon }: { value: number | null; label: string; detail: string; accessibleLabel?: string; precision?: number; layout?: 'centered' | 'summary'; icon?: ReactNode }) {
  const rating = value !== null && Number.isFinite(value) && value >= 1 && value <= 5 ? value : null
  const circumference = 2 * Math.PI * 76
  return <figure className="mp-review-ring" data-layout={layout} data-available={rating !== null} aria-label={accessibleLabel ?? `${label}: ${rating === null ? 'not published' : `${rating.toFixed(precision)} out of 5`}. ${detail}.`}>
    <div className="mp-review-ring-graphic" aria-hidden="true"><svg viewBox="0 0 176 176"><circle className="mp-review-ring-track" cx="88" cy="88" r="76" />{rating !== null && <circle className="mp-review-ring-value" cx="88" cy="88" r="76" strokeDasharray={circumference} strokeDashoffset={circumference * (1 - rating / 5)} />}</svg>{icon && <span className="mp-review-ring-icon">{icon}</span>}</div>
    <figcaption><span>{label}</span><strong>{rating === null ? '—' : rating.toFixed(precision)}{rating !== null && <small>/ 5</small>}</strong><span>{detail}</span></figcaption>
  </figure>
}
