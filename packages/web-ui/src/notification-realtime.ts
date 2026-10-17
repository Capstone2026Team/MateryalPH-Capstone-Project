import { NotificationsApi } from '@materyalph/api-client-ts'
import { createWebApiConfiguration } from './web-api-session'
import type { NotificationAudience } from './notifications-workspace'

type Subscription = { listeners: Set<() => void>; stop?: () => void; closed: boolean }
const subscriptions = new Map<string, Subscription>()

/** Components share a socket, but a new session always obtains a new private channel. */
export async function watchNotificationUpdates(basePath: string, audience: NotificationAudience, refresh: () => void): Promise<() => void> {
  const key = `${basePath}|${audience}`
  let entry = subscriptions.get(key)
  if (!entry) {
    entry = { listeners: new Set(), closed: false }
    subscriptions.set(key, entry)
    const current = entry
    const clear = () => {
      current.closed = true
      current.stop?.()
      if (subscriptions.get(key) === current) subscriptions.delete(key)
      window.removeEventListener('materyalph:session-cleared', clear)
    }
    window.addEventListener('materyalph:session-cleared', clear)
    void startNotificationUpdates(basePath, audience, () => current.listeners.forEach(listener => listener())).then(stop => {
      if (current.closed) stop()
      else current.stop = () => { stop(); window.removeEventListener('materyalph:session-cleared', clear) }
    })
  }
  const current = entry
  current.listeners.add(refresh)
  return () => {
    current.listeners.delete(refresh)
    if (current.listeners.size === 0) {
      current.closed = true
      current.stop?.()
      if (subscriptions.get(key) === current) subscriptions.delete(key)
    }
  }
}

/** Private invalidations only; reconnects obtain current account authority before subscribing. */
async function startNotificationUpdates(basePath: string, audience: NotificationAudience, refresh: () => void): Promise<() => void> {
  const api = new NotificationsApi(createWebApiConfiguration(basePath, { refreshSession: true }))
  let closed = false
  let socket: WebSocket | undefined
  let retry: ReturnType<typeof setTimeout> | undefined
  let handshake: ReturnType<typeof setTimeout> | undefined
  let heartbeat: ReturnType<typeof setInterval> | undefined
  let authority: ReturnType<typeof setInterval> | undefined
  let delay = 1000
  let connection = 0
  function disconnect() {
    clearTimeout(handshake)
    clearInterval(heartbeat)
    clearInterval(authority)
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
      let lastReceived = Date.now()
      heartbeat = setInterval(() => {
        if (closed || socket !== current) return
        if (Date.now() - lastReceived > 60_000) reconnect()
        else if (current.readyState === WebSocket.OPEN) current.send(JSON.stringify({ event: 'pusher:ping', data: {} }))
      }, 25_000)
      handshake = setTimeout(reconnect, 15_000)
      current.onclose = reconnect
      current.onerror = reconnect
      current.onmessage = event => {
        void (async () => {
          if (closed || socket !== current) return
          lastReceived = Date.now()
          const message: { event?: string; channel?: string; data?: string | Record<string, unknown> } = JSON.parse(String(event.data))
          const data: Record<string, unknown> = typeof message.data === 'string' ? JSON.parse(message.data) : message.data ?? {}
          if (message.event === 'pusher:connection_established' && typeof data.socket_id === 'string') {
            const signature = await api.authorizeNotificationChannel({ audience, chatChannelAuth: { socketId: data.socket_id, channelName: channel } })
            if (!closed && socket === current && current.readyState === WebSocket.OPEN) current.send(JSON.stringify({ event: 'pusher:subscribe', data: { channel, auth: signature.data.auth } }))
          } else if (message.event === 'pusher:ping') current.send(JSON.stringify({ event: 'pusher:pong', data: {} }))
          else if (message.channel === channel && message.event === 'pusher_internal:subscription_succeeded') {
            clearTimeout(handshake); delay = 1000; refresh()
            clearInterval(authority)
            let checking = false
            authority = setInterval(() => {
              if (checking || closed || socket !== current) return
              checking = true
              void api.getNotificationRealtime({ audience }).then(result => {
                if (closed || socket !== current) return
                const next = result.data
                if (!next.enabled || next.inboxChannel !== target || next.key !== config.key || next.host !== config.host || next.port !== config.port || next.scheme !== config.scheme) reconnect()
              }).catch(() => { if (!closed && socket === current) reconnect() }).finally(() => { checking = false })
            }, 30_000)
          }
          else if (message.channel === channel && ['notifications.changed', 'navigation.changed'].includes(message.event ?? '')) refresh()
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
