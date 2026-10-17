import { useEffect, useState } from 'react'
import { getProductSummaries, type ProductSummary } from './product-analytics-api'

/** Summaries for the visible My Products page, keyed by listing; null while unavailable (the list still works without them). */
export function useProductSummaries(listingIds: string[], enabled: boolean): { summaries: Map<string, ProductSummary> | null; failed: boolean } {
  const key = listingIds.join(',')
  const [state, setState] = useState<{ key: string; summaries: Map<string, ProductSummary> | null; failed: boolean }>({ key: '', summaries: null, failed: false })
  useEffect(() => {
    if (!enabled || key === '') return
    let active = true
    getProductSummaries(key.split(','), 30).then(result => { if (active) setState({ key, summaries: new Map(result.items.map(item => [item.listingId, item])), failed: false }) })
      .catch(() => { if (active) setState({ key, summaries: null, failed: true }) })
    return () => { active = false }
  }, [key, enabled])
  return state.key === key ? { summaries: state.summaries, failed: state.failed } : { summaries: null, failed: false }
}
