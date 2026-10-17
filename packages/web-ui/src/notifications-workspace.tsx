import { PageHeader } from './page-patterns'
import { useCallback, useEffect, useMemo, useState, type ReactNode } from 'react'
import { NotificationsApi } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from './web-api-session'
import { Button } from './button'
import { NotificationInbox, type NotificationInboxWatcher } from './notification-inbox'
import { notificationError } from './notification-error'
import { NotificationPreferencesDialog } from './notification-preferences-dialog'

export { notificationError } from './notification-error'

export type NotificationAudience = 'vendor' | 'admin'

export function NotificationsWorkspace({ basePath, audience, navigate, enablePush, watchUpdates, headerActions }: { basePath: string; audience: NotificationAudience; navigate: (path: string) => void; enablePush?: () => Promise<void>; watchUpdates?: NotificationInboxWatcher; headerActions?: ReactNode }) {
  const api = useMemo(() => new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true })), [basePath])
  const [preferencesOpen, setPreferencesOpen] = useState(false)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const open = useCallback(async (id: string) => {
    setBusy(true); setError('')
    try {
      const result = await api.resolveNotification({ audience, noticeId: id })
      await api.readNotification({ audience, noticeId: id })
      window.dispatchEvent(new CustomEvent('materyalph:notification-read', { detail: { id, audience } }))
      window.dispatchEvent(new Event('materyalph:navigation-updates'))
      if (!result.data.path.startsWith('/') || result.data.path.startsWith('//')) throw new Error('Invalid target')
      navigate(result.data.path)
    } catch (cause) { setError(await notificationError(cause)) } finally { setBusy(false) }
  }, [api, audience, navigate])
  useEffect(() => {
    const notice = new URLSearchParams(window.location.search).get('notice')
    if (notice && /^[0-9a-f-]{36}$/i.test(notice)) void open(notice)
  }, [open])
  return <section className="grid gap-6" aria-busy={busy}>
    <PageHeader eyebrow={audience === 'vendor' ? 'Vendor Portal' : 'Admin Portal'} title="Notifications" description="Updates that need your attention, with secure links to your work." actions={headerActions} />
    {error && <div role="alert" className="grid gap-2 rounded-surface border border-border-default bg-surface-primary p-4"><p>{error}</p><Button variant="secondary" onClick={() => { setError(''); window.dispatchEvent(new Event('materyalph:notifications-refresh')) }}>Retry</Button></div>}
    <NotificationInbox api={api} audience={audience} disabled={busy} onOpen={open} onPreferences={() => setPreferencesOpen(true)} {...(watchUpdates ? { watchUpdates } : {})} />
    {preferencesOpen && <NotificationPreferencesDialog api={api} audience={audience} onClose={() => setPreferencesOpen(false)} {...(enablePush ? { enablePush } : {})} />}
  </section>
}
