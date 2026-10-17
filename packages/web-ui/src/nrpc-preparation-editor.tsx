import { useId } from 'react'
import { Trash2 } from 'lucide-react'
import { Button } from './button'
import { Select } from './filter-controls'
import { MoneyField } from './money-field'
import { formatPesoCentavos } from './order-patterns'
import { nrpcPreparationAssessment, type NrpcPreparedMaterial, type NrpcPreparationValue, type NrpcReasonLimits } from './nrpc-preparation'

export function NrpcPreparationEditor({ enabled, value, materials, onToggle, onChange, reasonLimits, disabled = false, termsAvailable, termsVersion, errors = {} }: {
  enabled: boolean
  value: NrpcPreparationValue
  materials: NrpcPreparedMaterial[]
  onToggle: (enabled: boolean) => void
  onChange: (value: NrpcPreparationValue) => void
  reasonLimits: NrpcReasonLimits
  disabled?: boolean
  termsAvailable?: boolean | undefined
  termsVersion?: number | undefined
  errors?: Record<string, string>
}) {
  const id = useId()
  const assessment = nrpcPreparationAssessment(materials, value, reasonLimits)
  const selected = Object.entries(value.allocations)
  const available = materials.filter(material => material.payableCentavos !== null && material.payableCentavos > 0 && !Object.hasOwn(value.allocations, material.id))
  const reasonError = errors['nrpc.reason'] ?? (value.reason.trim() ? assessment.reasonError : null)
  const allocationError = errors['nrpc.lines'] ?? errors['nrpc.allocations'] ?? errors['nrpc.amount_centavos']
  return <section aria-labelledby={`${id}-heading`} className="grid min-w-0 gap-3 rounded-surface border border-border-default p-3 sm:p-4">
    <div className="flex flex-wrap items-center justify-between gap-x-4 gap-y-1">
      <h3 id={`${id}-heading`} className="text-sm font-semibold">Non-Recoverable Preparation Cost <span className="font-normal text-text-secondary">(optional)</span></h3>
      <label className="inline-flex min-h-11 cursor-pointer items-center gap-2 text-sm font-semibold"><input type="checkbox" className="h-4 w-4 accent-action-primary" checked={enabled} disabled={disabled || termsAvailable === false} onChange={event => onToggle(event.target.checked)} />Include NRPC</label>
    </div>
    <p className="text-xs text-text-secondary">For irreversible preparation such as cutting or mixing. Included in the materials total. The Buyer must accept the NRPC Terms{termsVersion !== undefined ? ` v${termsVersion}` : ''} before payment. Orders with NRPC require manual handling.</p>
    {termsAvailable === false && <p role="status" className="text-sm text-text-secondary">NRPC Terms are unavailable. Reload the order before proposing a preparation cost.</p>}
    {enabled && <>
      <label className="grid gap-2 text-sm font-semibold">Reason for preparation
        <textarea rows={2} className="w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 py-2 text-sm font-normal placeholder:text-text-secondary disabled:opacity-60" maxLength={reasonLimits.max} disabled={disabled} value={value.reason} placeholder="e.g. Cut steel bars to the Buyer’s specified lengths." aria-invalid={Boolean(reasonError)} aria-describedby={reasonError ? `${id}-reason-error` : undefined} onChange={event => onChange({ ...value, reason: event.target.value })} />
        {reasonError && <span id={`${id}-reason-error`} role="alert" className="font-normal text-status-error">{reasonError}</span>}
      </label>
      <Select label="Add prepared material" value="" disabled={disabled || available.length === 0} onChange={event => { if (event.target.value) onChange({ ...value, allocations: { ...value.allocations, [event.target.value]: 0 } }) }}>
        <option value="">{!materials.length ? 'Add materials first' : available.length ? 'Choose a material that needs preparation' : selected.length ? 'All eligible materials selected' : 'Complete material quantities and prices first'}</option>
        {available.map(material => <option key={material.id} value={material.id}>{[material.name, material.detail].filter(Boolean).join(' · ')}</option>)}
      </Select>
      {selected.length > 0 && <div className="divide-y divide-border-default border-y border-border-default">{selected.map(([materialId, amount]) => {
        const material = materials.find(line => line.id === materialId)
        const lineError = assessment.lineErrors[materialId]
        const remove = () => { const next = { ...value.allocations }; delete next[materialId]; onChange({ ...value, allocations: next }) }
        return <div key={materialId} className="grid min-w-0 grid-cols-[minmax(0,1fr)_auto] items-center gap-x-3 gap-y-2 py-3 sm:grid-cols-[minmax(0,1fr)_11rem_auto]">
          <div className="min-w-0"><p className="break-words text-sm font-medium">{material?.name ?? 'Removed material'}</p>{material?.detail && <p className="text-xs text-text-secondary">{material.detail}</p>}<p className="mt-1 text-xs text-text-secondary">{material?.payableCentavos !== null && material?.payableCentavos !== undefined ? `Within payable materials: ${formatPesoCentavos(material.payableCentavos)}` : 'Payable value pending valid quantities and prices.'}</p></div>
          <div className="col-span-2 sm:col-span-1"><MoneyField label="Preparation cost (₱)" aria-label={`Preparation cost for ${[material?.name ?? 'removed material', material?.detail].filter(Boolean).join(', ')}`} valueCentavos={amount} allowEmptyZero placeholder="0.00" disabled={disabled || !material || material.payableCentavos === null || material.payableCentavos === 0} error={amount === 0 ? undefined : lineError} onChange={next => onChange({ ...value, allocations: { ...value.allocations, [materialId]: next } })} /></div>
          <Button variant="quiet" className="col-start-2 row-start-1 min-w-11 px-3 sm:col-start-3" aria-label={`Remove ${[material?.name ?? 'removed material', material?.detail].filter(Boolean).join(', ')} from NRPC`} disabled={disabled} onClick={remove}><Trash2 size={16} aria-hidden="true" /></Button>
          {lineError && amount === 0 && <p role="status" className="col-span-full text-xs text-text-secondary">{lineError}</p>}
        </div>
      })}</div>}
      {allocationError && <p role="alert" className="text-sm text-status-error">{allocationError}</p>}
      <div aria-live="polite" className="flex flex-wrap items-center justify-between gap-2 text-sm"><p className="font-semibold">NRPC total <span className="ml-2 tabular-nums">{assessment.totalCentavos === null ? 'Enter valid amounts' : formatPesoCentavos(assessment.totalCentavos)}</span></p><p className="text-xs text-text-secondary">{assessment.eligibleSubtotalCentavos !== null && selected.length > 0 ? `Prepared materials payable: ${formatPesoCentavos(assessment.eligibleSubtotalCentavos)}` : assessment.allocationError ?? 'Included in the order total.'}</p></div>
    </>}
  </section>
}
