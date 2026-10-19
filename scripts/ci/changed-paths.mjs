import { appendFileSync, readFileSync } from 'node:fs'
import { execFileSync } from 'node:child_process'
import { pathToFileURL } from 'node:url'

export function affectedChecks(paths, full = false) {
  const infrastructure = full || paths.some(path => /^(?:infrastructure\/|scripts\/(?:ci|deployment)\/|tools\/deployment\/|\.github\/|render\.yaml$|\.dockerignore$|compose.*\.ya?ml$)/.test(path))
  const contract = infrastructure || paths.some(path => path.startsWith('packages/api-contract/'))
  return {
    backend: infrastructure || contract || paths.some(path => path.startsWith('services/api/')),
    contract,
    web: infrastructure || contract || paths.some(path => /^(?:apps\/(?:vendor-web|admin-web)\/|packages\/(?:web-ui|design-tokens|shared-config)\/)/.test(path)),
    mobile: infrastructure || contract || paths.some(path => /^(?:apps\/buyer-mobile\/|packages\/design-tokens\/)/.test(path)),
    infrastructure: infrastructure || paths.some(path => path.startsWith('services/api/')),
  }
}

export function main() {
  const event = JSON.parse(readFileSync(process.env.GITHUB_EVENT_PATH, 'utf8'))
  const base = event.pull_request?.base?.sha ?? event.before
  let full = process.env.GITHUB_EVENT_NAME === 'workflow_dispatch' || process.env.GITHUB_REF === 'refs/heads/staging'
  let paths = []
  if (!base || !/^[a-f0-9]{40}$/.test(base) || /^0+$/.test(base)) full = true
  if (!full) {
    try {
      paths = execFileSync('git', ['diff', '--name-only', '-z', base, process.env.GITHUB_SHA], { encoding: 'utf8' }).split('\0').filter(Boolean)
    } catch {
      full = true
    }
  }
  const checks = affectedChecks(paths, full)
  for (const [name, enabled] of Object.entries(checks)) appendFileSync(process.env.GITHUB_OUTPUT, `${name}=${enabled}\n`)
  console.log(JSON.stringify(checks))
}

if (process.argv[1] && import.meta.url === pathToFileURL(process.argv[1]).href) main()
