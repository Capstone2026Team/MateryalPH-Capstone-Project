import { WorkPackageAttachment } from '../components/WorkPackageAttachment'
import { listFleet } from '../lib/inventory-api'
import type { FleetVehicle } from '@materyalph/api-client-ts'
import { useCallback, useEffect, useRef, useState } from 'react'
import { Link, useNavigate, useSearchParams } from 'react-router-dom'
import { ChatDraftContentFromJSON, ChatDraftContentToJSON, ChatQuotationContentToJSON, type ChatDraftContent, type ChatMessage, type ChatProduct, type ChatHandler, type ChatQuotation, type ConversationDetail, type ConversationView, type CatalogListingSummary, type CatalogVariant } from '@materyalph/api-client-ts'
import { Button, ChatMessageBubble, ConversationHeader, ConversationInbox, QuotationVersionCard, StatusMessage, chatRoleLabel, conversationLabel, formatPesoCentavos } from '@materyalph/web-ui'
import { ArrowLeft, FileText, MessageSquare, Paperclip, Send, UsersRound } from 'lucide-react'
import { chatApi, loadChatAvatar, readableChatError, watchConversation } from '../lib/messaging-api'
import { getListing, listListings } from '../lib/catalog-api'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, VendorShell } from './PhaseThreeVendorPages'

const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base'

export function VendorMessagesPage() {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  return <VendorShell activeHref="/messages" accountLabel="Vendor" navigationData={snapshot}>
    {loading ? <LoadingState label="Loading messages…" /> : error || !snapshot ? <ErrorState message={error ?? 'Account unavailable.'} onRetry={() => void refresh()} /> : !snapshot.permissions.includes('portal.messages') ? <StatusMessage tone="error">Your role cannot access conversations.</StatusMessage> : <MessagingWorkspace role={snapshot.permissions.includes('quotations.publish') ? 'PUBLISHER' : snapshot.permissions.includes('orders.confirm') ? 'CUSTOMER_SERVICE' : 'FULFILLMENT'} />}
  </VendorShell>
}

export function MessagingWorkspace({ role }: { role: string }) {
  const [params, setParams] = useSearchParams()
  const navigate = useNavigate()
  const selected = params.get('conversation')
  const [rows, setRows] = useState<ConversationView[]>([])
  const [page, setPage] = useState(1)
  const [more, setMore] = useState(false)
  const [inboxLoading, setInboxLoading] = useState(true)
  const [inboxError, setInboxError] = useState<string | null>(null)
  const [inboxRefresh, setInboxRefresh] = useState(0)
  const [reload, setReload] = useState(0)
  const [historyOpen, setHistoryOpen] = useState(false)
  const [detail, setDetail] = useState<ConversationDetail | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)
  const [busy, setBusy] = useState(false)
  const [text, setText] = useState('')
  const [product, setProduct] = useState<ChatProduct | null>(null)
  const [picker, setPicker] = useState(false)
  const [productQuery, setProductQuery] = useState('')
  const [products, setProducts] = useState<ChatProduct[]>([])
  const [productPage, setProductPage] = useState(1)
  const [moreProducts, setMoreProducts] = useState(false)
  const [pending, setPending] = useState<(ChatMessage & { deliveryState: 'pending' | 'failed' })[]>([])
  const [typing, setTyping] = useState(false)
  const typingAt = useRef(0)
  const typingTimer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined)
  const typingSendTimer = useRef<ReturnType<typeof setTimeout> | undefined>(undefined)
  const lastTypingSent = useRef(0)
  const [editor, setEditor] = useState(false)
  const [handlers, setHandlers] = useState<ChatHandler[] | null>(null)
  const [handlerPage, setHandlerPage] = useState(1)
  const [moreHandlers, setMoreHandlers] = useState(false)
  const [target, setTarget] = useState('')
  const [reason, setReason] = useState('')
  const generation = useRef(0)
  const running = useRef(false)
  const currentDetail = useRef<ConversationDetail | null>(null)
  const reloadPending = useRef(false)
  const threadLive = useRef(false)
  const threadQuiet = useRef(0)
  const lastRead = useRef('')
  const sendKey = useRef(newIdempotencyKey())
  const actionKey = useRef(newIdempotencyKey())
  const threadBody = useRef<HTMLDivElement>(null)
  const fileInput = useRef<HTMLInputElement>(null)

  useEffect(() => {
    let active = true
    let fetching = false
    let pendingFetch = false
    setInboxLoading(true); setInboxError(null)
    async function fetchInbox() {
      if (fetching) { pendingFetch = true; return }
      fetching = true
      try {
        const result = await chatApi.list(page)
        if (active) { setRows(result.items); setMore(result.hasMore); setInboxError(null) }
      } catch (e) { const message = await readableChatError(e); if (active) setInboxError(message) }
      finally { fetching = false; if (active) { setInboxLoading(false); if (pendingFetch) { pendingFetch = false; void fetchInbox() } } }
    }
    void fetchInbox()
    let stop: (() => void) | undefined
    let live = false
    let quiet = 0
    void watchConversation(null, () => void fetchInbox(), undefined, undefined, value => { live = value }).then(close => { if (active) stop = close; else close() })
    // Realtime pushes changes; poll every 4 seconds only while the socket is down, otherwise every 45.
    const timer = window.setInterval(() => { quiet += 1; if (document.visibilityState === 'visible' && (!live || quiet >= 11)) { quiet = 0; void fetchInbox() } }, 4000)
    return () => { active = false; stop?.(); window.clearInterval(timer) }
  }, [page, inboxRefresh])

  const load = useCallback(async () => {
    if (running.current) { reloadPending.current = true; return }
    running.current = true
    const g = generation.current
    try {
      if (selected) {
        let value = await chatApi.get(selected)
        const previous = currentDetail.current?.messages
        const anchor = previous?.items.at(-1)?.id
        if (anchor && value.messages.items.length) {
          const incoming = [...value.messages.items]
          let cursor = value.messages
          while (!incoming.some(message => message.id === anchor) && cursor.hasMore && cursor.nextBefore && cursor.items[0] && cursor.items[0].id > anchor) {
            const older = await chatApi.get(selected, cursor.nextBefore)
            if (g !== generation.current) return
            cursor = older.messages
            incoming.unshift(...cursor.items)
          }
          const merged = new Map([...previous!.items, ...incoming].map(message => [message.id, message]))
          value = { ...value, messages: { ...previous!, items: [...merged.values()].sort((a, b) => a.id.localeCompare(b.id)) } }
        }
        if (g !== generation.current) return
        currentDetail.current = value
        setDetail(value)
        setError(null)
        setPending(current => current.filter(message => !value.messages.items.some(saved => saved.clientMessageId === message.clientMessageId)))
        const newest = value.messages.items.at(-1)
        if (newest && lastRead.current !== newest.id && value.conversation.unreadCount > 0) {
          lastRead.current = newest.id
          void chatApi.read(selected, newest.id).then(() => {
            if (g === generation.current) setRows(current => current.map(row => row.id === selected ? { ...row, unreadCount: 0 } : row))
          }).catch(() => { if (g === generation.current) lastRead.current = '' })
        }
      }
    } catch (e) { const message = await readableChatError(e); if (g === generation.current) { setError(message); setDetail(null); currentDetail.current = null } }
    finally { if (g === generation.current) { running.current = false; setLoading(false); if (reloadPending.current) { reloadPending.current = false; setReload(value => value + 1) } } }
  }, [selected])

  useEffect(() => {
    generation.current++; currentDetail.current = null; reloadPending.current = false; running.current = false; lastRead.current = ''; setLoading(true); setDetail(null); setError(null); setText(''); setProduct(null); setPicker(false); setPending([]); setTyping(false); typingAt.current = 0; clearTimeout(typingTimer.current); clearTimeout(typingSendTimer.current); setEditor(false); setHandlers(null); setHistoryOpen(false)
    void load()
    const timer = window.setInterval(() => { threadQuiet.current += 1; if (document.visibilityState === 'visible' && (!threadLive.current || threadQuiet.current >= 11)) { threadQuiet.current = 0; void load() } }, 4000)
    const requests = generation
    return () => { requests.current++; window.clearInterval(timer) }
  }, [load])
  useEffect(() => { if (reload > 0) void load() }, [reload, load])
  const channel = detail?.conversation.channel
  useEffect(() => {
    if (!channel) return
    let active = true; let close: (() => void) | undefined; let debounce: number | undefined
    void watchConversation(channel, () => { window.clearTimeout(debounce); debounce = window.setTimeout(() => void load(), 300) }, (active, at) => {
      if (at <= typingAt.current) return
      typingAt.current = at; clearTimeout(typingTimer.current); setTyping(active)
      typingTimer.current = setTimeout(() => setTyping(false), 3000)
    }, undefined, value => { threadLive.current = value }).then(stop => { if (active) close = stop; else stop() }).catch(() => undefined)
    return () => { active = false; threadLive.current = false; close?.(); window.clearTimeout(debounce); clearTimeout(typingTimer.current); clearTimeout(typingSendTimer.current) }
  }, [channel, load])

  const newestMessageId = detail?.messages.items.at(-1)?.id
  useEffect(() => {
    if (threadBody.current) threadBody.current.scrollTop = historyOpen || editor || handlers ? 0 : threadBody.current.scrollHeight
  }, [newestMessageId, historyOpen, editor, handlers])

  async function mutate(action: () => Promise<unknown>, refresh = true) {
    if (busy) return
    setBusy(true); setError(null)
    try { await action(); actionKey.current = newIdempotencyKey(); if (refresh) await load() }
    catch (e) { setError(await readableChatError(e)) }
    finally { setBusy(false) }
  }
  async function sendMessage(retry?: ChatMessage) {
    if (!selected || (!retry && !text.trim() && !product)) return
    const g = generation.current
    const message: ChatMessage = retry ?? { id: sendKey.current, clientMessageId: sendKey.current, body: text.trim(), kind: product ? (text.trim() ? 'TEXT_WITH_PRODUCT' : 'PRODUCT') : 'TEXT', ...(product ? { product } : {}), sender: { displayName: 'You', role: 'VENDOR' }, sentAt: new Date().toISOString(), mine: true, attachments: [], readByRecipient: false }
    setPending(current => [...current.filter(item => item.id !== message.id), { ...message, deliveryState: 'pending' }])
    if (!retry) { setText(''); setProduct(null); sendKey.current = newIdempotencyKey() }
    clearTimeout(typingSendTimer.current)
    void chatApi.typing(selected, false).catch(() => undefined)
    try {
      await chatApi.send(selected, message.body, message.clientMessageId, message.product?.productId)
      if (g === generation.current) { await load(); setInboxRefresh(value => value + 1) }
    } catch {
      if (g === generation.current) setPending(current => current.map(item => item.id === message.id ? { ...item, deliveryState: 'failed' } : item))
    }
  }
  function editMessage(value: string) {
    setText(value)
    if (selected && Date.now() - lastTypingSent.current > 1200) {
      lastTypingSent.current = Date.now()
      clearTimeout(typingSendTimer.current)
      typingSendTimer.current = setTimeout(() => { void chatApi.typing(selected, Boolean(value.trim())).catch(() => undefined) }, 200)
    }
  }
  async function findProducts(page = 1) {
    if (!selected) return
    const g = generation.current
    await mutate(async () => { const result = await chatApi.products(selected, productQuery, page); if (g !== generation.current) return; setProducts(result.items); setProductPage(page); setMoreProducts(result.hasMore); setPicker(true) }, false)
  }
  async function openFile(id: string) {
    if (!selected) return
    try { const blob = await chatApi.download(selected, id); const url = URL.createObjectURL(blob); const a = document.createElement('a'); a.href = url; a.download = 'attachment'; a.click(); window.setTimeout(() => URL.revokeObjectURL(url), 1000) }
    catch (e) { setError(await readableChatError(e)) }
  }
  const c = detail?.conversation
  const canStartQuotation = c?.purpose === 'SALES' && c.contextType === 'ITEM_BASED' && !c.canonicalConversationId && role !== 'FULFILLMENT' && detail?.quotations.quotation?.state === 'ACCEPTED'
  const canPrepare = c?.purpose === 'SALES' && role !== 'FULFILLMENT' && detail?.quotations.quotation?.state !== 'ACCEPTED'
  return <div className="chat-workspace">
    <h1 className="sr-only">Messages</h1>
    {error && <StatusMessage tone="error">{error} <button type="button" className="min-h-11 underline" onClick={() => { setError(null); void load() }}>Review latest conversation</button></StatusMessage>}
    <div className={`chat-layout ${selected ? 'has-selection' : ''}`}>
      <aside className="chat-sidebar" aria-label="Conversation inbox">
        <div className="chat-sidebar-heading"><h2>Inbox</h2><span>Page {page}</span></div>
        <div className="chat-sidebar-scroll">
          {inboxLoading ? <LoadingState label="Loading inbox…" /> : inboxError ? <div className="p-4"><StatusMessage tone="error">{inboxError}</StatusMessage><Button variant="quiet" onClick={() => setInboxRefresh(value => value + 1)}>Retry inbox</Button></div> : <ConversationInbox loadAvatar={loadChatAvatar} rows={rows} selected={selected} disabled={busy} onSelect={id => setParams({ conversation: id })} />}
        </div>
        <div className="chat-pagination"><Button variant="quiet" disabled={page === 1 || inboxLoading} onClick={() => setPage(value => value - 1)}>Previous</Button><Button variant="quiet" disabled={!more || inboxLoading} onClick={() => setPage(value => value + 1)}>Next</Button></div>
      </aside>
      <section className="chat-thread" aria-label="Selected conversation">
        {!selected ? <div className="chat-empty-thread"><MessageSquare size={36} aria-hidden="true" /><h2>Your conversations, in one place</h2><p>{role === 'FULFILLMENT' ? 'Choose an assigned order conversation to coordinate fulfillment.' : 'Choose an inquiry from the inbox to reply or prepare a quotation.'}</p></div> : <>
          <div className="chat-toolbar"><Button className="chat-back" aria-label="Back to inbox" variant="quiet" disabled={busy} onClick={() => setParams({})}><ArrowLeft size={16} aria-hidden="true" /><span className="chat-action-label">Back to inbox</span></Button><span className="chat-toolbar-label">{c ? conversationLabel(c) : 'Conversation'}</span>{c && <><Button variant="quiet" aria-label="Quotation history" aria-expanded={historyOpen} aria-controls="chat-quotation-history" onClick={() => setHistoryOpen(value => !value)}><FileText size={16} aria-hidden="true" /><span className="chat-action-label">Quotation history</span></Button>{c.canTransfer && <Button variant="quiet" aria-label="Transfer handler" disabled={busy} onClick={() => void mutate(async () => { const result = await chatApi.handlers(c.id); setHandlers(result.data); setHandlerPage(1); setMoreHandlers(Boolean(result.meta.has_more)) }, false)}><UsersRound size={16} aria-hidden="true" /><span className="chat-action-label">Transfer handler</span></Button>}</>}</div>
          {loading ? <LoadingState label="Loading conversation…" /> : detail && c ? <>
            <ConversationHeader store={c.store} buyer={c.buyer} handler={c.handler} purpose={c.purpose} loadAvatar={loadChatAvatar} />
            <div className="chat-thread-body" ref={threadBody}>
        {handlers && <form className="grid gap-3 border-b border-border-default p-5 sm:grid-cols-2" onSubmit={e => { e.preventDefault(); void mutate(async () => { await chatApi.transfer(c.id, Number(target), c.lockVersion, reason); setHandlers(null) }) }}><label className="grid gap-2 text-sm font-semibold">New handler<select className={control} required value={target} onChange={e => setTarget(e.target.value)}><option value="">Choose active staff</option>{handlers.map(h => <option key={h.id} value={h.id}>{h.displayName} · {chatRoleLabel(h.role)}</option>)}</select></label><label className="grid gap-2 text-sm font-semibold">Transfer reason<input className={control} required maxLength={500} value={reason} onChange={e => setReason(e.target.value)} /></label><div>{moreHandlers && <Button variant="secondary" onClick={() => void mutate(async () => { const result = await chatApi.handlers(c.id, handlerPage + 1); setHandlers([...handlers, ...result.data]); setHandlerPage(handlerPage + 1); setMoreHandlers(Boolean(result.meta.has_more)) }, false)}>More handlers</Button>}</div><p className="text-sm text-text-secondary sm:col-span-2">Transfer changes the handler. Their fixed role continues to determine what they may do.</p><Button disabled={busy || !target} type="submit">Confirm transfer</Button><Button variant="secondary" onClick={() => setHandlers(null)}>Cancel</Button></form>}
              {!editor && <WorkPackageAttachment reference={c.lockedReference} proposal={detail.quotations.versions[0] ? ChatQuotationContentToJSON(detail.quotations.versions[0].content) : undefined} />}
              {editor && <QuotationDraftEditor key={detail.quotations.quotation?.id ?? c.id} reference={c.lockedReference} conversationId={c.id} quotation={detail.quotations.quotation ?? null} role={role} onSaved={load} />}
              {historyOpen && <aside id="chat-quotation-history" className="chat-history" aria-label="Quotation history"><h3>Quotation history</h3><div className="chat-history-cards">{detail.quotations.versions.length === 0 ? <p className="py-6 text-sm text-text-secondary">Published quotations and their changes appear here.</p> : detail.quotations.versions.map(version => <QuotationVersionCard key={version.id} version={version} busy={busy} onAction={(_, v) => { if (window.confirm('Withdraw this quotation? Its history will remain available.')) void mutate(() => chatApi.withdraw(c.id, v.id, actionKey.current)) }} />)}{detail.quotations.hasMore && <Button variant="secondary" onClick={() => void mutate(async () => { const older = await chatApi.get(c.id, undefined, (detail.quotations.page ?? 1) + 1); setDetail({ ...detail, quotations: { ...older.quotations, versions: [...detail.quotations.versions, ...older.quotations.versions] } }) }, false)}>Older versions</Button>}</div></aside>}
              {detail.quotations.versions.filter(version => version.acceptedOrderId).map(version => <Link key={version.id} className="inline-flex min-h-11 items-center px-5 font-semibold underline" to={`/orders/${version.acceptedOrderId}`}>Open accepted order · {new Date(version.publishedAt).toLocaleDateString('en-PH')}</Link>)}
              <div className="chat-timeline">
                {detail.messages.hasMore && <div className="mb-5 text-center"><Button variant="secondary" disabled={busy} onClick={() => void mutate(async () => { const older = await chatApi.get(c.id, detail.messages.nextBefore ?? undefined); currentDetail.current = { ...detail, messages: { ...older.messages, items: [...older.messages.items, ...detail.messages.items] } }; setDetail(currentDetail.current) }, false)}>Earlier messages</Button></div>}
                <ol aria-label="Conversation messages">{detail.messages.items.map(message => <ChatMessageBubble key={message.id} message={message} onOpenAttachment={id => void openFile(id)} onOpenProduct={id => navigate(`/products/${id}`)} />)}{pending.map(message => <ChatMessageBubble key={message.id} message={message} deliveryState={message.deliveryState} onRetry={() => void sendMessage(message)} onOpenAttachment={() => undefined} onOpenProduct={id => navigate(`/products/${id}`)} />)}</ol>
                {detail.messages.items.length === 0 && <p className="py-10 text-center text-sm text-text-secondary">Start with a helpful reply about products or fulfillment.</p>}
              </div>
            </div>
            {typing && <p role="status" className="px-5 text-sm">typing...</p>}
            {c.canonicalConversationId && <Link className="min-h-11 px-5 underline" to={`/messages?conversation=${c.canonicalConversationId}`}>Open current conversation</Link>}
            {picker && <section className="p-4" aria-label="Attach product"><form className="flex gap-2" onSubmit={event => { event.preventDefault(); void findProducts() }}><input aria-label="Search store products" className={control} value={productQuery} onChange={event => setProductQuery(event.target.value)} /><Button type="submit" disabled={busy}>Search</Button><Button variant="quiet" onClick={() => setPicker(false)}>Close</Button></form><div className="max-h-60 overflow-y-auto">{products.map(item => <button type="button" className="flex min-h-11 w-full items-center gap-3 p-3 text-left" key={item.productId} onClick={() => { setProduct(item); setPicker(false) }}>{item.imageUrl && <img src={item.imageUrl} alt="" className="size-10 object-cover" />}{item.name} · {formatPesoCentavos(item.priceCentavos)}</button>)}{products.length === 0 && <p>No available products</p>}</div><Button variant="quiet" disabled={busy || productPage === 1} onClick={() => void findProducts(productPage - 1)}>Previous</Button><Button variant="quiet" disabled={busy || !moreProducts} onClick={() => void findProducts(productPage + 1)}>Next</Button></section>}
            {c.purpose === 'FULFILLMENT' && c.orderId && <Link className="inline-flex min-h-11 items-center px-5 text-sm font-semibold underline" to={`/orders/${c.orderId}`}>Open order {c.orderReference ?? ''}</Link>}
            {c.readOnly && <p role="status" className="mx-5 mb-4 rounded-control border border-border-default bg-surface-canvas px-4 py-3 text-sm text-text-secondary">
              {c.readOnlyReason === 'ORDER_COMPLETED' ? 'This order is completed.' : c.readOnlyReason === 'ORDER_CANCELLED' ? 'This order was cancelled.' : 'This order is not in fulfillment.'} Fulfillment messages are read-only and kept for your records.</p>}
            {!c.canonicalConversationId && !c.readOnly && <form className="chat-composer" onSubmit={event => { event.preventDefault(); void sendMessage() }}>
              {product && <div className="flex items-center justify-between"><p>{product.name} · {formatPesoCentavos(product.priceCentavos)}</p><Button variant="quiet" onClick={() => setProduct(null)}>Remove product</Button></div>}
              {c.purpose === 'SALES' && <Button variant="quiet" onClick={() => void findProducts()}>Attach product</Button>}
              {canStartQuotation && <Button variant="secondary" disabled={busy} onClick={() => void mutate(async () => { await chatApi.startQuotation(c.id, detail.quotations.quotation!.lockVersion, actionKey.current); setEditor(true) })}>New quotation</Button>}
              {canPrepare && <div className="chat-composer-hint"><FileText size={15} aria-hidden="true" /><span>Turn a product inquiry into a quotation.</span><button type="button" aria-expanded={editor} onClick={() => { setEditor(value => !value); if (threadBody.current) threadBody.current.scrollTop = 0 }}>{editor ? 'Close draft editor' : 'Prepare quotation'}</button></div>}
              <div className="chat-composer-controls">
                <input ref={fileInput} type="file" hidden accept={c.purpose === 'FULFILLMENT' ? 'image/png,image/jpeg' : 'image/png,image/jpeg,application/pdf'} disabled={busy} onChange={event => { const file = event.target.files?.[0]; if (file) void mutate(() => chatApi.upload(c.id, file, newIdempotencyKey())); event.target.value = '' }} />
                <button type="button" className="chat-icon-button" aria-label="Attach file" title="Attach file" disabled={busy} onClick={() => fileInput.current?.click()}><Paperclip size={18} aria-hidden="true" /></button>
                <div className="min-w-0 flex-1"><label className="sr-only" htmlFor="chat-message-input">Message</label><textarea id="chat-message-input" rows={1} maxLength={5000} disabled={busy} value={text} onChange={event => editMessage(event.target.value)} placeholder="Write a message…" /></div>
                <Button type="submit" className="chat-icon-button" aria-label={busy ? 'Saving message' : 'Send message'} title="Send message" disabled={busy || (!text.trim() && !product)}><Send size={18} aria-hidden="true" /></Button>
              </div>
              <p>{c.purpose === 'FULFILLMENT' ? 'JPG or PNG' : 'JPG, PNG or PDF'} · up to 10 MB · Attachments are checked before opening.</p>
            </form>}
          </> : <ErrorState message="The conversation is unavailable or your assignment changed." onRetry={() => void load()} />}
        </>}
      </section>
    </div>
  </div>
}

function QuotationDraftEditor({ conversationId, quotation, role, onSaved, reference }: { conversationId: string; quotation?: ChatQuotation | null; role: string; onSaved: () => Promise<void>; reference?: unknown }) {
  const [draft, setDraft] = useState<ChatDraftContent>(() => quotation?.draft ? ChatDraftContentFromJSON(quotation.draft) : { lines: [], fulfillmentMethod: 'PICKUP', paymentMethod: 'ONLINE', fulfillmentDate: '', deadlineHours: 24, vendorDiscountCentavos: 0 })
  const [query, setQuery] = useState('')
  const [products, setProducts] = useState<CatalogListingSummary[]>([])
  const [variants, setVariants] = useState<CatalogVariant[]>([])
  const [names, setNames] = useState<Record<string, string>>({})
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [dirty, setDirty] = useState(false)
  const [lock, setLock] = useState(quotation?.lockVersion ?? 1)
  const [saved, setSaved] = useState(false)
  const [fleet, setFleet] = useState<FleetVehicle[]>([])
  useEffect(() => { if (!dirty && quotation) { setLock(quotation.lockVersion); if (quotation.draft) setDraft(ChatDraftContentFromJSON(quotation.draft)) } }, [quotation, dirty])
  const delivery = draft.delivery ?? {}
  const vehicles = Array.isArray(delivery.vehicles) ? delivery.vehicles as { vehicle_id: string; number_of_vehicles: number; total_vehicle_trips: number }[] : []
  const allocations = (draft.nrpc?.allocations ?? {}) as Record<string, number>
  const deliveryEdit = (patch: Record<string, unknown>) => edit({ ...draft, delivery: { ...delivery, ...patch } })
  const key = useRef(newIdempotencyKey())
  const edit = (value: ChatDraftContent) => { setDraft(value); setDirty(true); setSaved(false); key.current = newIdempotencyKey() }
  async function act(action: () => Promise<void>) { setBusy(true); setError(null); try { await action() } catch (e) { setError(await readableChatError(e)) } finally { setBusy(false) } }
  return <section className="border-b border-border-default bg-surface-canvas p-4 sm:p-5" aria-label="Quotation draft"><h3 className="text-lg font-semibold">Prepare quotation</h3><p className="mt-1 text-sm text-text-secondary">{role === 'CUSTOMER_SERVICE' ? 'Save a draft for an authorized publisher to review.' : 'Save your draft, review its terms, then publish a new immutable version.'}</p>{error && <StatusMessage tone="error">{error}</StatusMessage>}{saved && <StatusMessage tone="success">Draft saved.</StatusMessage>}
    <WorkPackageAttachment reference={reference} proposal={ChatDraftContentToJSON(draft)} />
    <form className="mt-4 flex flex-wrap gap-2" onSubmit={e => { e.preventDefault(); void act(async () => setProducts((await listListings({ q: query, status: 'ACTIVE' })).items)) }}><label className="min-w-0 flex-1 text-sm font-semibold">Find store products<input className={control} value={query} onChange={e => setQuery(e.target.value)} placeholder="Product name or SKU" /></label><Button type="submit" variant="secondary" className="self-end" disabled={busy}>Search</Button></form>
    <div className="mt-3 flex flex-wrap gap-2">{products.map(product => <Button key={product.id} variant="secondary" onClick={() => void act(async () => { const listing = await getListing(product.id); setVariants(listing.variants); setNames(n => ({ ...n, ...Object.fromEntries(listing.variants.map(v => [v.id, `${listing.displayName} · ${v.label ?? v.sku}`])) })) })}>{product.displayName}</Button>)}</div>
    {variants.length > 0 && <label className="mt-3 grid gap-2 text-sm font-semibold">Add variant<select className={control} value="" onChange={e => { const v = variants.find(row => row.id === e.target.value); if (v && !draft.lines.some(line => line.variantId === v.id)) edit({ ...draft, lines: [...draft.lines, { variantId: v.id, quantity: '1', unitPriceCentavos: v.price?.amountCentavos ?? 1 }] }) }}><option value="">Choose a variant</option>{variants.map(v => <option key={v.id} value={v.id}>{v.label ?? v.sku}</option>)}</select></label>}
    <div className="mt-4 divide-y divide-border-default">{draft.lines.map((line, index) => <div key={line.variantId} className="grid gap-3 py-4 sm:grid-cols-[minmax(0,1fr)_110px_150px_auto]"><p className="self-center text-sm font-semibold">{line.description ?? names[line.variantId] ?? `Product line ${index + 1}`}</p><label className="grid gap-1 text-sm">Quantity<input className={control} inputMode="decimal" value={line.quantity} onChange={e => edit({ ...draft, lines: draft.lines.map((l, i) => i === index ? { ...l, quantity: e.target.value } : l) })} /></label><label className="grid gap-1 text-sm">Unit price (centavos)<input className={control} type="number" min="1" step="1" value={line.unitPriceCentavos} onChange={e => edit({ ...draft, lines: draft.lines.map((l, i) => i === index ? { ...l, unitPriceCentavos: Number(e.target.value) } : l) })} /><span className="text-xs">{formatPesoCentavos(line.unitPriceCentavos)}</span></label><Button variant="secondary" className="self-center" onClick={() => edit({ ...draft, lines: draft.lines.filter((_, i) => i !== index) })}>Remove</Button></div>)}</div>
    <div className="mt-4 space-y-4">{draft.lines.map((line, index) => <fieldset key={line.variantId} className="rounded-control border border-border-default p-4"><legend>Proposed material {index + 1}</legend><label className="grid gap-2 text-sm">Description<input className={control} maxLength={200} value={line.description ?? ''} onChange={e => edit({ ...draft, lines: draft.lines.map((l, i) => i === index ? { ...l, description: e.target.value } : l) })} /></label><label className="mt-3 grid gap-2 text-sm">Specifications (key=value per line)<textarea className={control} value={Object.entries(line.specifications ?? {}).map(([k,v]) => `${k}=${v}`).join('\n')} onChange={e => edit({ ...draft, lines: draft.lines.map((l, i) => i === index ? { ...l, specifications: Object.fromEntries(e.target.value.split('\n').filter(v => v.includes('=')).map(v => { const n = v.indexOf('='); return [v.slice(0,n).trim(), v.slice(n+1).trim()] })) } : l) })} /></label></fieldset>)}</div>
    <div className="mt-4 grid gap-4 sm:grid-cols-2"><label className="grid gap-2 text-sm font-semibold">Fulfillment date<input className={control} type="date" value={draft.fulfillmentDate} onChange={e => edit({ ...draft, fulfillmentDate: e.target.value })} /></label><label className="grid gap-2 text-sm font-semibold">Buyer deadline (hours)<input className={control} type="number" min="1" max="72" value={draft.deadlineHours ?? 24} onChange={e => edit({ ...draft, deadlineHours: Number(e.target.value) })} /></label><label className="grid gap-2 text-sm font-semibold">Vendor discount (centavos)<input className={control} type="number" min="0" value={draft.vendorDiscountCentavos ?? 0} onChange={e => edit({ ...draft, vendorDiscountCentavos: Number(e.target.value) })} /></label><div className="self-center text-sm text-text-secondary">Online payment<br />Processing fee is disclosed at payment-channel selection.</div></div>
    <div className="mt-4 space-y-4">
      <label className="grid gap-2 text-sm font-semibold">Fulfillment<select className={control} value={draft.fulfillmentMethod} onChange={e => { edit({ ...draft, fulfillmentMethod: e.target.value as ChatDraftContent['fulfillmentMethod'] }); if (e.target.value === 'DELIVERY') void act(async () => setFleet((await listFleet()).items.filter(v => v.active && v.available))) }}><option value="PICKUP">Self-Pickup</option><option value="DELIVERY">Site Delivery</option></select></label>
      {draft.fulfillmentMethod === 'DELIVERY' && <fieldset className="space-y-3 rounded-control border border-border-default p-4"><legend className="px-2 font-semibold">Delivery arrangement</legend><p className="text-sm text-text-secondary">Uses the Buyer's saved inquiry destination. Vehicle capacity, road distance and current rates are validated before publication.</p><Button variant="secondary" onClick={() => void act(async () => setFleet((await listFleet()).items.filter(v => v.active && v.available)))}>Load available vehicles</Button>
      <select aria-label="Add delivery vehicle" className={control} value="" onChange={e => { if (e.target.value && !vehicles.some(v => v.vehicle_id === e.target.value)) deliveryEdit({ vehicles: [...vehicles, { vehicle_id: e.target.value, number_of_vehicles: 1, total_vehicle_trips: 1 }] }) }}><option value="">Choose vehicle</option>{fleet.map(v => <option key={v.id} value={v.id}>{v.name}</option>)}</select>
      {vehicles.map((v, i) => <div key={v.vehicle_id} className="grid gap-3 sm:grid-cols-3"><span className="self-center font-medium">{fleet.find(f => f.id === v.vehicle_id)?.name ?? `Vehicle ${i + 1}`}</span>{(['number_of_vehicles', 'total_vehicle_trips'] as const).map(field => <label key={field} className="grid gap-1 text-sm">{field === 'number_of_vehicles' ? 'Vehicles' : 'Total vehicle trips'}<input className={control} type="number" min="1" value={v[field]} onChange={e => deliveryEdit({ vehicles: vehicles.map((row, n) => n === i ? { ...row, [field]: Number(e.target.value) } : row) })} /></label>)}<Button variant="secondary" onClick={() => deliveryEdit({ vehicles: vehicles.filter((_, n) => n !== i) })}>Remove vehicle</Button></div>)}
      <label className="grid gap-2 text-sm">Final delivery charge (centavos)<input className={control} type="number" min="0" value={Number(delivery.final_fee_centavos ?? 0)} onChange={e => deliveryEdit({ final_fee_centavos: Number(e.target.value) })} /></label><label className="grid gap-2 text-sm">Delivery arrangement<textarea className={control} value={String(delivery.arrangement ?? '')} onChange={e => deliveryEdit({ arrangement: e.target.value })} /></label><label className="flex min-h-11 items-center gap-2"><input type="checkbox" checked={Boolean(delivery.access_confirmed)} onChange={e => deliveryEdit({ access_confirmed: e.target.checked })} />Delivery access confirmed with Buyer</label><label className="flex min-h-11 items-center gap-2"><input type="checkbox" checked={Boolean(delivery.heavy_vehicle_access_confirmed)} onChange={e => deliveryEdit({ heavy_vehicle_access_confirmed: e.target.checked })} />Heavy vehicle access confirmed</label><label className="grid gap-2 text-sm">Manual review note (when required)<textarea className={control} value={String(delivery.manual_review_note ?? '')} onChange={e => deliveryEdit({ manual_review_note: e.target.value })} /></label></fieldset>}
      {role !== 'CUSTOMER_SERVICE' && <fieldset className="space-y-3 rounded-control border border-border-default p-4"><legend className="px-2 font-semibold">Non-Refundable Preparation Charge</legend><label className="flex min-h-11 items-center gap-2"><input type="checkbox" checked={Boolean(draft.nrpc)} onChange={e => { const { nrpc: previous, ...rest } = draft; void previous; edit(e.target.checked ? { ...draft, nrpc: { reason: '', amount_centavos: 0, allocations: {} } } : rest) }} />Include NRPC</label>{draft.nrpc && <><label className="grid gap-2 text-sm">Reason<textarea className={control} value={String(draft.nrpc.reason ?? '')} onChange={e => edit({ ...draft, nrpc: { ...draft.nrpc, reason: e.target.value } })} /></label><p className="text-sm text-text-secondary">Allocate the charge to affected lines. It is included in the materials amount and requires Buyer acceptance of the current Terms.</p>{draft.lines.map((line, i) => <label key={line.variantId} className="grid gap-2 text-sm">{names[line.variantId] ?? `Line ${i + 1}`} · NRPC (centavos)<input className={control} type="number" min="0" value={allocations[line.variantId] ?? 0} onChange={e => { const next = { ...allocations, [line.variantId]: Number(e.target.value) }; const nonzero = Object.fromEntries(Object.entries(next).filter(([, value]) => value > 0)); edit({ ...draft, nrpc: { ...draft.nrpc, allocations: nonzero, amount_centavos: Object.values(nonzero).reduce((sum, value) => sum + value, 0) } }) }} /></label>)}</>}</fieldset>}
    </div>
    <div className="mt-5 flex flex-wrap gap-3"><Button disabled={busy || !draft.lines.length || !draft.fulfillmentDate} onClick={() => void act(async () => { const result = await chatApi.draft(conversationId, lock, draft); setLock(result.quotation?.lockVersion ?? lock + 1); setDirty(false); setSaved(true); await onSaved() })}>Save draft</Button>{role !== 'CUSTOMER_SERVICE' && <Button variant="secondary" disabled={busy || dirty || !quotation?.draft} onClick={() => { if (window.confirm('Publish these terms? This starts a new Buyer deadline and supersedes the previous version.')) void act(async () => { await chatApi.publish(conversationId, lock, key.current); key.current = newIdempotencyKey(); await onSaved() }) }}>Publish quotation</Button>}</div>
  </section>
}
