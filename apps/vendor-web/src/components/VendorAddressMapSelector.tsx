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
}

const DEFAULT_CENTER = { lat: 14.5995, lng: 120.9842 }
const SCRIPT_ID = 'materyalph-google-maps-browser-script'

function configuredGoogleMaps(): GoogleMapsApi | undefined {
  const google = (window as GoogleWindow).google
  return google?.maps ? google : undefined
}

function loadGoogleMaps(browserKey: string): Promise<GoogleMapsApi> {
  const configured = configuredGoogleMaps()
  if (configured) return Promise.resolve(configured)

  return new Promise((resolve, reject) => {
    const existing = document.getElementById(SCRIPT_ID)
    const script = existing instanceof HTMLScriptElement ? existing : document.createElement('script')
    const finish = () => {
      const google = configuredGoogleMaps()
      if (google) resolve(google)
      else reject(new Error('Google Maps did not initialize.'))
    }

    script.addEventListener('load', finish, { once: true })
    script.addEventListener('error', () => reject(new Error('Google Maps could not be loaded.')), { once: true })
    if (!existing) {
      script.id = SCRIPT_ID
      script.async = true
      script.defer = true
      script.src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(browserKey)}&v=weekly`
      document.head.appendChild(script)
    }
  })
}

function validCoordinates(latitude: number | undefined, longitude: number | undefined): VendorAddressCoordinates | null {
  if (latitude === undefined || longitude === undefined || !Number.isFinite(latitude) || !Number.isFinite(longitude)) return null
  if (latitude < -90 || latitude > 90 || longitude < -180 || longitude > 180) return null
  return { latitude, longitude }
}

export function VendorAddressMapSelector({ latitude, longitude, onCoordinatesChange }: { latitude?: number; longitude?: number; onCoordinatesChange: (coordinates: VendorAddressCoordinates) => void }) {
  const containerRef = useRef<HTMLDivElement>(null)
  const callbackRef = useRef(onCoordinatesChange)
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

    let mounted = true
    let map: GoogleMap | undefined
    let marker: GoogleMarker | undefined
    const listeners: GoogleListener[] = []
    const selected = validCoordinates(latitude, longitude)
    const center = selected === null ? DEFAULT_CENTER : { lat: selected.latitude, lng: selected.longitude }

    void loadGoogleMaps(browserKey).then((google) => {
      if (!mounted || !containerRef.current) return
      map = new google.maps.Map(containerRef.current, { center, zoom: 15, gestureHandling: 'cooperative' })
      marker = new google.maps.Marker({ map, position: center, draggable: true })
      const select = (coordinates: VendorAddressCoordinates) => {
        marker?.setPosition({ lat: coordinates.latitude, lng: coordinates.longitude })
        map?.setCenter({ lat: coordinates.latitude, lng: coordinates.longitude })
        map?.setZoom(15)
        callbackRef.current(coordinates)
      }
      listeners.push(google.maps.event.addListener(map, 'click', (event) => {
        if (event.latLng) select({ latitude: event.latLng.lat(), longitude: event.latLng.lng() })
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
        setError('Interactive map is unavailable. Complete the labeled address fields manually.')
      }
    })

    return () => {
      mounted = false
      listeners.forEach((listener) => listener.remove?.())
    }
  }, [latitude, longitude])

  return <div className="grid gap-3" aria-describedby="address-map-help"><div className="flex flex-wrap items-center justify-between gap-3"><p className="text-sm font-semibold">Map selection</p><span className="text-xs font-semibold uppercase tracking-[0.12em] text-text-secondary">{state === 'ready' ? 'Interactive' : state === 'loading' ? 'Loading' : 'Manual fallback'}</span></div>{state === 'ready' ? <div ref={containerRef} className="min-h-64 w-full overflow-hidden rounded-control border border-border-default" aria-label="Interactive business address map" /> : <div ref={containerRef} className="grid min-h-24 place-items-center rounded-control border border-dashed border-border-default bg-surface-canvas px-5 py-6 text-center text-sm leading-6 text-text-secondary" role="status">{error ?? 'Interactive Google Maps is not configured for this environment.'}</div>}<p id="address-map-help" className="text-sm leading-6 text-text-secondary">{state === 'ready' ? 'Click the map or drag the pin. The coordinates and assistive address result will be copied into the labeled fields above for review before saving.' : 'The labeled address fields above remain the complete non-map alternative. Coordinates are stored separately from the human-readable address.'}</p></div>
}
