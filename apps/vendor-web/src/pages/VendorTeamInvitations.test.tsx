import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { expect, test, vi } from 'vitest'
import { VendorTeamInvitations } from '@materyalph/web-ui'

const list = vi.fn(async () => ({ data: [], meta: { currentPage: 1, lastPage: 1 }, errors: [] }))
const explainError = async () => 'Unable to send. Try again.'

test('delegated Managers cannot select Store Manager or grant delegation', async () => {
  render(<VendorTeamInvitations organizationName="Test Store" canInviteManager={false} invite={vi.fn()} list={list} explainError={explainError} />)
  await screen.findByText(/No invitations yet/)
  expect(screen.queryByRole('option', { name: 'Store Manager' })).not.toBeInTheDocument()
  expect(screen.queryByRole('checkbox')).not.toBeInTheDocument()
  expect(screen.getByRole('option', { name: 'Store Staff' })).toBeInTheDocument()
})

test('failed invitations preserve employee input and manager delegation defaults off', async () => {
  const invite = vi.fn().mockRejectedValue(new Error('offline'))
  render(<VendorTeamInvitations organizationName="Test Store" canInviteManager invite={invite} list={list} explainError={explainError} />)
  await screen.findByText(/No invitations yet/)
  fireEvent.change(screen.getByRole('combobox'), { target: { value: 'STORE_MANAGER' } })
  expect(screen.getByRole('checkbox')).not.toBeChecked()
  fireEvent.change(screen.getByRole('textbox', { name: /Employee full name/ }), { target: { value: 'Sample Employee' } })
  fireEvent.change(screen.getByRole('textbox', { name: /Email address/ }), { target: { value: 'employee@example.test' } })
  fireEvent.click(screen.getByRole('button', { name: 'Send invitation' }))
  await waitFor(() => expect(screen.getByRole('alert')).toHaveTextContent('Unable to send'))
  expect(screen.getByRole('textbox', { name: /Employee full name/ })).toHaveValue('Sample Employee')
  expect(invite).toHaveBeenCalledWith(expect.objectContaining({ role: 'STORE_MANAGER', canManageStaff: false }))
})
