import { NotificationsApi } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from './web-api-session'
import type { NotificationAudience } from './notifications-workspace'

/** Private invalidations only; reconnects obtain current account authority before subscribing. */
export async function watchNotificationUpdates(basePath: string, audience: NotificationAudience, refresh: () => void): Promise<() => void> {
  const api = new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true }))
  let closed = false
  let socket: WebSocket | undefined
  let retry: ReturnType<typeof setTimeout> | undefined
  let handshake: ReturnType<typeof setTimeout> | undefined
  let delay = 1000
  let connection = 0
  function disconnect() {
    clearTimeout(handshake)
    if (socket) { socket.onclose = null; socket.onerror = null; socket.onmessage = null; socket.close(); socket = undefined }
  }
  function reconnect() {
    if (closed || retry) return
    connection++
    disconnect()
    retry = setTimeout(() => { retry = undefined; void connect() }, delay)
    delay = Math.min(delay * 2, 30_000)
  }
  async function connect() {
    const epoch = ++connection
    try {
      const config = (await api.getNotificationRealtime({ audience })).data
      if (closed || epoch !== connection) return
      const target = config.inboxChannel
      if (!config.enabled || !config.key || !config.host || !target) { delay = 30_000; reconnect(); return }
      const channel = `private-${target}`
      const current = new WebSocket(`${config.scheme === 'https' ? 'wss' : 'ws'}://${config.host}:${config.port}/app/${encodeURIComponent(config.key)}?protocol=7&client=materyalph&version=1.0`)
      socket = current
      handshake = setTimeout(reconnect, 15_000)
      current.onclose = reconnect
      current.onerror = reconnect
      current.onmessage = event => {
        void (async () => {
          if (closed || socket !== current) return
          const message: { event?: string; channel?: string; data?: string | Record<string, unknown> } = JSON.parse(String(event.data))
          const data: Record<string, unknown> = typeof message.data === 'string' ? JSON.parse(message.data) : message.data ?? {}
          if (message.event === 'pusher:connection_established' && typeof data.socket_id === 'string') {
            const signature = await api.authorizeNotificationChannel({ audience, chatChannelAuth: { socketId: data.socket_id, channelName: channel } })
            if (!closed && socket === current && current.readyState === WebSocket.OPEN) current.send(JSON.stringify({ event: 'pusher:subscribe', data: { channel, auth: signature.data.auth } }))
          } else if (message.event === 'pusher:ping') current.send(JSON.stringify({ event: 'pusher:pong', data: {} }))
          else if (message.channel === channel && message.event === 'pusher_internal:subscription_succeeded') { clearTimeout(handshake); delay = 1000; refresh() }
          else if (message.channel === channel && message.event === 'notifications.changed') refresh()
          else if (message.event === 'pusher:error') reconnect()
        })().catch(() => { if (!closed && socket === current) reconnect() })
      }
    } catch { if (!closed && epoch === connection) reconnect() }
  }
  const online = () => { if (closed) return; refresh(); reconnect() }
  const visible = () => { if (document.visibilityState === 'visible') online() }
  const stop = () => {
    closed = true; connection++; clearTimeout(retry); disconnect()
    window.removeEventListener('online', online)
    window.removeEventListener('materyalph:session-cleared', stop)
    document.removeEventListener('visibilitychange', visible)
  }
  window.addEventListener('online', online)
  window.addEventListener('materyalph:session-cleared', stop)
  document.addEventListener('visibilitychange', visible)
  void connect()
  return stop
}
