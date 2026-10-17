import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import * as verification from '../lib/vendor-verification-api'
import { AdminVendorVerificationQueuePage } from './PhaseThreeAdminPages'

vi.mock('../lib/vendor-verification-api', async original => ({ ...await original<typeof import('../lib/vendor-verification-api')>(), listVendorVerificationQueue: vi.fn() }))
vi.mock('./PhaseThreeAdminPages', async original => ({ ...await original<typeof import('./PhaseThreeAdminPages')>(), AdminShell: ({ children }: { children: React.ReactNode }) => <main>{children}</main> }))

beforeEach(() => vi.clearAllMocks())

test('review status is a tab row with a count per status, no All tab, and a tab applies immediately', async () => {
  vi.mocked(verification.listVendorVerificationQueue).mockResolvedValue({ items: [], meta: { total: 0, last_page: 1, status_counts: { PENDING_VERIFICATION: 4, CHANGES_REQUIRED: 2, REJECTED: 0, APPROVED: 9, EXPIRED: 1 } } })
  render(<MemoryRouter><AdminVendorVerificationQueuePage /></MemoryRouter>)
  const tabs = await screen.findAllByRole('tab')
  expect(tabs.map(tab => tab.textContent)).toEqual(['Pending Verification4', 'Changes Required2', 'Rejected0', 'Approved9', 'Expired1'])
  expect(screen.getByRole('tab', { name: /Pending Verification/ })).toHaveAttribute('aria-selected', 'true')
  expect(vi.mocked(verification.listVendorVerificationQueue).mock.calls[0]?.[0]).toMatchObject({ status: 'PENDING_VERIFICATION' })
  fireEvent.click(screen.getByRole('tab', { name: /Approved/ }))
  await waitFor(() => expect(vi.mocked(verification.listVendorVerificationQueue).mock.calls.at(-1)?.[0]).toMatchObject({ status: 'APPROVED', page: 1 }))
  expect(screen.queryByRole('button', { name: 'Apply filters' })).not.toBeInTheDocument()
})
