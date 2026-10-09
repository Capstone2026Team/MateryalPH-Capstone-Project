import { useEffect, useState } from 'react'
import type { FulfillmentConversationPage } from '@materyalph/api-client-ts'
import { Button, FormDialog, formatManilaDateTime, orderStateLabel } from '@materyalph/web-ui'
import { ArrowLeft } from 'lucide-react'
import { chatApi, readableChatError } from '../lib/messaging-api'
import { ErrorState, LoadingState } from './PhaseThreeVendorPages'
import { ConversationThread } from './ConversationThread'

/** Both entry points share the same thread, while the underlying order/inquiry stays mounted. */
export function FulfillmentConversationDialog({ inquiryId, conversationId, onClose }: {
  inquiryId?: string; conversationId?: string; onClose: () => void
}) {
  const [selected, setSelected] = useState(conversationId ?? null)
  const [page, setPage] = useState(1)
  const [result, setResult] = useState<FulfillmentConversationPage | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)

  useEffect(() => {
    if (!inquiryId || selected) return
    let active = true
    setLoading(true); setError(null)
    chatApi.fulfillmentConversations(inquiryId, page)
      .then(value => { if (active) setResult(value) })
      .catch(async cause => { const message = await readableChatError(cause); if (active) setError(message) })
      .finally(() => { if (active) setLoading(false) })
    return () => { active = false }
  }, [inquiryId, page, selected, attempt])

  return <FormDialog open title="Fulfillment conversations" description={selected ? 'Order-specific pickup and delivery coordination' : 'Active order conversations first, followed by read-only history.'}
    onClose={onClose} footer={null} bodyClassName="flex h-[min(44rem,75dvh)] min-h-0 flex-col overflow-hidden">
    {selected ? <>
      {inquiryId && <div className="shrink-0 border-b border-border-default px-4"><Button variant="quiet" onClick={() => setSelected(null)}><ArrowLeft size={16} aria-hidden="true" />Back to conversations</Button></div>}
      <ConversationThread key={selected} selected={selected} role="FULFILLMENT" />
    </> : <div className="min-h-0 overflow-y-auto p-5">
      {loading ? <LoadingState label="Loading fulfillment conversations…" /> : error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : <>
        {result?.items.length === 0 && <p className="py-8 text-sm text-text-secondary">No fulfillment conversations yet. They open when an order is ready for pickup or out for delivery.</p>}
        <ul aria-label="Buyer fulfillment conversations" className="divide-y divide-border-default">
          {result?.items.map(row => <li key={row.conversationId}>
            <button type="button" className="flex min-h-11 w-full flex-wrap items-center justify-between gap-3 rounded-control p-4 text-left hover:bg-surface-canvas" onClick={() => setSelected(row.conversationId)}>
              <span className="grid gap-1"><strong className="text-sm text-text-strong">{row.orderReference}</strong>
                <span className="text-sm text-text-secondary">{orderStateLabel(row.orderState)} · {row.fulfillmentMethod === 'PICKUP' ? 'Self-Pickup' : 'Site Delivery'}</span>
                <span className="text-xs text-text-secondary">{formatManilaDateTime(row.updatedAt)}</span></span>
              <span className="grid gap-1 text-right text-xs"><span>{row.readOnly ? 'Read-only history' : 'Active conversation'}</span>{row.unreadCount > 0 && <strong className="text-action-primary">{row.unreadCount} unread</strong>}</span>
            </button>
          </li>)}
        </ul>
        {result && <nav aria-label="Fulfillment conversation pages" className="mt-4 flex items-center justify-between gap-3">
          <Button variant="quiet" disabled={page === 1} onClick={() => setPage(value => value - 1)}>Previous</Button><span className="text-xs">Page {result.page}</span>
          <Button variant="quiet" disabled={!result.hasMore} onClick={() => setPage(value => value + 1)}>Next</Button>
        </nav>}
      </>}
    </div>}
  </FormDialog>
}
