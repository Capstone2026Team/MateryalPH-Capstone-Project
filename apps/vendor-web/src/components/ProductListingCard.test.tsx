import { fireEvent, render, screen } from '@testing-library/react'
import { expect, test } from 'vitest'
import { ProductListingCard } from '@materyalph/web-ui'

test('a failed product photo keeps its details visible and recovers when the photo URL changes', () => {
  const props = { title: 'Cement', category: 'Cement and Concrete', sku: 'CEM-40', price: '₱285.50', variants: '1 variant', status: 'Active', stock: 'Available: 50 bag', actions: <button>Edit Cement</button> }
  const { container, rerender } = render(<ul><ProductListingCard {...props} imageUrl="https://example.test/old.png" /></ul>)
  fireEvent.error(container.querySelector('img')!)
  expect(screen.getByText('Photo unavailable')).toBeVisible()
  expect(screen.getByRole('heading', { name: 'Cement' })).toBeVisible()
  expect(screen.getByRole('button', { name: 'Edit Cement' })).toBeEnabled()
  rerender(<ul><ProductListingCard {...props} imageUrl="https://example.test/new.png" /></ul>)
  expect(screen.queryByText('Photo unavailable')).not.toBeInTheDocument()
  expect(container.querySelector('img')).toHaveAttribute('src', 'https://example.test/new.png')
})
