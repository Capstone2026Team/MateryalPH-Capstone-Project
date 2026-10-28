import { useEffect, useId, useRef, useState } from 'react'
import { loadGoogleMaps as loadSharedGoogleMaps } from './google-maps'

export type LocationCoordinates = {
  latitude: number
  longitude: number
}

type GoogleMapMouseEvent = {
  latLng: {
    lat: () => number
    lng: () => number
  } | null
}

type GoogleListener = {
  remove?: () => void
}

type GoogleMap = {
  setCenter: (position: { lat: number; lng: number }) => void
  setZoom: (zoom: number) => void
}

type GoogleMarker = {
  getPosition: () => { lat: () => number; lng: () => number } | null
  setPosition: (position: { lat: number; lng: number }) => void
}

type GoogleMapsApi = {
  maps: {
    Map: new (element: HTMLElement, options: { center: { lat: number; lng: number }; zoom: number; gestureHandling: string }) => GoogleMap
    Marker: new (options: { map: GoogleMap; position: { lat: number; lng: number }; draggable: boolean }) => GoogleMarker
    event: {
      addListener: (target: unknown, eventName: string, handler: (event: GoogleMapMouseEvent) => void) => GoogleListener
    }
  }
}

type GoogleWindow = Window & {
  google?: GoogleMapsApi
  materyalMapsReady?: () => void
  gm_authFailure?: (() => void) | undefined
}

const DEFAULT_CENTER = { lat: 14.5995, lng: 120.9842 }

const loadGoogleMaps = (browserKey: string) => loadSharedGoogleMaps<GoogleMapsApi>(browserKey)

function validCoordinates(latitude: number | undefined, longitude: number | undefined): LocationCoordinates | null {
  if (latitude === undefined || longitude === undefined || !Number.isFinite(latitude) || !Number.isFinite(longitude)) return null
  if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) return null
  return { latitude, longitude }
}

export function LocationPinMap({ latitude, longitude, onCoordinatesChange, browserKey, label = 'Interactive location map', instructions, unavailableMessage = 'Interactive map is unavailable. Use address search or retry the map.', className = 'h-72 sm:h-96' }: { latitude?: number | undefined; longitude?: number | undefined; onCoordinatesChange?: (coordinates: LocationCoordinates) => void; browserKey?: string | undefined; label?: string; instructions: string; unavailableMessage?: string; className?: string }) {
  const helpId = useId()
  const containerRef = useRef<HTMLDivElement>(null)
  const callbackRef = useRef(onCoordinatesChange)
  const mapRef = useRef<GoogleMap | null>(null)
  const markerRef = useRef<GoogleMarker | null>(null)
  const [attempt, setAttempt] = useState(0)
  const [state, setState] = useState<'loading' | 'ready' | 'unavailable'>('loading')
  const [error, setError] = useState<string | null>(null)

  useEffect(() => {
    callbackRef.current = onCoordinatesChange
  }, [onCoordinatesChange])

  useEffect(() => {
    if (!browserKey) {
      setState('unavailable')
      return
    }

    setState('loading')
    setError(null)
    const googleWindow = window as GoogleWindow
    const previousAuthFailure = googleWindow.gm_authFailure
    const authFailure = () => { setState('unavailable'); setError('Google Maps authorization failed. Use the address fields or retry the map.'); previousAuthFailure?.() }
    googleWindow.gm_authFailure = authFailure
    let mounted = true
    let map: GoogleMap | undefined
    let marker: GoogleMarker | undefined
    const listeners: GoogleListener[] = []
    const selected = validCoordinates(latitude, longitude)
    const center = selected === null ? DEFAULT_CENTER : { lat: selected.latitude, lng: selected.longitude }

    void loadGoogleMaps(browserKey).then((google) => {
      if (!mounted || !containerRef.current) return
      map = new google.maps.Map(containerRef.current, { center, zoom: 15, gestureHandling: 'cooperative' })
      marker = new google.maps.Marker({ map, position: center, draggable: Boolean(callbackRef.current) })
      mapRef.current = map
      markerRef.current = marker
      const select = (coordinates: LocationCoordinates) => {
        marker?.setPosition({ lat: coordinates.latitude, lng: coordinates.longitude })
        map?.setCenter({ lat: coordinates.latitude, lng: coordinates.longitude })
        map?.setZoom(15)
        callbackRef.current?.(coordinates)
      }
      listeners.push(google.maps.event.addListener(map, 'click', (event) => {
        if (callbackRef.current && event.latLng) select({ latitude: event.latLng.lat(), longitude: event.latLng.lng() })
      }))
      listeners.push(google.maps.event.addListener(marker, 'dragend', () => {
        const position = marker?.getPosition()
        if (position) select({ latitude: position.lat(), longitude: position.lng() })
      }))
      setState('ready')
      setError(null)
    }).catch(() => {
      if (mounted) {
        setState('unavailable')
        setError('Interactive map is unavailable. Use the address fields or retry the map.')
      }
    })

    return () => {
      mounted = false
      mapRef.current = null
      markerRef.current = null
      if (googleWindow.gm_authFailure === authFailure) googleWindow.gm_authFailure = previousAuthFailure
      listeners.forEach((listener) => listener.remove?.())
    }
  // Coordinates update the existing map in the effect below.
  // eslint-disable-next-line react-hooks/exhaustive-deps
  }, [attempt, browserKey])

  useEffect(() => {
    const position = validCoordinates(latitude, longitude)
    if (position && state === 'ready') {
      const center = { lat: position.latitude, lng: position.longitude }
      mapRef.current?.setCenter(center)
      markerRef.current?.setPosition(center)
    }
  }, [latitude, longitude, state])

  return <div className="grid gap-3" aria-describedby={helpId}>
    <div ref={containerRef} style={state === 'unavailable' ? { height: 0 } : undefined} className={`w-full overflow-hidden rounded-control border border-border-default ${className}`} aria-label={label} />
    {state !== 'ready' && <div role="status" className="text-sm text-text-secondary">{state === 'loading' ? 'Loading Google Maps…' : error ?? unavailableMessage}</div>}
    {state === 'unavailable' && <button type="button" className="min-h-11 text-action-primary underline" onClick={() => setAttempt(value => value + 1)}>Retry map</button>}
    <p id={helpId} className="text-xs text-text-secondary">{instructions}</p>
  </div>
}
