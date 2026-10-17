import { ALL_DATES, Button, DateFilter, EventTimeline, FactList, FilterTabs, InfoNote, ReasonedDecisionForm, SidePanel, StatusBadge, Toolbar, analyticsDay, formatAnalyticsDate, manilaToday } from '@materyalph/web-ui'
import { parseDate } from '@materyalph/api-client-ts'
import { ArrowLeft, Plus, RefreshCw } from 'lucide-react'
import { useRef, useState, type FormEvent } from 'react'
import { Link, useNavigate, useParams } from 'react-router-dom'
import { Pager, Panel } from '../components/OperationsKit'
import { control, label as humanize, labelClass, manilaDate, manilaDateTime, useLoad, useProtectedAction } from '../lib/operations-hooks'
import { getPrivacy, isConflict, listPrivacy, newKey, problemText, recordPrivacy, transitionPrivacy, type PrivacyRequestDetail } from '../lib/operations-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'
import { dateQuery } from '../lib/admin-format'

const TYPES = ['ACCESS', 'CORRECTION', 'OBJECTION', 'DELETION', 'RESTRICTION', 'PORTABILITY', 'OTHER']
const CHANNELS = ['DPO_EMAIL', 'SUPPORT_CASE', 'WRITTEN_LETTER', 'IN_APP']
const METHODS = ['REGISTERED_EMAIL_CONFIRMATION', 'SIGNED_IN_ACCOUNT_CONFIRMATION', 'GOVERNMENT_ID_SIGHTED', 'AUTHORIZED_REPRESENTATIVE_DOCUMENT_SIGHTED']
const COMMAND_LABEL: Record<string, string> = { ASSIGN: 'Assign handler', VERIFY: 'Record identity verification', START: 'Start handling', COMPLETE: 'Complete request', REJECT: 'Reject request', WITHDRAW: 'Record withdrawal' }
const COMMAND_AFTER: Record<string, string> = { ASSIGN: 'Handler and target date recorded', VERIFY: 'Identity Verified', START: 'In Progress', COMPLETE: 'Completed', REJECT: 'Rejected', WITHDRAW: 'Withdrawn' }
const tone = (state: string) => state === 'COMPLETED' ? 'success' : state === 'REJECTED' ? 'error' : state === 'WITHDRAWN' ? 'neutral' : state === 'RECEIVED' ? 'warning' : 'info'

export function AdminPrivacyQueuePage() {
  const [state, setState] = useState('')
  const [type, setType] = useState('')
  const [handler, setHandler] = useState('')
  const [page, setPage] = useState(1)
  const [recording, setRecording] = useState(false)
  const [range, setRange] = useState(ALL_DATES)
  const list = useLoad(() => listPrivacy({ ...(state ? { state: state as never } : {}), ...(type ? { requestType: type as never } : {}), ...(handler ? { handler: handler as never } : {}), ...dateQuery(range), page }), [state, type, handler, range.from, range.to, page])
  const items = list.data?.items ?? []
  return <AdminShell activeHref="/privacy"><div className="space-y-6">
    <PageHeader eyebrow="Platform" title="Privacy Requests" description="Data-subject requests received through the DPO channels, from identity verification to a recorded outcome. Personal data is shown masked."
      actions={<><Button variant="secondary" disabled={list.loading} onClick={list.retry}><RefreshCw size={16} aria-hidden="true" />Refresh</Button><Button onClick={() => setRecording(true)}><Plus size={16} aria-hidden="true" />Record request</Button></>} />
    <InfoNote>Record identity verification before disclosing or changing any data. A rejection or partial completion needs the legal exception relied on.</InfoNote>
    <FilterTabs label="Request state" value={state} onChange={value => { setState(value); setPage(1) }} chips={[{ value: '', label: 'All (open first)' }, { value: 'RECEIVED', label: 'Received' }, { value: 'IDENTITY_VERIFIED', label: 'Identity verified' }, { value: 'IN_PROGRESS', label: 'In progress' }, { value: 'COMPLETED', label: 'Completed' }, { value: 'REJECTED', label: 'Rejected' }, { value: 'WITHDRAWN', label: 'Withdrawn' }]} />
    <Toolbar filters={<>
      <DateFilter title="Request received dates" value={range} onChange={value => { setRange(value); setPage(1) }} />
      <label className="sr-only" htmlFor="privacy-type">Request type</label>
      <select id="privacy-type" className={`${control} w-auto`} value={type} onChange={event => { setType(event.target.value); setPage(1) }}><option value="">All request types</option>{TYPES.map(item => <option key={item} value={item}>{humanize(item)}</option>)}</select>
      <label className="sr-only" htmlFor="privacy-handler">Handler</label>
      <select id="privacy-handler" className={`${control} w-auto`} value={handler} onChange={event => { setHandler(event.target.value); setPage(1) }}><option value="">Any handler</option><option value="UNASSIGNED">Unassigned</option></select>
      {(state || type || handler || range.from || range.to) && <Button variant="quiet" onClick={() => { setState(''); setType(''); setHandler(''); setRange(ALL_DATES); setPage(1) }}>Reset filters</Button>}
    </>} />
    {list.error ? <ErrorState message={list.error} onRetry={list.retry} /> : !list.data ? <LoadingState /> : items.length === 0
      ? <p className="rounded-surface border border-dashed border-border-default bg-surface-primary px-6 py-10 text-center text-sm text-text-secondary">No privacy requests match this view.</p>
      : <div className="overflow-x-auto rounded-surface border border-border-default bg-surface-primary"><table className="w-full min-w-[860px] text-left text-sm">
        <caption className="sr-only">Privacy requests</caption>
        <thead className="bg-surface-canvas text-[13px] text-text-secondary"><tr>{['Reference', 'Type', 'Subject', 'State', 'Received', 'Target date', 'Handler'].map(head => <th key={head} scope="col" className="px-4 py-3 font-semibold">{head}</th>)}</tr></thead>
        <tbody className="divide-y divide-border-default">{items.map(item => <tr key={item.id}>
          <th scope="row" className="px-4 py-3 text-left"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline-offset-4 hover:underline" to={`/privacy/${item.id}`}>{item.reference}</Link></th>
          <td className="px-4 py-3">{humanize(item.requestType)}</td>
          <td className="px-4 py-3">{item.subjectDisplay}<p className="text-[13px] text-text-secondary">{humanize(item.subjectAccountType)}</p></td>
          <td className="px-4 py-3"><StatusBadge label={humanize(item.state)} tone={tone(item.state)} />{!item.identityVerified && !['REJECTED', 'WITHDRAWN'].includes(item.state) && <p className="mt-1 text-[13px] text-text-secondary">Identity not verified</p>}</td>
          <td className="px-4 py-3">{manilaDate(item.receivedAt)}</td>
          <td className="px-4 py-3">{item.targetDate ? formatAnalyticsDate(item.targetDate) : 'Not set'}</td>
          <td className="px-4 py-3">{item.handler ?? 'Unassigned'}</td>
        </tr>)}</tbody>
      </table></div>}
    {list.data && <Pager page={page} lastPage={list.data.lastPage} total={list.data.total} busy={list.loading} onChange={setPage} />}
    {recording && <RecordPrivacyPanel onClose={() => setRecording(false)} />}
  </div></AdminShell>
}

function RecordPrivacyPanel({ onClose }: { onClose: () => void }) {
  const navigate = useNavigate()
  const [error, setError] = useState<string | null>(null)
  const [fields, setFields] = useState<Record<string, string>>({})
  const key = useRef({ scope: '', value: newKey() })
  const { run, busy, dialog } = useProtectedAction()
  async function submit(event: FormEvent<HTMLFormElement>) {
    event.preventDefault(); setError(null); setFields({})
    const data = new FormData(event.currentTarget)
    const input = { subjectEmail: String(data.get('subject_email')).trim(), requestType: String(data.get('request_type')) as never, intakeChannel: String(data.get('intake_channel')) as never,
      receivedOn: parseDate(String(data.get('received_on'))), scope: String(data.get('scope')).trim(), note: String(data.get('note')).trim() }
    const scope = JSON.stringify(input)
    if (key.current.scope !== scope) key.current = { scope, value: newKey() }
    const result = await run('Verify to record a privacy request', () => recordPrivacy(input, key.current.value))
    if (result.ok) navigate(`/privacy/${result.value.id}`)
    else { setFields(result.problem.fields); setError(problemText(result.problem)) }
  }
  const fieldError = (name: string) => fields[name] ? <span role="alert" className="text-sm font-normal text-status-error">{fields[name]}</span> : null
  return <SidePanel open title="Record privacy request" description="Record a request received outside the app. The subject account must exist; its email is matched exactly." onClose={onClose}>
    <form onSubmit={event => void submit(event)} className="grid gap-5" noValidate>
      <label className={labelClass}>Subject account email<input name="subject_email" type="email" required className={control} autoComplete="off" />{fieldError('subject_email')}</label>
      <label className={labelClass}>Request type<select name="request_type" className={control}>{TYPES.map(item => <option key={item} value={item}>{humanize(item)}</option>)}</select></label>
      <label className={labelClass}>Intake channel<select name="intake_channel" className={control}>{CHANNELS.map(item => <option key={item} value={item}>{humanize(item)}</option>)}</select></label>
      <label className={labelClass}>Received on<input name="received_on" type="date" required className={control} defaultValue={manilaToday()} />{fieldError('received_on')}</label>
      <label className={labelClass}>Scope of the request<textarea name="scope" required minLength={10} maxLength={4000} className={`${control} min-h-24 py-2`} />{fieldError('scope')}</label>
      <label className={labelClass}>Intake note<textarea name="note" required minLength={3} maxLength={2000} className={`${control} min-h-16 py-2`} />{fieldError('note')}</label>
      {error && <p role="alert" className="rounded-control border border-status-error/30 bg-red-50 px-4 py-3 text-sm text-red-900">{error}</p>}
      <div className="flex justify-end"><Button type="submit" disabled={busy}>{busy ? 'Saving…' : 'Record request'}</Button></div>
    </form>
    {dialog}
  </SidePanel>
}

export function AdminPrivacyDetailPage() {
  const { requestId = '' } = useParams()
  const detail = useLoad(() => getPrivacy(requestId), [requestId])
  return <AdminShell activeHref="/privacy"><div className="space-y-6">
    <Link to="/privacy" className="inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-action-primary"><ArrowLeft size={16} aria-hidden="true" />Back to Privacy Requests</Link>
    {detail.error ? <ErrorState message={detail.error} onRetry={detail.retry} /> : !detail.data ? <LoadingState /> : <PrivacyCase detail={detail.data} onChanged={detail.set} onReload={detail.retry} />}
  </div></AdminShell>
}

function PrivacyCase({ detail, onChanged, onReload }: { detail: PrivacyRequestDetail; onChanged: (next: PrivacyRequestDetail) => void; onReload: () => void }) {
  const [command, setCommand] = useState<string | null>(null)
  const [extra, setExtra] = useState({ handler: '', targetDate: analyticsDay(detail.targetDate) ?? '', method: METHODS[0] ?? '', exception: '' })
  const [error, setError] = useState<string | null>(null)
  const [conflict, setConflict] = useState<string | null>(null)
  const { run, busy, dialog } = useProtectedAction()
  async function submit(note: string) {
    if (!command) return
    setError(null); setConflict(null)
    const input = { lockVersion: detail.lockVersion, note,
      ...(command === 'ASSIGN' ? { handlerUserId: Number(extra.handler), ...(extra.targetDate ? { targetDate: parseDate(extra.targetDate) } : {}) } : {}),
      ...(command === 'VERIFY' ? { verificationMethod: extra.method as never } : {}),
      ...(['COMPLETE', 'REJECT'].includes(command) && extra.exception.trim() ? { legalException: extra.exception.trim() } : {}) }
    const result = await run('Verify to update this privacy request', () => transitionPrivacy(detail.id, command.toLowerCase() as never, input))
    if (result.ok) { onChanged(result.value); setCommand(null); return }
    if (isConflict(result.problem)) setConflict('This request changed after you opened it. Reload to review the current state.')
    else setError(problemText(result.problem))
  }
  return <>
    <PageHeader compact eyebrow={`${humanize(detail.requestType)} request`} title={detail.reference} description={`Received ${manilaDate(detail.receivedAt)} via ${humanize(detail.intakeChannel ?? 'Unknown')}.`} />
    <div className="flex flex-wrap gap-2"><StatusBadge label={humanize(detail.state)} tone={tone(detail.state)} /><StatusBadge label={detail.identityVerified ? 'Identity verified' : 'Identity not verified'} tone={detail.identityVerified ? 'success' : 'warning'} /></div>
    <div className="grid items-start gap-5 xl:grid-cols-[minmax(0,1.3fr)_minmax(0,1fr)]">
      <div className="grid min-w-0 gap-5">
        <Panel title="Request">
          <FactList facts={[{ label: 'Subject', value: `${detail.subjectDisplay} · ${detail.subjectMaskedEmail}` }, { label: 'Account type', value: humanize(detail.subjectAccountType) }, { label: 'Scope', value: detail.scope ?? '—' },
            { label: 'Handler', value: detail.handler ?? 'Unassigned' }, { label: 'Target date', value: detail.targetDate ? formatAnalyticsDate(detail.targetDate) : 'Not set' },
            { label: 'Identity verification', value: detail.identityVerificationMethod ? `${humanize(detail.identityVerificationMethod)} · ${manilaDateTime(detail.identityVerifiedAt)}` : 'Not recorded' },
            ...(detail.legalException ? [{ label: 'Legal exception', value: detail.legalException }] : []), ...(detail.responseSummary ? [{ label: 'Response summary', value: detail.responseSummary }] : []),
            ...(detail.completedAt ? [{ label: 'Closed', value: manilaDateTime(detail.completedAt) }] : [])]} />
        </Panel>
        <Panel title="History" description="Append-only; notes are recorded with the actor and correlation ID.">
          <EventTimeline label="Privacy request history" formatDate={manilaDateTime} events={detail.events.map((event, index) => ({ id: `${event.correlationId}-${index}`, title: `${humanize(event.event)} · ${humanize(event.toState)}`, at: event.occurredAt, actor: `${event.actor} (${event.actorRole})`,
            detail: <><p>{event.note}</p><p className="break-all text-[13px] text-text-secondary">Correlation ID {event.correlationId}</p></> }))} />
        </Panel>
      </div>
      {detail.allowedActions.length > 0 && <Panel title="Next step">
        {!command ? <div className="flex flex-wrap gap-2">{detail.allowedActions.map(action => <Button key={action} variant={action === 'REJECT' ? 'danger' : action === 'WITHDRAW' ? 'secondary' : 'primary'} onClick={() => setCommand(action)}>{COMMAND_LABEL[action] ?? humanize(action)}</Button>)}</div>
          : <ReasonedDecisionForm title={COMMAND_LABEL[command] ?? humanize(command)} target={`${detail.reference} (${humanize(detail.requestType)})`} version={detail.lockVersion} before={humanize(detail.state)} after={COMMAND_AFTER[command]}
            submitLabel={COMMAND_LABEL[command] ?? 'Save'} variant={command === 'REJECT' ? 'danger' : 'primary'} busy={busy} error={error} conflict={conflict} onReload={onReload} minReason={3} maxReason={4000} onSubmit={note => void submit(note)}>
            {command === 'ASSIGN' && <><label className={labelClass}>Handler<select className={control} value={extra.handler} onChange={event => setExtra({ ...extra, handler: event.target.value })}><option value="">Choose a handler</option>{detail.handlers.map(item => <option key={item.userId} value={item.userId}>{item.name} · {item.role}</option>)}</select></label>
              <label className={labelClass}>Target date<input type="date" className={control} value={extra.targetDate} onChange={event => setExtra({ ...extra, targetDate: event.target.value })} /></label></>}
            {command === 'VERIFY' && <label className={labelClass}>Verification method<select className={control} value={extra.method} onChange={event => setExtra({ ...extra, method: event.target.value })}>{METHODS.map(item => <option key={item} value={item}>{humanize(item)}</option>)}</select></label>}
            {(command === 'COMPLETE' || command === 'REJECT') && <label className={labelClass}>Legal exception relied on {command === 'REJECT' ? '(required)' : '(if partial)'}<textarea className={`${control} min-h-16 py-2`} maxLength={2000} value={extra.exception} onChange={event => setExtra({ ...extra, exception: event.target.value })} /></label>}
            <Button variant="quiet" className="w-fit" onClick={() => { setCommand(null); setError(null); setConflict(null) }}>Cancel</Button>
          </ReasonedDecisionForm>}
      </Panel>}
    </div>
    {dialog}
  </>
}
