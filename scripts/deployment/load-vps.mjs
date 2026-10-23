import { writeFileSync } from 'node:fs'
import { performance } from 'node:perf_hooks'
import { setTimeout } from 'node:timers/promises'
import { pathToFileURL } from 'node:url'
import { privateFile } from './vps-config.mjs'

// Only DB reads: maps/provider calls, uploads and write journeys have separate acceptance.
const paths = new Set(['/buyers/listings/search', '/buyers/explore/summary', '/vendor/orders', '/vendor/catalog/listings', '/admin/dashboard'])
export function validateScenario(scenario) {
  const origin = new URL(scenario.origin)
  if (origin.protocol !== 'https:' || origin.pathname !== '/' || origin.search || origin.hash || origin.username || origin.password || !origin.hostname.endsWith('.duckdns.org')) throw new Error('Use the confirmed HTTPS Hostinger API origin.')
  if (scenario.syntheticDataConfirmed !== true || scenario.actors?.length !== 20 || !['buyer', 'vendor', 'admin'].every(role => scenario.actors.some(actor => actor.role === role))) throw new Error('Provide 20 synthetic, authenticated actors covering all three roles.')
  for (const actor of scenario.actors) {
    if (!['buyer', 'vendor', 'admin'].includes(actor.role) || !actor.requests?.length || !actor.headers || !Object.keys(actor.headers).every(name => ['authorization', 'cookie', 'accept'].includes(name.toLowerCase()))) throw new Error('Use only private authorization/cookie inputs and read requests.')
    for (const route of actor.requests) {
      const url = new URL(route, origin)
      if (url.origin !== origin.origin || !route.startsWith('/') || route.startsWith('//') || !paths.has(url.pathname) || url.hash) throw new Error('Unsupported load route; provider calls and mutations are excluded.')
    }
  }
  return origin.origin
}

export const percentile = (values, percentile) => [...values].sort((a, b) => a - b)[Math.max(0, Math.ceil(values.length * percentile) - 1)] ?? null
export async function measure(scenario, durationSeconds, fetcher = fetch) {
  const origin = validateScenario(scenario)
  const results = []
  const started = performance.now()
  await Promise.all(scenario.actors.map(async actor => {
    let index = 0
    while (performance.now() - started < durationSeconds * 1000) {
      const route = actor.requests[index++ % actor.requests.length]
      const start = performance.now()
      let ok = false
      try {
        const response = await fetcher(new URL('/api/v1' + route, origin).href, {
          method: 'GET', headers: { Accept: 'application/json', ...actor.headers }, redirect: 'error', signal: AbortSignal.timeout(10_000),
        })
        const body = await response.json()
        ok = response.status === 200 && Object.hasOwn(body, 'data') && (!body.errors || body.errors.length === 0)
      } catch { /* No response bodies, session values or signed URLs enter the report. */ }
      results.push({ route: new URL(route, origin).pathname, role: actor.role, milliseconds: performance.now() - start, ok })
      await setTimeout(500)
    }
  }))
  const groups = [...new Set(results.map(result => result.role + ':' + result.route))].map(key => {
    const samples = results.filter(result => result.role + ':' + result.route === key)
    return { operation: key, requests: samples.length, failures: samples.filter(result => !result.ok).length, p95Ms: percentile(samples.map(result => result.milliseconds), 0.95) }
  })
  return { users: 20, durationSeconds, requests: results.length, groups, passed: groups.length > 0 && groups.every(group => group.requests >= 20 && group.failures === 0 && group.p95Ms <= 2000) }
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) {
  try {
    const [input, output, seconds = '300'] = process.argv.slice(2)
    if (!input || !output || !/^\d+$/.test(seconds) || Number(seconds) < 60 || Number(seconds) > 1800) throw new Error('Usage: node load-vps.mjs PRIVATE_SCENARIO REPORT_JSON [60..1800 seconds]')
    const report = await measure(JSON.parse(privateFile(input)), Number(seconds))
    writeFileSync(output, JSON.stringify({ ...report, measuredAt: new Date().toISOString() }, null, 2), { flag: 'wx', mode: 0o600 })
    console.log(`20-user DB-read load gate: ${report.passed ? 'passed' : 'failed'}. Provider/write/device acceptance remains separate.`)
    if (!report.passed) process.exitCode = 1
  } catch { console.error('Load gate refused or failed. Check the private synthetic scenario; no request credentials or bodies were logged.'); process.exitCode = 1 }
}
