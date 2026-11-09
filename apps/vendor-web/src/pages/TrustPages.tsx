import { useEffect, useId, useRef, useState, type ReactNode } from 'react'
import { Navigate, useSearchParams } from 'react-router-dom'
import { Clock, EyeOff, PackageCheck, Scale, Star, Undo2 } from 'lucide-react'
import {
  AnalyticsNullState, Button, BuyerRatingForm, KpiCard, ReviewRatingSummary, StatusBadge, StatusMessage, StoreHealthIndicator, StorePerformanceSummary,
  formatAnalyticsDate, formatDurationSeconds, formatManilaDateTime, type BuyerRatingSubmission,
} from '@materyalph/web-ui'
import { ProductAnalyticsDetail, ProductAnalyticsWorkspace } from './ProductAnalyticsPages'
import {
  editBuyerRating, getOrderReviews, getStorePerformance, rateBuyer,
  type StorePerformance, type VendorOrderReviews,
} from '../lib/trust-api'
import { readableOrderError } from '../lib/orders-api'
import { storeName } from '../lib/catalog-access'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'
import { ReviewDetailsWorkspace, ReviewsWorkspace } from './VendorReviewPages'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { getVendorDashboardInsights, type VendorDashboardInsights } from '../lib/dashboard-api'
import type { DashboardRate } from '@materyalph/api-client-ts'

/** Shell + role gate shared by the Phase 14 Vendor pages; the API enforces the same permission on every request. */
function TrustShell({ activeHref, permission, deniedText, children }: { activeHref: string; permission: string | string[]; deniedText: string; children: ReactNode | ((permissions: string[]) => ReactNode) }) {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  if (loading) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><LoadingState label="Loading…" /></VendorShell>
  if (error || !snapshot) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><ErrorState message={error ?? 'This page is unavailable.'} onRetry={() => void refresh()} /></VendorShell>
  const allowed = (Array.isArray(permission) ? permission : [permission]).some(item => snapshot.permissions.includes(item))
  return <VendorShell activeHref={activeHref} accountLabel={storeName(snapshot)} navigationData={snapshot}>
    {allowed ? (typeof children === 'function' ? children(snapshot.permissions) : children) : <StatusMessage tone="error">{deniedText}</StatusMessage>}
  </VendorShell>
}

/** Store scores and badges only. Preserve links to the former product tab. */
export function VendorStorePerformancePage() {
  const [params] = useSearchParams()
  if (params.get('tab') === 'products') {
    const query = new URLSearchParams(params)
    query.delete('tab')
    return <Navigate to={{ pathname: '/analytics/products', search: query.toString() }} replace />
  }
  return <TrustShell activeHref="/performance" permission="scores.view_store" deniedText="Store Performance is available to the Owner and Store Manager only.">
    <div className="mp-analytics space-y-3">
      <PageHeader eyebrow="Analytics" title="Store Performance" description="Track your published scores, the operational events behind them and your badges." />
      <PerformanceWorkspace />
    </div>
  </TrustShell>
}

export function VendorProductAnalyticsOverviewPage() {
  return <TrustShell activeHref="/analytics/products" permission="catalog.manage" deniedText="Product analytics is available to roles that manage products.">
    {permissions => <div className="mp-analytics space-y-3">
      <PageHeader eyebrow="Analytics" title="Product Analytics" description="See which products Buyers view, order and convert on, with suggestions on what to do next." />
      <ProductAnalyticsWorkspace canViewScores={permissions.includes('scores.view_store')} />
    </div>}
  </TrustShell>
}

export function VendorProductAnalyticsPage() {
  return <TrustShell activeHref="/analytics/products" permission="catalog.manage" deniedText="Product analytics is available to roles that manage products.">
    {permissions => <ProductAnalyticsDetail canViewReviews={permissions.includes('reviews.view')} />}
  </TrustShell>
}

const rateValue = (rate: DashboardRate) => rate.percent == null ? '—' : `${rate.percent}%`
const rateHint = (rate: DashboardRate, noun: string) => rate.denominator === 0 ? `No ${noun} in this period.` : `${rate.numerator} of ${rate.denominator} ${noun}.`

function PerformanceMetrics({ data }: { data: VendorDashboardInsights }) {
  const kpis = data.access.orders ? data.orders?.kpis : null
  if (!kpis) return null
  return <section aria-label="Operational performance" className="mp-performance-operational-metrics">
    <div className="flex flex-wrap items-baseline justify-between gap-2"><h2 className="text-sm font-semibold">Operational performance</h2><p className="text-xs text-text-secondary">Last 30 days · Asia/Manila</p></div>
    <dl className="mp-performance-metrics">
      <KpiCard density="compact" label="Order completion rate" value={rateValue(kpis.fulfillmentRate)} hint={<><span className="mp-performance-metric-context">Completed by period end</span>{rateHint(kpis.fulfillmentRate, 'orders due')}</>} icon={<PackageCheck size={16} />} calculation="Confirmed, non-cancelled orders due in the last 30 days that were completed by the period's end ÷ all confirmed, non-cancelled orders due in that period × 100. Uses the expected fulfillment date in Asia/Manila. Completion by period end is separate from On-time fulfillment (FRR), which checks the confirmed fulfillment date over 90 days." />
      <KpiCard density="compact" label="Cancelled orders" value={rateValue(kpis.cancellationRate)} hint={<><span className="mp-performance-metric-context">All causes · Buyer and Vendor</span>{rateHint(kpis.cancellationRate, 'confirmed orders')}</>} icon={<Undo2 size={16} />} calculation="Orders first confirmed in the last 30 days that are now cancelled ÷ all orders first confirmed in that period × 100. Includes Buyer and Vendor cancellations; separate from the Vendor-caused Non-Fulfillment Rate used for OHS." />
      <KpiCard density="compact" label="Orders with disputes" value={rateValue(kpis.disputeRate)} hint={<><span className="mp-performance-metric-context">Any case status or outcome</span>{rateHint(kpis.disputeRate, 'confirmed orders')}</>} icon={<Scale size={16} />} calculation="Confirmed orders with at least one dispute case ÷ all orders first confirmed in the last 30 days × 100. Each order counts once, regardless of case status or outcome. This is separate from the confirmed findings used for Order Defect Rate (ODR)." />
      <KpiCard density="compact" label="Average order decision time" value={formatDurationSeconds(kpis.responseTime.meanSeconds)} hint={<><span className="mp-performance-metric-context">First human decision on an order request</span>{kpis.responseTime.answered > 0 ? `Median ${formatDurationSeconds(kpis.responseTime.medianSeconds)} · 90th percentile ${formatDurationSeconds(kpis.responseTime.p90Seconds)}` : 'No answered order requests in this period.'}</>} icon={<Clock size={16} />} calculation="Average elapsed time from an eligible order request submitted in the last 30 days to its first human Vendor decision. Auto-accepted and quotation-based orders, automated messages and unanswered requests are excluded. This is order-decision time, separate from the human inquiry responses used for CRR." />
    </dl>
  </section>
}

function PerformanceWorkspace() {
  const [data, setData] = useState<StorePerformance | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [signals, setSignals] = useState<VendorDashboardInsights | null>(null)
  const [signalsError, setSignalsError] = useState<string | null>(null)
  const [signalsAttempt, setSignalsAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setData(null); setError(null)
    getStorePerformance().then(result => { if (active) setData(result) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [attempt])
  useEffect(() => {
    let active = true
    setSignals(null); setSignalsError(null)
    getVendorDashboardInsights(30).then(result => { if (active) setSignals(result) }).catch(async cause => { const text = await readableOrderError(cause); if (active) setSignalsError(text) })
    return () => { active = false }
  }, [signalsAttempt])
  if (error) return <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
  if (!data) return <LoadingState label="Loading store performance…" />
  const signalRetry = signalsError ? <Button variant="secondary" onClick={() => setSignalsAttempt(value => value + 1)}>Retry health and metrics</Button> : undefined
  const metrics = signals ? <PerformanceMetrics data={signals} /> : <div role={signalsError ? 'alert' : 'status'} className="flex flex-wrap items-center gap-3 text-xs text-text-secondary"><p>{signalsError ? `Operational metrics could not be loaded. ${signalsError}` : 'Loading operational metrics…'}</p>{signalRetry}</div>
  if (!data.calculated) return <div className="space-y-3">{metrics}<AnalyticsNullState title="No daily calculation yet" reason="Your first scores appear after the next daily calculation at 00:30 Asia/Manila. Until the sample minimums are met your store shows New Vendor — Building Track Record." /></div>
  return <StorePerformanceSummary data={data} metrics={metrics} health={<StoreHealthIndicator density="compact" classification={signals?.performance?.classification} asOf={formatAnalyticsDate(signals?.performance?.asOf ?? data.asOf, true)} pending={!signals && !signalsError} error={signalsError} retry={signalRetry} />} />
}

export function VendorReviewsPage() {
  return <TrustShell activeHref="/reviews" permission="reviews.view" deniedText="Ratings and reviews are not available to your role.">
    <ReviewsWorkspace />
  </TrustShell>
}

export function VendorReviewDetailPage() {
  return <TrustShell activeHref="/reviews" permission="reviews.view" deniedText="Ratings and reviews are not available to your role.">
    {permissions => <ReviewDetailsWorkspace canViewProductAnalytics={permissions.includes('catalog.manage')} />}
  </TrustShell>
}

/** Order-detail panel: the store rates the Buyer (CCS) within the 14-day window and sees the Buyer's ratings after the blind reveal. */
export function OrderReviewPanel({ orderId, canRate }: { orderId: string; canRate: boolean }) {
  return <OrderReviewWorkspace key={orderId} orderId={orderId} canRate={canRate} />
}

function OrderReviewWorkspace({ orderId, canRate }: { orderId: string; canRate: boolean }) {
  const headingId = useId()
  const [data, setData] = useState<VendorOrderReviews | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [editing, setEditing] = useState(false)
  const [notice, setNotice] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [formError, setFormError] = useState<string | null>(null)
  const pending = useRef(false)
  const submission = useRef<{ fingerprint: string; key: string } | null>(null)
  const mounted = useRef(false)
  useEffect(() => { mounted.current = true; return () => { mounted.current = false } }, [])
  useEffect(() => {
    let active = true
    setData(null); setError(null); setFormError(null)
    getOrderReviews(orderId).then(result => {
      if (active) { setData(result); setEditing(canRate && result.canSubmitBuyerRating && !result.buyerRating) }
    }).catch(async cause => { const text = await readableOrderError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [orderId, canRate, attempt])
  const own = data?.buyerRating
  const editable = canRate && Boolean(data?.canSubmitBuyerRating || own?.canEdit)
  const submit = async (ratings: BuyerRatingSubmission) => {
    if (pending.current || !editable) return
    pending.current = true
    setBusy(true); setFormError(null)
    try {
      const fingerprint = JSON.stringify(ratings)
      if (!submission.current || submission.current.fingerprint !== fingerprint) submission.current = { fingerprint, key: newIdempotencyKey() }
      const updated = own ? await editBuyerRating(own.id, own.lockVersion, ratings) : await rateBuyer(orderId, ratings, submission.current.key)
      if (mounted.current) {
        setData(updated); setEditing(false); submission.current = null
        setNotice(own ? 'Your rating correction was saved.' : 'Your Buyer rating was submitted.')
      }
    } catch (cause) {
      const text = await readableOrderError(cause)
      if (mounted.current) setFormError(text)
    } finally { pending.current = false; if (mounted.current) setBusy(false) }
  }
  return <section aria-labelledby={headingId} className="grid min-w-0 gap-5 mp-card mp-card-padded">
    <div className="flex flex-wrap items-start justify-between gap-3">
      <div><h2 id={headingId} className="flex items-center gap-2 text-lg font-semibold"><Star className="text-action-primary" size={20} aria-hidden="true" />Ratings</h2><p className="mt-1 text-sm text-text-secondary">Feedback for this completed purchase.</p></div>
      {data && <StatusBadge label={data.state === 'OPEN' ? 'Rating window open' : data.state === 'CLOSED' ? 'Rating window closed' : 'Not yet eligible'} tone={data.state === 'OPEN' ? 'info' : 'neutral'} />}
    </div>
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : !data ? <LoadingState label="Loading ratings…" /> : <>
      {data.state === 'NOT_COMPLETED' ? <p className="text-sm text-text-secondary">Ratings become available once the order is completed.</p> : <>
        {notice && <StatusMessage tone="success">{notice}</StatusMessage>}
        <div className="grid gap-2 text-sm text-text-secondary">
          <p className="flex items-start gap-2"><EyeOff size={16} className="mt-0.5 shrink-0" aria-hidden="true" />{data.rules.blindReveal}</p>
          {data.closesAtLabel && <p>{data.state === 'OPEN' ? 'Submit by' : 'Window closed'} <span className="font-medium text-text-strong">{data.closesAtLabel}</span></p>}
        </div>
        {data.withheldForDispute && <StatusMessage>Publication is withheld while a related dispute is active.</StatusMessage>}
        {editing && editable ? <div className="grid min-w-0 gap-3">
          <div><h3 className="text-base font-semibold">{own ? 'Correct your Buyer rating' : 'Rate this Buyer'}</h3>
            {own && <p className="mt-1 text-sm text-text-secondary">Corrections available until {own.correctionRequested && own.correctionDueAt ? formatManilaDateTime(own.correctionDueAt) : own.editableUntilLabel}.</p>}
          </div>
          <BuyerRatingForm key={`${own?.id ?? 'new'}-${own?.lockVersion ?? 0}`} editing={Boolean(own)} busy={busy} error={formError} commentMax={data.rules.commentMax}
            initialValues={{ inquirySeriousness: own?.ratings.inquirySeriousness ?? null, communicationQuality: own?.ratings.communicationQuality ?? null, paymentReliability: own?.ratings.paymentReliability ?? null, comment: own?.comment ?? '' }}
            onSubmit={ratings => void submit(ratings)} onCancel={() => { setEditing(false); setFormError(null) }} />
        </div> : <div className="grid gap-3">
          {own ? <><h3 className="text-sm font-semibold">Your store's rating of this Buyer</h3><ReviewRatingSummary ratings={own.ratings} />{own.comment && <p className="whitespace-pre-wrap break-words text-sm">{own.comment}</p>}<p className="text-xs text-text-secondary">{own.canEdit ? `You can correct this rating until ${own.correctionRequested && own.correctionDueAt ? formatManilaDateTime(own.correctionDueAt) : own.editableUntilLabel}.` : 'This rating is locked.'}</p></>
            : data.state === 'CLOSED' ? <p className="text-sm text-text-secondary">The submission window has ended.</p> : !canRate ? <p className="text-sm text-text-secondary">Your role can view ratings but cannot rate this Buyer.</p> : null}
          {editable && <Button className="w-fit" variant="secondary" onClick={() => { setNotice(null); setFormError(null); setEditing(true) }}>{own ? 'Correct rating' : 'Rate Buyer'}</Button>}
        </div>}
        {data.revealed && <div className="grid gap-3 border-t border-border-default pt-4"><h3 className="text-sm font-semibold">The Buyer's ratings</h3>{data.received.length === 0 ? <p className="text-sm text-text-secondary">No Buyer ratings are available to view.</p> : data.received.map(review => <div key={review.id} className="grid min-w-0 gap-2 border-l-2 border-border-default pl-3"><ReviewRatingSummary ratings={review.ratings} />{review.comment && <p className="whitespace-pre-wrap break-words text-sm">{review.comment}</p>}</div>)}</div>}
      </>}
    </>}
  </section>
}

