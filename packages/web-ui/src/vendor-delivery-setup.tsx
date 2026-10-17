import type { ReactNode } from 'react'
import { CheckCircle2, Circle, Truck } from 'lucide-react'

export interface VendorDeliveryReadiness {
  staffReady: boolean
  vehicleReady: boolean
  pickupLocationReady: boolean
  serviceSettingsReady: boolean
  ready: boolean
  enabled: boolean
  available: boolean
  activeDeliveryObligations: number
}

/** Shared saved-data checklist for Store Setup, Store Profile, Team Accounts and Vehicles. */
export function VendorDeliverySetup({ method, state, staffAction, vehicleAction, locationAction, activationAction, divider = true, hideWhenReady = false }: {
  method: string
  /** Set false when the surrounding layout already draws a divider above the checklist. */
  divider?: boolean
  /** Hide completed setup reminders on management pages. */
  hideWhenReady?: boolean
  state?: VendorDeliveryReadiness | undefined
  staffAction?: ReactNode
  vehicleAction?: ReactNode
  locationAction?: ReactNode
  activationAction?: ReactNode
}) {
  if (method === 'SELF_PICKUP') return <p className="text-sm leading-6 text-text-secondary">Self-Pickup Only does not require Fulfillment Staff or delivery vehicles.</p>
  if (method !== 'VENDOR_DELIVERY' && method !== 'BOTH') return null
  if (hideWhenReady && state?.ready) return null
  const rows = [
    [state?.staffReady, 'At least one active Fulfillment Staff account'],
    [state?.vehicleReady, 'At least one active registered delivery vehicle'],
    [state?.pickupLocationReady, 'Valid store pickup location'],
    [state?.serviceSettingsReady, 'Delivery service settings configured'],
  ] as const
  return <section aria-label="Vendor Delivery Setup" className={`space-y-2.5 ${divider ? 'border-t border-border-default pt-3' : ''}`}>
    <div className="flex flex-wrap items-center justify-between gap-x-4 gap-y-1">
      <h3 className="flex items-center gap-2 text-base font-semibold text-text-strong"><Truck size={18} aria-hidden="true" />Vendor Delivery Setup</h3>
      {state && <p role="status" className={`inline-flex items-center gap-1.5 text-sm font-semibold ${state.ready ? 'text-status-success' : 'text-status-warning'}`}>{state.ready ? <CheckCircle2 size={16} aria-hidden="true" /> : <Circle size={16} aria-hidden="true" />}{state.ready ? 'Vendor Delivery Ready' : 'Vendor Delivery Setup incomplete'}</p>}
    </div>
    {!state ? <p role="status" className="text-sm text-text-secondary">Refresh to check your saved delivery setup. Delivery cannot be activated until eligibility is confirmed.</p> : <>
      <ul className="grid gap-x-8 gap-y-1 sm:grid-cols-2">{rows.map(([complete, label]) => <li key={label} className="flex items-center gap-2 text-sm text-text-strong">
        {complete ? <CheckCircle2 size={16} className="shrink-0 text-status-success" aria-hidden="true" /> : <Circle size={16} className="shrink-0 text-text-secondary" aria-hidden="true" />}
        <span><span className="sr-only">{complete ? 'Complete: ' : 'Required: '}</span>{label}</span>
      </li>)}</ul>
      {!state.staffReady && <div className="space-y-1"><h4 className="text-sm font-semibold">Fulfillment Staff Required</h4><p className="text-sm text-text-secondary">To enable vendor-managed delivery, you must first create at least one active Fulfillment Staff account. This staff member will be responsible for managing assigned deliveries, updating delivery statuses, and submitting proof of delivery.</p>{staffAction}</div>}
      {!state.vehicleReady && <div className="space-y-1"><h4 className="text-sm font-semibold">Delivery Vehicle Required</h4><p className="text-sm text-text-secondary">To enable vendor-managed delivery, you must register at least one active delivery vehicle. Registered vehicles are used to assign and manage deliveries through your Fulfillment Staff. The vehicle must be available and have complete capacity, image and delivery rates.</p>{vehicleAction}</div>}
      {!state.pickupLocationReady && <div className="space-y-1"><p className="text-sm text-text-secondary">Save a valid store address and map location in Store Verification.</p>{locationAction}</div>}
      {!state.serviceSettingsReady && <p className="text-sm text-text-secondary">Configure the delivery service settings before activating delivery.</p>}
      <p className="text-sm text-text-secondary">{state.available ? 'Vendor Delivery is available for new orders.' : state.enabled ? 'Vendor Delivery is temporarily unavailable for new orders until the missing setup is resolved.' : 'Saved as a draft. Activate Vendor Delivery when all requirements are complete.'} Existing delivery orders remain accessible with their saved assignments.</p>
      {state.activeDeliveryObligations > 0 && <p className="text-sm text-text-secondary">{state.activeDeliveryObligations} active delivery {state.activeDeliveryObligations === 1 ? 'obligation remains' : 'obligations remain'}. Complete them before switching to Self-Pickup Only. You can pause new deliveries.</p>}
    </>}
    {activationAction}
  </section>
}
