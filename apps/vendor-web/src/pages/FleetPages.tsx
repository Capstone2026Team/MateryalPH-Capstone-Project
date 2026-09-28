import { useCallback, useEffect, useRef, useState, type ReactNode } from 'react'
import { Link } from 'react-router-dom'
import { AlertTriangle, CheckCircle2, Truck } from 'lucide-react'
import { Button, ConflictBanner, DeliveryVehicles, StatusMessage, type DeliveryVehicleDraft } from '@materyalph/web-ui'
import { apiFailure, fleetImageUrl, listFleet, readableInventoryError, saveFleet, uploadFleetImage, type FleetVehicle, type FleetVehicleListMeta } from '../lib/inventory-api'
import { fleetFieldNames, fleetVehicleDraft, fleetVehiclePayload, vehicleErrors } from '../lib/delivery-vehicles'
import { useOnboardingSnapshot } from '../lib/vendor-status'
import { ErrorState, LoadingState, PageHeader, VendorShell } from './PhaseThreeVendorPages'
import { storeName } from '../lib/catalog-access'

const reasonText: Record<string, string> = {
  DELIVERY_NOT_ENABLED: 'Vendor Delivery is not enabled for your store', VEHICLE_DISABLED: 'Turned off for future deliveries', VEHICLE_UNAVAILABLE: 'Marked unavailable now',
  VEHICLE_INCOMPLETE: 'Configuration incomplete', IMAGE_MISSING: 'Vehicle image missing', RATE_MISSING: 'Delivery rates missing',
}

/** Eligibility for future proposals, as text plus icon. */
function Eligibility({ vehicle }: { vehicle: FleetVehicle }) {
  if (vehicle.eligibility.eligible) return <p className="flex items-center gap-2 text-sm font-semibold text-status-success"><CheckCircle2 size={16} aria-hidden="true" />Eligible for delivery proposals (configuration v{vehicle.configurationVersion}{vehicle.rateVersion ? `, rates v${vehicle.rateVersion}` : ''})</p>
  return <p className="flex items-start gap-2 text-sm font-semibold text-status-warning"><AlertTriangle size={16} className="mt-0.5 shrink-0" aria-hidden="true" />Not offered for new deliveries: {vehicle.eligibility.reasons.map(reason => reasonText[reason] ?? reason).join('; ')}</p>
}

export function VendorFleetPage() {
  const { snapshot, loading: snapshotLoading, error: snapshotError, refresh } = useOnboardingSnapshot()
  const permissions = snapshot?.permissions ?? []
  const [saved, setSaved] = useState<FleetVehicle[]>([])
  const [meta, setMeta] = useState<FleetVehicleListMeta | null>(null)
  const [drafts, setDrafts] = useState<DeliveryVehicleDraft[]>([])
  const [errors, setErrors] = useState<Record<string, Record<string, string>>>({})
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState<string | null>(null)
  const [notice, setNotice] = useState<{ tone: 'success' | 'error'; text: string } | null>(null)
  const [conflict, setConflict] = useState(false)
  const [busy, setBusy] = useState(false)
  const [dirty, setDirty] = useState(false)
  const [attempt, setAttempt] = useState(0)
  const pendingImages = useRef(new Set<string>())
  const canManage = permissions.includes('vehicles.manage')
  const canView = permissions.includes('portal.vehicles')

  const apply = useCallback((items: FleetVehicle[], nextMeta: FleetVehicleListMeta) => {
    setSaved(items); setMeta(nextMeta); setDrafts(items.map(fleetVehicleDraft)); setErrors({}); setDirty(false)
  }, [])
  useEffect(() => {
    if (!canView) return
    let active = true
    setLoading(true); setError(null)
    listFleet().then(result => { if (active) apply(result.items, result.meta) })
      .catch(async cause => { const text = await readableInventoryError(cause); if (active) setError(text) })
      .finally(() => { if (active) setLoading(false) })
    return () => { active = false }
  }, [canView, attempt, apply])

  async function save() {
    if (pendingImages.current.size > 0) { setNotice({ tone: 'error', text: 'Wait for the vehicle image upload to finish, or retry it, before saving.' }); return }
    const local = Object.fromEntries(drafts.map(vehicle => [vehicle.key, vehicleErrors(vehicle, true)]).filter(([, issues]) => Object.keys(issues as object).length > 0))
    setErrors(local); setNotice(null)
    if (Object.keys(local).length) { setNotice({ tone: 'error', text: 'Review the highlighted vehicle fields. Each vehicle shows its own problems.' }); return }
    const changed = drafts.filter(vehicle => !vehicle.id || vehicle.removed || JSON.stringify(fleetVehiclePayload(vehicle)) !== JSON.stringify(fleetVehiclePayload(fleetVehicleDraft(saved.find(row => row.id === vehicle.id) as FleetVehicle))))
    if (changed.length === 0) { setNotice({ tone: 'success', text: 'No vehicle changes to save.' }); return }
    setBusy(true)
    try {
      const result = await saveFleet(changed.map(fleetVehiclePayload))
      apply(result.items, result.meta)
      setNotice({ tone: 'success', text: 'Vehicles saved. Future delivery proposals use these settings; accepted orders keep their confirmed vehicle, rate and address.' })
    } catch (cause) {
      const failure = await apiFailure(cause)
      if (failure?.status === 409) setConflict(true)
      else if (failure?.status === 422) {
        const mapped: Record<string, Record<string, string>> = {}
        for (const [field, messages] of Object.entries(failure.details)) {
          const match = /^vehicles\.(\d+)\.(.+)$/.exec(field)
          const vehicle = match ? changed[Number(match[1])] : undefined
          const name = match ? fleetFieldNames[match[2] ?? ''] : undefined
          if (vehicle && name && Array.isArray(messages) && typeof messages[0] === 'string') mapped[vehicle.key] = { ...(mapped[vehicle.key] ?? {}), [name]: messages[0] }
        }
        setErrors(mapped)
        setNotice({ tone: 'error', text: await readableInventoryError(cause) })
      } else setNotice({ tone: 'error', text: await readableInventoryError(cause) })
    } finally { setBusy(false) }
  }

  const header = <PageHeader eyebrow="Store Management" title="Vehicles" description="Delivery vehicles, capacities, rates and service limits for future proposals. Recommendations are advisory; you confirm vehicles, trips and the final formula fee before a Buyer accepts." />
  const shell = (children: ReactNode) => <VendorShell activeHref="/vehicles" accountLabel={storeName(snapshot)} navigationData={snapshot}>{children}</VendorShell>
  if (snapshotLoading && !snapshot) return <VendorShell activeHref="/vehicles" accountLabel="Vendor" navigationData={null}><LoadingState label="Loading vehicles…" /></VendorShell>
  if (snapshotError && !snapshot) return <VendorShell activeHref="/vehicles" accountLabel="Vendor" navigationData={null}><ErrorState message={snapshotError} onRetry={() => void refresh()} /></VendorShell>
  if (!canView) return shell(<>{header}<div className="mt-6"><StatusMessage tone="error">Your role does not include Vehicles. Ask the store Owner if you need access.</StatusMessage></div></>)
  const deliveryOff = meta?.delivery && !meta.delivery.deliveryEnabled
  const notices = Object.fromEntries(drafts.filter(draft => draft.id).map(draft => { const row = saved.find(vehicle => vehicle.id === draft.id); return [draft.key, row ? <Eligibility key={draft.key} vehicle={row} /> : null] }))

  return shell(<div className="space-y-6">
    {header}
    {loading ? <LoadingState label="Loading vehicles…" />
      : error ? <ErrorState message={error} onRetry={() => setAttempt(value => value + 1)} />
        : meta?.scope === 'ASSIGNED_ONLY' ? <section className="rounded-surface border border-dashed border-border-default bg-surface-primary p-8 text-center"><Truck size={32} className="mx-auto text-text-secondary" aria-hidden="true" /><h2 className="mt-3 text-xl font-semibold">No assigned vehicle yet.</h2><p className="mx-auto mt-2 max-w-md text-sm text-text-secondary">The vehicle confirmed for an order assigned to you appears here. Vehicle configuration, fees and capacity are managed by the Owner or Store Manager.</p></section>
          : <>
            {deliveryOff && <StatusMessage>Vendor Delivery is not enabled for your store, so saved vehicles are kept but not offered. Change the fulfillment method in <Link className="font-semibold underline" to="/store-profile">Store Profile</Link>.</StatusMessage>}
            {conflict && <ConflictBanner title="A vehicle changed while you were editing" useCurrentLabel="Reload saved vehicles" onUseCurrent={() => { setConflict(false); setAttempt(value => value + 1) }}>
              <p>Another person saved a vehicle after you opened this page. Nothing was overwritten. Reload to see the saved configuration, then reapply your change.</p>
            </ConflictBanner>}
            {notice && <StatusMessage tone={notice.tone}>{notice.text}</StatusMessage>}
            {!canManage && <StatusMessage>You can view vehicles. Only the Owner or Store Manager can change vehicle configuration, fees or capacity.</StatusMessage>}
            {drafts.length === 0 && !dirty && <section className="rounded-surface border border-dashed border-border-default bg-surface-primary p-6 text-center"><h2 className="text-lg font-semibold">No vehicles yet.</h2><p className="mt-1 text-sm text-text-secondary">Add each vehicle type your store operates. At least one eligible vehicle is needed for Vendor Delivery.</p></section>}
            <DeliveryVehicles operational disabled={!canManage || busy} vehicles={drafts} errors={errors} notices={notices} coverageKm={meta?.delivery?.serviceRadiusKm ?? 50}
              onChange={next => { setDrafts(next); setDirty(true) }}
              onImagePending={(key, pending) => { if (pending) pendingImages.current.add(key); else pendingImages.current.delete(key) }}
              uploadImage={async file => { try { return await uploadFleetImage(file) } catch (cause) { throw new Error(await readableInventoryError(cause)) } }}
              resolveImage={fleetImageUrl} />
            {canManage && <div className="sticky bottom-0 z-10 flex flex-wrap items-center gap-3 border-t border-border-default bg-surface-canvas py-4">
              <Button disabled={busy || !dirty} onClick={() => void save()}>{busy ? 'Saving…' : 'Save vehicles'}</Button>
              <Button variant="secondary" disabled={busy || !dirty} onClick={() => { apply(saved, meta as FleetVehicleListMeta); setNotice(null) }}>Discard changes</Button>
              {dirty && <span className="text-sm text-text-secondary" role="status">Unsaved changes</span>}
            </div>}
          </>}
  </div>)
}
