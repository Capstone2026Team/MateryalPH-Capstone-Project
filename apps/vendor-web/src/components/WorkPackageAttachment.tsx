import { formatPesoCentavos } from '@materyalph/web-ui'

type Data = Record<string, unknown>
const object = (value: unknown): Data => value && typeof value === 'object' && !Array.isArray(value) ? value as Data : {}
const rows = (value: unknown): Data[] => Array.isArray(value) ? value.map(object) : []
const text = (value: unknown) => value == null ? '' : String(value)

function Copy({ title, content }: { title: string; content: Data }) {
  return <section className="min-w-0 rounded-panel border border-border-default bg-surface-raised p-5" aria-label={title}>
    <h3 className="text-base font-semibold">{title}</h3>
    {content.name != null && <p className="mt-2 font-medium">{text(content.name)}</p>}
    {typeof content.budget_centavos === 'number' && <p className="mt-1 text-sm">Budget {formatPesoCentavos(content.budget_centavos)}</p>}
    <p className="mt-2 text-sm text-text-secondary">{text(content.fulfillment_method)} · {text(content.payment_method)}</p>
    {content.fulfillment_date != null && <p className="text-sm">Fulfillment: {text(content.fulfillment_date)}</p>}
    <ol className="mt-4 divide-y divide-border-default">{rows(content.lines).map((line, i) => <li className="py-3" key={`${text(line.id ?? line.variant_id)}:${i}`}>
      <p className="font-medium">{text(line.name ?? line.description ?? `Material ${i + 1}`)}</p>
      <p className="text-sm">{text(line.quantity)} {text(line.unit_code)}</p>
      {line.preferred_brand != null && <p className="text-sm">Preferred brand: {text(line.preferred_brand)}</p>}
      {Object.entries(object(line.specifications)).map(([key, value]) => <p className="text-sm text-text-secondary" key={key}>{key}: {text(value)}</p>)}
      {typeof line.unit_price_centavos === 'number' && <p className="text-sm">Unit price {formatPesoCentavos(line.unit_price_centavos)}</p>}
    </li>)}</ol>
  </section>
}

export function WorkPackageAttachment({ reference, proposal }: { reference: unknown; proposal?: unknown }) {
  const ref = object(reference), original = object(ref.work_package)
  if (!Object.keys(original).length) return null
  const site = object(original.site), point = object(site.point), destination = object(original.destination)
  return <aside className="space-y-3 p-4 sm:p-5" aria-label="Work Package comparison">
    <div><h2 className="text-lg font-semibold">Work Package · locked original</h2><p className="mt-1 text-sm text-text-secondary">Site: {text(site.name)} · {text(point.formatted_address)}</p><p className="text-sm">Delivery endpoint: {destination.vehicle_endpoint === 'ALTERNATE_DROP_OFF' ? 'Alternative vehicle drop-off' : 'Project site'} · Project site remains the discovery origin.</p></div>
    <div className="grid min-w-0 gap-4 lg:grid-cols-2"><Copy title="Buyer original" content={original} /><Copy title="Vendor working duplicate / proposal" content={object(proposal ?? ref.working_duplicate)} /></div>
    <p className="text-xs text-text-secondary">Locked Work Package version {text(ref.version ?? 'saved')}</p>
    <p className="text-sm text-text-secondary">System delivery estimates are advisory. Owner/Manager-confirmed accepted terms create the delivery arrangement.</p>
    <button type="button" disabled className="min-h-11 rounded-control border border-border-default px-4 text-sm text-text-secondary">Work Package PDF · Phase 15</button>
  </aside>
}
