import { useState } from 'react'
import { Navigate, useSearchParams } from 'react-router-dom'
import { DateFilter, FilterTabs, PageHeader, dateFilterPreset } from '@materyalph/web-ui'
import { AdminShell } from './PhaseThreeAdminPages'
import { FinanceKpiPanel } from './FinanceOperationsPanels'
import { CommissionManagementWorkspace } from './CommissionManagementWorkspace'
import { PlatformXenditPanel } from './CommissionFinancePanels'

const PRIMARY_VIEWS = [{ value: 'overview', label: 'Finance overview' }, { value: 'statements', label: 'Commission management' }, { value: 'xendit', label: 'Xendit cash revenue & remittance' }]

export function AdminFinancePage() {
  const [params, setParams] = useSearchParams()
  const requested = params.get('view') ?? 'overview'
  const view = requested === 'payments' ? 'transactions' : requested === 'channels' ? 'xendit' : requested
  const primary = ['statements', 'overdue', 'transactions'].includes(view) ? 'statements' : view === 'xendit' ? 'xendit' : 'overview'
  const [overviewRange, setOverviewRange] = useState(() => dateFilterPreset(30))

  if (['tax-remittance', 'tax', 'adjustments', 'queue', 'remittances', 'withholding'].includes(requested)) {
    return <Navigate to="/finance" replace />
  }

  if (primary === 'statements') return <AdminShell activeHref="/finance"><CommissionManagementWorkspace overdue={view === 'overdue'} initialPayments={view === 'transactions'} onOverdueChange={value => setParams({ view: value ? 'overdue' : 'statements' })} navigation={<FilterTabs label="Finance view" chips={PRIMARY_VIEWS} value={primary} appearance="tabs" onChange={value => setParams({ view: value })} />} /></AdminShell>

  return <AdminShell activeHref="/finance"><div className="grid min-w-0 gap-4">
    <PageHeader compact eyebrow="Finance" title={primary === 'overview' ? 'Finance overview' : 'Platform Finance'} description={primary === 'overview' ? 'Commission earnings, collections and Vendor billing in one place.' : 'Commission earnings, Vendor billing and platform collections.'}
      actions={primary === 'overview' && <DateFilter title="Transaction dates" value={overviewRange} onChange={setOverviewRange} />} />
    <FilterTabs label="Finance view" chips={PRIMARY_VIEWS} value={primary} appearance="tabs" onChange={value => setParams({ view: value })} />
    <div key={view} className="grid min-w-0 gap-6">
      {primary === 'overview' && <FinanceKpiPanel range={overviewRange} />}
      {primary === 'xendit' && <PlatformXenditPanel />}

    </div>
  </div></AdminShell>
}
