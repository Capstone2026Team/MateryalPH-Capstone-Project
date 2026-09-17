import { fireEvent, render, screen } from '@testing-library/react'
import { DateFilter } from '@materyalph/web-ui'
import { expect, it, vi } from 'vitest'

it('reuses the shared picker with All dates by default and discards cancelled changes', () => {
  HTMLDialogElement.prototype.showModal = function () { this.open = true }
  HTMLDialogElement.prototype.close = function () { this.open = false }
  const change = vi.fn()
  render(<DateFilter onChange={change} />)
  const trigger = screen.getAllByRole('button', { name: 'All dates' })[0]!
  fireEvent.click(trigger)
  fireEvent.click(screen.getByRole('button', { name: 'Last 30 days' }))
  expect(screen.getByRole('button', { name: 'Last 30 days' })).toHaveAttribute('aria-pressed', 'true')
  fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
  expect(change).not.toHaveBeenCalled()
  fireEvent.click(trigger)
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(change).toHaveBeenCalledWith({ label: 'All dates', from: '', to: '' })
})

it('applies custom date boundaries without changing their interpretation', () => {
  const change = vi.fn()
  render(<DateFilter onChange={change} />)
  fireEvent.click(screen.getAllByRole('button', { name: 'All dates' })[0]!)
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-09-01' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-09-17' } })
  expect(change).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  expect(change).toHaveBeenCalledWith({ label: 'Custom range', from: '2026-09-01', to: '2026-09-17' })
})
