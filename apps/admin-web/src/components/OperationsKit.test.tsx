import { fireEvent, render, screen } from '@testing-library/react'
import { expect, test, vi } from 'vitest'
import { Paged } from './OperationsKit'

test('an empty later page retains navigation back to previous records', () => {
  const setPage = vi.fn()
  render(<Paged state={{ page: 2, setPage, data: { items: [], hasMore: false, total: 0 }, error: null, reload: vi.fn() }} empty="No records">{() => <p>Records</p>}</Paged>)
  expect(screen.getByText('No records')).toBeInTheDocument()
  fireEvent.click(screen.getByRole('button', { name: /previous/i }))
  expect(setPage).toHaveBeenCalledWith(1)
})
