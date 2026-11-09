import { act, fireEvent, render, screen, within } from '@testing-library/react'
import { useState, type ComponentProps } from 'react'
import { MemoryRouter, useSearchParams } from 'react-router-dom'
import { ALL_DATES, DateFilter, dateFilterPreset, dateRangeFromParams, dateRangePatch, type DateFilterRange } from '@materyalph/web-ui'
import { saveDateFilterRange } from '../../../../packages/web-ui/src/date-filter-preference'
import { beforeEach, expect, it, vi } from 'vitest'

const STORAGE_KEY = 'materyalph:date-filter:v1'

beforeEach(() => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
})

function ControlledFilter({ name, initial = dateFilterPreset(30), ...props }: { name: string; initial?: DateFilterRange } & Omit<ComponentProps<typeof DateFilter>, 'value' | 'onChange'>) {
  const [range, setRange] = useState(initial)
  return <section aria-label={name}>
    <DateFilter {...props} value={range} onChange={setRange} />
    <output aria-label={`${name} query dates`}>{range.from}|{range.to}</output>
    <button onClick={() => setRange(dateFilterPreset(30))}>Reset {name}</button>
  </section>
}

function choosePreset(name: string, preset: string) {
  fireEvent.click(within(screen.getByRole('region', { name })).getByRole('button', { expanded: false }))
  fireEvent.click(screen.getByRole('button', { name: preset }))
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
}

it('reuses the shared picker with the last 30 days by default and discards cancelled changes', () => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  const change = vi.fn()
  render(<DateFilter onChange={change} />)
  const trigger = screen.getAllByRole('button', { name: 'Last 30 days' })[0]!
  fireEvent.click(trigger)
  fireEvent.click(screen.getByRole('button', { name: 'Last 7 days' }))
  expect(screen.getByRole('button', { name: 'Last 7 days' })).toHaveAttribute('aria-pressed', 'true')
  fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
  expect(change).not.toHaveBeenCalled()
  fireEvent.click(trigger)
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(change).toHaveBeenCalledWith(dateFilterPreset(30))
})

it('applies custom date boundaries without changing their interpretation', () => {
  const change = vi.fn()
  render(<DateFilter onChange={change} />)
  fireEvent.click(screen.getAllByRole('button', { name: 'Last 30 days' })[0]!)
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-09-01' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-09-17' } })
  expect(change).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(change).toHaveBeenCalledWith({ label: 'Custom range', from: '2026-09-01', to: '2026-09-17' })
})

it('synchronizes applied dates and query state across every mounted picker', () => {
  render(<><ControlledFilter name="Orders" /><ControlledFilter name="Earnings" /></>)
  choosePreset('Orders', 'Last 7 days')
  const range = dateFilterPreset(7)
  for (const name of ['Orders', 'Earnings']) {
    expect(screen.getByLabelText(`${name} query dates`)).toHaveTextContent(`${range.from}|${range.to}`)
    expect(within(screen.getByRole('region', { name })).getByRole('button', { name: range.label })).toBeInTheDocument()
  }
  expect(JSON.parse(localStorage.getItem(STORAGE_KEY)!)).toEqual(range)
})

it('keeps independent date scopes separate from saved analytics dates', () => {
  const saved = dateFilterPreset(30)
  localStorage.setItem(STORAGE_KEY, JSON.stringify(saved))
  render(<><ControlledFilter name="Analytics" /><ControlledFilter name="Joined dates" initial={ALL_DATES} persistSelection={false} /></>)
  expect(screen.getByLabelText('Joined dates query dates')).toHaveTextContent(/^\|$/)
  choosePreset('Joined dates', 'Last 7 days')
  expect(screen.getByLabelText('Joined dates query dates')).toHaveTextContent(`${dateFilterPreset(7).from}|${dateFilterPreset(7).to}`)
  expect(screen.getByLabelText('Analytics query dates')).toHaveTextContent(`${saved.from}|${saved.to}`)
  expect(JSON.parse(localStorage.getItem(STORAGE_KEY)!)).toEqual(saved)
  choosePreset('Analytics', 'Last 90 days')
  expect(screen.getByLabelText('Joined dates query dates')).toHaveTextContent(`${dateFilterPreset(7).from}|${dateFilterPreset(7).to}`)
})

it('restores the saved selection after navigation or reload and replaces stale page dates', () => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify({ label: 'Custom range', from: '2026-09-01', to: '2026-09-17' }))
  const first = render(<ControlledFilter name="Orders" />)
  expect(screen.getByLabelText('Orders query dates')).toHaveTextContent('2026-09-01|2026-09-17')
  first.unmount()
  render(<ControlledFilter name="Earnings" initial={{ label: 'Custom range', from: '2026-08-01', to: '2026-08-31' }} />)
  expect(screen.getByLabelText('Earnings query dates')).toHaveTextContent('2026-09-01|2026-09-17')
})

it('keeps the applied selection when a draft is cancelled', () => {
  render(<ControlledFilter name="Orders" />)
  choosePreset('Orders', 'Last 7 days')
  const saved = localStorage.getItem(STORAGE_KEY)
  fireEvent.click(screen.getByRole('button', { name: 'Last 7 days' }))
  fireEvent.click(screen.getByRole('button', { name: 'Last 90 days' }))
  fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
  expect(localStorage.getItem(STORAGE_KEY)).toBe(saved)
  expect(screen.getByRole('button', { name: 'Last 7 days' })).toBeInTheDocument()
})

it('shares explicit All dates and open-ended ranges and keeps them after remounting', () => {
  const first = render(<><ControlledFilter name="Orders" /><ControlledFilter name="Earnings" /></>)
  choosePreset('Orders', 'All dates')
  expect(screen.getByLabelText('Earnings query dates')).toHaveTextContent('|')
  fireEvent.click(within(screen.getByRole('region', { name: 'Earnings' })).getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-09-17' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(screen.getByLabelText('Orders query dates')).toHaveTextContent('|2026-09-17')
  first.unmount()
  render(<ControlledFilter name="Inventory history" />)
  expect(screen.getByLabelText('Inventory history query dates')).toHaveTextContent('|2026-09-17')
})

it('retains workflow bounds without overwriting the shared preference', () => {
  localStorage.setItem(STORAGE_KEY, JSON.stringify(ALL_DATES))
  render(<><ControlledFilter name="Orders" /><ControlledFilter name="Marketplace" allowAllDates={false} allowOpenEnded={false} maxRangeDays={366} /></>)
  expect(screen.getByLabelText('Orders query dates')).toHaveTextContent('|')
  const defaultRange = dateFilterPreset(30)
  expect(screen.getByLabelText('Marketplace query dates')).toHaveTextContent(`${defaultRange.from}|${defaultRange.to}`)
  expect(JSON.parse(localStorage.getItem(STORAGE_KEY)!)).toEqual(ALL_DATES)
  choosePreset('Marketplace', 'Last 7 days')
  const range = dateFilterPreset(7)
  expect(screen.getByLabelText('Orders query dates')).toHaveTextContent(`${range.from}|${range.to}`)
})

it('propagates an explicit page reset to the other date filters', () => {
  render(<><ControlledFilter name="Orders" /><ControlledFilter name="Earnings" /></>)
  choosePreset('Orders', 'Last 7 days')
  fireEvent.click(screen.getByRole('button', { name: 'Reset Orders' }))
  const range = dateFilterPreset(30)
  expect(screen.getByLabelText('Earnings query dates')).toHaveTextContent(`${range.from}|${range.to}`)
  expect(JSON.parse(localStorage.getItem(STORAGE_KEY)!)).toEqual(range)
})

it('synchronizes another browser tab without echoing a storage write', () => {
  render(<ControlledFilter name="Orders" />)
  const range = dateFilterPreset(7)
  localStorage.setItem(STORAGE_KEY, JSON.stringify(range))
  const write = vi.spyOn(Storage.prototype, 'setItem')
  act(() => window.dispatchEvent(new StorageEvent('storage', { key: STORAGE_KEY })))
  expect(screen.getByLabelText('Orders query dates')).toHaveTextContent(`${range.from}|${range.to}`)
  expect(write).not.toHaveBeenCalled()
  write.mockRestore()
})

it.each(['{invalid', JSON.stringify({ label: 'Custom range', from: '2026-02-30', to: '' }), JSON.stringify({ label: 'Custom range', from: '2026-09-30', to: '2026-09-01' })])('recovers from an invalid saved preference: %s', saved => {
  localStorage.setItem(STORAGE_KEY, saved)
  render(<ControlledFilter name="Orders" />)
  expect(screen.getByRole('button', { name: 'Last 30 days' })).toBeInTheDocument()
})

it('keeps filters usable and synchronized when persistent storage is unavailable', () => {
  const write = vi.spyOn(Storage.prototype, 'setItem').mockImplementation(() => { throw new DOMException('Storage unavailable', 'QuotaExceededError') })
  try {
    render(<><ControlledFilter name="Orders" /><ControlledFilter name="Earnings" /></>)
    choosePreset('Orders', 'Last 7 days')
    const range = dateFilterPreset(7)
    expect(screen.getByLabelText('Earnings query dates')).toHaveTextContent(`${range.from}|${range.to}`)
  } finally {
    write.mockRestore()
    act(() => saveDateFilterRange(dateFilterPreset(30)))
  }
})

it('updates URL-backed query dates while preserving other filters and resetting pagination', () => {
  function UrlFilter() {
    const [params, setParams] = useSearchParams()
    return <section aria-label="Transactions"><DateFilter value={dateRangeFromParams(params)} onChange={range => setParams(current => {
      const next = new URLSearchParams(current)
      for (const [key, value] of Object.entries(dateRangePatch(range))) { if (value) next.set(key, value); else next.delete(key) }
      next.delete('page')
      return next
    })} /><output aria-label="Query">{params.toString()}</output></section>
  }
  render(<MemoryRouter initialEntries={['/?status=PAID&page=3']}><UrlFilter /><ControlledFilter name="Orders" /></MemoryRouter>)
  choosePreset('Orders', 'Last 7 days')
  const params = new URLSearchParams(screen.getByLabelText('Query').textContent!)
  expect(params.get('status')).toBe('PAID')
  expect(params.has('page')).toBe(false)
  expect(params.get('from')).toBe(dateFilterPreset(7).from)
  expect(params.get('to')).toBe(dateFilterPreset(7).to)
})
