import { useEffect, useRef, useState } from 'react'
import { Button, Field, StatusMessage } from '@materyalph/web-ui'
import { readableOnboardingError, resolveAddressPin, resolveAddressSelection } from '../lib/onboarding-api'
import { VendorAddressMapSelector, type VendorAddressCoordinates } from './VendorAddressMapSelector'

type Address = Record<string, unknown>
type Details = { street: string; unit: string; barangay: string; city_municipality: string; province: string; postal_code: string }
function text(address: Address, camel: string, snake = camel): string { return String(address[camel] ?? address[snake] ?? '') }
function details(address: Address): Details {
  return { street: text(address, 'street'), unit: text(address, 'unit'), barangay: text(address, 'barangay'), city_municipality: text(address, 'cityMunicipality', 'city_municipality'), province: text(address, 'province'), postal_code: text(address, 'postalCode', 'postal_code') }
}

export function VendorBusinessAddress({ initial, active, onDirty, restoreDraft = false }: { initial: Address; active: boolean; onDirty: () => void; restoreDraft?: boolean }) {
  const [fields, setFields] = useState(() => details(initial))
  const [mode, setMode] = useState<'MANUAL' | 'MAP'>(() => text(initial, 'source') === 'MANUAL' || (!text(initial, 'source') && text(initial, 'street')) ? 'MANUAL' : 'MAP')
  const [pinToken, setPinToken] = useState<string | null>(null)
  const [location, setLocation] = useState<Address>(initial)
  const [lookupBusy, setLookupBusy] = useState(false)
  const [changed, setChanged] = useState(restoreDraft)
  const [resolution, setResolution] = useState<{ token: string; key: string } | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [retry, setRetry] = useState(0)
  const sequence = useRef(0)
  const notifyDirty = useRef(onDirty)
  notifyDirty.current = onDirty
  const pinFields = useRef<Details | null>(null)
  const failedLookup = useRef<VendorAddressCoordinates | null>(null)
  const key = JSON.stringify([fields, pinToken, mode])
  const complete = fields.street.trim().length >= 2 && fields.province.trim() && fields.city_municipality.trim() && fields.barangay.trim() && /^[0-9]{4}$/.test(fields.postal_code)

  function edit(keepPin = false) {
    sequence.current++; setLookupBusy(false); setBusy(false); setChanged(true); setResolution(null); setError(''); failedLookup.current = null
    if (!keepPin) { setPinToken(null); setLocation({}); pinFields.current = null }
    onDirty()
  }

  async function locate(selection: VendorAddressCoordinates) {
    edit(); setMode('MAP'); setLookupBusy(true); failedLookup.current = selection
    const current = ++sequence.current
    try {
      const result = await resolveAddressPin(selection)
      if (sequence.current !== current) return
      if (!result.address || typeof result.address !== 'object' || typeof result.pin_token !== 'string') throw new Error('Invalid map response')
      const address = result.address as Address
      pinFields.current = details(address)
      setFields(pinFields.current); setLocation(address); setPinToken(result.pin_token); failedLookup.current = null; onDirty()
    } catch (cause) {
      const message = await readableOnboardingError(cause)
      if (sequence.current === current) setError(message)
    } finally { if (sequence.current === current) setLookupBusy(false) }
  }

  useEffect(() => {
    if (mode === 'MANUAL' || lookupBusy || error || !active || !changed || !complete) { setBusy(false); return }
    let disposed = false
    const current = ++sequence.current
    setBusy(true)
    const timer = window.setTimeout(() => {
      void resolveAddressSelection({ province: fields.province, cityMunicipality: fields.city_municipality, barangay: fields.barangay, street: fields.street, unit: fields.unit, postalCode: fields.postal_code, ...(pinToken ? { pinToken } : {}) }).then(result => {
        if (disposed || sequence.current !== current) return
        if (!result.address || typeof result.address !== 'object' || typeof result.resolution_token !== 'string') throw new Error('Invalid address response')
        setResolution({ token: result.resolution_token, key }); setLocation(result.address as Address); setBusy(false); notifyDirty.current()
      }).catch(async cause => {
        const message = await readableOnboardingError(cause)
        if (!disposed && sequence.current === current) { setError(message); setBusy(false); setResolution(null) }
      })
    }, 650)
    return () => { disposed = true; window.clearTimeout(timer) }
  }, [mode, key, active, changed, retry, fields, pinToken, lookupBusy, complete, error])

  const current = resolution?.key === key ? resolution : null
  const payload = changed ? { ...fields, source: mode, ...(mode === 'MAP' ? { resolution_token: current?.token ?? '' } : {}) } : null
  function update(field: keyof Details, value: string) { edit(field === 'unit' || Boolean(pinFields.current && !pinFields.current[field])); setFields(previous => ({ ...previous, [field]: value })) }
  function retryLookup() {
    if (failedLookup.current !== null) { void locate(failedLookup.current); return }
    setError(''); setRetry(value => value + 1)
  }

  return <div className="grid min-w-0 gap-6">
    <input type="hidden" name="address_payload" value={payload ? JSON.stringify(payload) : ''} />
    <fieldset className="flex flex-wrap gap-x-6 gap-y-2">
      <legend className="mb-2 font-semibold">How would you like to enter your address?</legend>
      {(['MAP', 'MANUAL'] as const).map(value => <label key={value} className="flex min-h-11 items-center gap-2"><input type="radio" name="address_entry_method" value={value} checked={mode === value} onChange={() => { edit(); setMode(value) }} />{value === 'MAP' ? 'Use Google Maps' : 'Enter address manually'}</label>)}
    </fieldset>
    {mode === 'MAP' && <div className="grid min-w-0 gap-4">
      {active && <VendorAddressMapSelector onCoordinatesChange={coordinates => { void locate(coordinates) }} latitude={typeof location.latitude === 'number' ? location.latitude : undefined} longitude={typeof location.longitude === 'number' ? location.longitude : undefined} />}
    </div>}
    {(lookupBusy || busy) && <p role="status" className="text-sm text-text-secondary">{lookupBusy ? 'Finding your address…' : 'Confirming your map location…'}</p>}
    {error && <StatusMessage tone="error"><p>{error}</p><div className="mt-3 flex flex-wrap gap-3"><Button variant="secondary" onClick={retryLookup}>Retry address lookup</Button><Button variant="quiet" onClick={() => { edit(); setMode('MANUAL') }}>Enter address manually</Button></div></StatusMessage>}
    <div className="grid gap-4">
      <div><h3 className="font-semibold">Address details</h3><p className="mt-1 text-sm text-text-secondary">{mode === 'MAP' ? 'Review the address filled from the map. You can edit it and add any missing details.' : 'Enter the address shown on your business documents.'}</p></div>
      <Field label="Street address" name="street" value={fields.street} required minLength={2} maxLength={200} placeholder="House or building number, street, subdivision" onChange={event => update('street', event.target.value)} />
      <Field label="Unit, floor or building (optional)" name="unit" value={fields.unit} maxLength={120} onChange={event => update('unit', event.target.value)} />
      <div className="grid items-start gap-4 sm:grid-cols-2">
        <Field label="Barangay" name="barangay" value={fields.barangay} required maxLength={120} onChange={event => update('barangay', event.target.value)} />
        <Field label="City / Municipality" name="city_municipality" value={fields.city_municipality} required maxLength={120} onChange={event => update('city_municipality', event.target.value)} />
        <Field label="Province / Metro Manila" name="province" value={fields.province} required maxLength={120} placeholder="For NCR, enter Metro Manila" onChange={event => update('province', event.target.value)} />
        <Field label="Postal code" name="postal_code" value={fields.postal_code} required inputMode="numeric" pattern="[0-9]{4}" maxLength={4} onChange={event => update('postal_code', event.target.value)} />
      </div>
    </div>
    {mode === 'MANUAL' && <p className="text-sm text-text-secondary">You can save this address without using the map.</p>}
    {current && <p role="status" className="text-sm text-text-secondary">Map location confirmed. Review the address details before continuing.</p>}
  </div>
}
