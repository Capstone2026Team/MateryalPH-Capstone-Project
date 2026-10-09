import { Button, FactList, FilterChips, HealthBadge, ReasonedDecisionForm, StatusBadge, formatManilaDateTime, formatPesoCentavos } from '@materyalph/web-ui'
import { useState } from 'react'
import { Link } from 'react-router-dom'
import { Paged, Panel, Table } from '../components/OperationsKit'
import { financeKpis, listTaxAdjustments, postTaxAdjustment, prepareTaxAdjustment, remittanceQueue, reviewTaxAdjustment, taxEvidenceQueue, type FinanceKpis, type TaxAdjustment } from '../lib/finance-api'
import { label as humanize, labelClass, control, useLoad, usePaged, useProtectedAction } from '../lib/operations-hooks'
import { isConflict, problemText } from '../lib/operations-api'
import { ErrorState, LoadingState } from './PhaseThreeAdminPages'

const iso = (date: Date) => date.toISOString().slice(0, 10)
/** Exact peso text to integer centavos without binary floating point; null when the text is not a peso amount. */
const toCentavos = (text: string): number | null => { const match = /^(\d{1,12})(?:\.(\d{1,2}))?$/.exec(text.trim()); return match ? Number(match[1]) * 100 + Number((match[2] ?? '').padEnd(2, '0')) : null }

/** Commerce (GMV) and finance amounts are kept in separate groups and are never summed together. */
export function FinanceKpiPanel() {
  const [range, setRange] = useState({ from: iso(new Date(Date.now() - 29 * 86_400_000)), to: iso(new Date()) })
  const kpis = useLoad(() => financeKpis(range.from, range.to), [range.from, range.to])
  return <section aria-labelledby="kpi-heading" className="grid gap-4">
    <div className="flex flex-wrap items-end justify-between gap-3"><div><h2 id="kpi-heading" className="text-lg font-semibold">Finance overview</h2>{kpis.data && <p className="text-sm text-text-secondary">{kpis.data.label} · {kpis.data.scenario}</p>}</div>
      <div className="flex flex-wrap gap-3"><label className={labelClass}>From<input type="date" className={control} value={range.from} max={range.to} onChange={event => setRange({ ...range, from: event.target.value })} /></label>
        <label className={labelClass}>To<input type="date" className={control} value={range.to} min={range.from} onChange={event => setRange({ ...range, to: event.target.value })} /></label></div></div>
    {kpis.error ? <ErrorState message={kpis.error} onRetry={kpis.retry} /> : !kpis.data ? <LoadingState /> : <>
      <KpiGroup title="Marketplace commerce (GMV)" description="Commercial value of confirmed orders. Not revenue, not cash." items={kpis.data.commerce} />
      <KpiGroup title="Platform finance" description="Withholding, commission, revenue, cash and receivables. Assessed CWT is never platform revenue." items={kpis.data.finance} />
      <Readiness counts={kpis.data.counts} />
    </>}
  </section>
}

function KpiGroup({ title, description, items }: { title: string; description: string; items: FinanceKpis['commerce'] }) {
  return <div className="grid gap-3"><div><h3 className="font-semibold">{title}</h3><p className="text-sm text-text-secondary">{description}</p></div>
    <dl className="grid grid-cols-1 gap-3 min-[420px]:grid-cols-2 xl:grid-cols-4">{items.map(item => <div key={item.key} className="min-w-0 rounded-xl border border-border-default bg-surface-primary p-4"><dt className="text-[13px] font-medium text-text-secondary">{item.label}</dt>
      <dd className="mt-2 text-xl font-semibold tabular-nums">{formatPesoCentavos(item.valueCentavos)}</dd><dd className="mt-1 text-[13px] text-text-secondary">{item.definition}</dd></div>)}</dl></div>
}

/** Report readiness: a tax support package should be prepared only when every blocking queue is empty. */
function Readiness({ counts }: { counts: Record<string, number> }) {
  const rows = [
    { key: 'unreconciled_remittances', label: 'Unreconciled remittances', href: '/finance?view=remittances' },
    { key: 'open_tax_adjustments', label: 'Open tax adjustments', href: '/finance?view=adjustments' },
    { key: 'pending_certificates', label: 'Certificates not yet verified', href: '/finance?view=evidence' },
    { key: 'draft_statements', label: 'Draft commission statements', href: '/finance?view=statements' },
  ]
  const ready = rows.every(row => (counts[row.key] ?? 0) === 0)
  return <Panel title="Report readiness" description="DEMO tax support packages are prepared and reviewed under Reports; nothing is filed with the BIR." actions={<HealthBadge state={ready ? 'HEALTHY' : 'DEGRADED'} label={ready ? 'Ready to prepare' : 'Blocked'} />}>
    <ul className="grid gap-2 sm:grid-cols-2">{rows.map(row => { const value = counts[row.key] ?? 0; return <li key={row.key} className="flex items-center justify-between gap-3 rounded-control border border-border-default px-3 py-2 text-sm">
      <span className="flex items-center gap-2"><HealthBadge state={value === 0 ? 'HEALTHY' : 'DEGRADED'} label={value === 0 ? 'Clear' : String(value)} />{row.label}</span>{value > 0 && <Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline-offset-4 hover:underline" to={row.href}>Open</Link>}</li> })}</ul>
    <Link className="inline-flex min-h-11 w-fit items-center font-semibold text-action-primary underline underline-offset-4" to="/reports/tax">Open tax support packages</Link>
  </Panel>
}

export function RemittanceQueue() {
  const [state, setStateFilter] = useState('RECONCILIATION_EXCEPTION')
  const paged = usePaged(page => remittanceQueue(page, state || undefined), [state])
  return <section className="grid gap-4" aria-labelledby="remittance-heading">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="remittance-heading" className="text-lg font-semibold">Remittance reconciliation</h2>
      <FilterChips label="Reconciliation state" chips={[{ value: 'RECONCILIATION_EXCEPTION', label: 'Exceptions' }, { value: 'PENDING', label: 'Pending' }, { value: 'RECONCILED', label: 'Reconciled' }, { value: '', label: 'All' }]} value={state} onChange={setStateFilter} /></div>
    <p className="text-sm text-text-secondary">FIN-05 components with the FIN-04A threshold status before and after each remittance. Exceptions are resolved from their finance work item; taxpayer identifiers are masked.</p>
    <Paged state={paged} empty="No remittances in this state.">
      {items => <Table caption="Remittance assessments" headers={['Order / Vendor', 'Gross basis', 'Withheld (W)', 'Reported', 'Threshold', 'States', 'Work item']}>
        {items.map(row => { const parts = row.components as Record<string, number | null>; return <tr key={row.id} className="align-top">
          <td className="px-4 py-3"><p className="font-semibold">{row.orderReference}</p><p className="text-[13px] text-text-secondary">{row.vendorName} · taxpayer …{row.taxpayerKeySuffix}</p></td>
          <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(parts.gross_basis_centavos ?? 0)}</td>
          <td className="px-4 py-3 tabular-nums">{formatPesoCentavos(parts.withheld_centavos ?? 0)}</td>
          <td className="px-4 py-3 tabular-nums">{parts.reported_withheld_centavos === null || parts.reported_withheld_centavos === undefined ? '—' : formatPesoCentavos(parts.reported_withheld_centavos)}</td>
          <td className="px-4 py-3 text-[13px]">{humanize(row.thresholdStatusBefore ?? 'NONE')} → {humanize(row.thresholdStatusAfter ?? 'NONE')}{row.gEffectiveAfterCentavos !== null && row.gEffectiveAfterCentavos !== undefined && <p className="text-text-secondary">G effective {formatPesoCentavos(row.gEffectiveAfterCentavos)}</p>}</td>
          <td className="px-4 py-3 text-[13px]"><p>Calculation: {humanize(row.calculationState)}</p><p>Evidence: {humanize(row.deductionEvidenceState)}</p><p><StatusBadge label={humanize(row.reconciliationState)} tone={row.reconciliationState === 'RECONCILED' ? 'success' : row.reconciliationState === 'PENDING' ? 'neutral' : 'error'} /></p></td>
          <td className="px-4 py-3">{row.reviewItemId ? <Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline-offset-4 hover:underline" to="/finance?view=queue">Open work queue</Link> : '—'}</td>
        </tr> })}
      </Table>}
    </Paged>
  </section>
}

export function TaxEvidenceQueue() {
  const [state, setStateFilter] = useState('PENDING')
  const paged = usePaged(page => taxEvidenceQueue(page, state || undefined), [state])
  return <section className="grid gap-4" aria-labelledby="evidence-heading">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="evidence-heading" className="text-lg font-semibold">Tax evidence</h2>
      <FilterChips label="Review state" chips={[{ value: 'PENDING', label: 'Pending' }, { value: 'APPROVED', label: 'Approved' }, { value: 'REJECTED', label: 'Rejected' }, { value: '', label: 'All' }]} value={state} onChange={setStateFilter} /></div>
    <p className="text-sm text-text-secondary">Sworn Declarations and other FIN-04 evidence. Decisions are made in the Vendor verification case. A declaration never reverses a crossed FIN-04A threshold for that year.</p>
    <Paged state={paged} empty="No tax evidence in this state.">
      {items => <Table caption="Tax evidence" headers={['Vendor', 'Evidence', 'Taxable year', 'Validity', 'Review', 'Decision']}>
        {items.map(row => <tr key={row.id} className="align-top"><td className="px-4 py-3 font-semibold">{row.vendor.name}</td><td className="px-4 py-3">{humanize(row.evidenceType)}<p className="text-[13px] text-text-secondary">{humanize(row.origin)} · profile v{row.taxProfileVersion}</p></td>
          <td className="px-4 py-3">{row.taxableYear ?? '—'}</td><td className="px-4 py-3 text-[13px]">{row.validFrom ? iso(row.validFrom) : '—'} – {row.validUntil ? iso(row.validUntil) : 'open'}</td>
          <td className="px-4 py-3"><StatusBadge label={humanize(row.reviewState)} tone={row.reviewState === 'APPROVED' ? 'success' : row.reviewState === 'REJECTED' ? 'error' : 'warning'} />{row.note && <p className="mt-1 text-[13px] text-text-secondary">{row.note}</p>}</td>
          <td className="px-4 py-3"><Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline-offset-4 hover:underline" to={row.decisionHref}>Open case</Link></td></tr>)}
      </Table>}
    </Paged>
  </section>
}

export function TaxAdjustments() {
  const [state, setStateFilter] = useState('ADJUSTMENT_REQUIRED')
  const paged = usePaged(page => listTaxAdjustments(page, state || undefined), [state])
  return <section className="grid gap-4" aria-labelledby="adjustments-heading">
    <div className="flex flex-wrap items-center justify-between gap-3"><h2 id="adjustments-heading" className="text-lg font-semibold">Tax adjustments</h2>
      <FilterChips label="Adjustment state" chips={[{ value: 'ADJUSTMENT_REQUIRED', label: 'To prepare' }, { value: 'UNDER_REVIEW', label: 'To review' }, { value: 'APPROVED', label: 'To post' }, { value: 'POSTED', label: 'Posted' }, { value: 'REJECTED', label: 'Rejected' }]} value={state} onChange={setStateFilter} /></div>
    <p className="text-sm text-text-secondary">Corrections never edit an original record: a reviewed adjustment posts a compensating DEMO entry. The preparer and the reviewer must be two different named finance users.</p>
    <Paged state={paged} empty="No adjustments in this state.">
      {items => <ul className="grid gap-3">{items.map(item => <TaxAdjustmentCard key={item.id} item={item} onChanged={paged.reload} />)}</ul>}
    </Paged>
  </section>
}

function TaxAdjustmentCard({ item, onChanged }: { item: TaxAdjustment; onChanged: () => void }) {
  const [mode, setMode] = useState<'PREPARE' | 'APPROVE' | 'REJECT' | null>(null)
  const [prepare, setPrepare] = useState({ corrected: '', impact: 'NONE', evidence: '' })
  const [error, setError] = useState<string | null>(null)
  const [conflict, setConflict] = useState<string | null>(null)
  const [posted, setPosted] = useState<string | null>(null)
  const { run, busy, dialog } = useProtectedAction()
  const values = (value: unknown) => Object.entries((value ?? {}) as Record<string, unknown>).map(([key, entry]) => `${humanize(key)}: ${typeof entry === 'number' && key.endsWith('centavos') ? formatPesoCentavos(entry) : String(entry)}`).join('; ') || '—'
  async function decide(reason: string) {
    setError(null); setConflict(null)
    if (mode === 'PREPARE' && toCentavos(prepare.corrected) === null) { setError('Enter the corrected withheld amount in pesos, for example 1250.50.'); return }
    const result = await run('Verify to record this tax adjustment decision', () => mode === 'PREPARE'
      ? prepareTaxAdjustment(item.id, { correctedWithheldCentavos: toCentavos(prepare.corrected) ?? -1, reason, certificateImpact: prepare.impact as never, ...(prepare.evidence.trim() ? { evidenceReference: prepare.evidence.trim() } : {}) })
      : reviewTaxAdjustment(item.id, mode === 'APPROVE' ? 'APPROVED' : 'REJECTED', reason))
    if (result.ok) { setMode(null); onChanged(); return }
    if (isConflict(result.problem)) setConflict('This adjustment changed after you opened it. Reload the queue to review it.')
    else setError(problemText(result.problem))
  }
  async function post() {
    setError(null)
    const result = await run('Verify to post this adjustment', () => postTaxAdjustment(item.id))
    if (result.ok) { setPosted('Posted as a compensating DEMO entry. The Vendor Owner was notified.'); onChanged() } else setError(problemText(result.problem))
  }
  return <li className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-4">
    <div className="flex flex-wrap items-start justify-between gap-2"><div className="min-w-0"><p className="font-semibold">{humanize(item.kind)} · {item.orderReference ?? humanize(item.originalRecordType)}</p><p className="text-sm text-text-secondary">{item.vendorName ?? 'Vendor'} · {iso(item.periodStart)} – {iso(item.periodEnd)} · opened by {item.openedBy === 'SYSTEM' ? 'the system' : 'a user'}</p></div>
      <StatusBadge label={humanize(item.state)} tone={item.state === 'POSTED' ? 'success' : item.state === 'REJECTED' ? 'error' : 'warning'} /></div>
    <FactList facts={[{ label: 'Amount', value: formatPesoCentavos(item.amountCentavos) }, { label: 'Reason', value: item.reason }, { label: 'Before', value: values(item.beforeValues) }, { label: 'After', value: values(item.afterValues) },
      { label: 'Preparer', value: item.preparer ?? 'Not prepared' }, { label: 'Reviewer', value: item.reviewer ? `${item.reviewer}${item.reviewedAt ? ` · ${formatManilaDateTime(item.reviewedAt)}` : ''}` : 'Not reviewed' }]} />
    {item.separationNote && <p className="text-[13px] text-text-secondary">{item.separationNote}</p>}
    {posted && <p role="status" className="text-sm text-status-success">{posted}</p>}
    {error && !mode && <p role="alert" className="text-sm text-status-error">{error}</p>}
    {!mode && item.allowedActions.length > 0 && <div className="flex flex-wrap gap-2">
      {item.allowedActions.includes('PREPARE') && <Button onClick={() => setMode('PREPARE')}>Prepare correction</Button>}
      {item.allowedActions.includes('APPROVE') && <Button onClick={() => setMode('APPROVE')}>Approve (reviewer)</Button>}
      {item.allowedActions.includes('REJECT') && <Button variant="secondary" onClick={() => setMode('REJECT')}>Reject</Button>}
      {item.allowedActions.includes('POST') && <Button disabled={busy} onClick={() => void post()}>{busy ? 'Posting…' : 'Post compensating entry'}</Button>}
    </div>}
    {mode && <ReasonedDecisionForm title={mode === 'PREPARE' ? 'Prepare correction' : mode === 'APPROVE' ? 'Approve adjustment' : 'Reject adjustment'} target={`${humanize(item.kind)} for ${item.orderReference ?? item.originalRecordId}`} before={values(item.beforeValues)}
      after={mode === 'PREPARE' ? (toCentavos(prepare.corrected) !== null ? `Corrected withheld ${formatPesoCentavos(toCentavos(prepare.corrected))}` : 'Enter the corrected amount in pesos, up to two decimals') : mode === 'APPROVE' ? 'Approved; ready to post' : 'Rejected; no entry is posted'}
      submitLabel={mode === 'PREPARE' ? 'Submit for review' : mode === 'APPROVE' ? 'Approve' : 'Reject'} variant={mode === 'REJECT' ? 'danger' : 'primary'} busy={busy} error={error} conflict={conflict} minReason={10} maxReason={2000} onSubmit={reason => void decide(reason)}>
      {mode === 'PREPARE' && <div className="grid gap-3 sm:grid-cols-2">
        <label className={labelClass}>Corrected withheld amount (₱)<input className={control} inputMode="decimal" value={prepare.corrected} onChange={event => setPrepare({ ...prepare, corrected: event.target.value.replace(/[^0-9.]/g, '') })} /></label>
        <label className={labelClass}>Certificate impact<select className={control} value={prepare.impact} onChange={event => setPrepare({ ...prepare, impact: event.target.value })}><option value="NONE">None</option><option value="REISSUE_REQUIRED">Reissue required</option><option value="AMENDMENT_REQUIRED">Amendment required</option></select></label>
        <label className={`${labelClass} sm:col-span-2`}>Evidence reference (optional)<input className={control} maxLength={200} value={prepare.evidence} onChange={event => setPrepare({ ...prepare, evidence: event.target.value })} /></label>
      </div>}
      <Button variant="quiet" className="w-fit" onClick={() => { setMode(null); setError(null); setConflict(null) }}>Cancel</Button>
    </ReasonedDecisionForm>}
    {dialog}
  </li>
}
