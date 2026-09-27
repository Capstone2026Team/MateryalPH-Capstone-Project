import { useEffect, useState } from 'react'
import type { VendorTeamActivityEnvelope } from '@materyalph/api-client-ts'
import { Button } from './button'
import { StatusMessage } from './status-message'

export function VendorTeamActivity({ list, explainError }: { list: (page: number) => Promise<VendorTeamActivityEnvelope>; explainError: (error: unknown) => Promise<string> }) {
  const [page, setPage] = useState(1)
  const [result, setResult] = useState<VendorTeamActivityEnvelope | null>(null)
  const [error, setError] = useState<string | null>(null)
  const [retry, setRetry] = useState(0)
  const [loading, setLoading] = useState(true)
  useEffect(() => {
    let current = true
    setLoading(true); setError(null)
    void list(page).then(value => { if (current) setResult(value) }).catch(async cause => { const message = await explainError(cause); if (current) setError(message) }).finally(() => { if (current) setLoading(false) })
    return () => { current = false }
  }, [list, page, explainError, retry])
  return <section className="min-w-0 space-y-5"><div className="flex flex-wrap items-center justify-between gap-3"><h2 className="text-2xl font-semibold">Team activity</h2><Button variant="secondary" disabled={loading} onClick={() => setRetry(retry + 1)}>Refresh activity</Button></div><p className="text-sm text-text-secondary">Activity retains the employee’s role at the time of the action. All times use Asia/Manila.</p>{error && <StatusMessage tone="error">{error}</StatusMessage>}{loading ? <p role="status">Loading activity…</p> : !error && <>{result?.data.length === 0 && <p>No activity recorded yet.</p>}<ul className="divide-y divide-border-default">{result?.data.map(item => <li key={item.id} className="space-y-2 py-5"><p className="font-semibold">{item.actorName || 'System'} · {item.actorRole.replaceAll('_', ' ')}</p><p>{item.action.replaceAll('_', ' ')} · {item.succeeded ? 'Succeeded' : 'Unsuccessful'}</p><p className="break-all text-sm text-text-secondary">{item.resourceType}: {item.resourceId || '—'} · {new Intl.DateTimeFormat('en-PH', { dateStyle: 'medium', timeStyle: 'short', timeZone: 'Asia/Manila' }).format(item.createdAt)}</p>{Object.entries(item.after).map(([key, value]) => <p className="text-sm" key={key}>{key.replaceAll('_', ' ')}: {String(item.before[key] ?? '—')} → {String(value)}</p>)}</li>)}</ul>{result && result.meta.lastPage > 1 && <div className="flex flex-wrap items-center gap-3"><Button variant="secondary" disabled={page <= 1} onClick={() => setPage(page - 1)}>Previous</Button><span>Page {page} of {result.meta.lastPage}</span><Button variant="secondary" disabled={page >= result.meta.lastPage} onClick={() => setPage(page + 1)}>Next page</Button></div>}</>}</section>
}
