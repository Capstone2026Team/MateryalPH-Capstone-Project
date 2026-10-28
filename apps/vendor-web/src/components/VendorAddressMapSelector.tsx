import { useEffect, useState } from 'react'
import { LocationPinMap, type LocationCoordinates } from '@materyalph/web-ui'

export type VendorAddressCoordinates = LocationCoordinates

export function VendorAddressMapSelector({ latitude, longitude, onCoordinatesChange }: { latitude?: number | undefined; longitude?: number | undefined; onCoordinatesChange?: (coordinates: VendorAddressCoordinates) => void }) {
  const [browserKey, setBrowserKey] = useState<string | undefined>()
  useEffect(() => { setBrowserKey(import.meta.env.VITE_GOOGLE_MAPS_BROWSER_KEY?.trim()) }, [])
  return <div className="grid gap-3"><p className="text-sm font-semibold">Map</p><LocationPinMap browserKey={browserKey} latitude={latitude} longitude={longitude} {...(onCoordinatesChange ? { onCoordinatesChange } : {})} label="Interactive business address map" unavailableMessage={onCoordinatesChange ? 'Interactive map is unavailable. Choose Enter address manually or retry the map.' : 'Interactive map is unavailable. Your registered address remains available. Retry to load the map.'} instructions={onCoordinatesChange ? 'Click the map or drag the pin to your business. The address details below will fill automatically.' : 'The pin marks your registered store location. Pan or zoom to explore the map.'} /></div>
}
