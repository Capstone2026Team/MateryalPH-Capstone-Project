import { useState, type ReactNode } from 'react'
import { FileText } from 'lucide-react'
import { Button } from './button'
import { FormDialog } from './form-dialog'
import { formatPesoCentavos } from './order-patterns'
import { materialPayablePreview } from './material-amounts'
import './work-package-attachment.css'
type Data = Record<string, unknown>
const object = (value: unknown): Data => value && typeof value === 'object' && !Array.isArray(value) ? value as Data : {}
const rows = (value: unknown): Data[] => Array.isArray(value) ? value.map(object) : []
const text = (value: unknown) => value == null ? '' : String(value)
const label = (value: unknown) => {
  const raw = text(value)
  const names: Record<string, string> = { BOTH: 'Pickup or site delivery', PICKUP: 'Pickup', DELIVERY: 'Site delivery', ONLINE: 'Online payment', CASH_ON_DELIVERY: 'Cash on delivery', IN_STORE: 'In-store payment' }
  const readable = raw.replaceAll('_', ' ').toLowerCase()
  return names[raw] ?? readable.charAt(0).toUpperCase() + readable.slice(1)
}
function PackageItems({ content }: { content: Data }) {
  const materials = rows(content.lines)
  const priced = materials.some(line => typeof line.unit_price_centavos === 'number')
  const amounts = materials.map((line, index) => materialPayablePreview([{ id: String(index), quantity: text(line.quantity), unitPriceCentavos: typeof line.unit_price_centavos === 'number' ? line.unit_price_centavos : NaN }], 0))
  const subtotal = materialPayablePreview(materials.map((line, index) => ({ id: String(index), quantity: text(line.quantity), unitPriceCentavos: typeof line.unit_price_centavos === 'number' ? line.unit_price_centavos : NaN })), 0)
  const money = object(content.commercial)
  const materialsAmount = typeof money.materials_payable_centavos === 'number' ? money.materials_payable_centavos : subtotal.valid ? subtotal.grossCentavos : null
  const site = object(content.site), point = object(site.point), destination = object(content.destination)
  const siteName = text(site.name).trim(), address = text(point.formatted_address).trim()
  const siteLabel = address.toLowerCase().includes(siteName.toLowerCase()) ? address : [siteName, address].filter(Boolean).join(' · ')
  const hasTerms = content.fulfillment_method != null || content.payment_method != null || content.fulfillment_date != null || siteLabel || content.site_contact != null || content.access_instructions != null || destination.vehicle_endpoint === 'ALTERNATE_DROP_OFF'
  return <section className="mp-package-items" aria-label="Items">
    <h3 className="mp-package-section-heading">Items ({materials.length})</h3>
    {materials.length > 0 ? <div className="mp-package-table-scroll" role="region" aria-label="Materials table" tabIndex={0}>
      <table className={`mp-package-table ${priced ? 'mp-package-table-priced' : ''}`}>
        <caption className="sr-only">Item details{priced ? ', line totals before discounts and fees' : ''}</caption>
        <thead><tr><th scope="col">Material</th><th scope="col">Qty</th>{priced && <><th scope="col">Unit price</th><th scope="col">Total</th></>}</tr></thead>
        <tbody>{materials.map((line, i) => <tr key={`${text(line.id ?? line.variant_id)}:${i}`}>
          <th scope="row"><span>{text(line.name ?? line.description ?? `Material ${i + 1}`)}</span>
            <div className="mp-package-specifications">
              {line.preferred_brand != null && <p>Preferred brand: {text(line.preferred_brand)}</p>}
              {Object.entries(object(line.specifications)).map(([key, value]) => <p key={key}>{label(key)}: {text(value)}</p>)}
            </div>
          </th>
          <td>{text(line.quantity)} {text(line.unit_code)}</td>
          {priced && <><td>{formatPesoCentavos(typeof line.unit_price_centavos === 'number' ? line.unit_price_centavos : null)}</td><td className="mp-package-line-total">{formatPesoCentavos(amounts[i]?.valid ? amounts[i].grossCentavos : null)}</td></>}
        </tr>)}</tbody>
      </table>
    </div> : <p className="mp-package-empty">No items to display.</p>}
    {materialsAmount !== null && <section className="mp-package-subsection" aria-label="Payment summary">
      <h4 className="mp-package-section-heading">Payment summary</h4>
      <dl className="mp-package-money">
        {typeof money.materials_gross_centavos === 'number' && typeof money.vendor_discount_centavos === 'number' && money.vendor_discount_centavos > 0 && <>
          <div><dt>Materials subtotal</dt><dd>{formatPesoCentavos(money.materials_gross_centavos)}</dd></div>
          <div><dt>Vendor discount (materials)</dt><dd>− {formatPesoCentavos(money.vendor_discount_centavos)}</dd></div>
        </>}
        <div><dt>{typeof money.vendor_discount_centavos === 'number' && money.vendor_discount_centavos > 0 ? 'Materials after discount' : typeof money.materials_payable_centavos === 'number' ? 'Materials' : 'Materials subtotal'}</dt><dd>{formatPesoCentavos(materialsAmount)}</dd></div>
        {typeof money.materials_vat_centavos === 'number' && <div className="mp-package-muted"><dt>Included VAT (in materials)</dt><dd>{formatPesoCentavos(money.materials_vat_centavos)}</dd></div>}
        {(typeof money.delivery_centavos === 'number' || content.fulfillment_method === 'PICKUP') && <div><dt>Delivery fee</dt><dd>{content.fulfillment_method === 'PICKUP' ? 'Not applicable (Self-Pickup)' : formatPesoCentavos(typeof money.delivery_centavos === 'number' ? money.delivery_centavos : null)}</dd></div>}
        {typeof money.nrpc_centavos === 'number' && money.nrpc_centavos > 0 && <div className="mp-package-muted"><dt>NRPC (in materials)</dt><dd>{formatPesoCentavos(money.nrpc_centavos)}</dd></div>}
        {typeof money.commercial_total_centavos === 'number' && <div className="mp-package-total"><dt>Total before e-wallet transaction fee</dt><dd>{formatPesoCentavos(money.commercial_total_centavos)}</dd></div>}
      </dl>
    </section>}
    {hasTerms && <section className="mp-package-subsection" aria-label="Delivery and payment">
      <h4 className="mp-package-section-heading">Delivery &amp; payment</h4>
      <dl className="mp-package-terms">
        {content.fulfillment_method != null && <div><dt>Fulfillment</dt><dd>{label(content.fulfillment_method)}</dd></div>}
        {siteLabel && <div><dt>Project site</dt><dd>{siteLabel}</dd></div>}
        {destination.vehicle_endpoint === 'ALTERNATE_DROP_OFF' && <div><dt>Delivery endpoint</dt><dd>Alternative vehicle drop-off</dd></div>}
        {content.payment_method != null && <div><dt>Payment method</dt><dd>{label(content.payment_method)}</dd></div>}
        {content.fulfillment_date != null && <div><dt>Expected fulfillment</dt><dd>{text(content.fulfillment_date)}</dd></div>}
        {content.site_contact != null && <div><dt>Site contact</dt><dd>{text(content.site_contact)}</dd></div>}
        {content.access_instructions != null && <div><dt>Access instructions</dt><dd>{text(content.access_instructions)}</dd></div>}
      </dl>
    </section>}
  </section>
}
export function WorkPackageAttachment({ reference, proposal, actions, compact = false }: { reference: unknown; proposal?: unknown; actions?: ReactNode; compact?: boolean }) {
  const [open, setOpen] = useState(false)
  const ref = object(reference), saved = object(ref.work_package)
  const order = object(ref.order)
  const scoped = ref.material_scope != null || Array.isArray(ref.vendor_allocations)
  const isOrder = ref.material_scope === 'VENDOR_ORDER'
  const original: Data = scoped ? { ...saved, budget_centavos: undefined,
    ...(Array.isArray(ref.vendor_allocations) ? { lines: rows(ref.vendor_allocations).map(allocation => ({
      ...rows(saved.lines).find(line => line.id === allocation.line_id), ...allocation,
      name: allocation.name ?? rows(saved.lines).find(line => line.id === allocation.line_id)?.name,
    })) } : {}),
  } : saved
  const proposed = object(proposal ?? ref.working_duplicate)
  // An order always uses its snapshot. Before an order, show the current items once.
  const details = !isOrder && Array.isArray(proposed.lines) ? { ...original, ...proposed, name: original.name } : original
  if (!Object.keys(saved).length) return null
  if (compact) return <aside className="shrink-0 border-b border-border-default bg-surface-primary px-4 py-3" aria-label="Attached Work Package">
    <Button variant="quiet" className="w-full justify-start text-left" onClick={() => setOpen(true)} aria-haspopup="dialog"><FileText size={20} aria-hidden="true" /><span className="min-w-0"><strong className="block break-words">{text(original.name) || 'Work Package'}</strong><span className="block text-xs text-text-secondary">Work Package · {rows(details.lines).length} {rows(details.lines).length === 1 ? 'material' : 'materials'} · View details</span></span></Button>
    {open && <FormDialog open size="compact" title="Work Package" description="Items and delivery details." footer={null} onClose={() => setOpen(false)}><WorkPackageAttachment reference={reference} proposal={proposal} actions={actions} /></FormDialog>}
  </aside>
  return <aside className={`mp-package-details ${scoped ? '' : 'mp-card mp-card-padded'}`} aria-label="Work Package details">
    <div className="mp-package-summary"><h2>{text(original.name) || 'Work Package'}</h2>{actions}</div>
    {order.reference != null && <p className="mp-package-order">Order {text(order.reference)}{order.accepted === true ? ' · Accepted terms' : ' · Pending confirmation'}</p>}
    <PackageItems content={details} />
  </aside>
}
