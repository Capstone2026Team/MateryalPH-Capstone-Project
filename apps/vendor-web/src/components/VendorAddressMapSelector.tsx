import { useEffect, useRef, useState } from 'react'

export type VendorAddressCoordinates = {
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
const SCRIPT_ID = 'materyalph-google-maps-browser-script'

function configuredGoogleMaps(): GoogleMapsApi | undefined {
  const google = (window as GoogleWindow).google
  return google?.maps ? google : undefined
}

let mapsLoading: Promise<GoogleMapsApi> | undefined

function loadGoogleMaps(browserKey: string): Promise<GoogleMapsApi> {
  const configured = configuredGoogleMaps()
  if (configured?.maps.Map) return Promise.resolve(configured)
  if (mapsLoading) return mapsLoading
  mapsLoading = new Promise((resolve, reject) => {
    document.getElementById(SCRIPT_ID)?.remove()
    const script = document.createElement('script')
    const fail = () => {
      window.clearTimeout(timeout)
      script.remove()
      mapsLoading = undefined
      reject(new Error('Google Maps could not initialize.'))
    }
    const timeout = window.setTimeout(fail, 15000)
    ;(window as GoogleWindow).materyalMapsReady = () => {
      const google = configuredGoogleMaps()
      if (!google?.maps.Map) { fail(); return }
      window.clearTimeout(timeout)
      resolve(google)
    }
    script.id = SCRIPT_ID
    script.async = true
    script.onerror = fail
    script.src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(browserKey)}&v=weekly&loading=async&callback=materyalMapsReady`
    document.head.appendChild(script)
  })
  return mapsLoading
}

function validCoordinates(latitude: number | undefined, longitude: number | undefined): VendorAddressCoordinates | null {
  if (latitude === undefined || longitude === undefined || !Number.isFinite(latitude) || !Number.isFinite(longitude)) return null
  if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) return null
  return { latitude, longitude }
}

export function VendorAddressMapSelector({ latitude, longitude, onCoordinatesChange }: { latitude?: number | undefined; longitude?: number | undefined; onCoordinatesChange?: (coordinates: VendorAddressCoordinates) => void }) {
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
    const browserKey = import.meta.env.VITE_GOOGLE_MAPS_BROWSER_KEY?.trim()
    if (!browserKey) {
      setState('unavailable')
      return
    }

    setState('loading')
    setError(null)
    const googleWindow = window as GoogleWindow
    const previousAuthFailure = googleWindow.gm_authFailure
    const authFailure = () => { setState('unavailable'); setError('Google Maps authorization failed. Check the browser key, enabled Maps JavaScript API, billing, and allowed website restrictions.'); previousAuthFailure?.() }
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
      const select = (coordinates: VendorAddressCoordinates) => {
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
        setError('Interactive map is unavailable. Check your connection and retry. You can still select your structured address fields.')
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
  }, [attempt])

  useEffect(() => {
    const position = validCoordinates(latitude, longitude)
    if (position && state === 'ready') {
      const center = { lat: position.latitude, lng: position.longitude }
      mapRef.current?.setCenter(center)
      markerRef.current?.setPosition(center)
    }
  }, [latitude, longitude, state])

  return <div className="grid gap-3" aria-describedby="address-map-help">
    <p className="text-sm font-semibold">Map</p>
    <div ref={containerRef} style={state === 'unavailable' ? { height: 0 } : undefined} className="h-96 w-full overflow-hidden rounded-control border border-border-default sm:h-[480px] lg:h-[560px]" aria-label="Interactive business address map" />
    {state !== 'ready' && <div role="status" className="text-sm text-text-secondary">{state === 'loading' ? 'Loading Google Maps…' : error ?? (onCoordinatesChange ? 'Interactive map is unavailable. Complete the structured fields using Manual Address Entry or retry the map.' : 'Interactive map is unavailable. Your registered address remains available. Retry to load the map.')}</div>}
    {state === 'unavailable' && <button type="button" className="min-h-11 text-action-primary underline" onClick={() => setAttempt(value => value + 1)}>Retry map</button>}
    <p id="address-map-help" className="text-sm text-text-secondary">{onCoordinatesChange ? 'Manual Address Entry needs no map interaction. Click the map or drag the pin to fill the address automatically. Review matched locations and select any missing PSGC fields. Coordinates are managed by the system.' : 'The pin marks your registered store location. Pan or zoom to explore the map.'}</p>
  </div>
}
