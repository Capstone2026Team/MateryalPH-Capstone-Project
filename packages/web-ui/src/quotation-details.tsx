import type { ChatQuotationContent, ChatQuotationLine } from '@materyalph/api-client-ts'
import { formatPesoCentavos } from './order-patterns'

const quantity = (value: string) => value.includes('.') ? value.replace(/0+$/, '').replace(/\.$/, '') : value
const specificationLabel = (code: string) => code.split(/[_-]+/).map(word => ['mm', 'cm', 'm', 'kg', 'psi', 'mpa'].includes(word.toLowerCase()) ? `(${word.toLowerCase() === 'mpa' ? 'MPa' : word.toLowerCase() === 'psi' ? 'PSI' : word})` : word.charAt(0).toUpperCase() + word.slice(1)).join(' ')

export function QuotationMaterialLines({ lines }: { lines: ChatQuotationLine[] }) {
  return <section className="mt-5" aria-label="Quoted materials">
    <h4 className="text-sm font-semibold">Materials</h4>
    <ul className="mt-3 divide-y divide-border-default">{lines.map(line => {
      const specifications = Object.entries(line.specifications ?? {}).filter(([, value]) => value.trim())
      const details = [
        ...(line.brand?.trim() ? [['Brand', line.brand]] : []),
        ...(line.variantLabel?.trim() ? [['Variant', line.variantLabel]] : []),
        ...specifications.map(([code, value]) => [specificationLabel(code), value]),
      ]
      return <li key={line.variantId} className="min-w-0 py-3 first:pt-0">
        <p className="break-words font-semibold">{line.description}</p>
        <p className="mt-1 text-sm text-text-secondary">{quantity(line.quantity)} {line.unitCode} × {formatPesoCentavos(line.unitPriceCentavos)}</p>
        {details.length > 0 ? <dl aria-label={`Technical details for ${line.description}`} className="mt-3 flex flex-wrap gap-2">{details.map(([label, value], index) => <div key={`${label}-${index}`} className="flex min-w-0 flex-wrap gap-x-1 rounded-control bg-surface-canvas px-2 py-1 text-xs"><dt className="text-text-secondary">{label}:</dt><dd className="min-w-0 break-words font-medium">{value}</dd></div>)}</dl>
          : <p className="mt-2 text-xs text-text-secondary">Technical details not recorded for this quotation.</p>}
      </li>
    })}</ul>
  </section>
}

function QuotationMoneyRow({ label, value, strong = false, muted = false }: { label: string; value: string; strong?: boolean; muted?: boolean }) {
  return <div className={`flex min-w-0 flex-wrap items-start justify-between gap-x-3 gap-y-1 ${strong ? 'text-base font-semibold' : 'text-sm'} ${muted ? 'text-text-secondary' : ''}`}>
    <dt className="min-w-0 flex-1 basis-40">{label}</dt><dd className="min-w-0 break-words text-right tabular-nums">{value}</dd>
  </div>
}

export function QuotationPaymentBreakdown({ content, selectedPaymentMethod, accepted = false }: { content: ChatQuotationContent; selectedPaymentMethod?: string | null; accepted?: boolean }) {
  const money = content.commercial
  const materialDiscount = money.vendorDiscountCentavos
  const directPhysical = selectedPaymentMethod && selectedPaymentMethod !== 'ONLINE' && money.nrpcCentavos === 0
  const deliveryDiscount = content.discount?.scope === 'DELIVERY' && content.discount.deductionCentavos > 0 ? content.discount : null
  const percent = content.discount?.percent
  const materialDiscountLabel = `Vendor discount (materials${content.discount?.scope === 'MATERIALS' && percent ? ` · ${percent}%` : ''})`
  return <>
    <section aria-label="Payment breakdown" className="mt-4 border-t border-border-default pt-4">
      <h4 className="mb-3 font-semibold">Payment breakdown</h4>
      <dl className="grid gap-3">
        {materialDiscount > 0 && money.materialsGrossCentavos !== undefined && <QuotationMoneyRow label="Materials subtotal" value={formatPesoCentavos(money.materialsGrossCentavos)} />}
        {materialDiscount > 0 && <QuotationMoneyRow label={materialDiscountLabel} value={`− ${formatPesoCentavos(materialDiscount)}`} />}
        <QuotationMoneyRow label={materialDiscount > 0 ? 'Materials after discounts' : 'Materials'} value={formatPesoCentavos(money.materialsPayableCentavos)} />
        <QuotationMoneyRow label="Included VAT (in materials)" value={formatPesoCentavos(money.materialsVatCentavos)} muted />
        {deliveryDiscount ? <>
          <QuotationMoneyRow label="Delivery subtotal" value={formatPesoCentavos(deliveryDiscount.basisCentavos)} />
          <QuotationMoneyRow label={`Vendor discount (delivery · ${deliveryDiscount.percent}%)`} value={`− ${formatPesoCentavos(deliveryDiscount.deductionCentavos)}`} />
          <QuotationMoneyRow label="Delivery after discounts" value={formatPesoCentavos(money.deliveryCentavos)} />
        </> : <QuotationMoneyRow label={content.fulfillmentMethod === 'PICKUP' ? 'Delivery (Self-Pickup)' : 'Delivery'} value={formatPesoCentavos(money.deliveryCentavos)} />}
      </dl>
      <p className="mt-2 text-xs text-text-secondary">VAT is already included in the materials amount.</p>
      <dl className="mt-4 border-t border-border-default pt-4"><QuotationMoneyRow label="Total before processing fee" value={formatPesoCentavos(money.commercialTotalCentavos)} strong /></dl>
      <dl className="mt-3"><QuotationMoneyRow label="Processing fee" value={directPhysical ? 'Not applicable' : 'Pending'} muted /></dl>
      <p className="mt-1 text-xs text-text-secondary">{directPhysical ? 'No online processing fee for this payment method.' : 'Calculated when a payment channel is selected.'}</p>
      {money.nrpcCentavos > 0 && <dl className="mt-3 rounded-control bg-surface-canvas p-3"><QuotationMoneyRow label="NRPC included in total" value={formatPesoCentavos(money.nrpcCentavos)} /></dl>}
    </section>
    <section aria-label="Fulfillment and payment" className="mt-4 border-t border-border-default pt-4">
      <h4 className="mb-3 font-semibold">Fulfillment &amp; payment</h4>
      <dl className="grid gap-3">
        <QuotationMoneyRow label="Fulfillment" value={content.fulfillmentMethod === 'PICKUP' ? 'Self-Pickup' : 'Site Delivery'} />
        <QuotationMoneyRow label="Fulfillment date" value={content.fulfillmentDate} />
        <QuotationMoneyRow label="Payment method" value={selectedPaymentMethod ? ({ ONLINE: 'Online payment', CASH_ON_DELIVERY: 'Cash on Delivery', IN_STORE: 'In-Store Payment' } as Record<string, string>)[selectedPaymentMethod] ?? selectedPaymentMethod : accepted ? 'See Order Details' : 'Buyer selects before accepting'} />
      </dl>
    </section>
  </>
}
