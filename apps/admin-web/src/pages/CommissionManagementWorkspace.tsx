import { useState, type ReactNode } from 'react'
import { CommissionCreditReviewPanel } from './CommissionCreditReviewPanel'
import { ChevronDown, Clock3, Download, History, Pencil, Percent } from 'lucide-react'
import { MultiSelectFilter, ActiveFilters, RowActionMenu, AsyncSkeleton, Button, CalculationHelp, CommissionCreditsExplanation, CommissionEmailBadge, CommissionStatementBadge, DashboardPanel, DateFilter, DenseLedgerTable, DocumentExportButton, FilterTabs, PageHeader, PaymentAttemptBadge, dateFilterPreset, formatManilaDateTime, formatPesoCentavos, manilaToday, useCommissionPolicyClock, type DateFilterRange } from '@materyalph/web-ui'
import { commissionTermsUrl, financeKpis, listCommissionPolicies, listCommissionTransactions, listStatements, type CommissionPolicies, type CommissionPolicy, type Page } from '../lib/finance-api'
import { record, type JsonRecord } from '../lib/admin-format'
import { control, useLoad, usePaged } from '../lib/operations-hooks'
import { Paged } from '../components/OperationsKit'
import { ErrorState } from './PhaseThreeAdminPages'
import { CommissionDeliveryStatus, CommissionPolicyHistory, CommissionRateEditor } from './CommissionPolicyPanel'
import { CommissionStatementDrawer } from './CommissionStatementDrawer'
import './CommissionManagementWorkspace.css'

const billStatuses = [{ value: 'DRAFT', label: 'Preparing' }, { value: 'ISSUED', label: 'Issued' }, { value: 'PARTIALLY_PAID', label: 'Partially paid' }, { value: 'PAID', label: 'Settled' }, { value: 'VOIDED', label: 'Voided' }]
const paymentStatuses = [{ value: 'PAID', label: 'Paid' }, { value: 'PAID_PARTIALLY_REFUNDED', label: 'Partially refunded' }, { value: 'PAID_REFUND_PENDING', label: 'Refund pending' }, { value: 'PAID_REFUNDED', label: 'Refunded' }, { value: 'PAID_REFUND_FAILED', label: 'Refund needs review' }]
const moneyColumn = { className: 'text-right tabular-nums whitespace-nowrap', headerClassName: 'text-right' }
const apiBase = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'

function dueRelative(date: string): string {
  const days = Math.round((Date.parse(`${date}T00:00:00+08:00`) - Date.parse(`${manilaToday()}T00:00:00+08:00`)) / 86400_000)
  return !Number.isFinite(days) ? '' : days < 0 ? `${-days} ${days === -1 ? 'day' : 'days'} overdue` : days === 0 ? 'Due today' : `in ${days} ${days === 1 ? 'day' : 'days'}`
}

function previousPeriod(range: DateFilterRange) {
  if (!range.from || !range.to) return null
  const start = Date.parse(`${range.from}T00:00:00Z`)
  const days = Math.round((Date.parse(`${range.to}T00:00:00Z`) - start) / 86400_000) + 1
  return { from: new Date(start - days * 86400_000).toISOString().slice(0, 10), to: new Date(start - 86400_000).toISOString().slice(0, 10) }
}

export function CommissionManagementWorkspace({ navigation, overdue, onOverdueChange, initialPayments = false }: { navigation: ReactNode; overdue: boolean; onOverdueChange: (value: boolean) => void; initialPayments?: boolean }) {
  const [reviewingCredits, setReviewingCredits] = useState(false)
  const [range, setRange] = useState(() => dateFilterPreset(30))
  const [tab, setTab] = useState(initialPayments ? 'payments' : 'bills')
  const [search, setSearch] = useState('')
  const [billStates, setBillStates] = useState<string[]>([])
  const [paymentStates, setPaymentStates] = useState<string[]>([])
  const [editor, setEditor] = useState<{ data: CommissionPolicies; cancel: boolean } | null>(null)
  const [published, setPublished] = useState<CommissionPolicy | null>(null)
  const [selected, setSelected] = useState<string | null>(null)
  const policies = useLoad(() => listCommissionPolicies(), [])
  useCommissionPolicyClock(policies.data?.policies.next?.effectiveFrom, policies.retry)
  const kpis = useLoad(() => financeKpis(range.from, range.to), [range.from, range.to])
  const previous = previousPeriod(range)
  const prior = useLoad(() => previous ? financeKpis(previous.from, previous.to) : Promise.resolve(null), [previous?.from, previous?.to])
  const bills = usePaged(page => listStatements(page, undefined, overdue, range, search || undefined, billStates.length ? billStates.join(',') : undefined), [range.from, range.to, overdue, search, billStates.join(',')])
  const payments = usePaged(page => listCommissionTransactions(page, range, undefined, search || undefined, paymentStates.length ? paymentStates.join(',') : undefined), [range.from, range.to, search, paymentStates.join(',')])
  const data = policies.data?.policies
  const current = data?.current
  const next = data?.next
  const statuses = tab === 'payments' ? paymentStates : billStates
  const setStatuses = tab === 'payments' ? setPaymentStates : setBillStates
  const choices = tab === 'payments' ? paymentStatuses : billStatuses
  const metric = (key: string) => kpis.data?.finance.find(item => item.key === key)?.valueCentavos
  function delta(key: string) {
    const now = metric(key)
    const before = prior.data?.finance.find(item => item.key === key)?.valueCentavos
    if (now === undefined || before === undefined || before === 0) return 'No comparison available'
    const percent = (now - before) * 100 / Math.abs(before)
    return `${percent > 0 ? '+' : ''}${percent.toFixed(1)}% vs previous period`
  }
  function clear() { setSearch(''); setStatuses([]); onOverdueChange(false) }
  const exportFilters = { ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}), ...(search ? { search } : {}), ...(tab === 'bills' ? { view: 'STATEMENTS', ...(billStates.length ? { states: billStates.join(',') } : {}), ...(overdue ? { overdue: true } : {}) } : paymentStates.length ? { statuses: paymentStates.join(',') } : {}) }
  const total = (bills.data as Page<JsonRecord> | null)?.totals
  function saved(policy: CommissionPolicy) { setPublished(policy); policies.retry() }
  return <div className="mp-commission-workspace grid min-w-0 gap-4">
    <PageHeader compact eyebrow="Finance" title="Commission management" description="Manage commission policy, Vendor billing and collection exceptions." actions={<div className="flex flex-wrap items-center gap-2"><DateFilter title="Commission reporting period" value={range} onChange={setRange} /><details className="mp-commission-export"><summary className="inline-flex min-h-11 cursor-pointer items-center gap-2 rounded-control border border-border-default bg-surface-primary px-3 text-sm font-semibold"><Download size={16} aria-hidden="true" />Export<ChevronDown size={14} aria-hidden="true" /></summary><div className="mp-commission-export__menu">{tab === 'history' ? <p className="p-2 text-sm">Select Vendor bills or Payments to export the selected period.</p> : data?.canExport ? (['CSV', 'PDF'] as const).map(format => <DocumentExportButton key={format} basePath={apiBase} audience="admin" types={['TRANSACTION_HISTORY']} title={tab === 'bills' ? 'Vendor commission bills' : 'Vendor commission payments'} format={format} filters={exportFilters} />) : <p className="p-2 text-sm">Finance export permission is required.</p>}</div></details></div>} />
    {navigation}
    <div className="mp-commission-demo" role="note"><strong>TEST/DEMO billing</strong><span>No automatic Vendor debit, real funds or BIR filing.</span></div>
    <section className="mp-commission-kpis" aria-label="Commission reporting summary">
      <div className="mp-commission-rate-kpi"><span className="mp-commission-kpi-label"><Percent size={15} aria-hidden="true" />Current rate</span><strong className="mp-commission-kpi-value">{current?.rateLabel ?? '—'}</strong><p>Effective since {current?.effectiveFrom ? new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeZone: 'Asia/Manila' }).format(new Date(current.effectiveFrom)) : 'loading policy'}</p><p>{next ? `${next.rateLabel} effective ${formatManilaDateTime(next.effectiveFrom)}` : 'No change scheduled'}</p><div className="mt-3 flex flex-wrap gap-2">{data?.canManage && <Button onClick={() => setEditor({ data, cancel: false })}><Pencil size={14} aria-hidden="true" />Edit rate</Button>}<Button variant="secondary" onClick={() => setTab('history')}><History size={14} aria-hidden="true" />View history</Button></div></div>
      {([{ key: 'billed', label: 'Billed this period' }, { key: 'net_collected', label: 'Collected (net)' }, { key: 'receivables', label: 'Outstanding' }, { key: 'overdue', label: 'Overdue' }, { key: 'fee_credits', label: 'Credits applied' }]).map(item => <div key={item.key} className={`mp-commission-kpi${item.key === 'overdue' && (metric(item.key) ?? 0) > 0 ? ' mp-commission-kpi--overdue' : ''}`}><span className="mp-commission-kpi-label">{item.label}</span>{item.key === 'overdue' ? <button aria-label="Show overdue Vendor bills" className="mp-commission-kpi-value min-h-11 text-left underline-offset-4 hover:underline" onClick={() => { setTab('bills'); onOverdueChange(true); setBillStates([]) }}>{metric(item.key) === undefined ? '—' : formatPesoCentavos(metric(item.key)!)}</button> : <strong className="mp-commission-kpi-value">{metric(item.key) === undefined ? '—' : formatPesoCentavos(metric(item.key)!)}</strong>}<p>{delta(item.key)}</p></div>)}
    </section>
    {kpis.error && <ErrorState message={kpis.error} onRetry={kpis.retry} />}{policies.error && <ErrorState message={policies.error} onRetry={policies.retry} />}
    {published && <DashboardPanel density="compact" title="Commission policy published" description="Existing transactions keep their original rate."><CommissionDeliveryStatus policy={data?.versions.find(row => row.id === published.id) ?? published} canManage={data?.canManage ?? false} onRefresh={policies.retry} /><Button variant="secondary" onClick={policies.retry}>Refresh delivery status</Button></DashboardPanel>}
    <div className="mp-commission-policy-row">
      <DashboardPanel density="compact" title="Commission terms" description="The current policy for new commercial transactions.">
        <div className="flex flex-wrap gap-2">{['After discounts', 'Excl. materials VAT', 'Billed monthly'].map(chip => <span key={chip} className="mp-commission-basis-chip">{chip}</span>)}</div>
        <dl className="mp-commission-term-facts"><div><dt>Published terms</dt><dd>Version {current?.termsVersion ?? '—'} · Policy v{current?.version ?? '—'}</dd></div><div><dt>Due date</dt><dd>Later of the 15th or 12 days after issuance, end of day Asia/Manila.</dd></div><div><dt>Automatic issuance</dt><dd>1st of each month, 00:05 Asia/Manila. Recovery every 5 minutes.</dd></div></dl>
        <a className="inline-flex min-h-11 items-center text-sm font-semibold text-action-primary underline" href={commissionTermsUrl()} target="_blank" rel="noreferrer">View Vendor-facing terms<span className="sr-only"> (opens in a new tab)</span></a>
        {next && <div className="mp-commission-upcoming"><p className="flex items-center gap-2 text-sm font-semibold"><Clock3 size={16} aria-hidden="true" />Upcoming change · {next.rateLabel}</p><p className="text-xs">Effective {formatManilaDateTime(next.effectiveFrom)} · in {Math.max(0, Math.ceil((new Date(next.effectiveFrom).valueOf() - Date.now()) / 86400_000))} days</p>{data?.canManage && <div className="flex gap-2"><Button variant="secondary" onClick={() => setEditor({ data, cancel: false })}>Edit scheduled change</Button><Button variant="quiet" onClick={() => setEditor({ data, cancel: true })}>Cancel change</Button></div>}</div>}
      </DashboardPanel>
      <DashboardPanel density="compact" title="Commission credits" description="Recorded reductions to earned commission." action={<CalculationHelp title="Commission credits" label="How credits work"><CommissionCreditsExplanation /></CalculationHelp>}>
        <dl className="mp-commission-credit-facts"><div><dt>Applied this period</dt><dd>{metric('fee_credits') === undefined ? '—' : formatPesoCentavos(metric('fee_credits')!)}</dd></div><div><dt>Pending approvals <span className="text-xs">(all periods)</span></dt><dd>{kpis.data?.counts.pending_commission_credits ?? '—'}</dd></div><div><dt>Refundable on paid bills <span className="text-xs">(current)</span></dt><dd>{metric('refundable_credits') === undefined ? '—' : formatPesoCentavos(metric('refundable_credits')!)}</dd></div></dl>
        <Button variant="quiet" className="w-fit" onClick={() => setReviewingCredits(true)}>Review commission credits</Button>
      </DashboardPanel>
    </div>
    <section className="mp-card min-w-0" aria-label="Commission records">
      <div className="px-4 pt-2"><FilterTabs label="Commission records" appearance="tabs" chips={[{ value: 'bills', label: 'Vendor bills' }, { value: 'payments', label: 'Payments' }, { value: 'history', label: 'Rate history & terms' }]} value={tab} onChange={setTab} /></div>
      {tab !== 'history' && <div className="mp-commission-filterbar"><div className="flex min-w-0 flex-wrap items-end gap-3"><label className="grid min-w-[180px] flex-1 gap-1.5 text-xs font-semibold">Search Vendor or statement<input type="search" className={control} placeholder="Vendor name or statement reference" value={search} maxLength={120} onChange={event => setSearch(event.target.value)} /></label><MultiSelectFilter legend={tab === 'payments' ? 'Payment statuses' : 'Statement statuses'} options={choices.filter(choice => !overdue || tab === 'payments' || ['ISSUED', 'PARTIALLY_PAID'].includes(choice.value))} value={statuses} onChange={setStatuses} />{tab === 'bills' && <label className="flex min-h-11 items-center gap-2 text-sm"><input type="checkbox" checked={overdue} onChange={event => { setBillStates([]); onOverdueChange(event.target.checked) }} />Overdue only</label>}</div>
        <ActiveFilters filters={[
          ...(search ? [{ key: 'search', label: `Search: ${search}`, onRemove: () => setSearch('') }] : []),
          ...statuses.map(status => ({ key: status, label: choices.find(choice => choice.value === status)?.label ?? status, onRemove: () => setStatuses(statuses.filter(value => value !== status)) })),
          ...(tab === 'bills' && overdue ? [{ key: 'overdue', label: 'Overdue only', onRemove: () => onOverdueChange(false) }] : []),
        ]} onClear={clear} />
      </div>}
      <div className="min-w-0 p-4">
        {tab === 'bills' && <>
          <p className="mb-3 text-xs text-text-secondary">Statement issue dates · {range.from} – {range.to} · Asia/Manila. Bills are issued automatically; no routine Admin approval.</p>
          <Paged embedded loading={<AsyncSkeleton label="Loading Vendor bills…" />} state={bills} empty={overdue ? 'No overdue commission balances match these filters.' : 'No bills match these filters. Statements are issued automatically for Vendors with billable completed orders.'}>{items => <DenseLedgerTable caption="Commission statements" compact rows={items} rowKey={row => String(row.id)} onRowClick={row => setSelected(String(row.id))} columns={[
            { key: 'vendor', header: 'Vendor / statement', cell: row => <div className="grid gap-1"><button className="min-h-11 text-left text-sm font-semibold text-action-primary hover:underline" onClick={() => setSelected(String(row.id))}>{String(row.vendor_name)}</button><span className="text-xs text-text-secondary">{String(row.reference)}</span></div> },
            { key: 'period', header: 'Period', cell: row => <span className="whitespace-nowrap text-xs">{String(row.period_start)}<br />{String(row.period_end)}</span> },
            { key: 'before', header: 'Commission before credits', ...moneyColumn, cell: row => formatPesoCentavos(Number(row.charges_centavos)) },
            { key: 'credits', header: 'Credits', ...moneyColumn, cell: row => formatPesoCentavos(Number(row.credits_centavos)) },
            { key: 'after', header: 'Commission after credits', ...moneyColumn, cell: row => <strong>{formatPesoCentavos(Math.max(0, Number(row.charges_centavos) - Number(row.credits_centavos)))}</strong> },
            { key: 'due', header: 'Amount due', ...moneyColumn, cell: row => Number(row.outstanding_centavos) === 0 ? <span className="text-xs">Paid in full</span> : <strong>{formatPesoCentavos(Number(row.outstanding_centavos))}</strong> },
            { key: 'date', header: 'Due date', cell: row => <div className="grid gap-1 whitespace-nowrap text-xs"><span>{row.state === 'DRAFT' ? 'Set on issue' : String(row.due_on)}</span>{['ISSUED', 'PARTIALLY_PAID'].includes(String(row.state)) && <span className={row.overdue ? 'text-red-700' : 'text-text-secondary'}>{dueRelative(String(row.due_on))}</span>}</div> },
            { key: 'status', header: 'Status', cell: row => <CommissionStatementBadge state={String(row.state)} overdue={Boolean(row.overdue)} /> },
            { key: 'email', header: 'Email', cell: row => { const email = record(row.email); return <CommissionEmailBadge state={Number(email.total ?? 0) === 0 ? 'NONE' : Number(email.failed ?? 0) > 0 ? 'FAILED' : Number(email.blocked ?? 0) > 0 ? 'BLOCKED' : Number(email.queued ?? 0) > 0 ? 'QUEUED' : 'SENT'} /> } },
            { key: 'actions', header: <span className="sr-only">Actions</span>, cell: row => <RowActionMenu label={`Actions for statement ${String(row.reference)}`}><Button variant="quiet" onClick={() => setSelected(String(row.id))}>View details</Button></RowActionMenu> },
          ]} footer={total && <tr><th colSpan={2} scope="row" className="px-3 py-3 text-left text-xs">Totals · current filter</th>{['charges_centavos', 'credits_centavos', 'after_credits_centavos', 'outstanding_centavos'].map(key => <td key={key} className="px-3 py-3 text-right text-sm font-semibold tabular-nums">{formatPesoCentavos(total[key] ?? 0)}</td>)}<td colSpan={4} /></tr>} />}</Paged>
        </>}
        {tab === 'payments' && <>
          <p className="mb-3 text-xs text-text-secondary">Verified commission payment dates · {range.from} – {range.to} · Asia/Manila. Successful platform-fee payments, less confirmed refunds.</p>
          <Paged embedded loading={<AsyncSkeleton label="Loading commission payments…" />} state={payments} empty="No successful commission payments match this period and filters.">{items => <DenseLedgerTable caption="Vendor commission payments" compact rows={items} rowKey={row => String(row.id)} columns={[
            { key: 'vendor', header: 'Vendor / statement', cell: row => <div className="grid gap-1"><strong>{String(row.vendor_name)}</strong><span className="text-xs text-text-secondary">{String(row.reference)}</span></div> },
            { key: 'state', header: 'Status', cell: row => <PaymentAttemptBadge status={String(row.status)} refundStatus={Number(row.refunded_centavos ?? 0) >= Number(row.total_centavos) ? 'REFUNDED' : Number(row.refund_pending_count ?? 0) > 0 ? 'REFUND_PENDING' : Number(row.refund_failed_count ?? 0) > 0 ? 'REFUND_FAILED' : Number(row.refunded_centavos ?? 0) > 0 ? 'PARTIALLY_REFUNDED' : undefined} /> },
            { key: 'channel', header: 'Channel / provider reference', cell: row => <div className="grid gap-1"><span>{String(row.channel_name ?? row.channel_code ?? '—')} <span className="mp-commission-test-chip">TEST</span></span><span className="text-xs text-text-secondary">{String(row.provider_session_reference ?? 'Reference unavailable')} · {row.evidence_origin === 'SIMULATED' ? 'Simulated' : row.evidence_origin === 'XENDIT_TEST' ? 'Xendit TEST' : 'Evidence unavailable'}</span></div> },
            { key: 'paid', header: 'Paid date', cell: row => <span className="text-xs">{formatManilaDateTime(row.paid_at as string | null)}</span> },
            { key: 'gross', header: 'Gross', ...moneyColumn, cell: row => formatPesoCentavos(Number(row.total_centavos)) },
            { key: 'refunded', header: 'Refunded', ...moneyColumn, cell: row => formatPesoCentavos(Number(row.refunded_centavos ?? 0)) },
            { key: 'net', header: 'Net collected', ...moneyColumn, cell: row => <strong>{formatPesoCentavos(Number(row.net_collected_centavos ?? 0))}</strong> },
          ]} />}</Paged>
        </>}
        {tab === 'history' && <CommissionPolicyHistory canManage={data?.canManage ?? false} />}
      </div>
    </section>
    {reviewingCredits && <CommissionCreditReviewPanel onClose={() => setReviewingCredits(false)} onChanged={() => { kpis.retry(); bills.reload() }} />}
    {editor && <CommissionRateEditor data={editor.data} cancel={editor.cancel} onClose={() => setEditor(null)} onSaved={saved} />}
    {selected && <CommissionStatementDrawer id={selected} onClose={() => setSelected(null)} onChanged={bills.reload} />}
    {!data && !policies.error && <span className="sr-only" role="status">Loading commission policy…</span>}
  </div>
}
