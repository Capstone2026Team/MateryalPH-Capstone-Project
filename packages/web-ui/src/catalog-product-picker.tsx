import { useEffect, useId, useRef, useState } from 'react'
import type { CatalogListing, CatalogListingSummary, CatalogVariant } from '@materyalph/api-client-ts'
import { ChevronDown, List, Search } from 'lucide-react'
import { Button } from './button'
import { Pagination, SearchInput, Select } from './filter-controls'
import { formatPesoCentavos } from './order-patterns'
import { StatusMessage } from './status-message'

type ProductPage = { items: CatalogListingSummary[]; meta: { total?: number; lastPage?: number } }

/** Browse a store's paginated products and add one of its current, priced variants. */
export function CatalogProductPicker({ active = true, disabled = false, selectedVariantIds, loadProducts, loadProduct, readableError, onAdd }: {
  active?: boolean
  disabled?: boolean
  selectedVariantIds: string[]
  loadProducts: (query: string, page: number) => Promise<ProductPage>
  loadProduct: (id: string) => Promise<CatalogListing>
  readableError: (error: unknown) => Promise<string>
  onAdd: (listing: CatalogListing, variant: CatalogVariant) => void
}) {
  const [mode, setMode] = useState<'SEARCH' | 'LIST' | null>(null)
  const [query, setQuery] = useState('')
  const [page, setPage] = useState(1)
  const [refresh, setRefresh] = useState(0)
  const [catalog, setCatalog] = useState<ProductPage & { loading: boolean; error: string | null }>({ items: [], meta: {}, loading: true, error: null })
  const [productId, setProductId] = useState<string | null>(null)
  const [variantId, setVariantId] = useState('')
  const [detail, setDetail] = useState<{ listing: CatalogListing | null; loading: boolean; error: string | null }>({ listing: null, loading: false, error: null })
  const [detailRefresh, setDetailRefresh] = useState(0)
  const [addedName, setAddedName] = useState<string | null>(null)
  const immediate = useRef(false)
  const selectedIds = useRef(selectedVariantIds)
  const searchInput = useRef<HTMLInputElement>(null)
  const resultsId = useId()
  const panelId = `${resultsId}-panel`
  const term = query.trim()

  useEffect(() => { selectedIds.current = selectedVariantIds }, [selectedVariantIds])

  useEffect(() => {
    if (!active) { setMode(null); setProductId(null) }
  }, [active])

  useEffect(() => {
    if (active && mode === 'SEARCH') searchInput.current?.focus()
  }, [active, mode])

  useEffect(() => {
    if (!active || mode === null) return
    let current = true
    setCatalog({ items: [], meta: {}, loading: true, error: null })
    setProductId(null)
    setAddedName(null)
    const delay = immediate.current || !term ? 0 : 300
    immediate.current = false
    const timer = window.setTimeout(async () => {
      try {
        const result = await loadProducts(term, page)
        if (current) {
          setCatalog({ ...result, loading: false, error: null })
          if (result.items.length === 1) setProductId(result.items[0]?.id ?? null)
        }
      } catch (error) {
        const message = await readableError(error)
        if (current) setCatalog({ items: [], meta: {}, loading: false, error: message })
      }
    }, delay)
    return () => { current = false; window.clearTimeout(timer) }
  }, [active, mode, term, page, refresh, loadProducts, readableError])

  useEffect(() => {
    if (!active || mode === null || !productId) return
    let current = true
    setVariantId('')
    setDetail({ listing: null, loading: true, error: null })
    void (async () => {
      try {
        const listing = await loadProduct(productId)
        if (current) {
          if (listing.status !== 'ACTIVE') {
            setDetail({ listing: null, loading: false, error: 'This product is no longer active. Search again to choose a current product.' })
          } else {
            setDetail({ listing, loading: false, error: null })
            const available = listing.variants.filter(variant => variant.active && (variant.price?.amountCentavos ?? 0) > 0 && !selectedIds.current.includes(variant.id))
            if (available.length === 1) setVariantId(available[0]?.id ?? '')
          }
        }
      } catch (error) {
        const message = await readableError(error)
        if (current) setDetail({ listing: null, loading: false, error: message })
      }
    })()
    return () => { current = false }
  }, [active, mode, productId, detailRefresh, loadProduct, readableError])

  const currentListing = detail.listing?.id === productId && !detail.loading ? detail.listing : null
  const selectedVariant = currentListing?.variants.find(variant => variant.id === variantId)
  const canAdd = selectedVariant?.active && (selectedVariant.price?.amountCentavos ?? 0) > 0 && !selectedVariantIds.includes(selectedVariant.id)
  const pricedVariants = currentListing?.variants.filter(variant => variant.active && (variant.price?.amountCentavos ?? 0) > 0) ?? []
  const allAdded = pricedVariants.length > 0 && pricedVariants.every(variant => selectedVariantIds.includes(variant.id))
  const search = () => { immediate.current = true; setRefresh(value => value + 1) }
  const toggle = (next: 'SEARCH' | 'LIST') => {
    setMode(current => current === next ? null : next)
    setProductId(null)
    setPage(1)
    if (next === 'LIST') setQuery('')
    immediate.current = true
  }

  return <section aria-label="Store product selection" className="space-y-3">
    <div className="flex flex-wrap gap-2">
      <Button variant={mode === 'SEARCH' ? 'outline' : 'secondary'} disabled={disabled} aria-expanded={mode === 'SEARCH'} aria-controls={panelId} onClick={() => toggle('SEARCH')}>
        <Search size={18} aria-hidden="true" />Search products<ChevronDown size={16} aria-hidden="true" className={mode === 'SEARCH' ? 'rotate-180' : ''} />
      </Button>
      <Button variant={mode === 'LIST' ? 'outline' : 'secondary'} disabled={disabled} aria-expanded={mode === 'LIST'} aria-controls={panelId} onClick={() => toggle('LIST')}>
        <List size={18} aria-hidden="true" />List products<ChevronDown size={16} aria-hidden="true" className={mode === 'LIST' ? 'rotate-180' : ''} />
      </Button>
    </div>
    <div id={panelId} hidden={!active || mode === null} className="space-y-3 rounded-control border border-border-default p-4">
    {active && mode !== null && <>
    {mode === 'SEARCH' && <form role="search" aria-label="Find store products" className="flex min-w-0 flex-col gap-2 sm:flex-row" onSubmit={event => { event.preventDefault(); if (!disabled) search() }}>
      <SearchInput ref={searchInput} label="Find store products" placeholder="Product name or SKU" value={query} maxLength={120} disabled={disabled} className="flex-1" aria-controls={resultsId} onChange={value => { setQuery(value); setPage(1); setProductId(null) }} />
      <Button type="submit" variant="secondary" disabled={disabled}>Search</Button>
    </form>}
    <div id={resultsId} aria-busy={catalog.loading} className="space-y-3">
      {catalog.loading ? <p role="status" className="py-3 text-sm text-text-secondary">{term ? 'Searching store products…' : 'Loading store products…'}</p> : catalog.error ? <>
        <StatusMessage tone="error">{catalog.error}</StatusMessage>
        <Button variant="secondary" disabled={disabled} onClick={search}>Retry products</Button>
      </> : catalog.items.length === 0 ? <p role="status" className="py-3 text-sm text-text-secondary">{term ? 'No products match your search. Try another product name or SKU.' : 'No active products are available. Publish a product in My Products to add it here.'}</p> : <>
        <div className="grid min-w-0 items-end gap-2 sm:grid-cols-[minmax(0,1fr)_minmax(0,1fr)_auto]">
          <Select label="Product" value={productId ?? ''} disabled={disabled} onChange={event => { setProductId(event.target.value || null); setAddedName(null) }}>
            <option value="">Choose a product ({catalog.meta.total ?? catalog.items.length})</option>
            {catalog.items.map(product => <option key={product.id} value={product.id}>{product.displayName} · {product.vendorSku}{product.minPriceCentavos != null ? ` · ${formatPesoCentavos(product.minPriceCentavos)}` : ''}</option>)}
          </Select>
          <Select label="Variant" value={currentListing ? variantId : ''} disabled={disabled || !currentListing || allAdded} onChange={event => setVariantId(event.target.value)}>
            <option value="">{detail.loading && productId ? 'Loading variants…' : allAdded ? 'All variants already added' : 'Choose a variant'}</option>
            {currentListing?.variants.map(variant => {
              const added = selectedVariantIds.includes(variant.id)
              const unavailable = !variant.active || (variant.price?.amountCentavos ?? 0) <= 0
              return <option key={variant.id} value={variant.id} disabled={added || unavailable}>{variant.label ? `${variant.label} · ` : ''}{variant.sku} · {variant.price ? `${formatPesoCentavos(variant.price.amountCentavos)} / ${variant.unitCode.toLowerCase()}` : 'Price unavailable'}{added ? ' · Already added' : unavailable ? ' · Unavailable' : ''}</option>
            })}
          </Select>
          <Button variant="secondary" disabled={disabled || !canAdd} onClick={() => {
            if (currentListing && selectedVariant && canAdd) {
              onAdd(currentListing, selectedVariant)
              setAddedName(`${currentListing.displayName} · ${selectedVariant.label ?? selectedVariant.sku}`)
              setVariantId('')
            }
          }}>Add material</Button>
        </div>
        {addedName && <p role="status" className="text-xs text-text-secondary">Added {addedName}. Choose another product or variant to continue.</p>}
        {productId && detail.error && <><StatusMessage tone="error">{detail.error}</StatusMessage><Button variant="secondary" disabled={disabled} onClick={() => setDetailRefresh(value => value + 1)}>Retry variants</Button></>}
        {currentListing && pricedVariants.length === 0 && <p role="status" className="text-sm text-text-secondary">This product has no active variants with a current price. Update it in My Products before adding it.</p>}
        {(catalog.meta.lastPage ?? 1) > 1 && <Pagination page={page} lastPage={catalog.meta.lastPage ?? 1} {...(catalog.meta.total !== undefined ? { total: catalog.meta.total } : {})} busy={disabled || catalog.loading} onChange={value => { immediate.current = true; setPage(value) }} />}
      </>}
    </div>
    </>}
    </div>
  </section>
}
