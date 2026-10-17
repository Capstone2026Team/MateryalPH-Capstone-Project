import { forwardRef, useId, type InputHTMLAttributes, type ReactNode, type SelectHTMLAttributes } from 'react'
import { ChevronDown, Search, X } from 'lucide-react'
import { Button } from './button'

export function FilterPanel({ label, children, footer, actions }: { label: string; children: ReactNode; footer?: ReactNode; actions?: ReactNode }) {
  return <section aria-label={label} className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-6">
    <div className="grid min-w-0 grid-cols-1 items-end gap-x-4 gap-y-5 sm:grid-cols-[repeat(auto-fit,minmax(min(100%,17rem),1fr))]">{children}</div>
    {(footer || actions) && <div className="mt-5 flex min-w-0 flex-col gap-4 border-t border-border-default pt-5 sm:flex-row sm:flex-wrap sm:items-end sm:justify-between">
      {footer && <div className="min-w-0 max-w-full">{footer}</div>}
      {actions && <div className="flex flex-col gap-3 sm:flex-row sm:flex-wrap sm:items-center">{actions}</div>}
    </div>}
  </section>
}

export const SearchInput = forwardRef<HTMLInputElement, Omit<InputHTMLAttributes<HTMLInputElement>, 'onChange' | 'value'> & {
  label: string; value: string; onChange: (value: string) => void
}>(({ label, value, onChange, className = '', id, disabled, type = 'search', ...props }, ref) => {
  const generatedId = useId()
  return <div className={`relative min-w-0 ${className}`}>
    <label className="sr-only" htmlFor={id ?? generatedId}>{label}</label>
    <Search size={18} aria-hidden="true" className="pointer-events-none absolute left-3 top-1/2 -translate-y-1/2 text-text-secondary" />
    <input {...props} ref={ref} id={id ?? generatedId} type={type} value={value} disabled={disabled} onChange={event => onChange(event.target.value)} className="portal-search-input min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary py-2 pl-10 pr-12 text-base text-text-strong placeholder:text-text-secondary sm:min-h-11 sm:text-sm disabled:cursor-not-allowed disabled:opacity-60" />
    {value && <button type="button" aria-label={`Clear ${label.toLowerCase()}`} disabled={disabled} onClick={() => { onChange(''); document.getElementById(id ?? generatedId)?.focus() }} className="absolute inset-y-0 right-0 grid min-w-11 place-items-center rounded-control text-text-secondary hover:text-text-strong focus-visible:outline-2 focus-visible:outline-focus-ring"><X size={16} aria-hidden="true" /></button>}
  </div>
})
SearchInput.displayName = 'SearchInput'

export const Select = forwardRef<HTMLSelectElement, SelectHTMLAttributes<HTMLSelectElement> & { label: string; hideLabel?: boolean; error?: string }>(({ label, hideLabel = false, error, id, className = '', children, ...props }, ref) => {
  const generatedId = useId()
  const fieldId = id ?? generatedId
  return <div className={`grid min-w-0 gap-2 ${className}`}>
    <label htmlFor={fieldId} className={hideLabel ? 'sr-only' : 'text-sm font-semibold text-text-strong'}>{label}</label>
    <div className="relative"><select {...props} ref={ref} id={fieldId} aria-invalid={Boolean(error)} aria-describedby={error ? `${fieldId}-error` : props['aria-describedby']} className={`min-h-12 w-full min-w-0 appearance-none rounded-control border bg-surface-primary py-2 pl-3 pr-10 text-base text-text-strong sm:min-h-11 sm:text-sm disabled:cursor-not-allowed disabled:opacity-60 ${error ? 'border-status-error' : 'border-border-default'}`}>{children}</select><ChevronDown size={16} aria-hidden="true" className="pointer-events-none absolute right-3 top-1/2 -translate-y-1/2 text-text-secondary" /></div>
    {error && <p id={`${fieldId}-error`} role="alert" className="text-sm text-status-error">{error}</p>}
  </div>
})
Select.displayName = 'Select'

export function Pagination({ page, lastPage, hasMore, busy = false, total, onChange }: {
  page: number; lastPage?: number; hasMore?: boolean; busy?: boolean; total?: number; onChange: (page: number) => void
}) {
  return <nav aria-label="Pagination" className="flex min-w-0 flex-wrap items-center justify-between gap-3 border-t border-border-default pt-4 text-sm">
    <p aria-live="polite" className="text-text-secondary tabular-nums">Page {page}{lastPage !== undefined ? ` of ${Math.max(1, lastPage)}` : ''}{total !== undefined ? ` · ${total.toLocaleString('en-PH')} records` : ''}</p>
    <div className="flex items-center gap-2"><Button variant="secondary" disabled={busy || page <= 1} onClick={() => onChange(page - 1)}>Previous</Button><Button variant="secondary" disabled={busy || (lastPage !== undefined ? page >= lastPage : !hasMore)} onClick={() => onChange(page + 1)}>Next</Button></div>
  </nav>
}

export function DataTable({ caption, headers, children, minWidth = '46rem' }: { caption: string; headers: ReactNode[]; children: ReactNode; minWidth?: string }) {
  return <div role="region" aria-label={caption} tabIndex={0} className="min-w-0 max-w-full overflow-x-auto rounded-surface border border-border-default bg-surface-primary"><table style={{ minWidth }} className="w-full border-collapse text-left text-sm"><caption className="sr-only">{caption}</caption><thead><tr>{headers.map((header, index) => <th key={index} scope="col">{header}</th>)}</tr></thead><tbody>{children}</tbody></table></div>
}
