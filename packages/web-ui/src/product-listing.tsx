import { useState, type ReactNode } from 'react'
import { ImageOff, Package } from 'lucide-react'
import './product-listing.css'

/** Shared catalog card; callers retain routing, permissions and product data. */
export function ProductListingCard({ imageUrl, title, category, sku, price, variants, status, compliance, stock, activity, actions }: {
  imageUrl?: string | null | undefined
  title: ReactNode
  category: string
  sku: string
  price: ReactNode
  variants: ReactNode
  status: ReactNode
  compliance?: ReactNode
  stock: ReactNode
  activity?: ReactNode
  actions: ReactNode
}) {
  const [failedUrl, setFailedUrl] = useState<string | null>(null)
  const unavailable = Boolean(imageUrl) && failedUrl === imageUrl
  const PhotoIcon = unavailable ? ImageOff : Package
  return <li className="mp-product-listing mp-card">
    <div className="mp-product-listing-photo">
      {imageUrl && !unavailable ? <img src={imageUrl} alt="" loading="lazy" onError={() => setFailedUrl(imageUrl)} />
        : <span className="mp-product-listing-placeholder"><PhotoIcon size={32} aria-hidden="true" />{unavailable ? 'Photo unavailable' : 'No photo yet'}</span>}
      <div className="mp-product-listing-status">{status}</div>
    </div>
    <div className="mp-product-listing-body">
      <div className="mp-product-listing-identity">
        <h3>{title}</h3>
        <p title={category}>{category}</p>
        <p className="mp-product-listing-sku" title={`SKU ${sku}`}>SKU <span>{sku}</span></p>
      </div>
      <div className="mp-product-listing-price"><p>{price}</p><span>{variants}</span></div>
      <div className="mp-product-listing-compliance">{compliance}</div>
    </div>
    <div className="mp-product-listing-footer">
      <div className="mp-product-listing-stock">{stock}</div>
      <div className="mp-card-action mp-product-listing-actions">{actions}</div>
    </div>
    {activity}
  </li>
}
