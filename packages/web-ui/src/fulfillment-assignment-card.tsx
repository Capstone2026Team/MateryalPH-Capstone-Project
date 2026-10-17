import type { ReactNode } from 'react'
import type { OrderDetail } from '@materyalph/api-client-ts'
import { AlertTriangle, CalendarDays, MapPin, MessageSquare, Truck } from 'lucide-react'
import { StatusBadge } from './portal-shell'
import { orderStateLabel } from './order-patterns'
import { formatManilaDateTime } from './stock-ledger'

export function fulfillmentDestinationLabel(order: OrderDetail): string {
  const destination = order.destination
  if (!destination) return 'Destination unavailable'
  if (destination.type === 'PICKUP') return String(destination.storeAddress ?? 'Store pickup')
  const endpoint = destination.vehicleEndpoint === 'ALTERNATE_DROP_OFF' || destination.heavyVehicleRestriction === 'YES' ? destination.alternateDropOff : destination.intended
  return String(endpoint?.formattedAddress ?? endpoint?.label ?? 'Confirmed destination')
}

export function fulfillmentScheduledDate(value?: string | null): string {
  if (!value) return 'Not scheduled'
  const date = new Date(`${value}T00:00:00+08:00`)
  return Number.isNaN(date.getTime()) ? value : new Intl.DateTimeFormat('en-PH', { month: 'short', day: 'numeric', year: 'numeric', timeZone: 'Asia/Manila' }).format(date)
}

/** The same assignment presentation in the staff dashboard and the paginated fulfillment queue. */
export function FulfillmentAssignmentCard({ order, reference, action }: { order: OrderDetail; reference: ReactNode; action: ReactNode }) {
  const fulfillment = order.fulfillment
  const delivered = ['DELIVERED', 'PICKED_UP', 'COMPLETED'].includes(fulfillment?.state ?? '')
  const issue = !delivered && (fulfillment?.vehicleIssues?.length ?? 0) > 0
  const unread = fulfillment?.thread.unreadCount ?? 0
  return <article className="flex h-full min-w-0 flex-col gap-4 rounded-surface border border-border-default bg-surface-primary p-4 [overflow-wrap:anywhere] sm:p-5">
    <header className="flex min-w-0 flex-wrap items-start justify-between gap-3">
      <div className="min-w-0"><p className="text-xs text-text-secondary">{order.fulfillmentMethod === 'PICKUP' ? 'Self-Pickup' : 'Site Delivery'}</p><h3 className="mt-1 break-words text-base font-semibold text-text-strong [overflow-wrap:anywhere]">{reference}</h3></div>
      <StatusBadge label={orderStateLabel(fulfillment?.state ?? '')} tone={delivered ? 'success' : fulfillment?.state === 'OUT_FOR_DELIVERY' ? 'info' : 'neutral'} />
    </header>
    <div className="grid min-w-0 gap-2">
      <p className="break-words font-semibold text-text-strong">{order.buyer?.displayName ?? 'Buyer'}</p>
      <p className="flex min-w-0 items-start gap-2 text-sm leading-6 text-text-secondary"><MapPin size={16} className="mt-1 shrink-0" aria-hidden="true" /><span className="break-words">{fulfillmentDestinationLabel(order)}</span></p>
    </div>
    <dl className="grid min-w-0 gap-4 border-t border-border-default pt-4 text-sm sm:grid-cols-2">
      <div className="min-w-0"><dt className="flex items-center gap-2 text-xs text-text-secondary"><CalendarDays size={15} aria-hidden="true" />Scheduled date</dt><dd className="mt-1 font-semibold">{fulfillmentScheduledDate(fulfillment?.expectedDate)}</dd></div>
      <div className="min-w-0"><dt className="flex items-center gap-2 text-xs text-text-secondary"><Truck size={15} aria-hidden="true" />Vehicle</dt><dd className="mt-1 break-words font-semibold">{fulfillment?.assignment?.vehicle?.name ?? (order.fulfillmentMethod === 'PICKUP' ? 'Self-Pickup' : 'Awaiting vehicle assignment')}</dd></div>
    </dl>
    {(!delivered && fulfillment?.late || issue) && <div className="flex flex-wrap gap-2">
      {!delivered && fulfillment?.late && <StatusBadge label="Past scheduled date" tone="warning" icon={<AlertTriangle size={14} aria-hidden="true" />} />}
      {issue && <StatusBadge label="Delivery issue reported" tone="warning" icon={<AlertTriangle size={14} aria-hidden="true" />} />}
    </div>}
    {order.destination?.accessInstructions && <p className="break-words text-sm leading-6 text-text-secondary"><span className="font-semibold text-text-strong">Access instructions: </span>{String(order.destination.accessInstructions)}</p>}
    <footer className="mt-auto grid min-w-0 gap-3 border-t border-border-default pt-4 sm:grid-cols-[minmax(0,1fr)_auto] sm:items-center">
      <div className="min-w-0 text-xs leading-5 text-text-secondary">{fulfillment?.assignment?.assignedAt && <p>Assigned {formatManilaDateTime(fulfillment.assignment.assignedAt)}</p>}{!delivered && !fulfillment?.assignment?.acknowledgedAt && <p className="font-semibold text-action-primary">Awaiting your acknowledgement</p>}{unread > 0 && <p className="flex items-center gap-1.5"><MessageSquare size={14} aria-hidden="true" />{unread} unread {unread === 1 ? 'message' : 'messages'}</p>}</div>
      <div className="grid min-w-0 [&>*]:justify-center">{action}</div>
    </footer>
  </article>
}
