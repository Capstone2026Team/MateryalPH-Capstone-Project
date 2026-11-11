import { fireEvent, render, screen, waitFor } from '@testing-library/react'
import { MemoryRouter, useLocation } from 'react-router-dom'
import { beforeEach, expect, test, vi } from 'vitest'
import type { ConversationView } from '@materyalph/api-client-ts'
import { chatApi } from '../lib/messaging-api'
import { MessagingWorkspace } from './MessagingPage'

vi.mock('../lib/messaging-api', () => ({ chatApi: { list: vi.fn() }, loadChatAvatar: vi.fn(), readableChatError: async () => 'Inbox unavailable', watchConversation: async () => () => {} }))
vi.mock('./ConversationThread', () => ({ ConversationThread: ({ selected, onBack }: { selected: string | null; onBack: () => void }) => <section aria-label="Selected thread"><p>{selected ?? 'No thread selected'}</p><button onClick={onBack}>Back to inbox</button></section> }))

const rows = [{ id: 'first', purpose: 'SALES', contextType: 'ITEM_BASED', buyerThreadId: 'buyer-first', unreadCount: 0, store: { name: 'Sample' } }, { id: 'second', purpose: 'SALES', contextType: 'ITEM_BASED', unreadCount: 0, store: { name: 'Sample' } }] as ConversationView[]
function Address() { return <output aria-label="Current URL">{useLocation().search}</output> }
function open(path = '/messages?source=menu') { render(<MemoryRouter initialEntries={[path]}><MessagingWorkspace role="PUBLISHER" /><Address /></MemoryRouter>) }
beforeEach(() => { vi.mocked(chatApi.list).mockReset().mockResolvedValue({ items: rows, hasMore: false, page: 1 }) })

test('opening Messages selects the first available thread and retains unrelated URL context', async () => {
  open()
  await waitFor(() => expect(screen.getByLabelText('Current URL')).toHaveTextContent('conversation=first'))
  expect(screen.getByLabelText('Current URL')).toHaveTextContent('source=menu')
  expect(screen.getByRole('region', { name: 'Selected thread' })).toHaveTextContent('first')
})

test('an explicit linked conversation is retained', async () => {
  open('/messages?conversation=second')
  await waitFor(() => expect(chatApi.list).toHaveBeenCalled())
  expect(screen.getByRole('region', { name: 'Selected thread' })).toHaveTextContent('second')
})

test('Back to inbox remains usable after the initial automatic selection', async () => {
  open()
  await waitFor(() => expect(screen.getByLabelText('Current URL')).toHaveTextContent('conversation=first'))
  fireEvent.click(screen.getByRole('button', { name: 'Back to inbox' }))
  await waitFor(() => expect(screen.getByRole('region', { name: 'Selected thread' })).toHaveTextContent('No thread selected'))
})

test('a failed inbox does not fabricate a selection; retry selects the first returned thread', async () => {
  vi.mocked(chatApi.list).mockRejectedValueOnce(new Error('offline'))
  open()
  fireEvent.click(await screen.findByRole('button', { name: 'Retry inbox' }))
  await waitFor(() => expect(screen.getByLabelText('Current URL')).toHaveTextContent('conversation=first'))
})

test('an empty inbox leaves the selection empty', async () => {
  vi.mocked(chatApi.list).mockResolvedValueOnce({ items: [], hasMore: false, page: 1 })
  open()
  await screen.findByText('No conversations yet. Buyer inquiries will appear here.')
  expect(screen.getByRole('region', { name: 'Selected thread' })).toHaveTextContent('No thread selected')
  expect(screen.getByLabelText('Current URL')).not.toHaveTextContent('conversation=')
})
