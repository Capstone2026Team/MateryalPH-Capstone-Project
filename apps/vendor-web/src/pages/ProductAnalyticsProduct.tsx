import { Link } from 'react-router-dom'
import { PencilLine } from 'lucide-react'
import { ProductImageGallery, formatPesoCentavos } from '@materyalph/web-ui'
import type { ProductAnalyticsRow } from '../lib/product-analytics-api'
import type { ProductAnalyticsContext } from '../lib/product-analytics-context'
import { ListingBadge } from './CatalogShared'
import { ErrorState, LoadingState } from './PhaseThreeVendorPages'

function fieldLabel(value: string) {
  const words = value.replace(/([a-z])([A-Z])/g, '$1 $2').replace(/[_-]+/g, ' ')
  return words.charAt(0).toUpperCase() + words.slice(1).toLowerCase()
}

export function ProductAnalyticsProduct({ product, context, error, refreshing, onRetry }: {
  product: Pick<ProductAnalyticsRow, 'listingId' | 'name' | 'sku' | 'category'>
  context: ProductAnalyticsContext | null
  error: string | null
  refreshing: boolean
  onRetry: () => void
}) {
  const listing = context?.listing
  const specifications = listing ? [
    ['Material', listing.material?.name || listing.otherLabel], ['Brand', listing.brand], ['Model', listing.model],
    ['Manufacturer', listing.manufacturer], ['Country of manufacture', listing.countryOfManufacture],
    ...Object.entries(listing.technicalAttributes).map(([code, value]) => [fieldLabel(code), value]),
  ].filter((row): row is [string, string] => Boolean(row[1]?.trim())) : []
  const variants = listing?.variants.filter(variant => variant.active) ?? []
  return <div className="grid min-w-0 gap-4">
    {context ? <ProductImageGallery images={context.images} productName={product.name} onRetry={onRetry} refreshing={refreshing} />
      : !error ? <div className="grid aspect-square max-h-[420px] place-items-center rounded-surface bg-surface-canvas"><LoadingState label="Loading product photos and details…" /></div> : null}
    <header className="grid min-w-0 gap-2">
      <div className="flex flex-wrap items-center gap-2"><span className="text-xs font-semibold uppercase tracking-wide text-action-primary">{product.category}</span>{listing && <ListingBadge status={listing.status} />}</div>
      <h1 className="break-words text-xl font-semibold leading-tight text-text-strong">{product.name}</h1>
      {product.sku && <p className="break-words text-xs text-text-secondary">SKU {product.sku}</p>}
      <Link className="inline-flex min-h-11 w-fit items-center gap-2 rounded-control border border-border-default px-4 text-sm font-semibold hover:bg-surface-canvas" to={`/products/${product.listingId}`}><PencilLine size={16} aria-hidden="true" />Edit listing</Link>
    </header>
    {error && <ErrorState message={error} onRetry={onRetry} />}
    {listing && <>
      <section aria-label="Product description" className="grid gap-2 border-t border-border-default pt-4">
        <h2 className="text-sm font-semibold">Product description</h2>
        <p className={`whitespace-pre-wrap break-words text-sm leading-6 ${listing.description?.trim() ? 'text-text-strong' : 'text-text-secondary'}`}>{listing.description?.trim() || 'No product description has been added.'}</p>
      </section>
      {specifications.length > 0 && <section aria-label="Product details" className="grid gap-2 border-t border-border-default pt-4">
        <h2 className="text-sm font-semibold">Product details</h2>
        <dl className="grid min-w-0 gap-2 text-sm">{specifications.map(([label, value]) => <div key={label} className="grid min-w-0 gap-1 sm:grid-cols-[minmax(0,1fr)_minmax(0,1.2fr)]"><dt className="break-words text-text-secondary">{label}</dt><dd className="break-words font-medium">{value}</dd></div>)}</dl>
      </section>}
      <section aria-label="Product variants" className="grid gap-2 border-t border-border-default pt-4">
        <h2 className="text-sm font-semibold">Variants &amp; unit prices</h2>
        {variants.length === 0 ? <p className="text-sm text-text-secondary">No active variants.</p> : <ul className="divide-y divide-border-default">{variants.map(variant => <li key={variant.id} className="grid min-w-0 gap-2 py-3 first:pt-0 last:pb-0">
          <div className="flex flex-wrap items-start justify-between gap-2"><span className="min-w-0 break-words text-sm font-semibold">{variant.label || variant.sku}</span><span className="text-sm font-semibold tabular-nums">{variant.price ? `${formatPesoCentavos(variant.price.amountCentavos)} / ${variant.unitCode.toLowerCase()}` : 'Price unavailable'}</span></div>
          <p className="break-words text-xs text-text-secondary">SKU {variant.sku}</p>
          {Object.keys(variant.attributes).length > 0 && <dl className="grid min-w-0 gap-1 text-xs text-text-secondary">{Object.entries(variant.attributes).map(([code, value]) => <div key={code} className="flex min-w-0 flex-wrap gap-x-2"><dt>{fieldLabel(code)}:</dt><dd className="break-words text-text-strong">{value}</dd></div>)}</dl>}
        </li>)}</ul>}
      </section>
    </>}
  </div>
}
