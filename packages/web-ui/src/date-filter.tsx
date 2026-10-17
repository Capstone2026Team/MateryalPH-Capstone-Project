import { useState } from 'react'
import { CalendarDays } from 'lucide-react'
import { RangeCalendar } from './range-calendar'
import { Button } from './button'
import { Field } from './field'
import { FormDialog } from './form-dialog'
import { isCalendarDate, manilaToday } from './calendar-dates'

export { manilaToday } from './calendar-dates'

export type DateFilterRange = { label: string; from: string; to: string }
export const ALL_DATES: DateFilterRange = { label: 'All dates', from: '', to: '' }

export function dateFilterPreset(days: number, yesterday = false, now = new Date()): DateFilterRange {
  const end = new Date(`${manilaToday(now)}T00:00:00Z`)
  if (yesterday) end.setUTCDate(end.getUTCDate() - 1)
  const start = new Date(end)
  start.setUTCDate(start.getUTCDate() - days + 1)
  return { label: yesterday ? 'Yesterday' : days === 1 ? 'Today' : `Last ${days} days`, from: start.toISOString().slice(0, 10), to: end.toISOString().slice(0, 10) }
}

/** A comparison period measures an endpoint against N days earlier, with both endpoints included. */
export function dateComparisonPreset(days: number, end: string): DateFilterRange {
  const start = new Date(`${end}T00:00:00Z`)
  start.setUTCDate(start.getUTCDate() - days)
  return { label: `${days}-day comparison`, from: start.toISOString().slice(0, 10), to: end }
}

function shortDate(value: string): string {
  if (!isCalendarDate(value)) return value
  const date = new Date(`${value}T00:00:00Z`)
  return Number.isNaN(date.getTime()) ? value : date.toLocaleDateString('en-PH', { day: 'numeric', month: 'short', year: 'numeric', timeZone: 'UTC' })
}

export function dateFilterLabel(range: DateFilterRange): string {
  if (!range.from && !range.to) return 'All dates'
  if (range.label && range.label !== 'Custom range' && range.label !== 'All dates') return range.label
  if (!range.from) return `Until ${shortDate(range.to)}`
  if (!range.to) return `From ${shortDate(range.from)}`
  return range.from === range.to ? shortDate(range.from) : `${shortDate(range.from)} – ${shortDate(range.to)}`
}

export function DateFilter({ value = ALL_DATES, onChange, title = 'Date range', disabled = false, allowOpenEnded = true, allowAllDates = true, presetDays = [1, -1, 7, 30, 60, 90, 365], presets: suppliedPresets, minRangeDays = 1, maxRangeDays, minDate, maxDate }: {
  value?: DateFilterRange; onChange: (value: DateFilterRange) => void; title?: string; disabled?: boolean
  allowOpenEnded?: boolean; allowAllDates?: boolean; presetDays?: number[]; presets?: DateFilterRange[]; minRangeDays?: number; maxRangeDays?: number; minDate?: string; maxDate?: string
}) {
  const [open, setOpen] = useState(false)
  const [draft, setDraft] = useState(value)
  const [selectingEnd, setSelectingEnd] = useState(false)
  const [calendarRevision, setCalendarRevision] = useState(0)
  const presets = suppliedPresets ?? [...(allowAllDates ? [ALL_DATES] : []), ...presetDays.map(days => dateFilterPreset(Math.abs(days), days === -1))]
  const length = draft.from && draft.to ? (Date.parse(`${draft.to}T00:00:00Z`) - Date.parse(`${draft.from}T00:00:00Z`)) / 86400000 + 1 : null
  const unrestricted = allowAllDates && !draft.from && !draft.to
  const error = unrestricted ? null
    : draft.from && !isCalendarDate(draft.from) || draft.to && !isCalendarDate(draft.to) ? 'Enter valid calendar dates.'
    : (!allowOpenEnded || !allowAllDates && !draft.from && !draft.to) && (!draft.from || !draft.to) ? 'Choose both a From date and a To date.'
    : draft.from && draft.to && draft.from > draft.to ? 'The To date must be on or after the From date.'
    : length !== null && length < minRangeDays ? `Choose a range of at least ${minRangeDays} calendar days.`
    : length !== null && maxRangeDays !== undefined && length > maxRangeDays ? `Choose a range of no more than ${maxRangeDays} calendar days.`
    : minDate && (draft.from && draft.from < minDate || draft.to && draft.to < minDate) ? `Choose dates on or after ${shortDate(minDate)}.`
    : maxDate && (draft.from && draft.from > maxDate || draft.to && draft.to > maxDate) ? `Choose dates on or before ${shortDate(maxDate)}.` : null
  const apply = () => {
    if (error) return
    onChange(!draft.from && !draft.to ? ALL_DATES : draft)
    setOpen(false)
  }
  return <>
    <Button variant="secondary" disabled={disabled} aria-haspopup="dialog" aria-expanded={open} className={`max-w-full rounded-full text-sm ${value.from || value.to ? 'border-action-primary bg-brand-orange-50' : ''}`} onClick={() => { setDraft(value); setSelectingEnd(false); setOpen(true) }}><CalendarDays size={18} className="shrink-0 text-action-primary" aria-hidden="true" /><span className="min-w-0 break-words">{dateFilterLabel(value)}</span></Button>
    <FormDialog open={open} title={title} description="Inclusive calendar dates in Asia/Manila." size="date" onClose={() => setOpen(false)} footer={<div className="flex justify-end gap-3"><Button variant="quiet" onClick={() => setOpen(false)}>Cancel</Button><Button disabled={Boolean(error)} onClick={apply}>Apply</Button></div>}>
      {open && <div className="grid min-w-0 gap-6 sm:grid-cols-[10rem_minmax(0,1fr)]">
        <div role="group" className="flex min-w-0 gap-1 overflow-x-auto py-1 sm:grid sm:content-start sm:overflow-visible sm:py-0" aria-label="Date presets">{presets.map(preset => <Button className="shrink-0 whitespace-nowrap" variant={draft.label === preset.label ? 'primary' : 'quiet'} key={preset.label} aria-pressed={draft.label === preset.label} onClick={() => { setDraft(preset); setSelectingEnd(false); setCalendarRevision(revision => revision + 1) }}>{preset.label}</Button>)}</div>
        <div className="grid min-w-0 content-start gap-5">
          <RangeCalendar key={calendarRevision} from={draft.from} to={draft.to} minDate={minDate} maxDate={maxDate} onSelect={date => {
            if (!selectingEnd) { setDraft({ label: 'Custom range', from: date, to: '' }); setSelectingEnd(true) }
            else { setDraft({ label: 'Custom range', from: date < draft.from ? date : draft.from, to: date < draft.from ? draft.from : date }); setSelectingEnd(false) }
          }} />
          <Field label="From" name="range_from" type="date" value={draft.from} min={minDate} max={draft.to || maxDate} onChange={event => { setDraft({ ...draft, label: 'Custom range', from: event.target.value }); setSelectingEnd(false); setCalendarRevision(revision => revision + 1) }} />
          <Field label="To" name="range_to" type="date" value={draft.to} min={draft.from || minDate} max={maxDate} onChange={event => { setDraft({ ...draft, label: 'Custom range', to: event.target.value }); setSelectingEnd(false); setCalendarRevision(revision => revision + 1) }} />
          {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
          <p className="text-sm leading-5 text-text-secondary">Choose a preset or use the calendar controls.{allowOpenEnded ? ' Leave a boundary empty for an open-ended range.' : ` Choose both dates${maxRangeDays ? `, up to ${maxRangeDays} calendar days` : ''}.`}</p>
        </div>
      </div>}
    </FormDialog>
  </>
}
