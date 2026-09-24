import { useEffect, useRef, useState } from 'react'
import { Button, Field, SearchableCombobox, StatusMessage, type ComboboxOption } from '@materyalph/web-ui'
import { readableOnboardingError, resolveAddressPin, resolveAddressSelection, searchAddressAreas } from '../lib/onboarding-api'
import { VendorAddressMapSelector, type VendorAddressCoordinates } from './VendorAddressMapSelector'

type Address = Record<string, unknown>
function text(address: Address, camel: string, snake = camel): string { return String(address[camel] ?? address[snake] ?? '') }
export function VendorBusinessAddress({ initial, active, onDirty, restoreDraft = false }: { initial: Address; active: boolean; onDirty: () => void; restoreDraft?: boolean }) {
  const [province, setProvince] = useState<ComboboxOption | null>(() => text(initial, 'provinceCode', 'province_code') ? { code: text(initial, 'provinceCode', 'province_code'), name: text(initial, 'province') } : null)
  const [city, setCity] = useState<ComboboxOption | null>(() => text(initial, 'cityCode', 'city_code') ? { code: text(initial, 'cityCode', 'city_code'), name: text(initial, 'cityMunicipality', 'city_municipality') } : null)
  const [barangay, setBarangay] = useState<ComboboxOption | null>(() => text(initial, 'psgcCode', 'psgc_code') ? { code: text(initial, 'psgcCode', 'psgc_code'), name: text(initial, 'barangay') } : null)
  const [street, setStreet] = useState(text(initial, 'street'))
  const [unit, setUnit] = useState(text(initial, 'unit'))
  const [postalCode, setPostalCode] = useState(text(initial, 'postalCode', 'postal_code'))
  const [mode, setMode] = useState<'MANUAL' | 'MAP'>(text(initial, 'source') === 'MAP' ? 'MAP' : 'MANUAL')
  const [pinToken, setPinToken] = useState<string | null>(null)
  const [pinLocation, setPinLocation] = useState<Address | null>(null)
  const [pinBusy, setPinBusy] = useState(false)
  const [pinMessage, setPinMessage] = useState('')
  const [changed, setChanged] = useState(restoreDraft)
  const [resolution, setResolution] = useState<{ address: Address; token: string; key: string } | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [retry, setRetry] = useState(0)
  const sequence = useRef(0)
  const key = JSON.stringify([province?.code, city?.code, barangay?.code, street, unit, postalCode, pinToken])
  function edit(keepPin = false) { sequence.current++; setPinBusy(false); setChanged(true); setResolution(null); setError(''); if (!keepPin) { setPinToken(null); setPinLocation(null); setPinMessage('') } onDirty() }
  async function selectPin(coordinates: VendorAddressCoordinates) {
    setMode('MAP'); edit(); setProvince(null); setCity(null); setBarangay(null); setPinBusy(true); setPinLocation(coordinates); const current = ++sequence.current
    try {
      const result = await resolveAddressPin(coordinates)
      if (sequence.current !== current) return
      const address = result.address
      if (!address || typeof address !== 'object') throw new Error('Invalid map response')
      const resolved = address as Address
      setProvince(text(resolved, 'province_code') ? { code: text(resolved, 'province_code'), name: text(resolved, 'province') } : null)
      setCity(text(resolved, 'city_code') ? { code: text(resolved, 'city_code'), name: text(resolved, 'city_municipality') } : null)
      setBarangay(text(resolved, 'psgc_code') ? { code: text(resolved, 'psgc_code'), name: text(resolved, 'barangay') } : null)
      setStreet(text(resolved, 'street')); setUnit(text(resolved, 'unit')); setPostalCode(text(resolved, 'postal_code'))
      setPinToken(typeof result.pin_token === 'string' ? result.pin_token : null); setPinLocation(resolved); setPinMessage(String(result.message ?? 'Review the address resolved from your pin.'))
    } catch (cause) { const message = await readableOnboardingError(cause); if (sequence.current === current) setError(message) }
    finally { if (sequence.current === current) setPinBusy(false) }
  }
  useEffect(() => {
    if (mode === 'MANUAL' || pinBusy || !active || !changed || !province || !city || !barangay) { setBusy(false); return }
    let disposed = false
    const current = ++sequence.current
    setBusy(true); setError('')
    const timer = window.setTimeout(() => {
      void resolveAddressSelection({ provinceCode: province.code, cityCode: city.code, psgcCode: barangay.code, street, unit, postalCode, ...(pinToken ? { pinToken } : {}) }).then(result => {
        if (disposed || sequence.current !== current) return
        const address = result.address
        const token = result.resolution_token
        if (!address || typeof address !== 'object' || typeof token !== 'string') throw new Error('Invalid address response')
        setResolution({ address: address as Address, token, key }); setBusy(false)
      }).catch(async cause => { const message = await readableOnboardingError(cause); if (!disposed && sequence.current === current) { setError(message); setBusy(false); setResolution(null) } })
    }, 650)
    return () => { disposed = true; window.clearTimeout(timer) }
  }, [mode, key, active, changed, retry, province, city, barangay, street, unit, postalCode, pinToken, pinBusy])
  const current = resolution?.key === key ? resolution : null
  const shown = current?.address ?? pinLocation ?? (!changed ? initial : {})
  const payload = changed ? { street, unit, postal_code: postalCode, province: province?.name ?? '', city_municipality: city?.name ?? '', barangay: barangay?.name ?? '', province_code: province?.code ?? '', city_code: city?.code ?? '', psgc_code: barangay?.code ?? '', source: mode, ...(mode === 'MAP' ? { resolution_token: current?.token ?? '' } : {}) } : null
  return <div className="grid min-w-0 gap-5">
    {!province && !changed && text(initial, 'street') && <StatusMessage tone="info">Saved address: {[text(initial, 'street'), text(initial, 'barangay'), text(initial, 'cityMunicipality', 'city_municipality'), text(initial, 'province')].filter(Boolean).join(', ')}. It is retained until you edit. Select the matching official locations when updating it.</StatusMessage>}
    <input type="hidden" name="address_payload" value={payload ? JSON.stringify(payload) : ''} />
    <fieldset className="flex flex-wrap gap-4"><legend className="mb-2 font-semibold">Address entry method</legend>{(['MANUAL', 'MAP'] as const).map(value => <label key={value} className="flex min-h-11 items-center gap-2"><input type="radio" name="address_entry_method" value={value} checked={mode === value} onChange={() => { edit(); setMode(value) }} />{value === 'MANUAL' ? 'Manual Address Entry' : 'Interactive Map Selection'}</label>)}</fieldset>
    <div className="grid min-w-0 items-start gap-6">
    <div className="grid min-w-0 items-start gap-5 sm:grid-cols-2">
      <SearchableCombobox label="Province / Region" value={province} load={(q, page) => searchAddressAreas('PROVINCE', undefined, q, page)} onChange={value => { edit(!province); setProvince(value); setCity(null); setBarangay(null) }} />
      <SearchableCombobox key={`city-${province?.code ?? ''}`} label="City / Municipality" value={city} disabled={!province} load={(q, page) => searchAddressAreas('CITY', province?.code, q, page)} onChange={value => { edit(!city); setCity(value); setBarangay(null) }} />
      <SearchableCombobox key={`barangay-${city?.code ?? ''}`} label="Barangay" value={barangay} disabled={!city} load={(q, page) => searchAddressAreas('BARANGAY', city?.code, q, page)} onChange={value => { edit(!barangay); setBarangay(value) }} />
      <Field label="Postal code" name="postal_code" value={postalCode} required inputMode="numeric" pattern="[0-9]{4}" maxLength={4} onChange={event => { edit(!postalCode); setPostalCode(event.target.value) }} />
      <Field label="Detailed Address" name="street" value={street} required minLength={2} maxLength={200} placeholder="House/Building No., Street, Subdivision, Compound" onChange={event => { edit(!street); setStreet(event.target.value) }} />
      <Field label="Unit or building" name="unit" value={unit} maxLength={120} onChange={event => { edit(!unit); setUnit(event.target.value) }} />
    </div>
    <div className="min-w-0 space-y-4">
    {active && <VendorAddressMapSelector onCoordinatesChange={coordinates => { void selectPin(coordinates) }} latitude={typeof shown.latitude === 'number' ? shown.latitude : undefined} longitude={typeof shown.longitude === 'number' ? shown.longitude : undefined} />}
    {mode === 'MANUAL' && <p role="status" className="text-sm text-text-secondary">Manual entry is sufficient for submission. Review the structured address; coordinates remain unavailable until a map location is resolved.</p>}
    </div></div>
    {pinBusy && <p role="status">Finding the address at your pin…</p>}
    {pinMessage && <p role="status">{pinMessage}</p>}
    {busy && <p role="status">Locating your selected address…</p>}
    {error && <StatusMessage tone="error">{error}<Button variant="quiet" onClick={() => { edit(); setMode('MANUAL') }}>Continue with manual address</Button><Button variant="secondary" onClick={() => { if (pinLocation && !pinToken && typeof pinLocation.latitude === 'number' && typeof pinLocation.longitude === 'number') { void selectPin({ latitude: pinLocation.latitude, longitude: pinLocation.longitude }) } else { setRetry(value => value + 1) } }}>Retry address lookup</Button></StatusMessage>}
    {changed && (!province || !city || !barangay) && <p role="status">Select a province or region, city/municipality, and barangay from the official suggestions.</p>}
    {current && <div><p role="status">Location resolved. Review your address before saving.</p><Button variant="quiet" onClick={() => { edit(); setRetry(value => value + 1) }}>Refresh address location</Button></div>}
    <p className="text-sm text-text-secondary">For an independent city or NCR, select its region where no province applies. Add the detailed address to refine the resolved map location.</p>
  </div>
}
