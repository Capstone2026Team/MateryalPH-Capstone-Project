import { BackNavigation, Toolbar } from '@materyalph/web-ui'
import { WorkPackageAttachment } from '../components/WorkPackageAttachment'
import { SiteInspectionPanel } from '../components/SiteInspectionPanel'
import { Fragment, useCallback, useEffect, useId, useRef, useState } from 'react'
import { Link, useNavigate } from 'react-router-dom'
import { ChatDraftContentFromJSON, ChatDraftContentToJSON, ChatQuotationContentToJSON, type ChatDraftContent, type ChatMessage, type ChatProduct, type ChatHandler, type ChatQuotation, type ChatQuotationVersion, type ChatWorkPackageAttachment, type ConversationDetail, type DeliveryPlan } from '@materyalph/api-client-ts'
import { Button, CatalogProductPicker, CountBadge, FormDialog, ChatMessageBubble, ChatTypingIndicator, ConversationHeader, quotationSelectedVehicles, quotationVehicleChoice, quotationDeliveryFee, quotationDeliveryChanged, QuotationDestinationFields, QuotationDeliveryArrangement, QuotationDraftSummary, QuotationEditorSection, QuotationMaterialsEditor, QuotationThreadCard, QuotationVersionCard, StatusMessage, useNavigationRefresh, chatRoleLabel, conversationLabel, conversationTimeline, formatPesoCentavos, quotationDiscountPreview } from '@materyalph/web-ui'
import { FileText, MessageSquare, Paperclip, Send, UsersRound } from 'lucide-react'
import { chatApi, loadChatAvatar, readableChatError, watchConversation } from '../lib/messaging-api'
import { getListing, listListings, readableCatalogError } from '../lib/catalog-api'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { quotationDraftForSave } from '../lib/quotation-draft'
import { ErrorState, LoadingState } from './PhaseThreeVendorPages'

const control = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base'

const loadQuotationProducts = (query: string, page: number) => listListings({ ...(query ? { q: query } : {}), status: 'ACTIVE', page })
const messageDate = (at: string) => new Date(at).toLocaleDateString('en-PH', { timeZone: 'Asia/Manila', dateStyle: 'medium' })
const mergeThreadContexts = (left: ConversationDetail, right: ConversationDetail) => [...new Map([...(left.threadContexts ?? []), ...(right.threadContexts ?? [])].map(context => [context.id, context])).values()]

export function ConversationThread({ selected, role, combined = false, onBuyerThread, onBack, onRead, onMessage, onFulfillmentList, onOpenQuotationInquiry, obscured = false, onBusyChange }: {
  selected: string | null; role: string; combined?: boolean; onBuyerThread?: (id: string | undefined) => void; onBack?: () => void; onRead?: (id: string) => void; onMessage?: () => void; onFulfillmentList?: (id: string) => void; onOpenQuotationInquiry?: (id: string) => void; obscured?: boolean; onBusyChange?: (busy: boolean) => void
}) {
  const navigate = useNavigate()
  const callbacks = useRef({ onRead, onMessage, onBuyerThread, obscured })
  const [reload, setReload] = useState(0)
  const [historyOpen, setHistoryOpen] = useState(false)
  const [quotationId, setQuotationId] = useState<string | null>(null)
  const [detail, setDetail] = useState<ConversationDetail | null>(null)
  const fulfillmentCountId = useId()
  const [error, setError] = useState<string | null>(null)
  const [loading, setLoading] = useState(true)
  const [busy, setBusy] = useState(false)
  useEffect(() => { onBusyChange?.(busy) }, [busy, onBusyChange])
  const [text, setText] = useState('')
  const [product, setProduct] = useState<ChatProduct | null>(null)
  const drafts = useRef(new Map<string, { text: string; product: ChatProduct | null }>())
  const sessionClosed = useRef(false)
  const draftConversation = useRef<string | null>(null)
  const composer = useRef({ text, product })
  useEffect(() => { composer.current = { text, product } }, [text, product])
  useEffect(() => {
    const clear = () => { sessionClosed.current = true; generation.current++; currentDetail.current = null; drafts.current.clear(); composer.current = { text: '', product: null }; setText(''); setProduct(null); setDetail(null); setPending([]); setError(null); setLoading(false) }
    window.addEventListener('materyalph:session-cleared', clear)
    return () => window.removeEventListener('materyalph:session-cleared', clear)
  }, [])
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
  const [quotationContext, setQuotationContext] = useState<ConversationDetail | null>(null)
  const [handlers, setHandlers] = useState<ChatHandler[] | null>(null)
  useEffect(() => { callbacks.current = { onRead, onMessage, onBuyerThread, obscured: obscured || historyOpen || Boolean(quotationId) || editor || handlers !== null } }, [onRead, onMessage, onBuyerThread, obscured, historyOpen, quotationId, editor, handlers])
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
  const followLatest = useRef(true)
  const fileInput = useRef<HTMLInputElement>(null)
  const getDetail = useCallback((id: string, before?: string, page = 1) => combined ? chatApi.buyerThread(id, before, page) : chatApi.get(id, before, page), [combined])

  const load = useCallback(async () => {
    if (sessionClosed.current) return
    if (running.current) { reloadPending.current = true; return }
    running.current = true
    const g = generation.current
    try {
      if (selected) {
        let value = await getDetail(selected)
        const sameAuthority = !combined || value.threadAuthority === currentDetail.current?.threadAuthority
        const quotationPages = sameAuthority ? currentDetail.current?.quotations.page ?? 1 : 1
        for (let page = 2; page <= quotationPages && value.quotations.hasMore; page++) {
          const older = await getDetail(selected, undefined, page)
          if (g !== generation.current) return
          if (combined && older.threadAuthority !== value.threadAuthority) { currentDetail.current = null; setDetail(null); reloadPending.current = true; return }
          value = { ...value, threadContexts: mergeThreadContexts(value, older), quotations: { ...older.quotations, ...(value.quotations.quotation ? { quotation: value.quotations.quotation } : {}), versions: [...new Map([...value.quotations.versions, ...older.quotations.versions].map(version => [version.id, version])).values()] } }
        }
        const previous = sameAuthority ? currentDetail.current?.messages : undefined
        const anchor = previous?.items.at(-1)?.id
        if (anchor && value.messages.items.length) {
          const incoming = [...value.messages.items]
          let cursor = value.messages
          while (!incoming.some(message => message.id === anchor) && cursor.hasMore && cursor.nextBefore && cursor.items[0] && cursor.items[0].id > anchor) {
            const older = await getDetail(selected, cursor.nextBefore)
            if (g !== generation.current) return
            if (combined && older.threadAuthority !== value.threadAuthority) { currentDetail.current = null; setDetail(null); reloadPending.current = true; return }
            cursor = older.messages
            value = { ...value, threadContexts: mergeThreadContexts(value, older) }
            incoming.unshift(...cursor.items)
          }
          const merged = new Map([...previous!.items, ...incoming].map(message => [message.id, message]))
          value = { ...value, messages: { ...previous!, items: [...merged.values()].sort((a, b) => a.id.localeCompare(b.id)) } }
        }
        if (sameAuthority && currentDetail.current) value = { ...value, threadContexts: mergeThreadContexts(currentDetail.current, value) }
        if (g !== generation.current) return
        currentDetail.current = value
        setDetail(value)
        callbacks.current.onBuyerThread?.(value.conversation.buyerThreadId)
        setError(null)
        setPending(current => current.filter(message => !value.messages.items.some(saved => saved.clientMessageId === message.clientMessageId)))
        const newest = value.messages.items.at(-1)
        if (!callbacks.current.obscured && newest && lastRead.current !== newest.id && (combined ? (value.threadContexts ?? [value.conversation]).some(context => context.unreadCount > 0) : value.conversation.unreadCount > 0)) {
          lastRead.current = newest.id
          const through = combined ? new Map(value.messages.items.map(message => [message.conversationId ?? selected, message.id])) : new Map([[selected, newest.id]])
          void Promise.all([...through].map(([id, message]) => chatApi.read(id, message))).then(() => {
            if (g === generation.current) callbacks.current.onRead?.(selected)
          }).catch(() => { if (g === generation.current) lastRead.current = '' })
        }
      }
    } catch (e) { const message = await readableChatError(e); if (g === generation.current) { setError(message); setDetail(null); currentDetail.current = null } }
    finally { if (g === generation.current) { running.current = false; setLoading(false); if (reloadPending.current) { reloadPending.current = false; setReload(value => value + 1) } } }
  }, [selected, combined, getDetail])

  // Sibling-thread activity refreshes the aggregate badges without replacing composer state.
  useNavigationRefresh(() => {
    if (selected && (onFulfillmentList && currentDetail.current?.conversation.canListFulfillmentConversations)) void load()
  })

  useEffect(() => {
    if (draftConversation.current) drafts.current.set(draftConversation.current, composer.current)
    const savedDraft = selected ? drafts.current.get(selected) : undefined
    draftConversation.current = selected
    composer.current = savedDraft ?? { text: '', product: null }
    generation.current++; currentDetail.current = null; reloadPending.current = false; running.current = false; lastRead.current = ''; setLoading(true); setDetail(null); setError(null); setText(savedDraft?.text ?? ''); setProduct(savedDraft?.product ?? null); setPicker(false); setPending([]); setTyping(false); typingAt.current = 0; clearTimeout(typingTimer.current); clearTimeout(typingSendTimer.current); setEditor(false); setQuotationContext(null); setHandlers(null); setHistoryOpen(false)
    setQuotationId(null); followLatest.current = true
    void load()
    const timer = window.setInterval(() => { threadQuiet.current += 1; if (document.visibilityState === 'visible' && (!threadLive.current || threadQuiet.current >= 11)) { threadQuiet.current = 0; void load() } }, 4000)
    const requests = generation
    return () => { requests.current++; window.clearInterval(timer); clearTimeout(typingTimer.current); clearTimeout(typingSendTimer.current) }
  }, [load, selected])
  useEffect(() => { if (reload > 0) void load() }, [reload, load])
  useEffect(() => {
    if (!combined || !selected) return
    let active = true; let close: (() => void) | undefined
    void watchConversation(null, () => void load()).then(stop => { if (active) close = stop; else stop() })
    const clear = () => { active = false; close?.() }
    window.addEventListener('materyalph:session-cleared', clear)
    return () => { clear(); window.removeEventListener('materyalph:session-cleared', clear) }
  }, [combined, selected, load])
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
  const newestQuotationId = detail?.quotations.versions[0]?.id
  useEffect(() => {
    if (!callbacks.current.obscured && threadBody.current && followLatest.current) threadBody.current.scrollTop = threadBody.current.scrollHeight
  }, [newestMessageId, newestQuotationId, handlers])
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
    const message: ChatMessage = retry ?? { conversationId: detail?.conversation.id ?? selected, id: sendKey.current, clientMessageId: sendKey.current, body: text.trim(), kind: product ? (text.trim() ? 'TEXT_WITH_PRODUCT' : 'PRODUCT') : 'TEXT', ...(product ? { product } : {}), sender: { displayName: 'You', role: 'VENDOR' }, sentAt: new Date().toISOString(), mine: true, attachments: [], readByRecipient: false }
    setPending(current => [...current.filter(item => item.id !== message.id), { ...message, deliveryState: 'pending' }])
    if (!retry) { setText(''); setProduct(null); sendKey.current = newIdempotencyKey() }
    clearTimeout(typingSendTimer.current)
    void chatApi.typing(message.conversationId ?? selected, false).catch(() => undefined)
    try {
      await chatApi.send(message.conversationId ?? detail?.conversation.id ?? selected, message.body, message.clientMessageId, message.product?.productId)
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
      typingSendTimer.current = setTimeout(() => { void chatApi.typing(currentDetail.current?.conversation.id ?? selected, Boolean(value.trim())).catch(() => undefined) }, 200)
    }
  }
  async function findProducts(page = 1) {
    if (!selected) return
    const g = generation.current
    await mutate(async () => { const result = await chatApi.products(currentDetail.current?.conversation.id ?? selected, productQuery, page); if (g !== generation.current) return; setProducts(result.items); setProductPage(page); setMoreProducts(result.hasMore); setPicker(true) }, false)
  }
  async function openFile(id: string, name?: string, contextId = selected) {
    if (!contextId) return
    try { const blob = await chatApi.download(contextId, id); const url = URL.createObjectURL(blob); const a = document.createElement('a'); a.href = url; a.download = name ?? 'attachment'; a.click(); window.setTimeout(() => URL.revokeObjectURL(url), 1000) }
    catch (e) { setError(await readableChatError(e)) }
  }
  // Stable per conversation so polling re-renders never re-download a previewed image.
  const attachmentLoaders = useRef(new Map<string, (id: string) => Promise<Blob>>())
  function attachmentLoader(contextId: string) {
    let loader = attachmentLoaders.current.get(contextId)
    if (!loader) { loader = id => chatApi.download(contextId, id); attachmentLoaders.current.set(contextId, loader) }
    return loader
  }
  const c = detail?.conversation
  const fulfillmentUnreadCount = c?.fulfillmentUnreadCount ?? 0
  const canStartQuotation = c?.purpose === 'SALES' && c.contextType === 'ITEM_BASED' && !c.canonicalConversationId && role !== 'FULFILLMENT' && detail?.quotations.quotation?.state === 'ACCEPTED'
  const canPrepare = c?.purpose === 'SALES' && !c.canonicalConversationId && !c.readOnly && role !== 'FULFILLMENT' && (!detail?.quotations.quotation || detail.quotations.quotation.canDraft)
  const changeRequested = detail?.quotations.quotation?.state === 'COUNTERED'
  const timeline = detail ? conversationTimeline(detail.messages.items, detail.quotations.versions) : []
  const contexts = new Map(detail?.threadContexts?.map(context => [context.id, context]) ?? [])
  const currentVersions = detail?.quotations.versions.filter(version => !combined || version.conversationId === c?.id) ?? []
  function canRevise(version: ChatQuotationVersion) {
    if (!version.latest || version.state !== 'COUNTERED' || role === 'FULFILLMENT') return false
    if (!version.conversationId || version.conversationId === c?.id) return canPrepare
    return detail?.messages.items.some(message => message.workPackageAttachment?.inquiryId === version.conversationId && message.workPackageAttachment?.canPrepareQuotation) ?? false
  }
  async function reviseQuotation(version: ChatQuotationVersion) {
    if (version.conversationId && version.conversationId !== c?.id) {
      await openPackageQuotation({ inquiryId: version.conversationId, reference: {}, canPrepareQuotation: true })
    } else { setQuotationContext(null); setEditor(true) }
    setQuotationId(null); setHistoryOpen(false)
  }
  async function openPackageQuotation(attachment: ChatWorkPackageAttachment) {
    await mutate(async () => {
      const inquiry = attachment.orderId ? await chatApi.pendingOrderQuotation(attachment.orderId, attachment.orderLockVersion!, actionKey.current) : attachment.inquiryId
      if (!inquiry) return
      const value = await chatApi.get(inquiry)
      if (!value.quotations.quotation?.canDraft) throw new Error('This quotation is no longer available to edit. Its history is preserved.')
      setQuotationContext(value); setEditor(true)
    }, false)
  }
  const editorDetail = quotationContext ?? detail
  const editorConversation = editorDetail?.conversation
  const selectedQuotation = detail?.quotations.versions.find(version => version.id === quotationId)
  function quotationDetails(version: ChatQuotationVersion) {
    return <div className="grid gap-3">{combined && version.conversationId && contexts.get(version.conversationId)?.contextType === 'PROJECT_BASED' && <p className="text-sm font-semibold">{contexts.get(version.conversationId)?.inquiryLabel}</p>}<QuotationVersionCard version={version} busy={busy} onAction={(action, v) => { if (action === 'withdraw' && window.confirm('Withdraw this quotation? Its history will remain available.')) void mutate(() => chatApi.withdraw(v.conversationId ?? c!.id, v.id, actionKey.current)) }} />
      {version.acceptedOrderId && <Link className="inline-flex min-h-11 items-center font-semibold underline" to={`/orders/${version.acceptedOrderId}`}>Open accepted order</Link>}
      {canRevise(version) && <Button disabled={busy} onClick={() => void reviseQuotation(version)}>Revise quotation</Button>}
    </div>
  }
  async function olderQuotations() {
    const current = currentDetail.current
    if (!current || !selected) return
    const g = generation.current
    await mutate(async () => {
      const older = await getDetail(selected, undefined, (current.quotations.page ?? 1) + 1)
      if (g !== generation.current || !currentDetail.current) return
      if (combined && older.threadAuthority !== currentDetail.current.threadAuthority) { currentDetail.current = older; setDetail(older); return }
      const latest = currentDetail.current
      currentDetail.current = { ...latest, threadContexts: mergeThreadContexts(latest, older), quotations: { ...older.quotations, ...(latest.quotations.quotation ? { quotation: latest.quotations.quotation } : {}), versions: [...new Map([...latest.quotations.versions, ...older.quotations.versions].map(version => [version.id, version])).values()] } }
      setDetail(currentDetail.current)
    }, false)
  }
  return (
      <section className="chat-thread flex-1" aria-label="Selected conversation">
        {error && <StatusMessage tone="error">{error} <Button variant="quiet" onClick={() => void load()}>Retry conversation</Button></StatusMessage>}
        {!selected ? <div className="chat-empty-thread"><MessageSquare size={36} aria-hidden="true" /><h2>Your conversations, in one place</h2><p>{role === 'FULFILLMENT' ? 'Choose an assigned order conversation to coordinate fulfillment.' : combined ? 'Choose a Buyer to view all messages, reply or prepare a quotation.' : 'Choose an inquiry from the inbox to reply or prepare a quotation.'}</p></div> : <>
          <div className="chat-toolbar">{onBack && <BackNavigation><button type="button" className="chat-back" aria-label="Back to inbox" disabled={busy} onClick={onBack}>Back to inbox</button></BackNavigation>}<span className="chat-toolbar-label">{combined ? 'Buyer conversation' : c ? conversationLabel(c) : 'Conversation'}</span>{c && <>{c.canListFulfillmentConversations && onFulfillmentList && <><Button variant="quiet" onClick={() => onFulfillmentList(c.id)} aria-haspopup="dialog" aria-describedby={fulfillmentCountId}><MessageSquare size={16} aria-hidden="true" /><span>Fulfillment conversations</span><CountBadge count={fulfillmentUnreadCount} /></Button><span id={fulfillmentCountId} className="sr-only" role="status">{fulfillmentUnreadCount > 0 ? `${fulfillmentUnreadCount} unread fulfillment messages` : 'No unread fulfillment messages'}</span></>}{(combined || c.purpose === 'SALES') && <Button variant="quiet" aria-label="Quotation history" aria-haspopup="dialog" onClick={() => setHistoryOpen(true)}><FileText size={16} aria-hidden="true" /><span className="chat-action-label">Quotation history</span></Button>}{c.canTransfer && <Button variant="quiet" aria-label="Transfer handler" aria-haspopup="dialog" disabled={busy} onClick={() => void mutate(async () => { const result = await chatApi.handlers(c.id); setTarget(''); setReason(''); setHandlers(result.data); setHandlerPage(1); setMoreHandlers(Boolean(result.meta.has_more)) }, false)}><UsersRound size={16} aria-hidden="true" /><span className="chat-action-label">Transfer handler</span></Button>}</>}</div>
          {loading ? <LoadingState label="Loading conversation…" /> : detail && c ? <>
            {editorConversation && (canPrepare || quotationContext?.quotations.quotation?.canDraft) && <QuotationDraftEditor key={editorConversation.id} open={editor} onClose={() => { setEditor(false); setQuotationContext(null) }} reference={editorConversation.lockedReference} conversationId={editorConversation.id} quotation={editorDetail?.quotations.quotation ?? null} sourceNames={Object.fromEntries(editorDetail?.quotations.versions.find(version => version.latest && (!version.conversationId || version.conversationId === editorConversation.id))?.content.lines.map(line => [line.variantId, line.description]) ?? [])} role={role} onSaved={load} onPendingChange={setBusy} />}
            {historyOpen && <FormDialog open title="Quotation history" description={combined ? "Review published quotations, changes and accepted orders for this Buyer." : "Review published quotations, changes and accepted orders for this inquiry."} busy={busy} onClose={() => setHistoryOpen(false)} footer={null}><div className="grid gap-4">
              {error && <StatusMessage tone="error">{error}</StatusMessage>}
              {detail.quotations.versions.length === 0 ? <p className="py-6 text-sm text-text-secondary">Published quotations and their changes appear here.</p> : detail.quotations.versions.map(version => <Fragment key={version.id}>{quotationDetails(version)}</Fragment>)}
              {detail.quotations.hasMore && <Button variant="secondary" disabled={busy} onClick={() => void olderQuotations()}>Older quotations</Button>}
            </div></FormDialog>}
            {selectedQuotation && <FormDialog open title={`Quotation v${selectedQuotation.version}`} description="Published terms and the Buyer's response for this version." busy={busy} onClose={() => setQuotationId(null)} footer={null}>{quotationDetails(selectedQuotation)}</FormDialog>}
            <ConversationHeader combined={combined} store={c.store} buyer={c.buyer} handler={c.handler} purpose={c.purpose} loadAvatar={loadChatAvatar} />
            {!combined && <WorkPackageAttachment compact reference={c.lockedReference} proposal={currentVersions[0] ? ChatQuotationContentToJSON(currentVersions[0].content) : undefined} />}
            {c.needsHumanResponse && <p role="status" className="border-b border-border-default px-5 py-2 text-sm font-semibold">Awaiting your team's reply</p>}
            {c.purpose === 'FULFILLMENT' && c.canPrepareOrderQuotation && c.orderId && <div className="border-b border-border-default px-5 py-3"><Button variant="secondary" disabled={busy} onClick={() => void mutate(async () => { const inquiry = await chatApi.pendingOrderQuotation(c.orderId!, c.orderLockVersion!, actionKey.current); if (onOpenQuotationInquiry) onOpenQuotationInquiry(inquiry); else navigate(`/messages?conversation=${inquiry}`) }, false)}>Prepare replacement quotation</Button><p className="mt-1 text-xs text-text-secondary">The pending order stays linked until the Buyer accepts the quotation.</p></div>}
            <div className="chat-thread-body" ref={threadBody} onScroll={event => { const body = event.currentTarget; followLatest.current = body.scrollHeight - body.scrollTop - body.clientHeight < 160 }}>
        {handlers && <FormDialog open size="compact" title="Transfer handler" description="Choose an active team member and record why this inquiry is changing hands." busy={busy} onClose={() => setHandlers(null)} footer={<div className="flex justify-end gap-3"><Button variant="secondary" disabled={busy} onClick={() => setHandlers(null)}>Cancel</Button><Button form="transfer-handler-form" disabled={busy || !target || !reason.trim()} type="submit">Confirm transfer</Button></div>}>
          {error && <StatusMessage tone="error">{error}</StatusMessage>}
          <form id="transfer-handler-form" className="grid gap-4" onSubmit={e => { e.preventDefault(); void mutate(async () => { await chatApi.transfer(c.id, Number(target), c.lockVersion, reason.trim()); setHandlers(null); setTarget(''); setReason('') }) }}>
            <label className="grid gap-2 text-sm font-semibold">New handler<select className={control} required disabled={busy} value={target} onChange={e => setTarget(e.target.value)}><option value="">Choose active staff</option>{handlers.map(h => <option key={h.id} value={h.id}>{h.displayName} · {chatRoleLabel(h.role)}</option>)}</select></label>
            <label className="grid gap-2 text-sm font-semibold">Transfer reason<textarea className={control} required disabled={busy} rows={3} maxLength={500} value={reason} onChange={e => setReason(e.target.value)} /></label>
            {handlers.length === 0 && <p role="status">No eligible handlers are available.</p>}
            {moreHandlers && <Button variant="secondary" disabled={busy} onClick={() => void mutate(async () => { const result = await chatApi.handlers(c.id, handlerPage + 1); setHandlers([...handlers, ...result.data]); setHandlerPage(handlerPage + 1); setMoreHandlers(Boolean(result.meta.has_more)) }, false)}>More handlers</Button>}
            <p className="text-sm text-text-secondary">Their fixed role continues to determine what they may do. Earlier messages keep their original attribution.</p>
          </form>
        </FormDialog>}
              <SiteInspectionPanel inspections={detail.siteInspections ?? []} busy={busy} onPrepareQuotation={canPrepare ? () => setEditor(true) : undefined} onDecide={async (inspection, action, decision) => {
                try { await chatApi.siteInspection(c.id, inspection.id, action, decision) } catch (cause) { throw new Error(await readableChatError(cause)) }
                await load()
              }} />

              <div className="chat-timeline">
                {detail.messages.hasMore && <div className="mb-5 text-center"><Button variant="secondary" disabled={busy} onClick={() => void mutate(async () => { const older = await getDetail(c.id, detail.messages.nextBefore ?? undefined); currentDetail.current = combined && older.threadAuthority !== detail.threadAuthority ? older : { ...detail, threadContexts: mergeThreadContexts(detail, older), messages: { ...older.messages, items: [...older.messages.items, ...detail.messages.items] } }; lastRead.current = ''; setDetail(currentDetail.current) }, false)}>Earlier messages</Button></div>}
                {detail.quotations.hasMore && <div className="mb-5 text-center"><Button variant="secondary" disabled={busy} onClick={() => void olderQuotations()}>Earlier quotations</Button></div>}
                <ol aria-label="Conversation messages">{timeline.map((entry, index) => <Fragment key={entry.id}>
                  {(index === 0 || messageDate(timeline[index - 1]!.timestamp) !== messageDate(entry.timestamp)) && <li className="text-center text-xs font-semibold text-text-secondary"><time dateTime={entry.timestamp}>{messageDate(entry.timestamp)} · Manila</time></li>}
                  {entry.kind === 'message' ? <ChatMessageBubble message={entry.message} onPrepareWorkPackage={attachment => void openPackageQuotation(attachment)} onOpenAttachment={(id, file) => void openFile(id, file?.displayName, entry.message.conversationId ?? c.id)} loadAttachment={attachmentLoader(entry.message.conversationId ?? c.id)} onOpenProduct={id => navigate(`/products/${id}`)} /> : <li className="flex justify-end"><QuotationThreadCard version={entry.quotation} busy={busy} onOpen={() => setQuotationId(entry.quotation.id)} {...(canRevise(entry.quotation) ? { onRevise: () => void reviseQuotation(entry.quotation) } : {})} /></li>}
                </Fragment>)}{pending.map(message => <ChatMessageBubble key={message.id} message={message} deliveryState={message.deliveryState} onRetry={() => void sendMessage(message)} onOpenAttachment={() => undefined} onOpenProduct={id => navigate(`/products/${id}`)} />)}</ol>
                {timeline.length === 0 && <p className="py-10 text-center text-sm text-text-secondary">Start with a helpful reply about products or fulfillment.</p>}
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
              {canPrepare && <div className="chat-composer-hint"><FileText size={15} aria-hidden="true" /><span>{changeRequested ? 'The Buyer requested changes to the latest quotation.' : c.contextType === 'PROJECT_BASED' ? 'Prepare a quotation for this Work Package.' : 'Turn a product inquiry into a quotation.'}</span><button type="button" disabled={busy} aria-haspopup="dialog" onClick={() => {
                  if (c.canPrepareOrderQuotation && c.pendingOrderId) void mutate(async () => { await chatApi.pendingOrderQuotation(c.pendingOrderId!, c.orderLockVersion!, actionKey.current); await load(); setEditor(true) }, false)
                  else setEditor(true)
                }}>{changeRequested ? 'Revise quotation' : 'Prepare quotation'}</button></div>}
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

export function QuotationDraftEditor({ open, onClose, conversationId, quotation, role, onSaved, reference, sourceNames = {}, onPendingChange }: { open: boolean; onClose: () => void; conversationId: string; quotation?: ChatQuotation | null; role: string; onSaved: () => Promise<void>; reference?: unknown; sourceNames?: Record<string, string>; onPendingChange?: (pending: boolean) => void }) {
  const [draft, setDraft] = useState<ChatDraftContent>(() => quotation?.draft ? ChatDraftContentFromJSON(quotation.draft) : { lines: [], fulfillmentMethod: 'PICKUP', fulfillmentDate: '', deadlineHours: 24, discount: { scope: 'MATERIALS', percent: '' } })
  const [names, setNames] = useState<Record<string, string>>({})
  const [productDetails, setProductDetails] = useState<Record<string, { variantLabel: string; specifications: Record<string, string>; unitCode?: string; quantityPolicy?: import('@materyalph/api-client-ts').QuantityPolicy | undefined }>>({})
  const [error, setError] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [dirty, setDirty] = useState(false)
  const [saved, setSaved] = useState(false)
  const [saving, setSaving] = useState(false)
  const [locationBusy, setLocationBusy] = useState(false)
  useEffect(() => { onPendingChange?.(dirty || busy || saving || locationBusy); return () => onPendingChange?.(false) }, [dirty, busy, saving, locationBusy, onPendingChange])
  const latest = useRef(draft)
  const lock = useRef(quotation?.lockVersion ?? 1)
  const revision = useRef(0)
  const savedRevision = useRef(0)
  const inFlight = useRef<Promise<void> | null>(null)
  const mounted = useRef(true)
  useEffect(() => { mounted.current = true; return () => { mounted.current = false } }, [])
  useEffect(() => {
    // Ignore an older poll response while our save or publish response is in flight.
    if (!dirty && !busy && !inFlight.current && quotation && quotation.lockVersion >= lock.current) {
      lock.current = quotation.lockVersion
      if (quotation.draft) { const value = ChatDraftContentFromJSON(quotation.draft); latest.current = value; setDraft(value) }
    }
  }, [quotation, dirty, busy])
  const [planResult, setPlanResult] = useState<{ input: string; value: DeliveryPlan } | null>(null)
  const [planError, setPlanError] = useState<string | null>(null)
  const [planBusy, setPlanBusy] = useState(false)
  const [planRetry, setPlanRetry] = useState(0)
  const planInput = JSON.stringify({ lines: draft.lines.map(({ variantId, quantity, unitPriceCentavos }) => ({ variantId, quantity, unitPriceCentavos })), fulfillmentMethod: draft.fulfillmentMethod, ...(draft.destination ? { destination: quotationDraftForSave(draft).destination } : {}), delivery: { access_confirmed: draft.delivery?.access_confirmed === true, heavy_vehicle_access_confirmed: draft.delivery?.heavy_vehicle_access_confirmed === true } })
  const plan = planResult?.input === planInput ? planResult.value : null
  const delivery = draft.delivery ?? {}
  const deliveryEdit = (patch: Record<string, unknown>) => {
    const next = { ...delivery, ...patch }
    if (plan && next.fee_override !== true) next.final_fee_centavos = quotationDeliveryFee(plan, quotationSelectedVehicles(next.vehicles)) ?? -1
    edit({ ...draft, delivery: next })
  }
  const key = useRef(newIdempotencyKey())
  const edit = (value: ChatDraftContent) => { latest.current = value; revision.current++; setDraft(value); setDirty(true); setSaved(false); setError(null); key.current = newIdempotencyKey() }
  const applyEdit = useRef(edit)
  applyEdit.current = edit
  useEffect(() => {
    if (!open || draft.fulfillmentMethod !== 'DELIVERY' || !draft.lines.length) return
    let current = true
    setPlanBusy(true); setPlanError(null)
    const timer = window.setTimeout(() => {
      void chatApi.quotationDelivery(conversationId, quotationDraftForSave(JSON.parse(planInput) as ChatDraftContent)).then(result => {
        if (!current) return
        setPlanResult({ input: planInput, value: result })
        const existing = latest.current.delivery ?? {}
        // A restored selection survives opening the editor. Changed inputs receive a fresh recommendation.
        const selected = quotationSelectedVehicles(existing.vehicles)
        const keepSelection = planResult === null && selected.length > 0
        const vehicles = keepSelection ? selected : result.groups.flatMap(group => group.candidates[0] ? [quotationVehicleChoice(group.key, group.candidates[0])] : [])
        const fee = quotationDeliveryFee(result, vehicles)
        if (vehicles.length && fee !== null) applyEdit.current({ ...latest.current, delivery: { ...existing, vehicles, ...(existing.fee_override === true ? {} : { final_fee_centavos: fee }) } })
      }).catch(async cause => { const message = await readableChatError(cause); if (current) setPlanError(message) }).finally(() => { if (current) setPlanBusy(false) })
    }, 550)
    return () => { current = false; window.clearTimeout(timer) }
  // Only load-affecting input changes trigger provider work; edits to notes and fees do not.
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [open, conversationId, planInput, planRetry])
  const saveDraft = useCallback(async () => {
    // Serialize writes and retain changes typed while an earlier save was running.
    while (savedRevision.current < revision.current) {
      if (inFlight.current) { await inFlight.current; continue }
      const savingRevision = revision.current
      const value = quotationDraftForSave(latest.current)
      setSaving(true)
      const request = (async () => {
        const result = await chatApi.draft(conversationId, lock.current, value)
        lock.current = result.quotation?.lockVersion ?? lock.current + 1
        savedRevision.current = savingRevision
        if (mounted.current && savingRevision === revision.current) { setDirty(false); setSaved(true) }
      })()
      inFlight.current = request
      try { await request } finally { inFlight.current = null; if (mounted.current) setSaving(false) }
    }
  }, [conversationId])
  useEffect(() => {
    if (!dirty || busy || error) return
    const timer = window.setTimeout(() => { void saveDraft().catch(async e => { const message = await readableChatError(e); if (mounted.current) setError(message) }) }, 800)
    return () => window.clearTimeout(timer)
  }, [draft, dirty, busy, error, saveDraft])
  const materialNames = { ...sourceNames, ...names }
  const amounts = quotationDiscountPreview(draft)
  const moneyValid = amounts.valid
  const deliveryPending = draft.fulfillmentMethod === 'DELIVERY' && (!plan || planBusy || Boolean(planError) || locationBusy || !plan.groups.length || plan.groups.some(group => !quotationSelectedVehicles(delivery.vehicles).some(row => (row.group_key ?? plan.groups[0]?.key) === group.key && (group.status === 'MANUAL_REVIEW_REQUIRED' ? group.manualReviewVehicles ?? [] : group.candidates).some(vehicle => vehicle.vehicleId === row.vehicle_id))) || !Array.isArray(delivery.vehicles) || delivery.vehicles.length === 0 || typeof delivery.final_fee_centavos !== 'number' || delivery.final_fee_centavos < 0)
  const deliveryReady = draft.fulfillmentMethod !== 'DELIVERY' || (role !== 'STORE_STAFF' && !deliveryPending && delivery.access_confirmed === true && Boolean(String(delivery.arrangement ?? '').trim()) && (!quotationDeliveryChanged(plan, delivery) || String(delivery.change_reason ?? '').trim().length >= 10))
  async function act(action: () => Promise<void>) { if (busy) return; setBusy(true); setError(null); try { await action() } catch (e) { setError(await readableChatError(e)) } finally { if (mounted.current) setBusy(false) } }
  const close = () => { void act(async () => { await saveDraft(); await onSaved(); onClose() }) }
  return <FormDialog open={open} onClose={close} busy={busy || locationBusy} title="Prepare quotation" bodyClassName="min-h-0 overflow-y-auto overscroll-contain bg-surface-canvas px-4 py-4 sm:px-6 sm:py-5" description={role === 'CUSTOMER_SERVICE' ? 'Prepare the details for an authorized publisher to review. Changes save automatically.' : 'Review your offer before publishing.'} footer={<div className="flex flex-wrap items-center justify-end gap-x-3 gap-y-2"><div className="min-w-0 basis-full sm:mr-auto sm:basis-auto"><p className="text-sm font-semibold tabular-nums">Quotation order total: {amounts.valid && !deliveryPending ? formatPesoCentavos(amounts.total) : draft.fulfillmentMethod === 'DELIVERY' ? 'Awaiting delivery fee' : 'Complete materials'}</p><p className="text-xs text-text-secondary">Before e-wallet transaction fees.</p><p role="status" className="mt-1 text-xs text-text-secondary">{busy ? 'Finishing quotation…' : saving ? 'Saving changes…' : error ? dirty ? 'Changes could not be saved. Retry before leaving.' : 'Review the issue above before publishing.' : dirty ? 'Waiting to save…' : saved ? 'All changes saved' : 'Changes save automatically.'}</p></div><Button variant="quiet" disabled={busy || locationBusy} onClick={close}>Close</Button>{role !== 'CUSTOMER_SERVICE' && <Button disabled={busy || !moneyValid || !deliveryReady || !draft.lines.length || !draft.fulfillmentDate} onClick={() => { if (window.confirm('Publish these terms? This starts a new Buyer deadline and supersedes the previous version.')) void act(async () => { await saveDraft(); await chatApi.publish(conversationId, lock.current, key.current); key.current = newIdempotencyKey(); lock.current++; onClose(); await onSaved() }) }}>Publish quotation</Button>}</div>}>
    <section aria-label="Quotation draft" className="space-y-5">
    {error && <StatusMessage tone="error">{error} {dirty && <Button variant="quiet" disabled={busy || saving} onClick={() => void act(saveDraft)}>Retry saving</Button>}</StatusMessage>}{quotation?.draft?.nrpc != null && <StatusMessage tone="info">NRPC is now set only on eligible orders awaiting Vendor confirmation. An Owner, Store Manager or Store Staff must save this draft to remove its previous NRPC before publishing.</StatusMessage>}
    <WorkPackageAttachment reference={reference} proposal={ChatDraftContentToJSON(draft)} />
    <div className="grid min-w-0 items-start gap-6 lg:grid-cols-[minmax(0,1fr)_17rem]">
    <div className="min-w-0 space-y-5">
    <QuotationEditorSection number={1} title="Materials" description="Add products, then review quantities and prices. Expand a line to edit its details.">
    <CatalogProductPicker active={open} disabled={busy} selectedVariantIds={draft.lines.map(line => line.variantId)} loadProducts={loadQuotationProducts} loadProduct={getListing} readableError={readableCatalogError} onAdd={(listing, variant) => {
      if (busy || !variant.price || draft.lines.some(line => line.variantId === variant.id)) return
      setNames(current => ({ ...current, [variant.id]: `${listing.displayName} · ${variant.label ?? variant.sku}` }))
      setProductDetails(current => ({ ...current, [variant.id]: { variantLabel: variant.label?.trim() || variant.sku, unitCode: variant.unitCode, quantityPolicy: variant.quantityPolicy, specifications: { ...listing.technicalAttributes, ...variant.attributes } } }))
      edit({ ...draft, lines: [...draft.lines, { variantId: variant.id, quantity: '1', unitPriceCentavos: variant.price.amountCentavos }] })
    }} />
    {!draft.lines.length && <p className="rounded-control border border-dashed border-border-default bg-surface-canvas p-5 text-center text-sm text-text-secondary">No materials added yet. Select a product and add a variant to start your quotation.</p>}
    <QuotationMaterialsEditor lines={draft.lines} names={materialNames} productDetails={productDetails} disabled={busy} onChange={(variantId, patch) => edit({ ...draft, lines: draft.lines.map(line => line.variantId === variantId ? { ...line, ...patch } : line) })} onRemove={variantId => {
      const remaining = draft.lines.filter(line => line.variantId !== variantId)
      edit({ ...draft, lines: remaining })
    }} />
    </QuotationEditorSection>

    <QuotationEditorSection number={2} title="Fulfillment" description="Set the schedule and confirm how the Buyer will receive the materials.">
    <label className="grid gap-2 text-sm font-semibold">Fulfillment<select className={`${control} font-normal`} disabled={busy} value={draft.fulfillmentMethod} onChange={e => edit({ ...draft, fulfillmentMethod: e.target.value as ChatDraftContent['fulfillmentMethod'], ...(e.target.value === 'PICKUP' && draft.discount?.scope === 'DELIVERY' ? { discount: { scope: 'MATERIALS', percent: '' } } : {}) })}><option value="PICKUP">Self-Pickup</option><option value="DELIVERY">Site Delivery</option></select></label>
    <div className="grid gap-4 sm:grid-cols-2">
      <label className="grid gap-2 text-sm font-semibold">Fulfillment date<input className={`${control} font-normal`} type="date" value={draft.fulfillmentDate ?? ''} disabled={busy} onChange={e => edit({ ...draft, fulfillmentDate: e.target.value })} /></label>
      <label className="grid gap-2 text-sm font-semibold">Buyer deadline (hours)<input className={`${control} font-normal`} type="number" min="1" max="72" disabled={busy} value={draft.deadlineHours ?? 24} onChange={e => edit({ ...draft, deadlineHours: Number(e.target.value) })} /></label>
    </div>
      {draft.fulfillmentMethod === 'DELIVERY' && <>
        {role === 'STORE_STAFF' && <StatusMessage tone="info">Prepare the delivery details for an Owner or Store Manager to confirm and publish.</StatusMessage>}
        <QuotationDestinationFields value={draft.destination} reference={reference} disabled={busy} onChange={destination => {
          const previous = latest.current.destination
          const endpointChanged = previous?.intendedAddressId !== destination.intendedAddressId || previous?.alternateAddressId !== destination.alternateAddressId || previous?.heavyVehicleRestriction !== destination.heavyVehicleRestriction
          edit({ ...latest.current, destination, ...(endpointChanged ? { delivery: { ...latest.current.delivery, access_confirmed: false, heavy_vehicle_access_confirmed: false } } : {}) })
        }} onPickerOpenChange={setLocationBusy} mapBrowserKey={import.meta.env.VITE_GOOGLE_MAPS_BROWSER_KEY} search={selection => chatApi.quotationLocation(conversationId, selection)} readableError={readableChatError} />
        <QuotationDeliveryArrangement value={delivery} onChange={deliveryEdit} plan={plan} loading={planBusy} error={planError} disabled={busy} onRetry={() => setPlanRetry(value => value + 1)} />
      </>}
    <p className="rounded-control bg-surface-canvas p-3 text-xs leading-relaxed text-text-secondary"><span className="font-semibold text-text-strong">Buyer payment choice</span><br />The Buyer chooses {draft.fulfillmentMethod === 'DELIVERY' ? 'Cash on Delivery or Online payment' : 'In-Store Payment or Online payment'} before accepting, subject to your enabled payment methods. Online e-wallet transaction fees are shown when they select a payment channel.</p>
    </QuotationEditorSection>
    <QuotationEditorSection number={3} title="Message to Buyer" description="Add a personal note or explain the offer. This is included in the published quotation.">
      <label className="grid gap-2 text-sm font-semibold">Message to Buyer (optional)<textarea className={`${control} font-normal`} rows={3} maxLength={5000} disabled={busy} value={draft.message ?? ''} placeholder="Explain your offer or add a note for the Buyer…" onChange={e => edit({ ...draft, message: e.target.value })} /></label>
    </QuotationEditorSection>
    </div>
    <QuotationDraftSummary draft={draft} deliveryPending={deliveryPending} disabled={busy} onDiscountChange={discount => edit({ ...draft, discount })} />
    </div>
  </section></FormDialog>
}
