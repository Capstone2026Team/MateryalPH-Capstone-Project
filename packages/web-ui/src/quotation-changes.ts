import type { ChatQuotationContent } from '@materyalph/api-client-ts'
import { formatPesoCentavos } from './order-patterns'

export interface QuotationChangeNote { title: string; before?: string; after?: string }

const record = (value: unknown): Record<string, unknown> => value !== null && typeof value === 'object' && !Array.isArray(value) ? value as Record<string, unknown> : {}
const text = (value: unknown) => typeof value === 'string' || typeof value === 'number' ? String(value) : undefined
const quantity = (value: unknown) => text(value)?.replace(/(\.\d*?)0+$/, '$1').replace(/\.$/, '')
const money = (value: unknown) => value !== null && value !== undefined && text(value)?.trim() && Number.isSafeInteger(Number(value)) ? formatPesoCentavos(Number(value)) : undefined
const fulfillment: Record<string, string> = { PICKUP: 'Self-Pickup', DELIVERY: 'Site Delivery', BOTH: 'Self-Pickup or Site Delivery' }
const payment: Record<string, string> = { ONLINE: 'Online payment', CASH_ON_DELIVERY: 'Cash on Delivery', IN_STORE: 'Pay in store' }

/** A presentation allowlist: immutable API diffs keep their full audit data. */
export function quotationChangeNotes(content: ChatQuotationContent): QuotationChangeNote[] {
  const notes: QuotationChangeNote[] = []
  const seen = new Set<string>()
  function add(title: string, before?: string, after?: string) {
    if (before !== undefined && before === after) return
    const key = JSON.stringify([title, before, after])
    if (!seen.has(key)) { seen.add(key); notes.push({ title, ...(before !== undefined ? { before } : {}), ...(after !== undefined ? { after } : {}) }) }
  }
  function product(value: unknown, index: number, added: boolean) {
    const line = record(value)
    const amount = quantity(line.quantity)
    add(`${added ? 'Added' : 'Removed'} · ${text(line.description) ?? `Product ${index + 1}`}`, undefined,
      amount === undefined ? undefined : `${amount} ${text(line.unit_code) ?? ''}`.trim())
  }
  const percent = (value: unknown) => text(value) === undefined ? undefined : `${text(value)}%`
  const discount = (value: unknown) => {
    const row = record(value)
    const amount = percent(row.percent)
    return amount === undefined ? undefined : `${amount} · ${row.scope === 'DELIVERY' ? 'delivery fee' : 'materials'}`
  }
  const deliveryFee = (value: unknown) => { const row = record(value); return money(row.final_charge_centavos ?? row.final_fee_centavos) }
  const address = (value: unknown) => {
    const row = record(value)
    const intended = record(row.intended)
    return text(intended.formatted_address ?? intended.address ?? row.formatted_address ?? row.address)
  }
  for (const change of content.changes) {
    const before: unknown = change.before
    const after: unknown = change.after
    if (change.path === 'lines') {
      if (before == null && Array.isArray(after)) after.forEach((line: unknown, index) => product(line, index, true))
      else if (after == null && Array.isArray(before)) before.forEach((line: unknown, index) => product(line, index, false))
      else add('Materials updated')
      continue
    }
    const line = /^lines\.(\d+)(?:\.(.+))?$/.exec(change.path)
    if (line) {
      const index = Number(line[1])
      if (!line[2]) { product(before ?? after, index, before == null); continue }
      const item = content.lines[index]
      const name = item?.description ?? `Product ${index + 1}`
      const changedUnit = content.changes.find(row => row.path === `lines.${index}.unit_code`)
      const unit = (value: unknown, code = item?.unitCode) => quantity(value) === undefined ? undefined : `${quantity(value)} ${code ?? ''}`.trim()
      switch (line[2]) {
        case 'quantity': add(`${name} · Quantity`, unit(before, text(changedUnit?.before) ?? item?.unitCode), unit(after)); break
        case 'unit_price_centavos': add(`${name} · Unit price`, money(before), money(after)); break
        case 'description': add(`${name} · Item`, text(before), text(after)); break
        case 'brand': case 'preferred_brand': add(`${name} · Brand`, text(before), text(after)); break
        case 'unit_code': add(`${name} · Unit`, text(before), text(after)); break
        case 'variant_id': add(`${name} · Product updated`); break
        default: if (line[2] === 'specifications' || line[2].startsWith('specifications.')) add(`${name} · Specifications updated`)
      }
      continue
    }
    const vehicle = /^delivery\.vehicles(?:\.\d+)?(?:\.(vehicle_id|number_of_vehicles|total_vehicle_trips))?$/.exec(change.path)
    if (vehicle) {
      if (vehicle[1] === 'number_of_vehicles') add('Delivery vehicle count', quantity(before), quantity(after))
      else if (vehicle[1] === 'total_vehicle_trips') add('Delivery trips', quantity(before), quantity(after))
      else add('Delivery vehicle updated')
      continue
    }
    if (change.path === 'nrpc.allocations' || change.path.startsWith('nrpc.allocations.')) { add('NRPC affected materials updated'); continue }
    if (change.path === 'nrpc.terms' || change.path.startsWith('nrpc.terms.')) { add('NRPC terms updated'); continue }
    switch (change.path) {
      case 'fulfillment_method': add('Fulfillment', fulfillment[String(before)], fulfillment[String(after)]); break
      case 'payment_method': add('Payment method', payment[String(before)], payment[String(after)]); break
      case 'fulfillment_date': add('Fulfillment date', text(before), text(after)); break
      case 'delivery': add(after == null ? 'Delivery removed' : 'Delivery fee', deliveryFee(before), deliveryFee(after)); break
      case 'delivery.final_charge_centavos': case 'delivery.final_fee_centavos': add('Delivery fee', money(before), money(after)); break
      case 'discount':
        if (before != null || Number(record(after).percent) !== 0) add('Vendor discount', discount(before), discount(after))
        break
      case 'discount.percent': add('Vendor discount', percent(before), percent(after)); break
      case 'discount.scope': add('Discount applies to', before == null ? undefined : before === 'DELIVERY' ? 'Delivery fee' : 'Materials', after == null ? undefined : after === 'DELIVERY' ? 'Delivery fee' : 'Materials'); break
      case 'nrpc': add(after == null ? 'NRPC removed' : 'NRPC', money(record(before).amount_centavos), after == null ? undefined : money(record(after).amount_centavos) ?? formatPesoCentavos(content.commercial.nrpcCentavos)); break
      case 'nrpc.amount_centavos': add('NRPC', money(before), money(after)); break
      case 'nrpc.reason': add('NRPC reason', text(before), text(after)); break
      case 'destination': if (content.fulfillmentMethod === 'DELIVERY' && address(before) !== address(after)) add('Delivery address', address(before), address(after)); break
      case 'destination.intended.address': case 'destination.intended.formatted_address': case 'destination.address': case 'destination.formatted_address':
        if (content.fulfillmentMethod === 'DELIVERY') add('Delivery address', text(before), text(after))
        break
    }
  }
  return notes
}
