import { Star } from 'lucide-react'
import type { PortalAccountScore } from '@materyalph/web-ui'

/** The store's Vendor Performance Score: the published value out of 5, or the workflow's New Vendor label until it is published. */
export function StoreScoreLine({ score }: { score: PortalAccountScore }) {
  const text = score.value ? `${score.name} ${score.value} out of 5` : `${score.name}: ${score.unpublishedLabel}`
  return <p className="mt-3 flex flex-wrap items-center gap-x-2 gap-y-1 text-sm text-text-secondary" aria-label={text}>
    <Star size={16} aria-hidden="true" className={score.value ? 'fill-brand-orange-500 text-brand-orange-500' : undefined} />
    {score.value
      ? <><strong className="font-semibold tabular-nums text-text-strong">{score.value}</strong><span aria-hidden="true">/ 5</span><span aria-hidden="true">· {score.name}</span></>
      : <><span aria-hidden="true">{score.name}:</span><span aria-hidden="true">{score.unpublishedLabel}</span></>}
  </p>
}
