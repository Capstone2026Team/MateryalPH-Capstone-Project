import { useCallback, useEffect, useState } from 'react'
import { AsyncLoading, Pagination, Select, StockLabelBadge, StatusMessage, usePortalResource } from '@materyalph/web-ui'
import { listInventory, type InventoryRow } from '../lib/inventory-api'
import { readableApiError } from '../lib/auth-api'
import { InventoryDetails, type InventoryDetailMode } from './InventoryDetails'
import { ListingBadge } from './CatalogShared'
import { ErrorState } from './PhaseThreeVendorPages'

/** Listing-filtered, paginated private inventory. Changing the analytics period leaves this workspace intact. */
export function ProductInventorySection({ listingId, onChanged }: { listingId: string; onChanged: () => void }) {
  const [page, setPage] = useState(1)
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [mode, setMode] = useState<InventoryDetailMode>('details')
  const loader = useCallback(() => listInventory({ listingId, page }), [listingId, page])
  const { data, error, pending, refresh, publish } = usePortalResource(`vendor-product-inventory-${listingId}-${page}`, loader)
  const [message, setMessage] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    setMessage(null)
    if (error) void readableApiError(error).then(text => { if (active) setMessage(text) })
    return () => { active = false }
  }, [error])
  const selected = data?.items.find(row => row.listingVariantId === selectedId) ?? data?.items[0]
  const changePage = (next: number) => { setPage(next); setSelectedId(null); setMode('details') }
  const saved = (rows: InventoryRow[]) => {
    if (!data) return
    publish(current => ({ ...data, ...current, items: (current ?? data).items.map(row => rows.find(next => next.listingVariantId === row.listingVariantId) ?? row) }))
    void refresh()
    onChanged()
  }
  return <section aria-label="Product inventory" className="grid min-w-0 gap-5 border-t border-border-default pt-5">
    <header className="flex flex-wrap items-start justify-between gap-3">
      <div><h2 className="text-base font-semibold">Inventory &amp; stock confirmation</h2><p className="mt-1 text-xs text-text-secondary">Review and confirm each active variant’s physical stock.</p></div>
      {pending && data && <AsyncLoading compact label="Updating inventory…" />}
    </header>
    {message && <ErrorState message={message} onRetry={() => void refresh()} />}
    {!data ? !message && <AsyncLoading compact label="Loading stock details…" /> : <>
      {selected ? <>
        <div className="flex flex-wrap items-end gap-4">
          <div className="min-w-0 flex-1"><Select label="Stock variant" value={selected.listingVariantId} disabled={pending} onChange={event => { setSelectedId(event.target.value); setMode('details') }}>{data.items.map(row => <option key={row.listingVariantId} value={row.listingVariantId}>{row.variantLabel || row.listingName} · SKU {row.sku}</option>)}</Select></div>
          <dl className="flex flex-wrap gap-4 text-sm"><div><dt className="mb-1 text-xs text-text-secondary">Stock status</dt><dd><StockLabelBadge label={selected.publicLabel} prefix="" /></dd></div><div><dt className="mb-1 text-xs text-text-secondary">Listing status</dt><dd><ListingBadge status={selected.listingStatus} /></dd></div></dl>
        </div>
        <InventoryDetails key={selected.listingVariantId} row={selected} permissions={data.meta.permissions} mode={mode} onModeChange={setMode} pending={pending || Boolean(error)} onSaved={saved} onReload={() => void refresh()} />
      </> : <StatusMessage>No active variants to track. Add a variant in Edit listing.</StatusMessage>}
      {data.meta.lastPage > 1 && <Pagination page={page} lastPage={data.meta.lastPage} total={data.meta.total} busy={pending} onChange={changePage} />}
    </>}
  </section>
}
