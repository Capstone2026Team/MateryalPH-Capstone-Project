import { act, renderHook } from '@testing-library/react'
import { afterEach, beforeEach, expect, it, vi } from 'vitest'
import { NotificationsApi } from '@materyalph/api-client-ts'
import { PortalResourceProvider } from '../../../../packages/web-ui/src/portal-resources'
import { useNavigationUpdates } from '../../../../packages/web-ui/src/use-navigation-updates'
import { useNotificationUnreadCount } from '../../../../packages/web-ui/src/use-notification-unread-count'

const live = vi.hoisted(() => ({ receive: undefined as (() => void) | undefined, stop: vi.fn() }))
vi.mock('../../../../packages/web-ui/src/notification-realtime', () => ({ watchNotificationUpdates: async (_base: string, _audience: string, callback: () => void) => { live.receive = callback; return live.stop } }))
const options = { basePath: 'https://api.example.test/api/v1', audience: 'vendor' as const }
const response = (messages: number, notices: number, orders = 2) => ({ data: { sections: { '/messages': messages, '/notifications': notices, '/orders': orders } }, meta: {}, errors: [] })
const flush = async (ms = 0) => { await act(async () => { await vi.advanceTimersByTimeAsync(ms) }) }
beforeEach(() => { vi.useFakeTimers(); live.receive = undefined; live.stop.mockClear() })
afterEach(() => { window.dispatchEvent(new Event('materyalph:session-cleared')); vi.restoreAllMocks(); vi.useRealTimers() })

it('updates messaging and pending counters on incoming events before any destination is opened', async () => {
  const load = vi.spyOn(NotificationsApi.prototype, 'getNavigationUpdates').mockResolvedValueOnce(response(0, 0)).mockResolvedValue(response(3, 1, 5))
  const hook = renderHook(() => useNavigationUpdates(options), { wrapper: PortalResourceProvider })
  await flush()
  expect(hook.result.current?.['/messages']).toBe(0)
  for (let i = 0; i < 20; i++) live.receive?.()
  await flush(100)
  expect(hook.result.current).toEqual(response(3, 1, 5).data.sections)
  expect(load).toHaveBeenCalledTimes(2)
  hook.unmount()
})

it('synchronizes all mounted consumers and clears messages after a successful read action', async () => {
  vi.spyOn(NotificationsApi.prototype, 'getNavigationUpdates').mockResolvedValueOnce(response(2, 4)).mockResolvedValue(response(0, 4))
  const hook = renderHook(() => ({ sections: useNavigationUpdates(options), unread: useNotificationUnreadCount(options) }), { wrapper: PortalResourceProvider })
  await flush()
  expect(hook.result.current.unread).toBe(4)
  window.dispatchEvent(new CustomEvent('materyalph:navigation-updates', { detail: { audience: 'vendor', basePath: options.basePath } }))
  await flush(100)
  expect(hook.result.current.sections?.['/messages']).toBe(0)
  expect(hook.result.current.unread).toBe(hook.result.current.sections?.['/notifications'])
  hook.unmount()
})

it('refetches when an event arrives during initial loading and does not accept another audience', async () => {
  let complete!: (result: ReturnType<typeof response>) => void
  const load = vi.spyOn(NotificationsApi.prototype, 'getNavigationUpdates').mockReturnValueOnce(new Promise(resolve => { complete = resolve })).mockResolvedValue(response(2, 1))
  const hook = renderHook(() => useNavigationUpdates(options), { wrapper: PortalResourceProvider })
  await flush()
  window.dispatchEvent(new CustomEvent('materyalph:navigation-updates', { detail: { audience: 'admin' } }))
  await flush(100)
  expect(load).toHaveBeenCalledTimes(1)
  live.receive?.()
  await flush(100)
  complete(response(1, 0))
  await flush()
  expect(hook.result.current?.['/messages']).toBe(2)
  expect(load).toHaveBeenCalledTimes(2)
  hook.unmount()
})

it('recovers missed events through polling and clears an old account snapshot on logout', async () => {
  const load = vi.spyOn(NotificationsApi.prototype, 'getNavigationUpdates').mockResolvedValueOnce(response(1, 1)).mockResolvedValue(response(0, 0))
  const hook = renderHook(() => useNavigationUpdates(options), { wrapper: PortalResourceProvider })
  await flush()
  await flush(15_000)
  expect(hook.result.current?.['/messages']).toBe(0)
  expect(load).toHaveBeenCalledTimes(2)
  act(() => { window.dispatchEvent(new Event('materyalph:session-cleared')) })
  expect(hook.result.current).toBeNull()
  live.receive?.()
  await flush(30_000)
  expect(load).toHaveBeenCalledTimes(2)
  hook.unmount()
})
