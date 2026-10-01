import { useEffect, useState } from 'react'
import type { ChatAttachment, ChatIdentity, ChatMessage, ChatQuotationVersion, ChatStore, ConversationView } from '@materyalph/api-client-ts'
import { BadgeCheck, Check, CheckCheck, FileText, MessageSquare, Search } from 'lucide-react'
import { Button } from './button'
import { DeadlineCountdown, formatPesoCentavos } from './order-patterns'
import './messaging-patterns.css'

export const conversationLabel = (conversation: ConversationView) => conversation.purpose === 'FULFILLMENT' ? 'Order coordination' : conversation.contextType === 'PROJECT_BASED' ? 'Project inquiry' : 'Product inquiry'

export function ConversationInbox({ rows, selected, onSelect, disabled = false }: { rows: ConversationView[]; selected: string | null; onSelect: (id: string) => void; disabled?: boolean }) {
  const [query, setQuery] = useState('')
  const visible = rows.filter(row => `${conversationLabel(row)} ${row.handler?.displayName ?? ''} ${row.orderId ?? ''} ${row.id}`.toLowerCase().includes(query.trim().toLowerCase()))
  return <>
    <div className="chat-inbox-search"><label><Search size={16} aria-hidden="true" /><span className="sr-only">Search conversations on this page</span><input type="search" placeholder="Search conversations…" value={query} onChange={event => setQuery(event.target.value)} /></label><p>Search inquiries, handlers or references on this page.</p></div>
    <ul className="chat-inbox-list" aria-label="Conversations">{visible.map(row => <li key={row.id}>
      <button type="button" className="chat-inbox-row" aria-current={row.id === selected ? 'true' : undefined} disabled={disabled} onClick={() => onSelect(row.id)}>
        <span className="chat-inbox-avatar" aria-hidden="true"><MessageSquare size={19} /></span>
        <span className="chat-inbox-copy"><span className="chat-inbox-title">{conversationLabel(row)}</span><span className="chat-inbox-preview">{row.handler ? `Handled by ${row.handler.displayName}` : 'Needs a handler'}</span><span className="chat-inbox-reference">{row.orderId ? `Order · ${row.orderId.slice(-8)}` : `Inquiry · ${row.id.slice(-8)}`}</span></span>
        <span className="chat-inbox-meta"><time dateTime={row.updatedAt}>{new Date(row.updatedAt).toLocaleDateString('en-PH', { timeZone: 'Asia/Manila', month: 'short', day: 'numeric' })}</time>{row.unreadCount > 0 && <span className="chat-unread" aria-label={`${row.unreadCount} unread messages`}>{row.unreadCount}</span>}</span>
      </button>
    </li>)}</ul>
    {visible.length === 0 && <p className="chat-inbox-empty" role="status">{rows.length ? 'No matching conversations on this page.' : 'No conversations yet. Buyer inquiries will appear here.'}</p>}
  </>
}

export function ChatMessageBubble({ message, onOpenAttachment }: { message: ChatMessage; onOpenAttachment: (id: string) => void }) {
  const date = new Date(message.sentAt)
  const timestamp = <time dateTime={message.sentAt} title={`${date.toLocaleString('en-PH', { timeZone: 'Asia/Manila' })} · Manila`}>{date.toLocaleTimeString('en-PH', { timeZone: 'Asia/Manila', hour: 'numeric', minute: '2-digit' })}</time>
  if (message.kind === 'SYSTEM') return <li className="chat-system-message"><p>{message.body}</p>{timestamp}</li>
  return <li className={`chat-message ${message.mine ? 'is-mine' : ''}`}>
    <ChatAvatar name={message.sender.displayName} />
    <div className="chat-message-content"><p className="chat-message-author">{message.sender.displayName} · {chatRoleLabel(message.sender.role)}</p>
      <div className="chat-message-bubble">{message.body && <p>{message.body}</p>}{message.attachments.map(file => <ChatAttachmentButton key={file.id} attachment={file} onOpen={() => onOpenAttachment(file.id)} />)}</div>
      <p className="chat-message-time">{timestamp}{message.mine && <><span aria-hidden="true">·</span>{message.readByRecipient ? <CheckCheck size={13} aria-hidden="true" /> : <Check size={13} aria-hidden="true" />}<span>{message.readByRecipient ? 'Read' : 'Sent'}</span></>}</p>
    </div>
  </li>
}

export const chatRoleLabel = (role: string) => ({ OWNER: 'Owner', STORE_MANAGER: 'Store Manager', STORE_STAFF: 'Store Staff', CUSTOMER_SERVICE: 'Customer Service', FULFILLMENT: 'Fulfillment Staff', BUYER: 'Buyer', SYSTEM: 'System' }[role] ?? 'Store team')

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

export function ConversationHeader({ store, handler, purpose, loadAvatar }: { store: ChatStore; handler?: ChatIdentity | null | undefined; purpose: string; loadAvatar?: (path: string) => Promise<Blob> }) {
  return <header className="flex min-w-0 flex-wrap items-center justify-between gap-4 border-b border-border-default p-4 sm:p-5">
    <div className="flex min-w-0 items-center gap-3">{store.logoUrl ? <img src={store.logoUrl} alt="" className="size-12 rounded-control object-cover" /> : <MessageSquare aria-hidden="true" className="size-10 text-text-secondary" />}
      <div className="min-w-0"><h2 className="break-words text-lg font-semibold">{store.name}</h2><p className="flex items-center gap-1 text-sm text-text-secondary">{store.verified && <><BadgeCheck size={16} aria-hidden="true" />Verified · </>}{purpose === 'FULFILLMENT' ? 'Fulfillment coordination' : 'Sales & quotations'}</p></div>
    </div>
    <div className="flex min-w-0 items-center gap-2">{handler ? <><ChatAvatar name={handler.displayName} path={handler.avatarPath} load={loadAvatar} /><div className="text-sm"><p className="text-text-secondary">Handled by</p><p className="font-semibold">{handler.displayName}</p><p className="text-text-secondary">{chatRoleLabel(handler.role)}</p></div></> : <p className="text-sm text-text-secondary">Awaiting an active handler</p>}</div>
  </header>
}

export function QuotationVersionCard({ version, busy = false, onAction }: { version: ChatQuotationVersion; busy?: boolean; onAction?: (action: string, version: ChatQuotationVersion) => void }) {
  const content = version.content
  return <article className="min-w-0 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5" aria-label={`Quotation version ${version.version}`}>
    <div className="flex flex-wrap items-start justify-between gap-2"><div><p className="text-xs font-semibold uppercase tracking-wide text-text-secondary">Order from chat</p><h3 className="mt-1 text-lg font-semibold">Quotation v{version.version}</h3></div><span className="rounded-control bg-surface-canvas px-2 py-1 text-sm font-semibold">{version.latest ? 'Latest version' : 'Superseded'}</span></div>
    <p className="mt-2 text-sm text-text-secondary">{version.state.replaceAll('_', ' ')} · {version.viewed ? 'Viewed by Buyer' : 'Not yet viewed'}</p>
    <dl className="my-4 divide-y divide-border-default">{content.lines.map(line => <div className="flex flex-wrap justify-between gap-2 py-3" key={line.variantId}><dt className="min-w-0"><span className="block break-words font-medium">{line.description}</span><span className="text-sm text-text-secondary">{line.quantity} {line.unitCode} × {formatPesoCentavos(line.unitPriceCentavos)} · {line.taxCategory.replaceAll('_', ' ')}</span></dt></div>)}</dl>
    <div className="space-y-2 border-t border-border-default pt-3 text-sm"><div className="flex justify-between gap-2"><span>Materials after discounts</span><strong>{formatPesoCentavos(content.commercial.materialsPayableCentavos)}</strong></div><div className="flex justify-between gap-2"><span>Included VAT</span><span>{formatPesoCentavos(content.commercial.materialsVatCentavos)}</span></div><div className="flex justify-between gap-2"><span>Delivery</span><span>{formatPesoCentavos(content.commercial.deliveryCentavos)}</span></div><div className="flex justify-between gap-2 text-base"><span>Total before processing fee</span><strong>{formatPesoCentavos(content.commercial.commercialTotalCentavos)}</strong></div><p className="text-text-secondary">Processing fee pending payment channel selection.</p><p>{content.fulfillmentMethod === 'PICKUP' ? 'Self-Pickup' : 'Site Delivery'} · {content.fulfillmentDate} · {content.paymentMethod}</p>{content.commercial.nrpcCentavos > 0 && <p className="font-semibold">NRPC {formatPesoCentavos(content.commercial.nrpcCentavos)} is included in the total.</p>}</div>
    <details className="mt-4 border-t border-border-default pt-3"><summary className="min-h-11 cursor-pointer font-medium">What changed · {content.changes.length} fields</summary><ul className="space-y-2 text-sm text-text-secondary">{content.changes.map(change => <li key={change.path}>{change.label}</li>)}</ul></details>
    <div className="mt-3"><DeadlineCountdown at={version.expiresAt} label="Buyer deadline" endedLabel="Quotation deadline passed" /></div>
    {!version.latest && <p className="mt-3 text-sm text-text-secondary">A newer quotation replaces these terms. Open the latest version to respond.</p>}
    {version.latest && version.actions.length > 0 && onAction && <div className="mt-4 flex flex-wrap gap-2">{version.actions.filter(action => action !== 'view').map(action => <Button key={action} variant={action === 'accept' ? 'primary' : 'secondary'} disabled={busy || Date.parse(version.expiresAt) <= Date.now()} onClick={() => onAction(action, version)}>{({ accept: 'Review & accept', reject: 'Reject', counter: 'Counter-offer', withdraw: 'Withdraw quotation' } as Record<string, string>)[action] ?? action}</Button>)}</div>}
  </article>
}

export function ChatAttachmentButton({ attachment, onOpen }: { attachment: ChatAttachment; onOpen: () => void }) {
  return <button type="button" onClick={onOpen} disabled={attachment.scanState !== 'CLEAN'} className="flex min-h-11 w-full items-center gap-3 rounded-control border border-border-default p-3 text-left"><FileText size={20} aria-hidden="true" /><span className="min-w-0 break-words"><span className="block font-medium">{attachment.displayName}</span><span className="text-xs text-text-secondary">{attachment.mediaType} · {Math.ceil(attachment.sizeBytes / 1024)} KB · Scan: {attachment.scanState.toLowerCase()}</span></span></button>
}
