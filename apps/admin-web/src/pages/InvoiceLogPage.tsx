import { useEffect, useState } from 'react'
import { useSearchParams } from 'react-router-dom'
import { FileText, Info } from 'lucide-react'
import { FilterChips, SignedFileButton, StatusBadge, formatManilaDateTime, formatPesoCentavos } from '@materyalph/web-ui'
import { adminApiBasePath, listInvoiceLog, type InvoiceListMeta, type InvoiceLogRow, type InvoiceLogView } from '../lib/disputes-api'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { AdminShell, ErrorState, LoadingState, PageHeader } from './PhaseThreeAdminPages'

const VIEWS: { value: InvoiceLogView; label: string; count: string }[] = [
  { value: 'REQUESTS', label: 'Requests', count: 'REQUESTS_OPEN' }, { value: 'RECORDS', label: 'Uploaded records', count: 'RECORDS' }, { value: 'MISMATCHES', label: 'Mismatched totals', count: 'MISMATCHES' },
]

/** Read-only Invoice Request Log (FIN-09): requests and service targets, uploaded Vendor copies, mismatches and download events. */
export function AdminInvoiceLogPage() {
  const [params, setParams] = useSearchParams()
  const view = (VIEWS.some(item => item.value === params.get('view')) ? params.get('view') : 'REQUESTS') as InvoiceLogView
  const [rows, setRows] = useState<InvoiceLogRow[] | null>(null)
  const [meta, setMeta] = useState<InvoiceListMeta | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setRows(null); setError(null)
    listInvoiceLog(view).then(result => { if (active) { setRows(result.items); setMeta(result.meta) } }).catch(async cause => { const text = await readableVerificationError(cause); if (active) setError(text) })
    return () => { active = false }
  }, [view, attempt])
  return <AdminShell activeHref="/invoices"><div className="grid min-w-0 gap-6">
    <PageHeader eyebrow="Finance" title="Invoice Request Log" description="Buyer copy and correction requests, Vendor-uploaded invoice copies and their reconciliation. MateryalPH documents are not the Vendor's invoice; Admins never create or certify a tax invoice." />
    {meta?.notice && <p className="flex items-start gap-2 rounded-control border border-border-default bg-surface-primary px-3 py-2 text-sm"><Info size={16} className="mt-0.5 shrink-0" aria-hidden="true" />{meta.notice}{meta.counts?.REQUESTS_OVERDUE ? ` ${meta.counts.REQUESTS_OVERDUE} request(s) are past the three-business-day target.` : ''}</p>}
    <FilterChips label="Invoice log view" value={view} onChange={value => setParams({ view: value })} chips={VIEWS.map(item => ({ value: item.value, label: item.label, count: meta?.counts?.[item.count] }))} />
    {error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} /> : rows === null ? <LoadingState /> : rows.length === 0
      ? <p className="rounded-surface border border-dashed border-border-default px-6 py-10 text-center text-sm text-text-secondary">Nothing to show in this view.</p>
      : <ul className="grid divide-y divide-border-default rounded-surface border border-border-default bg-surface-primary">{rows.map(row => <li key={row.id} className="grid gap-2 px-4 py-3">
        {view === 'REQUESTS' ? <>
          <p className="flex flex-wrap items-center gap-2 font-semibold"><FileText size={15} aria-hidden="true" />{row.orderReference} · {row.vendorName} · {row.kind === 'CORRECTION' ? 'Correction' : 'Copy'}</p>
          <div className="flex flex-wrap items-center gap-2"><StatusBadge label={(row.state ?? '').replaceAll('_', ' ').toLowerCase()} tone={row.overdue ? 'error' : 'neutral'} />{row.overdue && <span className="text-sm font-semibold text-status-error">Past the service target</span>}</div>
          <p className="text-sm text-text-secondary">Target {row.serviceTargetLabel}{row.uploadedAt ? ` · uploaded ${formatManilaDateTime(row.uploadedAt)}` : ''}</p>
        </> : <>
          <p className="flex flex-wrap items-center gap-2 font-semibold"><FileText size={15} aria-hidden="true" />{row.orderReference} · {row.vendorName} · {row.invoiceNumber} · <span className="tabular-nums">{formatPesoCentavos(row.amountCentavos ?? 0)}</span></p>
          <div className="flex flex-wrap gap-2"><StatusBadge label={row.originLabel ?? ''} tone="warning" />
            <StatusBadge label={row.reconciliationState === 'INVOICE_RECONCILIATION_REQUIRED' ? `Differs by ${formatPesoCentavos(row.reconciliationDifferenceCentavos ?? 0)}` : (row.reconciliationState ?? '').replaceAll('_', ' ').toLowerCase()} tone={row.reconciliationState === 'INVOICE_RECONCILIATION_REQUIRED' ? 'warning' : 'neutral'} /></div>
          <p className="text-sm text-text-secondary">{row.issuedOn}{row.uploadedAt ? ` · uploaded ${formatManilaDateTime(row.uploadedAt)}` : ''} · downloads {row.downloads ?? 0}{row.lastDownloadAt ? ` (last ${formatManilaDateTime(row.lastDownloadAt)})` : ''}</p>
          <p className="text-xs text-text-secondary">{row.complianceNote}</p>
          {row.download && <SignedFileButton url={row.download.url} label="Open invoice copy" apiBasePath={adminApiBasePath} />}
        </>}
      </li>)}</ul>}
  </div></AdminShell>
}
