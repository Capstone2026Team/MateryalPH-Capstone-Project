import { Button, DenseLedgerTable, Pagination, SidePanel, StatusBadge, StatusMessage, formatManilaDateTime, formatPesoCentavos } from '@materyalph/web-ui'
import { useRef, useState } from 'react'
import { commissionTermsUrl, listCommissionPolicies, previewCommissionPolicy, publishCommissionPolicy, resendFailedCommissionEmails, type CommissionPolicies, type CommissionPolicy, type CommissionPolicyPreview, type CommissionPolicyPublishRequest } from '../lib/finance-api'
import { control, labelClass, useLoad, useProtectedAction } from '../lib/operations-hooks'
import { problemText } from '../lib/operations-api'
import { readableVerificationError } from '../lib/vendor-verification-api'
import { ErrorState, LoadingState } from './PhaseThreeAdminPages'

export function CommissionDeliveryStatus({ policy, canManage = false, onRefresh }: { policy: CommissionPolicy; canManage?: boolean; onRefresh: () => void }) {
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const delivery = policy.delivery
  async function resend() {
    setBusy(true); setError(null)
    try { await resendFailedCommissionEmails(policy.id, crypto.randomUUID()); onRefresh() }
    catch (cause) { setError(await readableVerificationError(cause)) }
    finally { setBusy(false) }
  }
  if (!delivery) return <span className="text-xs text-text-secondary">No delivery record</span>
  return <div className="grid gap-2 text-sm" aria-live="polite">
    <p>Notified {delivery.sent} of {delivery.total}{delivery.failed > 0 ? `, ${delivery.failed} failed` : ''}{delivery.queued > 0 ? ` · ${delivery.queued} queued` : ''}{delivery.blocked > 0 ? ` · ${delivery.blocked} blocked` : ''}</p>
    {delivery.blocked > 0 && <p className="text-xs text-text-secondary">Blocked notices require an eligible verified Owner email or mail delivery access.</p>}
    {canManage && delivery.failed > 0 && <Button variant="secondary" disabled={busy} onClick={() => void resend()}>{busy ? 'Queueing…' : 'Resend failed'}</Button>}
    {error && <StatusMessage tone="error">{error}</StatusMessage>}
  </div>
}

export function CommissionPolicyHistory({ canManage }: { canManage: boolean }) {
  const [page, setPage] = useState(1)
  const result = useLoad(() => listCommissionPolicies(page), [page])
  return <section className="grid gap-3" aria-label="Rate history and terms">
    <p className="text-sm text-text-secondary">All published versions. Corrections and cancellations retain their original policy, terms and audit history.</p>
    {result.error ? <ErrorState message={result.error} onRetry={result.retry} /> : !result.data ? <LoadingState /> : <>
      <DenseLedgerTable caption="Commission policy versions" compact rows={result.data.policies.versions} rowKey={row => row.id} columns={[
        { key: 'rate', header: 'Version / rate', cell: row => <div className="grid gap-1"><strong>{row.rateLabel}</strong><span className="text-xs text-text-secondary">Policy v{row.version}</span><StatusBadge label={row.status.toLowerCase()} tone={row.status === 'CURRENT' ? 'success' : row.status === 'SCHEDULED' ? 'info' : 'neutral'} /></div> },
        { key: 'effective', header: 'Effective date', cell: row => formatManilaDateTime(row.effectiveFrom) },
        { key: 'reason', header: 'Published by / reason', cell: row => <div className="grid max-w-sm gap-1"><span>{row.publishedBy ?? 'System'}</span><span className="text-xs text-text-secondary">{row.reason ?? 'Initial approved policy.'}</span>{row.noticeOverrideReason && <span className="text-xs">Notice override: {row.noticeOverrideReason}</span>}</div> },
        { key: 'email', header: 'Vendor notice', cell: row => <CommissionDeliveryStatus policy={row} canManage={canManage} onRefresh={result.retry} /> },
        { key: 'terms', header: 'Terms', cell: row => <a className="inline-flex min-h-11 items-center text-action-primary underline" href={commissionTermsUrl(row.id)} target="_blank" rel="noreferrer">Terms v{row.termsVersion ?? '—'}<span className="sr-only"> (opens in a new tab)</span></a> },
      ]} />
      <Pagination page={page} hasMore={result.data.hasMore} onChange={setPage} />
    </>}
  </section>
}

export function CommissionRateEditor({ data, cancel = false, onClose, onSaved }: { data: CommissionPolicies; cancel?: boolean; onClose: () => void; onSaved: (policy: CommissionPolicy) => void }) {
  const initialPolicy = cancel ? data.current : data.next ?? data.current
  const [step, setStep] = useState(1)
  const [percent, setPercent] = useState(initialPolicy ? String(initialPolicy.commissionBasisPoints / 100) : '')
  const [scheduled, setScheduled] = useState(!cancel && Boolean(data.next))
  const [effective, setEffective] = useState(() => data.next?.effectiveFrom ? new Date(new Date(data.next.effectiveFrom).valueOf() + 8 * 3600_000).toISOString().slice(0, 16) : '')
  const [reason, setReason] = useState('')
  const [message, setMessage] = useState(data.next?.vendorMessage ?? '')
  const [override, setOverride] = useState(false)
  const [overrideReason, setOverrideReason] = useState('')
  const [preview, setPreview] = useState<CommissionPolicyPreview | null>(null)
  const [previewing, setPreviewing] = useState(false)
  const [confirmed, setConfirmed] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const [published, setPublished] = useState<CommissionPolicy | null>(null)
  const intent = useRef<{ signature: string; key: string } | null>(null)
  const { run, busy, dialog } = useProtectedAction()
  const valid = /^(?:\d{1,2}(?:\.\d{1,2})?|100(?:\.0{1,2})?)$/.test(percent)
  const parts = percent.split('.')
  const basisPoints = valid ? Number(parts[0]) * 100 + Number((parts[1] ?? '').padEnd(2, '0')) : 0
  const effectiveDate = scheduled && effective ? new Date(`${effective}:00+08:00`) : null
  const noticeRequired = !cancel && (data.minNoticeDays ?? 30) > 0 && basisPoints > (data.current?.commissionBasisPoints ?? 0) && (!effectiveDate || effectiveDate.valueOf() - Date.now() < (data.minNoticeDays ?? 30) * 86400_000)
  function input(): CommissionPolicyPublishRequest {
    return { commissionBasisPoints: basisPoints, expectedVersion: data.latestVersion, effectiveFrom: cancel ? null : effectiveDate, reason: reason.trim(),
      vendorMessage: message.trim() || null, noticeOverride: override, noticeOverrideReason: override ? overrideReason.trim() : null,
      supersedesPolicyId: data.next?.id ?? null, cancelScheduled: cancel }
  }
  async function next() {
    setError(null)
    if (step === 1) {
      if (!valid) { setError('Enter a percentage from 0 to 100 with up to two decimal places.'); return }
      if (scheduled && (!effectiveDate || !Number.isFinite(effectiveDate.valueOf()) || effectiveDate.valueOf() <= Date.now())) { setError('Choose a future date and time in Asia/Manila.'); return }
      if (noticeRequired && !override) { setError(`Increases require ${data.minNoticeDays ?? 30} days of notice. Schedule a later date or explicitly override the notice rule.`); return }
      if (override && overrideReason.trim().length < 10) { setError('Give a notice override reason in at least 10 characters.'); return }
    }
    if (step === 2) {
      if (reason.trim().length < 10) { setError('Give an internal reason in at least 10 characters.'); return }
      setPreviewing(true)
      try { setPreview(await previewCommissionPolicy(input())) } catch (cause) { setError(await readableVerificationError(cause)); return } finally { setPreviewing(false) }
    }
    setStep(value => value + 1)
  }
  async function publish() {
    setError(null)
    const value = input()
    const signature = JSON.stringify(value)
    if (intent.current?.signature !== signature) intent.current = { signature, key: crypto.randomUUID() }
    const result = await run('Verify to publish commission terms and notify Vendors', () => publishCommissionPolicy(value, intent.current!.key))
    if (result.ok) { setPublished(result.value); onSaved(result.value) }
    else setError(problemText(result.problem))
  }
  return <SidePanel open title={cancel ? 'Cancel scheduled commission change' : 'Edit commission rate'} description="Existing transactions keep their saved rate. Dates and times are Asia/Manila." onClose={onClose} closeDisabled={busy}>
    <div className="mp-commission-rate-editor grid gap-5">
      {published ? <><StatusMessage tone="success">Commission policy published. Earlier transactions keep their original rate.</StatusMessage><CommissionDeliveryStatus policy={published} canManage onRefresh={async () => { const value = await listCommissionPolicies(); setPublished(value.policies.versions.find(row => row.id === published.id) ?? published) }} /><Button onClick={onClose}>Done</Button></> : <>
        <ol className="mp-commission-steps" aria-label="Rate publishing steps">{['Rate and timing', 'Message', 'Impact preview', 'Confirm'].map((name, index) => <li key={name} aria-current={step === index + 1 ? 'step' : undefined}><span>{index + 1}</span>{name}</li>)}</ol>
        {step === 1 && <div className="grid gap-4">
          {cancel ? <StatusMessage tone="info">The scheduled {data.next?.rateLabel} change will be cancelled. A new terms version retaining {data.current?.rateLabel} will be published and Vendors will receive a cancellation email.</StatusMessage> : <>
            <label className={labelClass}>New commission rate (%)<input className={control} inputMode="decimal" value={percent} onChange={event => setPercent(event.target.value)} /></label>
            <fieldset className="grid gap-2"><legend className="text-sm font-semibold">Effective timing</legend>{[false, true].map(value => <label key={String(value)} className="flex min-h-11 items-center gap-2 text-sm"><input type="radio" name="commission-timing" checked={scheduled === value} onChange={() => setScheduled(value)} />{value ? 'Scheduled date and time' : 'Immediate'}</label>)}</fieldset>
            {scheduled && <label className={labelClass}>Effective date and time (Asia/Manila)<input className={control} type="datetime-local" value={effective} onChange={event => setEffective(event.target.value)} /></label>}
            <p className="text-sm text-text-secondary">Increases require at least {data.minNoticeDays ?? 30} days of notice. Decreases may be immediate.</p>
            {noticeRequired && <div className="grid gap-3 rounded-control border border-border-default p-3"><label className="flex min-h-11 items-center gap-2 text-sm"><input type="checkbox" checked={override} onChange={event => setOverride(event.target.checked)} />Explicitly override the minimum notice period</label>{override && <label className={labelClass}>Notice override reason<textarea className={`${control} min-h-24 py-2`} value={overrideReason} onChange={event => setOverrideReason(event.target.value)} maxLength={2000} /></label>}<p className="text-xs text-text-secondary">The override is audited. Vendor email states the actual notice given.</p></div>}
          </>}
        </div>}
        {step === 2 && <div className="grid gap-4"><label className={labelClass}>Internal reason<textarea className={`${control} min-h-24 py-2`} value={reason} onChange={event => setReason(event.target.value)} minLength={10} maxLength={2000} required /></label><p className="text-xs text-text-secondary">Retained in the Admin audit history.</p><label className={labelClass}>Vendor-facing message (optional)<textarea className={`${control} min-h-24 py-2`} value={message} onChange={event => setMessage(event.target.value)} maxLength={2000} /></label><p className="text-xs text-text-secondary">Included in the email and public policy. Do not include internal notes or private contacts.</p></div>}
        {step === 3 && preview && <div className="grid gap-4">
          <div className="mp-commission-impact"><strong>{preview.vendorCount} Vendors will be notified</strong><p>₱10,000.00 eligible materials → {formatPesoCentavos(preview.exampleCommissionCentavos)} commission</p><p>Estimated monthly change: <strong>{formatPesoCentavos(preview.estimatedMonthlyChangeCentavos)}</strong></p><p className="text-xs text-text-secondary">Based on average eligible volume of {formatPesoCentavos(preview.monthlyBasisCentavos)} per month · {preview.volumePeriod}. An illustration using the materials basis at completion, before later credits; future activity may differ.</p><p className="text-xs">Actual notice: {Math.floor(preview.noticeHours / 24)} days, {preview.noticeHours % 24} hours.</p></div>
          <details><summary className="min-h-11 cursor-pointer font-semibold">Terms diff — current and proposed</summary><div className="grid gap-3 xl:grid-cols-2">{[['Current terms', preview.currentTerms ?? 'No published terms'], ['Proposed terms', preview.newTerms]].map(([name, text]) => <section key={name}><h3 className="py-2 text-sm font-semibold">{name}</h3><pre className="max-h-80 overflow-auto whitespace-pre-wrap rounded-control border border-border-default p-3 font-sans text-xs leading-6">{text}</pre></section>)}</div></details>
          <section className="grid gap-2"><h3 className="text-sm font-semibold">Vendor email preview</h3><p className="text-xs text-text-secondary">{preview.emailSubject}</p><iframe title="Commission rate email preview" sandbox="" srcDoc={preview.emailHtml} className="h-[420px] w-full rounded-control border border-border-default" /></section>
        </div>}
        {step === 4 && <div className="grid gap-4"><StatusMessage tone="info">{cancel ? 'Cancel the scheduled change' : `Publish ${percent}% ${scheduled ? `effective ${effective.replace('T', ' ')} Asia/Manila` : 'immediately'}`}. {preview?.vendorCount ?? data.eligibleVendorCount ?? 'Eligible'} Vendors will be notified. Recent authentication is required.</StatusMessage><label className="flex min-h-11 items-start gap-3 text-sm"><input className="mt-1" type="checkbox" checked={confirmed} onChange={event => setConfirmed(event.target.checked)} />I reviewed the rate, effective date, terms and Vendor notice.</label></div>}
        {error && <StatusMessage tone="error">{error}</StatusMessage>}
        <div className="flex flex-wrap justify-between gap-3 border-t border-border-default pt-4"><Button variant="secondary" disabled={step === 1 || busy || previewing} onClick={() => { setStep(value => value - 1); setError(null); setConfirmed(false) }}>Back</Button>{step < 4 ? <Button disabled={previewing} onClick={() => void next()}>{previewing ? 'Preparing preview…' : 'Continue'}</Button> : <Button disabled={!confirmed || busy} onClick={() => void publish()}>{busy ? 'Publishing…' : cancel ? 'Cancel change and notify Vendors' : 'Publish new rate'}</Button>}</div>
      </>}
    </div>{dialog}
  </SidePanel>
}
