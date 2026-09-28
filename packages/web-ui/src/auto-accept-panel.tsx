import { useEffect, useId, useState } from 'react'
import { CircleOff, PauseCircle, PlayCircle, ShieldCheck } from 'lucide-react'
import { Button } from './button'
import { ConfirmDialog } from './confirm-dialog'
import { Field } from './field'

export type AutoAcceptPanelPolicy = {
  status: 'DISABLED' | 'ACTIVE' | 'PAUSED'; pauseReason: string | null; remainingAllotment: string
  maxUnitCount: string | null; maxOrderAmountPesos: string | null; lastEditor?: string | null
}
export type AutoAcceptPanelValues = { enabled: boolean; allotment: string; maxUnitCount: string; maxOrderAmountPesos: string }

/**
 * The single Item-Based auto-accept surface: enable switch, three independent safeguards, pause state as
 * text plus icon, and a deliberate resume whose confirmation names the allotment being restored.
 * Authorization stays on the server; controls a role may not use are read-only here only for clarity.
 */
export function AutoAcceptPanel({ policy, unit, canConfigure, canUpdateAllotment, busy, fieldErrors = {}, onSave, onSaveAllotment, onPause, onResume }: {
  policy: AutoAcceptPanelPolicy; unit: string; canConfigure: boolean; canUpdateAllotment: boolean; busy: boolean; fieldErrors?: Record<string, string>
  onSave: (values: AutoAcceptPanelValues) => void; onSaveAllotment: (allotment: string) => void; onPause: () => void; onResume: (allotment: string) => void
}) {
  const initial = (): AutoAcceptPanelValues => ({ enabled: policy.status !== 'DISABLED', allotment: policy.remainingAllotment === '0' && policy.status === 'DISABLED' ? '' : policy.remainingAllotment, maxUnitCount: policy.maxUnitCount ?? '', maxOrderAmountPesos: policy.maxOrderAmountPesos ?? '' })
  const [values, setValues] = useState<AutoAcceptPanelValues>(initial)
  const [confirmResume, setConfirmResume] = useState(false)
  const switchId = useId()
  // A saved policy replaces the draft so the form always starts from the current version.
  useEffect(() => { setValues(initial()) }, [policy.status, policy.remainingAllotment, policy.maxUnitCount, policy.maxOrderAmountPesos]) // eslint-disable-line react-hooks/exhaustive-deps
  const state = policy.status === 'ACTIVE'
    ? { icon: PlayCircle, text: 'Active — eligible Item-Based orders are accepted automatically', className: 'text-status-success' }
    : policy.status === 'PAUSED'
      ? { icon: PauseCircle, text: policy.pauseReason === 'ALLOTMENT_EXHAUSTED' ? 'Paused — the allotment reached zero' : 'Paused by the store', className: 'text-status-warning' }
      : { icon: CircleOff, text: 'Off — every order waits for manual confirmation (default)', className: 'text-text-secondary' }
  const StateIcon = state.icon
  const readOnly = !canConfigure
  const set = (patch: Partial<AutoAcceptPanelValues>) => setValues(current => ({ ...current, ...patch }))
  return <section aria-label="Item-Based auto-accept" className="grid min-w-0 gap-4">
    <div className="flex flex-wrap items-start justify-between gap-3">
      <div className="min-w-0">
        <h3 className="text-base font-semibold">Item-Based auto-accept</h3>
        <p className={`mt-1 flex items-center gap-1.5 text-sm font-semibold ${state.className}`} role="status"><StateIcon size={16} aria-hidden="true" />{state.text}</p>
        {policy.lastEditor && <p className="mt-1 text-xs text-text-secondary">Last changed by {policy.lastEditor}</p>}
      </div>
      <div className="flex items-center gap-3">
        <label htmlFor={switchId} className="text-sm font-semibold">Enable auto-accept</label>
        <button id={switchId} type="button" role="switch" aria-checked={values.enabled} disabled={busy || readOnly} onClick={() => set({ enabled: !values.enabled })}
          className={`relative inline-flex h-7 w-12 min-w-12 items-center rounded-pill border transition-colors motion-reduce:transition-none disabled:opacity-60 ${values.enabled ? 'border-action-primary bg-action-primary' : 'border-border-default bg-surface-canvas'} before:absolute before:-inset-2 before:content-['']`}>
          <span className={`inline-block h-5 w-5 rounded-full bg-white shadow transition-transform motion-reduce:transition-none ${values.enabled ? 'translate-x-6' : 'translate-x-1'}`} aria-hidden="true" />
        </button>
      </div>
    </div>
    <p className="flex items-start gap-2 text-sm text-text-secondary"><ShieldCheck size={16} className="mt-0.5 shrink-0" aria-hidden="true" />Applies only to Item-Based orders without NRPC. Project-Based procurement and any order with NRPC always wait for manual review. One failed check sends the whole order to manual review.</p>
    <div className="grid min-w-0 grid-cols-1 gap-4 md:grid-cols-3">
      <Field label={`Allotment (${unit || 'units'})`} name="allotment_quantity" inputMode="numeric" value={values.allotment} error={fieldErrors.allotment_quantity} disabled={busy || !(canConfigure || canUpdateAllotment)} onChange={event => set({ allotment: event.target.value })} hint="Whole units auto-accept may still reserve. Zero pauses it." />
      <Field label={`Max units per order (${unit || 'units'})`} name="max_unit_count" inputMode="decimal" value={values.maxUnitCount} error={fieldErrors.max_unit_count} disabled={busy || readOnly} onChange={event => set({ maxUnitCount: event.target.value })} hint="Optional. Empty means no unit cap." />
      <Field label="Max order amount (₱)" name="max_order_amount_centavos" inputMode="decimal" value={values.maxOrderAmountPesos} error={fieldErrors.max_order_amount_centavos} disabled={busy || readOnly} onChange={event => set({ maxOrderAmountPesos: event.target.value })} hint="Optional. Buyer total with VAT and delivery. Empty means no amount cap." />
    </div>
    <div className="flex flex-wrap gap-3 border-t border-border-default pt-4">
      {canConfigure && <Button disabled={busy} onClick={() => onSave(values)}>{busy ? 'Saving…' : 'Save auto-accept'}</Button>}
      {!canConfigure && canUpdateAllotment && <Button disabled={busy} onClick={() => onSaveAllotment(values.allotment)}>{busy ? 'Saving…' : 'Save allotment'}</Button>}
      {canConfigure && policy.status === 'ACTIVE' && <Button variant="secondary" disabled={busy} onClick={onPause}><PauseCircle size={16} aria-hidden="true" /> Pause</Button>}
      {canConfigure && policy.status === 'PAUSED' && <Button variant="secondary" disabled={busy || policy.remainingAllotment === '0'} onClick={() => setConfirmResume(true)}><PlayCircle size={16} aria-hidden="true" /> Resume</Button>}
      {canConfigure && policy.status === 'PAUSED' && policy.remainingAllotment === '0' && <p className="self-center text-sm text-text-secondary">Set and save an allotment above zero before resuming.</p>}
      {!canConfigure && !canUpdateAllotment && <p className="text-sm text-text-secondary">You can view auto-accept outcomes. The Owner or Store Manager changes this policy.</p>}
    </div>
    <ConfirmDialog open={confirmResume} tone="primary" title="Resume auto-accept?" confirmLabel={`Resume with ${policy.remainingAllotment} ${unit || 'units'}`} busy={busy} onCancel={() => setConfirmResume(false)} onConfirm={() => { setConfirmResume(false); onResume(policy.remainingAllotment) }}>
      <p>Auto-accept will start again with an allotment of <strong>{policy.remainingAllotment} {unit || 'units'}</strong>. Review your internal quantity first. Replenishing stock never resumes auto-accept on its own.</p>
    </ConfirmDialog>
  </section>
}
