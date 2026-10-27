import { Button, FactList, ReasonedDecisionForm, SidePanel, StatusMessage } from '@materyalph/web-ui'
import type { OperationFailure, OperationRetryResult } from '@materyalph/api-client-ts'
import { useEffect, useRef, useState } from 'react'
import { needsReauthentication, newKey, operationRetryPreview, problemText, retryOperation, type ApiProblem } from '../lib/operations-api'
import { useLoad, useProtectedAction } from '../lib/operations-hooks'
import { ErrorState, LoadingState } from './PhaseThreeAdminPages'

type Result = { item: OperationFailure } & ({ ok: true; value: OperationRetryResult } | { ok: false; problem: ApiProblem })
const identity = (item: OperationFailure) => `${item.kind}:${item.reference}`

export function BulkOperationRetryPanel({ kind, onClose, onChanged, onReview }: { kind: 'OUTBOX' | 'JOBS'; onClose: () => void; onChanged: () => void; onReview: () => void }) {
  const preview = useLoad(() => operationRetryPreview(kind), [kind])
  const { run, dialog } = useProtectedAction()
  const [running, setRunning] = useState(false)
  const [results, setResults] = useState<Map<string, Result>>(new Map())
  const [started, setStarted] = useState(false)
  const [stopping, setStopping] = useState(false)
  const executing = useRef(false), stop = useRef(false), mounted = useRef(true)
  const reason = useRef('')
  const keys = useRef(new Map<string, string>())
  const completed = useRef(new Map<string, Result>())
  useEffect(() => { mounted.current = true; return () => { mounted.current = false; stop.current = true } }, [])
  const items = preview.data ?? []
  const expectedKind = kind === 'OUTBOX' ? 'OUTBOX_EVENT' : 'FAILED_JOB'
  const eligible = items.filter(item => item.retryable && item.kind === expectedKind)
  const queued = [...results.values()].filter(result => result.ok).length
  const remaining = eligible.length - queued
  const label = kind === 'OUTBOX' ? 'deliveries' : 'jobs'
  const selectionLabel = eligible.length === 1 ? kind === 'OUTBOX' ? 'delivery' : 'job' : label
  const exclusions = new Map<string, number>()
  items.filter(item => !item.retryable || item.kind !== expectedKind).forEach(item => { const note = item.retryNote ?? 'This work is not eligible for retry here.'; exclusions.set(note, (exclusions.get(note) ?? 0) + 1) })

  async function submit(inputReason: string) {
    if (executing.current || eligible.length === 0) return
    executing.current = true; stop.current = false
    reason.current ||= inputReason
    setRunning(true); setStarted(true); setStopping(false)
    try {
      for (const item of eligible) {
        if (stop.current || !mounted.current) break
        const id = identity(item)
        if (completed.current.get(id)?.ok) continue
        const key = keys.current.get(id) ?? newKey()
        keys.current.set(id, key)
        const outcome = await run('Verify to retry eligible work', () => retryOperation({ targetType: item.kind, reference: item.reference, reason: reason.current }, key))
        completed.current.set(id, { item, ...outcome })
        if (mounted.current) setResults(new Map(completed.current))
        // Stop on lost authority, cancelled verification or an uncertain network outcome. Reuse the same key on resume.
        if (!outcome.ok && ([0, 401, 403, 429].includes(outcome.problem.status) || outcome.problem.status >= 500 || needsReauthentication(outcome.problem))) break
      }
    } finally {
      executing.current = false
      if (mounted.current) { setRunning(false); setStopping(false); onChanged() }
    }
  }

  return <SidePanel open title={`Retry eligible ${label}`} description="Review the eligible work before queuing another attempt." closeDisabled={running} onClose={onClose}>
    <div className="grid min-w-0 gap-5">
      <p className="text-sm leading-6 text-text-secondary">This preview covers all dates. Only work allowed by the server can be retried, and each request keeps its reason and audit record. Correct the underlying service issue before retrying.</p>
      {preview.error ? <ErrorState message={preview.error} onRetry={preview.retry} /> : !preview.data ? <LoadingState /> : <>
        <FactList columns={3} facts={[{ label: 'Listed failures', value: items.length }, { label: 'Eligible to retry', value: eligible.length }, { label: 'Kept for review', value: items.length - eligible.length }]} />
        {exclusions.size > 0 && <details className="rounded-control border border-border-default p-3"><summary className="min-h-11 cursor-pointer content-center text-sm font-semibold">Why some work is excluded</summary><ul className="grid gap-2 pb-2 text-sm text-text-secondary">{[...exclusions].map(([note, count]) => <li key={note}>{count} · {note}</li>)}</ul></details>}
        {eligible.length === 0 ? <StatusMessage>No eligible {label} are available. Open the failure list to review the required next steps.</StatusMessage> : !started ? <ReasonedDecisionForm title="Retry eligible work" target={`${eligible.length} ${selectionLabel}`} before="Failed work eligible for retry" after="Queued for another attempt" submitLabel={`Retry ${eligible.length} ${selectionLabel}`} minReason={10} maxReason={500} onSubmit={value => void submit(value)} /> : <>
          <div role="status" aria-live="polite" className="grid gap-3 rounded-control border border-border-default p-4">
            <p className="font-semibold">{running ? `Processing ${results.size} of ${eligible.length}` : 'Retry results'}</p>
            <progress aria-label="Retry progress" max={eligible.length} value={results.size} className="h-2 w-full accent-action-primary" />
            <FactList facts={[{ label: 'Queued again', value: queued }, { label: 'Needs review', value: results.size - queued }, { label: 'Not attempted', value: eligible.length - results.size }]} />
            <p className="text-sm text-text-secondary">Queued work still needs to run successfully. Counts refresh from the server; unresolved failures remain listed.</p>
          </div>
          <details className="rounded-control border border-border-default p-3"><summary className="min-h-11 cursor-pointer content-center text-sm font-semibold">Attempt details ({results.size})</summary><ul className="divide-y divide-border-default">{[...results.values()].map(result => <li key={identity(result.item)} className="grid gap-1 py-3 text-sm"><strong>{result.item.label}</strong>{result.ok ? <><span>Queued for another attempt</span><span className="break-all text-xs text-text-secondary">Correlation ID {result.value.correlationId}</span></> : <span className="text-status-error">{problemText(result.problem)}</span>}</li>)}</ul></details>
          {running ? <Button variant="secondary" disabled={stopping} onClick={() => { stop.current = true; setStopping(true) }}>{stopping ? 'Stopping after this request…' : 'Stop after current request'}</Button> : remaining > 0 && <Button variant="secondary" onClick={() => void submit(reason.current)}>Retry unfinished work ({remaining})</Button>}
        </>}
        <Button variant="quiet" disabled={running} onClick={onReview}>Review failure list</Button>
      </>}
    </div>
    {dialog}
  </SidePanel>
}
