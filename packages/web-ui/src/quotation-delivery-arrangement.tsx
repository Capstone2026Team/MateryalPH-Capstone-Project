import type { DeliveryPlan, DeliveryPlanVehicle } from '@materyalph/api-client-ts'
import { Button } from './button'
import { DeliveryArrangementFields } from './delivery-arrangement-fields'
import { deliveryPlanVehicleOptions } from './delivery-plan-options'
import { Field } from './field'
import { Select } from './filter-controls'
import { MoneyField } from './money-field'
import { formatPesoCentavos } from './order-patterns'
import { StatusMessage } from './status-message'

export type QuotationVehicleSelection = { vehicle_id: string; number_of_vehicles: number; total_vehicle_trips: number; group_key?: string }
export function quotationSelectedVehicles(value: unknown): QuotationVehicleSelection[] {
  if (!Array.isArray(value)) return []
  return value.flatMap((row: unknown) => {
    if (typeof row !== 'object' || row === null || !('vehicle_id' in row) || typeof row.vehicle_id !== 'string') return []
    return [{ vehicle_id: row.vehicle_id, number_of_vehicles: 'number_of_vehicles' in row && typeof row.number_of_vehicles === 'number' ? row.number_of_vehicles : 0, total_vehicle_trips: 'total_vehicle_trips' in row && typeof row.total_vehicle_trips === 'number' ? row.total_vehicle_trips : 0, ...('group_key' in row && typeof row.group_key === 'string' ? { group_key: row.group_key } : {}) }]
  })
}
export function quotationVehicleChoice(groupKey: string, vehicle: DeliveryPlanVehicle): QuotationVehicleSelection {
  return { group_key: groupKey, vehicle_id: vehicle.vehicleId, number_of_vehicles: vehicle.numberOfVehicles ?? 1, total_vehicle_trips: vehicle.totalVehicleTrips ?? 1 }
}
export function quotationDeliveryFee(plan: DeliveryPlan, vehicles: QuotationVehicleSelection[]): number | null {
  if (!vehicles.length || plan.groups.some(group => !vehicles.some(row => (row.group_key ?? plan.groups[0]?.key) === group.key))) return null
  let total = 0n
  for (const row of vehicles) {
    const vehicle = plan.eligibleVehicles.find(item => item.vehicleId === row.vehicle_id)
    if (!vehicle || !Number.isSafeInteger(row.number_of_vehicles) || !Number.isSafeInteger(row.total_vehicle_trips) || row.number_of_vehicles < 1 || row.total_vehicle_trips < row.number_of_vehicles) return null
    const units = vehicle.mobilizationBasis === 'PER_TRIP' ? row.total_vehicle_trips : vehicle.mobilizationBasis === 'PER_TRUCK' ? row.number_of_vehicles : 0
    total += BigInt(vehicle.perTripCentavos) * BigInt(row.total_vehicle_trips) + BigInt(vehicle.mobilizationFeeCentavos ?? 0) * BigInt(units)
  }
  return total <= BigInt(Number.MAX_SAFE_INTEGER) ? Number(total) : null
}
export function quotationDeliveryChanged(plan: DeliveryPlan | null, value: Record<string, unknown>): boolean {
  const vehicles = quotationSelectedVehicles(value.vehicles)
  return Boolean(plan && (value.fee_override === true || plan.groups.some(group => {
    const selected = vehicles.filter(row => (row.group_key ?? plan.groups[0]?.key) === group.key)
    const recommended = group.candidates[0]
    return recommended && (selected.length !== 1 || selected[0]?.vehicle_id !== recommended.vehicleId || selected[0]?.number_of_vehicles !== recommended.numberOfVehicles || selected[0]?.total_vehicle_trips !== recommended.totalVehicleTrips)
  })))
}
export function QuotationDeliveryArrangement({ value, onChange, plan, loading, error, disabled = false, onRetry }: {
  value: Record<string, unknown>
  onChange: (patch: Record<string, unknown>) => void
  plan: DeliveryPlan | null
  loading: boolean
  error: string | null
  disabled?: boolean
  onRetry: () => void
}) {
  const vehicles = quotationSelectedVehicles(value.vehicles)
  const fee = typeof value.final_fee_centavos === 'number' && value.final_fee_centavos >= 0 ? value.final_fee_centavos : null
  const changed = quotationDeliveryChanged(plan, value)
  const choose = (group: string, patch: QuotationVehicleSelection) => onChange({ vehicles: [...vehicles.filter(row => (row.group_key ?? plan?.groups[0]?.key) !== group), patch] })
  return <section aria-label="Delivery arrangement" className="grid min-w-0 gap-3 border-t border-border-default pt-4">
    <div><h4 className="text-sm font-semibold">Delivery arrangement &amp; fee</h4><p className="mt-1 text-xs text-text-secondary">The system calculates from the road distance, configured rates, load, vehicles and trips.</p></div>
    {loading && <p role="status" className="text-sm text-text-secondary">Calculating route and delivery options…</p>}
    {error && <StatusMessage tone="error">{error}<Button variant="secondary" disabled={disabled || loading} onClick={onRetry}>Retry delivery calculation</Button></StatusMessage>}
    {plan && <>
      <p className="text-sm">Road distance: <strong>{(plan.route.distanceMeters / 1000).toLocaleString('en-PH', { maximumFractionDigits: 2 })} km</strong> · {plan.endpoint.kind === 'ALTERNATE_DROP_OFF' ? 'Alternative vehicle drop-off' : 'Intended destination'}</p>
      {plan.status !== 'CANDIDATES_AVAILABLE' && <StatusMessage tone="info">{plan.reason}</StatusMessage>}
      {plan.groups.map(group => {
        const options = deliveryPlanVehicleOptions(group)
        const selected = vehicles.find(row => (row.group_key ?? plan.groups[0]?.key) === group.key)
        const option = options.find(item => item.vehicleId === selected?.vehicle_id)
        return <div key={group.key} className="grid gap-3 border-t border-border-default pt-3 sm:grid-cols-[minmax(0,1fr)_6rem_6rem]">
          <Select label={`Vehicle for ${group.label || 'material'}`} value={selected?.vehicle_id ?? ''} disabled={disabled || loading || !options.length} onChange={event => { const vehicle = options.find(item => item.vehicleId === event.target.value); if (vehicle) choose(group.key, quotationVehicleChoice(group.key, vehicle)) }}>
            <option value="">{options.length ? 'Select a vehicle' : 'No eligible vehicle'}</option>
            {options.map(vehicle => <option key={vehicle.vehicleId} value={vehicle.vehicleId}>{vehicle.name}{vehicle.recommended ? ' · Recommended' : ''}</option>)}
          </Select>
          <Field label="Vehicles" type="number" min={1} max={option?.numberAvailable} value={selected?.number_of_vehicles ?? ''} disabled={disabled || loading || !selected} onChange={event => { if (selected) choose(group.key, { ...selected, number_of_vehicles: Number(event.target.value) }) }} />
          <Field label="Total trips" type="number" min={selected?.number_of_vehicles ?? 1} value={selected?.total_vehicle_trips ?? ''} disabled={disabled || loading || !selected} onChange={event => { if (selected) choose(group.key, { ...selected, total_vehicle_trips: Number(event.target.value) }) }} />
          {option && <p className="text-xs text-text-secondary sm:col-span-3">{formatPesoCentavos(option.perTripCentavos)} per trip{(option.mobilizationFeeCentavos ?? 0) > 0 ? ` + ${formatPesoCentavos(option.mobilizationFeeCentavos)} mobilization ${option.mobilizationBasis === 'PER_TRIP' ? 'per trip' : 'per truck'}` : ''}</p>}
        </div>
      })}
    </>}
    <label className="flex min-h-11 items-center gap-2 text-sm"><input type="checkbox" checked={value.fee_override === true} disabled={disabled || loading || !plan} onChange={event => onChange({ fee_override: event.target.checked })} />Enter delivery fee manually</label>
    <MoneyField label="Delivery fee before discount (₱)" valueCentavos={fee} placeholder="Awaiting delivery calculation" disabled={disabled || loading || value.fee_override !== true} onChange={amount => onChange({ final_fee_centavos: amount ?? -1 })} />
    <p className="text-xs text-text-secondary">{value.fee_override === true ? 'Explain the manual fee below. The Buyer must review and accept it.' : 'Updates automatically when vehicles or trips change. Any delivery discount is applied afterward.'}</p>
    <DeliveryArrangementFields disabled={disabled} showHeavyAccess manualReviewRequired={plan?.status === 'MANUAL_REVIEW_REQUIRED'} recommendationChanged={changed} value={{ arrangement: typeof value.arrangement === 'string' ? value.arrangement : '', accessConfirmed: value.access_confirmed === true, heavyAccessConfirmed: value.heavy_vehicle_access_confirmed === true, manualReviewNote: typeof value.manual_review_note === 'string' ? value.manual_review_note : '', changeReason: typeof value.change_reason === 'string' ? value.change_reason : '' }} onChange={patch => onChange({ ...(patch.arrangement !== undefined ? { arrangement: patch.arrangement } : {}), ...(patch.accessConfirmed !== undefined ? { access_confirmed: patch.accessConfirmed } : {}), ...(patch.heavyAccessConfirmed !== undefined ? { heavy_vehicle_access_confirmed: patch.heavyAccessConfirmed } : {}), ...(patch.manualReviewNote !== undefined ? { manual_review_note: patch.manualReviewNote } : {}), ...(patch.changeReason !== undefined ? { change_reason: patch.changeReason } : {}) })} />
  </section>
}
