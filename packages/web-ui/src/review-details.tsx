import { useEffect, useId, useState, type ReactNode } from 'react'
import type { ReviewMediaLink, VendorReviewRow } from '@materyalph/api-client-ts'
import { ChevronRight, Flag, Image, ShieldCheck, Star, UserRound, Video } from 'lucide-react'
import { ReviewRatingSummary } from './review-patterns'
import { AsyncLoading } from './async-state'
import { Button } from './button'
import { readReviewMediaFile } from './web-api-session'
import { ReviewAuthorAvatar } from './review-author-avatar'
import { MaterialThumbnail } from './material-thumbnail'
import './review-workspace.css'

export type ReviewPresentationRow = VendorReviewRow & {
  product?: { listingId: string; name: string; variantLabel?: string | null } | null
}

export type ProductReviewSummaryData = {
  count: number
  average: number | null
  distribution: { stars: number; count: number }[]
}

function reviewTime(value: Date | undefined) {
  if (!value || !Number.isFinite(value.getTime())) return null
  return { iso: value.toISOString(), shortLabel: value.toLocaleDateString('en-PH', { timeZone: 'Asia/Manila', month: 'short', day: 'numeric', year: 'numeric' }), label: value.toLocaleString('en-PH', { timeZone: 'Asia/Manila', month: 'short', day: 'numeric', year: 'numeric', hour: 'numeric', minute: '2-digit' }) }
}

function reviewLabel(review: ReviewPresentationRow) {
  return review.product?.name || (review.type === 'BUYER' ? 'Buyer rating' : review.type === 'PRODUCT' ? 'Product review' : 'Store rating')
}

function mediaCounts(media: ReviewMediaLink[]) {
  const photos = media.filter(item => item.contentType?.startsWith('image/')).length
  const videos = media.filter(item => item.contentType?.startsWith('video/')).length
  const other = media.length - photos - videos
  return [photos ? `${photos} ${photos === 1 ? 'photo' : 'photos'}` : '', videos ? `${videos} ${videos === 1 ? 'video' : 'videos'}` : '', other ? `${other} ${other === 1 ? 'attachment' : 'attachments'}` : ''].filter(Boolean).join(' · ')
}

/** A review's whole main area opens its details; reporting remains a separate action. Media loads only in details. */
export function ReviewListCard({ review, onOpen, onReport, compact = false, apiBasePath = '/api/v1' }: {
  review: ReviewPresentationRow
  onOpen: () => void
  onReport?: () => void
  compact?: boolean
  apiBasePath?: string
}) {
  const time = reviewTime(review.submittedAt)
  const variant = review.product?.variantLabel ?? review.variantLabel
  const media = review.media ?? []
  return <article className={`min-w-0 bg-surface-primary${compact ? ' mp-review-card' : ''}`}>
    <button type="button" onClick={onOpen} aria-label={`View ${reviewLabel(review)} details by ${review.displayName || 'Reviewer unavailable'}`} className="group flex w-full min-w-0 flex-col gap-4 p-5 text-left text-text-strong transition-colors hover:bg-surface-canvas focus-visible:outline-2 focus-visible:-outline-offset-2 focus-visible:outline-focus-ring motion-reduce:transition-none sm:p-6">
      <span className="flex min-w-0 items-start gap-3">
        <ReviewAuthorAvatar review={review} apiBasePath={apiBasePath} className={compact ? 'mp-review-avatar' : 'mp-review-avatar mp-review-avatar-large'} />
        <span className="grid min-w-0 flex-1 gap-1">
          <span className={compact ? 'break-words text-sm font-semibold leading-5' : 'break-words text-base font-semibold leading-6'}>{compact ? review.displayName || 'Reviewer unavailable' : reviewLabel(review)}</span>
          {compact ? <span className="break-words text-xs text-text-secondary"><span>{reviewLabel(review)}</span>{variant ? ` · ${variant}` : ''}</span> : <>{variant && <span className="break-words text-xs text-text-secondary">Variant: {variant}</span>}<span className="break-words text-sm text-text-secondary">{review.type === 'BUYER' ? 'Submitted by' : 'Buyer'} <span className="font-medium text-text-strong">{review.displayName || 'Reviewer unavailable'}</span></span></>}
        </span>
        <ChevronRight size={20} className="mt-1 shrink-0 text-text-secondary group-hover:text-action-primary" aria-hidden="true" />
      </span>
      <ReviewRatingSummary ratings={review.ratings} compact={compact} />
      <span className={`${compact ? 'line-clamp-3' : 'line-clamp-2'} break-words text-sm leading-6 ${review.comment?.trim() ? 'text-text-strong' : 'text-text-secondary'}`}>{review.comment?.trim() || 'No written comment.'}</span>
      <span className="flex flex-wrap items-center gap-x-3 gap-y-2 text-xs text-text-secondary">
        {review.verifiedPurchase && <span className="inline-flex items-center gap-1.5"><ShieldCheck size={14} aria-hidden="true" />Verified purchase</span>}
        {time ? <time dateTime={time.iso} title={`${time.label} (Asia/Manila)`}>{compact ? time.shortLabel : `${time.label} (Asia/Manila)`}</time> : <span>Time unavailable</span>}
        {review.edited && <span>Edited</span>}
      </span>
      <span className="flex w-full flex-wrap items-center justify-between gap-2 border-t border-border-default pt-3">
        <span className="inline-flex flex-wrap items-center gap-2 text-xs text-text-secondary">{media.length > 0 ? <><Image size={15} aria-hidden="true" />{mediaCounts(media)}</> : 'No attachments'}</span>
        <span className="inline-flex items-center gap-1 text-sm font-semibold text-action-primary">View details<ChevronRight size={16} aria-hidden="true" /></span>
      </span>
    </button>
    {(review.orderReference || onReport) && <div className={`flex min-w-0 flex-wrap items-center justify-between gap-x-4 gap-y-1 border-t border-border-default px-5 py-2 sm:px-6${compact ? ' mp-review-card-footer' : ''}`}>
      {review.orderReference && <p className="break-words text-xs text-text-secondary">Order {review.orderReference}</p>}
      {onReport && <Button variant="quiet" onClick={onReport} className="ml-auto px-2 text-sm"><Flag size={16} aria-hidden="true" />Report</Button>}
    </div>}
  </article>
}

/** All-time, server-calculated Product Quality totals across every variant of the selected product. */
export function ProductReviewSummary({ summary, compact = false }: { summary: ProductReviewSummaryData; compact?: boolean }) {
  const id = useId()
  return <section aria-labelledby={`${id}-heading`} className="grid min-w-0 gap-6" style={{ gridTemplateColumns: 'repeat(auto-fit, minmax(min(100%, 240px), 1fr))' }}>
    <div>
      <h3 id={`${id}-heading`} className={`${compact ? 'text-sm' : 'text-base'} font-semibold`}>Product Quality rating</h3>
      <div className="mt-3 flex items-baseline gap-2"><span className={`inline-flex items-center gap-2 ${compact ? 'text-3xl' : 'text-4xl'} font-bold tabular-nums`}><Star size={compact ? 20 : 24} className="self-center fill-brand-orange-500 text-brand-orange-500" aria-hidden="true" />{summary.average === null ? '—' : summary.average.toFixed(1)}</span><span className="text-sm text-text-secondary">out of 5</span></div>
      <p className="mt-2 text-sm text-text-secondary">{summary.count.toLocaleString()} {summary.count === 1 ? 'review' : 'reviews'} · All time</p>
      {!compact && <p className="mt-2 text-xs leading-5 text-text-secondary">Published, verified-purchase reviews across all product variants.</p>}
    </div>
    <div className="grid content-center gap-3" aria-label="Product rating distribution">
      {[5, 4, 3, 2, 1].map(stars => {
        const count = summary.distribution.find(item => item.stars === stars)?.count ?? 0
        const percent = summary.count > 0 ? Math.min(100, Math.max(0, count / summary.count * 100)) : 0
        return <div key={stars} className="flex items-center gap-3">
          <span className="inline-flex w-12 shrink-0 items-center gap-1 text-sm tabular-nums" aria-hidden="true">{stars}<Star size={14} className="text-text-secondary" /></span>
          <div role="meter" aria-label={`${stars} ${stars === 1 ? 'star' : 'stars'}`} aria-valuemin={0} aria-valuemax={Math.max(1, summary.count)} aria-valuenow={count} aria-valuetext={`${count} ${count === 1 ? 'review' : 'reviews'}, ${Math.round(percent)} percent`} className="h-2.5 min-w-0 flex-1 overflow-hidden rounded-pill bg-surface-canvas"><div className="h-full rounded-pill bg-action-primary" style={{ width: `${percent}%` }} /></div>
          <span className="w-12 shrink-0 text-right text-sm tabular-nums text-text-secondary" aria-hidden="true">{count.toLocaleString()}</span>
        </div>
      })}
    </div>
  </section>
}

/** Review text and private photos/videos share the same presentation in reviews and product analytics. */
export function ReviewDetailContent({ review, apiBasePath, productAction, onRefreshMedia, refreshingMedia = false, compact = false }: {
  review: ReviewPresentationRow
  apiBasePath: string
  productAction?: ReactNode
  onRefreshMedia?: () => void
  refreshingMedia?: boolean
  compact?: boolean
}) {
  const id = useId()
  const time = reviewTime(review.submittedAt)
  const variant = review.product?.variantLabel ?? review.variantLabel
  const media = review.media ?? []
  return <div className={`min-w-0 mp-card${compact ? ' mp-review-detail-compact' : ''}`}>
    <section className="grid min-w-0 gap-5 p-5 sm:p-6" aria-labelledby={`${id}-product`}>
      <div className="flex min-w-0 flex-col gap-4 lg:flex-row lg:items-center lg:justify-between">
        <div className="flex min-w-0 items-center gap-4">
          {review.type === 'PRODUCT' ? <MaterialThumbnail url={review.product?.imageUrl} alt={reviewLabel(review)} size="lg" /> : <span className="grid h-11 w-11 shrink-0 place-items-center rounded-control border border-border-default bg-surface-canvas text-text-secondary"><UserRound size={21} aria-hidden="true" /></span>}
          <div className="min-w-0"><p className="mb-1 text-xs font-medium uppercase tracking-wide text-text-secondary">{review.type === 'PRODUCT' ? 'Product reviewed' : review.type === 'BUYER' ? 'Buyer rating' : 'Store rating'}</p><h2 id={`${id}-product`} className="break-words text-lg font-semibold">{reviewLabel(review)}</h2>{variant && <p className="mt-1 break-words text-sm text-text-secondary">Variant: {variant}</p>}</div>
        </div>
        {review.type === 'PRODUCT' && productAction && <div className="flex shrink-0">{productAction}</div>}
      </div>
      <dl className="grid min-w-0 gap-4 border-t border-border-default pt-5 sm:grid-cols-2">
        <div className="min-w-0"><dt className="text-xs text-text-secondary">{review.type === 'BUYER' ? 'Submitted by' : 'Buyer'}</dt><dd className="mt-2 flex items-center gap-3 break-words text-sm font-semibold"><ReviewAuthorAvatar review={review} apiBasePath={apiBasePath} />{review.displayName || 'Reviewer unavailable'}</dd></div>
        <div className="min-w-0"><dt className="text-xs text-text-secondary">Submitted</dt><dd className="mt-1 text-sm">{time ? <time dateTime={time.iso}>{time.label} (Asia/Manila)</time> : 'Time unavailable'}{review.edited && <span className="ml-2 text-xs text-text-secondary">Edited</span>}</dd></div>
      </dl>
      {review.verifiedPurchase && <p className="inline-flex items-center gap-2 text-xs font-medium text-text-secondary"><ShieldCheck size={16} aria-hidden="true" />Verified purchase</p>}
    </section>
    <section className="grid gap-4 border-t border-border-default p-5 sm:p-6" aria-labelledby={`${id}-rating`}><h2 id={`${id}-rating`} className="text-base font-semibold">Star rating</h2><ReviewRatingSummary ratings={review.ratings} /></section>
    <section className="grid gap-3 border-t border-border-default p-5 sm:p-6" aria-labelledby={`${id}-comment`}><h2 id={`${id}-comment`} className="text-base font-semibold">Comment</h2><p className={`whitespace-pre-wrap break-words text-sm leading-7 ${review.comment?.trim() ? 'text-text-strong' : 'text-text-secondary'}`}>{review.comment?.trim() || 'No written comment was included with this review.'}</p></section>
    <section className="grid gap-4 border-t border-border-default p-5 sm:p-6" aria-labelledby={`${id}-media`}>
      <div className="flex flex-wrap items-start justify-between gap-3"><div><h2 id={`${id}-media`} className="text-base font-semibold">Photos &amp; videos</h2><p className="mt-1 text-xs leading-5 text-text-secondary">{media.length > 0 ? `${mediaCounts(media)} · Open a photo to view it full size. Load videos when ready to watch.` : 'No photos or videos were attached to this review.'}</p></div>{media.length > 0 && onRefreshMedia && <Button variant="secondary" disabled={refreshingMedia} onClick={onRefreshMedia} className="text-sm">{refreshingMedia ? 'Refreshing…' : 'Refresh attachments'}</Button>}</div>
      {media.length > 0 && <div className="grid min-w-0 gap-4 sm:grid-cols-2 xl:grid-cols-3">{media.map((item, index) => <ReviewMediaPreview key={item.id} item={item} index={index + 1} apiBasePath={apiBasePath} />)}</div>}
    </section>
  </div>
}

function ReviewMediaPreview({ item, index, apiBasePath }: { item: ReviewMediaLink; index: number; apiBasePath: string }) {
  const isVideo = item.contentType?.startsWith('video/') ?? false
  const isPhoto = item.contentType?.startsWith('image/') ?? false
  const label = `${isVideo ? 'Video' : isPhoto ? 'Photo' : 'Attachment'} ${index}`
  const [requested, setRequested] = useState(isPhoto)
  const [attempt, setAttempt] = useState(0)
  const [preview, setPreview] = useState<{ source: string; url: string; type: string } | null>(null)
  const [failed, setFailed] = useState(false)
  const [playbackFailed, setPlaybackFailed] = useState(false)
  useEffect(() => {
    let active = true
    let objectUrl = ''
    setPreview(null)
    setFailed(false)
    setPlaybackFailed(false)
    const clear = () => {
      active = false
      if (objectUrl) URL.revokeObjectURL(objectUrl)
      objectUrl = ''
      setPreview(null)
    }
    window.addEventListener('materyalph:session-cleared', clear)
    if (requested) void readReviewMediaFile(apiBasePath, item.url).then(blob => {
      if (!active) return
      objectUrl = URL.createObjectURL(blob)
      setPreview({ source: item.url, url: objectUrl, type: blob.type })
    }).catch(() => { if (active) setFailed(true) })
    return () => {
      active = false
      window.removeEventListener('materyalph:session-cleared', clear)
      if (objectUrl) URL.revokeObjectURL(objectUrl)
    }
  }, [apiBasePath, item.url, requested, attempt])
  const current = preview?.source === item.url ? preview : null
  return <figure className="grid min-w-0 content-start gap-3 rounded-control border border-border-default p-3">
    <figcaption className="flex items-center gap-2 text-sm font-medium">{isVideo ? <Video size={17} aria-hidden="true" /> : <Image size={17} aria-hidden="true" />}{label}</figcaption>
    {!requested ? <div className="grid min-h-48 content-center justify-items-center gap-3 rounded-control bg-surface-canvas p-4"><Video size={28} className="text-text-secondary" aria-hidden="true" /><p className="text-center text-xs leading-5 text-text-secondary">{item.byteSize ? `${(item.byteSize / (1024 * 1024)).toFixed(1)} MB · ` : ''}Loads when selected.</p><Button variant="secondary" onClick={() => setRequested(true)}>Load {isVideo ? 'video' : 'attachment'}</Button></div>
      : failed ? <div role="alert" className="grid min-h-48 content-center justify-items-center gap-3 rounded-control bg-surface-canvas p-4"><p className="text-center text-sm text-text-secondary">This attachment could not be loaded. Retry or refresh attachments for a new link.</p><Button variant="secondary" onClick={() => setAttempt(value => value + 1)}>Retry {label.toLowerCase()}</Button></div>
        : !current ? <AsyncLoading label={`Loading ${label.toLowerCase()}…`} className="rounded-control bg-surface-canvas" />
          : current.type.startsWith('image/') ? <a href={current.url} target="_blank" rel="noopener noreferrer" aria-label={`Open ${label.toLowerCase()} full size`} className="flex min-h-48 items-center justify-center overflow-hidden rounded-control bg-surface-canvas focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring"><img src={current.url} alt={`Buyer review ${label.toLowerCase()}`} className="max-h-72 w-full object-contain" onError={() => setFailed(true)} /></a>
            : <div className="grid gap-3">{!playbackFailed && <video src={current.url} controls preload="metadata" aria-label={`Buyer review ${label.toLowerCase()}`} className="min-h-48 max-h-72 w-full rounded-control bg-surface-canvas" onError={() => setPlaybackFailed(true)} />}{playbackFailed && <p role="status" className="text-sm leading-6 text-text-secondary">This browser cannot play this video. Download it to watch with a compatible player.</p>}<a href={current.url} download={`review-video-${index}${current.type.startsWith('video/quicktime') ? '.mov' : '.mp4'}`} className="inline-flex min-h-11 items-center justify-center rounded-control px-3 text-sm font-semibold text-action-primary underline underline-offset-4 focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring">Download {label.toLowerCase()}</a></div>}
  </figure>
}
