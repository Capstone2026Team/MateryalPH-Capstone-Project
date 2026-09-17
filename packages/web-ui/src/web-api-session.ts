import { Configuration, ResponseError } from '@materyalph/api-client-ts'

type WebApiOptions = {
  refreshSession?: boolean
}

const csrfTokens = new Map<string, string>()
const csrfRequests = new Map<string, Promise<string>>()
const refreshRequests = new Map<string, Promise<RefreshResult>>()
const reads = new Map<string, Promise<Response>>()
const mutations = new Set<string>()
const cooldowns = new Map<string, { until: number; response: Response }>()

export function rateLimitMessage(response: Response): string {
  const seconds = retryAfterSeconds(response)
  return `This action is temporarily limited. Try again in ${seconds} seconds (after ${new Date(Date.now() + seconds * 1000).toLocaleTimeString('en-PH', { timeZone: 'Asia/Manila' })} Asia/Manila). Your session is still active; no automatic retry will be sent.`
}

function retryAfterSeconds(response: Response): number {
  const value = response.headers.get('Retry-After')
  if (value && /^\d+$/.test(value)) return Math.max(1, Number(value))
  const date = value ? Date.parse(value) : NaN
  return Number.isFinite(date) ? Math.max(1, Math.ceil((date - Date.now()) / 1000)) : 60
}

type RefreshResult =
  | { kind: 'refreshed' }
  | { kind: 'invalid' }
  | { kind: 'response'; response: Response }

function normalizedBasePath(basePath: string): string {
  return basePath.replace(/\/+$/, '')
}

async function issueCsrfToken(basePath: string): Promise<string> {
  const response = await fetch(`${basePath}/auth/csrf`, {
    method: 'GET',
    credentials: 'include',
    headers: { Accept: 'application/json' },
  })
  if (!response.ok) throw new ResponseError(response)

  const payload: unknown = await response.json()
  const token = csrfTokenFrom(payload)
  if (!token) throw new Error('The security token response was invalid. Refresh the page and try again.')
  csrfTokens.set(basePath, token)
  return token
}

export function getWebCsrfToken(basePath: string, force = false): Promise<string> {
  const key = normalizedBasePath(basePath)
  if (force) csrfTokens.delete(key)
  const cached = csrfTokens.get(key)
  if (cached) return Promise.resolve(cached)

  const current = csrfRequests.get(key)
  if (current) return current

  const request = issueCsrfToken(key).finally(() => csrfRequests.delete(key))
  csrfRequests.set(key, request)
  return request
}

export function clearWebSessionTransport(basePath?: string): void {
  reads.clear()
  cooldowns.clear()
  if (basePath) {
    const key = normalizedBasePath(basePath)
    csrfTokens.delete(key)
    csrfRequests.delete(key)
    refreshRequests.delete(key)
    return
  }
  csrfTokens.clear()
  csrfRequests.clear()
  refreshRequests.clear()
}

export function createWebApiConfiguration(basePath: string, options: WebApiOptions = {}): Configuration {
  const key = normalizedBasePath(basePath)
  return new Configuration({
    basePath: key,
    credentials: 'include',
    apiKey: () => getWebCsrfToken(key),
    fetchApi: (input, init) => coordinatedFetch(key, Boolean(options.refreshSession), input, init),
  })
}

async function coordinatedFetch(basePath: string, refreshSession: boolean, input: RequestInfo | URL, init?: RequestInit): Promise<Response> {
  const method = (init?.method ?? (input instanceof Request ? input.method : 'GET')).toUpperCase()
  const url = input instanceof Request ? input.url : String(input)
  const key = `${basePath}|${method}|${url}`
  const cooldown = cooldowns.get(key)
  if (cooldown && cooldown.until > Date.now()) {
    const headers = new Headers(cooldown.response.headers)
    headers.set('Retry-After', String(Math.ceil((cooldown.until - Date.now()) / 1000)))
    return new Response(await cooldown.response.clone().text(), { status: 429, headers })
  }
  cooldowns.delete(key)
  // Share only simultaneous ordinary GETs; never cache account/permission data.
  const shareRead = method === 'GET' && !init?.signal && !(input instanceof Request) && !new Headers(init?.headers).has('Authorization')
  const readKey = `${key}|${refreshSession}|${JSON.stringify(Array.from(new Headers(init?.headers).entries()))}`
  const current = shareRead ? reads.get(readKey) : undefined
  if (current) return (await current).clone()
  const mutation = !isSafeMethod(method)
  if (mutation && mutations.has(key)) throw new Error('This action is already processing. Please wait for it to finish.')
  if (mutation) mutations.add(key)
  const request = webFetch(basePath, refreshSession, input, init).then(response => {
    if (response.status === 429 && response.headers.has('Retry-After')) {
      const until = Date.now() + retryAfterSeconds(response) * 1000
      cooldowns.set(key, { until, response: response.clone() })
      if (typeof window !== 'undefined') window.dispatchEvent(new CustomEvent('materyalph:rate-limited', { detail: { until } }))
    }
    return response
  }).finally(() => { if (reads.get(readKey) === request) reads.delete(readKey); if (mutation) mutations.delete(key) })
  if (shareRead) reads.set(readKey, request)
  return (await request).clone()
}

async function webFetch(basePath: string, refreshSession: boolean, input: RequestInfo | URL, init?: RequestInit): Promise<Response> {
  let response = await fetch(input, init)

  if (response.status === 419 && !isSafeMethod(init?.method)) {
    const token = await getWebCsrfToken(basePath, true)
    response = await fetch(input, withCsrf(init, token))
  }

  if (response.status !== 401 || !refreshSession || isAuthenticationLifecycleRequest(input, basePath)) {
    return response
  }

  const refreshed = await refreshWebSession(basePath)
  if (refreshed.kind === 'invalid') return response
  if (refreshed.kind === 'response') return refreshed.response.clone()
  return fetch(input, init)
}

async function refreshWebSession(basePath: string): Promise<RefreshResult> {
  const current = refreshRequests.get(basePath)
  if (current) return current

  const request = performRefresh(basePath).finally(() => refreshRequests.delete(basePath))
  refreshRequests.set(basePath, request)
  return request
}

async function performRefresh(basePath: string): Promise<RefreshResult> {
  let token = await getWebCsrfToken(basePath)
  let response = await fetch(`${basePath}/auth/refresh`, withCsrf({
    method: 'POST',
    credentials: 'include',
    headers: { Accept: 'application/json' },
  }, token))

  if (response.status === 419) {
    token = await getWebCsrfToken(basePath, true)
    response = await fetch(`${basePath}/auth/refresh`, withCsrf({
      method: 'POST',
      credentials: 'include',
      headers: { Accept: 'application/json' },
    }, token))
  }

  if (response.ok) return { kind: 'refreshed' }
  if (response.status === 401) return { kind: 'invalid' }
  return { kind: 'response', response }
}

function withCsrf(init: RequestInit | undefined, token: string): RequestInit {
  const headers = new Headers(init?.headers)
  headers.set('X-CSRF-Token', token)
  headers.set('Accept', 'application/json')
  return { ...init, credentials: 'include', headers }
}

function isSafeMethod(method: string | undefined): boolean {
  return ['GET', 'HEAD', 'OPTIONS'].includes((method ?? 'GET').toUpperCase())
}

function isAuthenticationLifecycleRequest(input: RequestInfo | URL, basePath: string): boolean {
  const url = String(input)
  return url.startsWith(`${basePath}/auth/`) && !url.startsWith(`${basePath}/auth/session`)
}

function csrfTokenFrom(payload: unknown): string | null {
  if (typeof payload !== 'object' || payload === null || !('data' in payload)) return null
  const data = payload.data
  if (typeof data !== 'object' || data === null || !('csrf_token' in data)) return null
  return typeof data.csrf_token === 'string' && data.csrf_token.length >= 8 ? data.csrf_token : null
}
