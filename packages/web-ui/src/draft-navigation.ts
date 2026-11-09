import { useCallback, useEffect, useRef } from 'react'

/** Share an in-flight draft save with navigation instead of starting a second write. */
export function useSerializedDraftSave(save: (force?: boolean) => Promise<boolean>) {
  const latest = useRef(save)
  latest.current = save
  const pending = useRef<Promise<boolean> | null>(null)
  return useCallback((force = false): Promise<boolean> => {
    if (pending.current) return pending.current
    const task = latest.current(force).finally(() => { pending.current = null })
    pending.current = task
    return task
  }, [])
}

type BlockedNavigation = { proceed: () => void; reset: () => void }

/** Router adapters supply the pending navigation; failed saves leave the form open. */
export function useSaveBeforeLeave({ unsaved, save, blocked }: {
  unsaved: boolean
  save: () => Promise<boolean>
  blocked: BlockedNavigation | null
}) {
  const latest = useRef(save)
  latest.current = save
  useEffect(() => {
    if (!blocked) return
    let active = true
    void latest.current().then(saved => {
      if (active) { if (saved) blocked.proceed(); else blocked.reset() }
    }).catch(() => { if (active) blocked.reset() })
    return () => { active = false }
  }, [blocked])
  useEffect(() => {
    if (!unsaved) return
    const warn = (event: BeforeUnloadEvent) => { event.preventDefault(); event.returnValue = '' }
    window.addEventListener('beforeunload', warn)
    return () => window.removeEventListener('beforeunload', warn)
  }, [unsaved])
}
