import { act, fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { expect, test, vi } from 'vitest'
import { PageHeader, SupportClient, SupportConversation, SupportRequestList } from '@materyalph/web-ui'
import { parseDate } from '@materyalph/api-client-ts'

const empty = { data: [], meta: { nextCursor: null }, errors: [] }

test('ticket management and conversation keep independent submissions and preserve version checks', async () => {
  const client = new SupportClient('/api/v1', 'admin')
  const ticket = { id: 'support-ticket', ticketNumber: 'SUP-EXAMPLE', subject: 'Help with an order', fullName: 'Demo Requester', email: 'requester@example.com', userType: 'GUEST' as const, category: 'ORDER_CONCERN' as const, status: 'OPEN' as const, reference: null, referenceType: null, assignedAdminId: null, assignedAdminName: null, lockVersion: 4, createdAt: new Date('2026-10-22T04:00:00Z'), updatedAt: new Date('2026-10-22T04:00:00Z') }
  vi.spyOn(client, 'ticket').mockResolvedValue({ data: ticket, meta: {}, errors: [] })
  vi.spyOn(client, 'entries').mockResolvedValue({ ...empty, data: [{ id: 'entry', kind: 'MESSAGE', actorName: 'Demo Requester', actorRole: 'GUEST', body: 'Please help me find my order.', details: {}, attachments: [], createdAt: ticket.createdAt }] })
  vi.spyOn(client, 'handlers').mockResolvedValue({ ...empty, data: [{ id: 'support-admin', name: 'Support Administrator' }] })
  const update = vi.spyOn(client, 'update').mockResolvedValue({ data: { id: ticket.id }, meta: {}, errors: [] })
  const reply = vi.spyOn(client, 'reply').mockResolvedValue({ data: { id: 'reply' }, meta: {}, errors: [] })
  render(<SupportConversation client={client} ticketId={ticket.id} admin navigation={<a href="/support">Back to Support Requests</a>} />)

  expect(await screen.findByRole('heading', { level: 1, name: ticket.subject })).toBeInTheDocument()
  expect(screen.getByRole('link', { name: 'Back to Support Requests' })).toBeInTheDocument()
  const conversation = screen.getByRole('region', { name: 'Support conversation' })
  const management = screen.getByRole('form', { name: 'Manage request' })
  await within(management).findByRole('option', { name: 'Support Administrator' })
  expect(within(conversation).getByText('Please help me find my order.')).toBeInTheDocument()
  expect(within(screen.getByRole('region', { name: 'Requester details' })).getByText(ticket.email)).toBeInTheDocument()

  fireEvent.change(within(conversation).getByRole('textbox', { name: 'Response to the user' }), { target: { value: 'We are checking your order.' } })
  fireEvent.change(within(management).getByRole('combobox', { name: 'Status' }), { target: { value: 'IN_PROGRESS' } })
  fireEvent.change(within(management).getByRole('combobox', { name: 'Assigned administrator' }), { target: { value: 'support-admin' } })
  fireEvent.change(within(management).getByRole('textbox', { name: /Reason for update/ }), { target: { value: 'Assigned for investigation.' } })
  fireEvent.submit(management)
  await waitFor(() => expect(update).toHaveBeenCalledWith(ticket.id, { lockVersion: 4, reason: 'Assigned for investigation.', status: 'IN_PROGRESS', assignedAdminId: 'support-admin' }, expect.any(String)))
  expect(reply).not.toHaveBeenCalled()
  expect(within(conversation).getByRole('textbox', { name: 'Response to the user' })).toHaveValue('We are checking your order.')

  await waitFor(() => expect(screen.getByRole('button', { name: 'Send reply' })).toBeEnabled())
  fireEvent.submit(within(conversation).getByRole('button', { name: 'Send reply' }).closest('form')!)
  await waitFor(() => expect(reply).toHaveBeenCalledWith(ticket.id, 'We are checking your order.', [], expect.any(String)))
  expect(await screen.findByText('Your reply was sent.')).toBeInTheDocument()
  expect(update).toHaveBeenCalledTimes(1)
})

test('support filters update automatically, preserve other selections and reset pagination', async () => {
  const client = new SupportClient('/api/v1', 'admin')
  const list = vi.spyOn(client, 'list').mockResolvedValue(empty)
  render(<SupportRequestList client={client} admin renderHeader={actions => <PageHeader eyebrow="User assistance" title="Support Requests" actions={actions} />} onOpen={vi.fn()} />)
  expect(screen.getByRole('button', { name: 'Refresh requests' })).toBeDisabled()
  await screen.findByText('No support requests found.')
  expect(screen.getByRole('button', { name: 'Refresh requests' }).closest('header')).not.toBeNull()
  expect(screen.getAllByRole('tab').map(tab => tab.textContent)).toEqual(['All requests', 'Open', 'In Progress', 'Waiting For User', 'Resolved', 'Closed'])
  expect(screen.getByRole('tab', { name: 'All requests' })).toHaveAttribute('aria-selected', 'true')
  expect(screen.queryByRole('button', { name: 'Apply filters' })).not.toBeInTheDocument()

  fireEvent.change(screen.getByRole('textbox', { name: 'Search requests' }), { target: { value: 'delivery' } })
  fireEvent.change(screen.getByRole('combobox', { name: 'Category' }), { target: { value: 'COMPLAINT' } })
  expect(list).toHaveBeenLastCalledWith({ category: 'COMPLAINT' }, undefined)
  fireEvent.change(screen.getByRole('combobox', { name: 'User type' }), { target: { value: 'GUEST' } })
  expect(list).toHaveBeenLastCalledWith({ category: 'COMPLAINT', userType: 'GUEST' }, undefined)
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

  // A pending search must keep a status selected during the debounce delay.
  fireEvent.change(screen.getByRole('textbox', { name: 'Search requests' }), { target: { value: 'updated search' } })
  list.mockResolvedValue(empty)
  fireEvent.click(screen.getByRole('tab', { name: 'Closed' }))
  await waitFor(() => expect(list).toHaveBeenLastCalledWith({ ...applied, status: 'CLOSED' }, undefined))
  await waitFor(() => expect(screen.queryByRole('button', { name: 'Load more requests' })).not.toBeInTheDocument())
  expect(screen.getByRole('tab', { name: 'Closed' })).toHaveAttribute('aria-selected', 'true')
  expect(screen.getByRole('textbox', { name: 'Search requests' })).toHaveValue('updated search')

  await waitFor(() => expect(list).toHaveBeenLastCalledWith({ ...applied, q: 'updated search', status: 'CLOSED' }, undefined))
  fireEvent.click(screen.getByRole('tab', { name: 'All requests' }))
  await waitFor(() => expect(list).toHaveBeenLastCalledWith({ ...applied, q: 'updated search', status: undefined }, undefined))
  expect(screen.getByRole('tab', { name: 'All requests' })).toHaveAttribute('aria-selected', 'true')
  await waitFor(() => expect(screen.getByRole('button', { name: 'Refresh requests' })).toBeEnabled())
  const calls = list.mock.calls.length
  fireEvent.click(screen.getByRole('button', { name: 'Refresh requests' }))
  await waitFor(() => expect(list).toHaveBeenCalledTimes(calls + 1))
  expect(list).toHaveBeenLastCalledWith({ ...applied, q: 'updated search', status: undefined }, undefined)
})

test('search waits until typing pauses, clears automatically and ignores late results', async () => {
  vi.useFakeTimers()
  const client = new SupportClient('/api/v1', 'admin')
  let resolveSearch: ((response: Awaited<ReturnType<SupportClient['list']>>) => void) | undefined
  const list = vi.spyOn(client, 'list').mockImplementation(filters => filters.q === 'delivery'
    ? new Promise(resolve => { resolveSearch = resolve })
    : Promise.resolve(empty))
  const view = render(<SupportRequestList client={client} admin onOpen={vi.fn()} />)
  try {
    await act(async () => {})
    const search = screen.getByRole('textbox', { name: 'Search requests' })
    fireEvent.change(search, { target: { value: 'del' } })
    await act(async () => { await vi.advanceTimersByTimeAsync(200) })
    fireEvent.change(search, { target: { value: 'delivery' } })
    await act(async () => { await vi.advanceTimersByTimeAsync(299) })
    expect(list).toHaveBeenCalledTimes(1)
    await act(async () => { await vi.advanceTimersByTimeAsync(1) })
    expect(list).toHaveBeenLastCalledWith({ q: 'delivery' }, undefined)
    expect(screen.getByText('Loading support requests…')).toBeInTheDocument()

    fireEvent.change(search, { target: { value: '' } })
    await act(async () => { await vi.advanceTimersByTimeAsync(300) })
    expect(list).toHaveBeenLastCalledWith({ q: undefined }, undefined)
    expect(screen.getByText('No support requests found.')).toBeInTheDocument()
    await act(async () => { resolveSearch?.({ ...empty, meta: { nextCursor: 'stale-search-page' } }) })
    expect(screen.queryByRole('button', { name: 'Load more requests' })).not.toBeInTheDocument()

    fireEvent.change(search, { target: { value: 'pending search' } })
    view.unmount()
    await act(async () => { await vi.advanceTimersByTimeAsync(300) })
    expect(list).toHaveBeenCalledTimes(3)
  } finally {
    view.unmount()
    vi.useRealTimers()
  }
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
