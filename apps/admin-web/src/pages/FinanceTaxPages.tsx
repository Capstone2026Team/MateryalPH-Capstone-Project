import { useEffect, useId, useRef, useState, type ReactNode } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { ArrowLeft, Plus, RefreshCw } from 'lucide-react'
import { ALL_DATES, Button, ControlBar, DateFilter, DemoLabel, DocumentExportButton, Field, FormDialog, MoneyField, Select, StatusBadge, StatusMessage, formatPesoCentavos } from '@materyalph/web-ui'
import { Paged, Table } from '../components/OperationsKit'
import { record } from '../lib/admin-format'
import { taxEvidenceQueue } from '../lib/finance-api'
import { getTaxPackage, listTaxAdjustments, listTaxPackages, listTaxVendors, postTaxAdjustment, prepareTaxAdjustment, prepareTaxPackage, recordTaxSimulation, reviewTaxAdjustment, reviewTaxPackage, taxBasePath, type TaxAdjustment, type TaxAdjustmentPrepareRequest, type TaxPackage, type TaxPackageInput } from '../lib/finance-tax-api'
import { apiProblem, problemText } from '../lib/operations-api'
import { control, label, labelClass, manilaDate, manilaDateTime, useLoad, usePaged } from '../lib/operations-hooks'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'

const taxHome = '/finance?view=tax'
const packageHome = `${taxHome}&taxView=packages`
const forms: { value: TaxPackageInput['form']; name: string }[] = [
  { value: '1601-EQ', name: '1601-EQ · Quarterly return support' }, { value: '2307', name: '2307 · Vendor certificate support' },
  { value: '0619-E', name: '0619-E · Monthly remittance support' }, { value: 'QAP', name: 'QAP · Quarterly payee list' },
  { value: '1604-E', name: '1604-E · Annual return support' }, { value: 'ANNUAL_ALPHALIST', name: 'Annual payee list' },
]
const states: Record<string, string> = { ADJUSTMENT_REQUIRED: 'Needs preparation', UNDER_REVIEW: 'Awaiting review', APPROVED: 'Ready to post', POSTED: 'Posted', REJECTED: 'Returned for correction', NOT_REQUIRED: 'No adjustment needed', DRAFT: 'Draft', REVIEWED: 'Reviewed', EXPORTED: 'Exported', SIMULATED_SUBMISSION_RECORDED: 'Demo submission recorded' }
const blockers: Record<string, string> = { TAX_ADJUSTMENT_REVIEW_REQUIRED: 'An adjustment still needs review or posting.', RECONCILIATION_REQUIRED: 'A source remittance needs reconciliation.', HISTORICAL_TAX_SOURCE_REVIEW_REQUIRED: 'A source tax profile or reporting code needs verification.' }
const amount = (value: unknown): number | null => typeof value === 'number' && Number.isSafeInteger(value) && value >= 0 ? value : null
const explain = async (cause: unknown) => problemText(await apiProblem(cause))

function TaxStatus({ state }: { state: string }) {
  return <StatusBadge label={states[state] ?? label(state)} tone={['POSTED', 'REVIEWED', 'EXPORTED', 'NOT_REQUIRED'].includes(state) ? 'success' : ['ADJUSTMENT_REQUIRED', 'UNDER_REVIEW', 'REJECTED', 'DRAFT'].includes(state) ? 'warning' : 'neutral'} />
}

function Summary({ children }: { children: ReactNode }) {
  return <dl className="grid gap-x-6 gap-y-4 text-sm sm:grid-cols-2">{children}</dl>
}

function Fact({ title, children }: { title: string; children: ReactNode }) {
  return <div className="min-w-0"><dt className="text-text-secondary">{title}</dt><dd className="mt-1 break-words font-semibold text-text-strong">{children}</dd></div>
}

export function FinanceTaxRecords() {
  const [params, setParams] = useSearchParams()
  const view = ['packages', 'evidence'].includes(params.get('taxView') ?? '') ? params.get('taxView')! : 'adjustments'
  return <section className="grid min-w-0 gap-5 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5" aria-labelledby="tax-records-heading">
    <div className="flex flex-wrap items-start justify-between gap-4"><div><h2 id="tax-records-heading" className="text-lg font-semibold">Tax records</h2><p className="mt-1 text-sm text-text-secondary">Review withholding corrections and prepare supporting reports.</p></div>
      <Select label="Tax records view" value={view} onChange={event => setParams({ view: 'tax', taxView: event.target.value })}><option value="adjustments">Tax adjustments</option><option value="packages">Tax support packages</option><option value="evidence">Tax evidence</option></Select></div>
    <DemoLabel>Sample / Demo · No real funds or BIR filing</DemoLabel>
    <div key={view} className="grid min-w-0 gap-4 border-t border-border-default pt-5">{view === 'adjustments' ? <TaxAdjustments /> : view === 'packages' ? <TaxPackages /> : <TaxEvidence />}</div>
  </section>
}

function TaxAdjustments() {
  const [state, setState] = useState<TaxAdjustment['state'] | ''>('ADJUSTMENT_REQUIRED')
  const [range, setRange] = useState(ALL_DATES)
  const [selected, setSelected] = useState<TaxAdjustment | null>(null)
  const [notice, setNotice] = useState('')
  const paged = usePaged(page => listTaxAdjustments(page, state, range), [state, range.from, range.to])
  return <>
    <p className="text-sm text-text-secondary">Prepare a correction, have another finance user review it, then post the approved entry. Original records stay unchanged.</p>
    {notice && <StatusMessage tone="success">{notice}</StatusMessage>}
    <ControlBar tabs={<><Select label="Adjustment status" value={state} onChange={event => setState(event.target.value as typeof state)}><option value="ADJUSTMENT_REQUIRED">Needs preparation</option><option value="UNDER_REVIEW">Awaiting review</option><option value="APPROVED">Ready to post</option><option value="POSTED">Posted</option><option value="REJECTED">Returned for correction</option><option value="NOT_REQUIRED">No adjustment needed</option><option value="">All statuses</option></Select><DateFilter title="Adjustment dates" value={range} onChange={setRange} /></>} actions={<Button variant="secondary" onClick={paged.reload}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    <Paged embedded state={paged} empty="No tax adjustments match these filters.">{items => <Table caption="Tax adjustments" headers={['Vendor / order', 'Reporting period', 'Status', 'Action']}>{items.map(item => <tr key={item.id}>
      <td className="px-4 py-3"><p className="font-semibold">{item.vendorName ?? 'Vendor unavailable'}</p><p className="text-sm text-text-secondary">{item.orderReference ?? 'No linked order'}</p></td><td className="px-4 py-3 text-sm">{manilaDate(item.periodStart)} – {manilaDate(item.periodEnd)}</td><td className="px-4 py-3"><TaxStatus state={item.state} /></td>
      <td className="px-4 py-3"><Button variant="secondary" onClick={() => setSelected(item)} aria-label={`${item.allowedActions.length ? 'Review' : 'View'} adjustment for ${item.orderReference ?? item.vendorName ?? 'Vendor'}`}>{item.allowedActions.length ? 'Review' : 'View'}</Button></td>
    </tr>)}</Table>}</Paged>
    {selected && <AdjustmentDialog key={`${selected.id}-${selected.state}`} item={selected} onClose={() => setSelected(null)} onSaved={next => { setSelected(next.state === 'POSTED' ? null : next); setNotice(next.state === 'UNDER_REVIEW' ? 'Correction prepared. A different finance user must review it.' : next.state === 'APPROVED' ? 'Adjustment approved. Post it to record the correction.' : next.state === 'REJECTED' ? 'Adjustment returned for correction.' : 'Adjustment posted. The original assessment is preserved.'); paged.reload() }} />}
  </>
}

function AdjustmentDialog({ item, onClose, onSaved }: { item: TaxAdjustment; onClose: () => void; onSaved: (item: TaxAdjustment) => void }) {
  const formId = useId()
  const reasonId = useId()
  const before = record(item.beforeValues)
  const after = record(item.afterValues)
  const [withheld, setWithheld] = useState<number | null>(amount(after.proposed_withheld_centavos) ?? amount(before.withheld_centavos))
  const [impact, setImpact] = useState<TaxAdjustmentPrepareRequest['certificateImpact']>(after.certificate_impact === 'REISSUE_REQUIRED' || after.certificate_impact === 'AMENDMENT_REQUIRED' ? after.certificate_impact : 'NONE')
  const [reference, setReference] = useState(typeof after.evidence_reference === 'string' ? after.evidence_reference : '')
  const [reason, setReason] = useState(item.allowedActions.includes('PREPARE') && typeof after.preparer_reason === 'string' ? after.preparer_reason : '')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const prepare = item.allowedActions.includes('PREPARE')
  const review = item.allowedActions.includes('APPROVE')
  const post = item.allowedActions.includes('POST')
  async function save(decision?: 'APPROVED' | 'REJECTED') {
    if (busy) return
    if ((prepare || review) && reason.trim().length < 10) { setError('Enter a reason of at least 10 characters.'); return }
    if (prepare && withheld === null) { setError('Enter a valid corrected withholding amount.'); return }
    setBusy(true); setError('')
    try {
      const next = prepare ? await prepareTaxAdjustment(item.id, { correctedWithheldCentavos: withheld!, reason: reason.trim(), certificateImpact: impact, evidenceReference: reference.trim() || null })
        : review ? await reviewTaxAdjustment(item.id, { decision: decision ?? 'APPROVED', reason: reason.trim() }) : await postTaxAdjustment(item.id)
      onSaved(next)
    } catch (cause) { setError(await explain(cause)) } finally { setBusy(false) }
  }
  return <FormDialog open size="compact" title="Tax adjustment" description={`${item.vendorName ?? 'Vendor'} · ${item.orderReference ?? 'Finance record'}`} busy={busy} onClose={onClose}
    footer={<div className="flex flex-wrap justify-end gap-3"><Button variant="secondary" disabled={busy} onClick={onClose}>Close</Button>{review && <Button variant="secondary" disabled={busy} onClick={() => void save('REJECTED')}>Return for correction</Button>}{(prepare || review || post) && <Button type="submit" form={formId} disabled={busy}>{busy ? 'Saving…' : prepare ? 'Send for review' : review ? 'Approve adjustment' : 'Post adjustment'}</Button>}</div>}>
    <div className="grid gap-5"><div className="flex flex-wrap items-center gap-3"><TaxStatus state={item.state} /><span className="text-sm text-text-secondary">{manilaDate(item.periodStart)} – {manilaDate(item.periodEnd)}</span></div>
      <p className="break-words text-sm">{item.reason}</p><Summary><Fact title="Recorded remittance base">{amount(before.gross_basis_centavos) === null ? 'Not recorded' : formatPesoCentavos(before.gross_basis_centavos as number)}</Fact><Fact title="Original withholding">{amount(before.withheld_centavos) === null ? 'Not recorded' : formatPesoCentavos(before.withheld_centavos as number)}</Fact><Fact title="Proposed withholding">{amount(after.proposed_withheld_centavos) === null ? 'Not prepared' : formatPesoCentavos(after.proposed_withheld_centavos as number)}</Fact>{item.preparer && <Fact title="Prepared by">{item.preparer}</Fact>}{item.reviewer && <Fact title="Reviewed by">{item.reviewer}</Fact>}</Summary>
      {item.separationNote && <StatusMessage tone="info">{item.separationNote}</StatusMessage>}
      {error && <StatusMessage tone="error">{error}</StatusMessage>}
      {(prepare || review || post) && <form id={formId} onSubmit={event => { event.preventDefault(); void save() }}><fieldset disabled={busy} className="grid gap-4 border-t border-border-default pt-5">
        {prepare && <><p className="text-sm text-text-secondary">The recorded remittance base stays unchanged. Enter the corrected withholding amount.</p><MoneyField label="Corrected withholding" valueCentavos={withheld} onChange={setWithheld} /><Select label="Certificate impact" value={impact} onChange={event => setImpact(event.target.value as typeof impact)}><option value="NONE">No certificate change</option><option value="REISSUE_REQUIRED">Reissue required</option><option value="AMENDMENT_REQUIRED">Amendment required</option></Select><Field label="Evidence reference (optional)" value={reference} maxLength={200} onChange={event => setReference(event.target.value)} hint="Reference the refund or document supporting this correction." /></>}
        {(prepare || review) && <label className={labelClass} htmlFor={reasonId}>{prepare ? 'Reason for correction' : 'Review reason'}<textarea id={reasonId} className={`${control} min-h-24 py-3`} required minLength={10} maxLength={2000} value={reason} onChange={event => setReason(event.target.value)} /></label>}
        {review && <p className="text-sm text-text-secondary">Check the proposed amount, certificate impact and supporting evidence before approving.</p>}
        {post && <p className="text-sm text-text-secondary">Posting records the approved correction as a linked demo entry. It does not change the original assessment or submit a BIR filing.</p>}
      </fieldset></form>}
      <details className="border-t border-border-default pt-2"><summary className="min-h-11 cursor-pointer py-3 text-sm font-semibold">Supporting details</summary><Summary><Fact title="Certificate impact">{label(typeof after.certificate_impact === 'string' ? after.certificate_impact : 'Not recorded')}</Fact><Fact title="Evidence reference">{typeof after.evidence_reference === 'string' ? after.evidence_reference : 'Not recorded'}</Fact><Fact title="Preparation reason">{typeof after.preparer_reason === 'string' ? after.preparer_reason : 'Not recorded'}</Fact><Fact title="Recorded">{manilaDateTime(item.createdAt)}</Fact>{item.postedAt && <Fact title="Posted">{manilaDateTime(item.postedAt)}</Fact>}</Summary></details>
    </div>
  </FormDialog>
}

function TaxPackages() {
  const [range, setRange] = useState(ALL_DATES)
  const [creating, setCreating] = useState(false)
  const paged = usePaged(page => listTaxPackages(page, range), [range.from, range.to])
  return <>
    <div className="flex flex-wrap items-center justify-between gap-3"><p className="max-w-2xl text-sm text-text-secondary">Prepare a period report, ask another finance user to review it, then export the reviewed package.</p><Button onClick={() => setCreating(true)}><Plus size={16} aria-hidden="true" />Prepare package</Button></div>
    <ControlBar tabs={<DateFilter title="Package preparation dates" value={range} onChange={setRange} />} actions={<Button variant="secondary" onClick={paged.reload}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    <Paged embedded showTotal={false} state={paged} empty="No tax packages match these dates. Prepare a package when you need a supporting report.">{items => <Table caption="Tax support packages" headers={['Report', 'Reporting period', 'Status', 'Action']}>{items.map(item => <tr key={item.id}><td className="px-4 py-3 font-semibold">{forms.find(form => form.value === item.packageType)?.name ?? item.packageType}</td><td className="px-4 py-3 text-sm">{manilaDate(item.periodStart)} – {manilaDate(item.periodEnd)}</td><td className="px-4 py-3"><TaxStatus state={item.state} /></td><td className="px-4 py-3"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline focus-visible:outline-2 focus-visible:outline-focus-ring" to={`/finance/tax/packages/${item.id}`}>Open package</Link></td></tr>)}</Table>}</Paged>
    {creating && <PreparePackageDialog onClose={() => setCreating(false)} />}
  </>
}

function PreparePackageDialog({ onClose }: { onClose: () => void }) {
  const navigate = useNavigate()
  const formId = useId()
  const [form, setForm] = useState<TaxPackageInput['form']>('1601-EQ')
  const [period, setPeriod] = useState('')
  const [entity, setEntity] = useState<TaxPackageInput['withholdingEntity']>('DEMO_PLATFORM_WITHHOLDER')
  const [vendor, setVendor] = useState('')
  const [vendors, setVendors] = useState<{ id: string; name: string }[]>([])
  const [page, setPage] = useState(1)
  const directory = useLoad(() => listTaxVendors(page), [page])
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const intent = useRef<{ signature: string; key: string } | null>(null)
  useEffect(() => { if (directory.data) setVendors(old => [...new Map([...old, ...directory.data!.items].map(item => [item.id, item])).values()]) }, [directory.data])
  const periodHint = ['1604-E', 'ANNUAL_ALPHALIST'].includes(form) ? 'Use January 1 of the reporting year.' : form === '0619-E' ? 'Use the first day of the first or second month of a quarter.' : 'Use January 1, April 1, July 1 or October 1 of the reporting year.'
  async function save() {
    if (busy) return
    setError(''); setBusy(true)
    const input: TaxPackageInput = { form, periodStart: period, withholdingEntity: entity, vendorOrganizationId: vendor || null }
    const signature = JSON.stringify(input)
    if (intent.current?.signature !== signature) intent.current = { signature, key: crypto.randomUUID() }
    try { const item = await prepareTaxPackage(input, intent.current.key); navigate(`/finance/tax/packages/${item.id}`) } catch (cause) { setError(await explain(cause)) } finally { setBusy(false) }
  }
  return <FormDialog open size="compact" title="Prepare tax package" description="Create a sample report from recorded remittances. Another finance user reviews it before export." busy={busy} onClose={onClose} footer={<div className="flex flex-wrap justify-end gap-3"><Button variant="secondary" disabled={busy} onClick={onClose}>Cancel</Button><Button type="submit" form={formId} disabled={busy}>{busy ? 'Preparing…' : 'Prepare draft'}</Button></div>}>
    <form id={formId} onSubmit={event => { event.preventDefault(); void save() }}><fieldset disabled={busy} className="grid gap-4">
      {error && <StatusMessage tone="error">{error}</StatusMessage>}
      <Select label="Report form" value={form} onChange={event => setForm(event.target.value as typeof form)}>{forms.map(item => <option key={item.value} value={item.value}>{item.name}</option>)}</Select>
      <Field label="Reporting period start" type="date" required value={period} onChange={event => setPeriod(event.target.value)} hint={periodHint} />
      <Select label="Withholding records" value={entity} onChange={event => setEntity(event.target.value as typeof entity)}><option value="DEMO_PLATFORM_WITHHOLDER">Platform withholding · Demo</option><option value="DEMO_PROVIDER_WITHHOLDER">Processor withholding · Demo</option></Select>
      <Select label={form === '2307' ? 'Vendor (required)' : 'Vendor'} required={form === '2307'} value={vendor} onChange={event => setVendor(event.target.value)}><option value="">{form === '2307' ? 'Choose a Vendor' : 'All Vendors'}</option>{vendors.map(item => <option key={item.id} value={item.id}>{item.name}</option>)}</Select>
      {directory.loading && <p role="status" className="text-sm text-text-secondary">Loading Vendors…</p>}{directory.error && <StatusMessage tone="error">{directory.error}<Button variant="quiet" onClick={directory.retry}>Retry Vendors</Button></StatusMessage>}
      {!directory.loading && !directory.error && vendors.length === 0 && <p className="text-sm text-text-secondary">No Vendors are recorded yet.</p>}
      {directory.data?.hasMore && <Button variant="secondary" onClick={() => setPage(value => value + 1)}>Load more Vendors</Button>}
    </fieldset></form>
  </FormDialog>
}

function TaxEvidence() {
  const [range, setRange] = useState(ALL_DATES)
  const paged = usePaged(page => taxEvidenceQueue(page, undefined, range), [range.from, range.to])
  return <>
    <p className="text-sm text-text-secondary">Supporting documents stay in the existing Vendor verification record.</p><ControlBar tabs={<DateFilter title="Tax evidence dates" value={range} onChange={setRange} />} actions={<Button variant="secondary" onClick={paged.reload}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    <Paged embedded state={paged} empty="No tax evidence matches these dates.">{items => <Table caption="Tax evidence" headers={['Vendor', 'Document', 'Review status', 'Action']}>{items.map(item => <tr key={item.id}><td className="px-4 py-3 font-semibold">{item.vendor.name}</td><td className="px-4 py-3 text-sm">{label(item.evidenceType)}<p className="text-text-secondary">{item.taxableYear ? `Tax year ${item.taxableYear}` : `Profile version ${item.taxProfileVersion}`}</p></td><td className="px-4 py-3"><StatusBadge label={label(item.reviewState)} tone={item.reviewState === 'APPROVED' ? 'success' : 'neutral'} /></td><td className="px-4 py-3"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline focus-visible:outline-2 focus-visible:outline-focus-ring" to={`/vendor-verification/${item.vendor.id}`}>Open verification</Link></td></tr>)}</Table>}</Paged>
  </>
}

export function AdminTaxPackagePage() {
  const { packageId = '' } = useParams()
  const loaded = useLoad(() => getTaxPackage(packageId), [packageId])
  const [reviewing, setReviewing] = useState(false)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [notice, setNotice] = useState('')
  const item = loaded.data
  const snapshot = record(item?.snapshot)
  const issues = Array.isArray(snapshot.blockers) ? snapshot.blockers.filter((value): value is string => typeof value === 'string') : []
  async function simulate() {
    if (busy) return
    setBusy(true); setError('')
    try { await recordTaxSimulation(packageId); setNotice('Demo submission recorded. No government filing or payment was created.'); loaded.retry() } catch (cause) { setError(await explain(cause)) } finally { setBusy(false) }
  }
  return <AdminShell activeHref="/finance"><div className="grid min-w-0 gap-5">
    <Link to={packageHome} className="inline-flex min-h-11 w-fit items-center gap-2 text-sm font-semibold text-text-secondary hover:text-text-strong"><ArrowLeft size={16} aria-hidden="true" />Tax records</Link>
    <PageHeader compact eyebrow="Finance · Reconciliation" title="Tax support package" description="Review the report and its sources before exporting." actions={<Button variant="secondary" disabled={loaded.loading || busy} onClick={loaded.retry}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    <DemoLabel>Sample / Demo · No real funds or BIR filing</DemoLabel>{notice && <StatusMessage tone="success">{notice}</StatusMessage>}{error && <StatusMessage tone="error">{error}</StatusMessage>}
    {loaded.error ? <ErrorState message={loaded.error} onRetry={loaded.retry} /> : !item ? <LoadingState /> : <section className="grid min-w-0 gap-5 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5">
      <div className="flex flex-wrap items-start justify-between gap-3"><div><h2 className="text-lg font-semibold">{forms.find(form => form.value === item.packageType)?.name ?? item.packageType}</h2><p className="mt-1 text-sm text-text-secondary">{manilaDate(item.periodStart)} – {manilaDate(item.periodEnd)}</p></div><TaxStatus state={item.state} /></div>
      <Summary><Fact title="Withholding records">{item.withholdingEntity === 'DEMO_PLATFORM_WITHHOLDER' ? 'Platform · Demo' : 'Processor · Demo'}</Fact><Fact title="Reviewed due date">{item.actualDueDate ? manilaDate(item.actualDueDate) : 'Awaiting independent review'}</Fact><Fact title="Remittance base">{amount(snapshot.basis_centavos) === null ? 'Not recorded' : formatPesoCentavos(snapshot.basis_centavos as number)}</Fact><Fact title="Withholding total">{amount(snapshot.tax_centavos) === null ? 'Not recorded' : formatPesoCentavos(snapshot.tax_centavos as number)}</Fact></Summary>
      {issues.length > 0 && <StatusMessage tone="info"><p className="font-semibold">Resolve these records before preparing a new package.</p><ul className="mt-2 list-disc pl-5">{issues.map(issue => <li key={issue}>{blockers[issue] ?? label(issue)}</li>)}</ul><Link className="mt-2 inline-flex min-h-11 items-center font-semibold underline" to={taxHome}>Open tax records</Link></StatusMessage>}
      <div className="flex flex-wrap gap-3 border-t border-border-default pt-4">{item.state === 'DRAFT' && issues.length === 0 && <Button onClick={() => setReviewing(true)}>Review package</Button>}{['REVIEWED', 'EXPORTED', 'SIMULATED_SUBMISSION_RECORDED'].includes(item.state) && <DocumentExportButton basePath={taxBasePath} audience="admin" types={['TAX_PACKAGE']} resourceId={item.id} title="Reviewed demo tax support package" />}{item.state === 'EXPORTED' && <Button variant="secondary" disabled={busy} onClick={() => void simulate()}>Record demo submission</Button>}<Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline" to={packageHome}>All packages</Link></div>
      <details className="border-t border-border-default pt-2"><summary className="min-h-11 cursor-pointer py-3 text-sm font-semibold">Report contents and source details</summary><div className="grid gap-4 pt-2"><p className="text-sm text-text-secondary">Suggested deadline: {manilaDate(item.nominalDueDate)}. A different finance user must validate the applicable deadline and sources.</p><p className="break-words text-sm text-text-secondary">Calendar source: {item.dueDateSource ?? 'Not recorded'}</p><PackageRows snapshot={snapshot} />{item.contentHash && <p className="break-all text-xs text-text-secondary">File verification hash: {item.contentHash}</p>}</div></details>
    </section>}
    {reviewing && item && <PackageReviewDialog item={item} onClose={() => setReviewing(false)} onSaved={next => { setReviewing(false); loaded.set(next); setNotice('Package reviewed. You can now export the sample report.') }} />}
  </div></AdminShell>
}

function PackageRows({ snapshot }: { snapshot: Record<string, unknown> }) {
  const rows = Array.isArray(snapshot.rows) ? snapshot.rows.filter((row): row is unknown[] => Array.isArray(row)).slice(4) : []
  return rows.length > 0 ? <Table caption="Package report contents" headers={['Payee / item', 'Month / value', 'Reporting code', 'Remittance base (PHP)', 'Withholding (PHP)', 'Review details', 'Assessment reference']}>{rows.map((row, index) => <tr key={index}>{Array.from({ length: 7 }, (_, cell) => <td key={cell} className="max-w-64 break-words px-4 py-3 text-sm">{typeof row[cell] === 'string' || typeof row[cell] === 'number' ? String(row[cell]) : '—'}</td>)}</tr>)}</Table> : <p className="text-sm text-text-secondary">No source rows are recorded.</p>
}

function PackageReviewDialog({ item, onClose, onSaved }: { item: TaxPackage; onClose: () => void; onSaved: (item: TaxPackage) => void }) {
  const formId = useId()
  const [due, setDue] = useState(item.actualDueDate ?? '')
  const [source, setSource] = useState('')
  const [reason, setReason] = useState('')
  const [checked, setChecked] = useState(false)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  async function save() {
    if (busy) return
    setBusy(true); setError('')
    try { onSaved(await reviewTaxPackage(item.id, { lockVersion: item.lockVersion, actualDueDate: due, dueDateSource: source.trim(), reason: reason.trim(), reconciled: checked })) } catch (cause) { setError(await explain(cause)) } finally { setBusy(false) }
  }
  return <FormDialog open size="compact" title="Review tax package" description="A different finance user must review the prepared package. Confirm the report, deadline and supporting records." busy={busy} onClose={onClose} footer={<div className="flex flex-wrap justify-end gap-3"><Button variant="secondary" disabled={busy} onClick={onClose}>Cancel</Button><Button type="submit" form={formId} disabled={busy}>{busy ? 'Saving…' : 'Approve package'}</Button></div>}>
    <form id={formId} onSubmit={event => { event.preventDefault(); void save() }}><fieldset disabled={busy} className="grid gap-4">{error && <StatusMessage tone="error">{error}</StatusMessage>}<Field label="Reviewed due date" type="date" required value={due} onChange={event => setDue(event.target.value)} /><Field label="Deadline source and version" required minLength={10} maxLength={1000} value={source} onChange={event => setSource(event.target.value)} hint="Cite the calendar or reference you checked." /><Field label="Review reason" required minLength={10} maxLength={2000} value={reason} onChange={event => setReason(event.target.value)} /><label className="flex min-h-11 items-start gap-3 text-sm"><input className="mt-1 size-5 shrink-0" type="checkbox" required checked={checked} onChange={event => setChecked(event.target.checked)} />I checked the issuer, Vendors, period, withholding and adjustments.</label></fieldset></form>
  </FormDialog>
}
