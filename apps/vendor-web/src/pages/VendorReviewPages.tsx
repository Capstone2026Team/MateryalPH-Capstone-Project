import { useEffect, useId, useRef, useState, type FormEvent } from 'react'
import { Link, useLocation, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { ArrowLeft, Flag } from 'lucide-react'
import {
  ActiveFilters, ALL_DATES, Button, DateFilter, EmptyState, FilterTabs, FormDialog, InfoNote, Pagination,
  ProductReviewSummary, ReviewDetailContent, ReviewListCard, Select, StatusMessage,
  dateFilterLabel, type DateFilterRange,
} from '@materyalph/web-ui'
import { getReview, listReviews, reportReview, type FlagReason, type ReviewTab, type VendorReviewRow } from '../lib/trust-api'
import { readableOrderError } from '../lib/orders-api'
import { dateRangeFromParams, dateRangePatch } from '../lib/date-filters'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { ErrorState, LoadingState, PageHeader } from './PhaseThreeVendorPages'

const TABS: { value: ReviewTab; label: string }[] = [
  { value: 'VENDOR', label: 'Store ratings' }, { value: 'PRODUCT', label: 'Product reviews' }, { value: 'BUYER', label: 'Your Buyer ratings' },
]
const FLAG_REASONS: { value: FlagReason; label: string }[] = [
  { value: 'OFFENSIVE', label: 'Offensive language' }, { value: 'PERSONAL_INFORMATION', label: 'Personal information' },
  { value: 'SPAM', label: 'Spam' }, { value: 'IRRELEVANT', label: 'Not about this purchase' },
  { value: 'CONFLICT_OF_INTEREST', label: 'Conflict of interest' }, { value: 'FALSE_CLAIM', label: 'False claim' }, { value: 'OTHER', label: 'Other' },
]
const apiBasePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const link = 'inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-action-primary underline-offset-4 hover:underline'

function useReviews(type: ReviewTab, page: number, from?: string, to?: string, listingId?: string) {
  const scope = JSON.stringify([type, page, from, to, listingId])
  const [loaded, setLoaded] = useState<{ scope: string; data: Awaited<ReturnType<typeof listReviews>> } | null>(null)
  const [failure, setFailure] = useState<{ scope: string; text: string } | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setLoaded(null); setFailure(null)
    listReviews(type, page, { ...(from ? { from } : {}), ...(to ? { to } : {}), ...(listingId ? { listingId } : {}) })
      .then(data => { if (active) setLoaded({ scope, data }) })
      .catch(async cause => { const text = await readableOrderError(cause); if (active) setFailure({ scope, text }) })
    return () => { active = false }
  }, [type, page, from, to, listingId, scope, attempt])
  return { data: loaded?.scope === scope ? loaded.data : null, error: failure?.scope === scope ? failure.text : null, retry: () => setAttempt(value => value + 1) }
}

function useReviewActions() {
  const navigate = useNavigate()
  const location = useLocation()
  const [reporting, setReporting] = useState<VendorReviewRow | null>(null)
  const [notice, setNotice] = useState<string | null>(null)
  return {
    notice,
    open: (review: VendorReviewRow) => { if (review.id) navigate(`/reviews/${review.id}`, { state: { returnTo: location.pathname + location.search } }) },
    report: (review: VendorReviewRow) => { setReporting(review); setNotice(null) },
    dialog: reporting ? <ReportReviewDialog review={reporting} onClose={sent => { setReporting(null); if (sent) setNotice('Report sent. Our moderation team will review it.') }} /> : null,
  }
}

function ReviewRows({ rows, open, report }: { rows: VendorReviewRow[]; open: (review: VendorReviewRow) => void; report: (review: VendorReviewRow) => void }) {
  return <ul className="divide-y divide-border-default" aria-label="Reviews">{rows.map(row => <li key={row.id}>
    <ReviewListCard review={row} onOpen={() => open(row)} {...(row.canReport ? { onReport: () => report(row) } : {})} />
  </li>)}</ul>
}

function ReviewPagination({ data, page, onChange }: { data: Awaited<ReturnType<typeof listReviews>>; page: number; onChange: (page: number) => void }) {
  const total = data.meta.total ?? 0
  const perPage = data.meta.perPage ?? 20
  return total > perPage ? <div className="border-t border-border-default px-4 py-4 sm:px-6"><Pagination page={page} lastPage={Math.ceil(total / perPage)} total={total} busy={false} onChange={onChange} /></div> : null
}

export function ReviewsWorkspace() {
  const [params, setParams] = useSearchParams()
  const range = dateRangeFromParams(params)
  const tab = TABS.find(item => item.value === params.get('tab'))?.value ?? 'VENDOR'
  const pageValue = Number(params.get('page'))
  const page = Number.isSafeInteger(pageValue) && pageValue > 0 ? pageValue : 1
  const { data, error, retry } = useReviews(tab, page, range.from || undefined, range.to || undefined)
  const actions = useReviewActions()
  const changeDates = (nextRange: DateFilterRange) => setParams(current => {
    const next = new URLSearchParams(current)
    next.delete('page')
    for (const [key, value] of Object.entries(dateRangePatch(nextRange))) { if (value) next.set(key, value); else next.delete(key) }
    return next
  }, { replace: true })
  return <div className="space-y-6">
    <PageHeader eyebrow="Store operations" title="Ratings & Reviews" description="Explore verified-purchase feedback, review media and your Buyer ratings." />
    <InfoNote>Ratings appear after both sides submit or 14 days after completion. You can report a review for moderation; stores cannot delete reviews or their attachments.</InfoNote>
    <FilterTabs appearance="tabs" label="Review type" value={tab} chips={TABS} onChange={value => setParams(current => { const next = new URLSearchParams(current); next.set('tab', value); next.delete('page'); return next }, { replace: true })} />
    <section className="overflow-hidden rounded-surface border border-border-default bg-surface-primary" aria-label={TABS.find(item => item.value === tab)?.label}>
      <div className="flex flex-wrap items-center justify-between gap-3 border-b border-border-default px-4 py-4 sm:px-6">
        <div><h2 className="text-base font-semibold">{TABS.find(item => item.value === tab)?.label}</h2><p className="mt-1 text-sm text-text-secondary">{data ? `${data.meta.total ?? 0} ${tab === 'PRODUCT' ? 'product reviews' : 'ratings'} · Newest first` : 'Newest first'} · Select a review to view details</p></div>
        <DateFilter title="Review submission dates" value={range} onChange={changeDates} />
      </div>
      {(range.from || range.to) && <div className="px-4 pt-4 sm:px-6"><ActiveFilters filters={[{ key: 'dates', label: dateFilterLabel(range), onRemove: () => changeDates(ALL_DATES) }]} onClear={() => changeDates(ALL_DATES)} /></div>}
      {actions.notice && <div className="px-4 pt-4 sm:px-6"><StatusMessage tone="success">{actions.notice}</StatusMessage></div>}
      {error ? <div className="p-6"><ErrorState message={error} onRetry={retry} /></div> : !data ? <div className="p-6"><LoadingState label="Loading reviews…" /></div>
        : data.items.length === 0 ? <div className="p-6"><EmptyState message={range.from || range.to ? 'No reviews in this date range. Try another range or view all dates.' : tab === 'BUYER' ? 'Rate Buyers from completed orders within 14 days of completion.' : 'No published reviews yet.'} action={<Link className={link} to="/orders?group=CLOSED">View completed orders</Link>} /></div>
          : <ReviewRows rows={data.items} open={actions.open} report={actions.report} />}
      {data && <ReviewPagination data={data} page={page} onChange={value => setParams(current => { const next = new URLSearchParams(current); next.set('page', String(value)); return next }, { replace: true })} />}
    </section>
    {actions.dialog}
  </div>
}

/** All published feedback for this listing, independent of the analytics chart period. */
export function ProductReviewsSection({ listingId, canView }: { listingId: string; canView: boolean }) {
  if (!canView) return <section className="rounded-surface border border-border-default bg-surface-primary p-5"><h2 className="text-base font-semibold">Ratings & reviews</h2><p className="mt-2 text-sm text-text-secondary">Your role does not include access to store reviews.</p></section>
  return <ProductReviewsWorkspace key={listingId} listingId={listingId} />
}

function ProductReviewsWorkspace({ listingId }: { listingId: string }) {
  const [params, setParams] = useSearchParams()
  const requestedPage = Number(params.get('reviews_page'))
  const page = Number.isSafeInteger(requestedPage) && requestedPage > 0 ? requestedPage : 1
  const { data, error, retry } = useReviews('PRODUCT', page, undefined, undefined, listingId)
  const actions = useReviewActions()
  return <section aria-labelledby="product-reviews-title" className="overflow-hidden rounded-surface border border-border-default bg-surface-primary">
    <div className="border-b border-border-default px-4 py-5 sm:px-6"><h2 id="product-reviews-title" className="text-base font-semibold">Ratings & reviews</h2><p className="mt-1 text-sm text-text-secondary">All-time published feedback for this product. Includes every variant and is independent of the chart period.</p></div>
    {actions.notice && <div className="px-4 pt-4 sm:px-6"><StatusMessage tone="success">{actions.notice}</StatusMessage></div>}
    {error ? <div className="p-6"><ErrorState message={error} onRetry={retry} /></div> : !data ? <div className="p-6"><LoadingState label="Loading product ratings and reviews…" /></div> : <>
      {data.meta.summary ? <div className="border-b border-border-default px-4 py-5 sm:px-6"><ProductReviewSummary summary={data.meta.summary} /></div> : <div className="p-6"><ErrorState message="The rating summary is unavailable." onRetry={retry} /></div>}
      {data.items.length > 0 ? <><div className="px-4 pt-5 text-sm font-semibold sm:px-6">Buyer reviews <span className="font-normal text-text-secondary">· Newest first</span></div><ReviewRows rows={data.items} open={actions.open} report={actions.report} /></> : <div className="px-4 py-6 text-sm text-text-secondary sm:px-6">No published reviews yet. Feedback appears here after an eligible purchase and publication.</div>}
      <ReviewPagination data={data} page={page} onChange={value => setParams(current => { const next = new URLSearchParams(current); next.set('reviews_page', String(value)); return next }, { replace: true })} />
    </>}
    {actions.dialog}
  </section>
}

function reviewReturnPath(state: unknown): string {
  if (state && typeof state === 'object' && 'returnTo' in state && typeof state.returnTo === 'string'
    && /^\/(?:reviews(?:\?[^#]*)?|performance\/products\/[a-zA-Z0-9-]+(?:\?[^#]*)?)$/.test(state.returnTo)) return state.returnTo
  return '/reviews'
}

export function ReviewDetailsWorkspace() {
  const { reviewId = '' } = useParams()
  return <ReviewDetails key={reviewId} reviewId={reviewId} />
}

function ReviewDetails({ reviewId }: { reviewId: string }) {
  const location = useLocation()
  const [review, setReview] = useState<VendorReviewRow | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const actions = useReviewActions()
  useEffect(() => {
    let active = true
    // Refetch the current review before showing refreshed signed media URLs.
    setReview(null); setError(null)
    getReview(reviewId).then(data => { if (active) setReview(data) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [reviewId, attempt])
  const back = reviewReturnPath(location.state)
  return <div className="space-y-6">
    <Link to={back} className={link}><ArrowLeft size={16} aria-hidden="true" />{back.startsWith('/performance/') ? 'Product analytics' : 'Ratings & Reviews'}</Link>
    <PageHeader eyebrow="Ratings & reviews" title="Review details" description="Verified-purchase feedback and attachments."
      actions={review && <>{review.orderId && <Link className="inline-flex min-h-11 items-center rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold" to={`/orders/${review.orderId}`}>View order {review.orderReference}</Link>}{review.canReport && <Button variant="secondary" onClick={() => actions.report(review)}><Flag size={16} aria-hidden="true" />Report review</Button>}</>} />
    {actions.notice && <StatusMessage tone="success">{actions.notice}</StatusMessage>}
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : !review ? <LoadingState label="Loading review details…" />
      : <ReviewDetailContent review={review} apiBasePath={apiBasePath} onRefreshMedia={() => setAttempt(value => value + 1)} />}
    {actions.dialog}
  </div>
}

function ReportReviewDialog({ review, onClose }: { review: VendorReviewRow; onClose: (sent: boolean) => void }) {
  const id = useId()
  const submission = useRef<{ fingerprint: string; key: string } | null>(null)
  const [reason, setReason] = useState<FlagReason>('OFFENSIVE')
  const [details, setDetails] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const submit = async (event: FormEvent) => {
    event.preventDefault()
    if (busy || !review.id) return
    setBusy(true); setError(null)
    const comment = details.trim() || null
    const fingerprint = JSON.stringify([review.id, reason, comment])
    if (submission.current?.fingerprint !== fingerprint) submission.current = { fingerprint, key: newIdempotencyKey() }
    try { await reportReview(review.id, reason, comment, submission.current.key); onClose(true) } catch (cause) { setError(await readableOrderError(cause)) } finally { setBusy(false) }
  }
  return <FormDialog open title="Report review" description="Tell our moderation team why this review needs attention. Submitting a report does not remove the review." size="compact" busy={busy} onClose={() => onClose(false)}
    footer={<div className="flex flex-wrap justify-end gap-2"><Button variant="secondary" disabled={busy} onClick={() => onClose(false)}>Cancel</Button><Button type="submit" form={id} disabled={busy}>{busy ? 'Sending…' : 'Send report'}</Button></div>}>
    <form id={id} onSubmit={submit} className="grid gap-4">
      <p className="text-sm text-text-secondary">Review by {review.displayName || 'Verified Buyer'} · {review.orderReference}</p>
      <Select label="Reason" value={reason} disabled={busy} onChange={event => setReason(event.target.value as FlagReason)}>{FLAG_REASONS.map(item => <option key={item.value} value={item.value}>{item.label}</option>)}</Select>
      <label className="grid gap-2 text-sm font-semibold">Details (optional)<textarea className="min-h-28 w-full min-w-0 resize-y rounded-control border border-border-default bg-surface-primary p-3 text-base font-normal" maxLength={1000} disabled={busy} value={details} onChange={event => setDetails(event.target.value)} /></label>
      {error && <StatusMessage tone="error">{error}</StatusMessage>}
    </form>
  </FormDialog>
}
