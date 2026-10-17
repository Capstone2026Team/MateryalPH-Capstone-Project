import { act, cleanup, fireEvent, render, screen, waitFor, within } from '@testing-library/react'
import { MemoryRouter, useLocation } from 'react-router-dom'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import type { ChatMessage, ConversationDetail, FulfillmentConversationSummary } from '@materyalph/api-client-ts'
import { chatApi, watchConversation } from '../lib/messaging-api'
import { FulfillmentConversationDialog } from './FulfillmentConversationDialog'
import { MessagingWorkspace } from './MessagingPage'

vi.mock('../lib/messaging-api', async original => ({
  ...await original<typeof import('../lib/messaging-api')>(),
  chatApi: { get: vi.fn(), list: vi.fn(), projectInquiries: vi.fn(), fulfillmentConversations: vi.fn(), send: vi.fn(), read: vi.fn(), typing: vi.fn(), upload: vi.fn(), download: vi.fn() },
  watchConversation: vi.fn(),
}))

const message: ChatMessage = { id: 'm-2', clientMessageId: 'client-2', body: 'Pickup is ready', kind: 'TEXT', sender: { displayName: 'Buyer', role: 'BUYER' }, sentAt: '2026-10-07T08:00:00Z', mine: false, attachments: [], readByRecipient: false }
function detail(id = 'fulfillment-1', readOnly = false): ConversationDetail {
  return {
    conversation: { id, purpose: id === 'sales-1' ? 'SALES' : 'FULFILLMENT', contextType: 'ITEM_BASED', lockVersion: 1, store: { id: 'store-1', name: 'Supply', verified: true }, buyer: { displayName: 'Buyer One', role: 'BUYER' }, unreadCount: 1,
      channel: `channel-${id}`, lockedReference: {}, updatedAt: '2026-10-07T08:00:00Z', canTransfer: false, fulfillmentEntryEnabled: id !== 'sales-1', readOnly, ...(readOnly ? { readOnlyReason: 'ORDER_COMPLETED' } : {}),
      canListFulfillmentConversations: id === 'sales-1', ...(id === 'sales-1' ? {} : { orderId: 'order-1', orderReference: 'ORD-ONE' }) },
    messages: { items: [{ ...message, body: id === 'sales-1' ? 'Inquiry text' : message.body }], hasMore: false },
    quotations: { versions: [], hasMore: false },
  }
}
const row: FulfillmentConversationSummary = { conversationId: 'fulfillment-1', orderId: 'order-1', orderReference: 'ORD-ONE', orderState: 'READY_FOR_PICKUP', fulfillmentMethod: 'PICKUP', unreadCount: 1, updatedAt: new Date('2026-10-07T08:00:00Z'), readOnly: false }
const stop = vi.fn()
beforeEach(() => {
  vi.resetAllMocks()
  vi.mocked(watchConversation).mockResolvedValue(stop)
  vi.mocked(chatApi.get).mockImplementation(async id => detail(id))
  vi.mocked(chatApi.list).mockResolvedValue({ items: [detail('sales-1').conversation], page: 1, hasMore: false })
  vi.mocked(chatApi.fulfillmentConversations).mockResolvedValue({ items: [row], page: 1, hasMore: false })
  vi.mocked(chatApi.read).mockResolvedValue({ data: {}, meta: {}, errors: [] })
  vi.mocked(chatApi.typing).mockResolvedValue({ data: {}, meta: {}, errors: [] })
})
afterEach(cleanup)
function Location() { return <output aria-label="Location">{useLocation().search}</output> }

test('buyer inquiry retains draft, selection and scroll while its fulfillment popup opens and closes', async () => {
  render(<MemoryRouter initialEntries={['/messages?conversation=sales-1']}><Location /><MessagingWorkspace role="PUBLISHER" /></MemoryRouter>)
  const composer = await screen.findByRole('textbox', { name: 'Message' })
  fireEvent.change(composer, { target: { value: 'Unsent inquiry draft' } })
  const body = screen.getByText('Inquiry text').closest('.chat-thread-body')!
  body.scrollTop = 35
  const trigger = screen.getByRole('button', { name: 'Fulfillment conversations' })
  trigger.focus(); fireEvent.click(trigger)
  const dialog = await screen.findByRole('dialog', { name: 'Fulfillment conversations' })
  fireEvent.click(await within(dialog).findByRole('button', { name: /ORD-ONE/ }))
  await within(dialog).findByText('Pickup is ready')
  expect(within(dialog).queryByRole('button', { name: 'Quotation history' })).not.toBeInTheDocument()
  expect(within(dialog).queryByRole('button', { name: 'Attach product' })).not.toBeInTheDocument()
  expect(screen.getByLabelText('Location')).toHaveTextContent('?conversation=sales-1')
  expect(composer).toHaveValue('Unsent inquiry draft')
  expect(body.scrollTop).toBe(35)
  fireEvent.click(within(dialog).getByRole('button', { name: 'Back to conversations' }))
  await within(dialog).findByRole('button', { name: /ORD-ONE/ })
  fireEvent.click(within(dialog).getByRole('button', { name: 'Close fulfillment conversations' }))
  expect(screen.queryByRole('dialog')).not.toBeInTheDocument()
  expect(trigger).toHaveFocus()
  expect(composer).toHaveValue('Unsent inquiry draft')
  expect(stop).toHaveBeenCalled()
})

test('list supports pagination, empty and retry states; completed history has no composer', async () => {
  vi.mocked(chatApi.fulfillmentConversations).mockRejectedValueOnce(new Error('Offline'))
    .mockResolvedValueOnce({ items: [row], page: 1, hasMore: true })
    .mockResolvedValueOnce({ items: [], page: 2, hasMore: false })
    .mockResolvedValue({ items: [{ ...row, readOnly: true, orderState: 'COMPLETED' }], page: 1, hasMore: false })
  vi.mocked(chatApi.get).mockResolvedValue(detail('fulfillment-1', true))
  render(<MemoryRouter><FulfillmentConversationDialog inquiryId="sales-1" onClose={vi.fn()} /></MemoryRouter>)
  fireEvent.click(await screen.findByRole('button', { name: 'Try again' }))
  await screen.findByRole('button', { name: /ORD-ONE/ })
  fireEvent.click(screen.getByRole('button', { name: 'Next' }))
  await screen.findByText(/No fulfillment conversations yet/)
  expect(chatApi.fulfillmentConversations).toHaveBeenLastCalledWith('sales-1', 2)
  fireEvent.click(screen.getByRole('button', { name: 'Previous' }))
  fireEvent.click(await screen.findByRole('button', { name: /ORD-ONE/ }))
  await screen.findByText(/Fulfillment messages are read-only/)
  expect(screen.queryByRole('textbox', { name: 'Message' })).not.toBeInTheDocument()
})

test('thread reuses retry keys, read receipts, history paging, image uploads and realtime cleanup', async () => {
  vi.mocked(chatApi.get).mockResolvedValue({ ...detail(), messages: { items: [message], hasMore: true, nextBefore: 'm-2' } })
  vi.mocked(chatApi.send).mockRejectedValueOnce(new Error('Offline')).mockResolvedValue({ data: { id: 'saved' }, meta: {}, errors: [] })
  const { unmount } = render(<MemoryRouter><FulfillmentConversationDialog conversationId="fulfillment-1" onClose={vi.fn()} /></MemoryRouter>)
  await screen.findByText('Pickup is ready')
  await waitFor(() => expect(chatApi.read).toHaveBeenCalledWith('fulfillment-1', 'm-2'))
  vi.mocked(chatApi.get).mockResolvedValue({ ...detail(), messages: { items: [{ ...message, id: 'm-1', body: 'Earlier pickup instructions' }], hasMore: false } })
  fireEvent.click(screen.getByRole('button', { name: 'Earlier messages' }))
  await screen.findByText('Earlier pickup instructions')
  expect(chatApi.get).toHaveBeenCalledWith('fulfillment-1', 'm-2')
  fireEvent.change(screen.getByRole('textbox', { name: 'Message' }), { target: { value: 'I am coming' } })
  fireEvent.click(screen.getByRole('button', { name: 'Send message' }))
  fireEvent.click(await screen.findByRole('button', { name: 'Failed to send · Retry' }))
  await waitFor(() => expect(chatApi.send).toHaveBeenCalledTimes(2))
  expect(vi.mocked(chatApi.send).mock.calls[0]).toEqual(vi.mocked(chatApi.send).mock.calls[1])
  const input = document.querySelector<HTMLInputElement>('input[type=file]')!
  expect(input.accept).toBe('image/png,image/jpeg')
  const file = new File(['image'], 'pickup.png', { type: 'image/png' })
  await act(async () => { fireEvent.change(input, { target: { files: [file] } }) })
  expect(chatApi.upload).toHaveBeenCalledWith('fulfillment-1', file, expect.any(String))
  await waitFor(() => expect(watchConversation).toHaveBeenCalled())
  unmount()
  expect(stop).toHaveBeenCalled()
})

test('realtime reload applies closure and a revoked conversation stops exposing its content', async () => {
  render(<MemoryRouter><FulfillmentConversationDialog conversationId="fulfillment-1" onClose={vi.fn()} /></MemoryRouter>)
  await screen.findByRole('textbox', { name: 'Message' })
  await waitFor(() => expect(watchConversation).toHaveBeenCalled())
  const refresh = vi.mocked(watchConversation).mock.calls[0]![1]
  vi.mocked(chatApi.get).mockResolvedValue(detail('fulfillment-1', true))
  act(() => refresh())
  await screen.findByText(/Fulfillment messages are read-only/)
  expect(screen.queryByRole('textbox', { name: 'Message' })).not.toBeInTheDocument()
  vi.mocked(chatApi.get).mockRejectedValue(new Error('Conversation access revoked'))
  act(() => refresh())
  await screen.findByText('Conversation access revoked')
  expect(screen.queryByText('Pickup is ready')).not.toBeInTheDocument()
  await waitFor(() => expect(stop).toHaveBeenCalled())
})

test('the inquiry fulfillment badge refreshes received and read counts while retaining its draft', async () => {
  vi.mocked(chatApi.get).mockImplementation(async id => {
    const value = detail(id)
    return { ...value, conversation: { ...value.conversation, fulfillmentUnreadCount: 120 } }
  })
  render(<MemoryRouter initialEntries={['/messages?conversation=sales-1']}><MessagingWorkspace role="PUBLISHER" /></MemoryRouter>)
  const button = await screen.findByRole('button', { name: 'Fulfillment conversations' })
  expect(within(button).getByText('99+')).toBeInTheDocument()
  expect(button).toHaveAccessibleDescription('120 unread fulfillment messages')
  const composer = screen.getByRole('textbox', { name: 'Message' })
  fireEvent.change(composer, { target: { value: 'Keep this unsent inquiry' } })
  vi.mocked(chatApi.get).mockImplementation(async id => {
    const value = detail(id)
    return { ...value, conversation: { ...value.conversation, fulfillmentUnreadCount: 2 } }
  })
  act(() => window.dispatchEvent(new Event('materyalph:domain-refresh')))
  await within(button).findByText('2')
  expect(composer).toHaveValue('Keep this unsent inquiry')
  vi.mocked(chatApi.get).mockImplementation(async id => {
    const value = detail(id)
    return { ...value, conversation: { ...value.conversation, fulfillmentUnreadCount: 0 } }
  })
  act(() => window.dispatchEvent(new Event('materyalph:navigation-updates')))
  await waitFor(() => expect(button.querySelector('.portal-count-badge')).toBeNull())
  expect(composer).toHaveValue('Keep this unsent inquiry')
})

test('fulfillment list badges update without navigating and disappear when read', async () => {
  render(<MemoryRouter><FulfillmentConversationDialog inquiryId="sales-1" onClose={vi.fn()} /></MemoryRouter>)
  const button = await screen.findByRole('button', { name: /ORD-ONE/ })
  expect(within(button).getByText('1')).toHaveClass('portal-count-badge')
  vi.mocked(chatApi.fulfillmentConversations).mockResolvedValue({ items: [{ ...row, unreadCount: 3 }], page: 1, hasMore: false })
  act(() => window.dispatchEvent(new Event('materyalph:domain-refresh')))
  await within(button).findByText('3')
  vi.mocked(chatApi.fulfillmentConversations).mockResolvedValue({ items: [{ ...row, unreadCount: 0 }], page: 1, hasMore: false })
  act(() => window.dispatchEvent(new Event('materyalph:navigation-updates')))
  await waitFor(() => expect(button.querySelector('.portal-count-badge')).toBeNull())
  expect(chatApi.read).not.toHaveBeenCalled()
})

test('an inquiry without the server capability does not offer the fulfillment list', async () => {
  const restricted = detail('sales-1')
  restricted.conversation.canListFulfillmentConversations = false
  vi.mocked(chatApi.get).mockResolvedValue(restricted)
  render(<MemoryRouter initialEntries={['/messages?conversation=sales-1']}><MessagingWorkspace role="CUSTOMER_SERVICE" /></MemoryRouter>)
  await screen.findByText('Inquiry text')
  expect(screen.queryByRole('button', { name: 'Fulfillment conversations' })).not.toBeInTheDocument()
  expect(chatApi.fulfillmentConversations).not.toHaveBeenCalled()
})

test('inbox badges identify each buyer and synchronize sales and fulfillment counts without resetting search', async () => {
  const first = { ...detail('sales-1').conversation, unreadCount: 1, fulfillmentUnreadCount: 120 }
  const second = { ...first, id: 'sales-2', buyer: { displayName: 'Buyer Two', role: 'BUYER' }, unreadCount: 0, fulfillmentUnreadCount: 0 }
  vi.mocked(chatApi.list).mockResolvedValue({ items: [first, second], page: 1, hasMore: false })
  render(<MemoryRouter initialEntries={['/messages']}><MessagingWorkspace role="PUBLISHER" /></MemoryRouter>)
  const inbox = within(screen.getByRole('complementary', { name: 'Conversation inbox' }))
  const firstButton = await inbox.findByRole('button', { name: /Buyer One/ })
  expect(within(firstButton).getByText('99+')).toHaveClass('portal-count-badge')
  expect(firstButton).toHaveAccessibleName(/121 unread messages/)
  expect(inbox.getByRole('button', { name: /Buyer Two/ }).querySelector('.portal-count-badge')).toBeNull()
  const search = inbox.getByRole('searchbox')
  fireEvent.change(search, { target: { value: 'Buyer One' } })
  vi.mocked(chatApi.list).mockResolvedValue({ items: [{ ...first, unreadCount: 0, fulfillmentUnreadCount: 2 }, { ...second, unreadCount: 3 }], page: 1, hasMore: false })
  act(() => window.dispatchEvent(new Event('materyalph:domain-refresh')))
  await within(firstButton).findByText('2')
  expect(firstButton).toHaveAccessibleName(/2 unread messages/)
  expect(search).toHaveValue('Buyer One')
  expect(inbox.queryByRole('button', { name: /Buyer Two/ })).not.toBeInTheDocument()
  fireEvent.change(search, { target: { value: '' } })
  expect(within(inbox.getByRole('button', { name: /Buyer Two/ })).getByText('3')).toHaveClass('portal-count-badge')
  vi.mocked(chatApi.list).mockResolvedValue({ items: [{ ...first, unreadCount: 0, fulfillmentUnreadCount: 0 }, { ...second, unreadCount: 3 }], page: 1, hasMore: false })
  act(() => window.dispatchEvent(new Event('materyalph:navigation-updates')))
  await waitFor(() => expect(firstButton.querySelector('.portal-count-badge')).toBeNull())
  expect(firstButton).not.toHaveAccessibleName(/unread messages/)
  expect(chatApi.read).not.toHaveBeenCalled()
})

test('inbox only includes fulfillment aggregates allowed by the server capability', async () => {
  const restricted = { ...detail('sales-1').conversation, canListFulfillmentConversations: false, fulfillmentUnreadCount: 120 }
  const fulfillment = { ...detail('fulfillment-1').conversation, unreadCount: 2, fulfillmentUnreadCount: 120 }
  vi.mocked(chatApi.list).mockResolvedValue({ items: [restricted, fulfillment], page: 1, hasMore: false })
  render(<MemoryRouter initialEntries={['/messages']}><MessagingWorkspace role="CUSTOMER_SERVICE" /></MemoryRouter>)
  const inbox = within(screen.getByRole('complementary', { name: 'Conversation inbox' }))
  const buttons = await inbox.findAllByRole('button', { name: /Buyer One/ })
  expect(buttons[0]).toHaveAccessibleName(/1 unread messages/)
  expect(within(buttons[0]!).getByText('1')).toHaveClass('portal-count-badge')
  expect(buttons[1]).toHaveAccessibleName(/2 unread messages/)
  expect(within(buttons[1]!).getByText('2')).toHaveClass('portal-count-badge')
  expect(inbox.queryByText('99+')).not.toBeInTheDocument()
})

test('reading an inquiry retains its buyer fulfillment badge until those messages are read', async () => {
  const inquiry = { ...detail('sales-1').conversation, fulfillmentUnreadCount: 3 }
  vi.mocked(chatApi.list).mockResolvedValue({ items: [inquiry], page: 1, hasMore: false })
  vi.mocked(chatApi.read).mockImplementation(async () => {
    vi.mocked(chatApi.list).mockResolvedValue({ items: [{ ...inquiry, unreadCount: 0 }], page: 1, hasMore: false })
    return { data: {}, meta: {}, errors: [] }
  })
  render(<MemoryRouter initialEntries={['/messages?conversation=sales-1']}><Location /><MessagingWorkspace role="PUBLISHER" /></MemoryRouter>)
  const inbox = within(screen.getByRole('complementary', { name: 'Conversation inbox' }))
  const buyer = await inbox.findByRole('button', { name: /Buyer One/ })
  await within(buyer).findByText('3')
  expect(chatApi.read).toHaveBeenCalledWith('sales-1', 'm-2')
  const composer = screen.getByRole('textbox', { name: 'Message' })
  fireEvent.change(composer, { target: { value: 'Keep this draft' } })
  vi.mocked(chatApi.list).mockResolvedValue({ items: [{ ...inquiry, unreadCount: 0, fulfillmentUnreadCount: 0 }], page: 1, hasMore: false })
  act(() => window.dispatchEvent(new Event('materyalph:navigation-updates')))
  await waitFor(() => expect(buyer.querySelector('.portal-count-badge')).toBeNull())
  expect(screen.getByLabelText('Location')).toHaveTextContent('?conversation=sales-1')
  expect(composer).toHaveValue('Keep this draft')
})

test('inbox clears private badges on session end and ignores late responses', async () => {
  render(<MemoryRouter initialEntries={['/messages']}><MessagingWorkspace role="PUBLISHER" /></MemoryRouter>)
  const inbox = within(screen.getByRole('complementary', { name: 'Conversation inbox' }))
  await inbox.findByRole('button', { name: /Buyer One/ })
  let resolve!: (value: Awaited<ReturnType<typeof chatApi.list>>) => void
  vi.mocked(chatApi.list).mockReturnValueOnce(new Promise(value => { resolve = value }))
  act(() => window.dispatchEvent(new Event('materyalph:domain-refresh')))
  await waitFor(() => expect(chatApi.list).toHaveBeenCalledTimes(2))
  act(() => window.dispatchEvent(new Event('materyalph:session-cleared')))
  expect(inbox.queryByRole('button', { name: /Buyer One/ })).not.toBeInTheDocument()
  await act(async () => { resolve({ items: [detail('sales-1').conversation], page: 1, hasMore: false }) })
  expect(inbox.queryByRole('button', { name: /Buyer One/ })).not.toBeInTheDocument()
  expect(stop).toHaveBeenCalled()
})


test('project inquiry opens inside the main item thread and preserves its draft and unread project count', async () => {
  const main = detail('sales-1')
  main.conversation.projectUnreadCount = 2
  main.conversation.projectInquiryCount = 1
  main.conversation.mainConversationId = 'sales-1'
  const project: ConversationDetail = { ...detail('sales-1'),
    conversation: { ...detail('sales-1').conversation, id: 'project-1', contextType: 'PROJECT_BASED', inquiryLabel: 'Foundation', canListFulfillmentConversations: false, lockedReference: { work_package: { name: 'Foundation', lines: [] } } },
    messages: { items: [{ ...message, id: 'project-message', body: 'Foundation inquiry text' }], hasMore: false },
  }
  vi.mocked(chatApi.get).mockImplementation(async id => id === 'sales-1' ? main : project)
  vi.mocked(chatApi.list).mockResolvedValue({ items: [{ ...main.conversation, unreadCount: 2 }], page: 1, hasMore: false })
  vi.mocked(chatApi.projectInquiries).mockResolvedValue({ items: [project.conversation], page: 1, hasMore: false })
  render(<MemoryRouter initialEntries={['/messages?conversation=sales-1']}><Location /><MessagingWorkspace role="PUBLISHER" /></MemoryRouter>)
  const composer = await screen.findByRole('textbox', { name: 'Message' })
  fireEvent.change(composer, { target: { value: 'Keep my item draft' } })
  fireEvent.click(screen.getByRole('button', { name: /Project inquiries/ }))
  const dialog = await screen.findByRole('dialog', { name: 'Project inquiries' })
  fireEvent.click(await within(dialog).findByRole('button', { name: /Foundation/ }))
  await within(dialog).findByText('Foundation inquiry text')
  expect(within(dialog).getByRole('button', { name: 'Quotation history' })).toBeInTheDocument()
  expect(screen.getByLabelText('Location')).toHaveTextContent('?conversation=sales-1')
  expect(composer).toHaveValue('Keep my item draft')
  fireEvent.click(within(dialog).getByRole('button', { name: 'Back to project inquiries' }))
  await within(dialog).findByRole('button', { name: /Foundation/ })
  fireEvent.click(within(dialog).getByRole('button', { name: 'Close project inquiries' }))
  expect(composer).toHaveValue('Keep my item draft')
  const inbox = within(screen.getByRole('complementary', { name: 'Conversation inbox' }))
  expect((await inbox.findAllByRole('button', { name: /Buyer One/ })).length).toBe(1)
  expect(within(await inbox.findByRole('button', { name: /Buyer One/ })).getByText('2')).toBeInTheDocument()
})
