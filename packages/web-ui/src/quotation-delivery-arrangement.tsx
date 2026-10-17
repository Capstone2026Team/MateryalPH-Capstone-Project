import { useEffect, useState } from 'react'
import { Trash2, Truck } from 'lucide-react'
import type { FleetVehicle } from '@materyalph/api-client-ts'
import { Button } from './button'
import { DeliveryArrangementFields } from './delivery-arrangement-fields'
import { Field } from './field'
import { Select } from './filter-controls'
import { MoneyField } from './money-field'
import { StatusMessage } from './status-message'

type VehicleSelection = { vehicle_id: string; number_of_vehicles: number; total_vehicle_trips: number; group_key?: string }

function selectedVehicles(value: unknown): VehicleSelection[] {
  if (!Array.isArray(value)) return []
  return value.flatMap((row: unknown) => {
    if (typeof row !== 'object' || row === null || !('vehicle_id' in row) || typeof row.vehicle_id !== 'string') return []
    return [{ vehicle_id: row.vehicle_id, number_of_vehicles: 'number_of_vehicles' in row && typeof row.number_of_vehicles === 'number' ? row.number_of_vehicles : 0, total_vehicle_trips: 'total_vehicle_trips' in row && typeof row.total_vehicle_trips === 'number' ? row.total_vehicle_trips : 0, ...('group_key' in row && typeof row.group_key === 'string' ? { group_key: row.group_key } : {}) }]
  })
}

export function QuotationDeliveryArrangement({ value, onChange, active, disabled = false, loadVehicles, readableError }: {
  value: Record<string, unknown>
  onChange: (patch: Record<string, unknown>) => void
  active: boolean
  disabled?: boolean
  loadVehicles: () => Promise<FleetVehicle[]>
  readableError: (error: unknown) => Promise<string>
}) {
  const [fleet, setFleet] = useState<FleetVehicle[]>([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [reload, setReload] = useState(0)
  useEffect(() => {
    if (!active) return
    let current = true
    setLoading(true)
    setError(null)
    void loadVehicles().then(items => { if (current) setFleet(items) }).catch(async cause => { const message = await readableError(cause); if (current) setError(message) }).finally(() => { if (current) setLoading(false) })
    return () => { current = false }
  }, [active, reload, loadVehicles, readableError])
  const vehicles = selectedVehicles(value.vehicles)
  const available = fleet.filter(vehicle => vehicle.active && vehicle.available && !vehicles.some(row => row.vehicle_id === vehicle.id))
  const fee = typeof value.final_fee_centavos === 'number' && value.final_fee_centavos >= 0 ? value.final_fee_centavos : value.final_fee_centavos === undefined ? 0 : null
  // An unknown saved vehicle still needs the access confirmation until its metadata loads.
  const heavy = vehicles.some(row => !fleet.find(vehicle => vehicle.id === row.vehicle_id) || fleet.find(vehicle => vehicle.id === row.vehicle_id)?.heavyClassification === 'HEAVY')
  return <section aria-label="Delivery arrangement" className="grid min-w-0 gap-3 rounded-surface border border-border-default p-3 sm:p-4">
    <div><h4 className="flex items-center gap-2 text-sm font-semibold"><Truck size={17} aria-hidden="true" />Delivery arrangement</h4><p className="mt-1 text-xs text-text-secondary">Uses the Buyer's saved inquiry destination. Vehicles, road distance and rates are checked before publication.</p></div>
    {error && <StatusMessage tone="error">{error}<Button variant="secondary" disabled={disabled || loading} onClick={() => setReload(value => value + 1)}>Retry vehicles</Button></StatusMessage>}
    <div className="grid min-w-0 items-start gap-3 sm:grid-cols-[minmax(0,1fr)_minmax(10rem,0.6fr)]">
      <Select label="Add vehicle" value="" disabled={disabled || loading || Boolean(error) || available.length === 0} onChange={event => { if (event.target.value) onChange({ vehicles: [...vehicles, { vehicle_id: event.target.value, number_of_vehicles: 1, total_vehicle_trips: 1 }] }) }}>
        <option value="">{loading ? 'Loading available vehicles…' : !available.length ? 'No more available vehicles' : 'Choose a vehicle'}</option>
        {available.map(vehicle => <option key={vehicle.id} value={vehicle.id}>{vehicle.name}{vehicle.brand ? ` · ${vehicle.brand}` : ''}</option>)}
      </Select>
      <MoneyField label="Delivery fee before discount (₱)" valueCentavos={fee} allowEmptyZero placeholder="0.00" disabled={disabled} onChange={amount => onChange({ final_fee_centavos: amount ?? -1 })} />
    </div>
    {!loading && !error && fleet.filter(vehicle => vehicle.active && vehicle.available).length === 0 && <p role="status" className="text-sm text-text-secondary">No available vehicles. Update your fleet before preparing delivery.</p>}
    {vehicles.length > 0 && <div className="divide-y divide-border-default rounded-control border border-border-default">{vehicles.map((row, index) => {
      const vehicle = fleet.find(item => item.id === row.vehicle_id)
      return <div key={row.vehicle_id} className="grid min-w-0 grid-cols-[minmax(0,1fr)_auto] items-center gap-3 p-3 sm:grid-cols-[minmax(0,1fr)_6rem_6rem_auto]">
        <div className="min-w-0"><p className="break-words text-sm font-semibold">{vehicle?.name ?? `Selected vehicle ${index + 1}`}</p>{vehicle && <p className="text-xs text-text-secondary">{[vehicle.brand, vehicle.heavyClassification === 'HEAVY' ? 'Heavy vehicle' : null].filter(Boolean).join(' · ')}</p>}</div>
        <div className="col-span-2 grid grid-cols-2 gap-3 sm:contents">{(['number_of_vehicles', 'total_vehicle_trips'] as const).map(field => <Field key={field} label={field === 'number_of_vehicles' ? 'Vehicles' : 'Total trips'} type="number" inputMode="numeric" min={1} max={field === 'number_of_vehicles' ? vehicle?.numberAvailable : undefined} value={row[field] || ''} disabled={disabled} onChange={event => onChange({ vehicles: vehicles.map((item, i) => i === index ? { ...item, [field]: Number(event.target.value) } : item) })} />)}</div>
        <Button variant="quiet" className="col-start-2 row-start-1 min-w-11 px-3 sm:col-start-4" aria-label={`Remove ${vehicle?.name ?? `vehicle ${index + 1}`}`} disabled={disabled} onClick={() => onChange({ vehicles: vehicles.filter((_, i) => i !== index) })}><Trash2 size={16} aria-hidden="true" /></Button>
      </div>
    })}</div>}
    <p className="text-xs text-text-secondary">Enter the configured rate × total trips. Any delivery discount is deducted after this fee is verified.</p>
    <DeliveryArrangementFields disabled={disabled} showHeavyAccess={heavy || Boolean(value.heavy_vehicle_access_confirmed)} value={{ arrangement: typeof value.arrangement === 'string' ? value.arrangement : '', accessConfirmed: value.access_confirmed === true, heavyAccessConfirmed: value.heavy_vehicle_access_confirmed === true, manualReviewNote: typeof value.manual_review_note === 'string' ? value.manual_review_note : '', changeReason: typeof value.change_reason === 'string' ? value.change_reason : '' }} onChange={patch => onChange({ ...(patch.arrangement !== undefined ? { arrangement: patch.arrangement } : {}), ...(patch.accessConfirmed !== undefined ? { access_confirmed: patch.accessConfirmed } : {}), ...(patch.heavyAccessConfirmed !== undefined ? { heavy_vehicle_access_confirmed: patch.heavyAccessConfirmed } : {}), ...(patch.manualReviewNote !== undefined ? { manual_review_note: patch.manualReviewNote } : {}), ...(patch.changeReason !== undefined ? { change_reason: patch.changeReason } : {}) })} />
  </section>
}
