import { fireEvent, render, screen } from '@testing-library/react'
import { expect, test, vi } from 'vitest'
import { VersionedAgreementPanel } from '@materyalph/web-ui'

const props = { title: '2% Commission Terms', version: 1, content: 'Published TEST terms', accepted: false, eligible: true, busy: false, error: '', children: 'Commission summary', onAccept: vi.fn() }

test('commission consent requires reading and an explicit unchecked choice', async () => {
  render(<VersionedAgreementPanel {...props} />)
  const checkbox = screen.getByRole('checkbox')
  expect(checkbox).not.toBeChecked()
  expect(checkbox).toBeDisabled()
  fireEvent.click(screen.getByText('Read the full commission terms'))
  const reader = await screen.findByRole('region', { name: 'Current commission agreement' })
  fireEvent.scroll(reader)
  expect(checkbox).toBeEnabled()
  expect(screen.getByRole('button', { name: 'Accept commission terms' })).toBeDisabled()
  fireEvent.click(checkbox)
  fireEvent.click(screen.getByRole('button', { name: 'Accept commission terms' }))
  expect(props.onAccept).toHaveBeenCalledTimes(1)
})

test('pending authority and unavailable content keep acceptance disabled', () => {
  render(<VersionedAgreementPanel {...props} content="" eligible={false} />)
  expect(screen.getByRole('checkbox')).toBeDisabled()
  expect(screen.getByRole('button')).toBeDisabled()
  expect(screen.getByText(/published terms are unavailable/)).toBeVisible()
  expect(screen.getByText(/Owner-linked representative is approved/)).toBeVisible()
})

test('accepted current agreement replaces consent with its recorded status', () => {
  render(<VersionedAgreementPanel {...props} accepted />)
  expect(screen.queryByRole('checkbox')).not.toBeInTheDocument()
  expect(screen.getByRole('status')).toHaveTextContent('Current commission terms accepted')
})
