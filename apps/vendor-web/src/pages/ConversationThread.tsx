import { Toolbar } from '@materyalph/web-ui'
import { WorkPackageAttachment } from '../components/WorkPackageAttachment'
import { SiteInspectionPanel } from '../components/SiteInspectionPanel'
import { listFleet } from '../lib/inventory-api'
import { useCallback, useEffect, useId, useRef, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { ChatDraftContentFromJSON, ChatDraftContentToJSON, ChatQuotationContentToJSON, type ChatDraftContent, type ChatMessage, type ChatProduct, type ChatHandler, type ChatQuotation, type ConversationDetail } from '@materyalph/api-client-ts'
import { Button, CatalogProductPicker, CountBadge, FormDialog, ChatMessageBubble, ChatTypingIndicator, ConversationHeader, NrpcPreparationEditor, QuotationDeliveryArrangement, QuotationDiscountEditor, QuotationMaterialsEditor, QuotationVersionCard, StatusMessage, useNavigationRefresh, chatRoleLabel, conversationLabel, formatPesoCentavos, nrpcPreparationAssessment, quotationDiscountPreview, type NrpcPreparedMaterial, type NrpcPreparationValue } from '@materyalph/web-ui'
import { ArrowLeft, FileText, MessageSquare, Paperclip, Send, UsersRound } from 'lucide-react'
import { chatApi, loadChatAvatar, readableChatError, watchConversation } from '../lib/messaging-api'
import { getListing, listListings, readableCatalogError } from '../lib/catalog-api'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { quotationDraftForSave } from '../lib/quotation-draft'
import { ErrorState, LoadingState } from './PhaseThreeVendorPages'

const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base'

const loadQuotationProducts = (query: string, page: number) => listListings({ ...(query ? { q: query } : {}), status: 'ACTIVE', page })
const loadQuotationVehicles = async () => (await listFleet()).items

export function ConversationThread({ selected, role, onBack, onRead, onMessage, onFulfillmentList, onProjectList, onOpenMain, obscured = false, onBusyChange }: {
  selected: string | null; role: string; onBack?: () => void; onRead?: (id: string) => void; onMessage?: () => void; onFulfillmentList?: () => void; onProjectList?: () => void; onOpenMain?: (id: string) => void; obscured?: boolean; onBusyChange?: (busy: boolean) => void
}) {
  const navigate = useNavigate()
  const callbacks = useRef({ onRead, onMessage, obscured })
  useEffect(() => { callbacks.current = { onRead, onMessage, obscured } }, [onRead, onMessage, obscured])
  const [reload, setReload] = useState(0)
  const [historyOpen, setHistoryOpen] = useState(false)
  const [detail, setDetail] = useState<ConversationDetail | null>(null)
  const fulfillmentCountId = useId()
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)
  const [busy, setBusy] = useState(false)
  useEffect(() => { onBusyChange?.(busy) }, [busy, onBusyChange])
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
        if (!callbacks.current.obscured && newest && lastRead.current !== newest.id && value.conversation.unreadCount > 0) {
          lastRead.current = newest.id
          void chatApi.read(selected, newest.id).then(() => {
            if (g === generation.current) callbacks.current.onRead?.(selected)
          }).catch(() => { if (g === generation.current) lastRead.current = '' })
        }
      }
    } catch (e) { const message = await readableChatError(e); if (g === generation.current) { setError(message); setDetail(null); currentDetail.current = null } }
    finally { if (g === generation.current) { running.current = false; setLoading(false); if (reloadPending.current) { reloadPending.current = false; setReload(value => value + 1) } } }
  }, [selected])

  // Sibling-thread activity refreshes the aggregate badges without replacing composer state.
  useNavigationRefresh(() => {
    if (selected && (onProjectList || (onFulfillmentList && currentDetail.current?.conversation.canListFulfillmentConversations))) void load()
  })

  useEffect(() => {
    generation.current++; currentDetail.current = null; reloadPending.current = false; running.current = false; lastRead.current = ''; setLoading(true); setDetail(null); setError(null); setText(''); setProduct(null); setPicker(false); setPending([]); setTyping(false); typingAt.current = 0; clearTimeout(typingTimer.current); clearTimeout(typingSendTimer.current); setEditor(false); setHandlers(null); setHistoryOpen(false)
    void load()
    const timer = window.setInterval(() => { threadQuiet.current += 1; if (document.visibilityState === 'visible' && (!threadLive.current || threadQuiet.current >= 11)) { threadQuiet.current = 0; void load() } }, 4000)
    const requests = generation
    return () => { requests.current++; window.clearInterval(timer); clearTimeout(typingTimer.current); clearTimeout(typingSendTimer.current) }
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
    if (!callbacks.current.obscured && threadBody.current) threadBody.current.scrollTop = historyOpen || handlers ? 0 : threadBody.current.scrollHeight
  }, [newestMessageId, historyOpen, handlers])
  // Reveal the typing bubble only for a reader already at the latest message; never pull someone reading history.
  useEffect(() => {
    const body = threadBody.current
    if (!typing || !body || callbacks.current.obscured || body.scrollHeight - body.scrollTop - body.clientHeight > 160) return
    body.scrollTop = body.scrollHeight
  }, [typing])

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
      if (g === generation.current) { await load(); callbacks.current.onMessage?.() }
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
  async function openFile(id: string, name?: string) {
    if (!selected) return
    try { const blob = await chatApi.download(selected, id); const url = URL.createObjectURL(blob); const a = document.createElement('a'); a.href = url; a.download = name ?? 'attachment'; a.click(); window.setTimeout(() => URL.revokeObjectURL(url), 1000) }
    catch (e) { setError(await readableChatError(e)) }
  }
  // Stable per conversation so polling re-renders never re-download a previewed image.
  const loadAttachment = useCallback((id: string) => selected ? chatApi.download(selected, id) : Promise.reject(new Error('No conversation selected')), [selected])
  const c = detail?.conversation
  const fulfillmentUnreadCount = c?.fulfillmentUnreadCount ?? 0
  const canStartQuotation = c?.purpose === 'SALES' && c.contextType === 'ITEM_BASED' && !c.canonicalConversationId && role !== 'FULFILLMENT' && detail?.quotations.quotation?.state === 'ACCEPTED'
  const canPrepare = c?.purpose === 'SALES' && role !== 'FULFILLMENT' && detail?.quotations.quotation?.state !== 'ACCEPTED'
  return (
      <section className="chat-thread flex-1" aria-label="Selected conversation">
        {error && <StatusMessage tone="error">{error} <Button variant="quiet" onClick={() => void load()}>Retry conversation</Button></StatusMessage>}
        {!selected ? <div className="chat-empty-thread"><MessageSquare size={36} aria-hidden="true" /><h2>Your conversations, in one place</h2><p>{role === 'FULFILLMENT' ? 'Choose an assigned order conversation to coordinate fulfillment.' : 'Choose an inquiry from the inbox to reply or prepare a quotation.'}</p></div> : <>
          <div className="chat-toolbar">{onBack && <Button className="chat-back" aria-label="Back to inbox" variant="quiet" disabled={busy} onClick={onBack}><ArrowLeft size={16} aria-hidden="true" /><span className="chat-action-label">Back to inbox</span></Button>}{c?.contextType === 'PROJECT_BASED' && c.mainConversationId && onOpenMain && <Button variant="quiet" disabled={busy} onClick={() => onOpenMain(c.mainConversationId!)}>Item inquiry</Button>}<span className="chat-toolbar-label">{c ? conversationLabel(c) : 'Conversation'}</span>{c?.purpose === 'SALES' && onProjectList && <Button variant="quiet" disabled={busy} onClick={onProjectList} aria-haspopup="dialog"><MessageSquare size={16} aria-hidden="true" /><span>Project inquiries</span><CountBadge count={c.projectUnreadCount ?? 0} /><span className="sr-only">{c.projectUnreadCount ?? 0} unread project messages</span></Button>}{c && <>{c.canListFulfillmentConversations && onFulfillmentList && <><Button variant="quiet" onClick={onFulfillmentList} aria-haspopup="dialog" aria-describedby={fulfillmentCountId}><MessageSquare size={16} aria-hidden="true" /><span>Fulfillment conversations</span><CountBadge count={fulfillmentUnreadCount} /></Button><span id={fulfillmentCountId} className="sr-only" role="status">{fulfillmentUnreadCount > 0 ? `${fulfillmentUnreadCount} unread fulfillment messages` : 'No unread fulfillment messages'}</span></>}{c.purpose === 'SALES' && <Button variant="quiet" aria-label="Quotation history" aria-expanded={historyOpen} aria-controls="chat-quotation-history" onClick={() => setHistoryOpen(value => !value)}><FileText size={16} aria-hidden="true" /><span className="chat-action-label">Quotation history</span></Button>}{c.canTransfer && <Button variant="quiet" aria-label="Transfer handler" disabled={busy} onClick={() => void mutate(async () => { const result = await chatApi.handlers(c.id); setHandlers(result.data); setHandlerPage(1); setMoreHandlers(Boolean(result.meta.has_more)) }, false)}><UsersRound size={16} aria-hidden="true" /><span className="chat-action-label">Transfer handler</span></Button>}</>}</div>
          {loading ? <LoadingState label="Loading conversation…" /> : detail && c ? <>
            {canPrepare && <QuotationDraftEditor key={c.id} open={editor} onClose={() => setEditor(false)} reference={c.lockedReference} conversationId={c.id} quotation={detail.quotations.quotation ?? null} sourceNames={Object.fromEntries(detail.quotations.versions.find(version => version.latest)?.content.lines.map(line => [line.variantId, line.description]) ?? [])} role={role} onSaved={load} />}
            <ConversationHeader store={c.store} buyer={c.buyer} handler={c.handler} purpose={c.purpose} loadAvatar={loadChatAvatar} />
            <div className="chat-thread-body" ref={threadBody}>
        {handlers && <form className="grid gap-3 border-b border-border-default p-5 sm:grid-cols-2" onSubmit={e => { e.preventDefault(); void mutate(async () => { await chatApi.transfer(c.id, Number(target), c.lockVersion, reason); setHandlers(null) }) }}><label className="grid gap-2 text-sm font-semibold">New handler<select className={control} required value={target} onChange={e => setTarget(e.target.value)}><option value="">Choose active staff</option>{handlers.map(h => <option key={h.id} value={h.id}>{h.displayName} · {chatRoleLabel(h.role)}</option>)}</select></label><label className="grid gap-2 text-sm font-semibold">Transfer reason<input className={control} required maxLength={500} value={reason} onChange={e => setReason(e.target.value)} /></label><div>{moreHandlers && <Button variant="secondary" onClick={() => void mutate(async () => { const result = await chatApi.handlers(c.id, handlerPage + 1); setHandlers([...handlers, ...result.data]); setHandlerPage(handlerPage + 1); setMoreHandlers(Boolean(result.meta.has_more)) }, false)}>More handlers</Button>}</div><p className="text-sm text-text-secondary sm:col-span-2">Transfer changes the handler. Their fixed role continues to determine what they may do.</p><Button disabled={busy || !target} type="submit">Confirm transfer</Button><Button variant="secondary" onClick={() => setHandlers(null)}>Cancel</Button></form>}
              <WorkPackageAttachment reference={c.lockedReference} proposal={detail.quotations.versions[0] ? ChatQuotationContentToJSON(detail.quotations.versions[0].content) : undefined} />
              <SiteInspectionPanel inspections={detail.siteInspections ?? []} busy={busy} onPrepareQuotation={canPrepare ? () => setEditor(true) : undefined} onDecide={async (inspection, action, decision) => {
                try { await chatApi.siteInspection(c.id, inspection.id, action, decision) } catch (cause) { throw new Error(await readableChatError(cause)) }
                await load()
              }} />
              {historyOpen && <aside id="chat-quotation-history" className="chat-history" aria-label="Quotation history"><h3>Quotation history</h3><div className="chat-history-cards">{detail.quotations.versions.length === 0 ? <p className="py-6 text-sm text-text-secondary">Published quotations and their changes appear here.</p> : detail.quotations.versions.map(version => <QuotationVersionCard key={version.id} version={version} busy={busy} onAction={(_, v) => { if (window.confirm('Withdraw this quotation? Its history will remain available.')) void mutate(() => chatApi.withdraw(c.id, v.id, actionKey.current)) }} />)}{detail.quotations.hasMore && <Button variant="secondary" onClick={() => void mutate(async () => { const older = await chatApi.get(c.id, undefined, (detail.quotations.page ?? 1) + 1); setDetail({ ...detail, quotations: { ...older.quotations, versions: [...detail.quotations.versions, ...older.quotations.versions] } }) }, false)}>Older versions</Button>}</div></aside>}
              {detail.quotations.versions.filter(version => version.acceptedOrderId).map(version => <Link key={version.id} className="inline-flex min-h-11 items-center px-5 font-semibold underline" to={`/orders/${version.acceptedOrderId}`}>Open accepted order · {new Date(version.publishedAt).toLocaleDateString('en-PH')}</Link>)}
              <div className="chat-timeline">
                {detail.messages.hasMore && <div className="mb-5 text-center"><Button variant="secondary" disabled={busy} onClick={() => void mutate(async () => { const older = await chatApi.get(c.id, detail.messages.nextBefore ?? undefined); currentDetail.current = { ...detail, messages: { ...older.messages, items: [...older.messages.items, ...detail.messages.items] } }; setDetail(currentDetail.current) }, false)}>Earlier messages</Button></div>}
                <ol aria-label="Conversation messages">{detail.messages.items.map(message => <ChatMessageBubble key={message.id} message={message} onOpenAttachment={(id, file) => void openFile(id, file?.displayName)} loadAttachment={loadAttachment} onOpenProduct={id => navigate(`/products/${id}`)} />)}{pending.map(message => <ChatMessageBubble key={message.id} message={message} deliveryState={message.deliveryState} onRetry={() => void sendMessage(message)} onOpenAttachment={() => undefined} onOpenProduct={id => navigate(`/products/${id}`)} />)}</ol>
                {detail.messages.items.length === 0 && <p className="py-10 text-center text-sm text-text-secondary">Start with a helpful reply about products or fulfillment.</p>}
                <ChatTypingIndicator active={typing} />
              </div>
            </div>
            {c.canonicalConversationId && <Link className="min-h-11 px-5 underline" to={`/messages?conversation=${c.canonicalConversationId}`}>Open current conversation</Link>}
            {picker && <section className="p-4" aria-label="Attach product"><Toolbar search={{ label: 'Search store products', placeholder: 'Product name or SKU', value: productQuery, onChange: setProductQuery, disabled: busy, onSubmit: event => { event.preventDefault(); if (!busy) void findProducts() } }} viewToggle={<Button variant="quiet" onClick={() => setPicker(false)}>Close</Button>} /><div className="max-h-60 overflow-y-auto">{products.map(item => <button type="button" className="flex min-h-11 w-full items-center gap-3 p-3 text-left" key={item.productId} onClick={() => { setProduct(item); setPicker(false) }}>{item.imageUrl && <img src={item.imageUrl} alt="" className="size-10 object-cover" />}{item.name} · {formatPesoCentavos(item.priceCentavos)}</button>)}{products.length === 0 && <p>No available products</p>}</div><Button variant="quiet" disabled={busy || productPage === 1} onClick={() => void findProducts(productPage - 1)}>Previous</Button><Button variant="quiet" disabled={busy || !moreProducts} onClick={() => void findProducts(productPage + 1)}>Next</Button></section>}
            {c.purpose === 'FULFILLMENT' && c.orderId && <Link className="inline-flex min-h-11 items-center px-5 text-sm font-semibold underline" to={`/orders/${c.orderId}`}>Open order {c.orderReference ?? ''}</Link>}
            {c.readOnly && <p role="status" className="mx-5 mb-4 rounded-control border border-border-default bg-surface-canvas px-4 py-3 text-sm text-text-secondary">
              {c.readOnlyReason === 'ORDER_COMPLETED' ? 'This order is completed.' : c.readOnlyReason === 'ORDER_CANCELLED' ? 'This order was cancelled.' : 'This order is not in fulfillment.'} Fulfillment messages are read-only and kept for your records.</p>}
            {!c.canonicalConversationId && !c.readOnly && <form className="chat-composer" onSubmit={event => { event.preventDefault(); void sendMessage() }}>
              {product && <div className="flex items-center justify-between"><p>{product.name} · {formatPesoCentavos(product.priceCentavos)}</p><Button variant="quiet" onClick={() => setProduct(null)}>Remove product</Button></div>}
              {c.purpose === 'SALES' && <Button variant="quiet" onClick={() => void findProducts()}>Attach product</Button>}
              {canStartQuotation && <Button variant="secondary" disabled={busy} onClick={() => void mutate(async () => { await chatApi.startQuotation(c.id, detail.quotations.quotation!.lockVersion, actionKey.current); setEditor(true) })}>New quotation</Button>}
              {canPrepare && <div className="chat-composer-hint"><FileText size={15} aria-hidden="true" /><span>Turn a product inquiry into a quotation.</span><button type="button" aria-haspopup="dialog" onClick={() => setEditor(true)}>Prepare quotation</button></div>}
              <div className="chat-composer-controls">
                <input ref={fileInput} type="file" hidden accept={c.purpose === 'FULFILLMENT' ? 'image/png,image/jpeg' : 'image/png,image/jpeg,application/pdf'} disabled={busy} onChange={event => { const file = event.target.files?.[0]; if (file) void mutate(() => chatApi.upload(c.id, file, newIdempotencyKey())); event.target.value = '' }} />
                <button type="button" className="chat-icon-button" aria-label="Attach file" title="Attach file" disabled={busy} onClick={() => fileInput.current?.click()}><Paperclip size={18} aria-hidden="true" /></button>
                <div className="min-w-0 flex-1"><label className="sr-only" htmlFor={`chat-message-input-${selected}`}>Message</label><textarea id={`chat-message-input-${selected}`} rows={1} maxLength={5000} disabled={busy} value={text} onChange={event => editMessage(event.target.value)} onKeyDown={event => { if (event.key === 'Enter' && !event.shiftKey && !event.nativeEvent.isComposing) { event.preventDefault(); if (!busy && (text.trim() || product)) void sendMessage() } }} placeholder="Write a message…" /></div>
                <Button type="submit" className="chat-icon-button" aria-label={busy ? 'Saving message' : 'Send message'} title="Send message" disabled={busy || (!text.trim() && !product)}><Send size={18} aria-hidden="true" /></Button>
              </div>
              <p>{c.purpose === 'FULFILLMENT' ? 'JPG or PNG' : 'JPG, PNG or PDF'} · up to 10 MB · Attachments are checked before opening.</p>
            </form>}
          </> : <ErrorState message="The conversation is unavailable or your assignment changed." onRetry={() => void load()} />}
        </>}
      </section>
  )
}

function QuotationDraftEditor({ open, onClose, conversationId, quotation, role, onSaved, reference, sourceNames = {} }: { open: boolean; onClose: () => void; conversationId: string; quotation?: ChatQuotation | null; role: string; onSaved: () => Promise<void>; reference?: unknown; sourceNames?: Record<string, string> }) {
  const [draft, setDraft] = useState<ChatDraftContent>(() => quotation?.draft ? ChatDraftContentFromJSON(quotation.draft) : { lines: [], fulfillmentMethod: 'PICKUP', paymentMethod: 'ONLINE', fulfillmentDate: '', deadlineHours: 24, discount: { scope: 'MATERIALS', percent: '' } })
  const nrpcBuffer = useRef<NrpcPreparationValue | null>(null)
  const [names, setNames] = useState<Record<string, string>>({})
  const [productDetails, setProductDetails] = useState<Record<string, { variantLabel: string; specifications: Record<string, string> }>>({})
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [dirty, setDirty] = useState(false)
  const [lock, setLock] = useState(quotation?.lockVersion ?? 1)
  const [saved, setSaved] = useState(false)
  useEffect(() => { if (!dirty && quotation) { setLock(quotation.lockVersion); if (quotation.draft) setDraft(ChatDraftContentFromJSON(quotation.draft)) } }, [quotation, dirty])
  const delivery = draft.delivery ?? {}
  const nrpcValues = { reason: typeof draft.nrpc?.reason === 'string' ? draft.nrpc.reason : '', allocations: Object.fromEntries(Object.entries(draft.nrpc?.allocations ?? {}).map(([id, amount]) => [id, typeof amount === 'number' ? amount : null])) }
  const deliveryEdit = (patch: Record<string, unknown>) => edit({ ...draft, delivery: { ...delivery, ...patch } })
  const key = useRef(newIdempotencyKey())
  const edit = (value: ChatDraftContent) => { setDraft(value); setDirty(true); setSaved(false); key.current = newIdempotencyKey() }
  const materialNames = { ...sourceNames, ...names }
  const amounts = quotationDiscountPreview(draft)
  const nrpcMaterials: NrpcPreparedMaterial[] = draft.lines.map((line, index) => ({ id: line.variantId, name: materialNames[line.variantId] ?? (line.description?.trim() || `Material ${index + 1}`), detail: `Quantity ${line.quantity}`, payableCentavos: amounts.valid ? amounts.linePayableCentavos[line.variantId] ?? 0 : null }))
  const nrpcAssessment = nrpcPreparationAssessment(nrpcMaterials, nrpcValues, { min: 3, max: 2000 })
  const moneyValid = amounts.valid && (role === 'CUSTOMER_SERVICE' || !draft.nrpc || nrpcAssessment.valid)
  async function act(action: () => Promise<void>) { setBusy(true); setError(null); try { await action() } catch (e) { setError(await readableChatError(e)) } finally { setBusy(false) } }
  return <FormDialog open={open} onClose={onClose} busy={busy} title="Prepare quotation" description={role === 'CUSTOMER_SERVICE' ? 'Save a draft for an authorized publisher to review.' : 'Add materials, confirm fulfillment, then save and publish your quotation.'} footer={<div className="flex flex-col gap-3 sm:flex-row sm:items-center sm:justify-end"><p className="text-sm text-text-secondary sm:mr-auto">{busy ? 'Saving changes...' : dirty ? 'Unsaved changes' : saved ? 'Draft saved' : 'Review your draft before publishing.'}</p><Button variant="quiet" disabled={busy} onClick={onClose}>Close</Button><Button disabled={busy || !moneyValid || !draft.lines.length || !draft.fulfillmentDate} onClick={() => void act(async () => { const result = await chatApi.draft(conversationId, lock, quotationDraftForSave(draft)); setLock(result.quotation?.lockVersion ?? lock + 1); setDirty(false); setSaved(true); await onSaved() })}>Save draft</Button>{role !== 'CUSTOMER_SERVICE' && <Button variant="secondary" disabled={busy || !moneyValid || dirty || !quotation?.draft} onClick={() => { if (window.confirm('Publish these terms? This starts a new Buyer deadline and supersedes the previous version.')) void act(async () => { await chatApi.publish(conversationId, lock, key.current); key.current = newIdempotencyKey(); await onSaved() }) }}>Publish quotation</Button>}</div>}>
    <section aria-label="Quotation draft" className="space-y-6">
    {error && <StatusMessage tone="error">{error}</StatusMessage>}{saved && <StatusMessage tone="success">Draft saved.</StatusMessage>}
    <WorkPackageAttachment reference={reference} proposal={ChatDraftContentToJSON(draft)} />
    <section className="space-y-3"><div className="sticky top-0 z-10 space-y-2 bg-surface-primary pb-2"><div><h3 className="font-semibold">Materials</h3><p className="mt-1 text-sm text-text-secondary">Add products below. Expand a material to edit its description and specifications.</p></div>
    <CatalogProductPicker active={open} disabled={busy} selectedVariantIds={draft.lines.map(line => line.variantId)} loadProducts={loadQuotationProducts} loadProduct={getListing} readableError={readableCatalogError} onAdd={(listing, variant) => {
      if (busy || !variant.price || draft.lines.some(line => line.variantId === variant.id)) return
      setNames(current => ({ ...current, [variant.id]: `${listing.displayName} · ${variant.label ?? variant.sku}` }))
      setProductDetails(current => ({ ...current, [variant.id]: { variantLabel: variant.label?.trim() || variant.sku, specifications: { ...listing.technicalAttributes, ...variant.attributes } } }))
      edit({ ...draft, lines: [...draft.lines, { variantId: variant.id, quantity: '1', unitPriceCentavos: variant.price.amountCentavos }] })
    }} />
    </div>
    {!draft.lines.length && <p className="rounded-control border border-dashed border-border-default bg-surface-canvas p-5 text-center text-sm text-text-secondary">No materials added yet. Select a product and add a variant to start your quotation.</p>}
    <QuotationMaterialsEditor lines={draft.lines} names={materialNames} productDetails={productDetails} disabled={busy} onChange={(variantId, patch) => edit({ ...draft, lines: draft.lines.map(line => line.variantId === variantId ? { ...line, ...patch } : line) })} onRemove={variantId => {
      const remaining = draft.lines.filter(line => line.variantId !== variantId)
      if (draft.nrpc && role !== 'CUSTOMER_SERVICE') {
        const nextAllocations = { ...nrpcValues.allocations }
        delete nextAllocations[variantId]
        const next = nrpcPreparationAssessment(nrpcMaterials.filter(line => line.id !== variantId), { ...nrpcValues, allocations: nextAllocations }, { min: 3, max: 2000 })
        edit({ ...draft, lines: remaining, nrpc: { ...draft.nrpc, allocations: nextAllocations, amount_centavos: next.totalCentavos ?? 0 } })
      } else edit({ ...draft, lines: remaining })
    }} />
    </section>

    <section className="space-y-4 border-t border-border-default pt-6"><h3 className="font-semibold">Fulfillment & payment</h3><div className="grid gap-4 sm:grid-cols-2">
      <label className="grid gap-2 text-sm font-semibold">Fulfillment date<input className={control} type="date" value={draft.fulfillmentDate} onChange={e => edit({ ...draft, fulfillmentDate: e.target.value })} /></label>
      <label className="grid gap-2 text-sm font-semibold">Buyer deadline (hours)<input className={control} type="number" min="1" max="72" value={draft.deadlineHours ?? 24} onChange={e => edit({ ...draft, deadlineHours: Number(e.target.value) })} /></label>
    </div>
    <p className="text-xs text-text-secondary">Online payment · Processing fee is disclosed at payment-channel selection.</p>
    <div className="mt-4 space-y-4">
      <label className="grid gap-2 text-sm font-semibold">Fulfillment<select className={control} disabled={busy} value={draft.fulfillmentMethod} onChange={e => edit({ ...draft, fulfillmentMethod: e.target.value as ChatDraftContent['fulfillmentMethod'], ...(e.target.value === 'PICKUP' && draft.discount?.scope === 'DELIVERY' ? { discount: { scope: 'MATERIALS', percent: '' } } : {}) })}><option value="PICKUP">Self-Pickup</option><option value="DELIVERY">Site Delivery</option></select></label>
      {draft.fulfillmentMethod === 'DELIVERY' && <QuotationDeliveryArrangement value={delivery} onChange={deliveryEdit} active={open} disabled={busy} loadVehicles={loadQuotationVehicles} readableError={readableChatError} />}
      <QuotationDiscountEditor draft={draft} disabled={busy} onChange={discount => edit({ ...draft, discount })} />
      {role !== 'CUSTOMER_SERVICE' && <NrpcPreparationEditor enabled={Boolean(draft.nrpc)} value={nrpcValues} materials={nrpcMaterials} reasonLimits={{ min: 3, max: 2000 }} disabled={busy} onToggle={enabled => {
        if (enabled) {
          const value = nrpcBuffer.current ?? { reason: '', allocations: {} }
          const restored = { ...value, allocations: Object.fromEntries(Object.entries(value.allocations).filter(([id]) => draft.lines.some(line => line.variantId === id))) }
          const next = nrpcPreparationAssessment(nrpcMaterials, restored, { min: 3, max: 2000 })
          edit({ ...draft, nrpc: { reason: restored.reason, allocations: restored.allocations, amount_centavos: next.totalCentavos ?? 0 } })
        } else {
          nrpcBuffer.current = nrpcValues
          const { nrpc: previous, ...rest } = draft
          void previous
          edit(rest)
        }
      }} onChange={value => {
        const next = nrpcPreparationAssessment(nrpcMaterials, value, { min: 3, max: 2000 })
        edit({ ...draft, nrpc: { ...draft.nrpc, reason: value.reason, allocations: value.allocations, amount_centavos: next.totalCentavos ?? 0 } })
      }} />}
    </div>

    </section>
  </section></FormDialog>
}
