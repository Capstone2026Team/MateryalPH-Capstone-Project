import { Configuration, ResponseError } from '@materyalph/api-client-ts'

type WebApiOptions = {
  refreshSession?: boolean
}

const csrfTokens = new Map<string, string>()
const csrfRequests = new Map<string, Promise<string>>()
const refreshRequests = new Map<string, Promise<RefreshResult>>()

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
    fetchApi: (input, init) => webFetch(key, Boolean(options.refreshSession), input, init),
  })
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
  if (refreshed.kind === 'response') return refreshed.response
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
