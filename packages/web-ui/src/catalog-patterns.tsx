import { useId, useRef, useState, type ReactNode } from 'react'
import { AlertCircle, ImagePlus, Plus, RefreshCw, Trash2 } from 'lucide-react'
import { Button } from './button'
import { StatusBadge } from './portal-shell'

export type RecordColumn<T> = { key: string; header: string; cell: (row: T) => ReactNode; className?: string }

/**
 * A filterable record list: a dense table at 1024px and above and labelled
 * cards below, rendered from one column definition so both views stay in sync.
 * Wide tables scroll inside their own container, never the page.
 */
export function ResponsiveRecordList<T>({ caption, rows, columns, rowKey, cardTitle, cardAction }: {
  caption: string; rows: T[]; columns: RecordColumn<T>[]; rowKey: (row: T) => string
  cardTitle: (row: T) => ReactNode; cardAction?: (row: T) => ReactNode
}) {
  return <>
    <div className="hidden overflow-x-auto rounded-surface border border-border-default bg-surface-primary lg:block">
      <table className="w-full min-w-[960px] text-left text-sm">
        <caption className="sr-only">{caption}</caption>
        <thead className="border-b border-border-default bg-surface-canvas"><tr>{columns.map(column => <th key={column.key} scope="col" className="px-4 py-3 font-semibold text-text-strong">{column.header}</th>)}</tr></thead>
        <tbody>{rows.map(row => <tr key={rowKey(row)} className="border-t border-border-default align-top">{columns.map(column => <td key={column.key} className={`px-4 py-3 ${column.className ?? ''}`}>{column.cell(row)}</td>)}</tr>)}</tbody>
      </table>
    </div>
    <ul className="grid gap-3 lg:hidden" aria-label={caption}>
      {rows.map(row => <li key={rowKey(row)} className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-4">
        <div className="min-w-0 break-words font-semibold">{cardTitle(row)}</div>
        <dl className="mt-3 grid gap-x-4 gap-y-2 text-sm min-[420px]:grid-cols-2">{columns.slice(1).map(column => <div key={column.key} className="min-w-0"><dt className="text-xs text-text-secondary">{column.header}</dt><dd className="mt-0.5 break-words">{column.cell(row)}</dd></div>)}</dl>
        {cardAction && <div className="mt-3 border-t border-border-default pt-3">{cardAction(row)}</div>}
      </li>)}
    </ul>
  </>
}

/**
 * Repeatable row group with per-row validation. Rows are edited inline in a
 * labelled fieldset; errors are listed at the top of their own row and never
 * open a modal.
 */
export function RowGroup<T>({ legend, rows, rowLabel, renderRow, errorsFor, onAdd, onRemove, addLabel, maxRows, disabled = false }: {
  legend: string; rows: T[]; rowLabel: (row: T, index: number) => string; renderRow: (row: T, index: number) => ReactNode
  errorsFor: (index: number) => string[]; onAdd: () => void; onRemove: (index: number) => void; addLabel: string; maxRows: number; disabled?: boolean
}) {
  return <fieldset className="min-w-0 space-y-4">
    <legend className="text-lg font-semibold">{legend}</legend>
    {rows.map((row, index) => {
      const errors = errorsFor(index)
      const headingId = `row-group-${index}`
      return <section key={index} aria-labelledby={headingId} className={`min-w-0 rounded-surface border p-4 ${errors.length ? 'border-status-error' : 'border-border-default'}`}>
        <div className="flex flex-wrap items-center justify-between gap-2">
          <h4 id={headingId} className="font-semibold">{rowLabel(row, index)}</h4>
          <Button variant="quiet" disabled={disabled || rows.length <= 1} onClick={() => onRemove(index)} aria-label={`Remove ${rowLabel(row, index)}`}><Trash2 size={16} aria-hidden="true" /> Remove</Button>
        </div>
        {errors.length > 0 && <ul className="mt-3 grid gap-1 rounded-control border border-status-error/30 bg-red-50 p-3 text-sm text-red-900" role="alert">{errors.map(error => <li key={error} className="flex gap-2"><AlertCircle size={16} className="mt-0.5 shrink-0" aria-hidden="true" />{error}</li>)}</ul>}
        <div className="mt-4 min-w-0">{renderRow(row, index)}</div>
      </section>
    })}
    <Button variant="secondary" disabled={disabled || rows.length >= maxRows} onClick={onAdd}><Plus size={16} aria-hidden="true" /> {addLabel}</Button>
    {rows.length >= maxRows && <p className="text-sm text-text-secondary">The maximum of {maxRows} rows is reached.</p>}
  </fieldset>
}

export type MediaItem = { id: string; label: string; status: string; version: number; scanState: string; contentType: string; byteSize: number; previewUrl?: string | null }

const formatBytes = (bytes: number) => bytes >= 1_048_576 ? `${(bytes / 1_048_576).toFixed(1)} MB` : `${Math.max(1, Math.round(bytes / 1024))} KB`

/**
 * Photo slots: the first ready photo is the main listing image, then one open slot
 * while the limit allows. Replaced and removed versions stay listed as history.
 * The client pre-check only helps the user; the server remains the authority on
 * content, safety and size.
 */
export function MediaUploadField({ label, accept, acceptedLabel, maxBytes, items, busy, error, onUpload, onReplace, onRemove, maxItems }: {
  label: string; accept: string[]; acceptedLabel: string; maxBytes: number; items: MediaItem[]; busy: boolean; error?: string | null
  onUpload: (file: File) => void; onReplace: (id: string, file: File) => void; onRemove: (id: string) => void; maxItems: number
}) {
  const inputId = useId()
  const hintId = `${inputId}-hint`
  const input = useRef<HTMLInputElement>(null)
  const [replacing, setReplacing] = useState<string | null>(null)
  const [localError, setLocalError] = useState<string | null>(null)
  const ready = items.filter(item => item.status === 'READY')
  const history = items.filter(item => item.status !== 'READY')
  function choose(file: File | undefined) {
    if (!file) return
    setLocalError(null)
    if (!accept.includes(file.type)) setLocalError(`${file.name} is not an accepted type. Use ${acceptedLabel}.`)
    else if (file.size > maxBytes) setLocalError(`${file.name} is ${formatBytes(file.size)}. The limit is ${formatBytes(maxBytes)}.`)
    else if (replacing) onReplace(replacing, file)
    else onUpload(file)
    setReplacing(null)
    if (input.current) input.current.value = ''
  }
  const shownError = localError ?? error
  const canAdd = maxItems > 0 && ready.length < maxItems
  return <div className="grid min-w-0 gap-3">
    <div>
      <label htmlFor={inputId} className="text-sm font-semibold">{label}</label>
      <p id={hintId} className="mt-1 text-sm text-text-secondary">Accepted: {acceptedLabel}. Up to {formatBytes(maxBytes)} each, {maxItems} photos. The first photo is the main listing image. Every file is checked for malware before it is used.</p>
      <input ref={input} id={inputId} className="sr-only" type="file" accept={accept.join(',')} aria-describedby={shownError ? `${inputId}-error` : hintId} disabled={busy || (!canAdd && !replacing)} onChange={event => choose(event.target.files?.[0])} />
    </div>
    {shownError && <p id={`${inputId}-error`} className="text-sm text-status-error" role="alert">{shownError}</p>}
    <ul className="grid grid-cols-1 gap-3 min-[420px]:grid-cols-2 md:grid-cols-3 xl:grid-cols-5" aria-label={`${label}: ${ready.length} of ${maxItems}`}>
      {ready.map((item, index) => <li key={item.id} className="min-w-0 overflow-hidden rounded-surface border border-border-default bg-surface-primary">
        <div className="relative grid aspect-square place-items-center bg-surface-canvas">
          {item.previewUrl ? <img src={item.previewUrl} alt={item.label} className="h-full w-full object-cover" /> : <ImagePlus className="text-text-secondary" aria-hidden="true" />}
          {index === 0 && <span className="absolute left-2 top-2 rounded-pill bg-action-primary px-2 py-0.5 text-xs font-semibold text-white">Main photo</span>}
        </div>
        <div className="grid gap-1 p-2">
          <p className="truncate text-xs text-text-secondary" title={`Version ${item.version} · ${item.contentType} · ${formatBytes(item.byteSize)}`}>{item.scanState === 'CLEAN' ? 'Safety check passed' : `Scan: ${item.scanState}`} · {formatBytes(item.byteSize)}</p>
          <div className="flex flex-wrap gap-1"><Button variant="quiet" disabled={busy} onClick={() => { setReplacing(item.id); input.current?.click() }} aria-label={`Replace ${index === 0 ? 'main photo' : `photo ${index + 1}`}`}><RefreshCw size={16} aria-hidden="true" /> Replace</Button><Button variant="quiet" disabled={busy} onClick={() => onRemove(item.id)} aria-label={`Remove ${index === 0 ? 'main photo' : `photo ${index + 1}`}`}><Trash2 size={16} aria-hidden="true" /> Remove</Button></div>
        </div>
      </li>)}
      {canAdd && <li className="min-w-0"><button type="button" disabled={busy} onClick={() => { setReplacing(null); input.current?.click() }} className="grid aspect-square w-full place-items-center rounded-surface border-2 border-dashed border-border-default bg-surface-canvas p-3 text-center text-sm font-semibold text-text-strong transition-colors hover:border-action-primary hover:bg-brand-orange-50 disabled:opacity-60 motion-reduce:transition-none">
        <span className="grid justify-items-center gap-2"><ImagePlus size={24} className="text-action-primary" aria-hidden="true" />{busy ? 'Uploading…' : ready.length === 0 ? 'Add main photo' : `Add photo ${ready.length + 1}`}</span>
      </button></li>}
    </ul>
    {ready.length === 0 && <p className="text-sm text-text-secondary">No photos yet. Upload at least one clear product photo.</p>}
    {history.length > 0 && <details className="text-sm"><summary className="min-h-11 cursor-pointer py-2 font-semibold">Earlier photo versions ({history.length})</summary>
      <ul className="grid gap-1 text-text-secondary">{history.map(item => <li key={item.id} className="flex flex-wrap items-center gap-2"><StatusBadge label={item.status === 'REPLACED' ? 'Replaced' : 'Removed'} tone="neutral" />Version {item.version} · {formatBytes(item.byteSize)}</li>)}</ul>
    </details>}
  </div>
}

export type SummaryTile = { key: string; label: string; value: number | string; hint: string; tone?: 'neutral' | 'success' | 'warning' | 'error' | 'info' }

const tileAccent = { neutral: 'border-t-border-default', success: 'border-t-status-success', warning: 'border-t-status-warning', error: 'border-t-status-error', info: 'border-t-status-info' }

/** Compact counts above a record list. Tone is an accent only; each tile names its meaning in text. */
export function SummaryTiles({ label, tiles }: { label: string; tiles: SummaryTile[] }) {
  return <dl aria-label={label} className="grid grid-cols-1 gap-3 min-[420px]:grid-cols-2 lg:grid-cols-3 xl:grid-cols-5">
    {tiles.map(tile => <div key={tile.key} className={`min-w-0 rounded-surface border border-t-4 border-border-default bg-surface-primary px-4 py-3 ${tileAccent[tile.tone ?? 'neutral']}`}>
      <dt className="text-xs font-semibold uppercase tracking-wide text-text-secondary">{tile.label}</dt>
      <dd className="mt-1 text-2xl font-semibold tabular-nums text-text-strong">{tile.value}</dd>
      <dd className="text-xs text-text-secondary">{tile.hint}</dd>
    </div>)}
  </dl>
}

export type FilterChip = { value: string; label: string; count?: number | undefined; icon?: ReactNode }

/** Single-choice filter or view switch as pressed buttons; counts are part of each accessible name. */
export function FilterChips({ label, chips, value, onChange, disabled = false }: { label: string; chips: FilterChip[]; value: string; onChange: (value: string) => void; disabled?: boolean }) {
  return <div role="group" aria-label={label} className="flex min-w-0 flex-wrap gap-2">
    {chips.map(chip => {
      const pressed = chip.value === value
      return <button key={chip.value} type="button" aria-pressed={pressed} disabled={disabled} onClick={() => onChange(chip.value)} className={`inline-flex min-h-11 items-center gap-2 rounded-pill border px-4 text-sm font-semibold transition-colors motion-reduce:transition-none disabled:opacity-60 ${pressed ? 'border-action-primary bg-action-primary text-white' : 'border-border-default bg-surface-primary text-text-strong hover:bg-surface-canvas'}`}>
        {chip.icon}{chip.label}{chip.count !== undefined && <span className={`rounded-pill px-1.5 text-xs tabular-nums ${pressed ? 'bg-white/20' : 'bg-surface-canvas'}`}>{chip.count}</span>}
      </button>
    })}
  </div>
}
export type RowErrorRecord = { rowNumber: number; identifier: string; errors: Record<string, string[]> }

/** Spreadsheet row errors with a jump link to every rejected row. */
export function RowErrorTable({ caption, rows }: { caption: string; rows: RowErrorRecord[] }) {
  if (rows.length === 0) return null
  return <section aria-labelledby="row-error-heading" className="grid min-w-0 gap-3">
    <h3 id="row-error-heading" className="text-lg font-semibold">{caption}</h3>
    <nav aria-label="Jump to a rejected row"><ul className="flex flex-wrap gap-2">{rows.map(row => <li key={row.rowNumber}><a className="inline-flex min-h-11 items-center rounded-control border border-border-default px-3 text-sm font-semibold text-action-primary underline" href={`#import-row-${row.rowNumber}`}>Row {row.rowNumber}</a></li>)}</ul></nav>
    <div className="overflow-x-auto rounded-surface border border-border-default">
      <table className="w-full min-w-[640px] text-left text-sm">
        <caption className="sr-only">{caption}</caption>
        <thead className="bg-surface-canvas"><tr><th scope="col" className="px-4 py-3">Row</th><th scope="col" className="px-4 py-3">Listing / variant</th><th scope="col" className="px-4 py-3">Problems</th></tr></thead>
        <tbody>{rows.map(row => <tr key={row.rowNumber} id={`import-row-${row.rowNumber}`} tabIndex={-1} className="border-t border-border-default align-top target:bg-red-50 focus:outline-2 focus:outline-focus-ring">
          <th scope="row" className="px-4 py-3 font-semibold">Row {row.rowNumber}</th>
          <td className="px-4 py-3 break-words">{row.identifier || '—'}</td>
          <td className="px-4 py-3"><ul className="grid gap-1">{Object.entries(row.errors).flatMap(([field, messages]) => messages.map(message => <li key={field + message}><span className="font-semibold">{field.replaceAll('_', ' ')}:</span> {message}</li>))}</ul></td>
        </tr>)}</tbody>
      </table>
    </div>
  </section>
}

/**
 * The Phase 3E review arrangement: requirements navigation, information with
 * its evidence, and the decision area. Three regions at wide desktop, two at
 * tablet width and a single reading-order stack on narrow screens.
 */
export function ReviewWorkspace({ navigator, information, decision }: { navigator: ReactNode; information: ReactNode; decision: ReactNode }) {
  return <div className="grid min-w-0 items-start gap-5 md:grid-cols-[minmax(13rem,16rem)_minmax(0,1fr)] 2xl:grid-cols-[minmax(13rem,16rem)_minmax(0,1fr)_minmax(20rem,26rem)]">
    <nav aria-label="Review sections" className="min-w-0 md:sticky md:top-4">{navigator}</nav>
    <div className="min-w-0">{information}</div>
    <div className="min-w-0 md:col-start-2 2xl:col-start-auto">{decision}</div>
  </div>
}
