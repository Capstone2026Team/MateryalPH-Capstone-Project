import { useRef, useState } from 'react'
import type { ChatQuotationDestination, QuotationLocation } from '@materyalph/api-client-ts'
import { Button } from './button'
import { Field } from './field'
import { Select } from './filter-controls'
import { StatusMessage } from './status-message'

export function QuotationDestinationFields({ value, reference, disabled = false, onChange, search, readableError }: {
  value: ChatQuotationDestination | undefined
  reference: unknown
  disabled?: boolean
  onChange: (value: ChatQuotationDestination) => void
  search: (query: string) => Promise<QuotationLocation>
  readableError: (cause: unknown) => Promise<string>
}) {
  const record = (value: unknown): Record<string, unknown> => typeof value === 'object' && value !== null ? value as Record<string, unknown> : {}
  const source = record(reference)
  const destination = record(source.destination)
  const intended = record(destination.intended)
  const alternate = record(destination.alternate_drop_off)
  const locked = Boolean(source.work_package)
  const [queries, setQueries] = useState({ intended: '', alternate: '' })
  const [addresses, setAddresses] = useState<Record<string, string>>({})
  const [searching, setSearching] = useState<string | null>(null)
  const [error, setError] = useState<string | null>(null)
  const sequence = useRef(0)
  const currentValue = useRef(value)
  currentValue.current = value
  const restriction = value?.heavyVehicleRestriction ?? String(destination.heavy_vehicle_restriction ?? 'UNANSWERED')
  const instructions = value?.accessInstructions ?? String(destination.access_instructions ?? '')
  const edit = (patch: Partial<ChatQuotationDestination>) => onChange({ ...value, ...patch })
  async function find(kind: 'intended' | 'alternate') {
    const request = ++sequence.current
    setSearching(kind); setError(null)
    try {
      const result = await search(queries[kind].trim())
      if (sequence.current !== request) return
      setAddresses(previous => ({ ...previous, [result.id]: result.formattedAddress }))
      onChange({ ...currentValue.current, ...(kind === 'intended' ? { intendedAddressId: result.id } : { alternateAddressId: result.id }) })
    } catch (cause) { const message = await readableError(cause); if (sequence.current === request) setError(message) }
    finally { if (sequence.current === request) setSearching(null) }
  }
  return <section aria-label="Delivery destination and access" className="grid gap-4">
    <div><h4 className="text-sm font-semibold">Delivery destination &amp; heavy vehicle access</h4><p className="mt-1 text-xs text-text-secondary">Confirm the destination and restriction answer with the Buyer. The Buyer reviews these details before accepting.</p></div>
    {error && <StatusMessage tone="error">{error} Edit the address and search again.</StatusMessage>}
    {(['intended', ...(restriction === 'YES' ? ['alternate'] as const : [])] as const).map(kind => {
      const id = kind === 'intended' ? value?.intendedAddressId : value?.alternateAddressId
      const label = kind === 'intended' ? 'Delivery destination' : 'Alternative vehicle drop-off'
      const saved = kind === 'intended' ? intended : alternate
      const selectedAddress = id ? addresses[id] ?? (kind === 'intended' ? value?.intendedAddress : value?.alternateAddress) ?? 'Searched address selected' : typeof saved.formatted_address === 'string' ? saved.formatted_address : null
      return <div className="grid gap-2" key={kind}>
        <p className="text-sm font-semibold">{label}</p>
        <p role="status" className="break-words text-sm text-text-secondary">{selectedAddress ?? 'No location shared. Search for the address confirmed by the Buyer.'}</p>
        {!locked && <>
          {typeof saved.formatted_address === 'string' && <Button variant="secondary" disabled={disabled || searching !== null || !id} onClick={() => { sequence.current++; edit(kind === 'intended' ? { intendedAddressId: null } : { alternateAddressId: null }) }}>Use Buyer’s shared {kind === 'intended' ? 'location' : 'drop-off'}</Button>}
          <div className="grid items-end gap-2 sm:grid-cols-[minmax(0,1fr)_auto]">
            <Field label={`Search ${label.toLowerCase()}`} value={queries[kind]} maxLength={300} disabled={disabled || searching !== null} placeholder="Street, barangay, city / municipality" onChange={event => { setQueries(previous => ({ ...previous, [kind]: event.target.value })); setError(null) }} onKeyDown={event => { if (event.key === 'Enter') { event.preventDefault(); if (queries[kind].trim().length >= 5 && !searching) void find(kind) } }} />
            <Button variant="secondary" disabled={disabled || searching !== null || queries[kind].trim().length < 5} onClick={() => void find(kind)}>{searching === kind ? 'Searching…' : `Find ${kind === 'intended' ? 'destination' : 'drop-off'}`}</Button>
          </div>
          <p className="text-xs text-text-secondary">Address search by Google Maps. Review the resolved address with the Buyer.</p>
        </>}
      </div>
    })}
    <Select label="Does the Buyer know of a heavy-vehicle restriction?" value={restriction} disabled={disabled || locked || searching !== null} onChange={event => edit({ heavyVehicleRestriction: event.target.value as NonNullable<ChatQuotationDestination['heavyVehicleRestriction']> })}>
      <option value="UNANSWERED">Select the Buyer’s answer</option><option value="NO">No known restriction</option><option value="YES">Yes — use an alternative drop-off</option>
    </Select>
    <label className="grid gap-2 text-sm font-semibold">Access &amp; unloading instructions{restriction === 'YES' ? ' (required)' : ' (optional)'}<textarea className="min-h-20 w-full rounded-control border border-border-default bg-surface-primary px-3 py-2 font-normal" maxLength={500} disabled={disabled || locked} value={instructions} onChange={event => edit({ accessInstructions: event.target.value })} /></label>
    <p className="text-xs text-text-secondary">{restriction === 'YES' ? 'The alternative drop-off is used for road distance and the delivery fee. The intended site stays separate.' : 'No known restriction does not guarantee unrestricted access. Confirm vehicle access before publication.'}{locked ? ' Work Package delivery details are locked.' : ''}</p>
  </section>
}
