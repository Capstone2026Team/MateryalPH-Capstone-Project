import { BackNavigation, openPendingWindow, shouldRotateIdempotencyKey } from '@materyalph/web-ui'
import { DocumentExportButton } from '@materyalph/web-ui'
import { useCallback, useEffect, useRef, useState, type FormEvent, type ReactNode } from 'react'
import { Link, Navigate, useNavigate, useParams, useSearchParams } from 'react-router-dom'
import { Banknote, CreditCard, Download, ExternalLink, History, Landmark, ReceiptText, RefreshCw, ShieldAlert, Wallet } from 'lucide-react'
import {
  ALL_DATES, ActiveFilters, useCommissionPolicyClock, AnalyticsChartCard, AnalyticsSummary, AssessedPaymentBreakdown, Button, CalculationHelp, ChartDataTable, CommissionOrderTable, CommissionRateSummary, ControlBar, DashboardPanel, DateFilter, dateFilterPreset, DemoLabel, DenseLedgerTable, FilterTabs, FinanceAmount, FinanceBreakdownPanel, FinanceDetails, FinancePaymentMethod, FinanceProviderCard, FinanceSection, FinanceSummaryColumns, FinanceTransactionList, FormDialog, Pagination, PaymentAttemptBadge, PaymentChannelList, ShareBar,
  RevealableValue, StatusBadge, StatusMessage, InfoNote, EmptyState, ThresholdPanel, TrendLineChart, WithholdingStatusBadge, FinancePaymentRemittance,
  analyticsDay, formatChartDay, formatChartMonth, formatCompactCentavos, formatCount, formatManilaDateTime, formatPesoCentavos, manilaToday, type DateFilterRange, type TrendSeries, type VizColor,
} from '@materyalph/web-ui'
import {
  channelRows, exportTransactions, getCommissionMonitoring, getEarnings, getFinanceOverview, getStatement, getThresholdPayments, listTransactions, payStatement, readableFinanceError, refreshFeePayment, revealTin, section,
  thresholdData, type FeeStatementDetail, type FinanceRow, type FinanceTab, type PaymentAttempt, type PaymentStatusFilter, type VendorEarnings, type VendorEarningsTrendPoint, type VendorFinanceOverview,
} from '../lib/finance-api'
import { pesoInputToCentavos } from '../lib/orders-api'
import { getVendorOnboarding, newIdempotencyKey } from '../lib/onboarding-api'
import { CommissionTerms } from '../components/CommissionTerms'
import { earningsCalculations } from '../components/earnings-calculations'
import { storeName } from '../lib/catalog-access'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'
import { dateRangeFromParams, dateRangePatch } from '../lib/date-filters'
import { CommissionPaymentSummary } from '@materyalph/web-ui'

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
  return <div className="grid gap-3 mp-card mp-card-padded" role="alert">
    <div className="flex items-start gap-3"><ShieldAlert className="mt-0.5 shrink-0 text-action-primary" size={20} aria-hidden="true" />
      <div><PageHeader eyebrow="Finance" title="Store-wide finance is Owner-only" description="Access depends on your assigned role." />
        <p className="mt-1 text-sm text-text-secondary">Earnings, Transactions, withholding and commission statements and finance exports are available to the Vendor Owner. Order-specific payment status stays visible on each order you can work on.</p></div></div>
    <Link className="text-sm font-semibold text-action-primary underline" to="/orders">Go to Orders</Link>
  </div>
}

type FinanceView = 'overview' | 'commissions' | 'transactions' | 'threshold'

const FINANCE_VIEWS: { value: FinanceView; label: string }[] = [
  { value: 'overview', label: 'Finance overview' }, { value: 'commissions', label: 'Commission monitoring' },
  { value: 'transactions', label: 'Transactions' },
  { value: 'threshold', label: 'Xendit cash revenue & remittance' },
]

function FinanceTabs({ current }: { current: FinanceView }) {
  const navigate = useNavigate()
  const [params] = useSearchParams()
  return <FilterTabs appearance="tabs" label="Finance sections" value={current} chips={FINANCE_VIEWS} onChange={value => {
    if (value === 'commissions' || value === 'transactions') { navigate(`/finance/${value}`); return }
    const next = new URLSearchParams()
    for (const key of ['from', 'to']) { const date = params.get(key); if (date) next.set(key, date) }
    if (value !== 'overview') next.set('section', value)
    navigate({ pathname: '/finance', search: next.toString() })
  }} />
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
  return <FinanceGate activeHref="/finance" permission="portal.wallet">{snapshot => <FinanceOverview canViewEarnings={snapshot.permissions.includes('portal.earnings')} />}</FinanceGate>
}

/** Setup views use one card; the financial overview draws its own cards. */
const settingsPanel = 'min-w-0 mp-card mp-card-padded'

function FinanceOverview({ canViewEarnings, earningsRoute = false }: { canViewEarnings: boolean; earningsRoute?: boolean }) {
  const { data, error, reload } = useLoader(getFinanceOverview)
  const [params] = useSearchParams()
  const requestedSection = params.get('section')
  // Former Xendit links open the combined overview and retain their selected dates.
  const current = requestedSection === 'threshold' ? 'threshold' : 'overview'
  const earningsDates = useEarningsDates()
  if (error) return <div className="grid gap-4"><ErrorState message={error} onRetry={reload} /></div>
  if (!data) return <LoadingState label="Loading finance overview…" />
  const tax = section(data.taxProfile)
  const declaration = section(tax.declaration)
  const arrangement = section(data.withholdingArrangement)
  const withholdingRate = String(arrangement.rate_label ?? '—')
  const withholdingRateSummary = withholdingRate.split(';', 1)[0]?.replace(/\s*\(RR No\.[^)]+\)/g, '').trim() || withholdingRate
  const threshold = thresholdData(data.threshold)
  const remittanceParams = new URLSearchParams({ tab: 'PAYMENTS' })
  const thresholdFrom = data.threshold?.yearStartAt ? manilaToday(data.threshold.yearStartAt) : null
  const thresholdTo = data.threshold?.yearEndAt ? manilaToday(new Date(data.threshold.yearEndAt.getTime() - 1)) : null
  if (thresholdFrom) remittanceParams.set('from', thresholdFrom)
  if (thresholdTo) remittanceParams.set('to', thresholdTo)
  const annualPaymentParams = new URLSearchParams(remittanceParams)
  annualPaymentParams.set('tab', 'PAYMENTS')
  const mandatory = data.notices.filter(notice => notice.mandatory)
  const tin = tax.tin_masked ? <RevealableValue masked={String(tax.tin_masked)} label="TIN" reveal={revealTin} readError={readableFinanceError} /> : 'Not provided'

  return <div className="grid min-w-0 gap-4">
    <PageHeader compact eyebrow="Finance" title={current === 'threshold' ? 'Xendit cash revenue & remittance' : earningsRoute ? 'Earnings' : 'Finance overview'} description={current === 'threshold' ? 'Xendit cash revenue after refunds and withholding, connection details and annual remittance records.' : 'Sales, collections and payment channels in one place.'} actions={canViewEarnings && current === 'overview' ? <>{earningsDates.dates}{earningsDates.exportButton}</> : undefined} />
    <FinanceTabs current={current} />
    {mandatory.length > 0 && <section aria-labelledby="notices-heading" className="grid gap-2">
      <h2 id="notices-heading" className="text-base font-semibold">Required finance notices</h2>
      <ul className="grid gap-2">{mandatory.slice(0, 3).map(notice => <li key={notice.id} className="rounded-control border border-red-300 bg-red-50 p-3 text-sm text-red-900"><p className="font-semibold">{notice.title}</p><p className="mt-1">{notice.body}</p><p className="mt-1 text-xs">{formatManilaDateTime(notice.createdAt)} · Cannot be turned off</p></li>)}</ul>
    </section>}
    <section role="tabpanel" aria-label={FINANCE_VIEWS.find(view => view.value === current)?.label} className="min-w-0">
      {current === 'overview' ? <div className="grid min-w-0 gap-4">
        {canViewEarnings ? <Earnings controls={earningsDates} paymentOverview={data} /> : <FinancePaymentChannels data={data} />}
      </div> : <div className="mp-online-payout-layout">
        <div className={`${settingsPanel} mp-finance-tax-profile`}>
          <FinanceSection id="tax" layout="compact" title="Tax profile" badge={<CalculationHelp title="Tax profile"><p>Collected in Store Verification. Corrections create a new version and never rewrite posted records.</p><p>{withholdingRate}</p><p>The withholding rate applies to qualifying remittances. It is not an extra Buyer charge.</p><p>DEMO — No real funds or BIR filing.</p>{typeof declaration.note === 'string' && <p>{declaration.note}</p>}</CalculationHelp>}>
            {tax.available ? <FinanceDetails appearance="compact" items={[
              ['TIN', tin], ['VAT status', String(tax.vat_category ?? '—').replaceAll('_', ' ')],
              ['Taxable year starts', monthName(Number(tax.fiscal_year_start_month ?? 1))],
              ['Relief declaration', `${String(declaration.status ?? 'NOT_SUBMITTED').replaceAll('_', ' ').toLowerCase()}${declaration.taxable_year ? ` · ${String(declaration.taxable_year)}` : ''}`],
              ['Withholding rate', withholdingRateSummary],
            ]} /> : <StatusMessage tone="info">Your Vendor Tax Profile has no validated taxpayer identity yet. Complete it in Store Verification.</StatusMessage>}
          </FinanceSection>
        </div>
        <div className={`${settingsPanel} mp-threshold-workspace`}>
          {threshold ? <ThresholdPanel data={threshold} layout="overview" showDemoLabel={false} hasApprovedDeclaration={declaration.status === 'APPROVED'}
            paymentBreakdown={threshold.calculationBreakdown && <AssessedPaymentBreakdown load={getThresholdPayments} readError={readableFinanceError}
              historyLink={<Link className="inline-flex min-h-11 items-center font-semibold text-action-primary underline underline-offset-4" to={`/finance/transactions?${annualPaymentParams}`}>View Payments for this taxable year</Link>} />} /> : <StatusMessage tone="info">The threshold panel appears once your tax profile is complete.</StatusMessage>}
        </div>
        <aside className="mp-finance-aside" aria-label="Xendit cash revenue and connection">
          {canViewEarnings ? <OnlinePayout controls={earningsDates} paymentOverview={data} /> : <>
            <StatusMessage tone="info">The Xendit cash revenue estimate requires Earnings access.</StatusMessage>
            <XenditConnection data={data} />
          </>}
        </aside>
      </div>}
    </section>
  </div>
}

function XenditConnection({ data, summary, children }: { data: VendorFinanceOverview; summary?: ReactNode; children?: ReactNode }) {
  const [demoOpen, setDemoOpen] = useState(false)
  const connection = section(data.xenditConnection)
  return <>
    <FinanceProviderCard title="Xendit connection" summary={summary} status={<StatusBadge label={String(connection.label ?? 'Not connected')} tone={connection.status === 'CONNECTED_TEST' ? 'success' : 'warning'} />}
      items={[
        ['Provider', 'Xendit Sandbox'], ['Environment', 'TEST'],
        ['Last reconciled', formatManilaDateTime(connection.last_reconciled_at as string | null)],
      ]} note={<>{typeof connection.note === 'string' && <>{connection.note.replace(/\bbalances?\b/gi, 'funds')} </>}Available funds and withdrawals stay in your Xendit dashboard.</>}
      action={<Button variant="secondary" aria-haspopup="dialog" onClick={() => setDemoOpen(true)}><ExternalLink size={16} aria-hidden="true" />Open Xendit account (demo)</Button>}>
      {children}
    </FinanceProviderCard>
    {demoOpen && <FormDialog open title="Xendit account demo" description="Demo shortcut · Xendit TEST mode" size="small" onClose={() => setDemoOpen(false)}
      footer={<div className="flex justify-end"><Button onClick={() => setDemoOpen(false)}>Got it</Button></div>}>
      <p className="text-sm leading-6 text-text-secondary">This previews the Xendit account shortcut. Account access is simulated while MateryalPH uses Xendit TEST mode.</p>
    </FormDialog>}
  </>
}

function FinancePaymentChannels({ data }: { data: VendorFinanceOverview }) {
  const online = section(data.onlineChannels)
  return <DashboardPanel density="compact" title="Online payment channels" description={typeof online.fee_note === 'string' ? online.fee_note : 'Configured channels and published DEMO rates.'}>
    <PaymentChannelList layout="grid" caption="Configured online channels" channels={channelRows(online.channels)} />
  </DashboardPanel>
}

export function VendorCommissionPage() {
  return <FinanceGate activeHref="/finance" permission="portal.wallet">{(_, publish) => <CommissionMonitoring onSnapshotSaved={publish} />}</FinanceGate>
}

const COMMISSION_BILLING_HELP = [
  { title: 'Not yet billed', description: 'Commission from completed orders that has not yet been added to a monthly bill. Approved fee reductions are already deducted. Estimates from unfinished orders are excluded.' },
  { title: 'Draft bills awaiting issue', description: 'Commission bills that have been prepared but have not yet been issued. They appear in Unpaid statements after issue while an amount remains due.' },
  { title: 'Approved commission credits', description: 'Approved reductions to commission already charged, such as adjustments for returned materials. A credit reduces your commission fee. Any cash refund is recorded separately under Completed refunds in the payment panels.' },
  { title: 'Unpaid statements', description: 'All issued bills still due, including earlier months and years. These balances carry forward when the payment totals reset.' },
  { title: 'Overdue', description: 'The part of unpaid statements past its due date. It is already included in Unpaid statements, not an extra charge.' },
  { title: 'Estimated commission', description: 'Accepted orders awaiting completion. These are estimates, not paid commission, and do not enter the annual or monthly payment totals.' },
]

function CommissionMonitoring({ onSnapshotSaved }: { onSnapshotSaved: (snapshot: Snapshot) => void }) {
  const [page, setPage] = useState(1)
  const [statementRefresh, setStatementRefresh] = useState(0)
  const [termsOpen, setTermsOpen] = useState(false)
  const [paymentHistoryOpen, setPaymentHistoryOpen] = useState(false)
  const result = useLoader(() => getCommissionMonitoring(page), String(page))
  const data = result.data?.monitoring
  const refreshAt = [data?.nextPolicy?.effectiveFrom, data?.monthlyPayments.resetsAt].filter((date): date is Date => date != null).sort((a, b) => a.valueOf() - b.valueOf())[0]
  useCommissionPolicyClock(refreshAt, result.reload)
  const total = data?.summary
  return <div className="mp-commission-monitoring grid min-w-0 gap-4">
    <PageHeader compact eyebrow="Finance" title="Commission monitoring" description="Review commission charges, monthly bills and payments." actions={<Button variant="outline" onClick={() => { result.reload(); setStatementRefresh(value => value + 1) }}><RefreshCw size={16} aria-hidden="true" />Refresh</Button>} />
    <FinanceTabs current="commissions" />
    {result.error ? <ErrorState message={result.error} onRetry={result.reload} /> : !data || !total ? <LoadingState label="Loading commission monitoring…" /> : <>
      {!data.termsAccepted && <StatusMessage tone="info">Review and accept the current Commission Terms before new transactions use this rate. Existing orders keep their saved rate.</StatusMessage>}
      <CommissionRateSummary rateLabel={data.currentPolicy?.rateLabel} effectiveFrom={data.currentPolicy?.effectiveFrom} nextRateLabel={data.nextPolicy?.rateLabel} nextEffectiveFrom={data.nextPolicy?.effectiveFrom}
        actions={<Button variant="outline" aria-haspopup="dialog" onClick={() => setTermsOpen(true)}>Review Commission Terms</Button>} />
      <div className="mp-commission-panels">
      <CommissionPaymentSummary title="Annual total commission payment" annual period={data.annualPayments}
        action={<Button variant="outline" aria-haspopup="dialog" onClick={() => setPaymentHistoryOpen(true)}><History size={16} aria-hidden="true" />Annual history</Button>} />
      <CommissionPaymentSummary title="Monthly commission payment" period={data.monthlyPayments} />
      <CommissionStatementsPanel refreshToken={statementRefresh} />
      </div>
      <DashboardPanel density="compact" title="Current commission balances" description="All billing periods · unpaid amounts carry forward. Payment totals above reset; outstanding bills do not."
        calculation={<>{COMMISSION_BILLING_HELP.map(item => <section key={item.title}><h4 className="font-semibold text-text-strong">{item.title}</h4><p className="mt-1">{item.description}</p></section>)}</>}
        footer={<a className="inline-flex min-h-11 items-center gap-2 text-sm font-semibold text-action-primary underline underline-offset-4" href="#commission-statements"><ReceiptText size={16} aria-hidden="true" />View and pay commission statements</a>}>
        <FinanceSummaryColumns>
          <FinanceBreakdownPanel title="Billing" caption="Commission billing" rows={[
            { key: 'unbilled', label: 'Not yet billed', amount: formatPesoCentavos(total.unbilledCentavos) },
            { key: 'draft', label: 'Draft bills awaiting issue', amount: formatPesoCentavos(total.draftCentavos) },
            { key: 'credits', label: 'Approved commission credits', amount: formatPesoCentavos(total.creditedCentavos) },
          ]} />
          <FinanceBreakdownPanel title="Due amounts and estimates" caption="Current commission obligations" rows={[
            { key: 'outstanding', label: 'Unpaid statements', amount: formatPesoCentavos(total.outstandingCentavos), total: true },
            { key: 'overdue', label: 'Overdue (included above)', amount: formatPesoCentavos(total.overdueCentavos) },
            { key: 'estimated', label: 'Estimated commission', amount: formatPesoCentavos(total.estimatedCentavos) },
          ]} />
        </FinanceSummaryColumns>
      </DashboardPanel>
      <DashboardPanel density="compact" title="Commission by order" description="Materials value is after discounts, excluding VAT and delivery. Final commission = commission charged − approved fee reductions. Each order keeps its original rate."
        footer={(page > 1 || result.data?.hasMore) ? <Pagination page={page} hasMore={result.data?.hasMore ?? false} onChange={setPage} /> : undefined}>
        {data.assessments.length === 0 ? <p className="py-3 text-sm text-text-secondary">No commission assessments yet. An estimate appears when an order is accepted; the fee is charged at completion.</p> : <CommissionOrderTable rows={data.assessments} />}
      </DashboardPanel>
    </>}
    {termsOpen && <CommissionTermsDialog onClose={() => setTermsOpen(false)} onSaved={snapshot => { onSnapshotSaved(snapshot); result.reload() }} />}
    {paymentHistoryOpen && <AnnualCommissionPaymentHistory onClose={() => setPaymentHistoryOpen(false)} />}
  </div>
}

function AnnualCommissionPaymentHistory({ onClose }: { onClose: () => void }) {
  const [page, setPage] = useState(1)
  const result = useLoader(() => getCommissionMonitoring(1, page), String(page))
  const history = result.data?.monitoring.paymentHistory
  return <FormDialog open size="compact" title="Annual total commission payment history" description="Completed calendar years, using Philippine time. Original payments and completed refunds are retained when a new year starts." onClose={onClose}
    bodyClassName="mp-commission-history min-h-0 overflow-y-auto overscroll-contain px-5 py-4 sm:px-6"
    footer={history && (page > 1 || history.hasMore) ? <Pagination page={page} hasMore={history.hasMore} onChange={setPage} /> : null}>
    {result.error ? <ErrorState message={result.error} onRetry={result.reload} /> : !history ? <LoadingState label="Loading annual commission payment history…" /> : history.items.length === 0 ? <p className="py-3 text-sm text-text-secondary">No completed years with commission payments or refunds yet. This year will appear here when the new year starts.</p> :
      <DenseLedgerTable compact responsive caption="Annual commission payment history" rows={history.items} rowKey={row => row.label} columns={[
        { key: 'year', header: 'Year', cell: row => row.label },
        { key: 'collected', header: 'Payments', className: 'tabular-nums', cell: row => formatPesoCentavos(row.collectedCentavos) },
        { key: 'refunded', header: 'Refunds', className: 'tabular-nums', cell: row => formatPesoCentavos(-row.refundedCentavos || 0) },
        { key: 'net', header: 'Net paid', className: 'tabular-nums font-semibold', cell: row => formatPesoCentavos(row.netCollectedCentavos) },
      ]} />}
    <p className="mt-3 text-xs leading-5 text-text-secondary">Payments − completed refunds = net paid commission. Refunds belong to the year they complete; they do not rewrite the original payment year.</p>
  </FormDialog>
}

function StatementState({ state, overdue = false }: { state: string; overdue?: boolean }) {
  return <StatusBadge label={overdue ? 'Overdue' : state === 'PAID' ? 'Paid' : state === 'PARTIALLY_PAID' ? 'Partly paid' : state === 'VOIDED' ? 'Voided' : 'Unpaid'} tone={overdue ? 'error' : state === 'PAID' ? 'success' : state === 'PARTIALLY_PAID' ? 'warning' : state === 'VOIDED' ? 'neutral' : 'info'} />
}

function CommissionStatementsPanel({ refreshToken }: { refreshToken: number }) {
  const [params, setParams] = useSearchParams()
  const page = Math.max(1, Number(params.get('statement_page') ?? '1') || 1)
  const result = useLoader(() => listTransactions('STATEMENTS', page, { statementState: 'NOT_PAID' }), JSON.stringify([page, refreshToken]))
  const historyOpen = params.get('statement_history') === '1'
  const showHistory = (open: boolean) => setParams(current => {
    const next = new URLSearchParams(current)
    if (open) next.set('statement_history', '1'); else next.delete('statement_history')
    return next
  }, { replace: true })
  const search = params.toString()
  return <div id="commission-statements" className="mp-commission-statements">
    <DashboardPanel density="compact" title="Commission statements" description="Monthly bills and amounts due."
      action={<Button variant="outline" aria-haspopup="dialog" onClick={() => showHistory(true)}><History size={16} aria-hidden="true" />History</Button>}
      footer={(page > 1 || result.data?.hasMore || Boolean(result.data?.items.length)) ? <div className="grid gap-2 py-2">
        {Boolean(result.data?.items.length) && <CommissionStatementExports state="NOT_PAID" />}
        {(page > 1 || result.data?.hasMore) && <Pagination page={page} hasMore={result.data?.hasMore ?? false} onChange={next => setParams(current => { const updated = new URLSearchParams(current); updated.set('statement_page', String(next)); return updated }, { replace: true })} />}
      </div> : undefined}>
      {result.error ? <ErrorState message={result.error} onRetry={result.reload} /> : !result.data ? <LoadingState label="Loading commission statements…" /> : result.data.items.length === 0 ? <p className="py-3 text-sm text-text-secondary">No unpaid commission statements. View paid bills in History.</p> :
        <ul className="mp-commission-statement-list" aria-label="Published commission statements" tabIndex={0}>{result.data.items.map(row => <li key={String(row.id)}>
          <Link className="mp-commission-statement-link" to={`/finance/statements/${String(row.id)}${search ? `?${search}` : ''}`}><span>{String(row.reference)}</span><strong>{formatPesoCentavos(Number(row.outstanding_centavos))}<span className="sr-only"> due</span></strong></Link>
          <div className="mp-commission-statement-meta"><span>{formatChartMonth(String(row.period_start))} · Due {String(row.due_on)}</span><StatementState state={String(row.state)} overdue={Boolean(row.overdue)} /></div>
        </li>)}</ul>}
    </DashboardPanel>
    {historyOpen && <CommissionStatementHistory refreshToken={refreshToken} onClose={() => showHistory(false)} />}
  </div>
}

function CommissionStatementExports({ state, range = ALL_DATES }: { state: 'PAID' | 'NOT_PAID'; range?: DateFilterRange }) {
  const filters = { tab: 'STATEMENTS', statement_state: state, ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }
  return <div className="flex flex-wrap gap-2">
    <DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="vendor" types={['TRANSACTION_HISTORY']} filters={filters} title="Commission statements" />
    <DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="vendor" types={['TRANSACTION_HISTORY']} format="CSV" filters={filters} title="Commission statements" />
  </div>
}

function CommissionStatementHistory({ refreshToken, onClose }: { refreshToken: number; onClose: () => void }) {
  const [params, setParams] = useSearchParams()
  const page = Math.max(1, Number(params.get('history_page') ?? '1') || 1)
  const range = params.has('from') || params.has('to') ? dateRangeFromParams(params) : ALL_DATES
  const filters = { statementState: 'PAID' as const, ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }
  const result = useLoader(() => listTransactions('STATEMENTS', page, filters), JSON.stringify([page, range.from, range.to, refreshToken]))
  const update = (patch: Record<string, string>) => setParams(current => {
    const next = new URLSearchParams(current)
    for (const [key, value] of Object.entries(patch)) { if (value) next.set(key, value); else next.delete(key) }
    if (!('history_page' in patch)) next.delete('history_page')
    return next
  }, { replace: true })
  const search = params.toString()
  return <FormDialog open size="compact" initialFocus="title" title="Commission statement history" description="Fully paid commission statements. Filter by statement issue date." onClose={onClose}
    bodyClassName="mp-commission-history min-h-0 overflow-y-auto overscroll-contain px-5 py-4 sm:px-6"
    headerDetails={<DateFilter title="Statement issue dates" value={range} onChange={next => update(dateRangePatch(next))} />}
    footer={result.data && (result.data.items.length > 0 || page > 1) ? <div className="grid gap-3">
      {result.data.items.length > 0 && <CommissionStatementExports state="PAID" range={range} />}
      {(page > 1 || result.data.hasMore) && <Pagination page={page} hasMore={result.data.hasMore} onChange={next => update({ history_page: String(next) })} />}
    </div> : null}>
    {result.error ? <ErrorState message={result.error} onRetry={result.reload} /> : !result.data ? <LoadingState label="Loading paid commission statements…" /> : result.data.items.length === 0 ? <p className="py-3 text-sm text-text-secondary">{range.from || range.to ? 'No paid commission statements in these dates.' : 'No paid commission statements yet.'}</p> :
      <DenseLedgerTable<FinanceRow & { key: string }> compact responsive caption="Paid commission statements" rowKey={row => row.key} rows={result.data.items.map(row => ({ ...row, key: String(row.id) }))} columns={[
        { key: 'reference', header: 'Statement', cell: row => <div className="grid gap-1"><Link className="inline-flex min-h-11 items-center break-all font-semibold text-action-primary underline underline-offset-4" to={`/finance/statements/${String(row.id)}?${search}`}>{String(row.reference)}</Link><span className="text-xs text-text-secondary">{formatChartMonth(String(row.period_start))}</span></div> },
        { key: 'issued', header: 'Issued', cell: row => String(row.issued_on) },
        { key: 'paid', header: 'Amount paid', headerClassName: 'text-right', className: 'text-right tabular-nums font-semibold', cell: row => formatPesoCentavos(Number(row.paid_centavos)) },
      ]} />}
  </FormDialog>
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

// ── Transactions ─────────────────────────────────────────────────────────────────────────

const TABS: { value: FinanceTab; label: string }[] = [
  { value: 'PAYMENTS', label: 'Payments' },
  { value: 'TAX_DOCUMENTS', label: 'Tax documents' },
]
const EMPTY: Record<FinanceTab, string> = {
  PAYMENTS: 'No payments yet. Online payments and Cash on Delivery or In-Store orders appear here.', PHYSICAL: 'No Cash on Delivery or In-Store records yet.',
  REMITTANCES: 'No simulated remittance assessments yet. They appear after verified collections.', STATEMENTS: 'No issued commission statements yet. Statements are drafted on the first of each month.',
  REFUNDS: 'No refunds or adjustments.', TAX_DOCUMENTS: 'No tax documents. Sample certificates are watermarked and never official.',
}

/** Labels match the badge each Payments row shows, so the dropdown and the table read the same. */
const PAYMENT_STATUSES: { value: PaymentStatusFilter; label: string }[] = [
  { value: 'PAID', label: 'Paid — verified by provider' }, { value: 'PAID_REFUNDED', label: 'Paid — refunded' }, { value: 'PAID_PARTIALLY_REFUNDED', label: 'Paid — partially refunded' },
  { value: 'PAID_REFUND_PENDING', label: 'Paid — refund pending' }, { value: 'PAID_REFUND_FAILED', label: 'Paid — refund failed' }, { value: 'PENDING', label: 'Pending verification' },
  { value: 'FAILED', label: 'Failed — not charged' }, { value: 'EXPIRED', label: 'Expired — not charged' }, { value: 'LATE_CAPTURE', label: 'Late capture' },
  { value: 'PHYSICAL_COLLECTED', label: 'Cash — collected (Vendor record)' }, { value: 'PHYSICAL_PARTIAL', label: 'Cash — partially collected' },
  { value: 'PHYSICAL_TO_RECORD', label: 'Cash — handed over, not recorded' }, { value: 'PHYSICAL_AWAITING', label: 'Cash — awaiting delivery or pickup' },
  { value: 'PHYSICAL_RELEASED', label: 'Cash — not collected, order cancelled' },
]

export function VendorTransactionHistoryPage() {
  const [params] = useSearchParams()
  if (params.get('tab') === 'REMITTANCES') {
    const next = new URLSearchParams(params)
    next.set('tab', 'PAYMENTS')
    return <Navigate replace to={{ pathname: '/finance/transactions', search: next.toString() }} />
  }
  if (params.get('tab') === 'STATEMENTS') {
    const next = new URLSearchParams(params)
    next.delete('tab')
    if (next.has('page')) { next.set('statement_page', next.get('page')!); next.delete('page') }
    return <Navigate replace to={{ pathname: '/finance/commissions', search: next.toString(), hash: '#commission-statements' }} />
  }
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
  return <div className="grid min-w-0 gap-4">
    <PageHeader compact eyebrow="Finance" title="Transactions" description="Review payments with their remittances and withholding tax in one list." />
    <FinanceTabs current="transactions" />
    <ControlBar tabs={tabs.length > 1 ? <FilterTabs label="Transaction type" chips={tabs} value={tab} onChange={value => update({ tab: value, status: '' })} /> : undefined} actions={<>
      <DateFilter title={tab === 'TAX_DOCUMENTS' ? 'Tax period end dates' : 'Transaction dates'} value={range} onChange={next => update(dateRangePatch(next))} />
      {tab === 'PAYMENTS' && <label className="flex min-w-0 items-center gap-2 text-sm font-semibold">Status
        <select className="min-h-11 min-w-0 max-w-full rounded-control border border-border-default bg-surface-primary px-3 text-sm font-normal" value={status?.value ?? ''} onChange={event => update({ status: event.target.value })}>
          <option value="">All statuses</option>
          {PAYMENT_STATUSES.map(item => <option key={item.value} value={item.value}>{item.label}</option>)}
        </select>
      </label>}
      <DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="vendor" types={['TRANSACTION_HISTORY']} filters={{ tab, ...filters }} title="Transactions" />
      <Button variant="secondary" disabled={exporting || !rows || rows.length === 0} onClick={() => void download()}><Download size={16} aria-hidden="true" />{exporting ? 'Preparing…' : 'Export CSV'}</Button>
    </>} />
    <ActiveFilters filters={[
      ...(status ? [{ key: 'status', label: status.label, onRemove: () => update({ status: '' }) }] : []),
    ]} onClear={() => update({ ...dateRangePatch(dateFilterPreset(30)), status: '' })} />
    <InfoNote>Use your authorized Xendit dashboard for available funds and money withdrawals.</InfoNote>
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
      : rows === null ? <LoadingState label="Loading records…" />
        : rows.length === 0 ? <EmptyState icon={<Wallet size={24} aria-hidden="true" />} message={EMPTY[tab]} action={<Button variant="secondary" onClick={() => setAttempt(value => value + 1)}>Retry</Button>} />
          : <TransactionTable tab={tab} rows={rows} />}
    {(page > 1 || hasMore) && <Pagination page={page} hasMore={hasMore} busy={rows === null} onChange={next => update({ page: String(next) })} />}
  </div>
}

type Column = { header: string; cell: (row: FinanceRow) => ReactNode; numeric?: boolean }
const nullableAmount = (value: unknown): number | null => value === null || value === undefined ? null : Number(value)
const money = (key: string, deduction = false, total = false): Column['cell'] => row => <FinanceAmount centavos={row[key] === null || row[key] === undefined ? null : Number(row[key])} deduction={deduction} total={total} />
const text = (key: string): Column['cell'] => row => String(row[key] ?? '—').replaceAll('_', ' ')
const transactionLabels: Record<string, string> = {
  FULL_ORDER_PAYMENT: 'Full order payment', NRPC_ASSURANCE_PAYMENT: 'NRPC assurance payment', REMAINING_BALANCE_PAYMENT: 'Remaining balance payment',
  CASH_ON_DELIVERY: 'Cash on Delivery', IN_STORE_PAYMENT: 'In-Store payment', XENDIT_TEST: 'Xendit TEST', SIMULATED: 'Simulated',
  VENDOR_RECORD: 'Vendor record', SIMULATED_WITHHELD: 'Simulated withheld',
}
const transactionLabel = (value: unknown) => value === null || value === undefined || value === '' ? '—' : transactionLabels[String(value)] ?? String(value).replaceAll('_', ' ').toLowerCase().replace(/^./, letter => letter.toUpperCase())
/** The order reference, opening the order when the record belongs to one. */
const orderLink: Column['cell'] = row => row.order_id ? <Link className="mp-finance-order-link" to={`/orders/${String(row.order_id)}`}>{String(row.reference)}</Link> : text('reference')(row)
const transactionDate: Column['cell'] = row => <time dateTime={typeof row.at === 'string' ? row.at : undefined}>{formatManilaDateTime(row.at as string).replace(' (Asia/Manila)', '').replace(/ (AM|PM)$/, '\u00a0$1')}</time>

const COLUMNS: Record<FinanceTab, Column[]> = {
  PAYMENTS: [
    { header: 'Order', cell: row => <div className="mp-finance-record">{orderLink(row)}<FinancePaymentMethod kind={row.kind === 'PHYSICAL' ? 'PHYSICAL' : row.kind === 'REMITTANCE' ? 'REMITTANCE' : 'ONLINE'} /><span className="mp-finance-record-note">{row.kind === 'REMITTANCE' ? 'Historical assessment without a linked payment' : transactionLabel(row.purpose)}</span><span className="mp-finance-record-note">{transactionDate(row)} · Asia/Manila</span></div> },
    { header: 'Status', cell: row => <div className="mp-finance-record">{row.kind === 'REMITTANCE' ? <StatusBadge label="Assessment recorded" tone="info" /> : <PaymentAttemptBadge status={String(row.status)} refundStatus={String(row.refund_state ?? 'NOT_REQUESTED')} />}<span className="mp-finance-record-note">{row.kind === 'PHYSICAL' ? `${row.channel === 'IN_STORE' ? 'In-Store' : 'COD'} · Vendor record` : transactionLabel(row.evidence_origin)}</span></div> },
    { header: 'Gross', cell: money('gross_centavos'), numeric: true },
    { header: 'Refunded', cell: money('refunded_centavos', true), numeric: true },
    { header: 'Net collected', cell: row => <div className="mp-finance-record mp-finance-record-numeric">{money('net_collected_centavos', false, true)(row)}
      {row.kind === 'PHYSICAL' && (row.status === 'PHYSICAL_RELEASED' ? <span className="mp-finance-record-note">No longer due</span> : Number(row.remaining_centavos) > 0 ? <span className="mp-finance-record-note">{money('remaining_centavos')(row)} still owed</span> : null)}</div>, numeric: true },
    { header: 'Remittance & tax', cell: row => <FinancePaymentRemittance reference={String(row.reference)} physical={row.kind === 'PHYSICAL'} assessment={row.assessment_id ? {
      calculationState: String(row.calculation_state), grossBasisCentavos: nullableAmount(row.gross_basis_centavos), withheldCentavos: nullableAmount(row.withheld_centavos), expectedCashCentavos: nullableAmount(row.expected_cash_centavos),
      orderAfterRefundsCentavos: nullableAmount(row.order_after_refunds_centavos), netRemittanceCentavos: nullableAmount(row.net_remittance_centavos),
      orderPaymentCentavos: nullableAmount(row.gross_centavos), principalRefundsCentavos: nullableAmount(row.refunded_centavos),
      collectedCentavos: nullableAmount(row.assessment_collected_centavos), refundsCentavos: nullableAmount(row.assessment_refunds_centavos), providerChargeCentavos: nullableAmount(row.provider_charge_centavos),
      deliveryCentavos: nullableAmount(row.assessment_delivery_centavos), materialVatCentavos: nullableAmount(row.assessment_vat_centavos), effectiveRateBasisPoints: nullableAmount(row.assessment_rate_basis_points),
      thresholdStatus: String(row.threshold_status_after ?? ''), deductionEvidence: String(row.deduction_evidence_state ?? ''), reconciliationState: String(row.reconciliation_state ?? ''), at: row.assessment_at as string | null,
    } : null} /> },
  ],
  PHYSICAL: [{ header: 'Order', cell: orderLink }, { header: 'Record', cell: text('kind') }, { header: 'Amount', cell: money('amount_centavos'), numeric: true }, { header: 'Remaining', cell: money('remaining_centavos'), numeric: true },
    { header: 'Source', cell: text('evidence_origin') }, { header: 'Buyer acknowledged', cell: row => row.buyer_acknowledged ? 'Yes' : 'No' }, { header: 'Date', cell: row => formatManilaDateTime(row.at as string) }],
  REMITTANCES: [
    { header: 'Order', cell: row => <div className="mp-finance-record">{orderLink(row)}<span className="mp-finance-record-note">{formatManilaDateTime(row.at as string)}</span></div> },
    { header: 'Collected', cell: money('collected_centavos'), numeric: true },
    { header: 'Deductions', cell: row => <dl className="mp-finance-deductions">
      {Number(row.refunds_centavos) > 0 && <div><dt>Refunds</dt><dd>{money('refunds_centavos', true)(row)}</dd></div>}
      <div><dt>Provider charge</dt><dd>{money('provider_charge_centavos', true)(row)}</dd></div>
      <div><dt>Withholding tax</dt><dd>{money('withheld_centavos', true)(row)}</dd></div>
    </dl> },
    { header: 'Expected cash', cell: row => <div className="mp-finance-record mp-finance-record-numeric">{money('expected_cash_centavos', false, true)(row)}{row.calculation_state === 'VOIDED' && <span className="mp-finance-record-note">Original assessment · voided</span>}</div>, numeric: true },
    { header: 'Taxable remittance', cell: row => <div className="mp-finance-record mp-finance-record-numeric">{money('gross_basis_centavos')(row)}<span className="mp-finance-record-note">Withholding basis</span></div>, numeric: true },
    { header: 'Assessment', cell: row => <div className="mp-finance-record">{row.calculation_state === 'VOIDED' ? <StatusBadge label="Voided — fully refunded" icon={<History size={14} aria-hidden="true" />} />
      : row.calculation_state === 'BASE_REVIEW_REQUIRED' ? <StatusBadge label="Calculation needs review" tone="warning" icon={<ShieldAlert size={14} aria-hidden="true" />} />
        : <WithholdingStatusBadge status={String(row.threshold_status_after)} />}
      <span className="mp-finance-record-note">{transactionLabel(row.deduction_evidence_state)} · DEMO</span></div> },
  ],
  STATEMENTS: [{ header: 'Statement', cell: row => <Link className="font-semibold text-action-primary underline" to={`/finance/statements/${String(row.id)}`}>{String(row.reference)}</Link> },
    { header: 'Period', cell: row => `${String(row.period_start)} – ${String(row.period_end)}` }, { header: 'State', cell: row => `${String(row.state).replaceAll('_', ' ')}${row.overdue ? ' · overdue' : ''}` },
    { header: 'Charges', cell: money('charges_centavos'), numeric: true }, { header: 'Credits', cell: money('credits_centavos'), numeric: true }, { header: 'Outstanding', cell: money('outstanding_centavos'), numeric: true }, { header: 'Due', cell: text('due_on') }],
  REFUNDS: [{ header: 'Order', cell: orderLink }, { header: 'Trigger', cell: text('trigger') }, { header: 'Amount', cell: money('amount_centavos'), numeric: true }, { header: 'State', cell: text('state') }, { header: 'Date', cell: row => formatManilaDateTime(row.at as string) }],
  TAX_DOCUMENTS: [{ header: 'Type', cell: text('certificate_type') }, { header: 'Issuer', cell: text('issuer') }, { header: 'Period', cell: row => `${String(row.period_start)} – ${String(row.period_end)}` }, { header: 'Tax', cell: money('tax_centavos'), numeric: true }, { header: 'Verification', cell: text('verification_state') }],
}

function TransactionTable({ tab, rows }: { tab: FinanceTab; rows: FinanceRow[] }) {
  const columns = COLUMNS[tab]
  return <FinanceTransactionList caption={TABS.find(item => item.value === tab)?.label ?? transactionLabel(tab)}
    hint={tab === 'PAYMENTS' ? 'Payments and recorded tax assessments together. Commission is billed separately.' : undefined}
    rows={rows} rowKey={row => `${String(row.kind ?? tab)}:${String(row.id)}`} paymentKind={tab === 'PAYMENTS' ? row => row.kind === 'PHYSICAL' ? 'PHYSICAL' : 'ONLINE' : undefined}
    columns={columns.map(column => ({ key: column.header, header: column.header, cell: column.cell, ...(column.numeric ? { className: 'text-right', headerClassName: 'text-right' } : {}) }))} />
}

// ── Statement detail and platform-fee payment ────────────────────────────────────────────────────

export function VendorStatementPage() {
  const { statementId = '' } = useParams()
  return <FinanceGate activeHref="/finance" permission="portal.wallet">{() => <StatementDetail statementId={statementId} />}</FinanceGate>
}

function StatementDetail({ statementId }: { statementId: string }) {
  const { data, setData, error, reload } = useLoader(() => getStatement(statementId), statementId)
  if (error) return <div className="grid gap-4"><BackToStatements /><ErrorState message={error} onRetry={reload} /></div>
  if (!data) return <div className="grid gap-4"><BackToStatements /><LoadingState label="Loading statement…" /></div>
  const payable = ['ISSUED', 'PARTIALLY_PAID'].includes(data.state) && data.outstandingCentavos > 0
  return <div className="mp-statement-detail grid min-w-0 gap-4">
    <BackToStatements />
    <PageHeader compact eyebrow="Commission statement" title={data.reference} description={`${data.periodStart} to ${data.periodEnd} · Due ${data.dueOn} (end of day, Asia/Manila).`} actions={<><StatementState state={data.state} overdue={data.overdue} /><DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="vendor" types={['FEE_STATEMENT']} resourceId={statementId} title={data.reference} /></>} />
    <div><DemoLabel>{data.sampleNotice}</DemoLabel></div>
    <AnalyticsSummary density="compact" title="Statement summary" featured={{ label: 'Amount due', value: formatPesoCentavos(data.outstandingCentavos), hint: `Due ${data.dueOn}` }} metrics={[
      { label: 'Commission charged', value: formatPesoCentavos(data.chargesCentavos), hint: 'Before approved fee reductions' },
      { label: 'Fee reductions', value: formatPesoCentavos(data.creditsCentavos), hint: 'Approved commission credits' },
      { label: 'Payments received', value: formatPesoCentavos(data.paidCentavos), hint: 'Verified statement payments' },
    ]} />
    {data.disputedHeldCentavos > 0 && <StatusMessage tone="info">{formatPesoCentavos(data.disputedHeldCentavos)} is held for disputes and is separate from the collectible amount due.</StatusMessage>}
    {!payable && <StatusMessage tone={data.state === 'PAID' ? 'success' : 'info'}>{data.state === 'PAID' ? 'Statement settled. No payment is due.' : data.state === 'VOIDED' ? 'This statement was voided. No payment is due.' : 'No payment is currently due.'}</StatusMessage>}
    <div className={payable ? 'mp-statement-layout' : 'grid min-w-0 gap-4'}>
      <div className="grid min-w-0 content-start gap-4">
        <DashboardPanel density="compact" title="Statement breakdown" description="Original order rates and approved fee reductions.">
          {data.lines.length === 0 ? <p className="py-3 text-sm text-text-secondary">No statement lines are available.</p> : <div className="mp-statement-lines" role="region" aria-label="Statement line items" tabIndex={0}><DenseLedgerTable<FinanceRow & { key: string }> responsive compact caption="Statement breakdown" rows={data.lines.map((line, index) => ({ ...section(line), key: String(index) }))} rowKey={row => row.key} columns={[
            { key: 'description', header: 'Order / description', cell: row => <div className="grid gap-1"><span className="font-semibold">{String(row.order_reference ?? row.description)}</span>{Boolean(row.order_reference) && <span className="text-xs text-text-secondary">{String(row.description)}</span>}</div> },
            { key: 'basis', header: 'Materials value', headerClassName: 'text-right', className: 'text-right tabular-nums', cell: row => row.basis_centavos == null ? '—' : formatPesoCentavos(Number(row.basis_centavos)) },
            { key: 'rate', header: 'Commission rate', headerClassName: 'text-right', className: 'text-right tabular-nums', cell: row => row.commission_basis_points == null ? '—' : `${(Number(row.commission_basis_points) / 100).toFixed(2)}%` },
            { key: 'amount', header: 'Amount', headerClassName: 'text-right', className: 'text-right font-semibold tabular-nums', cell: row => formatPesoCentavos(['CREDIT', 'CREDIT_TRANSFER'].includes(String(row.type)) && Number(row.amount_centavos) !== 0 ? -Number(row.amount_centavos) : Number(row.amount_centavos)) },
          ]} /></div>}
        </DashboardPanel>
        <PaymentHistory payments={data.payments} onUpdated={updated => setData({ ...data, payments: data.payments.map(item => item.id === updated.id ? updated : item) })} />
      </div>
      {payable && <aside aria-label="Pay statement" className="min-w-0"><PayStatementForm statement={data} onStarted={() => reload()} /></aside>}
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
  const key = useRef(newIdempotencyKey())
  const [checkoutUrl, setCheckoutUrl] = useState<string | null>(null)
  // Each provider attempt has a separate key; unknown transport outcomes retain the current one.
  const attemptState = statement.payments.map(payment => `${payment.id}:${payment.status}`).join('|')
  const previousState = useRef(attemptState)
  const pendingAttempt = statement.payments.some(payment => payment.status === 'PENDING')
  useEffect(() => {
    if (previousState.current === attemptState) return
    previousState.current = attemptState
    if (!pendingAttempt) key.current = newIdempotencyKey()
  }, [attemptState, pendingAttempt])
  const open = statement.payments.find(payment => payment.status === 'PENDING')
  async function submit(event: FormEvent) {
    event.preventDefault()
    setError(null)
    const centavos = installment ? pesoInputToCentavos(amount) : null
    if (installment && (centavos === null || centavos < 1 || centavos > statement.outstandingCentavos)) { setError(`Enter an amount from ₱0.01 to ${formatPesoCentavos(statement.outstandingCentavos)}.`); return }
    const tab = openPendingWindow()
    setBusy(true)
    try {
      const attempt = await payStatement(statement.id, channel, centavos, key.current)
      setCheckoutUrl(attempt.checkoutUrl ?? null)
      if (attempt.checkoutUrl && tab && !tab.closed) tab.location.replace(attempt.checkoutUrl)
      else if (!attempt.checkoutUrl) tab?.close()
      onStarted()
    } catch (cause) { tab?.close(); if (shouldRotateIdempotencyKey(cause)) key.current = newIdempotencyKey(); setError(await readableFinanceError(cause)) }
    finally { setBusy(false) }
  }
  const fallback = checkoutUrl && <a href={checkoutUrl} target="_blank" rel="noopener noreferrer" className="inline-flex min-h-11 items-center font-semibold text-action-primary underline">Open payment checkout</a>
  if (open) return <div className="grid gap-3"><StatusMessage tone="info">A payment for this statement is pending verification. Check its status below before starting another.</StatusMessage>{fallback}</div>
  return <form className="grid gap-4 mp-card mp-card-padded" onSubmit={event => void submit(event)} aria-labelledby="pay-heading">
    <div><h2 id="pay-heading" className="text-lg font-semibold">Pay statement</h2><p className="mt-1 text-sm text-text-secondary">Xendit TEST payment to the MateryalPH platform account. No real charge, no automatic debit; MateryalPH absorbs the processing charge on its own bill.</p></div>
    <fieldset className="grid gap-2"><legend className="text-sm font-semibold">Channel</legend>
      {channels.length === 0 && <StatusMessage tone="error">No payment channel is available right now. Try again later.</StatusMessage>}
      {channels.map(item => <label key={item.code} className="flex min-h-11 items-center gap-3 rounded-control border border-border-default px-3 text-sm"><input type="radio" name="channel" className="h-5 w-5 accent-action-primary" value={item.code} checked={channel === item.code} onChange={() => setChannel(item.code)} disabled={busy} />{item.displayName}</label>)}
    </fieldset>
    <label className="flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={installment} onChange={event => setInstallment(event.target.checked)} disabled={busy} />Pay part of the balance now</label>
    {installment && <label className="grid gap-2 text-sm font-semibold">Amount (₱)<input className="min-h-12 rounded-control border border-border-default px-3 text-base font-normal" inputMode="decimal" value={amount} onChange={event => setAmount(event.target.value)} disabled={busy} aria-describedby="amount-hint" /><span id="amount-hint" className="text-xs font-normal text-text-secondary">Up to {formatPesoCentavos(statement.outstandingCentavos)}</span></label>}
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <Button type="submit" disabled={busy || !channel}>{busy ? 'Opening payment…' : `Pay ${installment ? 'amount' : formatPesoCentavos(statement.outstandingCentavos)} — TEST`} <ExternalLink size={16} aria-hidden="true" /></Button>
    {fallback}
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
  return <DashboardPanel density="compact" title="Payment history">
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
    <ul className="grid divide-y divide-border-default">
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
  </DashboardPanel>
}

function BackToStatements() {
  const [params] = useSearchParams()
  return <BackNavigation><Link to={{ pathname: '/finance/commissions', search: params.toString(), hash: '#commission-statements' }}>Commission statements</Link></BackNavigation>
}

// ── Earnings ────────────────────────────────────────────────────────────────────────────────────

export function VendorEarningsPage() {
  return <FinanceGate activeHref="/finance" permission="portal.earnings">{() => <FinanceOverview canViewEarnings earningsRoute />}</FinanceGate>
}

/** The Earnings date range lives in the URL and supplies the Finance overview controls. */
function useEarningsDates() {
  const [params, setParams] = useSearchParams()
  const range = dateRangeFromParams(params)
  const changeDates = (nextRange: DateFilterRange) => setParams(current => { const next = new URLSearchParams(current); for (const [key, value] of Object.entries(dateRangePatch(nextRange))) { if (value) next.set(key, value); else next.delete(key) } return next }, { replace: true })
  const exportButton = <DocumentExportButton basePath={import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'} audience="vendor" types={['EARNINGS']} filters={{ ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }} title="Earnings" />
  const dates = <DateFilter title="Earnings dates" value={range} onChange={changeDates} />
  return { range, changeDates, exportButton, dates }
}

function Earnings({ controls, paymentOverview }: { controls: ReturnType<typeof useEarningsDates>; paymentOverview: VendorFinanceOverview }) {
  const { range } = controls
  const { data, error, reload } = useLoader<VendorEarnings>(() => getEarnings({ ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }), `${range.from}|${range.to}`)
  return <div className="grid min-w-0 gap-3">
    {error ? <ErrorState message={error} onRetry={reload} /> : !data ? <LoadingState label="Loading earnings…" /> : <>
    <EarningsAnalytics data={data} compare={Boolean(range.from)} paymentOverview={paymentOverview} />
    <div className="flex flex-wrap items-center gap-3 mp-card mp-card-padded text-sm">
      <ReceiptText size={18} className="text-action-primary" aria-hidden="true" />
      <span>Unpaid commission statements: <strong className="tabular-nums">{formatPesoCentavos(data.unpaidStatementsCentavos)}</strong></span>
      <Link className="font-semibold text-action-primary underline" to="/finance/commissions#commission-statements">View statements</Link>
      <span className="text-xs text-text-secondary">DEMO — No real funds or BIR filing.</span>
    </div>
    </>}
  </div>
}

/** Xendit cash revenue uses the assessment-date projection; confirmed refunds are already netted by the server. */
function OnlinePayout({ controls, paymentOverview }: { controls: ReturnType<typeof useEarningsDates>; paymentOverview: VendorFinanceOverview }) {
  const { range } = controls
  const { data, error, reload } = useLoader<VendorEarnings>(() => getEarnings({ ...(range.from ? { from: range.from } : {}), ...(range.to ? { to: range.to } : {}) }), `${range.from}|${range.to}`)
  const calculation = data ? earningsCalculations(data).remittance : null
  const previous = range.from ? data?.trend.previous : null
  const periodLabel = data ? `previous ${formatCount(data.trend.days)} ${data.trend.days === 1 ? 'day' : 'days'}` : ''
  return <div className="mp-online-payout-figures">
    <XenditConnection data={paymentOverview} summary={<div aria-label="Xendit cash revenue estimate">
      <AnalyticsSummary embedded density="compact" title="Xendit cash revenue summary" actions={controls.dates} context={data ? `${formatChartDay(analyticsDay(data.trend.from) ?? '')} – ${formatChartDay(analyticsDay(data.trend.to) ?? '')} · TEST estimate` : 'TEST estimate'}
      featured={{ label: 'Xendit cash revenue', value: data ? formatPesoCentavos(data.estimatedRemittanceCashCentavos) : '—',
        hint: 'After completed refunds and withholding', icon: <Landmark size={17} />, calculation,
        changePercent: previous?.changePercent.estimatedRemittanceCashCentavos, comparison: `vs ${periodLabel}`, comparisonUnavailable: range.from ? 'Previous period unavailable' : 'Choose dates to compare' }} metrics={[]} />
      {(error || !data) && <div className="px-3 pb-3">{error ? <ErrorState message={error} onRetry={reload} /> : <LoadingState label="Loading Xendit cash revenue…" />}</div>}
    </div>}>
    {data && <DashboardPanel embedded density="compact" title="Payment breakdown" description="Refunds are not counted. Buyer-paid fees are separate.">
      <FinanceBreakdownPanel title="Xendit cash revenue" calculation={calculation} caption="Estimated remittance calculation" rows={[
        { key: 'retained', label: 'Order payments after refunds', amount: formatPesoCentavos(data.estimatedRemittanceCashCentavos + data.simulatedCwtCentavos) },
        { key: 'cwt', label: 'Creditable withholding tax', amount: formatPesoCentavos(data.simulatedCwtCentavos === 0 ? 0 : -data.simulatedCwtCentavos) },
        { key: 'total', label: 'Xendit cash revenue', amount: formatPesoCentavos(data.estimatedRemittanceCashCentavos), total: true },
      ]} />
      <p className="mp-finance-caption mt-3">Fully refunded payments are excluded; completed partial refunds are subtracted. Commission is billed separately.</p>
    </DashboardPanel>}
    </XenditConnection>
  </div>
}

type TrendFigure = Exclude<keyof VendorEarningsTrendPoint, 'date'>

/**
 * FIN-11 Earnings as the Sales & Revenue dashboard draws it: headline cards with the change against the previous equal
 * period, then each figure over time. Every figure stays separate — no margin, net income or ratio is derived — and
 * every chart has a table view. The comparison only shows when a start date is chosen; "All dates" has no prior period.
 */
function EarningsAnalytics({ data, compare, paymentOverview }: { data: VendorEarnings; compare: boolean; paymentOverview: VendorFinanceOverview }) {
  const calculations = earningsCalculations(data)
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
  const summaryChange = (figure: TrendFigure) => ({
    changePercent: previous?.changePercent[figure], comparison: `vs ${periodLabel}`,
    comparisonUnavailable: previous ? `No ${periodLabel} to compare` : compare ? 'Previous period unavailable' : 'Choose dates to compare',
  })
  const { sales, online, physical } = data.breakdown
  const minus = (centavos: number) => formatPesoCentavos(centavos === 0 ? 0 : -centavos)
  const series = (figure: TrendFigure, label: string, colorVar: VizColor, kind?: 'bar'): TrendSeries => ({ key: figure, label, colorVar, values: values(figure), ...(kind ? { kind } : {}) })
  const column = (figure: TrendFigure, header: string) => ({ key: figure, header, values: points.map(point => formatPesoCentavos(point[figure])) })
  const chart = (title: string, chartSeries: TrendSeries[], empty: string, variant: 'area' | 'bar' = 'area') => <TrendLineChart variant={variant} title={title} labels={active(...chartSeries.map(item => item.key as TrendFigure)) ? labels : []}
    formatLabel={formatLabel} formatValue={value => formatCompactCentavos(Math.round(value))} formatTooltipValue={value => formatPesoCentavos(Math.round(value))} emptyReason={empty} series={chartSeries} />
  const table = (caption: string, columns: ReturnType<typeof column>[]) => <ChartDataTable caption={caption} rowHeader={monthly ? 'Month' : 'Date'} rows={rows} columns={columns} />

  return <div className="mp-analytics mp-finance-overview">
    <p className="text-xs text-text-secondary">{points.length === 0 ? 'The chosen dates start after today, so there is nothing to chart yet.'
      : `Charted by ${unit} · ${formatChartDay(analyticsDay(trend.from) ?? '')} – ${formatChartDay(analyticsDay(trend.to) ?? '')} (Asia/Manila)${previous ? ` · compared with ${formatChartDay(analyticsDay(previous.from) ?? '')} – ${formatChartDay(analyticsDay(previous.to) ?? '')}` : ''}`}</p>
    <AnalyticsSummary density="compact" title="Sales overview" context={`${formatChartDay(analyticsDay(trend.from) ?? '')} – ${formatChartDay(analyticsDay(trend.to) ?? '')}`} featured={{ label: 'Earnings', value: formatPesoCentavos(data.commercialSalesCentavos), calculation: calculations.commercialSales, icon: <Wallet size={17} />, hint: `${formatCount(sales.orders)} orders · VAT included`, ...summaryChange('commercialSalesCentavos') }} metrics={[
      { label: 'Online collections', value: formatPesoCentavos(data.onlineCollectionsCentavos), calculation: calculations.onlineCollections, icon: <CreditCard size={17} />, hint: 'After confirmed refunds', ...summaryChange('onlineCollectionsCentavos') },
      { label: 'Physical collections', value: formatPesoCentavos(data.physicalCollectionsCentavos), calculation: calculations.physicalCollections, icon: <Banknote size={17} />, hint: 'Recorded COD / In-Store receipts', ...summaryChange('physicalCollectionsCentavos') },
    ]} />
    <div className="mp-finance-layout">
    <div className="mp-finance-main">
    <div className="mp-finance-report-row">
      <AnalyticsChartCard title="Sales and collections" calculation={calculations.salesChart} description={`Earnings per ${unit} with the online and physical collections received.`}>
          {chart('Earnings and collections', [series('commercialSalesCentavos', 'Earnings', '--mp-viz-series-1', 'bar'), series('onlineCollectionsCentavos', 'Online collections', '--mp-viz-series-2'),
            series('physicalCollectionsCentavos', 'Physical collections', '--mp-viz-series-3')], 'No sales or collections in this period.', 'bar')}
          {table(`Sales and collections per ${unit}`, [column('commercialSalesCentavos', 'Earnings'), column('onlineCollectionsCentavos', 'Online collections'), column('onlineRefundsCentavos', 'Confirmed online refunds'), column('physicalCollectionsCentavos', 'Physical collections')])}
      </AnalyticsChartCard>
    <DashboardPanel density="compact" title="Financial calculations" description="Recorded amounts behind the overview totals.">
    <div aria-label="Earnings summary" className="mp-finance-calculations">
      <FinanceBreakdownPanel title="Earnings" calculation={calculations.commercialSales}
        hint={`${formatCount(sales.orders)} ${sales.orders === 1 ? 'order' : 'orders'} · includes ${formatPesoCentavos(data.includedVatCentavos)} VAT. Cancelled and fully refunded orders are left out.`}
        caption="Earnings calculation" rows={[
          { key: 'materials', label: 'Materials before discounts', amount: formatPesoCentavos(sales.materialsBeforeDiscountCentavos) },
          { key: 'discounts', label: 'Vendor discounts', amount: minus(sales.vendorDiscountsCentavos) },
          { key: 'delivery', label: 'Delivery', amount: formatPesoCentavos(sales.deliveryCentavos) },
          ...(sales.refundsCentavos ? [{ key: 'refunds', label: 'Completed refunds', amount: minus(sales.refundsCentavos) }] : []),
          { key: 'total', label: 'Earnings', amount: formatPesoCentavos(data.commercialSalesCentavos), total: true },
        ]} />
      <FinanceBreakdownPanel title="Online collections" calculation={calculations.onlineCollections} hint="Verified principal after confirmed refunds"
        caption="Online collections calculation" rows={[
          { key: 'paid', label: `Verified online payments (${formatCount(online.payments)})`, amount: formatPesoCentavos(online.principalPaidCentavos) },
          { key: 'refunds', label: 'Confirmed refunds of that principal', amount: minus(online.refundedPrincipalCentavos) },
          { key: 'total', label: 'Online collections', amount: formatPesoCentavos(data.onlineCollectionsCentavos), total: true },
        ]} />
      <FinanceBreakdownPanel title="Physical collections" calculation={calculations.physicalCollections}
        hint={physical.unrecordedCentavos > 0 ? <>Your recorded COD / In-Store receipts. <strong className="font-semibold text-text-strong">{formatPesoCentavos(physical.unrecordedCentavos)}</strong> on {formatCount(physical.unrecordedOrders)} delivered or picked-up {physical.unrecordedOrders === 1 ? 'order is' : 'orders are'} not recorded yet and not counted. <Link className="font-semibold text-action-primary underline underline-offset-2" to="/finance/transactions?tab=PAYMENTS&status=PHYSICAL_TO_RECORD">Review cash to record</Link></> : 'Your recorded COD / In-Store receipts'}
        caption="Physical collections calculation" rows={[
          { key: 'cod', label: 'Cash on Delivery', amount: formatPesoCentavos(physical.cashOnDeliveryCentavos) },
          { key: 'store', label: 'In-Store Payment', amount: formatPesoCentavos(physical.inStoreCentavos) },
          { key: 'total', label: `Physical collections (${formatCount(physical.records)} ${physical.records === 1 ? 'receipt' : 'receipts'})`, amount: formatPesoCentavos(data.physicalCollectionsCentavos), total: true },
        ]} />
    </div>
    </DashboardPanel>
    </div>
    <div className="mp-finance-report-row">
      <AnalyticsChartCard title="Deductions and commission" calculation={calculations.deductionsChart} description={`Charges and tax per ${unit}. Platform commission is billed separately.`}>
          {chart('Deductions and commission', [series('simulatedCwtCentavos', 'Creditable withholding tax', '--mp-viz-series-2'),
            series('earnedCommissionCentavos', 'Platform commission charges', '--mp-viz-series-3')], 'No deductions or commission in this period.')}
          {table(`Deductions and commission per ${unit}`, [column('simulatedCwtCentavos', 'Creditable withholding tax'), column('earnedCommissionCentavos', 'Platform commission charges')])}
      </AnalyticsChartCard>
      <DashboardPanel density="compact" title="Deductions and fees" description="Totals for the selected dates. Commission is billed separately from remittances.">
        <div className="grid gap-3">
          <div className="grid gap-2"><h3 className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">Collections by method</h3>
            <ShareBar label="Collections by method" empty="No collections in this period." formatValue={formatPesoCentavos} segments={[
              { key: 'online', label: 'Online collections', value: data.onlineCollectionsCentavos, colorVar: '--mp-viz-series-2' },
              { key: 'physical', label: 'Physical collections', value: data.physicalCollectionsCentavos, colorVar: '--mp-viz-series-3' }]} /></div>
          <dl className="mp-finance-fee-totals">{[
            { label: 'E-wallet transaction fees', amount: data.buyerProcessingFeesCentavos, hint: 'Paid by Buyers; never store revenue.', calculation: calculations.buyerFees },
            { label: 'Creditable withholding tax', amount: data.simulatedCwtCentavos, hint: 'A tax credit, not a sales reduction.', calculation: calculations.cwt },
            { label: 'Platform commission charges', amount: data.earnedCommissionCentavos, hint: `Billed monthly on statements · estimated ${formatPesoCentavos(data.estimatedCommissionCentavos)} for orders not yet completed.`, calculation: calculations.commission },
          ].map(({ label, amount, hint, calculation }) => <div key={label}><dt className="flex min-h-11 items-center justify-between gap-2 text-xs text-text-secondary"><span>{label}</span><CalculationHelp title={label}>{calculation}</CalculationHelp></dt><dd className="mt-1 text-base font-semibold tabular-nums">{formatPesoCentavos(amount)}</dd><dd className="mp-finance-caption mt-1">{hint}</dd></div>)}</dl>
        </div>
      </DashboardPanel>
    </div>
    <EarningsProducts key={`${trend.from.toISOString()}|${trend.to.toISOString()}`} data={data} calculation={calculations.productSales} />
    </div>
    <aside aria-label="Online payment channels">
      <FinancePaymentChannels data={paymentOverview} />
    </aside>
    </div>
  </div>
}

const PRODUCTS_PER_PAGE = 10

/**
 * Sales value per product and the best sellers for the same orders and dates as Earnings, laid out like
 * Product analytics. Materials plus delivery less completed partial refunds equal Earnings.
 */
function EarningsProducts({ data, calculation }: { data: VendorEarnings; calculation: ReactNode }) {
  const [page, setPage] = useState(1)
  const { items, total, truncated } = data.products
  const { materialsAfterDiscountCentavos: productValue, deliveryCentavos } = data.breakdown.sales
  const lastPage = Math.max(1, Math.ceil(items.length / PRODUCTS_PER_PAGE))
  const visible = items.slice((Math.min(page, lastPage) - 1) * PRODUCTS_PER_PAGE, Math.min(page, lastPage) * PRODUCTS_PER_PAGE)
  const share = (value: number) => (productValue > 0 ? `${((value / productValue) * 100).toFixed(1)}%` : '—')
  const name = (item: (typeof items)[number]) => (item.listingId ? <Link className="hover:text-action-primary hover:underline" to={`/analytics/products/${item.listingId}`}>{item.name}</Link> : item.name)
  const stats: [string, string][] = [['Product sales value', formatPesoCentavos(productValue)], ['Plus delivery', formatPesoCentavos(deliveryCentavos)], ...(data.breakdown.sales.refundsCentavos ? [['Less completed refunds', formatPesoCentavos(-data.breakdown.sales.refundsCentavos)] as [string, string]] : []), ['Equals earnings', formatPesoCentavos(data.commercialSalesCentavos)]]
  return <div className="min-w-0">
      <DashboardPanel density="compact" title="Product sales value" calculation={calculation} description="What each product sold for in the selected dates, after vendor discounts, VAT included.">
        <div className="grid gap-4">
          <dl aria-label="Product sales value reconciliation" className="mp-finance-product-totals">
            {stats.map(([label, amount]) => <div key={label}><dt>{label}</dt><dd>{amount}</dd></div>)}
          </dl>
          {items.length === 0 ? <p className="rounded-control border border-dashed border-border-default px-4 py-6 text-center text-sm text-text-secondary">No product was sold in these dates.</p> : <>
            <div className="overflow-x-auto rounded-control border border-border-default">
              <table className="w-full min-w-[28rem] border-collapse text-sm">
                <caption className="sr-only">Product sales value</caption>
                <thead className="bg-surface-canvas text-xs text-text-secondary"><tr>
                  <th scope="col" className="px-4 py-2.5 text-left font-semibold">Product</th><th scope="col" className="whitespace-nowrap px-4 py-2.5 text-right font-semibold">Orders</th>
                  <th scope="col" className="whitespace-nowrap px-4 py-2.5 text-right font-semibold">Share</th><th scope="col" className="whitespace-nowrap px-4 py-2.5 text-right font-semibold">Sales value</th></tr></thead>
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

    </div>
}

function monthName(month: number): string {
  return new Intl.DateTimeFormat('en-PH', { month: 'long' }).format(new Date(2026, Math.max(0, Math.min(11, month - 1)), 1))
}
