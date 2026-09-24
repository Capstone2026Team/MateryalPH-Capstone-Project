import { useEffect, useId, useRef, useState } from 'react'
import { Button } from './button'

export type ComboboxOption = { code: string; name: string; level?: string }
export function SearchableCombobox({ label, value, disabled = false, load, onChange }: {
  label: string; value: ComboboxOption | null; disabled?: boolean;
  load: (query: string, page: number) => Promise<{ items: ComboboxOption[]; hasMore: boolean }>;
  onChange: (value: ComboboxOption | null) => void;
}) {
  const id = useId()
  const [query, setQuery] = useState(value?.name ?? '')
  const [open, setOpen] = useState(false)
  const [options, setOptions] = useState<ComboboxOption[]>([])
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [page, setPage] = useState(1)
  const [more, setMore] = useState(false)
  const [active, setActive] = useState(-1)
  const [retry, setRetry] = useState(0)
  const loadRef = useRef(load)
  loadRef.current = load
  useEffect(() => { if (value) setQuery(value.name) }, [value])
  useEffect(() => {
    if (!open || disabled) return
    let current = true
    setBusy(true); setError(''); setActive(-1)
    const timer = window.setTimeout(() => {
      void loadRef.current(value ? '' : query, page).then(result => {
        if (current) { setOptions(previous => page === 1 ? result.items : [...previous, ...result.items]); setMore(result.hasMore); setBusy(false) }
      }).catch(() => { if (current) { setError('Locations could not be loaded. Please retry.'); setOptions([]); setBusy(false) } })
    }, 200)
    return () => { current = false; window.clearTimeout(timer) }
  }, [open, disabled, query, value, page, retry])
  function select(option: ComboboxOption) { onChange(option); setQuery(option.name); setOpen(false); setActive(-1) }
  return <div className="relative grid min-w-0 content-start gap-2" onBlur={event => { if (!event.currentTarget.contains(event.relatedTarget)) setOpen(false) }}>
    <label htmlFor={id} className="text-sm font-semibold">{label} <span aria-hidden="true">*</span></label>
    <div className="flex gap-2">
      <input id={id} role="combobox" aria-autocomplete="list" aria-expanded={open} aria-controls={`${id}-options`} aria-activedescendant={active >= 0 ? `${id}-${active}` : undefined} aria-required="true" aria-invalid={!value && Boolean(query)} aria-describedby={`${id}-help`} autoComplete="off" disabled={disabled} value={query} placeholder={`Search or select ${label.toLowerCase()}…`} className="min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3" onFocus={() => { setOpen(true); setPage(1) }} onChange={event => { onChange(null); setQuery(event.target.value); setPage(1); setOpen(true); setOptions([]) }} onKeyDown={event => {
        if (event.key === 'Escape') setOpen(false)
        if (event.key === 'ArrowDown' || event.key === 'ArrowUp') { event.preventDefault(); setOpen(true); setActive(index => Math.max(0, Math.min(options.length - 1, index + (event.key === 'ArrowDown' ? 1 : -1)))) }
        if (event.key === 'Enter' && open) { event.preventDefault(); if (options[active]) select(options[active]) }
      }} />
      {(value || query) && <Button variant="quiet" aria-label={`Clear ${label}`} onClick={() => { onChange(null); setQuery(''); setPage(1); setOpen(true) }}>Clear</Button>}
    </div>
    <p id={`${id}-help`} className="text-sm text-text-secondary">{disabled ? 'Select the preceding address field first.' : !value && query ? 'Select a matching official location from the suggestions.' : value?.level === 'REGION' ? 'Region grouping for locations without a province parent.' : 'Select an official PSGC location.'}</p>
    {open && !disabled && <div className="absolute inset-x-0 top-full z-50 mt-1 rounded-control border border-border-default bg-surface-primary p-2 shadow-sm">
      <ul id={`${id}-options`} role="listbox" aria-label={`${label} suggestions`} className="max-h-64 overflow-y-auto">
        {options.map((option, index) => <li id={`${id}-${index}`} key={option.code} role="option" aria-selected={value?.code === option.code} className={`min-h-11 cursor-pointer px-3 py-3 ${index === active ? 'bg-surface-canvas' : ''}`} onMouseDown={event => event.preventDefault()} onClick={() => select(option)}>{option.name}{option.level === 'REGION' ? ' (no province)' : ''}</li>)}
      </ul>
      {busy && <p role="status">Loading locations…</p>}
      {error && <div role="alert">{error}<Button variant="secondary" onClick={() => setRetry(value => value + 1)}>Retry locations</Button></div>}
      {!busy && !error && options.length === 0 && <p role="status">No matching official locations.</p>}
      {more && !busy && <Button variant="quiet" onClick={() => setPage(value => value + 1)}>Load more locations</Button>}
    </div>}
  </div>
}
