/**
 * One Google Maps JavaScript API loader for both portals. The browser key is a referrer-restricted public key
 * (VITE_GOOGLE_MAPS_BROWSER_KEY), never a backend secret. A failed or timed-out load rejects so callers fall back
 * to their accessible list or tile view instead of hanging.
 */
type MapsWindow = Window & { google?: { maps?: unknown }; materyalMapsReady?: () => void }

const SCRIPT_ID = 'materyalph-google-maps-browser-script'
let loading: Promise<unknown> | undefined

export function loadGoogleMaps<T = unknown>(browserKey: string): Promise<T> {
  const existing = (window as MapsWindow).google
  if (existing?.maps && typeof (existing.maps as { Map?: unknown }).Map === 'function') return Promise.resolve(existing as T)
  if (loading) return loading as Promise<T>
  loading = new Promise((resolve, reject) => {
    document.getElementById(SCRIPT_ID)?.remove()
    const script = document.createElement('script')
    const fail = () => {
      window.clearTimeout(timeout)
      script.remove()
      loading = undefined
      reject(new Error('Google Maps could not initialize.'))
    }
    const timeout = window.setTimeout(fail, 15000)
    ;(window as MapsWindow).materyalMapsReady = () => {
      const google = (window as MapsWindow).google
      if (!google?.maps || typeof (google.maps as { Map?: unknown }).Map !== 'function') { fail(); return }
      window.clearTimeout(timeout)
      resolve(google)
    }
    script.id = SCRIPT_ID
    script.async = true
    script.onerror = fail
    script.src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(browserKey)}&v=weekly&loading=async&callback=materyalMapsReady`
    document.head.appendChild(script)
  })
  return loading as Promise<T>
}
