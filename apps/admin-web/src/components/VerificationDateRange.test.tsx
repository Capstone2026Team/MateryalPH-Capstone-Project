import { fireEvent, render, screen } from '@testing-library/react'
import { expect, it, vi } from 'vitest'
import { DateFilter as VerificationDateRange } from '@materyalph/web-ui'

it('applies calendar-day presets only after confirmation', () => {
  vi.useFakeTimers(); vi.setSystemTime(new Date('2026-09-16T18:00:00Z'))
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  const change = vi.fn()
  render(<VerificationDateRange value={{ label: 'All dates', from: '', to: '' }} onChange={change} />)
  fireEvent.click(screen.getAllByRole('button', { name: 'All dates' })[0]!)
  fireEvent.click(screen.getByRole('button', { name: 'Last 7 days' }))
  expect(change).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(change).toHaveBeenCalledWith({ label: 'Last 7 days', from: '2026-09-11', to: '2026-09-17' })
  vi.useRealTimers()
})
