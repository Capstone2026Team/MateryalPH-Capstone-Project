import { useId, useState } from 'react'
import type { ChatDraftLine, QuantityPolicy } from '@materyalph/api-client-ts'
import { ChevronDown, Trash2 } from 'lucide-react'
import { Button } from './button'
import { Field } from './field'
import { QuantityField } from './quantity-field'
import { MoneyField } from './money-field'
import { formatPesoCentavos } from './order-patterns'
import { SpecificationFields } from './specification-fields'
import { materialPayablePreview } from './material-amounts'

type MaterialDetails = { variantLabel: string; specifications: Record<string, string>; unitCode?: string; quantityPolicy?: QuantityPolicy | undefined }

/** Compact material rows with one optional details editor open at a time. */
export function QuotationMaterialsEditor({ lines, names, productDetails, disabled = false, onChange, onRemove }: {
  lines: ChatDraftLine[]
  names: Record<string, string>
  productDetails: Record<string, MaterialDetails>
  disabled?: boolean
  onChange: (variantId: string, patch: Partial<ChatDraftLine>) => void
  onRemove: (variantId: string) => void
}) {
  const [expandedId, setExpandedId] = useState<string | null>(null)
  const editorId = useId()
  if (!lines.length) return null

  return <section aria-label="Added quotation materials" className="min-w-0 space-y-2">
    <h4 className="text-sm font-semibold" aria-live="polite">Added materials ({lines.length})</h4>
    <ul className="min-w-0 divide-y divide-border-default rounded-control border border-border-default">
      {lines.map((line, index) => {
        const name = line.description?.trim() || names[line.variantId] || `Product line ${index + 1}`
        const details = productDetails[line.variantId]
        const specifications = line.specifications ?? details?.specifications ?? {}
        const preview = Object.entries(specifications).filter(([, value]) => value.trim()).map(([key, value]) => `${key.replace(/[_-]+/g, ' ')}: ${value}`).join(' · ')
        const expanded = expandedId === line.variantId
        const detailsId = `${editorId}-${line.variantId}`
        const subtotal = materialPayablePreview([{ id: line.variantId, quantity: line.quantity, unitPriceCentavos: line.unitPriceCentavos }], 0)
        return <li key={line.variantId} className="min-w-0">
          <div className="grid min-w-0 grid-cols-2 items-end gap-3 p-3 sm:grid-cols-[5.5rem_9rem_minmax(0,1fr)] sm:p-4">
            <div className="col-span-2 flex min-w-0 items-start justify-between gap-2 sm:col-span-3">
            <div className="min-w-0">
              <p className="break-words text-sm font-semibold">{name}</p>
              {preview && <p className="mt-1 break-words text-xs text-text-secondary">{preview}</p>}
            </div>
            <div className="flex shrink-0 gap-1">
              <Button variant="quiet" disabled={disabled} aria-label={`Edit details for ${name}`} title="Edit description and specifications" aria-expanded={expanded} aria-controls={detailsId} onClick={() => setExpandedId(expanded ? null : line.variantId)}><ChevronDown size={18} aria-hidden="true" className={expanded ? 'rotate-180' : ''} /></Button>
              <Button variant="quiet" disabled={disabled} aria-label={`Remove ${name}`} title="Remove material" onClick={() => { if (expanded) setExpandedId(null); onRemove(line.variantId) }}><Trash2 size={18} aria-hidden="true" /></Button>
            </div>
            </div>
            <div className="min-w-0">
              <QuantityField unitCode={details?.unitCode ?? line.unitCode ?? ''} policy={details?.quantityPolicy ?? line.quantityPolicy} label={details?.unitCode || line.unitCode ? undefined : 'Quantity'} aria-label={`Quantity for ${name}`} disabled={disabled} inputMode="decimal" value={line.quantity} onChange={event => onChange(line.variantId, { quantity: event.target.value })} />
            </div>
            <div className="min-w-0">
              <MoneyField label="Unit price (₱)" aria-label={`Unit price in pesos for ${name}`} disabled={disabled} valueCentavos={line.unitPriceCentavos > 0 ? line.unitPriceCentavos : null} minCentavos={1} maxCentavos={100000000000} onChange={value => onChange(line.variantId, { unitPriceCentavos: value ?? 0 })} />
            </div>
            <dl aria-label={`Subtotal for ${name}`} className="col-span-2 flex flex-wrap items-baseline justify-between gap-1 text-sm sm:col-span-1 sm:block sm:pb-2 sm:text-right"><dt className="text-xs text-text-secondary">Line subtotal</dt><dd className="font-semibold tabular-nums sm:mt-2">{subtotal.valid ? formatPesoCentavos(subtotal.grossCentavos) : '—'}</dd></dl>
          </div>
          <div id={detailsId} hidden={!expanded} className="space-y-3 border-t border-border-default bg-surface-canvas p-3">
            {expanded && <>
              <Field label="Description" disabled={disabled} maxLength={200} value={line.description ?? ''} onChange={event => onChange(line.variantId, { description: event.target.value })} />
              <SpecificationFields disabled={disabled} variantLabel={details?.variantLabel ?? ''} value={specifications} onChange={value => onChange(line.variantId, { specifications: value })} />
            </>}
          </div>
        </li>
      })}
    </ul>
  </section>
}
