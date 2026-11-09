import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter, Route, Routes } from 'react-router-dom'
import { beforeEach, describe, expect, it, vi } from 'vitest'
import { VendorAccountDeletion } from './VendorAccountDeletion'

const mocks = vi.hoisted(() => ({ preview: vi.fn(), remove: vi.fn(), security: vi.fn(), verify: vi.fn() }))
vi.mock('@materyalph/api-client-ts', async importOriginal => ({
  ...await importOriginal<typeof import('@materyalph/api-client-ts')>(),
  AccountsApi: class {
    getVendorAccountDeletionPreview = mocks.preview
    deleteVendorAccount = mocks.remove
    getAccountSecurity = mocks.security
    reauthenticateAccount = mocks.verify
  },
}))

const eligible = {
  canDelete: true, confirmationPhrase: 'DELETE',
  retainedRecords: [{ category: 'Orders, quotations and invoices', purpose: 'Accounting and legal claims' }],
  blockers: { activeOrders: 0, pendingPayments: 0, unresolvedDisputes: 0, pendingRefunds: 0, uncollectedPayments: 0, outstandingStatements: 0, unbilledCommissions: 0, financeReviews: 0 },
}
function show() {
  render(<MemoryRouter initialEntries={['/store-profile']}><Routes><Route path="/store-profile" element={<VendorAccountDeletion />} /><Route path="/login" element={<p>Signed out successfully</p>} /></Routes></MemoryRouter>)
}
beforeEach(() => {
  vi.resetAllMocks()
  mocks.preview.mockResolvedValue({ data: eligible })
  mocks.security.mockResolvedValue({ data: { totpEnrolled: true } })
  mocks.verify.mockResolvedValue({ data: { changed: true } })
  mocks.remove.mockResolvedValue({ data: { signInRequired: true } })
})

describe('Vendor account deletion', () => {
  it('shows blocker counts and resolution links and prevents confirmation', async () => {
    mocks.preview.mockResolvedValue({ data: { ...eligible, canDelete: false, blockers: { ...eligible.blockers, activeOrders: 2, pendingRefunds: 1, unbilledCommissions: 3 } } })
    show()
    await screen.findByText('Resolve the following items before deleting your account.')
    expect(screen.getByRole('button', { name: 'Delete account' })).toBeDisabled()
    expect(screen.getByRole('link', { name: 'Review active orders' })).toHaveAttribute('href', '/orders')
    expect(screen.getByRole('link', { name: 'Review unresolved refunds' })).toHaveAttribute('href', '/finance')
    expect(screen.getByRole('link', { name: 'Review unbilled earned commission' })).toBeVisible()
    expect(screen.getByText('Orders, quotations and invoices')).toBeVisible()
    expect(mocks.remove).not.toHaveBeenCalled()
  })

  it('requires exact typed confirmation and authenticator verification before deleting and redirecting', async () => {
    show()
    await screen.findByText(/Your account is eligible/)
    fireEvent.click(screen.getByRole('button', { name: 'Delete account' }))
    const remove = screen.getByRole('button', { name: 'Delete account permanently' })
    expect(remove).toBeDisabled()
    fireEvent.change(screen.getByLabelText(/Type DELETE to confirm/), { target: { value: 'delete' } })
    expect(remove).toBeDisabled()
    fireEvent.change(screen.getByLabelText(/Type DELETE to confirm/), { target: { value: 'DELETE' } })
    fireEvent.click(remove)
    await screen.findByLabelText(/Authenticator code/)
    expect(mocks.remove).not.toHaveBeenCalled()
    fireEvent.change(screen.getByLabelText(/Authenticator code/), { target: { value: '123456' } })
    fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
    await screen.findByText('Signed out successfully')
    expect(mocks.verify).toHaveBeenCalledWith({ accountPortal: 'vendors', accountReauthentication: { code: '123456' } })
    expect(mocks.remove).toHaveBeenCalledTimes(1)
    expect(mocks.remove).toHaveBeenCalledWith({ idempotencyKey: expect.any(String), vendorAccountDeletionRequest: { confirmation: 'DELETE' } })
  })

  it('cancels verification without deleting', async () => {
    show()
    await screen.findByText(/Your account is eligible/)
    fireEvent.click(screen.getByRole('button', { name: 'Delete account' }))
    fireEvent.change(screen.getByLabelText(/Type DELETE to confirm/), { target: { value: 'DELETE' } })
    fireEvent.click(screen.getByRole('button', { name: 'Delete account permanently' }))
    await screen.findByLabelText(/Authenticator code/)
    fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
    await waitFor(() => expect(screen.getByRole('button', { name: 'Delete account' })).toBeEnabled())
    expect(mocks.remove).not.toHaveBeenCalled()
  })

  it('keeps deletion unavailable on network failure and allows eligibility retry', async () => {
    mocks.preview.mockRejectedValueOnce(new Error('offline'))
    show()
    await waitFor(() => expect(screen.getByRole('button', { name: 'Check again' })).toBeEnabled())
    expect(screen.getByRole('button', { name: 'Delete account' })).toBeDisabled()
    fireEvent.click(screen.getByRole('button', { name: 'Check again' }))
    await screen.findByText(/Your account is eligible/)
    expect(screen.getByRole('button', { name: 'Delete account' })).toBeEnabled()
  })

  it('refreshes blockers after the server refuses a stale eligibility review', async () => {
    mocks.remove.mockImplementation(async () => {
      mocks.preview.mockResolvedValue({ data: { ...eligible, canDelete: false, blockers: { ...eligible.blockers, pendingPayments: 1 } } })
      throw new Error('Eligibility changed')
    })
    show()
    await screen.findByText(/Your account is eligible/)
    fireEvent.click(screen.getByRole('button', { name: 'Delete account' }))
    fireEvent.change(screen.getByLabelText(/Type DELETE to confirm/), { target: { value: 'DELETE' } })
    fireEvent.click(screen.getByRole('button', { name: 'Delete account permanently' }))
    await screen.findByLabelText(/Authenticator code/)
    fireEvent.change(screen.getByLabelText(/Authenticator code/), { target: { value: '123456' } })
    fireEvent.click(screen.getByRole('button', { name: 'Verify and continue' }))
    await screen.findByRole('link', { name: 'Review pending payments' })
    expect(screen.getByRole('button', { name: 'Delete account' })).toBeDisabled()
  })
})
