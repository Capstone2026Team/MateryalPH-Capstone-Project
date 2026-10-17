import { createContext, useCallback, useContext, useEffect, useState, useSyncExternalStore, type ReactNode } from 'react'
import { PortalResourceStore } from './portal-resource-store'
import { ResponseError } from '@materyalph/api-client-ts'

const Resources = createContext<PortalResourceStore | null>(null)

export function PortalResourceProvider({ children }: { children: ReactNode }) {
  const [store] = useState(() => new PortalResourceStore())
  useEffect(() => {
    const denied = (event: Event) => { if (event instanceof CustomEvent && event.detail instanceof Response) store.rejectAll(new ResponseError(event.detail)) }
    window.addEventListener('materyalph:session-cleared', store.clear)
    window.addEventListener('materyalph:access-denied', denied)
    return () => {
      window.removeEventListener('materyalph:session-cleared', store.clear)
      window.removeEventListener('materyalph:access-denied', denied)
      store.clear()
    }
  }, [store])
  return <Resources.Provider value={store}>{children}</Resources.Provider>
}

export function usePortalResource<T>(key: string, loader: () => Promise<T>, enabled = true) {
  const shared = useContext(Resources)
  const [local] = useState(() => new PortalResourceStore())
  const store = shared ?? local
  const read = useCallback(() => store.read<T>(key), [store, key])
  const state = useSyncExternalStore(store.subscribe, read, read)
  const refresh = useCallback(() => store.load(key, loader), [store, key, loader])
  const publish = useCallback((value: T | ((previous: T | null) => T)) => store.publish(key, value), [store, key])
  const synchronize = useCallback(() => store.synchronize(key, loader), [store, key, loader])
  useEffect(() => {
    if (!enabled) return
    const release = store.retain(key)
    void store.load(key, loader, false)
    return release
  }, [store, key, loader, enabled])
  return { ...state, refresh, publish, synchronize }
}
