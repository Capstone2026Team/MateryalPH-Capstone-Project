import { FileCheck2, FileText, ReceiptText } from 'lucide-react'
import { useId, type ReactNode } from 'react'
import { serializeDate, type InvoiceRecordView, type VendorOrderInvoices, type InvoiceOrderSummary } from '@materyalph/api-client-ts'
import { SignedFileButton } from './dispute-patterns'
import { invoicePreparationLabel } from './invoice-preset-fields'
import { formatPesoCentavos } from './order-patterns'
import { StatusBadge } from './portal-shell'
import { formatManilaDateTime } from './stock-ledger'
import './invoice-workspace.css'

/** A shared invoice list and document layout; the caller supplies authorized data and actions. */
export function InvoiceWorkspace({ summary, list, detail }: { summary: ReactNode; list: ReactNode; detail: ReactNode }) {
  return <div className="mp-invoice-workspace">
    <div className="mp-invoice-overview"><dl aria-label="Invoice overview" className="mp-invoice-summary">{summary}</dl>{list}</div>
    <div id="invoice-details" className="mp-invoice-detail">{detail}</div>
  </div>
}

export function InvoiceListItem({ title, reference, metadata, status, amount, selected, onSelect }: {
  title: string; reference?: string; metadata: { label: string; value: ReactNode }[]; status: ReactNode; amount?: ReactNode; selected: boolean; onSelect: () => void
}) {
  return <li className="min-w-0">
    <button type="button" aria-label={`View ${title}${reference ? ` · ${reference}` : ''}`} aria-pressed={selected} aria-controls="invoice-details" onClick={onSelect} className="mp-invoice-row" data-selected={selected}>
      <span className="mp-invoice-row-heading"><span className="mp-invoice-row-icon" aria-hidden="true"><FileText size={18} /></span><span className="min-w-0"><span className="mp-invoice-row-title">{title}</span>{reference && <span className="mp-invoice-row-reference">{reference}</span>}</span></span>
      <span className="mp-invoice-row-metadata">{metadata.map(item => <span key={item.label} className="min-w-0"><span className="mp-invoice-row-label">{item.label}</span><span className="mp-invoice-row-value">{item.value}</span></span>)}</span>
      <span className="mp-invoice-row-end">{amount && <span className="mp-invoice-row-amount">{amount}</span>}{status}</span>
    </button>
  </li>
}

export function InvoiceSelectionPlaceholder() {
  return <section aria-label="Invoice details" className="mp-invoice-sheet mp-invoice-placeholder">
    <span className="mp-invoice-placeholder-icon"><ReceiptText size={28} aria-hidden="true" /></span>
    <h2 className="text-lg font-semibold text-text-strong">Your invoice, at a glance</h2>
    <p className="max-w-xs text-sm leading-6 text-text-secondary">Select a request, sale or uploaded copy to review its details and available actions here.</p>
  </section>
}

/** Accepted order values and recorded document facts stay visibly distinct. */
export function InvoiceDetailSummary({ data, record, actions, recordAction, apiBasePath, showDraft = true }: { data: VendorOrderInvoices; record?: InvoiceRecordView; actions?: ReactNode; recordAction?: ReactNode; apiBasePath: string; showDraft?: boolean }) {
  const heading = useId()
  const draft = showDraft && data.draft && !data.draft.sentRecordId ? data.draft : null
  const billing = !draft && record?.orderSummary ? record.orderSummary.billingDetails : data.billingDetails
  const buyerName = !record || draft ? data.buyerName : undefined
  const orderSummary = !draft && record?.orderSummary ? record.orderSummary : data.orderSummary
  const number = draft?.invoiceNumber ?? record?.invoiceNumber
  const total = draft?.amountCentavos ?? record?.amountCentavos
  const vat = draft?.vatCentavos ?? record?.vatCentavos
  const issuedOn = draft ? serializeDate(draft.issuedOn) : record?.issuedOn
  const download = draft?.download ?? record?.download
  const fileName = draft?.fileName ?? record?.fileName
  const reconciliation = record ? ({ MATCHED: 'Matches accepted order', INVOICE_RECONCILIATION_REQUIRED: 'Amount mismatch needs review', EXPLAINED: 'Amount mismatch explained', CORRECTED: 'Corrected by a later document', NOT_APPLICABLE: 'Adjustment document' }[record.reconciliationState] ?? record.reconciliationState) : null
  return <div className="grid min-w-0 gap-5">
    <header className="mp-invoice-document-heading">
      <div className="flex flex-wrap items-center justify-between gap-3"><p className="flex items-center gap-2 text-xs font-medium text-text-secondary"><ReceiptText size={15} aria-hidden="true" />Invoice details</p>{actions}</div>
      <h2 id={heading} className="mp-invoice-document-number">{number ?? data.orderReference}</h2>
      <div className="flex flex-wrap gap-2">
        <StatusBadge label={draft ? 'Ready to send' : record ? 'Sent to Buyer' : 'No copy yet'} tone={draft || record ? 'success' : 'neutral'} />
        {record && !draft && <StatusBadge label={record.originLabel} tone={record.documentOrigin === 'DEMO_SAMPLE' ? 'warning' : 'neutral'} />}
      </div>
      {number && <p className="text-xs text-text-secondary">Order {data.orderReference}</p>}
    </header>
    <div className="mp-invoice-parties">
      <div><h3 className="mp-invoice-section-label">Issued by</h3><p className="mt-2 text-sm font-semibold">{draft?.issuerName ?? record?.issuer ?? data.issuerName}</p><p className="mt-1 text-xs leading-5 text-text-secondary">{(draft?.invoiceType ?? record?.invoiceType) === 'VENDOR_ADJUSTMENT_DOCUMENT' ? 'Vendor adjustment document' : 'Vendor sales invoice'}</p></div>
      <div><h3 className="mp-invoice-section-label">{billing ? 'Bill to' : buyerName ? 'Buyer' : 'Bill to'}</h3>{billing ? <><p className="mt-2 text-sm font-semibold">{billing.billingName}</p><p className="mt-1 whitespace-pre-line text-xs leading-5 text-text-secondary">{billing.billingAddress}</p>{billing.tinMasked && <p className="mt-1 text-xs text-text-secondary">TIN: {billing.tinMasked}</p>}</> : <>{buyerName && <p className="mt-2 text-sm font-semibold">{buyerName}</p>}<p className={`${buyerName ? 'mt-1 text-xs' : 'mt-2 text-sm'} leading-6 text-text-secondary`}>No billing details provided.</p></>}</div>
    </div>
    {issuedOn && <dl className="mp-invoice-dates"><div><dt className="mp-invoice-section-label">Invoice date</dt><dd className="mt-2 text-sm">{issuedOn}</dd></div><div><dt className="mp-invoice-section-label">{draft ? 'Last saved' : 'Sent to Buyer'}</dt><dd className="mt-2 text-sm">{draft?.updatedAt ? formatManilaDateTime(draft.updatedAt) : record?.sentAt || record?.uploadedAt ? formatManilaDateTime(record.sentAt ?? record.uploadedAt!) : 'Not recorded'}</dd></div></dl>}
    {(draft || record) && <dl className="grid gap-3 text-xs">{([['Document type', 'document', draft?.invoiceType ?? record?.invoiceType], ['Issued through', 'source', draft?.sourceSystem ?? record?.sourceSystem], ['Invoicing method', 'method', draft?.invoicingMethod ?? record?.invoicingMethod]] as const).map(([label, kind, value]) => value && <div key={label} className="flex flex-wrap justify-between gap-2"><dt className="text-text-secondary">{label}</dt><dd className="font-medium">{invoicePreparationLabel(kind, value)}</dd></div>)}</dl>}
    {orderSummary && <InvoiceOrderBreakdown summary={orderSummary} />}
    {total !== undefined && <div className="mp-invoice-amounts" role="group" aria-label="Recorded invoice amounts">
      {vat !== undefined && vat !== null && <div><span>VAT shown on invoice</span><span>{formatPesoCentavos(vat)}</span></div>}
      <div className="mp-invoice-total"><span>Invoice total</span><span>{formatPesoCentavos(total)}</span></div>
      {!draft && record?.reconciliationState === 'INVOICE_RECONCILIATION_REQUIRED' && <div><span>Difference</span><span>{formatPesoCentavos(record.reconciliationDifferenceCentavos)}</span></div>}
    </div>}
    {download && data.canOpenFiles && <div className="mp-invoice-attachment"><FileCheck2 size={22} aria-hidden="true" className="shrink-0 text-status-success" /><div className="min-w-0"><p className="text-sm font-semibold">{draft ? 'Invoice copy uploaded' : 'Sent invoice copy'}</p><p className="mt-1 break-all text-xs text-text-secondary">{fileName ?? 'Invoice document'}</p><SignedFileButton url={download.url} label="Open invoice copy" apiBasePath={apiBasePath} /></div></div>}
    {!draft && record && <div className="grid gap-3">
      <div className="flex items-start gap-2 text-sm"><FileCheck2 size={17} className="mt-0.5 shrink-0 text-text-secondary" aria-hidden="true" /><span>{reconciliation}</span></div>
      {record.reconciliationNote && <p className="text-sm leading-6 text-text-secondary">Explanation: {record.reconciliationNote}</p>}
      <p className="text-xs leading-5 text-text-secondary">{record.complianceNote}</p>
      <div><StatusBadge label={record.verificationState === 'VERIFIED' ? 'Verified' : 'Not verified as compliant'} tone="neutral" /></div>
      {record.amendsInvoiceRecordId && <p className="text-xs leading-5 text-text-secondary">Amends: {data.records.find(item => item.id === record.amendsInvoiceRecordId)?.invoiceNumber ?? 'an earlier invoice record'}</p>}
      {recordAction}
    </div>}
    {!record && !draft && !data.orderSummary && data.lines.length > 0 && <div><h3 className="mp-invoice-section-label">Order materials</h3><ul className="mt-2 divide-y divide-border-default text-sm">{data.lines.map(line => <li key={line.orderLineId} className="py-2.5">{line.displayName}</li>)}</ul></div>}
  </div>
}

export function InvoiceOrderBreakdown({ summary }: { summary: InvoiceOrderSummary }) {
  const amount = (value: number | null | undefined) => value == null ? '—' : formatPesoCentavos(value)
  return <section aria-label="Accepted order breakdown" className="grid min-w-0 gap-2">
    <h3 className="mp-invoice-section-label">Accepted order breakdown</h3>
    <div className="mp-invoice-table-scroll"><table className="mp-invoice-table"><caption className="sr-only">Accepted order materials and prices, excluding E-wallet transaction fees</caption><thead><tr><th scope="col">Item</th><th scope="col">Price</th><th scope="col">Qty</th><th scope="col">Amount</th></tr></thead><tbody>{summary.lines.map(line => <tr key={line.orderLineId}><td><span className="font-medium">{line.displayName}</span>{line.category && <span className="mt-1 block text-xs text-text-secondary">{line.category}</span>}</td><td>{amount(line.unitPriceCentavos)}</td><td>{line.quantity?.includes('.') ? line.quantity.replace(/\.?0+$/, '') : line.quantity} {line.unitName}</td><td>{amount(line.lineTotalCentavos)}</td></tr>)}</tbody></table></div>
    <dl className="mp-invoice-breakdown-totals"><div><dt>Materials after discount</dt><dd>{amount(summary.materialsSubtotalCentavos)}</dd></div><div><dt>Delivery fee</dt><dd>{amount(summary.deliveryCentavos)}</dd></div>{Boolean(summary.discountCentavos) && <div><dt>Discount (already applied)</dt><dd>{amount(summary.discountCentavos)}</dd></div>}<div><dt>VAT (included)</dt><dd>{amount(summary.includedVatCentavos)}</dd></div><div className="font-semibold"><dt>Accepted order total</dt><dd>{amount(summary.totalCentavos)}</dd></div></dl>
  </section>
}
