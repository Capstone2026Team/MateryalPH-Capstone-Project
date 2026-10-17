import { useCallback, useEffect, useState } from 'react'
import { Link } from 'react-router-dom'
import type { DeliveryWorkspacePage, ListAssignedFulfillmentsStatusEnum } from '@materyalph/api-client-ts'
import { AlertTriangle, ArrowRight, Boxes, CalendarDays, CheckCircle2, ClipboardList, FileText, MessageSquare, PackageCheck, Scale, Truck } from 'lucide-react'
import { Button, DashboardPanel, EmptyState, FulfillmentAssignmentCard, KpiCard, StatusMessage, formatCount, useNavigationRefresh, usePortalResource } from '@materyalph/web-ui'
import { readableApiError } from '../lib/auth-api'
import { getVendorDashboardInsights } from '../lib/dashboard-api'
import { listAssignedFulfillments } from '../lib/orders-api'
import { ActionList } from './VendorDashboardInsights'

function useStaffDashboardResource<T>(key: string, loader: () => Promise<T>) {
  const resource = usePortalResource(key, loader)
  const [message, setMessage] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    setMessage(null)
    if (resource.error) void readableApiError(resource.error).then(text => { if (active) setMessage(text) })
    return () => { active = false }
  }, [resource.error])
  useNavigationRefresh(() => { void resource.synchronize() }, { intervalMs: resource.error ? 120_000 : 60_000 })
  return { ...resource, message }
}

function ResourceFeedback({ message, pending, retry }: { message: string | null; pending: boolean; retry: () => void }) {
  return message ? <StatusMessage tone="error">{message}<Button variant="secondary" className="mt-3" onClick={retry}>Retry dashboard</Button></StatusMessage>
    : <p role="status" className="text-sm text-text-secondary">{pending ? 'Loading your dashboard…' : 'Preparing your dashboard…'}</p>
}

export function VendorStaffDashboard({ permissions }: { permissions: string[] }) {
  return permissions.includes('portal.fulfillment') && !permissions.includes('fulfillment.assign') ? <FulfillmentStaffDashboard /> : <OperationsStaffDashboard permissions={permissions} />
}

const loadOperations = () => getVendorDashboardInsights({})

function OperationsStaffDashboard({ permissions }: { permissions: string[] }) {
  const { data, message, pending, refresh } = useStaffDashboardResource('vendor-staff-dashboard', loadOperations)
  const has = (permission: string) => permissions.includes(permission)
  const inventoryRole = has('inventory.manage') && !has('orders.confirm')
  const shortcuts = [
    { permission: 'orders.confirm', title: 'Orders', description: 'Review requests and coordinate fulfillment.', href: '/orders', icon: ClipboardList },
    { permission: 'portal.messages', title: 'Messages', description: 'Coordinate with Buyers and your store.', href: '/messages', icon: MessageSquare },
    { permission: 'inventory.manage', title: 'Inventory', description: 'Maintain stock and replenishment.', href: '/products/inventory', icon: Boxes },
    { permission: 'catalog.manage', title: 'Products', description: 'Maintain listings and product compliance.', href: '/products', icon: PackageCheck },
    { permission: 'portal.disputes', title: 'Disputes', description: 'Respond to cases and submit evidence.', href: '/disputes', icon: Scale },
    { permission: 'portal.invoices', title: 'E-Invoices', description: 'Review order invoice requests and status.', href: '/invoices', icon: FileText },
    { permission: 'vehicles.manage', title: 'Vehicles', description: 'Manage the store’s delivery vehicles.', href: '/vehicles', icon: Truck },
  ].filter(item => has(item.permission))
  if (!data) return <ResourceFeedback message={message} pending={pending} retry={() => void refresh()} />
  const actions = data.actions.filter(action => action.key !== 'ASSIGNED_FULFILLMENT' && (action.href !== '/products/inventory' || has('inventory.manage')) && (action.href !== '/orders' || has('orders.confirm')) && (action.href !== '/disputes' || has('portal.disputes')))
  const metrics = inventoryRole && data.stock ? [
    { label: 'In stock', count: data.stock.inStock, hint: 'Variants available to sell.', icon: PackageCheck },
    { label: 'Low stock', count: data.stock.limitedStock, hint: 'At or below their configured reorder level.', icon: AlertTriangle },
    { label: 'Out of stock', count: data.stock.outOfStock, hint: 'Variants that need replenishment.', icon: Boxes },
  ] : actions.filter(action => ['ORDER_CONFIRMATION', 'FULFILLMENT_DUE_TODAY', 'FULFILLMENT_OVERDUE', 'DISPUTE_RESPONSE'].includes(action.key)).map(action => ({
    label: ({ ORDER_CONFIRMATION: 'Pending order decisions', FULFILLMENT_DUE_TODAY: 'Due today', FULFILLMENT_OVERDUE: 'Past scheduled date', DISPUTE_RESPONSE: 'Cases awaiting response' } as Record<string, string>)[action.key]!,
    count: action.count, hint: action.detail ?? 'Current work for your role.', icon: action.severity === 'ALERT' ? AlertTriangle : ClipboardList,
  }))
  return <div className="grid min-w-0 gap-5">
    {metrics.length > 0 && <dl aria-label="Your work overview" className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{metrics.map(metric => <KpiCard key={metric.label} label={metric.label} value={formatCount(metric.count)} hint={metric.hint} icon={<metric.icon size={16} aria-hidden="true" />} />)}</dl>}
    <div className="grid min-w-0 items-start gap-5 xl:grid-cols-[minmax(0,1.5fr)_minmax(18rem,1fr)]">
      <DashboardPanel title="Priority actions" description="Current work for your role, with urgent items first.">{actions.some(action => action.count > 0) ? <ActionList actions={actions.filter(action => action.count > 0)} /> : <p className="text-sm text-text-secondary">No work is waiting for action. Open a workspace to continue.</p>}</DashboardPanel>
      {shortcuts.length > 0 && <DashboardPanel title="Your workspace"><ul className="divide-y divide-border-default">{shortcuts.map(({ title, description, href, icon: Icon }) => <li key={href}><Link to={href} className="group flex min-h-11 items-center gap-3 py-3"><Icon size={18} className="shrink-0 text-action-primary" aria-hidden="true" /><span className="min-w-0 flex-1"><span className="block font-semibold group-hover:text-action-primary">{title}</span><span className="mt-1 block text-xs leading-5 text-text-secondary">{description}</span></span><ArrowRight size={16} className="shrink-0 text-text-secondary" aria-hidden="true" /></Link></li>)}</ul></DashboardPanel>}
    </div>
  </div>
}

const deliveryStatuses = ['ALL', 'PENDING', 'OUT_FOR_DELIVERY', 'DELIVERED', 'ISSUES'] as const satisfies readonly ListAssignedFulfillmentsStatusEnum[]
async function loadFulfillment() {
  // Use full server totals; a first page can never stand in for the number of assigned orders.
  const pages = await Promise.all(deliveryStatuses.map(status => listAssignedFulfillments({ status, sort: 'SCHEDULED', page: 1 })))
  return Object.fromEntries(deliveryStatuses.map((status, index) => [status, pages[index]!])) as Record<typeof deliveryStatuses[number], DeliveryWorkspacePage>
}

function FulfillmentStaffDashboard() {
  const loader = useCallback(loadFulfillment, [])
  const { data, message, pending, refresh } = useStaffDashboardResource('vendor-assigned-delivery-dashboard', loader)
  if (!data) return <ResourceFeedback message={message} pending={pending} retry={() => void refresh()} />
  const active = data.OUT_FOR_DELIVERY
  const upcoming = data.PENDING
  const metrics = [
    { label: 'Assigned orders', value: data.ALL.meta.total, status: 'ALL', hint: 'Your current assignments across all statuses.', icon: ClipboardList },
    { label: 'Pending fulfillment', value: upcoming.meta.total, status: 'PENDING', hint: 'Preparing or ready for pickup.', icon: CalendarDays },
    { label: 'Out for delivery', value: active.meta.total, status: 'OUT_FOR_DELIVERY', hint: 'Deliveries currently on the road.', icon: Truck },
    { label: 'Handover complete', value: data.DELIVERED.meta.total, status: 'DELIVERED', hint: 'Delivered or picked up; Buyer receipt is separate.', icon: CheckCircle2 },
  ]
  return <div className="grid min-w-0 gap-5">
    <dl aria-label="Your fulfillment overview" className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">{metrics.map(({ label, value, status, hint, icon: Icon }) => <KpiCard key={status} label={label} value={<Link className="inline-flex min-h-11 items-center hover:text-action-primary focus-visible:outline-2 focus-visible:outline-focus-ring" aria-label={`${label}: ${formatCount(value)}. View assignments`} to={`/fulfillment?status=${status}`}>{formatCount(value)}</Link>} hint={hint} icon={<Icon size={16} aria-hidden="true" />} accent={status === 'OUT_FOR_DELIVERY' && value > 0} />)}</dl>
    {data.ISSUES.meta.total > 0 && <StatusMessage tone="info"><div className="flex flex-wrap items-center justify-between gap-3"><p className="flex items-start gap-2"><AlertTriangle size={18} className="mt-0.5 shrink-0" aria-hidden="true" />{formatCount(data.ISSUES.meta.total)} assigned {data.ISSUES.meta.total === 1 ? 'order has' : 'orders have'} a reported delivery issue.</p><Link to="/fulfillment?status=ISSUES" className="inline-flex min-h-11 items-center gap-2 font-semibold underline underline-offset-4">Review delivery issues<ArrowRight size={16} aria-hidden="true" /></Link></div></StatusMessage>}
    {active.meta.total === 0 && upcoming.meta.total === 0 ? <EmptyState icon={<Truck size={24} aria-hidden="true" />} message="No deliveries or pickups are waiting for action. New assignments from your Owner or Store Manager will appear here." action={<Link to="/fulfillment" className="inline-flex min-h-11 items-center font-semibold text-action-primary">View assigned orders<ArrowRight size={16} aria-hidden="true" /></Link>} /> : <>
      {[{ title: 'Active deliveries', page: active, status: 'OUT_FOR_DELIVERY', description: 'Open an assignment to coordinate with the Buyer and submit delivery proof.' }, { title: 'Pending deliveries and pickups', page: upcoming, status: 'PENDING', description: 'Next scheduled assignments to prepare and acknowledge.' }].filter(group => group.page.meta.total > 0).map(group => <section key={group.status} aria-label={group.title} className="grid min-w-0 gap-4">
        <header className="flex flex-wrap items-center justify-between gap-3"><div><h2 className="text-lg font-semibold">{group.title}<span className="ml-2 text-sm font-normal tabular-nums text-text-secondary">{formatCount(group.page.meta.total)}</span></h2><p className="mt-1 text-sm leading-6 text-text-secondary">{group.description}</p></div><Link to={`/fulfillment?status=${group.status}`} className="inline-flex min-h-11 items-center gap-2 font-semibold text-action-primary">View all<ArrowRight size={16} aria-hidden="true" /></Link></header>
        <ul className="grid min-w-0 gap-4 lg:grid-cols-2">{group.page.data.slice(0, 4).map(order => <li key={order.id} className="min-w-0"><FulfillmentAssignmentCard order={order} reference={<Link to={`/fulfillment/${order.id}`} className="inline-flex min-h-11 items-center hover:text-action-primary">{order.reference}</Link>} action={<Link to={`/fulfillment/${order.id}`} className="inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default px-4 text-sm font-semibold hover:bg-surface-canvas">View assignment<ArrowRight size={16} aria-hidden="true" /></Link>} /></li>)}</ul>
      </section>)}
    </>}
  </div>
}
