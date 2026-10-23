import { act, renderHook } from '@testing-library/react'
import { ResponseError } from '@materyalph/api-client-ts'
import { afterEach, beforeEach, expect, it, vi } from 'vitest'
import { useAnalyticsResource } from './use-analytics-resource'

beforeEach(() => {
  vi.useFakeTimers()
  vi.spyOn(document, 'visibilityState', 'get').mockReturnValue('visible')
  vi.spyOn(navigator, 'onLine', 'get').mockReturnValue(true)
})
afterEach(() => { vi.restoreAllMocks(); vi.useRealTimers() })

it('fetches new values automatically without clearing the displayed data during a refresh', async () => {
  let finish!: (value: number) => void
  const load = vi.fn().mockResolvedValueOnce(4).mockImplementationOnce(() => new Promise<number>(resolve => { finish = resolve }))
  const { result, unmount } = renderHook(() => useAnalyticsResource('geo', load))
  await act(async () => {})
  expect(result.current.data).toBe(4)
  await act(() => vi.advanceTimersByTimeAsync(30_000))
  expect(load).toHaveBeenCalledTimes(2)
  expect(result.current.data).toBe(4)
  await act(() => vi.advanceTimersByTimeAsync(60_000))
  expect(load).toHaveBeenCalledTimes(2)
  await act(async () => { finish(8) })
  expect(result.current.data).toBe(8)
  unmount()
  await act(() => vi.advanceTimersByTimeAsync(60_000))
  expect(load).toHaveBeenCalledTimes(2)
})

it('keeps an old filter response from replacing the current area', async () => {
  let finish!: (value: number) => void
  const previous = vi.fn(() => new Promise<number>(resolve => { finish = resolve }))
  const current = vi.fn().mockResolvedValue(12)
  const { result, rerender } = renderHook(({ area }) => useAnalyticsResource(`geo-${area}`, area === 'previous' ? previous : current), { initialProps: { area: 'previous' } })
  await act(async () => {})
  rerender({ area: 'current' })
  await act(async () => {})
  expect(result.current.data).toBe(12)
  await act(async () => { finish(4) })
  expect(result.current.data).toBe(12)
  await act(() => vi.advanceTimersByTimeAsync(30_000))
  expect(current).toHaveBeenCalledTimes(2)
})

it('pauses offline and hidden workspaces and fetches current data on return', async () => {
  const load = vi.fn().mockResolvedValue(4)
  const { result } = renderHook(() => useAnalyticsResource('materials', load))
  await act(async () => {})
  const online = vi.spyOn(navigator, 'onLine', 'get').mockReturnValue(false)
  const visibility = vi.spyOn(document, 'visibilityState', 'get').mockReturnValue('hidden')
  await act(() => vi.advanceTimersByTimeAsync(60_000))
  expect(load).toHaveBeenCalledTimes(1)
  load.mockResolvedValue(8)
  online.mockReturnValue(true)
  visibility.mockReturnValue('visible')
  await act(async () => { window.dispatchEvent(new Event('online')) })
  expect(result.current.data).toBe(8)
})

it('clears revoked data and backs off before retrying', async () => {
  const denied = new ResponseError(new Response(JSON.stringify({ data: null, meta: {}, errors: [{ code: 'FORBIDDEN', message: 'Aggregate access was revoked.' }] }), { status: 403, headers: { 'Content-Type': 'application/json' } }))
  const load = vi.fn().mockResolvedValueOnce(4).mockRejectedValue(denied)
  const { result } = renderHook(() => useAnalyticsResource('materials', load))
  await act(async () => {})
  await act(() => vi.advanceTimersByTimeAsync(30_000))
  expect(result.current.data).toBeNull()
  expect(result.current.error).toBeTruthy()
  await act(() => vi.advanceTimersByTimeAsync(119_000))
  expect(load).toHaveBeenCalledTimes(2)
  await act(() => vi.advanceTimersByTimeAsync(1_000))
  expect(load).toHaveBeenCalledTimes(3)
})
