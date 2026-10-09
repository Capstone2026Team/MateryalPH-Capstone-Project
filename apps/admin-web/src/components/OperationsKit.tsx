import { Button } from '@materyalph/web-ui'
import type { ReactNode } from 'react'
import type { PagedState } from '../lib/operations-hooks'
import { ErrorState, LoadingState } from '../pages/PhaseThreeAdminPages'

export function Pager({ page, lastPage, busy, onChange, total }: { page: number; lastPage: number; busy?: boolean; onChange: (page: number) => void; total?: number }) {
  return <nav aria-label="Pagination" className="flex flex-wrap items-center gap-3 text-sm">
    <Button variant="secondary" disabled={busy || page <= 1} onClick={() => onChange(page - 1)}>Previous</Button>
    <span className="tabular-nums">Page {page} of {lastPage}{total !== undefined ? ` · ${total.toLocaleString('en-PH')} records` : ''}</span>
    <Button variant="secondary" disabled={busy || page >= lastPage} onClick={() => onChange(page + 1)}>Next</Button>
  </nav>
}

export function Panel({ title, description, actions, children, id }: { title: string; description?: string; actions?: ReactNode; children: ReactNode; id?: string }) {
  return <section aria-labelledby={id ?? title} className="grid min-w-0 gap-4 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
    <div className="flex flex-wrap items-start justify-between gap-3"><div className="min-w-0"><h2 id={id ?? title} className="text-lg font-semibold text-text-strong">{title}</h2>{description && <p className="mt-1 text-sm text-text-secondary">{description}</p>}</div>{actions && <div className="flex flex-wrap gap-2">{actions}</div>}</div>
    {children}
  </section>
}

export function Paged<T>({ state, empty, children }: { state: PagedState<T>; empty: string; children: (items: T[]) => ReactNode }) {
  if (state.error) return <ErrorState message={state.error} onRetry={state.reload} />
  if (!state.data) return <LoadingState />
  if (state.data.items.length === 0) return <p className="rounded-surface border border-dashed border-border-default bg-surface-primary p-8 text-center text-sm text-text-secondary">{empty}</p>
  return <div className="grid gap-4">{children(state.data.items)}
    {(state.page > 1 || state.data.hasMore) && <div className="flex items-center justify-between gap-3"><Button variant="secondary" disabled={state.page === 1} onClick={() => state.setPage(state.page - 1)}>Previous</Button><span className="text-sm text-text-secondary">Page {state.page} · {state.data.total} total</span><Button variant="secondary" disabled={!state.data.hasMore} onClick={() => state.setPage(state.page + 1)}>Next</Button></div>}
  </div>
}

export function Table({ caption, headers, children }: { caption: string; headers: string[]; children: ReactNode }) {
  return <div className="min-w-0 overflow-x-auto rounded-surface border border-border-default bg-surface-primary"><table className="w-full min-w-[46rem] border-collapse text-left text-sm"><caption className="sr-only">{caption}</caption>
    <thead className="bg-surface-canvas text-xs uppercase tracking-wide text-text-secondary"><tr>{headers.map(header => <th key={header} scope="col" className="px-4 py-3 font-semibold">{header}</th>)}</tr></thead>
    <tbody className="divide-y divide-border-default">{children}</tbody></table></div>
}