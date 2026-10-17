import { afterEach, beforeEach, describe, expect, it, vi } from 'vitest'
import { NotificationsApi } from '@materyalph/api-client-ts'
import { watchNotificationUpdates } from '../../../../packages/web-ui/src/notification-realtime'

class TestSocket {
  static OPEN = 1
  static instances: TestSocket[] = []
  readyState = 1
  onmessage: ((event: MessageEvent) => void) | null = null
  onclose: (() => void) | null = null
  onerror: (() => void) | null = null
  send = vi.fn()
  close = vi.fn(() => { this.readyState = 3 })
  constructor(readonly url: string) { TestSocket.instances.push(this) }
  receive(event: string, channel?: string, data: Record<string, unknown> = {}) {
    this.onmessage?.({ data: JSON.stringify({ event, channel, data }) } as MessageEvent)
  }
}
const config = (channel = 'notifications.current') => ({ data: { enabled: true, key: 'synthetic-public-app-key', host: 'realtime.example.test', port: 443, scheme: 'https', inboxChannel: channel }, meta: {}, errors: [] })
const flush = () => vi.advanceTimersByTimeAsync(0)

beforeEach(() => { vi.useFakeTimers(); TestSocket.instances = []; vi.stubGlobal('WebSocket', TestSocket) })
afterEach(() => { window.dispatchEvent(new Event('materyalph:session-cleared')); vi.restoreAllMocks(); vi.unstubAllGlobals(); vi.useRealTimers() })

describe('private notification realtime transport', () => {
  it('rotates a still-connected socket when the current account authority changes', async () => {
    vi.spyOn(NotificationsApi.prototype, 'getNotificationRealtime').mockResolvedValueOnce(config('notifications.old')).mockResolvedValue(config('notifications.new'))
    const stop = await watchNotificationUpdates('https://api.example.test/api/v1', 'vendor', vi.fn())
    await flush()
    const old = TestSocket.instances[0]!
    old.receive('pusher_internal:subscription_succeeded', 'private-notifications.old')
    await vi.advanceTimersByTimeAsync(31_000)
    expect(old.close).toHaveBeenCalledTimes(1)
    expect(TestSocket.instances).toHaveLength(2)
    stop()
  })
  it('shares the private socket across counters and refreshes only on the current navigation channel', async () => {
    vi.spyOn(NotificationsApi.prototype, 'getNotificationRealtime').mockResolvedValue(config())
    const first = vi.fn(), second = vi.fn()
    const stopFirst = await watchNotificationUpdates('https://api.example.test/api/v1', 'vendor', first)
    const stopSecond = await watchNotificationUpdates('https://api.example.test/api/v1', 'vendor', second)
    await flush()
    expect(TestSocket.instances).toHaveLength(1)
    const socket = TestSocket.instances[0]!
    socket.receive('navigation.changed', 'private-notifications.foreign')
    socket.receive('navigation.changed', 'private-notifications.current')
    await flush()
    expect(first).toHaveBeenCalledTimes(1)
    expect(second).toHaveBeenCalledTimes(1)
    stopFirst()
    expect(socket.close).not.toHaveBeenCalled()
    stopSecond()
    expect(socket.close).toHaveBeenCalledTimes(1)
  })

  it('recovers a silent socket through heartbeats and reauthorizes its channel', async () => {
    const load = vi.spyOn(NotificationsApi.prototype, 'getNotificationRealtime').mockResolvedValue(config())
    const stop = await watchNotificationUpdates('https://api.example.test/api/v1', 'vendor', vi.fn())
    await flush()
    const socket = TestSocket.instances[0]!
    socket.receive('pusher_internal:subscription_succeeded', 'private-notifications.current')
    await vi.advanceTimersByTimeAsync(76_000)
    expect(socket.send.mock.calls.some(([payload]) => JSON.parse(payload).event === 'pusher:ping')).toBe(true)
    expect(socket.close).toHaveBeenCalledTimes(1)
    expect(load.mock.calls.length).toBeGreaterThanOrEqual(2)
    stop()
  })
  it('authorizes the current account channel and accepts only its notification invalidations', async () => {
    vi.spyOn(NotificationsApi.prototype, 'getNotificationRealtime').mockResolvedValue(config())
    const auth = vi.spyOn(NotificationsApi.prototype, 'authorizeNotificationChannel').mockResolvedValue({ data: { auth: 'synthetic-signature' }, meta: {}, errors: [] })
    const refresh = vi.fn()
    const stop = await watchNotificationUpdates('https://api.example.test/api/v1', 'admin', refresh)
    await flush()
    const socket = TestSocket.instances[0]!
    expect(socket.url).toContain('wss://realtime.example.test:443/app/')
    socket.receive('pusher:connection_established', undefined, { socket_id: '10.20' })
    await flush()
    expect(auth).toHaveBeenCalledWith({ audience: 'admin', chatChannelAuth: { socketId: '10.20', channelName: 'private-notifications.current' } })
    expect(JSON.parse(socket.send.mock.calls[0]![0])).toEqual({ event: 'pusher:subscribe', data: { channel: 'private-notifications.current', auth: 'synthetic-signature' } })
    socket.receive('pusher_internal:subscription_succeeded', 'private-notifications.current')
    socket.receive('notifications.changed', 'private-notifications.foreign')
    socket.receive('conversation.changed', 'private-notifications.current')
    await flush()
    expect(refresh).toHaveBeenCalledTimes(1)
    socket.receive('notifications.changed', 'private-notifications.current')
    await flush()
    expect(refresh).toHaveBeenCalledTimes(2)
    stop()
    expect(socket.close).toHaveBeenCalledTimes(1)
  })

  it('does not open a socket when cleanup occurs during configuration setup', async () => {
    let resolve!: (value: Awaited<ReturnType<NotificationsApi['getNotificationRealtime']>>) => void
    vi.spyOn(NotificationsApi.prototype, 'getNotificationRealtime').mockReturnValue(new Promise(done => { resolve = done }))
    const stop = await watchNotificationUpdates('https://api.example.test/api/v1', 'vendor', vi.fn())
    stop(); resolve(config())
    await flush()
    expect(TestSocket.instances).toEqual([])
  })

  it('does not subscribe after an in-flight authorization completes for a closed session', async () => {
    vi.spyOn(NotificationsApi.prototype, 'getNotificationRealtime').mockResolvedValue(config())
    let resolve!: (value: Awaited<ReturnType<NotificationsApi['authorizeNotificationChannel']>>) => void
    vi.spyOn(NotificationsApi.prototype, 'authorizeNotificationChannel').mockReturnValue(new Promise(done => { resolve = done }))
    await watchNotificationUpdates('https://api.example.test/api/v1', 'admin', vi.fn())
    await flush()
    const socket = TestSocket.instances[0]!
    socket.receive('pusher:connection_established', undefined, { socket_id: '10.20' })
    await flush()
    window.dispatchEvent(new Event('materyalph:session-cleared'))
    resolve({ data: { auth: 'synthetic-signature' }, meta: {}, errors: [] })
    await flush()
    expect(socket.close).toHaveBeenCalledTimes(1)
    expect(socket.send).not.toHaveBeenCalled()
  })

  it('obtains a fresh channel on reconnect and cancels further reconnects on cleanup', async () => {
    const load = vi.spyOn(NotificationsApi.prototype, 'getNotificationRealtime').mockResolvedValueOnce(config('notifications.old')).mockResolvedValue(config('notifications.new'))
    const stop = await watchNotificationUpdates('https://api.example.test/api/v1', 'vendor', vi.fn())
    await flush()
    TestSocket.instances[0]!.onerror?.()
    await vi.advanceTimersByTimeAsync(1000)
    expect(load).toHaveBeenCalledTimes(2)
    expect(TestSocket.instances).toHaveLength(2)
    stop()
    await vi.advanceTimersByTimeAsync(60_000)
    expect(load).toHaveBeenCalledTimes(2)
  })

  it('keeps the new connection when authorization on an older socket fails late', async () => {
    vi.spyOn(NotificationsApi.prototype, 'getNotificationRealtime').mockResolvedValue(config())
    let reject!: (error: Error) => void
    vi.spyOn(NotificationsApi.prototype, 'authorizeNotificationChannel').mockReturnValue(new Promise((_resolve, fail) => { reject = fail }))
    const stop = await watchNotificationUpdates('https://api.example.test/api/v1', 'admin', vi.fn())
    await flush()
    TestSocket.instances[0]!.receive('pusher:connection_established', undefined, { socket_id: '10.20' })
    await flush()
    TestSocket.instances[0]!.onerror?.()
    await vi.advanceTimersByTimeAsync(1000)
    const current = TestSocket.instances[1]!
    reject(new Error('Old authorization failed'))
    await flush()
    expect(current.close).not.toHaveBeenCalled()
    stop()
  })
})
