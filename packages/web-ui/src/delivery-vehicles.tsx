import { useEffect, useId, useRef, useState } from 'react'
import { Button } from './button'
import { Field } from './field'
import { ImagePlus, Upload, Trash2 } from 'lucide-react'

export type DeliveryVehicleDraft = {
  key: string; id?: string; category: string; type: string; customType: string; name: string; brand: string;
  count: string; weight: string; mixer: string; length: string; width: string; height: string; heavy: string;
  baseFee: string; perKm: string; imageId: string; active: boolean
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
    try { onChange(await upload(selected)); setFile(null); onPending(false) } catch (cause) { setError(cause instanceof Error ? cause.message : 'Upload failed. Try again.') } finally { setBusy(false) }
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

export function DeliveryVehicles({ vehicles, onChange, uploadImage, resolveImage, onImagePending, errors = {} }: {
  onImagePending?: (key: string, pending: boolean) => void;
  errors?: Record<string, Record<string, string>>;
  vehicles: DeliveryVehicleDraft[]; onChange: (vehicles: DeliveryVehicleDraft[]) => void;
  uploadImage: (file: File) => Promise<string>; resolveImage: (id: string) => Promise<string>; coverageKm: number
}) {
  const currentVehicles = useRef(vehicles)
  currentVehicles.current = vehicles
  function update(key: string, change: Partial<DeliveryVehicleDraft>) { onChange(currentVehicles.current.map(vehicle => vehicle.key === key ? { ...vehicle, ...change } : vehicle)) }
  return <section aria-label="Delivery Configuration" className="rounded-surface border border-border-default bg-surface-primary p-5 sm:p-7">
    <h3 className="text-xl font-semibold">Delivery Configuration</h3>
    <p className="mt-2 max-w-3xl text-sm leading-6 text-text-secondary">Configure the vehicles your store operates or legitimately controls. At least one eligible vehicle is required for Vendor Delivery before Store Activation.</p>
    <div className="mt-6 grid min-w-0 grid-cols-1 gap-8">{vehicles.filter(vehicle => vehicle.active).map((vehicle, index) => {
      const issues = errors[vehicle.key] ?? {}
      const prefix = `vehicle-${vehicle.key}`
      const mixer = vehicle.type === 'CONCRETE_MIXER'
      const detail = vehicle.category && vehicle.type
      const input = (label: string, field: keyof DeliveryVehicleDraft, type = 'text', hint?: string) => <Field label={label} error={issues[field] ?? ''} name={`${prefix}-${field}`} value={String(vehicle[field] ?? '')} onChange={event => update(vehicle.key, { [field]: event.target.value })} type={type} {...(type === 'number' ? { min: field === 'count' ? '1' : '0.0001', step: field === 'count' ? '1' : '0.0001' } : {})} hint={hint} />
      return <fieldset key={vehicle.key} className="min-w-0 border-t border-border-default pt-6"><legend className="sr-only">Vehicle {index + 1}{vehicle.name ? ` — ${vehicle.name}` : ''}</legend>
        <div className="mb-6 flex items-start justify-between gap-3"><h3 className="min-w-0 break-words pt-2 text-lg font-semibold">Vehicle {index + 1}{vehicle.name ? ` — ${vehicle.name}` : ''}</h3><Button className="shrink-0 text-sm" type="button" variant="quiet" aria-label={`Remove vehicle ${index + 1}`} onClick={() => onChange(vehicle.id ? currentVehicles.current.map(row => row.key === vehicle.key ? { ...row, active: false } : row) : currentVehicles.current.filter(row => row.key !== vehicle.key))}><Trash2 size={16} aria-hidden="true" />Remove</Button></div>
        <div className="grid min-w-0 grid-cols-1 items-start gap-6 md:grid-cols-2 md:gap-8">
          <div className="grid min-w-0 grid-cols-1 gap-5">
            <Select id={`${prefix}-category`} label="Vehicle Category" error={issues.category} value={vehicle.category} options={vehicleCategories} onChange={category => update(vehicle.key, { category, type: category === 'MOTORCYCLE' ? 'MOTORCYCLE' : '', customType: '', mixer: '' })} />
            {vehicle.category && vehicle.category !== 'MOTORCYCLE' && <Select id={`${prefix}-type`} label="Vehicle Type" error={issues.type} value={vehicle.type} options={[...(vehicleTypes[vehicle.category] ?? []), customType]} onChange={type => update(vehicle.key, { type })} />}
            {detail && <>{vehicle.type === 'CUSTOM' && input('Custom Vehicle Type', 'customType')}{input('Vehicle Name', 'name')}{input('Vehicle Brand', 'brand', 'text', 'Brand or manufacturer, where applicable.')}</>}
          </div>
          {detail && <div className="min-w-0">{issues.imageId && <p role="alert" className="mb-3 text-sm text-status-error">{issues.imageId}</p>}<VehicleImage onPending={pending => onImagePending?.(vehicle.key, pending)} vehicle={vehicle} upload={uploadImage} resolve={resolveImage} onChange={imageId => update(vehicle.key, { imageId })} /></div>}
        </div>
        {detail && <div className="mt-8 grid min-w-0 grid-cols-1 gap-6">
          <div className="border-t border-border-default pt-5"><h4 className="font-semibold">Capacity and access</h4><div className="mt-4 grid min-w-0 grid-cols-1 gap-5 md:grid-cols-2">{input('Number of Vehicles', 'count', 'number')}{input('Maximum Weight Capacity (kg)', 'weight', 'number')}{mixer ? input('Mixer Capacity (m³)', 'mixer', 'number', 'Ready-mixed concrete volume per vehicle per trip.') : <>{input('Cargo Length (m)', 'length', 'number')}{input('Cargo Width (m)', 'width', 'number')}{input('Cargo Height (m)', 'height', 'number')}</>}
          <Select id={`${prefix}-heavy`} label="Heavy Vehicle Classification" error={issues.heavy} value={vehicle.heavy} options={[{ value: 'HEAVY', label: 'Heavy vehicle', description: 'Subject to applicable heavy-vehicle or site-access restrictions.' }, { value: 'NOT_HEAVY', label: 'Not a heavy vehicle', description: 'Normal road and site-access checks still apply.' }]} onChange={heavy => update(vehicle.key, { heavy })} /></div>{mixer && <p className="mt-3 text-sm text-text-secondary">Cargo dimensions: Not applicable. Mixer capacity is used for ready-mixed concrete delivery.</p>}</div>
          <section aria-label={`Vehicle ${index + 1} delivery rates`} className="min-w-0 rounded-surface border border-border-default bg-surface-canvas p-4 sm:p-6"><h4 className="text-lg font-semibold">Delivery rates</h4><p className="mt-2 text-sm leading-6 text-text-secondary">Enter amounts in Philippine pesos. The final delivery charge requires Vendor confirmation of vehicles, trips and the delivery arrangement.</p><div className="mt-4 grid min-w-0 grid-cols-1 gap-5 md:grid-cols-2">{input('Base Fee (₱)', 'baseFee', 'text', 'Fixed delivery amount per applicable trip, e.g. 500.00.')}{input('Per-Kilometer Rate (₱/km)', 'perKm', 'text', 'Distance-based amount, e.g. 25.50.')}</div><DeliveryRateCalculator baseFee={vehicle.baseFee} perKm={vehicle.perKm} /></section>
        </div>}
      </fieldset>
    })}</div>
    <Button className="mt-6" type="button" variant="secondary" onClick={() => onChange([...vehicles, emptyDeliveryVehicle()])}>Add delivery vehicle</Button>
  </section>
}

export function emptyDeliveryVehicle(): DeliveryVehicleDraft {
  return { key: crypto.randomUUID(), category: '', type: '', customType: '', name: '', brand: '', count: '', weight: '', mixer: '', length: '', width: '', height: '', heavy: '', baseFee: '', perKm: '', imageId: '', active: true }
}

function DeliveryRateCalculator({ baseFee, perKm }: { baseFee: string; perKm: string }) {
  const [distance, setDistance] = useState('')
  const [trips, setTrips] = useState('1')
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
  const total = perTrip !== null && validTrips ? perTrip * Number(trips) : null
  const money = (value: number) => new Intl.NumberFormat('en-PH', { style: 'currency', currency: 'PHP' }).format(value / 100)
  return <div className="mt-6 border-t border-border-default pt-5" onChange={event => event.stopPropagation()}>
    <h4 className="font-semibold">Delivery rate calculator</h4>
    <p className="mt-2 text-sm text-text-secondary">Try a distance and trip count to compare your rates. Estimate = (base fee + distance × per-kilometer rate) × total vehicle trips. This estimate does not set the final charge.</p>
    <div className="mt-4 grid gap-5 md:grid-cols-2">
      <Field name={`${prefix}-distance`} label="Sample delivery distance (km)" type="number" min="0" max="50" step="0.001" value={distance} onChange={event => setDistance(event.target.value)} hint="Distance per trip, from 0 to 50 km." error={distance && !validDistance ? 'Enter 0–50 km with up to three decimal places.' : ''} />
      <Field name={`${prefix}-trips`} label="Total vehicle trips" type="number" min="1" max="1000000" step="1" value={trips} onChange={event => setTrips(event.target.value)} hint="Two vehicles making two trips each means four vehicle trips." error={!validTrips ? 'Enter a positive whole number up to 1,000,000.' : ''} />
    </div>
    <p className="mt-4 font-semibold" role="status">{total !== null && Number.isSafeInteger(total) ? `Estimated delivery charge: ${money(total)} (${money(perTrip!)} per vehicle trip)` : 'Enter valid rates, distance and trips to calculate an estimate.'}</p>
  </div>
}
