import { useId, useState } from 'react'
import type { ChatDraftLine, QuantityPolicy } from '@materyalph/api-client-ts'
import { ChevronDown, Trash2 } from 'lucide-react'
import { Button } from './button'
import { Field } from './field'
import { QuantityField } from './quantity-field'
import { MoneyField } from './money-field'
import { formatPesoCentavos } from './order-patterns'
import { SpecificationFields } from './specification-fields'

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
    <div className="hidden grid-cols-[minmax(0,1fr)_5.5rem_9rem_7rem] gap-2 px-3 text-xs text-text-secondary sm:grid" aria-hidden="true">
      <span>Material</span><span>Quantity</span><span>Unit price (₱)</span><span className="sr-only">Actions</span>
    </div>
    <ul className="min-w-0 divide-y divide-border-default rounded-control border border-border-default">
      {lines.map((line, index) => {
        const name = line.description?.trim() || names[line.variantId] || `Product line ${index + 1}`
        const details = productDetails[line.variantId]
        const specifications = line.specifications ?? details?.specifications ?? {}
        const preview = Object.entries(specifications).filter(([, value]) => value.trim()).map(([key, value]) => `${key.replace(/[_-]+/g, ' ')}: ${value}`).join(' · ')
        const expanded = expandedId === line.variantId
        const detailsId = `${editorId}-${line.variantId}`
        return <li key={line.variantId} className="min-w-0">
          <div className="grid min-w-0 grid-cols-[minmax(0,1fr)_minmax(0,1fr)_auto] items-center gap-2 px-3 py-2 sm:grid-cols-[minmax(0,1fr)_5.5rem_9rem_7rem]">
            <div className="col-span-2 min-w-0 sm:col-span-1">
              <p className="break-words text-sm font-semibold">{name}</p>
              <p className="mt-0.5 truncate text-xs text-text-secondary" title={preview}>{line.unitPriceCentavos > 0 ? formatPesoCentavos(line.unitPriceCentavos) : 'Enter a unit price'}{preview ? ` · ${preview}` : ''}</p>
            </div>
            <div className="col-start-1 row-start-2 min-w-0 sm:col-start-2 sm:row-start-1 sm:[&_label]:sr-only">
              <QuantityField unitCode={details?.unitCode ?? line.unitCode ?? ''} policy={details?.quantityPolicy ?? line.quantityPolicy} label={details?.unitCode || line.unitCode ? undefined : 'Quantity'} aria-label={`Quantity for ${name}`} disabled={disabled} inputMode="decimal" value={line.quantity} onChange={event => onChange(line.variantId, { quantity: event.target.value })} />
            </div>
            <div className="col-span-2 col-start-2 row-start-2 min-w-0 sm:col-span-1 sm:col-start-3 sm:row-start-1 sm:[&_label]:sr-only">
              <MoneyField label="Unit price (₱)" aria-label={`Unit price in pesos for ${name}`} disabled={disabled} valueCentavos={line.unitPriceCentavos > 0 ? line.unitPriceCentavos : null} minCentavos={1} maxCentavos={100000000000} onChange={value => onChange(line.variantId, { unitPriceCentavos: value ?? 0 })} />
            </div>
            <div className="col-start-3 row-start-1 flex justify-end gap-1 sm:col-start-4">
              <Button variant="quiet" disabled={disabled} aria-label={`Edit details for ${name}`} title="Edit description and specifications" aria-expanded={expanded} aria-controls={detailsId} onClick={() => setExpandedId(expanded ? null : line.variantId)}><ChevronDown size={18} aria-hidden="true" className={expanded ? 'rotate-180' : ''} /></Button>
              <Button variant="quiet" disabled={disabled} aria-label={`Remove ${name}`} title="Remove material" onClick={() => { if (expanded) setExpandedId(null); onRemove(line.variantId) }}><Trash2 size={18} aria-hidden="true" /></Button>
            </div>
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
