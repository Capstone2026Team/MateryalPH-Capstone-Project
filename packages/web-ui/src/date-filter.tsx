import { RangeCalendar } from './range-calendar'
import { useId, useRef, useState } from 'react'
import { Button } from './button'
import { Field } from './field'

function CalendarDays() {
  return <svg width="18" height="18" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round" className="shrink-0 text-action-primary" aria-hidden="true"><rect x="3" y="5" width="18" height="16" rx="2" /><path d="M16 3v4M8 3v4M3 11h18" /></svg>
}

export type DateFilterRange = { label: string; from: string; to: string }
function dateFilterPreset(days: number, yesterday = false, now = new Date()): DateFilterRange {
  const today = new Intl.DateTimeFormat('en-CA', { timeZone: 'Asia/Manila', year: 'numeric', month: '2-digit', day: '2-digit' }).format(now)
  const end = new Date(`${today}T00:00:00Z`)
  if (yesterday) end.setUTCDate(end.getUTCDate() - 1)
  const start = new Date(end); start.setUTCDate(start.getUTCDate() - days + 1)
  return { label: yesterday ? 'Yesterday' : days === 1 ? 'Today' : `Last ${days} days`, from: start.toISOString().slice(0, 10), to: end.toISOString().slice(0, 10) }
}

export const ALL_DATES: DateFilterRange = { label: 'All dates', from: '', to: '' }

export function DateFilter({ value = ALL_DATES, onChange, title = 'Date range' }: { value?: DateFilterRange; onChange: (value: DateFilterRange) => void; title?: string }) {
  const titleId = useId()
  const dialog = useRef<HTMLDialogElement>(null)
  const [draft, setDraft] = useState(value)
  const [selectingEnd, setSelectingEnd] = useState(false)
  return <><Button variant="secondary" aria-haspopup="dialog" className="rounded-full hover:bg-brand-orange-50" onClick={() => { setDraft(value); setSelectingEnd(false); dialog.current?.showModal() }}><CalendarDays />{value.label}</Button>
    <dialog ref={dialog} className="m-auto w-[min(48rem,calc(100%_-_2rem))] max-w-full max-h-[calc(100dvh_-_2rem)] overflow-y-auto rounded-surface border border-border-default bg-surface-primary p-0 text-text-strong backdrop:bg-black/30" aria-labelledby={titleId}>
      <form onSubmit={event => { event.preventDefault(); onChange(draft); dialog.current?.close() }}>
        <header className="border-b border-border-default p-5"><h2 id={titleId} className="text-xl font-semibold">{title}</h2><p className="mt-1 text-sm text-text-secondary">Inclusive calendar dates in Asia/Manila.</p></header>
        <div className="grid gap-6 p-5 sm:grid-cols-[10rem_1fr]"><div className="grid content-start gap-1" aria-label="Date presets">{[0, 1, -1, 7, 30, 60, 90, 365].map(days => { const preset = days === 0 ? { label: 'All dates', from: '', to: '' } : dateFilterPreset(Math.abs(days), days === -1); return <Button variant={draft.label === preset.label ? 'primary' : 'quiet'} key={days} aria-pressed={draft.label === preset.label} onClick={() => { setDraft(preset); setSelectingEnd(false) }}>{preset.label}</Button> })}</div><div className="grid content-start gap-5"><RangeCalendar from={draft.from} to={draft.to} onSelect={date => { if (!selectingEnd) { setDraft({ label: 'Custom range', from: date, to: '' }); setSelectingEnd(true) } else { setDraft({ label: 'Custom range', from: date < draft.from ? date : draft.from, to: date < draft.from ? draft.from : date }); setSelectingEnd(false) } }} /><Field label="From" id={`${titleId}-from`} name="range_from" type="date" value={draft.from} max={draft.to || undefined} onChange={event => setDraft({ ...draft, label: 'Custom range', from: event.target.value })} /><Field label="To" id={`${titleId}-to`} name="range_to" type="date" value={draft.to} min={draft.from || undefined} onChange={event => setDraft({ ...draft, label: 'Custom range', to: event.target.value })} /><p className="text-sm text-text-secondary">Choose a preset or use the calendar controls. Leave a boundary empty for an open-ended range.</p></div></div>
        <footer className="flex justify-end gap-3 border-t border-border-default p-5"><Button variant="quiet" onClick={() => dialog.current?.close()}>Cancel</Button><Button type="submit">Apply</Button></footer>
      </form>
    </dialog></>
}
