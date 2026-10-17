import { useCallback, useEffect, useRef, useState } from 'react'
import { type NotificationPreference, type NotificationsApi } from '@materyalph/api-client-ts'
import { ShieldCheck } from 'lucide-react'
import { Button } from './button'
import { FormDialog } from './form-dialog'
import { notificationError } from './notification-error'
import { notificationTypeLabel } from './notification-inbox-state'
import type { NotificationAudience } from './notifications-workspace'

const channels = [{ key: 'inApp', label: 'In-app' }, { key: 'email', label: 'Email' }, { key: 'push', label: 'Push' }] as const

export function NotificationPreferencesDialog({ api, audience, onClose, enablePush }: { api: NotificationsApi; audience: NotificationAudience; onClose: () => void; enablePush?: () => Promise<void> }) {
  const [preferences, setPreferences] = useState<NotificationPreference[] | null>(null)
  const [loading, setLoading] = useState(true)
  const [busy, setBusy] = useState(false)
  const [error, setError] = useState('')
  const [status, setStatus] = useState('')
  const request = useRef<AbortController | null>(null)
  const saving = useRef(false)
  const load = useCallback(async () => {
    request.current?.abort()
    const controller = new AbortController()
    request.current = controller
    saving.current = false
    setBusy(false); setLoading(true); setError(''); setStatus('')
    try {
      const result = await api.getNotificationPreferences({ audience }, { signal: controller.signal })
      if (!controller.signal.aborted) setPreferences(result.data)
    } catch (cause) {
      const message = await notificationError(cause)
      if (!controller.signal.aborted) { setPreferences(null); setError(message) }
    } finally { if (!controller.signal.aborted) setLoading(false) }
  }, [api, audience])
  useEffect(() => { void load(); return () => { request.current?.abort() } }, [load])

  async function change(preference: NotificationPreference, channel: typeof channels[number]['key'], enabled: boolean) {
    if (saving.current || preference.mandatory) return
    const controller = request.current
    saving.current = true
    setBusy(true); setError(''); setStatus('Saving…')
    try {
      const result = await api.updateNotificationPreference({ audience, notificationPreferenceInput: { category: preference.category, inApp: preference.inApp, email: preference.email, push: preference.push, [channel]: enabled } })
      if (controller !== request.current || controller?.signal.aborted) return
      setPreferences(result.data); setStatus('Changes saved.')
      window.dispatchEvent(new Event('materyalph:notifications-refresh'))
      if (audience === 'vendor') window.dispatchEvent(new Event('materyalph:navigation-updates'))
    } catch (cause) {
      const message = await notificationError(cause)
      if (controller !== request.current || controller?.signal.aborted) return
      if (cause && typeof cause === 'object' && 'response' in cause && cause.response instanceof Response && [401, 403].includes(cause.response.status)) setPreferences(null)
      setStatus(''); setError(message)
    } finally { if (controller === request.current && !controller?.signal.aborted) { saving.current = false; setBusy(false) } }
  }

  async function enableBrowserPush() {
    if (!enablePush || saving.current) return
    const controller = request.current
    saving.current = true
    setBusy(true); setError(''); setStatus('')
    try { await enablePush(); if (controller === request.current && !controller?.signal.aborted) setStatus('Browser notifications enabled.') }
    catch (cause) { const message = await notificationError(cause); if (controller === request.current && !controller?.signal.aborted) setError(message) }
    finally { if (controller === request.current && !controller?.signal.aborted) { saving.current = false; setBusy(false) } }
  }

  const optional = preferences?.filter(preference => !preference.mandatory) ?? []
  const required = preferences?.filter(preference => preference.mandatory) ?? []
  return <FormDialog open size="compact" title="Notification preferences" description="Choose where you receive optional updates." busy={busy} onClose={onClose} footer={<div className="flex flex-wrap items-center justify-between gap-3"><p role="status" className="text-xs text-text-secondary">{status || 'Changes save automatically.'}</p><Button disabled={busy} onClick={onClose}>Done</Button></div>}>
    {error && <div role="alert" className="mb-4 grid gap-2"><p className="text-sm">{error}</p><Button variant="secondary" className="justify-self-start" disabled={busy || loading} onClick={() => void load()}>Retry</Button></div>}
    {loading ? <p role="status" className="py-6 text-sm text-text-secondary">Loading preferences…</p> : preferences && <div className="grid gap-5">
      {optional.length ? <table className="w-full table-fixed text-sm">
        <caption className="sr-only">Optional notification delivery channels</caption>
        <thead className="border-b border-border-default text-xs text-text-secondary"><tr><th scope="col" className="w-2/5 pb-3 text-left font-medium">Update</th>{channels.map(channel => <th key={channel.key} scope="col" className="pb-3 text-center font-medium">{channel.label}</th>)}</tr></thead>
        <tbody className="divide-y divide-border-default">{optional.map(preference => <tr key={preference.category}><th scope="row" className="break-words py-2 pr-2 text-left font-medium">{notificationTypeLabel(preference.category)}</th>{channels.map(channel => <td key={channel.key} className="py-2 text-center"><label className="inline-flex h-11 w-11 cursor-pointer items-center justify-center rounded-control hover:bg-surface-canvas"><input type="checkbox" className="h-4 w-4 cursor-pointer accent-action-primary focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring disabled:cursor-not-allowed disabled:opacity-50" checked={preference[channel.key]} disabled={busy} onChange={event => void change(preference, channel.key, event.target.checked)} /><span className="sr-only">{notificationTypeLabel(preference.category)}: {channel.label}</span></label></td>)}</tr>)}</tbody>
      </table> : <p className="text-sm text-text-secondary">No optional preferences are available.</p>}
      {required.length > 0 && <section className="border-t border-border-default pt-4"><div className="flex flex-wrap items-center gap-2"><ShieldCheck size={18} aria-hidden="true" className="shrink-0 text-text-secondary" /><h3 className="text-sm font-semibold">Required notices</h3><span className="ml-auto rounded-control bg-surface-canvas px-2 py-1 text-xs font-medium text-text-secondary">Always enabled</span></div><p className="mt-2 text-xs leading-5 text-text-secondary">Security, legal and transaction notices stay enabled across all channels.</p><details className="mt-1"><summary className="min-h-11 cursor-pointer py-3 text-xs font-medium focus-visible:outline-2 focus-visible:outline-offset-2 focus-visible:outline-focus-ring">View required types</summary><ul className="flex flex-wrap gap-x-4 gap-y-2 pb-2 text-xs text-text-secondary">{required.map(preference => <li key={preference.category}>{notificationTypeLabel(preference.category)}</li>)}</ul></details></section>}
      {enablePush && <div className="flex flex-wrap items-center justify-between gap-3 border-t border-border-default pt-4"><p className="text-xs text-text-secondary">Push delivery requires permission on this browser.</p><Button variant="secondary" disabled={busy} onClick={() => void enableBrowserPush()}>Enable browser notifications</Button></div>}
    </div>}
  </FormDialog>
}
