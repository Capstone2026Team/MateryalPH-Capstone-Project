export type ResourceState<T> = { data: T | null; error: unknown; pending: boolean }
const empty: ResourceState<never> = { data: null, error: null, pending: false }
type Entry = { state: ResourceState<unknown>; updatedAt: number; request?: Promise<void> }

/** Short-lived display snapshots belonging to one mounted, signed-in portal. Never authorization. */
export class PortalResourceStore {
  private entries = new Map<string, Entry>()
  private listeners = new Set<() => void>()
  private generation = 0
  private invalidations = new Map<string, Promise<void>>()
  private mounted = new Map<string, number>()

  constructor(private readonly now = Date.now, private readonly maxAge = 30_000) {}

  subscribe = (listener: () => void) => {
    this.listeners.add(listener)
    return () => { this.listeners.delete(listener) }
  }

  read<T>(key: string): ResourceState<T> {
    const entry = this.entries.get(key)
    if (!entry) return empty
    return entry.state as ResourceState<T>
  }

  private emit() { this.listeners.forEach(listener => listener()) }

  retain(key: string): () => void {
    this.mounted.set(key, (this.mounted.get(key) ?? 0) + 1)
    return () => {
      const remaining = (this.mounted.get(key) ?? 1) - 1
      if (remaining > 0) this.mounted.set(key, remaining)
      else this.mounted.delete(key)
    }
  }

  clear = () => {
    this.generation++
    this.entries.clear()
    this.invalidations.clear()
    this.emit()
  }

  rejectAll(error: unknown) {
    this.generation++
    for (const key of this.entries.keys()) {
      this.entries.set(key, { state: { data: null, error, pending: false }, updatedAt: this.now() })
    }
    this.emit()
  }

  publish<T>(key: string, update: T | ((previous: T | null) => T)) {
    const previous = this.entries.get(key)
    const data = typeof update === 'function'
      ? (update as (previous: T | null) => T)((previous?.state.data as T | null) ?? null)
      : update
    this.entries.set(key, { state: { data, error: null, pending: false }, updatedAt: this.now(), ...(previous?.request ? { request: previous.request } : {}) })
    this.emit()
  }

  /** An event during a GET must fetch again after that response, rather than lose the invalidation. */
  synchronize<T>(key: string, loader: () => Promise<T>): Promise<void> {
    const queued = this.invalidations.get(key)
    if (queued) return queued
    const request = this.entries.get(key)?.request
    if (!request) return this.load(key, loader)
    const generation = this.generation
    const next = request.then(() => { if (generation === this.generation) return this.load(key, loader) }).finally(() => {
      if (this.invalidations.get(key) === next) this.invalidations.delete(key)
    })
    this.invalidations.set(key, next)
    return next
  }

  load<T>(key: string, loader: () => Promise<T>, retainExpired = true): Promise<void> {
    const existing = this.entries.get(key)
    if (existing?.request) return existing.request
    const generation = this.generation
    const data = existing && (retainExpired || this.now() - existing.updatedAt <= this.maxAge) ? this.read<T>(key).data : null
    const entry: Entry = { state: { data, error: null, pending: true }, updatedAt: this.now() }
    this.entries.set(key, entry)
    // Bound reusable snapshots without evicting mounted counters/read models or active requests.
    if (this.entries.size > 20) {
      const oldest = [...this.entries].find(([candidate, value]) => candidate !== key && !this.mounted.has(candidate) && !value.state.pending)
      if (oldest) this.entries.delete(oldest[0])
    }
    const current = () => this.generation === generation && this.entries.get(key) === entry
    entry.request = Promise.resolve().then(loader).then(data => {
      if (current()) { entry.state = { data, error: null, pending: false }; entry.updatedAt = this.now() }
    }).catch((error: unknown) => {
      if (current()) { entry.state = { data: null, error, pending: false }; entry.updatedAt = this.now() }
    }).finally(() => {
      const snapshot = this.entries.get(key)
      if (snapshot?.request === entry.request && snapshot) delete snapshot.request
      if (current()) this.emit()
    })
    this.emit()
    return entry.request
  }
}
