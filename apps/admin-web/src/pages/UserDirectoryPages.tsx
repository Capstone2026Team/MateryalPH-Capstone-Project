import { BackNavigation,
  ALL_DATES, Button, DataTable, DateFilter, EmptyState, FactList, FilterTabs, InfoNote, Pagination, BuyerPerformanceCard, PerformanceRating, ProfileDetailsLayout, ProfileHeader, ProfileImage, ProfileSection, ProfileWorkspace, ProfileMetricGroup, SectionWorkspace, StarRatingDisplay, StatusBadge, StatusMessage, Toolbar, formatPesoCentavos,
} from '@materyalph/web-ui'
import { BadgeCheck, Building2, CalendarDays, ImageOff, MapPin, RefreshCw, ShieldAlert, ShieldCheck, Star, Store, UserRound } from 'lucide-react'
import { useCallback, useEffect, useState, type FormEvent, type ReactNode } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { Panel } from '../components/OperationsKit'
import { dateQuery, statusLabel, statusTone } from '../lib/admin-format'
import { label as humanize, manilaDate, manilaDateTime, useLoad } from '../lib/operations-hooks'
import {
  BUYER_STATUSES, VENDOR_ACTIVATION_STATUSES, VENDOR_VERIFICATION_STATUSES, getDirectoryBuyer, getDirectoryBuyerPhoto, getDirectoryVendor, listDirectoryBuyerReviews, listDirectoryBuyers, listDirectoryVendorListings,
  listDirectoryVendorReviews, listDirectoryVendors, type BuyerFilters, type BuyerReviewFilters, type DirectoryBuyerRow, type DirectoryList, type DirectoryListing, type DirectoryPageMeta, type DirectoryReview,
  type DirectorySanction, type VendorFilters, type VendorReviewFilters,
} from '../lib/user-directory-api'
import { VendorPerformanceMonitoring } from './TrustPages'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'
import { RecordActionDialog } from './EnforcementPages'

const filterSelect = 'min-h-11 w-auto max-w-full rounded-control border border-border-default bg-surface-primary px-3 text-sm font-normal text-text-strong'
const rowLink = 'font-semibold text-action-primary underline-offset-4 hover:underline'
const profileAction = 'inline-flex min-h-11 items-center justify-center gap-2 rounded-control border border-border-default bg-surface-primary px-4 py-2 text-sm font-semibold text-text-strong hover:bg-surface-canvas'
const SORTS = [['joined_desc', 'Newest joined first'], ['joined_asc', 'Oldest joined first'], ['name_asc', 'Name A to Z'], ['name_desc', 'Name Z to A']] as const

const accountTone = (status: string) => status === 'DEACTIVATED' ? 'error' : status === 'DELETED' ? 'neutral' : statusTone(status)
const stockTone = { IN_STOCK: 'success', LIMITED_STOCK: 'warning', OUT_OF_STOCK: 'error' } as const
const stockLabel = { IN_STOCK: 'In stock', LIMITED_STOCK: 'Limited stock', OUT_OF_STOCK: 'Out of stock' } as const
const listingTone = (status: string) => status === 'ACTIVE' ? 'success' : status === 'REJECTED' ? 'error' : status === 'DRAFT' ? 'neutral' : 'warning'
const average = (value: string | null) => value === null ? 'No ratings yet' : `${value} / 5`

/** Applies a search only on submit, and only when it meets the API minimum, so typing never reloads the list. */
function useDirectorySearch() {
  const [draft, setDraft] = useState('')
  const [applied, setApplied] = useState('')
  const [error, setError] = useState<string | null>(null)
  function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    const term = draft.trim()
    if (term.length === 1) { setError('Enter at least 2 characters to search.'); return }
    setError(null); setApplied(term)
  }
  function change(value: string) {
    setDraft(value); setError(null)
    if (value === '') setApplied('')
  }
  function reset() { setDraft(''); setApplied(''); setError(null) }
  return { draft, applied, error, submit, change, reset }
}

/** Keeps the last received per-status counts so the tabs do not blank while the next page loads. */
function useStatusCounts(meta: DirectoryPageMeta | undefined) {
  const [last, setLast] = useState<Record<string, number>>({})
  useEffect(() => { if (meta?.statusCounts) setLast(meta.statusCounts) }, [meta])
  return meta?.statusCounts ?? last
}

function statusChips(statuses: readonly string[], counts: Record<string, number>, withAll = true) {
  const total = Object.values(counts).reduce((sum, value) => sum + value, 0)
  const chips = statuses.map(value => ({ value, label: statusLabel(value), count: counts[value] ?? 0 }))
  return withAll ? [{ value: '', label: 'All', count: total }, ...chips] : chips
}

/** A table row that opens its profile on click; the name link keeps keyboard and assistive-technology access. */
function OpenableRow({ href, children }: { href: string; children: ReactNode }) {
  const navigate = useNavigate()
  return <tr className="cursor-pointer hover:bg-surface-canvas" onClick={event => { if (!(event.target instanceof Element) || !event.target.closest('a, button')) navigate(href) }}>{children}</tr>
}

function BuyerDirectoryPhoto({ buyer }: { buyer: DirectoryBuyerRow }) {
  const loadPhoto = useCallback((source: string) => getDirectoryBuyerPhoto(buyer.id, source), [buyer.id])
  return <ProfileImage kind="buyer" size="compact" name={buyer.name} src={buyer.status === 'DELETED' ? null : buyer.avatarUrl} load={loadPhoto} />
}

function ListSection({ loading, error, onRetry, empty, children, pagination }: { loading: boolean; error: string | null; onRetry: () => void; empty: boolean; children: ReactNode; pagination: ReactNode }) {
  if (error) return <ErrorState message={error} onRetry={onRetry} />
  if (loading) return <LoadingState />
  return <>{empty ? <EmptyState message="No users match these filters. Adjust the search or filters and try again." /> : children}{pagination}</>
}

export function AdminBuyerUsersPage() {
  const search = useDirectorySearch()
  const [status, setStatus] = useState('ACTIVE')
  const [buyerType, setBuyerType] = useState('')
  const [sort, setSort] = useState('joined_desc')
  const [range, setRange] = useState(ALL_DATES)
  const [page, setPage] = useState(1)
  const list = useLoad(() => listDirectoryBuyers({
    ...(search.applied ? { q: search.applied } : {}), ...(status ? { status: status as BuyerFilters['status'] } : {}), ...(buyerType ? { buyerType: buyerType as BuyerFilters['buyerType'] } : {}),
    sort: sort as BuyerFilters['sort'], page, ...dateQuery(range),
  }), [search.applied, status, buyerType, sort, range.from, range.to, page])
  const counts = useStatusCounts(list.data?.meta)
  const change = (apply: () => void) => { apply(); setPage(1) }
  const filtered = Boolean(search.applied || status !== 'ACTIVE' || buyerType || sort !== 'joined_desc' || range.from || range.to)
  const items = list.data?.items ?? []

  return <AdminShell activeHref="/buyer-users"><div className="space-y-6">
    <PageHeader eyebrow="Buyer Management" title="Buyer Users" description="Every Buyer account on the platform. Open a Buyer to see their profile, performance, ratings and reviews, and usage and activity."
      actions={<Button variant="secondary" disabled={list.loading} onClick={list.retry}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    <InfoNote>Contact details are shown because your role holds user directory access. Opening a Buyer profile is recorded in the audit log. Account actions stay in Enforcement.</InfoNote>
    <FilterTabs label="Account status" value={status} onChange={value => change(() => setStatus(value))} chips={statusChips(BUYER_STATUSES, counts, false)} />
    <Toolbar search={{ label: 'Search Buyers', placeholder: 'Search name, email or company', value: search.draft, onChange: value => { search.change(value); if (value === '') setPage(1) }, onSubmit: event => { search.submit(event); setPage(1) }, maxLength: 120 }}
      filters={<>
        <DateFilter title="Joined dates" value={range} persistSelection={false} onChange={value => change(() => setRange(value))} />
        <label className="sr-only" htmlFor="buyer-type">Buyer type</label>
        <select id="buyer-type" className={filterSelect} value={buyerType} onChange={event => change(() => setBuyerType(event.target.value))}><option value="">All Buyer types</option><option value="INDIVIDUAL">Individual</option><option value="BUSINESS">Business</option></select>
        <label className="sr-only" htmlFor="buyer-sort">Sort by</label>
        <select id="buyer-sort" className={filterSelect} value={sort} onChange={event => change(() => setSort(event.target.value))}>{SORTS.map(([value, text]) => <option key={value} value={value}>{text}</option>)}</select>
        {filtered && <Button variant="quiet" onClick={() => { search.reset(); setStatus('ACTIVE'); setBuyerType(''); setSort('joined_desc'); setRange(ALL_DATES); setPage(1) }}>Reset filters</Button>}
      </>} />
    {search.error && <p role="alert" className="text-sm text-status-error">{search.error}</p>}
    <ListSection loading={list.loading || !list.data} error={list.error} onRetry={list.retry} empty={items.length === 0}
      pagination={list.data && <Pagination page={page} lastPage={list.data.meta.lastPage} total={list.data.meta.total} busy={list.loading} onChange={setPage} />}>
      <DataTable caption="Buyer users" headers={['Name', 'Email', 'Buyer rating (CCS)', 'Status', 'Date joined']} minWidth="42rem">
        {items.map(buyer => <OpenableRow key={buyer.id} href={`/buyer-users/${buyer.id}`}>
          <td><div className="flex items-center gap-3"><BuyerDirectoryPhoto buyer={buyer} /><div className="min-w-0"><Link className={rowLink} to={`/buyer-users/${buyer.id}`}>{buyer.name}</Link>{buyer.companyName && <p className="mt-1 text-[13px] text-text-secondary">{buyer.companyName}</p>}</div></div></td>
          <td>{buyer.email}</td>
          <td><PerformanceRating label="Buyer rating (CCS)" value={buyer.rating.score} empty="Building your rating" /></td>
          <td><StatusBadge label={statusLabel(buyer.status)} tone={accountTone(buyer.status)} /></td>
          <td className="whitespace-nowrap">{manilaDate(buyer.joinedAt)}</td>
        </OpenableRow>)}
      </DataTable>
    </ListSection>
  </div></AdminShell>
}

export function AdminVendorUsersPage() {
  const search = useDirectorySearch()
  const [status, setStatus] = useState('ACTIVE')
  const [verification, setVerification] = useState('')
  const [discoverability, setDiscoverability] = useState('')
  const [sort, setSort] = useState('joined_desc')
  const [range, setRange] = useState(ALL_DATES)
  const [page, setPage] = useState(1)
  const list = useLoad(() => listDirectoryVendors({
    ...(search.applied ? { q: search.applied } : {}), ...(status ? { status: status as VendorFilters['status'] } : {}), ...(verification ? { verification: verification as VendorFilters['verification'] } : {}),
    ...(discoverability ? { discoverability: discoverability as VendorFilters['discoverability'] } : {}), sort: sort as VendorFilters['sort'], page, ...dateQuery(range),
  }), [search.applied, status, verification, discoverability, sort, range.from, range.to, page])
  const counts = useStatusCounts(list.data?.meta)
  const change = (apply: () => void) => { apply(); setPage(1) }
  const filtered = Boolean(search.applied || status !== 'ACTIVE' || verification || discoverability || sort !== 'joined_desc' || range.from || range.to)
  const items = list.data?.items ?? []

  return <AdminShell activeHref="/vendor-users"><div className="space-y-6">
    <PageHeader eyebrow="Vendor Management" title="Vendor Users" description="Every Vendor store on the platform. Open a store to see its profile, performance, ratings and reviews, usage and activity, and product listings."
      actions={<Button variant="secondary" disabled={list.loading} onClick={list.retry}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    <InfoNote>Status is the Store Activation status. Verification and discovery are separate states and are filtered below. Opening a store profile is recorded in the audit log; verification decisions stay in Vendor Verification.</InfoNote>
    <FilterTabs label="Store status" value={status} onChange={value => change(() => setStatus(value))} chips={statusChips(VENDOR_ACTIVATION_STATUSES, counts, false)} />
    <Toolbar search={{ label: 'Search Vendors', placeholder: 'Search store, owner or email', value: search.draft, onChange: value => { search.change(value); if (value === '') setPage(1) }, onSubmit: event => { search.submit(event); setPage(1) }, maxLength: 120 }}
      filters={<>
        <DateFilter title="Joined dates" value={range} persistSelection={false} onChange={value => change(() => setRange(value))} />
        <label className="sr-only" htmlFor="vendor-verification">Verification</label>
        <select id="vendor-verification" className={filterSelect} value={verification} onChange={event => change(() => setVerification(event.target.value))}><option value="">Any verification state</option>{VENDOR_VERIFICATION_STATUSES.map(value => <option key={value} value={value}>{statusLabel(value)}</option>)}</select>
        <label className="sr-only" htmlFor="vendor-discovery">Discovery</label>
        <select id="vendor-discovery" className={filterSelect} value={discoverability} onChange={event => change(() => setDiscoverability(event.target.value))}><option value="">Any discovery state</option><option value="DISCOVERABLE">Discoverable</option><option value="NOT_DISCOVERABLE">Not discoverable</option></select>
        <label className="sr-only" htmlFor="vendor-sort">Sort by</label>
        <select id="vendor-sort" className={filterSelect} value={sort} onChange={event => change(() => setSort(event.target.value))}>{SORTS.map(([value, text]) => <option key={value} value={value}>{text}</option>)}</select>
        {filtered && <Button variant="quiet" onClick={() => { search.reset(); setStatus('ACTIVE'); setVerification(''); setDiscoverability(''); setSort('joined_desc'); setRange(ALL_DATES); setPage(1) }}>Reset filters</Button>}
      </>} />
    {search.error && <p role="alert" className="text-sm text-status-error">{search.error}</p>}
    <ListSection loading={list.loading || !list.data} error={list.error} onRetry={list.retry} empty={items.length === 0}
      pagination={list.data && <Pagination page={page} lastPage={list.data.meta.lastPage} total={list.data.meta.total} busy={list.loading} onChange={setPage} />}>
      <DataTable caption="Vendor users" headers={['Store name', 'Owner', 'VPS rating', 'Status', 'Date joined']} minWidth="46rem">
        {items.map(vendor => <OpenableRow key={vendor.id} href={`/vendor-users/${vendor.id}`}>
          <td className="min-w-56"><div className="flex items-center gap-3"><ProfileImage kind="store" size="compact" name={vendor.storeName} src={vendor.logoUrl} /><div className="min-w-0"><Link className={rowLink} to={`/vendor-users/${vendor.id}`}>{vendor.storeName}</Link>{vendor.location && <p className="mt-1 text-[13px] text-text-secondary">{vendor.location}</p>}</div></div></td>
          <td className="min-w-48">{vendor.ownerName ?? 'No active Owner'}{vendor.ownerEmail && <p className="mt-1 text-[13px] text-text-secondary">{vendor.ownerEmail}</p>}</td>
          <td><PerformanceRating label="Vendor performance (VPS)" value={vendor.vps} empty="New Vendor" /></td>
          <td className="min-w-48"><StatusBadge label={statusLabel(vendor.status)} tone={statusTone(vendor.status)} /><p className="mt-2 text-[13px] text-text-secondary">Verification: {statusLabel(vendor.verificationStatus)}</p></td>
          <td className="whitespace-nowrap">{manilaDate(vendor.joinedAt)}</td>
        </OpenableRow>)}
      </DataTable>
    </ListSection>
  </div></AdminShell>
}

function BackLink({ to, children }: { to: string; children: ReactNode }) {
  return <BackNavigation><Link to={to}>{children}</Link></BackNavigation>
}

const RATING_LABELS: Record<string, string> = {
  service_quality: 'Service quality', speed_rating: 'Speed', product_quality: 'Product quality', inquiry_seriousness: 'Inquiry seriousness', communication_quality: 'Communication', payment_reliability: 'Payment reliability',
}

function Sanctions({ sanctions }: { sanctions: DirectorySanction[] }) {
  if (sanctions.length === 0) return null
  return <Panel title="Enforcement history" description="The five most recent actions. Open one to see its reason, plan and history.">
    <ul className="divide-y divide-border-default">{sanctions.map(item => <li key={item.id} className="flex flex-wrap items-start justify-between gap-3 py-3 first:pt-0 last:pb-0">
      <div className="min-w-0"><p className="font-semibold">{item.actionLabel} <span className="font-normal text-text-secondary">· {manilaDateTime(item.createdAt)}</span></p><p className="mt-1 text-sm text-text-secondary">{item.reason}</p></div>
      <div className="flex shrink-0 items-center gap-3"><StatusBadge label={humanize(item.state)} tone={item.state === 'APPLIED' ? 'error' : item.state === 'REFERRED' ? 'warning' : 'neutral'} /><Link className={rowLink} to={`/enforcement/${item.id}`} aria-label={`Open ${item.actionLabel} recorded ${manilaDate(item.createdAt)}`}>Open</Link></div>
    </li>)}</ul>
  </Panel>
}

/** Reviews load per page; the parent re-keys this component whenever the filter changes so the page resets. */
function ReviewList({ load, canModerate }: { load: (page: number) => Promise<DirectoryList<DirectoryReview>>; canModerate?: boolean }) {
  const [page, setPage] = useState(1)
  const reviews = useLoad(() => load(page), [page])
  if (reviews.error) return <ErrorState message={reviews.error} onRetry={reviews.retry} />
  if (!reviews.data) return <LoadingState />
  const moderate = canModerate ?? reviews.data.meta.canModerate ?? false
  return <div className="grid gap-4">
    {reviews.data.items.length === 0 ? <EmptyState message="No reviews have been submitted yet." /> : <ul aria-label="Reviews" className="grid gap-3">{reviews.data.items.map(review => <li key={review.id} className="grid min-w-0 gap-3 mp-card mp-card-padded">
      <div className="flex flex-wrap items-start justify-between gap-2">
        <div className="min-w-0"><p className="font-semibold">{review.authorName || 'Anonymous'}<span className="font-normal text-text-secondary"> · {review.storeName}{review.productName ? ` · ${review.productName}` : ''}</span></p>
          <p className="mt-1 text-[13px] text-text-secondary">Order {review.orderReference} · {manilaDateTime(review.submittedAt)}</p></div>
        {review.visibility !== 'PUBLIC' && <StatusBadge label={humanize(review.visibility)} tone={review.visibility === 'REMOVED' ? 'error' : 'warning'} />}
      </div>
      <div className="flex flex-wrap gap-x-6 gap-y-2">{Object.entries(review.ratings).filter((entry): entry is [string, number] => typeof entry[1] === 'number').map(([key, value]) => <span key={key} className="inline-flex flex-wrap items-center gap-2 text-sm"><span className="text-text-secondary">{RATING_LABELS[key] ?? humanize(key)}</span><StarRatingDisplay value={value} label={RATING_LABELS[key] ?? humanize(key)} /></span>)}</div>
      {review.comment ? <p className="whitespace-pre-line break-words text-sm">{review.comment}</p> : <p className="text-sm text-text-secondary">{review.visibility === 'PUBLIC' ? 'No written comment.' : 'The written text is withheld while this review is hidden or removed.'}</p>}
      {moderate && <Link className={`${rowLink} w-fit`} to={`/reviews/${review.id}`}>Open in Review Moderation</Link>}
    </li>)}</ul>}
    {reviews.data.meta.lastPage > 1 && <Pagination page={page} lastPage={reviews.data.meta.lastPage} total={reviews.data.meta.total} busy={reviews.loading} onChange={setPage} />}
  </div>
}

export function AdminBuyerUserDetailPage() {
  const { buyerId = '' } = useParams()
  const detail = useLoad(() => getDirectoryBuyer(buyerId), [buyerId])
  const loadPhoto = useCallback((source: string) => getDirectoryBuyerPhoto(buyerId, source), [buyerId])
  const [direction, setDirection] = useState('RECEIVED')
  const [enforcementOpen, setEnforcementOpen] = useState(false)
  const [enforcementRecorded, setEnforcementRecorded] = useState(false)
  const buyer = detail.data
  return <AdminShell activeHref="/buyer-users"><div className="space-y-4">
    <BackLink to="/buyer-users">Back to Buyer Users</BackLink>
    {enforcementRecorded && <StatusMessage tone="success">Enforcement action recorded. Email and in-app notification queued.</StatusMessage>}
    {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !buyer ? <LoadingState /> : <ProfileWorkspace identity={<ProfileHeader appearance="sidebar" eyebrow="Buyer Management" name={buyer.name}
        avatar={<ProfileImage kind="buyer" name={buyer.name} src={buyer.status === 'DELETED' ? null : buyer.profile.avatarUrl} load={loadPhoto} />}
        metadata={<span className="inline-flex items-center gap-2"><CalendarDays size={15} aria-hidden="true" />Buyer since {manilaDate(buyer.profile.joinedAt)}</span>}
        statuses={<><StatusBadge label={statusLabel(buyer.status)} tone={accountTone(buyer.status)} />{buyer.profile.commerceRestrictedUntil && <StatusBadge label={`Restricted until ${manilaDateTime(buyer.profile.commerceRestrictedUntil)}`} tone="warning" />}</>}
        details={<ProfileSection title="Contact details" {...(buyer.status === 'DELETED' ? { description: 'This Buyer deleted their account, so the email is masked and the mobile number is not shown.' } : {})}>
          <FactList columns={1} facts={[
            { label: 'Email', value: <div className="flex flex-wrap items-center gap-x-2 gap-y-1"><span className="min-w-0 break-words">{buyer.profile.email}</span>{buyer.status !== 'DELETED' && <span className="inline-flex items-center gap-1 text-xs text-text-secondary">{buyer.profile.emailVerified && <BadgeCheck size={14} aria-hidden="true" />}{buyer.profile.emailVerified ? 'Verified' : 'Not verified'}</span>}</div> },
            { label: 'Mobile', value: buyer.profile.mobile ?? 'Not provided' }, { label: 'Area', value: buyer.profile.area ?? 'No saved location' },
          ]} />
        </ProfileSection>}
        notice="This profile is read-only. Record warnings, restrictions and suspensions in Enforcement."
        actions={buyer.canViewEnforcement ? <button type="button" className={profileAction} onClick={() => { setEnforcementRecorded(false); setEnforcementOpen(true) }}><ShieldAlert size={16} aria-hidden="true" />Open Enforcement</button> : null} />}>
      <SectionWorkspace sections={[
        { label: 'Profile', content: <div className="grid min-w-0 gap-3">
          <ProfileDetailsLayout appearance="cards" sidebar={<>
            <ProfileSection title="Buyer information" appearance="card" icon={<Building2 size={17} />}>
              <FactList facts={[
                { label: 'Buyer type', value: humanize(buyer.profile.buyerType) }, { label: 'Company', value: buyer.profile.companyName ?? 'Not provided' },
                { label: 'Position', value: buyer.profile.positionTitle ?? 'Not provided' }, { label: 'Industry', value: buyer.profile.industry ? humanize(buyer.profile.industry) : 'Not provided' },
              ]} />
            </ProfileSection>
            <ProfileSection title="Buyer rating (CCS)" appearance="card" icon={<Star size={17} />}>
              <div className="profile-rating-summary"><PerformanceRating label="Buyer rating (CCS)" value={buyer.rating.score} empty="Building your rating" /><p>{buyer.rating.count} eligible completed transactions · Rolling {buyer.rating.windowDays} days. Published after {buyer.rating.minimumCount} eligible transactions.</p></div>
            </ProfileSection>
          </>}>
            <ProfileSection title="Account overview" appearance="card" icon={<ShieldCheck size={17} />}>
              <FactList facts={[
                { label: 'Account status', value: <StatusBadge label={statusLabel(buyer.status)} tone={accountTone(buyer.status)} /> }, { label: 'Date joined', value: manilaDateTime(buyer.profile.joinedAt) },
                { label: 'Onboarding', value: humanize(buyer.profile.onboardingStatus) }, { label: 'Last active', value: manilaDateTime(buyer.activity.lastActiveAt) },
                ...(buyer.profile.deletedAt ? [{ label: 'Deleted', value: manilaDateTime(buyer.profile.deletedAt) }] : []),
              ]} />
            </ProfileSection>
            <ProfileMetricGroup label="Order activity" tiles={[
              { label: 'Orders', value: buyer.activity.ordersTotal }, { label: 'Completed orders', value: buyer.activity.ordersCompleted },
              { label: 'Open orders', value: buyer.activity.ordersOpen }, { label: 'Disputes (open / total)', value: `${buyer.activity.disputesOpen} / ${buyer.activity.disputesTotal}` },
            ]} />
          </ProfileDetailsLayout>
          <Sanctions sanctions={buyer.sanctions} />
        </div> },
        { label: 'Performance Monitoring', content: <div className="grid min-w-0 gap-4 lg:grid-cols-[minmax(0,1fr)_minmax(0,1fr)]">
          <BuyerPerformanceCard summary={buyer.rating} />
          <ProfileSection title="Activity context" appearance="card" description="Account totals. These counts are separate from the rolling CCS eligibility window.">
            <FactList facts={[
              { label: 'Completed orders', value: buyer.activity.ordersCompleted }, { label: 'Open orders', value: buyer.activity.ordersOpen },
              { label: 'Disputes (open / total)', value: `${buyer.activity.disputesOpen} / ${buyer.activity.disputesTotal}` }, { label: 'Last active', value: manilaDateTime(buyer.activity.lastActiveAt) },
            ]} />
          </ProfileSection>
        </div> },
        { label: 'Ratings and reviews', content: <div className="grid gap-3">
          <ProfileMetricGroup label="Buyer ratings" tiles={[
            { label: 'Ratings received', value: buyer.ratings.received.count, hint: 'Ratings from Vendors on completed orders that are currently visible.' },
            { label: 'Inquiry seriousness', value: average(buyer.ratings.received.inquirySeriousness) }, { label: 'Communication', value: average(buyer.ratings.received.communicationQuality) },
            { label: 'Payment reliability', value: average(buyer.ratings.received.paymentReliability) },
          ]} />
          <FilterTabs label="Review direction" value={direction} onChange={setDirection} chips={[{ value: 'RECEIVED', label: 'Received from Vendors', count: buyer.ratings.received.count }, { value: 'WRITTEN', label: 'Written by this Buyer', count: buyer.ratings.written.count }]} />
          <ReviewList key={direction} load={page => listDirectoryBuyerReviews({ buyerId, direction: direction as BuyerReviewFilters['direction'], page })} />
        </div> },
        { label: 'Usage and activity', content: <div className="grid gap-3">
          <ProfileMetricGroup label="Orders and quotations" tiles={[
            { label: 'Orders', value: buyer.activity.ordersTotal }, { label: 'Open orders', value: buyer.activity.ordersOpen }, { label: 'Completed orders', value: buyer.activity.ordersCompleted },
            { label: 'Cancelled, declined or expired', value: buyer.activity.ordersCancelled }, { label: 'Quotations', value: buyer.activity.quotationsTotal }, { label: 'Quotations accepted', value: buyer.activity.quotationsAccepted },
            { label: 'Projects', value: buyer.activity.projectsTotal }, { label: 'Work packages', value: buyer.activity.workPackagesTotal },
          ]} />
          <ProfileMetricGroup label="Engagement" tiles={[
            { label: 'Sign-ins in 30 days', value: buyer.activity.signIns30Days }, { label: 'Conversations', value: buyer.activity.conversationsTotal }, { label: 'Favorite stores', value: buyer.activity.favoriteStores },
            { label: 'Disputes (open / total)', value: `${buyer.activity.disputesOpen} / ${buyer.activity.disputesTotal}` },
          ]} />
          <Panel title="Recent orders" description="The five most recent orders. Order Operations holds the full record.">
            {buyer.recentOrders.length === 0 ? <EmptyState message="This Buyer has not placed an order yet." /> : <DataTable caption="Recent orders" headers={['Reference', 'Store', 'Order', 'Payment', 'Placed']} minWidth="40rem">
              {buyer.recentOrders.map(order => <tr key={order.id}><th scope="row" className="text-left font-semibold">{order.reference}</th><td>{order.storeName}</td><td>{humanize(order.orderState)}</td><td>{humanize(order.paymentState)}</td><td className="whitespace-nowrap">{manilaDate(order.createdAt)}</td></tr>)}
            </DataTable>}
          </Panel>
        </div> },
      ]} />
    </ProfileWorkspace>}
    {buyer && enforcementOpen && <RecordActionDialog key={buyer.id} initialType="BUYER" initialSubjectId={buyer.id} lockType onClose={() => setEnforcementOpen(false)} onRecorded={() => { setEnforcementOpen(false); setEnforcementRecorded(true); detail.retry() }} />}
  </div></AdminShell>
}

function ListingsSection({ vendorId }: { vendorId: string }) {
  const [status, setStatus] = useState('')
  const [page, setPage] = useState(1)
  const search = useDirectorySearch()
  const listings = useLoad(() => listDirectoryVendorListings({ vendorId, ...(search.applied ? { q: search.applied } : {}), ...(status ? { status } : {}), page }), [vendorId, search.applied, status, page])
  const counts = useStatusCounts(listings.data?.meta)
  const statuses = Object.keys(counts).sort()
  const items = listings.data?.items ?? []
  return <div className="grid gap-4">
    <Toolbar compact filters={<FilterTabs label="Listing status" value={status} onChange={value => { setStatus(value); setPage(1) }} chips={statusChips(statuses, counts)} />} search={{ label: 'Search listings', placeholder: 'Search product name or SKU', value: search.draft, onChange: value => { search.change(value); if (value === '') setPage(1) }, onSubmit: event => { search.submit(event); setPage(1) }, maxLength: 120 }} />
    {search.error && <p role="alert" className="text-sm text-status-error">{search.error}</p>}
    <ListSection loading={listings.loading || !listings.data} error={listings.error} onRetry={listings.retry} empty={items.length === 0}
      pagination={listings.data && <Pagination page={page} lastPage={listings.data.meta.lastPage} total={listings.data.meta.total} busy={listings.loading} onChange={setPage} />}>
      <DataTable caption="Product listings" headers={['Product', 'Price', 'Stock', 'Status']} minWidth="40rem">
        {items.map(listing => <ListingRow key={listing.id} listing={listing} />)}
      </DataTable>
    </ListSection>
  </div>
}

function ListingRow({ listing }: { listing: DirectoryListing }) {
  const [failed, setFailed] = useState(false)
  const price = listing.minPriceCentavos === null ? '—' : listing.minPriceCentavos === listing.maxPriceCentavos ? formatPesoCentavos(listing.minPriceCentavos) : `${formatPesoCentavos(listing.minPriceCentavos)} – ${formatPesoCentavos(listing.maxPriceCentavos)}`
  return <tr>
    <td className="min-w-48"><div className="flex items-center gap-3">
      {listing.imageUrl && !failed
        ? <img src={listing.imageUrl} alt={listing.imageAlt ?? `${listing.name} photo`} loading="lazy" className="h-10 w-10 shrink-0 rounded-control border border-border-default object-cover" onError={() => setFailed(true)} />
        : <span className="grid h-10 w-10 shrink-0 place-items-center rounded-control border border-border-default bg-surface-canvas text-text-secondary" role="img" aria-label="No photo"><ImageOff size={18} aria-hidden="true" /></span>}
      <div className="min-w-0"><p className="font-semibold">{listing.name}</p>{listing.sku && <p className="mt-1 text-[13px] text-text-secondary">SKU {listing.sku}</p>}</div>
    </div></td>
    <td className="whitespace-nowrap">{price}{listing.minPriceCentavos !== null && listing.unitCode && <span className="text-text-secondary"> / {listing.unitCode}</span>}{listing.variantCount > 1 && <p className="mt-1 text-[13px] text-text-secondary">{listing.variantCount} variants</p>}</td>
    <td><StatusBadge label={stockLabel[listing.stock]} tone={stockTone[listing.stock]} /></td>
    <td><StatusBadge label={statusLabel(listing.status)} tone={listingTone(listing.status)} /></td>
  </tr>
}

export function AdminVendorUserDetailPage() {
  const { vendorId = '' } = useParams()
  const detail = useLoad(() => getDirectoryVendor(vendorId), [vendorId])
  const [type, setType] = useState('VENDOR')
  const [enforcementOpen, setEnforcementOpen] = useState(false)
  const [enforcementRecorded, setEnforcementRecorded] = useState(false)
  const vendor = detail.data
  return <AdminShell activeHref="/vendor-users"><div className="space-y-4">
    <BackLink to="/vendor-users">Back to Vendor Users</BackLink>
    {enforcementRecorded && <StatusMessage tone="success">Enforcement action recorded. Email and in-app notification queued.</StatusMessage>}
    {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !vendor ? <LoadingState /> : <ProfileWorkspace identity={<ProfileHeader appearance="sidebar" eyebrow="Vendor Management" name={vendor.storeName}
        avatar={<ProfileImage kind="store" name={vendor.storeName} src={vendor.store.logoUrl} />}
        metadata={<><span className="inline-flex items-center gap-2"><CalendarDays size={15} aria-hidden="true" />Joined {manilaDate(vendor.store.joinedAt)}</span>{vendor.store.location && <span className="inline-flex min-w-0 items-start gap-2"><MapPin size={15} className="mt-0.5 shrink-0" aria-hidden="true" /><span className="break-words">{vendor.store.location}</span></span>}</>}
        statuses={<><StatusBadge label={`Store ${statusLabel(vendor.store.activationStatus).toLowerCase()}`} tone={statusTone(vendor.store.activationStatus)} /><StatusBadge label={`Verification ${statusLabel(vendor.store.verificationStatus).toLowerCase()}`} tone={statusTone(vendor.store.verificationStatus)} />{vendor.store.vacationMode && <StatusBadge label="On vacation" tone="info" />}</>}
        details={<ProfileSection title="Store contact"><FactList columns={1} facts={[
          { label: 'Contact email', value: vendor.store.contactEmail ?? 'Not provided' }, { label: 'Contact phone', value: vendor.store.contactPhone ?? 'Not provided' },
          { label: 'Registered address', value: vendor.store.address ?? 'Not provided' },
        ]} /></ProfileSection>}
        notice="Store profile details are read-only. Verification and enforcement stay in their queues."
        actions={vendor.canViewVerification || vendor.canViewEnforcement ? <>
          {vendor.canViewVerification && <Link className={profileAction} to={`/vendor-verification/${vendor.id}`}><BadgeCheck size={16} aria-hidden="true" />Open verification case</Link>}
          {vendor.canViewEnforcement && <button type="button" className={profileAction} onClick={() => { setEnforcementRecorded(false); setEnforcementOpen(true) }}><ShieldAlert size={16} aria-hidden="true" />Open Enforcement</button>}
        </> : null} />}>
      <SectionWorkspace sections={[
        { label: 'Store profile', content: <div className="grid min-w-0 gap-3">
          <ProfileDetailsLayout appearance="cards" sidebar={<>
            <ProfileSection title="About the store" appearance="card" icon={<Store size={17} />}>
              <div className="profile-store-media"><ProfileImage kind="banner" name={vendor.storeName} src={vendor.store.bannerUrl} /></div>
              <p className="whitespace-pre-line break-words text-sm leading-relaxed text-text-secondary">{vendor.store.description ?? 'This store has not written a description.'}</p>
            </ProfileSection>
            <ProfileSection title="Verification and status" appearance="card" icon={<ShieldCheck size={17} />}>
              <FactList facts={[
                { label: 'Store Verification', value: <StatusBadge label={statusLabel(vendor.store.verificationStatus)} tone={statusTone(vendor.store.verificationStatus)} /> },
                { label: 'Store Setup', value: statusLabel(vendor.store.setupStatus) },
                { label: 'Store Activation', value: <StatusBadge label={statusLabel(vendor.store.activationStatus)} tone={statusTone(vendor.store.activationStatus)} /> },
                { label: 'Account', value: statusLabel(vendor.store.accountStatus) },
                ...(vendor.store.activationHoldCode ? [{ label: 'Hold', value: statusLabel(vendor.store.activationHoldCode) }] : []),
              ]} />
            </ProfileSection>
          </>}>
            <ProfileSection title="Business information" appearance="card" icon={<Building2 size={17} />}>
              <FactList facts={[
                { label: 'Business type', value: vendor.store.businessType ? humanize(vendor.store.businessType) : 'Not provided' },
                { label: 'Legal name', value: vendor.store.legalName ?? 'Not provided' }, { label: 'Registered name', value: vendor.store.registeredName ?? 'Not provided' },
              ]} />
            </ProfileSection>
            <ProfileSection title="Owner contact" appearance="card" icon={<UserRound size={17} />} description="The active store Owner.">
              {vendor.owner ? <FactList facts={[{ label: 'Name', value: vendor.owner.name }, { label: 'Email', value: vendor.owner.email }, { label: 'Mobile', value: vendor.owner.mobile ?? 'Not provided' }]} /> : <EmptyState message="This store has no active Owner." />}
            </ProfileSection>
            <ProfileSection title="Marketplace availability" appearance="card" icon={<Store size={17} />}>
              <FactList facts={[
                { label: 'Marketplace discovery', value: statusLabel(vendor.store.discoverabilityStatus) },
                { label: 'Bulk capability', value: vendor.store.bulkCapability ? 'Yes' : 'No' },
                { label: 'Date joined', value: manilaDateTime(vendor.store.joinedAt) },
              ]} />
            </ProfileSection>
          </ProfileDetailsLayout>
          <Sanctions sanctions={vendor.sanctions} />
        </div> },
        ...(vendor.canViewScores ? [{ label: 'Performance Monitoring', content: <VendorPerformanceMonitoring key={vendor.id} vendorId={vendor.id} /> }] : []),
        { label: 'Ratings and reviews', content: <div className="grid gap-3">
          <ProfileMetricGroup label="Vendor ratings" tiles={[
            { label: 'Store reviews', value: vendor.ratings.store.count, hint: 'Buyer ratings of the store on completed orders that are currently visible.' },
            { label: 'Service quality', value: average(vendor.ratings.store.serviceQuality) }, { label: 'Speed', value: average(vendor.ratings.store.speed) },
            { label: 'Product reviews', value: vendor.ratings.product.count, hint: `Average ${average(vendor.ratings.product.average)}` },
          ]} />
          <FilterTabs label="Review type" value={type} onChange={setType} chips={[{ value: 'VENDOR', label: 'Store reviews', count: vendor.ratings.store.count }, { value: 'PRODUCT', label: 'Product reviews', count: vendor.ratings.product.count }]} />
          <ReviewList key={type} load={page => listDirectoryVendorReviews({ vendorId, type: type as VendorReviewFilters['type'], page })} />
        </div> },
        { label: 'Usage and activity', content: <div className="grid gap-3">
          <ProfileMetricGroup label="Quotations and orders" tiles={[
            { label: 'Quotes sent', value: vendor.activity.quotesSent, hint: 'Published quotation versions.' }, { label: 'Quotes accepted', value: vendor.activity.quotesAccepted },
            { label: 'Orders fulfilled', value: vendor.activity.ordersFulfilled, hint: 'Orders that reached Completed.' }, { label: 'Open orders', value: vendor.activity.ordersOpen },
            { label: 'Orders', value: vendor.activity.ordersTotal }, { label: 'Cancelled, declined or expired', value: vendor.activity.ordersCancelled },
            { label: 'Disputes (open / total)', value: `${vendor.activity.disputesOpen} / ${vendor.activity.disputesTotal}` }, { label: 'Active listings', value: `${vendor.activity.listingsActive} of ${vendor.activity.listingsTotal}` },
          ]} />
          <ProfileMetricGroup label="Team and sign-ins" tiles={[
            { label: 'Last login', value: <span className="text-sm font-medium leading-6">{manilaDateTime(vendor.activity.lastLoginAt)}</span> }, { label: 'Sign-ins in 30 days', value: vendor.activity.signIns30Days, hint: 'Across every active team member.' },
            { label: 'Active team members', value: vendor.activity.teamMembers },
          ]} />
        </div> },
        { label: 'Product listings', content: <ListingsSection vendorId={vendor.id} /> },
      ]} />
    </ProfileWorkspace>}
    {vendor && enforcementOpen && <RecordActionDialog key={vendor.id} initialType="VENDOR_ORGANIZATION" initialSubjectId={vendor.id} lockType onClose={() => setEnforcementOpen(false)} onRecorded={() => { setEnforcementOpen(false); setEnforcementRecorded(true); detail.retry() }} />}
  </div></AdminShell>
}
