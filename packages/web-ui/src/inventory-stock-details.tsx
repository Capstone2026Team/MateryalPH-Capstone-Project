import type { InventoryRow } from '@materyalph/api-client-ts'
import { formatPesoCentavos } from './order-patterns'
import { StockConfirmationStatus } from './stock-ledger'

const quantity = (value: string) => value.includes('.') ? value.replace(/\.?0+$/, '') : value

/** Current server-provided reasons for a hidden listing; stock quantity and visibility are independent. */
export function StockVisibilityNotice({ blockers, compact = false }: { blockers?: string[]; compact?: boolean }) {
  if (!blockers?.length) return null
  return compact ? <p className="mt-1 text-xs text-text-secondary">{blockers[0]}</p> : <div className="text-sm text-text-secondary">
    <p className="font-semibold text-text-strong">Still hidden from Buyers</p>
    <ul className="mt-1 list-disc space-y-1 pl-5">{blockers.map(reason => <li key={reason}>{reason}</li>)}</ul>
  </div>
}

/** The same private stock summary in the ledger dialog and product analytics workspace. */
export function InventoryStockDetails({ row, showQuantities = true }: { row: InventoryRow; showQuantities?: boolean }) {
  return <>
    <dl aria-label="Inventory overview" className="grid gap-5 border-b border-border-default pb-6 text-sm sm:grid-cols-3">
      <div><dt className="text-xs text-text-secondary">Confirmation</dt><dd className="mt-1.5"><StockConfirmationStatus confirmation={row.stockConfirmation} /></dd></div>
      <div className="border-t border-border-default pt-4 sm:border-l sm:border-t-0 sm:pl-5 sm:pt-0"><dt className="text-xs text-text-secondary">Reorder level</dt><dd className="mt-1.5 font-semibold tabular-nums">{row.inventory?.reorderLevel != null ? `${quantity(row.inventory.reorderLevel)} ${row.unitCode}` : 'Not set'}</dd></div>
      <div className="border-t border-border-default pt-4 sm:border-l sm:border-t-0 sm:pl-5 sm:pt-0"><dt className="text-xs text-text-secondary">Ordinary price</dt><dd className="mt-1.5 font-semibold tabular-nums">{row.price ? formatPesoCentavos(row.price.amountCentavos) : 'No price'}{row.price && <span className="mt-1 block text-xs font-normal text-text-secondary">Price version {row.price.version}</span>}</dd></div>
    </dl>
    {showQuantities && <section aria-label="Stock quantities">
      <h3 className="text-base font-semibold">Stock quantities</h3>
      <dl className="mt-5 grid grid-cols-2 gap-x-6 gap-y-5 lg:grid-cols-4">{[['On hand', row.inventory?.quantityOnHand], ['Hard reserved', row.inventory?.hardReservedQuantity], ['Soft-held', row.inventory?.softHeldQuantity], ['Available to sell', row.inventory?.availableToSell]].map(([label, value]) => <div key={label} className={`min-w-0 border-l-2 pl-4 ${label === 'Available to sell' ? 'border-action-primary' : 'border-border-default'}`}><dt className="text-xs text-text-secondary">{label}</dt><dd className={`mt-2 break-words text-xl font-semibold tabular-nums ${label === 'Available to sell' ? 'text-action-primary' : ''}`}>{value == null ? 'No count' : <>{quantity(value)} <span className="text-sm font-normal text-text-secondary">{row.unitCode}</span></>}</dd></div>)}</dl>
      <p className="mt-5 text-xs text-text-secondary">Exact stock quantities are private to your team.</p>
    </section>}
  </>
}
