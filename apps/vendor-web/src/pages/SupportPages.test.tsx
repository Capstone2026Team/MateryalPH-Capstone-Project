import { act, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { describe, expect, it, vi } from 'vitest'
import { ResponseError } from '@materyalph/api-client-ts'
import { SupportClient, SupportRequestForm, SupportRequestList, SupportConversation } from '@materyalph/web-ui'

const receipt = { id: 'ticket-id', ticketNumber: 'SUP-EXAMPLE', status: 'OPEN' as const }
const ticket = { ...receipt, subject: 'Technical issue', fullName: 'Buyer Name', email: 'buyer@example.com', userType: 'BUYER' as const, category: 'TECHNICAL_ISSUE' as const, reference: null, referenceType: null, assignedAdminId: null, assignedAdminName: null, lockVersion: 1, createdAt: new Date('2026-10-19T00:00:00Z'), updatedAt: new Date('2026-10-19T00:00:00Z') }
const meta = { nextCursor: null }

describe('Support forms and conversation', () => {
  it('submits the account identity once while pending and displays the ticket confirmation', async () => {
    const client = new SupportClient('/api/v1', 'vendors')
    let complete: ((result: Awaited<ReturnType<SupportClient['create']>>) => void) | undefined
    const create = vi.spyOn(client, 'create').mockImplementation(() => new Promise(resolve => { complete = resolve }))
    const { container } = render(<SupportRequestForm client={client} identity={{ fullName: 'Vendor Owner', email: 'vendor@example.com', userType: 'VENDOR' }} />)
    expect(screen.getByLabelText(/Full name/)).toHaveAttribute('readonly')
    fireEvent.change(screen.getByLabelText(/Subject/), { target: { value: 'Need assistance' } })
    fireEvent.change(screen.getByLabelText(/Message \/ Description/), { target: { value: 'Please investigate this issue.' } })
    fireEvent.click(screen.getByRole('checkbox'))
    const form = container.querySelector('form')!
    fireEvent.submit(form); fireEvent.submit(form)
    expect(create).toHaveBeenCalledTimes(1)
    expect(create.mock.calls[0]?.[0]).toMatchObject({ fullName: 'Vendor Owner', email: 'vendor@example.com', userType: 'VENDOR', privacyAcknowledged: true })
    await act(async () => { complete?.({ data: receipt, meta: {}, errors: [] }) })
    expect(await screen.findByText('Ticket SUP-EXAMPLE')).toBeInTheDocument()
  })

  it('keeps the idempotency key for an unchanged retry and replaces it when the draft changes', async () => {
    const client = new SupportClient('/api/v1', 'guest')
    const create = vi.spyOn(client, 'create').mockRejectedValue(new Error('Connection lost'))
    const { container } = render(<SupportRequestForm client={client} />)
    const form = container.querySelector('form')!
    fireEvent.submit(form)
    await screen.findByText('Connection lost')
    fireEvent.submit(form)
    await waitFor(() => expect(create).toHaveBeenCalledTimes(2))
    expect(create.mock.calls[1]?.[1]).toBe(create.mock.calls[0]?.[1])
    await waitFor(() => expect(screen.getByRole('button', { name: 'Submit inquiry' })).toBeEnabled())
    fireEvent.change(screen.getByLabelText(/Subject/), { target: { value: 'A different concern' } })
    fireEvent.submit(form)
    await waitFor(() => expect(create).toHaveBeenCalledTimes(3))
    expect(create.mock.calls[2]?.[1]).not.toBe(create.mock.calls[1]?.[1])
  })

  it('shows an empty request list and opens persisted tickets', async () => {
    const client = new SupportClient('/api/v1', 'vendors')
    const list = vi.spyOn(client, 'list').mockResolvedValue({ data: [], meta, errors: [] })
    const open = vi.fn()
    render(<SupportRequestList client={client} onOpen={open} />)
    expect(await screen.findByText('No support requests found.')).toBeInTheDocument()
    list.mockResolvedValue({ data: [ticket], meta, errors: [] })
    fireEvent.click(screen.getByRole('button', { name: 'Refresh requests' }))
    fireEvent.click(await screen.findByRole('button', { name: /Technical issue/ }))
    expect(open).toHaveBeenCalledWith(ticket.id)
  })

  it('shows closed ticket history without allowing a reply', async () => {
    const client = new SupportClient('/api/v1', 'vendors')
    vi.spyOn(client, 'ticket').mockResolvedValue({ data: { ...ticket, status: 'CLOSED' }, meta: {}, errors: [] })
    vi.spyOn(client, 'entries').mockResolvedValue({ data: [], meta, errors: [] })
    render(<SupportConversation client={client} ticketId={ticket.id} />)
    expect(await screen.findByText(/This request is closed/)).toBeInTheDocument()
    expect(screen.queryByRole('button', { name: 'Send reply' })).not.toBeInTheDocument()
  })

  it('clears private ticket content when a refresh loses authorization', async () => {
    const client = new SupportClient('/api/v1', 'vendors')
    const detail = vi.spyOn(client, 'ticket').mockResolvedValue({ data: ticket, meta: {}, errors: [] })
    vi.spyOn(client, 'entries').mockResolvedValue({ data: [], meta, errors: [] })
    render(<SupportConversation client={client} ticketId={ticket.id} />)
    expect(await screen.findByText(ticket.subject)).toBeInTheDocument()
    detail.mockRejectedValue(new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'UNAUTHENTICATED', message: 'Sign in again.', details: {} }] }), { status: 401, headers: { 'Content-Type': 'application/json' } })))
    fireEvent.click(screen.getByRole('button', { name: 'Refresh conversation' }))
    await waitFor(() => expect(screen.queryByText(ticket.subject)).not.toBeInTheDocument())
    expect(screen.queryByRole('button', { name: 'Send reply' })).not.toBeInTheDocument()
  })
})
