import { fireEvent, render, screen, within } from '@testing-library/react'
import { ALL_DATES, DateFilter, SearchInput, dateComparisonPreset, dateFilterPreset } from '@materyalph/web-ui'
import { afterEach, beforeEach, expect, it, vi } from 'vitest'

beforeEach(() => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
})
afterEach(() => vi.useRealTimers())

it('keeps material comparison endpoints anchored to the published snapshot instead of the system day', () => {
  expect(dateComparisonPreset(7, '2026-10-02')).toEqual({ label: '7-day comparison', from: '2026-09-25', to: '2026-10-02' })
})

it('uses the Manila calendar day around UTC midnight and crosses leap-month boundaries inclusively', () => {
  expect(dateFilterPreset(7, false, new Date('2028-02-29T17:00:00Z'))).toEqual({ label: 'Last 7 days', from: '2028-02-24', to: '2028-03-01' })
  expect(dateFilterPreset(1, true, new Date('2028-02-29T17:00:00Z'))).toEqual({ label: 'Yesterday', from: '2028-02-29', to: '2028-02-29' })
})

it('shows custom boundaries on the trigger and starts the calendar at that selection', () => {
  render(<DateFilter title="Order dates" value={{ label: 'Custom range', from: '2025-02-03', to: '2025-03-09' }} onChange={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Feb 3, 2025 – Mar 9, 2025' }))
  expect(screen.getByRole('dialog', { name: 'Order dates' })).toBeVisible()
  expect(screen.getByRole('region', { name: 'February 2025' })).toBeVisible()
  expect(screen.getByRole('region', { name: 'March 2025' })).toBeVisible()
})

it('lets someone repair malformed calendar dates from a saved URL without crashing', () => {
  const change = vi.fn()
  render(<DateFilter value={{ label: 'Custom range', from: '2026-99-01', to: '2026-02-31' }} onChange={change} />)
  fireEvent.click(screen.getByRole('button', { name: /2026-99-01/ }))
  const dialog = screen.getByRole('dialog')
  expect(within(dialog).getByRole('alert')).toHaveTextContent('Enter valid calendar dates.')
  expect(within(dialog).getByRole('button', { name: 'Apply' })).toBeDisabled()
  fireEvent.click(within(dialog).getByRole('button', { name: 'All dates' }))
  fireEvent.click(within(dialog).getByRole('button', { name: 'Apply' }))
  expect(change).toHaveBeenCalledExactlyOnceWith(ALL_DATES)
})

it('shows a newly chosen preset when the applied selection was in an older month', () => {
  vi.useFakeTimers()
  vi.setSystemTime(new Date('2026-10-09T02:00:00Z'))
  const change = vi.fn()
  render(<DateFilter value={{ label: 'Custom range', from: '2025-02-03', to: '2025-02-09' }} onChange={change} />)
  fireEvent.click(screen.getByRole('button', { name: 'Feb 3, 2025 – Feb 9, 2025' }))
  expect(screen.getByRole('region', { name: 'February 2025' })).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Today' }))
  expect(screen.getByRole('region', { name: 'October 2026' })).toBeVisible()
  expect(screen.getByRole('button', { name: '2026-10-09' })).toHaveAttribute('aria-pressed', 'true')
  expect(change).not.toHaveBeenCalled()
})

it('selects a reversed calendar range in chronological order and applies once', () => {
  const change = vi.fn()
  render(<DateFilter value={{ label: 'Custom range', from: '2026-10-01', to: '2026-10-31' }} onChange={change} />)
  fireEvent.click(screen.getByRole('button', { name: 'Oct 1, 2026 – Oct 31, 2026' }))
  fireEvent.click(screen.getByRole('button', { name: '2026-10-20' }))
  fireEvent.click(screen.getByRole('button', { name: '2026-10-07' }))
  expect(change).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(change).toHaveBeenCalledExactlyOnceWith({ label: 'Custom range', from: '2026-10-07', to: '2026-10-20' })
})

it('supports an inclusive open-ended range and resetting to All dates', () => {
  const change = vi.fn()
  const view = render(<DateFilter onChange={change} />)
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-10-08' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(change).toHaveBeenLastCalledWith({ label: 'Custom range', from: '', to: '2026-10-08' })
  view.rerender(<DateFilter value={{ label: 'Custom range', from: '', to: '2026-10-08' }} onChange={change} />)
  fireEvent.click(screen.getByRole('button', { name: 'Until Oct 8, 2026' }))
  fireEvent.click(within(screen.getByRole('dialog')).getByRole('button', { name: 'All dates' }))
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(change).toHaveBeenLastCalledWith(ALL_DATES)
})

it('blocks reversed, missing and over-limit dates on bounded analytics', () => {
  render(<DateFilter allowAllDates={false} allowOpenEnded={false} minRangeDays={2} maxRangeDays={366} presetDays={[7, 30, 90]} value={dateFilterPreset(30)} onChange={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'Last 30 days' }))
  const apply = screen.getByRole('button', { name: 'Apply' })
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '' } })
  expect(apply).toBeDisabled()
  expect(screen.getByRole('alert')).toHaveTextContent('Choose both')
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-10' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-10-09' } })
  expect(apply).toBeDisabled()
  expect(screen.getByRole('alert')).toHaveTextContent('on or after')
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-10-10' } })
  expect(screen.getByRole('alert')).toHaveTextContent('at least 2')
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2028-10-10' } })
  expect(screen.getByRole('alert')).toHaveTextContent('no more than 366')
  expect(screen.queryByRole('button', { name: 'All dates' })).not.toBeInTheDocument()
})

it('discards Escape changes, restores trigger focus and reopens from applied dates', () => {
  const change = vi.fn()
  render(<DateFilter onChange={change} />)
  const trigger = screen.getByRole('button', { name: 'All dates' })
  trigger.focus()
  fireEvent.click(trigger)
  fireEvent.click(screen.getByRole('button', { name: 'Last 7 days' }))
  fireEvent(screen.getByRole('dialog'), new Event('cancel', { cancelable: true }))
  expect(trigger).toHaveFocus()
  expect(change).not.toHaveBeenCalled()
  fireEvent.click(trigger)
  expect(within(screen.getByRole('dialog')).getByRole('button', { name: 'All dates' })).toHaveAttribute('aria-pressed', 'true')
})

it('moves calendar focus by keyboard across a month boundary', () => {
  render(<DateFilter value={{ label: 'Custom range', from: '2026-10-31', to: '' }} onChange={vi.fn()} />)
  fireEvent.click(screen.getByRole('button', { name: 'From Oct 31, 2026' }))
  const day = screen.getByRole('button', { name: '2026-10-31' })
  day.focus()
  fireEvent.keyDown(day, { key: 'ArrowRight' })
  expect(screen.getByRole('button', { name: '2026-11-01' })).toHaveFocus()
  fireEvent.keyDown(screen.getByRole('button', { name: '2026-11-01' }), { key: 'PageDown' })
  expect(screen.getByRole('button', { name: '2026-12-01' })).toHaveFocus()
})

it('clears search through a named control and keeps focus in the search field', () => {
  const change = vi.fn()
  render(<SearchInput label="Search orders" value="cement" onChange={change} />)
  fireEvent.click(screen.getByRole('button', { name: 'Clear search orders' }))
  expect(change).toHaveBeenCalledWith('')
  expect(screen.getByRole('searchbox', { name: 'Search orders' })).toHaveFocus()
})
