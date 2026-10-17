import { describe, expect, test, vi } from 'vitest'
import { PortalResourceStore } from '../../../../packages/web-ui/src/portal-resource-store'

function deferred<T>() {
  let resolve!: (value: T) => void
  const promise = new Promise<T>(done => { resolve = done })
  return { promise, resolve }
}

describe('portal display snapshots', () => {
  test('a read action preserves the pending GET barrier before fetching its authoritative remaining count', async () => {
    const store = new PortalResourceStore()
    const old = deferred<number>()
    void store.load('counts', () => old.promise)
    store.publish('counts', 0)
    const loader = vi.fn(async () => 0)
    const synchronize = store.synchronize('counts', loader)
    await Promise.resolve()
    expect(loader).not.toHaveBeenCalled()
    old.resolve(2)
    await synchronize
    expect(loader).toHaveBeenCalledTimes(1)
    expect(store.read('counts').data).toBe(0)
  })
  test('keeps mounted badges synchronized while many navigation/filter snapshots accumulate', async () => {
    const store = new PortalResourceStore()
    const release = store.retain('vendor-navigation-updates')
    store.publish('vendor-navigation-updates', { '/messages': 3 })
    for (let i = 0; i < 25; i++) await store.load(`filtered-orders-${i}`, async () => i)
    expect(store.read('vendor-navigation-updates').data).toEqual({ '/messages': 3 })
    release()
    await store.load('another-page', async () => 1)
    expect(store.read('vendor-navigation-updates').data).toBeNull()
  })
  test('coalesces events during a GET and synchronizes once after its stale response', async () => {
    const store = new PortalResourceStore()
    const initial = deferred<number>()
    const load = store.load('counts', () => initial.promise)
    const loader = vi.fn(async () => 4)
    const next = store.synchronize('counts', loader)
    expect(store.synchronize('counts', loader)).toBe(next)
    initial.resolve(1)
    await load
    await next
    expect(loader).toHaveBeenCalledTimes(1)
    expect(store.read('counts').data).toBe(4)
  })

  test('does not run a queued invalidation after the session is cleared', async () => {
    const store = new PortalResourceStore()
    const initial = deferred<number>()
    void store.load('counts', () => initial.promise)
    const loader = vi.fn(async () => 4)
    const next = store.synchronize('counts', loader)
    store.clear()
    initial.resolve(1)
    await next
    expect(loader).not.toHaveBeenCalled()
    expect(store.read('counts').data).toBeNull()
  })
  test('shares concurrent loads and retains data during navigation revalidation', async () => {
    const store = new PortalResourceStore()
    const first = deferred<string>()
    const loader = vi.fn(() => first.promise)
    const request = store.load('orders', loader)
    expect(store.load('orders', loader)).toBe(request)
    await Promise.resolve()
    expect(loader).toHaveBeenCalledTimes(1)
    first.resolve('first')
    await request
    const second = deferred<string>()
    const refresh = store.load('orders', () => second.promise)
    expect(store.read('orders')).toMatchObject({ data: 'first', pending: true })
    second.resolve('updated')
    await refresh
    expect(store.read('orders').data).toBe('updated')
  })

  test('never restores an old response after logout or a newer mutation snapshot', async () => {
    const store = new PortalResourceStore()
    const old = deferred<string>()
    const request = store.load('vendor', () => old.promise)
    store.clear()
    old.resolve('previous-account')
    await request
    expect(store.read('vendor').data).toBeNull()
    const pending = deferred<string>()
    const refresh = store.load('vendor', () => pending.promise)
    store.publish('vendor', 'saved')
    pending.resolve('before-save')
    await refresh
    expect(store.read('vendor').data).toBe('saved')
  })

  test('clears private snapshots on denied access and ignores requests still in flight', async () => {
    const store = new PortalResourceStore()
    store.publish('dashboard', 'private')
    const pending = deferred<string>()
    const request = store.load('queue', () => pending.promise)
    const denial = new Error('Access denied')
    store.rejectAll(denial)
    pending.resolve('no-longer-authorized')
    await request
    expect(store.read('dashboard')).toMatchObject({ data: null, error: denial })
    expect(store.read('queue')).toMatchObject({ data: null, error: denial })
  })

  test('expires reused data on later loads and isolates filter keys and portal instances', async () => {
    let now = 0
    const store = new PortalResourceStore(() => now)
    store.publish('queue:pending', 'pending')
    expect(store.read('queue:approved').data).toBeNull()
    expect(new PortalResourceStore().read('queue:pending').data).toBeNull()
    now = 30_001
    const response = deferred<string>()
    const request = store.load('queue:pending', () => response.promise, false)
    expect(store.read('queue:pending').data).toBeNull()
    response.resolve('current')
    await request
    await store.load('queue:pending', () => Promise.reject(new Error('Offline')))
    expect(store.read('queue:pending').data).toBeNull()
    expect(store.read('queue:pending').error).toBeInstanceOf(Error)
  })

  test('background polling retains the visible snapshot after the navigation reuse window', async () => {
    let now = 0
    const store = new PortalResourceStore(() => now)
    store.publish('dashboard', 'visible')
    now = 60_000
    const response = deferred<string>()
    const request = store.load('dashboard', () => response.promise)
    expect(store.read('dashboard')).toMatchObject({ data: 'visible', pending: true })
    response.resolve('fresh')
    await request
    expect(store.read('dashboard').data).toBe('fresh')
  })
})
