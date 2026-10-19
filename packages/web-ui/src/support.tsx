import { useCallback, useEffect, useId, useRef, useState, type FormEvent, type ReactNode } from 'react'
import { RefreshCw } from 'lucide-react'
import { SupportApi, ResponseError, parseDate, type SupportPortal, type SupportTicket, type SupportEntry, type SupportReceipt, type SupportCategory, type SupportUserType, type SupportStatus, type SupportReferenceType, type SupportUpdate, type SupportHandler } from '@materyalph/api-client-ts'
import { Button } from './button'
import { Field, FormErrors } from './field'
import { FilterPanel } from './filter-controls'
import { StatusMessage } from './status-message'
import { StatusBadge } from './portal-shell'
import { EmptyState, FilterTabs } from './page-patterns'
import { ALL_DATES, DateFilter, type DateFilterRange } from './date-filter'
import { PrivateEvidenceButton } from './private-evidence-button'
import { createWebApiConfiguration, webRequestErrorMessage } from './web-api-session'

export const SUPPORT_CATEGORIES: readonly SupportCategory[] = ['GENERAL_INQUIRY', 'TECHNICAL_ISSUE', 'ACCOUNT_CONCERN', 'VERIFICATION_ISSUE', 'PAYMENT_CONCERN', 'ORDER_CONCERN', 'COMPLAINT', 'FEEDBACK_SUGGESTION', 'OTHER']
export const SUPPORT_STATUSES: readonly SupportStatus[] = ['OPEN', 'IN_PROGRESS', 'WAITING_FOR_USER', 'RESOLVED', 'CLOSED']
export const SUPPORT_TYPES: readonly SupportUserType[] = ['BUYER', 'VENDOR', 'GUEST']
export const SUPPORT_PRIVACY = 'MateryalPH uses your contact details, messages and attachments to investigate and respond to your concern. Only you and authorized administrators can access the ticket. Records are retained under platform retention and legal obligations. Share only relevant information. Never send passwords, one-time codes or full payment credentials. You may request access or correction through support.'
export function supportLabel(value: string): string {
  if (value === 'FEEDBACK_SUGGESTION') return 'Feedback / Suggestion'
  return value.split('_').map(word => word.charAt(0) + word.slice(1).toLowerCase()).join(' ')
}
export type SupportIdentity = { fullName: string; email: string; userType: SupportUserType }
export type SupportDraft = { fullName?: string; email?: string; userType: SupportUserType; category: SupportCategory; subject: string; message: string; privacyAcknowledged: boolean; referenceType?: SupportReferenceType; reference?: string; website?: string; files?: Blob[] }
export type SupportFilters = { q?: string | undefined; category?: SupportCategory | undefined; status?: SupportStatus | undefined; userType?: SupportUserType | undefined; from?: Date | undefined; to?: Date | undefined }

export class SupportClient {
  constructor(readonly basePath: string, readonly portal: SupportPortal) {}
  private api() { return new SupportApi(createWebApiConfiguration(this.basePath, { refreshSession: this.portal !== 'guest' })) }
  create(draft: SupportDraft, idempotencyKey: string) { return this.api().createSupportTicket({ supportPortal: this.portal, idempotencyKey, ...draft }) }
  list(filters: SupportFilters, cursor?: string) { return this.api().listSupportTickets({ supportPortal: this.portal, ...(cursor ? { cursor } : {}), ...(filters.q ? { q: filters.q } : {}), ...(filters.category ? { category: filters.category } : {}), ...(filters.status ? { status: filters.status } : {}), ...(filters.userType ? { userType: filters.userType } : {}), ...(filters.from ? { from: filters.from } : {}), ...(filters.to ? { to: filters.to } : {}) }) }
  ticket(ticketId: string) { return this.api().getSupportTicket({ supportPortal: this.portal, ticketId }) }
  entries(ticketId: string, cursor?: string) { return this.api().listSupportEntries({ supportPortal: this.portal, ticketId, ...(cursor ? { cursor } : {}) }) }
  reply(ticketId: string, message: string, files: Blob[], idempotencyKey: string) { return this.api().replyToSupportTicket({ supportPortal: this.portal, ticketId, message, files, idempotencyKey }) }
  update(ticketId: string, supportUpdate: SupportUpdate, idempotencyKey: string) { return this.api().updateSupportTicket({ supportPortal: this.portal, ticketId, supportUpdate, idempotencyKey }) }
  handlers(cursor?: string) { return this.api().listSupportHandlers(cursor ? { cursor } : {}) }
  accessEmail(ticketNumber: string, email: string) { return this.api().requestSupportAccessEmail({ supportAccessEmail: { ticketNumber, email } }) }
  exchange(token: string) { return this.api().exchangeSupportAccess({ supportAccessExchange: { token } }) }
  attachmentUrl(ticketId: string, fileId: string) { return `${this.basePath}/support/${this.portal}/tickets/${encodeURIComponent(ticketId)}/attachments/${encodeURIComponent(fileId)}` }
}

async function supportFailure(error: unknown): Promise<{ message: string; fields: Record<string, string> }> {
  const fields: Record<string, string> = {}
  if (error instanceof ResponseError) {
    try {
      const body: unknown = await error.response.clone().json()
      if (body && typeof body === 'object' && 'errors' in body && Array.isArray(body.errors)) {
        const first: unknown = body.errors[0]
        if (first && typeof first === 'object' && 'details' in first && first.details && typeof first.details === 'object') {
          for (const [name, messages] of Object.entries(first.details)) {
            if (Array.isArray(messages) && typeof messages[0] === 'string') { fields[name] = messages[0]; if (name.startsWith('files.')) fields.files = messages[0] }
          }
        }
      }
    } catch { /* The shared mapper supplies a safe fallback for malformed responses. */ }
  }
  return { message: await webRequestErrorMessage(error) ?? 'The support request could not be completed. Please retry.', fields }
}
const accessLost = (error: unknown) => error instanceof ResponseError && [401, 403, 404].includes(error.response.status)
const control = 'min-h-11 w-full rounded-control border border-border-default bg-surface-primary px-3 py-2 text-base font-normal text-text-strong focus:ring-2 focus:ring-focus-ring'
function Select({ label, name, children, error, value, onChange, disabled }: { label: string; name: string; children: ReactNode; error?: string | undefined; value?: string | undefined; onChange?: ((value: string) => void) | undefined; disabled?: boolean | undefined }) {
  return <label className="grid min-w-0 gap-2 text-sm font-semibold">{label}<select name={name} className={control} value={value} onChange={onChange ? event => onChange(event.target.value) : undefined} disabled={disabled} aria-invalid={Boolean(error)} aria-describedby={error ? `${name}-error` : undefined}>{children}</select>{error && <span className="font-normal text-status-error" role="alert" id={`${name}-error`}>{error}</span>}</label>
}
function AttachmentField() {
  return <Field label="Attachments (optional)" name="files" type="file" multiple accept="image/jpeg,image/png,application/pdf" hint="Up to 3 JPG, PNG or PDF files, at most 3 MB each. Files are checked and stored privately." />
}
function attachments(form: FormData): File[] {
  const files = form.getAll('files').filter((file): file is File => file instanceof File && file.size > 0)
  if (files.length > 3 || files.some(file => file.size > 3 * 1024 * 1024 || !/\.(jpe?g|png|pdf)$/i.test(file.name))) throw new Error('Choose up to 3 JPG, PNG or PDF files, at most 3 MB each.')
  return files
}
function localError(error: unknown) { return error instanceof Error && !(error instanceof ResponseError) ? error.message : undefined }

export function SupportRequestForm({ client, identity, onCreated }: { client: SupportClient; identity?: SupportIdentity | undefined; onCreated?: (receipt: SupportReceipt) => void }) {
  const [busy, setBusy] = useState(false)
  const processing = useRef(false)
  const key = useRef(crypto.randomUUID())
  const [failure, setFailure] = useState<{ message: string; fields: Record<string, string> } | null>(null)
  const [receipt, setReceipt] = useState<SupportReceipt | null>(null)
  const [userType, setUserType] = useState<SupportUserType>('GUEST')
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (processing.current) return
    const form = new FormData(event.currentTarget)
    processing.current = true; setBusy(true); setFailure(null)
    try {
      const referenceType = String(form.get('reference_type') ?? '') as SupportReferenceType
      const draft: SupportDraft = { fullName: identity?.fullName ?? String(form.get('full_name')), email: identity?.email ?? String(form.get('email')), userType: identity?.userType ?? String(form.get('user_type')) as SupportUserType, category: String(form.get('category')) as SupportCategory, subject: String(form.get('subject')), message: String(form.get('message')), privacyAcknowledged: form.get('privacy_acknowledged') === 'on', website: String(form.get('website') ?? ''), files: attachments(form), ...(referenceType ? { referenceType, reference: String(form.get('reference')) } : {}) }
      const result = await client.create(draft, key.current)
      setReceipt(result.data); onCreated?.(result.data)
    } catch (error) { setFailure(localError(error) ? { message: localError(error)!, fields: {} } : await supportFailure(error)) }
    finally { processing.current = false; setBusy(false) }
  }
  if (receipt) return <StatusMessage tone="success"><p>Your support request was submitted.</p><p className="mt-2 font-semibold">Ticket {receipt.ticketNumber}</p><p className="mt-2">{identity ? 'Open My Support Requests to read responses and continue the conversation.' : 'Check your email for a secure link to read responses and send follow-ups. Keep your ticket number for requesting a fresh link.'}</p></StatusMessage>
  return <FormErrors.Provider value={failure?.fields ?? {}}><form onSubmit={submit} onChange={() => { key.current = crypto.randomUUID() }} className="grid gap-5" aria-busy={busy}>
    {failure && <StatusMessage tone="error">{failure.message}</StatusMessage>}
    <fieldset disabled={busy} className="grid min-w-0 gap-5">
      <div className="grid gap-5 sm:grid-cols-2"><Field label="Full name" name="full_name" autoComplete="name" required maxLength={160} defaultValue={identity?.fullName} readOnly={Boolean(identity)} /><Field label="Email address" name="email" type="email" autoComplete="email" required maxLength={254} defaultValue={identity?.email} readOnly={Boolean(identity)} /></div>
      <div className="grid gap-5 sm:grid-cols-2"><Select label="User type" name="user_type" value={identity?.userType ?? userType} onChange={value => setUserType(value as SupportUserType)} disabled={Boolean(identity)} error={failure?.fields.user_type}>{SUPPORT_TYPES.map(value => <option key={value} value={value}>{supportLabel(value)}</option>)}</Select><Select label="Concern category" name="category" error={failure?.fields.category}>{SUPPORT_CATEGORIES.map(value => <option key={value} value={value}>{supportLabel(value)}</option>)}</Select></div>
      <Field label="Subject" name="subject" required minLength={3} maxLength={160} />
      <label className="grid gap-2 text-sm font-semibold">Message / Description<textarea name="message" className={`${control} min-h-40`} required minLength={3} maxLength={10000} aria-invalid={Boolean(failure?.fields.message)} aria-describedby={failure?.fields.message ? 'support-message-error' : undefined} />{failure?.fields.message && <span id="support-message-error" role="alert" className="font-normal text-status-error">{failure.fields.message}</span>}</label>
      <div className="grid gap-5 sm:grid-cols-2"><Select label="Reference type (optional)" name="reference_type"><option value="">No reference</option>{['ORDER','PROJECT','WORK_PACKAGE','TRANSACTION'].map(value => <option key={value} value={value}>{supportLabel(value)}</option>)}</Select><Field label="Reference number or ID (optional)" name="reference" maxLength={120} hint="For an existing order, project, work package or transaction." /></div>
      <AttachmentField />
      <div className="hidden" aria-hidden="true"><input name="website" tabIndex={-1} autoComplete="off" aria-label="Leave this field empty" /></div>
      <div className="border-t border-border-default pt-4"><p className="text-sm leading-6 text-text-secondary">{SUPPORT_PRIVACY} <a href="/legal/privacy-notice" className="font-semibold text-action-primary underline">Privacy Notice</a></p><label className="mt-3 flex min-h-11 items-start gap-3 text-sm"><input type="checkbox" name="privacy_acknowledged" required className="mt-1 size-5 accent-action-primary" /><span>I acknowledge how my support information will be used.</span></label></div>
    </fieldset>
    <Button type="submit" className="w-fit" disabled={busy}>{busy ? 'Submitting inquiry…' : 'Submit inquiry'}</Button>
  </form></FormErrors.Provider>
}

export function SupportRequestList({ client, onOpen, admin = false, renderHeader }: { client: SupportClient; onOpen: (id: string) => void; admin?: boolean; renderHeader?: (refreshAction: ReactNode) => ReactNode }) {
  const filtersId = useId()
  const [filters, setFilters] = useState<SupportFilters>({})
  const [draft, setDraft] = useState<SupportFilters>({})
  const [range, setRange] = useState(ALL_DATES)
  const [tickets, setTickets] = useState<SupportTicket[]>([])
  const [cursor, setCursor] = useState<string | null>(null)
  const [busy, setBusy] = useState(true)
  const [error, setError] = useState('')
  const revision = useRef(0)
  const load = useCallback(async (next?: string) => {
    const current = ++revision.current
    setBusy(true); setError('')
    try { const response = await client.list(filters, next); if (current === revision.current) { setTickets(old => next ? [...old, ...response.data] : response.data); setCursor(response.meta.nextCursor) } }
    catch (error) { if (current === revision.current) { if (accessLost(error)) setTickets([]); setError((await supportFailure(error)).message) } }
    finally { if (current === revision.current) setBusy(false) }
  }, [client, filters])
  useEffect(() => { void load(); return () => { revision.current++ } }, [load])
  function changeStatus(value: string) {
    const status = value === 'ALL' ? undefined : value as SupportStatus
    if (status === filters.status) return
    setFilters(current => ({ ...current, status }))
    setDraft(current => ({ ...current, status }))
    setTickets([])
    setCursor(null)
  }
  function changeDates(value: DateFilterRange) {
    const dates = { from: value.from ? parseDate(value.from) : undefined, to: value.to ? parseDate(value.to) : undefined }
    setRange(value)
    setFilters(current => ({ ...current, ...dates }))
    setDraft(current => ({ ...current, ...dates }))
    setTickets([])
    setCursor(null)
  }
  const refreshAction = <Button variant="secondary" disabled={busy} onClick={() => void load()}>{renderHeader && <RefreshCw size={16} aria-hidden="true" />}Refresh requests</Button>
  return <>{renderHeader?.(refreshAction)}<div className="grid gap-5">
    {admin && <FilterTabs label="Support request status" value={filters.status ?? 'ALL'} onChange={changeStatus} chips={[{ value: 'ALL', label: 'All requests' }, ...SUPPORT_STATUSES.map(value => ({ value, label: supportLabel(value) }))]} />}
    {admin && <FilterPanel label="Support request filters"><div className="col-span-full grid gap-4">
      <form id={filtersId} className="grid gap-3 sm:grid-cols-2 xl:grid-cols-3" onSubmit={event => { event.preventDefault(); setFilters({ ...draft }); setTickets([]); setCursor(null) }}>
        <Field label="Search requests" name="support-search" placeholder="Ticket, name, email or subject" value={draft.q ?? ''} maxLength={160} onChange={event => setDraft({ ...draft, q: event.target.value })} />
        <Select label="Category" name="filter-category" value={draft.category ?? ''} onChange={value => setDraft({ ...draft, category: value ? value as SupportCategory : undefined })}><option value="">All categories</option>{SUPPORT_CATEGORIES.map(value => <option value={value} key={value}>{supportLabel(value)}</option>)}</Select>
        <Select label="User type" name="filter-type" value={draft.userType ?? ''} onChange={value => setDraft({ ...draft, userType: value ? value as SupportUserType : undefined })}><option value="">All user types</option>{SUPPORT_TYPES.map(value => <option value={value} key={value}>{supportLabel(value)}</option>)}</Select>
      </form>
      <div className="flex flex-wrap items-center gap-3"><DateFilter title="Request received dates" value={range} onChange={changeDates} /><Button type="submit" form={filtersId} disabled={busy}>Apply filters</Button></div>
    </div></FilterPanel>}
    {!renderHeader && <div>{refreshAction}</div>}
    {error && <StatusMessage tone="error">{error}<Button variant="secondary" onClick={() => void load()}>Retry</Button></StatusMessage>}
    {busy && <StatusMessage>Loading support requests…</StatusMessage>}
    {!busy && !error && tickets.length === 0 && <EmptyState icon={false} message="No support requests found." />}
    <ul className="divide-y divide-border-default">{tickets.map(ticket => <li key={ticket.id}><button type="button" onClick={() => onOpen(ticket.id)} className="grid min-h-11 w-full gap-2 py-5 text-left hover:bg-surface-canvas focus-visible:ring-2 focus-visible:ring-focus-ring"><div className="flex flex-wrap items-center justify-between gap-2"><span className="font-semibold">{ticket.subject}</span><StatusBadge label={supportLabel(ticket.status)} tone={ticket.status === 'RESOLVED' ? 'success' : 'neutral'} /></div><p className="text-sm text-text-secondary">{ticket.ticketNumber} · {supportLabel(ticket.category)} · {formatSupportDate(ticket.createdAt)}</p>{admin && <p className="break-all text-sm">{ticket.fullName} · {ticket.email} · {supportLabel(ticket.userType)}</p>}</button></li>)}</ul>
    {cursor && <Button variant="secondary" disabled={busy} onClick={() => void load(cursor)}>Load more requests</Button>}
  </div></>
}

function formatSupportDate(date: Date) { return new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' }).format(date) }

export function SupportConversation({ client, ticketId, admin = false }: { client: SupportClient; ticketId: string; admin?: boolean }) {
  const [ticket, setTicket] = useState<SupportTicket | null>(null)
  const [entries, setEntries] = useState<SupportEntry[]>([])
  const [cursor, setCursor] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [sending, setSending] = useState(false)
  const [error, setError] = useState('')
  const [success, setSuccess] = useState('')
  const revision = useRef(0)
  const key = useRef(crypto.randomUUID())
  const sendingRef = useRef(false)
  const load = useCallback(async () => {
    const current = ++revision.current
    setBusy(true); setError('')
    try { const [detail, history] = await Promise.all([client.ticket(ticketId), client.entries(ticketId)]); if (current === revision.current) { setTicket(detail.data); setEntries(history.data); setCursor(history.meta.nextCursor) } }
    catch (error) { if (current === revision.current) { if (accessLost(error)) { setTicket(null); setEntries([]) }; setError((await supportFailure(error)).message) } }
    finally { if (current === revision.current) setBusy(false) }
  }, [client, ticketId])
  useEffect(() => { setTicket(null); void load(); return () => { revision.current++ } }, [load])
  async function earlier() {
    if (!cursor || busy) return
    setBusy(true); setError('')
    try { const page = await client.entries(ticketId, cursor); setEntries(old => [...page.data, ...old]); setCursor(page.meta.nextCursor) }
    catch (error) { if (accessLost(error)) { setTicket(null); setEntries([]) }; setError((await supportFailure(error)).message) }
    finally { setBusy(false) }
  }
  async function reply(event: FormEvent<HTMLFormElement>) {
    event.preventDefault()
    if (sendingRef.current) return
    const form = event.currentTarget
    const data = new FormData(form)
    sendingRef.current = true; setSending(true); setError(''); setSuccess('')
    try { await client.reply(ticketId, String(data.get('message')), attachments(data), key.current); form.reset(); key.current = crypto.randomUUID(); setSuccess('Your reply was sent.'); await load() }
    catch (error) { if (accessLost(error)) { setTicket(null); setEntries([]) }; setError(localError(error) ?? (await supportFailure(error)).message) }
    finally { sendingRef.current = false; setSending(false) }
  }
  return <div className="grid gap-6">
    <div><Button variant="secondary" disabled={busy || sending} onClick={() => void load()}>Refresh conversation</Button></div>
    {busy && <StatusMessage>Loading support conversation…</StatusMessage>}
    {error && <StatusMessage tone="error">{error}</StatusMessage>}{success && <StatusMessage tone="success">{success}</StatusMessage>}
    {ticket && <><header className="grid gap-2 border-b border-border-default pb-5"><p className="text-sm font-semibold text-action-primary">{ticket.ticketNumber}</p><h2 className="text-2xl font-semibold">{ticket.subject}</h2><div><StatusBadge label={supportLabel(ticket.status)} tone={ticket.status === 'RESOLVED' ? 'success' : 'neutral'} /></div><p className="text-sm text-text-secondary">{supportLabel(ticket.category)} · Submitted {formatSupportDate(ticket.createdAt)}</p>{admin && <p className="break-words text-sm">{ticket.fullName} · {ticket.email} · {supportLabel(ticket.userType)}</p>}{ticket.reference && <p className="break-all text-sm">{supportLabel(ticket.referenceType ?? 'Reference')}: {ticket.reference}</p>}<p className="text-sm">Assigned to {ticket.assignedAdminName ?? 'Unassigned'}</p></header>
      {admin && <SupportManagement client={client} ticket={ticket} onSaved={load} />}
      <section aria-label="Support conversation" className="grid gap-4">{cursor && <Button disabled={busy} variant="secondary" onClick={() => void earlier()}>Load earlier history</Button>}{entries.map(entry => <article key={entry.id} className="min-w-0 border-b border-border-default pb-5"><div className="flex flex-wrap justify-between gap-2 text-sm"><span className="font-semibold">{entry.actorName} · {supportLabel(entry.actorRole)}</span><time dateTime={entry.createdAt.toISOString()} className="text-text-secondary">{formatSupportDate(entry.createdAt)}</time></div>{entry.kind !== 'MESSAGE' && <p className="mt-2 text-sm font-semibold">{entry.kind === 'STATUS_CHANGED' ? `${supportLabel(entry.details.fromStatus ?? '')} → ${supportLabel(entry.details.toStatus ?? '')}` : `${entry.details.previousHandler ?? 'Unassigned'} → ${entry.details.newHandler ?? 'Unassigned'}`}</p>}<p className="mt-3 whitespace-pre-wrap break-words leading-7">{entry.body}</p><div className="mt-2 flex flex-wrap gap-2">{entry.attachments.map(file => <PrivateEvidenceButton key={file.id} apiBasePath={client.basePath} loadUrl={async () => ({ url: client.attachmentUrl(ticketId, file.id) })}>{file.originalName} ({Math.ceil(file.byteSize / 1024)} KB)</PrivateEvidenceButton>)}</div></article>)}</section>
      {ticket.status === 'CLOSED' ? <StatusMessage>This request is closed. An administrator must reopen it before another reply. You can submit a new request if you need further assistance.</StatusMessage> : <form onSubmit={reply} onChange={() => { key.current = crypto.randomUUID() }} aria-busy={sending} className="grid gap-4"><label className="grid gap-2 text-sm font-semibold">{admin ? 'Response to the user' : 'Your follow-up message'}<textarea className={`${control} min-h-32`} name="message" required minLength={3} maxLength={10000} disabled={sending} /></label><fieldset disabled={sending}><AttachmentField /></fieldset><Button className="w-fit" type="submit" disabled={sending || busy}>{sending ? 'Sending reply…' : 'Send reply'}</Button></form>}
    </>}
  </div>
}

function SupportManagement({ client, ticket, onSaved }: { client: SupportClient; ticket: SupportTicket; onSaved: () => Promise<void> }) {
  const [handlers, setHandlers] = useState<SupportHandler[]>([])
  const [cursor, setCursor] = useState<string | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const key = useRef(crypto.randomUUID())
  useEffect(() => { let active = true; void client.handlers().then(page => { if (active) { setHandlers(page.data); setCursor(page.meta.nextCursor) } }).catch(async error => { if (active) setError((await supportFailure(error)).message) }); return () => { active = false } }, [client])
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); if (busy) return
    const form = new FormData(event.currentTarget)
    setBusy(true); setError('')
    try { await client.update(ticket.id, { lockVersion: ticket.lockVersion, reason: String(form.get('reason')), status: String(form.get('status')) as SupportStatus, assignedAdminId: String(form.get('assigned_admin_id')) || null }, key.current); key.current = crypto.randomUUID(); await onSaved() }
    catch (error) { setError((await supportFailure(error)).message) }
    finally { setBusy(false) }
  }
  async function moreHandlers() {
    if (!cursor) return
    try { const page = await client.handlers(cursor); setHandlers(old => [...old, ...page.data]); setCursor(page.meta.nextCursor) }
    catch (error) { setError((await supportFailure(error)).message) }
  }
  return <form key={ticket.lockVersion} onSubmit={submit} onChange={() => { key.current = crypto.randomUUID() }} className="grid gap-4 border-b border-border-default pb-5" aria-busy={busy}>
    <h3 className="text-lg font-semibold">Manage request</h3>{error && <StatusMessage tone="error">{error}</StatusMessage>}
    <fieldset disabled={busy} className="grid gap-4 sm:grid-cols-2"><label className="grid gap-2 text-sm font-semibold">Status<select name="status" defaultValue={ticket.status} className={control}>{SUPPORT_STATUSES.map(value => <option key={value} value={value}>{supportLabel(value)}</option>)}</select></label><label className="grid gap-2 text-sm font-semibold">Assigned administrator<select name="assigned_admin_id" defaultValue={ticket.assignedAdminId ?? ''} className={control}><option value="">Unassigned</option>{ticket.assignedAdminId && !handlers.some(handler => handler.id === ticket.assignedAdminId) && <option value={ticket.assignedAdminId}>{ticket.assignedAdminName}</option>}{handlers.map(handler => <option key={handler.id} value={handler.id}>{handler.name}</option>)}</select></label><Field label="Reason for update" name="reason" required minLength={3} maxLength={2000} hint="Recorded in the ticket history and visible to its user." /></fieldset>
    {cursor && <Button type="button" variant="secondary" onClick={() => void moreHandlers()}>Load more administrators</Button>}<Button type="submit" className="w-fit" disabled={busy}>{busy ? 'Saving update…' : 'Save status / assignment'}</Button>
  </form>
}

export function GuestSupportAccessForm({ client }: { client: SupportClient }) {
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState('')
  const [error, setError] = useState('')
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); if (busy) return
    const form = new FormData(event.currentTarget)
    setBusy(true); setError(''); setMessage('')
    try { setMessage((await client.accessEmail(String(form.get('ticket_number')), String(form.get('guest_email')))).data.message) }
    catch (error) { setError((await supportFailure(error)).message) }
    finally { setBusy(false) }
  }
  return <form onSubmit={submit} className="grid gap-4" aria-busy={busy}><h2 className="text-xl font-semibold">Continue a guest support request</h2><p className="text-sm text-text-secondary">Request a fresh secure email link. Your ticket number alone cannot open the conversation.</p>{message && <StatusMessage tone="success">{message}</StatusMessage>}{error && <StatusMessage tone="error">{error}</StatusMessage>}<Field label="Ticket number" name="ticket_number" required maxLength={32} /><Field label="Email used for this request" name="guest_email" type="email" required maxLength={254} /><Button className="w-fit" type="submit" disabled={busy}>{busy ? 'Requesting access…' : 'Email a secure access link'}</Button></form>
}
