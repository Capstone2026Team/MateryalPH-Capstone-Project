import { useCallback, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ResponseError } from '@materyalph/api-client-ts'
import { usePortalResource } from '@materyalph/web-ui'
import { getVendorOnboarding, readableOnboardingError, type VendorOnboardingSnapshot } from './onboarding-api'

export function statusTone(status: string): 'neutral' | 'warning' | 'success' | 'error' | 'info' {
  if (['APPROVED', 'COMPLETED', 'COMPLETE', 'ACTIVE', 'CONNECTED', 'CONNECTED_TEST', 'READY'].includes(status)) return 'success'
  if (['CHANGES_REQUIRED', 'IN_PROGRESS', 'PENDING_VERIFICATION', 'PENDING', 'NOT_READY', 'UNVERIFIED'].includes(status)) return 'warning'
  if (['REJECTED', 'EXPIRED', 'FAILED', 'RESTRICTED', 'SUSPENDED'].includes(status)) return 'error'
  if (['SUBMITTED', 'SUBMITTED'].includes(status)) return 'info'
  return 'neutral'
}

export function statusLabel(status: string): string {
  return status.replaceAll('_', ' ').toLowerCase().replace(/(^|\s)\S/g, (letter) => letter.toUpperCase())
}

function lockVersion(snapshot: VendorOnboardingSnapshot): number {
  return typeof snapshot.lockVersion === 'number' && Number.isFinite(snapshot.lockVersion) ? snapshot.lockVersion : 0
}

/** Reuse the last display snapshot during navigation; every mount revalidates with the API. */
export function useOnboardingSnapshot(enabled = true) {
  const navigate = useNavigate()
  const resource = usePortalResource('vendor-onboarding', getVendorOnboarding, enabled)
  const publishResource = resource.publish
  const [error, setError] = useState<string | null>(null)
  const publish = useCallback((updated: VendorOnboardingSnapshot) => {
    publishResource(current => current && lockVersion(current) > lockVersion(updated) ? current : updated)
  }, [publishResource])

  useEffect(() => {
    let active = true
    setError(null)
    const cause = resource.error
    if (cause) {
      if (cause instanceof ResponseError && cause.response.status === 401) navigate('/login', { replace: true })
      else void readableOnboardingError(cause).then(message => { if (active) setError(message) })
    }
    return () => { active = false }
  }, [navigate, resource.error])
  return { snapshot: resource.data, loading: !resource.data && !resource.error, error, refresh: resource.refresh, setSnapshot: publish }
}
