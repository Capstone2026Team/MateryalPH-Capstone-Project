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

export function DeliveryRouteMap({ origin, destination, encodedPolyline, browserKey }: { origin: Point; destination: Point; encodedPolyline: string; browserKey: string }) {
  const container = useRef<HTMLDivElement>(null)
  const [error, setError] = useState<string | null>(null)
  useEffect(() => {
    let active = true
    const cleanup: (() => void)[] = []
    setError(null)
    if (!browserKey) { setError('Map display is unavailable. Use the delivery addresses or open navigation.'); return }
    void loadGoogleMaps<MapsApi>(browserKey).then(google => {
      if (!active || !container.current) return
      const map = new google.maps.Map(container.current, { center: { lat: origin.latitude, lng: origin.longitude }, zoom: 13, gestureHandling: 'cooperative', streetViewControl: false, mapTypeControl: false })
      cleanup.push(() => google.maps.event.clearInstanceListeners(map))
      const bounds = new google.maps.LatLngBounds()
      for (const point of [origin, destination]) {
        const position = { lat: point.latitude, lng: point.longitude }
        bounds.extend(position)
        const marker = new google.maps.Marker({ map, position, title: point.label })
        cleanup.push(() => marker.setMap(null))
      }
      const path = decodeDeliveryPolyline(encodedPolyline)
      path.forEach(point => bounds.extend(point))
      const line = new google.maps.Polyline({ map, path, strokeWeight: 4 })
      map.fitBounds(bounds)
      cleanup.push(() => line.setMap(null))
    }).catch(() => { cleanup.forEach(dispose => dispose()); if (active) setError('The map could not load. Use the addresses below or open navigation.') })
    return () => { active = false; cleanup.forEach(dispose => dispose()) }
  }, [origin.latitude, origin.longitude, origin.label, destination.latitude, destination.longitude, destination.label, encodedPolyline, browserKey])
  return <div className="grid min-w-0 gap-3">
    {error ? <p role="status" className="text-sm leading-6 text-text-secondary">{error}</p> : <div ref={container} role="region" aria-label="Delivery route map" className="h-56 w-full min-w-0 overflow-hidden rounded-control border border-border-default sm:h-72" />}
    <dl className="grid min-w-0 gap-4 text-sm sm:grid-cols-2" aria-label="Delivery route addresses">
      <div className="grid min-w-0 content-start gap-1.5"><dt className="flex items-center gap-2 font-semibold"><Store size={16} className="shrink-0 text-text-secondary" aria-hidden="true" />Starting point</dt><dd className="break-words leading-6 text-text-secondary">{origin.label}</dd></div>
      <div className="grid min-w-0 content-start gap-1.5"><dt className="flex items-center gap-2 font-semibold"><MapPin size={16} className="shrink-0 text-text-secondary" aria-hidden="true" />Confirmed drop-off</dt><dd className="break-words leading-6 text-text-secondary">{destination.label}</dd></div>
    </dl>
  </div>
}
