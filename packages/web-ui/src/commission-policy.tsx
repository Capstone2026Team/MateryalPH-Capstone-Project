import { Configuration, PublicFinanceApi, type PublicCommissionPolicy } from '@materyalph/api-client-ts'
import { useCallback, useEffect, useRef, useState } from 'react'
import { AlertCircle, CheckCircle2, Clock3, FileX2, Mail } from 'lucide-react'
import { StatusBadge } from './portal-shell'

/** Read-only refresh at the effective instant, on return to the tab, and after remote publications. */
export function useCommissionPolicyClock(nextEffective: Date | string | null | undefined, reload: () => void) {
  const refresh = useRef(reload)
  useEffect(() => { refresh.current = reload }, [reload])
  const instant = nextEffective ? new Date(nextEffective).valueOf() : null
  useEffect(() => {
    const visible = () => { if (document.visibilityState === 'visible') refresh.current() }
    const interval = window.setInterval(visible, 60_000)
    let timer: number | null = null
    const activate = () => {
      if (instant === null) return
      const remaining = instant - Date.now()
      if (remaining <= 0) refresh.current()
      else timer = window.setTimeout(activate, Math.min(remaining + 100, 2_147_000_000))
    }
    if (instant !== null) activate()
    document.addEventListener('visibilitychange', visible)
    window.addEventListener('commission-policy-changed', visible)
    return () => { clearInterval(interval); if (timer !== null) clearTimeout(timer); document.removeEventListener('visibilitychange', visible); window.removeEventListener('commission-policy-changed', visible) }
  }, [instant])
}

/** Public rate/terms projection; never substitutes a launch rate if the server is unavailable. */
export function useCommissionPolicy(basePath: string, policy?: string) {
  const [data, setData] = useState<PublicCommissionPolicy | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const reload = useCallback(() => setAttempt(value => value + 1), [])
  useEffect(() => {
    const abort = new AbortController()
    new PublicFinanceApi(new Configuration({ basePath })).getPublicCommissionPolicy(policy ? { policy } : {}, { cache: 'no-store', signal: abort.signal })
      .then(value => { if (!abort.signal.aborted) { setData(value.data); setError(null) } })
      .catch(() => { if (!abort.signal.aborted) setError('The commission policy is unavailable. Try again.') })
    return () => abort.abort()
  }, [basePath, policy, attempt])
  useCommissionPolicyClock(data?.next?.effectiveFrom, reload)
  return { data, error, reload }
}

export function CommissionStatementBadge({ state, overdue = false }: { state: string; overdue?: boolean }) {
  const label = overdue ? 'Overdue' : ({ DRAFT: 'Preparing', ISSUED: 'Issued', PARTIALLY_PAID: 'Partially paid', PAID: 'Settled', VOIDED: 'Voided' }[state] ?? state)
  const tone = overdue ? 'error' : state === 'PAID' ? 'success' : state === 'ISSUED' ? 'info' : state === 'PARTIALLY_PAID' ? 'warning' : 'neutral'
  const Icon = overdue ? AlertCircle : state === 'PAID' ? CheckCircle2 : state === 'VOIDED' ? FileX2 : Clock3
  return <StatusBadge label={label} tone={tone} icon={<Icon size={13} aria-hidden="true" />} />
}

export function CommissionEmailBadge({ state }: { state: string }) {
  return <StatusBadge label={state === 'SENT' ? 'Email sent' : state === 'FAILED' || state === 'BLOCKED' ? 'Email needs attention' : state === 'NONE' ? 'No email' : `Email ${state.toLowerCase()}`} tone={state === 'SENT' ? 'success' : state === 'FAILED' || state === 'BLOCKED' ? 'error' : 'neutral'} icon={<Mail size={13} aria-hidden="true" />} />
}
