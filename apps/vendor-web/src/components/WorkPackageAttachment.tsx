import type { ReactNode } from 'react'
import { formatPesoCentavos } from '@materyalph/web-ui'

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

function Copy({ title, content }: { title: string; content: Data }) {
  return <section className="min-w-0 rounded-panel border border-border-default bg-surface-primary p-5" aria-label={title}>
    <h3 className="text-base font-semibold">{title}</h3>
    {content.name != null && <p className="mt-2 font-medium">{text(content.name)}</p>}
    {typeof content.budget_centavos === 'number' && <p className="mt-1 text-sm">Budget {formatPesoCentavos(content.budget_centavos)}</p>}
    {(content.fulfillment_method != null || content.payment_method != null) && <p className="mt-2 text-sm text-text-secondary">{[content.fulfillment_method, content.payment_method].filter(value => value != null).map(label).join(' · ')}</p>}
    {content.fulfillment_date != null && <p className="text-sm">Fulfillment: {text(content.fulfillment_date)}</p>}
    <p className="mt-4 text-sm font-semibold text-text-secondary">Materials ({rows(content.lines).length})</p>
    <ol className="mt-2 divide-y divide-border-default">{rows(content.lines).map((line, i) => <li className="py-3" key={`${text(line.id ?? line.variant_id)}:${i}`}>
      <div className="flex flex-wrap items-start justify-between gap-2"><p className="font-medium">{text(line.name ?? line.description ?? `Material ${i + 1}`)}</p>
      <p className="text-sm font-semibold text-action-primary">{text(line.quantity)} {text(line.unit_code)}</p></div>
      {line.preferred_brand != null && <p className="text-sm">Preferred brand: {text(line.preferred_brand)}</p>}
      {Object.entries(object(line.specifications)).map(([key, value]) => <p className="text-sm text-text-secondary" key={key}>{label(key)}: {text(value)}</p>)}
      {typeof line.unit_price_centavos === 'number' && <p className="text-sm">Unit price {formatPesoCentavos(line.unit_price_centavos)}</p>}
    </li>)}</ol>
  </section>
}

export function WorkPackageAttachment({ reference, proposal, actions }: { reference: unknown; proposal?: unknown; actions?: ReactNode }) {
  const ref = object(reference), original = object(ref.work_package)
  if (!Object.keys(original).length) return null
  const site = object(original.site), point = object(site.point), destination = object(original.destination)
  const proposed = object(proposal ?? ref.working_duplicate)
  const siteName = text(site.name).trim(), address = text(point.formatted_address).trim()
  const siteLabel = address.toLowerCase().includes(siteName.toLowerCase()) ? address : [siteName, address].filter(Boolean).join(' · ')
  return <aside className="space-y-4 rounded-surface border border-border-default bg-surface-primary p-4 sm:p-5" aria-label="Work Package comparison">
    <div className="flex flex-wrap items-start justify-between gap-3"><div><h2 className="text-lg font-semibold">Work Package</h2><p className="mt-1 text-xs text-text-secondary">Locked Buyer original / version {text(ref.version ?? 'saved')}</p></div>{actions}</div>
    <div><p className="text-sm text-text-secondary">Site: {siteLabel || 'Project site'}</p><p className="mt-1 text-sm text-text-secondary">Delivery endpoint: {destination.vehicle_endpoint === 'ALTERNATE_DROP_OFF' ? 'Alternative vehicle drop-off' : 'Project site'} / Project site remains the discovery origin.</p></div>
    {ref.arrangement_id != null && <div className="space-y-3">
      <p className="text-sm text-text-secondary">You are a member of this Work Package’s quotation group. Quote and confirm only the materials assigned to your store. Other vendors manage their own quotations and orders.</p>
      <Copy title="Your assigned materials" content={{ lines: rows(ref.vendor_allocations) }} />
    </div>}
    <div className={`grid min-w-0 items-start gap-4 ${Object.keys(proposed).length ? 'lg:grid-cols-2' : ''}`}><Copy title="Buyer original" content={original} />{Object.keys(proposed).length > 0 && <Copy title="Vendor working duplicate / proposal" content={proposed} />}</div>
    <p className="text-sm text-text-secondary">System delivery estimates are advisory. Owner/Manager-confirmed accepted terms create the delivery arrangement.</p>
  </aside>
}
