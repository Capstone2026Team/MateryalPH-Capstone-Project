import { useState } from 'react'
import { ExternalLink, Landmark } from 'lucide-react'
import {
  AnalyticsSummary, DashboardPanel, DateFilter, dateFilterPreset, manilaToday,
  FinanceBreakdownPanel, FinanceProviderCard, PlatformCollectionsThreshold, PlatformEarningsBreakdown,
  StatusBadge, formatChartDay, analyticsDay,
  formatPesoCentavos,
} from '@materyalph/web-ui'
import { financeKpis } from '../lib/finance-api'
import { useLoad } from '../lib/operations-hooks'
import { ErrorState, LoadingState } from './PhaseThreeAdminPages'

const platformAnnualThresholdCentavos = 50_000_000

export function PlatformXenditPanel() {
  const [range, setRange] = useState(() => dateFilterPreset(30))
  const kpis = useLoad(() => financeKpis(range.from, range.to), [range.from, range.to])
  const value = (key: string) => kpis.data?.finance.find(item => item.key === key)?.valueCentavos ?? 0
  return <div className="mp-online-payout-layout">
    <div className="mp-finance-main">
      <div className="mp-finance-annual-collections"><PlatformAnnualCollections /></div>
      <DashboardPanel density="compact" title="Platform tax records" description="Recorded tax on MateryalPH commission fees. Vendor deductions remain separate.">
        {kpis.error ? <ErrorState message={kpis.error} onRetry={kpis.retry} /> : !kpis.data ? <LoadingState /> : <>
        <FinanceBreakdownPanel title="VAT and withholding" hint={`${formatChartDay(analyticsDay(range.from) ?? '')} – ${formatChartDay(analyticsDay(range.to) ?? '')} · Asia/Manila · Selected earnings dates`} caption="Platform tax amounts"
          calculation={<><p><strong>Output VAT on fees:</strong> VAT posted with commission assessments, less recorded VAT reversals on approved credits. It follows the saved platform tax profile for each assessment. Annual collection totals do not activate VAT or change earlier assessments.</p><p><strong>Creditable withholding tax:</strong> The current finance records do not supply a confirmed withholding amount for the platform's commission receipts. Confirm any applicable deduction and supporting certificate in the platform Xendit account.</p><p>Vendor remittance withholding is separate. It is not deducted from platform earnings or substituted for platform withholding. A recorded zero is shown as zero; missing data is shown as unavailable.</p></>}
          rows={[
          { key: 'vat', label: 'Output VAT on fees', amount: kpis.data?.finance.some(item => item.key === 'fee_vat') ? formatPesoCentavos(value('fee_vat')) : '—' },
          { key: 'withholding', label: 'Creditable withholding tax', amount: 'Not available' },
        ]} />
        <p className="mp-finance-caption">Only confirmed platform withholding can be shown as a deduction. Reaching a collection total alone does not establish an amount withheld.</p>
        </>}
      </DashboardPanel>
    </div>
    <aside className="mp-finance-aside" aria-label="Platform earnings and Xendit account">
      <FinanceProviderCard title="Platform Xendit account" status={<StatusBadge label="Xendit TEST" tone="warning" />}
        summary={<><AnalyticsSummary embedded density="compact" title="Platform earnings summary" context={`${formatChartDay(analyticsDay(range.from) ?? '')} – ${formatChartDay(analyticsDay(range.to) ?? '')} · Asia/Manila · TEST`}
          actions={<DateFilter title="Platform earnings dates" value={range} onChange={setRange} />}
          featured={{ label: 'Net platform earnings', value: kpis.data ? formatPesoCentavos(value('net_platform_earnings')) : '—', icon: <Landmark size={16} />, hint: 'After fee VAT and platform processing costs' }} metrics={[]} />
          {kpis.error ? <div className="px-4 pb-4"><ErrorState message={kpis.error} onRetry={kpis.retry} /></div> : !kpis.data && <LoadingState />}</>}
        items={[[ 'Provider', 'Xendit Sandbox' ], [ 'Account', 'MateryalPH platform' ], [ 'Receives', 'Vendor commission payments' ]]}
        note="TEST records only. Sign in directly to Xendit to review account status and remittances. MateryalPH never stores or shows its Xendit credentials."
        action={<a className="inline-flex min-h-11 items-center justify-center gap-2 rounded-control bg-surface-primary px-4 text-sm font-semibold text-action-primary" href="https://dashboard.xendit.co/" target="_blank" rel="noopener noreferrer"><ExternalLink size={16} aria-hidden="true" />Open Xendit dashboard<span className="sr-only"> (opens in a new tab)</span></a>}>
        <DashboardPanel embedded density="compact" title="Payment breakdown" description="Earned commission after approved credits. Collections remain separate.">
          <PlatformEarningsBreakdown figures={kpis.data?.finance ?? null} />
          <p className="mp-finance-caption mt-3">Only successful, verified payments enter commission collections. Pending and failed attempts are excluded; payment evidence retains its Xendit TEST or simulated origin.</p>
        </DashboardPanel>
      </FinanceProviderCard>
    </aside>
  </div>
}

function PlatformAnnualCollections() {
  const year = Number(manilaToday().slice(0, 4))
  const annual = useLoad(() => financeKpis(`${year}-01-01`, `${year}-12-31`), [year])
  return <DashboardPanel density="compact" title="Gross-remittance threshold" description={`${formatPesoCentavos(platformAnnualThresholdCentavos)} per taxable year · MateryalPH platform · TEST figures`}>
    {annual.error ? <ErrorState message={annual.error} onRetry={annual.retry} /> : !annual.data ? <LoadingState /> :
      <PlatformCollectionsThreshold figures={annual.data.finance} thresholdCentavos={platformAnnualThresholdCentavos} taxableYear={year} />}
  </DashboardPanel>
}

