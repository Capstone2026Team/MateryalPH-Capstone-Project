import { execFile } from 'node:child_process'
import { promisify } from 'node:util'
import { resolve } from 'node:path'
import { pathToFileURL } from 'node:url'
import { setTimeout as delay } from 'node:timers/promises'

const execute = promisify(execFile)
export const roles = ['api', 'reverb', 'worker', 'scheduler']
export function configuration(env) {
  const uuid = /^[a-f0-9]{8}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{4}-[a-f0-9]{12}$/
  if (!/^[a-f0-9]{40}$/.test(env.DEPLOY_COMMIT ?? '') || !env.RAILWAY_TOKEN
    || !uuid.test(env.RAILWAY_PROJECT_ID ?? '') || !uuid.test(env.RAILWAY_ENVIRONMENT_ID ?? '')
    || env.GITHUB_REF !== 'refs/heads/staging') throw new Error('Configure the reviewed staging targets, scoped project token and passing source commit.')
  const services = JSON.parse(env.RAILWAY_STAGING_SERVICE_IDS ?? '{}')
  if (Object.keys(services).length !== roles.length || roles.some(role => !uuid.test(services[role] ?? ''))
    || new Set(Object.values(services)).size !== roles.length) throw new Error('Configure four distinct application service IDs; database services are never redeployed here.')
  return { project: env.RAILWAY_PROJECT_ID, environment: env.RAILWAY_ENVIRONMENT_ID, services, commit: env.DEPLOY_COMMIT }
}

export async function deployStaging(config, { run = execute, sleep = delay, log = console.log } = {}) {
  const head = (await run('git', ['rev-parse', 'HEAD'])).stdout.trim()
  const dirty = (await run('git', ['status', '--porcelain'])).stdout.trim()
  if (head !== config.commit || dirty) throw new Error('Deploy only a clean checkout of the exact passing commit.')
  async function railway(args) {
    try {
      return (await run('railway', args, { timeout: 30 * 60_000, maxBuffer: 16 * 1024 * 1024 })).stdout
    } catch { throw new Error('Railway command failed; inspect sanitized provider logs in the dashboard.') }
  }
  await railway(['link', '--project', config.project, '--environment', config.environment, '--json'])
  async function latest(id) {
    const payload = JSON.parse(await railway(['deployment', 'list', '--service', id, '--environment', config.environment, '--json']))
    if (!Array.isArray(payload)) throw new Error('Unexpected Railway deployment-list response.')
    return payload[0]
  }
  for (const role of roles) {
    const id = config.services[role]
    const before = await latest(id)
    // Uses the tested checkout; respects .gitignore/.railwayignore. Never include ignored credentials.
    await railway(['up', '--project', config.project, '--environment', config.environment, '--service', id,
      '--ci', '--message', `staging ${config.commit}`])
    let current = await latest(id)
    if (!current?.id || current.id === before?.id) throw new Error(`${role}: no new deployment identified.`)
    const deploymentId = current.id
    const deadline = Date.now() + 15 * 60_000
    while (current.status !== 'SUCCESS' && Date.now() < deadline) {
      if (['FAILED', 'CRASHED', 'REMOVED', 'SKIPPED'].includes(current.status)) throw new Error(`${role}: deployment failed.`)
      await sleep(10_000)
      current = await latest(id)
      if (current?.id !== deploymentId) throw new Error(`${role}: concurrent deployment changed the release target.`)
    }
    if (current.status !== 'SUCCESS') throw new Error(`${role}: deployment did not become healthy.`)
    log(`${role}: staging deployment succeeded for ${config.commit}`)
  }
}

if (process.argv[1] && import.meta.url === pathToFileURL(resolve(process.argv[1])).href) {
  try { await deployStaging(configuration(process.env)) }
  catch { console.error('Staging deployment failed; no credentials or provider payloads are logged.'); process.exitCode = 1 }
}
