import { useCallback, useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ResponseError } from '@materyalph/api-client-ts'
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

/** The authoritative Vendor onboarding snapshot; a stale response never replaces a newer one. */
export function useOnboardingSnapshot(enabled = true) {
  const navigate = useNavigate()
  const [snapshot, setSnapshot] = useState<VendorOnboardingSnapshot | null>(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const publish = useCallback((updated: VendorOnboardingSnapshot) => {
    setSnapshot(current => current && lockVersion(current) > lockVersion(updated) ? current : updated)
  }, [])

  const refresh = useCallback(async () => {
    setLoading(true)
    setError(null)
    try {
      publish(await getVendorOnboarding())
    } catch (cause) {
      if (cause instanceof ResponseError && cause.response.status === 401) navigate('/login', { replace: true })
      else setError(await readableOnboardingError(cause))
    } finally {
      setLoading(false)
    }
  }, [navigate, publish])

  useEffect(() => { if (enabled) void refresh() }, [refresh, enabled])
  return { snapshot, loading, error, refresh, setSnapshot: publish }
}
