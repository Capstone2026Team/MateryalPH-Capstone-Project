import { useCallback, useEffect, useRef, useState } from 'react'
import { Link, useParams, useSearchParams } from 'react-router-dom'
import type { DeliveryNavigationRoute, DeliveryWorkspacePage, ListAssignedFulfillmentsStatusEnum, ListAssignedFulfillmentsSortEnum } from '@materyalph/api-client-ts'
import { ActiveFilters, Button, ChatAvatar, CopyableText, CountBadge, DashboardPanel, DeliveryRouteMap, EmptyState, FilterPanel, FilterTabs, FulfillmentAssignmentCard, Pagination, SearchInput, Select, StatusMessage, formatCount, formatManilaDateTime, fulfillmentDestinationLabel as destinationText, fulfillmentScheduledDate, useNavigationRefresh } from '@materyalph/web-ui'
import { ArrowRight, CalendarDays, Clock3, MapPin, MessageSquare, Navigation, Route as RouteIcon, Truck, UserRound } from 'lucide-react'
import { acknowledgeAssignment, apiFailure, getDeliveryDirections, getOrder, listAssignedFulfillments, quantityText, readDeliveryBuyerPhoto, readableOrderError, type OrderDetail } from '../lib/orders-api'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'
import { FulfillmentWorkspace } from './OrderFulfillmentPanels'
import { FulfillmentConversationDialog } from './FulfillmentConversationDialog'

const statuses = [{ value: 'ALL', label: 'All assignments' }, { value: 'PENDING', label: 'Pending' }, { value: 'OUT_FOR_DELIVERY', label: 'Out for delivery' }, { value: 'DELIVERED', label: 'Delivered / picked up' }, { value: 'ISSUES', label: 'Delivery issues' }]

export function VendorFulfillmentPage() {
  const { orderId } = useParams()
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  return <VendorShell activeHref="/fulfillment" accountLabel={String(snapshot?.organization.storeName ?? 'Vendor')} navigationData={snapshot}>
    {loading ? <LoadingState label="Loading fulfillment…" /> : error || !snapshot ? <ErrorState message={error ?? 'Account unavailable.'} onRetry={() => void refresh()} />
      : !snapshot.permissions.includes('portal.fulfillment') || snapshot.permissions.includes('fulfillment.assign') ? <StatusMessage tone="error">This workspace is available to Fulfillment Staff. Manage delivery assignments from <Link to="/orders" className="underline">Orders</Link>.</StatusMessage>
        : orderId ? <AssignedDelivery key={orderId} orderId={orderId} /> : <AssignedDeliveries />}
  </VendorShell>
}

function AssignedDeliveries() {
  const [params, setParams] = useSearchParams()
  const status = (statuses.some(row => row.value === params.get('status')) ? params.get('status') : 'ALL') as ListAssignedFulfillmentsStatusEnum
  const sort = (params.get('sort') === 'NEWEST' ? 'NEWEST' : 'SCHEDULED') as ListAssignedFulfillmentsSortEnum
  const requestedPage = Number(params.get('page'))
  const page = Number.isSafeInteger(requestedPage) && requestedPage > 0 ? requestedPage : 1
  const q = params.get('q') ?? ''
  const [search, setSearch] = useState(q)
  useEffect(() => { setSearch(q) }, [q])
  const [result, setResult] = useState<DeliveryWorkspacePage | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useNavigationRefresh(() => setAttempt(value => value + 1))
  useEffect(() => {
    let active = true
    void listAssignedFulfillments({ status, sort, page, ...(q ? { q } : {}) }).then(value => { if (active) { setResult(value); setError(null) } }).catch(async cause => {
      const failure = await apiFailure(cause)
      const message = await readableOrderError(cause)
      if (active) { if (failure && ['PERMISSION_DENIED', 'UNAUTHENTICATED', 'MEMBERSHIP_NOT_ACTIVE', 'ACCOUNT_NOT_ACTIVE'].includes(failure.code ?? '')) setResult(null); setError(message) }
    })
    return () => { active = false }
  }, [status, sort, page, q, attempt])
  const updateParams = (next: URLSearchParams) => { if (next.toString() !== params.toString()) { setResult(null); setParams(next) } }
  const filter = (key: string, value: string) => { const next = new URLSearchParams(params); if (value) next.set(key, value); else next.delete(key); if (key !== 'page') next.delete('page'); updateParams(next) }
  const clearFilters = () => { const next = new URLSearchParams(params); next.delete('status'); next.delete('q'); next.delete('page'); setSearch(''); updateParams(next) }
  const activeFilters = [
    ...(status !== 'ALL' ? [{ key: 'status', label: statuses.find(row => row.value === status)!.label, onRemove: () => filter('status', 'ALL') }] : []),
    ...(q ? [{ key: 'search', label: `Search: ${q}`, onRemove: () => filter('q', '') }] : []),
  ]
  return <div className="grid min-w-0 gap-5">
    <PageHeader eyebrow="Store Operations" title="Fulfillment" description="Manage your assigned deliveries and pickups. Open an assignment to view directions, message the Buyer and record handover proof." />
    <FilterPanel label="Assignment filters" footer={<FilterTabs label="Delivery status" value={status} onChange={value => filter('status', value)} chips={statuses} />}>
      <div className="col-span-full grid min-w-0 gap-4 lg:grid-cols-[minmax(0,1fr)_minmax(10rem,14rem)] lg:items-end"><form role="search" aria-label="Find assigned deliveries" className="flex min-w-0 flex-col gap-2 sm:flex-row sm:items-end" onSubmit={event => { event.preventDefault(); setSearch(search.trim()); filter('q', search.trim()) }}>
        <div className="grid min-w-0 flex-1 gap-2"><label id="delivery-search-label" htmlFor="delivery-search" className="text-sm font-semibold">Search deliveries</label><SearchInput id="delivery-search" aria-labelledby="delivery-search-label" label="Search deliveries" name="delivery_search" placeholder="Order number or Buyer name" value={search} onChange={setSearch} maxLength={120} /></div>
        <Button type="submit" variant="secondary">Search</Button>
      </form>
      <Select label="Sort" value={sort} onChange={event => filter('sort', event.target.value)}><option value="SCHEDULED">Scheduled date</option><option value="NEWEST">Newest assignment</option></Select></div>
    </FilterPanel>
    <ActiveFilters filters={activeFilters} onClear={clearFilters} />
    {error && <StatusMessage tone="error">{error} <Button variant="quiet" onClick={() => setAttempt(value => value + 1)}>Retry</Button></StatusMessage>}
    {!result && !error ? <LoadingState label="Loading assignments…" /> : result && result.data.length === 0 ? <EmptyState icon={<Truck size={24} aria-hidden="true" />} message={activeFilters.length > 0 ? 'No assigned deliveries match these filters. Clear the filters or search for another order or Buyer.' : 'No assigned deliveries. Assignments from the Owner or Store Manager appear here.'} action={activeFilters.length > 0 ? <Button variant="secondary" onClick={clearFilters}>Clear filters</Button> : undefined} /> : result && <>
      <div className="flex flex-wrap items-center justify-between gap-3"><h2 className="text-lg font-semibold">Assigned orders</h2><p role="status" className="text-sm tabular-nums text-text-secondary">{formatCount(result.meta.total)} {result.meta.total === 1 ? 'assignment' : 'assignments'}{status !== 'ALL' || q ? ' matching your filters' : ''}</p></div>
      <ul className="grid min-w-0 gap-4 lg:grid-cols-2" aria-label="Assigned deliveries">{result.data.map(order => {
        const href = `/fulfillment/${order.id}${params.size ? `?${params.toString()}` : ''}`
        return <li key={order.id} className="min-w-0"><FulfillmentAssignmentCard order={order} reference={<Link to={href} className="inline-flex min-h-11 items-center hover:text-action-primary">{order.reference}</Link>} action={<Link to={href} className="inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default px-4 text-sm font-semibold hover:bg-surface-canvas">View assignment<ArrowRight size={16} aria-hidden="true" /></Link>} /></li>
      })}</ul>
      <Pagination page={page} hasMore={result.meta.hasMore} total={result.meta.total} onChange={value => filter('page', String(value))} />
    </>}
  </div>
}

function AssignedDelivery({ orderId }: { orderId: string }) {
  const [params] = useSearchParams()
  const [order, setOrder] = useState<OrderDetail | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [messageOpen, setMessageOpen] = useState(false)
  const [notice, setNotice] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const key = useRef(newIdempotencyKey())
  const readVersion = useRef(0)
  const acceptUpdate = useCallback((updated: OrderDetail, text: string) => {
    // An automatic read begun before proof submission must not restore an older milestone.
    readVersion.current++
    setOrder(current => current && current.lockVersion > updated.lockVersion ? current : updated)
    setError(null)
    setNotice(text)
  }, [])
  const reload = useCallback(() => setAttempt(value => value + 1), [])
  useNavigationRefresh(reload)
  useEffect(() => {
    let active = true
    const version = ++readVersion.current
    void getOrder(orderId).then(value => { if (active && version === readVersion.current) { setOrder(current => current && current.id === value.id && current.lockVersion > value.lockVersion ? current : value); setError(null) } }).catch(async cause => {
      const failure = await apiFailure(cause)
      const message = await readableOrderError(cause)
      if (active && version === readVersion.current) { if (failure && ['ORDER_NOT_FOUND', 'PERMISSION_DENIED', 'UNAUTHENTICATED', 'MEMBERSHIP_NOT_ACTIVE', 'ACCOUNT_NOT_ACTIVE', 'DELIVERY_CONTACT_UNAVAILABLE'].includes(failure.code ?? '')) { setOrder(null); setMessageOpen(false) }; setError(message) }
    })
    return () => { active = false }
  }, [orderId, attempt])
  return <div className="grid min-w-0 gap-5">
    <Link to={`/fulfillment${params.size ? `?${params.toString()}` : ''}`} className="inline-flex min-h-11 items-center text-action-primary">← Assigned deliveries</Link>
    {error && <StatusMessage tone="error">{error} <Button variant="quiet" onClick={reload}>Retry</Button></StatusMessage>}
    {!order ? !error && <LoadingState label="Loading delivery…" /> : <>
      <PageHeader eyebrow="Assigned fulfillment" title={order.reference} status={order.fulfillment?.state ?? ''} description={`${order.buyer?.displayName ?? 'Buyer'} · ${fulfillmentScheduledDate(order.fulfillment?.expectedDate)}`} />
      {notice && <StatusMessage tone="success">{notice}</StatusMessage>}
      <div className="grid min-w-0 items-start gap-5 xl:grid-cols-[minmax(0,1fr)_minmax(0,1.1fr)]">
        <div className="grid min-w-0 gap-5">
        <DeliveryInformation order={order} busy={busy} onMessage={() => setMessageOpen(true)} onAcknowledge={() => void (async () => {
          setBusy(true)
          try { acceptUpdate(await acknowledgeAssignment(order.id, key.current), 'Assignment acknowledged.'); key.current = newIdempotencyKey() } catch (cause) { setError(await readableOrderError(cause)) } finally { setBusy(false) }
        })()} />
        {order.lines?.length > 0 && <DashboardPanel title="Items to fulfill" description="Confirmed item quantities for this assignment."><dl className="divide-y divide-border-default">{order.lines.filter(line => line.change !== 'LINE_REMOVED' && Number(line.confirmedQuantity ?? line.requestedQuantity) > 0).map(line => <div key={line.id} className="flex min-w-0 flex-wrap items-start justify-between gap-3 py-3 first:pt-0 last:pb-0"><dt className="min-w-0 flex-1 break-words font-semibold">{line.displayName}{line.variantLabel && <span className="mt-1 block text-xs font-normal text-text-secondary">{line.variantLabel}</span>}</dt><dd className="text-sm font-semibold tabular-nums">{quantityText(line.confirmedQuantity ?? line.requestedQuantity)} {line.unitName}</dd></div>)}</dl></DashboardPanel>}
        </div>
        <div className="grid min-w-0 gap-5">
          <FulfillmentWorkspace staffWorkspace order={order} onChanged={acceptUpdate} onReload={reload} />
          {order.fulfillmentMethod === 'DELIVERY' && <DeliveryDirections key={order.id} orderId={order.id} fallbackDestination={destinationText(order)} />}
        </div>
      </div>
      {messageOpen && order.fulfillment?.thread.conversationId && <FulfillmentConversationDialog conversationId={order.fulfillment.thread.conversationId} onClose={() => setMessageOpen(false)} />}
    </>}
  </div>
}

function DeliveryInformation({ order, busy, onMessage, onAcknowledge }: { order: OrderDetail; busy: boolean; onMessage: () => void; onAcknowledge: () => void }) {
  const intended = order.destination?.intended
  const alternate = order.destination?.heavyVehicleRestriction === 'YES' || order.destination?.vehicleEndpoint === 'ALTERNATE_DROP_OFF'
  const address = String(intended?.formattedAddress ?? intended?.label ?? destinationText(order))
  const buyer = order.buyer
  return <section aria-label="Delivery coordination" className="grid min-w-0 gap-5 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
    <header className="flex items-center gap-2"><UserRound size={20} className="shrink-0 text-action-primary" aria-hidden="true" /><h2 className="text-lg font-semibold">Delivery information</h2></header>
    <div className="grid min-w-0 gap-3">
      <div className="flex min-w-0 items-center gap-3"><ChatAvatar name={buyer?.displayName ?? 'Buyer'} path={buyer?.avatarPath} load={readDeliveryBuyerPhoto} /><div className="min-w-0"><p className="text-xs font-semibold text-text-secondary">Buyer</p><p className="break-words text-lg font-semibold">{buyer?.displayName ?? 'Buyer'}</p></div></div>
      <div className="grid min-w-0 gap-1"><p className="text-xs font-semibold text-text-secondary">Phone number</p>{buyer?.mobileE164 ? <CopyableText value={buyer.mobileE164} copyLabel="Copy Buyer phone number" /> : <p className="text-sm text-text-secondary">Phone number unavailable. Use Message Buyer to coordinate.</p>}</div>
    </div>
    <dl className="grid min-w-0 gap-4 border-t border-border-default pt-4 text-sm">
      <div className="grid min-w-0 gap-1.5"><dt className="flex items-center gap-2 font-semibold"><MapPin size={16} className="shrink-0 text-text-secondary" aria-hidden="true" />{order.fulfillmentMethod === 'DELIVERY' ? 'Delivery address' : 'Pickup address'}</dt><dd className="break-words leading-6 text-text-secondary">{address}</dd></div>
      {alternate && <div className="grid min-w-0 gap-1.5"><dt className="font-semibold">Confirmed vehicle drop-off</dt><dd className="break-words leading-6 text-text-secondary">{destinationText(order)}</dd><dd className="text-xs leading-5 text-text-secondary">Alternate drop-off for the accepted heavy-vehicle restriction.</dd></div>}
      <div className="grid min-w-0 gap-4 sm:grid-cols-2">
        <div className="grid min-w-0 gap-1.5"><dt className="flex items-center gap-2 font-semibold"><Truck size={16} className="shrink-0 text-text-secondary" aria-hidden="true" />Assigned vehicle</dt><dd className="break-words text-text-secondary">{order.fulfillment?.assignment?.vehicle?.name ?? (order.fulfillmentMethod === 'PICKUP' ? 'Self-Pickup' : 'Awaiting vehicle assignment')}</dd></div>
        <div className="grid min-w-0 gap-1.5"><dt className="flex items-center gap-2 font-semibold"><CalendarDays size={16} className="shrink-0 text-text-secondary" aria-hidden="true" />Scheduled date</dt><dd className="break-words text-text-secondary">{fulfillmentScheduledDate(order.fulfillment?.expectedDate)}</dd></div>
      </div>
      {order.destination?.accessInstructions && <div className="grid min-w-0 gap-1.5"><dt className="font-semibold">Access instructions</dt><dd className="whitespace-pre-wrap break-words leading-6 text-text-secondary">{String(order.destination.accessInstructions)}</dd></div>}
    </dl>
    <footer className="grid min-w-0 gap-3 border-t border-border-default pt-4">
      <div className="flex min-w-0 flex-col gap-3 sm:flex-row sm:flex-wrap">
        {!order.fulfillment?.assignment?.acknowledgedAt && <Button className="w-full sm:w-auto" disabled={busy} onClick={onAcknowledge}>{busy ? 'Saving…' : 'Acknowledge assignment'}</Button>}
        <Button variant="secondary" className="w-full sm:w-auto" disabled={!order.fulfillment?.thread.conversationId} onClick={onMessage}><MessageSquare size={16} aria-hidden="true" />Message Buyer<CountBadge count={order.fulfillment?.thread.unreadCount ?? 0} /></Button>
      </div>
      {order.fulfillment?.assignment?.acknowledgedAt && <p className="text-xs leading-5 text-text-secondary">Acknowledged {formatManilaDateTime(order.fulfillment.assignment.acknowledgedAt)}</p>}
    </footer>
  </section>
}

function DeliveryDirections({ orderId, fallbackDestination }: { orderId: string; fallbackDestination: string }) {
  const [route, setRoute] = useState<DeliveryNavigationRoute | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setError(null)
    void getDeliveryDirections(orderId).then(value => { if (active) setRoute(value) }).catch(async cause => {
      const failure = await apiFailure(cause)
      const text = await readableOrderError(cause)
      if (active) {
        if (failure && ['ORDER_NOT_FOUND', 'PERMISSION_DENIED', 'UNAUTHENTICATED', 'MEMBERSHIP_NOT_ACTIVE', 'ACCOUNT_NOT_ACTIVE'].includes(failure.code ?? '')) setRoute(null)
        setError(text)
      }
    })
    return () => { active = false }
  }, [orderId, attempt])
  const navigation = route ? `https://www.google.com/maps/dir/?api=1&origin=${route.origin.latitude},${route.origin.longitude}&destination=${route.destination.latitude},${route.destination.longitude}&travelmode=driving` : `https://www.google.com/maps/dir/?api=1&destination=${encodeURIComponent(fallbackDestination)}&travelmode=driving`
  return <section aria-label="Delivery directions" className="grid min-w-0 gap-5 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
    <header className="grid gap-2"><h2 className="flex items-center gap-2 text-lg font-semibold"><Navigation size={20} className="shrink-0 text-action-primary" aria-hidden="true" />Route and navigation</h2><p className="text-sm leading-6 text-text-secondary">Registered store to the confirmed drop-off. No live GPS tracking.</p></header>
    {route ? <>
      <dl className="grid min-w-0 grid-cols-2 gap-4 rounded-control bg-surface-canvas p-4 text-sm" aria-label="Driving estimate">
        <div className="grid gap-2"><dt className="flex items-center gap-2 text-text-secondary"><RouteIcon size={16} className="shrink-0" aria-hidden="true" />Distance</dt><dd className="text-lg font-semibold tabular-nums">{(route.distanceMeters / 1000).toFixed(1)} <span className="text-sm font-normal">km</span></dd></div>
        <div className="grid gap-2"><dt className="flex items-center gap-2 text-text-secondary"><Clock3 size={16} className="shrink-0" aria-hidden="true" />Driving time</dt><dd className="text-lg font-semibold tabular-nums">{Math.ceil(route.durationSeconds / 60)} <span className="text-sm font-normal">min</span></dd></div>
      </dl>
      <DeliveryRouteMap origin={route.origin} destination={route.destination} encodedPolyline={route.encodedPolyline} browserKey={import.meta.env.VITE_GOOGLE_MAPS_BROWSER_KEY ?? ''} />
      <p className="text-xs leading-5 text-text-secondary">Google Routes estimate · {formatManilaDateTime(route.computedAt)}. Travel time may change.</p>
    </> : <div className="grid min-w-0 gap-4">
      <div className="grid gap-1.5 rounded-control bg-surface-canvas p-4 text-sm"><p className="font-semibold">Confirmed drop-off</p><p className="break-words leading-6 text-text-secondary">{fallbackDestination}</p></div>
      {error ? <StatusMessage tone="error">{error}<Button variant="quiet" className="mt-2 w-full sm:w-auto" onClick={() => setAttempt(value => value + 1)}>Retry route</Button></StatusMessage> : <p role="status" className="text-sm text-text-secondary">Loading delivery route…</p>}
    </div>}
    <footer className="grid min-w-0 gap-3 border-t border-border-default pt-4">
      <a className="inline-flex min-h-12 w-full items-center justify-center gap-2 rounded-control bg-action-primary px-4 py-2 text-sm font-semibold text-white hover:bg-action-primary-pressed focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring sm:min-h-11 sm:w-fit" href={navigation} target="_blank" rel="noopener noreferrer"><Navigation size={16} aria-hidden="true" />Open directions</a>
      <p className="text-xs leading-5 text-text-secondary">Opens Google Maps for navigation to the confirmed drop-off.</p>
    </footer>
  </section>
}
