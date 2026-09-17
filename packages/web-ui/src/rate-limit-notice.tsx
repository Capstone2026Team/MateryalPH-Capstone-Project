import { useEffect, useState } from 'react'

export function RateLimitNotice() {
  const [until, setUntil] = useState(0)
  const [now, setNow] = useState(Date.now())
  useEffect(() => {
    function limited(event: Event) { setUntil((event as CustomEvent<{ until: number }>).detail.until); setNow(Date.now()) }
    window.addEventListener('materyalph:rate-limited', limited)
    return () => window.removeEventListener('materyalph:rate-limited', limited)
  }, [])
  useEffect(() => {
    if (!until) return
    const timer = window.setInterval(() => { const time = Date.now(); setNow(time); if (time >= until) window.clearInterval(timer) }, 1000)
    return () => window.clearInterval(timer)
  }, [until])
  if (!until) return null
  const remaining = Math.max(0, Math.ceil((until - now) / 1000))
  return <aside className="mb-5 flex flex-wrap items-center justify-between gap-3 rounded-control border border-border-default bg-surface-primary p-4 text-sm" aria-label="Request limit notice"><div><p role="status">{remaining ? 'A request is temporarily limited. You are still signed in.' : 'The retry wait has ended. You can try the action again.'}</p>{remaining > 0 && <p className="mt-1 text-text-secondary">Retry in {remaining}s · after {new Date(until).toLocaleTimeString('en-PH', { timeZone: 'Asia/Manila' })} Asia/Manila. Nothing will be resubmitted automatically.</p>}</div><button type="button" className="min-h-11 px-3 font-semibold" onClick={() => setUntil(0)}>Dismiss</button></aside>
}
