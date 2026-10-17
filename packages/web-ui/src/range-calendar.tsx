import { useEffect, useRef, useState, type KeyboardEvent } from 'react'
import { ChevronLeft, ChevronRight } from 'lucide-react'
import { Button } from './button'
import { isCalendarDate, manilaToday } from './calendar-dates'

const monthOf = (date: string) => new Date(`${date.slice(0, 7)}-01T00:00:00Z`)
const monthLabel = (date: Date) => date.toLocaleDateString('en-PH', { month: 'long', year: 'numeric', timeZone: 'UTC' })

export function RangeCalendar({ from, to, onSelect, minDate, maxDate }: {
  from: string; to: string; onSelect: (date: string) => void; minDate?: string | undefined; maxDate?: string | undefined
}) {
  const initialDate = () => {
    const selected = [from, to].find(isCalendarDate) || manilaToday()
    return minDate && selected < minDate ? minDate : maxDate && selected > maxDate ? maxDate : selected
  }
  const [month, setMonth] = useState(() => monthOf(initialDate()))
  const [focusedDate, setFocusedDate] = useState(initialDate)
  const pendingFocus = useRef(false)
  const container = useRef<HTMLDivElement>(null)
  useEffect(() => {
    if (pendingFocus.current) {
      container.current?.querySelector<HTMLButtonElement>(`[data-date="${focusedDate}"]`)?.focus()
      pendingFocus.current = false
    }
  }, [month, focusedDate])
  function shift(amount: number) { setMonth(value => new Date(Date.UTC(value.getUTCFullYear(), value.getUTCMonth() + amount, 1))) }
  function move(event: KeyboardEvent<HTMLButtonElement>, value: string) {
    const date = new Date(`${value}T00:00:00Z`)
    const change = event.key === 'ArrowRight' ? 1 : event.key === 'ArrowLeft' ? -1 : event.key === 'ArrowDown' ? 7 : event.key === 'ArrowUp' ? -7 : event.key === 'Home' ? -date.getUTCDay() : event.key === 'End' ? 6 - date.getUTCDay() : null
    if (change !== null) date.setUTCDate(date.getUTCDate() + change)
    else if (event.key === 'PageUp' || event.key === 'PageDown') {
      const day = date.getUTCDate()
      date.setUTCDate(1)
      date.setUTCMonth(date.getUTCMonth() + (event.key === 'PageUp' ? -1 : 1))
      date.setUTCDate(Math.min(day, new Date(Date.UTC(date.getUTCFullYear(), date.getUTCMonth() + 1, 0)).getUTCDate()))
    } else return
    event.preventDefault()
    const next = date.toISOString().slice(0, 10)
    if (minDate && next < minDate || maxDate && next > maxDate) return
    const lastVisible = new Date(Date.UTC(month.getUTCFullYear(), month.getUTCMonth() + 2, 0)).toISOString().slice(0, 10)
    if (next < month.toISOString().slice(0, 10) || next > lastVisible) setMonth(monthOf(next))
    pendingFocus.current = true
    setFocusedDate(next)
  }
  return <div ref={container} className="-mx-5 min-w-0 px-px min-[360px]:mx-0 min-[360px]:px-0">
    <div className="mb-2 flex justify-between"><Button variant="quiet" aria-label="Previous month" onClick={() => shift(-1)}><ChevronLeft size={16} aria-hidden="true" /></Button><Button variant="quiet" aria-label="Next month" onClick={() => shift(1)}><ChevronRight size={16} aria-hidden="true" /></Button></div>
    <div className="grid min-w-0 gap-5" style={{ gridTemplateColumns: 'repeat(auto-fit, minmax(min(100%, 19.25rem), 1fr))' }}>{[0, 1].map(offset => {
      const first = new Date(Date.UTC(month.getUTCFullYear(), month.getUTCMonth() + offset, 1))
      const count = new Date(Date.UTC(first.getUTCFullYear(), first.getUTCMonth() + 1, 0)).getUTCDate()
      const today = manilaToday()
      const focusInMonth = focusedDate.slice(0, 7) === first.toISOString().slice(0, 7)
      return <section className="min-w-0" key={offset} aria-label={monthLabel(first)}><h3 aria-live="polite" className="mb-3 text-center text-sm font-semibold">{monthLabel(first)}</h3>
        <div className="grid grid-cols-7 text-center text-xs">{['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map(day => <span className="py-2 text-text-secondary" key={day}>{day}</span>)}{Array.from({ length: first.getUTCDay() }, (_, index) => <span key={`space-${index}`} />)}{Array.from({ length: count }, (_, index) => {
          const date = new Date(Date.UTC(first.getUTCFullYear(), first.getUTCMonth(), index + 1)).toISOString().slice(0, 10)
          const selected = date === from || date === to
          const between = Boolean(from && to && date > from && date < to)
          const disabled = Boolean(minDate && date < minDate || maxDate && date > maxDate)
          return <button className={`min-h-11 min-w-11 text-sm tabular-nums focus-visible:relative focus-visible:z-10 focus-visible:outline-2 focus-visible:outline-offset-0 focus-visible:outline-focus-ring disabled:cursor-not-allowed disabled:opacity-40 ${selected ? 'rounded-control bg-action-primary font-semibold text-white' : between ? 'bg-brand-orange-100 text-text-strong' : 'rounded-control hover:bg-surface-canvas'} ${date === today && !selected ? 'font-semibold underline decoration-action-primary underline-offset-4' : ''}`} key={date} data-date={date} type="button" aria-label={date} aria-current={date === today ? 'date' : undefined} aria-pressed={selected || between} disabled={disabled} tabIndex={focusedDate === date || !focusInMonth && index === 0 ? 0 : -1} onFocus={() => setFocusedDate(date)} onKeyDown={event => move(event, date)} onClick={() => onSelect(date)}>{index + 1}</button>
        })}</div>
      </section>
    })}</div>
  </div>
}
