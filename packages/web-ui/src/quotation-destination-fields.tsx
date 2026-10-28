import { useEffect, useState } from 'react'
import { Check, MapPin, Navigation } from 'lucide-react'
import type { ChatQuotationDestination, QuotationLocation, QuotationLocationSearch } from '@materyalph/api-client-ts'
import { Button } from './button'
import { QuotationLocationDialog } from './quotation-location-dialog'
import type { LocationCoordinates } from './location-pin-map'
import { Select } from './filter-controls'

export function QuotationDestinationFields({ value, reference, disabled = false, onChange, search, readableError, mapBrowserKey, onPickerOpenChange }: {
  value: ChatQuotationDestination | undefined
  reference: unknown
  disabled?: boolean
  onChange: (value: ChatQuotationDestination) => void
  search: (selection: QuotationLocationSearch) => Promise<QuotationLocation>
  mapBrowserKey?: string | undefined
  onPickerOpenChange?: (open: boolean) => void
  readableError: (cause: unknown) => Promise<string>
}) {
  const record = (value: unknown): Record<string, unknown> => typeof value === 'object' && value !== null ? value as Record<string, unknown> : {}
  const source = record(reference)
  const destination = record(source.destination)
  const intended = record(destination.intended)
  const alternate = record(destination.alternate_drop_off)
  const locked = Boolean(source.work_package)
  const [picker, setPicker] = useState<'intended' | 'alternate' | null>(null)
  const [addresses, setAddresses] = useState<Record<string, string>>({})
  useEffect(() => { onPickerOpenChange?.(picker !== null); return () => onPickerOpenChange?.(false) }, [picker, onPickerOpenChange])
  const restriction = value?.heavyVehicleRestriction ?? String(destination.heavy_vehicle_restriction ?? 'UNANSWERED')
  const instructions = value?.accessInstructions ?? String(destination.access_instructions ?? '')
  const edit = (patch: Partial<ChatQuotationDestination>) => onChange({ ...value, ...patch })
  const address = (kind: 'intended' | 'alternate') => {
    const id = kind === 'intended' ? value?.intendedAddressId : value?.alternateAddressId
    const saved = kind === 'intended' ? intended : alternate
    return id ? addresses[id] ?? (kind === 'intended' ? value?.intendedAddress : value?.alternateAddress) ?? 'Selected delivery location' : typeof saved.formatted_address === 'string' ? saved.formatted_address : undefined
  }
  const savedPoint = picker === 'alternate' ? alternate : intended
  const latitude = Number(savedPoint.latitude)
  const longitude = Number(savedPoint.longitude)
  const initialPoint: LocationCoordinates | undefined = savedPoint.latitude != null && savedPoint.longitude != null && Number.isFinite(latitude) && Number.isFinite(longitude) ? { latitude, longitude } : undefined
  return <section aria-label="Delivery destination and access" className="grid min-w-0 gap-4 rounded-control border border-border-default bg-surface-canvas p-3 sm:p-4">
    <div className="border-b border-border-default pb-3"><h4 className="text-sm font-semibold">Delivery destination &amp; heavy vehicle access</h4><p className="mt-1 text-xs leading-relaxed text-text-secondary">Confirm the destination and restriction answer with the Buyer. The Buyer reviews these details before accepting.</p></div>
    {(['intended', ...(restriction === 'YES' ? ['alternate'] as const : [])] as const).map(kind => {
      const id = kind === 'intended' ? value?.intendedAddressId : value?.alternateAddressId
      const label = kind === 'intended' ? 'Delivery destination' : 'Alternative vehicle drop-off'
      const saved = kind === 'intended' ? intended : alternate
      const selectedAddress = address(kind)
      return <div className="grid gap-2" key={kind}>
        <p className="text-sm font-semibold">{label}</p>
        <div className="flex items-start gap-2 rounded-control bg-surface-primary p-3"><MapPin size={18} aria-hidden="true" className="mt-0.5 shrink-0 text-text-secondary" /><p role="status" className="min-w-0 break-words text-sm leading-relaxed">{selectedAddress ?? 'No location shared. Search for the address confirmed by the Buyer.'}</p></div>
        {!locked && <div className="flex flex-wrap gap-2">
          <Button className="w-full max-w-full sm:w-auto [&>svg]:shrink-0" variant={!id && selectedAddress ? 'outline' : 'secondary'} aria-pressed={!id && Boolean(selectedAddress)} disabled={disabled || typeof saved.formatted_address !== 'string'} onClick={() => edit(kind === 'intended' ? { intendedAddressId: null } : { alternateAddressId: null })}><Navigation size={17} aria-hidden="true" />{kind === 'intended' ? 'Current location' : 'Shared drop-off'}{!id && selectedAddress && <Check size={16} aria-hidden="true" />}</Button>
          <Button className="w-full max-w-full sm:w-auto [&>svg]:shrink-0" variant={id ? 'outline' : 'secondary'} aria-pressed={Boolean(id)} aria-haspopup="dialog" disabled={disabled} onClick={() => setPicker(kind)}><MapPin size={17} aria-hidden="true" />{kind === 'intended' ? 'Alternate Buyer Location' : 'Choose drop-off on map'}{id && <Check size={16} aria-hidden="true" />}</Button>
        </div>}
        {kind === 'intended' && !locked && <p className="text-xs text-text-secondary">Current location uses the address shared by the Buyer. Choose an alternate location to search or pin a different address.</p>}
      </div>
    })}
    <Select label="Does the Buyer know of a heavy-vehicle restriction?" value={restriction} disabled={disabled || locked} onChange={event => edit({ heavyVehicleRestriction: event.target.value as NonNullable<ChatQuotationDestination['heavyVehicleRestriction']> })}>
      <option value="UNANSWERED">Select the Buyer’s answer</option><option value="NO">No known restriction</option><option value="YES">Yes — use an alternative drop-off</option>
    </Select>
    <label className="grid gap-2 text-sm font-semibold">Access &amp; unloading instructions{restriction === 'YES' ? ' (required)' : ' (optional)'}<textarea className="min-h-20 w-full rounded-control border border-border-default bg-surface-primary px-3 py-2 font-normal" maxLength={500} disabled={disabled || locked} value={instructions} onChange={event => edit({ accessInstructions: event.target.value })} /></label>
    <p className="text-xs text-text-secondary">{restriction === 'YES' ? 'The alternative drop-off is used for road distance and the delivery fee. The intended site stays separate.' : 'No known restriction does not guarantee unrestricted access. Confirm vehicle access before publication.'}{locked ? ' Work Package delivery details are locked.' : ''}</p>
    {picker && <QuotationLocationDialog title={picker === 'intended' ? 'Alternate Buyer Location' : 'Alternative vehicle drop-off'} initialAddressId={picker === 'intended' ? value?.intendedAddressId : value?.alternateAddressId} initialLabel={address(picker)} initialPoint={initialPoint} browserKey={mapBrowserKey} resolve={search} readableError={readableError} onClose={() => setPicker(null)} onConfirm={location => {
      setAddresses(previous => ({ ...previous, [location.id]: location.formattedAddress }))
      edit(picker === 'intended' ? { intendedAddressId: location.id } : { alternateAddressId: location.id })
      setPicker(null)
    }} />}
  </section>
}
