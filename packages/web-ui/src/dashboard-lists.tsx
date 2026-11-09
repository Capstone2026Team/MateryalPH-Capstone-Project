import type { ReactNode } from 'react'
import { Activity, BadgePercent, ClipboardList, FileText, MessageSquare, Package, ReceiptText, Scale, ShieldCheck, ShoppingBag, Truck, Users } from 'lucide-react'
import { formatCount } from './chart-patterns'
import { formatManilaDateTime } from './stock-ledger'
import './dashboard-activity.css'

const activityTime = new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' })

export type DashboardQueueItem = { key: string; label: string; count: number; detail?: ReactNode; attention?: boolean }

/** Both portals keep queue navigation while sharing the same compact row hierarchy. */
export function DashboardQueueList<T extends DashboardQueueItem>({ items, empty, renderLink }: { items: T[]; empty: string; renderLink: (item: T, content: ReactNode) => ReactNode }) {
  if (!items.length) return <p className="text-sm text-text-secondary">{empty}</p>
  return <ul className="mp-analytics-queue">{items.map(item => <li key={item.key}>{renderLink(item, <>
    <span className="min-w-0 flex-1"><strong>{item.label}</strong>{item.detail && <small>{item.detail}</small>}</span>
    <span className="mp-analytics-queue-count" data-attention={item.attention || undefined}>{formatCount(item.count)}</span>
  </>)}</li>)}</ul>
}

export type DashboardActivityItem = { key: string; title: string; detail: ReactNode; at: Date; timeLabel?: string; unsuccessful?: boolean; eventType?: string; resourceType?: string }

function activityIcon(item: DashboardActivityItem) {
  const event = `${item.eventType ?? item.title} ${item.resourceType ?? ''}`.toUpperCase()
  if (/INVOICE|PAYMENT|REFUND|FINANCE/.test(event)) return ReceiptText
  if (/INVENTORY|STOCK/.test(event)) return ShoppingBag
  if (/DISCOUNT|PRICE/.test(event)) return BadgePercent
  if (/PRODUCT|LISTING|CATALOG/.test(event)) return Package
  if (/DELIVERY|FULFILLMENT|SHIPPED|SHIPPING|PICKUP/.test(event)) return Truck
  if (/DISPUTE|APPEAL|REMEDY/.test(event)) return Scale
  if (/VERIFICATION|COMPLIANCE|ENFORCEMENT|RESTRICTION/.test(event)) return ShieldCheck
  if (/QUOTATION|DOCUMENT|EXPORT/.test(event)) return FileText
  if (/MESSAGE|CONVERSATION/.test(event)) return MessageSquare
  if (/ORDER/.test(event)) return ClipboardList
  if (/USER|MEMBER|TEAM|ACCOUNT|VENDOR|BUYER/.test(event)) return Users
  return Activity
}

/** Safe, caller-selected event text; arbitrary activity payloads never render here. */
export function DashboardActivityList({ label, items }: { label: string; items: DashboardActivityItem[] }) {
  return <ol aria-label={label} className="mp-analytics-activity">{items.map(item => {
    const Icon = activityIcon(item)
    return <li key={item.key} data-unsuccessful={item.unsuccessful || undefined}>
    <span aria-hidden="true" className="mp-dashboard-activity-icon"><Icon size={18} strokeWidth={1.7} /></span><div className="mp-dashboard-activity-content"><strong>{item.title}{/[:.!?]$/.test(item.title) ? '' : ':'}</strong><p>{item.detail}</p>
      {item.unsuccessful && <p className="font-semibold text-status-error">Unsuccessful</p>}
      <time dateTime={item.at.toISOString()} title={formatManilaDateTime(item.at)}>{item.timeLabel ?? activityTime.format(item.at)}</time>
    </div>
  </li>})}</ol>
}
