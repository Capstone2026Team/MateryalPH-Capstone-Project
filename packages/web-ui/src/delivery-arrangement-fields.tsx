import { useId } from 'react'

export type DeliveryArrangementValues = {
  arrangement: string
  accessConfirmed: boolean
  heavyAccessConfirmed: boolean
  manualReviewNote: string
  changeReason?: string
}

export function DeliveryArrangementFields({ value, onChange, disabled = false, showHeavyAccess = false, manualReviewRequired = false, recommendationChanged = false, errors = {} }: {
  value: DeliveryArrangementValues
  onChange: (patch: Partial<DeliveryArrangementValues>) => void
  disabled?: boolean
  showHeavyAccess?: boolean
  manualReviewRequired?: boolean
  recommendationChanged?: boolean
  errors?: Record<string, string>
}) {
  const id = useId()
  const textarea = 'w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 py-2 text-sm font-normal placeholder:text-text-secondary disabled:opacity-60'
  const review = <label className="grid gap-2 text-sm font-semibold">Manual load review
    <textarea className={textarea} rows={2} maxLength={2000} disabled={disabled} value={value.manualReviewNote} placeholder="Explain how you checked the load and selected the vehicles and trips." aria-invalid={Boolean(errors['delivery.manual_review_note'])} aria-describedby={errors['delivery.manual_review_note'] ? `${id}-review-error` : undefined} onChange={event => onChange({ manualReviewNote: event.target.value })} />
    {errors['delivery.manual_review_note'] && <span id={`${id}-review-error`} role="alert" className="font-normal text-status-error">{errors['delivery.manual_review_note']}</span>}
  </label>
  return <div className="grid min-w-0 gap-3">
    {(recommendationChanged || value.changeReason !== undefined) && <label className="grid gap-2 text-sm font-semibold">Reason for changing the system recommendation{recommendationChanged ? ' (required)' : ''}
      <textarea className={textarea} rows={2} minLength={10} maxLength={2000} disabled={disabled} value={value.changeReason ?? ''} placeholder="Explain why different vehicles or trips are needed. The Buyer must approve this before paying." aria-invalid={Boolean(errors['delivery.change_reason'])} aria-describedby={errors['delivery.change_reason'] ? `${id}-change-error` : undefined} onChange={event => onChange({ changeReason: event.target.value })} />
      {errors['delivery.change_reason'] && <span id={`${id}-change-error`} role="alert" className="font-normal text-status-error">{errors['delivery.change_reason']}</span>}
    </label>}
    <label className="grid gap-2 text-sm font-semibold">Arrangement shown to the Buyer
      <textarea className={textarea} rows={2} maxLength={2000} disabled={disabled} value={value.arrangement} placeholder="e.g. One truck trip to the north gate before noon." aria-invalid={Boolean(errors['delivery.arrangement'])} aria-describedby={errors['delivery.arrangement'] ? `${id}-arrangement-error` : undefined} onChange={event => onChange({ arrangement: event.target.value })} />
      {errors['delivery.arrangement'] && <span id={`${id}-arrangement-error`} role="alert" className="font-normal text-status-error">{errors['delivery.arrangement']}</span>}
    </label>
    <div className="grid gap-x-4 gap-y-1 sm:grid-cols-2">
      <div><label className="flex min-h-11 cursor-pointer items-center gap-2 text-sm"><input type="checkbox" className="h-4 w-4 shrink-0 accent-action-primary" disabled={disabled} checked={value.accessConfirmed} aria-invalid={Boolean(errors['delivery.access_confirmed'])} aria-describedby={errors['delivery.access_confirmed'] ? `${id}-access-error` : undefined} onChange={event => onChange({ accessConfirmed: event.target.checked })} /><span>Drop-off access confirmed with Buyer</span></label>
        {errors['delivery.access_confirmed'] && <p id={`${id}-access-error`} role="alert" className="text-sm text-status-error">{errors['delivery.access_confirmed']}</p>}
      </div>
      {showHeavyAccess && <div><label className="flex min-h-11 cursor-pointer items-center gap-2 text-sm"><input type="checkbox" className="h-4 w-4 shrink-0 accent-action-primary" disabled={disabled} checked={value.heavyAccessConfirmed} aria-invalid={Boolean(errors['delivery.heavy_vehicle_access_confirmed'])} onChange={event => onChange({ heavyAccessConfirmed: event.target.checked })} /><span>Heavy vehicle access confirmed</span></label>
        {errors['delivery.heavy_vehicle_access_confirmed'] && <p role="alert" className="text-sm text-status-error">{errors['delivery.heavy_vehicle_access_confirmed']}</p>}
      </div>}
    </div>
    {manualReviewRequired ? review : <details open={value.manualReviewNote.trim() !== '' || Boolean(errors['delivery.manual_review_note']) ? true : undefined} className="border-t border-border-default pt-1"><summary className="flex min-h-11 cursor-pointer items-center text-sm font-medium">Manual load review (when required)</summary>{review}</details>}
  </div>
}
