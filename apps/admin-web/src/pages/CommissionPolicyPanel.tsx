import { Button, CommissionRateSummary, Pagination, ReasonedDecisionForm, SidePanel, StatusBadge, StatusMessage, formatManilaDateTime, formatPesoCentavos } from '@materyalph/web-ui'
import { History, Pencil } from 'lucide-react'
import { useRef, useState } from 'react'
import { listCommissionPolicies, publishCommissionPolicy, type CommissionPolicies, type CommissionPolicyPublishRequest } from '../lib/finance-api'
import { control, labelClass, useLoad, useProtectedAction } from '../lib/operations-hooks'
import { problemText } from '../lib/operations-api'
import { ErrorState, LoadingState } from './PhaseThreeAdminPages'

export function CommissionPolicyPanel() {
  const [page, setPage] = useState(1)
  const policies = useLoad(() => listCommissionPolicies(page), [page])
  const [editing, setEditing] = useState(false)
  const [history, setHistory] = useState(false)
  const [saved, setSaved] = useState<string | null>(null)
  if (policies.error) return <ErrorState message={policies.error} onRetry={policies.retry} />
  if (!policies.data) return <LoadingState />
  const data = policies.data.policies
  return <div className="grid gap-3">
    <CommissionRateSummary rateLabel={data.current?.rateLabel} effectiveFrom={data.current?.effectiveFrom} nextRateLabel={data.next?.rateLabel} nextEffectiveFrom={data.next?.effectiveFrom}
      actions={<><Button variant="secondary" onClick={() => setHistory(true)}><History size={16} aria-hidden="true" />View history</Button>{data.canManage && <Button onClick={() => setEditing(true)}><Pencil size={16} aria-hidden="true" />Edit rate</Button>}</>} />
    {saved && <StatusMessage tone="success">{saved}</StatusMessage>}
    {editing && <CommissionRateEditor data={data} onClose={() => setEditing(false)} onReload={() => { setEditing(false); policies.retry() }} onSaved={() => { setEditing(false); setSaved('Commission policy published. Earlier transactions keep their original rate.'); policies.retry() }} />}
    {history && <SidePanel open title="Commission rate history" description="Published versions and reasons. Dates are Asia/Manila." onClose={() => setHistory(false)}>
      <ol className="divide-y divide-border-default">{data.versions.map(policy => <li key={policy.id} className="grid gap-2 py-4">
        <div className="flex flex-wrap items-center justify-between gap-3"><strong>Version {policy.version} · {policy.rateLabel}</strong><StatusBadge label={policy.status.toLowerCase()} tone={policy.status === 'CURRENT' ? 'success' : 'neutral'} /></div>
        <p className="text-sm text-text-secondary">Effective {formatManilaDateTime(policy.effectiveFrom)}</p><p className="text-sm">{policy.reason ?? 'Initial approved commission policy.'}</p>
      </li>)}</ol>
      <Pagination page={page} hasMore={policies.data.hasMore} onChange={setPage} />
    </SidePanel>}
  </div>
}

function CommissionRateEditor({ data, onClose, onReload, onSaved }: { data: CommissionPolicies; onClose: () => void; onReload: () => void; onSaved: () => void }) {
  const [percent, setPercent] = useState(((data.next ?? data.current)?.commissionBasisPoints ?? 200) / 100 + '')
  const [scheduled, setScheduled] = useState(Boolean(data.next))
  const [effective, setEffective] = useState('')
  const [error, setError] = useState<string | null>(null)
  const [conflict, setConflict] = useState<string | null>(null)
  const intent = useRef<{ signature: string; key: string } | null>(null)
  const { run, busy, dialog } = useProtectedAction()
  const valid = /^(?:\d{1,2}(?:\.\d{1,2})?|100(?:\.0{1,2})?)$/.test(percent)
  const parts = percent.split('.')
  const basisPoints = valid ? Number(parts[0]) * 100 + Number((parts[1] ?? '').padEnd(2, '0')) : 0
  async function save(reason: string) {
    setError(null); setConflict(null)
    if (!valid) { setError('Enter a percentage from 0 to 100 with up to two decimal places.'); return }
    const date = scheduled ? new Date(`${effective}:00+08:00`) : null
    if (scheduled && (!effective || Number.isNaN(date?.valueOf()))) { setError('Choose an effective date and time in Asia/Manila.'); return }
    const input: CommissionPolicyPublishRequest = { commissionBasisPoints: basisPoints, expectedVersion: data.latestVersion, effectiveFrom: date, reason }
    const signature = JSON.stringify(input)
    if (intent.current?.signature !== signature) intent.current = { signature, key: crypto.randomUUID() }
    const key = intent.current.key
    const result = await run('Verify to publish a commission rate', () => publishCommissionPolicy(input, key))
    if (result.ok) onSaved()
    else if (result.problem.code === 'COMMISSION_POLICY_VERSION_CONFLICT') setConflict(problemText(result.problem))
    else setError(problemText(result.problem))
  }
  return <SidePanel open title="Edit commission rate" description="Publish a new policy for future transactions. Existing quotations, orders and credits retain their saved rate." onClose={onClose}>
    <ReasonedDecisionForm title="New commission policy" target="Vendor-paid commission" version={data.latestVersion} before={(data.next ?? data.current)?.rateLabel ?? 'Not configured'} after={valid ? `${percent}%` : 'Enter a valid rate'} submitLabel="Publish new rate" busy={busy} error={error} conflict={conflict} onReload={onReload} minReason={10} maxReason={2000} onSubmit={reason => void save(reason)}>
      <label className={labelClass}>Commission percentage (%)<input className={control} inputMode="decimal" value={percent} onChange={event => setPercent(event.target.value)} required aria-describedby="commission-preview" /></label>
      <label className="flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" checked={scheduled} onChange={event => setScheduled(event.target.checked)} />Schedule an effective date</label>
      {scheduled && <label className={labelClass}>Effective date and time (Asia/Manila)<input className={control} type="datetime-local" value={effective} onChange={event => setEffective(event.target.value)} required /></label>}
      <p id="commission-preview" className="rounded-control bg-surface-canvas p-4 text-sm">For ₱10,000.00 of eligible completed materials, the commission would be <strong>{valid ? formatPesoCentavos(Math.floor((1000000 * basisPoints + 5000) / 10000)) : '—'}</strong>. Vendor Owners review revised terms in Finance.</p>
    </ReasonedDecisionForm>
    {dialog}
  </SidePanel>
}
