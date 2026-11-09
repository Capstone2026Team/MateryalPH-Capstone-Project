import { EventEmitter } from 'node:events'
import { afterEach, expect, test, vi } from 'vitest'
import { watchGeneratedApiClient } from '../../../../packages/shared-config/vite-api-client.mjs'

afterEach(() => vi.useRealTimers())

test('coalesces generated client writes and ignores unrelated files', () => {
  vi.useFakeTimers()
  const watcher = Object.assign(new EventEmitter(), { add: vi.fn() })
  const refresh = vi.fn()
  const stop = watchGeneratedApiClient(watcher, 'C:\\client\\esm', refresh)
  expect(watcher.add).toHaveBeenCalledWith('C:\\client\\esm')
  watcher.emit('change', 'C:/client/esm-extra/model.js')
  watcher.emit('change', 'C:/client/esm/model.d.ts')
  vi.advanceTimersByTime(1000)
  expect(refresh).not.toHaveBeenCalled()
  watcher.emit('add', 'C:/client/esm/api.js')
  vi.advanceTimersByTime(900)
  watcher.emit('change', 'C:\\client\\esm\\model.js')
  vi.advanceTimersByTime(900)
  expect(refresh).not.toHaveBeenCalled()
  vi.advanceTimersByTime(100)
  expect(refresh).toHaveBeenCalledOnce()
  watcher.emit('unlink', 'C:/client/esm/api.js')
  stop()
  vi.advanceTimersByTime(1000)
  expect(refresh).toHaveBeenCalledOnce()
  expect(watcher.listenerCount('change')).toBe(0)
})
