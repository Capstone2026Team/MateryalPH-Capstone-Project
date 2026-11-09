import { useEffect, useRef, useState } from 'react'
import { NotificationsApi, type NotificationItem } from '@materyalph/api-client-ts'
import { Button } from './button'
import { FormDialog } from './form-dialog'
import { loadNotificationInbox } from './notification-inbox-state'
import { watchNotificationUpdates } from './notification-realtime'
import { notificationError } from './notification-error'
import { createWebApiConfiguration } from './web-api-session'

/** Foreground enforcement notice; server-authorized REST is the only source of its content. */
export function EnforcementNoticePopup({ basePath, enabled = true }: { basePath: string; enabled?: boolean }) {
  const [notice, setNotice] = useState<NotificationItem | null>(null)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const refresh = useRef<() => void>(() => undefined)
  const generation = useRef(0)
  useEffect(() => {
    const epoch = ++generation.current
    setBusy(false); setError('')
    if (!enabled) { setNotice(null); return }
    let active = true, pending = false
    const controller = new AbortController()
    const api = new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true }))
    const update = async () => {
      if (!active || pending || document.visibilityState === 'hidden') return
      pending = true
      try {
        const items = await loadNotificationInbox(api, 'vendor', controller.signal)
        if (active) setNotice(items.find(item => item.category === 'SUSPENSION' && !item.readAt) ?? null)
      } catch { /* The existing inbox owns connection errors; the next invalidation/poll retries. */ }
      finally { pending = false }
    }
    refresh.current = () => { void update() }
    const clear = () => { active = false; generation.current++; controller.abort(); setNotice(null); setError(''); setBusy(false) }
    let stop: (() => void) | undefined
    void watchNotificationUpdates(basePath, 'vendor', refresh.current).then(close => { if (active) stop = close; else close() })
    const timer = window.setInterval(refresh.current, 15_000)
    window.addEventListener('materyalph:session-cleared', clear)
    window.addEventListener('materyalph:notification-read', refresh.current)
    document.addEventListener('visibilitychange', refresh.current)
    void update()
    return () => { active = false; if (generation.current === epoch) generation.current++; controller.abort(); stop?.(); clearInterval(timer); window.removeEventListener('materyalph:session-cleared', clear); window.removeEventListener('materyalph:notification-read', refresh.current); document.removeEventListener('visibilitychange', refresh.current) }
  }, [basePath, enabled])
  async function acknowledge() {
    if (!notice || busy) return
    const id = notice.id
    const epoch = generation.current
    setBusy(true); setError('')
    try {
      await new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true })).readNotification({ audience: 'vendor', noticeId: id })
      if (generation.current !== epoch) return
      setNotice(current => current?.id === id ? null : current)
      window.dispatchEvent(new CustomEvent('materyalph:notification-read', { detail: { audience: 'vendor', id } }))
      window.dispatchEvent(new Event('materyalph:notifications-refresh'))
      refresh.current()
    } catch (cause) { const message = await notificationError(cause); if (generation.current === epoch) setError(message) }
    finally { if (generation.current === epoch) setBusy(false) }
  }
  if (!notice) return null
  return <FormDialog open size="small" initialFocus="title" title={notice.title} description="Account enforcement update from MateryalPH" busy={busy} onClose={() => { void acknowledge() }} footer={<div className="flex justify-end"><Button disabled={busy} onClick={() => { void acknowledge() }}>{busy ? 'Saving…' : 'Acknowledge'}</Button></div>}>
    <p className="whitespace-pre-line break-words text-sm leading-6">{notice.body}</p>
    {error && <p role="alert" className="mt-3 text-sm text-status-error">{error}</p>}
  </FormDialog>
}
