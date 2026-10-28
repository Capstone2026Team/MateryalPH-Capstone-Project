import { useCallback, useEffect, useRef, useState } from 'react'
import { MapPin, Search } from 'lucide-react'
import type { QuotationLocation, QuotationLocationSearch } from '@materyalph/api-client-ts'
import { Button } from './button'
import { Field } from './field'
import { FormDialog } from './form-dialog'
import { LocationPinMap, type LocationCoordinates } from './location-pin-map'
import { StatusMessage } from './status-message'

export function QuotationLocationDialog({ title, initialAddressId, initialLabel = '', initialPoint, browserKey, resolve, readableError, onConfirm, onClose }: {
  title: string
  initialAddressId?: string | null | undefined
  initialLabel?: string | undefined
  initialPoint?: LocationCoordinates | undefined
  browserKey?: string | undefined
  resolve: (selection: QuotationLocationSearch) => Promise<QuotationLocation>
  readableError: (cause: unknown) => Promise<string>
  onConfirm: (location: QuotationLocation) => void
  onClose: () => void
}) {
  const [query, setQuery] = useState(initialLabel)
  const [point, setPoint] = useState<LocationCoordinates | undefined>(initialPoint)
  const [selected, setSelected] = useState<QuotationLocation | null>(null)
  const [loading, setLoading] = useState(false)
  const [error, setError] = useState<string | null>(null)
  const sequence = useRef(0)
  const callbacks = useRef({ resolve, readableError })
  callbacks.current = { resolve, readableError }
  const locate = useCallback(async (selection: QuotationLocationSearch) => {
    const request = ++sequence.current
    setSelected(null); setLoading(true); setError(null)
    if (selection.latitude !== undefined && selection.longitude !== undefined) setPoint({ latitude: selection.latitude, longitude: selection.longitude })
    try {
      const result = await callbacks.current.resolve(selection)
      if (request !== sequence.current) return
      setSelected(result); setPoint({ latitude: result.latitude, longitude: result.longitude }); setQuery(result.formattedAddress)
    } catch (cause) {
      const message = await callbacks.current.readableError(cause)
      if (request === sequence.current) setError(message)
    } finally { if (request === sequence.current) setLoading(false) }
  }, [])
  useEffect(() => {
    if (initialAddressId) void locate({ addressId: initialAddressId })
    return () => { sequence.current++ }
  }, [initialAddressId, locate])
  const close = () => { sequence.current++; onClose() }
  return <FormDialog open title={title} description="Search the Buyer’s address or move the pin, then confirm the delivery point." onClose={close} size="compact" footer={<div className="flex flex-col-reverse gap-2 sm:flex-row sm:justify-end"><Button variant="quiet" onClick={close}>Cancel</Button><Button disabled={loading || !selected} onClick={() => { if (selected) onConfirm(selected) }}>Use this location</Button></div>}>
    <div className="grid gap-4">
      <div className="grid items-end gap-2 sm:grid-cols-[minmax(0,1fr)_auto]">
        <Field label="Search Buyer location" value={query} maxLength={300} placeholder="Street, landmark, barangay or city" onChange={event => { sequence.current++; setLoading(false); setSelected(null); setError(null); setQuery(event.target.value) }} onKeyDown={event => { if (event.key === 'Enter') { event.preventDefault(); if (query.trim().length >= 5 && !loading) void locate({ query: query.trim() }) } }} />
        <Button variant="secondary" disabled={loading || query.trim().length < 5} onClick={() => void locate({ query: query.trim() })}><Search size={17} aria-hidden="true" />Search address</Button>
      </div>
      {error && <StatusMessage tone="error">{error} Search again or choose another map pin.</StatusMessage>}
      <LocationPinMap browserKey={browserKey} latitude={point?.latitude} longitude={point?.longitude} label="Buyer delivery location map" instructions="Click the map or drag the pin. Address search above is also available without using the map." className="h-64 sm:h-80" onCoordinatesChange={coordinates => { void locate(coordinates) }} />
      <div aria-live="polite" className="flex min-w-0 items-start gap-3 rounded-control border border-border-default bg-surface-canvas p-3">
        <MapPin size={18} className="mt-0.5 shrink-0 text-action-primary" aria-hidden="true" />
        <div className="min-w-0"><p className="text-sm font-semibold">Selected location</p><p className="mt-1 break-words text-sm text-text-secondary">{loading ? 'Finding the address…' : selected?.formattedAddress ?? 'Search an address or choose a pin to continue.'}</p></div>
      </div>
      <p className="text-xs text-text-secondary">Address lookup by Google Maps. Confirm the delivery point with the Buyer before using it.</p>
    </div>
  </FormDialog>
}
