import { DocumentExportButton } from '@materyalph/web-ui'
import { useCallback, useEffect, useState, type FormEvent, type ReactNode } from 'react'
import { Link, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { ArrowLeft, Banknote, ClipboardCheck, CreditCard, Download, ExternalLink, Landmark, Percent, ReceiptText, RefreshCw, ShieldAlert, ShieldCheck, Wallet } from 'lucide-react'
import {
  ActiveFilters, ALL_DATES, BarList, Button, ChartDataTable, CommissionRateSummary, DashboardPanel, DataTable, DateFilter, DemoLabel, FilterTabs, FinanceDetails, FinanceSection, FormDialog, KpiCard, MethodNote, Pagination, PaymentAttemptBadge, PaymentChannelList, ShareBar,
  RankedList, RevealableValue, StatusBadge, StatusMessage, StatCards, InfoNote, EmptyState, SectionWorkspace, ThresholdPanel, Toolbar, TrendLineChart,
  analyticsDay, dateFilterLabel, formatChartDay, formatChartMonth, formatCompactCentavos, formatCount, formatManilaDateTime, formatPesoCentavos, type DateFilterRange, type TrendSeries, type VizColor,
} from '@materyalph/web-ui'
import {
  channelRows, exportTransactions, getCommissionMonitoring, getEarnings, getFinanceOverview, getFinanceReviews, getStatement, listTransactions, payStatement, readableFinanceError, refreshFeePayment, revealTin, section,
  thresholdData, type FeeStatementDetail, type FinanceRow, type FinanceTab, type PaymentAttempt, type PaymentStatusFilter, type VendorEarnings, type VendorEarningsTrendPoint,
} from '../lib/finance-api'
import { pesoInputToCentavos } from '../lib/orders-api'
import { getVendorOnboarding, newIdempotencyKey } from '../lib/onboarding-api'
import { CommissionTerms } from '../components/CommissionTerms'
import { storeName } from '../lib/catalog-access'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'
import { dateRangeFromParams, dateRangePatch } from '../lib/date-filters'

type Snapshot = NonNullable<ReturnType<typeof useOnboardingSnapshot>['snapshot']>

/**
 * Owner-only finance gate. The server enforces it on every request (FINANCE_OWNER_ONLY); this gate only avoids
 * showing a dead page. A Store Manager's operational order access never reaches these modules.
 */
function FinanceGate({ activeHref, permission, children }: { activeHref: string; permission: 'portal.wallet' | 'portal.earnings'; children: (snapshot: Snapshot, publish: (snapshot: Snapshot) => void) => ReactNode }) {
  const { snapshot, loading, error, refresh, setSnapshot } = useOnboardingSnapshot()
  if (loading) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><LoadingState label="Loading finance…" /></VendorShell>
  if (error || !snapshot) return <VendorShell activeHref={activeHref} accountLabel="Vendor" navigationData={null}><ErrorState message={error ?? 'Finance is unavailable.'} onRetry={() => void refresh()} /></VendorShell>
  return <VendorShell activeHref={activeHref} accountLabel={storeName(snapshot)} navigationData={snapshot}>
    {snapshot.permissions.includes(permission) ? children(snapshot, setSnapshot) : <OwnerOnly />}
  </VendorShell>
}

function OwnerOnly() {
  return <div className="grid gap-3 rounded-surface border border-border-default bg-surface-primary p-6" role="alert">
    <div className="flex items-start gap-3"><ShieldAlert className="mt-0.5 shrink-0 text-action-primary" size={20} aria-hidden="true" />
      <div><PageHeader eyebrow="Finance" title="Store-wide finance is Owner-only" description="Access depends on your assigned role." />
        <p className="mt-1 text-sm text-text-secondary">Earnings, Transaction History, withholding and commission statements and finance exports are available to the Vendor Owner. Order-specific payment status stays visible on each order you can work on.</p></div></div>
    <Link className="text-sm font-semibold text-action-primary underline" to="/orders">Go to Orders</Link>
  </div>
}

function FinanceTabs({ current }: { current: 'overview' | 'transactions' | 'commissions' }) {
  const navigate = useNavigate()
  return <FilterTabs appearance="tabs" label="Finance sections" value={current} chips={[{ value: 'overview', label: 'Finance overview' }, { value: 'commissions', label: 'Commission monitoring' }, { value: 'transactions', label: 'Transaction History' }]} onChange={value => navigate(value === 'overview' ? '/finance' : `/finance/${value}`)} />
}

function useLoader<T>(load: () => Promise<T>, key?: string) {
  const [data, setData] = useState<T | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const reload = useCallback(() => setAttempt(value => value + 1), [])
  useEffect(() => {
    let active = true
    if (key !== undefined) setData(null)
    setError(null)
    load().then(value => { if (active) setData(value) }).catch(async cause => { const text = await readableFinanceError(cause); if (active) setError(text) })
    return () => { active = false }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- the loader identity is stable per page; attempt drives reloads.
  }, [attempt, key])
  return { data, setData, error, reload }
}

// ── Finance overview ────────────────────────────────────────────────────────────────────────────

export function VendorFinancePage() {
  return <FinanceGate activeHref="/finance" permission="portal.wallet">{() => <FinanceOverview />}</FinanceGate>
}

function FinanceOverview() {
  const { data, error, reload } = useLoader(getFinanceOverview)
  const [xenditDemoOpen, setXenditDemoOpen] = useState(false)
  if (error) return <div className="grid gap-4"><ErrorState message={error} onRetry={reload} /></div>
  if (!data) return <LoadingState label="Loading finance overview…" />
  const connection = section(data.xenditConnection)
  const tax = section(data.taxProfile)
  const declaration = section(tax.declaration)
  const arrangement = section(data.withholdingArrangement)
  const terms = section(data.commissionTerms)
  const online = section(data.onlineChannels)
  const statements = section(data.statements)
  const threshold = thresholdData(data.threshold)
  const mandatory = data.notices.filter(notice => notice.mandatory)
  const tin = tax.tin_masked ? <RevealableValue masked={String(tax.tin_masked)} label="TIN" reveal={revealTin} readError={readableFinanceError} /> : 'Not provided'

  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Finance" title="Finance overview" description="Manage your TEST connection, tax profile, withholding and commission terms." actions={<Link className="inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold text-action-primary" to="/finance/commissions"><Percent size={16} aria-hidden="true" />Monitor commission fees</Link>} />
    <FinanceTabs current="overview" />
    <InfoNote>MateryalPH holds no wallet or balance for your store.</InfoNote>
    {mandatory.length > 0 && <section aria-labelledby="notices-heading" className="grid gap-2">
      <h2 id="notices-heading" className="text-base font-semibold">Required finance notices</h2>
      <ul className="grid gap-2">{mandatory.slice(0, 3).map(notice => <li key={notice.id} className="rounded-control border border-red-300 bg-red-50 p-3 text-sm text-red-900"><p className="font-semibold">{notice.title}</p><p className="mt-1">{notice.body}</p><p className="mt-1 text-xs">{formatManilaDateTime(notice.createdAt)} · Cannot be turned off</p></li>)}</ul>
    </section>}
    <div className="min-w-0">
      <SectionWorkspace appearance="chips" contentClassName="min-w-0 rounded-surface border border-border-default bg-surface-primary p-5 sm:p-6 xl:p-8" sections={[
        { label: 'Xendit & payment channels', content: <div className="grid min-w-0 gap-6 xl:gap-8">
          <FinanceSection id="xendit" layout="split" title="Xendit connection" icon={<Landmark size={20} />} description={String(connection.note ?? '')}
            badge={<StatusBadge label={String(connection.label ?? 'Not connected')} tone={connection.status === 'CONNECTED_TEST' ? 'success' : 'warning'} />}>
            <FinanceDetails appearance="rows" items={[
              ['Environment', 'TEST'], ['Account contract', String(connection.account_contract ?? '—')],
              ['Payment API', String(connection.payment_api ?? '—')], ['Last reconciled', formatManilaDateTime(connection.last_reconciled_at as string | null)],
            ]} />
            <div className="flex flex-wrap">
              <Button variant="outline" aria-haspopup="dialog" onClick={() => setXenditDemoOpen(true)}><ExternalLink size={16} aria-hidden="true" />Open Xendit account (demo)</Button>
            </div>
          </FinanceSection>
          <FinanceSection id="channels" layout="split" title="Online payment channels" icon={<CreditCard size={20} />} description={String(online.fee_note ?? '')}>
            <PaymentChannelList layout="columns" caption="Configured online channels" channels={channelRows(online.channels)} />
          </FinanceSection>
        </div> },
        { label: 'Gross-remittance threshold', content: <div className="grid min-w-0 gap-6 xl:gap-8">
          {threshold ? <ThresholdPanel data={threshold} layout="overview" showDemoLabel={false} /> : <StatusMessage tone="info">The threshold panel appears once your tax profile is complete.</StatusMessage>}
          <FinanceSection id="tax" layout="split" title="Vendor Tax Profile summary" icon={<ReceiptText size={20} />} description="Collected once in Store Verification. Corrections create a new version and never rewrite posted records.">
            {tax.available ? <FinanceDetails appearance="rows" items={[
              ['TIN', tin], ['VAT status', String(tax.vat_category ?? '—').replaceAll('_', ' ')],
              ['Taxable year starts', monthName(Number(tax.fiscal_year_start_month ?? 1))],
              ['Relief declaration', `${String(declaration.status ?? 'NOT_SUBMITTED').replaceAll('_', ' ').toLowerCase()}${declaration.taxable_year ? ` · ${String(declaration.taxable_year)}` : ''}`],
            ]} /> : <StatusMessage tone="info">Your Vendor Tax Profile has no validated taxpayer identity yet. Complete it in Store Verification.</StatusMessage>}
            {typeof declaration.note === 'string' && <p className="border-l-2 border-border-default pl-3 text-sm leading-6 text-text-secondary">{declaration.note}</p>}
          </FinanceSection>
          <FinanceSection id="arrangement" layout="split" title="Withholding arrangement" icon={<ShieldCheck size={20} />}>
            <FinanceDetails appearance="rows" items={[['Rate', String(arrangement.rate_label ?? '—')]]} />
          </FinanceSection>
          <FinanceSection id="terms" layout="split" title="Commission Terms" icon={<Percent size={20} />} description={String(terms.note ?? '')} badge={<StatusBadge label={terms.accepted ? `Accepted · version ${String(terms.version ?? '')}` : 'Not accepted'} tone={terms.accepted ? 'success' : 'warning'} />}>
            <FinanceDetails appearance="rows" items={[['Rate', String(terms.rate_label ?? '') || '—'], ['Accepted', formatManilaDateTime(terms.accepted_at as string | null)]]} />
            {Number(statements.outstanding_centavos ?? 0) > 0 && <div className="flex flex-wrap items-center justify-between gap-4 rounded-control bg-surface-canvas p-4">
              <div className="min-w-0"><p className="text-xs font-semibold text-text-secondary">Outstanding statements</p><p className="mt-1 text-xl font-semibold tabular-nums text-text-strong">{formatPesoCentavos(Number(statements.outstanding_centavos))}</p>{Boolean(statements.next_due_on) && <p className="mt-1 text-xs text-text-secondary">Next due {String(statements.next_due_on)}</p>}</div>
              <Link className="inline-flex min-h-11 items-center gap-2 rounded-control border border-border-default bg-surface-primary px-4 text-sm font-semibold text-action-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring" to="/finance/transactions?tab=STATEMENTS"><ReceiptText size={16} aria-hidden="true" />View statements</Link>
            </div>}
          </FinanceSection>
        </div> },
        { label: 'Finance reviews', content: <FinanceReviewsSection /> },
      ]} />
    </div>
    {xenditDemoOpen && <FormDialog open title="Xendit account demo" description="Demo shortcut · Xendit TEST mode" size="small" onClose={() => setXenditDemoOpen(false)}
      footer={<div className="flex justify-end"><Button onClick={() => setXenditDemoOpen(false)}>Got it</Button></div>}>
      <p className="text-sm leading-6 text-text-secondary">This previews the Xendit account shortcut. Account access is simulated while MateryalPH uses Xendit TEST mode.</p>
    </FormDialog>}
  </div>
}

export function VendorCommissionPage() {
  return <FinanceGate activeHref="/finance" permission="portal.wallet">{(_, publish) => <CommissionMonitoring onSnapshotSaved={publish} />}</FinanceGate>
}

function CommissionMonitoring({ onSnapshotSaved }: { onSnapshotSaved: (snapshot: Snapshot) => void }) {
  const [page, setPage] = useState(1)
  const [termsOpen, setTermsOpen] = useState(false)
  const result = useLoader(() => getCommissionMonitoring(page), String(page))
  const data = result.data?.monitoring
  const total = data?.summary
  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Finance" title="Commission monitoring" description="Track your store's commission fees from accepted order to monthly statement and payment." actions={<Button variant="outline" onClick={result.reload}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    <FinanceTabs current="commissions" />
    {result.error ? <ErrorState message={result.error} onRetry={result.reload} /> : !data || !total ? <LoadingState label="Loading commission monitoring…" /> : <>
      {!data.termsAccepted && <StatusMessage tone="info">Review and accept the current Commission Terms before new transactions use this rate. Existing orders keep their saved rate.</StatusMessage>}
      <CommissionRateSummary rateLabel={data.currentPolicy?.rateLabel} effectiveFrom={data.currentPolicy?.effectiveFrom} nextRateLabel={data.nextPolicy?.rateLabel} nextEffectiveFrom={data.nextPolicy?.effectiveFrom}
        actions={<Button variant="outline" aria-haspopup="dialog" onClick={() => setTermsOpen(true)}>Review Commission Terms</Button>} />
      <StatCards label="Commission fee monitoring" tiles={[
        { key: 'estimated', label: 'Estimated fees', value: formatPesoCentavos(total.estimatedCentavos), hint: 'Accepted orders awaiting completion' },
        { key: 'earned', label: 'Net earned commission', value: formatPesoCentavos(total.netEarnedCentavos), hint: 'Completed orders less approved credits' },
        { key: 'outstanding', label: 'Unpaid statements', value: formatPesoCentavos(total.outstandingCentavos), hint: 'Issued bills still due' },
        { key: 'overdue', label: 'Overdue', value: formatPesoCentavos(total.overdueCentavos), hint: 'Unpaid after the statement due date', tone: total.overdueCentavos > 0 ? 'warning' : 'neutral' },
      ]} />
      <DashboardPanel title="Billing and payments" description="All-time recorded fees and payments. Estimated fees are earned only when an order completes.">
        <FinanceDetails appearance="rows" items={[
          ['Not yet billed', formatPesoCentavos(total.unbilledCentavos)], ['Draft bills awaiting issue', formatPesoCentavos(total.draftCentavos)],
          ['Approved commission credits', formatPesoCentavos(total.creditedCentavos)], ['Payments collected', formatPesoCentavos(total.collectedCentavos)],
          ['Confirmed fee refunds', formatPesoCentavos(total.refundedCentavos)], ['Net collected payments', formatPesoCentavos(total.netCollectedCentavos)],
        ]} />
        <Link className="mt-4 inline-flex min-h-11 items-center gap-2 font-semibold text-action-primary underline underline-offset-4" to="/finance/transactions?tab=STATEMENTS"><ReceiptText size={16} aria-hidden="true" />View and pay commission statements</Link>
      </DashboardPanel>
      <DashboardPanel title="Commission by order" description="Each order keeps its original rate, including later returns. Amounts exclude materials VAT and delivery.">
        {data.assessments.length === 0 ? <p className="py-5 text-sm text-text-secondary">No commission assessments yet. An estimate appears when an order is accepted; the fee is earned at completion.</p> : <DataTable caption="Commission by order" minWidth="48rem" headers={['Order', 'Materials basis', 'Saved rate', 'Estimated', 'Earned', 'Credits', 'Net earned', 'Status']}>
            {data.assessments.map(row => <tr key={row.id}>
              <th scope="row" className="px-4 py-4 font-semibold">{row.orderReference}</th><td className="px-4 py-4 tabular-nums">{formatPesoCentavos(row.commissionBasisCentavos)}</td><td className="px-4 py-4 tabular-nums">{(row.commissionBasisPoints / 100).toFixed(2)}%</td>
              {[row.estimatedCentavos, row.earnedCentavos, row.creditedCentavos, row.netCentavos].map((amount, index) => <td key={index} className="px-4 py-4 tabular-nums">{formatPesoCentavos(amount)}</td>)}
              <td className="px-4 py-4"><StatusBadge label={row.disputeHold ? 'Dispute hold' : row.state.toLowerCase()} tone={row.disputeHold ? 'warning' : 'neutral'} />{row.earnedAt && <p className="mt-1 text-xs text-text-secondary">{formatManilaDateTime(row.earnedAt)}</p>}</td>
            </tr>)}
        </DataTable>}
        {(page > 1 || result.data?.hasMore) && <Pagination page={page} hasMore={result.data?.hasMore ?? false} onChange={setPage} />}
      </DashboardPanel>
    </>}
    {termsOpen && <CommissionTermsDialog onClose={() => setTermsOpen(false)} onSaved={snapshot => { onSnapshotSaved(snapshot); result.reload() }} />}
  </div>
}

function CommissionTermsDialog({ onClose, onSaved }: { onClose: () => void; onSaved: (snapshot: Snapshot) => void }) {
  // Fetch again on every open so the version and organization lock are current.
  const { data, setData, error, reload } = useLoader(getVendorOnboarding)
  const [busy, setBusy] = useState(false)
  return <FormDialog open title="Review Commission Terms" description="Read your store's current agreement and review its acceptance status here in Finance." busy={busy} onClose={onClose}
    footer={<div className="flex justify-end"><Button variant="outline" disabled={busy} onClick={onClose}>Done</Button></div>}>
    {error ? <ErrorState message={error} onRetry={reload} /> : !data ? <LoadingState label="Loading Commission Terms…" /> : <CommissionTerms snapshot={data} onBusyChange={setBusy} onSaved={snapshot => { setData(snapshot); onSaved(snapshot) }} />}
  </FormDialog>
}

// ── Finance review status (FIN-10) ─────────────────────────────────────────────────────────────

function FinanceReviewsSection() {
  const { data, error, reload } = useLoader(getFinanceReviews)
  const text = (value: unknown) => String(value ?? '').replaceAll('_', ' ').toLowerCase().replace(/(^|\s)\S/g, letter => letter.toUpperCase())
  return <FinanceSection id="reviews" title="Finance reviews" icon={<ClipboardCheck size={20} />} description="Where your statements, tax adjustments and tax evidence stand with the MateryalPH finance team. Corrections post new entries; nothing you filed is edited." badge={data ? <DemoLabel>{data.label}</DemoLabel> : undefined}>
    {error ? <ErrorState message={error} onRetry={reload} /> : !data ? <LoadingState label="Loading finance reviews…" /> : <div className="grid gap-6">
      {data.openReviews.length > 0 && <ul className="grid gap-2" aria-label="Open finance reviews">{data.openReviews.map(item => <li key={item.id} className="flex flex-wrap items-center justify-between gap-2 rounded-control border border-amber-300 bg-amber-50 px-3 py-2 text-sm text-amber-900"><span className="font-semibold">{item.label}</span><span>Opened {formatManilaDateTime(item.createdAt)}</span></li>)}</ul>}
      <div className="min-w-0 overflow-x-auto rounded-control border border-border-default focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring" tabIndex={0} role="region" aria-label="Commission statement records"><table className="w-full min-w-[40rem] text-left text-sm"><caption className="border-b border-border-default px-4 py-4 text-left text-base font-semibold text-text-strong">Commission statements</caption>
        <thead className="bg-surface-canvas text-xs text-text-secondary"><tr>{['Statement', 'Period', 'Approval', 'Outstanding', 'Payment status'].map(head => <th key={head} scope="col" className="px-4 py-3 font-semibold">{head}</th>)}</tr></thead>
        <tbody className="divide-y divide-border-default">{data.statements.length === 0 ? <tr><td colSpan={5} className="px-4 py-6 text-text-secondary">No issued statements yet.</td></tr> : data.statements.map(row => <tr key={String(row.id)} className="align-top">
          <td className="px-4 py-4 font-semibold text-text-strong">{String(row.reference ?? '—')}</td><td className="px-4 py-4 text-text-secondary">{String(row.period_start)} – {String(row.period_end)}</td>
          <td className="px-4 py-4">{row.approved ? 'Approved and issued' : 'Awaiting approval'}</td><td className="px-4 py-4 font-semibold tabular-nums text-text-strong">{formatPesoCentavos(Number(row.outstanding_centavos ?? 0))}</td>
          <td className="px-4 py-4"><StatusBadge label={row.overdue ? `Overdue since ${String(row.due_on)}` : text(row.state)} tone={row.overdue ? 'error' : row.state === 'PAID' ? 'success' : 'warning'} /></td></tr>)}</tbody></table></div>
      <div className="grid gap-6 lg:grid-cols-2 lg:gap-8">
        <section aria-labelledby="adjustments-heading" className="grid content-start gap-3 border-t border-border-default pt-5"><h3 id="adjustments-heading" className="text-base font-semibold text-text-strong">Tax adjustments</h3>
          {data.taxAdjustments.length === 0 ? <p className="rounded-control bg-surface-canvas p-4 text-sm text-text-secondary">No tax adjustments.</p> : <ul className="divide-y divide-border-default">{data.taxAdjustments.map(row => <li key={String(row.id)} className="flex min-w-0 flex-wrap items-start justify-between gap-3 py-3 text-sm">
            <span className="grid min-w-0 gap-1"><span className="font-semibold text-text-strong">{text(row.kind)}</span><span className="text-text-secondary [overflow-wrap:anywhere]">{String(row.order_reference)} · {formatPesoCentavos(Number(row.amount_centavos ?? 0))}</span></span><StatusBadge label={text(row.state)} tone={row.state === 'POSTED' ? 'success' : row.state === 'REJECTED' ? 'error' : 'warning'} /></li>)}</ul>}</section>
        <section aria-labelledby="evidence-heading" className="grid content-start gap-3 border-t border-border-default pt-5"><h3 id="evidence-heading" className="text-base font-semibold text-text-strong">Tax evidence</h3>
          {data.evidence.length === 0 ? <p className="rounded-control bg-surface-canvas p-4 text-sm text-text-secondary">No tax evidence submitted.</p> : <ul className="divide-y divide-border-default">{data.evidence.map(row => <li key={String(row.id)} className="flex min-w-0 flex-wrap items-start justify-between gap-3 py-3 text-sm">
            <span className="grid min-w-0 gap-1"><span className="font-semibold text-text-strong">{text(row.evidence_type)}</span>{Boolean(row.taxable_year) && <span className="text-xs text-text-secondary">Taxable year {String(row.taxable_year)}</span>}</span><StatusBadge label={text(row.review_state)} tone={row.review_state === 'APPROVED' ? 'success' : row.review_state === 'REJECTED' ? 'error' : 'warning'} /></li>)}</ul>}</section>
      </div>
    </div>}
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

/** Labels match the badge each Payments row shows, so the dropdown and the table read the same. */
const PAYMENT_STATUSES: { value: PaymentStatusFilter; label: string }[] = [
  { value: 'PAID', label: 'Paid — verified by provider' }, { value: 'PAID_REFUNDED', label: 'Paid — refunded' }, { value: 'PAID_PARTIALLY_REFUNDED', label: 'Paid — partially refunded' },
  { value: 'PAID_REFUND_PENDING', label: 'Paid — refund pending' }, { value: 'PAID_REFUND_FAILED', label: 'Paid — refund failed' }, { value: 'PENDING', label: 'Pending verification' },
  { value: 'FAILED', label: 'Failed — not charged' }, { value: 'EXPIRED', label: 'Expired — not charged' }, { value: 'LATE_CAPTURE', label: 'Late capture' },
]

export function VendorTransactionHistoryPage() {
  return <FinanceGate activeHref="/finance" permission="portal.wallet">{() => <TransactionHistory />}</FinanceGate>
}

function TransactionHistory() {
  const [params, setParams] = useSearchParams()
  // Tax documents stay hidden until the first certificate exists; nothing in the app uploads one, so an empty tab is only noise.
  const [hasTaxDocuments, setHasTaxDocuments] = useState(false)
  useEffect(() => {
    let active = true
    listTransactions('TAX_DOCUMENTS', 1).then(result => { if (active) setHasTaxDocuments(result.items.length > 0) }).catch(() => undefined)
    return () => { active = false }
  }, [])
  const tabs = hasTaxDocuments ? TABS : TABS.filter(item => item.value !== 'TAX_DOCUMENTS')
  const tab = (tabs.some(item => item.value === params.get('tab')) ? params.get('tab') : 'PAYMENTS') as FinanceTab
  const page = Math.max(1, Number(params.get('page') ?? '1') || 1)
  const range = dateRangeFromParams(params)
  const status = tab === 'PAYMENTS' ? PAYMENT_STATUSES.find(item => item.value === params.get('status')) : undefined
  const dates = { ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }
  const statusValue = status?.value
  const filters = { ...dates, ...(statusValue ? { status: statusValue } : {}) }
  const update = (patch: Record<string, string>) => setParams(current => {
    const next = new URLSearchParams(current)
    for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) }
    if (!('page' in patch)) next.delete('page')
    return next
  }, { replace: true })
  const [rows, setRows] = useState<FinanceRow[] | null>(null)
  const [hasMore, setHasMore] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [exporting, setExporting] = useState(false)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setRows(null); setError(null)
    listTransactions(tab, page, { ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}), ...(statusValue ? { status: statusValue } : {}) }).then(result => { if (active) { setRows(result.items); setHasMore(result.hasMore) } }).catch(async cause => { const text = await readableFinanceError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [tab, page, range.from, range.to, statusValue, attempt])
  async function download() {
    setExporting(true)
    try {
      const blob = await exportTransactions(tab, filters)
      const url = URL.createObjectURL(blob)
      const link = Object.assign(document.createElement('a'), { href: url, download: `materyalph-${tab.toLowerCase()}-test.csv` })
      link.click(); URL.revokeObjectURL(url)
    } catch (cause) { setError(await readableFinanceError(cause)) }
    finally { setExporting(false) }
  }
  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Finance" title="Transaction History" description="Review payments, receipts, simulated remittances, statements, refunds and tax documents."
      actions={<><DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="vendor" types={['TRANSACTION_HISTORY']} filters={{ tab, ...filters }} title="Transaction History" /><Button variant="secondary" disabled={exporting || !rows || rows.length === 0} onClick={() => void download()}><Download size={16} aria-hidden="true" />{exporting ? 'Preparing…' : 'Export CSV'}</Button></>} />
    <InfoNote>Read-only records; this page shows no balance and moves no money. Internal Operational Report — Not a Tax Invoice. Use your authorized Xendit dashboard for balances and withdrawals.</InfoNote>
    <FinanceTabs current="transactions" />
    <FilterTabs label="Transaction type" chips={tabs} value={tab} onChange={value => update({ tab: value, status: '' })} />
    <Toolbar filters={<>
      <DateFilter title={tab === 'STATEMENTS' ? 'Statement issue dates' : tab === 'TAX_DOCUMENTS' ? 'Tax period end dates' : tab === 'REFUNDS' ? 'Refund creation dates' : 'Transaction dates'} value={range} onChange={next => update(dateRangePatch(next))} />
      {tab === 'PAYMENTS' && <label className="flex min-w-0 items-center gap-2 text-sm font-semibold">Status
        <select className="min-h-11 min-w-0 max-w-full rounded-control border border-border-default bg-surface-primary px-3 text-sm font-normal" value={status?.value ?? ''} onChange={event => update({ status: event.target.value })}>
          <option value="">All statuses</option>
          {PAYMENT_STATUSES.map(item => <option key={item.value} value={item.value}>{item.label}</option>)}
        </select>
      </label>}
    </>} />
    <ActiveFilters filters={[
      ...(range.from || range.to ? [{ key: 'dates', label: dateFilterLabel(range), onRemove: () => update(dateRangePatch(ALL_DATES)) }] : []),
      ...(status ? [{ key: 'status', label: status.label, onRemove: () => update({ status: '' }) }] : []),
    ]} onClear={() => update({ ...dateRangePatch(ALL_DATES), status: '' })} />
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
      : rows === null ? <LoadingState label="Loading records…" />
        : rows.length === 0 ? <EmptyState icon={<Wallet size={24} aria-hidden="true" />} message={EMPTY[tab]} action={<Button variant="secondary" onClick={() => setAttempt(value => value + 1)}>Retry</Button>} />
          : <TransactionTable tab={tab} rows={rows} />}
    {(page > 1 || hasMore) && <Pagination page={page} hasMore={hasMore} busy={rows === null} onChange={next => update({ page: String(next) })} />}
  </div>
}

type Column = { header: string; cell: (row: FinanceRow) => ReactNode; numeric?: boolean }
const money = (key: string): Column['cell'] => row => <span className="tabular-nums">{row[key] === null || row[key] === undefined ? '—' : formatPesoCentavos(Number(row[key]))}</span>
const text = (key: string): Column['cell'] => row => String(row[key] ?? '—').replaceAll('_', ' ')

const COLUMNS: Record<FinanceTab, Column[]> = {
  PAYMENTS: [{ header: 'Order', cell: text('reference') }, { header: 'Purpose', cell: text('purpose') }, { header: 'Status', cell: row => <PaymentAttemptBadge status={String(row.status)} refundStatus={String(row.refund_state ?? 'NOT_REQUESTED')} /> },
    { header: 'Gross', cell: money('gross_centavos'), numeric: true }, { header: 'Buyer fee', cell: money('buyer_processing_fee_centavos'), numeric: true },
    { header: 'Refunded', cell: money('refunded_centavos'), numeric: true }, { header: 'Net collected', cell: money('net_collected_centavos'), numeric: true },
    { header: 'Origin', cell: text('evidence_origin') }, { header: 'Date', cell: row => formatManilaDateTime(row.at as string) }],
  PHYSICAL: [{ header: 'Order', cell: text('reference') }, { header: 'Record', cell: text('kind') }, { header: 'Amount', cell: money('amount_centavos'), numeric: true }, { header: 'Remaining', cell: money('remaining_centavos'), numeric: true },
    { header: 'Source', cell: text('evidence_origin') }, { header: 'Buyer acknowledged', cell: row => row.buyer_acknowledged ? 'Yes' : 'No' }, { header: 'Date', cell: row => formatManilaDateTime(row.at as string) }],
  REMITTANCES: [{ header: 'Order', cell: text('reference') }, { header: 'Collected (C)', cell: money('collected_centavos'), numeric: true }, { header: 'Charge (P)', cell: money('provider_charge_centavos'), numeric: true },
    { header: 'Base (G)', cell: money('gross_basis_centavos'), numeric: true }, { header: 'CWT (W)', cell: money('withheld_centavos'), numeric: true }, { header: 'Expected cash', cell: money('expected_cash_centavos'), numeric: true },
    { header: 'Threshold status', cell: row => row.calculation_state === 'VOIDED' ? 'Voided — fully refunded' : text('threshold_status_after')(row) }, { header: 'Evidence', cell: row => `${String(row.deduction_evidence_state ?? '').replaceAll('_', ' ')} · DEMO` }],
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
    <PageHeader eyebrow="Commission statement" title={data.reference} status={data.overdue ? 'OVERDUE' : data.state} description={`Monthly commission for ${data.periodStart} to ${data.periodEnd}. Due ${data.dueOn} (end of day, Asia/Manila).`} actions={<><DemoLabel>{data.sampleNotice}</DemoLabel><DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="vendor" types={['FEE_STATEMENT']} resourceId={statementId} title={data.reference} /></>} />
    <StatCards label="Statement amounts" tiles={[
      { key: 'charges', label: 'Earned commission', value: formatPesoCentavos(data.chargesCentavos), hint: 'Completed materials excluding VAT × each order’s saved rate' },
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
  const [params, setParams] = useSearchParams()
  const range = dateRangeFromParams(params)
  const { data, error, reload } = useLoader<VendorEarnings>(() => getEarnings({ ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }), `${range.from}|${range.to}`)
  const changeDates = (nextRange: DateFilterRange) => setParams(current => { const next = new URLSearchParams(current); for (const [key, value] of Object.entries(dateRangePatch(nextRange))) { if (value) next.set(key, value); else next.delete(key) } return next }, { replace: true })
  return <div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Analytics" title="Earnings" description="Review sales, collections, deductions and commission." actions={<DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="vendor" types={['EARNINGS']} filters={{ ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }} title="Earnings" />} />
    <Toolbar filters={<DateFilter title="Earnings dates" value={range} onChange={changeDates} />} />
    <ActiveFilters filters={range.from || range.to ? [{ key: 'dates', label: dateFilterLabel(range), onRemove: () => changeDates(ALL_DATES) }] : []} onClear={() => changeDates(ALL_DATES)} />
    {error ? <ErrorState message={error} onRetry={reload} /> : !data ? <LoadingState label="Loading earnings…" /> : <>
    <InfoNote>{data.demo ? `Demo aggregates are TEST-only. ${data.notice}` : data.notice}</InfoNote>
    <EarningsAnalytics data={data} compare={Boolean(range.from)} />
    <div className="flex flex-wrap items-center gap-3 rounded-surface border border-border-default bg-surface-primary p-4 text-sm">
      <ReceiptText size={18} className="text-action-primary" aria-hidden="true" />
      <span>Unpaid commission statements: <strong className="tabular-nums">{formatPesoCentavos(data.unpaidStatementsCentavos)}</strong></span>
      <Link className="font-semibold text-action-primary underline" to="/finance/transactions?tab=STATEMENTS">View statements</Link>
      <span className="flex items-center gap-1 text-text-secondary"><Landmark size={16} aria-hidden="true" />Balances and withdrawals stay in your Xendit dashboard.</span>
    </div>
    </>}
  </div>
}

type TrendFigure = Exclude<keyof VendorEarningsTrendPoint, 'date'>

/**
 * FIN-11 Earnings as the Sales & Revenue dashboard draws it: headline cards with the change against the previous equal
 * period, then each figure over time. Every figure stays separate — no margin, net income or ratio is derived — and
 * every chart has a table view. The comparison only shows when a start date is chosen; "All dates" has no prior period.
 */
function EarningsAnalytics({ data, compare }: { data: VendorEarnings; compare: boolean }) {
  const trend = data.trend
  const points = trend.points
  const monthly = trend.granularity === 'MONTH'
  const unit = monthly ? 'month' : 'day'
  const labels = points.map(point => analyticsDay(point.date) ?? '')
  const formatLabel = monthly ? formatChartMonth : formatChartDay
  const rows = labels.map(formatLabel)
  const values = (figure: TrendFigure) => points.map(point => point[figure])
  const active = (...figures: TrendFigure[]) => points.some(point => figures.some(figure => point[figure] !== 0))
  const previous = compare ? trend.previous : null
  const periodLabel = `previous ${formatCount(trend.days)} ${trend.days === 1 ? 'day' : 'days'}`
  const delta = (figure: TrendFigure) => (previous ? { changePercent: previous.changePercent[figure], periodLabel } : null)
  const { sales, online, physical } = data.breakdown
  const minus = (centavos: number) => formatPesoCentavos(centavos === 0 ? 0 : -centavos)
  const series = (figure: TrendFigure, label: string, colorVar: VizColor, kind?: 'bar'): TrendSeries => ({ key: figure, label, colorVar, values: values(figure), ...(kind ? { kind } : {}) })
  const column = (figure: TrendFigure, header: string) => ({ key: figure, header, values: points.map(point => formatPesoCentavos(point[figure])) })
  const chart = (title: string, chartSeries: TrendSeries[], empty: string) => <TrendLineChart title={title} labels={active(...chartSeries.map(item => item.key as TrendFigure)) ? labels : []}
    formatLabel={formatLabel} formatValue={value => formatCompactCentavos(Math.round(value))} emptyReason={empty} series={chartSeries} />
  const table = (caption: string, columns: ReturnType<typeof column>[]) => <ChartDataTable caption={caption} rowHeader={monthly ? 'Month' : 'Date'} rows={rows} columns={columns} />

  return <>
    <p className="-mt-2 text-xs text-text-secondary">{points.length === 0 ? 'The chosen dates start after today, so there is nothing to chart yet.'
      : `Charted by ${unit} · ${formatChartDay(analyticsDay(trend.from) ?? '')} – ${formatChartDay(analyticsDay(trend.to) ?? '')} (Asia/Manila)${previous ? ` · compared with ${formatChartDay(analyticsDay(previous.from) ?? '')} – ${formatChartDay(analyticsDay(previous.to) ?? '')}` : ''}`}</p>
    <dl aria-label="Earnings summary" className="grid gap-4 md:grid-cols-2">
      <KpiCard label="Commercial sales" value={formatPesoCentavos(data.commercialSalesCentavos)} delta={delta('commercialSalesCentavos')} sparkline={values('commercialSalesCentavos')} icon={<Wallet size={16} aria-hidden="true" />} accent
        hint={`${formatCount(sales.orders)} ${sales.orders === 1 ? 'order' : 'orders'} · includes ${formatPesoCentavos(data.includedVatCentavos)} VAT. Cancelled and fully refunded orders are left out.`}
        breakdown={{ caption: 'Commercial sales calculation', rows: [
          { key: 'materials', label: 'Materials before discounts', amount: formatPesoCentavos(sales.materialsBeforeDiscountCentavos) },
          { key: 'discounts', label: 'Vendor discounts', amount: minus(sales.vendorDiscountsCentavos) },
          { key: 'delivery', label: 'Delivery', amount: formatPesoCentavos(sales.deliveryCentavos) },
          { key: 'total', label: 'Commercial sales', amount: formatPesoCentavos(data.commercialSalesCentavos), total: true },
        ] }} />
      <KpiCard label="Online collections" value={formatPesoCentavos(data.onlineCollectionsCentavos)} delta={delta('onlineCollectionsCentavos')} sparkline={values('onlineCollectionsCentavos')} icon={<CreditCard size={16} aria-hidden="true" />} hint="Verified principal after confirmed refunds"
        breakdown={{ caption: 'Online collections calculation', rows: [
          { key: 'paid', label: `Verified online payments (${formatCount(online.payments)})`, amount: formatPesoCentavos(online.principalPaidCentavos) },
          { key: 'refunds', label: 'Confirmed refunds of that principal', amount: minus(online.refundedPrincipalCentavos) },
          { key: 'total', label: 'Online collections', amount: formatPesoCentavos(data.onlineCollectionsCentavos), total: true },
        ] }} />
      <KpiCard label="Physical collections" value={formatPesoCentavos(data.physicalCollectionsCentavos)} delta={delta('physicalCollectionsCentavos')} sparkline={values('physicalCollectionsCentavos')} icon={<Banknote size={16} aria-hidden="true" />} hint="Your recorded COD / In-Store receipts"
        breakdown={{ caption: 'Physical collections calculation', rows: [
          { key: 'cod', label: 'Cash on Delivery', amount: formatPesoCentavos(physical.cashOnDeliveryCentavos) },
          { key: 'store', label: 'In-Store Payment', amount: formatPesoCentavos(physical.inStoreCentavos) },
          { key: 'total', label: `Physical collections (${formatCount(physical.records)} ${physical.records === 1 ? 'receipt' : 'receipts'})`, amount: formatPesoCentavos(data.physicalCollectionsCentavos), total: true },
        ] }} />
      <KpiCard label="Estimated remittance cash" value={formatPesoCentavos(data.estimatedRemittanceCashCentavos)} delta={delta('estimatedRemittanceCashCentavos')} sparkline={values('estimatedRemittanceCashCentavos')} icon={<Landmark size={16} aria-hidden="true" />} hint="Collected − Refunds − Provider charge − Withholding"
        breakdown={{ caption: 'Estimated remittance calculation', rows: [
          { key: 'collected', label: 'Collected online payments, including Buyer fees', amount: formatPesoCentavos(data.remittanceCollectionsCentavos) },
          { key: 'refunds', label: 'Confirmed refunds', amount: minus(data.remittanceRefundsCentavos) },
          { key: 'provider', label: 'Provider charges', amount: minus(data.providerChargesCentavos) },
          { key: 'cwt', label: 'Simulated CWT', amount: minus(data.simulatedCwtCentavos) },
          { key: 'total', label: 'Estimated remittance cash', amount: formatPesoCentavos(data.estimatedRemittanceCashCentavos), total: true },
        ] }} />
    </dl>
    <EarningsProducts key={`${trend.from.toISOString()}|${trend.to.toISOString()}`} data={data} />
    <div className="grid items-start gap-5 xl:grid-cols-2">
      <DashboardPanel title="Sales and collections" description={`Commercial sales per ${unit} with the online and physical collections received.`}>
        <div className="grid gap-4">
          {chart('Commercial sales and collections', [series('commercialSalesCentavos', 'Commercial sales', '--mp-viz-series-1', 'bar'), series('onlineCollectionsCentavos', 'Online collections', '--mp-viz-series-2'),
            series('physicalCollectionsCentavos', 'Physical collections', '--mp-viz-series-3')], 'No sales or collections in this period.')}
          {table(`Sales and collections per ${unit}`, [column('commercialSalesCentavos', 'Commercial sales'), column('onlineCollectionsCentavos', 'Online collections'), column('onlineRefundsCentavos', 'Confirmed online refunds'), column('physicalCollectionsCentavos', 'Physical collections')])}
        </div>
      </DashboardPanel>
      <DashboardPanel title="Estimated remittance cash" description={`Simulated cash expected per ${unit} after refunds, provider charges and CWT.`}>
        <div className="grid gap-4">
          {chart('Estimated remittance cash', [series('estimatedRemittanceCashCentavos', 'Estimated remittance cash', '--mp-viz-series-1')], 'No remittances assessed in this period.')}
          {table(`Estimated remittance cash per ${unit}`, [column('estimatedRemittanceCashCentavos', 'Estimated remittance cash'), column('onlineCollectionsCentavos', 'Online collections')])}
        </div>
      </DashboardPanel>
    </div>
    <div className="grid items-start gap-5 xl:grid-cols-2">
      <DashboardPanel title="Deductions and commission" description={`Provider charges, simulated CWT and earned commission per ${unit}.`}>
        <div className="grid gap-4">
          {chart('Deductions and commission', [series('providerChargesCentavos', 'Provider charges', '--mp-viz-series-1'), series('simulatedCwtCentavos', 'Simulated CWT', '--mp-viz-series-2'),
            series('earnedCommissionCentavos', 'Earned commission', '--mp-viz-series-3')], 'No deductions or commission in this period.')}
          {table(`Deductions and commission per ${unit}`, [column('providerChargesCentavos', 'Provider charges'), column('simulatedCwtCentavos', 'Simulated CWT'), column('earnedCommissionCentavos', 'Earned commission'), column('buyerProcessingFeesCentavos', 'Buyer processing fees')])}
        </div>
      </DashboardPanel>
      <DashboardPanel title="Deductions and fees" description="Totals for the selected dates.">
        <div className="grid gap-5">
          <div className="grid gap-2"><h3 className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">Collections by method</h3>
            <ShareBar label="Collections by method" empty="No collections in this period." formatValue={formatPesoCentavos} segments={[
              { key: 'online', label: 'Online collections', value: data.onlineCollectionsCentavos, colorVar: '--mp-viz-series-2' },
              { key: 'physical', label: 'Physical collections', value: data.physicalCollectionsCentavos, colorVar: '--mp-viz-series-3' }]} /></div>
          <BarList label="Deductions and fees" empty="No deductions or fees in this period." items={[
            { key: 'buyer-fees', label: 'Buyer processing fees', value: data.buyerProcessingFeesCentavos, display: formatPesoCentavos(data.buyerProcessingFeesCentavos), detail: 'Paid by Buyers; never store revenue.' },
            { key: 'provider', label: 'Provider charges', value: data.providerChargesCentavos, display: formatPesoCentavos(data.providerChargesCentavos), detail: 'Reduce remittances (P).' },
            { key: 'cwt', label: 'Simulated CWT', value: data.simulatedCwtCentavos, display: formatPesoCentavos(data.simulatedCwtCentavos), detail: 'A tax credit, not a sales reduction.' },
            { key: 'commission', label: 'Earned commission', value: data.earnedCommissionCentavos, display: formatPesoCentavos(data.earnedCommissionCentavos), detail: `Billed monthly on statements · estimated ${formatPesoCentavos(data.estimatedCommissionCentavos)} not yet earned.` },
          ]} />
        </div>
      </DashboardPanel>
    </div>
    <DashboardPanel title="How these figures are calculated" description="Each card above shows its own lines; this explains where they come from.">
      <div className="grid gap-5">
        <dl className="grid gap-x-8 gap-y-4 text-sm md:grid-cols-2">
          {[
            ['Commercial sales', 'Materials after vendor discounts (VAT included) plus delivery, for orders accepted in the selected dates. Cancelled orders and orders whose payment was fully refunded are left out, so refunded money never counts as sold. The Dashboard’s Gross sales is different: it is counted before returns and refunds, so it can be higher.'],
            ['Product sales value', 'The materials part of commercial sales, split by product. Delivery belongs to no product, so the products plus delivery equal commercial sales.'],
            ['Online collections', 'Verified online principal less the principal of confirmed refunds, by original payment date. Buyer processing fees are shown separately and are never store revenue.'],
            ['Physical collections', 'Cash on Delivery and In-Store receipts you recorded, counted on the date recorded.'],
          ].map(([term, text]) => <div key={term} className="grid gap-1"><dt className="font-semibold text-text-strong">{term}</dt><dd className="leading-6 text-text-secondary">{text}</dd></div>)}
        </dl>
        <p className="text-sm leading-6 text-text-secondary">These amounts use remittances assessed in the selected dates (Asia/Manila). Fully refunded payments appear in both collections and refunds, cancelling out; confirmed partial refunds are deducted once. Pending or failed refunds remain counted. Physical receipts and monthly commission statements are separate.</p>
        <MethodNote>Why this can differ from your Xendit balance: estimated remittance cash is worked out when a payment is verified, before Xendit settles it, so it includes payments still pending there. It also deducts the 0.5% creditable withholding ({formatPesoCentavos(data.simulatedCwtCentavos)} in this period), which Xendit does not take from your balance. Provider fees can differ by a centavo or two from the rounded amounts Xendit posts.</MethodNote>
        <MethodNote label="Refunds, dates and commission">Refunded money is not counted as paid. Online collections and Buyer processing fees exclude their confirmed refunded portions (confirmed online refunds in this period: {formatPesoCentavos(data.onlineRefundsCentavos)}, including refunded Buyer fees); pending or failed refunds remain counted. Estimated remittance cash is collected − refunds − provider charge − CWT for each collection, and a collection that was fully refunded adds no provider charge, CWT or cash. Collections and refunds use the original payment date, and remittance cash uses the assessment date. Physical collections count when recorded, and commission when earned. Cash receipts do not equal taxable income.</MethodNote>
      </div>
    </DashboardPanel>
  </>
}

const PRODUCTS_PER_PAGE = 10

/**
 * Sales value per product and the best sellers for the same orders and dates as Commercial sales, laid out like
 * Product analytics. The products' materials plus delivery equal Commercial sales, so the strip reconciles the list.
 */
function EarningsProducts({ data }: { data: VendorEarnings }) {
  const [page, setPage] = useState(1)
  const { items, total, truncated } = data.products
  const { materialsAfterDiscountCentavos: productValue, deliveryCentavos } = data.breakdown.sales
  const lastPage = Math.max(1, Math.ceil(items.length / PRODUCTS_PER_PAGE))
  const visible = items.slice((Math.min(page, lastPage) - 1) * PRODUCTS_PER_PAGE, Math.min(page, lastPage) * PRODUCTS_PER_PAGE)
  const leader = Math.max(1, ...items.map(item => item.valueCentavos))
  const share = (value: number) => (productValue > 0 ? `${((value / productValue) * 100).toFixed(1)}%` : '—')
  const name = (item: (typeof items)[number]) => (item.listingId ? <Link className="hover:text-action-primary hover:underline" to={`/performance/products/${item.listingId}`}>{item.name}</Link> : item.name)
  const stats: [string, string][] = [['Product sales value', formatPesoCentavos(productValue)], ['Plus delivery', formatPesoCentavos(deliveryCentavos)], ['Equals commercial sales', formatPesoCentavos(data.commercialSalesCentavos)]]
  return <>
    <div className="flex items-center gap-3"><h2 className="text-xs font-semibold uppercase tracking-widest text-action-primary">Products</h2><div className="h-px flex-1 bg-border-default" /></div>
    <div className="grid items-start gap-5 xl:grid-cols-[minmax(0,3fr)_minmax(0,2fr)]">
      <DashboardPanel title="Product sales value" description="What each product sold for in the selected dates, after vendor discounts, VAT included.">
        <div className="grid gap-4">
          <dl aria-label="Product sales value reconciliation" className="grid grid-cols-[repeat(auto-fit,minmax(9rem,1fr))] gap-3">
            {stats.map(([label, amount]) => <div key={label} className="min-w-0 rounded-control bg-surface-canvas px-4 py-3">
              <dt className="text-xs font-semibold text-text-secondary">{label}</dt><dd className="mt-1 break-words text-lg font-semibold tabular-nums text-text-strong">{amount}</dd></div>)}
          </dl>
          {items.length === 0 ? <p className="rounded-control border border-dashed border-border-default px-4 py-6 text-center text-sm text-text-secondary">No product was sold in these dates.</p> : <>
            <div className="overflow-x-auto rounded-control border border-border-default">
              <table className="w-full min-w-[28rem] border-collapse text-sm">
                <caption className="sr-only">Product sales value</caption>
                <thead className="bg-surface-canvas text-xs text-text-secondary"><tr>
                  <th scope="col" className="px-4 py-2.5 text-left font-semibold">Product</th><th scope="col" className="px-4 py-2.5 text-right font-semibold">Orders</th>
                  <th scope="col" className="px-4 py-2.5 text-right font-semibold">Share</th><th scope="col" className="px-4 py-2.5 text-right font-semibold">Sales value</th></tr></thead>
                <tbody>{visible.map(item => <tr key={item.listingId ?? 'unlisted'} className="border-t border-border-default align-top">
                  <th scope="row" className="min-w-0 px-4 py-3 text-left font-normal"><span className="block font-semibold text-text-strong">{name(item)}</span><span className="block text-xs text-text-secondary">{item.category}{item.sku ? ` · SKU ${item.sku}` : ''}</span></th>
                  <td className="whitespace-nowrap px-4 py-3 text-right tabular-nums">{formatCount(item.orders)}</td>
                  <td className="whitespace-nowrap px-4 py-3 text-right tabular-nums text-text-secondary">{share(item.valueCentavos)}</td>
                  <td className="whitespace-nowrap px-4 py-3 text-right font-semibold tabular-nums text-text-strong">{formatPesoCentavos(item.valueCentavos)}</td>
                </tr>)}</tbody>
              </table>
            </div>
            {truncated && <p className="text-xs text-text-secondary">Showing the top {formatCount(items.length)} of {formatCount(total)} products by sales value.</p>}
            {lastPage > 1 && <Pagination page={Math.min(page, lastPage)} lastPage={lastPage} total={items.length} onChange={setPage} />}
          </>}
        </div>
      </DashboardPanel>
      <DashboardPanel title="Top selling products" description="Your best sellers by sales value in the selected dates, to plan stock and pricing.">
        <RankedList label="Top selling products" empty="No product was sold in these dates." items={items.slice(0, 5).map(item => ({ key: item.listingId ?? 'unlisted', label: name(item), title: item.name, meta: item.category,
          value: formatPesoCentavos(item.valueCentavos), detail: `${formatCount(item.orders)} ${item.orders === 1 ? 'order' : 'orders'} · ${share(item.valueCentavos)}`, share: item.valueCentavos / leader }))} />
      </DashboardPanel>
    </div>
  </>
}

function monthName(month: number): string {
  return new Intl.DateTimeFormat('en-PH', { month: 'long' }).format(new Date(2026, Math.max(0, Math.min(11, month - 1)), 1))
}
