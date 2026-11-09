import { DataTable, Pagination } from '@materyalph/web-ui'
import { useId, type ReactNode } from 'react'
import type { PagedState } from '../lib/operations-hooks'
import { ErrorState, LoadingState } from '../pages/PhaseThreeAdminPages'

export function Pager({ page, lastPage, busy, onChange, total }: { page: number; lastPage: number; busy?: boolean; onChange: (page: number) => void; total?: number | undefined }) {
  return <Pagination page={page} lastPage={lastPage} busy={busy ?? false} {...(total !== undefined ? { total } : {})} onChange={onChange} />
}

export function Panel({ title, description, actions, children, id, compact = false }: { title: string; description?: string; actions?: ReactNode; children: ReactNode; id?: string; compact?: boolean }) {
  const generatedId = useId()
  const headingId = id ?? generatedId
  return <section aria-labelledby={headingId} className={`grid min-w-0 mp-card ${compact ? 'gap-2 p-3' : 'gap-4 mp-card-padded'}`}>
    <div className="flex flex-wrap items-start justify-between gap-3"><div className="min-w-0"><h2 id={headingId} className="mp-card-heading">{title}</h2>{description && <p className="mt-1 text-xs leading-5 text-text-secondary">{description}</p>}</div>{actions && <div className="flex flex-wrap gap-2">{actions}</div>}</div>
    {children}
  </section>
}

export function Paged<T>({ state, empty, children, embedded = false, showTotal = true, loading }: { state: PagedState<T>; empty: string; children: (items: T[]) => ReactNode; embedded?: boolean; showTotal?: boolean; loading?: ReactNode }) {
  if (state.error) return <ErrorState message={state.error} onRetry={state.reload} />
  if (!state.data) return loading ?? <LoadingState />
  const emptyContent = <p className={`text-center text-sm text-text-secondary ${embedded ? 'px-4 py-6' : 'rounded-surface border border-dashed border-border-default bg-surface-primary p-8'}`}>{empty}</p>
  return <div className="grid gap-4">{state.data.items.length === 0 ? emptyContent : children(state.data.items)}
    {(state.page > 1 || state.data.hasMore) && <Pagination page={state.page} hasMore={state.data.hasMore} {...(showTotal ? { total: state.data.total } : {})} onChange={state.setPage} />}
  </div>
}

export function Table({ caption, headers, children }: { caption: string; headers: string[]; children: ReactNode }) {
  return <DataTable caption={caption} headers={headers}>{children}</DataTable>
}
