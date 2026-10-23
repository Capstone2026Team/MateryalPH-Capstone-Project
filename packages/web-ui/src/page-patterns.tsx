import { createContext, useId, useState, type FormEventHandler, type ReactNode } from 'react'
import { Info, SearchX, X, MoreHorizontal } from 'lucide-react'
import type { FilterChip, SummaryTile } from './catalog-patterns'
import { SearchInput } from './filter-controls'

export const PortalPagePatterns = createContext(false)

/** `compact` tightens the header for pages whose controls sit directly beneath it. */
export function PageHeader({ eyebrow, title, description, actions, status, compact = false }: { eyebrow: string; title: string; description?: string; actions?: ReactNode; status?: ReactNode; compact?: boolean }) {
  return <header className={`flex min-w-0 flex-col border-b border-border-default lg:flex-row lg:items-end lg:justify-between ${compact ? 'gap-3 pb-3' : 'gap-4 pb-6'}`}>
    <div className="min-w-0 max-w-3xl"><p className="text-label uppercase tracking-widest text-action-primary">{eyebrow}</p><div className={`flex flex-wrap items-center gap-2 ${compact ? 'mt-1' : 'mt-2'}`}><h1 className="break-words text-h1 tracking-tight text-text-strong">{title}</h1>{status}</div>{description && <p className={`text-sm leading-6 text-text-secondary ${compact ? 'mt-0.5' : 'mt-2'}`}>{description}</p>}</div>
    {actions && <div className="flex shrink-0 flex-wrap items-center gap-2">{actions}</div>}
  </header>
}

export function StatCard({ label, value, icon, hint, active, onClick, disabled }: { label: string; value: ReactNode; icon?: ReactNode; hint?: string; active?: boolean; onClick?: () => void; disabled?: boolean }) {
  const id = useId()
  const [dismissed, setDismissed] = useState(false)
  return <div className={`relative min-w-0 rounded-xl border bg-surface-primary p-4 ${active ? 'border-action-primary ring-1 ring-action-primary' : 'border-border-default'}`}>
    {onClick && <button type="button" aria-label={`Filter: ${label}`} aria-pressed={Boolean(active)} disabled={disabled} onClick={onClick} className="absolute inset-0 rounded-xl focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring disabled:cursor-wait" />}
    <dt className="flex items-center justify-between gap-2 text-[13px] font-medium text-text-secondary"><span>{label}</span><span className="flex items-center gap-2">{icon}{hint && <span className="group relative z-10"><button type="button" aria-label={`About ${label}`} aria-describedby={dismissed ? undefined : id} onFocus={() => setDismissed(false)} onMouseEnter={() => setDismissed(false)} onKeyDown={event => { if (event.key === 'Escape') setDismissed(true) }} className="grid min-h-11 min-w-11 place-items-center rounded-control"><Info size={16} aria-hidden="true" /></button>{!dismissed && <span id={id} role="tooltip" className="absolute right-0 top-full z-20 hidden w-56 max-w-[75vw] rounded-control border border-border-default bg-surface-primary p-2 text-[13px] font-normal leading-5 text-text-strong shadow-md group-hover:block group-focus-within:block">{hint}</span>}</span>}</span></dt>
    <dd className="mt-2 break-words text-[28px] font-semibold leading-tight tabular-nums text-text-strong">{value}</dd>
  </div>
}

export function StatCards({ label, tiles }: { label: string; tiles: SummaryTile[] }) {
  return <dl aria-label={label} className="grid grid-cols-1 gap-4 min-[420px]:grid-cols-2 xl:grid-cols-4">{tiles.map(tile => <StatCard key={tile.key} label={tile.label} value={tile.value} hint={tile.hint} />)}</dl>
}

/** Arrow keys, Home and End activate and focus the corresponding tab. */
export function FilterTabs({ label, chips, value, onChange, disabled = false, appearance = 'chips' }: { label: string; chips: FilterChip[]; value: string; onChange: (value: string) => void; disabled?: boolean; appearance?: 'chips' | 'tabs' }) {
  return <div role="tablist" aria-label={label} className={`flex min-w-0 flex-wrap gap-2 ${appearance === 'tabs' ? 'border-b border-border-default' : ''}`}>
    {chips.map((chip, index) => <button key={chip.value} type="button" role="tab" aria-selected={chip.value === value} tabIndex={chip.value === value || (!chips.some(item => item.value === value) && index === 0) ? 0 : -1} disabled={disabled} onClick={() => onChange(chip.value)} onKeyDown={event => {
      const next = event.key === 'ArrowRight' ? (index + 1) % chips.length : event.key === 'ArrowLeft' ? (index - 1 + chips.length) % chips.length : event.key === 'Home' ? 0 : event.key === 'End' ? chips.length - 1 : null
      if (next === null) return
      event.preventDefault()
      const buttons = event.currentTarget.parentElement?.querySelectorAll<HTMLButtonElement>('[role="tab"]')
      buttons?.[next]?.focus()
      const nextChip = chips[next]
      if (nextChip) onChange(nextChip.value)
    }} className={`inline-flex min-h-11 items-center gap-2 px-4 text-sm font-semibold focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring disabled:opacity-60 ${appearance === 'tabs' ? `border-b-2 ${chip.value === value ? 'border-action-primary text-action-primary' : 'border-transparent text-text-secondary hover:bg-surface-primary'}` : `rounded-full border ${chip.value === value ? 'border-action-primary bg-action-primary text-white' : 'border-border-default bg-surface-primary text-text-strong hover:bg-surface-canvas'}`}`}>
      {chip.icon}{chip.label}{chip.count !== undefined && <span className={`rounded-full px-2 text-[13px] tabular-nums ${chip.value === value && appearance !== 'tabs' ? 'bg-black/10' : 'bg-surface-canvas'}`}>{chip.count}</span>}
    </button>)}
  </div>
}

export function Toolbar({ filters, search, viewToggle, searchFirst = false, alignEnd = false }: { searchFirst?: boolean; alignEnd?: boolean; filters?: ReactNode; search?: { label: string; placeholder: string; value: string; onChange: (value: string) => void; onSubmit: FormEventHandler<HTMLFormElement>; maxLength?: number; disabled?: boolean }; viewToggle?: ReactNode }) {
  const searchField = search && <form role="search" aria-label={search.label} onSubmit={search.onSubmit} className="min-w-0 flex-1 xl:min-w-48 xl:max-w-sm"><SearchInput label={search.label} placeholder={search.placeholder} value={search.value} onChange={search.onChange} maxLength={search.maxLength} disabled={search.disabled} /></form>
  return <div className={`flex min-w-0 flex-col gap-4 rounded-xl border border-border-default bg-surface-primary p-4 xl:flex-row ${alignEnd ? 'xl:items-end' : 'xl:items-center'}`}>
    {searchFirst && searchField}
    {filters && <div className="flex min-w-0 flex-wrap items-center gap-2 [&>select]:w-auto [&>select]:max-w-full [&>select]:min-h-12 sm:[&>select]:min-h-11">{filters}</div>}
    {!searchFirst && <div className="flex min-w-0 flex-1 xl:justify-end">{searchField}</div>}
    {viewToggle && <div className="flex shrink-0 items-center gap-2 xl:ml-auto">{viewToggle}</div>}
  </div>
}

/** One row for a section switcher and the controls that act on it: dates, filters and exports wrap beneath the tabs on narrow screens. */
export function ControlBar({ tabs, actions }: { tabs: ReactNode; actions?: ReactNode }) {
  return <div className="flex min-w-0 flex-wrap items-center justify-between gap-x-4 gap-y-2">
    {tabs}
    {actions && <div className="flex min-w-0 flex-wrap items-center gap-2">{actions}</div>}
  </div>
}

export function InfoNote({ children, dismissible = false }: { children: ReactNode; dismissible?: boolean }) {
  const [dismissed, setDismissed] = useState(false)
  if (dismissed) return null
  return <aside aria-label="Information" className="flex items-start gap-2 rounded-xl border border-border-default bg-surface-primary px-4 py-2 text-[13px] leading-5 text-text-secondary"><Info size={16} aria-hidden="true" className="mt-0.5 shrink-0 text-action-primary" /><div className="min-w-0 flex-1">{children}</div>{dismissible && <button type="button" aria-label="Dismiss information" onClick={() => setDismissed(true)} className="-my-2 grid min-h-11 min-w-11 shrink-0 place-items-center rounded-control"><X size={16} aria-hidden="true" /></button>}</aside>
}

export function EmptyState({ icon, message, action }: { icon?: ReactNode; message: string; action?: ReactNode }) {
  return <div className={`grid justify-items-center gap-4 rounded-xl border border-dashed border-border-default bg-surface-primary px-6 text-center ${icon === false ? 'py-10' : 'py-8'}`}>{icon !== false && <span className="text-text-secondary">{icon ?? <SearchX size={24} aria-hidden="true" />}</span>}<p className="text-sm text-text-secondary">{message}</p>{action}</div>
}

export function ActiveFilters({ filters, onClear }: { filters: { key: string; label: string; onRemove: () => void }[]; onClear: () => void }) {
  if (!filters.length) return null
  return <div aria-label="Active filters" className="flex flex-wrap items-center gap-2">{filters.map(filter => <button key={filter.key} type="button" onClick={filter.onRemove} aria-label={`Remove ${filter.label} filter`} className="inline-flex min-h-11 items-center gap-2 rounded-full border border-border-default bg-surface-primary px-3 text-[13px] text-text-strong">{filter.label}<X size={14} aria-hidden="true" /></button>)}<button type="button" onClick={onClear} className="min-h-11 px-2 text-sm font-semibold text-action-primary underline underline-offset-4">Clear all</button></div>
}

export function RowActionMenu({ label, children }: { label: string; children: ReactNode }) {
  return <details className="relative" onKeyDown={event => { if (event.key === 'Escape') { event.currentTarget.open = false; event.currentTarget.querySelector('summary')?.focus() } }}>
    <summary aria-label={label} className="grid min-h-11 min-w-11 cursor-pointer list-none place-items-center rounded-control [&::-webkit-details-marker]:hidden"><MoreHorizontal size={20} aria-hidden="true" /></summary>
    <div className="relative z-30 grid min-w-44 gap-2 rounded-xl border border-border-default bg-surface-primary p-2 shadow-sm" onClick={event => { if (!(event.target instanceof Element) || !event.target.closest('button')) return; const details = event.currentTarget.closest('details'); if (details) { details.open = false; details.querySelector('summary')?.focus() } }}>{children}</div>
  </details>
}
