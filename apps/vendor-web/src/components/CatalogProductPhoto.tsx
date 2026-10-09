import { useEffect, useState } from 'react'
import { Package } from 'lucide-react'
import { getCatalogFileUrl, getListing } from '../lib/catalog-api'

type Photo = { state: 'loading' | 'empty' | 'error' } | { state: 'ready'; url: string; alt: string }

/** Loads the first current, clean product photo through the authorized catalog API. */
export function CatalogProductPhoto({ listingId }: { listingId: string }) {
  const [photo, setPhoto] = useState<Photo>({ state: 'loading' })
  const [attempt, setAttempt] = useState(0)

  useEffect(() => {
    let active = true
    setPhoto({ state: 'loading' })
    async function load() {
      try {
        const listing = await getListing(listingId)
        if (!active) return
        const media = listing.media.find(item => item.status === 'READY' && item.scanState === 'CLEAN')
        if (!media) { setPhoto({ state: 'empty' }); return }
        const url = await getCatalogFileUrl(media.fileId)
        if (active) setPhoto({ state: 'ready', url, alt: media.altText?.trim() || listing.displayName })
      } catch {
        if (active) setPhoto({ state: 'error' })
      }
    }
    void load()
    return () => { active = false }
  }, [listingId, attempt])

  return <div className="grid h-24 w-24 place-items-center overflow-hidden rounded-control border border-border-default bg-surface-canvas sm:h-28 sm:w-28">
    {photo.state === 'ready'
      ? <img src={photo.url} alt={photo.alt} className="h-full w-full object-contain" onError={() => setPhoto({ state: 'error' })} />
      : <div className="grid justify-items-center gap-1 px-1 text-center text-xs text-text-secondary">
        <Package size={24} aria-hidden="true" />
        {photo.state === 'error'
          ? <><span>Photo unavailable</span><button type="button" aria-label="Retry product photo" className="min-h-11 rounded-control px-2 font-semibold text-action-primary underline focus-visible:outline-2 focus-visible:outline-focus-ring" onClick={() => setAttempt(value => value + 1)}>Retry</button></>
          : <span role={photo.state === 'loading' ? 'status' : undefined}>{photo.state === 'loading' ? 'Loading photo…' : 'No photo yet'}</span>}
      </div>}
  </div>
}
