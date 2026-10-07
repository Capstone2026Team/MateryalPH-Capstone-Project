import { describe, expect, test, vi } from 'vitest'
import { PortalResourceStore } from '../../../../packages/web-ui/src/portal-resource-store'

function deferred<T>() {
  let resolve!: (value: T) => void
  const promise = new Promise<T>(done => { resolve = done })
  return { promise, resolve }
}

describe('portal display snapshots', () => {
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
