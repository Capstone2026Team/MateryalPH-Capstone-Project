import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { beforeEach, expect, test, vi } from 'vitest'
import { ResponseError, type AccountMembershipListEnvelope, type VendorTeamPerformanceEnvelope } from '@materyalph/api-client-ts'
import { VendorTeamActivity } from '@materyalph/web-ui'

const first = { id: 'first', name: 'First Employee', role: 'INVENTORY', status: 'ACTIVE', canManageStaff: false }
const second = { ...first, id: 'second', name: 'Second Employee' }
const envelope = (data = [first, second]): AccountMembershipListEnvelope => ({ data, meta: { current_page: 1, last_page: 1 }, errors: [] })
const explainError = async () => 'Unable to load this team.'
const props = () => ({
  listMembers: vi.fn(async () => envelope()),
  performance: vi.fn(() => new Promise<VendorTeamPerformanceEnvelope>(() => {})),
  list: vi.fn(async () => ({ data: [], meta: { currentPage: 1, lastPage: 1, total: 0, totalEvents: 0, succeededEvents: 0, failedEvents: 0, categories: [] }, errors: [] })),
  watchUpdates: vi.fn(async () => () => {}),
  canManageManagers: true,
  explainError,
})

beforeEach(() => {
  vi.stubGlobal('ResizeObserver', class { observe() {} disconnect() {} })
  vi.stubGlobal('matchMedia', () => ({ matches: false, addEventListener() {}, removeEventListener() {} }))
})

test('waits for the authorized list, opens its first account and preserves a manual selection across filtering', async () => {
  const input = props()
  let resolve!: (value: AccountMembershipListEnvelope) => void
  input.listMembers.mockImplementationOnce(() => new Promise(done => { resolve = done }))
  render(<VendorTeamActivity {...input} />)
  await waitFor(() => expect(input.listMembers).toHaveBeenCalledOnce())
  expect(input.performance).not.toHaveBeenCalled()
  expect(document.querySelector('.team-tracking-workspace')).toHaveAttribute('data-tutorial-member-loading', 'true')
  await act(async () => resolve(envelope()))
  await waitFor(() => expect(screen.getByRole('button', { name: /First Employee/ })).toHaveAttribute('aria-pressed', 'true'))
  await waitFor(() => expect(input.performance).toHaveBeenCalledWith(expect.objectContaining({ memberId: 'first' })))
  fireEvent.click(screen.getByRole('button', { name: /Second Employee/ }))
  await waitFor(() => expect(input.performance).toHaveBeenLastCalledWith(expect.objectContaining({ memberId: 'second' })))
  input.listMembers.mockResolvedValue(envelope([first]))
  fireEvent.change(screen.getByRole('searchbox', { name: /Find a team member/ }), { target: { value: 'First' } })
  await waitFor(() => expect(input.listMembers).toHaveBeenCalledWith(expect.objectContaining({ search: 'First' })))
  expect(screen.getByRole('heading', { name: 'Second Employee' })).toBeInTheDocument()
  expect(screen.getByRole('button', { name: /First Employee/ })).toHaveAttribute('aria-pressed', 'false')
  input.listMembers.mockResolvedValue(envelope([]))
  fireEvent.change(screen.getByRole('searchbox', { name: /Find a team member/ }), { target: { value: 'No match' } })
  await waitFor(() => expect(input.listMembers).toHaveBeenCalledWith(expect.objectContaining({ search: 'No match' })))
  expect(document.querySelector('.team-tracking-workspace')).toHaveAttribute('data-tutorial-members-empty', 'false')
  fireEvent.click(screen.getByRole('button', { name: 'Activity history' }))
  await waitFor(() => expect(input.list).toHaveBeenCalledWith(expect.objectContaining({ memberId: 'second' })))
})

test('an empty team makes no member requests and can select the first account when one becomes available', async () => {
  const input = props()
  input.listMembers.mockResolvedValueOnce(envelope([]))
  render(<VendorTeamActivity {...input} />)
  await screen.findByText(/No team members match/)
  expect(input.performance).not.toHaveBeenCalled()
  expect(input.list).not.toHaveBeenCalled()
  expect(document.querySelector('.team-tracking-workspace')).toHaveAttribute('data-tutorial-member-loading', 'false')
  fireEvent.change(screen.getByRole('searchbox', { name: /Find a team member/ }), { target: { value: 'First' } })
  await waitFor(() => expect(input.performance).toHaveBeenCalledWith(expect.objectContaining({ memberId: 'first' })))
})

test('denied member access never opens an account; retry waits for a newly authorized list', async () => {
  const input = props()
  input.listMembers.mockRejectedValueOnce(new ResponseError(new Response(null, { status: 403 })))
  render(<VendorTeamActivity {...input} />)
  await screen.findByRole('alert')
  expect(input.performance).not.toHaveBeenCalled()
  expect(input.list).not.toHaveBeenCalled()
  expect(document.querySelector('.team-tracking-workspace')).toHaveAttribute('data-tutorial-member-selected', 'false')
  fireEvent.click(screen.getByRole('button', { name: 'Retry team list' }))
  await waitFor(() => expect(input.performance).toHaveBeenCalledWith(expect.objectContaining({ memberId: 'first' })))
})
