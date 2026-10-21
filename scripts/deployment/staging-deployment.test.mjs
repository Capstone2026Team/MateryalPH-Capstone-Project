import { test } from 'node:test'
import assert from 'node:assert/strict'
import { mkdtemp, mkdir, writeFile, readFile } from 'node:fs/promises'
import { tmpdir } from 'node:os'
import { join } from 'node:path'
import { portalConfiguration, preparePortals } from './prepare-portals.mjs'
import { publishPortals } from './publish-portals.mjs'
import { configuration, deployStaging } from './deploy-railway-staging.mjs'

const sha = 'a'.repeat(40)
const api = 'https://materyalph-test.up.railway.app'
const uuid = number => `00000000-0000-4000-8000-${String(number).padStart(12, '0')}`
const environment = () => ({ DEPLOY_COMMIT: sha, RAILWAY_TOKEN: 'synthetic-only', RAILWAY_PROJECT_ID: uuid(1),
  RAILWAY_ENVIRONMENT_ID: uuid(2), GITHUB_REF: 'refs/heads/staging',
  RAILWAY_STAGING_SERVICE_IDS: JSON.stringify({ api: uuid(3), worker: uuid(4), scheduler: uuid(5), reverb: uuid(6) }) })

test('API-first rewrites preserve paths and disable API caches', () => {
  const config = portalConfiguration(api)
  assert.equal(config.rewrites[0].destination, `${api}/api/v1`)
  assert.equal(config.rewrites[1].destination, `${api}/api/v1/:path*`)
  assert.equal(config.rewrites[2].destination, '/index.html')
  assert.ok(config.headers[0].headers.every(header => /no-store/.test(header.value)))
  for (const origin of ['http://localhost', 'https://other.example.test', `${api}/api/v1`, `${api}?token=x`, 'https://user:pass@x.up.railway.app']) {
    assert.throws(() => portalConfiguration(origin))
  }
})

async function fixture() {
  const root = await mkdtemp(join(tmpdir(), 'materyalph-release-'))
  for (const role of ['vendor', 'admin']) {
    await mkdir(join(root, `apps/${role}-web/dist/assets`), { recursive: true })
    await writeFile(join(root, `apps/${role}-web/dist/index.html`), '<html>Compiled fixture</html>')
    await writeFile(join(root, `apps/${role}-web/dist/assets/app.js`), 'export {}')
  }
  return { root, output: join(root, '.tmp/release'), apiOrigin: api, sourceCommit: sha }
}

test('packages both tested portals with matching release metadata, without overwriting', async () => {
  const input = await fixture()
  await preparePortals(input)
  for (const role of ['vendor', 'admin']) {
    assert.equal(JSON.parse(await readFile(join(input.output, role, 'release.json'), 'utf8')).sourceCommit, sha)
  }
  await assert.rejects(preparePortals(input))
})

test('rejects source maps and output outside ignored staging artifacts', async () => {
  const input = await fixture()
  await writeFile(join(input.root, 'apps/vendor-web/dist/assets/app.js.map'), '{}')
  await assert.rejects(preparePortals(input))
  await assert.rejects(preparePortals({ ...input, output: join(input.root, 'source') }))
})

test('publishing rejects organization identity before any mutation', async () => {
  const calls = []
  await assert.rejects(publishPortals({ owner: 'owner', token: 'synthetic-only', sourceCommit: sha }, async (url, options) => {
    calls.push(options.method)
    return { ok: true, json: async () => url.endsWith('/user') ? { type: 'Organization', login: 'owner' }
      : { private: true, owner: { type: 'Organization', login: 'owner' } } }
  }))
  assert.deepEqual(calls, ['GET', 'GET'])
})

test('publishes a complete artifact tree attributed to the authenticated personal owner', async () => {
  const input = await fixture()
  await preparePortals(input)
  const changes = []
  const commit = await publishPortals({ directory: input.output, owner: 'owner', token: 'synthetic-only', sourceCommit: sha }, async (url, options) => {
    if (options.method !== 'GET') changes.push({ url, body: JSON.parse(options.body) })
    if (url.endsWith('/user')) return { ok: true, json: async () => ({ type: 'User', login: 'owner', id: 12 }) }
    if (url.endsWith('/materyalph-staging-portals')) return { ok: true, json: async () => ({ private: true, owner: { type: 'User', login: 'owner' } }) }
    if (url.endsWith('/git/ref/heads/main')) return { ok: false, status: 404 }
    return { ok: true, json: async () => ({ sha: 'b'.repeat(40) }) }
  })
  assert.equal(commit, 'b'.repeat(40))
  const tree = changes.find(change => change.url.endsWith('/git/trees')).body.tree
  assert.ok(tree.some(file => file.path === 'vendor/index.html'))
  assert.ok(tree.some(file => file.path === 'admin/vercel.json'))
  const published = changes.find(change => change.url.endsWith('/git/commits')).body
  assert.equal(published.author.email, '12+owner@users.noreply.github.com')
  assert.ok(published.message.endsWith(sha))
})

test('deployment rejects wrong branches, duplicate services and database role substitutions', () => {
  const env = environment()
  configuration(env)
  assert.throws(() => configuration({ ...env, GITHUB_REF: 'refs/heads/main' }))
  assert.throws(() => configuration({ ...env, RAILWAY_STAGING_SERVICE_IDS: JSON.stringify({ api: uuid(3), worker: uuid(3), scheduler: uuid(5), reverb: uuid(6) }) }))
  assert.throws(() => configuration({ ...env, RAILWAY_STAGING_SERVICE_IDS: JSON.stringify({ postgres: uuid(3), worker: uuid(4), scheduler: uuid(5), reverb: uuid(6) }) }))
})

test('deployment does not contact Railway for an untested or dirty checkout', async () => {
  const commands = []
  await assert.rejects(deployStaging(configuration(environment()), { run: async (command, args) => {
    commands.push(command)
    return { stdout: args[0] === 'rev-parse' ? sha : ' M source.php' }
  } }))
  assert.ok(commands.every(command => command === 'git'))
})

test('deploys four app roles from the tested checkout and waits for new successful deployments', async () => {
  let deployed = false
  let deployments = 0
  await deployStaging(configuration(environment()), { log: () => {}, run: async (command, args) => {
    if (command === 'git') return { stdout: args[0] === 'rev-parse' ? sha : '' }
    if (args[0] === 'up') { deployed = true; deployments++; return { stdout: '' } }
    if (args[0] === 'deployment') {
      const current = deployed
      deployed = false
      return { stdout: JSON.stringify([{ id: current ? `new-${deployments}` : 'old', status: 'SUCCESS' }]) }
    }
    return { stdout: '{}' }
  } })
  assert.equal(deployments, 4)
})
