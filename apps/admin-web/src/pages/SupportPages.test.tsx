import { act, fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { expect, test, vi } from 'vitest'
import { PageHeader, SupportClient, SupportRequestList } from '@materyalph/web-ui'
import { parseDate } from '@materyalph/api-client-ts'

const empty = { data: [], meta: { nextCursor: null }, errors: [] }

test('support status tabs preserve applied filters, reset pagination and stay selected when filters are applied', async () => {
  const client = new SupportClient('/api/v1', 'admin')
  const list = vi.spyOn(client, 'list').mockResolvedValue(empty)
  render(<SupportRequestList client={client} admin renderHeader={actions => <PageHeader eyebrow="User assistance" title="Support Requests" actions={actions} />} onOpen={vi.fn()} />)
  expect(screen.getByRole('button', { name: 'Refresh requests' })).toBeDisabled()
  await screen.findByText('No support requests found.')
  expect(screen.getByRole('button', { name: 'Refresh requests' }).closest('header')).not.toBeNull()
  expect(screen.getAllByRole('tab').map(tab => tab.textContent)).toEqual(['All requests', 'Open', 'In Progress', 'Waiting For User', 'Resolved', 'Closed'])
  expect(screen.getByRole('tab', { name: 'All requests' })).toHaveAttribute('aria-selected', 'true')

  fireEvent.change(screen.getByRole('textbox', { name: 'Search requests' }), { target: { value: 'delivery' } })
  fireEvent.change(screen.getByRole('combobox', { name: 'Category' }), { target: { value: 'COMPLAINT' } })
  fireEvent.change(screen.getByRole('combobox', { name: 'User type' }), { target: { value: 'GUEST' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply filters' }))
  await waitFor(() => expect(list).toHaveBeenLastCalledWith({ q: 'delivery', category: 'COMPLAINT', userType: 'GUEST' }, undefined))
  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.change(screen.getByLabelText('To'), { target: { value: '2026-10-19' } })
  list.mockResolvedValue({ ...empty, meta: { nextCursor: 'next-page' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  const applied = { q: 'delivery', category: 'COMPLAINT', userType: 'GUEST', from: parseDate('2026-10-01'), to: parseDate('2026-10-19') }
  await waitFor(() => expect(list).toHaveBeenLastCalledWith(applied, undefined))
  fireEvent.click(await screen.findByRole('button', { name: 'Load more requests' }))
  await waitFor(() => expect(list).toHaveBeenLastCalledWith(applied, 'next-page'))

  // Switching status must not submit an unfinished search draft.
  fireEvent.change(screen.getByRole('textbox', { name: 'Search requests' }), { target: { value: 'unfinished search' } })
  list.mockResolvedValue(empty)
  fireEvent.click(screen.getByRole('tab', { name: 'Closed' }))
  await waitFor(() => expect(list).toHaveBeenLastCalledWith({ ...applied, status: 'CLOSED' }, undefined))
  await waitFor(() => expect(screen.queryByRole('button', { name: 'Load more requests' })).not.toBeInTheDocument())
  expect(screen.getByRole('tab', { name: 'Closed' })).toHaveAttribute('aria-selected', 'true')
  expect(screen.getByRole('textbox', { name: 'Search requests' })).toHaveValue('unfinished search')

  await waitFor(() => expect(screen.getByRole('button', { name: 'Apply filters' })).toBeEnabled())
  fireEvent.click(screen.getByRole('button', { name: 'Apply filters' }))
  await waitFor(() => expect(list).toHaveBeenLastCalledWith({ ...applied, q: 'unfinished search', status: 'CLOSED' }, undefined))
  fireEvent.click(screen.getByRole('tab', { name: 'All requests' }))
  await waitFor(() => expect(list).toHaveBeenLastCalledWith({ ...applied, q: 'unfinished search', status: undefined }, undefined))
  expect(screen.getByRole('tab', { name: 'All requests' })).toHaveAttribute('aria-selected', 'true')
  await waitFor(() => expect(screen.getByRole('button', { name: 'Refresh requests' })).toBeEnabled())
  const calls = list.mock.calls.length
  fireEvent.click(screen.getByRole('button', { name: 'Refresh requests' }))
  await waitFor(() => expect(list).toHaveBeenCalledTimes(calls + 1))
  expect(list).toHaveBeenLastCalledWith({ ...applied, q: 'unfinished search', status: undefined }, undefined)
})

test('support date dialog cancels safely, applies open-ended dates and clears them with All dates', async () => {
  const client = new SupportClient('/api/v1', 'admin')
  const list = vi.spyOn(client, 'list').mockResolvedValue(empty)
  render(<SupportRequestList client={client} admin onOpen={vi.fn()} />)
  await screen.findByText('No support requests found.')
  fireEvent.click(screen.getByRole('tab', { name: 'Open' }))
  await waitFor(() => expect(list).toHaveBeenLastCalledWith({ status: 'OPEN' }, undefined))
  const calls = list.mock.calls.length

  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  expect(screen.getByRole('dialog', { name: 'Request received dates' })).toHaveTextContent('Inclusive calendar dates in Asia/Manila.')
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.click(screen.getByRole('button', { name: 'Cancel' }))
  expect(list).toHaveBeenCalledTimes(calls)

  fireEvent.click(screen.getByRole('button', { name: 'All dates' }))
  expect(screen.getByLabelText('From')).toHaveValue('')
  fireEvent.change(screen.getByLabelText('From'), { target: { value: '2026-10-01' } })
  fireEvent.click(screen.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(list).toHaveBeenLastCalledWith({ status: 'OPEN', from: parseDate('2026-10-01'), to: undefined }, undefined))

  fireEvent.click(screen.getByRole('button', { name: /^From / }))
  const dialog = within(screen.getByRole('dialog', { name: 'Request received dates' }))
  fireEvent.click(dialog.getByRole('button', { name: 'All dates' }))
  fireEvent.click(dialog.getByRole('button', { name: 'Apply' }))
  await waitFor(() => expect(list).toHaveBeenLastCalledWith({ status: 'OPEN', from: undefined, to: undefined }, undefined))
  expect(screen.getByRole('button', { name: 'All dates' })).toBeInTheDocument()
})

test('keyboard status changes ignore a late response from the previous status', async () => {
  const client = new SupportClient('/api/v1', 'admin')
  let resolveOpen: ((response: Awaited<ReturnType<SupportClient['list']>>) => void) | undefined
  vi.spyOn(client, 'list').mockImplementation(filters => filters.status === 'OPEN'
    ? new Promise(resolve => { resolveOpen = resolve })
    : Promise.resolve(empty))
  render(<SupportRequestList client={client} admin onOpen={vi.fn()} />)
  await screen.findByText('No support requests found.')
  fireEvent.click(screen.getByRole('tab', { name: 'Open' }))
  expect(await screen.findByText('Loading support requests…')).toBeInTheDocument()
  const openTab = screen.getByRole('tab', { name: 'Open' })
  openTab.focus()
  fireEvent.keyDown(openTab, { key: 'ArrowRight' })
  await screen.findByText('No support requests found.')
  const selected = screen.getByRole('tab', { name: 'In Progress' })
  expect(selected).toHaveAttribute('aria-selected', 'true')
  expect(selected).toHaveFocus()

  await act(async () => { resolveOpen?.({ ...empty, meta: { nextCursor: 'stale-open-page' } }) })
  expect(screen.queryByRole('button', { name: 'Load more requests' })).not.toBeInTheDocument()
  expect(selected).toHaveAttribute('aria-selected', 'true')
})
