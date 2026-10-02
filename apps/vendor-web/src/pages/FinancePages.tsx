import { useCallback, useEffect, useState, type FormEvent, type ReactNode } from 'react'
import { Link, useParams } from 'react-router-dom'
import { ArrowLeft, Download, ExternalLink, Landmark, ReceiptText, RefreshCw, ShieldAlert, Wallet } from 'lucide-react'
import {
  Button, DemoLabel, FilterChips, FinanceSection, PaymentAttemptBadge, PaymentChannelList, StatusBadge, StatusMessage, SummaryTiles, ThresholdPanel,
  formatManilaDateTime, formatPesoCentavos,
} from '@materyalph/web-ui'
import {
  channelRows, exportTransactions, getEarnings, getFinanceOverview, getStatement, listTransactions, payStatement, readableFinanceError, refreshFeePayment, section,
  thresholdData, updatePhysicalPayments, type FeeStatementDetail, type FinanceRow, type FinanceTab, type PaymentAttempt, type VendorEarnings, type VendorFinanceOverview,
} from '../lib/finance-api'
import { pesoInputToCentavos } from '../lib/orders-api'
import { newIdempotencyKey } from '../lib/onboarding-api'
import { storeName } from '../lib/catalog-access'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'

type Snapshot = NonNullable<ReturnType<typeof useOnboardingSnapshot>['snapshot']>

/**
 * Owner-only finance gate. The server enforces it on every request (FINANCE_OWNER_ONLY); this gate only avoids
 * showing a dead page. A Store Manager's operational order access never reaches these modules.
 */
function FinanceGate({ activeHref, permission, children }: { activeHref: string; permission: 'portal.wallet' | 'portal.earnings'; children: (snapshot: Snapshot) => ReactNode }) {
  const { snapshot, loading, error, refresh } = useOnboardingSnapshot()
  if (loading) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><LoadingState label="Loading finance…" /></VendorShell>
  if (error || !snapshot) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><ErrorState message={error ?? 'Finance is unavailable.'} onRetry={() => void refresh()} /></VendorShell>
  return <VendorShell activeHref={activeHref} accountLabel={storeName(snapshot)} navigationData={snapshot}>
    {snapshot.permissions.includes(permission) ? children(snapshot) : <OwnerOnly />}
  </VendorShell>
}

function OwnerOnly() {
  return <div className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-6" role="alert">
    <div className="flex items-start gap-3"><ShieldAlert className="mt-0.5 shrink-0 text-action-primary" size={20} aria-hidden="true" />
      <div><h1 className="text-xl font-semibold">Store-wide finance is Owner-only</h1>
        <p className="mt-1 text-sm text-text-secondary">Earnings, Transaction History, withholding and commission statements and finance exports are available to the Vendor Owner. Order-specific payment status stays visible on each order you can work on.</p></div></div>
    <Link className="text-sm font-semibold text-action-primary underline" to="/orders">Go to Orders</Link>
  </div>
}

function FinanceTabs({ current }: { current: 'overview' | 'transactions' }) {
  const item = (to: string, label: string, active: boolean) => <Link to={to} aria-current={active ? 'page' : undefined}
    className={`inline-flex min-h-11 items-center border-b-2 px-3 text-sm font-semibold ${active ? 'border-action-primary text-text-strong' : 'border-transparent text-text-secondary hover:text-text-strong'}`}>{label}</Link>
  return <nav aria-label="Finance sections" className="flex flex-wrap gap-1 border-b border-border-default">{item('/finance', 'Finance overview', current === 'overview')}{item('/finance/transactions', 'Transaction History', current === 'transactions')}</nav>
}

function useLoader<T>(load: () => Promise<T>) {
  const [data, setData] = useState<T | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const reload = useCallback(() => setAttempt(value => value + 1), [])
  useEffect(() => {
    let active = true
    setError(null)
    load().then(value => { if (active) setData(value) }).catch(async cause => { const text = await readableFinanceError(cause); if (active) setError(text) })
    return () => { active = false }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- the loader identity is stable per page; attempt drives reloads.
  }, [attempt])
  return { data, setData, error, reload }
}

// ── Finance overview ────────────────────────────────────────────────────────────────────────────

export function VendorFinancePage() {
  return <FinanceGate activeHref="/finance" permission="portal.wallet">{() => <FinanceOverview />}</FinanceGate>
}

function FinanceOverview() {
  const { data, setData, error, reload } = useLoader(getFinanceOverview)
  if (error) return <div className="grid gap-4"><ErrorState message={error} onRetry={reload} /></div>
  if (!data) return <LoadingState label="Loading finance overview…" />
  const connection = section(data.xenditConnection)
  const tax = section(data.taxProfile)
  const declaration = section(tax.declaration)
  const arrangement = section(data.withholdingArrangement)
  const terms = section(data.commissionTerms)
  const online = section(data.onlineChannels)
  const physical = section(data.physicalPayments)
  const refund = section(data.refundCapability)
  const statements = section(data.statements)
  const threshold = thresholdData(data.threshold)
  const mandatory = data.notices.filter(notice => notice.mandatory)

  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Finance" title="Finance overview" description="Your Xendit TEST connection, tax profile, withholding position, commission terms and payment options. MateryalPH holds no wallet or balance for your store." actions={<DemoLabel />} />
    <FinanceTabs current="overview" />
    <StatusMessage tone="info">{data.demoLabel}</StatusMessage>
    {mandatory.length > 0 && <section aria-labelledby="notices-heading" className="grid gap-2">
      <h2 id="notices-heading" className="text-base font-semibold">Required finance notices</h2>
      <ul className="grid gap-2">{mandatory.slice(0, 3).map(notice => <li key={notice.id} className="rounded-control border border-red-300 bg-red-50 p-3 text-sm text-red-900"><p className="font-semibold">{notice.title}</p><p className="mt-1">{notice.body}</p><p className="mt-1 text-xs">{formatManilaDateTime(notice.createdAt)} · Cannot be turned off</p></li>)}</ul>
    </section>}
    <div className="grid min-w-0 gap-6 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-6">
      <FinanceSection id="xendit" title="Xendit connection" description={String(connection.note ?? '')}
        badge={<StatusBadge label={String(connection.label ?? 'Not connected')} tone={connection.status === 'CONNECTED_TEST' ? 'success' : 'warning'} />}>
        <dl className="grid gap-x-6 gap-y-3 text-sm sm:grid-cols-2 lg:grid-cols-4">
          <Fact label="Environment" value="TEST" /><Fact label="Account contract" value={String(connection.account_contract ?? '—')} />
          <Fact label="Payment API" value={String(connection.payment_api ?? '—')} /><Fact label="Last reconciled" value={formatManilaDateTime(connection.last_reconciled_at as string | null)} />
        </dl>
      </FinanceSection>
      <FinanceSection id="tax" title="Vendor Tax Profile summary" description="Collected once in Store Verification. Corrections create a new version and never rewrite posted records.">
        {tax.available ? <dl className="grid gap-x-6 gap-y-3 text-sm sm:grid-cols-2 lg:grid-cols-4">
          <Fact label="TIN" value={String(tax.tin_masked ?? 'Not provided')} /><Fact label="VAT status" value={String(tax.vat_category ?? '—').replaceAll('_', ' ')} />
          <Fact label="Taxable year starts" value={monthName(Number(tax.fiscal_year_start_month ?? 1))} />
          <Fact label="Relief declaration" value={`${String(declaration.status ?? 'NOT_SUBMITTED').replaceAll('_', ' ').toLowerCase()}${declaration.taxable_year ? ` · ${String(declaration.taxable_year)}` : ''}`} />
        </dl> : <StatusMessage tone="info">Your Vendor Tax Profile has no validated taxpayer identity yet. Complete it in Store Verification.</StatusMessage>}
        {typeof declaration.note === 'string' && <p className="text-sm text-text-secondary">{declaration.note}</p>}
      </FinanceSection>
      <FinanceSection id="arrangement" title="Withholding arrangement" badge={<StatusBadge label={String(arrangement.production_assignment_label ?? 'Production assignment unconfirmed')} tone="warning" />}>
        <dl className="grid gap-x-6 gap-y-3 text-sm sm:grid-cols-2"><Fact label="Scenario" value={String(arrangement.label ?? '—')} /><Fact label="Rate" value={String(arrangement.rate_label ?? '—')} /></dl>
      </FinanceSection>
      <div className="border-t border-border-default pt-6">{threshold ? <ThresholdPanel data={threshold} /> : <StatusMessage tone="info">The threshold panel appears once your tax profile is complete.</StatusMessage>}</div>
      <FinanceSection id="terms" title="Commission Terms" description={String(terms.note ?? '')} badge={<StatusBadge label={terms.accepted ? `Accepted · version ${String(terms.version ?? '')}` : 'Not accepted'} tone={terms.accepted ? 'success' : 'warning'} />}>
        <dl className="grid gap-x-6 gap-y-3 text-sm sm:grid-cols-2"><Fact label="Rate" value={String(terms.rate_label ?? '')} /><Fact label="Accepted" value={formatManilaDateTime(terms.accepted_at as string | null)} /></dl>
        {Number(statements.outstanding_centavos ?? 0) > 0 && <p className="text-sm">Outstanding statements: <strong className="tabular-nums">{formatPesoCentavos(Number(statements.outstanding_centavos))}</strong>{statements.next_due_on ? ` · next due ${String(statements.next_due_on)}` : ''}. <Link className="font-semibold text-action-primary underline" to="/finance/transactions?tab=STATEMENTS">View statements</Link></p>}
      </FinanceSection>
      <FinanceSection id="channels" title="Online payment channels" description={String(online.fee_note ?? '')}>
        <PaymentChannelList caption="Configured online channels" channels={channelRows(online.channels)} />
      </FinanceSection>
      <PhysicalPaymentsSection settings={physical} onSaved={saved => setData({ ...data, physicalPayments: { ...physical, cod_enabled: saved.codEnabled, in_store_enabled: saved.inStoreEnabled, lock_version: saved.lockVersion } } as VendorFinanceOverview)} />
      <FinanceSection id="refunds" title="Refund capability" description={String(refund.note ?? '')} badge={<StatusBadge label={refund.status === 'AVAILABLE_TEST' ? 'Available — TEST' : 'Unavailable'} tone={refund.status === 'AVAILABLE_TEST' ? 'success' : 'warning'} />}>
        <p className="text-sm">Refund-capable channels: {(Array.isArray(refund.refund_channels) && refund.refund_channels.length > 0) ? (refund.refund_channels as string[]).join(', ') : 'none'}</p>
      </FinanceSection>
    </div>
  </div>
}

function PhysicalPaymentsSection({ settings, onSaved }: { settings: Record<string, unknown>; onSaved: (saved: { codEnabled: boolean; inStoreEnabled: boolean; lockVersion: number }) => void }) {
  const [cod, setCod] = useState(Boolean(settings.cod_enabled))
  const [inStore, setInStore] = useState(Boolean(settings.in_store_enabled))
  const [busy, setBusy] = useState(false)
  const [message, setMessage] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const changed = cod !== Boolean(settings.cod_enabled) || inStore !== Boolean(settings.in_store_enabled)
  async function save(event: FormEvent) {
    event.preventDefault()
    setBusy(true); setMessage(null)
    try {
      const saved = await updatePhysicalPayments(Number(settings.lock_version ?? 0), cod, inStore)
      onSaved(saved)
      setMessage({ tone: 'success', text: 'Saved. The change applies to new orders only; accepted orders keep their payment method.' })
    } catch (cause) { setMessage({ tone: 'error', text: await readableFinanceError(cause) }) }
    finally { setBusy(false) }
  }
  const toggle = (id: string, label: string, hint: string, checked: boolean, set: (value: boolean) => void) => <label htmlFor={id} className="flex min-h-11 items-start gap-3 text-sm">
    <input id={id} type="checkbox" className="mt-0.5 h-5 w-5 accent-action-primary" checked={checked} disabled={busy} onChange={event => set(event.target.checked)} />
    <span><span className="font-semibold">{label}</span><span className="block text-text-secondary">{hint}</span></span>
  </label>
  return <FinanceSection id="physical" title="Physical payments" description="Buyers pay you directly. You record what you receive with evidence; a record never confirms an online payment.">
    <form className="grid gap-3" onSubmit={event => void save(event)}>
      {toggle('cod-enabled', 'Accept Cash on Delivery', String(settings.cod_note ?? 'Site Delivery orders only.'), cod, setCod)}
      {toggle('in-store-enabled', 'Accept In-Store Payment', String(settings.in_store_note ?? 'Self-Pickup orders only.'), inStore, setInStore)}
      {message && <StatusMessage tone={message.tone}>{message.text}</StatusMessage>}
      <div><Button type="submit" variant="secondary" disabled={busy || !changed}>{busy ? 'Saving…' : 'Save physical payment options'}</Button></div>
    </form>
  </FinanceSection>
}

// ── Transaction History ─────────────────────────────────────────────────────────────────────────

const TABS: { value: FinanceTab; label: string }[] = [
  { value: 'PAYMENTS', label: 'Payments' }, { value: 'PHYSICAL', label: 'Physical receipts' }, { value: 'REMITTANCES', label: 'Remittances and CWT' },
  { value: 'STATEMENTS', label: 'Commission statements' }, { value: 'REFUNDS', label: 'Refunds and adjustments' }, { value: 'TAX_DOCUMENTS', label: 'Tax documents' },
]
const EMPTY: Record<FinanceTab, string> = {
  PAYMENTS: 'No online payments yet. Verified Buyer payments appear here.', PHYSICAL: 'No Cash on Delivery or In-Store records yet.',
  REMITTANCES: 'No simulated remittance assessments yet. They appear after verified collections.', STATEMENTS: 'No issued commission statements yet. Statements are drafted on the first of each month.',
  REFUNDS: 'No refunds or adjustments.', TAX_DOCUMENTS: 'No tax documents. Sample certificates are watermarked and never official.',
}

export function VendorTransactionHistoryPage() {
  return <FinanceGate activeHref="/finance" permission="portal.wallet">{() => <TransactionHistory />}</FinanceGate>
}

function TransactionHistory() {
  const initial = (new URLSearchParams(window.location.search).get('tab') ?? 'PAYMENTS') as FinanceTab
  const [tab, setTab] = useState<FinanceTab>(TABS.some(item => item.value === initial) ? initial : 'PAYMENTS')
  const [page, setPage] = useState(1)
  const [rows, setRows] = useState<FinanceRow[] | null>(null)
  const [hasMore, setHasMore] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [exporting, setExporting] = useState(false)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setRows(null); setError(null)
    listTransactions(tab, page).then(result => { if (active) { setRows(result.items); setHasMore(result.hasMore) } }).catch(async cause => { const text = await readableFinanceError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [tab, page, attempt])
  async function download() {
    setExporting(true)
    try {
      const blob = await exportTransactions(tab)
      const url = URL.createObjectURL(blob)
      const link = Object.assign(document.createElement('a'), { href: url, download: `materyalph-${tab.toLowerCase()}-test.csv` })
      link.click(); URL.revokeObjectURL(url)
    } catch (cause) { setError(await readableFinanceError(cause)) }
    finally { setExporting(false) }
  }
  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Finance" title="Transaction History" description="A read-only record of payments, physical receipts, simulated remittances, statements, refunds and tax documents. It shows no balance and moves no money."
      actions={<><DemoLabel /><Button variant="secondary" disabled={exporting || !rows || rows.length === 0} onClick={() => void download()}><Download size={16} aria-hidden="true" />{exporting ? 'Preparing…' : 'Export CSV'}</Button></>} />
    <FinanceTabs current="transactions" />
    <FilterChips label="Transaction type" chips={TABS} value={tab} onChange={value => { setTab(value as FinanceTab); setPage(1) }} />
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
      : rows === null ? <LoadingState label="Loading records…" />
        : rows.length === 0 ? <div className="grid place-items-center gap-2 rounded-surface border border-dashed border-border-default bg-surface-primary p-10 text-center"><Wallet className="text-action-primary" size={28} aria-hidden="true" /><p className="max-w-md text-sm text-text-secondary">{EMPTY[tab]}</p></div>
          : <TransactionTable tab={tab} rows={rows} />}
    {(page > 1 || hasMore) && <div className="flex items-center justify-between gap-3"><Button variant="secondary" disabled={page === 1} onClick={() => setPage(page - 1)}>Previous</Button><span className="text-sm text-text-secondary">Page {page}</span><Button variant="secondary" disabled={!hasMore} onClick={() => setPage(page + 1)}>Next</Button></div>}
    <p className="text-xs text-text-secondary">Internal Operational Report — Not a Tax Invoice. For balances and withdrawals use your authorized Xendit dashboard.</p>
  </div>
}

type Column = { header: string; cell: (row: FinanceRow) => ReactNode; numeric?: boolean }
const money = (key: string): Column['cell'] => row => <span className="tabular-nums">{row[key] === null || row[key] === undefined ? '—' : formatPesoCentavos(Number(row[key]))}</span>
const text = (key: string): Column['cell'] => row => String(row[key] ?? '—').replaceAll('_', ' ')

const COLUMNS: Record<FinanceTab, Column[]> = {
  PAYMENTS: [{ header: 'Order', cell: text('reference') }, { header: 'Purpose', cell: text('purpose') }, { header: 'Status', cell: row => <PaymentAttemptBadge status={String(row.status)} /> },
    { header: 'Gross', cell: money('gross_centavos'), numeric: true }, { header: 'Buyer fee', cell: money('buyer_processing_fee_centavos'), numeric: true }, { header: 'Origin', cell: text('evidence_origin') }, { header: 'Date', cell: row => formatManilaDateTime(row.at as string) }],
  PHYSICAL: [{ header: 'Order', cell: text('reference') }, { header: 'Record', cell: text('kind') }, { header: 'Amount', cell: money('amount_centavos'), numeric: true }, { header: 'Remaining', cell: money('remaining_centavos'), numeric: true },
    { header: 'Source', cell: text('evidence_origin') }, { header: 'Buyer acknowledged', cell: row => row.buyer_acknowledged ? 'Yes' : 'No' }, { header: 'Date', cell: row => formatManilaDateTime(row.at as string) }],
  REMITTANCES: [{ header: 'Order', cell: text('reference') }, { header: 'Collected (C)', cell: money('collected_centavos'), numeric: true }, { header: 'Charge (P)', cell: money('provider_charge_centavos'), numeric: true },
    { header: 'Base (G)', cell: money('gross_basis_centavos'), numeric: true }, { header: 'CWT (W)', cell: money('withheld_centavos'), numeric: true }, { header: 'Expected cash', cell: money('expected_cash_centavos'), numeric: true },
    { header: 'Threshold status', cell: text('threshold_status_after') }, { header: 'Evidence', cell: row => `${String(row.deduction_evidence_state ?? '').replaceAll('_', ' ')} · DEMO` }],
  STATEMENTS: [{ header: 'Statement', cell: row => <Link className="font-semibold text-action-primary underline" to={`/finance/statements/${String(row.id)}`}>{String(row.reference)}</Link> },
    { header: 'Period', cell: row => `${String(row.period_start)} – ${String(row.period_end)}` }, { header: 'State', cell: row => `${String(row.state).replaceAll('_', ' ')}${row.overdue ? ' · overdue' : ''}` },
    { header: 'Charges', cell: money('charges_centavos'), numeric: true }, { header: 'Credits', cell: money('credits_centavos'), numeric: true }, { header: 'Outstanding', cell: money('outstanding_centavos'), numeric: true }, { header: 'Due', cell: text('due_on') }],
  REFUNDS: [{ header: 'Order', cell: text('reference') }, { header: 'Trigger', cell: text('trigger') }, { header: 'Amount', cell: money('amount_centavos'), numeric: true }, { header: 'State', cell: text('state') }, { header: 'Date', cell: row => formatManilaDateTime(row.at as string) }],
  TAX_DOCUMENTS: [{ header: 'Type', cell: text('certificate_type') }, { header: 'Issuer', cell: text('issuer') }, { header: 'Period', cell: row => `${String(row.period_start)} – ${String(row.period_end)}` }, { header: 'Tax', cell: money('tax_centavos'), numeric: true }, { header: 'Verification', cell: text('verification_state') }],
}

function TransactionTable({ tab, rows }: { tab: FinanceTab; rows: FinanceRow[] }) {
  const columns = COLUMNS[tab]
  return <div className="min-w-0 overflow-x-auto rounded-surface border border-border-default bg-surface-primary">
    <table className="w-full min-w-[44rem] border-collapse text-left text-sm">
      <caption className="sr-only">{TABS.find(item => item.value === tab)?.label}</caption>
      <thead className="bg-surface-canvas text-xs uppercase tracking-wide text-text-secondary"><tr>{columns.map(column => <th key={column.header} scope="col" className={`px-4 py-3 font-semibold ${column.numeric ? 'text-right' : ''}`}>{column.header}</th>)}</tr></thead>
      <tbody className="divide-y divide-border-default">{rows.map((row, index) => <tr key={String(row.id ?? index)}>{columns.map(column => <td key={column.header} className={`px-4 py-3 align-top ${column.numeric ? 'text-right' : ''}`}>{column.cell(row)}</td>)}</tr>)}</tbody>
    </table>
  </div>
}

// ── Statement detail and platform-fee payment ────────────────────────────────────────────────────

export function VendorStatementPage() {
  const { statementId = '' } = useParams()
  return <FinanceGate activeHref="/finance" permission="portal.wallet">{() => <StatementDetail statementId={statementId} />}</FinanceGate>
}

function StatementDetail({ statementId }: { statementId: string }) {
  const { data, setData, error, reload } = useLoader(() => getStatement(statementId))
  if (error) return <div className="grid gap-4"><BackToStatements /><ErrorState message={error} onRetry={reload} /></div>
  if (!data) return <div className="grid gap-4"><BackToStatements /><LoadingState label="Loading statement…" /></div>
  const payable = ['ISSUED', 'PARTIALLY_PAID'].includes(data.state) && data.outstandingCentavos > 0
  return <div className="grid min-w-0 gap-6">
    <BackToStatements />
    <PageHeader eyebrow="Commission statement" title={data.reference} status={data.overdue ? 'OVERDUE' : data.state} description={`Monthly 2% commission for ${data.periodStart} to ${data.periodEnd}. Due ${data.dueOn} (end of day, Asia/Manila).`} actions={<DemoLabel>{data.sampleNotice}</DemoLabel>} />
    <SummaryTiles label="Statement amounts" tiles={[
      { key: 'charges', label: 'Earned commission', value: formatPesoCentavos(data.chargesCentavos), hint: 'Completed, non-refunded materials excluding VAT × 2%' },
      { key: 'credits', label: 'Credits', value: formatPesoCentavos(data.creditsCentavos), hint: 'Approved adjustments' },
      { key: 'paid', label: 'Paid', value: formatPesoCentavos(data.paidCentavos), hint: 'Verified platform-fee payments' },
      { key: 'outstanding', label: 'Outstanding', value: formatPesoCentavos(data.outstandingCentavos), hint: data.disputedHeldCentavos > 0 ? `${formatPesoCentavos(data.disputedHeldCentavos)} held for disputes` : 'Due by the date shown', tone: payable ? 'warning' : 'success' },
    ]} />
    <div className="grid min-w-0 gap-6 xl:grid-cols-[minmax(0,1fr)_24rem]">
      <section aria-labelledby="lines-heading" className="grid content-start gap-3">
        <h2 id="lines-heading" className="text-lg font-semibold">Statement lines</h2>
        <ul className="grid divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary">
          {data.lines.map((line, index) => { const row = section(line); return <li key={index} className="flex flex-wrap justify-between gap-3 px-4 py-3 text-sm">
            <span className="grid gap-0.5"><span className="font-semibold">{String(row.order_reference ?? row.description)}</span><span className="text-text-secondary">{String(row.description)}{row.basis_centavos ? ` · basis ${formatPesoCentavos(Number(row.basis_centavos))}` : ''}</span></span>
            <span className={`font-semibold tabular-nums ${row.type === 'CREDIT' ? 'text-green-800' : ''}`}>{row.type === 'CREDIT' ? '−' : ''}{formatPesoCentavos(Number(row.amount_centavos))}</span></li> })}
        </ul>
        <PaymentHistory payments={data.payments} onUpdated={updated => setData({ ...data, payments: data.payments.map(item => item.id === updated.id ? updated : item) })} />
      </section>
      <aside aria-label="Pay statement" className="grid content-start gap-4">
        {payable ? <PayStatementForm statement={data} onStarted={() => reload()} /> : <StatusMessage tone="success">Nothing is due on this statement.</StatusMessage>}
      </aside>
    </div>
  </div>
}

function PayStatementForm({ statement, onStarted }: { statement: FeeStatementDetail; onStarted: () => void }) {
  const channels = statement.channels.filter(channel => channel.available)
  const [channel, setChannel] = useState(channels[0]?.code ?? '')
  const [installment, setInstallment] = useState(false)
  const [amount, setAmount] = useState('')
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [key] = useState(newIdempotencyKey)
  const open = statement.payments.find(payment => payment.status === 'PENDING')
  async function submit(event: FormEvent) {
    event.preventDefault()
    setError(null)
    const centavos = installment ? pesoInputToCentavos(amount) : null
    if (installment && (centavos === null || centavos < 1 || centavos > statement.outstandingCentavos)) { setError(`Enter an amount from ₱0.01 to ${formatPesoCentavos(statement.outstandingCentavos)}.`); return }
    setBusy(true)
    try {
      const attempt = await payStatement(statement.id, channel, centavos, key)
      if (attempt.checkoutUrl) window.open(attempt.checkoutUrl, '_blank', 'noopener,noreferrer')
      onStarted()
    } catch (cause) { setError(await readableFinanceError(cause)) }
    finally { setBusy(false) }
  }
  if (open) return <StatusMessage tone="info">A payment for this statement is pending verification. Check its status below before starting another.</StatusMessage>
  return <form className="grid gap-4 rounded-surface border border-border-default bg-surface-primary p-4" onSubmit={event => void submit(event)} aria-labelledby="pay-heading">
    <div><h2 id="pay-heading" className="text-lg font-semibold">Pay statement</h2><p className="mt-1 text-sm text-text-secondary">Xendit TEST payment to the MateryalPH platform account. No real charge, no automatic debit; MateryalPH absorbs the processing charge on its own bill.</p></div>
    <fieldset className="grid gap-2"><legend className="text-sm font-semibold">Channel</legend>
      {channels.length === 0 && <StatusMessage tone="error">No payment channel is available right now. Try again later.</StatusMessage>}
      {channels.map(item => <label key={item.code} className="flex min-h-11 items-center gap-3 rounded-control border border-border-default px-3 text-sm"><input type="radio" name="channel" className="h-5 w-5 accent-action-primary" value={item.code} checked={channel === item.code} onChange={() => setChannel(item.code)} disabled={busy} />{item.displayName}</label>)}
    </fieldset>
    <label className="flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={installment} onChange={event => setInstallment(event.target.checked)} disabled={busy} />Pay part of the balance now</label>
    {installment && <label className="grid gap-2 text-sm font-semibold">Amount (₱)<input className="min-h-12 rounded-control border border-border-default px-3 text-base font-normal" inputMode="decimal" value={amount} onChange={event => setAmount(event.target.value)} disabled={busy} aria-describedby="amount-hint" /><span id="amount-hint" className="text-xs font-normal text-text-secondary">Up to {formatPesoCentavos(statement.outstandingCentavos)}</span></label>}
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <Button type="submit" disabled={busy || !channel}>{busy ? 'Opening payment…' : `Pay ${installment ? 'amount' : formatPesoCentavos(statement.outstandingCentavos)} — TEST`} <ExternalLink size={16} aria-hidden="true" /></Button>
    <p className="text-xs text-text-secondary">The payment opens in a new tab. The statement updates only after the provider verifies it; returning from the payment page does not confirm it.</p>
  </form>
}

function PaymentHistory({ payments, onUpdated }: { payments: PaymentAttempt[]; onUpdated: (payment: PaymentAttempt) => void }) {
  const [busy, setBusy] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  if (payments.length === 0) return null
  async function check(id: string) {
    setBusy(id); setError(null)
    try { onUpdated(await refreshFeePayment(id)) } catch (cause) { setError(await readableFinanceError(cause)) } finally { setBusy(null) }
  }
  return <section aria-labelledby="payments-heading" className="grid gap-3">
    <h2 id="payments-heading" className="text-lg font-semibold">Payments</h2>
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <ul className="grid divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary">
      {payments.map(payment => <li key={payment.id} className="grid gap-2 px-4 py-3 text-sm">
        <div className="flex flex-wrap items-center justify-between gap-2"><span className="font-semibold tabular-nums">{formatPesoCentavos(payment.totalCentavos)} · {payment.channelName ?? payment.channelCode}</span><PaymentAttemptBadge status={payment.status} /></div>
        <p className="text-text-secondary">{payment.message}</p>
        <p className="text-xs text-text-secondary">Started {formatManilaDateTime(payment.createdAt)}{payment.expiresAt ? ` · expires ${formatManilaDateTime(payment.expiresAt)}` : ''} · {payment.evidenceOrigin === 'SIMULATED' ? 'SIMULATED' : 'Xendit TEST'}</p>
        {payment.canCheckStatus && <div className="flex flex-wrap gap-2">
          {payment.checkoutUrl && <a className="inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-action-primary underline" href={payment.checkoutUrl} target="_blank" rel="noopener noreferrer">Open payment page <ExternalLink size={14} aria-hidden="true" /></a>}
          <Button variant="secondary" disabled={busy === payment.id} onClick={() => void check(payment.id)}><RefreshCw size={16} aria-hidden="true" />{busy === payment.id ? 'Checking…' : 'Check status'}</Button>
        </div>}
      </li>)}
    </ul>
  </section>
}

function BackToStatements() {
  return <Link to="/finance/transactions?tab=STATEMENTS" className="inline-flex min-h-11 w-fit items-center gap-2 text-sm font-semibold text-text-secondary hover:text-text-strong"><ArrowLeft size={16} aria-hidden="true" />Commission statements</Link>
}

// ── Earnings ────────────────────────────────────────────────────────────────────────────────────

export function VendorEarningsPage() {
  return <FinanceGate activeHref="/finance/earnings" permission="portal.earnings">{() => <Earnings />}</FinanceGate>
}

function Earnings() {
  const { data, error, reload } = useLoader<VendorEarnings>(getEarnings)
  if (error) return <ErrorState message={error} onRetry={reload} />
  if (!data) return <LoadingState label="Loading earnings…" />
  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Analytics" title="Earnings" description={data.notice} actions={<DemoLabel>TEST dataset — DEMO figures</DemoLabel>} />
    <SummaryTiles label="Sales and collections" tiles={[
      { key: 'sales', label: 'Commercial sales', value: formatPesoCentavos(data.commercialSalesCentavos), hint: `Includes ${formatPesoCentavos(data.includedVatCentavos)} VAT` },
      { key: 'online', label: 'Online collections', value: formatPesoCentavos(data.onlineCollectionsCentavos), hint: 'Verified provider payments, principal only' },
      { key: 'physical', label: 'Physical collections', value: formatPesoCentavos(data.physicalCollectionsCentavos), hint: 'Your recorded COD / In-Store receipts' },
      { key: 'cash', label: 'Estimated remittance cash', value: formatPesoCentavos(data.estimatedRemittanceCashCentavos), hint: 'C − R − P − W (simulated)' },
    ]} />
    <SummaryTiles label="Deductions and fees" tiles={[
      { key: 'fees', label: 'Buyer processing fees', value: formatPesoCentavos(data.buyerProcessingFeesCentavos), hint: 'Paid by Buyers, never your revenue' },
      { key: 'charges', label: 'Provider charges', value: formatPesoCentavos(data.providerChargesCentavos), hint: 'Removed from remittances (P)' },
      { key: 'cwt', label: 'Simulated CWT', value: formatPesoCentavos(data.simulatedCwtCentavos), hint: 'A tax credit record, not a sales reduction' },
      { key: 'commission', label: 'Earned commission', value: formatPesoCentavos(data.earnedCommissionCentavos), hint: `${formatPesoCentavos(data.estimatedCommissionCentavos)} still estimated`, tone: 'info' },
    ]} />
    <div className="flex flex-wrap items-center gap-3 rounded-surface border border-border-default bg-surface-primary p-4 text-sm">
      <ReceiptText size={18} className="text-action-primary" aria-hidden="true" />
      <span>Unpaid commission statements: <strong className="tabular-nums">{formatPesoCentavos(data.unpaidStatementsCentavos)}</strong></span>
      <Link className="font-semibold text-action-primary underline" to="/finance/transactions?tab=STATEMENTS">View statements</Link>
      <span className="flex items-center gap-1 text-text-secondary"><Landmark size={16} aria-hidden="true" />Balances and withdrawals stay in your Xendit dashboard.</span>
    </div>
  </div>
}

function Fact({ label, value }: { label: string; value: string }) {
  return <div className="grid gap-1"><dt className="text-xs font-semibold uppercase tracking-wide text-text-secondary">{label}</dt><dd className="font-semibold text-text-strong">{value || '—'}</dd></div>
}

function monthName(month: number): string {
  return new Intl.DateTimeFormat('en-PH', { month: 'long' }).format(new Date(2026, Math.max(0, Math.min(11, month - 1)), 1))
}
