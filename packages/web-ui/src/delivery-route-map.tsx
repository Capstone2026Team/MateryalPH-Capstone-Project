import { AsyncLoading } from './async-state'
import { useEffect, useRef, useState } from 'react'
import { MapPin, Store } from 'lucide-react'
import { loadGoogleMaps } from './google-maps'

type Point = { latitude: number; longitude: number; label: string }
type Position = { lat: number; lng: number }
type MapsApi = { maps: {
  Map: new (element: HTMLElement, options: object) => { fitBounds: (bounds: unknown) => void }
  Marker: new (options: object) => { setMap: (map: null) => void }
  Polyline: new (options: object) => { setMap: (map: null) => void }
  LatLngBounds: new () => { extend: (point: Position) => void }
  event: { clearInstanceListeners: (instance: unknown) => void }
} }

/** Decode the provider's encoded route; never substitute a straight line for a driving route. */
export function decodeDeliveryPolyline(encoded: string): Position[] {
  const path: Position[] = []
  let index = 0, lat = 0, lng = 0
  function next() {
    let value = 0, shift = 0, byte = 0
    do {
      if (index >= encoded.length || shift > 30) throw new Error('Invalid route geometry')
      byte = encoded.charCodeAt(index++) - 63
      value |= (byte & 31) << shift
      shift += 5
    } while (byte >= 32)
    return value & 1 ? ~(value >> 1) : value >> 1
  }
  while (index < encoded.length) {
    lat += next(); lng += next()
    path.push({ lat: lat / 1e5, lng: lng / 1e5 })
  }
  return path
}

export function DeliveryRouteMap({ origin, destination, encodedPolyline = '', browserKey, mapLabel = 'Delivery route map', originLabel = 'Starting point', destinationLabel = 'Confirmed drop-off', stackAddresses = false }: {
  origin?: Point | null; destination?: Point | null; encodedPolyline?: string; browserKey: string
  mapLabel?: string; originLabel?: string; destinationLabel?: string; stackAddresses?: boolean
}) {
  const container = useRef<HTMLDivElement>(null)
  const [error, setError] = useState<string | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [loading, setLoading] = useState(true)
  useEffect(() => {
    let active = true
    const cleanup: (() => void)[] = []
    setError(null)
    setLoading(true)
    const center = origin ?? destination
    if (!center) { setError('A map pin is unavailable for this address. Use the address below or open navigation.'); setLoading(false); return }
    if (!browserKey) { setError('Map display is unavailable. Use the addresses below or open navigation.'); setLoading(false); return }
    void loadGoogleMaps<MapsApi>(browserKey).then(google => {
      if (!active || !container.current) return
      const map = new google.maps.Map(container.current, { center: { lat: center.latitude, lng: center.longitude }, zoom: 15, gestureHandling: 'cooperative', streetViewControl: false, mapTypeControl: false })
      cleanup.push(() => google.maps.event.clearInstanceListeners(map))
      const bounds = new google.maps.LatLngBounds()
      for (const point of [origin, destination]) {
        if (!point) continue
        const position = { lat: point.latitude, lng: point.longitude }
        bounds.extend(position)
        const marker = new google.maps.Marker({ map, position, title: point.label })
        cleanup.push(() => marker.setMap(null))
      }
      const path = decodeDeliveryPolyline(encodedPolyline)
      path.forEach(point => bounds.extend(point))
      if (path.length > 0) {
        const line = new google.maps.Polyline({ map, path, strokeWeight: 4 })
        cleanup.push(() => line.setMap(null))
      }
      if (origin && destination) map.fitBounds(bounds)
      setLoading(false)
    }).catch(() => { cleanup.forEach(dispose => dispose()); cleanup.length = 0; if (active) { setError('The map could not load. Use the addresses below or open navigation.'); setLoading(false) } })
    return () => { active = false; cleanup.forEach(dispose => dispose()) }
  }, [origin?.latitude, origin?.longitude, origin?.label, destination?.latitude, destination?.longitude, destination?.label, encodedPolyline, browserKey, attempt])
  return <div className="grid min-w-0 gap-3">
    <div className="relative min-w-0">
      <div ref={container} role="region" aria-label={mapLabel} aria-busy={loading} hidden={Boolean(error)} className="h-56 w-full min-w-0 overflow-hidden rounded-control border border-border-default sm:h-72" />
      {loading && !error && <AsyncLoading label="Loading map…" className="absolute inset-0 bg-surface-canvas" />}
      {error && <div className="grid gap-2"><p role="status" className="text-sm leading-6 text-text-secondary">{error}</p>{browserKey && (origin || destination) && <button type="button" className="min-h-11 w-fit text-sm font-semibold text-action-primary underline focus-visible:outline-2 focus-visible:outline-focus-ring" onClick={() => setAttempt(value => value + 1)}>Retry map</button>}</div>}
    </div>
    <dl className={`grid min-w-0 gap-4 text-sm${stackAddresses ? '' : ' sm:grid-cols-2'}`} aria-label="Delivery route addresses">
      {origin && <div className="grid min-w-0 content-start gap-1.5"><dt className="flex items-center gap-2 font-semibold"><Store size={16} className="shrink-0 text-text-secondary" aria-hidden="true" />{originLabel}</dt><dd className="break-words leading-6 text-text-secondary">{origin.label}</dd></div>}
      {destination && <div className="grid min-w-0 content-start gap-1.5"><dt className="flex items-center gap-2 font-semibold"><MapPin size={16} className="shrink-0 text-text-secondary" aria-hidden="true" />{destinationLabel}</dt><dd className="break-words leading-6 text-text-secondary">{destination.label}</dd></div>}
    </dl>
  </div>
}
