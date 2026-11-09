import { useEffect, useState } from 'react'
import type { VendorReviewRow } from '@materyalph/api-client-ts'
import { UserRound } from 'lucide-react'
import { readReviewBuyerPhoto } from './web-api-session'

/** The same private-photo loader and neutral fallback in review cards, highlights and details. */
export function ReviewAuthorAvatar({ review, apiBasePath = '/api/v1', className = 'mp-review-avatar' }: {
  review: VendorReviewRow
  apiBasePath?: string
  className?: string
}) {
  const source = review.type !== 'BUYER' && review.displayName && review.displayName !== 'Reviewer unavailable' ? review.buyerAvatarUrl : null
  const scope = JSON.stringify([source, apiBasePath, review.id])
  const [photo, setPhoto] = useState<{ scope: string; url: string } | null>(null)
  useEffect(() => {
    let active = true
    let objectUrl: string | null = null
    if (!source || !review.id) return
    void readReviewBuyerPhoto(apiBasePath, review.id, source).then(blob => {
      if (!active) return
      objectUrl = URL.createObjectURL(blob)
      setPhoto({ scope, url: objectUrl })
    }).catch(() => { /* Missing, expired or denied photos keep the neutral fallback. */ })
    return () => { active = false; if (objectUrl) URL.revokeObjectURL(objectUrl) }
  }, [source, apiBasePath, review.id, scope])
  return <span className={className} aria-hidden="true">{photo?.scope === scope ? <img src={photo.url} alt="" className="h-full w-full object-cover" onError={() => setPhoto(null)} /> : <UserRound size={18} />}</span>
}
