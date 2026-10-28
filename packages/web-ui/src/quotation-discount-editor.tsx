import type { ChatDraftContent, ChatQuotationDiscount } from '@materyalph/api-client-ts'
import { Field } from './field'
import { Select } from './filter-controls'
import { formatPesoCentavos } from './order-patterns'
import { quotationDiscountPreview } from './quotation-discount'

export function QuotationDiscountEditor({ draft, deliveryPending = false, disabled = false, compact = false, onChange }: {
  draft: ChatDraftContent
  deliveryPending?: boolean
  disabled?: boolean
  compact?: boolean
  onChange: (discount: ChatQuotationDiscount) => void
}) {
  return <VendorDiscountEditor discount={draft.discount} fulfillmentMethod={draft.fulfillmentMethod} legacyDiscountCentavos={draft.vendorDiscountCentavos} preview={quotationDiscountPreview(draft)} deliveryPending={deliveryPending} disabled={disabled} compact={compact} onChange={onChange} />
}

export function VendorDiscountEditor({ discount, fulfillmentMethod, preview, legacyDiscountCentavos, deliveryPending = false, disabled = false, compact = false, onChange }: {
  discount?: ChatQuotationDiscount | undefined
  fulfillmentMethod: 'PICKUP' | 'DELIVERY'
  preview: ReturnType<typeof quotationDiscountPreview>
  legacyDiscountCentavos?: number | undefined
  deliveryPending?: boolean
  disabled?: boolean
  compact?: boolean
  onChange: (discount: ChatQuotationDiscount) => void
}) {
  const percent = discount?.percent ?? ''
  const scope = discount?.scope ?? 'MATERIALS'
  return <section aria-label="Vendor discount" className={compact ? 'space-y-3' : 'space-y-3 border-y border-border-default py-3'}>
    <div className={`grid min-w-0 items-end gap-3 ${compact ? '' : 'sm:grid-cols-[9rem_minmax(0,1fr)]'}`}>
      <Field label="Vendor discount (%)" value={percent} placeholder="0 (no discount)" inputMode="decimal" disabled={disabled} onChange={event => onChange({ scope, percent: event.target.value })} />
      <Select label="Apply discount to" value={scope} disabled={disabled} onChange={event => onChange({ scope: event.target.value === 'DELIVERY' ? 'DELIVERY' : 'MATERIALS', percent })}>
        <option value="MATERIALS">Materials only</option>
        <option value="DELIVERY" disabled={fulfillmentMethod !== 'DELIVERY'}>Delivery fee only</option>
      </Select>
    </div>
    {!discount && (legacyDiscountCentavos ?? 0) > 0 && <p className="text-xs text-text-secondary">Saved materials discount: {formatPesoCentavos(legacyDiscountCentavos)}. Enter a percentage to replace it.</p>}
    {deliveryPending && scope === 'DELIVERY' ? <p role="status" className="text-sm text-text-secondary">Choose delivery vehicles and trips to see the deduction and total.</p> : preview.valid ? !compact && <>
      <dl aria-live="polite" className="grid grid-cols-1 gap-2 text-sm sm:grid-cols-3">
        <div><dt className="text-text-secondary">{preview.scope === 'MATERIALS' ? 'Materials' : 'Delivery fee'} before discount</dt><dd className="font-semibold tabular-nums">{formatPesoCentavos(preview.basis)}</dd></div>
        <div><dt className="text-text-secondary">Deduction</dt><dd className="font-semibold tabular-nums">− {formatPesoCentavos(preview.deduction)}</dd></div>
        <div><dt className="text-text-secondary">Estimated order total</dt><dd className="font-semibold tabular-nums">{deliveryPending ? 'Awaiting delivery fee' : formatPesoCentavos(preview.total)}</dd></div>
      </dl>
      <p className="text-xs text-text-secondary">Materials {formatPesoCentavos(preview.materialsPayable)} · {deliveryPending ? 'Delivery awaiting confirmation' : `Delivery ${formatPesoCentavos(preview.deliveryPayable)}`} · Before payment processing fees.</p>
    </> : <p role="status" className="text-sm text-text-secondary">{preview.message}</p>}
  </section>
}
