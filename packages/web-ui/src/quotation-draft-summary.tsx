import type { ReactNode } from 'react'
import type { ChatDraftContent, ChatQuotationDiscount } from '@materyalph/api-client-ts'
import { formatPesoCentavos } from './order-patterns'
import { quotationDiscountPreview } from './quotation-discount'
import { QuotationDiscountEditor } from './quotation-discount-editor'

/** Shared quotation hierarchy keeps the reading and keyboard order linear. */
export function QuotationEditorSection({ number, title, description, children }: { number: number; title: string; description: string; children: ReactNode }) {
  return <section aria-label={title} className="min-w-0 space-y-4 rounded-surface border border-border-default bg-surface-primary p-3 sm:p-5">
    <div className="flex items-start gap-3 border-b border-border-default pb-4">
      <span aria-hidden="true" className="flex size-7 shrink-0 items-center justify-center rounded-full border border-border-default bg-surface-canvas text-xs font-semibold tabular-nums">{number}</span>
      <div className="min-w-0"><h3 className="font-semibold">{title}</h3><p className="mt-1 text-xs text-text-secondary sm:text-sm">{description}</p></div>
    </div>
    {children}
  </section>
}

export function QuotationDraftSummary({ draft, deliveryPending, disabled, onDiscountChange }: {
  draft: ChatDraftContent
  deliveryPending: boolean
  disabled: boolean
  onDiscountChange: (discount: ChatQuotationDiscount) => void
}) {
  const amounts = quotationDiscountPreview(draft)
  return <aside aria-label="Quotation order summary" className="min-w-0 self-start rounded-surface border border-border-default bg-surface-primary p-4 lg:sticky lg:top-0">
    <h3 className="font-semibold">Order summary</h3>
    <p className="mt-1 text-xs text-text-secondary">{draft.lines.length} material {draft.lines.length === 1 ? 'line' : 'lines'} · {draft.fulfillmentMethod === 'DELIVERY' ? 'Site Delivery' : 'Self-Pickup'}</p>
    <div className="my-4 border-y border-border-default py-4">
      <QuotationDiscountEditor compact draft={draft} deliveryPending={deliveryPending} disabled={disabled} onChange={onDiscountChange} />
    </div>
    <dl className="space-y-3 text-sm">
      <div className="flex flex-wrap justify-between gap-x-3 gap-y-1"><dt className="text-text-secondary">Materials subtotal</dt><dd className="font-medium tabular-nums">{amounts.valid ? formatPesoCentavos(amounts.materialsGross) : '—'}</dd></div>
      <div className="flex flex-wrap justify-between gap-x-3 gap-y-1"><dt className="text-text-secondary">Delivery fee</dt><dd className="font-medium tabular-nums">{draft.fulfillmentMethod === 'PICKUP' ? 'Not applicable' : deliveryPending ? 'Awaiting fee' : amounts.valid ? formatPesoCentavos(amounts.deliveryGross) : '—'}</dd></div>
      <div className="flex flex-wrap justify-between gap-x-3 gap-y-1"><dt className="text-text-secondary">Discount{amounts.valid && amounts.deduction > 0 ? ` · ${amounts.scope === 'MATERIALS' ? 'materials' : 'delivery'}` : ''}</dt><dd className="font-medium tabular-nums">{amounts.valid && !(deliveryPending && amounts.scope === 'DELIVERY') ? `${amounts.deduction > 0 ? '− ' : ''}${formatPesoCentavos(amounts.deduction)}` : '—'}</dd></div>
      <div className="border-t border-border-default pt-4"><dt className="font-semibold">Quotation order total</dt><dd aria-live="polite" aria-atomic="true" className="mt-1 break-words text-2xl font-semibold tracking-tight tabular-nums">{amounts.valid && !deliveryPending ? formatPesoCentavos(amounts.total) : <span className="text-base font-medium text-text-secondary">{deliveryPending ? 'Awaiting delivery fee' : 'Complete materials'}</span>}</dd></div>
    </dl>
    <p className="mt-2 text-xs leading-relaxed text-text-secondary">After discounts, before payment processing fees. The Buyer reviews these terms before accepting.</p>
  </aside>
}
