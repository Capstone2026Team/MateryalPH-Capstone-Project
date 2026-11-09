import { fireEvent, render, screen } from '@testing-library/react'
import { expect, test, vi } from 'vitest'
import { StatCard } from '@materyalph/web-ui'

test('filterable metric cards retain their selected state, keyboard control and dismissible help', () => {
  const filter = vi.fn()
  const { rerender } = render(<dl><StatCard label="Pending orders" value={7} hint="Orders awaiting your confirmation" onClick={filter} active /></dl>)
  const trigger = screen.getByRole('button', { name: 'Filter: Pending orders' })
  expect(trigger).toHaveAttribute('aria-pressed', 'true')
  fireEvent.click(trigger)
  expect(filter).toHaveBeenCalledOnce()
  const help = screen.getByRole('button', { name: 'About Pending orders' })
  help.focus()
  expect(help).toHaveAttribute('aria-describedby')
  fireEvent.keyDown(help, { key: 'Escape' })
  expect(help).not.toHaveAttribute('aria-describedby')
  expect(screen.queryByRole('tooltip', { hidden: true })).not.toBeInTheDocument()
  rerender(<dl><StatCard label="Pending orders" value={7} hint="Orders awaiting your confirmation" onClick={filter} disabled /></dl>)
  expect(trigger).toHaveAttribute('aria-pressed', 'false')
  expect(trigger).toBeDisabled()
  fireEvent.click(trigger)
  expect(filter).toHaveBeenCalledOnce()
})
