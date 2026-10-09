import type { ReactNode } from 'react'

export const teamRoles = [
  { value: 'STORE_MANAGER', label: 'Store Manager', detail: 'Oversees orders, quotation publication, listings, inventory, fulfillment and disputes. Staff management requires Owner delegation; protected finances remain Owner-only.', categories: ['SALES', 'INVENTORY', 'FULFILLMENT', 'DISPUTES', 'TEAM'] },
  { value: 'STORE_STAFF', label: 'Store Staff', detail: 'Handles sales, published quotations, permitted disputes, listings, stock and compliance. Delivery dispatch and fulfillment proof belong to fulfillment roles.', categories: ['SALES', 'INVENTORY', 'DISPUTES'] },
  { value: 'CUSTOMER_SERVICE', label: 'Customer Service Staff', detail: 'Handles inquiries, unchanged order confirmations and quotation drafts. Dispute access depends on the Owner setting. Cannot publish quotations or change prices, stock or fulfillment.', categories: ['SALES', 'DISPUTES'] },
  { value: 'INVENTORY', label: 'Inventory Staff', detail: 'Maintains listings, variants, stock, prices, SKU allotments and PS/ICC compliance. Inventory work does not count as sales ownership.', categories: ['INVENTORY'] },
  { value: 'FULFILLMENT', label: 'Fulfillment Staff', detail: 'Prepares assigned orders, records milestones and proof, and coordinates fulfillment messages. Accepted prices, fees and vehicle configurations remain unchanged.', categories: ['FULFILLMENT'] },
] as const

export const teamCategoryLabels: Record<string, string> = { SALES: 'Orders & conversations', INVENTORY: 'Products & inventory', FULFILLMENT: 'Fulfillment', DISPUTES: 'Disputes & invoices', TEAM: 'Team management', OTHER: 'Other activity' }
export function teamRoleLabel(role: string | null | undefined) { return teamRoles.find(item => item.value === role)?.label ?? (role === 'OWNER' ? 'Vendor Owner' : role?.replaceAll('_', ' ') || 'System') }
export function teamDate(value: Date | string | null | undefined) { return value ? new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' }).format(new Date(value)) : '—' }
export function TeamAvatar({ name }: { name: string }) { return <span aria-hidden="true" className="grid h-11 w-11 shrink-0 place-items-center rounded-full border border-border-default bg-surface-canvas text-sm font-semibold text-action-primary">{name.trim().split(/\s+/).slice(0, 2).map(part => part[0]).join('').toUpperCase() || 'T'}</span> }
export function TeamPagination({ page, lastPage, busy, onPage }: { page: number; lastPage: number; busy: boolean; onPage: (page: number) => void }) { return lastPage > 1 && <div className="mt-5 flex flex-wrap items-center justify-between gap-2 text-sm"><button type="button" className="min-h-11 rounded-control px-3 text-action-primary disabled:opacity-50" disabled={busy || page <= 1} onClick={() => onPage(page - 1)}>Previous</button><span>Page {page} of {lastPage}</span><button type="button" className="min-h-11 rounded-control px-3 text-action-primary disabled:opacity-50" disabled={busy || page >= lastPage} onClick={() => onPage(page + 1)}>Next page</button></div> }
export function TeamMetric({ label, value, icon }: { label: string; value: number; icon: ReactNode }) { return <div className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-4"><div className="mb-3 flex items-center gap-2 text-text-secondary">{icon}<span className="text-sm">{label}</span></div><p className="text-3xl font-semibold tabular-nums">{value.toLocaleString('en-PH')}</p><p className="mt-2 text-xs text-text-secondary">Recorded events in selected period</p></div> }

export function TeamActivityDistribution({ categories, onSelect }: { categories: { category: string; count: number }[]; onSelect: (category: string) => void }) {
  const maximum = Math.max(1, ...categories.map(item => item.count))
  return <section className="rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5" aria-label="Activity distribution">
    <h3 className="font-semibold">Activity distribution</h3>
    <p className="mt-2 text-sm leading-6 text-text-secondary">Recorded actions by work area. Select a column to open its history.</p>
    <div className="mt-5 overflow-x-auto pb-2">
      <div className="relative min-w-[480px] pl-10">
        <div aria-hidden="true" className="pointer-events-none absolute inset-x-0 top-0 flex h-52 flex-col justify-between text-xs tabular-nums text-text-secondary">{[maximum, Math.round(maximum / 2), 0].map((value, index) => <div key={index} className="flex items-center gap-3"><span className="w-7 text-right">{value}</span><span className="flex-1 border-t border-dashed border-border-default" /></div>)}</div>
        <div className="relative grid grid-cols-6 gap-3">{categories.map(item => <button type="button" key={item.category} onClick={() => onSelect(item.category)} className="group min-w-0 rounded-control focus-visible:outline-2 focus-visible:outline-focus-ring" aria-label={`${teamCategoryLabels[item.category]}: ${item.count} recorded actions. View history.`}>
          <span className="flex h-52 items-end justify-center px-3 pt-5"><span className="relative block w-full max-w-16 rounded-t-control bg-action-primary group-hover:bg-action-primary-pressed" style={{ height: `${item.count / maximum * 100}%` }}><span className="absolute inset-x-0 -top-6 text-center text-xs font-semibold tabular-nums text-text-strong">{item.count}</span></span></span>
          <span className="mt-4 block min-h-11 text-xs leading-5 text-text-secondary">{teamCategoryLabels[item.category]}</span>
        </button>)}</div>
      </div>
    </div>
    {categories.every(item => item.count === 0) && <p className="mt-3 text-sm text-text-secondary">No activity recorded for this selection yet.</p>}
  </section>
}
