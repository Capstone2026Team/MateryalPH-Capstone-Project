import { EmptyState } from './page-patterns'
import { useEffect, useId, useRef, useState, type ReactNode } from 'react'
import { ConfirmDialog } from './confirm-dialog'
import { FormDialog } from './form-dialog'
import { Button } from './button'
import { Field } from './field'
import { ImagePlus, Pencil, Plus, Truck, Upload, Trash2 } from 'lucide-react'

export type VehicleCapacitySource = { id: string; label: string; volumeM3: string; kgPerM3: string }

export type DeliveryVehicleDraft = {
  key: string; id?: string; category: string; type: string; customType: string; name: string; brand: string;
  count: string; weight: string; mixer: string; length: string; width: string; height: string; heavy: string;
  baseFee: string; perKm: string; imageId: string; active: boolean
  /** Mixer only: Vendor-set mobilization fee and whether it is charged per truck or per trip. */
  mobilizationFee: string; mobilizationBasis: string
  /** Operational fleet fields: per-vehicle service limit, temporary availability, removal and optimistic version. */
  maxDistance: string; available: boolean; removed: boolean; lockVersion?: number
  /** Advisory UI state only. Saved capacities remain Vendor-entered operational values. */
  capacitySourceId?: string; capacityReviewRequired?: boolean
}
type Option = { value: string; label: string; description: string }
export const vehicleCategories: Option[] = [
  { value: 'MOTORCYCLE', label: 'Motorcycle', description: 'A two-wheeled vehicle for small, light loads.' },
  { value: 'PICKUP', label: 'Pickup', description: 'A light cargo vehicle with an open rear bed.' },
  { value: 'VAN', label: 'Van', description: 'An enclosed vehicle that protects cargo from the weather.' },
  { value: 'TRUCK', label: 'Truck', description: 'A larger vehicle for heavy, bulky or specialized materials.' },
]
export const vehicleTypes: Record<string, Option[]> = {
  MOTORCYCLE: [],
  PICKUP: [
    { value: 'COMPACT_PICKUP', label: 'Compact Pickup', description: 'A smaller pickup for lighter loads and tighter access.' },
    { value: 'MID_SIZE_PICKUP', label: 'Mid-Size Pickup', description: 'A medium pickup with an open bed for general materials.' },
    { value: 'HEAVY_DUTY_PICKUP', label: 'Heavy-Duty Pickup', description: 'A pickup designed for heavier payloads; enter its actual rated capacity.' },
  ],
  VAN: [
    { value: 'MINI_PANEL_VAN', label: 'Compact / Mini Panel Van', description: 'A small enclosed cargo van for light deliveries.' },
    { value: 'MID_SIZE_CARGO_VAN', label: 'Mid-Size Cargo Van', description: 'An enclosed van with moderate cargo space.' },
    { value: 'FULL_SIZE_CARGO_VAN', label: 'Full-Size Cargo Van', description: 'A larger enclosed van for bulkier cargo.' },
  ],
  TRUCK: [
    { value: 'BOX_TRUCK', label: 'Box Truck', description: 'An enclosed cargo box for protected general freight.' },
    { value: 'WING_TRUCK', label: 'Wing Truck', description: 'A truck with side panels that open upward for loading access.' },
    { value: 'FLATBED_TRUCK', label: 'Flatbed Truck', description: 'An open, flat platform for long or bulky materials.' },
    { value: 'CONCRETE_MIXER', label: 'Concrete Mixer Truck / Transit Mixer', description: 'A rotating mixer for ready-mixed concrete, measured in cubic meters. Not for bagged cement.' },
  ],
}
const customType: Option = { value: 'CUSTOM', label: 'Custom Vehicle Type', description: 'Describe a vehicle type not listed and provide its actual cargo capacity.' }

function Select({ label, value, options, onChange, id, error }: { error?: string | undefined; label: string; value: string; options: Option[]; onChange: (value: string) => void; id: string }) {
  return <div className="grid min-w-0 grid-cols-1 content-start gap-2"><label htmlFor={id} className="text-sm font-semibold">{label}</label><select id={id} aria-invalid={Boolean(error)} value={value} onChange={event => onChange(event.target.value)} aria-describedby={`${id}-hint`} className="min-h-12 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3 text-base focus:ring-2 focus:ring-focus-ring"><option value="">Select an option</option>{options.map(option => <option value={option.value} key={option.value}>{option.label}</option>)}</select><p id={`${id}-hint`} className="text-sm leading-6 text-text-secondary">{error || options.find(option => option.value === value)?.description || 'Choose an option to continue.'}</p></div>
}

function VehicleImage({ vehicle, upload, resolve, onChange, onPending }: { onPending: (pending: boolean) => void; vehicle: DeliveryVehicleDraft; upload: (file: File) => Promise<string>; resolve: (id: string) => Promise<string>; onChange: (id: string) => void }) {
  const [url, setUrl] = useState('')
  const [localUrl, setLocalUrl] = useState('')
  const [file, setFile] = useState<File | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const id = useId()
  const fileInput = useRef<HTMLInputElement>(null)
  const mounted = useRef(true)
  useEffect(() => { mounted.current = true; return () => { mounted.current = false } }, [])
  useEffect(() => {
    let cancelled = false
    setUrl('')
    if (vehicle.imageId) void resolve(vehicle.imageId).then(value => { if (!cancelled) setUrl(value); else if (value.startsWith('blob:')) URL.revokeObjectURL(value) }).catch(() => { if (!cancelled) setError('Image preview unavailable. Choose an image to replace it.') })
    return () => { cancelled = true }
  }, [vehicle.imageId, resolve])
  useEffect(() => () => { if (url.startsWith('blob:')) URL.revokeObjectURL(url) }, [url])
  useEffect(() => () => { if (localUrl) URL.revokeObjectURL(localUrl) }, [localUrl])
  async function send(selected: File) {
    if (!['image/jpeg', 'image/png', 'image/webp'].includes(selected.type) || selected.size > 20 * 1024 * 1024) { setError('Choose a JPEG, PNG or WebP image up to 20 MB.'); return }
    setLocalUrl(URL.createObjectURL(selected))
    onPending(true); setFile(selected); setError(''); setBusy(true)
    try {
      const imageId = await upload(selected)
      if (mounted.current) { onChange(imageId); setFile(null); onPending(false) }
    } catch (cause) { if (mounted.current) setError(cause instanceof Error ? cause.message : 'Upload failed. Try again.') } finally { if (mounted.current) setBusy(false) }
  }
  return <div className="grid min-w-0 content-start gap-3">
    <label htmlFor={id} className="text-sm font-semibold">Vehicle Image</label>
    <div className="flex aspect-[4/3] min-w-0 items-center justify-center overflow-hidden rounded-surface border-2 border-dashed border-border-default bg-surface-canvas p-4">
      {(localUrl || url) ? <img src={localUrl || url} alt={`Vehicle image preview${vehicle.name ? `: ${vehicle.name}` : ''}`} className="h-full w-full object-contain" /> : <div className="grid justify-items-center gap-3 px-3 text-center"><ImagePlus size={32} strokeWidth={1.5} className="text-text-secondary" aria-hidden="true" /><p className="text-sm font-semibold">Add a vehicle image</p><p className="text-sm leading-6 text-text-secondary">Choose a clear photo of your vehicle to review here.</p></div>}
    </div>
    <input ref={fileInput} id={id} type="file" accept="image/jpeg,image/png,image/webp" disabled={busy} className="sr-only" tabIndex={-1} onChange={event => { const selected = event.target.files?.[0]; if (selected) void send(selected); event.target.value = '' }} />
    <Button className="justify-self-start text-sm" type="button" variant="secondary" disabled={busy} onClick={() => fileInput.current?.click()}><Upload size={16} aria-hidden="true" />{busy ? 'Uploading…' : localUrl || url || vehicle.imageId ? 'Change image' : 'Select image'}</Button>
    <p className="text-sm leading-6 text-text-secondary">JPEG, PNG or WebP, up to 20 MB. Review your image before continuing.</p>
    {busy && <p role="status" className="text-sm text-text-secondary">Uploading vehicle image…</p>}
    {error && <p role="alert" className="text-sm text-status-error">{error}</p>}
    {file && !busy && <Button className="justify-self-start" type="button" variant="secondary" onClick={() => void send(file)}>Retry vehicle image</Button>}
  </div>
}

function VehicleThumbnail({ vehicle, resolve }: { vehicle: DeliveryVehicleDraft; resolve: (id: string) => Promise<string> }) {
  const [url, setUrl] = useState('')
  useEffect(() => {
    let active = true
    let resolved = ''
    setUrl('')
    if (vehicle.imageId) void resolve(vehicle.imageId).then(value => {
      resolved = value
      if (active) setUrl(value)
      else if (value.startsWith('blob:')) URL.revokeObjectURL(value)
    }).catch(() => { /* The editor provides image replacement and retry. */ })
    return () => { active = false; if (resolved.startsWith('blob:')) URL.revokeObjectURL(resolved) }
  }, [vehicle.imageId, resolve])
  return <div className="flex h-24 w-32 shrink-0 items-center justify-center overflow-hidden rounded-control border border-border-default bg-surface-canvas">
    {url ? <img src={url} alt={vehicle.name || 'Vehicle'} className="h-full w-full object-contain" /> : <Truck size={32} className="text-text-secondary" aria-hidden="true" />}
  </div>
}

export function DeliveryVehicles({ vehicles, onChange, uploadImage, resolveImage, onImagePending, errors = {}, operational = false, notices = {}, disabled = false, editorActions, editorFeedback, capacitySources = [], initialEditorKey, resetEditorRevision, onEditorChange, inlineEditor = false }: {
  onImagePending?: (key: string, pending: boolean) => void;
  errors?: Record<string, Record<string, string>>;
  vehicles: DeliveryVehicleDraft[]; onChange: (vehicles: DeliveryVehicleDraft[]) => void;
  uploadImage: (file: File) => Promise<string>; resolveImage: (id: string) => Promise<string>; coverageKm: number
  /** Operational fleet mode adds the per-vehicle distance limit, enabled/availability state and confirmed removal. */
  operational?: boolean; notices?: Record<string, ReactNode>; disabled?: boolean
  editorActions?: ReactNode; editorFeedback?: ReactNode; capacitySources?: VehicleCapacitySource[]; initialEditorKey?: string | null
  resetEditorRevision?: number; onEditorChange?: (editing: boolean) => void; inlineEditor?: boolean
}) {
  const currentVehicles = useRef(vehicles)
  currentVehicles.current = vehicles
  const [pendingRemoval, setPendingRemoval] = useState<DeliveryVehicleDraft | null>(null)
  const [pendingImageKeys, setPendingImageKeys] = useState<Set<string>>(() => new Set())
  const [editorState, setEditorState] = useState<{ key: string | null; revision: number | undefined }>({ key: null, revision: resetEditorRevision })
  const editorKey = editorState.revision === resetEditorRevision ? editorState.key : null
  const panel = useRef<HTMLElement>(null)
  const selectedKey = vehicles.some(vehicle => vehicle.key === editorKey && !vehicle.removed) ? editorKey : null
  function edit(key: string | null) {
    setEditorState({ key, revision: resetEditorRevision })
  }
  useEffect(() => { if (initialEditorKey) setEditorState({ key: initialEditorKey, revision: resetEditorRevision }) }, [initialEditorKey, resetEditorRevision])
  useEffect(() => { setPendingImageKeys(new Set()) }, [resetEditorRevision])
  useEffect(() => { onEditorChange?.(Boolean(selectedKey)) }, [selectedKey, onEditorChange])
  useEffect(() => {
    if (!operational) return
    const first = Object.keys(errors).find(key => Object.keys(errors[key] ?? {}).length > 0)
    if (first) edit(first)
  }, [errors, operational])
  function update(key: string, change: Partial<DeliveryVehicleDraft>) { onChange(currentVehicles.current.map(vehicle => vehicle.key === key ? { ...vehicle, ...change } : vehicle)) }
  function remove(vehicle: DeliveryVehicleDraft) {
    if (operational && vehicle.id) { setPendingRemoval(vehicle); return }
    onImagePending?.(vehicle.key, false)
    if (operational) edit(null)
    onChange(vehicle.id ? currentVehicles.current.map(row => row.key === vehicle.key ? { ...row, active: false } : row) : currentVehicles.current.filter(row => row.key !== vehicle.key))
  }
  const visible = vehicles.filter(vehicle => operational ? !vehicle.removed : vehicle.active)
  const amount = (value: string, suffix = '') => value.trim() && Number.isFinite(Number(value)) ? `₱${Number(value).toLocaleString('en-PH', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}${suffix}` : 'Not set'
  const selected = visible.find(vehicle => vehicle.key === selectedKey)
  const editorBusy = disabled || Boolean(selectedKey && pendingImageKeys.has(selectedKey))
  function imagePending(key: string, pending: boolean) {
    setPendingImageKeys(previous => { const next = new Set(previous); if (pending) next.add(key); else next.delete(key); return next })
    onImagePending?.(key, pending)
  }
  const editor = <div className="grid min-w-0 gap-6">{visible.map((vehicle, index) => {
      if (operational && selectedKey !== vehicle.key) return null
      const issues = errors[vehicle.key] ?? {}
      const prefix = `vehicle-${vehicle.key}`
      const mixer = vehicle.type === 'CONCRETE_MIXER'
      const detail = vehicle.category && vehicle.type
      const input = (label: string, field: keyof DeliveryVehicleDraft, type = 'text', hint?: string) => <Field label={label} error={issues[field] ?? ''} name={`${prefix}-${field}`} value={String(vehicle[field] ?? '')} onChange={event => update(vehicle.key, { [field]: event.target.value, ...(field === 'mixer' ? { capacityReviewRequired: false } : {}) })} type={type} {...(type === 'number' ? { min: field === 'count' || field === 'maxDistance' ? '1' : '0.0001', step: field === 'count' || field === 'maxDistance' ? '1' : '0.0001' } : {})} hint={hint} />
      return <fieldset key={vehicle.key} data-vehicle-editor={vehicle.key} disabled={disabled} className="min-w-0"><legend className="sr-only">Vehicle {index + 1}{vehicle.name ? ` — ${vehicle.name}` : ''}</legend>
        {!operational && <div className="mb-5 flex items-center justify-between gap-3"><h3 className="text-lg font-semibold">Vehicle {index + 1}{vehicle.name ? ` — ${vehicle.name}` : ''}</h3><Button type="button" variant="quiet" aria-label={`Remove vehicle ${index + 1}`} onClick={() => remove(vehicle)}><Trash2 size={16} aria-hidden="true" />Remove</Button></div>}
        {notices[vehicle.key] && <div className="mb-4">{notices[vehicle.key]}</div>}
        <div className="grid min-w-0 items-start gap-6 md:grid-cols-[minmax(0,1fr)_15rem]">
          <div className="grid min-w-0 gap-4">
            <h3 className="font-semibold">Vehicle details</h3>
            <div className="grid min-w-0 gap-4 sm:grid-cols-2">
              <Select id={`${prefix}-category`} label="Vehicle Category" error={issues.category} value={vehicle.category} options={vehicleCategories} onChange={category => update(vehicle.key, { category, type: category === 'MOTORCYCLE' ? 'MOTORCYCLE' : '', customType: '', mixer: '', capacityReviewRequired: false })} />
              {vehicle.category && vehicle.category !== 'MOTORCYCLE' && <Select id={`${prefix}-type`} label="Vehicle Type" error={issues.type} value={vehicle.type} options={[...(vehicleTypes[vehicle.category] ?? []), customType]} onChange={type => update(vehicle.key, { type, capacityReviewRequired: false })} />}
              {detail && <>{vehicle.type === 'CUSTOM' && input('Custom Vehicle Type', 'customType')}{input('Vehicle Name', 'name')}{input('Vehicle Brand', 'brand', 'text', 'Brand or manufacturer, where applicable.')}</>}
            </div>
            {operational && <fieldset className="flex flex-wrap gap-x-6 gap-y-1 border-t border-border-default pt-3"><legend className="sr-only">Service status</legend>
              <label className="flex min-h-11 items-center gap-2 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={vehicle.active} onChange={event => update(vehicle.key, { active: event.target.checked })} />Enabled for future deliveries</label>
              <label className="flex min-h-11 items-center gap-2 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={vehicle.available} onChange={event => update(vehicle.key, { available: event.target.checked })} />Available now</label>
            </fieldset>}
          </div>
          {detail && <div className="min-w-0">{issues.imageId && <p role="alert" className="mb-3 text-sm text-status-error">{issues.imageId}</p>}<VehicleImage onPending={pending => imagePending(vehicle.key, pending)} vehicle={vehicle} upload={uploadImage} resolve={resolveImage} onChange={imageId => update(vehicle.key, { imageId })} /></div>}
        </div>
        {detail && <div className="mt-5 grid min-w-0 gap-5">
          <section className="border-t border-border-default pt-4" aria-label="Capacity and access"><h3 className="font-semibold">Capacity and access</h3>
            <div className="mt-4 grid min-w-0 gap-4 sm:grid-cols-2 lg:grid-cols-3">{input('Number of Vehicles', 'count', 'number')}{mixer && input('Mixer Capacity (m³)', 'mixer', 'number', 'Actual usable drum volume per truck per trip. Confirm any listing-based prefill.')}{input('Maximum Weight Capacity (kg)', 'weight', 'number', 'Actual rated payload, excluding the truck’s own weight.')}{!mixer && <>{input('Cargo Length (m)', 'length', 'number', 'Usable cargo length in meters.')}{input('Cargo Width (m)', 'width', 'number', 'Usable cargo width in meters.')}{input('Cargo Height (m)', 'height', 'number', 'Usable cargo height in meters.')}</>}
            <Select id={`${prefix}-heavy`} label="Heavy Vehicle Classification" error={issues.heavy} value={vehicle.heavy} options={[{ value: 'HEAVY', label: 'Heavy vehicle', description: 'Check road restrictions, site entry and unloading space for every delivery.' }, { value: 'NOT_HEAVY', label: 'Not a heavy vehicle', description: 'Normal road and site-access checks still apply.' }]} onChange={heavy => update(vehicle.key, { heavy })} /></div>
            <CapacityGuidance vehicle={vehicle} sources={capacitySources} onChange={change => update(vehicle.key, change)} />
            {vehicle.capacitySourceId && vehicle.capacityReviewRequired !== undefined && <label className="mt-3 flex min-h-11 items-center gap-3 text-sm"><input type="checkbox" className="h-5 w-5 accent-action-primary" checked={!vehicle.capacityReviewRequired} onChange={event => update(vehicle.key, { capacityReviewRequired: !event.target.checked })} />I checked this mixer capacity against the actual truck.</label>}
            {issues.capacityReviewRequired && <p role="alert" className="text-sm text-status-error">{issues.capacityReviewRequired}</p>}
          </section>
          <section aria-label={`Vehicle ${index + 1} delivery rates`} className="min-w-0 border-t border-border-default pt-4"><h3 className="font-semibold">Delivery rates</h3><p className="mt-1 text-sm text-text-secondary">Amounts in Philippine pesos. You confirm the final arrangement and fee before Buyer acceptance.</p><div className="mt-4 grid min-w-0 gap-4 sm:grid-cols-2 lg:grid-cols-3">{input('Base Fee (₱)', 'baseFee', 'text', 'Fixed amount per vehicle trip.')}{input('Per-Kilometer Rate (₱/km)', 'perKm', 'text', 'Distance-based amount per trip.')}{operational && input('Maximum Delivery Distance (km)', 'maxDistance', 'number', 'Within your store’s delivery area.')}</div>{mixer && <MobilizationFields prefix={prefix} vehicle={vehicle} issues={issues} onChange={change => update(vehicle.key, change)} />}<details open={!operational} className="mt-4 border-t border-border-default pt-3"><summary className="min-h-11 cursor-pointer py-3 text-sm font-semibold">Try the delivery rate calculator</summary><DeliveryRateCalculator baseFee={vehicle.baseFee} perKm={vehicle.perKm} mobilizationFee={mixer ? vehicle.mobilizationFee : ''} mobilizationBasis={mixer ? vehicle.mobilizationBasis : ''} /></details></section>
        </div>}
      </fieldset>
    })}</div>
  return <section ref={panel} aria-label="Delivery Configuration" className="mp-card mp-card-padded">
    <div className="flex flex-wrap items-start justify-between gap-4">
      <div><h3 data-vehicle-overview className="text-lg font-semibold">{operational ? 'Your vehicles' : 'Delivery Configuration'}</h3>{operational && <p className="mt-1 text-sm text-text-secondary">{visible.length} {visible.length === 1 ? 'configuration' : 'configurations'} · Capacity and rates per vehicle</p>}</div>
      {operational && visible.length > 0 && !(inlineEditor && selected) && <Button disabled={disabled} onClick={() => { const vehicle = emptyDeliveryVehicle(); onChange([...vehicles, vehicle]); edit(vehicle.key) }}><Plus size={18} aria-hidden="true" />Add vehicle</Button>}
    </div>
    <p className={operational ? 'sr-only' : 'mt-2 max-w-3xl text-sm leading-6 text-text-secondary'}>{operational ? 'Changes apply to future delivery proposals. Accepted orders keep their confirmed vehicle, rate and address.' : 'Configure the vehicles your store operates or legitimately controls. At least one eligible vehicle is required for Vendor Delivery before Store Activation.'}</p>
    <ConfirmDialog open={pendingRemoval !== null} title="Remove this vehicle?" confirmLabel="Remove vehicle" onCancel={() => setPendingRemoval(null)} onConfirm={() => { if (pendingRemoval) { update(pendingRemoval.key, { removed: true }); onImagePending?.(pendingRemoval.key, false) }; edit(null); setPendingRemoval(null) }}>
      <p>“{pendingRemoval?.name || 'This vehicle'}” will no longer be offered for future deliveries after you save. Accepted orders keep their confirmed vehicle. To stop using it for a while instead, turn off “Available now”.</p>
    </ConfirmDialog>
    {operational && !(inlineEditor && selected) && <div className="mt-4 divide-y divide-border-default border-t border-border-default">
      {visible.length === 0 && <EmptyState icon={<Truck size={24} aria-hidden="true" />} message="No vehicles yet." action={<Button variant="secondary" disabled={disabled} onClick={() => { const vehicle = emptyDeliveryVehicle(); onChange([...vehicles, vehicle]); edit(vehicle.key) }}>Add vehicle</Button>} />}
      {visible.map((vehicle, index) => <article key={vehicle.key} aria-label={vehicle.name || `Vehicle ${index + 1}`} className="grid min-w-0 gap-4 py-4 sm:grid-cols-[8rem_minmax(0,1fr)]">
        <VehicleThumbnail vehicle={vehicle} resolve={resolveImage} />
        <div className="min-w-0 space-y-3">
          <div className="flex flex-wrap items-start justify-between gap-3">
            <div className="min-w-0"><p className="break-words text-sm text-text-secondary">{vehicleCategories.find(category => category.value === vehicle.category)?.label || 'Category not set'}{vehicle.type && ` · ${vehicle.type === 'CUSTOM' ? vehicle.customType || 'Custom type' : vehicleTypes[vehicle.category]?.find(type => type.value === vehicle.type)?.label || (vehicle.type === 'MOTORCYCLE' ? 'Motorcycle' : vehicle.type)}`}</p><h4 className="mt-1 break-words text-lg font-semibold">{vehicle.name || 'New vehicle'}</h4><p className="mt-1 text-sm text-text-secondary">{!vehicle.id ? 'Not saved · ' : ''}{!vehicle.active ? 'Disabled for deliveries' : vehicle.available ? 'Enabled · Available now' : 'Enabled · Unavailable now'}</p></div>
            <div className="flex flex-wrap gap-2"><Button variant="secondary" disabled={disabled} aria-label={`Edit ${vehicle.name || `vehicle ${index + 1}`}`} onClick={() => edit(vehicle.key)}><Pencil size={16} aria-hidden="true" />Edit</Button><Button variant="quiet" disabled={disabled} aria-label={`Remove vehicle ${index + 1}`} onClick={() => remove(vehicle)}><Trash2 size={16} aria-hidden="true" />Remove</Button></div>
          </div>
          <dl className="grid grid-cols-2 gap-x-4 gap-y-2 xl:grid-cols-4">
            {([['Capacity per vehicle', vehicle.weight ? `${Number(vehicle.weight).toLocaleString('en-PH')} kg${vehicle.type === 'CONCRETE_MIXER' && vehicle.mixer ? ` · ${vehicle.mixer} m³` : ''}` : 'Not set'], ['Vehicles / max. distance', `${vehicle.count || '—'} / ${vehicle.maxDistance ? `${vehicle.maxDistance} km` : 'Not set'}`], ['Base fee per trip', amount(vehicle.baseFee)], ['Per-kilometer rate', amount(vehicle.perKm, '/km')], ...(vehicle.type === 'CONCRETE_MIXER' ? [['Mobilization fee', vehicle.mobilizationFee.trim() && Number(vehicle.mobilizationFee) > 0 ? amount(vehicle.mobilizationFee, vehicle.mobilizationBasis === 'PER_TRIP' ? ' per trip' : ' per truck') : 'None']] : [])]).map(([label, value]) => <div key={label} className="min-w-0"><dt className="text-sm text-text-secondary">{label}</dt><dd className="mt-0.5 break-words text-sm font-semibold">{value}</dd></div>)}
          </dl>
          {notices[vehicle.key]}
          {Object.keys(errors[vehicle.key] ?? {}).length > 0 && <p className="text-sm font-semibold text-status-error">Review this vehicle’s highlighted fields before saving.</p>}
        </div>
      </article>)}
    </div>}
    {operational ? selected && (inlineEditor ? <div className="mt-5 grid min-w-0 gap-4">{editorFeedback}{editor}{editorActions}</div> : <FormDialog initialFocus="title" open title={selected.id ? `Edit ${selected.name || 'vehicle'}` : 'Add vehicle'} description="Configure the vehicle, confirm capacity and access, then set delivery rates." busy={editorBusy} onClose={() => edit(null)} footer={<div className="flex flex-wrap items-center justify-between gap-3"><Button variant="secondary" disabled={editorBusy} onClick={() => edit(null)}>Back to vehicles</Button><div className="flex flex-wrap items-center gap-3">{editorActions}</div></div>}>
      {editorFeedback && <div className="mb-4 space-y-3">{editorFeedback}</div>}
      {editor}
    </FormDialog>) : editor}
    {!selectedKey && editorActions && <div className="mt-4 flex flex-wrap items-center gap-3 border-t border-border-default pt-4">{editorActions}</div>}
    {!operational && <Button className="mt-6" type="button" variant="secondary" disabled={disabled} onClick={() => onChange([...vehicles, emptyDeliveryVehicle()])}>Add delivery vehicle</Button>}
  </section>
}

export function emptyDeliveryVehicle(): DeliveryVehicleDraft {
  return { key: crypto.randomUUID(), category: '', type: '', customType: '', name: '', brand: '', count: '', weight: '', mixer: '', length: '', width: '', height: '', heavy: '', baseFee: '', perKm: '', mobilizationFee: '', mobilizationBasis: '', imageId: '', active: true, maxDistance: '', available: true, removed: false }
}

/** Listing quantities are a planning starting point, never proof of a truck's drum size or rated payload. */
function CapacityGuidance({ vehicle, sources, onChange }: { vehicle: DeliveryVehicleDraft; sources: VehicleCapacitySource[]; onChange: (change: Partial<DeliveryVehicleDraft>) => void }) {
  const source = sources.find(item => item.id === vehicle.capacitySourceId) ?? (sources.length === 1 ? sources[0] : undefined)
  const [manualDensity, setManualDensity] = useState('')
  const density = Number(source?.kgPerM3 || manualDensity)
  const volume = Number(vehicle.mixer)
  const payload = volume > 0 && Number.isFinite(volume) && density > 0 && Number.isFinite(density) ? Math.ceil(volume * density) : null
  const id = useId()
  const mixer = vehicle.type === 'CONCRETE_MIXER'
  return <div className="mt-3 grid gap-2 rounded-control border border-border-default bg-surface-canvas p-3 text-sm">
    <p className="font-semibold">{mixer ? 'Mixer capacity recommendation' : 'Confirm your vehicle’s capacity'}</p>
    {mixer ? <>
      {sources.length > 0 && <div className="grid gap-2"><label htmlFor={id} className="font-semibold">Ready-mix listing / strength</label><select id={id} className="min-h-11 w-full min-w-0 rounded-control border border-border-default bg-surface-primary px-3" value={source?.id ?? ''} onChange={event => onChange({ capacitySourceId: event.target.value })}><option value="">Choose a listing</option>{sources.map(item => <option key={item.id} value={item.id}>{item.label}</option>)}</select></div>}
      {source && <div className="flex flex-wrap items-center justify-between gap-2"><p className="min-w-0 flex-1 basis-64 text-text-secondary">Listing batch volume: {source.volumeM3 || 'not recorded'} m³. This is supply volume; confirm how much one truck can carry before saving.</p>{Number(source.volumeM3) > 0 && <Button variant="secondary" onClick={() => onChange({ mixer: source.volumeM3, capacitySourceId: source.id, capacityReviewRequired: true })}>Prefill mixer capacity</Button>}</div>}
      {!source?.kgPerM3 && <Field label="Concrete weight per m³ (kg)" name={`${id}-density`} type="number" min="0.0001" step="0.0001" value={manualDensity} onChange={event => setManualDensity(event.target.value)} hint="Enter the mix’s actual weight to calculate the suggested payload." />}
      {payload !== null && <div className="flex flex-wrap items-center justify-between gap-2"><div className="min-w-0 flex-1 basis-64"><p className="font-semibold">Suggested payload: {payload.toLocaleString('en-PH')} kg</p><p className="text-text-secondary">{vehicle.mixer} m³ × {density.toLocaleString('en-PH')} kg/m³{source?.kgPerM3 ? ' from the listing' : ''}. This is the load weight; verify the truck’s rated payload.</p>{Number(vehicle.weight) > 0 && Number(vehicle.weight) < payload && <p className="text-status-warning">At the entered payload, carry at most {Number((Number(vehicle.weight) / density).toFixed(3)).toLocaleString('en-PH')} m³ per trip.</p>}</div><Button variant="secondary" onClick={() => onChange({ weight: String(payload) })}>Use suggested payload</Button></div>}
      <p className="text-text-secondary">Recommended access classification: Heavy vehicle. Confirm it for your actual truck.</p>
      {vehicle.heavy !== 'HEAVY' && <Button className="w-fit" variant="secondary" onClick={() => onChange({ heavy: 'HEAVY' })}>Confirm heavy vehicle</Button>}
    </> : <p className="text-text-secondary">Enter the rated payload and measure the usable cargo area. Vehicle type alone cannot establish capacity.</p>}
    <p className="text-text-secondary">You can type the actual values directly. Check road restrictions, entry width, overhead clearance, turning and unloading space for each delivery.</p>
  </div>
}

export const mobilizationBases: Option[] = [
  { value: 'PER_TRUCK', label: 'Per truck', description: 'Charged once for each mixer truck dispatched to the order, however many trips it makes.' },
  { value: 'PER_TRIP', label: 'Per trip', description: 'Charged for every mixer trip, on top of the base fee and distance rate.' },
]

/** Mixer mobilization: each Vendor sets its own fee and chooses whether it is charged per truck or per trip. */
function MobilizationFields({ prefix, vehicle, issues, onChange }: { prefix: string; vehicle: DeliveryVehicleDraft; issues: Record<string, string>; onChange: (change: Partial<DeliveryVehicleDraft>) => void }) {
  return <div className="mt-6 grid min-w-0 grid-cols-1 gap-5 border-t border-border-default pt-5 md:grid-cols-2">
    <div className="grid gap-2 md:col-span-2">
      <h5 className="font-semibold">Mixer mobilization</h5>
      <p className="text-sm text-text-secondary">Optional dispatch/setup charge, added to base and distance fees. Leave blank or 0 for none; otherwise choose per truck or per trip. The Buyer sees it in the delivery fee before payment.</p>
    </div>
    <Field label="Mobilization Fee (₱)" name={`${prefix}-mobilizationFee`} value={vehicle.mobilizationFee} error={issues.mobilizationFee ?? ''} hint="For example 1500.00." onChange={event => onChange({ mobilizationFee: event.target.value })} />
    <Select id={`${prefix}-mobilizationBasis`} label="Charge mobilization" error={issues.mobilizationBasis} value={vehicle.mobilizationBasis} options={mobilizationBases} onChange={mobilizationBasis => onChange({ mobilizationBasis })} />
  </div>
}

function DeliveryRateCalculator({ baseFee, perKm, mobilizationFee = '', mobilizationBasis = '' }: { baseFee: string; perKm: string; mobilizationFee?: string; mobilizationBasis?: string }) {
  const [distance, setDistance] = useState('')
  const [trips, setTrips] = useState('1')
  const [trucks, setTrucks] = useState('1')
  const prefix = useId()
  const centavos = (value: string) => {
    if (!/^\d+(?:\.\d{1,2})?$/.test(value.trim())) return null
    const [whole, fraction = ''] = value.trim().split('.')
    const amount = Number(whole) * 100 + Number(fraction.padEnd(2, '0'))
    return Number.isSafeInteger(amount) && amount <= 1000000000 ? amount : null
  }
  const base = centavos(baseFee), rate = centavos(perKm)
  const validDistance = /^\d+(?:\.\d{1,3})?$/.test(distance) && Number(distance) <= 50
  const meters = Math.round(Number(distance) * 1000)
  const validTrips = /^\d+$/.test(trips) && Number(trips) > 0 && Number(trips) <= 1000000
  const perTrip = base !== null && rate !== null && validDistance ? base + Math.floor((rate * meters + 500) / 1000) : null
  const mobilization = mobilizationFee.trim() ? centavos(mobilizationFee) : 0
  const validTrucks = /^\d+$/.test(trucks) && Number(trucks) > 0 && Number(trucks) <= Number(trips)
  const mobilizationUnits = mobilizationBasis === 'PER_TRIP' ? Number(trips) : mobilizationBasis === 'PER_TRUCK' ? Number(trucks) : 0
  const mobilizationTotal = mobilization !== null && mobilization > 0 && mobilizationBasis ? mobilization * mobilizationUnits : 0
  const total = perTrip !== null && validTrips && (mobilizationBasis !== 'PER_TRUCK' || validTrucks) && mobilization !== null ? perTrip * Number(trips) + mobilizationTotal : null
  const money = (value: number) => new Intl.NumberFormat('en-PH', { style: 'currency', currency: 'PHP' }).format(value / 100)
  return <div className="mt-6 border-t border-border-default pt-5" onChange={event => event.stopPropagation()}>
    <h4 className="font-semibold">Delivery rate calculator</h4>
    <p className="mt-2 text-sm text-text-secondary">Try a distance and trip count to compare your rates. Estimate = (base fee + distance × per-kilometer rate) × total vehicle trips{mobilizationBasis ? `, plus the mobilization fee ${mobilizationBasis === 'PER_TRIP' ? 'per trip' : 'per truck dispatched'}` : ''}. This estimate does not set the final charge.</p>
    <div className="mt-4 grid gap-5 md:grid-cols-2">
      <Field name={`${prefix}-distance`} label="Sample delivery distance (km)" type="number" min="0" max="50" step="0.001" value={distance} onChange={event => setDistance(event.target.value)} hint="Distance per trip, from 0 to 50 km." error={distance && !validDistance ? 'Enter 0–50 km with up to three decimal places.' : ''} />
      <Field name={`${prefix}-trips`} label="Total vehicle trips" type="number" min="1" max="1000000" step="1" value={trips} onChange={event => setTrips(event.target.value)} hint="Two vehicles making two trips each means four vehicle trips." error={!validTrips ? 'Enter a positive whole number up to 1,000,000.' : ''} />
      {mobilizationBasis === 'PER_TRUCK' && <Field name={`${prefix}-trucks`} label="Trucks dispatched" type="number" min="1" step="1" value={trucks} onChange={event => setTrucks(event.target.value)} hint="Mobilization is charged once per truck." error={!validTrucks ? 'Enter a whole number from 1 up to the number of trips.' : ''} />}
    </div>
    <p className="mt-4 font-semibold" role="status">{total !== null && Number.isSafeInteger(total) ? `Estimated delivery charge: ${money(total)} (${money(perTrip!)} per vehicle trip${mobilizationTotal > 0 ? ` + ${money(mobilizationTotal)} mobilization` : ''})` : 'Enter valid rates, distance and trips to calculate an estimate.'}</p>
  </div>
}
