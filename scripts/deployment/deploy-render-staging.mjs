import { pathToFileURL } from 'node:url'
import { setTimeout as delay } from 'node:timers/promises'

export const roles = ['api', 'reverb', 'vendor', 'admin']
const failedStatuses = new Set(['build_failed', 'pre_deploy_failed', 'update_failed', 'canceled', 'deactivated'])

export function configuration(env) {
  if (!/^[a-f0-9]{40}$/.test(env.DEPLOY_COMMIT ?? '')) throw new Error('DEPLOY_COMMIT must identify the exact tested Git commit.')
  if (!/^tea-[a-z0-9]+$/.test(env.RENDER_WORKSPACE_ID ?? '')) throw new Error('Configure the confirmed staging workspace ID.')
  if (!/^[\w.-]+\/[\w.-]+$/.test(env.DEPLOY_REPOSITORY ?? '')) throw new Error('Configure the source repository.')
  if (!env.RENDER_API_KEY) throw new Error('Set RENDER_STAGING_API_KEY in the protected GitHub staging environment.')
  let services
  try { services = JSON.parse(env.RENDER_STAGING_SERVICE_IDS ?? '') } catch { throw new Error('RENDER_STAGING_SERVICE_IDS must map all four staging roles to Render service IDs.') }
  if (!services || Array.isArray(services) || Object.keys(services).length !== roles.length) throw new Error('Configure exactly the four staging services.')
  for (const role of roles) if (!/^(?:srv|crn)-[a-z0-9]+$/.test(services[role] ?? '')) throw new Error(`Configure a valid ${role} staging service ID.`)
  if (new Set(Object.values(services)).size !== roles.length) throw new Error('Each staging role must have its own service.')
  const urls = {}
  for (const role of ['api', 'vendor', 'admin']) {
    let url
    try { url = new URL(env[`STAGING_${role.toUpperCase()}_URL`]) } catch { throw new Error(`Configure the public ${role} HTTPS origin.`) }
    if (url.protocol !== 'https:' || url.username || url.password || url.search || url.hash || url.pathname !== '/') throw new Error(`Use a plain HTTPS origin for ${role}.`)
    urls[role] = url.origin
  }
  return { services, urls, commit: env.DEPLOY_COMMIT, owner: env.RENDER_WORKSPACE_ID, repository: env.DEPLOY_REPOSITORY, token: env.RENDER_API_KEY }
}

function repositoryName(repo) {
  return String(repo ?? '').replace(/^https:\/\/github\.com\//, '').replace(/^git@github\.com:/, '').replace(/\.git$/, '')
}

export async function deployStaging(config, { fetcher = fetch, sleep = delay, now = Date.now, log = console.log } = {}) {
  async function request(path, method = 'GET', body) {
    const response = await fetcher(`https://api.render.com/v1${path}`, {
      method,
      headers: { Authorization: `Bearer ${config.token}`, Accept: 'application/json', 'Content-Type': 'application/json' },
      body: body === undefined ? undefined : JSON.stringify(body),
      signal: AbortSignal.timeout(30_000),
    })
    // Provider response bodies can contain credentials. Report status and resource only.
    if (!response.ok) throw new Error(`Render returned HTTP ${response.status} for ${method} ${path}.`)
    return response.json()
  }

  // Validate every target before the first mutation. Never deploy a service from another workspace or branch.
  for (const role of roles) {
    const payload = await request(`/services/${config.services[role]}`)
    const service = payload.service ?? payload
    if (service.ownerId !== config.owner || service.branch !== 'staging' || repositoryName(service.repo) !== config.repository
      || !String(service.name).startsWith('materyalph-staging-') || service.autoDeploy !== 'no'
      || (['api', 'reverb'].includes(role) && service.serviceDetails?.plan !== 'free')) {
      throw new Error(`The ${role} target must belong to the confirmed workspace, staging branch and repository, with automatic deployments disabled.`)
    }
  }

  async function deploy(role) {
    const payload = await request(`/services/${config.services[role]}/deploys`, 'POST', { commitId: config.commit })
    const created = payload.deploy ?? payload
    if (!/^dep-[a-z0-9]+$/.test(created.id ?? '')) throw new Error(`Render did not identify the ${role} deployment.`)
    log(`${role}: deployment ${created.id} started for ${config.commit}`)
    const deadline = now() + 30 * 60_000
    while (now() < deadline) {
      const response = await request(`/services/${config.services[role]}/deploys/${created.id}`)
      const current = response.deploy ?? response
      if (failedStatuses.has(current.status)) throw new Error(`${role}: deployment ended with ${current.status}.`)
      if (current.status === 'live') {
        if (current.commit?.id !== config.commit) throw new Error(`${role}: live deployment does not match the tested commit.`)
        log(`${role}: exact tested commit is live`)
        return
      }
      await sleep(10_000)
    }
    throw new Error(`${role}: deployment did not become live within 30 minutes.`)
  }

  // The Free API starts only after its guarded startup migration; its jobs share that container.
  await deploy('api')
  await deploy('reverb')
  await Promise.all(['vendor', 'admin'].map(deploy))
  await smokeCheck(config.urls, fetcher)
  log('All four Free staging builds are live and public HTTP smoke checks passed. Provider and authenticated acceptance remain separate checks.')
}

export async function smokeCheck(urls, fetcher = fetch) {
  const get = (url, options = {}) => fetcher(url, { ...options, redirect: 'error', signal: AbortSignal.timeout(30_000) })
  const health = await get(`${urls.api}/api/v1/health`)
  if (health.status !== 200 || (await health.json()).data?.status !== 'ok') throw new Error('The API health envelope is unavailable.')
  const session = await get(`${urls.api}/api/v1/auth/session`, { headers: { Accept: 'application/json' } })
  if (session.status !== 401) throw new Error('The unauthenticated session endpoint must return 401.')
  for (const portal of ['vendor', 'admin']) {
    const page = await get(`${urls[portal]}/login`)
    if (page.status !== 200 || !page.headers.get('content-type')?.includes('text/html')) throw new Error(`${portal}: SPA login route is unavailable.`)
    const csrf = await get(`${urls[portal]}/api/v1/auth/csrf`, { headers: { Origin: urls[portal], Accept: 'application/json' } })
    const cookie = csrf.headers.get('set-cookie') ?? ''
    if (csrf.status !== 200 || typeof (await csrf.json()).data?.csrf_token !== 'string'
      || !cookie.includes(`mp_csrf_${portal}=`) || !/;\s*secure/i.test(cookie) || /;\s*domain=/i.test(cookie)) {
      throw new Error(`${portal}: same-origin API rewrite or secure host-only CSRF cookie is unavailable.`)
    }
    const forbidden = await get(`${urls[portal]}/api/v1/auth/login`, {
      method: 'POST', headers: { Origin: urls[portal], 'Content-Type': 'application/json', Accept: 'application/json' }, body: '{}',
    })
    if (forbidden.status !== 419) throw new Error(`${portal}: the API rewrite must preserve POST and reject requests without CSRF.`)
    const cors = await get(`${urls.api}/api/v1/auth/csrf`, {
      method: 'OPTIONS',
      headers: { Origin: urls[portal], 'Access-Control-Request-Method': 'GET', 'Access-Control-Request-Headers': 'content-type,x-csrf-token' },
    })
    if (!cors.ok || cors.headers.get('access-control-allow-origin') !== urls[portal]
      || cors.headers.get('access-control-allow-credentials') !== 'true') throw new Error(`${portal}: credentialed CORS does not match its exact origin.`)
  }
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    await deployStaging(configuration(process.env))
  } catch (error) {
    // Never emit request headers, environment values, provider payloads or underlying transport exceptions.
    console.error(error instanceof Error && !error.cause ? error.message : 'Staging deployment failed. Inspect the service events in Render.')
    process.exitCode = 1
  }
}
