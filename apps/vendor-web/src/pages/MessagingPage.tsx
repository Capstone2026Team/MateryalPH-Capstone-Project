import { useEffect, useRef, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import type { ConversationView } from '@materyalph/api-client-ts'
import { Button, ConversationInbox, StatusMessage, useNavigationRefresh } from '@materyalph/web-ui'
import { chatApi, loadChatAvatar, readableChatError, watchConversation } from '../lib/messaging-api'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, VendorShell } from './PhaseThreeVendorPages'
import { ConversationThread } from './ConversationThread'
import { FulfillmentConversationDialog } from './FulfillmentConversationDialog'
import { ProjectInquiryDialog } from './ProjectInquiryDialog'

export function VendorMessagesPage() {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  return <VendorShell activeHref="/messages" accountLabel="Vendor" navigationData={snapshot}>
    {loading ? <LoadingState label="Loading messages…" /> : error || !snapshot ? <ErrorState message={error ?? 'Account unavailable.'} onRetry={() => void refresh()} /> : !snapshot.permissions.includes('portal.messages') ? <StatusMessage tone="error">Your role cannot access conversations.</StatusMessage> : <MessagingWorkspace role={snapshot.permissions.includes('quotations.publish') ? 'PUBLISHER' : snapshot.permissions.includes('orders.confirm') ? 'CUSTOMER_SERVICE' : 'FULFILLMENT'} />}
  </VendorShell>
}

export function MessagingWorkspace({ role }: { role: string }) {
  const [params, setParams] = useSearchParams()
  const selected = params.get('conversation')
  const [fulfillmentOpen, setFulfillmentOpen] = useState(false)
  const [projectsOpen, setProjectsOpen] = useState(false)
  const [busy, setBusy] = useState(false)
  const [rows, setRows] = useState<ConversationView[]>([])
  const [page, setPage] = useState(1)
  const [more, setMore] = useState(false)
  const [inboxLoading, setInboxLoading] = useState(true)
  const [inboxError, setInboxError] = useState<string | null>(null)
  const [inboxRefresh, setInboxRefresh] = useState(0)
  const refreshInbox = useRef<() => void>(() => {})
  useNavigationRefresh(() => refreshInbox.current())
  useEffect(() => {
    let active = true
    let fetching = false
    let pendingFetch = false
    setInboxLoading(true); setInboxError(null)
    async function fetchInbox() {
      if (!active) return
      if (fetching) { pendingFetch = true; return }
      fetching = true
      try {
        const result = await chatApi.list(page)
        if (active) { setRows(result.items); setMore(result.hasMore); setInboxError(null) }
      } catch (e) { const message = await readableChatError(e); if (active) setInboxError(message) }
      finally { fetching = false; if (active) { setInboxLoading(false); if (pendingFetch) { pendingFetch = false; void fetchInbox() } } }
    }
    refreshInbox.current = () => void fetchInbox()
    void fetchInbox()
    let stop: (() => void) | undefined
    let live = false
    let quiet = 0
    void watchConversation(null, () => void fetchInbox(), undefined, undefined, value => { live = value }).then(close => { if (active) stop = close; else close() })
    // Realtime pushes changes; poll every 4 seconds only while the socket is down, otherwise every 45.
    const timer = window.setInterval(() => { quiet += 1; if (document.visibilityState === 'visible' && (!live || quiet >= 11)) { quiet = 0; void fetchInbox() } }, 4000)
    const clearSession = () => {
      active = false
      refreshInbox.current = () => {}
      stop?.(); window.clearInterval(timer)
      setRows([]); setMore(false); setProjectsOpen(false); setFulfillmentOpen(false)
    }
    window.addEventListener('materyalph:session-cleared', clearSession)
    return () => { active = false; refreshInbox.current = () => {}; stop?.(); window.clearInterval(timer); window.removeEventListener('materyalph:session-cleared', clearSession) }
  }, [page, inboxRefresh])

  return <div className="chat-workspace">
    <h1 className="sr-only">Messages</h1>
    <div className={`chat-layout ${selected ? 'has-selection' : ''}`}>
      <aside className="chat-sidebar" aria-label="Conversation inbox">
        <div className="chat-sidebar-heading"><h2>Inbox</h2><span>Page {page}</span></div>
        <div className="chat-sidebar-scroll">
          {inboxLoading ? <LoadingState label="Loading inbox…" /> : inboxError ? <div className="p-4"><StatusMessage tone="error">{inboxError}</StatusMessage><Button variant="quiet" onClick={() => setInboxRefresh(value => value + 1)}>Retry inbox</Button></div> : <ConversationInbox loadAvatar={loadChatAvatar} rows={rows} selected={selected} disabled={busy} onSelect={id => setParams({ conversation: id })} />}
        </div>
        <div className="chat-pagination"><Button variant="quiet" disabled={page === 1 || inboxLoading} onClick={() => setPage(value => value - 1)}>Previous</Button><Button variant="quiet" disabled={!more || inboxLoading} onClick={() => setPage(value => value + 1)}>Next</Button></div>
      </aside>
      <ConversationThread selected={selected} role={role} onBack={() => setParams({})} obscured={fulfillmentOpen || projectsOpen} onBusyChange={setBusy}
        onRead={() => refreshInbox.current()} onProjectList={() => setProjectsOpen(true)} onOpenMain={id => setParams({ conversation: id })}
        onMessage={() => setInboxRefresh(value => value + 1)} onFulfillmentList={() => setFulfillmentOpen(true)} />
    </div>
    {fulfillmentOpen && selected && <FulfillmentConversationDialog inquiryId={selected} onClose={() => setFulfillmentOpen(false)} />}
    {projectsOpen && selected && <ProjectInquiryDialog inquiryId={selected} role={role} onClose={() => { setProjectsOpen(false); refreshInbox.current(); window.dispatchEvent(new Event('materyalph:domain-refresh')) }} />}
  </div>
}
