import { useId, useState, type ReactNode } from 'react'
import { ImageOff, Package } from 'lucide-react'
import { Button } from './button'
import './product-workspace.css'

export type ProductGalleryImage = { id: string; url: string | null; alt: string }

/** Product information stays beneath its gallery; the adjacent workspace holds analytics and reviews. */
export function ProductDetailWorkspace({ information, children }: { information: ReactNode; children: ReactNode }) {
  return <div className="mp-product-detail-workspace">
    <section aria-label="Product information" className="mp-product-detail-information">{information}</section>
    <section aria-label="Product analytics and reviews" className="mp-product-detail-analysis mp-analytics-main">{children}</section>
  </div>
}

/** Current, authorized listing photos with keyboard-accessible thumbnail selection and local failure handling. */
export function ProductImageGallery({ images, productName, onRetry, refreshing = false }: {
  images: ProductGalleryImage[]
  productName: string
  onRetry?: () => void
  refreshing?: boolean
}) {
  const id = useId()
  const [selectedId, setSelectedId] = useState<string | null>(null)
  const [failed, setFailed] = useState<Set<string>>(() => new Set())
  const selected = images.find(image => image.id === selectedId) ?? images[0]
  const unavailable = Boolean(selected) && (!selected?.url || failed.has(selected.url))
  const fail = (url: string) => setFailed(previous => new Set(previous).add(url))
  return <section className="mp-product-gallery" aria-label={`${productName} photos`}>
    <div id={`${id}-photo`} className="mp-product-gallery-main" aria-live="polite">
      {selected?.url && !unavailable ? <img src={selected.url} alt={selected.alt || productName} onError={() => fail(selected.url!)} />
        : <div className="mp-product-gallery-placeholder">
          {unavailable ? <ImageOff size={40} aria-hidden="true" /> : <Package size={40} aria-hidden="true" />}
          <p>{unavailable ? 'This product photo is unavailable.' : 'No product photos yet.'}</p>
          {unavailable && onRetry && <Button variant="secondary" disabled={refreshing} onClick={() => { setFailed(new Set()); onRetry() }}>{refreshing ? 'Refreshing photos…' : 'Retry photos'}</Button>}
        </div>}
    </div>
    {images.length > 1 && <div className="mp-product-gallery-thumbnails" role="group" aria-label="Choose a product photo">
      {images.map((image, index) => <button key={image.id} type="button" aria-label={`View product photo ${index + 1} of ${images.length}`} aria-pressed={image.id === selected?.id} aria-controls={`${id}-photo`} onClick={() => setSelectedId(image.id)}>
        {image.url && !failed.has(image.url) ? <img src={image.url} alt="" loading="lazy" onError={() => fail(image.url!)} /> : <ImageOff size={20} aria-hidden="true" />}
      </button>)}
    </div>}
    {selected && <p className="text-xs text-text-secondary">Photo {images.indexOf(selected) + 1} of {images.length}</p>}
  </section>
}
