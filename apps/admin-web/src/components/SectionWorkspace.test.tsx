import { fireEvent, render, screen } from '@testing-library/react'
import { SectionWorkspace } from '@materyalph/web-ui'
import { expect, it } from 'vitest'

it('defaults to Overview, shows one section and exposes the existing date picker', () => {
  render(<SectionWorkspace dateFilter sections={[{ label: 'Overview', content: <p>Current counts</p> }, { label: 'Platform Health', content: <p>Health preview</p> }]} />)
  expect(screen.getByText('Current counts')).toBeVisible()
  expect(screen.queryByText('Health preview')).not.toBeInTheDocument()
  expect(screen.getAllByRole('button', { name: 'All dates' })[0]).toBeVisible()
  fireEvent.click(screen.getByRole('button', { name: 'Platform Health' }))
  expect(screen.getByText('Health preview')).toBeVisible()
  expect(screen.queryByText('Current counts')).not.toBeInTheDocument()
  expect(screen.getByRole('button', { name: 'Platform Health' })).toHaveAttribute('aria-pressed', 'true')
})
