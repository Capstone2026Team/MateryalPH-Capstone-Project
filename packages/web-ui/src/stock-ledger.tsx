import { Fragment, useEffect, useState, type ReactNode } from 'react'
import { AlertTriangle, CheckCircle2, Clock, EyeOff, XCircle } from 'lucide-react'
import { Button } from './button'

export type StockLabelValue = 'IN_STOCK' | 'LIMITED_STOCK' | 'OUT_OF_STOCK'

const stockLabels: Record<StockLabelValue, { text: string; icon: typeof CheckCircle2; className: string }> = {
  IN_STOCK: { text: 'In Stock', icon: CheckCircle2, className: 'border-green-300 bg-green-50 text-green-900' },
  LIMITED_STOCK: { text: 'Limited Stock', icon: AlertTriangle, className: 'border-amber-300 bg-amber-50 text-amber-900' },
  OUT_OF_STOCK: { text: 'Out of Stock', icon: XCircle, className: 'border-red-300 bg-red-50 text-red-900' },
}

export function stockLabelText(label: string): string {
  return stockLabels[label as StockLabelValue]?.text ?? 'Out of Stock'
}

/** The only stock wording a Buyer receives, shown as text plus icon beside the Vendor's private numbers. */
export function StockLabelBadge({ label, prefix = 'Buyers see' }: { label: string; prefix?: string }) {
  const entry = stockLabels[label as StockLabelValue] ?? stockLabels.OUT_OF_STOCK
  const Icon = entry.icon
  return <span className={`inline-flex max-w-full items-center gap-1.5 rounded-pill border px-2.5 py-0.5 text-xs font-semibold ${entry.className}`}>
    <Icon size={14} aria-hidden="true" /><span className="min-w-0">{prefix ? <span className="font-normal">{prefix}: </span> : null}{entry.text}</span>
  </span>
}

export type LedgerColumn<T> = { key: string; header: ReactNode; cell: (row: T) => ReactNode; className?: string; headerClassName?: string }

/**
 * Dense ledger. The header stays visible while rows scroll, the identifier column is frozen, and wide
 * content scrolls horizontally inside the table's own labelled region, never the page. An expanded row
 * renders an inline editor directly under its row.
 */
export function DenseLedgerTable<T>({ caption, columns, rows, rowKey, expandedKey, renderExpanded, emptyText }: {
  caption: string; columns: LedgerColumn<T>[]; rows: T[]; rowKey: (row: T) => string
  expandedKey?: string | null; renderExpanded?: (row: T) => ReactNode; emptyText?: string
}) {
  const [first, ...rest] = columns
  return <div role="region" aria-label={caption} tabIndex={0} className="max-h-[70vh] max-w-full overflow-auto rounded-surface border border-border-default bg-surface-primary focus-visible:outline-2 focus-visible:outline-focus-ring">
    <table className="w-full min-w-[1320px] border-separate border-spacing-0 text-left text-sm">
      <caption className="sr-only">{caption}</caption>
      <thead className="sticky top-0 z-20">
        <tr>{first && <th scope="col" className={`sticky left-0 z-30 w-40 border-b border-border-default bg-surface-canvas px-3 py-2.5 font-semibold text-text-strong sm:w-56 ${first.headerClassName ?? ''}`}>{first.header}</th>}
          {rest.map(column => <th key={column.key} scope="col" className={`border-b border-border-default bg-surface-canvas px-3 py-2.5 font-semibold text-text-strong ${column.headerClassName ?? ''}`}>{column.header}</th>)}</tr>
      </thead>
      <tbody>
        {rows.length === 0 && <tr><td colSpan={columns.length} className="px-3 py-6 text-center text-text-secondary">{emptyText ?? 'No rows.'}</td></tr>}
        {rows.map(row => {
          const key = rowKey(row)
          const expanded = expandedKey === key
          return <Fragment key={key}>
            <tr className={`align-top ${expanded ? 'bg-brand-orange-50' : ''}`}>
              {first && <th scope="row" className={`sticky left-0 z-10 w-40 border-b border-border-default px-3 py-2.5 text-left font-normal sm:w-56 ${expanded ? 'bg-brand-orange-50' : 'bg-surface-primary'} ${first.className ?? ''}`}>{first.cell(row)}</th>}
              {rest.map(column => <td key={column.key} className={`border-b border-border-default px-3 py-2.5 ${column.className ?? ''}`}>{column.cell(row)}</td>)}
            </tr>
            {expanded && renderExpanded && <tr><td colSpan={columns.length} className="border-b border-border-default bg-surface-canvas p-0"><div className="sticky left-0 w-[min(100%,calc(100vw-2rem))] max-w-4xl p-4">{renderExpanded(row)}</div></td></tr>}
          </Fragment>
        })}
      </tbody>
    </table>
  </div>
}

/**
 * Optimistic-concurrency conflict. The editor's input is kept; the current saved values are shown so the
 * person can reapply their change on top of them instead of silently overwriting another editor.
 */
export function ConflictBanner({ title = 'This row changed while you were editing', children, onUseCurrent, useCurrentLabel = 'Use current values' }: {
  title?: string; children: ReactNode; onUseCurrent: () => void; useCurrentLabel?: string
}) {
  return <div role="alert" className="grid gap-3 rounded-surface border border-amber-300 bg-amber-50 p-3 text-sm text-amber-950">
    <p className="flex items-start gap-2 font-semibold"><AlertTriangle size={16} className="mt-0.5 shrink-0" aria-hidden="true" />{title}</p>
    <div className="min-w-0">{children}</div>
    <Button variant="secondary" className="justify-self-start" onClick={onUseCurrent}>{useCurrentLabel}</Button>
  </div>
}

const manila = new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' })

export type DateLike = string | Date | null | undefined

const toDate = (value: DateLike): Date | null => { if (!value) return null; const date = value instanceof Date ? value : new Date(value); return Number.isNaN(date.getTime()) ? null : date }

export function formatManilaDateTime(value: DateLike): string {
  const date = toDate(value)
  return date ? `${manila.format(date)} (Asia/Manila)` : '—'
}

export function countdownText(target: DateLike, now: number): string {
  const date = toDate(target)
  if (!date) return ''
  const remaining = date.getTime() - now
  if (remaining <= 0) return 'Due now'
  const hours = Math.floor(remaining / 3_600_000)
  const days = Math.floor(hours / 24)
  return days > 0 ? `${days} day${days === 1 ? '' : 's'} ${hours % 24} h left` : `${Math.max(1, hours)} h left`
}

/** Re-renders once a minute so countdowns stay current; stops on unmount. */
export function useMinuteClock(initial?: number): number {
  const [now, setNow] = useState(() => initial ?? Date.now())
  useEffect(() => {
    if (initial !== undefined) return
    const timer = window.setInterval(() => setNow(Date.now()), 60_000)
    return () => window.clearInterval(timer)
  }, [initial])
  return now
}

export type StaleStockItem = { id: string; name: string; state: string; hideAt: DateLike; hidden: boolean }

/**
 * Persistent stale-stock band. Each listing shows its countdown with the exact Asia/Manila date and time.
 * Hidden listings say so plainly; hiding is never described as a store suspension.
 */
export function StaleStockBand({ count, items, now, renderAction }: { count: number; items: StaleStockItem[]; now?: number; renderAction?: (item: StaleStockItem) => ReactNode }) {
  const clock = useMinuteClock(now)
  if (count === 0) return null
  const hidden = items.some(item => item.hidden)
  return <section aria-labelledby="stale-stock-heading" className={`rounded-surface border-l-4 border border-border-default p-4 ${hidden ? 'border-l-status-error bg-red-50' : 'border-l-status-warning bg-amber-50'}`}>
    <h2 id="stale-stock-heading" className="flex items-center gap-2 font-semibold text-text-strong"><Clock size={18} aria-hidden="true" />{count} listing{count === 1 ? '' : 's'} need a stock confirmation</h2>
    <p className="mt-1 text-sm text-text-strong">Confirm counts at least every 15 days. Reminders arrive on Day 7 and Day 12; on Day 15 the listing is temporarily hidden from Buyers until its stock is confirmed. Your store is not suspended.</p>
    <ul className="mt-3 grid gap-2">{items.map(item => <li key={item.id} className="flex min-w-0 flex-wrap items-center justify-between gap-2 border-t border-border-default/60 pt-2 text-sm">
      <span className="min-w-0 break-words font-semibold">{item.name}</span>
      <span className="flex min-w-0 flex-wrap items-center gap-2">
        {item.hidden
          ? <span className="inline-flex items-center gap-1 font-semibold text-status-error"><EyeOff size={14} aria-hidden="true" />Hidden from Buyers</span>
          : <span className="font-semibold tabular-nums">{countdownText(item.hideAt, clock)}</span>}
        <span className="text-text-secondary">{item.hidden ? 'Since' : 'Hides'} <time dateTime={toDate(item.hideAt)?.toISOString()}>{formatManilaDateTime(item.hideAt)}</time></span>
        {renderAction?.(item)}
      </span>
    </li>)}</ul>
    {count > items.length && <p className="mt-2 text-sm text-text-secondary">And {count - items.length} more. Filter the ledger by “Confirmation due” to see them.</p>}
  </section>
}
