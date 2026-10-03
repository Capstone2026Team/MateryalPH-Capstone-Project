import { act, renderHook } from '@testing-library/react'
import { useAutomaticRefresh } from '@materyalph/web-ui'
import { afterEach, beforeEach, expect, it, vi } from 'vitest'

beforeEach(() => {
  vi.useFakeTimers()
  vi.spyOn(document, 'visibilityState', 'get').mockReturnValue('visible')
  vi.spyOn(navigator, 'onLine', 'get').mockReturnValue(true)
})
afterEach(() => { vi.restoreAllMocks(); vi.useRealTimers() })

it('waits for the interval, updates automatically and removes work on unmount', async () => {
  const refresh = vi.fn().mockResolvedValue(undefined)
  const { unmount } = renderHook(() => useAutomaticRefresh(refresh))
  expect(refresh).not.toHaveBeenCalled()
  await act(() => vi.advanceTimersByTimeAsync(30_000))
  expect(refresh).toHaveBeenCalledTimes(1)
  unmount()
  await act(() => vi.advanceTimersByTimeAsync(90_000))
  window.dispatchEvent(new Event('focus'))
  expect(refresh).toHaveBeenCalledTimes(1)
})

it('pauses hidden and offline pages, then updates once when overdue', async () => {
  const visibility = vi.spyOn(document, 'visibilityState', 'get').mockReturnValue('hidden')
  const online = vi.spyOn(navigator, 'onLine', 'get').mockReturnValue(false)
  const refresh = vi.fn().mockResolvedValue(undefined)
  const { unmount } = renderHook(() => useAutomaticRefresh(refresh))
  await act(() => vi.advanceTimersByTimeAsync(90_000))
  expect(refresh).not.toHaveBeenCalled()
  visibility.mockReturnValue('visible')
  document.dispatchEvent(new Event('visibilitychange'))
  expect(refresh).not.toHaveBeenCalled()
  online.mockReturnValue(true)
  await act(async () => {
    window.dispatchEvent(new Event('online'))
    window.dispatchEvent(new Event('focus'))
    document.dispatchEvent(new Event('visibilitychange'))
  })
  expect(refresh).toHaveBeenCalledTimes(1)
  unmount()
})

it('never overlaps a slow request or sends extra requests for rapid focus events', async () => {
  let finish!: () => void
  const refresh = vi.fn(() => new Promise<void>(resolve => { finish = resolve }))
  const { unmount } = renderHook(() => useAutomaticRefresh(refresh))
  await act(() => vi.advanceTimersByTimeAsync(30_000))
  await act(() => vi.advanceTimersByTimeAsync(90_000))
  window.dispatchEvent(new Event('focus'))
  expect(refresh).toHaveBeenCalledTimes(1)
  await act(async () => { finish() })
  window.dispatchEvent(new Event('focus'))
  expect(refresh).toHaveBeenCalledTimes(1)
  await act(() => vi.advanceTimersByTimeAsync(30_000))
  expect(refresh).toHaveBeenCalledTimes(2)
  unmount()
  await act(async () => { finish() })
})

it('respects busy state and a longer failure retry interval', async () => {
  const refresh = vi.fn().mockResolvedValue(undefined)
  const { rerender, unmount } = renderHook(({ enabled, intervalMs }) => useAutomaticRefresh(refresh, { enabled, intervalMs }), { initialProps: { enabled: false, intervalMs: 30_000 } })
  await act(() => vi.advanceTimersByTimeAsync(60_000))
  expect(refresh).not.toHaveBeenCalled()
  rerender({ enabled: true, intervalMs: 120_000 })
  await act(() => vi.advanceTimersByTimeAsync(30_000))
  window.dispatchEvent(new Event('focus'))
  expect(refresh).not.toHaveBeenCalled()
  await act(() => vi.advanceTimersByTimeAsync(90_000))
  expect(refresh).toHaveBeenCalledTimes(1)
  unmount()
})
