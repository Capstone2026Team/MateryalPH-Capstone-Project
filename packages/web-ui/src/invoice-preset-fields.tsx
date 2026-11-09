import { useId } from 'react'

export type InvoicePresetValues = { invoiceType: string; issuerName: string; sourceSystem: string; invoicingMethod: string }
const documentTypes = { VENDOR_GOODS_INVOICE: 'Sales invoice', VENDOR_ADJUSTMENT_DOCUMENT: 'Adjustment document' }
const sources = { REGISTERED_CAS: 'Registered CAS / accounting system', BIR_EIS: 'BIR EIS', LOOSE_LEAF_OR_PRINTED: 'Loose-leaf or printed (ATP)', OTHER_REGISTERED: 'Other registered process' }
const methods = { ELECTRONIC: 'Electronic', COMPUTERIZED: 'Computerized', MANUAL: 'Manual' }
export function invoicePreparationLabel(kind: 'document' | 'source' | 'method', code: string): string {
  const labels: Record<string, string> = kind === 'document' ? documentTypes : kind === 'source' ? sources : methods
  return labels[code] ?? code
}
const field = 'min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base font-normal'

/** Reusable business defaults shared by the invoice popup and store preset settings. */
export function InvoicePresetFields({ value, onChange, registeredName, disabled = false, issuerError, invoiceTypes = Object.keys(documentTypes), sourceSystems = Object.keys(sources), invoicingMethods = Object.keys(methods) }: {
  value: InvoicePresetValues; onChange: (next: InvoicePresetValues) => void; registeredName: string; disabled?: boolean; issuerError?: string | undefined; invoiceTypes?: string[]; sourceSystems?: string[]; invoicingMethods?: string[]
}) {
  const id = useId()
  const label = (labels: Record<string, string>, code: string) => labels[code] ?? code
  return <div className="grid min-w-0 gap-4 sm:grid-cols-2">
    <label className="grid min-w-0 content-start gap-2 text-sm font-semibold">Document type<select className={field} disabled={disabled} value={value.invoiceType} onChange={event => onChange({ ...value, invoiceType: event.target.value })}>{invoiceTypes.map(code => <option key={code} value={code}>{label(documentTypes, code)}</option>)}</select></label>
    <div className="grid min-w-0 content-start gap-2 text-sm font-semibold"><label htmlFor={`${id}-issuer`}>Issuer (registered business name)</label><input id={`${id}-issuer`} aria-invalid={Boolean(issuerError)} aria-describedby={`${id}-issuer-hint${issuerError ? ` ${id}-issuer-error` : ''}`} className={field} disabled={disabled} value={value.issuerName} maxLength={240} onChange={event => onChange({ ...value, issuerName: event.target.value })} /><p id={`${id}-issuer-hint`} className="text-xs font-normal leading-5 text-text-secondary">Must match: {registeredName}</p>{issuerError && <p id={`${id}-issuer-error`} role="alert" className="text-sm font-normal text-status-error">{issuerError}</p>}</div>
    <label className="grid min-w-0 content-start gap-2 text-sm font-semibold">Issued through<select className={field} disabled={disabled} value={value.sourceSystem} onChange={event => onChange({ ...value, sourceSystem: event.target.value })}>{sourceSystems.map(code => <option key={code} value={code}>{label(sources, code)}</option>)}</select></label>
    <label className="grid min-w-0 content-start gap-2 text-sm font-semibold">Invoicing method<select className={field} disabled={disabled} value={value.invoicingMethod} onChange={event => onChange({ ...value, invoicingMethod: event.target.value })}>{invoicingMethods.map(code => <option key={code} value={code}>{label(methods, code)}</option>)}</select></label>
  </div>
}
