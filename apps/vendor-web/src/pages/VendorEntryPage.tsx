import { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { ResponseError } from '@materyalph/api-client-ts'
import { AsyncLoading, ConnectionNotice, RequestErrorState } from '@materyalph/web-ui'
import { getVendorOnboarding, readableOnboardingError } from '../lib/onboarding-api'
import { vendorLoginDestination } from '../lib/vendor-destination'

export function VendorEntryPage() {
  const navigate = useNavigate()
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    void getVendorOnboarding().then(snapshot => {
      if (active) navigate(vendorLoginDestination(snapshot), { replace: true })
    }).catch(async cause => {
      if (!active) return
      if (cause instanceof ResponseError && cause.response.status === 401) navigate('/login', { replace: true })
      else setError(await readableOnboardingError(cause))
    })
    return () => { active = false }
  }, [navigate, attempt])
  return <main className="mx-auto max-w-xl p-8"><ConnectionNotice /><h1 className="text-2xl font-semibold">Opening your Vendor workspace</h1>{error ? <RequestErrorState message={error} retryLabel="Retry" onRetry={() => { setError(null); setAttempt(value => value + 1) }} /> : <AsyncLoading label="Checking your onboarding progress…" />}</main>
}
