import { useId } from 'react'

/** Displays physical payment options; checkout still enforces the fulfillment/payment pairing. */
export function PhysicalPaymentOptions({ codEnabled, inStoreEnabled, disabled = false, onChange }: {
  codEnabled: boolean
  inStoreEnabled: boolean
  disabled?: boolean
  onChange?: (options: { codEnabled: boolean; inStoreEnabled: boolean }) => void
}) {
  const id = useId()
  return <div className="grid gap-4">
    <label className="flex min-h-11 items-start gap-3 text-sm">
      <input type="checkbox" className="mt-0.5 h-5 w-5 shrink-0 accent-action-primary" checked={codEnabled} disabled={disabled || !onChange} aria-labelledby={`${id}-cod-label`} aria-describedby={`${id}-cod-note`} onChange={event => onChange?.({ codEnabled: event.target.checked, inStoreEnabled })} />
      <span><span id={`${id}-cod-label`} className="font-semibold">Accept Cash on Delivery</span><span id={`${id}-cod-note`} className="block text-text-secondary">Cash on Delivery pairs with Site Delivery only.</span></span>
    </label>
    <label className="flex min-h-11 items-start gap-3 text-sm">
      <input type="checkbox" className="mt-0.5 h-5 w-5 shrink-0 accent-action-primary" checked={inStoreEnabled} disabled={disabled || !onChange} aria-labelledby={`${id}-in-store-label`} aria-describedby={`${id}-in-store-note`} onChange={event => onChange?.({ codEnabled, inStoreEnabled: event.target.checked })} />
      <span><span id={`${id}-in-store-label`} className="font-semibold">Accept In-Store Payment</span><span id={`${id}-in-store-note`} className="block text-text-secondary">In-Store Payment pairs with Self-Pickup only.</span></span>
    </label>
  </div>
}
