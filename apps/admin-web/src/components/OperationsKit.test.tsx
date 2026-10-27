import { fireEvent, render, screen } from '@testing-library/react'
import { expect, test, vi } from 'vitest'
import { Paged, Panel } from './OperationsKit'

test('panels have unique accessible heading references even when titles contain spaces or repeat', () => {
  render(<><Panel title="Queue status">First queue</Panel><Panel title="Queue status">Second queue</Panel><Panel title="Import status" id="import-status">Import</Panel></>)
  const panels = screen.getAllByRole('region', { name: 'Queue status' })
  expect(panels).toHaveLength(2)
  expect(panels[0]?.getAttribute('aria-labelledby')).not.toMatch(/\s/)
  expect(panels[0]?.getAttribute('aria-labelledby')).not.toEqual(panels[1]?.getAttribute('aria-labelledby'))
  expect(screen.getByRole('heading', { name: 'Import status' })).toHaveAttribute('id', 'import-status')
})

test('an empty later page retains navigation back to previous records', () => {
  const setPage = vi.fn()
  render(<Paged state={{ page: 2, setPage, data: { items: [], hasMore: false, total: 0 }, error: null, reload: vi.fn() }} empty="No records">{() => <p>Records</p>}</Paged>)
  expect(screen.getByText('No records')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: /previous/i }))
  expect(setPage).toHaveBeenCalledWith(1)
})
