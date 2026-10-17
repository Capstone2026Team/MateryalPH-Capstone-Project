import { AccountsApi } from '@materyalph/api-client-ts'
import { createWebApiConfiguration, useAccountVerification } from '@materyalph/web-ui'
import { useCallback, useEffect, useState } from 'react'
import { apiProblem, needsReauthentication, problemText, type ApiProblem } from './operations-api'

export const control = 'min-h-11 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-sm font-normal text-text-strong'
export const labelClass = 'grid min-w-0 gap-2 text-sm font-semibold text-text-strong'

const basePath = import.meta.env.VITE_API_BASE_URL ?? 'http://localhost:8080/api/v1'
const accountsApi = () => new AccountsApi(createWebApiConfiguration(basePath, { refreshSession: true }))
const explain = async (error: unknown) => problemText(await apiProblem(error))

export function manilaDateTime(value: Date | string | null | undefined): string {
  if (!value) return 'Not recorded'
  const date = value instanceof Date ? value : new Date(value)
  return Number.isNaN(date.valueOf()) ? 'Not recorded' : new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' }).format(date)
}

export function manilaDate(value: Date | string | null | undefined): string {
  if (!value) return 'Not recorded'
  const date = value instanceof Date ? value : new Date(value)
  return Number.isNaN(date.valueOf()) ? 'Not recorded' : new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeZone: 'Asia/Manila' }).format(date)
}

export const label = (value: string | null | undefined) => (value ?? '').replaceAll('_', ' ').toLowerCase().replace(/(^|\s)\S/g, letter => letter.toUpperCase())

/** Loads on mount and whenever `deps` change; the error is the structured problem text with its correlation ID. */
export function useLoad<T>(load: () => Promise<T>, deps: unknown[]): { data: T | null; error: string | null; problem: ApiProblem | null; loading: boolean; retry: () => void; set: (value: T) => void } {
  const [data, setData] = useState<T | null>(null)
  const [problem, setProblem] = useState<ApiProblem | null>(null)
  const [loading, setLoading] = useState(true)
  const [attempt, setAttempt] = useState(0)
  useEffect(() => {
    let active = true
    setLoading(true); setProblem(null); setData(null)
    load().then(result => { if (active) setData(result) }).catch(async cause => { const next = await apiProblem(cause); if (active) setProblem(next) }).finally(() => { if (active) setLoading(false) })
    return () => { active = false }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- callers pass every dependency of load
  }, [...deps, attempt])
  return { data, error: problem ? problemText(problem) : null, problem, loading, retry: () => setAttempt(value => value + 1), set: setData }
}

/**
 * Runs a protected mutation. A RECENT_AUTHENTICATION_REQUIRED answer opens the shared verification dialog and retries
 * once after a successful verification; every other failure is returned as a structured problem for the form.
 */
export function useProtectedAction() {
  const { verify, dialog } = useAccountVerification({ api: accountsApi, portal: 'admin', explainError: explain })
  const [busy, setBusy] = useState(false)
  const run = useCallback(async <T,>(title: string, action: () => Promise<T>): Promise<{ ok: true; value: T } | { ok: false; problem: ApiProblem }> => {
    setBusy(true)
    try {
      try { return { ok: true, value: await action() } }
      catch (cause) {
        const problem = await apiProblem(cause)
        if (!needsReauthentication(problem)) return { ok: false, problem }
        if (!(await verify(title))) return { ok: false, problem: { ...problem, message: 'Verification was cancelled; nothing was changed.' } }
        try { return { ok: true, value: await action() } } catch (retryCause) { return { ok: false, problem: await apiProblem(retryCause) } }
      }
    } finally { setBusy(false) }
  }, [verify])
  return { run, busy, dialog }
}

export type PagedResult<T> = { items: T[]; hasMore: boolean; total: number }

/** Page-numbered loader for finance-style lists that report `has_more`; errors carry the correlation ID. */
export function usePaged<T>(load: (page: number) => Promise<PagedResult<T>>, deps: unknown[]) {
  const filterKey = JSON.stringify(deps)
  const [position, setPosition] = useState({ filterKey, page: 1 })
  const page = position.filterKey === filterKey ? position.page : 1
  const setPage = (next: number) => setPosition({ filterKey, page: Math.max(1, next) })
  const [data, setData] = useState<PagedResult<T> | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const reload = useCallback(() => setAttempt(value => value + 1), [])
  useEffect(() => {
    let active = true
    setData(null); setError(null)
    load(page).then(value => { if (active) setData(value) }).catch(async cause => { const text = problemText(await apiProblem(cause)); if (active) setError(text) })
    return () => { active = false }
    // eslint-disable-next-line react-hooks/exhaustive-deps -- reload on page, attempt and caller filters only.
  }, [page, attempt, ...deps])
  return { page, setPage, data, error, reload }
}
export type PagedState<T> = ReturnType<typeof usePaged<T>>
