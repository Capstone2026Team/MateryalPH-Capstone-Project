import { useState } from 'react'

export type StoreOperatingDay = {
  dayOfWeek: number
  status: 'OPEN' | 'CLOSED' | ''
  opensAt: string
  closesAt: string
}

export const STORE_WEEKDAYS = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'] as const

export function emptyStoreSchedule(): StoreOperatingDay[] {
  return STORE_WEEKDAYS.map((_, index) => ({ dayOfWeek: index + 1, status: '', opensAt: '', closesAt: '' }))
}

export function storeScheduleErrors(days: StoreOperatingDay[]): Record<number, string> {
  const errors: Record<number, string> = {}
  for (const day of days) {
    if (!day.status) errors[day.dayOfWeek] = 'Choose Open or Closed.'
    else if (day.status === 'OPEN' && (!/^([01]\d|2[0-3]):[0-5]\d$/.test(day.opensAt) || !/^([01]\d|2[0-3]):[0-5]\d$/.test(day.closesAt) || day.closesAt <= day.opensAt)) {
      errors[day.dayOfWeek] = 'Enter an opening time and a later closing time.'
    }
  }
  return errors
}

export function formatStoreTime(value: string): string {
  const [hour = 0, minute = 0] = value.split(':').map(Number)
  return `${hour % 12 || 12}:${String(minute).padStart(2, '0')} ${hour < 12 ? 'AM' : 'PM'}`
}

export function StoreHours({ days }: { days: StoreOperatingDay[] }) {
  return <section aria-label="Store Hours"><h3 className="text-lg font-semibold">Store Hours</h3><dl className="mt-3 grid gap-2 text-sm">{days.map(day => <div className="flex flex-wrap justify-between gap-x-4 border-b border-border-default py-2" key={day.dayOfWeek}><dt className="font-semibold">{STORE_WEEKDAYS[day.dayOfWeek - 1]}</dt><dd>{day.status === 'CLOSED' ? 'Closed' : day.status === 'OPEN' && day.opensAt && day.closesAt ? `${formatStoreTime(day.opensAt)} – ${formatStoreTime(day.closesAt)}` : 'Not configured'}</dd></div>)}</dl></section>
}

export function StoreOperationSchedule({ days, onChange, errors = {} }: { days: StoreOperatingDay[]; onChange: (days: StoreOperatingDay[]) => void; errors?: Record<number, string> }) {
  const [source, setSource] = useState(1)
  const [selected, setSelected] = useState<number[]>([])
  const [notice, setNotice] = useState('')
  const edit = (number: number, patch: Partial<StoreOperatingDay>) => {
    setNotice('')
    onChange(days.map(day => day.dayOfWeek === number ? { ...day, ...patch } : day))
  }
  const sourceDay = days.find(day => day.dayOfWeek === source)
  const sourceValid = Boolean(sourceDay?.status && !storeScheduleErrors([sourceDay])[source])
  const configured = days.filter(day => day.status && !storeScheduleErrors([day])[day.dayOfWeek]).length
  const control = 'min-h-11 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-sm text-text-strong focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-focus-ring disabled:cursor-not-allowed disabled:bg-surface-canvas disabled:text-text-secondary'

  return <section aria-labelledby="store-operation-title" className="space-y-6">
    <div className="flex flex-wrap items-start justify-between gap-3">
      <div className="max-w-xl">
        <h2 id="store-operation-title" className="text-xl font-semibold text-text-strong">Weekly operating schedule</h2>
        <p className="mt-2 text-sm leading-6 text-text-secondary">Let Buyers know when your store normally accepts customers, inquiries and pickups.</p>
      </div>
      <span className="rounded-control bg-surface-canvas px-3 py-2 text-xs font-semibold text-text-secondary">Philippine time · UTC+8</span>
    </div>

    <div className="overflow-hidden rounded-control border border-border-default">
      <div className="flex flex-wrap items-center justify-between gap-2 border-b border-border-default bg-surface-canvas px-4 py-3">
        <p className="text-sm font-semibold text-text-strong">Your weekly hours</p>
        <p className="text-xs text-text-secondary">{configured} of 7 days configured</p>
      </div>
      <div aria-hidden="true" className="hidden grid-cols-[minmax(6rem,1fr)_minmax(8rem,1fr)_minmax(0,1fr)_minmax(0,1fr)] gap-4 border-b border-border-default px-4 py-3 text-xs font-semibold text-text-secondary lg:grid">
        <span>Day</span><span>Status</span><span>Opening time</span><span>Closing time</span>
      </div>
      <div className="divide-y divide-border-default">
        {days.map(day => {
          const name = STORE_WEEKDAYS[day.dayOfWeek - 1]
          return <div key={day.dayOfWeek} role="group" aria-label={`${name} operating hours`} className="grid min-w-0 grid-cols-2 gap-3 px-4 py-4 lg:grid-cols-[minmax(6rem,1fr)_minmax(8rem,1fr)_minmax(0,1fr)_minmax(0,1fr)] lg:items-center lg:gap-4">
            <div className="self-center">
              <p className="text-sm font-semibold text-text-strong">{name}</p>
              <p className="mt-1 text-xs text-text-secondary">{day.status === 'CLOSED' ? 'Closed all day' : day.status === 'OPEN' ? 'Open for business' : 'Choose a status'}</p>
            </div>
            <label className="grid min-w-0 gap-1.5">
              <span className="sr-only">{name} status</span>
              <select className={control} value={day.status} onChange={event => edit(day.dayOfWeek, { status: event.target.value as StoreOperatingDay['status'], opensAt: event.target.value === 'CLOSED' ? '' : day.opensAt, closesAt: event.target.value === 'CLOSED' ? '' : day.closesAt })}>
                <option value="">Choose</option><option value="OPEN">Open</option><option value="CLOSED">Closed</option>
              </select>
            </label>
            <label className="col-span-2 grid min-w-0 gap-1.5 sm:col-span-1">
              <span className="text-xs font-medium text-text-secondary lg:sr-only">Opening time</span>
              <input className={control} aria-label={`${name} opening time`} aria-invalid={Boolean(errors[day.dayOfWeek])} type="time" value={day.opensAt} disabled={day.status !== 'OPEN'} onChange={event => edit(day.dayOfWeek, { opensAt: event.target.value })} />
            </label>
            <label className="col-span-2 grid min-w-0 gap-1.5 sm:col-span-1">
              <span className="text-xs font-medium text-text-secondary lg:sr-only">Closing time</span>
              <input className={control} aria-label={`${name} closing time`} aria-invalid={Boolean(errors[day.dayOfWeek])} type="time" value={day.closesAt} disabled={day.status !== 'OPEN'} onChange={event => edit(day.dayOfWeek, { closesAt: event.target.value })} />
            </label>
            {errors[day.dayOfWeek] && <p className="col-span-2 text-sm text-status-error lg:col-span-4" role="alert">{errors[day.dayOfWeek]}</p>}
          </div>
        })}
      </div>
    </div>

    <div className="rounded-control bg-surface-canvas p-4 sm:p-5">
      <h3 className="font-semibold text-text-strong">Copy hours to other days</h3>
      <p className="mt-1 text-sm leading-6 text-text-secondary">Use the same schedule on several days. You can still adjust each day afterward.</p>
      <div className="mt-4 grid gap-5 lg:grid-cols-[minmax(10rem,1fr)_minmax(0,2fr)]">
        <label className="grid content-start gap-2 text-sm font-semibold text-text-strong">Copy from
          <select className={control} value={source} onChange={event => { setSource(Number(event.target.value)); setSelected([]); setNotice('') }}>
            {days.map(day => <option value={day.dayOfWeek} key={day.dayOfWeek}>{STORE_WEEKDAYS[day.dayOfWeek - 1]}</option>)}
          </select>
          <span className="text-xs font-normal leading-5 text-text-secondary">{sourceValid && sourceDay ? sourceDay.status === 'CLOSED' ? 'Closed all day' : `${formatStoreTime(sourceDay.opensAt)} – ${formatStoreTime(sourceDay.closesAt)}` : 'Configure this day’s status and hours first.'}</span>
        </label>
        <fieldset className="min-w-0">
          <legend className="mb-2 text-sm font-semibold text-text-strong">Apply to</legend>
          <div className="flex flex-wrap gap-2">
            {days.filter(day => day.dayOfWeek !== source).map(day => <label className={`flex min-h-11 cursor-pointer items-center gap-2 rounded-control border bg-surface-primary px-3 text-sm focus-within:ring-2 focus-within:ring-focus-ring ${selected.includes(day.dayOfWeek) ? 'border-action-primary font-semibold text-text-strong' : 'border-border-default text-text-secondary hover:border-action-primary'}`} key={day.dayOfWeek}>
              <input className="h-4 w-4 shrink-0 accent-action-primary" type="checkbox" checked={selected.includes(day.dayOfWeek)} onChange={event => { setSelected(event.target.checked ? [...selected, day.dayOfWeek] : selected.filter(value => value !== day.dayOfWeek)); setNotice('') }} />{STORE_WEEKDAYS[day.dayOfWeek - 1]}
            </label>)}
          </div>
        </fieldset>
      </div>
      <div className="mt-5 flex flex-wrap items-center gap-3 border-t border-border-default pt-4">
        <button type="button" className="min-h-11 w-full rounded-control bg-action-primary px-4 text-sm font-semibold text-white hover:bg-action-primary-pressed focus-visible:outline-none focus-visible:ring-2 focus-visible:ring-focus-ring focus-visible:ring-offset-2 disabled:cursor-not-allowed disabled:opacity-50 sm:w-auto" disabled={!sourceValid || selected.length === 0} onClick={() => {
          if (!sourceDay) return
          onChange(days.map(day => selected.includes(day.dayOfWeek) ? { ...day, status: sourceDay.status, opensAt: sourceDay.opensAt, closesAt: sourceDay.closesAt } : day))
          setNotice(`${STORE_WEEKDAYS[source - 1]}’s schedule copied to ${selected.length} ${selected.length === 1 ? 'day' : 'days'}.`)
          setSelected([])
        }}>Apply to Selected Days</button>
        <p className="text-xs text-text-secondary" role="status">{notice || (selected.length ? `${selected.length} ${selected.length === 1 ? 'day selected' : 'days selected'}` : 'Select the days you want to update.')}</p>
      </div>
    </div>
  </section>
}
