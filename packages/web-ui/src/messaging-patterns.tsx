import { useEffect, useState } from 'react'
import type { ChatAttachment, ChatIdentity, ChatMessage, ChatQuotationVersion, ChatStore, ConversationView } from '@materyalph/api-client-ts'
import { BadgeCheck, Check, CheckCheck, Download, FileText, ImageOff, MessageSquare, Search } from 'lucide-react'
import { Button } from './button'
import { CountBadge } from './count-badge'
import { DeadlineCountdown, formatPesoCentavos } from './order-patterns'
import { quotationChangeNotes, type QuotationChangeNote } from './quotation-changes'
import { QuotationMaterialLines, QuotationPaymentBreakdown } from './quotation-details'
import './messaging-patterns.css'

export const conversationLabel = (conversation: ConversationView) => conversation.purpose === 'FULFILLMENT' ? 'Order coordination' : conversation.contextType === 'PROJECT_BASED' ? conversation.inquiryLabel ?? 'Project inquiry' : 'Inquiry'

export function ConversationInbox({ rows, selected, onSelect, disabled = false, loadAvatar }: { rows: ConversationView[]; selected: string | null; onSelect: (id: string) => void; disabled?: boolean; loadAvatar?: (path: string) => Promise<Blob> }) {
  const [query, setQuery] = useState('')
  const visible = rows.filter(row => `${row.buyer?.displayName ?? ''} ${row.lastMessagePreview ?? ''} ${conversationLabel(row)} ${row.handler?.displayName ?? ''} ${row.orderId ?? ''} ${row.id}`.toLowerCase().includes(query.trim().toLowerCase()))
  return <>
    <div className="chat-inbox-search"><label><Search size={16} aria-hidden="true" /><span className="sr-only">Search conversations on this page</span><input type="search" placeholder="Search conversations…" value={query} onChange={event => setQuery(event.target.value)} /></label><p>Search inquiries, handlers or references on this page.</p></div>
    <ul className="chat-inbox-list" aria-label="Conversations">{visible.map(row => {
      const unreadCount = row.unreadCount + (row.canListFulfillmentConversations ? row.fulfillmentUnreadCount ?? 0 : 0)
      return <li key={row.id}>
        <button type="button" className="chat-inbox-row" aria-current={row.id === selected ? 'true' : undefined} disabled={disabled} onClick={() => onSelect(row.id)}>
          <ChatAvatar name={row.buyer?.displayName ?? 'Buyer'} path={row.buyer?.avatarPath} load={loadAvatar} />
          <span className="chat-inbox-copy"><span className="chat-inbox-title">{row.buyer?.displayName ?? conversationLabel(row)}</span><span className="chat-inbox-preview">{row.lastMessagePreview || (row.handler ? `Handled by ${row.handler.displayName}` : 'Needs a handler')}</span><span className="chat-inbox-reference">{row.orderId ? `Order · ${row.orderId.slice(-8)}` : conversationLabel(row)}</span></span>
          <span className="chat-inbox-meta"><time dateTime={row.updatedAt}>{new Date(row.updatedAt).toLocaleDateString('en-PH', { timeZone: 'Asia/Manila', month: 'short', day: 'numeric' })}</time>{unreadCount > 0 && <><CountBadge count={unreadCount} /><span className="sr-only">{unreadCount} unread messages</span></>}</span>
        </button>
      </li>
    })}</ul>
    {visible.length === 0 && <p className="chat-inbox-empty" role="status">{rows.length ? 'No matching conversations on this page.' : 'No conversations yet. Buyer inquiries will appear here.'}</p>}
  </>
}

/** The server's body for an attachment-only message; it adds nothing beside the file itself. */
const attachmentPlaceholder = (message: ChatMessage) => message.kind === 'ATTACHMENT' && message.body === 'Attachment' && message.attachments.length > 0

export function ChatMessageBubble({ message, onOpenAttachment, loadAttachment, onOpenProduct, deliveryState, onRetry }: { message: ChatMessage; onOpenAttachment: (id: string, attachment?: ChatAttachment) => void; loadAttachment?: (id: string) => Promise<Blob>; onOpenProduct?: (listingId: string) => void; deliveryState?: 'pending' | 'failed'; onRetry?: () => void }) {
  const date = new Date(message.sentAt)
  const timestamp = <time dateTime={message.sentAt} title={`${date.toLocaleString('en-PH', { timeZone: 'Asia/Manila' })} · Manila`}>{date.toLocaleTimeString('en-PH', { timeZone: 'Asia/Manila', hour: 'numeric', minute: '2-digit' })}</time>
  if (message.kind === 'SYSTEM') return <li className="chat-system-message"><p>{message.body}</p>{timestamp}</li>
  return <li className={`chat-message ${message.mine ? 'is-mine' : ''}`}>
    <ChatAvatar name={message.sender.displayName} />
    <div className="chat-message-content"><p className="chat-message-author">{message.sender.displayName} · {chatRoleLabel(message.sender.role)}</p>
      <div className="chat-message-bubble">{message.body && !attachmentPlaceholder(message) && <p>{message.body}</p>}{message.product && <button type="button" disabled={!message.product.available || !onOpenProduct} onClick={() => onOpenProduct?.(message.product!.listingId)} className="flex min-h-11 items-center gap-3 p-3 text-left">{message.product.imageUrl && <img src={message.product.imageUrl} alt="" className="size-12 object-cover" />}<span><strong className="block">{message.product.name}</strong>{formatPesoCentavos(message.product.priceCentavos)}{!message.product.available && <span className="block">No longer available</span>}</span></button>}{message.attachments.map(file => loadAttachment && file.scanState === 'CLEAN' && file.mediaType.startsWith('image/')
        ? <ChatImageAttachment key={file.id} attachment={file} load={loadAttachment} onDownload={() => onOpenAttachment(file.id, file)} />
        : <ChatAttachmentButton key={file.id} attachment={file} onOpen={() => onOpenAttachment(file.id, file)} />)}</div>
      {deliveryState ? <p role="status">{deliveryState === 'pending' ? 'Sending…' : <button className="min-h-11 underline" type="button" onClick={onRetry}>Failed to send · Retry</button>}</p> :
      <p className="chat-message-time">{timestamp}{message.mine && <><span aria-hidden="true">·</span>{message.readByRecipient ? <CheckCheck size={13} aria-hidden="true" /> : <Check size={13} aria-hidden="true" />}<span>{message.readByRecipient ? 'Read' : 'Sent'}</span></>}</p>
      }
    </div>
  </li>
}

/**
 * The other side's live typing signal. The event carries no identity, so the bubble stays anonymous; the status
 * region is always mounted so assistive technology announces the change.
 */
export function ChatTypingIndicator({ active }: { active: boolean }) {
  return <div className="chat-typing" role="status">
    {active && <div className="chat-typing-bubble" aria-hidden="true"><span /><span /><span /></div>}
    <span className="sr-only">{active ? 'Someone is typing…' : ''}</span>
  </div>
}

export const chatRoleLabel =(role: string) => ({ OWNER: 'Owner', STORE_MANAGER: 'Store Manager', STORE_STAFF: 'Store Staff', CUSTOMER_SERVICE: 'Customer Service', FULFILLMENT: 'Fulfillment Staff', BUYER: 'Buyer', SYSTEM: 'System' }[role] ?? 'Store team')

export function ChatAvatar({ name, path, load }: { name: string; path?: string | null | undefined; load?: ((path: string) => Promise<Blob>) | undefined }) {
  const [image, setImage] = useState<{ path: string; url: string } | null>(null)
  useEffect(() => {
    let active = true; let objectUrl: string | null = null
    if (path && load) void load(path).then(blob => { if (active) { objectUrl = URL.createObjectURL(blob); setImage({ path, url: objectUrl }) } }).catch(() => undefined)
    return () => { active = false; if (objectUrl) URL.revokeObjectURL(objectUrl) }
  }, [path, load])
  const url = image?.path === path ? image?.url : null
  return <span className="chat-avatar grid size-10 shrink-0 place-items-center overflow-hidden rounded-full bg-brand-orange-100 text-text-strong font-semibold" aria-label={name}>{url ? <img className="size-full object-cover" src={url} alt="" /> : name.trim().split(/\s+/).map(part => part[0]).slice(0, 2).join('').toUpperCase()}</span>
}

export function ConversationHeader({ store, buyer, handler, purpose, loadAvatar }: { store: ChatStore; buyer?: ChatIdentity | null | undefined; handler?: ChatIdentity | null | undefined; purpose: string; loadAvatar?: (path: string) => Promise<Blob> }) {
  const topic = purpose === 'FULFILLMENT' ? 'Fulfillment coordination' : 'Sales & quotations'
  return <header className="flex min-w-0 flex-wrap items-center justify-between gap-4 border-b border-border-default p-4 sm:p-5">
    {buyer ? <div className="flex min-w-0 items-center gap-3"><ChatAvatar name={buyer.displayName} path={buyer.avatarPath} load={loadAvatar} />
      <div className="min-w-0"><h2 className="break-words text-lg font-semibold">{buyer.displayName}</h2><p className="text-sm text-text-secondary">Buyer · {topic}</p></div>
    </div> :
    <div className="flex min-w-0 items-center gap-3">{store.logoUrl ? <img src={store.logoUrl} alt="" className="size-12 rounded-control object-cover" /> : <MessageSquare aria-hidden="true" className="size-10 text-text-secondary" />}
      <div className="min-w-0"><h2 className="break-words text-lg font-semibold">{store.name}</h2><p className="flex items-center gap-1 text-sm text-text-secondary">{store.verified && <><BadgeCheck size={16} aria-hidden="true" />Verified · </>}{topic}</p></div>
    </div>}
    <div className="flex min-w-0 items-center gap-2">{handler ? <><ChatAvatar name={handler.displayName} path={handler.avatarPath} load={loadAvatar} /><div className="text-sm"><p className="text-text-secondary">Handled by</p><p className="font-semibold">{handler.displayName}</p><p className="text-text-secondary">{chatRoleLabel(handler.role)}</p></div></> : <p className="text-sm text-text-secondary">Awaiting an active handler</p>}</div>
  </header>
}

const quotationStatus = (version: ChatQuotationVersion) => ({ PUBLISHED: 'Awaiting Buyer response', VIEWED: 'Viewed by Buyer', COUNTERED: 'Buyer requested changes', ACCEPTED: 'Accepted', REJECTED: 'Rejected', WITHDRAWN: 'Withdrawn', EXPIRED: 'Expired', SUPERSEDED: 'Superseded', STOCK_REVALIDATION_REQUIRED: 'Stock revalidation required' }[version.state] ?? version.state.replaceAll('_', ' ').toLowerCase())

function QuotationChangeRequest({ version }: { version: ChatQuotationVersion }) {
  if (!version.requestedChanges) return null
  return <section className="mt-3 border-t border-border-default pt-3" aria-label={`Buyer change request for quotation v${version.version}`}>
    <h4 className="text-sm font-semibold">Buyer requested changes</h4>
    <p className="mt-1 whitespace-pre-wrap break-words text-sm">{version.requestedChanges}</p>
    {version.changeRequestedAt && <p className="mt-1 text-xs text-text-secondary">Requested <time dateTime={version.changeRequestedAt}>{new Date(version.changeRequestedAt).toLocaleString('en-PH', { timeZone: 'Asia/Manila', dateStyle: 'medium', timeStyle: 'short' })} Manila</time></p>}
    {version.latest && version.state === 'COUNTERED' && version.vendorResponseDueAt && <div className="mt-2"><DeadlineCountdown at={version.vendorResponseDueAt} label="Vendor response due" endedLabel="Vendor response deadline passed" /></div>}
  </section>
}

/** Compact in-thread entry; full materials, changes and payment details open on demand. */
export function QuotationThreadCard({ version, busy = false, onOpen, onRevise }: { version: ChatQuotationVersion; busy?: boolean; onOpen: () => void; onRevise?: () => void }) {
  return <article className="w-full min-w-0 max-w-xl overflow-hidden rounded-surface border border-border-default bg-surface-primary" aria-label={`Quotation v${version.version}`}>
    <div className="p-4 sm:p-5">
    <div className="flex items-start gap-3"><span className="flex size-10 shrink-0 items-center justify-center rounded-control bg-surface-canvas"><FileText size={20} aria-hidden="true" /></span><div className="min-w-0 flex-1">
      <div className="flex flex-wrap items-center justify-between gap-2"><h3 className="font-semibold">Quotation v{version.version}</h3><span className="rounded-control bg-surface-canvas px-2 py-1 text-xs font-medium">{quotationStatus(version)}</span></div>
      <p className="mt-1 text-xs text-text-secondary">Published <time dateTime={version.publishedAt}>{new Date(version.publishedAt).toLocaleString('en-PH', { timeZone: 'Asia/Manila', dateStyle: 'medium', timeStyle: 'short' })} Manila</time></p>
    </div></div>
    <dl className="mt-4 border-t border-border-default pt-4"><dt className="text-xs text-text-secondary">Quotation order total</dt><dd className="mt-1 text-2xl font-semibold tracking-tight tabular-nums">{formatPesoCentavos(version.content.commercial.commercialTotalCentavos)}</dd></dl>
    <p className="mt-1 text-xs text-text-secondary">{version.content.lines.length} material {version.content.lines.length === 1 ? 'line' : 'lines'} · {version.content.fulfillmentMethod === 'DELIVERY' ? 'Site Delivery' : 'Self-Pickup'} · Before payment processing fees</p>
    {version.content.message && <p className="mt-4 whitespace-pre-wrap break-words border-l-2 border-border-default pl-3 text-sm leading-relaxed">{version.content.message}</p>}
    <QuotationChangeRequest version={version} />
    </div>
    <div className="flex flex-wrap gap-2 border-t border-border-default bg-surface-canvas px-4 py-3 sm:px-5"><Button variant="secondary" onClick={onOpen} aria-haspopup="dialog">View quotation v{version.version}</Button>{version.latest && version.state === 'COUNTERED' && onRevise && <Button disabled={busy} onClick={onRevise}>Revise quotation</Button>}</div>
  </article>
}

export function QuotationVersionCard({ version, busy = false, onAction }: { version: ChatQuotationVersion; busy?: boolean; onAction?: (action: string, version: ChatQuotationVersion) => void }) {
  const content = version.content
  return <article className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5" aria-label={`Quotation version ${version.version}`}>
    <div className="flex flex-wrap items-start justify-between gap-2"><div><p className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Order from chat</p><h3 className="mt-1 text-lg font-semibold">Quotation v{version.version}</h3></div><span className="rounded-control bg-surface-canvas px-2 py-1 text-sm font-semibold">{version.latest && ['PUBLISHED', 'VIEWED'].includes(version.state) ? 'Latest version' : quotationStatus(version)}</span></div>
    <p className="mt-2 text-sm text-text-secondary">{version.state === 'VIEWED' && version.viewed ? 'Viewed by Buyer' : `${version.state.replaceAll('_', ' ').toLowerCase().replace(/^./, letter => letter.toUpperCase())} · ${version.viewed ? 'Viewed by Buyer' : 'Not yet viewed'}`}</p>
    {content.message && <p className="mt-3 whitespace-pre-wrap break-words text-sm">{content.message}</p>}
    <QuotationMaterialLines lines={content.lines} />
    <QuotationPaymentBreakdown content={content} selectedPaymentMethod={version.selectedPaymentMethod ?? null} accepted={version.state === 'ACCEPTED'} />
    <QuotationChangeList key={version.id} notes={quotationChangeNotes(content)} />
    <QuotationChangeRequest version={version} />
    {version.latest && ['PUBLISHED', 'VIEWED'].includes(version.state) && <div className="mt-3"><DeadlineCountdown at={version.expiresAt} label="Buyer deadline" endedLabel="Quotation deadline passed" /></div>}
    {version.state === 'SUPERSEDED' && <p className="mt-3 text-sm text-text-secondary">A newer quotation replaces these terms. Open the latest version to respond.</p>}
    {version.latest && version.actions.length > 0 && onAction && <div className="mt-4 flex flex-wrap gap-2">{version.actions.filter(action => action !== 'view').map(action => <Button key={action} variant={action === 'accept' ? 'primary' : 'secondary'} disabled={busy || Date.parse(version.expiresAt) <= Date.now()} onClick={() => onAction(action, version)}>{({ accept: 'Review & accept', reject: 'Reject', counter: 'Counter-offer', withdraw: 'Withdraw quotation' } as Record<string, string>)[action] ?? action}</Button>)}</div>}
  </article>
}

function QuotationChangeList({ notes }: { notes: QuotationChangeNote[] }) {
  const [all, setAll] = useState(false)
  const shown = all ? notes : notes.slice(0, 5)
  return <details className="mt-4 border-t border-border-default pt-3">
    <summary className="min-h-11 cursor-pointer font-medium">What changed{notes.length > 0 ? ` · ${notes.length} ${notes.length === 1 ? 'change' : 'changes'}` : ''}</summary>
    {notes.length === 0 ? <p className="pb-3 text-sm text-text-secondary">Quotation terms are shown above.</p> : <>
      <ul className="grid gap-3 pb-2">{shown.map(note => <li key={JSON.stringify(note)} className="min-w-0 break-words text-sm">
        <p className="font-medium">{note.title}</p>
        {(note.before !== undefined || note.after !== undefined) && <p className="mt-1 text-text-secondary">
          {note.before !== undefined && note.after !== undefined ? <><span className="sr-only">Changed from </span><span>{note.before}</span><span aria-hidden="true"> → </span><span className="sr-only"> to </span><span className="font-medium text-text-strong">{note.after}</span></> : note.after ?? `Previously ${note.before}`}
        </p>}
      </li>)}</ul>
      {notes.length > 5 && <Button variant="quiet" onClick={() => setAll(value => !value)} aria-expanded={all}>{all ? 'Show fewer changes' : `Show all ${notes.length} changes`}</Button>}
    </>}
  </details>
}

/** A clean chat photo previewed from its private bytes as a short-lived object URL, never a stored or public link. */
export function ChatImageAttachment({ attachment, load, onDownload }: { attachment: ChatAttachment; load: (id: string) => Promise<Blob>; onDownload: () => void }) {
  const [image, setImage] = useState<{ id: string; url: string } | null>(null)
  const [failed, setFailed] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true; let objectUrl: string | null = null
    void load(attachment.id).then(blob => { if (active) { objectUrl = URL.createObjectURL(blob); setImage({ id: attachment.id, url: objectUrl }); setFailed(null) } }).catch(() => { if (active) setFailed(attachment.id) })
    return () => { active = false; if (objectUrl) URL.revokeObjectURL(objectUrl) }
  }, [attachment.id, load, attempt])
  const url = image?.id === attachment.id ? image.url : null
  return <figure className="chat-image-attachment">
    {url ? <a href={url} target="_blank" rel="noopener noreferrer" className="chat-image-preview" aria-label={`Open ${attachment.displayName} full size`}><img src={url} alt={attachment.displayName} /></a>
      : failed === attachment.id ? <button type="button" className="chat-image-preview chat-image-status" onClick={() => setAttempt(value => value + 1)}><ImageOff size={20} aria-hidden="true" /><span>Image unavailable · Retry</span></button>
        : <div className="chat-image-preview chat-image-status" role="status"><span>Loading image…</span></div>}
    <figcaption><span className="min-w-0 truncate">{attachment.displayName} · {Math.ceil(attachment.sizeBytes / 1024)} KB</span><button type="button" className="chat-image-download" onClick={onDownload}><Download size={16} aria-hidden="true" />Download</button></figcaption>
  </figure>
}

export function ChatAttachmentButton({ attachment, onOpen }: { attachment: ChatAttachment; onOpen: () => void }) {
  return <button type="button" onClick={onOpen} disabled={attachment.scanState !== 'CLEAN'} className="flex min-h-11 w-full items-center gap-3 rounded-control border border-border-default p-3 text-left"><FileText size={20} aria-hidden="true" /><span className="min-w-0 break-words"><span className="block font-medium">{attachment.displayName}</span><span className="text-xs text-text-secondary">{attachment.mediaType} · {Math.ceil(attachment.sizeBytes / 1024)} KB · Scan: {attachment.scanState.toLowerCase()}</span></span></button>
}
