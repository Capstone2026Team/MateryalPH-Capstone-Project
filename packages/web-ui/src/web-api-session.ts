import { AuthenticationApi, Configuration, FetchError, ResponseError } from '@materyalph/api-client-ts'

type WebApiOptions = {
  refreshSession?: boolean
  readOnlyPostPaths?: readonly string[]
}

const csrfTokens = new Map<string, string>()
const csrfRequests = new Map<string, Promise<string>>()
const refreshRequests = new Map<string, Promise<RefreshResult>>()
const refreshVersions = new Map<string, number>()
let sessionGeneration = 0
const reads = new Map<string, Promise<Response>>()
const mutations = new Set<string>()
const cooldowns = new Map<string, { until: number; response: Response }>()

const READ_TIMEOUT_MS = 30_000
const READ_RETRY_DELAY_MS = 300

function readTimeoutMs(): number {
  const configured = Number(import.meta.env.VITE_API_READ_TIMEOUT_MS)
  return Number.isInteger(configured) && configured >= READ_TIMEOUT_MS && configured <= 120_000 ? configured : READ_TIMEOUT_MS
}

class WebReadTimeoutError extends Error {
  constructor() {
    super('The server is taking too long to respond. Check your connection and try again.')
    this.name = 'WebReadTimeoutError'
  }
}

/** Generated clients wrap transport failures; keep the actionable timeout message available to every portal. */
export function webRequestErrorMessage(error: unknown): string | null {
  const cause = error instanceof FetchError ? error.cause : error
  return cause instanceof WebReadTimeoutError ? cause.message : null
}

/** Use the local dev proxy without changing API identity, signed URLs or the configured production endpoint. */
function localRequestInput(basePath: string, input: RequestInfo | URL): RequestInfo | URL {
  if (!import.meta.env.DEV || typeof window === 'undefined' || window.location.protocol !== 'http:'
    || window.location.hostname !== 'localhost' || !['5173', '5174'].includes(window.location.port)) return input
  const base = new URL(basePath, window.location.origin)
  const url = new URL(input instanceof Request ? input.url : String(input), base)
  if (base.origin !== 'http://localhost:8080' || url.origin !== base.origin
    || !url.pathname.startsWith(`${base.pathname.replace(/\/$/, '')}/`)) return input
  const proxied = `${window.location.origin}${url.pathname}${url.search}`
  return input instanceof Request ? new Request(proxied, input) : proxied
}

async function fetchWebRequest(basePath: string, input: RequestInfo | URL, init?: RequestInit): Promise<Response> {
  const requestInput = localRequestInput(basePath, input)
  const method = init?.method ?? (input instanceof Request ? input.method : 'GET')
  const accept = new Headers(init?.headers ?? (input instanceof Request ? input.headers : undefined)).get('Accept')
  const bounded = (isSafeMethod(method) || String(input) === `${basePath}/auth/refresh`) && (!accept || accept.includes('application/json'))
  if (!bounded) return fetch(requestInput, init)
  const controller = new AbortController()
  const parentSignal = init?.signal ?? (input instanceof Request ? input.signal : undefined)
  const signal = parentSignal ? AbortSignal.any([parentSignal, controller.signal]) : controller.signal
  let timer: ReturnType<typeof setTimeout> | undefined
  const deadline = new Promise<never>((_, reject) => {
    timer = setTimeout(() => {
      const error = new WebReadTimeoutError()
      controller.abort(error)
      reject(error)
    }, readTimeoutMs())
  })
  try {
    return await Promise.race([fetch(requestInput, { ...init, signal }).then(async response => {
      // A server can send headers and then stall its JSON body; parsing must be bounded too.
      if (!response.body || !response.headers.get('Content-Type')?.includes('application/json')) return response
      return new Response(await response.arrayBuffer(), { status: response.status, statusText: response.statusText, headers: response.headers })
    }), deadline])
  } finally {
    clearTimeout(timer)
  }
}

/** Recover a brief transport/server failure once, without replaying commands or extending a timed-out read. */
async function fetchRecoverableRead(basePath: string, input: RequestInfo | URL, init?: RequestInit): Promise<Response> {
  const generation = sessionGeneration
  const method = init?.method ?? (input instanceof Request ? input.method : 'GET')
  const signal = init?.signal ?? (input instanceof Request ? input.signal : undefined)
  const accept = new Headers(init?.headers ?? (input instanceof Request ? input.headers : undefined)).get('Accept')
  if (!isSafeMethod(method) || (accept && !accept.includes('application/json'))) return fetchWebRequest(basePath, input, init)
  let response: Response | undefined
  let failure: unknown
  try {
    response = await fetchWebRequest(basePath, input, init)
    if (![500, 502, 503, 504].includes(response.status) || response.headers.has('Retry-After')) return response
  } catch (error) {
    if (!(error instanceof TypeError) || signal?.aborted) throw error
    failure = error
  }
  await new Promise(resolve => setTimeout(resolve, READ_RETRY_DELAY_MS))
  if (signal?.aborted) throw signal.reason
  // Never send an old account's delayed retry after logout/account replacement.
  if (generation !== sessionGeneration) {
    if (response) return response
    throw failure
  }
  return fetchWebRequest(basePath, input, init)
}

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
  const response = await coordinatedFetch(basePath, false, `${basePath}/auth/csrf`, {
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
  sessionGeneration++
  if (typeof window !== 'undefined') window.dispatchEvent(new Event('materyalph:session-cleared'))
  reads.clear()
  cooldowns.clear()
  if (basePath) {
    const key = normalizedBasePath(basePath)
    csrfTokens.delete(key)
    csrfRequests.delete(key)
    refreshRequests.delete(key)
    refreshVersions.delete(key)
    return
  }
  csrfTokens.clear()
  csrfRequests.clear()
  refreshRequests.clear()
  refreshVersions.clear()
}

export function createWebApiConfiguration(basePath: string, options: WebApiOptions = {}): Configuration {
  const key = normalizedBasePath(basePath)
  return new Configuration({
    basePath: key,
    credentials: 'include',
    apiKey: () => getWebCsrfToken(key),
    fetchApi: (input, init) => coordinatedFetch(key, Boolean(options.refreshSession), input, init, options.readOnlyPostPaths),
  })
}

export async function signOutWebSession(basePath: string): Promise<void> {
  // Acquire CSRF separately: a bootstrap failure is not proof of an expired session.
  await getWebCsrfToken(basePath)
  try {
    await new AuthenticationApi(createWebApiConfiguration(basePath, { refreshSession: true })).logout()
  } catch (error) {
    if (!(error instanceof ResponseError) || error.response.status !== 401) throw error
    // Logout also attempts refresh. A final 401 means the session is already invalid.
  }
  clearWebSessionTransport(basePath)
}

async function coordinatedFetch(basePath: string, refreshSession: boolean, input: RequestInfo | URL, init?: RequestInit, readOnlyPostPaths: readonly string[] = [], behavior: { localForbidden?: boolean } = {}): Promise<Response> {
  const generation = sessionGeneration
  const method = (init?.method ?? (input instanceof Request ? input.method : 'GET')).toUpperCase()
  const url = input instanceof Request ? input.url : String(input)
  const key = `${generation}|${basePath}|${method}|${url}`
  const cooldown = cooldowns.get(key)
  if (cooldown && cooldown.until > Date.now()) {
    const headers = new Headers(cooldown.response.headers)
    headers.set('Retry-After', String(Math.ceil((cooldown.until - Date.now()) / 1000)))
    return new Response(await cooldown.response.clone().text(), { status: 429, headers })
  }
  cooldowns.delete(key)
  // Share only simultaneous ordinary GETs; never cache account/permission data.
  const shareRead = method === 'GET' && !init?.signal && !(input instanceof Request) && !new Headers(init?.headers).has('Authorization')
  const readKey = `${key}|${refreshSession}|${Boolean(behavior.localForbidden)}|${JSON.stringify(Array.from(new Headers(init?.headers).entries()))}`
  const current = shareRead ? reads.get(readKey) : undefined
  if (current) return (await current).clone()
  // Lookup POSTs still use CSRF and authentication, but newer lookups must be
  // allowed to finish before stale responses. Actual mutations remain guarded.
  const readOnlyPost = method === 'POST' && readOnlyPostPaths.some(path => url === `${basePath}${path}`)
  const mutation = !isSafeMethod(method) && !readOnlyPost
  if (mutation && mutations.has(key)) throw new Error('This action is already processing. Please wait for it to finish.')
  if (mutation) mutations.add(key)
  const request = webFetch(basePath, refreshSession, input, init).then(response => {
    if (typeof window !== 'undefined' && generation === sessionGeneration) {
      if (response.status === 401 || (response.status === 403 && !behavior.localForbidden)) window.dispatchEvent(new CustomEvent('materyalph:access-denied', { detail: response.clone() }))
      if (mutation && response.ok && !isAuthenticationLifecycleRequest(input, basePath) && !/\/(auth|typing)$/.test(url)) {
        const audience = url.slice(basePath.length).split('/')[1]
        if (audience === 'vendor' || audience === 'admin') window.dispatchEvent(new CustomEvent('materyalph:navigation-updates', { detail: { basePath, audience } }))
      }
    }
    if (generation === sessionGeneration && response.status === 429 && response.headers.has('Retry-After')) {
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
  const generation = sessionGeneration
  const version = refreshVersions.get(basePath) ?? 0
  let response = await fetchRecoverableRead(basePath, input, init)
  if (generation !== sessionGeneration) return response

  if (response.status === 419 && !isSafeMethod(init?.method)) {
    const token = await getWebCsrfToken(basePath, true)
    init = withCsrf(init, token)
    response = await fetchWebRequest(basePath, input, init)
  }

  if (response.status !== 401 || !refreshSession || isAuthenticationLifecycleRequest(input, basePath)) {
    return response
  }

  // A slower request may return its old-token 401 after another request has
  // already refreshed. Replay once with the new cookie without rotating again.
  if ((refreshVersions.get(basePath) ?? 0) !== version) return fetchRecoverableRead(basePath, input, init)

  const refreshed = await refreshWebSession(basePath)
  if (generation !== sessionGeneration) return response
  if (refreshed.kind === 'invalid') return response
  if (refreshed.kind === 'response') return refreshed.response.clone()
  return fetchRecoverableRead(basePath, input, init)
}

async function refreshWebSession(basePath: string): Promise<RefreshResult> {
  const current = refreshRequests.get(basePath)
  if (current) return current

  const request = coordinateTabRefresh(basePath).finally(() => {
    if (refreshRequests.get(basePath) === request) refreshRequests.delete(basePath)
  })
  refreshRequests.set(basePath, request)
  return request
}

async function coordinateTabRefresh(basePath: string): Promise<RefreshResult> {
  // HttpOnly cookies are shared across tabs. In-memory promises alone cannot prevent
  // two tabs from rotating the same refresh token and triggering reuse revocation.
  if (typeof navigator === 'undefined' || !navigator.locks) return performRefresh(basePath)
  const generation = sessionGeneration
  const name = `materyalph:refresh:${basePath}`
  const immediate = await navigator.locks.request(name, { ifAvailable: true }, lock => {
    if (generation !== sessionGeneration) return { kind: 'invalid' } as const
    return lock ? performRefresh(basePath) : null
  })
  if (immediate) return immediate
  return navigator.locks.request(name, { signal: AbortSignal.timeout(readTimeoutMs()) }, async () => {
    if (generation !== sessionGeneration) return { kind: 'invalid' }
    // The tab ahead of us may already have installed fresh cookies. Check them
    // under the lock instead of rotating again; no token is shared through JS.
    const response = await fetchRecoverableRead(basePath, `${basePath}/auth/session`, {
      credentials: 'include', headers: { Accept: 'application/json' },
    })
    if (generation !== sessionGeneration) return { kind: 'invalid' }
    if (response.ok) {
      refreshVersions.set(basePath, (refreshVersions.get(basePath) ?? 0) + 1)
      return { kind: 'refreshed' }
    }
    return response.status === 401 ? performRefresh(basePath) : { kind: 'response', response }
  })
}

async function performRefresh(basePath: string): Promise<RefreshResult> {
  const token = await getWebCsrfToken(basePath)
  const response = await coordinatedFetch(basePath, false, `${basePath}/auth/refresh`, withCsrf({
    method: 'POST',
    credentials: 'include',
    headers: { Accept: 'application/json' },
  }, token))

  if (response.ok) {
    refreshVersions.set(basePath, (refreshVersions.get(basePath) ?? 0) + 1)
    return { kind: 'refreshed' }
  }
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
  return url.startsWith(`${basePath}/auth/`) && !url.startsWith(`${basePath}/auth/session`) && url !== `${basePath}/auth/logout`
}

function csrfTokenFrom(payload: unknown): string | null {
  if (typeof payload !== 'object' || payload === null || !('data' in payload)) return null
  const data = payload.data
  if (typeof data !== 'object' || data === null || !('csrf_token' in data)) return null
  return typeof data.csrf_token === 'string' && data.csrf_token.length >= 8 ? data.csrf_token : null
}


// Fetch within the portal so Origin/Referer selects its isolated HttpOnly cookies.
// Never navigate to the signed endpoint or send credentials to another origin.
/**
 * Order evidence (delivery/handover proof, problem photos, reimbursement and NRPC evidence) through the authorized,
 * order-scoped API path only. The server re-checks the order and role on every read.
 */
export async function readOrderEvidenceFile(basePath: string, evidencePath: string): Promise<Blob> {
  const base = new URL(basePath, window.location.origin)
  if (!/^\/vendor\/orders\/[0-9a-f-]{36}\/files\/[0-9a-f-]{36}$/i.test(evidencePath)) {
    throw new Error('The evidence path is invalid. Refresh and try again.')
  }
  const url = new URL(`${base.pathname.replace(/\/$/, '')}${evidencePath}`, base)
  const response = await coordinatedFetch(normalizedBasePath(base.href), true, url, {
    credentials: 'include', cache: 'no-store', referrerPolicy: 'origin', headers: { Accept: 'application/pdf,image/jpeg,image/png' },
  })
  if (!response.ok) throw new ResponseError(response)
  const blob = await response.blob()
  if (!['application/pdf', 'image/jpeg', 'image/png'].includes(blob.type.split(';')[0] ?? '')) {
    throw new Error('This file type cannot be previewed.')
  }
  return blob
}

/** Personal photos stay behind the owner-only API and the portal's authenticated transport. */
export async function readAccountPhoto(basePath: string, portal: 'vendors' | 'admin', signedUrl: string): Promise<Blob> {
  const base = new URL(basePath, window.location.origin)
  const url = new URL(signedUrl, base)
  if (url.origin !== base.origin || url.pathname !== `${base.pathname.replace(/\/$/, '')}/${portal}/account/photo`) {
    throw new Error('The profile picture URL is invalid. Refresh and try again.')
  }
  const response = await coordinatedFetch(normalizedBasePath(base.href), true, url, {
    credentials: 'include', cache: 'no-store', referrerPolicy: 'origin', headers: { Accept: 'image/png' },
  })
  if (!response.ok) throw new ResponseError(response)
  const blob = await response.blob()
  if (blob.type.split(';')[0] !== 'image/png') throw new Error('The profile picture cannot be previewed.')
  return blob
}

/** Directory photos remain scoped to the selected Buyer and the currently authorized Admin session. */
export async function readDirectoryBuyerPhoto(basePath: string, buyerId: string, signedUrl: string): Promise<Blob> {
  const base = new URL(basePath, window.location.origin)
  const url = new URL(signedUrl, base)
  if (url.origin !== base.origin || url.username || url.password
    || url.pathname !== `${base.pathname.replace(/\/$/, '')}/admin/buyers/${encodeURIComponent(buyerId)}/photo`) {
    throw new Error('The Buyer profile picture URL is invalid. Refresh and try again.')
  }
  // Preserve the signed query exactly; expired media links must not clear an otherwise valid directory page.
  const response = await coordinatedFetch(normalizedBasePath(base.href), true, url, {
    credentials: 'include', cache: 'no-store', referrerPolicy: 'origin', headers: { Accept: 'image/png' },
  }, [], { localForbidden: true })
  if (!response.ok) throw new ResponseError(response)
  const blob = await response.blob()
  if (blob.type.split(';')[0] !== 'image/png') throw new Error('The Buyer profile picture cannot be previewed.')
  return blob
}

const SIGNED_CASE_CONTENT = [
  /\/(vendor|admin)\/disputes\/[0-9a-f-]{36}\/files\/[0-9a-f-]{36}\/content$/i,
  /\/(vendor|admin)\/invoice-records\/[0-9a-f-]{36}\/content$/i,
]

/**
 * Reads case evidence or an invoice copy through its five-minute signed link. Only same-origin API paths of those two
 * kinds are accepted, the session cookie travels with the request and the server re-authorizes the caller.
 */
export async function readSignedCaseFile(basePath: string, signedUrl: string): Promise<Blob> {
  const base = new URL(basePath, window.location.origin)
  const url = new URL(signedUrl, base)
  if (url.origin !== base.origin || !url.pathname.startsWith(base.pathname.replace(/\/$/, '')) || !SIGNED_CASE_CONTENT.some(pattern => pattern.test(url.pathname))) {
    throw new Error('The file link is invalid. Refresh and try again.')
  }
  const response = await coordinatedFetch(normalizedBasePath(base.href), true, url, {
    credentials: 'include', cache: 'no-store', referrerPolicy: 'origin', headers: { Accept: 'application/pdf,image/jpeg,image/png' },
  })
  if (!response.ok) throw new ResponseError(response)
  const blob = await response.blob()
  if (!['application/pdf', 'image/jpeg', 'image/png'].includes(blob.type.split(';')[0] ?? '')) {
    throw new Error('This file type cannot be previewed.')
  }
  return blob
}

/** Review photos and videos stay on their exact, viewer-authorized API content route. */
export async function readReviewMediaFile(basePath: string, signedUrl: string): Promise<Blob> {
  const base = new URL(basePath, window.location.origin)
  const url = new URL(signedUrl, base)
  const apiPath = base.pathname.replace(/\/$/, '')
  const reviewPath = url.pathname.slice(apiPath.length)
  if (url.origin !== base.origin || url.username || url.password || !url.pathname.startsWith(`${apiPath}/`)
    || !/^\/(vendor|admin)\/reviews\/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\/media\/[0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12}\/content$/i.test(reviewPath)) {
    throw new Error('The review attachment URL is invalid. Refresh attachments and try again.')
  }
  // An expired signature is a local attachment failure, not evidence that the portal session lost its permissions.
  const response = await coordinatedFetch(normalizedBasePath(base.href), true, url, {
    credentials: 'include', cache: 'no-store', referrerPolicy: 'origin',
    headers: { Accept: 'image/jpeg,image/png,video/mp4,video/quicktime' },
  }, [], { localForbidden: true })
  if (!response.ok) throw new ResponseError(response)
  const blob = await response.blob()
  if (!['image/jpeg', 'image/png', 'video/mp4', 'video/quicktime'].includes(blob.type.split(';')[0] ?? '')) {
    throw new Error('This review attachment type cannot be previewed.')
  }
  return blob
}

/** Signed private-content routes the evidence previews may read: onboarding documents and catalog files (PS/ICC evidence). */
const PRIVATE_CONTENT_ROUTES = ['vendor-onboarding-files', 'catalog-files']

export async function readWebPrivateFile(basePath: string, signedUrl: string): Promise<Blob> {
  const base = new URL(basePath, window.location.origin)
  const url = new URL(signedUrl, base)
  const apiPath = base.pathname.replace(/\/$/, '')
  if (url.origin !== base.origin || !PRIVATE_CONTENT_ROUTES.some(route => url.pathname.startsWith(`${apiPath}/${route}/`)) || !url.pathname.endsWith('/content')) {
    throw new Error('The private evidence URL is invalid. Refresh and try again.')
  }
  const response = await coordinatedFetch(normalizedBasePath(base.href), true, url, {
    credentials: 'include', cache: 'no-store', referrerPolicy: 'origin', headers: { Accept: 'application/pdf,image/jpeg,image/png,image/webp' },
  })
  if (!response.ok) throw new ResponseError(response)
  const blob = await response.blob()
  if (!['application/pdf', 'image/jpeg', 'image/png', 'image/webp'].includes(blob.type.split(';')[0] ?? '')) {
    throw new Error('This file type cannot be previewed.')
  }
  return blob
}
