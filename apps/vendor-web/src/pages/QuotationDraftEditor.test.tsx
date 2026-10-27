import { act, cleanup, fireEvent, render, screen, waitFor } from '@testing-library/react'
import { afterEach, beforeEach, expect, test, vi } from 'vitest'
import type { ChatDraftContent, ChatQuotation } from '@materyalph/api-client-ts'
import { ChatDraftContentToJSON } from '@materyalph/api-client-ts'
import { chatApi } from '../lib/messaging-api'
import { QuotationDraftEditor } from './ConversationThread'

vi.mock('../lib/messaging-api', async original => ({
  ...await original<typeof import('../lib/messaging-api')>(),
  chatApi: { draft: vi.fn(), publish: vi.fn() },
  readableChatError: async () => 'Unable to save. Please retry.',
}))

const draft: ChatDraftContent = { lines: [{ variantId: 'variant', quantity: '2', unitPriceCentavos: 10000 }], fulfillmentMethod: 'PICKUP', fulfillmentDate: '2099-01-01', deadlineHours: 24 }
const quotation: ChatQuotation = { id: 'quote', lockVersion: 1, state: 'DRAFT', canDraft: true, canPublish: true, draft: ChatDraftContentToJSON(draft) }
const props = () => ({ open: true, conversationId: 'conversation', quotation, role: 'PUBLISHER', onSaved: vi.fn(async () => {}), onClose: vi.fn() })

beforeEach(() => {
  vi.mocked(chatApi.draft).mockReset().mockImplementation(async (_id, version) => ({ quotation: { ...quotation, lockVersion: version + 1 }, versions: [], hasMore: false }))
  vi.mocked(chatApi.publish).mockReset().mockResolvedValue({ data: { versions: [], hasMore: false }, meta: {}, errors: [] })
  vi.spyOn(window, 'confirm').mockReturnValue(true)
})
afterEach(() => { cleanup(); vi.restoreAllMocks() })

test('autosaves the optional message without a Save draft button', async () => {
  render(<QuotationDraftEditor {...props()} />)
  expect(screen.queryByRole('button', { name: 'Save draft' })).not.toBeInTheDocument()
  fireEvent.change(screen.getByRole('textbox', { name: /Message to Buyer/ }), { target: { value: '  A discount is included.  ' } })
  await waitFor(() => expect(chatApi.draft).toHaveBeenCalledWith('conversation', 1, expect.objectContaining({ message: 'A discount is included.' })))
  expect(await screen.findByText('All changes saved')).toBeInTheDocument()
})

test('publish flushes the newest edit and closes only after publication succeeds', async () => {
  const options = props()
  render(<QuotationDraftEditor {...options} />)
  fireEvent.change(screen.getByRole('textbox', { name: /Message to Buyer/ }), { target: { value: 'My final offer.' } })
  fireEvent.click(screen.getByRole('button', { name: 'Publish quotation' }))
  await waitFor(() => expect(options.onClose).toHaveBeenCalledOnce())
  expect(chatApi.draft).toHaveBeenCalledWith('conversation', 1, expect.objectContaining({ message: 'My final offer.' }))
  expect(chatApi.publish).toHaveBeenCalledWith('conversation', 2, expect.any(String))
  expect(options.onSaved).toHaveBeenCalledOnce()
})

test('edits made during autosave are saved with the next lock version', async () => {
  let resolve!: () => void
  const gate = new Promise<void>(done => { resolve = done })
  vi.mocked(chatApi.draft).mockImplementationOnce(async () => { await gate; return { quotation: { ...quotation, lockVersion: 2 }, versions: [], hasMore: false } })
  render(<QuotationDraftEditor {...props()} />)
  const input = screen.getByRole('textbox', { name: /Message to Buyer/ })
  fireEvent.change(input, { target: { value: 'First edit' } })
  await waitFor(() => expect(chatApi.draft).toHaveBeenCalledTimes(1))
  fireEvent.change(input, { target: { value: 'Latest edit' } })
  await act(async () => resolve())
  await waitFor(() => expect(chatApi.draft).toHaveBeenCalledWith('conversation', 2, expect.objectContaining({ message: 'Latest edit' })))
  expect(input).toHaveValue('Latest edit')
})

test('failed saves keep the editor open and a retry preserves the message', async () => {
  vi.mocked(chatApi.draft).mockRejectedValueOnce(new Error('offline'))
  const options = props()
  render(<QuotationDraftEditor {...options} />)
  fireEvent.change(screen.getByRole('textbox', { name: /Message to Buyer/ }), { target: { value: 'Keep this offer' } })
  fireEvent.click(screen.getByRole('button', { name: /^Close$/ }))
  expect(await screen.findByText('Unable to save. Please retry.')).toBeInTheDocument()
  expect(options.onClose).not.toHaveBeenCalled()
  fireEvent.click(screen.getByRole('button', { name: 'Retry saving' }))
  expect(await screen.findByText('All changes saved')).toBeInTheDocument()
  expect(screen.getByRole('textbox', { name: /Message to Buyer/ })).toHaveValue('Keep this offer')
})

test('Customer Service autosaves drafts without a publish action', async () => {
  render(<QuotationDraftEditor {...props()} role="CUSTOMER_SERVICE" />)
  expect(screen.queryByRole('button', { name: 'Publish quotation' })).not.toBeInTheDocument()
  fireEvent.change(screen.getByRole('textbox', { name: /Message to Buyer/ }), { target: { value: 'For review' } })
  await waitFor(() => expect(chatApi.draft).toHaveBeenCalledTimes(1))
})
