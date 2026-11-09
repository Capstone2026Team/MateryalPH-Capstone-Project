import { useCallback } from 'react'
import { usePortalResource, type ProductGalleryImage } from '@materyalph/web-ui'
import { getCatalogFileUrl, getListing, type CatalogListing } from './catalog-api'

export type ProductAnalyticsContext = { listing: CatalogListing; images: ProductGalleryImage[] }

async function productContext(listingId: string): Promise<ProductAnalyticsContext> {
  const listing = await getListing(listingId)
  const media = listing.media.filter(image => image.status === 'READY' && image.scanState === 'CLEAN')
  const links = await Promise.allSettled(media.map(image => getCatalogFileUrl(image.fileId)))
  const images = media.map((image, index) => {
    const result = links[index]
    return { id: image.id, alt: image.altText || listing.displayName, url: result?.status === 'fulfilled' ? result.value : null }
  })
  return { listing, images }
}

/** Independent of the chart period, so date and review-page changes keep the selected product photo. */
export function useProductAnalyticsListing(listingId: string) {
  const loader = useCallback(() => productContext(listingId), [listingId])
  return usePortalResource(`vendor-product-context-${listingId}`, loader)
}
