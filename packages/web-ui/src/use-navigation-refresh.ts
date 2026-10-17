import { useEffect, useRef } from 'react'
import { useAutomaticRefresh } from './use-automatic-refresh'

/** Refresh mounted read models and their status tabs; form drafts retain their own state. */
export function useNavigationRefresh(refresh: () => void, { intervalMs = 15_000 }: { intervalMs?: number } = {}) {
  const callback = useRef(refresh)
  const active = useRef(true)
  useEffect(() => { callback.current = refresh }, [refresh])
  useAutomaticRefresh(async () => { if (active.current) callback.current() }, { intervalMs })
  useEffect(() => {
    active.current = true
    let timer: ReturnType<typeof setTimeout> | undefined
    const update = () => {
      if (!active.current || timer) return
      timer = setTimeout(() => { timer = undefined; if (active.current) callback.current() }, 100)
    }
    const clear = () => { active.current = false; clearTimeout(timer) }
    window.addEventListener('materyalph:domain-refresh', update)
    window.addEventListener('materyalph:navigation-updates', update)
    window.addEventListener('materyalph:session-cleared', clear)
    return () => {
      clear()
      window.removeEventListener('materyalph:domain-refresh', update)
      window.removeEventListener('materyalph:navigation-updates', update)
      window.removeEventListener('materyalph:session-cleared', clear)
    }
  }, [])
}
