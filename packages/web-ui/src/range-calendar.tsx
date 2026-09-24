import { useState } from 'react'
import { Button } from './button'

export function RangeCalendar({ from, to, onSelect }: { from: string; to: string; onSelect: (date: string) => void }) {
  const [month, setMonth] = useState(() => { const value = new Date(); return new Date(Date.UTC(value.getFullYear(), value.getMonth(), 1)) })
  function shift(amount: number) { setMonth(value => new Date(Date.UTC(value.getUTCFullYear(), value.getUTCMonth() + amount, 1))) }
  return <div><div className="mb-3 flex justify-between"><Button variant="quiet" aria-label="Previous month" onClick={() => shift(-1)}>‹</Button><Button variant="quiet" aria-label="Next month" onClick={() => shift(1)}>›</Button></div><div className="grid gap-5 md:grid-cols-2">{[0, 1].map(offset => {
    const first = new Date(Date.UTC(month.getUTCFullYear(), month.getUTCMonth() + offset, 1))
    const count = new Date(Date.UTC(first.getUTCFullYear(), first.getUTCMonth() + 1, 0)).getUTCDate()
    return <section key={offset} aria-label={first.toLocaleDateString('en-PH', { month: 'long', year: 'numeric', timeZone: 'UTC' })}><h3 className="mb-4 text-center text-sm font-semibold">{first.toLocaleDateString('en-PH', { month: 'long', year: 'numeric', timeZone: 'UTC' })}</h3><div className="grid grid-cols-7 text-center text-xs">{['Su', 'Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa'].map(day => <span className="py-2 text-text-secondary" key={day}>{day}</span>)}{Array.from({ length: first.getUTCDay() }, (_, index) => <span key={`space-${index}`} />)}{Array.from({ length: count }, (_, index) => {
      const date = new Date(Date.UTC(first.getUTCFullYear(), first.getUTCMonth(), index + 1)).toISOString().slice(0, 10)
      const selected = date === from || date === to
      const between = from && to && date > from && date < to
      return <button className={`min-h-9 min-w-6 rounded-control text-sm focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring ${selected ? 'bg-action-primary text-white' : between ? 'bg-brand-orange-100 text-text-strong' : 'hover:bg-surface-canvas'}`} key={date} type="button" aria-label={date} aria-pressed={selected} onClick={() => onSelect(date)}>{index + 1}</button>
    })}</div></section>
  })}</div></div>
}
