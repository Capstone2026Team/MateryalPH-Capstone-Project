import { useEffect, useState } from 'react'
import type { GeoFeature } from './geo-analytics-patterns'

export type ReferenceBoundary = GeoFeature & { properties: GeoFeature['properties'] & { regionCode: string; provinceCode: string } }
type Collection = { features: ReferenceBoundary[] }
const sources = import.meta.glob<Collection>('./geography/subregions/*.json', { import: 'default' })
const emptyBoundaries: ReferenceBoundary[] = []

/** Lazy local reference assets only. Statistics, permissions and navigation always come from the API. */
export function useReferenceBoundaries(scopeCode: string | null | undefined) {
  const regionCode = scopeCode && /^\d{10}$/.test(scopeCode) ? `${scopeCode.slice(0, 2)}00000000` : null
  const source = regionCode ? sources[`./geography/subregions/${regionCode}.json`] : undefined
  const [attempt, setAttempt] = useState(0)
  const [result, setResult] = useState<{ regionCode: string | null; features: ReferenceBoundary[]; loading: boolean; error: boolean }>({ regionCode: null, features: [], loading: false, error: false })
  useEffect(() => {
    if (!source) return
    let active = true
    setResult({ regionCode, features: [], loading: true, error: false })
    void source().then(collection => {
      if (active) setResult({ regionCode, features: collection.features, loading: false, error: false })
    }).catch(() => {
      if (active) setResult({ regionCode, features: [], loading: false, error: true })
    })
    return () => { active = false }
  }, [source, regionCode, attempt])
  const current = result.regionCode === regionCode
  return { features: current ? result.features : emptyBoundaries, loading: Boolean(source) && (!current || result.loading), error: current && result.error, retry: () => setAttempt(value => value + 1) }
}

/** Public context borders have no metric, selection or drill-down semantics. */
export function referenceContext(features: ReferenceBoundary[], scopeCode: string | null | undefined): ReferenceBoundary[] {
  if (!scopeCode) return []
  const scope = features.find(feature => feature.properties.code === scopeCode)
  const locality = (feature: ReferenceBoundary) => ['CITY', 'MUNICIPALITY'].includes(feature.properties.level)
  if (scope) return scope.properties.level === 'PROVINCE' ? features.filter(feature => feature.properties.provinceCode === scopeCode && locality(feature)) : []
  return features.filter(feature => feature.properties.regionCode === scopeCode && (scopeCode === '1300000000' ? locality(feature) : feature.properties.level === 'PROVINCE'))
}
