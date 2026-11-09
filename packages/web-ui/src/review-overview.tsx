import { useId } from 'react'
import { ChevronRight, MessageSquareText, Star } from 'lucide-react'
import { reviewRatingEntries } from './review-patterns'
import type { ProductReviewSummaryData, ReviewPresentationRow } from './review-details'
import './review-workspace.css'
import { ReviewAuthorAvatar } from './review-author-avatar'
import { RatingRing } from './rating-ring'

type ReviewType = 'VENDOR' | 'PRODUCT' | 'BUYER'

/** A read-only overview of the authorized page. Only the product summary covers every result. */
export function ReviewOverview({ rows, total, type, summary, onOpen, apiBasePath = '/api/v1' }: {
  rows: ReviewPresentationRow[]
  total: number
  type: ReviewType
  summary?: ProductReviewSummaryData
  onOpen: (review: ReviewPresentationRow) => void
  apiBasePath?: string
}) {
  const id = useId()
  const ratingsTitle = type === 'VENDOR' ? 'Community rating (VCS)' : type === 'PRODUCT' ? 'Material quality (MQS)' : 'Ratings'
  const primaryLabel = type === 'PRODUCT' ? 'Product Quality' : type === 'BUYER' ? 'Inquiry Seriousness' : 'Service Quality'
  const criteria = new Map<string, number[]>()
  for (const row of rows) for (const [label, value] of reviewRatingEntries(row.ratings)) {
    const values = criteria.get(label) ?? []
    values.push(value)
    criteria.set(label, values)
  }
  const primary = criteria.get(primaryLabel) ?? []
  const productSummary = type === 'PRODUCT' ? summary : undefined
  const average = productSummary ? productSummary.average : primary.length ? primary.reduce((sum, value) => sum + value, 0) / primary.length : null
  const count = productSummary?.count ?? primary.length
  const scope = productSummary ? 'All matching product reviews' : `${rows.length.toLocaleString()} ${rows.length === 1 ? 'review' : 'reviews'} on this page`
  const distribution = [1, 2, 3, 4, 5].map(stars => ({ stars, count: productSummary ? productSummary.distribution.find(bucket => bucket.stars === stars)?.count ?? 0 : primary.filter(value => value === stars).length }))
  const maximum = Math.max(1, ...distribution.map(bucket => bucket.count))
  const written = rows.filter(row => row.comment?.trim()).length

  return <div className="mp-review-overview">
    <section className="mp-card mp-review-overview-panel" aria-labelledby={`${id}-statistics`}>
      <div className="mp-review-panel-heading"><h2 id={`${id}-statistics`}>Review statistics</h2><MessageSquareText size={18} aria-hidden="true" /></div>
      <dl className="mp-review-statistics">
        <div><dt>Total {type === 'PRODUCT' ? 'reviews' : 'ratings'}</dt><dd>{total.toLocaleString()}</dd><span>Matching your filters</span></div>
        <div><dt>Written comments</dt><dd>{written.toLocaleString()}<span> / {rows.length.toLocaleString()}</span></dd><span>On this page</span></div>
      </dl>
      <figure className="mp-review-distribution" aria-labelledby={`${id}-distribution`}>
        <figcaption id={`${id}-distribution`}><strong>{primaryLabel} distribution</strong><span>{scope}</span></figcaption>
        <div className="mp-review-bars">{distribution.map(bucket => <div className="mp-review-bar-column" key={bucket.stars}>
          <span className="mp-review-bar-count" aria-hidden="true">{bucket.count}</span>
          <div className="mp-review-bar-track"><div role="meter" aria-label={`${bucket.stars} ${bucket.stars === 1 ? 'star' : 'stars'}`} aria-valuemin={0} aria-valuemax={Math.max(1, count)} aria-valuenow={bucket.count} aria-valuetext={`${bucket.count} of ${count} ratings`} className={`mp-review-bar${bucket.stars === 5 ? ' mp-review-bar-highest' : ''}`} style={{ height: `${bucket.count / maximum * 100}%` }} /></div>
          <span className="mp-review-bar-label" aria-hidden="true">{bucket.stars}<Star size={11} /></span>
        </div>)}</div>
      </figure>
    </section>

    <section className="mp-card mp-review-overview-panel" aria-labelledby={`${id}-ratings`}>
      <div className="mp-review-panel-heading"><h2 id={`${id}-ratings`}>{ratingsTitle}</h2><Star size={18} aria-hidden="true" /></div>
      <RatingRing value={average} label={primaryLabel} detail={`${count.toLocaleString()} ${count === 1 ? 'rating' : 'ratings'}`} accessibleLabel={`${primaryLabel}: ${average === null ? 'not yet rated' : `${average.toFixed(1)} out of 5`}. ${scope}.`} />
      <dl className="mp-review-criterion-averages">{Array.from(criteria, ([label, values]) => {
        const value = label === primaryLabel && productSummary ? productSummary.average : values.reduce((sum, rating) => sum + rating, 0) / values.length
        return <div key={label}><dt>{label}</dt><dd><Star size={13} aria-hidden="true" />{value === null ? '—' : value.toFixed(1)}<span>/5</span></dd></div>
      })}</dl>
      <p className="mp-review-scope">{scope}. {type === 'VENDOR' ? 'Separate criteria; not a VPS or VCS score.' : type === 'BUYER' ? 'Ratings submitted by your store.' : 'Product Quality only.'}</p>
    </section>

    <section className="mp-card mp-review-overview-panel mp-review-highlights-panel" aria-labelledby={`${id}-highlights`}>
      <div className="mp-review-panel-heading"><h2 id={`${id}-highlights`}>Recent feedback</h2><span className="mp-review-heading-note">On this page</span></div>
      <div className="mp-review-highlights">{rows.slice(0, 3).map(row => {
        const rating = reviewRatingEntries(row.ratings)[0]
        return <button className="mp-review-highlight" type="button" key={row.id} onClick={() => onOpen(row)} aria-label={`Open recent feedback by ${row.displayName || 'Reviewer unavailable'}`}>
          <ReviewAuthorAvatar review={row} apiBasePath={apiBasePath} />
          <span className="mp-review-highlight-copy"><strong>{row.displayName || 'Reviewer unavailable'}</strong>{rating && <span className="mp-review-highlight-rating"><Star size={12} aria-hidden="true" />{rating[1]}/5 <span>{rating[0]}</span></span>}<span className="mp-review-highlight-comment">{row.comment?.trim() || 'No written comment.'}</span></span>
          <ChevronRight size={15} aria-hidden="true" />
        </button>
      })}</div>
      <p className="mp-review-scope">Select feedback to read the full review and view its attachments.</p>
    </section>
  </div>
}
